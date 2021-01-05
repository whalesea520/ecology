
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.cowork.CoworkDAO"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ include file="/systeminfo/leftMenuCommon.jsp" %>
<%@ page import="java.util.*" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<%
String mainType=Util.null2String(request.getParameter("mainType"));
String subType=Util.null2String(request.getParameter("subType"));
String mainTypeId=Util.null2String(request.getParameter("mainTypeId"));
String subTypeId=Util.null2String(request.getParameter("subTypeId"));

%>

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
						
						<!--
						<li class="e8_tree">
							<a><%=SystemEnv.getHtmlLabelName(455,user.getLanguage()) %></a>
						</li>
						 -->
						<li class="defaultTab">
							<a href="" target="tabcontentframe" _datetype="list"><%=TimeUtil.getCurrentTimeString() %></a>
						</li>
					</ul>
					<div id="rightBox" class="e8_rightBox"></div>
				</div>
			</div>
		</div>
		<div class="tab_box"><div>
		<iframe src="" onload="update()" id="tabcontentframe" name="tabcontentframe" class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
	</div>	
</body>

<script type="text/javascript">

	
	var mainType = "<%=mainType%>";
	var subType ="<%=subType%>";
	var mainTypeId ="<%=mainTypeId%>";
	var subTypeId ="<%=subTypeId%>";
	window.notExecute = true;
   $(document).ready(function(){
	    $('.e8_box').Tabs({
			getLine : 1,
			iframe : "tabcontentframe",
			mouldID:"<%= MouldIDConst.getID("customer")%>",
        	staticOnLoad:true,
        	objName:"<%=SystemEnv.getHtmlLabelName(18037,user.getLanguage())%>"
		});
		attachUrl();
		
		jQuery("#e8_tablogo").bind("click",function(){
    		parent.refreshTab(mainType , subType);
    	});
  });
 
  function attachUrl(){
	
	$("a[target='tabcontentframe']").each(function(){
		
		var datetype=$(this).attr("_datetype");
		
		if("list" == datetype){
			var fieldArr = ["CustomerTypes","CustomerDesc","CustomerStatus","CustomerSize"];
			
			var url = "/CRM/search/SearchOperation.jsp?selectType=share";
			
			if("" != mainTypeId){
				url += "&"+fieldArr[mainType]+"="+mainTypeId;
			}
			if('' != subTypeId){
				url += "&"+fieldArr[subType]+"="+subTypeId;
			}
			$(this).attr("href",url);

		}
		
		
		
	});
	$("[name='tabcontentframe']").attr("src",$("a[target='tabcontentframe']:eq(0)").attr("href"));
}

</script>
</html>

