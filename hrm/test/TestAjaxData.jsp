<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="net.sf.json.JSONArray" %>
<%@ page import="net.sf.json.JSONObject"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%

out.clear();
String cmd = Util.null2String(request.getParameter("cmd"));
JSONObject jsonObj = new JSONObject();
char separator = Util.getSeparator() ;
String sql = "";

if(cmd.equals("comAll")){}else if(cmd.equals("trainlayout")){
}

%>