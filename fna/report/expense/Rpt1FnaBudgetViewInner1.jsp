<%@page import="weaver.fna.budget.BudgetYear"%>
<%@page import="weaver.systeminfo.label.LabelComInfo"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="weaver.fna.budget.Expense"%>
<%@page import="weaver.fna.budget.BudgetHandler"%>
<%@page import="weaver.fna.maintenance.FnaBudgetInfoComInfo"%>
<%@page import="weaver.fna.general.FnaSplitPageTransmethod"%>
<%@page import="weaver.hrm.resource.ResourceComInfo"%>
<%@page import="weaver.hrm.company.DepartmentComInfo"%>
<%@page import="weaver.hrm.company.SubCompanyComInfo"%>
<%@page import="weaver.hrm.company.CompanyComInfo"%>
<%@page import="weaver.conn.RecordSet"%>
<%@page import="weaver.fna.general.FnaBudgetLeftRuleSet"%>
<%@page import="org.apache.commons.lang.StringEscapeUtils"%>
<%@page import="weaver.fna.maintenance.BudgetfeeTypeComInfo"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="UserDefaultManager" class="weaver.docs.tools.UserDefaultManager" scope="session" />

<%
boolean canView = HrmUserVarify.checkUserRight("FnaBudget:All",user) ;
boolean canEdit = false;

if(!canView){
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = "";
String needfav ="1";
String needhelp ="";


RecordSet rs = new RecordSet();

String fnayear = Util.null2String(request.getParameter("fnayear"));
String projectid = Util.null2String(request.getParameter("projectid"));//来自项目模块界面
String crmid = Util.null2String(request.getParameter("crmid"));//来自客户模块界面
String organizationtype = Util.null2String(request.getParameter("organizationtype"));//组织类型
String organizationid = Util.null2String(request.getParameter("organizationid"));//组织ID
int budgetinfoid = Util.getIntValue(request.getParameter("budgetinfoid"), 0);//预算设置主表id
int budgetperiods = Util.getIntValue(request.getParameter("budgetperiods"), 0);//预算年度id
int status = Util.getIntValue(request.getParameter("status"), 0);//预算状态
int revision = Util.getIntValue(request.getParameter("revision"), 0);//预算版本
String guid1 = Util.null2String(request.getParameter("guid1"));
if("".equals(guid1)){
	guid1 = UUID.randomUUID().toString();
}
String goBackUrl = Util.null2String(request.getParameter("goBackUrl"));

if(!"".equals(projectid)){
	organizationtype = "prj";
	organizationid = projectid;
}else if(!"".equals(crmid)){
	organizationtype = "crm";
	organizationid = crmid;
}

if(budgetperiods<=0){
	rs.executeSql("select d1.id, d1.fnayear FROM FnaYearsPeriods d1 where d1.status = 1 order by fnayear desc");
	if(rs.next()){
		budgetperiods = rs.getInt("id");
	}else{
		rs.executeSql("select max(d1.id) id FROM FnaYearsPeriods d1");
		if(rs.next()){
			budgetperiods = rs.getInt("id");
		}
	}
}

boolean edit = false;//是否是要已编辑方式打开

String tabFeeperiod = Util.null2String(request.getParameter("tabFeeperiod")).trim();//打开预算周期tab页类型
if("".equals(tabFeeperiod)){
	tabFeeperiod = "M";
}


String nameQuery = Util.null2String(request.getParameter("nameQuery")).trim();
request.getSession().setAttribute("FnaBudgetViewInner1.jsp_nameQuery_"+guid1, nameQuery);

String commonPara = "projectid="+projectid+"&organizationtype="+organizationtype+"&organizationid="+organizationid+"&budgetinfoid="+budgetinfoid+"&budgetperiods="+budgetperiods+
	"&status="+status+"&revision="+revision+"&fnayear="+fnayear+"&guid1="+guid1;


DecimalFormat df = new DecimalFormat("####################################################0.00");

String orgTypeName = "";
String orgName = "";

if("crm".equals(organizationtype)){//客户
	orgTypeName = SystemEnv.getHtmlLabelName(136,user.getLanguage());
	String sql = "select name from CRM_CustomerInfo where id = "+Util.getIntValue(organizationid);
	rs.executeSql(sql);
	if(rs.next()){
		orgName = Util.null2String(rs.getString("name")).trim();
	}
}else if("prj".equals(organizationtype)){//项目
	orgTypeName = SystemEnv.getHtmlLabelName(101,user.getLanguage());
	String sql = "select name from Prj_ProjectInfo where id = "+Util.getIntValue(organizationid);
	rs.executeSql(sql);
	if(rs.next()){
		orgName = Util.null2String(rs.getString("name")).trim();
	}
}

String sql = "";

%>
<html>
<head>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<link type="text/css" href="/js/tabs/css/e8tabs2_wev8.css" rel="stylesheet" />
<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>

<script language="javascript" src="/js/weaver_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<script language="javascript" src="/fna/js/e8Common_wev8.js?r=3"></script>
</head>
<body style="overflow:hidden;">
<form name="form2" method="post"  action="/fna/report/expense/Rpt1FnaBudgetViewInner1.jsp">


<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<input type="text" class="searchInput" id="nameQuery" name="nameQuery" value="<%=nameQuery %>" /><!-- 快速搜索 -->
			&nbsp;&nbsp;&nbsp;
			<span id="advancedSearch" class="advancedSearch" style="display: none;"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage()) %></span><!-- 高级搜索 -->
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu"></span><!-- 菜单 -->
		</td>
	</tr>
