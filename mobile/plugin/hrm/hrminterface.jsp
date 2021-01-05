<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.*" %>
<%@ page import="org.apache.commons.logging.Log"%>
<%@ page import="org.apache.commons.logging.LogFactory"%>
<%@ page import="net.sf.json.JSONObject"%>
<%@ page import="weaver.file.FileUpload"%>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<jsp:useBean id="hrmResourceMobileTools" class="weaver.hrm.tools.HrmResourceMobileTools" scope="page"/>
<%
Log log = LogFactory.getLog(page.getClass());
request.setCharacterEncoding("UTF-8");
response.setContentType("text/html;charset=UTF-8");
log.info("Follow is the QueryString:\t" + request.getQueryString());

User user = HrmUserVarify.getUser (request , response) ;
FileUpload fu = new FileUpload(request);
String userid = Util.null2String(fu.getParameter("userid"));
if(userid.length()==0){
	userid = ""+user.getUID();
}
String cmd = Util.null2String(fu.getParameter("cmd"));
JSONObject tmp = new JSONObject();
if(cmd.equals("getPasswordComplexity")){
	String languageid = Util.null2String(fu.getParameter("languageid")).toLowerCase();
	//zh-CN  中文简体 ；  zh-TW  zh-HK  繁体 ,其他英文 
	//zh-Hans-CN 简体中文 zn-Hant-CN 繁体中文
	if(languageid.equals("zh-cn")||languageid.equals("zh-hans-cn")){
		languageid = "7";
	}else if(languageid.equals("zh-tw")||languageid.equals("zh-hk")||languageid.equals("zn-hant-cn")){
		languageid = "9";
	}else{
		languageid = "8";
	}
	String result = hrmResourceMobileTools.getPasswordComplexity(languageid);
	tmp.put("result",result);
}else if(cmd.equals("getResourceInfo")){
	String subcompanyid1 = Util.null2String(fu.getParameter("subcompanyid1"));
	String departmentid = Util.null2String(fu.getParameter("departmentid"));
	String result = hrmResourceMobileTools.getResourceInfo(subcompanyid1,departmentid);
	tmp.put("resourcelist",result);
}else if(cmd.equals("getHrmAppDetachInfo")){
	String result = hrmResourceMobileTools.getHrmAppDetachInfo(userid);
	tmp.put("result",result);
}else if(cmd.equals("getMobileShowType")){
	String result = hrmResourceMobileTools.getMobileShowType(userid);
	tmp.put("result",result);
}else if(cmd.equals("getHrmGroupInfo")){
	String result = hrmResourceMobileTools.getHrmGroupInfo(userid);
	tmp.put("result",result);
}
response.getWriter().write(tmp.toString());
%>