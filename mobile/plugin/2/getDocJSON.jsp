
<%@ page language="java" contentType="application/json" pageEncoding="UTF-8"%>
<%@page import="net.sf.json.*"%>
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


String documentid = Util.null2String(request.getParameter("documentid"));

Map result = DocServiceForMobile.getDoc(documentid,user);
String docsubject_tmp =(String)result.get("docsubject");
docsubject_tmp = docsubject_tmp.replaceAll("&lt;", "<");
docsubject_tmp = docsubject_tmp.replaceAll("&gt;", ">");
result.put("docsubject",docsubject_tmp);
JSONObject jo = JSONObject.fromObject(result);

out.println(jo);
%>