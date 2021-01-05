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
boolean canEdit = HrmUserVarify.checkUserRight("FnaBudgetEdit:Edit", user);

if(!canEdit){
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

String organizationtype = Util.null2String(request.getParameter("organizationtype"));//组织类型
String organizationid = Util.null2String(request.getParameter("organizationid"));//组织ID
int budgetinfoid = Util.getIntValue(request.getParameter("budgetinfoid"), 0);//预算设置主表id
int budgetperiods = Util.getIntValue(request.getParameter("budgetperiods"), 0);//预算年度id
int status = Util.getIntValue(request.getParameter("status"), 0);//预算状态
int revision = Util.getIntValue(request.getParameter("revision"), 0);//预算版本

String guid1 = Util.null2String(request.getParameter("guid1")).trim();

if(canEdit){
	String sql = "select count(*) cnt from FnaYearsPeriods where id = "+budgetperiods+" and status in (0,1) ";
	rs.executeSql(sql);
	if(!(rs.next() && rs.getInt("cnt") == 1)){
		canEdit = false;
	}
}

if(canEdit && budgetinfoid > 0){
	String sql = "select count(*) cnt from FnaBudgetInfo a where a.id = "+budgetinfoid+" and a.status in (0,1)";
	rs.executeSql(sql);
	if(!(rs.next() && rs.getInt("cnt") == 1)){
		canEdit = false;
	}
}

if(canEdit){
	if(!FnaBudgetInfoComInfo.getSupOrgIdHaveEnableFnaBudgetRevision(organizationid, organizationtype, budgetperiods+"")){
		canEdit = false;
	}
}

if(!canEdit){
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}

String nameQuery = Util.null2String((String)request.getSession().getAttribute("FnaBudgetViewInner1.jsp_nameQuery_"+guid1));
boolean showNilQuery = 1==Util.getIntValue((String)request.getSession().getAttribute("FnaBudgetViewInner1.jsp_hiddenNilQuery_"+guid1), 0);

int qCount = 0;
int feeperiod = 0;
String tabFeeperiod = Util.null2String(request.getParameter("tabFeeperiod")).trim();//打开预算周期tab页类型
if("".equals(tabFeeperiod)){
	tabFeeperiod = "M";
}

//查询各个的期间的关闭状态,整合未关闭的期间
int[] openPeriodsid = new int[]{0,0,0,0,0,0,0,0,0,0,0,0};
String periodsql = " select * from FnaYearsPeriodsList where fnayearid = " + budgetperiods;
periodsql += " order by Periodsid ";
rs.executeSql(periodsql);
int m = 0;
while(rs.next()){
	int mouthStatus = rs.getInt("status");
	int periodsid = rs.getInt("Periodsid");
	if(periodsid != 13){
		openPeriodsid[m] = mouthStatus;
	}
	m++;
}

BaseBean baseBean = new BaseBean();

List<Integer> tmpbudgetList = new ArrayList<Integer>();

if("M".equals(tabFeeperiod)){
	qCount = 12;
	feeperiod = 1;
	for(int i = 0; i < openPeriodsid.length; i++){
		tmpbudgetList.add(openPeriodsid[i]);
	}
}else if("Q".equals(tabFeeperiod)){
	qCount = 4;
	feeperiod = 2;
	for(int i = 1; i < 5 ;i++){
		if(openPeriodsid[3*i-3]==0||openPeriodsid[3*i-2]==0||openPeriodsid[3*i-1]==0){
			tmpbudgetList.add(0);
		}else{
			tmpbudgetList.add(1);
		}
	}
}else if("H".equals(tabFeeperiod)){
	qCount = 2;
	feeperiod = 3;
	for(int i = 1; i < 3; i++){
		if(openPeriodsid[6*i-6]==0||openPeriodsid[6*i-5]==0||openPeriodsid[6*i-4]==0||openPeriodsid[6*i-3]==0||openPeriodsid[6*i-2]==0||openPeriodsid[6*i-1]==0){
			tmpbudgetList.add(0);
		}else{
			tmpbudgetList.add(1);
		}
	}
}else if("Y".equals(tabFeeperiod)){
	qCount = 1;
	feeperiod = 4;
	boolean openYear = false;
	for(int i = 0; i < openPeriodsid.length; i ++){
		if(openPeriodsid[i] == 0){
			openYear = true;
		}
	}
	if(openYear){
		tmpbudgetList.add(0);
	}else{
		tmpbudgetList.add(1);
	}
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
//如果没有传入具体哪个预算机构，或者有传入具体哪个预算机构，并判断为不允许允许查看的，则提示无权限
if(!fnaBudgetViewFlagForEdit){
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}



DecimalFormat df = new DecimalFormat("####################################################0.00");
FnaBudgetInfoComInfo fnaBudgetInfoComInfo = new FnaBudgetInfoComInfo();
BudgetHandler budgetHandler = new BudgetHandler();
BudgetfeeTypeComInfo budgetfeeTypeComInfo = new BudgetfeeTypeComInfo();


String sql = "";

boolean showHiddenSubject = 1==Util.getIntValue(fnaSystemSetComInfo.get_showHiddenSubject());
boolean subjectFilter = 1==Util.getIntValue(fnaSystemSetComInfo.get_subjectFilter());
String separator = Util.null2String(fnaSystemSetComInfo.get_separator());

if("".equals(separator)){
	separator = "/";
}

String _wImg100 = "<img alt=\"\" src=\"\" style=\"width: 80px; height: 0px;\" />";
String _wImg80 = "<img alt=\"\" src=\"\" style=\"width: 80px; height: 0px;\" />";
String _wImg250 = _wImg100;
if(user.getLanguage()!=7){
	_wImg100 = "<img alt=\"\" src=\"\" style=\"min-width: 100px; width: 100px; height: 0px;\" />";
	_wImg80 = "<img alt=\"\" src=\"\" style=\"min-width: 80px; width: 80px; height: 0px;\" />";
	_wImg250 = "<img alt=\"\" src=\"\" style=\"min-width: 200px; width: 200px; height: 0px;\" />";
}
%>
<html>
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
.inputYs{
	width: 66px;
	text-align: right;
}
.fbold{
	font-weight: bold;
}
</style>
</head>
<body style="overflow:auto;">
<%
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
	sql_rs_split.append(" and exists ( \n"+
			" select 1 \n"+
			" from FnaBudgetInfoDetail fbid \n"+
			" join Fnabudgetfeetype fbft on fbid.budgettypeid = fbft.id and fbft.isEditFeeTypeId = b3.id \n"+
			" where (fbid.budgetaccount <> 0.0) \n"+
			" and fbid.budgetinfoid = "+budgetinfoid+" \n"+
		" ) ");
}

if(!"".equals(nameQuery)){
	sql_rs_split.append(" and (b3.name like '%"+StringEscapeUtils.escapeSql(nameQuery)+"%') ");
}
if(!showHiddenSubject){
	sql_rs_split.append(" and (b3.archive is null or b3.archive=0) ");
}
sql_rs_split.append(" and b3.feeperiod = "+feeperiod+" and b3.isEditFeeType = 1 ");


String backFields = " t1.* ";
String sqlFrom = " from ("+sql_rs_split.toString()+") t1 ";
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

%>

<input id="organizationtype" name="organizationtype" value="<%=organizationtype%>" type="hidden" />
<input id="organizationid" name="organizationid" value="<%=organizationid%>" type="hidden" />
<input id="status" name="status" value="<%=status%>" type="hidden" />
<input id="revision" name="revision" value="<%=revision%>" type="hidden" />
<input id="tabFeeperiod" name="tabFeeperiod" value="<%=tabFeeperiod%>" type="hidden" />
<input id="qCount" name="tabFeeperiod" value="<%=qCount%>" type="hidden" />
<input id="pageIndex" name="pageIndex" value="<%=pageIndex%>" type="hidden" />
<input id="pageSize" name="pageSize" value="<%=pageSize%>" type="hidden" />
<input id="guid1" name="guid1" value="<%=guid1%>" type="hidden" />
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

//得到指定范围内所有统一费控的科目整期预算
HashMap<String, Map> b2BudgetTypeAmountHm = fnaBudgetInfoComInfo.getBudgetAmountBySubjects_GroupCtrl(budgetinfoid, currentPage_groupCtrlIds.toString());

//bb.writeLog("5 FnaBudgetViewData.jsp>>>"+SDF.format(Calendar.getInstance().getTime()));
//得到指定范围内所有三级科目整期预算
HashMap<String, Map> b3BudgetTypeAmountHm = fnaBudgetInfoComInfo.getBudgetAmountBySubjects_isEditFeeType(budgetinfoid, currentPage_isEditFeeTypeIds.toString());

//bb.writeLog("6 FnaBudgetViewData.jsp>>>"+SDF.format(Calendar.getInstance().getTime()));
List periodsidKeyList = new ArrayList();
Map budgetPeriodMap = BudgetHandler.getBudgetPeriodMap(budgetperiods, feeperiod+"", periodsidKeyList);
int periodsidKeyListLen = periodsidKeyList.size();
//bb.writeLog("7.1 FnaBudgetViewData.jsp>>>"+SDF.format(Calendar.getInstance().getTime()));

//得到指定范围内三级科目整期已分配预算
HashMap<String, Map> b3DistributiveBudgetTypeAmountHm = fnaBudgetInfoComInfo.getDistributiveBudgetAmountBySubjects_isEditFeeType(budgetperiods, 
		Util.getIntValue(organizationtype), Util.getIntValue(organizationid), currentPage_isEditFeeTypeIds.toString(), df);
//bb.writeLog("7.2 FnaBudgetViewData.jsp>>>"+SDF.format(Calendar.getInstance().getTime()));

//得到指定范围内三级科目整期审批中和已使用预算
HashMap<String, HashMap<String, Expense>> b3BudgetTypeExpenseHm = fnaBudgetInfoComInfo.getBudgetTypeExpenseBySubjects_isEditFeeType(periodsidKeyList, budgetPeriodMap, 
		currentPage_isEditFeeTypeIds.toString(), Util.getIntValue(organizationtype), Util.getIntValue(organizationid), df);
//bb.writeLog("8.1 FnaBudgetViewData.jsp>>>"+SDF.format(Calendar.getInstance().getTime()));

//得到指定范围内三级科目整期上级可用预算
HashMap<String, Map> b3ParentAvailableBudgetAmount = fnaBudgetInfoComInfo.getParentAvailableBudgetAmountBySubjects_isEditFeeType(organizationid, organizationtype, 
		budgetperiods+"", currentPage_isEditFeeTypeIds.toString(), periodsidKeyList, budgetPeriodMap, df);
//bb.writeLog("8.2 FnaBudgetViewData.jsp>>>"+SDF.format(Calendar.getInstance().getTime()));

List<String> b2id_distinct_list = new ArrayList<String>();
StringBuffer jsValidate = new StringBuffer();
StringBuffer sql2 = new StringBuffer(); 
sql2.append("select distinct b3.groupDispalyOrder b3groupDispalyOrder, b3.id b3id, b3.feelevel b3feelevel, b3.displayOrder b3displayOrder, b3.codeName b3codeName, b3.name b3name, \n");
sql2.append("	b2.groupDispalyOrder b2groupDispalyOrder, b2.id b2id, b2.feelevel b2feelevel, b2.displayOrder b2displayOrder, b2.codeName b2codeName, b2.name b2name \n");
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
		
	    //Map<String, String> budgetAmtHm2 = fnaBudgetInfoComInfo.getBudgetAmountBySubject(budgetinfoid+"", b2id);
	    Map<String, String> budgetAmtHm2 = b2BudgetTypeAmountHm.get(b2id);
		if(budgetAmtHm2==null){
			budgetAmtHm2 = new HashMap<String, String>();
		}
	    double sumAmt2Db = 0.00;
	    double sumAmt2 = 0.00;
%>
	<tr class="fnaBudgetInfo_mainTb_tr">
		<td class="tdRowSplit" colspan="2">
			<span style="margin-left: 5px;">
				<span style="font-weight: bold;"><%=b2name %></span>
			</span>
			<input name="saveB2id" value="<%=b2id %>" type="hidden" />
		</td>
	<%
		for(int i=1;i<=qCount;i++){
			double _amt2Db = Util.getDoubleValue(budgetAmtHm2.get(i+""), 0.00);
			double _amt2 = _amt2Db;
			
			_amt2 = FnaCommon.getBudgetEditNewAmtByGuid(session, guid1, tabFeeperiod, Util.getIntValue(b2id), i, _amt2);
	
			sumAmt2Db = Util.getDoubleValue(df.format(sumAmt2Db + _amt2Db));
			sumAmt2 = Util.getDoubleValue(df.format(sumAmt2 + _amt2));
			
			String _divStyle = "";
			if(_amt2Db==_amt2){
				_divStyle = "visibility: hidden;";
			}
	%>
		<td class="amtTd tdRowSplit">
			<div style="font-weight: bold;" id="supSubjectOld_<%=b2id %>_<%=i %>" _val="<%=df.format(_amt2Db) %>" ><%=SystemEnv.getHtmlLabelName(82840,user.getLanguage())%><%=df.format(_amt2Db) %></div>
			<div style="background-color: #D7F300;<%=_divStyle %>" id="supSubjectNew_<%=b2id %>_<%=i %>" _val="<%=df.format(_amt2) %>" ><%=SystemEnv.getHtmlLabelName(82839,user.getLanguage())%><%=df.format(_amt2) %></div>
		</td>
	<%
		}
		String _divStyle = "";
		if(sumAmt2Db==sumAmt2){
			_divStyle = "visibility: hidden;";
		}
	%>
		<td class="amtTd tdRowSplit">
			<div style="font-weight: bold;" id="supSubjectOld_<%=b2id %>_ALL" _val="<%=df.format(sumAmt2Db) %>" ><%=SystemEnv.getHtmlLabelName(82840,user.getLanguage())%><%=df.format(sumAmt2Db) %></div>
			<div style="background-color: #D7F300;<%=_divStyle %>" id="supSubjectNew_<%=b2id %>_ALL" _val="<%=df.format(sumAmt2) %>" ><%=SystemEnv.getHtmlLabelName(82839,user.getLanguage())%><%=df.format(sumAmt2) %></div>
		</td>
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
		//查询科目预算可为负数
		boolean budgetCanBeNegative = "1".equals(budgetfeeTypeComInfo.getBudgetCanBeNegative(b3id+""));
		String b3name = "";
		if(!b2id.equals(_b3id)){
			b3name = budgetfeeTypeComInfo.getSubjectPartName(b3id, b2id, separator);
		}else{
			b3name = budgetfeeTypeComInfo.getSubjectFullName(b3id, separator);
		}
		boolean b3Archive = 1==Util.getIntValue(_b3Hm.get("b3Archive"), 0);
		String b3Alertvalue = _b3Hm.get("b3Alertvalue");
		boolean b3IsEditFeeType = 1==Util.getIntValue(_b3Hm.get("b3IsEditFeeType"), 0);//如果是汇总统计的话则考虑这一项，来判断是否可以显示编辑框
		
		b3IsEditFeeType = true;
		if(!b3IsEditFeeType){
			String groupCtrlSubjectId = Util.null2String(FnaBudgetInfoComInfo.getGroupCtrlSubjectId(b3id)).trim();
			if(groupCtrlSubjectId.equals(b3id)){
				b3IsEditFeeType = true;
			}
		}
		
		String b3ArchiveHtml = "";
		if(b3Archive){
			b3ArchiveHtml = "<br /><span style=\"margin-left: 15px;font-weight: bold;color: red;\">("+SystemEnv.getHtmlLabelName(22151,user.getLanguage())+")</span>";//封存
		}

		//得到某科目整期预算
	    //Map budgetTypeAmount = fnaBudgetInfoComInfo.getBudgetTypeAmount_NULL(budgetinfoid+"", b3id);
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
	    //得到某科目整期上级可用预算
	    //Map availableBudgetAmount = fnaBudgetInfoComInfo.getAvailableBudgetAmount(organizationid, organizationtype, budgetperiods+"", b3id);
	    Map availableBudgetAmount = b3ParentAvailableBudgetAmount.get(b3id);
	    if(availableBudgetAmount==null){
	    	availableBudgetAmount = new HashMap();
	    }

	    double _sum_ysze = 0.00;
	    double _sum_ysze_db = 0.00;
	    double _sum_yfpys = 0.00;
	    double _sum_yfsys = 0.00;
	    double _sum_spzys = 0.00;
	    double _sum_sjkyys = 0.00;
	    
		String colorRed2 = "";
		
	    int rowspan = 6;
	    if((FnaCostCenter.ORGANIZATION_TYPE+"").equals(organizationtype) || budgetControlType2==1){
	    	rowspan = 4;
	    }
%>
	<tr class="fnaBudgetInfo_mainTb_tr">
		<td class="tdRowSplit" rowspan="<%=rowspan %>" style="vertical-align: top;<%=border_bottom_color %>">
			<input id="chkJfKm3_<%=b3id %>" name="chkJfKm3" _km3Id="<%=b3id %>" value="" type="checkbox"/>
			<span style="font-weight: bold;margin-left: 15px;"><%=FnaCommon.escapeHtml(b3name) %></span>
			<%=b3ArchiveHtml %>
			<input id="b2id_<%=b2id %>" name="b2id" value="<%=b2id%>" type="hidden" />
			<input id="b3id_<%=b3id %>" name="b3id" value="<%=b3id%>" type="hidden" />
		</td>
<%if(!(FnaCostCenter.ORGANIZATION_TYPE+"").equals(organizationtype) && budgetControlType2!=1){ %>
		<td><%=SystemEnv.getHtmlLabelName(18604,user.getLanguage()) %></td><!-- 上级可用预算 -->
<%} %>
	<%for(int i=1;i<=qCount;i++){
		//预算总额
		String _yszeStr = Util.null2String((String)budgetTypeAmount.get(i+"")).trim();
		double _ysze = Util.getDoubleValue(_yszeStr, 0.00);
		//已分配预算
		double _yfpys = Util.getDoubleValue((String)distributiveBudgetAmount.get(i+""), 0.00);
		Expense expense = (Expense)budgetTypeExpense.get(i+"");
		//已发生预算
		double _yfsys = 0.00;
		//审批中预算
		double _spzys = 0.00;
		if(expense!=null){
			_yfsys = Util.getDoubleValue(df.format(expense.getRealExpense()), 0.00);			
			_spzys = Util.getDoubleValue(df.format(expense.getPendingExpense()), 0.00);
		}
		//上级可用预算
		double _sjkyys = Util.getDoubleValue((String)availableBudgetAmount.get(i+""), 0.00);
		
		//已使用预算
		double _ysyys = Util.getDoubleValue(df.format(_yfpys + _yfsys + _spzys), 0.00);


		_ysze = FnaCommon.getBudgetEditNewAmtByGuid(session, guid1, tabFeeperiod, Util.getIntValue(b3id), i, _ysze);
		_yszeStr = df.format(_ysze);
		

		_sum_ysze = Util.getDoubleValue(df.format(_sum_ysze + _ysze));
		_sum_yfpys = Util.getDoubleValue(df.format(_sum_yfpys + _yfpys));
		_sum_yfsys = Util.getDoubleValue(df.format(_sum_yfsys + _yfsys));
		_sum_spzys = Util.getDoubleValue(df.format(_sum_spzys + _spzys));
		_sum_sjkyys = Util.getDoubleValue(df.format(_sum_sjkyys + _sjkyys));
		
		if(!(FnaCostCenter.ORGANIZATION_TYPE+"").equals(organizationtype) && budgetControlType2!=1){
	%>
		<td class="amtTd"><%= df.format(_sjkyys) %></td>
	<%
		}
	}
if(!(FnaCostCenter.ORGANIZATION_TYPE+"").equals(organizationtype) && budgetControlType2!=1){
	%>
		<td class="amtTd"><%= df.format(_sum_sjkyys) %></td>
	</tr>
	<tr class="fnaBudgetInfo_mainTb_tr">
		<td><%=SystemEnv.getHtmlLabelName(18502,user.getLanguage()) %></td><!-- 已分配/汇总预算 -->
	<%for(int i=1;i<=qCount;i++){
		//已分配预算
		double _yfpys = Util.getDoubleValue((String)distributiveBudgetAmount.get(i+""), 0.00);

		//预算总额
		double _ysze = Util.getDoubleValue((String)budgetTypeAmount.get(i+""), 0.00);

		String colorRed1 = "";
		if(_ysze < _yfpys){
			colorRed1 = "color: red;";
		}
	%>
		<td class="amtTd" style="<%=colorRed1%>"><%= df.format(_yfpys) %></td>
	<%}
	
	colorRed2 = "";
	if(_sum_ysze < _sum_yfpys){
		colorRed2 = "color: red;";
	}
	%>
		<td class="amtTd" style="<%=colorRed2%>"><%= df.format(_sum_yfpys) %></td>
	</tr>
	<tr class="fnaBudgetInfo_mainTb_tr">
<%} %>
		<td><%=SystemEnv.getHtmlLabelName(18503,user.getLanguage()) %></td><!-- 已发生费用 -->
	<%for(int i=1;i<=qCount;i++){
		Expense expense = (Expense)budgetTypeExpense.get(i+"");
		//已发生预算
		double _yfsys = 0.00;
		if(expense!=null){
			_yfsys = Util.getDoubleValue(df.format(expense.getRealExpense()), 0.00);			
		}

		//预算总额
		double _ysze = Util.getDoubleValue((String)budgetTypeAmount.get(i+""), 0.00);

		String colorRed1 = "";
		if(_ysze < _yfsys){
			colorRed1 = "color: red;";
		}
	%>
		<td class="amtTd" style="<%=colorRed1%>"><%= df.format(_yfsys) %></td>
	<%}
	
	colorRed2 = "";
	if(_sum_ysze < _sum_yfsys){
		colorRed2 = "color: red;";
	}
	%>
		<td class="amtTd" style="<%=colorRed2%>"><%= df.format(_sum_yfsys) %></td>
	</tr>
	<tr class="fnaBudgetInfo_mainTb_tr">
		<td><%=SystemEnv.getHtmlLabelName(18769,user.getLanguage()) %></td><!-- 审批中费用 -->
	<%for(int i=1;i<=qCount;i++){
		Expense expense = (Expense)budgetTypeExpense.get(i+"");
		//审批中预算
		double _spzys = 0.00;
		if(expense!=null){
			_spzys = Util.getDoubleValue(df.format(expense.getPendingExpense()), 0.00);
		}

		//预算总额
		double _ysze = Util.getDoubleValue((String)budgetTypeAmount.get(i+""), 0.00);

		String colorRed1 = "";
		if(_ysze < _spzys){
			colorRed1 = "color: red;";
		}
	%>
		<td class="amtTd" style="<%=colorRed1%>"><%= df.format(_spzys) %></td>
	<%}
	
	colorRed2 = "";
	if(_sum_ysze < _sum_spzys){
		colorRed2 = "color: red;";
	}
	%>
		<td class="amtTd" style="<%=colorRed2%>"><%= df.format(_sum_spzys) %></td>
	</tr>
	<tr class="fnaBudgetInfo_mainTb_tr">
		<td><%=SystemEnv.getHtmlLabelName(22108,user.getLanguage()) %></td><!-- 当前预算 -->
	<%for(int i=1;i<=qCount;i++){
		//预算总额
		double _ysze = Util.getDoubleValue((String)budgetTypeAmount.get(i+""), 0.00);
		//已分配预算
		double _yfpys = Util.getDoubleValue((String)distributiveBudgetAmount.get(i+""), 0.00);
		Expense expense = (Expense)budgetTypeExpense.get(i+"");
		//已发生预算
		double _yfsys = 0.00;
		//审批中预算
		double _spzys = 0.00;
		if(expense!=null){
			_yfsys = Util.getDoubleValue(df.format(expense.getRealExpense()), 0.00);			
			_spzys = Util.getDoubleValue(df.format(expense.getPendingExpense()), 0.00);
		}
		//上级可用预算
		double _sjkyys = Util.getDoubleValue((String)availableBudgetAmount.get(i+""), 0.00);
		
		//已使用预算
		double _ysyys = Util.getDoubleValue(df.format(_yfpys + _yfsys + _spzys), 0.00);

		String colorRed1 = "";
		if(_ysze < _ysyys){
			colorRed1 = "color: red;";
		}
		
		_sum_ysze_db = Util.getDoubleValue(df.format(_sum_ysze_db + _ysze));
	%>
		<td class="amtTd fbold" style="<%=colorRed1%>"><%= df.format(_ysze) %></td>
	<%}
	
	double _sum_ysyys = Util.getDoubleValue(df.format(_sum_yfpys + _sum_yfsys + _sum_spzys), 0.00);
	
	colorRed2 = "";
	if(_sum_ysze_db < _sum_ysyys){
		colorRed2 = "color: red;";
	}
	%>
		<td class="amtTd fbold" style="<%=colorRed2%>"><%= df.format(_sum_ysze_db) %></td>
	</tr>
	<tr class="fnaBudgetInfo_mainTb_tr">
		<td class="tdRowSplit" style="<%=border_bottom_color %>"><%=SystemEnv.getHtmlLabelName(18570,user.getLanguage()) %></td><!-- 新预算额 -->
	<%for(int i=1;i<=qCount;i++){
		
		//关账月份控制输入
		String readonly = "";
		RecordSet rSet = new RecordSet();
		if(qCount == 12){
			StringBuffer buffer = new StringBuffer();
			buffer.append(" select * from FnaYearsPeriodsList where fnayearid = ").append(budgetperiods);
			buffer.append(" and Periodsid = ").append(i);
			rSet.executeSql(buffer.toString());
			if(rSet.next()){
				int mouthStatus = rSet.getInt("status");
				if(mouthStatus == 1){
					readonly = "readonly";
				}
			}
		}
		if(qCount == 4){
			StringBuffer buffer = new StringBuffer();
			buffer.append(" select COUNT(*) num from FnaYearsPeriodsList where fnayearid = ").append(budgetperiods);
			buffer.append(" and status = 1 ");
			buffer.append(" and Periodsid in (").append(3*i-2).append(",").append(3*i-1).append(",").append(3*i).append(")");
			rSet.executeSql(buffer.toString());
			if(rSet.next()){
				int num = rSet.getInt("num");
				if(num == 3){
					readonly = "readonly";
				}
			}
		}
		if(qCount == 2){
			StringBuffer buffer = new StringBuffer();
			buffer.append(" select COUNT(*) num from FnaYearsPeriodsList where fnayearid = ").append(budgetperiods);
			buffer.append(" and status = 1 ");
			buffer.append(" and Periodsid <= ").append(i*6);
			buffer.append(" and Periodsid >= ").append(i*6-5);
			rSet.executeSql(buffer.toString());
			if(rSet.next()){
				int num = rSet.getInt("num");
				if(num == 6){
					readonly = "readonly";
				}
			}
		}
		if(qCount == 1){
			StringBuffer buffer = new StringBuffer();
			buffer.append(" select COUNT(*) num from FnaYearsPeriodsList where fnayearid = ").append(budgetperiods);
			buffer.append(" and status = 1 ");
			rSet.executeSql(buffer.toString());
			if(rSet.next()){
				int num = rSet.getInt("num");
				if(num == 12){
					readonly = "readonly";
				}
			}
		}
		
		//预算总额
		String _yszeStr = Util.null2String((String)budgetTypeAmount.get(i+"")).trim();
		double _yszeDb = Util.getDoubleValue(_yszeStr, 0.00);
		double _ysze = _yszeDb;

		_ysze = FnaCommon.getBudgetEditNewAmtByGuid(session, guid1, tabFeeperiod, Util.getIntValue(b3id), i, _ysze);
		_yszeStr = df.format(_ysze);	
		
		
		String inputName = "ipt_ysze_"+b3id+"_"+tabFeeperiod+"_"+i;
		
		if(budgetCanBeNegative){
			jsValidate.append("controlNumberCheck_jQuery(\""+inputName+"\", true, 2, true, 16);"+"\r\n");
		}else{
			jsValidate.append("controlNumberCheck_jQuery(\""+inputName+"\", true, 2, false, 16);"+"\r\n");
		}
		jsValidate.append("jQuery(\"#"+inputName+"\").bind(\"blur\", function(){_reloadAmt(\""+inputName+"\")});"+"\r\n");
	%>
		<td class="amtTd tdRowSplit" style="<%=border_bottom_color %>">
	<%
		String iptType = "text";
		if(!b3IsEditFeeType){
			iptType = "hidden";
	%>
			<%=("".equals(_yszeStr))?_yszeStr:df.format(_ysze) %>
	<%
		} 
		String _styleStr = "";
		if(_yszeDb!=_ysze){
			_styleStr = "border-color: #D7F300;";
		}
	%>
			<input id="<%=inputName %>" name="<%=inputName %>" value="<%=("".equals(_yszeStr))?_yszeStr:df.format(_ysze) %>" type="<%=iptType %>" class="inputstyle inputYs" 
			 style="<%=_styleStr %>"  <%=readonly %>
			 _dbVal="<%=df.format(_yszeDb) %>" 
			 _oldVal="<%=("".equals(_yszeStr))?_yszeStr:df.format(_ysze) %>" _b2id="<%=b2id %>" _b3id="<%=b3id %>" _i="<%=i %>" 
			 onblur="iptFna_onblur(<%=b3id %>, '<%=tabFeeperiod %>', <%=i %>);" />
		</td>
	<%}
	
	String sumInputName = "ipt_ysze_"+b3id+"_"+tabFeeperiod+"_sum";

	if(budgetCanBeNegative){
		jsValidate.append("controlNumberCheck_jQuery(\""+sumInputName+"\", true, 2, true, 16);"+"\r\n");
	}else{
		jsValidate.append("controlNumberCheck_jQuery(\""+sumInputName+"\", true, 2, false, 16);"+"\r\n");
	}
	
	%>
		<td class="amtTd tdRowSplit" style="<%=colorRed2%><%=border_bottom_color %>">
	<%
		String iptType = "text";
		if(!b3IsEditFeeType){
			iptType = "hidden";
	%>
			<%= df.format(_sum_ysze) %>
	<%
		} 
		String _styleStr = "";
		if(_sum_ysze_db!=_sum_ysze){
			_styleStr = "border-color: #D7F300;";
		}
	%>
			<input id="<%=sumInputName %>" name="<%=sumInputName %>" value="<%= df.format(_sum_ysze) %>" type="<%=iptType %>" 
			style="<%=_styleStr %>"   
			 	_dbVal="<%=df.format(_sum_ysze_db) %>" 
				_oldVal="<%= df.format(_sum_ysze) %>" _b2id="<%=b2id %>" _b3id="<%=b3id %>" _i="ALL" 
				_budgetCanBeNegative = "<%=budgetCanBeNegative %>"
				onblur="chkedJf(this);" 
			 	class="inputstyle inputYs" />
		</td>
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
RCMenu += "{"+SystemEnv.getHtmlLabelName(18579,user.getLanguage())+",javascript:splitYearAmtAll(),_self} ";//下一页
RCMenuHeight += RCMenuHeightStep;
%>

<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(18579,user.getLanguage()) %>" id="btnReturn"
				class="e8_btn_top" onclick="splitYearAmtAll();"/><!-- 按预算期均分 -->
			&nbsp;&nbsp;&nbsp;
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu"></span><!-- 菜单 -->
		</td>
	</tr>
</table>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>


<!-- advanced search -->
<div class="advancedSearchDiv" id="advancedSearchDiv" style="display: none;">
</div>

<script language="javascript">

var NewNum = "<%=SystemEnv.getHtmlLabelName(82839,user.getLanguage())%>";

var qCount = <%=qCount%>;

var tmpbudgetArray = new Array();
<%
if(qCount == 12){
%>	
	tmpbudgetArray[0] = <%=tmpbudgetList.get(0) %>;
	tmpbudgetArray[1] = <%=tmpbudgetList.get(1) %>;
	tmpbudgetArray[2] = <%=tmpbudgetList.get(2) %>;
	tmpbudgetArray[3] = <%=tmpbudgetList.get(3) %>;
	tmpbudgetArray[4] = <%=tmpbudgetList.get(4) %>;
	tmpbudgetArray[5] = <%=tmpbudgetList.get(5) %>;
	tmpbudgetArray[6] = <%=tmpbudgetList.get(6) %>;
	tmpbudgetArray[7] = <%=tmpbudgetList.get(7) %>;
	tmpbudgetArray[8] = <%=tmpbudgetList.get(8) %>;
	tmpbudgetArray[9] = <%=tmpbudgetList.get(9) %>;
	tmpbudgetArray[10] = <%=tmpbudgetList.get(10) %>;
	tmpbudgetArray[11] = <%=tmpbudgetList.get(11) %>;
<%	
}else if(qCount == 4){
%>
	tmpbudgetArray[0] = <%=tmpbudgetList.get(0) %>;
	tmpbudgetArray[1] = <%=tmpbudgetList.get(1) %>;
	tmpbudgetArray[2] = <%=tmpbudgetList.get(2) %>;
	tmpbudgetArray[3] = <%=tmpbudgetList.get(3) %>;
<%	
}else if(qCount == 2){
%>	
	tmpbudgetArray[0] = <%=tmpbudgetList.get(0) %>;
	tmpbudgetArray[1] = <%=tmpbudgetList.get(1) %>;
<%	
}else if(qCount == 1){
%>	
	tmpbudgetArray[0] = <%=tmpbudgetList.get(0) %>;
<%	
}
%>


//全年失去焦点是选中均分checkbox
function chkedJf(_obj){
	var b3id = jQuery(_obj).attr("_b3id");
	jQuery("#chkJfKm3_"+b3id).trigger("checked",true);
}

//即时重算新预算合计
function _reloadAmt(iptId){
	
	var _iptObj = jQuery("#"+iptId);
	var _iptNewVal = fnaRound2(_iptObj.val(), 2);
	var _iptOldVal = fnaRound2(_iptObj.attr("_oldVal"), 2);
	var _offsetVal = fnaRound2(_iptNewVal - _iptOldVal, 2);
	var _iptDbVal = fnaRound2(_iptObj.attr("_dbVal"), 2);
	
	var _b2id = _iptObj.attr("_b2id");
	var _i = _iptObj.attr("_i");

	var _td2OldObj = jQuery("#supSubjectOld_"+_b2id+"_"+_i);//统一费控科目

	var _td2Obj = jQuery("#supSubjectNew_"+_b2id+"_"+_i);

	_iptObj.attr("_oldVal", _iptNewVal);
	
	var _td2CurVal = fnaRound2(_td2Obj.attr("_val"), 2);
	
	var _td2NewVal = fnaRound2(_td2CurVal + _offsetVal, 2);

	_td2Obj.text(NewNum+formatNumber(_td2NewVal, "0.00"));

	_td2Obj.attr("_val", formatNumber(_td2NewVal, "0.00"));
	
	var _td2OldVal = fnaRound2(_td2OldObj.attr("_val"), 2);
	
	if(_iptDbVal==_iptNewVal){
		_iptObj.css("border-color", "#E9E9E2");
	}else{
		_iptObj.css("border-color", "#D7F300");
	}

	try{
		if(_td2OldVal==fnaRound2(_td2Obj.attr("_val"), 2)){
			_td2Obj[0].style.visibility="hidden";
		}else{
			_td2Obj[0].style.visibility="visible";
		}
	}catch(ex1){}
}

//按预算期均分全年预算ALL
function splitYearAmtAll(){
	top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(18579,user.getLanguage())+"?" %>",
		function(){
		var _flag = false;
			var _km3Array = jQuery("input[name='chkJfKm3']");
			for(var i=0;i<_km3Array.length;i++){
				if(jQuery(_km3Array[i]).attr("checked")){
					_flag = true;
					break;
				}
			}
			if(_flag){
				splitYearAmtAll2();
			}else{
				top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(82843,user.getLanguage())%>");
			}
		},function(){
		}
	);
}

