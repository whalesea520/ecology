
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.cowork.CoworkDAO"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ include file="/systeminfo/leftMenuCommon.jsp" %>
<%@ page import="java.util.*" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>

<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
<link rel="stylesheet" href="/css/ecology8/request/searchInput_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/searchInput_wev8.js"></script>
<link rel="stylesheet" href="/css/ecology8/request/seachBody_wev8.css" type="text/css" />
<link rel="stylesheet" href="/css/ecology8/request/hoverBtn_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/hoverBtn_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/request/titleCommon_wev8.js"></script>


</head>

<%
	String url = "";
	String objName = "";
	if(request.getQueryString() != null){
		String _fromURL= request.getParameter("_fromURL");
		url = "/cowork/transfer/CoworkType.jsp?"+request.getQueryString();
		if(_fromURL.toUpperCase().contains("T181") || _fromURL.toUpperCase().contains("C171") || _fromURL.toUpperCase().contains("D153")){
			url = "/cowork/transfer/Cowork.jsp?"+request.getQueryString();
			objName = SystemEnv.getHtmlLabelName(18831,user.getLanguage());//协作主题
		}else if(_fromURL.toUpperCase().contains("T182") 
				||_fromURL.toUpperCase().contains("C172")
				||_fromURL.toUpperCase().contains("D151")
				|| _fromURL.toUpperCase().contains("T231")
				||_fromURL.toUpperCase().contains("C251")
				||_fromURL.toUpperCase().contains("D231")
				||_fromURL.toUpperCase().contains("T331")
				||_fromURL.toUpperCase().contains("C351")
				||_fromURL.toUpperCase().contains("D331")
				||_fromURL.toUpperCase().contains("T421")
				||_fromURL.toUpperCase().contains("C441")
				||_fromURL.toUpperCase().contains("D421")){
			objName = SystemEnv.getHtmlLabelNames("21945",user.getLanguage());//创建权限
		}else{
			objName = SystemEnv.getHtmlLabelNames("633,385",user.getLanguage());//管理权限
		}
		
	}
	
%>

</head>

<body scroll="no">
	<div class="e8_box demo2" id="rightContent">
		<div class="e8_boxhead">
			<div class="div_e8_xtree" id="div_e8_xtree"></div>
	        <div class="e8_tablogo" id="e8_tablogo"></div>
			<div class="e8_ultab">
				<div class="e8_navtab" id="e8_navtab">
					<span id="objName"></span>
				</div>
				<div>
					<ul class="tab_menu">
						
						<li class="defaultTab">
							<a href="" target="tabcontentframe" _datetype="list"></a>
						</li>
					</ul>
					<div id="rightBox" class="e8_rightBox"></div>
				</div>	
			</div>
		</div>
				
		<div class="tab_box"><div>
		<iframe src="<%=url %>" onload="update()" id="tabcontentframe" name="tabcontentframe" class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
	</div>	
</body>

<script>
$(document).ready(function(){
    $('.e8_box').Tabs({
        getLine:1,
        iframe:"tabcontentframe",
        mouldID:"<%= MouldIDConst.getID("collaboration")%>",
        staticOnLoad:true,
        objName:"<%=objName %>"
    });
});


</script>
</html>
