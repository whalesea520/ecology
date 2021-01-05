<%@page import="weaver.fna.maintenance.FnaSystemSetComInfo"%>
<%@page import="weaver.fna.general.FnaCommon"%>
<%@page import="weaver.fna.maintenance.FnaCostCenter"%>
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
String timestrformart = "yyyy-MM-dd HH:mm:ss.SSSZ" ;
SimpleDateFormat SDF = new SimpleDateFormat(timestrformart) ;

BaseBean bb = new BaseBean();

//bb.writeLog("1 FnaBudgetViewData.jsp>>>"+SDF.format(Calendar.getInstance().getTime()));
boolean canView = HrmUserVarify.checkUserRight("BudgetAuthorityRule:readOnly", user);//预算编制只读权限
boolean canEdit = (HrmUserVarify.checkUserRight("FnaBudget:View", user) || 
		HrmUserVarify.checkUserRight("FnaBudgetEdit:Edit", user) || 
		HrmUserVarify.checkUserRight("BudgetAuthorityRule:edit", user));//财务预算维护、预算编制权限
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
RecordSet rs1 = new RecordSet();
RecordSet rs2 = new RecordSet();

String organizationtype = Util.null2String(request.getParameter("organizationtype"));//组织类型
String organizationid = Util.null2String(request.getParameter("organizationid"));//组织ID
int budgetinfoid = Util.getIntValue(request.getParameter("budgetinfoid"), 0);//预算设置主表id
int budgetperiods = Util.getIntValue(request.getParameter("budgetperiods"), 0);//预算年度id
int status = Util.getIntValue(request.getParameter("status"), 0);//预算状态
int revision = Util.getIntValue(request.getParameter("revision"), 0);//预算版本

String guid1 = Util.null2String(request.getParameter("guid1")).trim();

String _startdate = "";
String _enddate = "";
rs.executeSql("select b.startdate, b.enddate, a.budgetperiods from FnaBudgetInfo a join FnaYearsPeriods b on a.budgetperiods = b.id where a.id = "+budgetinfoid);
if(rs.next()){
	budgetperiods = rs.getInt("budgetperiods");
	_startdate = Util.null2String(rs.getString("startdate"));
	_enddate = Util.null2String(rs.getString("enddate"));
}

String nameQuery = Util.null2String((String)request.getSession().getAttribute("FnaBudgetViewInner1.jsp_nameQuery_"+guid1));
boolean showNilQuery = 1==Util.getIntValue((String)request.getSession().getAttribute("FnaBudgetViewInner1.jsp_hiddenNilQuery_"+guid1), 0);

int qCount = 0;
int feeperiod = 0;
String tabFeeperiod = Util.null2String(request.getParameter("tabFeeperiod")).trim();//打开预算周期tab页
if("".equals(tabFeeperiod)){
	tabFeeperiod = "M";
}

if("M".equals(tabFeeperiod)){
	qCount = 12;
	feeperiod = 1;
}else if("Q".equals(tabFeeperiod)){
	qCount = 4;
	feeperiod = 2;
}else if("H".equals(tabFeeperiod)){
	qCount = 2;
	feeperiod = 3;
}else if("Y".equals(tabFeeperiod)){
	qCount = 1;
	feeperiod = 4;
}

String commonPara = "organizationtype="+organizationtype+"&organizationid="+organizationid+"&budgetinfoid="+budgetinfoid+"&budgetperiods="+budgetperiods+
	"&status="+status+"&revision="+revision+"&tabFeeperiod="+tabFeeperiod+"&guid1="+guid1;

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

DecimalFormat df = new DecimalFormat("####################################################0.00");
FnaSplitPageTransmethod fnaSplitPageTransmethod = new FnaSplitPageTransmethod();
FnaBudgetInfoComInfo fnaBudgetInfoComInfo = new FnaBudgetInfoComInfo();
BudgetHandler budgetHandler = new BudgetHandler();
BudgetfeeTypeComInfo budgetfeeTypeComInfo = new BudgetfeeTypeComInfo();


String sql = "";

boolean showHiddenSubject = 1==Util.getIntValue(fnaSystemSetComInfo.get_showHiddenSubject(), 0);
boolean subjectFilter = 1==Util.getIntValue(fnaSystemSetComInfo.get_subjectFilter(), 0);
String separator = Util.null2String(fnaSystemSetComInfo.get_separator());
int alertvalue_FnaSystemSet = Util.getIntValue(fnaSystemSetComInfo.get_alertvalue(), 0);
if("".equals(separator)){
	separator = "/";
}

String _wImg100 = "<img alt=\"\" src=\"\" style=\"width: 100px; height: 0px;\" />";
String _wImg80 = "<img alt=\"\" src=\"\" style=\"width: 80px; height: 0px;\" />";
String _wImg250 = _wImg100;
if(user.getLanguage()!=7){
	_wImg100 = "<img alt=\"\" src=\"\" style=\"min-width: 100px; width: 100px; height: 0px;\" />";
	_wImg80 = "<img alt=\"\" src=\"\" style=\"min-width: 80px; width: 80px; height: 0px;\" />";
	_wImg250 = "<img alt=\"\" src=\"\" style=\"min-width: 200px; width: 200px; height: 0px;\" />";
}
%>

