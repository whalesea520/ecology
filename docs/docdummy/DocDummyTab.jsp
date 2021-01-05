
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="pack" class="weaver.general.ParameterPackage" scope="page"/>
<HTML><HEAD>
<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
<script type="text/javascript">
$(function(){
    $('.e8_box').Tabs({
        getLine:1,
        iframe:"tabcontentframe"
    });
 
 function refreshTab(){
	jQuery('.flowMenusTd',parent.document).toggle();
	jQuery('.leftTypeSearch',parent.document).toggle();
 }
 }); 
    
</script>

<%
	HashMap kv = (HashMap)pack.packageParams(request, HashMap.class);
	String url = "/docs/docdummy/DocDummyRight.jsp?dummyId="+kv.get("dummyId");
%>

</head>
<BODY scroll="no">
	<div class="e8_box demo2">
		    <ul class="tab_menu">
	        <li class="e8_tree">
	        	<a onclick="javascript:refreshTab();"><%=SystemEnv.getHtmlLabelName(32452,user.getLanguage()) %></a>
	        </li>
		    </ul>
	    <div id="rightBox" class="e8_rightBox">
	    </div>
	    <div class="tab_box">
	        <div>
	            <iframe src="<%=url %>" id="tabcontentframe" name="tabcontentframe" class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
	        </div>
	    </div>
	</div>     
</body>
</html>

