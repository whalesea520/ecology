
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    
    <title>My JSP 'QCLogin.jsp' starting page</title>
    
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<!--
	<link rel="stylesheet" type="text/css" href="styles_wev8.css">
	-->
	<script type="text/javascript" src="/express/js/jquery-1.8.3.min_wev8.js"></script>
	<style type="text/css">
	* {
		font-family: '微软雅黑';
	}
	</style>
	
	<script type="text/javascript">
	var loginInterval = null;
	$(function () {
		loginInterval = window.setInterval(function () {
			getloginstatus("<%=session.getId() %>");
		}, 1000);
	});
	
	
	function getloginstatus(key) {
		jQuery.ajax({
            url: "/QCLoginStatus.jsp?loginkey=" + key + "&rdm=" + new Date().getTime(),
            dataType: "text", 
            contentType : "charset=UTF-8", 
            error:function(ajaxrequest){}, 
            success:function(content){
				window.console.log(jQuery.trim(content));
				if (jQuery.trim(content) != '0') {
					window.console.log("Successful user login!");
					window.clearInterval(loginInterval);
					window.location.href = jQuery.trim(content);
				}
            }
        });
	}
	
	</script>
  </head>
  
  <body>
  	<table width="300px" cellpadding="5" cellspacing="0" align="top" style="border:1px solid #666666;">
  		<colgroup>
  			<col width="30%">
  			<col width="*">
  		</colgroup>
  		<tr>
  			<td colspan="2" align="center">
  				<h1>QC登录</h1>
  				请扫描登录
  			</td>
  		</tr>
  		<tr>
  			<td colspan="2" align="center">
  				<div><%=session.getId() %></div>
  			</td>
  		</tr>
  	</table>
  </body>
</html>
