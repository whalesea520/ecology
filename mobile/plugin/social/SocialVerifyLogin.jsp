<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="net.sf.json.*"%>
<%@page import="weaver.mobile.plugin.ecology.service.HrmResourceService"%>
<%@ page import="weaver.file.*" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.hrm.*" %>
<%
	request.setCharacterEncoding("UTF-8");
	response.setContentType("application/json;charset=UTF-8");
	FileUpload fu = new FileUpload(request); 
	
	String loginId = Util.null2String(fu.getParameter("loginid"));
	String password = Util.null2String(fu.getParameter("password"));
	String dynapass = Util.null2String(fu.getParameter("dynapass"));
	String tokenpass = Util.null2String(fu.getParameter("tokenpass"));
	String language = Util.null2String(fu.getParameter("language"));
	String ipaddress = Util.null2String(fu.getParameter("ipaddress"));
	int policy = Util.getIntValue(Util.null2String(fu.getParameter("policy")),0);
	String auth = Util.null2String(fu.getParameter("auth"));
	JSONObject result = new JSONObject();
	
	if(loginId == null || "".equals(loginId) || password == null || "".equals(password)){
		result.put("error", "no loginid or password!");
	}
	else{
		HrmResourceService hrs = new HrmResourceService();
		int status = hrs.checkLogin(loginId, password, "","",0);
		
		if(status == 1){
			User user = hrs.getUserById(hrs.getUserId(loginId));
			request.getSession(true).setAttribute("weaver_user@bean",user);
		}
		result.put("status", status);
	}
	out.println(result);
%>