<%@page import="java.text.SimpleDateFormat"%><html>
<head>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language="javascript" src="/js/weaver_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<script language="javascript" src="/fna/js/e8Common_wev8.js?r=5"></script>
<style>
.tb tr td{
	height: 25px;
	vertical-align: middle;
}
.tbTh td{
	text-align: center;
	font-weight: bold;
}
.amtTd{
	text-align: right;
}
.tdRowSplit{
	border-bottom: 1px solid #F2F2F2;
}
</style>
</head>
<body style="overflow:auto;">
<%if(false){%>
<script type="text/javascript">
jQuery(document).ready(function(){
	var _tdMaxWidthArray = [0,0,0,0,0, 0,0,0,0,0, 0,0];
	var fnaBudgetInfo_mainTb = jQuery("#fnaBudgetInfo_mainTb");
	var _trObjArray = fnaBudgetInfo_mainTb.find(".fnaBudgetInfo_mainTb_tr");
	var _firstRowTdLength = 0;
	for(var trI=0;trI<_trObjArray.length;trI++){
		var _tdObjArray = jQuery(_trObjArray[trI]).find("td");
		if(_tdObjArray.length==0){
			_tdObjArray = jQuery(_trObjArray[trI]).find("th");
		}
		if(_firstRowTdLength==0){
			_firstRowTdLength = _tdObjArray.length;
		}
		if(_tdObjArray.length==_firstRowTdLength){
			for(var tdI=0;tdI<_tdObjArray.length && tdI<100;tdI++){
				var _tdWidth = fnaRound2(jQuery(_tdObjArray[tdI]).width(),0);
				var _tdMaxWidth = fnaRound2(_tdMaxWidthArray[tdI],0);
				if(_tdWidth > _tdMaxWidth){
					_tdMaxWidthArray[tdI] = _tdWidth+"";
				}
			}
		}
	}
	var _trHead1ObjArray = fnaBudgetInfo_mainTb.find(".fnaBudgetInfo_mainTb_trHead1");
	var _trHead2ObjArray = fnaBudgetInfo_mainTb.find(".fnaBudgetInfo_mainTb_trHead2");

	var fnaBudgetInfo_main_positionFixed_Head_str = "<table id=\"fnaBudgetInfo_main_positionFixed\" class=\"tb\" style=\"width: 100%;z-index: 50;position:fixed;\" cellpadding=\"5\" cellspacing=\"0\">";
	fnaBudgetInfo_main_positionFixed_Head_str += "<tr class=\"fnaBudgetInfo_mainTb_tr\" "+
		"style=\"height: 0px; background-color: #F2F2F2; border: 0px; margin: 0px; padding: 0px; color: #F2F2F2; font-size: 0px; visibility: hidden;\" height=\"0px\">";
	fnaBudgetInfo_main_positionFixed_Head_str += _trHead1ObjArray.html();
	fnaBudgetInfo_main_positionFixed_Head_str += "</tr>";
	fnaBudgetInfo_main_positionFixed_Head_str += "<tr class=\"tbTh fnaBudgetInfo_mainTb_tr\" style=\"background-color: #F2F2F2;\">";
	fnaBudgetInfo_main_positionFixed_Head_str += _trHead2ObjArray.html();
	fnaBudgetInfo_main_positionFixed_Head_str += "</tr>";
	fnaBudgetInfo_main_positionFixed_Head_str += "</table>";
	
	fnaBudgetInfo_mainTb.before(fnaBudgetInfo_main_positionFixed_Head_str);
	
	var fnaBudgetInfo_main_positionFixed = jQuery("#fnaBudgetInfo_main_positionFixed");
	var _trObjArray_positionFixed = fnaBudgetInfo_main_positionFixed.find(".fnaBudgetInfo_mainTb_tr");
	for(var trI=0;trI<_trObjArray_positionFixed.length;trI++){
		var _tdObjArray_positionFixed = jQuery(_trObjArray_positionFixed[trI]).find("td");
		if(_tdObjArray_positionFixed.length==0){
			_tdObjArray_positionFixed = jQuery(_trObjArray_positionFixed[trI]).find("th");
		}
		for(var tdI=0;tdI<_tdObjArray_positionFixed.length && tdI<100;tdI++){
			if(_tdMaxWidthArray.length > tdI){
				var _tdMaxWidth = fnaRound2(_tdMaxWidthArray[tdI], 0);
				if(_tdObjArray_positionFixed.length==(tdI+1)){
					_tdMaxWidth += 30;
				}
				//jQuery(_tdObjArray_positionFixed[tdI]).html(_tdMaxWidth);
				jQuery(_tdObjArray_positionFixed[tdI]).css("width", _tdMaxWidth+"px");
			}
		}
	}

	jQuery('#fnaBudgetInfo_main_positionFixed').__fnaScrollFixed({fixed:'left'}); 
});
</script>
<%}%>
<table id="fnaBudgetInfo_mainTb" class="tb" style="width: 100%;margin-top: -4px;" cellpadding="5" cellspacing="0">
	<tr class="fnaBudgetInfo_mainTb_tr fnaBudgetInfo_mainTb_trHead1" style="height: 0px; background-color: #F2F2F2; border: 0px; margin: 0px; padding: 0px; color: #F2F2F2; font-size: 0px; visibility: hidden;" height="0px">
		<th style="height: 0px; font-size: 0px;" height="0px"><%=_wImg100 %></th>
		<th style="height: 0px; font-size: 0px;" height="0px"><%=_wImg250 %></th>
	<%for(int i=1;i<=qCount;i++){%>
		<th style="height: 0px; font-size: 0px;" height="0px"><%=_wImg80 %></th>
	<%}%>
		<th style="height: 0px; font-size: 0px;" height="0px"><%=_wImg80 %></th>
	</tr>
	<tr class="tbTh fnaBudgetInfo_mainTb_tr fnaBudgetInfo_mainTb_trHead2" style="background-color: #F2F2F2;">
		<td><%=SystemEnv.getHtmlLabelName(15409,user.getLanguage()) %></td><!-- 科目名称 -->
		<td><%=SystemEnv.getHtmlLabelName(16893,user.getLanguage()) %></td><!-- 统计项 -->
	<%for(int i=1;i<=qCount;i++){%>
		<td><%=i+SystemEnv.getHtmlLabelName(21868,user.getLanguage()) %></td><!-- 期 -->
	<%}%>
		<td><%=SystemEnv.getHtmlLabelName(1013,user.getLanguage()) %></td><!-- 全年 -->
	</tr>
<%
//bb.writeLog("2 FnaBudgetViewData.jsp>>>"+SDF.format(Calendar.getInstance().getTime()));
int pageIndex = Util.getIntValue(request.getParameter("pageIndex"), 1);
int pageSize = Util.getIntValue(request.getParameter("pageSize"), -1);
pageSize = FnaCommon.getAndSaveFnaBudgetInfoPageSize(pageSize, 50, user.getUID());

