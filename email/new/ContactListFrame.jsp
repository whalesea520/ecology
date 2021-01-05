
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.cowork.CoworkDAO"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%@ page import="java.util.*" %>

<html>
<head>
<%
String mailgroupid = Util.null2String(request.getParameter("mailgroupid"));

%>

<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<script src="/js/tabs/expandCollapse_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
<link rel="stylesheet" href="/css/ecology8/request/searchInput_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/searchInput_wev8.js"></script>

<link rel="stylesheet" href="/css/ecology8/request/seachBody_wev8.css" type="text/css" />
<link rel="stylesheet" href="/css/ecology8/request/hoverBtn_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/hoverBtn_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/request/titleCommon_wev8.js"></script>

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
				<div>
					<ul class="tab_menu">
						<li class="e8_tree">
							<a><%=SystemEnv.getHtmlLabelName(455,user.getLanguage()) %></a>
						</li>
						<li class="defaultTab" >
							<a href="" target="tabcontentframe"  _datetype="import"><%=TimeUtil.getCurrentTimeString() %></a>
						</li>
					</ul>
					<div id="rightBox" class="e8_rightBox"></div>
				</div>
			</div>
		</div>
			
		<div class="tab_box">
			<iframe src="/email/new/ContactList.jsp?mailgroupid=<%=mailgroupid%>" onload="update();" id="tabcontentframe" name="tabcontentframe" class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
		<div>
	</div>
</body>

<script type="text/javascript">
	window.notExecute = true;
	$(document).ready(function(){
	    $('.e8_box').Tabs({
			getLine : 1,
			iframe : "tabcontentframe",
			mouldID:"<%= MouldIDConst.getID("mail")%>",
			staticOnLoad:true,
			objName:"<%=SystemEnv.getHtmlLabelName(572,user.getLanguage()) %>"
		});
		
		jQuery("#e8_tablogo").bind("click",function(){
    		parent.refreshTreeData("frame");
    	});
	});
	
	
  function attachUrl(){
	
	$("[name='tabcontentframe']").attr("src","/email/new/ContactList.jsp?mailgroupid=<%=mailgroupid%>&"+new Date().getTime());
  }

</script>
</html>

