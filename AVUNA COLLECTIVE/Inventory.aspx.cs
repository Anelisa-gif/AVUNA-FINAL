using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Globalization;
using System.Text;
using System.Web;
using System.Web.UI;

namespace AVUNA_COLLECTIVE
{
	public partial class Inventory : System.Web.UI.Page
	{
		// A variant with this many units or fewer (but more than 0) is shown as "Low stock".
		private const int LowStockLimit = 20;

		private class Variant
		{
			public int Id;
			public string ItemId = "", ItemName = "", Size = "", Colour = "";
			public int Qty;
			public decimal UnitCost;
			public bool Estimated;
			public decimal Value { get { return Qty * UnitCost; } }
			public string Status
			{
				get { return Qty <= 0 ? "Out of stock" : (Qty <= LowStockLimit ? "Low stock" : "In stock"); }
			}
		}

		// Raw materials view (Inventory.aspx?view=materials)
		protected bool ShowMaterials;
		protected string MaterialsHtml = "";

		protected void Page_Load(object sender, EventArgs e)
		{
			if (Session["staff_Role"] == null)
			{
				Response.Redirect("~/Default.aspx");
				return;
			}

			string role = Session["staff_Role"].ToString();
			if (role != "Manager" && role != "Admin Staff")
			{
				Response.Redirect("~/Default.aspx");
				return;
			}

			string fullName = ((Session["staff_First_Name"] as string ?? "") + " " + (Session["staff_Last_Name"] as string ?? "")).Trim();
			litManagerName.Text = HttpUtility.HtmlEncode(fullName.Length == 0 ? "Manager" : fullName);

			string q = (Request.QueryString["q"] ?? "").Trim();
			if (q.Length > 80) q = q.Substring(0, 80);

			string status = (Request.QueryString["status"] ?? "").Trim().ToLowerInvariant();
			if (status != "in" && status != "low" && status != "out") status = "";

			ShowMaterials = string.Equals(Request.QueryString["view"], "materials", StringComparison.OrdinalIgnoreCase);

			// Manager saves a new unit cost (base price) for a raw material
			if (Request.HttpMethod == "POST" && Request.Form["avMatSave"] == "1")
			{
				SaveMaterialPrice(role);
				return;
			}

			LoadInventory(q, status);
			if (ShowMaterials) MaterialsHtml = BuildMaterials(q, (Request.QueryString["cat"] ?? "").Trim(), role == "Manager");
		}

		// ------------------------------------------------------------------ RAW MATERIALS
		private void SaveMaterialPrice(string role)
		{
			string result = "err";
			string id = (Request.Form["avMatId"] ?? "").Trim();
			string raw = (Request.Form["avMatCost"] ?? "").Trim().Replace(',', '.');
			decimal cost;
			if (role == "Manager" && id.Length > 0 && id.Length <= 30 &&
				decimal.TryParse(raw, NumberStyles.Number, CultureInfo.InvariantCulture, out cost) && cost >= 0m && cost <= 9999999m)
			{
				try
				{
					string connStr = ConfigurationManager.ConnectionStrings["GroupWst2"].ConnectionString;
					using (var conn = new SqlConnection(connStr))
					using (var cmd = new SqlCommand("UPDATE dbo.RawMaterial SET unitCost = @c, lastUpdated = GETDATE() WHERE material_ID = @id", conn))
					{
						cmd.Parameters.AddWithValue("@c", Math.Round(cost, 2));
						cmd.Parameters.AddWithValue("@id", id);
						conn.Open();
						result = cmd.ExecuteNonQuery() > 0 ? "ok" : "err";
					}
				}
				catch (Exception)
				{
					result = "err";
				}
			}
			Response.Redirect("~/Inventory.aspx?view=materials&saved=" + result + "&mid=" + HttpUtility.UrlEncode(id), false);
			Context.ApplicationInstance.CompleteRequest();
		}

		private class Material
		{
			public string Id = "", Name = "", Category = "", Unit = "", Supplier = "";
			public decimal Qty, Reorder, Cost;
			public DateTime? Updated;
			public decimal Value { get { return Qty * Cost; } }
			public string Status { get { return Qty <= 0 ? "Out of stock" : (Qty <= Reorder ? "Reorder" : "In stock"); } }
		}

