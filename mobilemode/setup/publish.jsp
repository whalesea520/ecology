<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="java.io.File"%>
<%@page import="weaver.general.GCONST"%>
<%@page import="java.io.FileInputStream"%>
<%@page import="java.io.IOException"%>
<%@ include file="/mobilemode/init.jsp"%>
<%
String id = Util.null2String(request.getParameter("id"));
String ispublish = Util.null2String(request.getParameter("ispublish"));
%>
<!DOCTYPE>
<html>
  <head>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<style type="text/css">
		*{
			font-family: 'Microsoft YaHei', Arial;
		 }
		.tipContainer{padding: 15px 10px 15px 10px;}
		.tipContainer div:first-child{
			font-size: 12px;
			color: red;
			padding-bottom: 10px;
			line-height: 20px;
		}
		.tipContainer div:nth-child(2){position: relative;}
		#emobileAddress{width: 100%;border: 1px solid #ccc;height: 30px;padding: 0px 0px 0px 5px;border-radius: 5px;box-sizing: border-box;outline:none;}
		.btnClass{background-color: #007aff;color: #fff;height: 30px;padding: 0 18px;margin: 0;border: none;cursor: pointer;overflow: visible;outline: none;
			position: absolute;
		    top: 0px;
		    right: 0px;
		    border-bottom-right-radius: 5px;
		    border-top-right-radius: 5px;
		}
		.btnDisable{background-color: #ccc !important;}
		.e8_zDialog_bottom {
		    position: absolute;
		    left: 0px;
		    bottom: 0px;
		    padding: 0px 10px;
		    width: 100%;
		    box-sizing: border-box;
		    margin-bottom: 15px;
		}
		.e8_zDialog_bottom .e8_btn_submit {
		    width: 100%;
		    border-radius: 5px;
		    box-sizing: border-box;
		    height: 32px;
		}
		#msg {
		    margin: 10px 0px;
		    padding: 5px;
		    border-radius: 3px;
		    display: none;
		}
		#msg.error{
		    display: inline-block;
		    color: red;
		}
		#msg.success{
		    display: inline-block;
		    color: #16a122;
		}
	</style>
	<script type="text/javascript">
		$(function(){
			var $emobileAddress = $("#emobileAddress");
			$emobileAddress.bind("input", function(){
				var v = $(this).val();
				if(v == ""){
					$("#checkStatusBtn").addClass("btnDisable");
				}else{
					$("#checkStatusBtn").removeClass("btnDisable");
				}
			});
			var emobileAddressKey = localStorage.getItem("emobileAddressKey");
			if(emobileAddressKey != null && emobileAddressKey != ""){
				$emobileAddress.val("").focus().val(emobileAddressKey).trigger("input");
			}else{
				$emobileAddress.focus();
			}
			
		});
		function publish(btnobj){
			$("#msg")[0].className = "";
			var emobileAddress = $("#emobileAddress").val();
			var Expression=/http(s)?:\/\/([\w-]+\.)+[\w-]+(\/[\w-.\/?%&=]*)?/;
			var objExp = new RegExp(Expression);
			if(emobileAddress != "" && !objExp.test(emobileAddress)){
				showMsg("<%=SystemEnv.getHtmlLabelName(129407,user.getLanguage())%>！","error",function(){ //地址格式不正确！
					$("#emobileAddress").focus();
				});
				return
			}
			if(emobileAddress != ""){
				localStorage.setItem("emobileAddressKey",emobileAddress);
			}
			$(btnobj).addClass("btnDisable").attr("disabled",true);
			var url = jionActionUrl("com.weaver.formmodel.mobile.servlet.MobileAppBaseAction", "action=publish");
			FormmodeUtil.doAjaxDataSave(url, {"id":<%=id%>,"ispublish":<%=ispublish%>,"requestURL":emobileAddress}, function(res){
				top.closeTopDialog(res);
			});
		}
		function onClose(){
			top.closeTopDialog();
		}
		function checkUrlStatus(){
			$("#msg")[0].className = "";
			var $checkStatusBtn = $("#checkStatusBtn");
			if($checkStatusBtn.hasClass("btnDisable")){
				return;
			}
			var emobileAddress = $("#emobileAddress").val();
			var Expression=/http(s)?:\/\/([\w-]+\.)+[\w-]+(\/[\w- .\/?%&=]*)?/;
			var objExp = new RegExp(Expression);
			if(emobileAddress != "" && !objExp.test(emobileAddress)){
				showMsg("<%=SystemEnv.getHtmlLabelName(129407,user.getLanguage())%>！","error",function(){ //地址格式不正确！
					$("#emobileAddress").focus();
				});
				return
			}
			$("#checkStatusBtn").addClass("btnDisable");
			var url = jionActionUrl("com.weaver.formmodel.mobile.servlet.MobileAppBaseAction", "action=checkUrlStatus");
			FormmodeUtil.doAjaxDataSave(url, {"urlStr":emobileAddress}, function(res){
				$(".btnClass").removeClass("btnDisable").attr("disabled",false);
				if(res == "1"){
					showMsg("<%=SystemEnv.getHtmlLabelName(32359,user.getLanguage())%>","success",function(){}); //测试连接通过，连接配置正确!
				}else{
					showMsg("<%=SystemEnv.getHtmlLabelName(32296,user.getLanguage())%>","error",function(){$("#emobileAddress").focus();}); //测试不通过，请检查设置
				}
			});
		}
		
		function showMsg(msg, cls, fn){
			$("#msg")[0].className = "";
			$("#msg").addClass(cls).html(msg);
			if(typeof(fn) == "function"){
				fn.call(window);
			}
		}
	</script>
  </head>
  
  <body>
  	 <div class="tipContainer">
  	 	<div><%=SystemEnv.getHtmlNoteName(4977,user.getLanguage())%><%if("1".equals(ispublish)){%><%=SystemEnv.getHtmlNoteName(4978,user.getLanguage())%><%}else{%><%=SystemEnv.getHtmlNoteName(4979,user.getLanguage())%><%}%></div>
  	 	<div>
  	 		<input id="emobileAddress" name="emobileAddress" type="text" placeholder="<%=SystemEnv.getHtmlLabelName(383289,user.getLanguage())%>http://192.168.0.245:89" value=""/><!-- Emobile服务端地址，如: -->
  	 		<button id="checkStatusBtn" type="button" class="btnClass btnDisable" onclick="checkUrlStatus()"><%=SystemEnv.getHtmlLabelName(25496,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(130730,user.getLanguage())%><!-- 测试连接 --></button>
  	 	</div>
  	 	<span id="msg"></span>
  	 </div>
  	 <div class="e8_zDialog_bottom">
  	 	<button type="button" class="e8_btn_submit" onclick="publish(this)">
  	 		<%if("1".equals(ispublish)){%>
  	 			<%=SystemEnv.getHtmlLabelName(114,user.getLanguage())%><!-- 发布 -->
  	 		<%}else{%>
  	 			<%=SystemEnv.getHtmlLabelName(127383,user.getLanguage())%><!-- 下架 -->
  	 		<%}%>
  	 	</button>
	 </div>
  </body>
</html>

