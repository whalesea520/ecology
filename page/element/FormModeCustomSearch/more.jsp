<%@page import="weaver.general.Util"%>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.formmode.search.FormModeTransMethod"%>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<%
String eid = request.getParameter("eid");
String customid = Util.null2String(session.getAttribute("page_formmode"+eid));
String formmodeelementid = Util.null2String(session.getAttribute("page_formmodeelementid"+eid));

String url = "/formmode/search/CustomSearchBySimple.jsp?customid={?}";
url = url.replace("{?}", customid);

String sql="select morehref from formmodeelement where id="+Util.getIntValue(formmodeelementid, 0);
rs1.executeQuery(sql);
int hreftype=0;
String morehref="";
if(rs1.next()){
	morehref = Util.null2String(rs1.getString("morehref"));
}

//手动输入more链接地址
if(!morehref.equals("")){
	//参数解析
	User user = HrmUserVarify.getUser(request,response);
	FormModeTransMethod formModeTransMethod = new FormModeTransMethod();
	url = formModeTransMethod.getDefaultSql(user,morehref);
	url = url.replace("$customid$", customid);
}

response.sendRedirect(url);
%>