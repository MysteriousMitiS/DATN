using API.Models;
using Helper;
using Microsoft.ApplicationBlocks.Data;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data.Entity.Validation;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Net.Sockets;
using System.Security.Claims;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using System.Web;
using System.Web.Http;
using System.Web.Http.Cors;

namespace Controllers
{
  
    public class SQLController : ApiController
    {
        public string getipaddress()
        {
            var host = Dns.GetHostEntry(Dns.GetHostName());
            foreach (var ip in host.AddressList)
            {
                if (ip.AddressFamily == AddressFamily.InterNetwork)
                {
                    return ip.ToString();
                }
            }
            return "localhost";
        }
       
        [Authorize]
        [HttpPost]
        public async Task<HttpResponseMessage> FilterSQLOFFSET([FromBody] FilterSQL filterSQL)
        {
            var identity = User.Identity as ClaimsIdentity;
            IEnumerable<Claim> claims = identity.Claims;
            try
            {
                if (identity == null)
                {
                    return Request.CreateResponse(HttpStatusCode.OK, new { ms = "Bạn không có quyền truy cập chức năng này!", err = "1" });
                }
            }
            catch
            {
                return Request.CreateResponse(HttpStatusCode.OK, new { ms = "Bạn không có quyền truy cập chức năng này!", err = "1" });
            }
            try
            {
                string Connection = System.Configuration.ConfigurationManager.ConnectionStrings["Connection"].ConnectionString;
                string ip = getipaddress();
                string name = claims.Where(p => p.Type == "fname").FirstOrDefault()?.Value;
                string tid = claims.Where(p => p.Type == "tid").FirstOrDefault()?.Value;
                string uid = claims.Where(p => p.Type == "uid").FirstOrDefault()?.Value;
                string domainurl = HttpContext.Current.Request.Url.Scheme + "://" + HttpContext.Current.Request.Url.Host + ":" + HttpContext.Current.Request.Url.Port + "/";
                string sql = "";
                try
                {
                    int OFFSET = (filterSQL.PageNo - 1) * filterSQL.PageSize;
                    sql = @"
                        Select WebAcess_ID,Users_ID,FullName,IsTime,IsEndTime,FromIP,FromDivice from Sys_WebAcess
                    ";
                    string WhereSQL = "";
                    if (filterSQL.fieldSQLS != null && filterSQL.fieldSQLS.Count > 0)
                    {
                        foreach (var field in filterSQL.fieldSQLS)
                        {
                            if (field.filteroperator == "in")
                            {
                                WhereSQL += (WhereSQL != "" ? " And " : " ") + field.key + " in(" + String.Join(",", field.filterconstraints.Select(a => "'" + a.value + "'").ToList()) + ")";
                            }
                            else
                            {
                                foreach (var m in field.filterconstraints.Where(a => a.value != null))
                                {
                                    switch (m.matchMode)
                                    {
                                        case "startsWith":
                                            WhereSQL += " " + field.filteroperator + " " + field.key + " like N'" + m.value + "%'";
                                            break;
                                        case "endsWith":
                                            WhereSQL += " " + field.filteroperator + " " + field.key + " like N'%" + m.value + "'";
                                            break;
                                        case "contains":
                                            WhereSQL += " " + field.filteroperator + " " + field.key + " like N'%" + m.value + "%'";
                                            break;
                                        case "notContains":
                                            WhereSQL += " " + field.filteroperator + " " + field.key + "  not like N'%" + m.value + "%'";
                                            break;
                                        case "equals":
                                            WhereSQL += " " + field.filteroperator + " " + field.key + " = N'" + m.value + "'";
                                            break;
                                        case "notEquals":
                                            WhereSQL += " " + field.filteroperator + " " + field.key + "  <> N'" + m.value + "'";
                                            break;
                                        case "dateIs":
                                            WhereSQL += " " + field.filteroperator + " CAST(" + field.key + " as date) = CAST('" + m.value + "' as date)";
                                            break;
                                        case "dateIsNot":
                                            WhereSQL += " " + field.filteroperator + " CAST(" + field.key + " as date) <> CAST('" + m.value + "' as date)";
                                            break;
                                        case "dateBefore":
                                            WhereSQL += " " + field.filteroperator + " CAST(" + field.key + " as date) < CAST('" + m.value + "' as date)";
                                            break;
                                        case "dateAfter":
                                            WhereSQL += " " + field.filteroperator + " CAST(" + field.key + " as date) > CAST('" + m.value + "' as date)";
                                            break;

                                    }
                                }
                            }
                        }
                    }
                    if (WhereSQL.StartsWith(" and "))
                    {
                        WhereSQL = WhereSQL.Substring(4);
                    }
                    else if (WhereSQL.StartsWith(" or "))
                    {
                        WhereSQL = WhereSQL.Substring(3);
                    }
                    if (WhereSQL.Trim() != "")
                    {
                        sql += " WHERE " + WhereSQL;
                    }
                    sql += @"
                        ORDER BY " + filterSQL.sqlO + @"
                        OFFSET " + OFFSET + " ROWS FETCH NEXT " + filterSQL.PageSize + " ROWS ONLY";
                    sql = sql.Replace("\r", " ").Replace("\n", " ").Replace("   ", " ").Trim();
                    sql = Regex.Replace(sql, @"\s+", " ").Trim();
                    var task = Task.Run(() => SqlHelper.ExecuteDataset(Connection, System.Data.CommandType.Text, sql).Tables);
                    var tables = await task;
                    string JSONresult = JsonConvert.SerializeObject(tables);
                    return Request.CreateResponse(HttpStatusCode.OK, new { data = JSONresult, sql, err = "0" });
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
            catch (Exception)
            {
                return Request.CreateResponse(HttpStatusCode.BadRequest);
            }

        }

        [Authorize]
        [HttpPost]
        public async Task<HttpResponseMessage> FilterCMS_News([FromBody] FilterSQL filterSQL)
        {
            var identity = User.Identity as ClaimsIdentity;
            IEnumerable<Claim> claims = identity.Claims;
            try
            {
                if (identity == null)
                {
                    return Request.CreateResponse(HttpStatusCode.OK, new { ms = "Bạn không có quyền truy cập chức năng này!", err = "1" });
                }
            }
            catch
            {
                return Request.CreateResponse(HttpStatusCode.OK, new { ms = "Bạn không có quyền truy cập chức năng này!", err = "1" });
            }
            try
            {
                string Connection = System.Configuration.ConfigurationManager.ConnectionStrings["Connection"].ConnectionString;
                string ip = getipaddress();
                string name = claims.Where(p => p.Type == "fname").FirstOrDefault()?.Value;
                string tid = claims.Where(p => p.Type == "tid").FirstOrDefault()?.Value;
                string uid = claims.Where(p => p.Type == "uid").FirstOrDefault()?.Value;
                string domainurl = HttpContext.Current.Request.Url.Scheme + "://" + HttpContext.Current.Request.Url.Host + ":" + HttpContext.Current.Request.Url.Port + "/";
                string sql = "";
                string sqlCount = "";
               
                     sqlCount = " Select count(News_ID)  as totalRecords from News";

                
                try
                {
                    int Start = (filterSQL.PageNo * filterSQL.PageSize - filterSQL.PageSize);
                    sql = @"
                        Select cn.*  from News as cn
                    ";
                    string WhereSQL = "";
                
                        if (filterSQL.fieldSQLS != null && filterSQL.fieldSQLS.Count > 0)
                    {
                        foreach (var field in filterSQL.fieldSQLS)
                        {
                            if (field.filteroperator == "in")
                            {
                                WhereSQL += (WhereSQL != "" ? " And " : " ") + field.key + " in(" + String.Join(",", field.filterconstraints.Select(a => "'" + a.value + "'").ToList()) + ")";
                            }
                            else
                            {
                                foreach (var m in field.filterconstraints.Where(a => a.value != null))
                                {
                                    switch (m.matchMode)
                                    {
                                        case "lt":
                                            WhereSQL += " " + field.filteroperator + " (" + field.key + " < " + m.value + ")";
                                            break;
                                        case "gt":
                                            WhereSQL += " " + field.filteroperator + " (" + field.key + " >" + m.value + ")";
                                            break;
                                        case "lte":
                                            WhereSQL += " " + field.filteroperator + " (" + field.key + " <= " + m.value + ")";
                                            break;
                                        case "gte":
                                            WhereSQL += " " + field.filteroperator + " (" + field.key + " >= " + m.value + ")";
                                            break;
                                        case "startsWith":
                                            WhereSQL += " " + field.filteroperator + " " + field.key + " LIKE '" + m.value + "%' ";
                                            break;
                                        case "endsWith":
                                            WhereSQL += " " + field.filteroperator + " Contains(" + field.key + ",'\"*" + m.value + "\"') ";
                                            break;
                                        case "contains":
                                            WhereSQL += " " + field.filteroperator + " Contains(" + field.key + ",'\"*" + m.value + "*\"') ";
                                            break;
                                        case "notContains":
                                            WhereSQL += " " + field.filteroperator + " NOT Contains(" + field.key + ",'\"*" + m.value + "*\"') ";
                                            break;
                                        case "equals":
                                            WhereSQL += " " + field.filteroperator + " (" + field.key + " = N'" + m.value + "')";
                                            break;
                                        case "notEquals":
                                            WhereSQL += " " + field.filteroperator + " (" + field.key + "  <> N'" + m.value + "')";
                                            break;
                                        case "dateIs":
                                            WhereSQL += " " + field.filteroperator + " CAST(" + field.key + " as date) = CAST('" + m.value + "' as date)";
                                            break;
                                        case "dateIsNot":
                                            WhereSQL += " " + field.filteroperator + " CAST(" + field.key + " as date) <> CAST('" + m.value + "' as date)";
                                            break;
                                        case "dateBefore":
                                            WhereSQL += " " + field.filteroperator + " CAST(" + field.key + " as date) < CAST('" + m.value + "' as date)";
                                            break;
                                        case "dateAfter":
                                            WhereSQL += " " + field.filteroperator + " CAST(" + field.key + " as date) > CAST('" + m.value + "' as date)";
                                            break;

                                    }
                                }
                            }
                        }
                    }

                    if (WhereSQL.StartsWith(" and "))
                    {
                        WhereSQL = WhereSQL.Substring(4);
                    }
                    else if (WhereSQL.StartsWith(" or "))
                    {
                        WhereSQL = WhereSQL.Substring(3);
                    }

                    //if (filterSQL.next)//Trang tiếp
                    //{
                    //    if (filterSQL.id != null)
                    //    {
                    //        WhereSQL = " (News_ID" + (filterSQL.sqlO.Contains("DESC") ? "<" : ">") + filterSQL.id + ") " + (WhereSQL.Trim() != "" ? " And " + WhereSQL : "");
                    //    }
                    //}
                    //else//Trang trước
                    //{
                    //    if (filterSQL.id != "-1")
                    //    {
                    //        WhereSQL = " (News_ID" + (filterSQL.sqlO.Contains("DESC") ? ">" : "<") + filterSQL.id + ") " + (WhereSQL.Trim() != "" ? " And " + WhereSQL : "");
                    //    }
                    //}
                    //Search
                    if (!string.IsNullOrWhiteSpace(filterSQL.Search))
                    {
                        WhereSQL = (WhereSQL.Trim() != "" ? (WhereSQL + " And  ") : "") + "News_Name like N'%" + filterSQL.Search.ToUpper() + "%' collate Latin1_General_100_Bin2";
                    }
                    if (WhereSQL.Trim() != "")
                    {
                        sql += " WHERE " + WhereSQL;
                        sqlCount += " WHERE " + WhereSQL;
                    }
                    if (!filterSQL.next)//Đảo Sort
                    {
                        sql = "Select * from (" + sql + " ORDER BY " + (filterSQL.sqlO.Contains("DESC") ? filterSQL.sqlO.Replace("DESC", "ASC") : filterSQL.sqlO.Replace("ASC", "DESC")) + ") as tbn ";
                    }
                    sql += @"
                        ORDER BY " + filterSQL.sqlO + @"
                        OFFSET " + Start + " ROWS FETCH NEXT " + filterSQL.PageSize + " ROWS ONLY";
                    if (filterSQL.id == null)
                    {
                        sql += sqlCount;
                    }
                    sql = sql.Replace("\r", " ").Replace("\n", " ").Replace("   ", " ").Trim();
                    sql = Regex.Replace(sql, @"\s+", " ").Trim();
                    var task = Task.Run(() => SqlHelper.ExecuteDataset(Connection, System.Data.CommandType.Text, sql).Tables);
                    var tables = await task;
                    string JSONresult = JsonConvert.SerializeObject(tables);
                    return Request.CreateResponse(HttpStatusCode.OK, new { data = JSONresult, sql, err = "0" });
                }
                catch (DbEntityValidationException e)
                {
                    string contents = helper.getCatchError(e, null);
                    if (!helper.debug)
                    {
                        contents = "";
                    }
                    return Request.CreateResponse(HttpStatusCode.OK, new { ms = contents, err = "1", sql });
                }
                catch (Exception e)
                {
                    string contents = helper.ExceptionMessage(e);
                    if (!helper.debug)
                    {
                        contents = "";
                    }
                    return Request.CreateResponse(HttpStatusCode.OK, new { ms = contents, err = "1", sql });
                }
            }
            catch (Exception)
            {
                return Request.CreateResponse(HttpStatusCode.BadRequest);
            }

        }
    }
}