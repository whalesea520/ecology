
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
						<li>
				        	<a  _datetype="" href="#"  target="tabcontentframe">
				        		<%=SystemEnv.getHtmlLabelName(332,user.getLanguage()) %>
				        	</a>
				        </li>
				        <li class="current">
				        	<a _datetype="1" href="#"  target="tabcontentframe">
				        		<%=SystemEnv.getHtmlLabelName(15537,user.getLanguage()) %>
				        	</a>
				        </li>
				         <li>
				        	<a _datetype="2" href="#"  target="tabcontentframe">
				        		<%=SystemEnv.getHtmlLabelName(15539,user.getLanguage()) %>
				        	</a>
				        </li>
				        <li>
				        	<a _datetype="3" href="#"  target="tabcontentframe">
				        		<%=SystemEnv.getHtmlLabelName(15541,user.getLanguage()) %>
				        	</a>
				        </li>
				        <li>
				        	<a _datetype="4" href="#"  target="tabcontentframe">
				        		<%=SystemEnv.getHtmlLabelName(21904,user.getLanguage()) %>
				        	</a>
				        </li>
				        <li>
				        	<a _datetype="5" href="#"  target="tabcontentframe">
				        		<%=SystemEnv.getHtmlLabelName(15384,user.getLanguage()) %>
				        	</a>
				        </li>
					</ul>
					<div id="rightBox" class="e8_rightBox"></div>
				</div>
			</div>
		</div>
		
		<div class="tab_box">
			<iframe src="CRMLoginLogRpChild.jsp?datetype=1" onload="update()" id="tabcontentframe" name="tabcontentframe" class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
			
		<div>
	</div>	
</body>

<script type="text/javascript">
	
	$(document).ready(function(){
	    $('.e8_box').Tabs({
			getLine : 1,
			iframe : "tabcontentframe",
			mouldID:"<%= MouldIDConst.getID("customer")%>",
			staticOnLoad:true,
			objName:"<%=SystemEnv.getHtmlLabelName(18180,user.getLanguage())%>"
		});
		
		attachUrl();
	});
  
  	function attachUrl(){
		$("a[target='tabcontentframe']").each(function(){
			var datetype=$(this).attr("_datetype");
			$(this).attr("href","/CRM/report/CRMLoginLogRpChild.jsp?datetype="+datetype+"&"+new Date().getTime());
		});
		
	}

</script>
</html>

