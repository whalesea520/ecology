
<%@ page language="java" contentType="text/html; charset=UTF-8" %>


<%@ include file="/systeminfo/init_wev8.jsp" %>

<%
String imagefilename = "/images/hdHRM_wev8.gif";
String titlename = "";
String needfav ="1";
String needhelp ="";

String treeDocFieldId=Util.null2String(request.getParameter("treeDocFieldId"));
String err=Util.null2String(request.getParameter("err"));

%>


<HTML><HEAD>
<script type="text/javascript" src="/wui/common/jquery/plugin/zTree/js/jquery.ztree.core_wev8.js"></script>
	<script type="text/javascript" src="/js/jquery/plugins/client/jquery.client_wev8.js"></script>
	<link rel="stylesheet" href="/wui/common/jquery/plugin/zTree/css/zTreeStyle/zTreeStyle_wev8.css" type="text/css">
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script type="text/javascript">
	function refreshTreeMain(id,parentId,options){
		var options = jQuery.extend({
			idPrefix:"field_"
		},options);
		refreshTree(id,parentId,options);
	}
</script>
</HEAD>
<body scroll="no">
<%@ include file="/systeminfo/leftMenuCommon.jsp" %>
<table cellspacing="0" cellpadding="0" class="flowsTable" style="width:100%;"  >
	<tr>
		<td class="leftTypeSearch">
			<div>
				<span class="leftType">
				<span><img style="vertical-align:middle;" src="/images/ecology8/request/alltype_wev8.png" width="18"></span>
				<span><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></span><span id="totalDoc"></span></span>
				<span class="leftSearchSpan">
					<input type="text" class="leftSearchInput" style="width:110px;"/>
				</span>
			</div>
		</td>
		<td rowspan="2">
			<iframe src="" id="contentframe" name="contentframe" class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
		</td>
	</tr>
	<tr>
		<td style="width:23%;" class="flowMenusTd">
			<div class="flowMenuDiv"  >
				<!--<div class="flowMenuAll"><span class="allText">全部&nbsp;</span></div>-->
				<div style="overflow:hidden;height:300px;position:relative;" id="overFlowDiv">
					<div class="ulDiv" ></div>
				</div>
			</div>
		</td>
	</tr>
</table>
	
	<script type="text/javascript">
		jQuery(document).ready(function(){
			e8_initTree("DocTreeDocFieldLeft.jsp?treeDocFieldId=<%=treeDocFieldId%>&err=<%=err%>");
		});
	</script>
<!-- 
<TABLE class=viewform width=100% id=oTable1 height=100% cellpadding="0px" cellspacing="0px">
  
  <TBODY>
<tr><td  height=100% id=oTd1 name=oTd1 width="220px" style=’padding:0px’>
<IFRAME name=leftframe id=leftframe src="DocTreeDocFieldLeft.jsp?treeDocFieldId=<%=treeDocFieldId%>&err=<%=err%>" width="100%" height="100%" frameborder=no scrolling=auto>
<%=SystemEnv.getHtmlLabelName(15017,user.getLanguage())%></IFRAME>
</td>
<td height=100% id=oTd0 name=oTd0 width="10px" style=’padding:0px’>
<IFRAME name=middleframe id=middleframe   src="/framemiddle.jsp" width="100%" height="100%" frameborder=no scrolling=no noresize>
<%=SystemEnv.getHtmlLabelName(15017,user.getLanguage())%></IFRAME>
</td>
<td height=100% id=oTd2 name=oTd2 width="*" style=’padding:0px’>
<IFRAME name=contentframe id=contentframe src="DocTreeDocFieldRight.jsp" width="100%" height="100%" frameborder=no scrolling=yes>
<%=SystemEnv.getHtmlLabelName(15017,user.getLanguage())%></IFRAME>
</td>
</tr>
  </TBODY>
</TABLE> -->
 </body>

</html>
