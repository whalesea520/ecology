<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/jsp/systeminfo/init.jsp"%> 
<html>
 <head>
	<title> E-cology升级程序</title>
	    <script type="text/javascript" src="/js/jquery.js"></script>
		<script type="text/javascript" src="/js/updatepassword.js"></script>
	    <link rel="stylesheet" href="/css/main.css" type="text/css">
 </head>
<body style="height:100%;width:100%;">

	<div id=warp>
		<div style="height:40px;">
		</div>
		<div  style="height:380px;border:none;">
			<!-- div style="height:100%;width:120px;float:left;border:none;">
				<div style="background:url('/img/btn2.png') no-repeat;background-position:center center;height:38px;margin-top:10px;text-align:center;
			font-size:13px;padding-top:20px;color:#3c3c3c;" >
				   	密码修改
				</div>
			</div -->
			<div  style="height:370px;width:636px;float:right;margin-top:10px;border:none;">
				<div style="height:100%;width:620px;background:white;margin-left:-10px;"> 
			           	 <div style="width:100%;height:100%;font-size:18px;" align="center" >
			           	   <div style="margin-left:40px;width:90%;height:90%;text-align:left;" >
			           	    <div style="height:10px;"></div>
			           	    <div style="margin-top:30px;">请输入旧密码</div>
			           	    <div style="margin-top:20px;height:60px;">
			           	    	<input id="oldpassword" type="password" style="width:50%;height:25px;font-size:16px;line-height:25px;"/> 
			           	    	<b style="color: red;">*</b>
			           	    	<span id="message1" style="color:red;font-size:15px; "></span>
			           	    </div>
			           	    <div style="margin-top:10px;">新密码(长度至少3个字符)</div>
			           	    <div style="margin-top:20px;height:60px;">
			           	    	<input id="newpassword" type="password" style="width:50%;height:25px;font-size:16px;line-height:25px;"/> 
			           	    	<b style="color: red;">*</b>
			           	    	<span id="message2" style="color:red;font-size:15px; "></span>
			           	    </div>
			           	    <div style="margin-top:10px;">确认密码</div>
			           	    <div style="margin-top:10px;height:60px;">
			           	    	<input id="confirmpassword" type="password" style="width:50%;height:25px;font-size:16px;line-height:25px;"/> 
			           	    	<b style="color: red;">*</b>
			           	    	<span id="message3" style="color:red;font-size:15px; "></span>
			           	    </div>
			               </div>
			           </div>    
			    </div>
		   </div>
			
		</div>
		<div  style="clear:both;height:45px;">
		    <div style="width:97%;height:30px;padding-right:20px;padding-top:14px;" align="right">
			        <!-- input id="before" type="button" value="返回登录" style="background:url(/img/prebtn.png);border:none;width:70px;height:25px;font-weight:bold;" -->
					<input id="ok" type="button" value="保存" style="background:url(/img/nextbtn.png);border:none;width:70px;height:25px;color:#ffffff;font-weight:bold;">
			</div>
			
		</div>
</body>
</html>
