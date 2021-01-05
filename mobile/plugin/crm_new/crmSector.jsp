<!DOCTYPE html>
<%@page import="weaver.general.Util"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.crm.Maint.SectorInfoComInfo"%>
<%
String callback = Util.null2String(request.getParameter("callback"));
%>
<html>
<head>
<title>客户行业</title>
</head>
<body>
<div id="crm_sector" class="page out">
	<style type="text/css">
		#crm_sector ul.list{padding:0px;}
		#crm_sector ul.list li{padding:0px;font-size: 14px;}
		#crm_sector ul.list li > a{height: 36px;line-height: 36px;padding-left: 15px;}
	</style>
	<div class="header" data-role="header">
		<div class="left" onclick="javascript:history.go(-1);">选择客户行业</div>
	</div>
	<div class="content">
		<div class="controlTitle">客户行业</div>
		<ul class="list">
			<%
				SectorInfoComInfo comInfo = new SectorInfoComInfo();
				while(comInfo.next()){
					String id = comInfo.getSectorInfoid();
					String name = comInfo.getSectorInfoname();
			%>
					<li><a href="javascript:void(0);" data-value="<%=id %>" data-text="<%=name %>"><%=name %></a></li>
			<%	}%>
		</ul>
	</div>
	<script type="text/javascript">
	$.extend(CRM, {
		buildCrmSectorPage : function(callback){
			var that = this;
			var $crm_sector = $("#crm_sector");
			
			$(".list > li > a", $crm_sector).click(function(){
				var value = $(this).attr("data-value");
				var text = $(this).attr("data-text");
				if(callback){
					var callbackFn = eval(callback);
					if(typeof(callbackFn) == "function"){
						callbackFn.call(that, value, text);
					}
					history.go(-1);
				}else{
					CRM.setCrmSearchValue(value, text, 'sector', true);
				}
				
			});
		}
	});
	CRM.buildCrmSectorPage("<%=callback%>");
	</script>
</div>
</body>
</html>
