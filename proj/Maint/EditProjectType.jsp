<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ProjectTypeComInfo" class="weaver.proj.Maint.ProjectTypeComInfo" scope="page" />
<%
String isclose = Util.null2String(request.getParameter("isclose"));
String isDialog = Util.null2String(request.getParameter("isdialog"));
String tabid = Util.null2String(request.getParameter("tabid"));
%>
<HTML><HEAD>
<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
<link rel="stylesheet" href="/css/ecology8/request/searchInput_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/searchInput_wev8.js"></script>

<link rel="stylesheet" href="/css/ecology8/request/seachBody_wev8.css" type="text/css" />
<link rel="stylesheet" href="/css/ecology8/request/hoverBtn_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/hoverBtn_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/request/titleCommon_wev8.js"></script>
<script type="text/javascript">
$(function(){
    $('.e8_box').Tabs({
        getLine:1,
        iframe:"tabcontentframe",
        mouldID:"<%= MouldIDConst.getID("proj")%>",
        staticOnLoad:true
    });
    attachUrl();
}); 
</script>
<script type="text/javascript">
var parentWin;
if("<%=isDialog %>"=="1"){
	parentWin = parent.getParentWindow(window);
}


if("<%=isclose%>"=="1"){
	parentWin.onBtnSearchClick();
	parentWin.closeDialog();	
}
</script>
<%

	String id= Util.null2String( request.getParameter("id"));

	String url = "/proj/Maint/EditProjectTypeTab.jsp?isdialog=1&id="+id;
	String url2 = "/proj/Maint/PrjTypeShareDsp.jsp?isdialog=1&paraid="+id;
	String url3 = "/proj/Maint/PrjTypeCreateDsp.jsp?isdialog=1&paraid="+id;
%>

</head>
<BODY scroll="no">
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
					<a target="tabcontentframe" href="<%=url %>"><%=SystemEnv.getHtmlLabelName(1361 ,user.getLanguage()) %></a>
				</li>
				<li >
					<a target="tabcontentframe" href="<%=url3 %>"><%=SystemEnv.getHtmlLabelName(21945,user.getLanguage()) %></a>
				</li>
				<li >
					<a target="tabcontentframe" href="<%=url2 %>"><%=SystemEnv.getHtmlLabelName(2112,user.getLanguage()) %></a>
				</li>
		    </ul>
	    <div id="rightBox" class="e8_rightBox">
	    </div>
	    </div>
	    </div>
	    </div>
	    <div class="tab_box">
	        <div>
	            <iframe src="" onload="update()" id="tabcontentframe" name="tabcontentframe" class="flowFrame" scrolling="no" frameborder="0" height="100%" width="100%;"></iframe>
	        </div>
	    </div>
 
	</div>    

<script type="text/javascript">	
function attachUrl()
{
	
	if("<%=tabid%>"=="2")
	{
		$("a[target='tabcontentframe']").parent("li").removeClass("current");
		$("a[target='tabcontentframe']:last").parent("li").addClass("current");
		$("#tabcontentframe").attr("src","<%=url2 %>");
	}else if("<%=tabid%>"=="3")
	{
		$("a[target='tabcontentframe']").parent("li").removeClass("current");
		$("a[target='tabcontentframe']:eq(1)").parent("li").addClass("current");
		$("#tabcontentframe").attr("src","<%=url3 %>");
	}else{
		$("#tabcontentframe").attr("src","<%=url %>");
	}
	
}
$(function(){
	setTabObjName("<%=ProjectTypeComInfo.getProjectTypename(id) %>");
});
</script>

</BODY>
</HTML>
