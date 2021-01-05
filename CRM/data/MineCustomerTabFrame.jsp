
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.cowork.CoworkDAO"%>
<%@page import="weaver.crm.customer.CustomerLabelVO"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ include file="/systeminfo/leftMenuCommon.jsp" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="CustomerStatusCount" class="weaver.crm.CustomerStatusCount" scope="page" />
<jsp:useBean id="CustomerLabelService" class="weaver.crm.customer.CustomerLabelService" scope="page" />
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<%
String userid=""+user.getUID();
String mainType=Util.null2String(request.getParameter("mainType"));
String subType=Util.null2String(request.getParameter("subType"));
String mainTypeId=Util.null2String(request.getParameter("mainTypeId"));
String subTypeId=Util.null2String(request.getParameter("subTypeId"));
int newCustomerNumber = CustomerStatusCount.getNewCustomerNumber(user.getUID()+"");//新客户数量
%>

<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
<link rel="stylesheet" href="/css/ecology8/request/searchInput_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/searchInput_wev8.js"></script>

<link rel="stylesheet" href="/css/ecology8/request/seachBody_wev8.css" type="text/css" />
<link rel="stylesheet" href="/css/ecology8/request/hoverBtn_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/hoverBtn_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/request/titleCommon_wev8.js"></script>
<style>
.btn_top{
	border:none;padding-left:0px !important;
}
.btn_top .btndiv{width:16px;height:16px;float:left;}


.btn_top{
	border:0px;
	cursor:pointer;
	overflow:visible;
	font-size:12px;
}
.btn_top{
		padding-right:10px !important;
		height:23px;
		line-height:23px;
		background-color:#FFF;
		vertical-align:middle;
		border:1px solid #aecef1;
		margin-left:-6px;
		border:0px;
		cursor:pointer;
		overflow:visible;
		font-size:12px;
		color:#1098ff;
	}

</style>
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
							<a href="" target="tabcontentframe" _labelid="my"><%=SystemEnv.getHtmlLabelName(6059,user.getLanguage())%></a>
						</li>
						<li>
							<a href="" target="tabcontentframe" _labelid="all"><%=SystemEnv.getHtmlLabelName(84357,user.getLanguage())%></a>
						</li>
						<%if(newCustomerNumber>0){%>
						<li>
							<a href="" target="tabcontentframe" _labelid="new"><%=SystemEnv.getHtmlLabelName(16400,user.getLanguage())%></a>
						</li>
						<%}%>
						<li>
							<a href="" target="tabcontentframe" _labelid="attention"><%=SystemEnv.getHtmlLabelName(84358,user.getLanguage())%></a>
						</li>
						<%
						List labelList=CustomerLabelService.getLabelList(userid+"","all");          //标签列表
						for(int i=0;i<labelList.size();i++){ 
			                 CustomerLabelVO labelVO=(CustomerLabelVO)labelList.get(i);
			                 String isUsed=labelVO.getIsUsed();
			                 if(isUsed.equals("0")) continue;
			                 String id=labelVO.getId();
			                 String labelType=labelVO.getLabelType();
			                 String labelName=labelVO.getName();
			                 labelName=labelVO.getName();
			            %>
			            <li>
							<a href="" target="tabcontentframe" type='<%=labelType%>' _labelid='<%=id%>' title='<%=labelName%>'><%=labelName%></a>
						</li>
			            <%} %>
					</ul>
					<div id="rightBox" class="e8_rightBox"></div>
				</div>
			</div>
		</div>
		
		<div class="tab_box">
			<iframe src="" onload="update()" id="tabcontentframe" name="tabcontentframe" class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
			
		</div>
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
			objName:"<%=SystemEnv.getHtmlLabelName(6059,user.getLanguage())%>"
		});
		attachUrl();
	});
  
  function attachUrl(){
	
	$("a[target='tabcontentframe']").each(function(){
		
		var labelid=$(this).attr("_labelid");
		var url="/CRM/customer/CustomerMain.jsp?labelid="+labelid;
		$(this).attr("href",url);
		
		if("import" == labelid){
			$(this).attr("href","/CRM/data/NewCustomerList.jsp?"+new Date().getTime());
		}
		
	});
	$("[name='tabcontentframe']").attr("src",$("a[target='tabcontentframe']:eq(0)").attr("href"));
}

function refreshTab(){
}

function doMouseover(obj){
	var type=$(obj).attr("_type");
	$(obj).css("background-image","url('/CRM/images/icon_"+type+"_h_wev8.png')").css("color","#1098ff");
}

function doMouseout(obj){
	var type=$(obj).attr("_type");
	$(obj).css("background-image","url('/CRM/images/icon_"+type+"_wev8.png')").css("color","#1098ff");
}

</script>
</html>

