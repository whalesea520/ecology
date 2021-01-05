<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ page import="com.cloudstore.api.obj.Auth"%>
<jsp:useBean id="uca" class="com.cloudstore.api.util.Util_CheckAuth" scope="page" />
<%
	Auth a = uca.initCloudStore(request,response);
	//用户ID：a.getUserId() 部门ID：a.getDepId() 公司ID：a.getComId() 应用编码：a.getCode()
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="initial-scale=1.0, maximum-scale=2.0">
<meta name="description" content="">
<meta name="author" content="">
<title>流程明细插件设置</title>
<%@ include file="/cloudstore/page/style1/jspHead.jsp" %>
</head>
<body>
<div id="container"></div>
<script type="text/javascript" src="js/wfDetailSet.js" charset="utf-8"></script>
</body>
</html>