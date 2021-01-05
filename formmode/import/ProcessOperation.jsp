
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="com.weaver.formmodel.util.StringHelper"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="com.weaver.formmodel.util.NumberHelper"%>
<%
response.reset();
String action=StringHelper.null2String(request.getParameter("action"));
if("doStatus".equalsIgnoreCase(action)){
	Object object=session.getAttribute("processMap");
	JSONObject processMap=new JSONObject();
	int isfinish=0;
	if (object != null) {
		processMap=(JSONObject)object;
		isfinish=NumberHelper.string2Int(processMap.get("isfinish"),0);
		if(isfinish==1){
			session.removeAttribute("processMap");
		}
	}
	out.print(processMap.toString());
}
out.flush();
%>