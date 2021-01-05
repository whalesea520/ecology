<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<%@ page import="java.util.Map.Entry" %>
<%@ page import="weaver.templetecheck.CheckConfigFile" %>
<HTML>
<HEAD>
<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
<link rel="stylesheet" href="/css/ecology8/request/searchInput_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/searchInput_wev8.js"></script>
<link rel="stylesheet" href="/css/ecology8/request/seachBody_wev8.css" type="text/css" />
<link rel="stylesheet" href="/css/ecology8/request/hoverBtn_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/hoverBtn_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/request/titleCommon_wev8.js"></script>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
	//判断只有管理员才有权限
	int userid = user.getUID();
	if(userid!=1) {
		response.sendRedirect("/notice/noright.jsp");
	    return;
	}
	CheckConfigFile checkConf = new CheckConfigFile();
	Map<String,String> map = null;
	String checkids = Util.null2String(request.getParameter("checkids"));
	if(checkids!=""&&!checkids.replaceAll(",", "").equals("")){
		map = checkConf.getDiffIds(checkids);
	}
	String proCheckIds = map.get("1");
	String xmlCheckIds = map.get("2");
	String url = "";
	String filetype = "";
	if (proCheckIds != null && !proCheckIds.equals("")) {
		filetype = "1";
		url = "/templetecheck/CheckConfigResult.jsp?checkids=" + proCheckIds + "&filetype=1";
	} else {
		filetype = "2";
		url = "/templetecheck/CheckConfigResult.jsp?checkids=" + xmlCheckIds + "&filetype=2";
	}

%>
<script type="text/javascript">
$(function(){
    $('.e8_box').Tabs({
        getLine:1,
        iframe:"tabcontentframe",
        mouldID:"<%= MouldIDConst.getID("checkfile")%>",
        staticOnLoad:true,
        notRefreshIfrm:true,
        objName:"配置文件检测结果"
    });
    
    if(<%=filetype%> == "2"){
    	$("#tab_menu_a ul li:eq(0)").removeClass("current");
    	$("#tab_menu_a ul li:eq(1)").addClass("current");
    }
}); 

function show(type) {
	if("1" == type) {
		$("#tabcontentframe").attr("src","/templetecheck/CheckConfigResult.jsp?filetype=1&checkids=<%=proCheckIds%>");
	} else {
		$("#tabcontentframe").attr("src","/templetecheck/CheckConfigResult.jsp?filetype=2&checkids=<%=xmlCheckIds%>");
	}
}
</script>
</head>

<body scroll="no">
	<div class="e8_box demo2">
		<div class="e8_boxhead">
			<div class="div_e8_xtree" id="div_e8_xtree"></div>
			<div class="e8_tablogo" id="e8_tablogo"></div>
			<div class="e8_ultab">
				<div class="e8_navtab" id="e8_navtab">
					<span id="objName"></span>
				</div>
				<div id="tab_menu_a">
					<ul class="tab_menu">
						<li class="current"><a href="javascript:show(1)">properties文件检测结果</a></li>
						<li><a href="javascript:show(2)">xml文件检测结果</a></li>
					</ul>
					<div id="rightBox" class=" e8_rightBox"></div>
				</div>
			</div>
		</div>
		<div class="tab_box">
			<div>
				<iframe src="<%=url %>" onload="update()" id="tabcontentframe" name="tabcontentframe" class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
			</div>
		</div>
	</div>
</body>
</html>