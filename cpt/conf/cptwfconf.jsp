<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
String from=Util.null2String(request.getParameter("from"));
String paraid=Util.null2String(request.getParameter("paraid"));

if(!HrmUserVarify.checkUserRight("Cpt:CusWfConfig", user)){
	response.sendRedirect("/notice/noright.jsp");	
	return;
}

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
        mouldID:"<%= MouldIDConst.getID("assest")%>",
        staticOnLoad:true
    });
}); 
</script>

<%
	String url = "/cpt/conf/cptwfconftab.jsp";
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
					<a target="tabcontentframe" href="<%=url+"?wftype=apply" %>"><%=SystemEnv.getHtmlLabelNames("84362",user.getLanguage())%></a>
				</li>
		       	<li class="">
					<a target="tabcontentframe" href="<%=url+"?wftype=fetch" %>"><%=SystemEnv.getHtmlLabelNames("886",user.getLanguage())%></a>
				</li>
		       	<li class="">
					<a target="tabcontentframe" href="<%=url+"?wftype=move" %>"><%=SystemEnv.getHtmlLabelNames("883",user.getLanguage())%></a>
				</li>
		       	<li class="">
					<a target="tabcontentframe" href="<%=url+"?wftype=lend" %>"><%=SystemEnv.getHtmlLabelNames("6051",user.getLanguage())%></a>
				</li>
		       	<li class="">
					<a target="tabcontentframe" href="<%=url+"?wftype=back" %>"><%=SystemEnv.getHtmlLabelNames("15305",user.getLanguage())%></a>
				</li>
		       	<li class="">
					<a target="tabcontentframe" href="<%=url+"?wftype=loss" %>"><%=SystemEnv.getHtmlLabelNames("6054",user.getLanguage())%></a>
				</li>
		       	<li class="">
					<a target="tabcontentframe" href="<%=url+"?wftype=discard" %>"><%=SystemEnv.getHtmlLabelNames("6052",user.getLanguage())%></a>
				</li>
		       	<li class="">
					<a target="tabcontentframe" href="<%=url+"?wftype=mend" %>"><%=SystemEnv.getHtmlLabelNames("22459",user.getLanguage())%></a>
				</li>
				<li class="">
					<a target="tabcontentframe" href="<%=url+"?wftype=change" %>"><%=SystemEnv.getHtmlLabelNames("6055",user.getLanguage())%></a>
				</li>
		    </ul>
	    <div id="rightBox" class="e8_rightBox">
	    </div>
	    </div>
	    </div>
	    </div>
	    <div class="tab_box">
	        <div>
	            <iframe src="<%=url+"?wftype=apply" %>" onload="update()" id="tabcontentframe" name="tabcontentframe" class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
	        </div>
	    </div>
	</div>  
<script type="text/javascript">	
$(function(){
	setTabObjName("<%=SystemEnv.getHtmlLabelName(81546,user.getLanguage()) %>");
});
</script>   
</BODY>
</HTML>
