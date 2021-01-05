
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.cowork.CoworkDAO"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ include file="/systeminfo/leftMenuCommon.jsp" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CustomerStatusCount" class="weaver.crm.CustomerStatusCount" scope="page" />

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<%
String layout=Util.null2String(request.getParameter("layout"),"1");
String mainType=Util.null2String(request.getParameter("mainType"));
String subType=Util.null2String(request.getParameter("subType"));
String mainTypeId=Util.null2String(request.getParameter("mainTypeId"));
String subTypeId=Util.null2String(request.getParameter("subTypeId"));

String tabtype=Util.null2String(request.getParameter("tabtype"),"info");

int count = CustomerStatusCount.getContactNumber(user.getUID()+"");
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
						<li class="current">
							<a href="" target="tabcontentframe" _datetype="info"><%=SystemEnv.getHtmlLabelName(16405,user.getLanguage()) %></a>
						</li>
						<li>
							<a href="" target="tabcontentframe" _datetype="plan"><%=SystemEnv.getHtmlLabelName(16402,user.getLanguage()) %></a>
						</li>
						<li>
							<a href="" target="tabcontentframe" _datetype="remind"><%=SystemEnv.getHtmlLabelName(16403,user.getLanguage()) %><%=count==0?"":"("+count+")" %></a>
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
 $(document).ready(function(){
    $('.e8_box').Tabs({
		getLine : 1,
		iframe : "tabcontentframe",
		mouldID:"<%= MouldIDConst.getID("customer")%>",
		staticOnLoad:true,
		objName:"<%=SystemEnv.getHtmlLabelName(6082,user.getLanguage())%>"
	});
	attachUrl();
 });
  
  function showMenu(){
	window.parent.showMenu();
	if("<%=layout%>"=="2"){
		update(".e8_box");
	}
  }
  
  function attachUrl(){
	
	$("a[target='tabcontentframe']").each(function(){
		
		var datetype=$(this).attr("_datetype");
		
		if("plan" == datetype){
			$(this).attr("href","/CRM/report/CRMContactLogRp.jsp?selectType=plan&finished=0&"+new Date().getTime());
		}
		
		if("info" == datetype){
			$(this).attr("href","/CRM/report/CRMContactLogRp.jsp?selectType=info&"+new Date().getTime());
		}
		
		if("remind" == datetype){
			$(this).attr("href","/CRM/data/CRMContactRemindNew.jsp?"+new Date().getTime());
		}
		
	});
	if("<%=tabtype%>"=="remind")
		$("[name='tabcontentframe']").attr("src",$("a[target='tabcontentframe']:eq(2)").attr("href"));
	else	
		$("[name='tabcontentframe']").attr("src",$("a[target='tabcontentframe']:eq(0)").attr("href"));
}

</script>
</html>