int sqlCondOrgType4ftRul = Util.getIntValue(organizationtype);
int sqlCondOrgId4ftRul = Util.getIntValue(organizationid);
if(Util.getIntValue(organizationtype)==3){//个人预算
	ResourceComInfo rci = new ResourceComInfo();
	sqlCondOrgType4ftRul = 2;
	sqlCondOrgId4ftRul = Util.getIntValue(rci.getDepartmentID(organizationid));
}

SplitPageParaBean splitPageParaBean = new SplitPageParaBean();
SplitPageUtil splitPageUtil = new SplitPageUtil();


StringBuffer sql_rs_split = new StringBuffer();
sql_rs_split.append("select DISTINCT b2.groupDispalyOrder b2groupDispalyOrder, b2.id b2id, b2.name b2name, b2.codeName b2codeName, b2.feelevel b2feelevel, b2.Archive b2Archive, b2.alertvalue b2Alertvalue, b2.isEditFeeType b2IsEditFeeType, b2.displayOrder b2displayOrder, \n");
sql_rs_split.append("	b3.groupDispalyOrder b3groupDispalyOrder, b3.id b3id, b3.name b3name, b3.codeName b3codeName, b3.feelevel b3feelevel, b3.Archive b3Archive, b3.alertvalue b3Alertvalue, b3.isEditFeeType b3IsEditFeeType, b3.displayOrder b3displayOrder \n");
sql_rs_split.append(" from Fnabudgetfeetype b2 ");
sql_rs_split.append(" join FnaBudgetfeeType b3 on b2.id = b3.groupCtrlId \n");
sql_rs_split.append(" where 1=1 \n");
if(subjectFilter){
	sql_rs_split.append(" and ( \n"+
			" not exists (select 1 from FnabudgetfeetypeRuleSet ftRul \n"+
			" 		where ftRul.type = "+sqlCondOrgType4ftRul+" and ftRul.mainid = b3.id ) \n"+
			" or \n"+
			" exists (select 1 from FnabudgetfeetypeRuleSet ftRul \n"+
			" 		where ftRul.type = "+sqlCondOrgType4ftRul+" and ftRul.orgid = "+sqlCondOrgId4ftRul+" and ftRul.mainid = b3.id ) \n"+
			" ) \n");
}
if(!showNilQuery){
	List<String> _list_new_sub_subCmp = null;//分部及所有下级分部
	int _list_new_len_sub_subCmp = 0;
	List<String> _list_new_sub_depId = null;//部门及所有下级部门
	int _list_new_len_sub_depId = 0;
	List<String> _list_new_self = null;//个人、成本中心
	int _list_new_len_self = 0;
	if("1".equals(organizationtype)){//分部
    	List<String> sub_subCmpId_list = budgetHandler.loadSubOrg_subCmp(Util.getIntValue(organizationid));
    	_list_new_sub_subCmp = FnaCommon.initData1(sub_subCmpId_list);
    	_list_new_len_sub_subCmp = _list_new_sub_subCmp.size();
		
	}else if("2".equals(organizationtype)){//部门
    	List<String> sub_depId_list = budgetHandler.loadSubOrg_dep_byDepId(Util.getIntValue(organizationid));
    	_list_new_sub_depId = FnaCommon.initData1(sub_depId_list);
    	_list_new_len_sub_depId = _list_new_sub_depId.size();
		
	}else if("3".equals(organizationtype) || Util.getIntValue(organizationtype)==FnaCostCenter.ORGANIZATION_TYPE){//个人、成本中心
		_list_new_self = new ArrayList<String>();
		_list_new_self.add(organizationid);
		_list_new_len_self = _list_new_self.size();
		
	}
	
	List<String> used_subject_list = new ArrayList<String>();
	StringBuffer _sql = new StringBuffer();
	_sql.append(" select DISTINCT b.budgettypeid subject  \n");
	_sql.append(" from FnaBudgetInfo a \n");
	_sql.append(" join FnaBudgetInfoDetail b on a.id = b.budgetinfoid \n");
	_sql.append(" join FnaBudgetfeeType c on c.id = b.budgettypeid \n");
	_sql.append(" where 1=1 \n");
	_sql.append(" and b.budgetaccount <> 0.0 \n");
	if(_list_new_len_sub_subCmp > 0){
		_sql.append(" and (1=2");
        for (int i = 0; i < _list_new_len_sub_subCmp; i++) {
        	_sql.append(" or (exists (select 1 from hrmresource hrm1 where hrm1.subcompanyid1 in ("+_list_new_sub_subCmp.get(i)+") and hrm1.id = a.budgetorganizationid) and organizationtype=3)");
		}
        for (int i = 0; i < _list_new_len_sub_subCmp; i++) {
        	_sql.append(" or (exists (select 1 from hrmdepartment dep1 where dep1.subcompanyid1 in ("+_list_new_sub_subCmp.get(i)+") and dep1.id = a.budgetorganizationid) and organizationtype=2)");
		}
        for (int i = 0; i < _list_new_len_sub_subCmp; i++) {
        	_sql.append(" or (a.budgetorganizationid in ("+_list_new_sub_subCmp.get(i)+") and a.organizationtype=1)");
		}
        _sql.append(") ");
	}else if(_list_new_len_sub_depId > 0){
		_sql.append(" and (1=2");
        for (int i = 0; i < _list_new_len_sub_depId; i++) {
        	_sql.append(" or (exists (select 1 from hrmresource hrm1 where hrm1.departmentid in ("+_list_new_sub_depId.get(i)+") and hrm1.id = a.budgetorganizationid) and organizationtype=3)");
		}
        for (int i = 0; i < _list_new_len_sub_depId; i++) {
        	_sql.append(" or (budgetorganizationid in ("+_list_new_sub_depId.get(i)+") and organizationtype=2)");
		}
        _sql.append(") ");
	}else if(_list_new_len_self > 0){
		_sql.append(" and (1=2");
        for (int i = 0; i < _list_new_len_self; i++) {
        	_sql.append(" or (a.budgetorganizationid in ("+_list_new_self.get(i)+") and a.organizationtype="+Util.getIntValue(organizationtype)+")");
		}
        _sql.append(") ");
	}
	_sql.append(" and c.feeperiod = "+feeperiod+" ");
	_sql.append(" and (a.status in (0,1,3)) and a.budgetperiods = "+budgetperiods+" \n");
	_sql.append(" UNION \n");
	_sql.append(" select DISTINCT b.isEditFeeTypeId subject \n");
	_sql.append(" from FnaExpenseInfo a \n");
	_sql.append(" join FnaBudgetfeeType b on a.subject = b.id \n");
	_sql.append(" where 1=1 \n");
	_sql.append(" and a.amount <> 0.0 \n");
	if(_list_new_len_sub_subCmp > 0){
		_sql.append(" and (1=2");
        for (int i = 0; i < _list_new_len_sub_subCmp; i++) {
        	_sql.append(" or (exists (select 1 from hrmresource hrm1 where hrm1.subcompanyid1 in ("+_list_new_sub_subCmp.get(i)+") and hrm1.id = a.organizationid) and organizationtype=3)");
		}
        for (int i = 0; i < _list_new_len_sub_subCmp; i++) {
        	_sql.append(" or (exists (select 1 from hrmdepartment dep1 where dep1.subcompanyid1 in ("+_list_new_sub_subCmp.get(i)+") and dep1.id = a.organizationid) and organizationtype=2)");
		}
        for (int i = 0; i < _list_new_len_sub_subCmp; i++) {
        	_sql.append(" or (organizationid in ("+_list_new_sub_subCmp.get(i)+") and organizationtype=1)");
		}
        _sql.append(") ");
	}else if(_list_new_len_sub_depId > 0){
		_sql.append(" and (1=2");
        for (int i = 0; i < _list_new_len_sub_depId; i++) {
        	_sql.append(" or (exists (select 1 from hrmresource hrm1 where hrm1.departmentid in ("+_list_new_sub_depId.get(i)+") and hrm1.id = a.organizationid) and organizationtype=3)");
		}
        for (int i = 0; i < _list_new_len_sub_depId; i++) {
        	_sql.append(" or (a.organizationid in ("+_list_new_sub_depId.get(i)+") and a.organizationtype=2)");
		}
        _sql.append(") ");
	}else if(_list_new_len_self > 0){
		_sql.append(" and (1=2");
        for (int i = 0; i < _list_new_len_self; i++) {
        	_sql.append(" or (a.organizationid in ("+_list_new_self.get(i)+") and a.organizationtype="+Util.getIntValue(organizationtype)+")");
		}
        _sql.append(") ");
	}
	_sql.append(" and b.feeperiod = "+feeperiod+" ");
	_sql.append(" and a.occurdate <= '"+StringEscapeUtils.escapeSql(_enddate)+"' ");
	_sql.append(" and a.occurdate >= '"+StringEscapeUtils.escapeSql(_startdate)+"' ");
	//rs.writeLog("FnaBudgetViewData.jsp>>>>>", _sql.toString());
	rs.executeSql(_sql.toString());
	while(rs.next()){
		used_subject_list.add(rs.getInt("subject")+"");
	}
	List<String> _list_new = FnaCommon.initData1(used_subject_list);
	int _list_new_len = _list_new.size();
	if(_list_new_len > 0){
		sql_rs_split.append(" and (1=2 \n");
        for (int i = 0; i < _list_new_len; i++) {
        	sql_rs_split.append(" or b3.id in ("+_list_new.get(i)+") ");
		}
		sql_rs_split.append(") \n");
	}else{
		sql_rs_split.append(" and 1=2 \n");
	}
	
	
	/*
	sql_rs_split.append(" and ( \n");
	sql_rs_split.append(" exists ( \n"+
			" select 1 \n"+
			" from FnaExpenseInfo fei \n"+
			" join FnaBudgetfeeType b on fei.subject = b.id \n"+
			" where (fei.amount <> 0.0) \n"+
			" and b.isEditFeeTypeId = b3.id \n"+
			" and fei.occurdate >= '"+StringEscapeUtils.escapeSql(_startdate)+"' and fei.occurdate <= '"+StringEscapeUtils.escapeSql(_enddate)+"' \n"+
			" and fei.organizationtype = "+Util.getIntValue(organizationtype)+" \n"+
			" and fei.organizationid = "+Util.getIntValue(organizationid)+" \n"+
		" ) ");
	sql_rs_split.append(" or \n");
	sql_rs_split.append(" exists ( \n"+
			" select 1 \n"+
			" from FnaBudgetInfoDetail fbid \n"+
			" where (fbid.budgetaccount <> 0.0) \n"+
			" and fbid.budgettypeid = b3.id \n"+
			" and fbid.budgetinfoid = "+budgetinfoid+" \n"+
		" ) ");
	sql_rs_split.append(" ) \n");
	*/
}

