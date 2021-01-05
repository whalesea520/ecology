
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="pack" class="weaver.general.ParameterPackage" scope="page"/>
<HTML><HEAD>
<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<!-- 
<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
-->
<link rel="stylesheet" href="/css/ecology8/request/searchInput_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/searchInput_wev8.js"></script>

<link rel="stylesheet" href="/css/ecology8/request/seachBody_wev8.css" type="text/css" />
<link rel="stylesheet" href="/css/ecology8/request/hoverBtn_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/hoverBtn_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/request/titleCommon_wev8.js"></script>
<script type="text/javascript">
jQuery(function(){
    jQuery('.e8_box').Tabs({
        getLine:1,
        iframe:"tabcontentframe"
    });
});

function refreshTab(){
	jQuery('.flowMenusTd',parent.document).toggle();
	jQuery('.leftTypeSearch',parent.document).toggle();
} 
</script>
<!-- 自定义设置tab页 -->
<%
	int title = 0;
	String url = "";
	HashMap<String, String> kv = (HashMap<String,String>)pack.packageParams(request, HashMap.class);
	String _fromURL = Util.null2String(kv.get("_fromURL"));//来源
	if(_fromURL.equals("DetachMSetEdit")){
		//分权管理设置
		title = 24326;
		url = "/system/DetachMSetEdit.jsp";
	}
%>
</head>			        
<BODY scroll="no">
	<SCRIPT LANGUAGE="JavaScript">
	<!-- Hide
	function killErrors() {
		return true;
	}
	window.onerror = killErrors;
	// -->
	</SCRIPT>
	<div class="e8_box demo2">
	   <%--
		    <ul class="tab_menu">
		        <li class="e8_tree">
		        	<a onclick="javascript:refreshTab();"><%=title==0?"":SystemEnv.getHtmlLabelName(title,user.getLanguage()) %></a>
		        </li>
		    </ul>
		    --%>
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

