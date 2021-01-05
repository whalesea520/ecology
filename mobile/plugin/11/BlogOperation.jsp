
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.mobile.plugin.ecology.service.PluginServiceImpl"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Enumeration"%>
<%@page import="weaver.file.FileUpload"%>
<%@page import="java.net.URLDecoder"%>
<%@ page import="weaver.hrm.*" %>
<%
User user = HrmUserVarify.getUser (request , response) ;
if(user == null)  return ;
request.setCharacterEncoding("UTF-8");
response.setContentType("text/html;charset=UTF-8");

FileUpload fu=new FileUpload(request);
PluginServiceImpl ps = new PluginServiceImpl();
Map<String,Object> param=new HashMap<String, Object>();
//获取所有请求参数
/*
Enumeration enu=fu.getParameterNames();
while(enu.hasMoreElements()){
	String paraName=(String)enu.nextElement();
	String value=fu.getParameter2(paraName);
    
	if(!paraName.equals("request")&&!paraName.equals("response")&&!paraName.equals("sessionkey"))
		param.put(paraName, value);
}
param.put("content",URLDecoder.decode(param.get("content")+"","utf-8"));
*/
out.print(ps.getBlogJson(fu));
%>