if(!"".equals(nameQuery)){
	sql_rs_split.append(" and (b3.name like '%"+StringEscapeUtils.escapeSql(nameQuery)+"%') \n");
}
if(!showHiddenSubject){
	sql_rs_split.append(" and (b3.archive is null or b3.archive=0) ");
}
sql_rs_split.append(" and b3.feeperiod = "+feeperiod+" and b3.isEditFeeType = 1 ");

//bb.writeLog("FnaBudgetViewData.jsp>>>", sql_rs_split.toString());

String backFields = " t1.* \n";
String sqlFrom = " from ("+sql_rs_split.toString()+") t1 \n";
String SqlOrderBy = " t1.b3groupDispalyOrder, t1.b2feelevel, t1.b2displayOrder, t1.b2codeName, t1.b2name, t1.b3feelevel, t1.b3displayOrder, t1.b3codeName, t1.b3name ";
String primaryKey = " b3id ";

splitPageParaBean.setBackFields(backFields);
splitPageParaBean.setSqlFrom(sqlFrom);
splitPageParaBean.setPrimaryKey(primaryKey);
splitPageParaBean.setSqlOrderBy(SqlOrderBy);
splitPageParaBean.setSortWay(splitPageParaBean.ASC);
splitPageParaBean.setDistinct(true);

splitPageUtil.setSpp(splitPageParaBean);

