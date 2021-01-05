
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<HTML>
<HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<link type="text/css" rel="stylesheet" href="/css/xtree_wev8.css">
<script type="text/javascript" src="/js/xmlextras_wev8.js"></script>
<script type="text/javascript" src="/js/xtree_wev8.js"></script>
<script type="text/javascript" src="/js/xloadtree_wev8.js"></script>
</head>
<%
if(!(user.getLogintype()).equals("1")) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
   }
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
			<div>
				<span class="leftType"><%=SystemEnv.getHtmlLabelName(17037,user.getLanguage())%><span id="totalDoc"></span></span>
				<span class="leftSearchSpan">
					&nbsp;<input type="text" class="leftSearchInput" style="width:110px;"/>
				</span>
			</div>
		</td>
		<td rowspan="2">
			<iframe src="/hrm/HrmTab.jsp?_fromURL=HrmCustomFieldManager" id="contentframe" name="contentframe" class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
		</td>
	</tr>
	<tr>
		<td style="width:23%;" class="flowMenusTd" >
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
			jQuery.ajax({
				url:"HrmCustomFieldManagerTreeLeft.jsp",
				async: true,
				success:function(data){
					jQuery(".ulDiv").html(data);
					window.setTimeout(function(){
						jQuery(".ulDiv").height(jQuery(".webfx-tree-container").height());
						jQuery('#overFlowDiv').perfectScrollbar();
					},1000);
				}
			  });
			});
	</script>
</BODY></HTML>