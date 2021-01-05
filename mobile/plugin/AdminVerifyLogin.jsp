
<%@ page language="java" contentType="application/json" pageEncoding="UTF-8"%>
<%@page import="net.sf.json.*"%>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.file.*" %>
<%@ page import="weaver.hrm.*" %>
<jsp:useBean id="ps" class="weaver.mobile.plugin.ecology.service.PluginServiceImpl" scope="page" />
<%
	response.setContentType("application/json;charset=UTF-8");

	FileUpload fu = new FileUpload(request);

	String loginId = Util.null2String(fu.getParameter("loginid"));
	String password = Util.null2String(fu.getParameter("password"));
	String ipaddress = Util.null2String(fu.getParameter("ipaddress"));
	
	Map result = ps.adminLogin(loginId, password,ipaddress);
	
	if(result!=null) {
		JSONObject jo = JSONObject.fromObject(result);
		//System.out.println(jo);
		out.println(jo.toString());
	}
%>
