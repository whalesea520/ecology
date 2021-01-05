
<%@ page language="java" contentType="application/json" pageEncoding="UTF-8"%>
<%@page import="net.sf.json.*"%>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.file.FileUpload" %>
<%@ page import="weaver.hrm.HrmUserVarify" %>
<%@ page import="weaver.hrm.User" %>
<jsp:useBean id="DocServiceForMobile" class="weaver.docs.webservices.DocServiceForMobile" scope="page" />

<%
out.clearBuffer();
response.setContentType("text/html;charset=UTF-8");

User user = HrmUserVarify.getUser (request , response) ;
if(user==null) {
	Map result = new HashMap();
	//未登录或登录超时
	result.put("result", "200001");
	result.put("error", "未登录或登录超");
			
	JSONObject jo = JSONObject.fromObject(result);
	out.println(jo);
	
	return;
}

FileUpload fu = new FileUpload(request); 
//操作方式  saveimagefile：保存附件
String operation = Util.null2String(fu.getParameter("operation"));
if(!operation.equals("saveimagefile")
	){
	Map result = new HashMap();
	//operation参数未设置正确
	result.put("result", "200002");
	result.put("error", "operation参数未设置正确");
	
	JSONObject jo = JSONObject.fromObject(result);
	out.println(jo);
	
	return;

}


Map result =null;
if(operation.equals("saveimagefile")){
	result = DocServiceForMobile.saveImageFile(fu,user);
}


JSONObject jo = JSONObject.fromObject(result);

out.println(jo);


%>