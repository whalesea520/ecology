<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util"%>
<%@ page import="weaver.formmode.service.FormInfoService"%>
<%@page import="weaver.formmode.Module"%>
<%@page import="weaver.formmode.service.LogService"%>
<%@page import="weaver.formmode.virtualform.VirtualFormHandler"%>
<%@ include file="/formmode/pub.jsp"%>
<%
	if (!HrmUserVarify.checkUserRight("ModeSetting:All", user)) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
%>
<%
int formId = Util.getIntValue(request.getParameter("id"), Integer.MIN_VALUE);
int appId = Util.getIntValue(request.getParameter("appId"));
FormInfoService formInfoService = new FormInfoService();
Map<String, Object> data = formInfoService.getFormInfoById(formId);
String formName = Util.null2String(data.get("labelname"));
String tableName = Util.null2String(data.get("tablename"));

boolean isCreate = (formId == Integer.MIN_VALUE);
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
			font-size: 15px;
			color: #A3A3A3;
			padding: 1px;
			text-decoration: none;
			cursor: pointer;
			border-bottom: 2px solid #fff;
		}
		.e8_digit{
			float: right;
			background: url(/formmode/images/circleBg_wev8.png) no-repeat 1px 1px;
			width: 10px; 
			height: 13px;
			padding: 1px 0 0 4px;
			margin-left: -1px;
			font-family: Tahoma;
			font-size: 9px;
			font-style: italic;
			color: #333;
		}
		.e8_digit_selected{
			float: right;
			background: url(/formmode/images/circleBgBlue_wev8.png) no-repeat 1px 1px;
			width: 10px; 
			height: 13px;
			padding: 1px 0 0 4px;
			margin-left: -1px;
			font-family: Tahoma;
			font-size: 9px;
			font-style: italic;
			color: #fff;
		}
		.e8_form_top ul li.selected a{
			color: #0072C6;		
			border-bottom: 2px solid #0072C6;
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
			setTabDigit();
			if(<%=VirtualFormHandler.isVirtualForm(formId)%>){
				var lastindex = FormmodeUtil.readCookie(window.location.pathname);
				var e8_form_tabs_ul_li = $(".e8_form_tabs").find("ul").find("li").not("li[defaultSelected='true']");
				if(lastindex && lastindex <= e8_form_tabs_ul_li.length){
					if(!e8_form_tabs_ul_li.eq(lastindex-1).is(":visible")){
						$(".e8_form_tabs").find("ul").find("li").eq(0).click();
					}
				}
			}
		});
		
		function forPageResize(){
			var $body = $(document.body);
			var $e8_form_top = $(".e8_form_top");
			var $e8_form_center = $(".e8_form_center");
			
			var centerHeight = $body.height() - $e8_form_top.outerHeight(true);
			
			$e8_form_center.height(centerHeight);
		}
		
		//加载标签页上的数字统计
		function setTabDigit(){
			var url = "/weaver/weaver.formmode.servelt.FormInfoAction?action=getFormInfoTabDigit&id=<%=formId%>";
			FormmodeUtil.doAjaxDataLoad(url, function(d){
				if(d.indexes>0){
					$("li[href='#tabs-content-4']").append("<div class='e8_digit'>"+d.indexes+"</div>");
				}
			});
		}
	</script>
</head>
  
<body>
	<div class="e8_form_top">
		<div style="width:40px;float:left;margin:2px 10px 0 0;"><img src="/formmode/images/formIconRounded_wev8.png" /></div>
		<div class="e8_from_info">
			<div class="e8_from_name"><!-- 表单 -->
				<%=SystemEnv.getHtmlLabelName(19532,user.getLanguage())%> / <%=formName %> <!-- - <%=tableName %> -->
			</div>
			<div class="e8_from_modify">
				<%LogService logService = new LogService(); %>
				<%=SystemEnv.getHtmlLabelName(82013,user.getLanguage())%>：<%=logService.getLastOptTime(formId, Module.FORM) %><!-- 最后编辑时间 -->
			</div>
		</div>
		<div class="e8_form_tabs">
			<ul>
				<li href="#tabs-content-1" defaultSelected="true"><a><%=SystemEnv.getHtmlLabelName(81990,user.getLanguage())%><!-- 基础 --></a></li>
				<%if(!isCreate){%>
				<li href="#tabs-content-2"><a><%=SystemEnv.getHtmlLabelName(261,user.getLanguage())%><!-- 字段 --></a></li>
				<li href="#tabs-content-3" style="display: none;"><a><%=SystemEnv.getHtmlLabelName(19407,user.getLanguage())%><!-- 布局 --></a></li>
				<li href="#tabs-content-4" <%if(VirtualFormHandler.isVirtualForm(formId)){%>style="display:none;"<%}%>><a><%=SystemEnv.getHtmlLabelName(31643,user.getLanguage())%><!-- 索引 --></a></li>
				<li href="#tabs-content-5"><a><%=SystemEnv.getHtmlLabelName(83,user.getLanguage())%><!-- 日志 --></a></li>
				<%} %>
			</ul>
		</div>
	</div>
	
	<div class="e8_form_center">
		<div id="tabs-content-1" class="e8_form_frameContainer">
			<%
				String url = isCreate ? "/formmode/setup/formAdd.jsp?appId="+appId : "/formmode/setup/formbase.jsp?id=" + formId;
			%>
			<iframe id="formbaseFrame" name="formbaseFrame" frameborder="0" style="width: 100%;height: 100%;" scrolling="no" lazy-src="<%=url %>">
					
			</iframe>
		</div>
		<%if(!isCreate){%>
		<div id="tabs-content-2" class="e8_form_frameContainer">
			<iframe id="formfieldFrame" name="formfieldFrame" frameborder="0" style="width: 100%;height: 100%;" scrolling="no" lazy-src="/formmode/setup/formfield.jsp?id=<%=formId %>">
					
			</iframe>
		</div>
		<div id="tabs-content-3" class="e8_form_frameContainer">
			<iframe id="formlayoutFrame" name="formlayoutFrame" frameborder="0" style="width: 100%;height: 100%;" scrolling="auto" lazy-src="/formmode/setup/formlayout.jsp?id=<%=formId %>">
					
			</iframe>
		</div>
		<div id="tabs-content-4" class="e8_form_frameContainer">
			<iframe id="formlogFrame" name="formlogFrame" frameborder="0" style="width: 100%;height: 100%;" scrolling="auto" lazy-src="/formmode/setup/formIndex.jsp?formId=<%=formId %>">
					
			</iframe>
		</div>
		<div id="tabs-content-5" class="e8_form_frameContainer">
			<iframe id="logFrame" name="logFrame" frameborder="0" style="width: 100%;height: 100%;" scrolling="auto" lazy-src="/formmode/setup/log.jsp?objid=<%=formId%>&logmodule=<%=Module.FORM %>">
					
			</iframe>
		</div>
		<%} %>
	</div>
</body>
</html>
