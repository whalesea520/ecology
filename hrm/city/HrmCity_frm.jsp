
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<!-- added by wcd 2014-07-15 [E7 to E8] -->
<%
	String pid = Util.null2String(request.getParameter("pid"));
%>
<HTML>
	<HEAD>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<script type="text/javascript" src="/wui/common/jquery/plugin/zTree/js/jquery.ztree.core_wev8.js"></script>
		<link rel="stylesheet" href="/wui/common/jquery/plugin/zTree/css/zTreeStyle/zTreeStyle_wev8.css" type="text/css">
		<script type="text/javascript">
			function refreshTreeMain(id,parentId,options){
				var options = jQuery.extend({
					idPrefix:"province_"
				},options);
				refreshTree(id,parentId,options);
			}
			function initTree(){
				
			}
		</script>
	</HEAD>
	<body scroll="no">
		<%@ include file="/systeminfo/leftMenuCommon.jsp" %>
		<table cellspacing="0" cellpadding="0" class="flowsTable" style="width:100%;"  >
			<tr>
				<td class="leftTypeSearch">
					<div class="topMenuTitle" style="border:none;">
						<span class="leftType" onclick="initTree();">
						<span><img style="vertical-align:middle;" src="/images/ecology8/request/alltype_wev8.png" width="18"/></span>
						<span><%=SystemEnv.getHtmlLabelNames("800",user.getLanguage())%></span>
						<span id="totalDoc"></span>
						</span>
						<span class="leftSearchSpan">
							<input type="text" class="leftSearchInput" style="width:110px;"/>
						</span>
					</div>
					
				</td>
				<td rowspan="2">
					<iframe src="/hrm/HrmTab.jsp?_fromURL=hrmCity&provinceid=<%=pid%>" id="contentframe" name="contentframe" class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
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
				e8_initTree("/hrm/city/HrmCity_left.jsp?pid=<%=pid%>");
			});
		</script>
	</body>
</html>