<%@ page import="weaver.general.Util"%>
<%@ page import="weaver.hrm.User"%>
<%@ page import="weaver.hrm.HrmUserVarify"%>
<%@ page import="java.util.Map"%>
<%@ page import="weaver.hrm.settings.RemindSettings"%>
<jsp:useBean id="LicenseCheckLogin" class="weaver.login.LicenseCheckLogin" scope="page" />

<%@ page language="java" contentType="text/html; charset=UTF-8"%>

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
	
	LicenseCheckLogin.updateOnlinFlag(""+ user.getUID());
	
	request.getSession(true).removeValue("moniter");
	request.getSession(true).removeValue("WeaverMailSet");
	request.getSession(true).invalidate();
%>