		private string BuildMaterials(string q, string cat, bool canEdit)
		{
			var list = new List<Material>();
			string problem = null;
			try
			{
				string connStr = ConfigurationManager.ConnectionStrings["GroupWst2"].ConnectionString;
				using (var conn = new SqlConnection(connStr))
				using (var cmd = new SqlCommand(
					"SELECT material_ID, material_Name, material_Category, unitOfMeasure, quantityAvailable, reorderLevel, unitCost, supplier, lastUpdated, supplier_ID " +
					"FROM dbo.RawMaterial ORDER BY material_Category, material_Name", conn))
				{
					conn.Open();
					using (var r = cmd.ExecuteReader())
					{
						while (r.Read())
						{
							var m = new Material();
							m.Id = Str(r, 0); m.Name = Str(r, 1); m.Category = Str(r, 2); m.Unit = Str(r, 3);
							m.Qty = r.IsDBNull(4) ? 0m : Convert.ToDecimal(r.GetValue(4), CultureInfo.InvariantCulture);
							m.Reorder = r.IsDBNull(5) ? 0m : Convert.ToDecimal(r.GetValue(5), CultureInfo.InvariantCulture);
							m.Cost = r.IsDBNull(6) ? 0m : Convert.ToDecimal(r.GetValue(6), CultureInfo.InvariantCulture);
							m.Supplier = Str(r, 7);
							if (m.Supplier.Length == 0) m.Supplier = Str(r, 9);
							m.Updated = r.IsDBNull(8) ? (DateTime?)null : Convert.ToDateTime(r.GetValue(8), CultureInfo.InvariantCulture);
							list.Add(m);
						}
					}
				}
			}
			catch (Exception ex) { problem = ex.Message; }

			var sb = new StringBuilder();

			// result of a save
			string saved = Request.QueryString["saved"];
			if (saved == "ok")
			{
				string mid = Request.QueryString["mid"] ?? "";
				sb.Append("<div class=\"mat-flash ok\">Price updated for <b>").Append(HttpUtility.HtmlEncode(mid)).Append("</b>. The new unit cost is saved.</div>");
			}
			else if (saved == "err")
				sb.Append("<div class=\"mat-flash bad\">The price could not be saved. Enter a valid amount (for example 85 or 85.50). Only a Manager can change prices.</div>");

			if (problem != null)
			{
				sb.Append("<div class=\"avuna-db-notice\"><strong>Raw materials could not be loaded from SQL Server.</strong><br />").Append(HttpUtility.HtmlEncode(problem)).Append("</div>");
				return sb.ToString();
			}

			var cats = new List<string>();
			foreach (Material m in list)
				if (m.Category.Length > 0 && !cats.Contains(m.Category)) cats.Add(m.Category);

			// toolbar: search + category chips
			sb.Append("<div class=\"avuna-toolbar\"><div class=\"avuna-search\">")
			  .Append("<input type=\"text\" id=\"matSearch\" maxlength=\"80\" autocomplete=\"off\" placeholder=\"Search by material, category, supplier or material number\" value=\"").Append(HttpUtility.HtmlEncode(q)).Append("\" />")
			  .Append("<input type=\"hidden\" id=\"matCat\" value=\"").Append(HttpUtility.HtmlEncode(cat)).Append("\" />")
			  .Append("<button type=\"button\" onclick=\"matSearch()\">Search</button>");
			if (q.Length > 0 || cat.Length > 0) sb.Append("<a href=\"Inventory.aspx?view=materials\" class=\"avuna-clear\">Clear</a>");
			sb.Append("</div><div class=\"avuna-filters\">").Append(MatChip("", "All", cat, q));
			foreach (string c in cats) sb.Append(MatChip(c, c, cat, q));
			sb.Append(MatChip("__reorder", "Needs reorder", cat, q)).Append("</div></div>");

			// filter
			var shown = new List<Material>();
			foreach (Material m in list)
			{
				if (cat == "__reorder") { if (m.Qty > m.Reorder) continue; }
				else if (cat.Length > 0 && !string.Equals(m.Category, cat, StringComparison.OrdinalIgnoreCase)) continue;
				if (q.Length > 0 && !(Has(m.Name, q) || Has(m.Category, q) || Has(m.Supplier, q) || Has(m.Id, q) || Has(m.Unit, q))) continue;
				shown.Add(m);
			}

			sb.Append("<section class=\"avuna-card\"><div class=\"avuna-orders-header\"><div><h2>Raw Materials</h2><p>")
			  .Append(shown.Count).Append(shown.Count == 1 ? " material" : " materials")
			  .Append(canEdit ? ". Edit a unit cost and press Update to change the base price." : ". Prices are view only for your role.")
			  .Append("</p></div></div><div class=\"avuna-table-wrap\"><table class=\"avuna-table\"><thead><tr>")
			  .Append("<th>ID</th><th>MATERIAL</th><th>UNIT</th><th class=\"num\">IN STOCK</th><th class=\"num\">REORDER LEVEL</th><th class=\"num\">UNIT COST (BASE PRICE)</th><th class=\"num\">STOCK VALUE</th><th>SUPPLIER</th><th>UPDATED</th><th>STATUS</th>")
			  .Append("</tr></thead><tbody>");

			if (shown.Count == 0)
				sb.Append("<tr><td colspan=\"10\" style=\"text-align:center; color:#8a7f72; padding:30px;\">").Append(list.Count == 0 ? "No raw materials have been added yet." : "No raw materials match that search.").Append("</td></tr>");

			foreach (Material m in shown)
			{
				string cls = m.Qty <= 0 ? "avuna-failed" : (m.Qty <= m.Reorder ? "avuna-pending" : "avuna-completed");
				string barCls = m.Qty <= 0 ? " avuna-stockbar-red" : (m.Qty <= m.Reorder ? " avuna-stockbar-amber" : "");
				decimal full = m.Reorder > 0 ? m.Reorder * 3 : 100;
				int pct = (int)Math.Min(100, Math.Max(0, m.Qty) * 100 / full);
				if (m.Qty > 0 && pct < 4) pct = 4;
				string idE = HttpUtility.HtmlAttributeEncode(m.Id), nameE = HttpUtility.HtmlAttributeEncode(m.Name);
				string cost = m.Cost.ToString("0.00", CultureInfo.InvariantCulture);

				sb.Append("<tr><td><span class=\"avuna-name\">").Append(HttpUtility.HtmlEncode(m.Id)).Append("</span></td>")
				  .Append("<td><span class=\"avuna-name\">").Append(Dash(m.Name)).Append("</span><span class=\"avuna-sub\">").Append(HttpUtility.HtmlEncode(m.Category)).Append("</span></td>")
				  .Append("<td>").Append(Dash(m.Unit)).Append("</td>")
				  .Append("<td class=\"num\"><span class=\"avuna-qty\">").Append(m.Qty.ToString("0.##", CultureInfo.InvariantCulture)).Append("</span><div class=\"avuna-stockbar").Append(barCls).Append("\"><span style=\"width:").Append(pct).Append("%\"></span></div></td>")
				  .Append("<td class=\"num avuna-money\">").Append(m.Reorder.ToString("0.##", CultureInfo.InvariantCulture)).Append("</td>");

				if (canEdit)
					sb.Append("<td class=\"num\"><div class=\"mat-edit\"><span class=\"mat-r\">R</span>")
					  .Append("<input type=\"text\" inputmode=\"decimal\" class=\"mat-in\" maxlength=\"10\" value=\"").Append(cost).Append("\" data-orig=\"").Append(cost)
					  .Append("\" data-id=\"").Append(idE).Append("\" data-name=\"").Append(nameE).Append("\" oninput=\"matChanged(this)\" onkeydown=\"if(event.key==='Enter'){event.preventDefault();this.parentNode.querySelector('.mat-save').click();}\" />")
					  .Append("<button type=\"button\" class=\"mat-save\" disabled onclick=\"matSave(this)\">Update</button></div></td>");
				else
					sb.Append("<td class=\"num avuna-money\">").Append(Rand(m.Cost)).Append("</td>");

				sb.Append("<td class=\"num avuna-money\">").Append(Rand(m.Value)).Append("</td>")
				  .Append("<td>").Append(Dash(m.Supplier)).Append("</td>")
				  .Append("<td class=\"avuna-money\">").Append(m.Updated.HasValue ? m.Updated.Value.ToString("d MMM yyyy", CultureInfo.InvariantCulture) : "-").Append("</td>")
				  .Append("<td><span class=\"avuna-status ").Append(cls).Append("\">").Append(m.Status).Append("</span></td></tr>");
			}
			sb.Append("</tbody></table></div></section>");
			return sb.ToString();
		}

