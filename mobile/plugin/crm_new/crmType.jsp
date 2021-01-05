<!DOCTYPE html>
<%@page import="weaver.general.Util"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.hrm.User"%>
<%@page import="com.weaver.formmodel.mobile.manager.MobileUserInit"%>
<%@page import="weaver.crm.Maint.CustomerTypeComInfo"%>
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
<title>客户类型</title>
</head>
<body>
<div id="crm_type" class="page out">
	<style type="text/css">
		#crm_type ul.list{padding:0px;}
		#crm_type ul.list li{padding:0px;font-size: 14px;}
		#crm_type ul.list li > a{height: 36px;line-height: 36px;padding-left: 15px;}
	</style>
	<div class="header" data-role="header">
		<div class="left" onclick="javascript:history.go(-1);">选择客户类型</div>
	</div>
	<div class="content">
		<div class="controlTitle">客户类型</div>
		<ul class="list">
			<%
				CustomerTypeComInfo comInfo = new CustomerTypeComInfo();
				while(comInfo.next()){
					String id = comInfo.getCustomerTypeid();
					String name = Util.toScreen(comInfo.getCustomerTypename(),user.getLanguage());
			%>
					<li><a href="javascript:void(0);" data-value="<%=id %>" data-text="<%=name %>"><%=name %></a></li>
			<%	}%>
		</ul>
	</div>
	<script type="text/javascript">
	$.extend(CRM, {
		buildCrmTypePage : function(callback){
			var that = this;
			var $crm_type = $("#crm_type");
			
			$(".list > li > a", $crm_type).click(function(){
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
	CRM.buildCrmTypePage("<%=callback%>");
	</script>
</div>
</body>
</html>
