<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@page import="com.alibaba.fastjson.*"%>
<jsp:useBean id="auth"
	class="weaver.contractn.serviceImpl.ModeAuthorityServiceImpl" scope="page" />
<jsp:useBean id="mode" class="weaver.contractn.serviceImpl.ModeServiceImpl" scope="page" />
<%@ include file="/page/maint/common/initNoCache.jsp"%>	
<%
  	//auth.getAuthorityOfModeData("75",user);
	String modeName = request.getParameter("modeName");
	String modeId = mode.queryModeInfoByModeName(modeName).get("modeid") == null ? "0" : mode.queryModeInfoByModeName(modeName).get("modeid").toString();
	out.print(auth.getAuthorityOfQueryList(modeId,user));
%>

