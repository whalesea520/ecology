<!DOCTYPE html>
<%@page import="weaver.crm.Maint.ContactWayComInfo"%>
<%@page import="weaver.general.Util"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%
String callback = Util.null2String(request.getParameter("callback"));
%>
<html>
<head>
<title>获得途径</title>
</head>
<body>
<div id="crm_way" class="page out">
	<style type="text/css">
		#crm_way ul.list{padding:0px;}
		#crm_way ul.list li{padding:0px;font-size: 14px;}
		#crm_way ul.list li > a{height: 36px;line-height: 36px;padding-left: 15px;}
	</style>
	<div class="header" data-role="header">
		<div class="left" onclick="javascript:history.go(-1);">选择获得途径</div>
	</div>
	<div class="content">
		<div class="controlTitle">获得途径</div>
		<ul class="list">
			<%
				ContactWayComInfo comInfo = new ContactWayComInfo();
				while(comInfo.next()){
					String id = comInfo.getContactWayid();
					String name = comInfo.getContactWayname();
			%>
					<li><a href="javascript:void(0);" data-value="<%=id %>" data-text="<%=name %>"><%=name %></a></li>
			<%	}%>
		</ul>
	</div>
	<script type="text/javascript">
	$.extend(CRM, {
		buildCrmWayPage : function(callback){
			var that = this;
			var $crm_way = $("#crm_way");
			
			$(".list > li > a", $crm_way).click(function(){
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
	CRM.buildCrmWayPage("<%=callback%>");
	</script>
</div>
</body>
</html>