List<String> currentPage_isEditFeeTypeIds_list = new ArrayList<String>();
StringBuffer currentPage_isEditFeeTypeIds = new StringBuffer("-1");
RecordSet rs_split = splitPageUtil.getCurrentPageRs(pageIndex, pageSize);
while(rs_split.next()){
	int b3id = rs_split.getInt("b3id");
	if(!currentPage_isEditFeeTypeIds_list.contains(b3id+"")){
		currentPage_isEditFeeTypeIds_list.add(b3id+"");
		currentPage_isEditFeeTypeIds.append(","+b3id);
	}
}
List<String> sqlCond_currentPage_isEditFeeTypeIds_list = FnaCommon.initData1(currentPage_isEditFeeTypeIds_list);
int sqlCond_currentPage_isEditFeeTypeIds_list_len = sqlCond_currentPage_isEditFeeTypeIds_list.size();

int rsAllCnt = splitPageUtil.getRecordCount();//currentPageAllB3IdList.size();
int maxPageIndex = (rsAllCnt / pageSize) + ((rsAllCnt % pageSize)>0?1:0);
if(pageIndex > maxPageIndex){
	pageIndex = maxPageIndex;
}

//bb.writeLog("4 FnaBudgetViewData.jsp>>>"+SDF.format(Calendar.getInstance().getTime()));
StringBuffer currentPage_groupCtrlIds = new StringBuffer("-1");
List<String> currentPage_groupCtrlIds_List = new ArrayList<String>();
HashMap<String, List<HashMap<String, String>>> currentPage_groupCtrlIds_FnaBudgetfeeTypeHm = new HashMap<String, List<HashMap<String, String>>>();
StringBuffer sql1 = new StringBuffer();
sql1.append("select DISTINCT b2.groupDispalyOrder b2groupDispalyOrder, b2.id b2id, b2.name b2name, b2.codeName b2codeName, b2.feelevel b2feelevel, b2.Archive b2Archive, b2.alertvalue b2Alertvalue, b2.isEditFeeType b2IsEditFeeType, b2.displayOrder b2displayOrder, \n");
sql1.append("	b3.groupDispalyOrder b3groupDispalyOrder, b3.id b3id, b3.name b3name, b3.codeName b3codeName, b3.feelevel b3feelevel, b3.Archive b3Archive, b3.alertvalue b3Alertvalue, b3.isEditFeeType b3IsEditFeeType, b3.displayOrder b3displayOrder \n");
sql1.append("from FnaBudgetfeeType b2 \n");
sql1.append("join FnaBudgetfeeType b3 on b2.id = b3.groupCtrlId \n");
sql1.append(" where (b2.id = b2.groupCtrlId) \n");
sql1.append(" and ( 1=2 \n");
for(int i=0;i<sqlCond_currentPage_isEditFeeTypeIds_list_len;i++){
	sql1.append(" or b3.id in ("+sqlCond_currentPage_isEditFeeTypeIds_list.get(i)+") \n");
}
sql1.append(" ) \n");
sql1.append(" ORDER BY b3.groupDispalyOrder, b2.feelevel, b2.displayOrder, b2.codeName, b2.name, b2.id, b3.feelevel, b3.displayOrder, b3.codeName, b3.name, b3.id ");
rs1.executeSql(sql1.toString());
while(rs1.next()){
	String b2id = Util.null2String(rs1.getString("b2id")).trim();
	String b3id = Util.null2String(rs1.getString("b3id")).trim();
	String b3name = Util.null2String(rs1.getString("b3name")).trim();
	String b3Archive = Util.getIntValue(rs1.getString("b3Archive"), 0)+"";
	String b3Alertvalue = Util.null2String(rs1.getString("b3Alertvalue")).trim();
	String b3IsEditFeeType = Util.null2String(rs1.getString("b3IsEditFeeType")).trim();
	
	HashMap<String, String> _hm = new HashMap<String, String>();
	_hm.put("b2id", b2id);//统一费控的科目id
	_hm.put("b3name", b3name);
	_hm.put("b3id", b3id);//可编制科目id
	_hm.put("b3Archive", b3Archive);
	_hm.put("b3Alertvalue", b3Alertvalue);
	_hm.put("b3IsEditFeeType", b3IsEditFeeType);
	
	List<HashMap<String, String>> _list = null;
	if(currentPage_groupCtrlIds_FnaBudgetfeeTypeHm.containsKey(b2id)){
		_list = currentPage_groupCtrlIds_FnaBudgetfeeTypeHm.get(b2id);
	}else{
		_list = new ArrayList<HashMap<String, String>>();
		currentPage_groupCtrlIds_FnaBudgetfeeTypeHm.put(b2id, _list);
	}
	_list.add(_hm);
	
	if(!b2id.equals(b3id) && !currentPage_groupCtrlIds_List.contains(b2id)){
		currentPage_groupCtrlIds_List.add(b2id);
		currentPage_groupCtrlIds.append(","+b2id);
	}
}

//得到指定范围内所有一级科目整期预算
HashMap<String, Map> b2BudgetTypeAmountHm = fnaBudgetInfoComInfo.getBudgetAmountBySubjects_GroupCtrl(budgetinfoid, currentPage_groupCtrlIds.toString());

//bb.writeLog("5 FnaBudgetViewData.jsp>>>"+SDF.format(Calendar.getInstance().getTime()));
//得到指定范围内所有三级科目整期预算
HashMap<String, Map> b3BudgetTypeAmountHm = fnaBudgetInfoComInfo.getBudgetAmountBySubjects_isEditFeeType(budgetinfoid, currentPage_isEditFeeTypeIds.toString());

//bb.writeLog("6 FnaBudgetViewData.jsp>>>"+SDF.format(Calendar.getInstance().getTime()));
List periodsidKeyList = new ArrayList();
Map budgetPeriodMap = BudgetHandler.getBudgetPeriodMap(budgetperiods, feeperiod+"", periodsidKeyList);
int periodsidKeyListLen = periodsidKeyList.size();
//bb.writeLog("7.1 FnaBudgetViewData.jsp>>>periodsidKeyListLen="+periodsidKeyListLen+";budgetPeriodMap>>>"+budgetPeriodMap);
//bb.writeLog("7.1 FnaBudgetViewData.jsp>>>"+SDF.format(Calendar.getInstance().getTime()));

