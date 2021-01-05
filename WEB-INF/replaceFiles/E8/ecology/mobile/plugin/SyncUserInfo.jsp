
<%@ page language="java" contentType="application/json" pageEncoding="UTF-8"%>
<%@page import="net.sf.json.*"%>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.file.*" %>
<%@ page import="weaver.hrm.*" %>
<jsp:useBean id="ps" class="weaver.mobile.plugin.ecology.service.PluginServiceImpl" scope="page" />
<%
response.setContentType("application/json;charset=UTF-8");
User user = HrmUserVarify.getUser (request , response) ;
	if(user==null) {
		Map result = new HashMap();
		result.put("error", "005");
		
		JSONObject jo = JSONObject.fromObject(result);
		out.println(jo);
		
		return;
	}
FileUpload fu = new FileUpload(request);

String userIdentifiers= Util.null2String(fu.getParameter("userIdentifiers"));
if(!"".equals(userIdentifiers) && !userIdentifiers.matches("^[0-9, ]*$")){
	return;
}
List userList=ps.syncUserInfo(userIdentifiers);

Map result=new HashMap();
result.put("userList",userList);

JSONObject jsObject = JSONObject.fromObject(result);
out.println(jsObject);
%>