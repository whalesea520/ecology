
<%@ page import="weaver.general.Util,
                 java.util.Map,
                 java.util.HashMap,weaver.general.StaticObj,weaver.general.WHashMap,
                 weaver.hrm.settings.RemindSettings,
                 weaver.general.GCONST" %>
<%@ page import="weaver.hrm.User,java.util.List,java.util.ArrayList"%>
<%@ page import="weaver.hrm.HrmUserVarify"%>
<%@ page import="weaver.hrm.OnLineMonitor"%>
<%@ page import="weaver.systeminfo.template.UserTemplate"%>
<%@page import="weaver.rdeploy.portal.PortalUtil"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%@page import="weaver.login.CALoginCheck"%>
<jsp:useBean id="rsExtend" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DocCheckInOutUtil" class="weaver.docs.docs.DocCheckInOutUtil" scope="page"/>
	
<jsp:useBean id="dactylogramCompare" class="weaver.login.dactylogramCompare" scope="page" /> 
<jsp:useBean id="VerifyLogin" class="weaver.login.VerifyLogin" scope="page" /> 
<jsp:useBean id="VerifyPasswdCheck" class="weaver.login.VerifyPasswdCheck" scope="page" />

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<html>
	<head>
		<script type="text/javascript" src="/js/ecology8/lang/weaver_lang_7_wev8.js"></script>
		<script language="javascript" type="text/javascript" src="/appres/hrm/js/mfcommon_wev8.js"></script>
		<SCRIPT language="javascript" type="text/javascript" src="/wui/common/jquery/jquery.min_wev8.js"></SCRIPT>
		<script type="text/javascript" src="/wui/common/jquery/plugin/jquery.cycle.all_wev8.js"></script>
		<script type="text/javascript" src="/js/jquery/plugins/client/jquery.client_wev8.js"></script>
		<script type="text/javascript" src="/wui/common/jquery/plugin/qrcode/jquery.qrcode_wev8.js"></script>
		<script type="text/javascript" src="/wui/common/jquery/plugin/qrcode/qrcode_wev8.js"></script>
		<script language=javascript src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
		<script type="text/javascript" src="/wui/common/jquery/plugin/jquery.overlabel_wev8.js"></script>
		<link href="/css/commom_wev8.css" type="text/css" rel="stylesheet">
	</head>
	<body>
<%
String requestMethod = Util.null2String(request.getMethod());
if(requestMethod.equalsIgnoreCase("GET")){
%>
<script language="javascript">
	alert("非法登录方式");
	window.close();
</script>
<%
	return;
}
String loginfile = Util.null2String(request.getParameter("loginfile")) ;
String logintype = Util.null2String(request.getParameter("logintype")) ;
String loginid = Util.null2String(request.getParameter("loginid")) ;
String forwardpage = Util.null2String(request.getParameter("forwardpage")) ;
String userpassword = Util.null2String(request.getParameter("userpassword"));
String isrsaopen = Util.null2String(request.getParameter("isrsaopen"));//密码是否为RSA加密
String cert = Util.null2String(request.getParameter("cert"));
String signed = Util.null2String(request.getParameter("signed"));


String message = Util.null2String(request.getParameter("message"));
String isIE = Util.null2String(request.getParameter("isie"));
 String agent = request.getHeader("user-agent");
 if(agent.indexOf("rv:11") == -1 && agent.indexOf("MSIE") == -1){
	isIE = "false";
 }

 if(agent.indexOf("rv:11") > -1 && agent.indexOf("Mozilla") > -1){
		isIE = "true";
	 }


if(!isIE.equals("false")){
	isIE = "true";
}
session.setAttribute("browser_isie",isIE);
//xiaofeng
int  islanguid = 7;//系统使用语言,未使用多语言的用户默认为中文。

String languid= "7";
boolean ismutilangua = false;
StaticObj staticobj = null;
staticobj = StaticObj.getInstance();
String multilanguage = (String)staticobj.getObject("multilanguage") ;
if(multilanguage == null) {
	VerifyLogin.checkLicenseInfo();
	multilanguage = (String)staticobj.getObject("multilanguage") ;
}else if(multilanguage.equals("y")){
	ismutilangua = true;
}
String usbType = "";
boolean isAdmin = false;
boolean isSyadmin=true;
//判断分权管理员

