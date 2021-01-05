
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*"%>
<%@page import="weaver.general.Util,weaver.systeminfo.*"%>

<%@ page import="weaver.hrm.*" %>


<%
request.setCharacterEncoding("UTF-8");
response.setContentType("text/html;charset=UTF-8");

User user = HrmUserVarify.getUser (request , response) ;
if(user == null)  return ;
%>

<!DOCTYPE html>
<html>
<head>
	<title><%=SystemEnv.getHtmlLabelName(18214, user.getLanguage()) %>:</title>
	<script type="text/javascript" src="/mobile/plugin/1/js/jquery-1.6.2.min_wev8.js"></script>
	<script type="text/javascript" src="/js/mylibs/asyncbox/AsyncBox.v1.4_wev8.js"></script>
	<link rel="stylesheet" href="/js/mylibs/asyncbox/skins/ZCMS/asyncbox_wev8.css">
	<style type="text/css">

	.operationBt {
			height:26px;
			margin-left:18px;
			line-height:26px;
			font-size:14px;
			color:#fff;
			text-align:center;
			-moz-border-radius: 5px;
			-webkit-border-radius: 5px; 
			border-radius:5px;
			border:1px solid #0084CB;
			background:#0084CB;
			background: -moz-linear-gradient(0, #30B0F5, #0084CB);
			background:-webkit-gradient(linear, 0 0, 0 100%, from(#30B0F5), to(#0084CB));
			overflow:hidden;
			float:left;
	}
	.width50 {
		width:80px;
	}
	
	.blockHead {
		width:100%;
		height:24px;
		line-height:24px;
		font-size:12px;
		font-weight:bold;
		color:#fff;
		border-top:1px solid #0084CB;
		border-left:1px solid #0084CB;
		border-right:1px solid #0084CB;
		-moz-border-top-left-radius: 5px;
		-moz-border-top-right-radius: 5px;
		-webkit-border-top-left-radius: 5px; 
		-webkit-border-top-right-radius: 5px; 
		border-top-left-radius:5px;
		border-top-left-radius:5px;
		background:#0084CB;
		background: -moz-linear-gradient(0, #31B1F6, #0084CB);
		background:-webkit-gradient(linear, 0 0, 0 100%, from(#31B1F6), to(#0084CB));
	}
	
	.m-l-14 {
		margin-left:14px;
	}
	
	
	.tblBlock {
		width:100%;
		border-left:1px solid #C5CACE;
		border-right:1px solid #C5CACE;
		border-bottom:1px solid #C5CACE;
		background:#fff;
		-moz-border-bottom-left-radius: 5px;
		-moz-border-bottom-right-radius: 5px;
		-webkit-border-bottom-left-radius: 5px; 
		-webkit-border-bottom-right-radius: 5px; 
		border-bottom-left-radius:5px;
		border-bottom-left-radius:5px;
	}
	
	#asyncbox_alert_content {
		height:auto!important;
		min-height:10px!important;
	}
	</style>
	
	
	<SCRIPT type="text/javascript">
	function forwmail(obj){
		var innerurl=parent.document.getElementById("forwordinnerurl").value;
		var url="";
		if(obj==1){
			url="/mobile/plugin/email/EmailNewIn.jsp"+innerurl;
		}else{
			url="/mobile/plugin/email/EmailNew.jsp"+innerurl;
		}
		parent.location.href=url;
		//parent.closeDialog();
		
	}
	
	</SCRIPT>
	
</head>
<body style="background:#F0F0F0;height:100%;">

<div data-role="page" class="page" style="background:#F0F0F0;margin:0;padding-left:10px;padding-right:10px;padding-top:10px;padding-bottom:10px;">

		<center>
			<div data-role="controlgroup" style="width:210px;margin-bottom:10px;margin-top:5px;">
				<div class="operationBt width50" onclick="forwmail(1);"><%=SystemEnv.getHtmlLabelName(24714, user.getLanguage()) %></div>
				<div class="operationBt width50" onclick="forwmail(0);"><%=SystemEnv.getHtmlLabelName(31139, user.getLanguage()) %></div>
				<div style="clear:both;"></div>
			</div>
		</center>
</div>

</body>
</html>