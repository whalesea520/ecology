<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.systeminfo.template.UserTemplate"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<%@ page import="weaver.login.*,weaver.general.*,weaver.messager.jingxin.*" %>
<%@ page import="java.net.*,weaver.file.Prop" %>
<%@ page import="weaver.general.Util,weaver.hrm.*,java.util.*,weaver.hrm.settings.*,HT.*,sun.misc.*"%>
<jsp:useBean id="rsExtend" class="weaver.conn.RecordSet" scope="page" />
<%!
private String getForwardUrl(String loginId, String url) throws Exception {
	String forwardUrl = Prop.getPropValue("messageforward", "forwardurl");
	if (forwardUrl != null && !forwardUrl.isEmpty()) {
		forwardUrl = forwardUrl.replace("[loginid]", URLEncoder.encode(loginId, "UTF-8"));
		forwardUrl = forwardUrl.replace("[url]", URLEncoder.encode(url, "UTF-8"));
	} else {
		forwardUrl = url;
	}
	return forwardUrl;
}
%>
<%
BaseBean bs=new BaseBean();
String agent = request.getHeader("user-agent");
session.setAttribute("browser_isie","false");
String browserName = "";
int browserVersion = 0;
if(agent.indexOf("MSIE")!=-1){
	session.setAttribute("browser_isie","true");
	browserName = "IE";
	StringTokenizer st = new StringTokenizer(agent,";"); 
	try{
		st.nextToken();
		//得到用户的浏览器名 
		String userbrowser = st.nextToken();
		String versinString = userbrowser.substring(userbrowser.indexOf("MSIE")+4,userbrowser.indexOf(".")).trim();
		//System.out.println("~~~~~~~~~~~~"+versinString);
		browserVersion = Integer.parseInt(versinString);
	}catch(Exception e){
		//session.setAttribute("browser_isie","false");
	}
}else if(agent.indexOf("Firefox")!=-1){
	String[] temp = agent.split(" ");
	browserName = "FF";
	for(int i=0;i<temp.length;i++){
		String userbrowser = temp[i];
		if(userbrowser.indexOf("Firefox")!=-1){
			String versinString = userbrowser.substring(userbrowser.indexOf("Firefox/")+8,userbrowser.indexOf(".")).trim();
			//System.out.println("~~~~~~~~~~~~"+versinString);
			browserVersion = Integer.parseInt(versinString);
		}
	}
}else if(agent.indexOf("Chrome")!=-1){
	String[] temp = agent.split(" ");
	browserName = "Chrome";
	for(int i=0;i<temp.length;i++){
		String userbrowser = temp[i];
		if(userbrowser.indexOf("Chrome")!=-1){
			String versinString = userbrowser.substring(userbrowser.indexOf("Chrome/")+7,userbrowser.indexOf(".")).trim();
			//System.out.println("~~~~~~~~~~~~"+versinString);
			browserVersion = Integer.parseInt(versinString);
		}
	}
}else if(agent.indexOf("Safari")!=-1){
	String[] temp = agent.split(" ");
	browserName = "Safari";
	for(int i=0;i<temp.length;i++){
		String userbrowser = temp[i];
		if(userbrowser.indexOf("Version")!=-1){
			String versinString = userbrowser.substring(userbrowser.indexOf("Version/")+8,userbrowser.indexOf(".")).trim();
			//System.out.println("~~~~~~~~~~~~"+versinString);
			browserVersion = Integer.parseInt(versinString);
		}
	}
}
String isIE = (String)session.getAttribute("browser_isie");
if(!"true".equals(isIE)){
	if (agent != null && agent.indexOf("rv:11") != -1) {
	    isIE = "true";
	    browserVersion = 11;
	    browserName = "IE";
	    session.setAttribute("browser_isie", "true");
	}
}
boolean IsUseIE6=Prop.getPropValue("sdlsyh","IsUseIE6").equalsIgnoreCase("1");
if(IsUseIE6){
	if((browserName == "IE"&&browserVersion<6)||(browserName == "FF"&&browserVersion<9)||(browserName == "Chrome"&&browserVersion<14)||(browserName == "Safari"&&browserVersion<5)){
	    response.sendRedirect("/wui/common/page/sysRemind.jsp?labelid=1&browserName="+browserName+"&browserVersion="+browserVersion);
		return;
 	}
}else{
	if((browserName == "IE"&&browserVersion<7)||(browserName == "FF"&&browserVersion<9)||(browserName == "Chrome"&&browserVersion<14)||(browserName == "Safari"&&browserVersion<5)){
		 response.sendRedirect("/wui/common/page/sysRemind.jsp?labelid=1&browserName="+browserName+"&browserVersion="+browserVersion);
		 return;
	 }
}
String d = request.getParameter("d");
String url = request.getParameter("url");
String sessionId = request.getParameter("sid");
String serial1 = request.getParameter("serial");
String rnd = request.getParameter("rnd");
String clientkey = request.getParameter("clientkey");
String clientserial = request.getParameter("clientserial");

