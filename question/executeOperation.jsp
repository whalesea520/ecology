<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="weaver.question.Execute"%>
<%@ page import="net.sf.json.JSONObject" %>
<%
String operation  = request.getParameter("operation");
Execute execute = new Execute();
JSONObject object = new JSONObject();
String res = execute.execute();
if(res == null) {
	object.put("status","success");
	out.print(object.toString());
} else {
	object.put("status","error");
	object.put("errormsg",res);
	out.print(object.toString());
}

%>