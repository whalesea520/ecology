
<%@ page language="java" contentType="application/json" pageEncoding="UTF-8"%>
<%@page import="net.sf.json.*"%>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.file.*" %>
<%@ page import="weaver.hrm.*" %>
<jsp:useBean id="ps" class="weaver.mobile.plugin.ecology.service.PluginServiceImpl" scope="page" />
<%
response.setContentType("application/json;charset=UTF-8");

String sessionkey = Util.null2String(request.getParameter("sessionkey"));
Map result = new HashMap();
if(ps.verify(sessionkey)) {
	result.put("verify", "1");
} else {
	result.put("verify", "0");
}

if(result!=null) {
	JSONObject jo = JSONObject.fromObject(result);
	out.println(jo);
}
%>