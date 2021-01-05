<%@page import="net.sf.json.JSONObject"%>
<%@page import="weaver.formmode.browser.FormModeBrowserUtil"%>
<%@page import="weaver.general.Util"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%
	String customid = Util.null2String(request.getParameter("customid"));
	String browsertype = Util.null2String(request.getParameter("browsertype"));
	
	String action = Util.null2String(request.getParameter("action"));
	JSONObject jsonobj = new JSONObject();
	boolean isRef = false;
	if("deleteBrowser".equals(action)) {
		isRef = FormModeBrowserUtil.isReferenced(customid);
		
	} else  if("deleteBrowserType".equals(action)) {
		isRef = FormModeBrowserUtil.isBrowserReferenced(browsertype);
	}
	jsonobj.put("isref", isRef);
	response.getWriter().write(jsonobj.toString());
 %>