//String Sysmanager = "select loginid,userUsbType from hrmresourcemanager where loginid = '"+loginid+"'";
String Sysmanager = "select loginid,userUsbType from hrmresourcemanager where loginid = ? ";
RecordSet1.executeQuery(Sysmanager,loginid);
if(RecordSet1.next()){
	isSyadmin = false;
	isAdmin = true;
	usbType = Util.null2String(RecordSet1.getString(2));
}
if(loginid.equalsIgnoreCase("sysadmin")){
	isSyadmin = false;
}
if(isSyadmin){
	if(ismutilangua){
			islanguid = Util.getIntValue(request.getParameter("islanguid"),0);
				if(islanguid == 0){//如何未选择，则默认系统使用语言为简体中文

					islanguid = 7;
				}
		languid = String.valueOf(islanguid); 
		Cookie syslanid = new Cookie("Systemlanguid",languid);
		syslanid.setMaxAge(-1);
		syslanid.setPath("/");
		response.addCookie(syslanid);
	}
}/*else{
	Cookie syslanid = new Cookie("Systemlanguid",languid);
	syslanid.setMaxAge(-1);
	syslanid.setPath("/");
	response.addCookie(syslanid);
}*/
String serial=Util.null2String(request.getParameter("serial"));
String username = Util.null2String(request.getParameter("username"));
String rnd=Util.null2String(request.getParameter("rnd"));
String loginPDA=Util.null2String(request.getParameter("loginPDA"));
session.setAttribute("loginPAD",loginPDA);
String RedirectFile="/wui/main.jsp"; 
if(!"".equals(forwardpage))
{
	RedirectFile = forwardpage;
}
if (loginPDA.equals("1"))
{
RedirectFile= "/mainPDA.jsp";
}
//add by sean.yang 2006-02-09 for TD3609
String validatecode=Util.null2String(request.getParameter("validatecode"));

//modify by mackjoe at 2005-11-28 td3282 邮件提醒登陆后直接到指定流程
String gopage=Util.null2String(request.getParameter("gopage"));
gopage=URLEncoder.encode(gopage);

if(!"".equals(gopage) && !gopage.contains("main.jsp")){
	session.setAttribute("gopageOrientation",gopage);
}
if(gopage.trim().equals("")&&session.getAttribute("gopages")!=null)
{
	try{
		gopage = (String)session.getAttribute("gopages");
		session.removeAttribute("gopages");
	}catch(Exception e){}
}
if(gopage.length()>0){
    RedirectFile = "/wui/main.jsp?gopage="+gopage ;
}
if (loginfile.equals("")) loginfile="/login/Login.jsp?logintype="+logintype+"&gopage="+gopage;

//add by wshen 259472
String headerReferer = Util.null2String(request.getHeader("Referer"));
String headerHost = Util.null2String(request.getHeader("Host"));
String basePath = request.getScheme()+"://"+request.getServerName()+"/"; 
if(!"".equals(basePath)){
	String sqlLoginTemplate = "SELECT domainName FROM SystemLoginTemplate where domainName is not null and domainName !=''";	
	rs.executeSql(sqlLoginTemplate);
	while(rs.next()){
		String domainName = Util.null2String(rs.getString("domainName"));
		if(basePath.contains(domainName)||headerReferer.contains(domainName)||domainName.contains(headerHost)){
			loginfile="/login/Login.jsp?logintype="+logintype+"&gopage="+gopage;
		}
	}
}



//end by mackjoe
// modify by dongping for TD1340 in 2004.11.05
// 用户登陆时要对cookies是否开放作判断，如果没有，则会给出提示!
String logincookid = Util.getEncrypt(loginid);
String testcookie = "";
if (!loginPDA.equals("1")){//手机登陆不要阻止cookie
	testcookie = new java.util.Date().getTime()+"+"+logincookid;
%>
<script>
document.cookie='logincookiecheck=<%=testcookie%>';
</script>
<%
}
%>
<script language="javascript">
function showmsg(mess,func) {
		var diag = new window.top.Dialog({
	        Width: 300,
	        Height: 80,
	        normalDialog:false,
	        Modal:true
	    });
		diag.Title = '<%=SystemEnv.getHtmlLabelName(15172, islanguid)%>';
	    diag.CancelEvent = function () {
	        diag.close();
        	if (func) func();
	    };
	    diag.InnerHtml = '<table height="100%" border="0" align="center" cellpadding="10" cellspacing="0">\
			<tr><td align="right"><img id="Icon_" src="' + IMAGESPATH + 'icon_alert_wev8.png" style="margin-right:10px;" width="26" height="26" align="absmiddle"></td>\
				<td align="left" id="Message_" style="font-size:9pt">' + mess + '</td></tr>\
		</table>';
		diag.ShowButtonRow=true;
		diag.normalDialog= false;
		diag.show();
   	 	diag.getDialogDiv().style.zIndex = 99999;
    	jQuery(diag.getContainer()).css("overflow-y","auto");
	    diag.okButton.style.display = "none";
	    diag.e8SepLine.style.display = "none";
	    diag.cancelButton.value = '<%=SystemEnv.getHtmlLabelName(826, islanguid)%>';
	    diag.cancelButton.focus();
}
</script>
<%
String dactylogram = Util.null2String(request.getParameter("dactylogram"));//指纹特征
boolean compareFlag = false;
if(!dactylogram.equals("")){

	//String dactylogramOfCookie = Util.null2String(Util.getCookie(request,"dactylogram"));
	//String assistantDactylogramOfCookie = Util.null2String(Util.getCookie(request,"assistantdactylogram"));
	//if(!dactylogramOfCookie.equals("")) dactylogramCompare.setCookieDactylogram(dactylogramOfCookie);
	//if(!assistantDactylogramOfCookie.equals("")) dactylogramCompare.setCookieAssistantDactylogram(assistantDactylogramOfCookie);
	
	compareFlag = dactylogramCompare.executeCompare(dactylogram);
	if(compareFlag){
		loginid = dactylogramCompare.getLoginId();
		userpassword = dactylogramCompare.getPassword();
		logintype = "1";
	}else{

		response.sendRedirect("/login/Login.jsp?&message=nomatch&languageid="+islanguid) ;
		return;
	}
}

