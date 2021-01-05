<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ page import="weaver.wxinterface.InterfaceUtil"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <title>微信扫描二维码登录</title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">
	<script type='text/javascript' src="/wxinterface/js/jquery-1.8.3.min.js"></script>
	<script type="text/javascript" src="/mobile/plugin/plus/login/js/jquery.qrcode_wev8.js"></script>
	<style>
		*,html{
			font-family:微软雅黑;
			font-size:12px;
			margin:0;
			padding:0;
		}
		.body{
			background:url("/mobile/plugin/plus/login/bg_wev8.jpg") center bottom;
		}
		.h-10{height:10px;}
		.qrcodediv{
			position:absolute;
			width:300px;
			height:300px;
			top:50%;
			left:50%;
			margin-left:-150px;
			margin-top:-150px;
		}
		.center{
			text-align:center;
			margin-left: auto;
			margin-right: auto;
		}
		.qrcodeimg{
			padding-top:20px;
			padding-left:20px;
			width:155px;
			height:155px;
			background: url(/mobile/plugin/plus/login/qrcodebg_wev8.png) center no-repeat;
		}
		.tips{
			font-size:16px;
			text-align:center;
			color:#D5E7E4;
			line-height:36px;
			height:36px;
		}
		.backBtn{
			text-align:center;
			background:#448fa2;
			line-height:30px;
			height:30px;
			color:#fff;
			width:155px;
			border-radius:15px;
			cursor:pointer;
		}
	</style>
	<% 
		String qrcode = UUID.randomUUID().toString().replace("-", "");
	%>
	<script type="text/javascript">
	var loginInterval = null;
	$(function(){
		$('#qrcodeImg').qrcode({
			render	: "div",
			text	: "ecologylogin:<%=qrcode %>:<%=InterfaceUtil.getOutsysid()%>",
			size:135,
            background : "none",
            fill : "#424345"
		});
		loginInterval = window.setInterval(function () {
			getloginstatus("<%=qrcode %>");
		}, 1000);
		$(".backBtn").click(function(){
			window.location.href = "/login/login.jsp";
		});
	});
	function getloginstatus(key) {
		jQuery.ajax({
            url: "/mobile/plugin/plus/login/QCLoginStatus.jsp?loginkey="+key+"&rdm="+new Date().getTime(),
            dataType: "text", 
            contentType : "charset=UTF-8", 
            error:function(ajaxrequest){}, 
            success:function(content){
				if (jQuery.trim(content) != '0' && jQuery.trim(content) != '9') {
					if(jQuery.trim(content)==""){
						content = "/wui/main.jsp";
					}
					window.clearInterval(loginInterval);
					window.location.href = jQuery.trim(content);
				}
            }
        });
	}
	</script>
  </head>
  <body class="body">
  	<div id="qrcodeLogin" class="qrcodediv">
  			<div class="tips">
				扫码登录OA系统
			</div>
			<div class="h-10">&nbsp;</div>
			<div class="center">
				<div id="qrcodeImg" class="qrcodeimg center"></div>
			</div>
			<div class="h-10">&nbsp;</div>
			<div class="backBtn center">返回账号密码登录</div>
	</div>
  </body>
</html>