</table>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<div id="div111">
<wea:layout type="4col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage()) %>'><!-- 基本信息 -->
		<wea:item><%=orgTypeName %></wea:item><!-- 客户、项目 -->
		<wea:item>
			<%=orgName %><span style="color: black; font-weight: bold;"></span>
       		<input id="organizationtype" name="organizationtype" value="<%=organizationtype%>" type="hidden" />
       		<input id="organizationid" name="organizationid" value="<%=organizationid%>" type="hidden" />
       		<input id="status" name="status" value="<%=status%>" type="hidden" />
       		<input id="revision" name="revision" value="<%=revision%>" type="hidden" />
       		<input id="tabFeeperiod" name="tabFeeperiod" value="<%=tabFeeperiod%>" type="hidden" />
       		<input id="guid1" name="guid1" value="<%=guid1%>" type="hidden" />
       		<input id="budgetinfoid" name="budgetinfoid" value="<%=budgetinfoid%>" type="hidden" />
       	</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(15365,user.getLanguage()) %></wea:item><!-- 预算年度 -->
		<wea:item>
	        <select class="inputstyle" id="budgetperiods" name="budgetperiods" onchange="feeperiod_onchange();" style="width: 80px;">
			<%
			sql = "select a.id, a.fnayear from FnaYearsPeriods a WHERE a.status in (1, -1) ORDER BY a.fnayear DESC ";
			rs.executeSql(sql);
			while(rs.next()){
				int _id = rs.getInt("id");
				int _fnayear = rs.getInt("fnayear");
			%>
				<option value="<%=_id %>" <% if(_id == budgetperiods){%>selected<%}%>><%=_fnayear%></option>
			<%
			}
			%>
	        </select>
       	</wea:item>
       	
	</wea:group>
</wea:layout>
</div>

<!-- 预算设置明细数据 -->
<%
String fnaBudgetViewInnerUrl = "/fna/report/expense/Rpt1FnaBudgetViewInner.jsp";

String fnaBudgetViewDataMurl = "/fna/report/expense/Rpt1FnaBudgetViewData.jsp?"+commonPara+"&tabFeeperiod=M";
String fnaBudgetViewDataQurl = "/fna/report/expense/Rpt1FnaBudgetViewData.jsp?"+commonPara+"&tabFeeperiod=Q";
String fnaBudgetViewDataHurl = "/fna/report/expense/Rpt1FnaBudgetViewData.jsp?"+commonPara+"&tabFeeperiod=H";
String fnaBudgetViewDataYurl = "/fna/report/expense/Rpt1FnaBudgetViewData.jsp?"+commonPara+"&tabFeeperiod=Y";

String fnaBudgetViewDataUrl = "";

String tab_menu_m_className = "";
String tab_menu_q_className = "";
String tab_menu_h_className = "";
String tab_menu_y_className = "";

if("M".equals(tabFeeperiod)){
	fnaBudgetViewDataUrl = fnaBudgetViewDataMurl;
	tab_menu_m_className = "class=\"current\"";
}else if("Q".equals(tabFeeperiod)){
	fnaBudgetViewDataUrl = fnaBudgetViewDataQurl;
	tab_menu_q_className = "class=\"current\"";
}else if("H".equals(tabFeeperiod)){
	fnaBudgetViewDataUrl = fnaBudgetViewDataHurl;
	tab_menu_h_className = "class=\"current\"";
}else if("Y".equals(tabFeeperiod)){
	fnaBudgetViewDataUrl = fnaBudgetViewDataYurl;
	tab_menu_y_className = "class=\"current\"";
}
%>
<div class="e8_box demo2 e8_boxInner1">
    <ul id="ulInfo1" class="tab_menu">
		<li <%=tab_menu_m_className %>>
			<a id="divMainInfo_m" onclick="tabMainInfo_onclick('<%=fnaBudgetViewDataMurl %>',<%=canEdit %>,<%=edit %>);return false;" href="#"><%=SystemEnv.getHtmlLabelName(15370,user.getLanguage()) %></a><!-- 月度预算 -->
		</li>
		<li <%=tab_menu_q_className %>>
			<a id="divMainInfo_q" onclick="tabMainInfo_onclick('<%=fnaBudgetViewDataQurl %>',<%=canEdit %>,<%=edit %>);return false;" href="#"><%=SystemEnv.getHtmlLabelName(15373,user.getLanguage()) %></a><!-- 季度预算 -->
		</li>
		<li <%=tab_menu_h_className %>>
			<a id="divMainInfo_h" onclick="tabMainInfo_onclick('<%=fnaBudgetViewDataHurl %>',<%=canEdit %>,<%=edit %>);return false;" href="#"><%=SystemEnv.getHtmlLabelName(15374,user.getLanguage()) %></a><!-- 半年预算 -->
		</li>
		<li <%=tab_menu_y_className %>>
			<a id="divMainInfo_y" onclick="tabMainInfo_onclick('<%=fnaBudgetViewDataYurl %>',<%=canEdit %>,<%=edit %>);return false;" href="#"><%=SystemEnv.getHtmlLabelName(15375,user.getLanguage()) %></a><!-- 年度预算 -->
		</li>
    </ul>
    <div id="rightBox" class="e8_rightBox">
    </div>
    <div class="tab_box">
        <div>
			<iframe src="<%=fnaBudgetViewDataUrl %>" onload="update();reSize_frmTabcontentframe2();" id="tabcontentframe2" name="tabcontentframe2" class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
        </div>
    </div>
