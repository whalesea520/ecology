
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.util.Date" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
if(!HrmUserVarify.checkUserRight("ModeSetting:All", user)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}
String menuaddress = Util.null2String(request.getParameter("menuaddress"));//菜单地址
long menuflag = System.currentTimeMillis();
session.setAttribute(user.getUID()+"_"+menuflag+"_menuaddress",menuaddress);
response.sendRedirect("/formmode/menu/MenuMaint.jsp?menuflag="+menuflag);
%>
