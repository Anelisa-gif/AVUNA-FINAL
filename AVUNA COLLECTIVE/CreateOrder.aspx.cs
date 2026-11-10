using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.Script.Serialization;
using System.IO;
using System.Globalization;
using System.Web.UI;

namespace AVUNA_COLLECTIVE
{
    public partial class CreateOrder : Page
    {
        public string InventoryJson { get; private set; } = "[]";
        public string ServerFeedbackHtml { get; private set; } = "";

        protected override void OnInit(EventArgs e)
        {
            base.OnInit(e);
            // Tie ASP.NET ViewState to this session for normal form postbacks.
            if (Session != null) ViewStateUserKey = Session.SessionID;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["customer_ID"] == null)
            {
                Response.Redirect("~/Login.aspx");
                return;
            }

            Page.Form.Enctype = "multipart/form-data";
            // A redirect after saving prevents an accidental duplicate order on Refresh.
            if (!IsPostBack && !String.IsNullOrWhiteSpace(Request.QueryString["saved"]) &&
                String.Equals(Convert.ToString(Session["LastCreatedOrderId"]),
                              Request.QueryString["saved"], StringComparison.Ordinal))
            {
                ShowServerMessage("Order " + Request.QueryString["saved"] +
                    " was submitted successfully and is Pending.", true);
            }
            try
            {
                // Exactly like Profile.aspx: SQL read during a normal page request.
                var variants = ReadInventory();
                var serializer = new JavaScriptSerializer { MaxJsonLength = 1000000 };
                InventoryJson = SafeJson(serializer.Serialize(variants));

                if (IsPostBack && Request.Form["checkoutSubmit"] == "1")
                    SubmitOrderFromPostback(serializer);
            }
            catch (SqlException ex)
            {
                System.Diagnostics.Trace.TraceError("CreateOrder Page_Load SQL error: " + ex);
                ShowServerMessage("Database operation failed. No successful order submission was confirmed. Check the Visual Studio Output log.", false);
            }
            catch (Exception ex)
            {
                System.Diagnostics.Trace.TraceError("CreateOrder Page_Load error: " + ex);
                ShowServerMessage("Unable to load or validate the order. Please check the Visual Studio Output log.", false);
            }
        }

        private static string SafeJson(string json)
        {
            return json.Replace("<", "\\u003c").Replace(">", "\\u003e")
                       .Replace("&", "\\u0026");
        }

        private void ShowServerMessage(string message, bool success)
        {
            ServerFeedbackHtml = "<div class=\"feedback " + (success ? "success" : "error") +
                "\" style=\"display:block\" role=\"status\">" +
                HttpUtility.HtmlEncode(message) + "</div>";
        }

        private void SubmitOrderFromPostback(JavaScriptSerializer serializer)
        {
            CheckoutRequest request;
            try
            {
                request = serializer.Deserialize<CheckoutRequest>(Request.Form["checkoutPayload"] ?? "");
            }
            catch (Exception)
            {
                ShowServerMessage("Invalid order details. Please make your selections again.", false);
                return;
            }

            // Validate the actual uploaded file, not merely the filename sent from JavaScript.
            HttpPostedFile file = Request.Files["designFile"];
            if (file == null || file.ContentLength <= 0 || file.ContentLength > 5 * 1024 * 1024 ||
                !IsSupportedImage(file))
            {
                ShowServerMessage("Upload a valid PNG, JPG or WEBP design image (maximum 5 MB).", false);
                return;
            }
            request.designFileName = Path.GetFileName(file.FileName);
            // All inventory, pricing, customer and ID checks are repeated inside
            // the same SQL transaction which performs the inserts.
            try
            {
                string newOrderId = SaveOrder(request, file);
                Session["LastCreatedOrderId"] = newOrderId;
                Response.Redirect(Request.Path + "?saved=" + HttpUtility.UrlEncode(newOrderId), false);
                Context.ApplicationInstance.CompleteRequest();
            }
            catch (OrderValidationException ex)
            {
                ShowServerMessage(ex.Message, false);
            }
            catch (SqlException ex)
            {
                System.Diagnostics.Trace.TraceError("CreateOrder SubmitOrder SQL error: " + ex);
                ShowServerMessage("Order was not saved: a database error occurred. Please check the Visual Studio Output log before retrying.", false);
            }
            catch (Exception ex)
            {
                System.Diagnostics.Trace.TraceError("CreateOrder SubmitOrder error: " + ex);
                ShowServerMessage("Order was not confirmed. Please check the Visual Studio Output log and verify the Order table before retrying.", false);
            }
        }