//得到指定范围内三级科目整期已分配预算
HashMap<String, Map> b3DistributiveBudgetTypeAmountHm = null;
if(budgetControlType2==1){
	b3DistributiveBudgetTypeAmountHm = fnaBudgetInfoComInfo.getRecursiveSubOrgBudgetAmountBySubjects_isEditFeeType(budgetperiods, 
				Util.getIntValue(organizationtype), Util.getIntValue(organizationid), currentPage_isEditFeeTypeIds.toString(), df);
}else{
	b3DistributiveBudgetTypeAmountHm = fnaBudgetInfoComInfo.getDistributiveBudgetAmountBySubjects_isEditFeeType(budgetperiods, 
				Util.getIntValue(organizationtype), Util.getIntValue(organizationid), currentPage_isEditFeeTypeIds.toString(), df);
}
//bb.writeLog("7.2 FnaBudgetViewData.jsp>>>"+SDF.format(Calendar.getInstance().getTime()));

//得到指定范围内三级科目整期审批中和已使用预算
HashMap<String, HashMap<String, Expense>> b3BudgetTypeExpenseHm = fnaBudgetInfoComInfo.getBudgetTypeExpenseBySubjects_isEditFeeType(periodsidKeyList, budgetPeriodMap, 
		currentPage_isEditFeeTypeIds.toString(), Util.getIntValue(organizationtype), Util.getIntValue(organizationid), df);
//bb.writeLog("8 FnaBudgetViewData.jsp>>>"+SDF.format(Calendar.getInstance().getTime()));

