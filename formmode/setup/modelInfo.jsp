<%@page import="weaver.formmode.virtualform.VirtualFormHandler"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="weaver.formmode.service.ModelInfoService"%>
<%@page import="weaver.formmode.service.LogService"%>
<%@page import="weaver.formmode.Module"%>
<%@ include file="/formmode/pub.jsp"%>
<%@ page import="weaver.general.Util"%>
<%
	if (!HrmUserVarify.checkUserRight("ModeSetting:All", user)) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
%>
<%
int modelId = Util.getIntValue(request.getParameter("id"), 0);
int appId = Util.getIntValue(request.getParameter("appId"), 0);
ModelInfoService modelInfoService = new ModelInfoService();
Map<String, Object> data = modelInfoService.getModelInfoById(modelId);
String modename = Util.null2String(data.get("modename"));
String modedesc = Util.null2String(data.get("modedesc"));
int formId = Util.getIntValue(Util.null2String(data.get("formid")),0);
boolean isVirtualForm = VirtualFormHandler.isVirtualForm(formId);
String isVirtualFormParam = "&isVirtualForm="+isVirtualForm;

int subCompanyId = Util.getIntValue(Util.null2String(data.get("subCompanyId")),-1);
String userRightStr = "ModeSetting:All";
Map rightMap = getCheckRightSubCompanyParam(userRightStr,user,fmdetachable, subCompanyId,"",request,response,session);
int operatelevel = Util.getIntValue(Util.null2String(rightMap.get("operatelevel")),-1);
subCompanyId = Util.getIntValue(Util.null2String(rightMap.get("subCompanyId")),-1);
String subCompanyId2 = ""+subCompanyId;