        private static bool IsSupportedImage(HttpPostedFile file)
        {
            string mime = (file.ContentType ?? "").ToLowerInvariant();
            if (mime != "image/png" && mime != "image/jpeg" && mime != "image/webp") return false;
            byte[] head = new byte[12];
            Stream stream = file.InputStream;
            if (stream.CanSeek) stream.Position = 0;
            int got = stream.Read(head, 0, head.Length);
            if (stream.CanSeek) stream.Position = 0;
            bool png = got >= 8 && head[0] == 137 && head[1] == 80 && head[2] == 78 && head[3] == 71;
            bool jpeg = got >= 3 && head[0] == 255 && head[1] == 216 && head[2] == 255;
            bool webp = got >= 12 && head[0] == 82 && head[1] == 73 && head[2] == 70 && head[3] == 70 &&
                        head[8] == 87 && head[9] == 69 && head[10] == 66 && head[11] == 80;
            return (mime == "image/png" && png) || (mime == "image/jpeg" && jpeg) || (mime == "image/webp" && webp);
        }

        public class StockVariant
        {
            public int id { get; set; }
            public string item { get; set; }
            public string size { get; set; }
            public string colour { get; set; }
            public int stock { get; set; }
            public int unitCents { get; set; }
        }
        public class ColourSelection
        {
            public string colour { get; set; }
            public int quantity { get; set; }
        }
        public class CheckoutRequest
        {
            public string item { get; set; }
            public string size { get; set; }
            public List<ColourSelection> colours { get; set; }
            public string designFileName { get; set; }
        }
        public class QuotedColour
        {
            public string colour { get; set; }
            public int quantity { get; set; }
            public int unitCents { get; set; }
        }
        public class CheckoutQuote
        {
            public int version { get; set; }
            public string item { get; set; }
            public string size { get; set; }
            public List<QuotedColour> colours { get; set; }
            public string package { get; set; }
            public string designFileName { get; set; }
            public int itemCostCents { get; set; }
            public int designFeeCents { get; set; }
            public int beforeVatCents { get; set; }
            public int vatCents { get; set; }
            public int subtotalCents { get; set; }
            public int markupCents { get; set; }
            public int totalCents { get; set; }
        }
        public class ValidationResult
        {
            public bool ok { get; set; }
            public string[] errors { get; set; }
            public CheckoutQuote quote { get; set; }
        }

        private static string DisplayName(string itemId, string rawName)
        {
            // Align inventory labels which refer to the same product, without showing item IDs.
            switch ((itemId ?? "").Trim().ToUpperInvariant())
            {
                case "IT1": case "IT2": return "Golf T-Shirts";
                case "IT4": case "IT9": return "Hoodies";
                case "IT5": case "IT16": return "Sweaters";
                case "IT7": case "IT13": return "V-Neck T-Shirts";
                case "IT3": return "Cap";
                case "IT6": return "Ties";
                case "IT8": return "Varsity Jackets";
                case "IT10": return "Sunhats";
                case "IT11": return "Round Neck T-Shirts";
                case "IT12": return "Plain Jackets";
                case "IT14": return "Puffer Jackets";
                case "IT15": return "Raincoats";
                case "IT17": return "Beanies";
                default: return (rawName ?? "").Trim();
            }
        }

        private static int ToCents(decimal value)
        {
            return checked((int)Math.Round(value * 100m, 0, MidpointRounding.AwayFromZero));
        }

        private static List<StockVariant> ReadInventory()
        {
            string cs = ConfigurationManager.ConnectionStrings["GroupWst2"].ConnectionString;
            using (var con = new SqlConnection(cs))
            {
                con.Open();
                return ReadInventory(con, null, false);
            }
        }