		private static string MatChip(string value, string label, string current, string q)
		{
			var parts = new List<string> { "view=materials" };
			if (q.Length > 0) parts.Add("q=" + HttpUtility.UrlEncode(q));
			if (value.Length > 0) parts.Add("cat=" + HttpUtility.UrlEncode(value));
			return "<a class=\"avuna-chip" + (value == current ? " active" : "") + "\" href=\"Inventory.aspx?" + string.Join("&", parts) + "\">" + HttpUtility.HtmlEncode(label) + "</a>";
		}

		// Shared by the Manager Dashboard and this page: builds the amber low-stock banner and, once per
		// login session, a pop-up that lists the variants that need restocking. Returns "" when all is well.
		public static string LowStockAlertHtml(System.Web.SessionState.HttpSessionState session)
		{
			var chips = new StringBuilder();
			int low = 0, outOf = 0, shown = 0;
			try
			{
				string connStr = ConfigurationManager.ConnectionStrings["GroupWst2"].ConnectionString;
				using (var conn = new SqlConnection(connStr))
				{
					conn.Open();
					const string sql =
						"SELECT item_Name, Variant_Size, Variant_Colour, QuantityAvailable " +
						"FROM dbo.InventoryVariant WHERE QuantityAvailable <= @limit ORDER BY QuantityAvailable, item_Name";
					using (var cmd = new SqlCommand(sql, conn))
					{
						cmd.Parameters.AddWithValue("@limit", LowStockLimit);
						using (var r = cmd.ExecuteReader())
						{
							while (r.Read())
							{
								int qty = r.IsDBNull(3) ? 0 : Convert.ToInt32(r.GetValue(3), CultureInfo.InvariantCulture);
								if (qty <= 0) outOf++; else low++;
								if (shown < 8)
								{
									shown++;
									string label = Str(r, 0);
									string size = Str(r, 1), colour = Str(r, 2);
									if (size.Length > 0) label += " \u00B7 " + size;
									if (colour.Length > 0) label += " \u00B7 " + colour;
									chips.Append("<li class=\"").Append(qty <= 0 ? "out" : "low").Append("\">")
										 .Append(HttpUtility.HtmlEncode(label)).Append(" \u2014 <b>")
										 .Append(qty <= 0 ? "out of stock" : qty + " left").Append("</b></li>");
								}
							}
						}
					}
				}
			}
			catch (Exception)
			{
				return "";
			}

			int total = low + outOf;
			if (total == 0) return "";

			string summary = total + (total == 1 ? " item needs" : " items need") + " restocking: " + outOf + " out of stock, " + low + " low (" + LowStockLimit + " units or fewer).";
			string more = total > shown ? "<li>+ " + (total - shown) + " more</li>" : "";
			var sb = new StringBuilder();
			sb.Append("<div class=\"av-lowstock\"><div class=\"av-ls-head\"><strong>Low stock alert</strong><span>")
			  .Append(HttpUtility.HtmlEncode(summary))
			  .Append("</span><a href=\"Inventory.aspx\">View inventory</a></div><ul>")
			  .Append(chips).Append(more).Append("</ul></div>");

			// Pop-up: only once per login session so it does not nag on every page view.
			if (session != null && session["LowStockPopupShown"] == null)
			{
				session["LowStockPopupShown"] = "1";
				string popupHtml = "<p style=\"margin:0\">" + HttpUtility.HtmlEncode(summary) + "</p><ul>" + chips + more + "</ul>";
				sb.Append("<script>document.addEventListener('DOMContentLoaded',function(){if(window.avNotice){avNotice('Low stock alert','")
				  .Append(HttpUtility.JavaScriptStringEncode(popupHtml))
				  .Append("','View inventory','Inventory.aspx');}});</script>");
			}
			return sb.ToString();
		}

