
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.*" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="weaver.general.*" %>

<jsp:useBean id="resourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="recordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>

<%
request.setCharacterEncoding("UTF-8");
response.setContentType("text/html;charset=UTF-8");

String id = Util.null2String((String)request.getParameter("id"));
String from = Util.null2String((String)request.getParameter("from"));
String module = Util.null2String((String)request.getParameter("module"));
String scope = Util.null2String((String)request.getParameter("scope"));
String mobileSession = Util.null2String((String)request.getParameter("mobileSession"));

char flag=Util.getSeparator() ;

%>
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<meta name="author" content="Weaver E-Mobile Dev Group" />
	<meta name="description" content="Weaver E-mobile" />
	<meta name="keywords" content="weaver,e-mobile" />
	<meta name="viewport" content="width=device-width,minimum-scale=1.0, maximum-scale=1.0" />
	<title></title>
	<script type='text/javascript' src='/js/jquery/jquery_wev8.js'></script>
	<script type='text/javascript' src='/js/jquery/jquery-ui_wev8.js'></script>
	<link rel="stylesheet" href="/css/cupertino/jquery-ui_wev8.css" type="text/css">
	<style type="text/css">
	body,ul,p {
		margin:0;
		padding:0;
	}
	.page {
		background: url(/images/contentbg_wev8.png);
	}
	#header {
		width:100%;
		background: -moz-linear-gradient(top, white, #ECECEC);
		filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#FFFFFF', endColorstr='#ececec');
		background: -webkit-gradient(linear, left top, left bottom, from(#FFFFFF), to(#ECECEC));
		background: -moz-linear-gradient(top, white, #ECECEC);
		border-bottom: #CCC solid 1px;
		filter: alpha(opacity=70);
		-moz-opacity: 0.70;
		opacity: 0.70;
	}
	#content {
		color:#3F3F3F;
		padding: 15px 8px 15px 8px;
		overflow:auto;
	}
	#bottom {
		width:100%;
	}
	</style>
</head>
<body class="page">

<div id="header">
</div>

<div id="content">
没有权限访问!

</div>

<div id="bottom">
</div>

</BODY>
</HTML>