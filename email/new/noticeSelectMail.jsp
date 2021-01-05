<%@ page import="weaver.general.Util"%>

<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp"%>
<html>
	<head>
		<link rel="stylesheet" type="text/css" href="/email/fonts/style.css">
	</head>
	<body style="background: #F6F6F6; box-shadow: inset 1px 0 0 0 rgba(226,226,226,0.50);">
		<div style="width: 100%; position: absolute; top: 39%; text-align: center; vertical-align: middle;">
			<div class="icon-blog-NoData" style="font-size: 52px; color: #B2B2B2; margin: 20px 0;"></div>
			<div style="color: #B2B2B2;"><%=SystemEnv.getHtmlLabelName(131416, user.getLanguage()) %></div>
		</div>
	</body>
</html>