<!DOCTYPE html>
<%@page import="weaver.crm.Maint.ContacterTitleComInfo"%>
<%@page import="weaver.general.Util"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%
String callback = Util.null2String(request.getParameter("callback"));
%>
<html>
<head>
<title>联系人称呼</title>
</head>
<body>
<div id="crm_contacter_title" class="page out">
	<style type="text/css">
		#crm_contacter_title ul.list{padding:0px;}
		#crm_contacter_title ul.list li{padding:0px;font-size: 14px;}
		#crm_contacter_title ul.list li > a{height: 36px;line-height: 36px;padding-left: 15px;}
	</style>
	<div class="header" data-role="header">
		<div class="left" onclick="javascript:history.go(-1);">选择称呼</div>
	</div>
	<div class="content">
		<div class="controlTitle">联系人称呼</div>
		<ul class="list">
			<%
				ContacterTitleComInfo comInfo = new ContacterTitleComInfo();
				while(comInfo.next()){
					String id = comInfo.getContacterTitleid();
					String name = comInfo.getContacterTitlename();
			%>
					<li><a href="javascript:void(0);" data-value="<%=id %>" data-text="<%=name %>"><%=name %></a></li>
			<%	}%>
		</ul>
	</div>
	<script type="text/javascript">
	$.extend(CRM, {
		buildCrmContacterTitlePage : function(callback){
			var that = this;
			var $crm_contacter_title = $("#crm_contacter_title");
			
			$(".list > li > a", $crm_contacter_title).click(function(){
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
	CRM.buildCrmContacterTitlePage("<%=callback%>");
	</script>
</div>
</body>
</html>
