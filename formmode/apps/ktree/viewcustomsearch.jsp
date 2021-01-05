<%@page import="weaver.general.Util"%>

<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
String searchid= Util.null2String(request.getParameter("searchid"));
String versionid = Util.null2String(request.getParameter("versionid"));
String functionid = Util.null2String(request.getParameter("functionid"));
String tabid = Util.null2String(request.getParameter("tabid"));
String url = "/formmode/search/CustomSearchBySimple.jsp?customid="+searchid;
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    
    <title></title>
    
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<!--
	<link rel="stylesheet" type="text/css" href="styles_wev8.css">
	-->
	<script type="text/javascript">
		function resetFrame(){
			var tabFrame = document.getElementById("customsearchiframe");
			try{	// 捕获可能存在的js跨域访问出现的异常
				tabFrame.style.height = "auto";
				var frameDoc = tabFrame.contentWindow.document;
				tabFrame.style.height = (frameDoc.body.scrollHeight + 320) + "px";
				window.parent.resetFrame();
			}catch(e){}
		}
	
	</script>
  </head>
  
  <body>
    <iframe src="<%=url %>" id="customsearchiframe" frameborder="0" style="width: 100%;" scrolling="no" onload="resetFrame();" ></iframe>
    
  </body>
</html>
