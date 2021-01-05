<%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="weaver.formmode.service.ReportInfoService"%>
<%@page import="weaver.formmode.Module"%>
<%@page import="weaver.formmode.service.LogService"%>
<%@ include file="/formmode/pub.jsp"%>
<%@ page import="weaver.general.Util"%>
<%
	if (!HrmUserVarify.checkUserRight("FORMMODEAPP:ALL", user)) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
%>
<%
int reportId = Util.getIntValue(request.getParameter("id"), 0);
int appid = Util.getIntValue(request.getParameter("appid"), 0);
String reportname = "";
String reportdesc = "";
ReportInfoService reportInfoService=new ReportInfoService();
if(reportId!=0){
	Map<String,Object> map=reportInfoService.getReportInfoById(reportId);
	if(map.size()>0){
		reportname = Util.toScreen(Util.null2String(map.get("reportname")),user.getLanguage());
		reportdesc = Util.toScreen(Util.null2String(map.get("reportdesc")),user.getLanguage());
	}
}
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
			padding: 0px 0 0 2px;
		}
		.e8_right_top{
			padding: 13px 10px 0px 10px;
			position: relative;
		}
		.e8_right_top .e8_baseinfo{
			border-bottom: 1px solid #E9E9E9;
			padding-bottom: 16px;
		}
		.e8_right_top .e8_baseinfo_name{
			font-size: 18px;
			color: #333;
		}
		.e8_right_top .e8_baseinfo_modify{
			font-size: 12px;
			color: #AFAFAF;
		}
		.e8_right_top ul{
			list-style: none;
			position: absolute;
			right: 20px;
			bottom: 15px;
		}
		.e8_right_top ul li{
			float: left;
			padding: 0px 5px;
		}
		.e8_right_top ul li a{
			display: block;
			font-size: 15px;
			color: #A3A3A3;
			padding: 1px;
			text-decoration: none;
			cursor: pointer;
			border-bottom: 2px solid #fff;
		}
		.e8_right_top ul li.selected a{
			color: #0072C6;		
			border-bottom: 2px solid #0072C6;
		}
		.e8_right_center{
			overflow: hidden;
			padding: 0px 10px;
		}
		.e8_right_center .e8_right_frameContainer{
			display: none;
			height: 100%;
		}
	</style>
	<script type="text/javascript">
		
		$(document).ready(function () {
			$(window).resize(forPageResize);
			forPageResize();
			
			$(".e8_right_tabs").simpleTabs();
		});
		
		function forPageResize(){
			var $body = $(document.body);
			var $e8_right_top = $(".e8_right_top");
			var $e8_right_center = $(".e8_right_center");
			
			var centerHeight = $body.height() - $e8_right_top.outerHeight(true);
			
			$e8_right_center.height(centerHeight);
		}
	</script>
</head>
  
<body>
	<div class="e8_right_top">
		<div style="width:40px;float:left;margin:2px 10px 0 0;"><img src="/formmode/images/reportIconRounded_wev8.png" /></div>
		<div class="e8_baseinfo">
			<div class="e8_baseinfo_name">
				<%=SystemEnv.getHtmlLabelName(15101,user.getLanguage())%> / <%=reportname%><!-- 报表 -->
			</div>
			<div class="e8_baseinfo_modify">
				<%LogService logService = new LogService(); %>
				<%=SystemEnv.getHtmlLabelName(82013,user.getLanguage())%>：<%=logService.getLastOptTime(reportId, Module.REPORT) %><!-- 最后编辑时间 -->
			</div>
		</div>
		<div class="e8_right_tabs">
			<ul>
				<li href="#tabs-content-1" defaultSelected="true"><a><%=SystemEnv.getHtmlLabelName(81990,user.getLanguage())%><!-- 基础 --></a></li>
				<%if(reportId>0){ %>
				<li href="#tabs-content-2"><a><%=SystemEnv.getHtmlLabelName(16503,user.getLanguage())%><!-- 字段定义 --></a></li>
				<li href="#tabs-content-3"><a><%=SystemEnv.getHtmlLabelName(385,user.getLanguage())%><!-- 权限 --></a></li>
				<li href="#tabs-content-4"><a><%=SystemEnv.getHtmlLabelName(83,user.getLanguage())%><!-- 日志 --></a></li>
				<%}%>
			</ul>
		</div>
	</div>
	
	<div class="e8_right_center">
		<div id="tabs-content-1" class="e8_right_frameContainer">
			<iframe frameborder="0" style="width: 100%;height: 100%;" scrolling="auto" lazy-src="/formmode/setup/reportinfoBase.jsp?appid=<%=appid %>&id=<%=reportId %>">
					
			</iframe>
		</div>
		<%if(reportId>0){ %>
		<div id="tabs-content-2" class="e8_right_frameContainer">
			<iframe frameborder="0" style="width: 100%;height: 100%;" scrolling="auto" lazy-src="/formmode/setup/reportinfoField.jsp?id=<%=reportId %>">
					
			</iframe>
		</div>
		<div id="tabs-content-3" class="e8_right_frameContainer">
			<iframe frameborder="0" style="width: 100%;height: 100%;" scrolling="auto" lazy-src="/formmode/report/ReportShare.jsp?appid=<%=appid %>&id=<%=reportId %>">
					
			</iframe>
		</div>
		<div id="tabs-content-4" class="e8_right_frameContainer">
			<iframe id="logFrame" name="logFrame" frameborder="0" style="width: 100%;height: 100%;" scrolling="auto" lazy-src="/formmode/setup/log.jsp?objid=<%=reportId%>&logmodule=<%=Module.REPORT %>">
					
			</iframe>
		</div>
		<%}%>
	</div>
</body>
</html>