        private static List<StockVariant> ReadInventory(SqlConnection con, SqlTransaction tx, bool lockRows)
        {
            var list = new List<StockVariant>();
            string hint = lockRows ? " WITH (UPDLOCK, HOLDLOCK) " : " ";
            string sql = @"SELECT v.Variant_ID, i.item_ID, i.item_Name,
                                  v.Variant_Size, v.Variant_Colour,
                                  v.QuantityAvailable, v.UnitCost
                           FROM dbo.InventoryVariant AS v" + hint + @"
                           INNER JOIN dbo.Inventory AS i ON i.item_ID = v.item_ID
                           WHERE v.QuantityAvailable > 0 AND v.UnitCost >= 0
                           ORDER BY i.item_Name, v.Variant_Size, v.Variant_Colour, v.Variant_ID";
            using (var cmd = new SqlCommand(sql, con, tx))
            {
                cmd.CommandTimeout = 30;
                using (var reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        list.Add(new StockVariant
                        {
                            id = Convert.ToInt32(reader["Variant_ID"]),
                            item = DisplayName(Convert.ToString(reader["item_ID"]), Convert.ToString(reader["item_Name"])),
                            size = Convert.ToString(reader["Variant_Size"]).Trim(),
                            colour = Convert.ToString(reader["Variant_Colour"]).Trim(),
                            stock = Convert.ToInt32(reader["QuantityAvailable"]),
                            unitCents = ToCents(Convert.ToDecimal(reader["UnitCost"]))
                        });
                    }
                }
            }
            return list;
        }

        private static void RequireCustomerSession()
        {
            if (HttpContext.Current == null || HttpContext.Current.Session == null ||
                HttpContext.Current.Session["customer_ID"] == null)
                throw new HttpException(401, "Please sign in as a customer.");
        }

        public static List<StockVariant> GetAvailableInventory()
        {
            RequireCustomerSession();
            return ReadInventory();
        }

        public static ValidationResult ValidateCheckout(CheckoutRequest request)
        {
            RequireCustomerSession();
            return ValidateCheckout(request, ReadInventory());
        }

        private static ValidationResult ValidateCheckout(CheckoutRequest request, List<StockVariant> variants)
        {
            var errors = new List<string>();
            if (request == null)
                return new ValidationResult { ok = false, errors = new[] { "Missing order details." } };
            if (String.IsNullOrWhiteSpace(request.item)) errors.Add("Select an item.");
            if (String.IsNullOrWhiteSpace(request.size)) errors.Add("Select a size.");
            if (String.IsNullOrWhiteSpace(request.designFileName)) errors.Add("Upload a design image.");
            if (request.colours == null || request.colours.Count == 0)
                errors.Add("Select at least one colour.");
            if (request.colours != null && request.colours.Count > 30)
                errors.Add("Too many colours selected.");
            if (errors.Count > 0) return new ValidationResult { ok = false, errors = errors.ToArray() };
            var sameItemAndSize = variants.Where(v =>
                String.Equals(v.item, request.item, StringComparison.OrdinalIgnoreCase) &&
                String.Equals(v.size, request.size, StringComparison.OrdinalIgnoreCase)).ToList();
            if (sameItemAndSize.Count == 0)
                errors.Add("The selected item and size are no longer available.");

            var seen = new HashSet<string>(StringComparer.OrdinalIgnoreCase);
            var selected = new List<QuotedColour>();
            decimal itemCost = 0m;
            foreach (var requested in request.colours)
            {
                if (requested == null || String.IsNullOrWhiteSpace(requested.colour))
                {
                    errors.Add("One selected colour is invalid.");
                    continue;
                }
                string colour = requested.colour.Trim();
                if (!seen.Add(colour))
                {
                    errors.Add("Colour " + colour + " was selected more than once.");
                    continue;
                }
                if (requested.quantity < 1)
                {
                    errors.Add("Enter a positive whole-number quantity for " + colour + ".");
                    continue;
                }
                var matches = sameItemAndSize.Where(v =>
                    String.Equals(v.colour, colour, StringComparison.OrdinalIgnoreCase)).ToList();
                if (matches.Count == 0)
                {
                    errors.Add(colour + " is no longer in stock for the selected item and size.");
                    continue;
                }
                int available = matches.Sum(v => v.stock);
                if (requested.quantity > available)
                {
                    errors.Add("Insufficient stock for " + colour + ": requested " + requested.quantity +
                               ", available " + available + ".");
                    continue;
                }
                if (matches.Select(v => v.unitCents).Distinct().Count() != 1)
                {
                    errors.Add("The selected " + colour + " variants have different prices; please contact staff.");
                    continue;
                }
                int unitCents = matches[0].unitCents;
                itemCost += (unitCents / 100m) * requested.quantity;
                selected.Add(new QuotedColour
                {
                    colour = matches[0].colour,
                    quantity = requested.quantity,
                    unitCents = unitCents
                });
            }
            if (errors.Count > 0) return new ValidationResult { ok = false, errors = errors.ToArray() };

            // Official Avuna Collective formula: (items + fixed design fee) * 1.15 * 1.10
            int colourCount = selected.Count;
            string package = colourCount >= 4 ? "Platinum" : colourCount == 3 ? "Gold" :
                             colourCount == 2 ? "Silver" : "Bronze";
            decimal fee = package == "Platinum" ? 400m : package == "Gold" ? 350m :
                          package == "Silver" ? 250m : 150m;
            decimal beforeVat = itemCost + fee;
            decimal vat = Math.Round(beforeVat * 0.15m, 2, MidpointRounding.AwayFromZero);
            decimal subtotal = beforeVat + vat;
            decimal total = Math.Round(subtotal * 1.10m, 2, MidpointRounding.AwayFromZero);
            decimal markup = total - subtotal;
            var quote = new CheckoutQuote
            {
                version = 2,
                item = request.item,
                size = request.size,
                colours = selected,
                package = package,
                designFileName = System.IO.Path.GetFileName(request.designFileName),
                itemCostCents = ToCents(itemCost),
                designFeeCents = ToCents(fee),
                beforeVatCents = ToCents(beforeVat),
                vatCents = ToCents(vat),
                subtotalCents = ToCents(subtotal),
                markupCents = ToCents(markup),
                totalCents = ToCents(total)
            };
            return new ValidationResult { ok = true, errors = new string[0], quote = quote };
        }



        private sealed class OrderValidationException : Exception
        {
            public OrderValidationException(string message) : base(message) { }
        }

        private sealed class OrderLine
        {
            public int VariantId;
            public string Colour;
            public int Quantity;
            public int UnitCents;
            public int BeforeTaxCents;
            public int FinalCents;
        }

        // Compare the numeric portion, rather than sorting string IDs lexicographically.
        // The exclusive application lock prevents simultaneous saves by this page
        // from generating the same IDs.
        private static string NextId(SqlConnection con, SqlTransaction tx,
                                     string table, string column, string prefix, int digits)
        {
            // These are fixed server-side names, never user input.
            string sql = "SELECT [" + column + "] FROM dbo.[" + table + "] WITH (UPDLOCK, HOLDLOCK)";
            int max = 0;
            using (var cmd = new SqlCommand(sql, con, tx))
            using (var reader = cmd.ExecuteReader())
            {
                while (reader.Read())
                {
                    string value = Convert.ToString(reader[0]).Trim();
                    if (!value.StartsWith(prefix, StringComparison.OrdinalIgnoreCase)) continue;
                    int number;
                    if (Int32.TryParse(value.Substring(prefix.Length), NumberStyles.None,
                                       CultureInfo.InvariantCulture, out number) && number > max)
                        max = number;
                }
            }
            return prefix + checked(max + 1).ToString("D" + digits, CultureInfo.InvariantCulture);
        }

        private static void AddText(SqlCommand command, string name, string value, int length)
        {
            command.Parameters.Add(name, SqlDbType.VarChar, length).Value = value;
        }

        private static void AddMoney(SqlCommand command, string name, decimal value)
        {
            var p = command.Parameters.Add(name, SqlDbType.Decimal);
            p.Precision = 18;
            p.Scale = 2;
            p.Value = value;
        }

        private static void Execute(SqlConnection con, SqlTransaction tx, string sql,
                                    Action<SqlCommand> prepare)
        {
            using (var cmd = new SqlCommand(sql, con, tx))
            {
                if (prepare != null) prepare(cmd);
                if (cmd.ExecuteNonQuery() != 1)
                    throw new InvalidOperationException("The expected database row was not saved.");
            }
        }

        private string SaveOrder(CheckoutRequest request, HttpPostedFile file)
        {
            int customerId;
            if (!Int32.TryParse(Convert.ToString(Session["customer_ID"]), out customerId) || customerId < 1)
                throw new OrderValidationException("Please sign in again before submitting an order.");

            byte[] photo;
            using (var ms = new MemoryStream())
            {
                if (file.InputStream.CanSeek) file.InputStream.Position = 0;
                file.InputStream.CopyTo(ms);
                photo = ms.ToArray();
            }
            if (photo.Length < 1 || photo.Length > 5 * 1024 * 1024)
                throw new OrderValidationException("The design image must be smaller than 5 MB.");

            string connection = ConfigurationManager.ConnectionStrings["GroupWst2"].ConnectionString;
            using (var con = new SqlConnection(connection))
            {
                con.Open();
                using (var tx = con.BeginTransaction(IsolationLevel.Serializable))
                {
                    try
                    {
                        // All new order inserts use this lock to prevent duplicate string IDs.
                        using (var lockCmd = new SqlCommand(
                            "DECLARE @result int; EXEC @result = sp_getapplock " +
                            "@Resource='Avuna_CreateOrder_IDs', @LockMode='Exclusive', " +
                            "@LockOwner='Transaction', @LockTimeout=15000; SELECT @result;", con, tx))
                        {
                            int code = Convert.ToInt32(lockCmd.ExecuteScalar());
                            if (code < 0) throw new InvalidOperationException("Could not obtain order lock.");
                        }

                        // Verify customer still exists.
                        using (var cmd = new SqlCommand(
                            "SELECT COUNT(1) FROM dbo.Customer WITH (UPDLOCK,HOLDLOCK) WHERE customer_ID=@id", con, tx))
                        {
                            cmd.Parameters.Add("@id", SqlDbType.Int).Value = customerId;
                            if (Convert.ToInt32(cmd.ExecuteScalar()) != 1)
                                throw new OrderValidationException("Customer account was not found. Please sign in again.");
                        }

                        // Re-read inventory with locks immediately before inserting the order.
                        var variants = ReadInventory(con, tx, true);
                        ValidationResult result = ValidateCheckout(request, variants);
                        if (!result.ok)
                            throw new OrderValidationException(String.Join(" ", result.errors));

                        if (request.item.Length > 50 || request.size.Length > 50 ||
                            result.quote.colours.Any(c => c.colour.Length > 50))
                            throw new OrderValidationException("An item, size or colour name exceeds the database limit.");
                        var lines = new List<OrderLine>();
                        foreach (var selected in result.quote.colours)
                        {
                            int remaining = selected.quantity;
                            var matching = variants.Where(v =>
                                String.Equals(v.item, request.item, StringComparison.OrdinalIgnoreCase) &&
                                String.Equals(v.size, request.size, StringComparison.OrdinalIgnoreCase) &&
                                String.Equals(v.colour, selected.colour, StringComparison.OrdinalIgnoreCase))
                                .OrderBy(v => v.id);
                            foreach (var variant in matching)
                            {
                                if (remaining == 0) break;
                                int take = Math.Min(remaining, variant.stock);
                                lines.Add(new OrderLine
                                {
                                    VariantId = variant.id,
                                    Colour = selected.colour,
                                    Quantity = take,
                                    UnitCents = variant.unitCents,
                                    BeforeTaxCents = checked(take * variant.unitCents)
                                });
                                remaining -= take;
                            }
                            if (remaining != 0)
                                throw new OrderValidationException("Available stock changed. Please review your order.");
                        }
                        if (lines.Count == 0) throw new OrderValidationException("Choose at least one item.");

                        // Charge the design package once. Allocate final tax-inclusive
                        // total across the item rows, with any rounding remainder on last row.
                        lines[0].BeforeTaxCents = checked(lines[0].BeforeTaxCents + result.quote.designFeeCents);
                        int sumBefore = lines.Sum(l => l.BeforeTaxCents);
                        if (sumBefore <= 0 || sumBefore != result.quote.beforeVatCents)
                            throw new InvalidOperationException("Order subtotal validation failed.");
                        int allocated = 0;
                        for (int i = 0; i < lines.Count; i++)
                        {
                            int amount = i == lines.Count - 1
                                ? result.quote.totalCents - allocated
                                : checked((int)Math.Round(
                                    (decimal)result.quote.totalCents * lines[i].BeforeTaxCents / sumBefore,
                                    0, MidpointRounding.AwayFromZero));
                            lines[i].FinalCents = amount;
                            allocated = checked(allocated + amount);
                        }
                        if (allocated != result.quote.totalCents)
                            throw new InvalidOperationException("Order total does not balance.");

                        string orderId = NextId(con, tx, "Order", "order_ID", "ORD", 3);
                        string designId = NextId(con, tx, "Design", "design_ID", "DES", 3);
                        string fileId = NextId(con, tx, "DesignFile", "designFile_ID", "DFID", 3);
                        string itemId = NextId(con, tx, "OrderItem", "orderItem_ID", "ORDIT", 3);
                        int nextItemNumber = Int32.Parse(itemId.Substring("ORDIT".Length), CultureInfo.InvariantCulture);

                        string description = Path.GetFileName(file.FileName);
                        if (String.IsNullOrWhiteSpace(description)) description = "Customer uploaded design";
                        if (description.Length > 100) description = description.Substring(0, 100);

                        Execute(con, tx, @"INSERT INTO dbo.DesignFile
                            (designFile_ID, design_Description, design_Photo)
                            VALUES (@id, @description, @photo)", cmd =>
                        {
                            AddText(cmd, "@id", fileId, 50);
                            AddText(cmd, "@description", description, 100);
                            cmd.Parameters.Add("@photo", SqlDbType.Image).Value = photo;
                        });

                        Execute(con, tx, @"INSERT INTO dbo.Design
                            (design_ID, design_Type, upload_Date, design_Fee, customer_ID)
                            VALUES (@id,@type,@date,@fee,@customer)", cmd =>
                        {
                            AddText(cmd, "@id", designId, 50);
                            AddText(cmd, "@type", result.quote.package, 50);
                            cmd.Parameters.Add("@date", SqlDbType.Date).Value = DateTime.Today;
                            AddMoney(cmd, "@fee", result.quote.designFeeCents / 100m);
                            cmd.Parameters.Add("@customer", SqlDbType.Int).Value = customerId;
                        });

                        Execute(con, tx, @"INSERT INTO dbo.[Order]
                            (order_ID, order_Date, order_TotalCost, order_Status, customer_ID)
                            VALUES (@id,@date,@total,'Pending',@customer)", cmd =>
                        {
                            AddText(cmd, "@id", orderId, 50);
                            cmd.Parameters.Add("@date", SqlDbType.Date).Value = DateTime.Today;
                            AddMoney(cmd, "@total", result.quote.totalCents / 100m);
                            cmd.Parameters.Add("@customer", SqlDbType.Int).Value = customerId;
                        });

                        for (int i = 0; i < lines.Count; i++)
                        {
                            OrderLine line = lines[i];
                            string currentId = "ORDIT" + checked(nextItemNumber + i).ToString("D3", CultureInfo.InvariantCulture);
                            string detail = "Uploaded design: " + description;
                            if (detail.Length > 200) detail = detail.Substring(0, 200);
                            Execute(con, tx, @"INSERT INTO dbo.OrderItem
                                (orderItem_ID, orderItem_Quantity, item, DesignPackage,
                                 orderItem_Subtotal, orderItem_Description, design_ID,
                                 order_ID, orderItem_Status, designFile_ID,
                                 orderItem_Size, orderItem_Colour, Variant_ID)
                                VALUES (@id,@quantity,@item,@package,@subtotal,@description,
                                        @design,@order,'Pending',@file,@size,@colour,@variant)", cmd =>
                            {
                                AddText(cmd, "@id", currentId, 50);
                                cmd.Parameters.Add("@quantity", SqlDbType.Int).Value = line.Quantity;
                                AddText(cmd, "@item", request.item, 50);
                                AddText(cmd, "@package", result.quote.package + " - R" +
                                    (result.quote.designFeeCents / 100m).ToString("0.00", CultureInfo.InvariantCulture), 50);
                                AddMoney(cmd, "@subtotal", line.FinalCents / 100m);
                                AddText(cmd, "@description", detail, 200);
                                AddText(cmd, "@design", designId, 50);
                                AddText(cmd, "@order", orderId, 50);
                                AddText(cmd, "@file", fileId, 50);
                                AddText(cmd, "@size", request.size, 50);
                                AddText(cmd, "@colour", line.Colour, 50);
                                cmd.Parameters.Add("@variant", SqlDbType.Int).Value = line.VariantId;
                            });
                        }

                        // Exactly as agreed: Customer.order_ID points to newest order.
                        Execute(con, tx,
                            "UPDATE dbo.Customer SET order_ID=@order WHERE customer_ID=@customer", cmd =>
                            {
                                AddText(cmd, "@order", orderId, 50);
                                cmd.Parameters.Add("@customer", SqlDbType.Int).Value = customerId;
                            });

                        tx.Commit();
                        return orderId;
                    }
                    catch
                    {
                        try { tx.Rollback(); } catch { /* preserve original error */ }
                        throw;
                    }
                }
            }
        }

    }
}