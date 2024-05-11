using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Data.Entity.Infrastructure;
using System.Data.Entity.Validation;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Net.Sockets;
using System.Security.Claims;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using System.Web;
using System.Web.Http;
using System.Web.Http.Description;
using API.Models;
using Helper;
using Newtonsoft.Json;


namespace API.Controllers
{
    public class NewsController : ApiController
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
        public async Task<HttpResponseMessage> AddNews()
        {
            var identity = User.Identity as ClaimsIdentity;
            string fdtintuc = "";
            IEnumerable<Claim> claims = identity.Claims;
            string ip = getipaddress();
            string name = claims.Where(p => p.Type == "fname").FirstOrDefault()?.Value;
            string tid = claims.Where(p => p.Type == "tid").FirstOrDefault()?.Value;
            string uid = claims.Where(p => p.Type == "uid").FirstOrDefault()?.Value;
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
                    string strPath = root + "/News";
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
                        fdtintuc = provider.FormData.GetValues("tintuc").SingleOrDefault();
                        News tinTuc = JsonConvert.DeserializeObject<News>(fdtintuc);
                        HtmlAgilityPack.HtmlDocument doc = new HtmlAgilityPack.HtmlDocument();
                        doc.LoadHtml(tinTuc.Details);

                        var imgs = doc.DocumentNode.SelectNodes("//img");

                        if (imgs != null)
                        {

                            foreach (var img in imgs)
                            {

                                var pathFolderDes = "/Portals/News";
                                var checkBase64 = img.Attributes["src"].Value.Substring(img.Attributes["src"].Value.LastIndexOf("base64,") + 7);
                                checkBase64 = checkBase64.Trim();
                                if ((checkBase64.Length % 4 == 0) && Regex.IsMatch(checkBase64, @"^[a-zA-Z0-9\+/]*={0,3}$", RegexOptions.None))
                                {
                                    byte[] bytes = Convert.FromBase64String(img.Attributes["src"].Value.Substring(img.Attributes["src"].Value.LastIndexOf("base64,") + 7));
                                    bool existsFolder = System.IO.Directory.Exists(strPath + pathFolderDes);
                                    if (!existsFolder)
                                    {
                                        System.IO.Directory.CreateDirectory(strPath);
                                    }

                                    var index1 = img.Attributes["src"].Value.LastIndexOf("data:image/") + 11;
                                    var index2 = img.Attributes["src"].Value.IndexOf("base64,");
                                    var typeFileHL = "." + img.Attributes["src"].Value.Substring(index1, index2 - index1 - 1);
                                    var pathShow = "/" + helper.GenKey() + typeFileHL;



                                    using (var imageFile = new FileStream(strPath + pathShow, FileMode.Create))
                                    {
                                        imageFile.Write(bytes, 0, bytes.Length);
                                        imageFile.Flush();
                                    }

                                    tinTuc.Details = tinTuc.Details.Replace(img.Attributes["src"].Value, domainurl + "/Portals/News" + pathShow);
                                }
                            }
                        }
                        // This illustrates how to get thefile names.
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
                            newFileName = Path.Combine(root + "/News", fileName);
                            fileInfo = new FileInfo(newFileName);
                            if (fileInfo.Exists)
                            {
                                fileName = fileInfo.Name.Replace(fileInfo.Extension, "");
                                fileName = fileName + (new Random().Next(0, 10000)) + fileInfo.Extension;

                                newFileName = Path.Combine(root + "/News", fileName);
                            }
                            tinTuc.Image = "/Portals/News/" + fileName;
                            ffileData = fileData;
                        }
                        var user = db.UserPs.AsNoTracking().Where(s => s.UserName == uid).FirstOrDefault<UserP>();
                        if (user != null )
                        {
                            tinTuc.UserId = user.UserId;
                        }
                        tinTuc.CreateDate = DateTime.Now;
                        tinTuc.CreateBy = uid;
                        tinTuc.CreateIP = ip;
                        