		private void LoadInventory(string q, string status)
		{
			var variants = new List<Variant>();
			string problem = null;

			string connStr = ConfigurationManager.ConnectionStrings["GroupWst2"].ConnectionString;
			try
			{
				using (var conn = new SqlConnection(connStr))
				{
					conn.Open();
					const string sql =
						"SELECT Variant_ID, item_ID, item_Name, Variant_Size, Variant_Colour, QuantityAvailable, UnitCost, IsEstimated " +
						"FROM dbo.InventoryVariant ORDER BY item_Name, Variant_ID";
					using (var cmd = new SqlCommand(sql, conn))
					using (var r = cmd.ExecuteReader())
					{
						while (r.Read())
						{
							var v = new Variant();
							v.Id = r.IsDBNull(0) ? 0 : Convert.ToInt32(r.GetValue(0), CultureInfo.InvariantCulture);
							v.ItemId = Str(r, 1);
							v.ItemName = Str(r, 2);
							v.Size = Str(r, 3);
							v.Colour = Str(r, 4);
							v.Qty = r.IsDBNull(5) ? 0 : Convert.ToInt32(r.GetValue(5), CultureInfo.InvariantCulture);
							v.UnitCost = r.IsDBNull(6) ? 0m : Convert.ToDecimal(r.GetValue(6), CultureInfo.InvariantCulture);
							v.Estimated = !r.IsDBNull(7) && Convert.ToBoolean(r.GetValue(7), CultureInfo.InvariantCulture);
							variants.Add(v);
						}
					}
				}
			}
			catch (Exception ex)
			{
				problem = ex.Message;
			}

			if (problem != null)
			{
				litDbNotice.Text = "<div class=\"avuna-db-notice\"><strong>Inventory could not be loaded from SQL Server.</strong><br />" + HttpUtility.HtmlEncode(problem) + "</div>";
				litToolbar.Text = BuildToolbar(q, status);
				litTableTitle.Text = "Inventory";
				litTableSubtitle.Text = "Inventory data is unavailable right now.";
				litRows.Text = EmptyRow("Inventory data is unavailable right now.");
				return;
			}

			litDbNotice.Text = LowStockAlertHtml(Session);

			// ---- cards (always for ALL variants) -------------------------------
			var products = new HashSet<string>(StringComparer.OrdinalIgnoreCase);
			long units = 0;
			decimal value = 0m;
			int low = 0, outOf = 0;
			bool anyEstimated = false;
			foreach (Variant v in variants)
			{
				products.Add(v.ItemId.Length > 0 ? v.ItemId : v.ItemName);
				if (v.Qty > 0) units += v.Qty;
				value += Math.Max(0, v.Qty) * v.UnitCost;
				if (v.Qty <= 0) outOf++; else if (v.Qty <= LowStockLimit) low++;
				if (v.Estimated) anyEstimated = true;
			}
			litTotalVariants.Text = variants.Count.ToString(CultureInfo.InvariantCulture);
			litItemsNote.Text = "Across " + products.Count + (products.Count == 1 ? " product" : " products");
			litTotalUnits.Text = units.ToString("N0", CultureInfo.InvariantCulture);
			litStockValue.Text = Rand(value);
			litAttention.Text = (low + outOf).ToString(CultureInfo.InvariantCulture);
			litAttentionNote.Text = low + " low, " + outOf + " out of stock";

			// ---- filter and search ---------------------------------------------
			var shown = new List<Variant>();
			foreach (Variant v in variants)
			{
				if (status == "in" && v.Qty <= LowStockLimit) continue;
				if (status == "low" && !(v.Qty > 0 && v.Qty <= LowStockLimit)) continue;
				if (status == "out" && v.Qty > 0) continue;
				if (q.Length == 0 || Matches(v, q)) shown.Add(v);
			}

			litToolbar.Text = BuildToolbar(q, status);

			string statusWords = status == "in" ? "in-stock " : (status == "low" ? "low-stock " : (status == "out" ? "out-of-stock " : ""));
			if (q.Length == 0 && status.Length == 0)
			{
				litTableTitle.Text = "All Stock";
				litTableSubtitle.Text = variants.Count + (variants.Count == 1 ? " variant" : " variants") + ", sorted by product. Low stock means " + LowStockLimit + " units or fewer."
					+ (anyEstimated ? " Costs marked \"Estimated\" have not been confirmed yet." : "");
			}
			else
			{
				litTableTitle.Text = q.Length == 0 ? "Filtered stock" : "Search results";
				litTableSubtitle.Text = shown.Count + (shown.Count == 1 ? " " + statusWords + "variant" : " " + statusWords + "variants")
					+ (q.Length == 0 ? " shown." : " match “" + HttpUtility.HtmlEncode(q) + "”.");
			}

			var rows = new StringBuilder();
			foreach (Variant v in shown) rows.Append(BuildRow(v));
			litRows.Text = shown.Count == 0
				? EmptyRow(variants.Count == 0 ? "No inventory has been added yet." : "No stock matches that search. Try a product, size, colour or variant number.")
				: rows.ToString();
		}

