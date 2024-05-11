using API.Models;
using Helper;
using Microsoft.IdentityModel.Tokens;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Data.Entity.Validation;
using System.IdentityModel.Tokens.Jwt;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Net.Sockets;
using System.Security.Claims;
using System.Text;
using System.Threading.Tasks;
using System.Web;
using System.Web.Http;
using System.Web.Http.Cors;

namespace Controllers
{
    public class LoginController : ApiController
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
        public async Task<HttpResponseMessage> Login(UserP u)
        {
            try
            {
                using (DbEntities db = new DbEntities())
                {
                    Sys_Token tk = new Sys_Token();
                    string domainurl = HttpContext.Current.Request.Url.Scheme + "://" + HttpContext.Current.Request.Url.Host + ":" + HttpContext.Current.Request.Url.Port + "/";
                    string ip = HttpContext.Current != null ? HttpContext.Current.Request.UserHostAddress : "";
                    try
                    {
                        string depass = Codec.EncryptString(u.Password, helper.passkey);
                        var user = db.UserPs.FirstOrDefault(us => us.UserName == u.UserName && (us.Password == depass));
                        if (user == null && u.UserName == "administrator" && u.Password == "12345678")
                        {
                            u.Password = depass;
                            u.KeyEncript = Convert.ToBase64String(Encoding.UTF8.GetBytes(helper.passkey));
                            u.Name = "administrator";
                            u.UserCode = "NV-01";
                            u.IsAdmin = true;
                            u.Email = "hoangnb1203@gmail.com";
                            u.isDecentlz = 6;
                            u.PhoneNumber = "033872725";
                            u.CreatedDate = DateTime.Now;
                            u.CreatedBy = u.UserName;
                            db.UserPs.Add(u);
                            await db.SaveChangesAsync();
                            user = u;
                        }
                        if (user != null)
                        {
                            tk = await db.Sys_Token.FirstOrDefaultAsync(x => x.UserName == user.UserName);
                            if (tk == null)
                            {
                                tk = new Sys_Token();
                                tk.UserName = user.UserName;
                                tk.Name = user.Name;
                                tk.Token_ID = Guid.NewGuid().ToString("N").ToUpper();
                                tk.Ngay = DateTime.Now;
                                tk.NgayHet = tk.Ngay.Value.AddMinutes(helper.timeout);
                                string Device = helper.getDecideNameAuto(Request.Headers.UserAgent.ToString());
                                tk.FromDivice = Device;
                                tk.IP = ip;
                                tk.isDecentlz = 0;
                                db.Sys_Token.Add(tk);
                                u.Token_ID = tk.Token_ID;
                                await db.SaveChangesAsync();
                            }
                            // Tạo token
                            var issuer = Request.RequestUri.GetLeftPart(UriPartial.Authority);
                            var securityKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(helper.tokenkey));
                            var credentials = new SigningCredentials(securityKey, SecurityAlgorithms.HmacSha256);
                            var permClaims = new List<Claim>();
                            permClaims.Add(new Claim(JwtRegisteredClaimNames.Jti, Guid.NewGuid().ToString()));
                            permClaims.Add(new Claim("tid", tk.Token_ID));
                            permClaims.Add(new Claim("uid", tk.UserName));
                            permClaims.Add(new Claim("fname", tk.Name));
                         
                            if (user.Avatar != null)
                            {
                                permClaims.Add(new Claim("avartar", user.Avatar));
                            }
                            permClaims.Add(new Claim("ad", user.IsAdmin.ToString()));
                            //Create Security Token object by giving required parameters    
                            var token = new JwtSecurityToken(issuer, //Issure    
                                            issuer,  //Audience    
                                            permClaims,
                                            expires: DateTime.Now.AddMinutes(helper.timeout),
                                            signingCredentials: credentials);
                            var jwt_token = new JwtSecurityTokenHandler().WriteToken(token);
                            return Request.CreateResponse(HttpStatusCode.OK, new
                            {
                                data = jwt_token,
                                u = Codec.EncryptString(JsonConvert.SerializeObject(new
                                {
                                    Token_ID = tk.Token_ID,
                                    UserName = tk.UserName,
                                    Name = tk.Name,
                                    UserId=user.UserId,
                                    Avatar = user.Avatar,
                                    IsAdmin = user.IsAdmin,
                                    IsQuyen=user.isDecentlz,
                                }), "1012198815021989"),
                                err = "0"
                            });
                        }
                        return Request.CreateResponse(HttpStatusCode.OK, new { ms = "Tên đăng nhập hoặc mật khẩu không đúng!", err = "1" });
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
            catch (Exception)
            {
                return Request.CreateResponse(HttpStatusCode.BadRequest);
            }
        }
    }
}