List<String> b2id_distinct_list = new ArrayList<String>();
StringBuffer jsValidate = new StringBuffer();
StringBuffer sql2 = new StringBuffer(); 
sql2.append("select distinct b3.groupDispalyOrder b3groupDispalyOrder, b3.id b3id, b3.feelevel b3feelevel, b3.displayOrder b3displayOrder, b3.codeName b3codeName, b3.name b3name, b3.Archive b3Archive, \n");
sql2.append("	b2.groupDispalyOrder b2groupDispalyOrder, b2.id b2id, b2.feelevel b2feelevel, b2.displayOrder b2displayOrder, b2.codeName b2codeName, b2.name b2name, b2.Archive b2Archive \n");
sql2.append("from FnaBudgetfeeType b3 \n");
sql2.append("join FnaBudgetfeeType b2 on b2.id = b3.groupCtrlId \n");
sql2.append("where b3.feeperiod = "+feeperiod+" ");
sql2.append("and (1=2 \n");
for(int i=0;i<sqlCond_currentPage_isEditFeeTypeIds_list_len;i++){
	sql2.append(" or b3.id in ("+sqlCond_currentPage_isEditFeeTypeIds_list.get(i)+") \n");
} 
sql2.append(") \n");
sql2.append("ORDER BY b3.groupDispalyOrder, b2.feelevel, b2.displayOrder, b2.codeName, b2.name, b2.id, b3.feelevel, b3.displayOrder, b3.codeName, b3.name, b3.id ");
rs.executeSql(sql2.toString());
while(rs.next()){
	String b2name = Util.null2String(rs.getString("b2name")).trim();
	String b2id = Util.null2String(rs.getString("b2id")).trim();
	boolean b2Archive = 1==Util.getIntValue(rs.getString("b2Archive"), 0);
	String _b3id = Util.null2String(rs.getString("b3id")).trim();
	
	if(b2id_distinct_list.contains(b2id)){
		continue;
	}
	b2id_distinct_list.add(b2id);
	
	if(!b2id.equals(_b3id)){
		if(b2Archive){
			b2name = FnaCommon.escapeHtml(budgetfeeTypeComInfo.getSubjectFullName(Util.getIntValues(b2id), separator))+"<font color=\"red\">("+SystemEnv.getHtmlLabelName(22151,user.getLanguage())+")</font>";//封存
		}else{
			b2name = FnaCommon.escapeHtml(budgetfeeTypeComInfo.getSubjectFullName(Util.getIntValues(b2id), separator));
		}
		
		//bb.writeLog("10 FnaBudgetViewData.jsp>>>"+SDF.format(Calendar.getInstance().getTime()));
	    //Map<String, String> budgetAmtHm2 = fnaBudgetInfoComInfo.getBudgetAmountBySubject(budgetinfoid+"", b2id);
	    Map<String, String> budgetAmtHm2 = b2BudgetTypeAmountHm.get(b2id);
		if(budgetAmtHm2==null){
			budgetAmtHm2 = new HashMap<String, String>();
		}
	    double sumAmt2 = 0.00;
%>
	<tr class="fnaBudgetInfo_mainTb_tr">
		<td class="tdRowSplit" colspan="2">
			<span style="margin-left: 5px;">
				<span style="font-weight: bold;"><%=b2name %></span>
			</span>
		</td>
	<%
		for(int i=1;i<=qCount;i++){
		double _amt2 = Util.getDoubleValue(budgetAmtHm2.get(i+""), 0.00);
		sumAmt2 = Util.getDoubleValue(df.format(sumAmt2 + _amt2));
	%>
		<td class="amtTd tdRowSplit" id="subject_<%=b2id %>_<%=i %>" _dbAmt="<%=df.format(_amt2) %>" ><%=fnaSplitPageTransmethod.fmtAmountQuartile(_amt2) %></td>
	<%}%>
		<td class="amtTd tdRowSplit" id="subject_<%=b2id %>_ALL" _dbAmt="<%=df.format(sumAmt2) %>" ><%=fnaSplitPageTransmethod.fmtAmountQuartile(sumAmt2) %></td>
	</tr>
<%
	}
	List<HashMap<String, String>> _b3List = currentPage_groupCtrlIds_FnaBudgetfeeTypeHm.get(b2id);
	int _b3ListLen = _b3List.size();
	for(int _b3ListI=0;_b3ListI<_b3ListLen;_b3ListI++){
		String border_bottom_color = "";
		if((_b3ListI+1)==_b3ListLen){
			border_bottom_color = "border-bottom-color: green;";
		}
		
		HashMap<String, String> _b3Hm = _b3List.get(_b3ListI);
		String b3id = _b3Hm.get("b3id");
		String b3name = "";
		if(!b2id.equals(_b3id)){
			b3name = budgetfeeTypeComInfo.getSubjectPartName(b3id, b2id, separator);
		}else{
			b3name = budgetfeeTypeComInfo.getSubjectFullName(b3id, separator);
		}
		boolean b3Archive = 1==Util.getIntValue(_b3Hm.get("b3Archive"), 0);
		String b3Alertvalue = _b3Hm.get("b3Alertvalue");
		
		
		int alertvalue = alertvalue_FnaSystemSet;
		if(!"".equals(b3Alertvalue)){
			alertvalue = Util.getIntValue(b3Alertvalue, 0);
		}
		
		String b3ArchiveHtml = "";
		if(b3Archive){
			b3ArchiveHtml = "<br /><span style=\"margin-left: 15px;font-weight: bold;color: red;\">("+SystemEnv.getHtmlLabelName(22151,user.getLanguage())+")</span>";//封存
		}
		

		//得到某科目整期预算
	    //Map budgetTypeAmount = fnaBudgetInfoComInfo.getBudgetTypeAmount(budgetinfoid+"", b3id);
		Map budgetTypeAmount = b3BudgetTypeAmountHm.get(b3id);
		if(budgetTypeAmount==null){
			budgetTypeAmount = new HashMap();
		}
		//得到某科目整期已分配预算
	    //Map distributiveBudgetAmount = fnaBudgetInfoComInfo.getDistributiveBudgetAmount(organizationid, organizationtype, budgetperiods+"", b3id);
		Map distributiveBudgetAmount = b3DistributiveBudgetTypeAmountHm.get(b3id);
		if(distributiveBudgetAmount==null){
			distributiveBudgetAmount = new HashMap();
		}
	    //得到某科目整期审批中和已使用预算
	    //Map budgetTypeExpense = fnaBudgetInfoComInfo.getBudgetTypeExpense(budgetinfoid+"", b3id, Util.getIntValue(organizationtype), Util.getIntValue(organizationid));
	    Map budgetTypeExpense = b3BudgetTypeExpenseHm.get(b3id);
	    if(budgetTypeExpense==null){
			budgetTypeExpense = new HashMap<String, Expense>();
	    	for(int i=0;i<periodsidKeyListLen;i++){
	    		Expense expense = new Expense();
	    		expense.setPendingExpense(0.00);
	    		expense.setRealExpense(0.00);
	    		budgetTypeExpense.put((i+1)+"", expense);
	    	}
	    }
	    //bb.writeLog("12 FnaBudgetViewData.jsp>>>"+SDF.format(Calendar.getInstance().getTime()));

	    double _sum_ysze = 0.00;
	    double _sum_yfpys = 0.00;
	    double _sum_yfsys = 0.00;
	    double _sum_spzys = 0.00;
	    
	    int rowspan = 4;
	    if((FnaCostCenter.ORGANIZATION_TYPE+"").equals(organizationtype)){
	    	rowspan = 3;
	    }
%>
	<tr class="fnaBudgetInfo_mainTb_tr">
		<td class="tdRowSplit" rowspan="<%=rowspan %>" style="vertical-align: top;<%=border_bottom_color %>">
			<span style="font-weight: bold;margin-left: 15px;"><%=FnaCommon.escapeHtml(b3name) %></span>
			<%=b3ArchiveHtml %>
		</td>
		<td><%=SystemEnv.getHtmlLabelName(18501,user.getLanguage()) %></td><!-- 预算总额 -->
	<%for(int i=1;i<=qCount;i++){
		double _ysze = Util.getDoubleValue((String)budgetTypeAmount.get(i+""), 0.00);

		double _yfpys = Util.getDoubleValue((String)distributiveBudgetAmount.get(i+""), 0.00);
		Expense expense = (Expense)budgetTypeExpense.get(i+"");
		double _yfsys = 0.00;
		double _spzys = 0.00;
		if(expense!=null){
			_yfsys = Util.getDoubleValue(df.format(expense.getRealExpense()), 0.00);			
			_spzys = Util.getDoubleValue(df.format(expense.getPendingExpense()), 0.00);
		}
		
		double _ysyys = 0.0;
		if(budgetControlType2==1){
			_ysyys = Util.getDoubleValue(df.format(_yfsys + _spzys), 0.00);
		}else{
			_ysyys = Util.getDoubleValue(df.format(_yfpys + _yfsys + _spzys), 0.00);
		}

		_sum_ysze = Util.getDoubleValue(df.format(_sum_ysze + _ysze));
		_sum_yfpys = Util.getDoubleValue(df.format(_sum_yfpys + _yfpys));
		_sum_yfsys = Util.getDoubleValue(df.format(_sum_yfsys + _yfsys));
		_sum_spzys = Util.getDoubleValue(df.format(_sum_spzys + _spzys));

		String colorRed1 = "";
		if(_ysze < _ysyys){
			colorRed1 = "color: red;";
		}else if(alertvalue != 0 && (_ysze != 0.00 || _ysyys != 0.00) 
				&& Util.getDoubleValue(df.format(_ysze - _ysyys), 0.00) <= Util.getDoubleValue(df.format((_ysze / 100) * alertvalue), 0.00)){
			colorRed1 = "color: orange;";
		}
	%>
		<td class="amtTd" style="<%=colorRed1%>"><%= fnaSplitPageTransmethod.fmtAmountQuartile(_ysze) %></td>
	<%}
	//bb.writeLog("13 FnaBudgetViewData.jsp>>>"+SDF.format(Calendar.getInstance().getTime()));
	
	double _sum_ysyys = 0.0;
	if(budgetControlType2==1){
		_sum_ysyys = Util.getDoubleValue(df.format(_sum_yfsys + _sum_spzys), 0.00);
	}else{
		_sum_ysyys = Util.getDoubleValue(df.format(_sum_yfpys + _sum_yfsys + _sum_spzys), 0.00);
	}
	%>
		<td class="amtTd"><%= fnaSplitPageTransmethod.fmtAmountQuartile(_sum_ysze) %></td>
	</tr>
<%if(!(FnaCostCenter.ORGANIZATION_TYPE+"").equals(organizationtype)){ %>
	<tr class="fnaBudgetInfo_mainTb_tr">
		<td>
			<%if(budgetControlType2==1){ %>
				<%=SystemEnv.getHtmlLabelName(130462,user.getLanguage()) %><!-- 下级预算总额  -->
			<%}else{ %>
				<%=SystemEnv.getHtmlLabelName(18502,user.getLanguage()) %><!-- 已分配总预算 -->
			<%} %>
		</td>
	<%for(int i=1;i<=qCount;i++){
		double _yfpys = Util.getDoubleValue((String)distributiveBudgetAmount.get(i+""), 0.00);

		double _ysze = Util.getDoubleValue((String)budgetTypeAmount.get(i+""), 0.00);

		String colorRed1 = "";
		if(budgetControlType2!=1 && _ysze < _yfpys){
			colorRed1 = "color: red;";
		}
	%>
		<td class="amtTd" style="<%=colorRed1%>"><%= fnaSplitPageTransmethod.fmtAmountQuartile(_yfpys) %></td>
	<%}
	%>
		<td class="amtTd"><%= fnaSplitPageTransmethod.fmtAmountQuartile(_sum_yfpys) %></td>
	</tr>
<%} %>
	<tr class="fnaBudgetInfo_mainTb_tr">
		<td><%=SystemEnv.getHtmlLabelName(18503,user.getLanguage()) %></td><!-- 已发生费用 -->
	<%for(int i=1;i<=qCount;i++){
		Expense expense = (Expense)budgetTypeExpense.get(i+"");
		double _yfsys = 0.00;
		if(expense!=null){
			_yfsys = Util.getDoubleValue(df.format(expense.getRealExpense()), 0.00);			
		}

		double _ysze = Util.getDoubleValue((String)budgetTypeAmount.get(i+""), 0.00);

		String colorRed1 = "";
		if(_ysze < _yfsys){
			colorRed1 = "color: red;";
		}
	%>
		<td class="amtTd" style="<%=colorRed1%>"><%= fnaSplitPageTransmethod.fmtAmountQuartile(_yfsys) %></td>
	<%}
	//bb.writeLog("14 FnaBudgetViewData.jsp>>>"+SDF.format(Calendar.getInstance().getTime()));
	%>
		<td class="amtTd"><%= fnaSplitPageTransmethod.fmtAmountQuartile(_sum_yfsys) %></td>
	</tr>
	<tr class="fnaBudgetInfo_mainTb_tr">
		<td class="tdRowSplit" style="<%=border_bottom_color %>"><%=SystemEnv.getHtmlLabelName(18769,user.getLanguage()) %></td><!-- 审批中费用  -->
	<%for(int i=1;i<=qCount;i++){
		Expense expense = (Expense)budgetTypeExpense.get(i+"");
		double _spzys = 0.00;
		if(expense!=null){
			_spzys = Util.getDoubleValue(df.format(expense.getPendingExpense()), 0.00);
		}

		double _ysze = Util.getDoubleValue((String)budgetTypeAmount.get(i+""), 0.00);

		String colorRed1 = "";
		if(_ysze < _spzys){
			colorRed1 = "color: red;";
		}
	%>
		<td class="amtTd tdRowSplit" style="<%=colorRed1%><%=border_bottom_color %>"><%= fnaSplitPageTransmethod.fmtAmountQuartile(_spzys) %></td>
	<%}
	//bb.writeLog("15 FnaBudgetViewData.jsp>>>"+SDF.format(Calendar.getInstance().getTime()));
	%>
		<td class="amtTd tdRowSplit" style="<%=border_bottom_color %>"><%= fnaSplitPageTransmethod.fmtAmountQuartile(_sum_spzys) %></td>
	</tr>
<%
	}
}
%>
	<tr>
		<td colspan="<%=2+qCount+1 %>">
			&nbsp;
		<%if(rsAllCnt > 0){ %>
			<div align="right">
				<jsp:include page="/fna/budget/FnaNavigationBar.jsp" flush="true">
					<jsp:param name="pageSize" value="<%=pageSize%>" />
					<jsp:param name="pageIndex" value="<%=pageIndex%>" />
					<jsp:param name="maxPageIndex" value="<%=maxPageIndex%>" />
					<jsp:param name="rsAllCnt" value="<%=rsAllCnt%>"/>
					<jsp:param name="editPageSize" value="1" />
				</jsp:include>
			</div>
		<%} %>
		</td>
	</tr>
