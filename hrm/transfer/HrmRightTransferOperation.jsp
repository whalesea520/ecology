
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.hrm.common.*,weaver.hrm.authority.manager.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<!-- modified by wcd 2014-06-25 [E7 to E8] -->
<%
	if(!HrmUserVarify.checkUserRight("HrmRrightTransfer:Tran", user)){
		response.sendRedirect("/notice/noright.jsp");
		return;
	}  
	String fromid = Tools.vString(request.getParameter("fromid"));
	String toid = Tools.vString(request.getParameter("toid"));
	String transferType = Tools.vString(request.getParameter("transferType"),"resource");
	String authorityTag = Tools.vString(request.getParameter("authorityTag"),"transfer");
	String result = new HrmRightTransferManager(authorityTag, fromid, toid, request).processData();
	response.sendRedirect("PermissionToAdjust.jsp?cmd=showDialog&fromid="+fromid+"&toid="+toid+"&transferType="+transferType+"&authorityTag="+authorityTag+"&numberstr="+Tools.getURLEncode(result));
%>