		// ---------------------------------------------------------------------------
		private static string BuildRow(Variant v)
		{
			string cls = v.Qty <= 0 ? "avuna-failed" : (v.Qty <= LowStockLimit ? "avuna-pending" : "avuna-completed");
			string barCls = v.Qty <= 0 ? " avuna-stockbar-red" : (v.Qty <= LowStockLimit ? " avuna-stockbar-amber" : "");
			int pct = (int)Math.Min(100, Math.Max(0, v.Qty) * 100 / 200);   // bar is full at 200 units
			if (v.Qty > 0 && pct < 4) pct = 4;

			var sb = new StringBuilder();
			sb.Append("<tr>")
			  .Append("<td><span class=\"avuna-name\">#").Append(v.Id.ToString(CultureInfo.InvariantCulture)).Append("</span></td>")
			  .Append("<td><span class=\"avuna-name\">").Append(Dash(v.ItemName)).Append("</span><span class=\"avuna-sub\">Item ").Append(HttpUtility.HtmlEncode(v.ItemId)).Append("</span></td>")
			  .Append("<td>").Append(v.Size.Length == 0 ? "<span class=\"avuna-muted\">-</span>" : "<span class=\"avuna-size\">" + HttpUtility.HtmlEncode(v.Size) + "</span>").Append("</td>")
			  .Append("<td>").Append(v.Colour.Length == 0 ? "<span class=\"avuna-muted\">-</span>" : "<span class=\"avuna-swatch\" style=\"background:" + Swatch(v.Colour) + "\"></span>" + HttpUtility.HtmlEncode(v.Colour)).Append("</td>")
			  .Append("<td class=\"num\"><span class=\"avuna-qty\">").Append(v.Qty.ToString("N0", CultureInfo.InvariantCulture)).Append("</span>")
			  .Append("<div class=\"avuna-stockbar").Append(barCls).Append("\"><span style=\"width:").Append(pct).Append("%\"></span></div></td>")
			  .Append("<td class=\"num avuna-money\">").Append(Rand(v.UnitCost)).Append(v.Estimated ? "<span class=\"avuna-est\">Estimated</span>" : "").Append("</td>")
			  .Append("<td class=\"num avuna-money\">").Append(Rand(v.Value)).Append("</td>")
			  .Append("<td><span class=\"avuna-status ").Append(cls).Append("\">").Append(v.Status).Append("</span></td>")
			  .Append("</tr>");
			return sb.ToString();
		}