//是否清空本行所有期间数据后均分
function splitYearAmtAll2(){
	top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(82844,user.getLanguage())%>",
		function(){
			var _km3Array = jQuery("input[name='chkJfKm3']");
			for(var i=0;i<_km3Array.length;i++){
				if(jQuery(_km3Array[i]).attr("checked")){
					var _km3 = jQuery(_km3Array[i]).attr("_km3Id");
					var sumInputName = "ipt_ysze_"+_km3+"_<%=tabFeeperiod %>_";
					var _objArray = jQuery("input[id^='"+sumInputName+"']");
					for(var j=0;j<_objArray.length;j++){
						if(_objArray[j].id!=sumInputName+"sum"){
							if(tmpbudgetArray[j]==0){
								_objArray[j].value="";
							}
						}
					}
				}
			}
			splitYearAmtAll3();
		},function(){
			splitYearAmtAll3();
		}
	);
}

//执行均分
function splitYearAmtAll3(){
	var _km3Array = jQuery("input[name='chkJfKm3']");
	for(var i=0;i<_km3Array.length;i++){
		if(jQuery(_km3Array[i]).attr("checked")){
			var _km3 = jQuery(_km3Array[i]).attr("_km3Id");
			var sumInputName = "ipt_ysze_"+_km3+"_<%=tabFeeperiod %>_";
			var _sumIptObj = jQuery("#"+sumInputName+"sum");
			splitYearAmt(_km3,'<%=tabFeeperiod %>',_sumIptObj.val(),_sumIptObj[0],true);
			var _objArray = jQuery("input[id^='"+sumInputName+"']");
			for(var j=0;j<_objArray.length;j++){
				_reloadAmt(_objArray[j].id);
			}
		}
	}
}