</table>

<input id="pageIndex" name="pageIndex" value="<%=pageIndex%>" type="hidden" />
<input id="pageSize" name="pageSize" value="<%=pageSize%>" type="hidden" />

<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(pageIndex > 1){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(1258,user.getLanguage())+",javascript:gotoPage(-1),_self} ";//上一页
	RCMenuHeight += RCMenuHeightStep;
}
if(pageIndex < maxPageIndex){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(1259,user.getLanguage())+",javascript:gotoPage(1),_self} ";//下一页
	RCMenuHeight += RCMenuHeightStep;
}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>


<!-- advanced search -->
<div class="advancedSearchDiv" id="advancedSearchDiv" style="display: none;">
</div>

<script language="javascript">
function gotoPage(_addPageIndex){
	var _pageIndex = jQuery("#pageIndex").val();
	_pageIndex = fnaRound2(_pageIndex, 0) + _addPageIndex;
	window.location.href = "/fna/budget/FnaBudgetViewData.jsp?<%=commonPara %>&pageIndex="+_pageIndex;
}

function jumpPage(_jumpPageIndex, _pageSize){
	if(_pageSize==null){
		_pageSize = "<%=pageSize %>";
	}
	window.location.href = "/fna/budget/FnaBudgetViewData.jsp?<%=commonPara %>&pageIndex="+_jumpPageIndex+"&pageSize="+_pageSize;
}

function jumpPageIpt(){
	jumpPage(jQuery("#_weaverTable_0_XTABLE_GOPAGE_buttom_fna").val());
}

function reloadPageByPageSize(_pageSize){
	jumpPage(1, _pageSize);
}


parent._is_reSize_frmTabcontentframe2 = false;
parent.reSize_frmTabcontentframe2();

</script>
</body>
</html>
<%
		//bb.writeLog("16 FnaBudgetViewData.jsp>>>"+SDF.format(Calendar.getInstance().getTime()));
%>