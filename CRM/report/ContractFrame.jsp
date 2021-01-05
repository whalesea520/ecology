
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.cowork.CoworkDAO"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="weaver.conn.RecordSet"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ include file="/systeminfo/leftMenuCommon.jsp" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CustomerStatusCount" class="weaver.crm.CustomerStatusCount" scope="page" />

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<%

int expireCount = CustomerStatusCount.getContractNumber("expire",user.getUID()+"");
int payCount = CustomerStatusCount.getContractNumber("pay",user.getUID()+"");
int deliveryCount = CustomerStatusCount.getContractNumber("delivery",user.getUID()+"");

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
						<li>
							<a href="" target="tabcontentframe" _datetype="all"><%=SystemEnv.getHtmlLabelName(332,user.getLanguage()) %></a>
						</li>
						<li class="current">
							<a href="" target="tabcontentframe" _datetype="unfinish"><%=SystemEnv.getHtmlLabelName(732,user.getLanguage()) %></a>
						</li>
						<li>
							<a href="" target="tabcontentframe" _datetype="finish"><%=SystemEnv.getHtmlLabelName(1961,user.getLanguage()) %></a>
						</li>
						<li>
							<a href="" target="tabcontentframe" _datetype="expire"><%=SystemEnv.getHtmlLabelName(32009,user.getLanguage()) %><%=expireCount==0?"":"("+expireCount +")"%></a>
						</li>
						<li>
							<a href="" target="tabcontentframe" _datetype="pay"><%=SystemEnv.getHtmlLabelName(15234,user.getLanguage()) %><%=payCount==0?"":"("+payCount +")" %></a>
						</li>
						<li>
							<a href="" target="tabcontentframe" _datetype="delivery"><%=SystemEnv.getHtmlLabelName(15233,user.getLanguage()) %><%=deliveryCount==0?"":"("+deliveryCount  +")"%></a>
						</li>
					</ul>
					<div id="rightBox" class="e8_rightBox"></div>
				</div>
			</div>
		</div>
		
		<div class="tab_box"><div>
		<iframe src="" onload="update();" id="tabcontentframe" name="tabcontentframe" class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
	</div>	
</body>

<script type="text/javascript">

	
   $(document).ready(function(){
	    $('.e8_box').Tabs({
			getLine : 1,
			iframe : "tabcontentframe",
			mouldID:"<%= MouldIDConst.getID("customer")%>",
			staticOnLoad:true,
			objName:"<%=SystemEnv.getHtmlLabelName(16260,user.getLanguage())%>"
		});
		attachUrl();
  });
  
  
  function attachUrl(){
	
	$("a[target='tabcontentframe']").each(function(){
		
		var datetype=$(this).attr("_datetype");
		
		if("all" == datetype){
			$(this).attr("href","/CRM/report/ContractReportNew.jsp?selectType=all&"+new Date().getTime());
		}
		if("unfinish" == datetype){
			$(this).attr("href","/CRM/report/ContractReportNew.jsp?selectType=unfinish&"+new Date().getTime());
		}
		if("finish" == datetype){
			$(this).attr("href","/CRM/report/ContractReportNew.jsp?selectType=finish&"+new Date().getTime());
		}
		if("expire" == datetype){
			$(this).attr("href","/CRM/report/ContractReportNew.jsp?selectType=expire&"+new Date().getTime());
		}
		if("pay" == datetype){
			$(this).attr("href","/CRM/report/ContractReportNew.jsp?selectType=pay&"+new Date().getTime());
		}
		if("delivery" == datetype){
			$(this).attr("href","/CRM/report/ContractReportNew.jsp?selectType=delivery&"+new Date().getTime());
		}
		
	});
	$("[name='tabcontentframe']").attr("src",$("a[target='tabcontentframe']:eq(1)").attr("href"));
}

</script>
</html>

