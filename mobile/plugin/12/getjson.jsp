
<%@ page language="java" contentType="application/json" pageEncoding="UTF-8"%>
<%@page import="net.sf.json.*"%>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.mobile.plugin.ecology.service.EMessageService" %>

<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
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
//String sessionkey = Util.null2String(request.getParameter("sessionkey"));
String func = Util.null2String(request.getParameter("func"));
String detailid = Util.null2String(request.getParameter("detailid"));

Map result = new HashMap();

if("msglist".equals(func)) {
	result = EMessageService.getInstance().getChatMessages(user.getLoginid(), ResourceComInfo.getLoginID(detailid));
}

JSONObject jo = JSONObject.fromObject(result);
out.println(jo);
%>