		// A variant matches when the text is found in its product, size, colour, item number, variant number or stock status.
		private static bool Matches(Variant v, string q)
		{
			if (Has(v.ItemName, q) || Has(v.ItemId, q) || Has(v.Size, q) || Has(v.Colour, q) || Has(v.Status, q)) return true;
			if (v.Id.ToString(CultureInfo.InvariantCulture) == q.TrimStart('#')) return true;
			if (v.Estimated && Has("estimated", q)) return true;
			if (Has(v.ItemName + " " + v.Colour, q) || Has(v.ItemName + " " + v.Size, q) || Has(v.Colour + " " + v.ItemName, q)) return true;
			return false;
		}

		private static bool Has(string text, string q)
		{
			return !string.IsNullOrEmpty(text) && text.IndexOf(q, StringComparison.OrdinalIgnoreCase) >= 0;
		}

		private static string BuildToolbar(string q, string status)
		{
			var sb = new StringBuilder();
			sb.Append("<div class=\"avuna-toolbar\"><div class=\"avuna-search\">")
			  .Append("<input type=\"text\" id=\"invSearch\" maxlength=\"80\" autocomplete=\"off\" placeholder=\"Search by product, size, colour, item number or variant number\" value=\"")
			  .Append(HttpUtility.HtmlEncode(q)).Append("\" />")
			  .Append("<input type=\"hidden\" id=\"invStatus\" value=\"").Append(status).Append("\" />")
			  .Append("<button type=\"button\" onclick=\"doSearch()\">Search</button>");
			if (q.Length > 0 || status.Length > 0) sb.Append("<a href=\"Inventory.aspx\" class=\"avuna-clear\">Clear</a>");
			sb.Append("</div><div class=\"avuna-filters\">")
			  .Append(Chip("", "All stock", status, q))
			  .Append(Chip("in", "In stock", status, q))
			  .Append(Chip("low", "Low stock", status, q))
			  .Append(Chip("out", "Out of stock", status, q))
			  .Append("</div></div>");
			return sb.ToString();
		}

