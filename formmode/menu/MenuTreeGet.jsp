
<%@ page language="java" contentType="application/x-json;charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="org.json.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="mu" class="weaver.page.maint.MenuUtil" scope="page" />



<%
	String menutype = Util.null2String(request.getParameter("typeid"));	
	String userId = Util.null2String(request.getParameter("userid"));
	String subCompanyId = Util.null2String(request.getParameter("subCompanyId"));
	boolean hasRight = Boolean.parseBoolean(Util.null2String(request.getParameter("hasRight")));
	out.print(mu.getMenuJsonStr(menutype,0,userId,subCompanyId,hasRight).toString());
%>
