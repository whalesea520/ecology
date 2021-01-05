
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
<link rel="stylesheet" href="/css/ecology8/request/searchInput_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/searchInput_wev8.js"></script>

<link rel="stylesheet" href="/css/ecology8/request/seachBody_wev8.css" type="text/css" />
<link rel="stylesheet" href="/css/ecology8/request/hoverBtn_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/hoverBtn_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/request/titleCommon_wev8.js"></script>
<% String id = Util.null2String(request.getParameter("id")); 
	String ishowname = Util.null2String(request.getParameter("ishowname"),"1"); 
%>
<script type="text/javascript">
var id = "<%=id%>";
$(function() {
	$('.e8_box').Tabs({
		getLine : 1,
		iframe : "tabcontentframe",
		needInitBoxHeight:false
	});
	attachUrl();
});


function attachUrl()
{
	
	$("[name='tabcontentframe']").attr("src","EditCustomerStatusInner.jsp?id="+id+"&winfo=<%=ishowname%>");
	if("<%=ishowname%>"==="2")
	{
		$("a[target='tabcontentframe']").parent("li").removeClass("current");
		$("a[target='tabcontentframe']:last").parent("li").addClass("current");
	}
	$("a[target='tabcontentframe']").each(function(){
		var	url = "EditCustomerStatusInner.jsp?id="+id+"&winfo="+$(this).attr("winfo");
		$(this).attr("href",url);
	});
}

$(document).ready(function(){
    $('.e8_box').Tabs({
		getLine : 1,
		iframe : "tabcontentframe",
		mouldID:"<%= MouldIDConst.getID("customer")%>",
		staticOnLoad:true,
		objName:"<%=SystemEnv.getHtmlLabelName(16495,user.getLanguage())%>"
	});
});

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
					<li class="current">
						<a href='#' winfo='1' target="tabcontentframe"><%=SystemEnv.getHtmlLabelName(1361,user.getLanguage()) %></a>
					</li>
					<li>
						<a href='#' winfo='2' target="tabcontentframe"><%=SystemEnv.getHtmlLabelName(15456,user.getLanguage()) %></a>
					</li>
				</ul>
				<div id="rightBox" class="e8_rightBox"></div>
			</div>
		</div>
	</div>
	<div class="tab_box">
		<iframe src="" onload="update();" id="tabcontentframe" name="tabcontentframe" class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
	<div>
</div> 
</BODY>
</HTML>