<!DOCTYPE html>
<%@page import="weaver.general.Util"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.hrm.User"%>
<%@page import="com.weaver.formmodel.mobile.manager.MobileUserInit"%>
<%@page import="weaver.crm.sellchance.SellstatusComInfo"%>
<%
User user = MobileUserInit.getUser(request, response);
if(user == null){
	out.println("无用户，请登录");
	return;
}
String callback = Util.null2String(request.getParameter("callback"));
%>
<html>
<head>
<title>商机状态</title>
</head>
<body>
<div id="crmSell_status" class="page out">
	<style type="text/css">
		#crmSell_status ul.list{padding:0px;}
		#crmSell_status ul.list li{padding:0px;font-size: 14px;}
		#crmSell_status ul.list li > a{height: 36px;line-height: 36px;padding-left: 15px;}
	</style>
	<div class="header" data-role="header">
		<div class="left" onclick="javascript:history.go(-1);">选择商机状态</div>
	</div>
	<div class="content">
		<div class="controlTitle">商机状态</div>
		<ul class="list">
			<%
			SellstatusComInfo comInfo = new SellstatusComInfo();
				while(comInfo.next()){
					String id = comInfo.getSellStatusid();
					String name = Util.toScreen(comInfo.getSellStatusname(id),user.getLanguage());
			%>
					<li><a href="javascript:void(0);" data-value="<%=id %>" data-text="<%=name %>"><%=name %></a></li>
			<%	}%>
		</ul>
	</div>
	<script type="text/javascript">
	$.extend(CRM, {
		buildCrmSellStatusPage : function(callback){
			var that = this;
			var $crmSell_status = $("#crmSell_status");
			
			$(".list > li > a", $crmSell_status).click(function(){
				if(callback){
					var callbackFn = eval(callback);
					if(typeof(callbackFn) == "function"){
						var value = $(this).attr("data-value");
						var text = $(this).attr("data-text");
						callbackFn.call(that, value, text);
					}
				}
				history.go(-1);
			});
		}
	});
	CRM.buildCrmSellStatusPage("<%=callback%>");
	</script>
</div>
</body>
</html>
