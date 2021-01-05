
<%@ page language="java" contentType="application/json" pageEncoding="UTF-8"%>
<%@page import="net.sf.json.*"%>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.hrm.*" %>
<jsp:useBean id="CoworkService" class="weaver.mobile.plugin.ecology.service.CoworkService" scope="page" />
<%
out.clearBuffer();
User user = HrmUserVarify.getUser (request , response) ;
if(user==null) {
	Map result = new HashMap();
	//未登录或登录超时
	result.put("error", "200001");
	
	JSONObject jo = JSONObject.fromObject(result);
	out.println(jo);
	
	return;
}

response.setContentType("application/json;charset=UTF-8");

String module = Util.null2String(request.getParameter("module"));
String scope = Util.null2String(request.getParameter("scope"));
String sessionkey = Util.null2String(request.getParameter("sessionkey"));

Map result = new HashMap();

result = CoworkService.getCoworkCount(user);

JSONObject jo = JSONObject.fromObject(result);
out.println(jo);
%>