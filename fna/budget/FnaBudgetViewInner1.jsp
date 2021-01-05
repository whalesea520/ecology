<%@page import="weaver.fna.maintenance.FnaYearsPeriodsComInfo"%>
<%@page import="weaver.fna.maintenance.FnaSystemSetComInfo"%>
<%@page import="weaver.fna.general.FnaCommon"%>
<%@page import="weaver.fna.maintenance.FnaCostCenter"%>
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
<%
boolean canView = HrmUserVarify.checkUserRight("BudgetAuthorityRule:readOnly", user);//预算编制只读权限
boolean canEdit = (HrmUserVarify.checkUserRight("FnaBudget:View", user) || 
		HrmUserVarify.checkUserRight("FnaBudgetEdit:Edit", user) || 
		HrmUserVarify.checkUserRight("BudgetAuthorityRule:edit", user));//财务预算维护、预算编制权限
boolean canEditSp1 = canEdit;

if(!canView && !canEdit){
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}

FnaSystemSetComInfo fnaSystemSetComInfo = new FnaSystemSetComInfo();
int budgetControlType2 = Util.getIntValue(fnaSystemSetComInfo.get_budgetControlType2(), 0);

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = "";
String needfav ="1";
String needhelp ="";


RecordSet rs = new RecordSet();

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

boolean isClearTmpData = "true".equalsIgnoreCase(Util.null2String(request.getParameter("isClearTmpData")).trim());//是否打开时清除，放入内存中的临时编辑数据
if(isClearTmpData){
	session.removeAttribute("FnaBudgetEditSaveFnaAjax.jsp_mbudgetvalues_"+guid1); 
	session.removeAttribute("FnaBudgetEditSaveFnaAjax.jsp_msubject3names_"+guid1);
	session.removeAttribute("FnaBudgetEditSaveFnaAjax.jsp_qbudgetvalues_"+guid1);
	session.removeAttribute("FnaBudgetEditSaveFnaAjax.jsp_qsubject3names_"+guid1);
	session.removeAttribute("FnaBudgetEditSaveFnaAjax.jsp_hbudgetvalues_"+guid1);
	session.removeAttribute("FnaBudgetEditSaveFnaAjax.jsp_hsubject3names_"+guid1);
	session.removeAttribute("FnaBudgetEditSaveFnaAjax.jsp_ybudgetvalues_"+guid1);
	session.removeAttribute("FnaBudgetEditSaveFnaAjax.jsp_ysubject3names_"+guid1);
	session.removeAttribute("FnaBudgetEditSaveFnaAjax.jsp_budgetValues_"+guid1);
	session.removeAttribute("FnaBudgetEditSaveFnaAjax.jsp_subjectNames_"+guid1);
}


boolean edit = "true".equalsIgnoreCase(Util.null2String(request.getParameter("edit")).trim());//是否是要已编辑方式打开

if(canEdit){
	String sql = "select count(*) cnt from FnaYearsPeriods where id = "+budgetperiods+" and status in (0,1) ";
	rs.executeSql(sql);
	if(!(rs.next() && rs.getInt("cnt") == 1)){
		canEdit = false;
		canEditSp1 = canEdit;
	}
}

if(canEdit){
	if(!FnaBudgetInfoComInfo.getSupOrgIdHaveEnableFnaBudgetRevision(organizationid, organizationtype, budgetperiods+"")){
		canEdit = false;
		canEditSp1 = canEdit;
	}
}

if(canEdit && budgetinfoid > 0){
	String sql = "select count(*) cnt from FnaBudgetInfo a where a.id = "+budgetinfoid+" and a.status in (0,1)";
	rs.executeSql(sql);
	if(!(rs.next() && rs.getInt("cnt") == 1)){
		canEdit = false;
	}
}