//按预算期均分全年预算
function splitYearAmt(b3id,tabFeeperiod,yearAmt,obj,notNeedCheck){
	
	if(notNeedCheck==null){
		notNeedCheck = false;
	}
	yearAmt = fnaRound2(yearAmt, 2);
	var tabFeeperiodLen = 12;
	if(tabFeeperiod=="Q"){
		tabFeeperiodLen = 4;
	}else if(tabFeeperiod=="H"){
		tabFeeperiodLen = 2;
	}else if(tabFeeperiod=="Y"){
		tabFeeperiodLen = 1;
	}
	obj = jQuery(obj);
	
	var haveNullInputCnt = 0;
	var allAmt = 0.00;
	var inputName = "ipt_ysze_"+b3id+"_"+tabFeeperiod+"_";
	var allIptArray = jQuery("input[name^='"+inputName+"']");
	for(var i=0;i<allIptArray.length;i++){
		if(i==allIptArray.length-1){
			break;
		}
		var allIpt = jQuery(allIptArray[i]);
		var amt = fnaRound2(allIpt.val(), 2);
		if(tmpbudgetArray[i]==0){
			allAmt = fnaRound2(allAmt+amt, 2);
			if(allIpt.val()==""){
				haveNullInputCnt++;
			}
		}
	}
	//获取当前科目预算可为负数
	var _budgetCanBeNegative = obj.attr("_budgetCanBeNegative");
	
	if(!_budgetCanBeNegative){
		if(yearAmt <= allAmt){
			obj.val(allAmt);
			return;
		}
	}

	if((haveNullInputCnt > 0 && yearAmt > allAmt) || (haveNullInputCnt > 0 && _budgetCanBeNegative)){
		//按预算期均分
		if(notNeedCheck){
			//(1200-0)/12   100
			var avgAllAmt = fnaRound2((yearAmt - allAmt) / (haveNullInputCnt*1.0), 2);
			//(1200-0)-(100*12)   0
			var pczAmt = fnaRound2((yearAmt - allAmt) - (avgAllAmt * haveNullInputCnt), 2);
			for(var i=0;i<allIptArray.length;i++){
				if(i==12){
					break;
				}
				var allIpt = jQuery(allIptArray[i]);
				if(allIpt.val()==""){
					if(tmpbudgetArray[i]==0){
						if(i==allIptArray.length-2){
							allIpt.val(fnaRound2(avgAllAmt + pczAmt, 2));
						}else{
							allIpt.val(avgAllAmt);
						}
					}
				}
			}
		}else{
			top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(18579,user.getLanguage())+"?" %>",
				function(){
					var avgAllAmt = fnaRound2((yearAmt - allAmt) / (haveNullInputCnt*1.0), 2);
					var pczAmt = fnaRound2((yearAmt - allAmt) - (avgAllAmt * haveNullInputCnt), 2);
					for(var i=0;i<allIptArray.length;i++){
						if(i==12){
							break;
						}
						var allIpt = jQuery(allIptArray[i]);
						if(allIpt.val()==""){
							if(tmpbudgetArray[i]==0){
								if(i==allIptArray.length-2){
									allIpt.val(fnaRound2(avgAllAmt + pczAmt, 2));
								}else{
									allIpt.val(avgAllAmt);
								}
							}
						}
					}
				},function(){
					//obj.val(allAmt);
				}
			);
		}
	}else{
		obj.val(allAmt);
	}
}

