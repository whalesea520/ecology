<!DOCTYPE html>
<%@page import="weaver.crm.Maint.CustomerDescComInfo"%>
<%@page import="weaver.general.Util"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%
String callback = Util.null2String(request.getParameter("callback"));
%>
<html>
<head>
<title>客户描述</title>
</head>
<body>
<div id="crm_desc" class="page out">
	<style type="text/css">
		#crm_desc ul.list{padding:0px;}
		#crm_desc ul.list li{padding:0px;font-size: 14px;}
		#crm_desc ul.list li > a{height: 36px;line-height: 36px;padding-left: 15px;}
	</style>
	<div class="header" data-role="header">
		<div class="left" onclick="javascript:history.go(-1);">选择客户描述</div>
	</div>
	<div class="content">
		<div class="controlTitle">客户描述</div>
		<ul class="list">
			<%
				CustomerDescComInfo comInfo = new CustomerDescComInfo();
				while(comInfo.next()){
					String id = comInfo.getCustomerDescid();
					String name = comInfo.getCustomerDescname();
			%>
					<li><a href="javascript:void(0);" data-value="<%=id %>" data-text="<%=name %>"><%=name %></a></li>
			<%	}%>
		</ul>
	</div>
	<script type="text/javascript">
	$.extend(CRM, {
		buildCrmDescPage : function(callback){
			var that = this;
			var $crm_desc = $("#crm_desc");
			
			$(".list > li > a", $crm_desc).click(function(){
				var value = $(this).attr("data-value");
				var text = $(this).attr("data-text");
				if(callback){
					var callbackFn = eval(callback);
					if(typeof(callbackFn) == "function"){
						callbackFn.call(that, value, text);
					}
				}
				history.go(-1);
			});
		}
	});
	CRM.buildCrmDescPage("<%=callback%>");
	</script>
</div>
</body>
</html>
