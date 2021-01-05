
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.cowork.CoworkDAO"%>
<%@page import="weaver.crm.customer.CustomerLabelVO"%>
<%@page import="weaver.crm.Maint.CustomerContacterComInfo"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ include file="/systeminfo/leftMenuCommon.jsp" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CustomerStatusCount" class="weaver.crm.CustomerStatusCount" scope="page" />
<jsp:useBean id="CustomerLabelService" class="weaver.crm.customer.CustomerLabelService" scope="page" />
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page"/>
<jsp:useBean id="CustomerContacterComInfo" class="weaver.crm.Maint.CustomerContacterComInfo" scope="page"/>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<%

String userid=""+user.getUID();

String ContacterID = Util.null2String(request.getParameter("ContacterID"));
String tabid = Util.null2String(request.getParameter("tabid"));

String contacterid = Util.null2String(request.getParameter("ContacterID"));
if("2".equals(user.getLogintype())){
	response.sendRedirect("/CRM/data/ViewContacter.jsp?ContacterID="+contacterid);
	return;
}

rs.executeProc("CRM_CustomerContacter_SByID", contacterid);
if (rs.getCounts() <= 0) {
	response.sendRedirect("/base/error/DBError.jsp?type=FindData");
	return;
}
rs.first();
String customerid = rs.getString(2);
String customertype = "";

boolean canedit = false;
if(!customerid.equals("")){
	//判断此客户是否存在
	rs.executeProc("CRM_CustomerInfo_SelectByID",customerid);
	if(!rs.next()){
		response.sendRedirect("/base/error/DBError.jsp?type=FindDataVCL");
		return;
	}
	//判断是否有查看该客户商机权限
	int sharelevel = CrmShareBase.getRightLevelForCRM(userid,customerid);
	if(sharelevel<1){
		response.sendRedirect("/notice/noright.jsp") ;
		return;
	}
}

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
						<li class="<%=tabid.equals("")?"current":""%>" >
							<a href="" target="tabcontentframe" _labelid="base">联系人信息</a>
						</li>
						<li class="<%=tabid.equals("trail")?"current":""%>">
							<a href="" target="tabcontentframe" _labelid="trail">工作轨迹</a>
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
			objName:"<%=CustomerContacterComInfo.getCustomerContactername(ContacterID)%>"
		});
		attachUrl();
	});
  
  function attachUrl(){
	
	$("a[target='tabcontentframe']").each(function(){
		
		var labelid=$(this).attr("_labelid");
		
		if("base" == labelid){
			$(this).attr("href","ContacterBase.jsp?ContacterID=<%=ContacterID%>");
		}else{
			$(this).attr("href","ContacterTrail.jsp?ContacterID=<%=ContacterID%>");
		}
		
	});
	if("<%=tabid%>"=="trail")
		$("[name='tabcontentframe']").attr("src",$("a[target='tabcontentframe']:eq(1)").attr("href"));
	else
		$("[name='tabcontentframe']").attr("src",$("a[target='tabcontentframe']:eq(0)").attr("href"));	
}

function refreshTab(){
}

</script>
</html>

