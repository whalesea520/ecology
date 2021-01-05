
<%@ page language="java" contentType="application/x-json;charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="org.json.*" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="DocDsp" class="weaver.docs.docs.DocDsp" scope="page"/>
<%
	String type = Util.null2String(request.getParameter("type"));
	

	JSONArray children=new JSONArray();
	if(type.equals("myrequest")){
		String requestType = Util.null2String(request.getParameter("requestType"));
		children = (JSONArray)session.getAttribute(requestType);
	}else{
		children = (JSONArray)session.getAttribute(type);
	}
    out.print(children.toString());
%>