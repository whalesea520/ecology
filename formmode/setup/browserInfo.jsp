<%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="weaver.formmode.service.BrowserInfoService"%>
<%@page import="weaver.formmode.service.LogService"%>
<%@page import="weaver.formmode.Module"%>
<%@ include file="/formmode/pub.jsp"%>
<%@ page import="weaver.general.Util"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
	if (!HrmUserVarify.checkUserRight("FORMMODEAPP:All", user)) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
%>
<%
int browserId = Util.getIntValue(request.getParameter("id"), 0);
int appid = Util.getIntValue(request.getParameter("appid"), 0);
String customname = "";
String customdesc = "";
BrowserInfoService browserInfoService = new BrowserInfoService();
if(browserId!=0){
	Map<String,Object> map=browserInfoService.getBrowserInfoById(browserId);
	if(map.size()>0){
		customname = Util.toScreen(Util.null2String(map.get("customname")),user.getLanguage());
		customdesc = Util.toScreen(Util.null2String(map.get("customdesc")),user.getLanguage());
	}
}

boolean hasTitleField = false;
if(browserId!=0){
	String sql = "select b.fieldname from mode_CustomBrowserDspField a,workflow_billfield b where a.fieldid = b.id and a.customid = "+browserId+" and (a.istitle = '1' or a.istitle='2')";
	rs.executeSql(sql);
	if(rs.next()){
		hasTitleField = true;
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
		<div style="width:40px;float:left;margin:2px 10px 0 0;"><img src="/formmode/images/browserIconRounded_wev8.png" /></div>
		<div class="e8_baseinfo">
			<div class="e8_baseinfo_name">
				<%=SystemEnv.getHtmlLabelName(32306,user.getLanguage())%> / <%=customname%><!-- 浏览框 -->
			</div>
			<div class="e8_baseinfo_modify">
				<%LogService logService = new LogService(); %>
				<%=SystemEnv.getHtmlLabelName(82013,user.getLanguage())%> ：<%=logService.getLastOptTime(browserId, Module.BROWSER) %><!-- 最后编辑时间 -->
			</div>
		</div>
		<div class="e8_right_tabs">
			<ul>
				<li href="#tabs-content-1" defaultSelected="true"><a><%=SystemEnv.getHtmlLabelName(81990,user.getLanguage())%></a></li><!-- 基础 -->
				<%if(browserId>0){ %>
				<li href="#tabs-content-2"><a><%=SystemEnv.getHtmlLabelName(16503,user.getLanguage())%></a></li><!-- 字段定义 -->
				<li href="#tabs-content-4"><a><%=SystemEnv.getHtmlLabelName(82029,user.getLanguage())%></a></li><!-- 浏览框列表 -->
				<li href="#tabs-content-3"><a><%=SystemEnv.getHtmlLabelName(83,user.getLanguage())%></a></li><!-- 日志 -->
				<%}%>
			</ul>
		</div>
	</div>
	
	<div class="e8_right_center">
		<div id="tabs-content-1" class="e8_right_frameContainer">
			<iframe frameborder="0" style="width: 100%;height: 100%;" scrolling="auto" lazy-src="/formmode/setup/browserBase.jsp?appid=<%=appid %>&id=<%=browserId %>">
					
			</iframe>
		</div>
		<%if(browserId>0){ %>
		<div id="tabs-content-2" class="e8_right_frameContainer">
			<iframe frameborder="0" style="width: 100%;height: 100%;" scrolling="no" lazy-src="/formmode/setup/browserField.jsp?id=<%=browserId %>">
					
			</iframe>
		</div>
		<div id="tabs-content-3" class="e8_right_frameContainer">
			<iframe id="logFrame" name="logFrame" frameborder="0" style="width: 100%;height: 100%;" scrolling="auto" lazy-src="/formmode/setup/log.jsp?objid=<%=browserId%>&logmodule=<%=Module.BROWSER %>">
					
			</iframe>
		</div>
		<div id="tabs-content-4" class="e8_right_frameContainer">
			<iframe id="listFrame" name="listFrame" frameborder="0" style="width: 100%;height: 100%;" scrolling="auto" lazy-src="/formmode/setup/browserList.jsp?objid=<%=browserId%>">
					
			</iframe>
		</div>
		<%}%>
	</div>

<script type="text/javascript">
function createbrowser(){
	if(<%=hasTitleField%>){
		var dialogurl = "/systeminfo/BrowserMain.jsp?url=/formmode/browser/CreateBrowser.jsp?customid=<%=browserId%>";
		var dialog = new window.top.Dialog();
		dialog.currentWindow = window;
		dialog.URL = dialogurl;
		dialog.callbackfun = function (paramobj, id1) {
			
		} ;
		dialog.Title = "<%=SystemEnv.getHtmlLabelName(28625,user.getLanguage())%>";//创建浏览框
		dialog.Width = 550 ;
		dialog.Height = 550;
		dialog.Drag = true;
		dialog.show();
	}else{
		Dialog.alert("<%=SystemEnv.getHtmlLabelName(82031,user.getLanguage())%>");//请先为浏览框设置链接字段！
	}
}
</script>
</body>
</html>
