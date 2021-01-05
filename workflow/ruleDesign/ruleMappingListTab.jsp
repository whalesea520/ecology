
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.workflow.ruleDesign.RuleBusiness"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>

<%
String ruleid = Util.null2String(request.getParameter("ruleid"));
%>
<%
//RuleBusiness rb = new RuleBusiness();
//rb.setRuleid(Integer.parseInt(ruleid));
//System.out.println(rb.ruleToIKString(ruleid));

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

<script type="text/javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<script type="text/javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<LINK href="/wui/theme/ecology8/jquery/js/e8_zDialog_btn_wev8.css" type=text/css rel=STYLESHEET>

<script type="text/javascript">
$(function(){
    $('.e8_box').Tabs({
        getLine:1,
        iframe:"tabcontentframe"
    });
 
 }); 
 
</script>

</head>
<BODY scroll="no">
	<div class="e8_box demo2">
		    <ul class="tab_menu">
		    </ul>
	    <div id="rightBox" class="e8_rightBox">
	    </div>
	    <div class="tab_box">
	        <div>
	            <iframe src="/workflow/ruleDesign/ruleMappingList.jsp?ruleid=<%=ruleid %>" id="tabcontentframe" name="tabcontentframe" class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
	        </div>
	    </div>
	</div>     
</body>
</html>

