<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/plain; charset=UTF-8" %> 

<%


int userid=Util.getIntValue(request.getParameter("userid"),0);
String showtype = Util.null2String(request.getParameter("showtype"));

Util.setCookie(response, "weaver_proj_template_showtype_"+userid, showtype);

out.println("success");

%>
