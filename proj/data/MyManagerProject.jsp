<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%

String from=Util.null2String(request.getParameter("from"));
String search_resourceid=Util.null2String(request.getParameter("search_resourceid"));
if(!"MyManagerProject".equals(from) ){
	response.sendRedirect("/proj/data/PrjTypeTreeFrame.jsp?from=MyManagerProject&search_resourceid="+search_resourceid);
	return;
}

String paraid=Util.null2String(request.getParameter("paraid"));
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
}); 
window.notExecute = true;
</script>

<%
	String url = "/proj/data/MyManagerProjectTab.jsp?paraid="+paraid+"&"+request.getQueryString();
	
	
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
		    	<li class="e8_tree">
		        	<a>&lt;&lt;结构</a>
		        </li>
		        <li>
					<a target="tabcontentframe" href="<%=url+"&src=all" %>"><%=SystemEnv.getHtmlLabelName(332 ,user.getLanguage()) %><span id="allNum_span"></span></a>
				</li>
		       	<li class="current">
					<a target="tabcontentframe" href="<%=url %>"><%=SystemEnv.getHtmlLabelName(732 ,user.getLanguage()) %><span id="todoNum_span"></span></a>
				</li>
		       	<li class="">
					<a target="tabcontentframe" href="<%=url+"&src=frozen" %>"><%=SystemEnv.getHtmlLabelName(1232 ,user.getLanguage()) %><span id="frozenNum_span"></span></a>
				</li>
		       	<li class="">
					<a target="tabcontentframe" href="<%=url+"&src=complete" %>"><%=SystemEnv.getHtmlLabelName(555 ,user.getLanguage()) %><span id="completeNum_span"></span></a>
				</li>
		    </ul>
	    <div id="rightBox" class="e8_rightBox">
	    </div>
	    </div>
	    </div>
	    </div>
	    <div class="tab_box">
	        <div>
	            <iframe src="<%=url %>" onload="update()" id="tabcontentframe" name="tabcontentframe" class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
	        </div>
	    </div>
	</div>  
<script type="text/javascript">	
$(function(){
	setTabObjName("<%=SystemEnv.getHtmlLabelName(1211,user.getLanguage()) %>");
});
</script>
</BODY>
</HTML>
