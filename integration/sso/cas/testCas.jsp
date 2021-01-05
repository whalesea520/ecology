<%@page language="java" contentType="text/html; charset=UTF-8" %><%@page import="org.apache.commons.httpclient.HttpClient" %><%@page import="org.apache.commons.httpclient.HttpMethod" %><%@page import="org.apache.commons.httpclient.methods.GetMethod" %><%@page import="weaver.general.Util" %><%
	String casserverurl = Util.null2String(request.getParameter("casserverurl"));
	HttpClient client = new HttpClient(); 
	// 设置代理服务器地址和端口      
	
	//client.getHostConfiguration().setProxy("proxy_host_addr",proxy_port); 
	// 使用 GET 方法 ，如果服务器需要通过 HTTPS 连接，那只需要将下面 URL 中的 http 换成 https 
	HttpMethod method=new GetMethod(casserverurl);
	//使用POST方法
	//HttpMethod method = new PostMethod("http://java.sun.com");
	client.executeMethod(method);
	//System.out.println(">>>> resultCode:"+method.getStatusCode());//277481,lv,[90]集成中心－解决代码质量问题修复--不允许使用 System.out.println()
	//释放连接
	method.releaseConnection();
	String outStr = "";
	String resultCode = ""+method.getStatusCode();
	if(resultCode.startsWith("2") || resultCode.startsWith("3")){
		outStr = "ok";
	}else{
		outStr = "error";
	}
%><%=outStr%>