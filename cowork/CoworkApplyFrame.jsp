<%@ include file="/systeminfo/init_wev8.jsp" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.cowork.CoworkDAO"%>
<%@ include file="/systeminfo/leftMenuCommon.jsp" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
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
<%
	rs.execute("select count(*) from cowork_items  t1  JOIN cowork_apply_info t2 ON t1.id = t2.coworkid where t1.principal = "+user.getUID()+" and t2.status = -1 ");
	rs.next();
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
						<li class="current" >
							<a href="" target="tabcontentframe" _datetype="list"><%=SystemEnv.getHtmlLabelName(83214,user.getLanguage())%></a>
						</li>
						<li>
							<a href="" target="tabcontentframe" _datetype="approve"><%=SystemEnv.getHtmlLabelName(83215,user.getLanguage())%>(<span id="approveCount"><%=Util.getIntValue(rs.getString(1),0) %></span>)</a>
						</li>
						<li>
							<a href="" target="tabcontentframe" _datetype="log"><%=SystemEnv.getHtmlLabelName(83216,user.getLanguage())%></a>
						</li>
					</ul>
					<div id="rightBox" class="e8_rightBox"></div>
				</div>
			</div>
		</div>
		
		<div class="tab_box">
			<iframe src="" onload="update()" id="tabcontentframe" name="tabcontentframe" class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
			
		<div>
	</div>	
</body>

<script type="text/javascript">
	$(document).ready(function(){
	    $('.e8_box').Tabs({
			getLine : 1,
			iframe : "tabcontentframe",
			mouldID:"<%= MouldIDConst.getID("collaboration")%>",
			staticOnLoad:true,
			objName:"<%=SystemEnv.getHtmlLabelName(33842,user.getLanguage())%>"
		});
		attachUrl();
	});
  
  function attachUrl(){
	
	$("a[target='tabcontentframe']").each(function(){
		
		var datetype=$(this).attr("_datetype");
		
		if("list" == datetype){
			$(this).attr("href","/cowork/CoworkApplyList.jsp?"+new Date().getTime());
		}
		
		if("approve" == datetype){
			$(this).attr("href","/cowork/CoworkApplyApprove.jsp?"+new Date().getTime());
		}
		
		if("log" == datetype){
			$(this).attr("href","/cowork/CoworkApplyLog.jsp?"+new Date().getTime());
		}
		
	});
	$("[name='tabcontentframe']").attr("src",$("a[target='tabcontentframe']:eq(0)").attr("href"));
}

function refreshTab(){
}

</script>
</html>

