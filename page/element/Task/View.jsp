<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/page/element/viewCommon.jsp"%>
<%@ include file="common.jsp"%>

<!-- 判断元素是否可以独立显示，引入样式 -->
<%
	String indie = Util.null2String(request.getParameter("indie"), "false");
	if ("true".equals(indie)) {
%>
	<%@ include file="/homepage/HpElementCss.jsp" %>
<%	} %>


<%
	String creater = (String)valueList.get(nameList.indexOf("creater"));
	String principalid = (String)valueList.get(nameList.indexOf("principalid"));
	String begindate = (String)valueList.get(nameList.indexOf("begindate"));
	String enddate = (String)valueList.get(nameList.indexOf("enddate"));	
	//System.out.println("eid===="+eid+"\ncreater==="+creater+"\nprincipalid===="+principalid+"\nperpage===="+perpage);
%>
<link rel="stylesheet" href="/page/element/Task/resource/css/task.css">
<link rel="stylesheet" href="/page/element/Task/resource/js/showLoading/css/showLoading.css">
<link rel="stylesheet" type="text/css" href="/page/element/Task/resource/js/shadowbox/shadowbox.css"/>
<div class="taskDiv" id="taskDiv_<%=eid %>">
	<div class="taskTab">
		<div id="tab1_1_<%=eid %>" class="tab1" _index="1" title="<%=SystemEnv.getHtmlLabelName(84045,user.getLanguage())%>"><%=SystemEnv.getHtmlLabelName(84046,user.getLanguage())%></div>
		<div id="tab1_2_<%=eid %>" class="tab1" _index="2" title="<%=SystemEnv.getHtmlLabelName(84047,user.getLanguage())%>"><%=SystemEnv.getHtmlLabelName(84048,user.getLanguage())%></div>
		<div id="tab1_3_<%=eid %>" class="tab1" _index="3" title="<%=SystemEnv.getHtmlLabelName(84050,user.getLanguage())%>"><%=SystemEnv.getHtmlLabelName(15537,user.getLanguage())%></div>
		<div id="tab1_4_<%=eid %>" class="tab1" _index="4" title="<%=SystemEnv.getHtmlLabelName(84053,user.getLanguage())%>"><%=SystemEnv.getHtmlLabelName(22488,user.getLanguage())%></div>
		<%-- <a href="/workrelate/task/data/Add.jsp?saveType=1&eid=<%=eid %>" style="color:#fff !important;"
			rel="shadowbox[taskCreate<%=eid %>];width=600;height=320;">
			<div class="taskBtn"><%=SystemEnv.getHtmlLabelName(83443,user.getLanguage())%></div>
		</a> --%>
		
		<a href="javascript:showAddDialog_<%=eid%>()" style="color:#fff !important;">
			<div class="taskBtn"><%=SystemEnv.getHtmlLabelName(83443,user.getLanguage())%></div>
		</a>
	</div>
	<div class="taskShow" id="taskShow_<%=eid %>"></div>
</div>	
<script type="text/javascript">
	var taskTabTag  = new Array("<%=SystemEnv.getHtmlLabelName(84046,user.getLanguage())%>","<%=SystemEnv.getHtmlLabelName(84048,user.getLanguage())%>","<%=SystemEnv.getHtmlLabelName(15537,user.getLanguage())%>","<%=SystemEnv.getHtmlLabelName(22488,user.getLanguage())%>");
	jQuery(document).ready(function(){
		//Shadowbox.init();
		jQuery("#taskDiv_<%=eid %>").css("height",jQuery("#content_view_id_<%=eid %>").height());
		//TAB切换页操作绑定
		jQuery("#taskDiv_<%=eid %> .tab1").bind("mouseover",function(){
			$(this).addClass("tab1_hover");
		}).bind("mouseout",function(){
			$(this).removeClass("tab1_hover");
		}).bind("click",function(){
			var _index = jQuery(this).attr("_index");
			getTaskList(jQuery(this),_index,"<%=eid%>","<%=perpage%>","<%=creater%>","<%=principalid%>","<%=begindate%>","<%=enddate%>");
		});
	});
	getCount('<%=eid%>');
	
	var diag_xx_<%=eid%> = null;
	function showAddDialog_<%=eid%>() {
		diag_xx_<%=eid%> = new Dialog();
		diag_xx_<%=eid%>.Width = 600;
		diag_xx_<%=eid%>.Height = 320;

		diag_xx_<%=eid%>.ShowCloseButton = true;
		diag_xx_<%=eid%>.Title = "<%=SystemEnv.getHtmlLabelName(15266,user.getLanguage())%>";
		diag_xx_<%=eid%>.Modal = true;

		diag_xx_<%=eid%>.URL = "/workrelate/task/data/Add.jsp?saveType=1&eid=<%=eid %>";
		diag_xx_<%=eid%>.show();
	}
	function closeAddDialog_<%=eid%>() {
		diag_xx_<%=eid%>.close();
		
		jQuery("#taskDiv_<%=eid %>").find("div.tab1_click").click();
	}
	function reloadList_<%=eid%>() {
		jQuery("#taskDiv_<%=eid %>").find("div.tab1_click").click();
	}
</script>