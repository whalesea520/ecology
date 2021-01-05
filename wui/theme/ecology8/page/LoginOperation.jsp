
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util"%>
<%@ page import="weaver.hrm.*,weaver.general.*,weaver.systeminfo.*" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="org.apache.commons.logging.Log"%>
<%@ page import="org.apache.commons.logging.LogFactory"%>

<%

String method=Util.null2String(request.getParameter("method"));
String backdata = "1";//判断用户是否登录。1:用户已登录。0:网页超时
if("checkIsAlive".equals(method)) {
	User user = null;
    user = HrmUserVarify.checkUser(request,response) ;
    if(user == null)  backdata = "0";
    out.println(backdata);
}

%>