%>
<html>
<head>
	<title></title>
	<link rel="stylesheet" type="text/css" href="/formmode/js/ext/resources/css/ext-all_wev8.css" />
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
			overflow: hidden;
		}
		.e8_form_top_body{
			overflow: hidden;border-bottom:1px solid #e9e9e9;
		}
		.e8_form_top .e8_from_info{
			width:300px;
			float:left;
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
		.e8_form_top .e8_form_tabs{
			float:left;
			margin-top:22px;
		}
		.e8_form_top ul{
			list-style: none;
			white-space: nowrap;
			overflow:hidden;
			float:right;
		}
		.e8_form_top ul li{
			padding: 0px 5px 0px 5px;
			display:inline-block;
			float:left;
			height:22px;
		}
		.e8_form_top ul li a{
			font-size: 15px;
			color: #A3A3A3;
			text-decoration: none;
			cursor: pointer;
			height:20px;
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
		.loading{
		    position:absolute;
		    left:45%;
		    background:#ffffff;
		    top:40%;
		    padding:8px;
		    z-index:20001;
		    height:auto;
		    border:1px solid #ccc;
		}
		.e8_from_logo{
			width:40px;
			float:left;
			margin:2px 10px 0 0;
		}
		.e8_form_tabs_button{
			width:18px;
			height:18px;
			float: right;
			margin-top:24px;
			background: url("/images/ecology8/request/cornerMenu_wev8.png") no-repeat;
			cursor:pointer;
			display:none;
		}
		.e8_form_tabs_more{
			position:absolute;
			background:#fffff;
			z-index:20001;
			border:1px solid #ccc;
			top:60px;
			right:10px;
			width: 120px;
			display: none;
		}
		
		.e8_form_tabs_more ul{
			list-style: none;
			background-color:#ffffff;
		}
		
		.e8_form_tabs_more ul li:hover{
			background-color:#E6E6E6 !important;
		}
		
		.e8_form_tabs_more ul li.selected{
			background-color:#E8F2FE;
		}
		
		.e8_form_tabs_more ul li a{
			font-size: 15px;
			color: #A3A3A3;
			padding: 5px;
			text-decoration: none;
			cursor: pointer;
		}
		
		.e8_form_tabs_more ul li.selected a{
			color: #0072C6;
		}
	</style>
	<script type="text/javascript">
		
		$(document).ready(function () {
			$(".e8_form_tabs").simpleTabs();
			$(window).resize(forPageResize);
			forPageResize();
			
			<%if(modelId>0){ %>
			setTabDigit();
			<%}%>
			$(".e8_form_tabs_button").hover(function(){
				$(".e8_form_tabs_more").slideDown(100);
				$(".e8_form_tabs_button").data("isOpen",true);
			},function(){
				$(".e8_form_tabs_button").data("isOpen",false);
				window.setTimeout(function(){
					if(!$(".e8_form_tabs_button").data("isOpen")){
						$(".e8_form_tabs_more").slideUp(100);
					}
				},600);
			})
			
			$(".e8_form_tabs_more").hover(function(){
				$(".e8_form_tabs_button").data("isOpen",true);
			},function(){
				$(".e8_form_tabs_button").data("isOpen",false);
				window.setTimeout(function(){
					if(!$(".e8_form_tabs_button").data("isOpen")){
						$(".e8_form_tabs_more").slideUp(100);
					}
				},600);
			})
		});
		
		function forPageResize(){
			var $body = $(document.body);
			setTimeout(function(){
				var $e8_form_top = $(".e8_form_top");
				var $e8_form_center = $(".e8_form_center");
				var centerHeight = $body.height() - $e8_form_top.outerHeight(true);
				$e8_form_center.height(centerHeight);
			},300);
			changeTabsWidth();
		}
		
		function changeTabsWidth(){
			var $body = $(document.body);
			var $e8_from_logo=$(".e8_from_logo");
			var $e8_from_info=$(".e8_from_info");
			var $e8_form_tabs_button=$(".e8_form_tabs_button");
			var buttonWidth=$e8_form_tabs_button.outerWidth(true);
			var tabsWidth=$body.width()-$e8_from_logo.outerWidth(true)-$e8_from_info.outerWidth(true)-20-5;
			if(tabsWidth<buttonWidth){
				tabsWidth=buttonWidth;
			}
			var hasRemoveTabs=removeTabs(tabsWidth);
			if(!hasRemoveTabs){
				retrieveTabs(tabsWidth);
			}
		}
		
		function removeTabs(tabsWidth){
			var $e8_form_tabs=$(".e8_form_tabs");
			var $e8_form_tabs_more_ul=$(".e8_form_tabs_more ul");
			var $e8_form_tabs_button=$(".e8_form_tabs_button");
			var buttonWidth=$e8_form_tabs_button.outerWidth(true);
			var $ul_temp=$("<ul></ul>");
			var lisWidth=0;
			var endflag=false;
			$(".e8_form_tabs ul li").each(function(){
				var liWidth=$(this).outerWidth(true);
				$(this).attr("liwidth",liWidth);
				lisWidth+=liWidth;
				if(endflag){
					$ul_temp.append($(this));
				}else if((tabsWidth<=buttonWidth)||tabsWidth<(buttonWidth+lisWidth)){
					endflag=true;
					$ul_temp.append($(this));
				}
			})
			if(endflag){
				$e8_form_tabs_more_ul.prepend($ul_temp.children("li"));
				$e8_form_tabs_button.show();
				$e8_form_tabs.width(tabsWidth-buttonWidth);
			}
			return endflag;
		}
		
		function retrieveTabs(tabsWidth){
			var $e8_form_tabs=$(".e8_form_tabs");
			var $e8_form_tabs_ul=$(".e8_form_tabs ul");
			var $e8_form_tabs_button=$(".e8_form_tabs_button");
			var buttonWidth=$e8_form_tabs_button.outerWidth(true);
			var lisWidth=0;
			$(".e8_form_tabs ul li").each(function(){
				lisWidth+=$(this).outerWidth(true);
			})
			var buttonHidden=false;
			var moreLiSize=$(".e8_form_tabs_more ul li").size();
			$(".e8_form_tabs_more ul li").each(function(i){
				var liWidth=$(this).attr("liwidth");
				lisWidth+=parseInt(liWidth);
				if((lisWidth+buttonWidth)<=tabsWidth){
					$e8_form_tabs_ul.append($(this));
					if(i==moreLiSize-1){
						buttonHidden=true;
					}
				}else if(lisWidth<=tabsWidth&&i==moreLiSize-1){
					$e8_form_tabs_ul.append($(this));
					buttonHidden=true;
				}
			})
			if(buttonHidden){
				$e8_form_tabs.width(tabsWidth);
				$e8_form_tabs_button.hide();
			}else if(lisWidth<=tabsWidth){
				$e8_form_tabs.width(tabsWidth);
			}else{
				$e8_form_tabs.width(tabsWidth-buttonWidth);
			}
		}
		
		//加载标签页上的数字统计
		function setTabDigit(){
			var url = "/weaver/weaver.formmode.servelt.ModelInfoAction?action=getModelInfoTabDigit&id=<%=modelId%>";
			FormmodeUtil.doAjaxDataLoad(url, function(d){
				if(d.defaultvalue>0){
					$("li[href='#tabs-content-2']").append("<div class='e8_digit'>"+d.defaultvalue+"</div>");
				}
				if(d.linkageattr>0){
					$("li[href='#tabs-content-4']").append("<div class='e8_digit'>"+d.linkageattr+"</div>");
				}
				if(d.linkagefield>0){
					$("li[href='#tabs-content-5']").append("<div class='e8_digit'>"+d.linkagefield+"</div>");
				}
				if(d.modetoworkflow>0){
					$("li[href='#tabs-content-6']").append("<div class='e8_digit'>"+d.modetoworkflow+"</div>");
				}
				if(d.workflowtomode>0){
					$("li[href='#tabs-content-7']").append("<div class='e8_digit'>"+d.workflowtomode+"</div>");
				}
				if(d.modeexpand>0){
					$("li[href='#tabs-content-8']").append("<div class='e8_digit'>"+d.modeexpand+"</div>");
				}
				if(d.modecode>0){
					$("li[href='#tabs-content-9']").append("<div class='e8_digit'>"+d.modecode+"</div>");
				}
			});
		}
	</script>
</head>
  
<body>
	<div class="e8_form_tabs_more">
		<ul></ul>
	</div>
    <div class="loading" >
		<span><img src="/images/loadingext_wev8.gif" align="absmiddle"></span>
		<span id="loading-msg"><%=SystemEnv.getHtmlLabelName(19945,user.getLanguage())%></span>
	</div>
	<div class="e8_form_top">
		<div class="e8_form_top_body">
		<div class="e8_from_logo"><img src="/formmode/images/modelIconRounded_wev8.png" /></div>
		<div class="e8_from_info">
			<div class="e8_from_name">
				<%=SystemEnv.getHtmlLabelName(19049,user.getLanguage())%> / <%=modename%><!-- 模块 -->
			</div>
			<div class="e8_from_modify">
				<%LogService logService = new LogService(); %>
				<%=SystemEnv.getHtmlLabelName(82013,user.getLanguage())%>：<%=logService.getLastOptTime(modelId, Module.MODEL) %><!-- 最后编辑时间 -->
			</div>
		</div>
		<div class="e8_form_tabs">
			<ul>
				<li href="#tabs-content-1" defaultSelected="true"><a><%=SystemEnv.getHtmlLabelName(81990,user.getLanguage())%><!-- 基础 --></a></li>
				<%if(modelId>0){ %>
				<li href="#tabs-content-12"><a><%=SystemEnv.getHtmlLabelName(19407,user.getLanguage())%><!-- 布局 --></a></li>
				<li href="#tabs-content-2"><a><%=SystemEnv.getHtmlLabelName(385,user.getLanguage())%><!-- 权限 --></a></li>
				<li href="#tabs-content-3"><a><%=SystemEnv.getHtmlLabelName(19206,user.getLanguage())%><!-- 默认值 --></a></li>
				<li href="#tabs-content-4"><a><%=SystemEnv.getHtmlLabelName(28477,user.getLanguage())%><!-- 属性联动 --></a></li>
				<%if(!isVirtualForm){  //虚拟表单隐藏 %>
				<li href="#tabs-content-5"><a><%=SystemEnv.getHtmlLabelName(21848,user.getLanguage())%><!-- 字段联动 --></a></li>
				<li href="#tabs-content-13"><a><%=SystemEnv.getHtmlLabelName(82471,user.getLanguage())%><!-- 数据关联授权 --></a></li>
				<li href="#tabs-content-6"><a><%=SystemEnv.getHtmlLabelName(30056,user.getLanguage())%><!-- 数据审批 --></a></li>
				<li href="#tabs-content-7"><a><%=SystemEnv.getHtmlLabelName(30055,user.getLanguage())%><!-- 流程转数据 --></a></li>
				<li href="#tabs-content-11"><a><%=SystemEnv.getHtmlLabelName(26601,user.getLanguage())%><!-- 批量导入 --></a></li>
				<%}%>
				<li href="#tabs-content-8"><a><%=SystemEnv.getHtmlLabelName(30090,user.getLanguage())%><!-- 页面扩展 --></a></li>
				<%if(!isVirtualForm){ %>
				<li href="#tabs-content-9"><a><%=SystemEnv.getHtmlLabelName(1321,user.getLanguage())%><!-- 编码 --></a></li>
				<%} %>
				<li href="#tabs-content-14"><a><%=SystemEnv.getHtmlLabelName(30184,user.getLanguage())%><!-- 二维码 --></a></li>
				<li href="#tabs-content-15"><a><%=SystemEnv.getHtmlLabelName(1362, user.getLanguage()) %><!-- 条形码 --></a></li>
				<li href="#tabs-content-10"><a><%=SystemEnv.getHtmlLabelName(83,user.getLanguage())%><!-- 日志 --></a></li>
				<%} %>
			</ul>
		</div>
		<div class="e8_form_tabs_button"></div>
		</div>
	</div>
	
	<div class="e8_form_center">
		<div id="tabs-content-1" class="e8_form_frameContainer">
			<iframe id="formfieldFrame" name="formfieldFrame" frameborder="0" style="width: 100%;height: 100%;" scrolling="auto" lazy-src="/formmode/setup/modelAdd.jsp?id=<%=modelId %>&formId=<%=formId %>&appId=<%=appId %><%=isVirtualFormParam%>">
					
			</iframe>
		</div>
		<%if(modelId>0){ %>
		<div id="tabs-content-12" class="e8_form_frameContainer">
			<iframe id="formlogFrame" name="formlogFrame" frameborder="0" style="width: 100%;height: 100%;" scrolling="auto" lazy-src="/formmode/setup/FormModeHtmlList.jsp?id=<%=modelId %>&formId=<%=formId %>">
					
			</iframe>
		</div>
		<div id="tabs-content-2" class="e8_form_frameContainer">
			<iframe id="formlogFrame" name="formlogFrame" frameborder="0" style="width: 100%;height: 100%;" scrolling="auto" lazy-src="/formmode/setup/ModeRightEdit.jsp?id=<%=modelId %>&formId=<%=formId %><%=isVirtualFormParam%>">
					
			</iframe>
		</div>
		<div id="tabs-content-3" class="e8_form_frameContainer">
			<iframe id="formlogFrame" name="formlogFrame" frameborder="0" style="width: 100%;height: 100%;" scrolling="auto" lazy-src="/formmode/setup/modelDefaultValue.jsp?id=<%=modelId %>&formId=<%=formId %><%=isVirtualFormParam%>">
					
			</iframe>
		</div>
		<div id="tabs-content-4" class="e8_form_frameContainer">
			<iframe id="formlogFrame" name="formlogFrame" frameborder="0" style="width: 100%;height: 100%;" scrolling="auto" lazy-src="/formmode/setup/modelLinkage.jsp?id=<%=modelId %>&formid=<%=formId %><%=isVirtualFormParam%>">
					
			</iframe>
		</div>
		<div id="tabs-content-5" class="e8_form_frameContainer">
			<iframe id="formlogFrame" name="formlogFrame" frameborder="0" style="width: 100%;height: 100%;" scrolling="auto" lazy-src="/formmode/setup/fieldTrigger.jsp?id=<%=modelId %>&formid=<%=formId %><%=isVirtualFormParam%>">
					
			</iframe>
		</div>
		<div id="tabs-content-13" class="e8_form_frameContainer">
			<iframe id="formlogFrame" name="formlogFrame" frameborder="0" style="width: 100%;height: 100%;" scrolling="auto" lazy-src="/formmode/setup/fieldauthorize.jsp?id=<%=modelId %>&formid=<%=formId %><%=isVirtualFormParam%>">
					
			</iframe>
		</div>
		<div id="tabs-content-6" class="e8_form_frameContainer">
			<iframe id="formlogFrame" name="formlogFrame" frameborder="0" style="width: 100%;height: 100%;" scrolling="auto" lazy-src="/formmode/interfaces/ModeTriggerWorkflowSet.jsp?id=<%=modelId %>&formId=<%=formId %><%=isVirtualFormParam%>">
					
			</iframe>
		</div>
		<div id="tabs-content-7" class="e8_form_frameContainer">
			<iframe id="formlogFrame" name="formlogFrame" frameborder="0" style="width: 100%;height: 100%;" scrolling="auto" lazy-src="/formmode/interfaces/WorkflowToModeList.jsp?id=<%=modelId %>&formId=<%=formId %><%=isVirtualFormParam%>">
					
			</iframe>
		</div>
		<div id="tabs-content-11" class="e8_form_frameContainer">
			<iframe id="formlogFrame" name="formlogFrame" frameborder="0" style="width: 100%;height: 100%;" scrolling="auto" lazy-src="/formmode/interfaces/ModeDataBatchImport.jsp?modeid=<%=modelId %>&sourcetype=1&formId=<%=formId %><%=isVirtualFormParam%>">
					
			</iframe>
		</div>
		<div id="tabs-content-8" class="e8_form_frameContainer">
			<iframe id="expandFrame" name="expandFrame" frameborder="0" style="width: 100%;height: 100%;" scrolling="auto" lazy-src="/formmode/setup/expandList.jsp?modeid=<%=modelId %><%=isVirtualFormParam%>">
					
			</iframe>
		</div>
		<div id="tabs-content-9" class="e8_form_frameContainer">
			<iframe id="formlogFrame" name="formlogFrame" frameborder="0" style="width: 100%;height: 100%;" scrolling="auto" lazy-src="/formmode/setup/ModeCode.jsp?id=<%=modelId %>&formId=<%=formId %><%=isVirtualFormParam%>">
					
			</iframe>
		</div>
		<div id="tabs-content-14" class="e8_form_frameContainer">
			<iframe id="QRCodeFrame" name="QRCodeFrame" frameborder="0" style="width: 100%;height: 100%;" scrolling="auto" lazy-src="/formmode/setup/QRCode.jsp?id=<%=modelId %>&formId=<%=formId %><%=isVirtualFormParam%>">
					
			</iframe>
		</div>
		<div id="tabs-content-15" class="e8_form_frameContainer">
			<iframe id="QRCodeFrame" name="QRCodeFrame" frameborder="0" style="width: 100%;height: 100%;" scrolling="auto" lazy-src="/formmode/setup/BarCode.jsp?id=<%=modelId %>&formId=<%=formId %><%=isVirtualFormParam%>">
					
			</iframe>
		</div>
		<div id="tabs-content-10" class="e8_form_frameContainer">
			<iframe id="logFrame" name="logFrame" frameborder="0" style="width: 100%;height: 100%;" scrolling="auto" lazy-src="/formmode/setup/log.jsp?objid=<%=modelId%>&logmodule=<%=Module.MODEL %><%=isVirtualFormParam%>">
					
			</iframe>
		</div>
		<%} %>
	</div>
</body>
</html>
