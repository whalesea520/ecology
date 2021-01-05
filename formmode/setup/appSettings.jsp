<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="weaver.formmode.service.AppInfoService"%>
<%@page import="weaver.formmode.Module"%>
<%@page import="weaver.formmode.service.LogService"%>
<%@ include file="/formmode/pub.jsp"%>
<%
	if (!HrmUserVarify.checkUserRight("FORMMODEAPP:ALL", user)) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
%>
<%

String userRightStr = "FORMMODEAPP:ALL";
Map rightMap = getCheckRightSubCompanyParam(userRightStr,user,fmdetachable ,-1,"",request,response,session);
int subCompanyId = Util.getIntValue(Util.null2String(rightMap.get("subCompanyId")),-1);
int operatelevel = Util.getIntValue(Util.null2String(rightMap.get("operatelevel")),-1);
String subCompanyId2 = ""+subCompanyId;

int modelId = Util.getIntValue(request.getParameter("modelId"), 0);
AppInfoService appInfoService = new AppInfoService();
Map<String, Object> modeInfo = appInfoService.getAppInfoById(modelId);
%>
<html>
<head>
	<title></title>
	<link rel="stylesheet" type="text/css" href="/formmode/js/ext/resources/css/ext-all_wev8.css" />
	<script type="text/javascript" src="/formmode/js/ext/adapter/ext/ext-base_wev8.js"></script>
	<script type="text/javascript" src="/formmode/js/ext/ext-all_wev8.js"></script>
	<script type="text/javascript" src="/formmode/js/ext/ux/miframe_wev8.js"></script>
	<script type="text/javascript" src="/formmode/js/jquery/simpleTabs/simpleTabs_wev8.js"></script>
	
	<style type="text/css">
		* {font:12px Microsoft YaHei}
		html,body{
			height: 100%;
			margin: 0px;
			padding: 0 0 0 5px;
		}
		.e8_form_top{
			padding: 13px 10px 0px 10px;
			position: relative;
		}
		.e8_form_top .e8_from_info{
			border-bottom: 1px solid #E9E9E9;
			padding-bottom: 16px;
		}
		.e8_form_top .e8_from_name{
			font-size: 18px;
			color: #333;
		}
		.e8_form_top .e8_from_modify{
			font-size: 12px;
			color: #AFAFAF;
		}
		.e8_form_top ul{
			list-style: none;
			position: absolute;
			right: 10px;
			bottom: 15px;
		}
		.e8_form_top ul li{
			float: left;
			padding: 0px 5px;
		}
		.e8_form_top ul li a{
			display: block;
			font-size: 15px;
			color: #A3A3A3;
			padding: 1px;
			text-decoration: none;
			cursor: pointer;
			border-bottom: 2px solid #fff;
		}
		.e8_form_top .e8_form_tabs ul li.selected a{
			color: #0072C6;		
			border-bottom: 2px solid #0072C6 !important;
		}
		.e8_form_center{
			overflow: hidden;
			padding: 0px 10px;
		}
		.e8_form_center .e8_form_frameContainer{
			display: none;
			height: 100%;
		}
	</style>
	<script type="text/javascript">
		
		$(document).ready(function () {
			$(window).resize(forPageResize);
			forPageResize();
			
			$(".e8_form_tabs").simpleTabs();
		});
		
		function forPageResize(){
			var $body = $(document.body);
			var $e8_form_top = $(".e8_form_top");
			var $e8_form_center = $(".e8_form_center");
			
			var centerHeight = $body.height() - $e8_form_top.outerHeight(true);
			
			$e8_form_center.height(centerHeight);
		}
	</script>
</head>
  
<body>
	<div class="e8_form_top">
		<div style="width:40px;float:left;margin:2px 10px 0 0;"><img src="/formmode/images/appIconRounded_wev8.png" /></div>
		<div class="e8_from_info">
			<div class="e8_from_name"><!-- 应用 -->
				<%=SystemEnv.getHtmlLabelName(25432,user.getLanguage())%> / <%=modeInfo.get("treefieldname") %>
			</div>
			<div class="e8_from_modify"><!-- 最后编辑时间 -->
				<%LogService logService = new LogService(); %>
				<%=SystemEnv.getHtmlLabelName(82013,user.getLanguage())%>：<%=logService.getLastOptTime(modelId, Module.APP) %>
			</div>
		</div>
		<div class="e8_form_tabs">
		<ul>
			<li href="#tabs-content-1" defaultSelected="true"><a><%=SystemEnv.getHtmlLabelName(81990,user.getLanguage())%><!-- 基础 --></a></li>
			<li href="#tabs-content-3"><a><%=SystemEnv.getHtmlLabelName(83,user.getLanguage())%><!-- 日志 --></a></li>
		</ul>
		</div>
	</div>
	
	<div class="e8_form_center">
		<div id="tabs-content-1" class="e8_form_frameContainer">
			<iframe id="formfieldFrame" name="formfieldFrame" frameborder="0" style="width: 100%;height: 100%;" scrolling="auto" lazy-src="/formmode/setup/appInfo.jsp?modelId=<%=modelId%>&t=<%=new Date().getTime() %>">
					
			</iframe>
		</div>
		<div id="tabs-content-2" class="e8_form_frameContainer">
			<iframe id="formlayoutFrame" name="formlayoutFrame" frameborder="0" style="width: 100%;height: 100%;" scrolling="auto" lazy-src="/formmode/setup/appAdd.jsp">
					
			</iframe>
		</div>
		<div id="tabs-content-3" class="e8_form_frameContainer">
			<iframe id="logFrame" name="logFrame" frameborder="0" style="width: 100%;height: 100%;" scrolling="auto" lazy-src="/formmode/setup/log.jsp?objid=<%=modelId%>&logmodule=<%=Module.APP %>">
					
			</iframe>
		</div>
	</div>
</body>
</html>
