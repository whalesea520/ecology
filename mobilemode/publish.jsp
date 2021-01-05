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
		.tipContainer div:first-child{font-size:12px;color:#E52355;}
		.tipContainer div:nth-child(2){margin-bottom:10px;font-size:12px;color:#E52355;}
		.btnClass{background-color: #007aff;color: #fff;height: 23px;padding: 0 18px;margin: 0;border: none;cursor: pointer;overflow: visible;outline: none;margin-left: 8px;}
		.btnDisable{background-color: #eee !important;}
	</style>
	<script type="text/javascript">
		$(function(){
			var emobileAddress = localStorage.getItem("emobileAddressKey");
			if(emobileAddress != null && emobileAddress != ""){
				$("#emobileAddress").val(emobileAddress);
			}
			$("#emobileAddress").get(0).select();
		});
		function publish(btnobj){
			var emobileAddress = $("#emobileAddress").val();
			var Expression=/http(s)?:\/\/([\w-]+\.)+[\w-]+(\/[\w-.\/?%&=]*)?/;
			var objExp = new RegExp(Expression);
			if(emobileAddress != "" && !objExp.test(emobileAddress)){
				Dialog.alert("<%=SystemEnv.getHtmlLabelName(129407,user.getLanguage())%>！",function(){ //地址格式不正确！
					$("#emobileAddress").val("").get(0).select();
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
			var emobileAddress = $("#emobileAddress").val();
			if(emobileAddress == ""){
				Dialog.alert("<%=SystemEnv.getHtmlLabelName(129406,user.getLanguage())%>",function(){ //地址不能为空！
					$("#emobileAddress").get(0).select();
				});
				return;
			}
			var Expression=/http(s)?:\/\/([\w-]+\.)+[\w-]+(\/[\w- .\/?%&=]*)?/;
			var objExp = new RegExp(Expression);
			if(emobileAddress != "" && !objExp.test(emobileAddress)){
				Dialog.alert("<%=SystemEnv.getHtmlLabelName(129407,user.getLanguage())%>！",function(){ //地址格式不正确！
					$("#emobileAddress").val("").get(0).select();
				});
				return
			}
			$(".btnClass").addClass("btnDisable").attr("disabled",true);
			var url = jionActionUrl("com.weaver.formmodel.mobile.servlet.MobileAppBaseAction", "action=checkUrlStatus");
			FormmodeUtil.doAjaxDataSave(url, {"urlStr":emobileAddress}, function(res){
				$(".btnClass").removeClass("btnDisable").attr("disabled",false);
				if(res == "1"){
					Dialog.alert("<%=SystemEnv.getHtmlLabelName(32359,user.getLanguage())%>",function(){}); //测试连接通过，连接配置正确!
				}else{
					Dialog.alert("<%=SystemEnv.getHtmlLabelName(32296,user.getLanguage())%>",function(){}); //测试不通过，请检查设置
				}
			});
		}
	</script>
  </head>
  
  <body>
  	 <div class="tipContainer">
  	 	<div>可以在下方的文本框中输入Emobile的服务端地址，如http://192.168.0.245:89</div>
  	 	<div><%if("1".equals(ispublish)){%>如果填写了该地址，我们会在发布应用的同时通知Emobile更新该发布的应用<%}else{%>如果填写了该地址，我们会在下架应用的同时通知Emobile更新删除该应用<%}%></div>
  	 	<div>
  	 		<input id="emobileAddress" name="emobileAddress" type="text" placeholder="Emobile服务端地址" value="" style="width:80%;"/>
  	 		<button type="button" class="btnClass" onclick="checkUrlStatus()"><%=SystemEnv.getHtmlLabelName(25496,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(130730,user.getLanguage())%><!-- 测试连接 --></button>
  	 	</div>
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