String FnaCommon_checkPermissionsFnaBudgetForEdit = "FnaCommon_checkPermissionsFnaBudgetForEdit_orgType_"+organizationtype+"_orgId_"+organizationid+"_userId_"+user.getUID();
boolean fnaBudgetViewFlagForEdit = false;
if(request.getSession().getAttribute(FnaCommon_checkPermissionsFnaBudgetForEdit)==null){
	fnaBudgetViewFlagForEdit = FnaCommon.checkPermissionsFnaBudgetForEdit(organizationtype, organizationid, user.getUID());
	request.getSession().setAttribute(FnaCommon_checkPermissionsFnaBudgetForEdit, fnaBudgetViewFlagForEdit?"true":"false");
}else{
	fnaBudgetViewFlagForEdit = "true".equalsIgnoreCase((String)request.getSession().getAttribute(FnaCommon_checkPermissionsFnaBudgetForEdit));
}
String FnaCommon_checkPermissionsFnaBudgetForView = "FnaCommon_checkPermissionsFnaBudgetForView_orgType_"+organizationtype+"_orgId_"+organizationid+"_userId_"+user.getUID();
boolean fnaBudgetViewFlagForView = false;
if(request.getSession().getAttribute(FnaCommon_checkPermissionsFnaBudgetForView)==null){
	fnaBudgetViewFlagForView = FnaCommon.checkPermissionsFnaBudgetForView(organizationtype, organizationid, user.getUID());
	request.getSession().setAttribute(FnaCommon_checkPermissionsFnaBudgetForView, fnaBudgetViewFlagForView?"true":"false");
}else{
	fnaBudgetViewFlagForView = "true".equalsIgnoreCase((String)request.getSession().getAttribute(FnaCommon_checkPermissionsFnaBudgetForView));
}
//如果没有传入具体哪个预算机构，或者有传入具体哪个预算机构，并判断为不允许允许查看的，则提示无权限
if(!fnaBudgetViewFlagForEdit && !fnaBudgetViewFlagForView){
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
if(canView){
	if(!fnaBudgetViewFlagForView){
		canView = false;
		canEdit = false;
		canEditSp1 = canEdit;
	}
}
if(canEdit){
	if(!fnaBudgetViewFlagForEdit){
		canEdit = false;
		canEditSp1 = canEdit;
	}
}


String tabFeeperiod = Util.null2String(request.getParameter("tabFeeperiod")).trim();//打开预算周期tab页类型
String tab_menu_m_display = "display: none;";
String tab_menu_q_display = "display: none;";
String tab_menu_h_display = "display: none;";
String tab_menu_y_display = "display: none;";
rs.executeSql("select DISTINCT a.feeperiod from FnaBudgetfeeType a where a.feelevel=1 order by a.feeperiod");
while(rs.next()){
	int _feeperiod = rs.getInt("feeperiod");
	if(_feeperiod==1){
		if("".equals(tabFeeperiod)){
			tabFeeperiod = "M";
		}
		tab_menu_m_display = "";
	}else if(_feeperiod==2){
		if("".equals(tabFeeperiod)){
			tabFeeperiod = "Q";
		}
		tab_menu_q_display = "";
	}else if(_feeperiod==3){
		if("".equals(tabFeeperiod)){
			tabFeeperiod = "H";
		}
		tab_menu_h_display = "";
	}else if(_feeperiod==4){
		if("".equals(tabFeeperiod)){
			tabFeeperiod = "Y";
		}
		tab_menu_y_display = "";
	}
}
if("".equals(tabFeeperiod)){
	tabFeeperiod = "M";
}


String nameQuery = Util.null2String(request.getParameter("nameQuery")).trim();
request.getSession().setAttribute("FnaBudgetViewInner1.jsp_nameQuery_"+guid1, nameQuery);

int showNilQuery = Util.getIntValue(request.getParameter("showNilQuery"), 0);
if(edit){
	showNilQuery = 1;
}
request.getSession().setAttribute("FnaBudgetViewInner1.jsp_hiddenNilQuery_"+guid1, showNilQuery+"");

String commonPara = "organizationtype="+organizationtype+"&organizationid="+organizationid+"&budgetinfoid="+budgetinfoid+"&budgetperiods="+budgetperiods+
	"&status="+status+"&revision="+revision+"&guid1="+guid1;

FnaYearsPeriodsComInfo fnaYearsPeriodsComInfo = new FnaYearsPeriodsComInfo();
String startdate = fnaYearsPeriodsComInfo.get_startdate(String.valueOf(budgetperiods));
String enddate = fnaYearsPeriodsComInfo.get_enddate(String.valueOf(budgetperiods));

DecimalFormat df = new DecimalFormat("####################################################0.00");
FnaSplitPageTransmethod fnaSplitPageTransmethod = new FnaSplitPageTransmethod();
CompanyComInfo cci = new CompanyComInfo();
SubCompanyComInfo scci = new SubCompanyComInfo();
DepartmentComInfo dci = new DepartmentComInfo();
ResourceComInfo rci = new ResourceComInfo();
FnaBudgetInfoComInfo fnaBudgetInfoComInfo = new FnaBudgetInfoComInfo();
BudgetHandler budgetHandler = new BudgetHandler();

String orgTypeName = "";
String orgName = "";

if("0".equals(organizationtype)){
	orgTypeName = SystemEnv.getHtmlLabelName(140,user.getLanguage());//总部
	orgName = cci.getCompanyname(organizationid);
}else if("1".equals(organizationtype)){
	orgTypeName = SystemEnv.getHtmlLabelName(141,user.getLanguage());//分部
	orgName = scci.getSubCompanyname(organizationid);
}else if("2".equals(organizationtype)){
	orgTypeName = SystemEnv.getHtmlLabelName(124,user.getLanguage());//部门
	orgName = dci.getDepartmentName(organizationid);
}else if("3".equals(organizationtype)){
	orgTypeName = SystemEnv.getHtmlLabelName(6087,user.getLanguage());//个人
	orgName = rci.getLastname(organizationid);
}else if((FnaCostCenter.ORGANIZATION_TYPE+"").equals(organizationtype)){
	orgTypeName = SystemEnv.getHtmlLabelName(515,user.getLanguage());//成本中心
	rs.executeSql("select name from FnaCostCenter where id = "+Util.getIntValue(organizationid));
	if(rs.next()){
		orgName = Util.null2String(rs.getString("name")).trim();
	}
}

double budgetaccount = fnaBudgetInfoComInfo.getBudgetAmount(budgetinfoid+"");

double yfpJe = 0.0;
if(budgetControlType2==1){
	yfpJe = fnaBudgetInfoComInfo.getRecursiveSubOrgBudgetAmount(organizationid, organizationtype, budgetperiods+"");
}else{
	yfpJe = fnaBudgetInfoComInfo.getDistributiveBudgetAmount(organizationid, organizationtype, budgetperiods+"");
}

Expense expense = budgetHandler.getExpenseRecursion(startdate, enddate, Util.getIntValue(organizationtype), Util.getIntValue(organizationid), 0, 0, 0, 0, false);
double yfsJe = expense.getRealExpense();
double spzJe = expense.getPendingExpense();


String budgetaccountName = "";
String yfpJeName = "";
String yfsJeName = "";
String spzJeName = "";

double ysyJe = 0.0;
if(budgetControlType2==1){
	ysyJe = Util.getDoubleValue(df.format(yfsJe + spzJe), 0.00);
}else{
	ysyJe = Util.getDoubleValue(df.format(yfpJe + yfsJe + spzJe), 0.00);
}
if(budgetaccount > ysyJe){
	budgetaccountName = "<font color='green'>"+fnaSplitPageTransmethod.fmtAmountQuartile(budgetaccount)+"</font>";
}else if(budgetaccount < ysyJe){
	budgetaccountName = "<font color='red'>"+fnaSplitPageTransmethod.fmtAmountQuartile(budgetaccount)+"</font>";
}else{
	budgetaccountName = fnaSplitPageTransmethod.fmtAmountQuartile(budgetaccount);
}
if(budgetControlType2!=1 && yfpJe > budgetaccount){
	yfpJeName = "<font color='red'>"+fnaSplitPageTransmethod.fmtAmountQuartile(yfpJe)+"</font>";
}else{
	yfpJeName = fnaSplitPageTransmethod.fmtAmountQuartile(yfpJe);
}
if(yfsJe > budgetaccount){
	yfsJeName = "<font color='red'>"+fnaSplitPageTransmethod.fmtAmountQuartile(yfsJe)+"</font>";
}else{
	yfsJeName = fnaSplitPageTransmethod.fmtAmountQuartile(yfsJe);
}
if(spzJe > budgetaccount){
	spzJeName = "<font color='red'>"+fnaSplitPageTransmethod.fmtAmountQuartile(spzJe)+"</font>";
}else{
	spzJeName = fnaSplitPageTransmethod.fmtAmountQuartile(spzJe);
}
%>
<html>
<head>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<link type="text/css" href="/js/tabs/css/e8tabs2_wev8.css" rel="stylesheet" />
<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>

<script language="javascript" src="/js/weaver_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<script language="javascript" src="/fna/js/e8Common_wev8.js?r=13"></script>
<script type="text/javascript">
var _Label33574 = "<%=SystemEnv.getHtmlLabelName(33574,user.getLanguage()) %>";//正在处理数据，请不要离开该页面，请稍等...
</script>
</head>
<body style="overflow:hidden;">
<form name="form2" method="post"  action="/fna/budget/FnaBudgetViewInner1.jsp">

<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
<%
boolean isApprove = false;//是否允许批准生效
boolean isSubmitApprove = false;//是否需要提交审批

String sql = "";
if(canEdit && edit){
	isApprove = true;
	isSubmitApprove = false;
	if("0".equals(organizationtype)){
		sql = "select count(*) cnt from BudgetAuditMapping a where a.subcompanyid = 0";
	}else if("1".equals(organizationtype)){
		sql = "select count(*) cnt from BudgetAuditMapping a where a.subcompanyid = "+organizationid;
	}else if("2".equals(organizationtype)){
		sql = "select count(*) cnt from BudgetAuditMapping a join HrmDepartment b on a.subcompanyid = b.subcompanyid1 where a.subcompanyid = "+dci.getSubcompanyid1(organizationid);
	}else if("3".equals(organizationtype)){
		sql = "select count(*) cnt from BudgetAuditMapping a join HrmResource b on a.subcompanyid = b.subcompanyid1 where a.subcompanyid = "+rci.getSubCompanyID(organizationid);
	}else if((FnaCostCenter.ORGANIZATION_TYPE+"").equals(organizationtype)){
		sql = "select count(*) cnt from BudgetAuditMapping a where a.fccId = "+organizationid;
	}
	rs.executeSql(sql);
	if(rs.next() && rs.getInt("cnt") > 0){
		isSubmitApprove = true;
	}
	if(isSubmitApprove){//如果有设置过审批流程，则不允许批准生效
		isApprove = false;
	}
	sql = "select count(*) cnt from FnaBudgetInfo a "+
		" where a.organizationtype = "+organizationtype+" and a.budgetorganizationid = "+organizationid+" and a.budgetperiods = "+budgetperiods+" "+
		" and a.status = 3";
	rs.executeSql(sql);
	if(rs.next() && rs.getInt("cnt") > 0){//如果有审批中的预算信息，则不允许批准生效和提交审批
		isApprove = false;
		isSubmitApprove = false;
	}
	RCMenu += "{" + SystemEnv.getHtmlLabelName(86, user.getLanguage())+",javascript:saveFnaBtn(),_self} ";
	RCMenuHeight += RCMenuHeightStep;
%>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>" id="btnSave"
				class="e8_btn_top" onclick="saveFnaBtn();"/><!-- 保存 -->
		<%
		if(isSubmitApprove){
			RCMenu += "{" + SystemEnv.getHtmlLabelName(15143, user.getLanguage())+",javascript:submitApprovalFna(),_self} ";
			RCMenuHeight += RCMenuHeightStep;
		%>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(15143,user.getLanguage()) %>" id="btnSave1"
				class="e8_btn_top" onclick="submitApprovalFna();"/><!-- 提交审批 -->
		<%
		}else if(isApprove){
			RCMenu += "{" + SystemEnv.getHtmlLabelName(33061, user.getLanguage())+",javascript:approveFna(),_self} ";
			RCMenuHeight += RCMenuHeightStep;
		%>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(33061,user.getLanguage()) %>" id="btnSaveAppover"
				class="e8_btn_top" onclick="approveFna();"/><!-- 批准生效 -->
		<%
		}
		RCMenu += "{" + SystemEnv.getHtmlLabelName(1290, user.getLanguage())+",javascript:viewFna(),_self} ";
		RCMenuHeight += RCMenuHeightStep;
		RCMenu += "{" + SystemEnv.getHtmlLabelName(20209, user.getLanguage())+",javascript:doImp_grid("+budgetinfoid+"),_self} ";
		RCMenuHeight += RCMenuHeightStep;
		%>				
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(1290,user.getLanguage()) %>" id="btnReturn"
				class="e8_btn_top" onclick="viewFna();"/><!-- 返回 -->
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(20209,user.getLanguage()) %>" id="btnImp" 
				class="e8_btn_top" onclick="doImp_grid(<%=budgetinfoid %>)"/><!-- 预算导入 -->
<%
}else if(canEdit){
	RCMenu += "{" + SystemEnv.getHtmlLabelName(93, user.getLanguage())+",javascript:editFna(),_self} ";
	RCMenuHeight += RCMenuHeightStep;
	RCMenu += "{" + SystemEnv.getHtmlLabelName(20209, user.getLanguage())+",javascript:doImp_grid("+budgetinfoid+"),_self} ";
	RCMenuHeight += RCMenuHeightStep;
%>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(93,user.getLanguage()) %>" id="btnEdit"
				class="e8_btn_top" onclick="editFna();"/><!-- 编辑 -->
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(20209,user.getLanguage()) %>" id="btnImp" 
				class="e8_btn_top" onclick="doImp_grid(<%=budgetinfoid %>)"/><!-- 预算导入 -->
<%
}
if(canEditSp1 && user.getUID()==1 && status==2){//只有系统管理员才有权限做这件事
	RCMenu += "{" + SystemEnv.getHtmlLabelName(126814, user.getLanguage())+",javascript:save2DraftVersion(),_self} ";//（将历史版本）保存为草稿版本
	RCMenuHeight += RCMenuHeightStep;
}
%>
<%
if(!edit){
%>
			<span style="font-size:12px;line-height:43px;text-align:center;font-weight: normal;">
							<input type="checkbox" id="showNilQuery" name="showNilQuery" value="1" notBeauty="true" 
								<%=showNilQuery==1?"checked=\"checked\"":"" %>
								onclick="window.tabcontentframe.onBtnSearchClick();" />
				<label for="showNilQuery" style="margin-right: 5px;" onclick="window.tabcontentframe.onBtnSearchClick();"><%=SystemEnv.getHtmlLabelName(82841,user.getLanguage())%></label>
			</span>
<%
}
%>
			<input type="text" class="searchInput" id="nameQuery" name="nameQuery" value="<%=FnaCommon.escapeHtml(nameQuery) %>" /><!-- 快速搜索 -->
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
		<wea:item><%=SystemEnv.getHtmlLabelName(33062,user.getLanguage()) %></wea:item><!-- 组织机构 -->
		<wea:item>
			<%=orgName %><span style="color: black; font-weight: bold;">(<%=FnaCommon.escapeHtml(orgTypeName) %>)</span>
       		<input id="organizationtype" name="organizationtype" value="<%=organizationtype%>" type="hidden" />
       		<input id="organizationid" name="organizationid" value="<%=organizationid%>" type="hidden" />
       		<input id="status" name="status" value="<%=status%>" type="hidden" />
       		<input id="revision" name="revision" value="<%=revision%>" type="hidden" />
       		<input id="tabFeeperiod" name="tabFeeperiod" value="<%=tabFeeperiod%>" type="hidden" />
       		<input id="guid1" name="guid1" value="<%=guid1%>" type="hidden" />
       		<input id="edit" name="edit" value="<%=edit%>" type="hidden" />
       		<input id="budgetinfoid" name="budgetinfoid" value="<%=budgetinfoid%>" type="hidden" />
       	</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(15365,user.getLanguage()) %></wea:item><!-- 预算年度 -->
		<wea:item>
	        <select class="inputstyle" id="budgetperiods" name="budgetperiods" onchange="feeperiod_onchange();" style="width: 80px;">
			<%
			sql = "select a.id, a.fnayear from FnaYearsPeriods a ORDER BY a.fnayear DESC ";
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
	        
			<%
			//设置好搜索条件
			String backFields ="a.id, a.revision, a.status, a.createrid, a.createdate, a.organizationtype, a.budgetorganizationid, a.budgetperiods ";
			String fromSql = " from FnaBudgetInfo a \n";
			String sqlWhere = " where a.organizationtype = "+organizationtype+" and a.budgetorganizationid = "+organizationid+" and a.budgetperiods = "+budgetperiods+" \n";
			String groupBy = " GROUP BY a.id, a.status, a.revision, a.createrid, a.createdate, a.organizationtype, a.budgetorganizationid, a.budgetperiods ";
			sqlWhere += groupBy;
			String orderBy=" (case when (a.status=1 or a.status=3) then 3 when (a.status=0) then 2 else 1 end) desc, a.revision desc";
			
			sql = "select "+backFields+" "+fromSql+" "+sqlWhere+" order by "+orderBy;
			rs.executeSql(sql);
			if(rs.getCounts() > 0){
			%>
	        <select class="inputstyle" id="revision_budgetinfoid" name="revision_budgetinfoid" onchange="revision_budgetinfoid_onchange();" style="width: 110px;">
			<%
				rs.executeSql(sql);
				while(rs.next()){
					int _id = rs.getInt("id");
					int _revision = rs.getInt("revision");
					int _status = rs.getInt("status");

					String _revisionName = "";
					if(_status==3 || _status==0 || _status==1){//待审批、草稿、生效
						_revisionName = fnaSplitPageTransmethod.getRevision2(String.valueOf(_status), String.valueOf(user.getLanguage()));
					}else if(_id == budgetinfoid){
						_revisionName = fnaSplitPageTransmethod.getRevision(String.valueOf(_revision), String.valueOf(_status)+"+"+String.valueOf(user.getLanguage()));
					}else{
						continue;
					}
					
			%>
				<option value="<%=_id %>" <% if(_id == budgetinfoid){%>selected<%}%>><%=_revisionName%></option>
			<%
				}
			%>
	        </select>
			<%
			}else{
			%>
	        <select class="inputstyle" id="revision_budgetinfoid" name="revision_budgetinfoid" style="width: 80px;">
				<option value="" selected><%=SystemEnv.getHtmlLabelName(220, user.getLanguage()) %></option><!-- 草稿 -->
	        </select>
			<%
			}
			%>
       	</wea:item>
       	
		<wea:item><%=SystemEnv.getHtmlLabelName(18501,user.getLanguage()) %></wea:item><!-- 预算总额 -->
		<wea:item>
			<%=budgetaccountName %>
       	</wea:item>
<%
if(FnaCostCenter.ORGANIZATION_TYPE!=Util.getIntValue(organizationtype)){
%>
		<wea:item>
			<%if(budgetControlType2==1){ %>
				<%=SystemEnv.getHtmlLabelName(130462,user.getLanguage()) %><!-- 下级预算总额  -->
			<%}else{ %>
				<%=SystemEnv.getHtmlLabelName(18502,user.getLanguage()) %><!-- 已分配总预算 -->
			<%} %>
		</wea:item><!-- 已分配/汇总预算 -->
		<wea:item>
			<%=yfpJeName %>
       	</wea:item>
<%
}
%>
		<wea:item><%=SystemEnv.getHtmlLabelName(18503,user.getLanguage()) %></wea:item><!-- 已发生费用 -->
		<wea:item>
			<%=yfsJeName %>
       	</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(18769,user.getLanguage()) %></wea:item><!-- 审批中费用 -->
		<wea:item>
			<%=spzJeName %>
       	</wea:item>
	</wea:group>
</wea:layout>
</div>

<!-- 预算设置明细数据 -->
<%
String fnaBudgetViewInner1Url = "/fna/budget/FnaBudgetViewInner1.jsp?"+commonPara+"&tabFeeperiod="+tabFeeperiod;

String fnaBudgetViewDataMurl = "/fna/budget/FnaBudgetViewData.jsp?"+commonPara+"&tabFeeperiod=M";
String fnaBudgetViewDataQurl = "/fna/budget/FnaBudgetViewData.jsp?"+commonPara+"&tabFeeperiod=Q";
String fnaBudgetViewDataHurl = "/fna/budget/FnaBudgetViewData.jsp?"+commonPara+"&tabFeeperiod=H";
String fnaBudgetViewDataYurl = "/fna/budget/FnaBudgetViewData.jsp?"+commonPara+"&tabFeeperiod=Y";

if(canEdit && edit){
	fnaBudgetViewDataMurl = "/fna/budget/FnaBudgetEdit.jsp?"+commonPara+"&tabFeeperiod=M";
	fnaBudgetViewDataQurl = "/fna/budget/FnaBudgetEdit.jsp?"+commonPara+"&tabFeeperiod=Q";
	fnaBudgetViewDataHurl = "/fna/budget/FnaBudgetEdit.jsp?"+commonPara+"&tabFeeperiod=H";
	fnaBudgetViewDataYurl = "/fna/budget/FnaBudgetEdit.jsp?"+commonPara+"&tabFeeperiod=Y";
}

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
		<li <%=tab_menu_m_className %> style="<%=tab_menu_m_display %>">
			<a id="divMainInfo_m" onclick="tabMainInfo_onclick('<%=fnaBudgetViewDataMurl %>',<%=canEdit %>,<%=edit %>);return false;" href="#"><%=SystemEnv.getHtmlLabelName(15370,user.getLanguage()) %></a><!-- 月度预算 -->
		</li>
		<li <%=tab_menu_q_className %> style="<%=tab_menu_q_display %>">
			<a id="divMainInfo_q" onclick="tabMainInfo_onclick('<%=fnaBudgetViewDataQurl %>',<%=canEdit %>,<%=edit %>);return false;" href="#"><%=SystemEnv.getHtmlLabelName(15373,user.getLanguage()) %></a><!-- 季度预算 -->
		</li>
		<li <%=tab_menu_h_className %> style="<%=tab_menu_h_display %>">
			<a id="divMainInfo_h" onclick="tabMainInfo_onclick('<%=fnaBudgetViewDataHurl %>',<%=canEdit %>,<%=edit %>);return false;" href="#"><%=SystemEnv.getHtmlLabelName(15374,user.getLanguage()) %></a><!-- 半年预算 -->
		</li>
		<li <%=tab_menu_y_className %> style="<%=tab_menu_y_display %>">
			<a id="divMainInfo_y" onclick="tabMainInfo_onclick('<%=fnaBudgetViewDataYurl %>',<%=canEdit %>,<%=edit %>);return false;" href="#"><%=SystemEnv.getHtmlLabelName(15375,user.getLanguage()) %></a><!-- 年度预算 -->
		</li>
    </ul>
    <div id="rightBox" class="e8_rightBox">
    </div>
    <div class="tab_box">
        <div>
			<iframe src="<%=fnaBudgetViewDataUrl %>" onload="update();" id="tabcontentframe2" name="tabcontentframe2" class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
        </div>
    </div>
</div> 

<!-- advanced search -->
<div class="advancedSearchDiv" id="advancedSearchDiv" style="display: none;">
</div>

<script language="javascript">
//tab切换事件
function tabMainInfo_onclick(_url,canEdit,edit){
	if(canEdit && edit){
		//如果是可编辑的页面，则先模仿翻页的业务逻辑，将当前页面的数据写入缓存中，再切换tab
		saveFna("tabMainInfo_onclick('"+_url+"',true,false)", true, false);
	}else{
		//如果是不可编辑的页面，则直接切换tab
		document.getElementById("tabcontentframe2").src = _url;
	}
}

//预算导入
function doImp_grid(id){
	var _w = 580;
	var _h = 420;
	_fnaOpenDialog("/fna/budget/FnaBudgetImport.jsp?fnabudgetinfoid="+id+"&openPanter=parent", 
			"<%=SystemEnv.getHtmlLabelName(20209,user.getLanguage()) %>", 
			_w, _h);
}

//快速（高级）搜索事件
function onBtnSearchClick(from_advSubmit){
	var showNilQuery = window.parent.window.jQuery("#showNilQuery").attr("checked")?"1":"";
	if(showNilQuery=="1"){
		jQuery("#showNilQuery").attr("checked", true);
	}else{
		jQuery("#showNilQuery").attr("checked", false);
	}
<%
if(canEdit && edit && (isSubmitApprove || isApprove)){//如果是可编辑的页面，先模仿翻页的业务逻辑，将当前页面的数据写入缓存中，再执行查询提交
%>
	saveFna("form2.submit()", true);
<%
}else{//如果不是可编辑的页面，直接执行查询提交
%>
	form2.submit();
<%
}
%>
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

//读取数据更新进度标志符
var _loadFnaBudgetEditSaveFnaLoadingAjaxFlag = false;
//读取数据更新进度函数
function loadFnaBudgetEditSaveFnaLoadingAjax(_guid1){
	jQuery.ajax({
		url : "/fna/FnaLoadingAjax4FnaBudgetEdit.jsp",
		type : "post",
		cache : false,
		processData : false,
		data : "guid="+_guid1,
		dataType : "json",
		success: function do4Success(_jsonObj){
		    try{
	    		if(_jsonObj.flag){
			    	_loadFnaBudgetEditSaveFnaLoadingAjaxFlag = false;
					try{closeNewDiv_FnaBudgetViewInner1();}catch(ex1){}
					try{showToolBarBtn();}catch(ex1){}
					loadFnaBudgetEditSaveFnaLoadingAjax_done(_jsonObj.resultJson);
	    		}else{
		    		if(top!=null&&top.document!=null&&top.document.getElementById("mask_FnaBudgetViewInner1_infoDiv")!=null){
			    		top.document.getElementById("mask_FnaBudgetViewInner1_infoDiv").innerHTML=null2String(_jsonObj.infoStr);
			    		if(_loadFnaBudgetEditSaveFnaLoadingAjaxFlag){
				    		setTimeout("loadFnaBudgetEditSaveFnaLoadingAjax('"+_guid1+"')", "1000");
			    		}
		    		}else{
			    		if(_loadFnaBudgetEditSaveFnaLoadingAjaxFlag){
				    		setTimeout("loadFnaBudgetEditSaveFnaLoadingAjax('"+_guid1+"')", "1000");
			    		}
		    		}
	    		}
		    }catch(e1){
		    	_loadFnaBudgetEditSaveFnaLoadingAjaxFlag = false;
				try{closeNewDiv_FnaBudgetViewInner1();}catch(ex1){}
				try{showToolBarBtn();}catch(ex1){}
		    }
		}
	});	
}

function loadFnaBudgetEditSaveFnaLoadingAjax_done(_json){
    try{
    	var _callbackFunc = _FnaBudgetViewInner1_callbackFunc;
    	var isGotoPage = _FnaBudgetViewInner1_isGotoPage;
    	var isApprove = _FnaBudgetViewInner1_isApprove;
    	var isSubmitApprove = _FnaBudgetViewInner1_isSubmitApprove;

    	_FnaBudgetViewInner1_callbackFunc = "";
    	_FnaBudgetViewInner1_isGotoPage = "";
    	_FnaBudgetViewInner1_isApprove = "";
    	_FnaBudgetViewInner1_isSubmitApprove = "";
    	
		if(_json.flag){
			if(isGotoPage){//翻页、切换tab，执行回调函数
				showToolBarBtn();
				eval(_callbackFunc);
			}else{
				alert(_json.msg._fnaReplaceAll("<br>","\r")._fnaReplaceAll("<br />","\r"));
				if(isApprove || isSubmitApprove){//批准生效
					if(parent!=null&&parent!=null){
						var _organizationtype = jQuery("#organizationtype").val();
						var _organizationid = jQuery("#organizationid").val();
						var _budgetperiods = jQuery("#budgetperiods").val();
						parent.location.href = "/fna/budget/FnaBudgetView.jsp"+
							"?organizationtype="+_organizationtype+"&organizationid="+_organizationid+"&budgetperiods="+_budgetperiods;
					}
				}else{//保存草稿
					if(parent!=null&&parent!=null){
						var _fnaBudgetId = _json.fnaBudgetId;
						parent.location.href = "/fna/budget/FnaBudgetView.jsp"+
							"?budgetinfoid="+_fnaBudgetId;
					}
				}
			}
		}else{
			alert(_json.msg._fnaReplaceAll("<br>","\r")._fnaReplaceAll("<br />","\r"));
			if(false && isSubmitApprove){
				var _organizationtype = jQuery("#organizationtype").val();
				var _organizationid = jQuery("#organizationid").val();
				var _budgetperiods = jQuery("#budgetperiods").val();
				parent.location.href = "/fna/budget/FnaBudgetView.jsp"+
					"?organizationtype="+_organizationtype+"&organizationid="+_organizationid+"&budgetperiods="+_budgetperiods;
			}
		}
    }catch(e1){
    	_loadFnaBudgetEditSaveFnaLoadingAjaxFlag = false;
    	try{closeNewDiv_FnaBudgetViewInner1();}catch(ex1){}
    	try{showToolBarBtn();}catch(ex1){}
    }
}

var _FnaBudgetViewInner1_callbackFunc = "";
var _FnaBudgetViewInner1_isGotoPage = "";
var _FnaBudgetViewInner1_isApprove = "";
var _FnaBudgetViewInner1_isSubmitApprove = "";

//保存事件3：保存数据
function saveFna2(_data, _callbackFunc, isGotoPage, isApprove, isSubmitApprove){
	openNewDiv_FnaBudgetViewInner1(_Label33574);

	_FnaBudgetViewInner1_callbackFunc = _callbackFunc;
	_FnaBudgetViewInner1_isGotoPage = isGotoPage;
	_FnaBudgetViewInner1_isApprove = isApprove;
	_FnaBudgetViewInner1_isSubmitApprove = isSubmitApprove;
	
	//async : false,
	jQuery.ajax({
		url : "/fna/budget/FnaBudgetEditSaveFnaAjax.jsp",
		type : "post",
		cache : false,
		processData : false,
		data : _data,
		dataType : "json",
		success: function do4Success(_json){
		}
	});	
}

//保存事件2：校验要保存的数据
function saveFnaVerifyAjax(_data, _callbackFunc, isGotoPage, isApprove, isSubmitApprove){
    try{
		saveFna2(_data, _callbackFunc, isGotoPage, isApprove, isSubmitApprove);
	}catch(ex1){
		_loadFnaBudgetEditSaveFnaLoadingAjaxFlag = false;
    	try{closeNewDiv_FnaBudgetViewInner1();}catch(ex1){}
    	try{showToolBarBtn();}catch(ex1){}
	}
}

//保存事件1：封装要保存的数据
function saveFna(_callbackFunc, isGotoPage, isApprove, isSubmitApprove){
	openNewDiv_FnaBudgetViewInner1(_Label33574);
	hideToolBarBtn();
	try{
		if(!isGotoPage){
			isGotoPage = false;
		}
		var _data = "";
		
		var _frm = window.tabcontentframe2;
		var _organizationtype = jQuery("#organizationtype").val();
		var _organizationid = jQuery("#organizationid").val();
		var _tabFeeperiod = _frm.jQuery("#tabFeeperiod").val();
		var _qCount = _frm.jQuery("#qCount").val();
		var _budgetinfoid = jQuery("#budgetinfoid").val();
		var _guid1 = jQuery("#guid1").val();
		var _budgetperiods = jQuery("#budgetperiods").val();
		
		_data += "organizationtype="+_organizationtype+"&organizationid="+_organizationid+"&tabFeeperiod="+_tabFeeperiod+"&qCount="+_qCount+"&budgetinfoid="+_budgetinfoid+
			"&guid1="+_guid1+"&budgetperiods="+_budgetperiods;
		if(isGotoPage){
			_data += "&isSave=false";
		}else{
			_data += "&isSave=true";
		}
		if(isApprove){
			_data += "&isApprove=true";
		}else{
			_data += "&isApprove=false";
		}
		if(isSubmitApprove){
			_data += "&isSubmitApprove=true";
		}else{
			_data += "&isSubmitApprove=false";
		}
		
		var _inputName_inputVal = "&_inputName_inputVal=";
		
		var _b3idIptArray = _frm.jQuery("input[name='b3id']");
		for(var i=0;i<_b3idIptArray.length;i++){
			var _b3id = jQuery(_b3idIptArray[i]).val();
			_data += "&b3id="+_b3id;
			for(var q=1;q<=_qCount;q++){
				var _inputName = "ipt_ysze_"+_b3id+"_"+_tabFeeperiod+"_"+q;
				var _inputVal = _frm.jQuery("#"+_inputName).val();
				//_data += "&"+_inputName+"="+_inputVal;
				_inputName_inputVal += ","+_inputName+"="+_inputVal;
			}
		}
		
		var _b2idIptArray = _frm.jQuery("input[name='saveB2id']");
		for(var i=0;i<_b2idIptArray.length;i++){
			var _bid = jQuery(_b2idIptArray[i]).val();
			_data += "&b2id="+_bid;
			for(var q=1;q<=_qCount;q++){
				var _inputName = "supSubjectNew_"+_bid+"_"+q;
				var _inputVal = jQuery.trim(_frm.jQuery("#"+_inputName).attr("_val"));
				//_data += "&"+_inputName+"="+_inputVal;
				_inputName_inputVal += ","+_inputName+"="+_inputVal;
			}
		}
		
		var _b1idIptArray = _frm.jQuery("input[name='saveB1id']");
		for(var i=0;i<_b1idIptArray.length;i++){
			var _bid = jQuery(_b1idIptArray[i]).val();
			_data += "&b1id="+_bid;
			for(var q=1;q<=_qCount;q++){
				var _inputName = "supSubjectNew_"+_bid+"_"+q;
				var _inputVal = jQuery.trim(_frm.jQuery("#"+_inputName).attr("_val"));
				//_data += "&"+_inputName+"="+_inputVal;
				_inputName_inputVal += ","+_inputName+"="+_inputVal;
			}
		}
		
		_data += _inputName_inputVal;
		
		_loadFnaBudgetEditSaveFnaLoadingAjaxFlag = true;
		loadFnaBudgetEditSaveFnaLoadingAjax(_guid1);
		saveFnaVerifyAjax(_data, _callbackFunc, isGotoPage, isApprove, isSubmitApprove);
	}catch(ex1){
		_loadFnaBudgetEditSaveFnaLoadingAjaxFlag = false;
    	try{closeNewDiv_FnaBudgetViewInner1();}catch(ex1){}
    	try{showToolBarBtn();}catch(ex1){}
	}
}

//按钮保存
function saveFnaBtn(){
	top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(32130,user.getLanguage())%>",
		function(){
			saveFna();
		}, function(){}
	);
}


//批准生效
function approveFna(){
	top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(33207,user.getLanguage())%>",
		function(){
			saveFna(null, false, true, false);
		}, function(){}
	);
}

