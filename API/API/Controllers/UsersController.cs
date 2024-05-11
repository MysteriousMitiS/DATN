using API.Models;
using Helper;
using Newtonsoft.Json;
using OfficeOpenXml;
using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Data.Entity.Validation;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Net.Sockets;
using System.Reflection;
using System.Security.Claims;
using System.Text;
using System.Threading.Tasks;
using System.Web;
using System.Web.Http;

namespace Controllers
{
    [Authorize]
    public class UsersController : ApiController
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

        [HttpPost]
        public async Task<HttpResponseMessage> Add_Users()
        {
            var identity = User.Identity as ClaimsIdentity;
            string fduser = "";
            IEnumerable<Claim> claims = identity.Claims;
            string ip = getipaddress();
            string name = claims.Where(p => p.Type == "fname").FirstOrDefault()?.Value;
            string tid = claims.Where(p => p.Type == "tid").FirstOrDefault()?.Value;
            string uid = claims.Where(p => p.Type == "uid").FirstOrDefault()?.Value;
            bool ad = claims.Where(p => p.Type == "ad").FirstOrDefault()?.Value == "True";
            string domainurl = HttpContext.Current.Request.Url.Scheme + "://" + HttpContext.Current.Request.Url.Host + ":" + HttpContext.Current.Request.Url.Port + "/";
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
                using (DbEntities db = new DbEntities())
                {
                    if (!Request.Content.IsMimeMultipartContent())
                    {
                        throw new HttpResponseException(HttpStatusCode.UnsupportedMediaType);
                    }

                    string root = HttpContext.Current.Server.MapPath("~/Portals");
                    string strPath = root + "/Users";
                    bool exists = Directory.Exists(strPath);
                    if (!exists)
                        Directory.CreateDirectory(strPath);
                    var provider = new MultipartFormDataStreamProvider(root);

                    // Read the form data and return an async task.
                    var task = Request.Content.ReadAsMultipartAsync(provider).
                    ContinueWith<HttpResponseMessage>(t =>
                    {
                        if (t.IsFaulted || t.IsCanceled)
                        {
                            Request.CreateErrorResponse(HttpStatusCode.InternalServerError, t.Exception);
                        }
                        var md = provider.FormData.GetValues("user").SingleOrDefault();
                        fduser = provider.FormData.GetValues("user").SingleOrDefault();
                        UserP user = JsonConvert.DeserializeObject<UserP>(fduser);
                        if (user.isDecentlz == null)
                        {
                            user.isDecentlz = 0;
                        };
                        if (user.IsAdmin == true)
                        {
                            user.isDecentlz = 6;
                        }
                        if (db.UserPs.Count(a => a.UserName == user.UserName) > 0)
                        {
                            return Request.CreateResponse(HttpStatusCode.OK, new { ms = "Đã có tài khoản người dùng này trong hệ thống rồi!", err = "1" });
                        }
                        if (db.UserPs.Count(a => a.UserCode == user.UserCode) > 0)
                        {
                            return Request.CreateResponse(HttpStatusCode.OK, new { ms = "Đã có mã  người dùng này trong hệ thống rồi!", err = "1" });
                        }

                        string depass = Codec.EncryptString(user.Password, helper.passkey);
                        user.Password = depass;
                        user.KeyEncript = Convert.ToBase64String(Encoding.UTF8.GetBytes(helper.passkey));
                        FileInfo fileInfo = null;
                        MultipartFileData ffileData = null;
                        string newFileName = "";
                        foreach (MultipartFileData fileData in provider.FileData)
                        {
                            string fileName = "";
                            if (string.IsNullOrEmpty(fileData.Headers.ContentDisposition.FileName))
                            {
                                fileName = Guid.NewGuid().ToString();
                            }
                            fileName = fileData.Headers.ContentDisposition.FileName;
                            if (fileName.StartsWith("\"") && fileName.EndsWith("\""))
                            {
                                fileName = fileName.Trim('"');
                            }
                            if (fileName.Contains(@"/") || fileName.Contains(@"\"))
                            {
                                fileName = Path.GetFileName(fileName);
                            }
                            fileName = helper.convertToUnSign3(fileName);
                            newFileName = Path.Combine(root + "/Users", fileName);
                            fileInfo = new FileInfo(newFileName);
                            if (fileInfo.Exists)
                            {
                                fileName = fileInfo.Name.Replace(fileInfo.Extension, "");
                                fileName = fileName + (new Random().Next(0, 10000)) + fileInfo.Extension;

                                newFileName = Path.Combine(root + "/Users", fileName);
                            }
                            if (!Directory.Exists(fileInfo.Directory.FullName))
                            {
                                Directory.CreateDirectory(fileInfo.Directory.FullName);
                            }
                            user.Avatar = "/Portals/Users/" + fileName;
                            ffileData = fileData;
                        }
                      
                        user.Token_ID = tid;
                      
                        user.CreatedDate = DateTime.Now;
                        user.CreatedBy = uid;
                      
                        if (!ad)
                        {
                            user.IsAdmin = false;
                        }

                        db.UserPs.Add(user);
                        db.SaveChanges();
                        if (fileInfo != null)
                        {
                            if (!Directory.Exists(fileInfo.Directory.FullName))
                            {
                                Directory.CreateDirectory(fileInfo.Directory.FullName);
                            }
                            File.Move(ffileData.LocalFileName, newFileName);
                            helper.ResizeImage(newFileName, 640, 640, 90);
                        }
                      
                        return Request.CreateResponse(HttpStatusCode.OK, new { err = "0" });
                    });
                    return await task;
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

        [HttpPut]
        public async Task<HttpResponseMessage> Update_Users()
        {
            var identity = User.Identity as ClaimsIdentity;
            string fduser = "";
            IEnumerable<Claim> claims = identity.Claims;
            string ip = getipaddress();
            string name = claims.Where(p => p.Type == "fname").FirstOrDefault()?.Value;
            string tid = claims.Where(p => p.Type == "tid").FirstOrDefault()?.Value;
            string uid = claims.Where(p => p.Type == "uid").FirstOrDefault()?.Value;
            bool ad = claims.Where(p => p.Type == "ad").FirstOrDefault()?.Value == "True";
            string domainurl = HttpContext.Current.Request.Url.Scheme + "://" + HttpContext.Current.Request.Url.Host + ":" + HttpContext.Current.Request.Url.Port + "/";
            List<string> delfiles = new List<string>();
            List<string> ltFiles = new List<string>();
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
                using (DbEntities db = new DbEntities())
                {
                    if (!Request.Content.IsMimeMultipartContent())
                    {
                        throw new HttpResponseException(HttpStatusCode.UnsupportedMediaType);
                    }

                    string root = HttpContext.Current.Server.MapPath("~/Portals");
                    string strPath = root + "/Users";
                    bool exists = Directory.Exists(strPath);
                    if (!exists)
                        Directory.CreateDirectory(strPath);
                    var provider = new MultipartFormDataStreamProvider(root);

                    // Read the form data and return an async task.
                    var task = Request.Content.ReadAsMultipartAsync(provider).
                    ContinueWith<HttpResponseMessage>(t =>
                    {
                        if (t.IsFaulted || t.IsCanceled)
                        {
                            Request.CreateErrorResponse(HttpStatusCode.InternalServerError, t.Exception);
                        }
                        var md = provider.FormData.GetValues("user").SingleOrDefault();
                        fduser = provider.FormData.GetValues("user").SingleOrDefault();
                        string noidung = provider.FormData.GetValues("noidung") != null ? provider.FormData.GetValues("noidung").SingleOrDefault() : "";
                        UserP user = JsonConvert.DeserializeObject<UserP>(fduser);
                        var um = db.UserPs.AsNoTracking().FirstOrDefault(x => x.UserName == user.UserName);
                        string depass = Codec.EncryptString(user.Password, helper.passkey);
                        if (um?.Password != user.Password)
                            user.Password = depass;
                        #region nội dung thay đổi
                        if (noidung == "")
                        {
                            if (um.Name != user.Name)
                            {
                                noidung += "Chỉnh sửa tên tài khoản\n";
                            }
                            if (provider.FileData.Count > 0)
                            {
                                noidung += "Chỉnh sửa ảnh tài khoản\n";
                            }
                         
                            if (um?.Password != depass)
                            {
                                noidung += "Chỉnh sửa mật khẩu\n";
                            }
                        }
                        #endregion
                        FileInfo fileInfo = null;
                        MultipartFileData ffileData = null;
                        string newFileName = "";
                        // This illustrates how to get thefile names.
                        foreach (MultipartFileData fileData in provider.FileData)
                        {
                            string fileName = "";
                            if (string.IsNullOrEmpty(fileData.Headers.ContentDisposition.FileName))
                            {
                                fileName = Guid.NewGuid().ToString();
                            }
                            fileName = fileData.Headers.ContentDisposition.FileName;
                            if (fileName.StartsWith("\"") && fileName.EndsWith("\""))
                            {
                                fileName = fileName.Trim('"');
                            }
                            if (fileName.Contains(@"/") || fileName.Contains(@"\"))
                            {
                                fileName = Path.GetFileName(fileName);
                            }
                            fileName = helper.convertToUnSign3(fileName);
                            newFileName = Path.Combine(root + "/Users", fileName);
                            fileInfo = new FileInfo(newFileName);
                            if (fileInfo.Exists)
                            {
                                fileName = fileInfo.Name.Replace(fileInfo.Extension, "");
                                fileName = fileName + (new Random().Next(0, 10000)) + fileInfo.Extension;

                                newFileName = Path.Combine(root + "/Users", fileName);
                            }
                            if (user.Avatar != null)
                                delfiles.Add(root + user.Avatar);
                            user.Avatar = "/Portals/Users/" + fileName;
                            ffileData = fileData;
                            if (!Directory.Exists(fileInfo.Directory.FullName))
                            {
                                Directory.CreateDirectory(fileInfo.Directory.FullName);
                            }
                            File.Move(fileData.LocalFileName, newFileName);
                            helper.ResizeImage(newFileName, 640, 640, 90);
                            ltFiles.Add(newFileName);
                        }
                   
                        user.Token_ID = tid;
                        
                        db.Entry(user).State = EntityState.Modified;
                  
                        try
                        {
                            db.SaveChanges();
                            //Add ảnh
                            foreach (string fpath in delfiles)
                            {
                                if (File.Exists(fpath))
                                    File.Delete(fpath);
                            }
                            return Request.CreateResponse(HttpStatusCode.OK, new { err = "0" });
                        }
                        catch (DbEntityValidationException e)
                        {
                            foreach (string fpath in ltFiles)
                            {
                                if (File.Exists(fpath))
                                    File.Delete(fpath);
                            }
                            string contents = helper.getCatchError(e, null);
                            if (!helper.debug)
                            {
                                contents = "";
                            }
                            return Request.CreateResponse(HttpStatusCode.OK, new { ms = contents, err = "1" });
                        }
                        catch (Exception e)
                        {
                            foreach (string fpath in ltFiles)
                            {
                                if (File.Exists(fpath))
                                    File.Delete(fpath);
                            }
                            string contents = helper.ExceptionMessage(e);
                            if (!helper.debug)
                            {
                                contents = "";
                            }
                            return Request.CreateResponse(HttpStatusCode.OK, new { ms = contents, err = "1" });
                        }
                    });
                    return await task;
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

        [HttpDelete]
        public async Task<HttpResponseMessage> Del_Users([FromBody] List<string> ids)
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
                string ip = getipaddress();
                string name = claims.Where(p => p.Type == "fname").FirstOrDefault()?.Value;
                string tid = claims.Where(p => p.Type == "tid").FirstOrDefault()?.Value;
                string uid = claims.Where(p => p.Type == "uid").FirstOrDefault()?.Value;
                bool ad = claims.Where(p => p.Type == "ad").FirstOrDefault()?.Value == "True";
                string domainurl = HttpContext.Current.Request.Url.Scheme + "://" + HttpContext.Current.Request.Url.Host + ":" + HttpContext.Current.Request.Url.Port + "/";
                try
                {
                    using (DbEntities db = new DbEntities())
                    {
                        var das = await db.UserPs.Where(a => ids.Contains(a.UserName)).ToListAsync();
                        List<string> paths = new List<string>();
                        if (das != null)
                        {
                            List<UserP> del = new List<UserP>();
                            foreach (var da in das)
                            {
                                if (da.IsAdmin==true && da.CreatedBy!=uid && uid!= "administrator")
                                {
                                    return Request.CreateResponse(HttpStatusCode.OK, new { err = "1", ms = "Bạn không có quyền xóa người dùng này." });

                                }
                                if (da.CreatedBy == uid || ad || uid == "administrator")
                                {
                                    del.Add(da);
                                  
                                    if (!string.IsNullOrWhiteSpace(da.Avatar))
                                        paths.Add(HttpContext.Current.Server.MapPath("~/") + da.Avatar);
                                }
                            }
                            if (del.Count == 0)
                            {
                                return Request.CreateResponse(HttpStatusCode.OK, new { err = "1", ms = "Bạn không có quyền xóa người dùng này." });
                            }
                            db.UserPs.RemoveRange(del);
                        }
                        await db.SaveChangesAsync();
                        foreach (string strPath in paths)
                        {
                            bool exists = System.IO.File.Exists(strPath);
                            if (exists)
                                System.IO.File.Delete(strPath);
                        }
                        return Request.CreateResponse(HttpStatusCode.OK, new { err = "0" });
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
            catch (Exception)
            {
                return Request.CreateResponse(HttpStatusCode.BadRequest);
            }

        }

        //#region Excel
        //[HttpPost]
        //public async Task<HttpResponseMessage> ImportExcel()
        //{
        //    string ListErr = "";
        //    var identity = User.Identity as ClaimsIdentity;
        //    IEnumerable<Claim> claims = identity.Claims;
        //    try
        //    {
        //        if (identity == null)
        //        {
        //            return Request.CreateResponse(HttpStatusCode.OK, new { ms = "Bạn không có quyền truy cập chức năng này!", err = "1" });
        //        }
        //    }
        //    catch
        //    {
        //        return Request.CreateResponse(HttpStatusCode.OK, new { ms = "Bạn không có quyền truy cập chức năng này!", err = "1" });
        //    }
        //    string ip = getipaddress();
        //    string name = claims.Where(p => p.Type == "fname").FirstOrDefault()?.Value;
        //    string tid = claims.Where(p => p.Type == "tid").FirstOrDefault()?.Value;
        //    string uid = claims.Where(p => p.Type == "uid").FirstOrDefault()?.Value;
        //    bool ad = claims.Where(p => p.Type == "ad").FirstOrDefault()?.Value == "True";
        //    string domainurl = HttpContext.Current.Request.Url.Scheme + "://" + HttpContext.Current.Request.Url.Host + ":" + HttpContext.Current.Request.Url.Port + "/";
        //    try
        //    {
        //        using (DbEntities db = new DbEntities())
        //        {
        //            if (!Request.Content.IsMimeMultipartContent())
        //            {
        //                throw new HttpResponseException(HttpStatusCode.UnsupportedMediaType);
        //            }

        //            string root = HttpContext.Current.Server.MapPath("~/Portals");
        //            string strPath = root + "/Users";
        //            bool exists = Directory.Exists(strPath);
        //            if (!exists)
        //                Directory.CreateDirectory(strPath);
        //            var provider = new MultipartFormDataStreamProvider(root);

        //            // Read the form data and return an async task.
        //            var task = Request.Content.ReadAsMultipartAsync(provider).
        //            ContinueWith<HttpResponseMessage>(t =>
        //            {
        //                if (t.IsFaulted || t.IsCanceled)
        //                {
        //                    Request.CreateErrorResponse(HttpStatusCode.InternalServerError, t.Exception);
        //                }
        //                foreach (MultipartFileData fileData in provider.FileData)
        //                {
        //                    string fileName = "";
        //                    if (string.IsNullOrEmpty(fileData.Headers.ContentDisposition.FileName))
        //                    {
        //                        fileName = Guid.NewGuid().ToString();
        //                    }
        //                    fileName = fileData.Headers.ContentDisposition.FileName;
        //                    if (fileName.StartsWith("\"") && fileName.EndsWith("\""))
        //                    {
        //                        fileName = fileName.Trim('"');
        //                    }
        //                    if (fileName.Contains(@"/") || fileName.Contains(@"\"))
        //                    {
        //                        fileName = Path.GetFileName(fileName);
        //                    }
        //                    if (!fileName.ToLower().Contains(".xls"))
        //                    {
        //                        ListErr = "File Excel không đúng định dạng! Kiểm tra lại mẫu Import";
        //                        return Request.CreateResponse(HttpStatusCode.OK, new { err = "1", ms = ListErr });
        //                    }
        //                    var newFileName = Path.Combine(root + "/Import", fileName);
        //                    var fileInfo = new FileInfo(newFileName);
        //                    if (fileInfo.Exists)
        //                    {
        //                        fileName = fileInfo.Name.Replace(fileInfo.Extension, "");
        //                        fileName = fileName + (new Random().Next(0, 10000)) + fileInfo.Extension;

        //                        newFileName = Path.Combine(root + "/Import", fileName);
        //                    }
        //                    if (!Directory.Exists(fileInfo.Directory.FullName))
        //                    {
        //                        Directory.CreateDirectory(fileInfo.Directory.FullName);
        //                    }
        //                    File.Move(fileData.LocalFileName, newFileName);
        //                    FileInfo temp = new FileInfo(newFileName);
        //                    using (ExcelPackage pck = new ExcelPackage(temp))
        //                    {
        //                        List<UserP> dvs = new List<UserP>();
        //                        ExcelWorksheet ws = pck.Workbook.Worksheets.First();
        //                        List<string> cols = new List<string>();
        //                        var dvcs = db.UserP.Select(a => new { a.Users_ID, a.FullName }).ToList();
        //                        for (int i = 5; i <= ws.Dimension.End.Row; i++)
        //                        {
        //                            if (ws.Cells[i, 1].Value == null)
        //                            {
        //                                break;
        //                            }
        //                            UserP dv = new UserP();
        //                            for (int j = 1; j <= ws.Dimension.End.Column; j++)
        //                            {
        //                                if (ws.Cells[3, j].Value == null)
        //                                {
        //                                    break;
        //                                }
        //                                var column = ws.Cells[3, j].Value;
        //                                var vl = ws.Cells[i, j].Value;
        //                                if (column != null && vl != null)
        //                                {
        //                                    PropertyInfo propertyInfo = db.UserP.GetType().GetProperty(column.ToString());
        //                                    propertyInfo.SetValue(db.UserP, Convert.ChangeType(vl,
        //                                    propertyInfo.PropertyType), null);
        //                                }
        //                            }
        //                            if (dvcs.Count(a => a.Users_ID == dv.Users_ID || a.FullName == dv.FullName) > 0)
        //                                break;
        //                            dv.IP = ip;
        //                            dv.Nguoicapnhat = uid;
        //                            dv.Ngaycapnhat = DateTime.Now;
        //                            dv.Token_ID = tid;
        //                            dvs.Add(dv);
        //                        }
        //                        if (dvs.Count > 0)
        //                        {
        //                            db.UserP.AddRange(dvs);
        //                            db.SaveChangesAsync();
        //                            File.Delete(newFileName);
        //                        }
        //                    }
        //                }
        //                return Request.CreateResponse(HttpStatusCode.OK, new { err = "0" });
        //            });
        //            return await task;
        //        }

        //    }
        //    catch (DbEntityValidationException e)
        //    {
        //        string contents = helper.getCatchError(e, null);
        //        helper.saveLog(uid, name, JsonConvert.SerializeObject(new { contents }), domainurl + "Users/ImportExcel", ip, tid, "Lỗi khi import người dùng", 0, "Users");
        //        if (!helper.debug)
        //        {
        //            contents = "";
        //        }
        //        return Request.CreateResponse(HttpStatusCode.OK, new { ms = contents, err = "1" });
        //    }
        //    catch (Exception e)
        //    {
        //        string contents = helper.ExceptionMessage(e);
        //        helper.saveLog(uid, name, JsonConvert.SerializeObject(new { contents }), domainurl + "Users/ImportExcel", ip, tid, "Lỗi khi import người dùng", 0, "Users");
        //        if (!helper.debug)
        //        {
        //            contents = "";
        //        }
        //        return Request.CreateResponse(HttpStatusCode.OK, new { ms = contents, err = "1" });
        //    }
        //}
        //#endregion
    }
}