try {
	StringBuffer sb=new StringBuffer();
		
		for(int i=0;i<url.length();i++){
			char text=url.charAt(i);
			
			if(text==':'||text=='/'||text=='?'||text=='='|| text == '&'){
				sb.append(text);
			}else{
				sb.append(URLEncoder.encode(""+text,"gbk"));
			}
		}
	url= sb.toString();
} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			bs.writeLog(e);
}


if(d!=null){
	response.sendRedirect("/messager/installm3/emessageinfo.jsp");
	return;
}
//if(sessionId!=null){
//	response.sendRedirect("/messager/installm3/emessageinfo.jsp");
//	return;
//}
if(url!=null&&"/login/bindTokenKey.jsp".equals(url)){
	response.sendRedirect(url);
}

if(clientkey!=null){
	int userid = -1;
	String sql = "select id from   HrmResource  where lower(loginid) in (select loginid  from ofClientKey where clientKey ='"+ clientkey+"')";
	rs.executeSql(sql);
	while(rs.next()){
		userid = rs.getInt("id");
	}
	if(userid!=-1){
		UserManager um = new UserManager();
		User user = um.getUserByUserIdAndLoginType(userid,"1");
		BASE64Decoder base = new BASE64Decoder();
		if(clientserial!=null){
			byte [] b = base.decodeBuffer(clientserial);
			user.setPwd(new String(b));
			session.getAttribute("password");
			session.setAttribute("password",new String(b));
		}
		if(user!=null){
			int languageId = Util.getIntValue(Util.null2String(request.getParameter("languageid")), 7);
			if (languageId == 8) {
				user.setLanguage(8);
			} else {
				user.setLanguage(7);
			}
			RemindSettings settings=(RemindSettings)application.getAttribute("hrmsettings");
			String sysNeedusb=Util.null2String(settings.getNeedusb());
			String needusbHt = Util.null2String(settings.getNeedusbHt());
			String needusbDt = Util.null2String(settings.getNeedusbDt());
			sysNeedusb = ("1".equals(needusbHt) || "1".equals(needusbDt)) ? "1" : "0";
			if(sysNeedusb.equals("1")&&browserName.equals("IE")){
				rs.executeSql("select * from HrmResource where id = "+userid);
				while(rs.next()){
			    	HrmSettingsComInfo sci=new HrmSettingsComInfo();
					/**检测是否启用usb网段策略开始**/
					CheckIpNetWork checkipnetwork = new CheckIpNetWork();
					String clientIP = request.getRemoteAddr();
					boolean IsUseIP=Prop.getPropValue("bjjxauth","IsUseIP").equalsIgnoreCase("1");
					boolean checktmp = false;
					if(IsUseIP){
						ICheckIpNetWork checkipnetwork1 = (ICheckIpNetWork)Class.forName("weaver.login.CheckIpNetWork").newInstance();
						String checkstr = checkipnetwork1.checkIpSeg1(request,user.getLoginid(),1);//true表示在网段之外,false表示在网段之内
						if(checkstr.equals("0")){
							checktmp = false;
						}else if(checkstr.equals("1")){
							checktmp = true;
						}else{
							response.sendRedirect("/login/Login.jsp?logintype=1&message="+167);
							return;
						}
						
					}else{
						checktmp = checkipnetwork.checkIpSeg(clientIP);//true表示在网段之外,false表示在网段之内
					}
					/**检测是否启用usb网段策略结束**/
			
			        int needusb = rs.getInt("needusb");
			        String usbstate = rs.getString("usbstate");
			        String usbType = sci.getUsbType();
			        String userUsbType=Util.null2String(rs.getString("userUsbType")); //指定usbkey验证类型
			        if("".equals(userUsbType)){
			        	userUsbType = usbType;
			        }
			        if (needusb == 1 && ("0".equals(usbstate) || "2".equals(usbstate))) {
			        	if(checktmp) {
			        		if("2".equals(userUsbType)){
			        			if(serial1==null){
			        				session.setAttribute("weaver_user", user);
			        				session.setAttribute("clientkey", clientkey);
			        				session.setAttribute("clientserial", clientserial);
			        				session.setAttribute("url", url);
			        				//RequestDispatcher rd = request.getRequestDispatcher("eimforwardlogin.jsp");
			        				//rd.forward(request,response);
			        				response.sendRedirect(getForwardUrl(user.getLoginid(), "eimforwardlogin.jsp"));
			        				return;
			        			}else{
			        				String serialNo = rs.getString("serial");
			        				user.setSerial(serialNo);
			        				user.setNeedusb(needusb);
			        				HTSrvAPI htsrv = new HTSrvAPI();
			                		String sharv = "";
			                		sharv = htsrv.HTSrvSHA1(rnd, rnd.length());
			                		sharv = sharv + "04040404";
			                		String ServerEncData = htsrv.HTSrvCrypt(0, serialNo, 0, sharv);
			                		String code = "";
			                		if(serial1.equals("0")){
			                			code =  "45";
			                		}else if(!ServerEncData.equals(serial1)){
			                			code =  "16";
			                		}
					                if (!code.equals("")) {
					                	 response.sendRedirect("/login/Login.jsp?logintype=1&message="+code);
					                	 return;
					                }
			        			
			        			}
			        		}
			        	}
			        }
				}
			}
			session.setAttribute("weaver_user@bean", user);
			ArrayList onlineuserids = (ArrayList)StaticObj.getInstance().getObject("onlineuserids") ;
			if (onlineuserids != null&&onlineuserids.indexOf("" + user.getUID()) == -1){
				onlineuserids.add(user.getUID()+"");
			}
			boolean MOREACCOUNTLANDING = GCONST.getMOREACCOUNTLANDING();
			
		    if(MOREACCOUNTLANDING){
		        //多帐号登陆
		        if (userid != 1) {
		            List accounts = new VerifyLogin().getAccountsById(userid);
		            request.getSession(true).setAttribute("accounts", accounts);
		        }
		        	Util.setCookie(response, "loginfileweaver", "/login/Login.jsp?logintype=1", 172800);
		        	Util.setCookie(response, "loginidweaver", user.getLoginid(), 172800);
		        }
		
			if(url.indexOf("/main.jsp")!=-1){
				String tourl = "";
				//url="/main.jsp";
				UserTemplate  ut=new UserTemplate();
				
				ut.getTemplateByUID(user.getUID(),user.getUserSubCompany1());
				int templateId=ut.getTemplateId();
				int extendTempletid=ut.getExtendtempletid();
				int extendtempletvalueid=ut.getExtendtempletvalueid();
				String defaultHp = ut.getDefaultHp();
				session.setAttribute("defaultHp",defaultHp);
				
				if(extendTempletid!=0){
					rsExtend.executeSql("select id,extendname,extendurl from extendHomepage  where id="+extendTempletid);
					if(rsExtend.next()){
						int id=Util.getIntValue(rsExtend.getString("id"));
						//String extendname=Util.null2String(rsExtend.getString("extendname"));	
						String extendurl=Util.null2String(rsExtend.getString("extendurl"));	
						rs.executeSql("select * from extendHpWebCustom where templateid="+templateId);
						String defaultshow ="";
						if(rs.next()){
							defaultshow = Util.null2String(rs.getString("defaultshow"));
						}
						String param = "";
						if(!defaultshow.equals("")){
							param ="&"+defaultshow.substring(defaultshow.indexOf("?")+1);
						}
						
								
						tourl = "/login/RemindLogin.jsp?RedirectFile="+extendurl+"/index.jsp?templateId="+templateId+param;
						
						//tourl = extendurl+"/index.jsp?templateId="+templateId+param;
						//response.sendRedirect(tourl) ;
						//return;		
					}
				} else {
					

					//tourl = RedirectFile;
					tourl = "/login/RemindLogin.jsp?RedirectFile="+url;
					
					//return;
				}
				response.sendRedirect(getForwardUrl(user.getLoginid(), tourl)) ;
				
			}else{
				bs.writeLog("@@@url:"+url);
				response.sendRedirect(getForwardUrl(user.getLoginid(), url));	
			}
			return;
		}else{
			response.sendRedirect("/login/Login.jsp?logintype=1");
		}
	}else{
		response.sendRedirect("/login/Login.jsp?logintype=1");
	}
	return;
}


