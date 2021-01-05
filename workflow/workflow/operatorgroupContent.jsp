
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<HTML>
<HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
<link rel="stylesheet" href="/css/ecology8/request/searchInput_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/searchInput_wev8.js"></script>

<link rel="stylesheet" href="/css/ecology8/request/seachBody_wev8.css" type="text/css" />
<link rel="stylesheet" href="/css/ecology8/request/hoverBtn_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/hoverBtn_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/request/titleCommon_wev8.js"></script>
<%
	String wfid = Util.null2String(request.getParameter("wfid"));
	String nodeid = Util.null2String(request.getParameter("nodeid"));
	String formid = Util.null2String(request.getParameter("formid"));
	String isbill = Util.null2String(request.getParameter("isbill"));
	String iscust = Util.null2String(request.getParameter("iscust"));
	String id = Util.null2String(request.getParameter("id"));
%>
<script type="text/javascript">
$(function() {
	$('.e8_box').Tabs({
		getLine : 1,
		iframe : "tabcontentframe",
		mouldID:"<%= MouldIDConst.getID("workflow")%>",
		staticOnLoad:true,
		objName:"<%=SystemEnv.getHtmlLabelName(15072,user.getLanguage())%>"
	});
	attachUrl();
});


function attachUrl()
{
	if("<%=id%>" === "")
		$("[name='tabcontentframe']").attr("src","/workflow/workflow/addoperatorgroup.jsp?ajax=1&wfid=<%=wfid%>&nodeid=<%=nodeid%>&formid=<%=formid%>&isbill=<%=isbill%>&iscust=<%=iscust%>");
	else
		$("[name='tabcontentframe']").attr("src","/workflow/workflow/editoperatorgroup.jsp?ajax=1&wfid=<%=wfid%>&nodeid=<%=nodeid%>&formid=<%=formid%>&isbill=<%=isbill%>&iscust=<%=iscust%>&id=<%=id%>");
}

</script>
</HEAD>
<BODY>
<div class="e8_box demo2">
	<div class="e8_boxhead">
		<div class="div_e8_xtree" id="div_e8_xtree"></div>
        <div class="e8_tablogo" id="e8_tablogo"></div>
		<div class="e8_ultab">
			<div class="e8_navtab" id="e8_navtab">
				<span id="objName"></span>
			</div>
			<div>
				<ul class="tab_menu">
				</ul>
				<div id="rightBox" class="e8_rightBox"></div>
			</div>
		</div>
	</div>
	<div class="tab_box"><div>
	<iframe src="" onload="update();" id="tabcontentframe" name="tabcontentframe" class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
</div> 
</BODY>
</HTML>