//提交审批
function submitApprovalFna(){
	top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(33206,user.getLanguage())%>",
		function(){
			saveFna(null, false, false, true);
		}, function(){}
	);
}

function viewFna(_obj){
	hideToolBarBtn();
	window.location.href = "<%=fnaBudgetViewInner1Url+"&edit=false&isClearTmpData=true" %>";
}

function editFna(_obj){
	hideToolBarBtn();
	window.location.href = "<%=fnaBudgetViewInner1Url+"&edit=true&isClearTmpData=true" %>";
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
	parent.location.href = "/fna/budget/FnaBudgetView.jsp?"+commonPara;
}

function revision_budgetinfoid_onchange(){
	var organizationtype = "";
	var organizationid = "";
	var budgetinfoid = jQuery("#revision_budgetinfoid").val();
	var budgetperiods = "";
	var status = "";
	var revision = "";
	var tabFeeperiod = jQuery("#tabFeeperiod").val();
	
	var commonPara = "organizationtype="+organizationtype+"&organizationid="+organizationid+"&budgetinfoid="+budgetinfoid+"&budgetperiods="+budgetperiods+
		"&status="+status+"&revision="+revision+"&tabFeeperiod="+tabFeeperiod;
	parent.location.href = "/fna/budget/FnaBudgetView.jsp?"+commonPara;
}