weaver.messager.SessionContext myc= weaver.messager.SessionContext.getInstance();
HttpSession sess = myc.getSession(sessionId);
if(sess!=null){

	User user = (User)sess.getAttribute("weaver_user@bean") ;
	if(user!=null){
		int userid = user.getUID();
		RemindSettings settings=(RemindSettings)application.getAttribute("hrmsettings");
		String sysNeedusb=Util.null2String(settings.getNeedusb());
		if(sysNeedusb.equals("1")&&browserName.equals("IE")){
			rs.executeSql("select * from HrmResource where id = "+userid);
			while(rs.next()){
		    	HrmSettingsComInfo sci=new HrmSettingsComInfo();
				/**检测是否启用usb网段策略开始**/
				CheckIpNetWork checkipnetwork = new CheckIpNetWork();
				String clientIP = request.getRemoteAddr();
				boolean checktmp = checkipnetwork.checkIpSeg(clientIP);//true表示在网段之外,false表示在网段之内
				/**检测是否启用usb网段策略结束**/
		
		        int needusb = rs.getInt("needusb");
		        String usbstate = rs.getString("usbstate");
		        String usbType = sci.getUsbType();
		        String userUsbType=Util.null2String(rs.getString("userUsbType")); //指定usbkey验证类型
		        if("".equals(userUsbType)){
		        	userUsbType = usbType;
		        }
		        if (needusb == 1 && ("0".equals(usbstate) || "2".equals(usbstate))) {
		        	if(checktmp) {
		        		if("2".equals(userUsbType)){
		        			if(serial1==null){
		        				%>
		        				<html>
		        				<head>
		        				<script language="JavaScript">
						                //验证海泰key
						                function checkusb2(){
							                try{
							                   var form1= document.getElementById("form1");
							                   var rndtext = document.getElementById("rnd");
							                   var serial = document.getElementById("serial");
							                    rnd = Math.round(Math.random()*1000000000);
							                    var returnstr = getUserPIN();
							                    if(returnstr != undefined && returnstr != ""){
							                        //form1.username.value= returnstr;
							                        var randomKey = getRandomKey(rnd);
							                        //alert(randomKey);
							                        rndtext.value=rnd;
							                        serial.value=randomKey;
							                    }else{
							                        rndtext.value=0;
							                        serial.value=0;
							                    }
							                }catch(err){
							                   rndtext.value=0;
							                   serial.value=0
							                }
							                form1.submit();
							            }
						        </script>
						        <OBJECT id="htactx" name="htactx" 
								classid=clsid:FB4EE423-43A4-4AA9-BDE9-4335A6D3C74E codebase="HTActX.cab#version=1,0,0,1" style="HEIGHT: 0px; WIDTH: 0px"></OBJECT>
								<form name="form1" id="form1" action="/messager/eimforward.jsp"  method="post">
									<INPUT type=hidden name="rnd" id="rndtext">
						            <INPUT type=hidden name="serial" id="serial">
						            <INPUT type=hidden name="sid" value="<%=sessionId%>">
						            <INPUT type=hidden name="url" value="<%=url%>">
								</form>
<script language="javascript">
function getUserPIN(){
	  try{
	  	var vbsserial="";
	  	var hCard = htactx.OpenDevice(1);//打开设备
	  	if(hCard==0){
	  		alert("请确认您已经正确地安装了驱动程序并插入了usb令牌")
	  		return vbsserial;
	  	}
	  	
	  	try{
		  	vbsserial = htactx.GetUserName(hCard)//获取用户名
		  	htactx.CloseDevice(hCard)
		  	return vbsserial;
		  }catch(e){
		  	alert("请确认您已经正确地安装了驱动程序并插入了usb令牌2");
		  	htactx.CloseDevice(hCard);
		  	return vbsserial;
		  }
	  }catch(e){
	  	alert("请确认您已经正确地安装了驱动程序并插入了usb令牌");
	  	htactx.CloseDevice(hCard);
	  	return vbsserial;
	  }
	}
	
	function getRandomKey(randnum){
		try{
			var hCard = htactx.OpenDevice(1);//打开设备
			if(hCard == 0 ){
				alert("请确认您已经正确地安装了驱动程序并插入了usb令牌4");
				return "";
			}
			try{
				var Digest = htactx.HTSHA1(randnum, (""+randnum).length);
				Digest = Digest+"04040404" //对SHA1数据进行补码
				htactx.VerifyUserPin(hCard, "<%=user.getPwd()%>") //校验口令
		   	var EnData = htactx.HTCrypt(hCard, 0, 0, Digest, Digest.length)//DES3加密SHA1后的数据
		   	htactx.CloseDevice(hCard);
		   	return EnData;
		  }catch(e){
		  	alert("请确认您已经正确地安装了驱动程序并插入了usb令牌5");
		  	htactx.CloseDevice(hCard);
		  	return "";
		  }
		}catch(e){
			alert("请确认您已经正确地安装了驱动程序并插入了usb令牌4");
			return "";
		}
	}
	</script>
							        </head>
							        <body onload="javascript:checkusb2();">
							        </body>
							        </html>
		        				<%
		        				return;
		        			}else{
		        				String serialNo = rs.getString("serial");
		        				user.setSerial(serialNo);
		        				user.setNeedusb(needusb);
		        				HTSrvAPI htsrv = new HTSrvAPI();
		                		String sharv = "";
		                		sharv = htsrv.HTSrvSHA1(rnd, rnd.length());
		                		sharv = sharv + "04040404";
		                		String ServerEncData = htsrv.HTSrvCrypt(0, serialNo, 0, sharv);
		                		String code = "";
		                		if(serial1.equals("0")){
		                			code =  "45";
		                		}else if(!ServerEncData.equals(serial1)){
		                			code =  "16";
		                		}
				                if (!code.equals("")) {
				                	 response.sendRedirect("/login/Login.jsp?logintype=1&message="+code);
				                	 return;
				                }
		        			
		        			}
		        		}
		        	}
		        }
			}
		}
		session.setAttribute("weaver_user@bean", user);
		boolean MOREACCOUNTLANDING = GCONST.getMOREACCOUNTLANDING();
		
	    if(MOREACCOUNTLANDING){
	        //多帐号登陆
	        if (userid != 1) {
	            List accounts = new VerifyLogin().getAccountsById(userid);
	            request.getSession(true).setAttribute("accounts", accounts);
	        }
	        	Util.setCookie(response, "loginfileweaver", "/login/Login.jsp?logintype=1", 172800);
	        	Util.setCookie(response, "loginidweaver", user.getLoginid(), 172800);
	        }
	
		if(url.indexOf("/main.jsp")!=-1){
			String tourl = "";
			url="/main.jsp";
			UserTemplate  ut=new UserTemplate();
			
			ut.getTemplateByUID(user.getUID(),user.getUserSubCompany1());
			int templateId=ut.getTemplateId();
			int extendTempletid=ut.getExtendtempletid();
			int extendtempletvalueid=ut.getExtendtempletvalueid();
			String defaultHp = ut.getDefaultHp();
			session.setAttribute("defaultHp",defaultHp);
			
			if(extendTempletid!=0){
				rsExtend.executeSql("select id,extendname,extendurl from extendHomepage  where id="+extendTempletid);
				if(rsExtend.next()){
					int id=Util.getIntValue(rsExtend.getString("id"));
					//String extendname=Util.null2String(rsExtend.getString("extendname"));	
					String extendurl=Util.null2String(rsExtend.getString("extendurl"));	
					rs.executeSql("select * from extendHpWebCustom where templateid="+templateId);
					String defaultshow ="";
					if(rs.next()){
						defaultshow = Util.null2String(rs.getString("defaultshow"));
					}
					String param = "";
					if(!defaultshow.equals("")){
						param ="&"+defaultshow.substring(defaultshow.indexOf("?")+1);
					}
					
							
					tourl = "/login/RemindLogin.jsp?RedirectFile="+extendurl+"/index.jsp?templateId="+templateId+param;
					
					//tourl = extendurl+"/index.jsp?templateId="+templateId+param;
					//response.sendRedirect(tourl) ;
					//return;		
				}
			} else {
				//tourl = RedirectFile;
				tourl = "/login/RemindLogin.jsp?RedirectFile="+url;
				
				//return;
			}
			response.sendRedirect(getForwardUrl(user.getLoginid(), tourl)) ;
			
		}else{
			response.sendRedirect(getForwardUrl(user.getLoginid(), url));	
		}
		return;
	}else{
		response.sendRedirect("/login/Login.jsp?logintype=1");
	}
}else{
	response.sendRedirect("/login/Login.jsp?logintype=1");
}
%>