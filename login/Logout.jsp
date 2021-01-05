<%@ page import="weaver.general.Util"%>
<%@ page import="weaver.hrm.User"%>
<%@ page import="weaver.hrm.HrmUserVarify"%>
<%@ page import="java.util.Map"%>
<%@ page import="weaver.hrm.settings.RemindSettings,weaver.hrm.*"%>
<jsp:useBean id="LicenseCheckLogin" class="weaver.login.LicenseCheckLogin" scope="page" />
<%--//QC334358 [80]Cas集成-E9已经完成CAS集成功能，整合到E8 -start--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="weaver.file.Prop"%>
<%@ page import="java.net.URLEncoder"%>
<%@ page import="weaver.interfaces.sso.cas.CasSetting" %>
<%@ page import="weaver.interfaces.sso.cas.CasUtil" %>
<%--//QC334358 [80]Cas集成-E9已经完成CAS集成功能，整合到E8 -start--%>

<%
	User user = HrmUserVarify.getUser(request, response);
	RemindSettings settings0 = (RemindSettings) application.getAttribute("hrmsettings");
	Map logmessages = (Map) application.getAttribute("logmessages");
	String a_logmessage = "";
	if (logmessages != null)
		a_logmessage = Util.null2String((String)logmessages.get(""+ user.getUID()));
	String s_logmessage = Util.null2String((String)session.getAttribute("logmessage"));
	if (s_logmessage == null)
		s_logmessage = "";
	String relogin0 = Util.null2String(settings0.getRelogin());
	String fromPDA = Util.null2String((String)session.getAttribute("loginPAD"));
	//hubo 清除小窗口登录标识
	if (request.getSession(true).getAttribute("layoutStyle") != null)
		request.getSession(true).setAttribute("layoutStyle", null);
	
	//xiaofeng 有效的登入者在退出时清除登陆标记,踢出的用户直接退出
	if (!relogin0.equals("1") && !s_logmessage.equals(a_logmessage)) {
		if (fromPDA.equals("1")) {
			response.sendRedirect("/login/LoginPDA.jsp");
		} else {
			response.sendRedirect("/login/Login.jsp");
		}
		return;
	} else {
		logmessages = (Map) application.getAttribute("logmessages");
		if (logmessages != null)
			logmessages.remove("" + user.getUID());
	}
    
	String loginfile = Util.getCookie(request, "loginfileweaver");
    //QC334358 [80]Cas集成-E9已经完成CAS集成功能，整合到E8
    String logintype = Util.null2String(user.getLogintype());
	LicenseCheckLogin.updateOnlinFlag(""+ user.getUID());
    //QC334358 [80]Cas集成-E9已经完成CAS集成功能，整合到E8

	//QC389586 [80]解决SSO域单点登录后退出再登录提示账号密码错误（IE11下）的问题start
	//AD域单点登录标识
	String LOGIN_SSO_FLAG = Util.null2String((String)request.getSession(true).getAttribute("LOGIN_SSO_FLAG"));
	//是否IE浏览器
	String isIE = Util.null2String((String)request.getSession(true).getAttribute("browser_isie"));
	//QC389586 [80]解决SSO域单点登录后退出再登录提示账号密码错误（IE11下）的问题end

    String weaver_login_type = Util.null2String((String)request.getSession(true).getAttribute("weaver_login_type"));
	request.getSession(true).removeValue("moniter");
	request.getSession(true).removeValue("WeaverMailSet");
	request.getSession(true).invalidate();
	try{
		response.addHeader("Set-Cookie","__clusterSessionIDCookieName="+Util.getCookie(request,"__clusterSessionIDCookieName")+";expires=Thu, 01-Dec-1994 16:00:00 GMT;Path=/;HttpOnly");
	}catch(Exception e){}
	weaver.hrm.HrmUserVarify.invalidateCookie(request,response);
	if (fromPDA.equals("1"))
		loginfile = "/login/LoginPDA.jsp";

	//考虑这种情况：Cookies 被清空  loginfile为空  此时得指定一个值
	if (loginfile == null || loginfile.trim().equals("")) {
		loginfile = "/login/Login.jsp?logintype=1";
	}

	//QC389586 [80]解决SSO域单点登录后退出再登录提示账号密码错误（IE11下）的问题start
	if(LOGIN_SSO_FLAG.equals("true") && isIE.equals("true")){//AD域单点登录清除认证缓存
%>
	<script language="javascript">
		try {
			document.execCommand("ClearAuthenticationCache");
			window.location.href('/login/Login.jsp?logintype=1'); // page with logout message somewhere in not protected directory
		} catch (exception) {}
	</script>
<%
	}
	//QC389586 [80]解决SSO域单点登录后退出再登录提示账号密码错误（IE11下）的问题end

//	response.sendRedirect("/Refresh.jsp?loginfile=" + loginfile);
//    QC334358 [80]Cas集成-E9已经完成CAS集成功能，整合到E8 -start
    request.getSession(true).setAttribute("weaver_user@bean",null);
    CasSetting cs = new CasSetting();
    CasUtil cu = new CasUtil();
    String caslogin = cs.getIsuse();
    String isFilterExist = cu.isFilterExist();
    if(weaver_login_type.equals("OALogin")){
        if(!caslogin.equals("1") || !"1".equals(isFilterExist)){
            response.sendRedirect("/Refresh.jsp?loginfile=" + loginfile);
        }else{
            response.sendRedirect("/login/OALogin.jsp?loginfile=" + loginfile);
        }
    }else{
        if(!caslogin.equals("1" ) || !"1".equals(isFilterExist)){
            response.sendRedirect("/Refresh.jsp?loginfile=" + loginfile);
        }else{
            String logoutUrl = cs.getCasserverurl()+cs.getCasserverlogoutpage();
            String service = cs.getEcologyurl();
            service = URLEncoder.encode(service, "UTF-8");

            String loginUrl = cs.getCasserverurl()+cs.getCasserverloginpage();
            loginUrl = loginUrl+"?service="+service;

%>
<script language="javascript">
    top.window.location.href="<%=logoutUrl%>?service=<%=service%>?logintype=<%=logintype%>";
    <%--top.window.location.href="<%=loginUrl%>--%>

</script>
<%
        }

    }
%>
<%--//QC334358 [80]Cas集成-E9已经完成CAS集成功能，整合到E8 -end--%>