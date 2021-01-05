<%@ page language="java" contentType="application/json" pageEncoding="UTF-8"%>

<%@page import="net.sf.json.JSONObject"%>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.hrm.*" %>
<jsp:useBean id="DocServiceForMobile" class="weaver.docs.webservices.DocServiceForMobile" scope="page" />
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


int parentid = Util.getIntValue(request.getParameter("parentid"),-1);
String categoryname = Util.null2String(request.getParameter("categoryname"));
int pageindex = Util.getIntValue(request.getParameter("pageindex"), 1);
int pagesize = Util.getIntValue(request.getParameter("pagesize"), 10);

Map<String, Object> result=DocServiceForMobile.getCategoryAndDocTree(parentid,categoryname,user,pageindex,pagesize);
JSONObject jo = JSONObject.fromObject(result);
out.println(jo);
%>