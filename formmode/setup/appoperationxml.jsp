
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="weaver.general.*" %>
<%@ page import="oracle.sql.CLOB" %>
<%@ page import="java.io.Writer" %>
<jsp:useBean id="exports" class="weaver.formmode.exports.services.FormmodeDataService" scope="page"/>

<%
  User user = HrmUserVarify.getUser (request , response) ;
  if(user == null)  return ;
  String src = Util.null2String(request.getParameter("src"));
  ////得到标记信息
  if(src.equalsIgnoreCase("export"))
  {
	   String appid=Util.null2String(Util.null2String(request.getParameter("appid")));
	   String result = exports.exportFormmodeByAppId(appid);
	   out.println(result);
  }
  else
  {}
%>