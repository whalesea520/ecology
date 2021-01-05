<!DOCTYPE html>
<%@page import="weaver.general.Util"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.hrm.User"%>
<%@page import="com.weaver.formmodel.mobile.manager.MobileUserInit"%>
<%@page import="weaver.crm.sellchance.SelltypesComInfo"%>
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
<title>商机类型</title>
</head>
<body>
<div id="crmSell_type" class="page out">
	<style type="text/css">
		#crmSell_type ul.list{padding:0px;}
		#crmSell_type ul.list li{padding:0px;font-size: 14px;}
		#crmSell_type ul.list li > a{height: 36px;line-height: 36px;padding-left: 15px;}
	</style>
	<div class="header" data-role="header">
		<div class="left" onclick="javascript:history.go(-1);">选择商机类型</div>
	</div>
	<div class="content">
		<div class="controlTitle">商机类型</div>
		<ul class="list">
			<%
			SelltypesComInfo comInfo = new SelltypesComInfo();
				while(comInfo.next()){
					String id = comInfo.getSellTypesid();
					String name = Util.toScreen(comInfo.getSellTypesname(id),user.getLanguage());
			%>
					<li><a href="javascript:void(0);" data-value="<%=id %>" data-text="<%=name %>"><%=name %></a></li>
			<%	}%>
		</ul>
	</div>
	<script type="text/javascript">
	$.extend(CRM, {
		buildCrmSellTypePage : function(callback){
			var that = this;
			var $crmSell_type = $("#crmSell_type");
			
			$(".list > li > a", $crmSell_type).click(function(){
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
	CRM.buildCrmSellTypePage("<%=callback%>");
	</script>
</div>
</body>
</html>
