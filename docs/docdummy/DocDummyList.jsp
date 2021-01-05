
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<script type="text/javascript" src="/wui/common/jquery/plugin/zTree/js/jquery.ztree.core_wev8.js"></script>
	<link rel="stylesheet" href="/wui/common/jquery/plugin/zTree/css/zTreeStyle/zTreeStyle_wev8.css" type="text/css">	
</head>
<body  scroll="no">
<div style="display:none;" id="menuStr">
	
</div>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
	<%
	int dummyId = Util.getIntValue(request.getParameter("dummyId"),1);
	%>
	<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
	
<%@ include file="/systeminfo/leftMenuCommon.jsp" %>
	
	
	<table cellspacing="0" cellpadding="0" class="flowsTable" style="width:100%;"  >
	<tr>
		<td class="leftTypeSearch">
			<div>
				<span class="leftType">
				<span><img style="vertical-align:middle;" src="/images/ecology8/request/alltype_wev8.png" width="18"/></span>	
				<span style="cursor:pointer;" onclick="e8InitTreeSearch({ifrms:'#contentframe,#tabcontentframe',formID:'#frmSubscribleHistory',conditions:'#dummyId'});">
				<span><%=SystemEnv.getHtmlLabelName(332,user.getLanguage()) %></span>
				<span id="totalDoc"></span>
				</span>
				</span>
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
			jQuery.ajax({
					url:"DocDummyLeft.jsp?dummyId=<%=dummyId%>",
					success:function(data){
						jQuery(".ulDiv").html(data);
						window.setTimeout(function(){
							jQuery(".ulDiv").height(jQuery("#ztreeDiv").height());
							jQuery('#overFlowDiv').perfectScrollbar("update");
						},1000);
					}
				});
			});
	</script>
	
	
	<!-- <TABLE class=viewform width=100% id=oTable1 height=100% cellpadding="0px" cellspacing="0px">
	  <TBODY>
	<tr><td  height=100% id=oTd1 name=oTd1 width="220"  style="padding:0px" class="field">
	<IFRAME name=leftframe id=leftframe src="DocDummyLeft.jsp?dummyId=<%=dummyId%>" width="100%" height="100%" frameborder=no scrolling=yes>
	<%=SystemEnv.getHtmlLabelName(15017,user.getLanguage())%></IFRAME>
	</td>
	
	<td height=100% id=oTd2 name=oTd2 width="*"  style="padding:0px"  class="field">
	<IFRAME name=contentframe id=contentframe src="" width="100%" height="100%" frameborder=no scrolling=yes>
	<%=SystemEnv.getHtmlLabelName(15017,user.getLanguage())%></IFRAME>
	</td>
	</tr>
	  </TBODY>
	</TABLE> -->
</body>
</html>