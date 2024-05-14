using API.Models;
using Helper;
using Microsoft.ApplicationBlocks.Data;
using OfficeOpenXml;
using OfficeOpenXml.Style;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity.Validation;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Security.Claims;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using System.Web;
using System.Web.Http;

namespace Controllers
{
    public class ExcelController : ApiController
    {
        public string getipaddress()
        {
            //var host = Dns.GetHostEntry(Dns.GetHostName());
            //foreach (var ip in host.AddressList)
            //{
            //    if (ip.AddressFamily == AddressFamily.InterNetwork)
            //    {
            //        return ip.ToString();
            //    }
            //}
            //return "localhost";
            return HttpContext.Current.Request.UserHostAddress;
        }
        [HttpPost]
        public async Task<HttpResponseMessage> ExportExcel([System.Web.Mvc.Bind(Include = "excelname,par,proc")][FromBody] sqlProc proc)
        {
            using (DbEntities db = new DbEntities())
            {
                var identity = User.Identity as ClaimsIdentity;
                IEnumerable<Claim> claims = identity.Claims;
                //try
                //{
                if (identity == null)
                {
                    return Request.CreateResponse(HttpStatusCode.OK, new { ms = "Bạn không có quyền truy cập chức năng này!", err = "1" });
                }
      
                string ip = getipaddress();
                string name = claims.Where(p => p.Type == "fname").FirstOrDefault()?.Value;
                string tid = claims.Where(p => p.Type == "tid").FirstOrDefault()?.Value;
                string uid = claims.Where(p => p.Type == "uid").FirstOrDefault()?.Value;
                string dvid = claims.Where(p => p.Type == "dvid").FirstOrDefault()?.Value;
                bool ad = claims.Where(p => p.Type == "ad").FirstOrDefault()?.Value == "True";
                string domainurl = HttpContext.Current.Request.Url.Scheme + "://" + HttpContext.Current.Request.Url.Host + ":" + HttpContext.Current.Request.Url.Port + "/";
                try
                {
                    string Connection = db.Database.Connection.ConnectionString;
                    using (ExcelPackage exportPackge = new ExcelPackage())
                    {
                        String FileName = String.Empty;
                        FileName = proc.excelname + "_" + DateTime.Now.ToString("ddMMyyyy");
                        ExcelWorksheet exWorkSheet = exportPackge.Workbook.Worksheets.Add(FileName);
                        #region tbody
                        var sqlpas = new List<SqlParameter>();
                        if (proc != null && proc.par != null)
                        {
                            foreach (sqlPar p in proc.par)
                            {
                                sqlpas.Add(new SqlParameter("@" + p.par, p.va));
                            }
                        }
                        var arrpas = sqlpas.ToArray();
                        var task = Task.Run(() => SqlHelper.ExecuteDataset(Connection, proc.proc, arrpas).Tables[0]);
                        var table = await task;
                        #region thead
                        var len = table.Columns.Count;
                        int start = 3;
                        ExcelRange topcell1 = exWorkSheet.Cells[1, 1, 1, len];
                        exWorkSheet.Row(1).Height = 40;
                        exWorkSheet.Row(2).Height = 20;
                        exWorkSheet.Row(3).Height = 25;
                        exWorkSheet.Row(4).Height = 25;
                        topcell1.Style.Font.Bold = true;
                        topcell1.Style.Font.Size = 16;
                        topcell1.Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
                        topcell1.Style.VerticalAlignment = ExcelVerticalAlignment.Center;
                        topcell1.Merge = true;
                        topcell1.Style.WrapText = true;
                        ExcelRange topcell2 = exWorkSheet.Cells[2, 1, 2, len];
                        topcell2.Value = DateTime.Now.ToString("HH:mm dd/MM/yyyy");
                        topcell2.Style.Font.Italic = true;
                        topcell2.Style.Font.Bold = false;
                        topcell2.Style.Font.Size = 12;
                        topcell2.Style.HorizontalAlignment = ExcelHorizontalAlignment.Right;
                        topcell2.Style.VerticalAlignment = ExcelVerticalAlignment.Center;
                        topcell2.Merge = true;
                        topcell2.Style.WrapText = true;
                        for (int i = 1; i <= len; i++)
                        {
                            var col = table.Columns[i - 1];
                            ExcelRange cell = exWorkSheet.Cells[start, i];
                            cell.Value = col.ColumnName.Split('|')[0];
                            exWorkSheet.Row(start).Hidden = true;
                            exWorkSheet.Row(start).Style.Font.Color.SetColor(System.Drawing.Color.Transparent);
                        }
                        start++;
                        for (int i = 1; i <= len; i++)
                        {
                            var col = table.Columns[i - 1];
                            ExcelRange cell = exWorkSheet.Cells[start, i];
                            cell.Value = col.ColumnName.Split('|')[1];
                            cell.Style.Indent = 1;
                            cell.Style.Font.Bold = true;
                            exWorkSheet.Column(i).Style.Font.Size = 12;
                            exWorkSheet.Column(i).Style.WrapText = true;
                            exWorkSheet.Column(i).Width = int.Parse(col.ColumnName.Split('|')[2]);
                            cell.Style.Fill.PatternType = ExcelFillStyle.Solid;
                            cell.Style.Border.Top.Style = ExcelBorderStyle.Thin;
                            cell.Style.Border.Left.Style = ExcelBorderStyle.Thin;
                            cell.Style.Border.Right.Style = ExcelBorderStyle.Thin;
                            cell.Style.Border.Bottom.Style = ExcelBorderStyle.Thin;
                            cell.Style.HorizontalAlignment = col.ColumnName.Split('|')[3].ToUpper() == "C" ? ExcelHorizontalAlignment.Center : ExcelHorizontalAlignment.Center;
                            cell.Style.VerticalAlignment = ExcelVerticalAlignment.Center;
                        }
                        exWorkSheet.Cells[start, 1, start, len].Style.Fill.PatternType = ExcelFillStyle.Solid;
                        exWorkSheet.Cells[start, 1, start, len].Style.Fill.BackgroundColor.SetColor(System.Drawing.ColorTranslator.FromHtml("#0078d4"));
                        exWorkSheet.Cells[start, 1, start, len].Style.Font.Color.SetColor(System.Drawing.Color.White);
                        #endregion
                        topcell1.Value = string.Format(proc.excelname + " ({0})", table.Rows.Count);
                        for (int k = 0; k < table.Rows.Count; k++)
                        {
                            start += 1;
                            var dr = table.Rows[k];
                            for (int i = 1; i <= len; i++)
                            {
                                var col = table.Columns[i - 1];
                                ExcelRange cell = exWorkSheet.Cells[start, i];
                                ExcelRange cellMauNen = exWorkSheet.Cells[4, 4];
                                ExcelRange cellMauChu = exWorkSheet.Cells[4, 5];
                                try
                                {
                                    if (dr[col.ColumnName].ToString().Contains("Portal") == true && proc.excelname == "DANH SÁCH TEM")
                                    {
                                        exWorkSheet.Row(i + 2).Height = 150;
                                        // cell.Value = dr[col.ColumnName].ToString() + "1";
                                        string strPath11 = HttpContext.Current.Server.MapPath(dr[col.ColumnName].ToString());
                                        System.Web.UI.WebControls.Image TEST_IMAGE = new System.Web.UI.WebControls.Image();

                                        var url = dr[col.ColumnName] != null ? dr[col.ColumnName].ToString() : "";
                                        url = Regex.Replace(url.Replace("\\", "/"), @"\.*/+", "/");
                                        var listPath = url.Split('/');
                                        var pathFile = "";
                                        foreach (var item in listPath)
                                        {
                                            if (item.Trim() != "")
                                            {
                                                pathFile += "/" + Path.GetFileName(item);
                                            }
                                        }
                                        if (!File.Exists(HttpContext.Current.Server.MapPath("~/") + pathFile))
                                        //string pathFileInExport = HttpContext.Current.Server.MapPath("~/Portals");
                                        //if (dr[col.ColumnName].ToString().Contains("Emote"))
                                        //{
                                        //    pathFileInExport += "/Emote";
                                        //}
                                        //if (!File.Exists(Path.Combine(pathFileInExport, Path.GetFileName(strPath11))))
                                        {
                                            cell.Value = dr[col.ColumnName].ToString() + " (File đã bị xóa hoặc chuyển đi nơi khác!)";
                                        }
                                        else
                                        {
                                            System.Drawing.Image myImage = System.Drawing.Image.FromFile(strPath11);
                                            var pic = exWorkSheet.Drawings.AddPicture(dr[col.ColumnName].ToString(), myImage);
                                            pic.SetSize(180, 180);
                                            // Row, RowoffsetPixel, Column, ColumnOffSetPixel
                                            pic.SetPosition(i + 1, 10, 2, 12);
                                        }
                                    }
                                    else
                                    {
                                        cell.Value = dr[col.ColumnName].ToString();
                                    }
                                    cell.Style.Indent = 1;
                                    cell.Style.Border.Top.Style = ExcelBorderStyle.Thin;
                                    cell.Style.Border.Left.Style = ExcelBorderStyle.Thin;
                                    cell.Style.Border.Right.Style = ExcelBorderStyle.Thin;
                                    cell.Style.Border.Bottom.Style = ExcelBorderStyle.Thin;
                                    cell.Style.HorizontalAlignment = col.ColumnName.Split('|')[3].ToUpper() == "C" ? ExcelHorizontalAlignment.Center : ExcelHorizontalAlignment.Left;
                                    cell.Style.VerticalAlignment = ExcelVerticalAlignment.Center;
                                }
                                catch (Exception e) { }
                            }
                        }
                        #endregion
                        Byte[] fileBytes = exportPackge.GetAsByteArray();
                        string fname = helper.convertToUnSign3(proc.excelname.ToLower() + "_" + uid);
                        var strPath = HttpContext.Current.Server.MapPath("~/Portals/Export");
                        bool exists = Directory.Exists(strPath);
                        if (!exists)
                            Directory.CreateDirectory(strPath);
                        string path = HttpContext.Current.Server.MapPath("~/Portals/Export/" + fname + ".xlsx");
                        File.WriteAllBytes(path, fileBytes);
                        return Request.CreateResponse(HttpStatusCode.OK, new { path = "/Portals/Export/" + fname + ".xlsx", err = "0" });
                    }
                }
                catch (DbEntityValidationException e)
                {
                    string contents = helper.getCatchError(e, null);
                    if (!helper.debug)
                    {
                        contents = "";
                    }

                    return Request.CreateResponse(HttpStatusCode.OK, new { ms = contents, err = "1" });
                }
                catch (Exception e)
                {
                    string contents = helper.ExceptionMessage(e);
                    if (!helper.debug)
                    {
                        contents = "";
                    }

                    return Request.CreateResponse(HttpStatusCode.OK, new { ms = contents, err = "1" });
                }
            }
        }
    }
}