function gotoPage(_addPageIndex){
	parent.saveFna("window.tabcontentframe2.gotoPage2("+_addPageIndex+")", true);
}
function gotoPage2(_addPageIndex){
	var _pageIndex = jQuery("#pageIndex").val();
	_pageIndex = fnaRound2(_pageIndex, 0) + _addPageIndex;
	window.location.href = "/fna/budget/FnaBudgetEdit.jsp?<%=commonPara %>&pageIndex="+_pageIndex;
}

function jumpPage(_jumpPageIndex, _pageSize){
	if(_pageSize==null){
		_pageSize = "<%=pageSize %>";
	}
	parent.saveFna("window.tabcontentframe2.jumpPage2("+_jumpPageIndex+", "+_pageSize+")", true);
}

function jumpPage2(_jumpPageIndex, _pageSize){
	if(_pageSize==null){
		_pageSize = "<%=pageSize %>";
	}
	window.location.href = "/fna/budget/FnaBudgetEdit.jsp?<%=commonPara %>&pageIndex="+_jumpPageIndex+"&pageSize="+_pageSize;
}


function jumpPageIpt(){
	jumpPage(jQuery("#_weaverTable_0_XTABLE_GOPAGE_buttom_fna").val());
}

function reloadPageByPageSize(_pageSize){
	jumpPage(1, _pageSize);
}


<%=jsValidate.toString() %>

//计算新预算全年合计
function iptFna_onblur(_b3id, _tabFeeperiod, _periodslist){
	var _sum_ysze = 0.00;
	var _iptFnaArray = jQuery("input[id^='ipt_ysze_"+_b3id+"_"+_tabFeeperiod+"_']");
	for(var i=0;i<_iptFnaArray.length;i++){
		var _iptFna = jQuery(_iptFnaArray[i]);
		if(_iptFna.attr("id").indexOf("_sum") < 0){
			_sum_ysze = fnaRound2(_sum_ysze + fnaRound2(_iptFna.val(), 2), 2);
		}
	}
	jQuery("#ipt_ysze_"+_b3id+"_"+_tabFeeperiod+"_sum").val(_sum_ysze);
	_reloadAmt("ipt_ysze_"+_b3id+"_"+_tabFeeperiod+"_sum");
}

parent._is_reSize_frmTabcontentframe2 = false;
parent.reSize_frmTabcontentframe2();

</script>
</body>
</html>