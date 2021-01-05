
<%@ page language="java" contentType="application/json" pageEncoding="UTF-8"%>
<%@page import="net.sf.json.*"%>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.file.*" %>
<%@ page import="weaver.hrm.*" %>

<jsp:useBean id="scheduleService" class="weaver.mobile.plugin.ecology.service.ScheduleService" scope="page"/>
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

FileUpload fu = new FileUpload(request);

String module = Util.null2String(fu.getParameter("module"));
String scope = Util.null2String(fu.getParameter("scope"));

String func = Util.null2String(fu.getParameter("func"));
String fromdate = Util.null2String(fu.getParameter("fromdate"));
String enddate = Util.null2String(fu.getParameter("enddate"));
String selectUser = Util.null2String(fu.getParameter("selectUser"));
String isShare = Util.null2String(fu.getParameter("isShare"));
String id = Util.null2String(fu.getParameter("id"));

Map result = new HashMap();

if("list".equals(func)) {
	result = scheduleService.getScheduleList2(fromdate, enddate, user,selectUser,isShare);
}
if("getview".equals(func)) {
	result = scheduleService.getScheduleByID(Integer.parseInt(id),user);
}
JSONObject jo = JSONObject.fromObject(result);
out.println(jo);
%>