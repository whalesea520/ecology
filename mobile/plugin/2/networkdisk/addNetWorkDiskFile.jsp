
<%@ page language="java" contentType="application/json" pageEncoding="UTF-8"%>
<%@page import="net.sf.json.*"%>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.conn.*" %>
<%
out.clearBuffer();
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

response.setContentType("application/json;charset=UTF-8");
String operation = Util.null2String(request.getParameter("operation"),"");
if(!operation.equals("sharetonetworkdisk")){
	Map result = new HashMap();
	//operation参数未设置正确
	result.put("result", "200002");
	result.put("error", "operation参数未设置正确");
	
	JSONObject jo = JSONObject.fromObject(result);
	out.println(jo);
	
	return;

}

RecordSet rs = new RecordSet();
String imagefileid = Util.null2String(request.getParameter("imagefileid"));
rs.writeLog(imagefileid+"=====================================");
Map result = new HashMap();
if(operation.equals("sharetonetworkdisk")){
	result.put("result", "0");
}


JSONObject jo = JSONObject.fromObject(result);

out.println(jo);
%>