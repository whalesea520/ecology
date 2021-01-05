
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.cowork.CoworkDAO"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ include file="/systeminfo/leftMenuCommon.jsp" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CustomerStatusCount" class="weaver.crm.CustomerStatusCount" scope="page" />

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<%
String contractId = request.getParameter("id");
String type = Util.null2String(request.getParameter("type"));//type为info为重新打开；contact为相关交流；share为共享设置
String customerid = "";
RecordSet.executeSql("select crmId from CRM_Contract where id="+contractId);
if(RecordSet.next()){
	customerid = RecordSet.getString("crmId");
}
if("".equals(type)){
	type = "info";
}

int count = CustomerStatusCount.getExchangeInfoCount(contractId,"CH",user.getUID());
String info = count==0?"":"<font id= 'crmExchange_1' name='crmExchange_1' style='color:red'>"+count+"</font>";
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
						<li <%if("info".equals(type)){ %>class="current" <%} %>>
							<a href="" target="tabcontentframe" _datetype="info"><%=SystemEnv.getHtmlLabelName(1361,user.getLanguage()) %></a>
						</li>
						<li <%if("contact".equals(type)){ %>class="current" <%} %>>
							<a href="" target="tabcontentframe" _datetype="chanceInfo"><%=SystemEnv.getHtmlLabelName(15153,user.getLanguage()) %><%=info %></a>
						</li>
						<li <%if("share".equals(type)){ %>class="current" <%} %>>
							<a href="" target="tabcontentframe" _datetype="share"><%=SystemEnv.getHtmlLabelName(19025,user.getLanguage()) %></a>
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
			mouldID:"<%= MouldIDConst.getID("customer")%>",
			staticOnLoad:true,
			objName:"<%=SystemEnv.getHtmlLabelName(34244,user.getLanguage())%>"
		});
		attachUrl();
  });
  
  function closeDialog(){
  	parent.getDialog(window).close();
  }
  
  function refreshInfo(){
  	 parent.getParentWindow(window)._table.reLoad();
  }
  
  function attachUrl(){
	
	$("a[target='tabcontentframe']").each(function(){
		
		var datetype=$(this).attr("_datetype");
		if("info" == datetype){
			$(this).attr("href","/CRM/data/ContractView.jsp?isfromtab=true&id=<%=contractId%>&"+new Date().getTime());
		}
		
		if("chanceInfo" == datetype){
			$(this).attr("href","/CRM/data/ContractViewMessage.jsp?isfromtab=true&id=<%=contractId%>&"+new Date().getTime());
			
		}
		
		if("share" == datetype){
			$(this).attr("href","/CRM/data/ContractShareAdd.jsp?isfromtab=true&contractId=<%=contractId%>&CustomerID=<%=customerid%>&"+new Date().getTime());
		}
		
	});
	<%if("info".equals(type)){ %>
		$("[name='tabcontentframe']").attr("src",$("a[target='tabcontentframe']:eq(0)").attr("href"));
	<%}else if("contact".equals(type)){%>
		$("[name='tabcontentframe']").attr("src",$("a[target='tabcontentframe']:eq(1)").attr("href"));
	<%}else{ %>
		$("[name='tabcontentframe']").attr("src",$("a[target='tabcontentframe']:eq(2)").attr("href"));
	<%}%>
}

jQuery(function(){
	jQuery("a[target='tabcontentframe']").click(function(obj){
		var datetype=$(this).attr("_datetype");
		if("chance" == datetype){
			parent.diag.ShowCloseButton= false;
		}
	});
});

function editInfo(){
	window.frames["tabcontentframe"].editInfo();
}
</script>
</html>

