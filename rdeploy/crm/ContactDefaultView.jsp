
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.hrm.resource.ResourceComInfo"%>
<%@page import="weaver.task.CommonTransUtil"%>
<%@page import="java.net.URLDecoder"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.WorkPlan.WorkPlanShareUtil"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="CustomerService" class="weaver.crm.customer.CustomerService" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="CommonTransUtil" class="weaver.task.CommonTransUtil" scope="page" />
<%
	String userid = user.getUID()+"";
	String labelid=Util.null2String(request.getParameter("labelid"),"my");       //标签id my我的客户，all全部客户，attention关注客户
	String resourceid=Util.null2String(request.getParameter("resourceid"),""+userid);    //被查看人id
	String viewtype=Util.null2String(request.getParameter("viewtype"),"0");              //查看类型 0仅本人，1包含下属，2仅下属
	String feedbackType=Util.null2String(request.getParameter("feedbackType"),"0");      //反馈类型 0 全部反馈 1本人反馈 2 他人指导
	String sector=Util.null2String(request.getParameter("sector")); //行业
	String status=Util.null2String(request.getParameter("status")); //状态
	String name =URLDecoder.decode( Util.null2String(request.getParameter("name"))); //名称
	
	String datatype = Util.null2String(request.getParameter("datatype"),"1");
	
%>

<LINK href="/CRM/css/Contact_wev8.css" type=text/css rel=STYLESHEET>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<LINK href="/CRM/css/Base1_wev8.css" type=text/css rel=STYLESHEET>
<LINK href="/CRM/css/Base_wev8.css" type=text/css rel=STYLESHEET>

<script type="text/javascript" src="/cowork/js/kkpager/kkpager_wev8.js"></script>
<link rel="stylesheet" href="/cowork/js/kkpager/kkpager_wev8.css" type="text/css"/>

<script type="text/javascript" src="/CRM/js/customerUtil_wev8.js"></script>

<style>
#listoperate{
	border-bottom: 1px solid #f2f2f2;
	height: 40px;
  	line-height: 40px;
}
.xTable_message, #loading{
	background-image:url('/express/task/images/loading1_wev8.gif') !important;
	border:0px;
}

</style>


<div id="listoperate">
	<div style="margin-left:5px;">
		<span style="color:#8e9598;margin-right:10px;">客户联系</span>
		<select name="datatype" id="datatype" onchange="loadDefault()">
				<option value="1" <%=datatype.equals("1")?"selected":""%>><%=SystemEnv.getHtmlLabelName(83223,user.getLanguage())%></option>
				<option value="2" <%=datatype.equals("2")?"selected":""%>><%=SystemEnv.getHtmlLabelName(83224,user.getLanguage())%></option>
				<option value="3" <%=datatype.equals("3")?"selected":""%>><%=SystemEnv.getHtmlLabelName(84343,user.getLanguage())%></option>
				<option value="4" <%=datatype.equals("4")?"selected":""%>><%=SystemEnv.getHtmlLabelName(83225,user.getLanguage())%></option>
				<option value="0" <%=datatype.equals("0")?"selected":""%>><%=SystemEnv.getHtmlLabelName(82857,user.getLanguage())%></option>
		</select>
	</div>
</div>

<div class="tabStyle2" id="topMenu" style="display:none;">
	<div class="tabitem <%=feedbackType.equals("0")?"select2":""%>" url="/CRM/data/ViewContactLog.jsp?isfromtab=true&from=default">
		<div class="title"><A href="javascript:void(0)"><%=SystemEnv.getHtmlLabelName(6082,user.getLanguage())%></A></div>
		<div class="arrow"></div>
	</div>
	<div class="tabitem <%=feedbackType.equals("1")?"select2":""%>" url="/CRM/customer/ContacterCard.jsp?from=default">
		<div class="title"><A href="javascript:void(0)"><%=SystemEnv.getHtmlLabelName(572,user.getLanguage())%></A></div>
		<div class="arrow"></div>
		<div class="tabseprator"></div>
	</div>
	<div class="tabitem <%=feedbackType.equals("2")?"select2":""%>" url="/CRM/data/ViewMessageLog.jsp?from=default&isfromtab=true">
		<div class="title"><A href="javascript:void(0)"><%=SystemEnv.getHtmlLabelName(84344,user.getLanguage())%></A></div>
		<div class="arrow"></div>
		<div class="tabseprator"></div>
	</div>
	<div class="tabitem <%=feedbackType.equals("2")?"select2":""%>" url="/CRM/customer/SellChanceCard.jsp?from=default">
		<div class="title"><A href="javascript:void(0)"><%=SystemEnv.getHtmlLabelName(2227,user.getLanguage())%></A></div>
		<div class="arrow"></div>
		<div class="tabseprator"></div>
	</div>
</div>

<div id="contentdiv">
	<iframe id='contentframe' src='' height=100% width="100%" border=0 frameborder="0" scrolling="auto"></iframe>
</div>

<div id="loading" class="loading" align='center'></div>


<script>
$(document).ready(function(){

	var operateHeight=$("#listoperate").height();
	var mainHeight=document.body.clientHeight;
	var operateHeight=$("#topMenu").height();
	$("#contentdiv").height(mainHeight-operateHeight);
	
	createIframeLinster("contentframe");
	
	loadDefault();
	
	jQuery(".tabitem").click(function(obj){
		jQuery(".tabitem").removeClass("select2");
		$(this).addClass("select2");
		loadDefault();
	});
	
});

function loadDefault(){

	var datatype=$("#datatype").val();

	//var url=$(".select2").attr("url");
	var url="/CRM/data/ViewContactLog.jsp?isfromtab=true&from=rdeploy";
	url+="&labelid=<%=labelid%>&resourceid=<%=resourceid%>&viewtype=<%=viewtype%>&sector=<%=sector%>&status=<%=status%>&datatype="+datatype;
	
	displayLoading(1);
	
	$("#contentframe").attr("src",url);
}

</script>