var _init_frmTabcontentframe2_height = 0;
var _is_reSize_frmTabcontentframe2 = false;
function reSize_frmTabcontentframe2(){
}

function save2DraftVersion(){
	var budgetinfoid = "<%=budgetinfoid%>";
	var tabFeeperiod = jQuery("#tabFeeperiod").val();
	top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(126815,user.getLanguage())%>",
		function(){
			openNewDiv_FnaBudgetViewInner1(_Label33574);
			jQuery.ajax({
				url : "/fna/budget/FnaBudgetEditSave2DraftVersionAjax.jsp",
				type : "post",
				cache : false,
				data : "budgetinfoid="+budgetinfoid+"&tabFeeperiod="+tabFeeperiod, 
				processData : false,
				dataType : "json",
				success: function do4Success(_json){
				    try{
						try{closeNewDiv_FnaBudgetViewInner1();}catch(ex1){}
						try{showToolBarBtn();}catch(ex1){}
						if(_json.flag){
							window.location.href = _json.locationHref+"&edit=false&isClearTmpData=true";
						}else{
							alert(_json.msg);
						}
				    }catch(e1){
				    	try{closeNewDiv_FnaBudgetViewInner1();}catch(ex1){}
				    	try{showToolBarBtn();}catch(ex1){}
				    }
				}
			});	
		}, function(){}
	);
}

jQuery('.e8_boxInner1').Tabs({
	getLine:1,
	iframe:"tabcontentframe2",
	staticOnLoad:true,
	noParentMenu:true
});

</script>
</form>
</body>
</html>