</div> 

<!-- advanced search -->
<div class="advancedSearchDiv" id="advancedSearchDiv" style="display: none;">
</div>

<script language="javascript">
//tab切换事件
function tabMainInfo_onclick(_url,canEdit,edit){
	document.getElementById("tabcontentframe2").src = _url;
}

//快速（高级）搜索事件
function onBtnSearchClick(from_advSubmit){
	form2.submit();
}

function hideToolBarBtn(){
	if(parent!=null){
		parent.jQuery("#tabcontentframe1_box").hide();
		parent.jQuery("#btnSave").hide();
		parent.jQuery("#btnSave1").hide();
		parent.jQuery("#btnSaveAppover").hide();
		parent.jQuery("#btnReturn").hide();
		parent.jQuery("#btnImp").hide();
		parent.jQuery("#btnEdit").hide();
	}else{
		jQuery("#tabcontentframe1_box").hide();
		jQuery("#btnSave").hide();
		jQuery("#btnSave1").hide();
		jQuery("#btnSaveAppover").hide();
		jQuery("#btnReturn").hide();
		jQuery("#btnImp").hide();
		jQuery("#btnEdit").hide();
	}
}
function showToolBarBtn(){
	if(parent!=null){
		parent.jQuery("#tabcontentframe1_box").show();
		parent.jQuery("#btnSave").show();
		parent.jQuery("#btnSave1").show();
		parent.jQuery("#btnSaveAppover").show();
		parent.jQuery("#btnReturn").show();
		parent.jQuery("#btnImp").show();
		parent.jQuery("#btnEdit").show();
	}else{
		jQuery("#tabcontentframe1_box").show();
		jQuery("#btnSave").show();
		jQuery("#btnSave1").show();
		jQuery("#btnSaveAppover").show();
		jQuery("#btnReturn").show();
		jQuery("#btnImp").show();
		jQuery("#btnEdit").show();
	}
}

function viewFna(_obj){
	hideToolBarBtn();
	window.location.href = "<%=goBackUrl %>";
}

function feeperiod_onchange(){
	var organizationtype = jQuery("#organizationtype").val();
	var organizationid = jQuery("#organizationid").val();
	var budgetinfoid = "";
	var budgetperiods = jQuery("#budgetperiods").val();
	var status = "";
	var revision = "";
	var tabFeeperiod = jQuery("#tabFeeperiod").val();
	
	var commonPara = "organizationtype="+organizationtype+"&organizationid="+organizationid+"&budgetinfoid="+budgetinfoid+"&budgetperiods="+budgetperiods+
		"&status="+status+"&revision="+revision+"&tabFeeperiod="+tabFeeperiod;
	parent.location.href = "<%=fnaBudgetViewInnerUrl %>?"+commonPara;
}

var _init_frmTabcontentframe2_height = 0;
var _is_reSize_frmTabcontentframe2 = false;
function reSize_frmTabcontentframe2(){
	/*
	if(!_is_reSize_frmTabcontentframe2){
		_is_reSize_frmTabcontentframe2 = true;
		var _frmTabcontentframe2 = document.getElementById("tabcontentframe2");
		var h1 = _frmTabcontentframe2.style.height.replace("px", "");
		if(_init_frmTabcontentframe2_height <= 0){
			_init_frmTabcontentframe2_height = fnaRound(h1, 0);
		}
		var _ulInfo1 = jQuery("#ulInfo1");
		var h21 = _ulInfo1.css("line-height").replace("px", "");
		var _div111 = jQuery("#div111");
		var h22 = _div111.css("height").replace("px", "");
		var h2 = fnaRound(fnaRound(h22, 0)+(fnaRound(h21, 0)/2), 0);
		var h3 = fnaRound(fnaRound(_init_frmTabcontentframe2_height, 0)-fnaRound(h2, 0), 0);
		_frmTabcontentframe2.style.height=h3+"px";
	}
	*/
}

jQuery('.e8_boxInner1').Tabs({
	getLine:1,
	iframe:"tabcontentframe2",
	staticOnLoad:true
});

</script>
</form>
</body>
</html>
