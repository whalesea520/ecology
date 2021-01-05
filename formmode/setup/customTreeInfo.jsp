<%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="weaver.formmode.service.CustomtreeService"%>
<%@page import="weaver.formmode.service.LogService"%>
<%@page import="weaver.formmode.Module"%>
<%@ include file="/formmode/pub.jsp"%>
<%@ page import="weaver.general.Util"%>
<%
	if (!HrmUserVarify.checkUserRight("FORMMODEAPP:ALL", user)) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
%>
<%
int treeId = Util.getIntValue(request.getParameter("id"), 0);
int appid = Util.getIntValue(request.getParameter("appid"), 1);
CustomtreeService customtreeService = new CustomtreeService();
Map<String, Object> data = customtreeService.getCustomtreeById(treeId);
String treename = Util.null2String(data.get("treename"));
int customSearchId = Util.getIntValue(request.getParameter("id"), 0);
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
		
		function reloadinfo(id,type){
			if(type=='del'){
				window.location.href = "about:blank";
				return;
			}
			$("#baseFrame").attr("lazy-src","/formmode/setup/expandBase.jsp?id="+id);
			$("#interfaceFrame").attr("lazy-src","/formmode/setup/expandBaseInterface.jsp?id="+id);
			$.ajax({
			   type: "POST",
			   dataType:"json",
			   url: "/formmode/setup/expandSettingsActing.jsp?operation=getexpand",
			   data: "id="+id,
			   success: function(respData){
					$("#treenameSpan").html(respData.treename);
			   }
			});
		}
		
		function copyTreeSetting(){
		var id = <%=treeId%>;
		if(id>0){
			if(confirm("<%=SystemEnv.getHtmlLabelName(82060,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(82061,user.getLanguage())%><%=treename%><%=SystemEnv.getHtmlLabelName(82062,user.getLanguage())%>")){//提示：确认要复制【】吗？
				jQuery.ajax({
				   type: "POST",
				   dataType:"json",
				   url: "/formmode/setup/customTreeAction.jsp",
				   data: "id="+id+"&operation=copytree",
				   success: function(data){
					if(data){
				     	parent.refreshCustomtree(data.id);
					}
				   }
				});
			}
		}else{
			parent.Dialog.alert("<%=SystemEnv.getHtmlLabelName(82059,user.getLanguage())%>");//请先保存数据，再复制！
		}
	}
	</script>
</head>
  
<body>
	<div class="e8_right_top">
		<div style="width:40px;float:left;margin:2px 10px 0 0;"><img src="/formmode/images/treeIconRounded_wev8.png" /></div>
		<div class="e8_baseinfo">
			<div class="e8_baseinfo_name"><!-- 树 -->
				 <%=SystemEnv.getHtmlLabelName(33713,user.getLanguage())%> / <span class="e8_baseinfo_name"  id="treenameSpan" name="treenameSpan"><%=treename %></span>
			</div>
			<div class="e8_baseinfo_modify">
				<%LogService logService = new LogService(); %>
				<%=SystemEnv.getHtmlLabelName(82013,user.getLanguage())%>：<%=logService.getLastOptTime(treeId, Module.TREE) %><!-- 最后编辑时间 -->
			</div>
		</div>
		<div class="e8_right_tabs">
			<ul>
				<li href="#tabs-content-1" defaultSelected="true"><a><%=SystemEnv.getHtmlLabelName(81990,user.getLanguage())%></a></li><!-- 基础 -->
				<%if(treeId>0){%>
					<li href="#tabs-content-3"><a><%=SystemEnv.getHtmlLabelName(124822,user.getLanguage())%></a></li><!--工具栏搜索 -->
					<li href="#tabs-content-2"><a><%=SystemEnv.getHtmlLabelName(83,user.getLanguage())%></a></li><!-- 日志 -->
				<%} %>
			</ul>
		</div>
	</div>
	
	<div class="e8_right_center">
		<div id="tabs-content-1" class="e8_right_frameContainer">
			<iframe id="baseFrame" name="baseFrame" frameborder="0" style="width: 100%;height: 100%;" scrolling="auto" lazy-src="/formmode/setup/customTreeBase.jsp?id=<%=treeId %>&appid=<%=appid %>">
			
			</iframe>
		</div>
		<div id="tabs-content-2" class="e8_right_frameContainer">
			<iframe id="logFrame" name="logFrame" frameborder="0" style="width: 100%;height: 100%;" scrolling="auto" lazy-src="/formmode/setup/log.jsp?objid=<%=treeId%>&logmodule=<%=Module.TREE %>">
					
			</iframe>
		</div>
		<div id="tabs-content-3" class="e8_right_frameContainer">
			<iframe id="logFrame" name="logFrame" frameborder="0" style="width: 100%;height: 100%;" scrolling="auto" lazy-src="/formmode/search/CustomSearchToolbar.jsp?id=<%=customSearchId%>&type=2">	
			</iframe>
		</div>
	</div>
</body>
</html>
