<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.general.*" %>
<%@page import="org.apache.commons.logging.Log"%>
<%@page import="org.apache.commons.logging.LogFactory"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="weaver.hrm.tools.HrmResourceMobileTools"%>
<%@page import="weaver.file.FileUpload"%>
<%@ page import="weaver.systeminfo.SystemEnv" %>
<%@ page import="weaver.hrm.settings.ChgPasswdReminder" %>
<%@ page import="weaver.hrm.settings.RemindSettings" %>
<jsp:useBean id="hrmResourceMobileTools" class="weaver.hrm.tools.HrmResourceMobileTools" scope="page"/>

<%!
	public static String getErrorMsg(int msgid, int languageid){
		String errormsg = "";
		switch (msgid) {
			case 1:
				errormsg = SystemEnv.getHtmlLabelName(16092,languageid);
				break;
			case 2:
				errormsg = SystemEnv.getHtmlLabelName(382265,languageid);
				break;
			case 3:
				errormsg = SystemEnv.getHtmlLabelName(382266,languageid);
				break;
			case 4:
				errormsg = SystemEnv.getHtmlLabelName(382267,languageid);
				break;
			case 5:
				errormsg = "";
				ChgPasswdReminder reminder=new ChgPasswdReminder();
				RemindSettings settings=reminder.getRemindSettings();
				String passwordComplexity = Util.null2String(settings.getPasswordComplexity());
				if(Util.null2String(passwordComplexity).equals("1")){
					errormsg += SystemEnv.getHtmlLabelName(31863,languageid);
				}else if(Util.null2String(passwordComplexity).equals("2")){
					errormsg += SystemEnv.getHtmlLabelName(83716,languageid);
				}
				break;
			default:
				errormsg = SystemEnv.getHtmlLabelName(126200,languageid);
				break;
		}
		return errormsg;
	}
%>
<%
Log log = LogFactory.getLog(page.getClass());
request.setCharacterEncoding("UTF-8");
response.setContentType("text/html;charset=UTF-8");
log.info("Follow is the QueryString:\t" + request.getQueryString());

FileUpload fu = new FileUpload(request);
String newPasswd = Util.null2String(fu.getParameter("newPasswd"));
String oldpasswd = Util.null2String(fu.getParameter("oldpasswd"));
String userid = Util.null2String(fu.getParameter("userid"));
String languageid = Util.null2String(fu.getParameter("languageid"));
int iLanguageid = 7;
if(!languageid.equals("zh-CN")){
	iLanguageid = 8;
}
if("".equals(languageid)){
	iLanguageid = 7;
}

int result = 0;
User user = HrmUserVarify.getUser(request , response) ;
if (user == null) {
	response.sendRedirect("/notice/noright.jsp");
	return;
} else {
	if ("".equalsIgnoreCase(userid)) {
		result = hrmResourceMobileTools.changePassword("" + user.getUID(), newPasswd, oldpasswd);
	} else {
		if (!userid.equals("" + user.getUID())) {
			response.sendRedirect("/notice/noright.jsp");
			return;
		} else {
			result = hrmResourceMobileTools.changePassword(userid, newPasswd, oldpasswd);
		}
	}
}
JSONObject tmp = new JSONObject();
tmp.put("result",result);
tmp.put("msg",getErrorMsg(result,iLanguageid));
response.getWriter().write(tmp.toString());
%>