		private static string Chip(string value, string label, string current, string q)
		{
			var parts = new List<string>();
			if (q.Length > 0) parts.Add("q=" + HttpUtility.UrlEncode(q));
			if (value.Length > 0) parts.Add("status=" + value);
			string href = "Inventory.aspx" + (parts.Count > 0 ? "?" + string.Join("&", parts) : "");
			return "<a class=\"avuna-chip" + (value == current ? " active" : "") + "\" href=\"" + href + "\">" + label + "</a>";
		}

		private static string Swatch(string colour)
		{
			switch ((colour ?? "").Trim().ToLowerInvariant())
			{
				case "black": return "#1a1a1a";
				case "white": return "#ffffff";
				case "blue": return "#2f5fb3";
				case "navy": case "navy blue": return "#1c2a5a";
				case "red": return "#c0392b";
				case "green": return "#2f8f5b";
				case "orange": return "#e8801f";
				case "yellow": return "#f2c230";
				case "brown": return "#7b4a2a";
				case "grey": case "gray": return "#9a9a9a";
				case "pink": return "#e58fb0";
				case "purple": return "#7b4fa0";
				case "maroon": return "#6e1f2b";
				case "beige": case "cream": return "#e8dcc0";
				default: return "#d8d0c0";
			}
		}

		// ---------------------------------------------------------------------------
		private static string Str(SqlDataReader r, int i)
		{
			return r.IsDBNull(i) ? "" : Convert.ToString(r.GetValue(i), CultureInfo.InvariantCulture).Trim();
		}

		private static string Dash(string s)
		{
			return string.IsNullOrWhiteSpace(s) ? "<span class=\"avuna-muted\">-</span>" : HttpUtility.HtmlEncode(s);
		}

		private static string Rand(decimal amount)
		{
			return "R" + amount.ToString(amount == Math.Floor(amount) ? "N0" : "N2", CultureInfo.InvariantCulture);
		}

		private static string EmptyRow(string message)
		{
			return "<tr><td colspan=\"8\" style=\"text-align:center; color:#8a7f72; padding:30px;\">" + HttpUtility.HtmlEncode(message) + "</td></tr>";
		}
	}
}