if (logintype.equals("2")){
	/**if(!gopage.equals("")){
 		RedirectFile = "/portal/main.jsp?gopage="+gopage ;
	}else{
		RedirectFile = "/portal/main.jsp" ;
	}**/
	RedirectFile = "/docs/news/NewsDsp.jsp" ;
}

String tourl = "";
if(loginid.equals("") || userpassword.equals("") ) response.sendRedirect(loginfile + "&languageid="+islanguid+"&message=17") ;
else  { 	
	if(!isAdmin){
		//rs.executeSql("select userUsbType from hrmresource where loginid = '"+loginid+"'");
		rs.executeQuery("select userUsbType from hrmresource where loginid = ?",loginid);
		if(rs.next()){
			usbType = Util.null2String(rs.getString("userUsbType"));
		}
	}
	RemindSettings settings=(RemindSettings)application.getAttribute("hrmsettings");
    String needusb=settings.getNeedusb();
	needusb = (settings.getNeedusbHt().equals("1") || settings.getNeedusbDt().equals("1")) ? "1" : "0";
	String usercheck ;
	String notusbusercheck = "";
	
	//# CA认证检查开始 #
	CALoginCheck caLoginCheck = new CALoginCheck() ;
	String caResult = caLoginCheck.check(cert,signed,loginid,isAdmin,request) ;
	System.err.println(">>>>>caResult:"+caResult) ;
	if(!"0".equals(caResult) && !"100".equals(caResult)){
		System.err.println(">>>>>caResult 2:"+caResult) ;
		session.setAttribute("tmploginid1", loginid);
		response.sendRedirect(loginfile + "&languageid="+islanguid+"&message=-21") ;
		return ;
	}
	// # CA认证检查结束 #
	
	if(compareFlag){
		usercheck= VerifyLogin.getUserCheckByDactylogram(request,response,loginid,userpassword,logintype,loginfile,validatecode,message,languid,ismutilangua);
	}else{
		boolean canpass = VerifyPasswdCheck.getUserCheck(loginid,"",1);
		if(!canpass){
			if(usbType.equals("2") || usbType.equals("3")){
				//notusbusercheck= VerifyLogin.getUserCheck(request,response,loginid,userpassword,logintype,loginfile,validatecode,message,languid,ismutilangua);
				request.getSession(true).removeAttribute("weaver_user@bean");
				if(!isIE.equals("true")&&usbType.equals("2")){
					//非IE 且 海泰key 不校验

					usercheck=VerifyLogin.getUserCheck(request,response,loginid,userpassword,logintype,loginfile,validatecode,message,languid,ismutilangua);
					//usercheck=notusbusercheck; //VerifyLogin.getUserCheck(request,response,loginid,userpassword,logintype,loginfile,validatecode,message,languid,ismutilangua);
				}else{
					usercheck= VerifyLogin.getUserCheck(request,response,loginid,userpassword,serial,username,rnd,logintype,loginfile,validatecode,message,languid,ismutilangua);
				}
				notusbusercheck = usercheck;
			}else{
				usercheck= VerifyLogin.getUserCheck(request,response,loginid,userpassword,logintype,loginfile,validatecode,message,languid,ismutilangua);
			}
		}else{
			usercheck = "110";
		}
	}
	VerifyPasswdCheck.getUserCheck(loginid,usercheck,2);
	try {
		session = request.getSession(true);
	   request.getSession(true).removeAttribute("validateRand");
	}catch (Exception e) {

  }	
	if(usercheck.equals("15")|| usercheck.equals("57") || usercheck.equals("17")|| usercheck.equals("45")|| usercheck.equals("46")|| usercheck.equals("47")|| usercheck.equals("55"))
    {
        String tmploginid=(String)session.getAttribute("tmploginid");
        if(tmploginid!=null&&loginid.equals(tmploginid))
           session.setAttribute("tmploginid1",loginid);
        else
           session.removeAttribute("tmploginid");
        response.sendRedirect(loginfile + "&languageid="+islanguid+"&message="+usercheck) ;
	}else if(usercheck.equals("52")) {
		String tmploginid=(String)session.getAttribute("tmploginid");
        if(tmploginid!=null&&loginid.equals(tmploginid)) {
           session.setAttribute("tmploginid1",loginid);
        }
        else {
        	session.removeAttribute("tmploginid");
        	session.setAttribute("tmploginid1", loginid);
        	response.sendRedirect(loginfile + "&languageid="+islanguid+"&message="+usercheck) ;
        }
	}else if(usercheck.equals("16")){
		String usbMsgparam = "";
		if((usbType.equals("2") || usbType.equals("3")) && !"16".equals(notusbusercheck)){
			if (!"0".equals(serial)) {
				usbMsgparam = "&usbparammsg=1";
			}
		}
		request.getSession(true).removeAttribute("weaver_user@bean");
		session.setAttribute("tmploginid1",loginid);
		response.sendRedirect(loginfile + "&languageid="+islanguid+"&message="+usercheck + usbMsgparam) ;
	}else if(usercheck.equals("19")){
		response.sendRedirect("/system/InLicense.jsp") ;
	} else if (usercheck.equals("26")) {
		if (!loginPDA.equals("1")) {
			response.sendRedirect("/login/Login.jsp?logintype=1&languageid="+islanguid+"&message="+usercheck);
		} else {
			response.sendRedirect("/login/LoginPDA.jsp?logintype=1&languageid="+islanguid+"&message="+usercheck);
		}
	}else if(usercheck.equals("101") || usercheck.equals("730")){
        session.setAttribute("tmploginid",loginid);
        session.setAttribute("tmploginid1",loginid);
        if (!loginPDA.equals("1")) {
        response.sendRedirect("/login/Login.jsp?logintype=1&languageid="+islanguid+"&message="+usercheck) ;
		}
		else
		{
		response.sendRedirect("/login/LoginPDA.jsp?logintype=1&languageid="+islanguid+"&message="+usercheck) ;
		}
    }
    else if(usercheck.equals("110"))
	{
		if (!loginPDA.equals("1"))
		{
			response.sendRedirect("/login/Login.jsp?logintype=1&languageid="+islanguid+"&message=" + usercheck);
		}
		else
		{
			response.sendRedirect("/login/LoginPDA.jsp?logintype=1&languageid="+islanguid+"&message=" + usercheck);
		}
	}else if(usercheck.equals("556")|| usercheck.equals("122")){   //动态密码错误

		response.sendRedirect("/login/Login.jsp?logintype=1&languageid="+islanguid+"&message=" + usercheck);
	}
	else if(usercheck.equals("120")){    //未绑定动态令牌

		response.sendRedirect("/login/bindTokenKey.jsp?languageid="+islanguid);
	}
	else if(usercheck.equals("88")){     //Added by wcd 2014-01-04
		%>
		<script>
			showmsg("<%=SystemEnv.getHtmlLabelName(81628, islanguid)%>", function(){
				window.location = "/login/Login.jsp";				
			});
		</script>
		<%
		return;
	}
	else if(usercheck.equals("185")){
		if (!loginPDA.equals("1")) {
			response.sendRedirect("/login/Login.jsp?logintype=1&languageid="+islanguid+"&message="+usercheck);
		} else {
			response.sendRedirect("/login/LoginPDA.jsp?logintype=1&languageid="+islanguid+"&message="+usercheck);
		}
	}
	else {
            if("1".equals(session.getAttribute("istest"))){
                session.removeAttribute("istest");
            }
            User user = HrmUserVarify.getUser (request , response) ;
            if(user == null) { response.sendRedirect(loginfile+"&languageid="+islanguid) ; return;}

            session.setAttribute("password",userpassword);
            session.setAttribute("isrsaopen",isrsaopen);//是否RSA加密
            if("1".equals(logintype)){
            session.setAttribute("moniter", new OnLineMonitor("" + user.getUID(),user.getLoginip(),application));
            }
            Map logmessages=(Map)application.getAttribute("logmessages");
                if(logmessages==null){
                logmessages=new WHashMap();
                logmessages.put(""+user.getUID(),"");
                application.setAttribute("logmessages",logmessages);
                }
	        session.setAttribute("logmessage",usercheck);
	        session.setAttribute("fromlogin","yes");
            session.removeAttribute("tmploginid");

            DocCheckInOutUtil.docCheckInWhenVerifyLogin(user,request);

		//小窗口登录 (TD 2227)
		//hubo,050707
		if(request.getSession(true).getAttribute("layoutStyle")!=null && request.getSession(true).getAttribute("layoutStyle").equals("1")){
			session.setAttribute("istimeout","no");
%>
			<SCRIPT LANGUAGE=VBS>
				window.parent.returnvalue = "1"
				window.parent.close
			</script>
<%
		}else{
			if (loginPDA.equals("1")){
				response.sendRedirect(RedirectFile) ;
				return;
			}
			if("2".equals(logintype)){
				response.sendRedirect(RedirectFile) ;
				return;
			} else {
				Map userSessions = (Map)application.getAttribute("userSessions");
				String uId = String.valueOf(user.getUID());
				if(userSessions==null){
					userSessions=new java.util.concurrent.ConcurrentHashMap();
				}
				List slist = (List)userSessions.get(uId);
				slist = slist == null ? new ArrayList() : slist;
				slist.add(session);
				userSessions.put(uId, slist);
				application.setAttribute("userSessions",userSessions);
				
				UserTemplate  ut=new UserTemplate();
				
				ut.getTemplateByUID(user.getUID(),user.getUserSubCompany1());
				int templateId=ut.getTemplateId();
				int extendTempletid=ut.getExtendtempletid();
				int extendtempletvalueid=ut.getExtendtempletvalueid();
				String defaultHp = ut.getDefaultHp();
				session.setAttribute("defaultHp",defaultHp);
				
				if(extendTempletid!=0){
					//rsExtend.executeSql("select id,extendname,extendurl from extendHomepage  where id="+extendTempletid);
					rsExtend.executeQuery("select id,extendname,extendurl from extendHomepage  where id= ? ",extendTempletid);
					if(rsExtend.next()){
						int id=Util.getIntValue(rsExtend.getString("id"));
						//String extendname=Util.null2String(rsExtend.getString("extendname"));	
						String extendurl=Util.null2String(rsExtend.getString("extendurl"));	
						//rs.executeSql("select * from extendHpWebCustom where templateid="+templateId);
						rs.executeQuery("select * from extendHpWebCustom where templateid= ?",templateId);
						String defaultshow ="";
						if(rs.next()){
							defaultshow = Util.null2String(rs.getString("defaultshow"));
						}
						String param = "";
						if(!defaultshow.equals("")){
							param ="&"+defaultshow.substring(defaultshow.indexOf("?")+1);
						}
						if(gopage.length()>0){
							tourl = "/login/RemindLogin.jsp?RedirectFile="+extendurl+"/index.jsp?templateId="+templateId+param+"&gopage="+gopage;
						}else{			
							tourl = "/login/RemindLogin.jsp?RedirectFile="+extendurl+"/index.jsp?templateId="+templateId+param;
						}
						//tourl = extendurl+"/index.jsp?templateId="+templateId+param;
						//response.sendRedirect(extendurl+"/index.jsp?templateId="+templateId+param) ;
						//return;		
					}
				} else {
					//tourl = RedirectFile;
					tourl = "/login/RemindLogin.jsp?RedirectFile="+RedirectFile;
					//response.sendRedirect(RedirectFile) ;
					//return;
				}
				
				if (PortalUtil.istomsgpage()) {
				    tourl = "/rdeploy/chatproject/main.jsp";
				}
			}
		}
	}
}

//手机不检测

if (!loginPDA.equals("1")){
%>
<script>
try {
	if(document.cookie.indexOf('logincookiecheck=<%=testcookie%>')==-1) {
		document.location.href = '/login/Login.jsp?logintype=<%=logintype%>&noAllowIe=yes';
	}
	else {
		//document.location.href = '/docs/news/NewsDsp.jsp';
        document.location.href = '<%=tourl%>';
	}
}
catch(e){
	document.location.href = '/login/Login.jsp?logintype=<%=logintype%>&noAllowIe=yes';
}
</script>
<%
}
else {
	response.sendRedirect(tourl) ;
	return;
}
%>
	</body>
</html>
