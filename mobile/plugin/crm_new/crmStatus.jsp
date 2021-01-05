<!DOCTYPE html>
<%@page import="weaver.general.Util"%>
<%@page import="weaver.crm.Maint.CustomerStatusComInfo"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%
String callback = Util.null2String(request.getParameter("callback"));
%>
<html>
<head>
<title>客户状态</title>
</head>
<body>
<div id="crm_status" class="page out">
	<style type="text/css">
		#crm_status ul.list{padding:0px;}
		#crm_status ul.list li{padding:0px;font-size: 14px;}
		#crm_status ul.list li > a{height: 36px;line-height: 36px;padding-left: 15px;}
	</style>
	<div class="header" data-role="header">
		<div class="left" onclick="javascript:history.go(-1);">选择客户状态</div>
	</div>
	<div class="content">
		<div class="controlTitle">客户状态</div>
		<ul class="list">
			<%
				CustomerStatusComInfo comInfo = new CustomerStatusComInfo();
				while(comInfo.next()){
					String id = comInfo.getCustomerStatusid();
					String name = comInfo.getCustomerStatusname();
			%>
					<li><a href="javascript:void(0);" data-value="<%=id %>" data-text="<%=name %>"><%=name %></a></li>
			<%	}%>
		</ul>
	</div>
	<script type="text/javascript">
	$.extend(CRM, {
		buildCrmStatusPage : function(callback){
			var that = this;
			var $crm_status = $("#crm_status");
			
			$(".list > li > a", $crm_status).click(function(){
				var value = $(this).attr("data-value");
				var text = $(this).attr("data-text");
				if(callback){
					var callbackFn = eval(callback);
					if(typeof(callbackFn) == "function"){
						callbackFn.call(that, value, text);
					}
					history.go(-1);
				}else{
					CRM.setCrmSearchValue(value, text, 'status', true);
				}
				
			});
		}
	});
	CRM.buildCrmStatusPage("<%=callback%>");
	</script>
</div>
</body>
</html>
