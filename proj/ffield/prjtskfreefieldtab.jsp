<%@page import="java.io.File"%>
<%@page import="java.io.FileWriter"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="FieldUtil" class="weaver.proj.util.FieldUtil" scope="page"/>
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

<%
if(!HrmUserVarify.checkUserRight("ProjectFreeFeild:Edit", user)){
	response.sendRedirect("/notice/noright.jsp");	
	return;
}




	String url = "/proj/ffield/editprjtskfieldbatch.jsp?ajax=1";
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
					<a target="tabcontentframe" href="/proj/ffield/editprjtskfieldbatch.jsp?ajax=1"><%=SystemEnv.getHtmlLabelName(21903 ,user.getLanguage()) %></a>
				</li>
		       	<li>
					<a target="tabcontentframe" href="/proj/ffield/editprjtskfieldlabel.jsp?ajax=1"><%=SystemEnv.getHtmlLabelName(32815,user.getLanguage()) %></a>
				</li>
		       	<li><a target="tabcontentframe" href="/proj/ffield/editprjtskfieldgroup.jsp?ajax=1" ><%=SystemEnv.getHtmlLabelName(34105,user.getLanguage()) %></a></li>
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
	setTabObjName("<%=SystemEnv.getHtmlLabelName(81856,user.getLanguage()) %>");
});
</script>    
</BODY>
</HTML>
