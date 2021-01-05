
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@page import="com.weaver.integration.log.LogInfo"%>
<%@page import="com.weaver.integration.datesource.SAPInterationOutUtil"%>
<%@page import="com.weaver.integration.datesource.SAPInterationBean"%>
<%@ include file="/page/maint/common/initNoCache.jsp"%>
<%@ page import="net.sf.json.*" %>
<%

		String hostname = Util.null2String(request.getParameter("hostname"));
		String saprouter = Util.null2String(request.getParameter("saprouter"));
		String systemnum = Util.null2String(request.getParameter("systemnum"));
		String client = Util.null2String(request.getParameter("client"));
		String language = Util.null2String(request.getParameter("language"));
		String username = Util.null2String(request.getParameter("username"));
		String password = Util.null2String(request.getParameter("password"));
		SAPInterationBean sb = new SAPInterationBean();
		sb.setClient(client);
		sb.setHostname(hostname);
		sb.setLanguage(language);
		sb.setUsername(username);
		sb.setPassword(password);
		sb.setSystemNum(systemnum);
		sb.setSapRouter(saprouter);
		SAPInterationOutUtil sou = new SAPInterationOutUtil();
		String flag = sou.getTestConnection(new LogInfo(), sb);
		JSONObject jsa = new JSONObject();
		
		jsa.accumulate("content", flag);
	    out.clear();
	    out.println(jsa);


%>