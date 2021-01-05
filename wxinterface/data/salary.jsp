<%@ page language="java" contentType="text/html; charset=GBK"%>
<%@ page import="weaver.general.*"%>
<%@ page import="weaver.file.Prop"%>
<%@ page import="weaver.wxinterface.InterfaceUtil"%>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
	try{
		String wxsysurl = Util.null2String(request.getParameter("wxsysurl"));
		response.sendRedirect("/wxinterface/data/loginEb.jsp?wxsysurl="+wxsysurl+"&gotourl=/main/salary");
		return;
	}catch(Exception e){
		e.printStackTrace();
	}
%>