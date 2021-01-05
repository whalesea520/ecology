<%@page import="weaver.general.Util"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="pack" class="weaver.general.ParameterPackage" scope="page"/>
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page"/>
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
</script>
<link rel="stylesheet" href="/proj/css/common_wev8.css" type="text/css" />
<!-- 自定义设置tab页 -->
<%
	String url = "";
	
	url = "/proj/report/ProjectModifyLogRpTab.jsp?1=1";
	
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
	       			<li >
						<a target="tabcontentframe" href="<%=url+"&src=all" %>"><%=SystemEnv.getHtmlLabelName(332,user.getLanguage()) %></a>
					</li>
					<li class="current">
						<a target="tabcontentframe" href="<%=url+"&src=today" %>"><%=SystemEnv.getHtmlLabelName(15537,user.getLanguage()) %></a>
					</li>
					<li >
						<a target="tabcontentframe" href="<%=url+"&src=thisweekday" %>"><%=SystemEnv.getHtmlLabelName( 15539 ,user.getLanguage()) %></a>
					</li>
					<li >
						<a target="tabcontentframe" href="<%=url+"&src=thismonth" %>"><%=SystemEnv.getHtmlLabelName( 15541 ,user.getLanguage()) %></a>
					</li>
					<li >
						<a target="tabcontentframe" href="<%=url+"&src=thisquater" %>"><%=SystemEnv.getHtmlLabelName( 21904 ,user.getLanguage()) %></a>
					</li>
					<li >
						<a target="tabcontentframe" href="<%=url+"&src=thisyear" %>"><%=SystemEnv.getHtmlLabelName( 15384 ,user.getLanguage()) %></a>
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
	var objname='<%=SystemEnv.getHtmlLabelName(33784, user.getLanguage()) %>';
	setTabObjName(objname);
});
</script>
</body>
</html>

