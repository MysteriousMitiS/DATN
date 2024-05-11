﻿using System;
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
using System.Threading.Tasks;
using System.Web;
using System.Web.Http;
using System.Web.Http.Description;
using API.Models;
using Helper;
using Newtonsoft.Json;

namespace API.Controllers
{
    public class WorkChecksController : ApiController
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

        //POST

        [HttpPost]
        public async Task<HttpResponseMessage> AddWorkCheck(List<WorkCheck> workcheck)
        {
            var identity = User.Identity as ClaimsIdentity;
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


                    List<int> arr2 = new List<int>();
                    arr2.Add(workcheck[0].WorkId);
                    var das = await db.WorkChecks.Where(a => arr2.Contains(a.WorkId)).ToListAsync();

                    if (das != null)
                    {
                        List<WorkCheck> del = new List<WorkCheck>();
                        foreach (var da in das)
                        {
                            del.Add(da);
                        }
                        if (del.Count != 0)
                        {
                            db.WorkChecks.RemoveRange(del);
                        }
                    }
                    foreach (var item in workcheck)
                    {
                        item.CreatedDate = DateTime.Now;
                        item.CreatedBy = uid;
                    }

                    db.WorkChecks.AddRange(workcheck);
                    await db.SaveChangesAsync();

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
        [HttpPut]
        public async Task<HttpResponseMessage> UpdateWorkCheck(WorkCheck workcheck)
        {
            var identity = User.Identity as ClaimsIdentity;

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

                    List<int> arr2 = new List<int>();

                    arr2.Add(workcheck.WorkId);
                    var wcheck = db.WorkChecks.Where(a => a.WorkId == workcheck.WorkId & a.UserId == workcheck.UserId).FirstOrDefault();
                    wcheck.CreatedBy = uid;
                    wcheck.CheckResult = workcheck.CheckResult;
                    wcheck.CreatedDate = DateTime.Now;
                    db.Entry(wcheck).State = EntityState.Modified;
                    if (workcheck.CheckResult == 2)
                    {
                        var das = await db.WorkChecks.Where(a => arr2.Contains(a.WorkId)).ToListAsync();
                        int check = 0;
                        foreach (var da in das)
                        {
                            if (da.CheckResult == 2)
                            {
                                check++;
                            }
                        }
                        if (check == das.Count)
                        {
                            var work = await db.Works.Where(a => arr2.Contains(a.WorkId)).ToListAsync();
                            var workChange = work[0];
                            workChange.WorkStatus = 5;
                            workChange.WorkCompleted = DateTime.Now;
                            db.Entry(workChange).State = EntityState.Modified;
                        }
                    }
                    else
                    {
                        var workChange = db.Works.Where(a => a.WorkId == workcheck.WorkId).FirstOrDefault();
                        if (workcheck.CheckResult == 0)
                        {
                            workChange.WorkStatus = 4;
                        }
                        if (workcheck.CheckResult == 1)
                        {
                            workChange.WorkStatus = 3;
                        }
                        db.Entry(workChange).State = EntityState.Modified;
                    }

                    await db.SaveChangesAsync();

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



        [HttpDelete]
        public async Task<HttpResponseMessage> DeleteWorkUser([FromBody] List<int> id)
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
                        var das = await db.WorkChecks.Where(a => id.Contains(a.WorkCheckId)).ToListAsync();
                        List<string> paths = new List<string>();
                        if (das != null)
                        {
                            List<WorkCheck> del = new List<WorkCheck>();
                            foreach (var da in das)
                            {
                                if (da.CreatedBy == uid || ad)
                                {
                                    del.Add(da);
                                }

                            }
                            if (del.Count == 0)
                            {
                                return Request.CreateResponse(HttpStatusCode.OK, new { err = "1", ms = "Bạn không có quyền xóa dữ liệu." });
                            }
                            db.WorkChecks.RemoveRange(del);
                        }
                        await db.SaveChangesAsync();


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