                        db.News.Add(tinTuc);
                        db.SaveChanges();
                        //Add ảnh
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
        public async Task<HttpResponseMessage> UpdateNews()
        {
            var identity = User.Identity as ClaimsIdentity;
            string fdtintuc = "";
            IEnumerable<Claim> claims = identity.Claims;
            string ip = getipaddress();
            string name = claims.Where(p => p.Type == "fname").FirstOrDefault()?.Value;
            string tid = claims.Where(p => p.Type == "tid").FirstOrDefault()?.Value;
            string uid = claims.Where(p => p.Type == "uid").FirstOrDefault()?.Value;
            bool ad = claims.Where(p => p.Type == "ad").FirstOrDefault()?.Value == "True";
            string domainurl = HttpContext.Current.Request.Url.Scheme + "://" + HttpContext.Current.Request.Url.Host + ":" + HttpContext.Current.Request.Url.Port + "/";
            List<string> delfiles = new List<string>();
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
                    string strPath = root + "/News";
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
                        fdtintuc = provider.FormData.GetValues("tintuc").SingleOrDefault();
                        News tinTuc = JsonConvert.DeserializeObject<News>(fdtintuc);
                        HtmlAgilityPack.HtmlDocument doc = new HtmlAgilityPack.HtmlDocument();
                        doc.LoadHtml(tinTuc.Details);
                        var imgs = doc.DocumentNode.SelectNodes("//img");
                        if (imgs != null)
                        {
                            foreach (var img in imgs)
                            {
                                var pathFolderDes = "/Portals/News";
                                var checkBase64 = img.Attributes["src"].Value.Substring(img.Attributes["src"].Value.LastIndexOf("base64,") + 7);
                                checkBase64 = checkBase64.Trim();
                                if ((checkBase64.Length % 4 == 0) && Regex.IsMatch(checkBase64, @"^[a-zA-Z0-9\+/]*={0,3}$", RegexOptions.None))
                                {
                                    byte[] bytes = Convert.FromBase64String(img.Attributes["src"].Value.Substring(img.Attributes["src"].Value.LastIndexOf("base64,") + 7));
                                    bool existsFolder = System.IO.Directory.Exists(strPath + pathFolderDes);
                                    if (!existsFolder)
                                    {
                                        System.IO.Directory.CreateDirectory(strPath);
                                    }
                                    var index1 = img.Attributes["src"].Value.LastIndexOf("data:image/") + 11;
                                    var index2 = img.Attributes["src"].Value.IndexOf("base64,");
                                    var typeFileHL = "." + img.Attributes["src"].Value.Substring(index1, index2 - index1 - 1);
                                    var pathShow = "/" + helper.GenKey() + typeFileHL;
                                    using (var imageFile = new FileStream(strPath + pathShow, FileMode.Create))
                                    {
                                        imageFile.Write(bytes, 0, bytes.Length);
                                        imageFile.Flush();
                                    }
                                    tinTuc.Details = tinTuc.Details.Replace(img.Attributes["src"].Value, domainurl + "/Portals/News" + pathShow);
                                }
                            }
                        }
                        
                        var newsOld = db.News.AsNoTracking().Where(s => s.News_ID == tinTuc.News_ID).FirstOrDefault<News>();
                    if (newsOld != null)
                        {
                            tinTuc.UserId = newsOld.UserId;
                        }
                        doc.LoadHtml(newsOld.Details);
                        imgs = doc.DocumentNode.SelectNodes("//img");
                        if (imgs != null)
                        {
                            foreach (var img in imgs)
                            {
                                var imgdel = img.Attributes["src"].Value;
                                imgdel = root + imgdel.Substring(imgdel.IndexOf("Portals/News") + 7);
                                if (!tinTuc.Details.Contains(img.Attributes["src"].Value))
                                {
                                    delfiles.Add(imgdel);
                                }

                            }
                        }
                        if (newsOld.Image != null && newsOld.Image != "" && newsOld.Image != tinTuc.Image)
                        {
                            string fileOld = newsOld.Image.Substring(8);
                            delfiles.Add(root + fileOld);
                        }

                        // This illustrates how to get thefile names.
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
                            newFileName = Path.Combine(root + "/News", fileName);
                            fileInfo = new FileInfo(newFileName);
                            if (fileInfo.Exists)
                            {
                                fileName = fileInfo.Name.Replace(fileInfo.Extension, "");
                                fileName = fileName + (new Random().Next(0, 10000)) + fileInfo.Extension;

                                newFileName = Path.Combine(root + "/News", fileName);
                            }

                            tinTuc.Image = "/Portals/News/" + fileName;
                            ffileData = fileData;
                        }

                        if (tinTuc.Trangthai != 0)
                        {
                            tinTuc.Nguoiduyet = uid;
                            tinTuc.Ngayduyet = DateTime.Now;
                            tinTuc.IPduyet = ip;
                        }

                        tinTuc.Ngaycapnhat = DateTime.Now;
                        tinTuc.Nguoicapnhat = uid;
                       
                        tinTuc.IPcapnhat = ip;
                        db.Entry(tinTuc).State = EntityState.Modified;
                        db.SaveChanges();
                        //Add ảnh
                        if (delfiles.Count > 0)
                        {
                            foreach (string fpath in delfiles)
                            {
                                if (File.Exists(fpath))
                                    File.Delete(fpath);
                            }
                        }
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



        [HttpDelete]
        public async Task<HttpResponseMessage> DeleteNews([FromBody] List<int> id)
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
                        var das = await db.News.Where(a => id.Contains(a.News_ID)).ToListAsync();
                        List<string> paths = new List<string>();
                        if (das != null)
                        {
                            List<News> del = new List<News>();
                            foreach (var da in das)
                            {
                                if (da.Nguoicapnhat == uid || ad)
                                {
                                    del.Add(da);
                                    if (!string.IsNullOrWhiteSpace(da.Image))
                                        paths.Add(HttpContext.Current.Server.MapPath("~/") + da.Image);
                                }
                              
                            }
                            if (del.Count == 0)
                            {
                                return Request.CreateResponse(HttpStatusCode.OK, new { err = "1", ms = "Bạn không có quyền xóa dữ liệu." });
                            }
                            db.News.RemoveRange(del);
                        }
                        await db.SaveChangesAsync();
                        foreach (string strPath in paths)
                        {
                            bool exists = File.Exists(strPath);
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

       

        [HttpPut]
        public async Task<HttpResponseMessage> Update_Trangthai(Trangthai trangthai)
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
                        var das = db.News.Where(a => (a.News_ID == trangthai.IntID)).FirstOrDefault<News>();
                        if (das != null)
                        {

                            das.Trangthai = trangthai.IntTrangthai;

                            if (das.Trangthai != 0)
                            {
                                das.Ngayduyet = DateTime.Now;
                                das.Nguoiduyet = uid;
                                das.IPduyet = ip;
                            }
                            else
                            {
                                das.Ngayduyet = null;
                                das.Nguoiduyet = null;
                                das.IPduyet = null;
                            }
                           
                            await db.SaveChangesAsync();
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
    }

}