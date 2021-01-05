
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";

/*用户验证*/
User user = HrmUserVarify.getUser (request , response) ;

//System.out.println("user=" + user);
if(user==null) {
	response.getWriter().write("0");
    return;
}
String sessionkey = request.getParameter("sessionkey");
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    
    <title></title>
    <meta name="viewport" content="width=device-width,minimum-scale=1.0,maximum-scale=1.0"/>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<!--
	<link rel="stylesheet" type="text/css" href="styles_wev8.css">
	-->
	<script type="text/javascript" src="/express/js/jquery-1.8.3.min_wev8.js"></script>
	<script type="text/javascript" src="/mobile/plugin/login/jquery.animate-colors-min_wev8.js"></script>
	
	<style type="text/css">
	* {
		font-family: '微软雅黑';
	}
	
	.submitbtn{
		display:inline-block;
		text-align:center;
		width:220px;
		border:0px;cursor:pointer;
		padding-left:10px;
		padding-right:10px;
		height:35px;
		line-height:35px;
		background-color:#1DA228;
		color:#ffffff;
		font-size:17px;
	}
	
	.resubmitbtn{
		background-color:#6BADF6;
	}
	
	.cancelbtn {
		background-color:#6BADF6;
	}
	
	.btnDown{
		background-color:#a1d829!important;
	}
	
	
	</style>
	
	<script type="text/javascript">
	
	jQuery(function () {
		//flicker(jQuery("#loginbutton")[0]);
		//$("#loginbutton").animate({backgroundColor: "#00CC00"})
		//btnColorflag = !btnColorflag;
		jQuery(".submitbtn").bind("mousedown", function () {
			jQuery(this).addClass("btnDown");
		});
		jQuery(".submitbtn").bind("mouseup", function () {
			jQuery(this).removeClass("btnDown");	
		});
		
		jQuery("#loginbutton").bind("click", function () {
			scan();
		});
		scan();
	});
	var inteval = null; 
	var btnColorflag = true;
	
	function login(key, operateflag) {
		jQuery.ajax({
			type: "POST",
            url: "/mobile/plugin/login/QCLoginManagerOperation.jsp?loginkey=" + key + "&operateflag=" + operateflag + "&rdm=" + new Date().getTime() + "&sessionkey=<%=sessionkey %>",
            dataType: "text", 
            contentType : "charset=UTF-8", 
            error:function(ajaxrequest){}, 
            success:function(content){
				if (jQuery.trim(content) == '1') {
					jQuery("#loginbutton").addClass("resubmitbtn");
					jQuery("#loginbutton").html("重新扫描");
					jQuery("#loginbutton").unbind();
					jQuery("#loginbutton").bind("click", function () {
						scan();
					});
				}
            }
        });
	}
	
	function scan() {
		var url = "emobile:QRCode:scanready";			
    	location = url; 
	}
	
	function scanready(qrcode) {
		$("#loginkey").val(qrcode);
		jQuery("#loginbutton").removeClass("resubmitbtn");
		jQuery("#loginbutton").html("登录PC版e-cology");
		jQuery("#loginbutton").unbind();
		jQuery("#loginbutton").bind("click", function () {
			login(document.getElementById('loginkey').value, 0);
			$("#loginbutton").animate({backgroundColor: "#1DA228"})
			window.clearInterval(inteval);
		});
		flicker(jQuery("#loginbutton")[0]);
		$("#loginbutton").animate({backgroundColor: "#00CC00"})
		btnColorflag = !btnColorflag;
	}
	
	function flicker(obj) {
		inteval = setInterval(function(){
			if (!btnColorflag) {
				$(obj).animate({backgroundColor: "#1DA228"})
			} else {
				$(obj).animate({backgroundColor: "#00CC00"})
			}
			btnColorflag = !btnColorflag;
		},1000);
	}
	
	function cancel() {
		$("#loginkey").val("");
		scan();
	}
	</script>
  </head>
  
  <body style="background:#43464D;">
  	<input type="hidden" name="loginkey" id="loginkey" value="">
    <div style="height:100%;text-align:center;">
    	<div style="width:100%;height:40px!important;"></div>
    	<div style="width:100%;width:131px;height:126px;margin:0 auto;">
    		<img src="/mobile/plugin/login/QRCodeBg_wev8.png" height="126px" width="131px"> 
    	</div>
    	<div style="width:100%;height:20px!important;"></div>
    	<div style="text-align:center;color:#ffffff;font-size:17px;fontWeight:bold;" >
    		即将在浏览器上登录PC版e-cology
    		<br>
    		请确认是否本人操作
    	</div>
    	<div style="width:100%;height:20px!important;"></div>
    	<div style="text-align:center;">
    		<div class="submitbtn" id="loginbutton">
    			登录PC版e-cology
    		</div>
    	</div>
    	
    	<div style="height:10px!important;">
    	</div>
    	
    	<div style="text-align:center;">
    		<div class="submitbtn cancelbtn" onclick="javascript:cancel();">重新扫描</div>
    	</div>
    </div>
  </body>
</html>
