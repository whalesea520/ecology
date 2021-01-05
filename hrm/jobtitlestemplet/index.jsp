
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<HTML>
<HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script type="text/javascript" src="/wui/common/jquery/plugin/zTree/js/jquery.ztree.core_wev8.js"></script>
<script type="text/javascript" src="/wui/common/jquery/plugin/zTree/js/jquery.ztree.excheck.min_wev8.js"></script>
<link rel="stylesheet" href="/wui/common/jquery/plugin/zTree/css/zTreeStyle/zTreeStyle_wev8.css" type="text/css">
<script type="text/javascript">
function refreshTreeMain(id,parentId,options){
			var options = jQuery.extend({
				idPrefix:"jobactivities_"
			},options);
			refreshTree(id,parentId,options);
}

function reLoad(){
	window.location.reload();
}
</script>
</head>
<%
String imagefilename = "/images/hdDOC_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(58,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(341,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY scroll="no">
<%@ include file="/systeminfo/leftMenuCommon.jsp" %>
<table cellspacing="0" cellpadding="0" class="flowsTable" style="width:100%;height:100%;"  >
	<tr>
		<td class="leftTypeSearch">
			<div class="topMenuTitle" style="border-bottom:none;">
				<span class="leftType">
					<span><img style="vertical-align:middle;" src="/images/ecology8/request/alltype_wev8.png" width="18"/></span>
					<span id="totalDoc"></span>
					<span onclick="e8InitTreeSearch({ifrms:'#contentframe',formID:'#searchfrm',conditions:'#advancedSearchDiv'});"><%=SystemEnv.getHtmlLabelName(82664,user.getLanguage())%></span>
				</span>
				<span class="leftSearchSpan">
					<input type="text" class="leftSearchInput" style="width:110px;"/>
				</span>
			</div>
		</td>
		<td rowspan="2">
			<iframe src="/hrm/HrmTab.jsp?_fromURL=jobtitlestemplet" id="contentframe" name="contentframe" class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
		</td>
	</tr>
	<tr>
		<td style="width:23%;" class="flowMenusTd">
			<div class="flowMenuDiv"  >
				<div style="overflow:hidden;height:300px;position:relative;" id="overFlowDiv">
					<div class="ulDiv" ></div>
				</div>
			</div>
		</td>
	</tr>
</table>
	
	<script type="text/javascript">
	jQuery(document).ready(function(){
		e8_initTree("indexTreeLeft.jsp");
	});
	
	function e8_custom_search_for_tree(categoryname,data){
			
		var condition = $(".leftSearchInput").val();		
		condition = encodeURI(encodeURI(condition));
		e8_after();
		e8_initTree("indexTreeLeft.jsp?condition="+condition);
	}
	
	
	</script>
</BODY></HTML>