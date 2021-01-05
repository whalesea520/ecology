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
boolean canView = HrmUserVarify.checkUserRight("FnaBudget:All",user) ;
boolean canEdit = false;
if(!canView && !canEdit){
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = "";
String needfav ="1";
String needhelp ="";

RecordSet rs = new RecordSet();
RecordSet rs1 = new RecordSet();
RecordSet rs2 = new RecordSet();
RecordSet rs3 = new RecordSet();

String organizationtype = Util.null2String(request.getParameter("organizationtype"));//组织类型
String organizationid = Util.null2String(request.getParameter("organizationid"));//组织ID
int budgetinfoid = Util.getIntValue(request.getParameter("budgetinfoid"), 0);//预算设置主表id
int budgetperiods = Util.getIntValue(request.getParameter("budgetperiods"), 0);//预算年度id
int status = Util.getIntValue(request.getParameter("status"), 0);//预算状态
int revision = Util.getIntValue(request.getParameter("revision"), 0);//预算版本

String guid1 = Util.null2String(request.getParameter("guid1")).trim();

String nameQuery = Util.null2String((String)request.getSession().getAttribute("FnaBudgetViewInner1.jsp_nameQuery_"+guid1));
boolean showNilQuery = 1==Util.getIntValue((String)request.getSession().getAttribute("FnaBudgetViewInner1.jsp_hiddenNilQuery_"+guid1), 0);

int qCount = 0;
int feeperiod = 0;
String tabFeeperiod = Util.null2String(request.getParameter("tabFeeperiod")).trim();//打开预算周期tab页类�?
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


DecimalFormat df = new DecimalFormat("####################################################0.00");
FnaBudgetInfoComInfo fnaBudgetInfoComInfo = new FnaBudgetInfoComInfo();
BudgetHandler budgetHandler = new BudgetHandler();
BudgetfeeTypeComInfo budgetfeeTypeComInfo = new BudgetfeeTypeComInfo();


String sql = "";


FnaSystemSetComInfo fnaSystemSetComInfo = new FnaSystemSetComInfo();
boolean showHiddenSubject = 1==Util.getIntValue(fnaSystemSetComInfo.get_showHiddenSubject(), 0);
boolean subjectFilter = 1==Util.getIntValue(fnaSystemSetComInfo.get_subjectFilter(), 0);
String separator = Util.null2String(fnaSystemSetComInfo.get_separator());
int alertvalue_FnaSystemSet = Util.getIntValue(fnaSystemSetComInfo.get_alertvalue(), 0);



if("".equals(separator)){
	separator = "/";
}

String _wImg100 = "<img alt=\"\" src=\"\" style=\"width: 100px; height: 0px;\" />";
String _wImg80 = "<img alt=\"\" src=\"\" style=\"width: 80px; height: 0px;\" />";
%>

<%@page import="java.text.SimpleDateFormat"%><html>
<head>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language="javascript" src="/js/weaver_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<script language="javascript" src="/fna/js/e8Common_wev8.js?r=3"></script>
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
<table class="tb" style="width: 100%;" cellpadding="5" cellspacing="0">
	<tr style="height: 0px; background-color: #F2F2F2; border: 0px; margin: 0px; padding: 0px; color: #F2F2F2; font-size: 0px; visibility: hidden;" height="0px">
		<th style="height: 0px; font-size: 0px;" height="0px"><%=_wImg100 %></th>
		<th style="height: 0px; font-size: 0px;" height="0px"><%=_wImg100 %></th>
	<%for(int i=1;i<=qCount;i++){%>
		<th style="height: 0px; font-size: 0px;" height="0px"><%=_wImg80 %></th>
	<%}%>
		<th style="height: 0px; font-size: 0px;" height="0px"><%=_wImg80 %></th>
	</tr>
	<tr class="tbTh" style="background-color: #F2F2F2;">
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
sql_rs_split.append("select DISTINCT b2.id b2id, b2.name b2name, b2.codeName b2codeName, b2.feelevel b2feelevel, b2.Archive b2Archive, b2.alertvalue b2Alertvalue, b2.isEditFeeType b2IsEditFeeType, b2.displayOrder b2displayOrder, \n");
sql_rs_split.append("	b3.id b3id, b3.name b3name, b3.codeName b3codeName, b3.feelevel b3feelevel, b3.Archive b3Archive, b3.alertvalue b3Alertvalue, b3.isEditFeeType b3IsEditFeeType, b3.displayOrder b3displayOrder \n");
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
	sql_rs_split.append(" and ( \n");
	sql_rs_split.append(" exists ( \n"+
			" select 1 \n"+
			" from FnaBudgetInfoDetail fbid \n"+
			" join Fnabudgetfeetype fbft on fbid.budgettypeid = fbft.id \n"+
			" where (fbid.budgetaccount <> 0.0) \n"+
			" and fbft.isEditFeeTypeId = b3.id \n"+
			" and fbid.budgetinfoid = "+budgetinfoid+" \n"+
		" ) ");
	sql_rs_split.append(" or \n");
	sql_rs_split.append(" exists ( \n"+
			" select 1 \n"+
			" from FnaExpenseInfo fei \n"+
			" join FnaBudgetfeeType b on fei.subject = b.id \n"+
			" where (fei.amount <> 0.0) \n"+
			" and fei.organizationtype = "+Util.getIntValue(organizationtype)+" \n"+
			" and fei.organizationid = "+Util.getIntValue(organizationid)+" \n"+
			" and b.isEditFeeTypeId = b3.id \n"+
		" ) ");
	sql_rs_split.append(" ) \n");
}

if(!"".equals(nameQuery)){
	sql_rs_split.append(" and (b3.name like '%"+StringEscapeUtils.escapeSql(nameQuery)+"%') \n");
}
if(!showHiddenSubject){
	sql_rs_split.append(" and (b3.archive is null or b3.archive=0) ");
}
sql_rs_split.append(" and b3.feeperiod = "+feeperiod+" and b3.isEditFeeType = 1 ");

String backFields = " t1.* \n";
String sqlFrom = " from ("+sql_rs_split.toString()+") t1 \n";
String SqlOrderBy = " t1.b2feelevel, t1.b2displayOrder, t1.b2codeName, t1.b2name, t1.b3feelevel, t1.b3displayOrder, t1.b3codeName, t1.b3name ";
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
sql1.append("select DISTINCT b2.id b2id, b2.name b2name, b2.codeName b2codeName, b2.feelevel b2feelevel, b2.Archive b2Archive, b2.alertvalue b2Alertvalue, b2.isEditFeeType b2IsEditFeeType, b2.displayOrder b2displayOrder, \n");
sql1.append("	b3.id b3id, b3.name b3name, b3.codeName b3codeName, b3.feelevel b3feelevel, b3.Archive b3Archive, b3.alertvalue b3Alertvalue, b3.isEditFeeType b3IsEditFeeType, b3.displayOrder b3displayOrder \n");
sql1.append("from FnaBudgetfeeType b2 \n");
sql1.append("join FnaBudgetfeeType b3 on b2.id = b3.groupCtrlId \n");
sql1.append(" where (b2.id = b2.groupCtrlId) \n");
sql1.append(" and ( 1=2 \n");
for(int i=0;i<sqlCond_currentPage_isEditFeeTypeIds_list_len;i++){
	sql1.append(" or b3.id in ("+sqlCond_currentPage_isEditFeeTypeIds_list.get(i)+") \n");
}
sql1.append(" ) \n");
sql1.append(" ORDER BY b2.feelevel, b2.displayOrder, b2.codeName, b2.name, b2.id, b3.feelevel, b3.displayOrder, b3.codeName, b3.name, b3.id ");
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
//bb.writeLog("7.1 FnaBudgetViewData.jsp>>>"+SDF.format(Calendar.getInstance().getTime()));

//得到指定范围内三级科目整期已分配预算
HashMap<String, Map> b3DistributiveBudgetTypeAmountHm = fnaBudgetInfoComInfo.getDistributiveBudgetAmountBySubjects_isEditFeeType(budgetperiods, 
		Util.getIntValue(organizationtype), Util.getIntValue(organizationid), currentPage_isEditFeeTypeIds.toString(), df);
//bb.writeLog("7.2 FnaBudgetViewData.jsp>>>"+SDF.format(Calendar.getInstance().getTime()));

//得到指定范围内三级科目整期审批中和已使用预算
HashMap<String, HashMap<String, Expense>> b3BudgetTypeExpenseHm = fnaBudgetInfoComInfo.getBudgetTypeExpenseBySubjects_isEditFeeType(periodsidKeyList, budgetPeriodMap, 
		currentPage_isEditFeeTypeIds.toString(), Util.getIntValue(organizationtype), Util.getIntValue(organizationid), df);
//bb.writeLog("8 FnaBudgetViewData.jsp>>>"+SDF.format(Calendar.getInstance().getTime()));

List<String> b2id_distinct_list = new ArrayList<String>();
StringBuffer jsValidate = new StringBuffer();
StringBuffer sql2 = new StringBuffer(); 
sql2.append("select distinct b3.id b3id, b3.feelevel b3feelevel, b3.displayOrder b3displayOrder, b3.codeName b3codeName, b3.name b3name, b3.Archive b3Archive, \n");
sql2.append("	b2.id b2id, b2.feelevel b2feelevel, b2.displayOrder b2displayOrder, b2.codeName b2codeName, b2.name b2name, b2.Archive b2Archive \n");
sql2.append("from FnaBudgetfeeType b3 \n");
sql2.append("join FnaBudgetfeeType b2 on b2.id = b3.groupCtrlId \n");
sql2.append("where b3.feeperiod = "+feeperiod+" ");
sql2.append("and (1=2 \n");
for(int i=0;i<sqlCond_currentPage_isEditFeeTypeIds_list_len;i++){
	sql2.append(" or b3.id in ("+sqlCond_currentPage_isEditFeeTypeIds_list.get(i)+") \n");
} 
sql2.append(") \n");
sql2.append("ORDER BY b2.feelevel, b2.displayOrder, b2.codeName, b2.name, b2.id, b3.feelevel, b3.displayOrder, b3.codeName, b3.name, b3.id ");
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
	<tr>
		<td class="tdRowSplit" colspan="2">
			<span style="margin-left: 15px;">
				<span style="font-weight: bold;"><%=b2name %></span>
			</span>
		</td>
	<%
		for(int i=1;i<=qCount;i++){
		double _amt2 = Util.getDoubleValue(budgetAmtHm2.get(i+""), 0.00);
		sumAmt2 = Util.getDoubleValue(df.format(sumAmt2 + _amt2));
	%>
		<td class="amtTd tdRowSplit" id="subject_<%=b2id %>_<%=i %>" _dbAmt="<%=df.format(_amt2) %>" ><%=df.format(_amt2) %></td>
	<%}%>
		<td class="amtTd tdRowSplit" id="subject_<%=b2id %>_ALL" _dbAmt="<%=df.format(sumAmt2) %>" ><%=df.format(sumAmt2) %></td>
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
		String b3name = _b3Hm.get("b3name");
		String b3id = _b3Hm.get("b3id");
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
	    double _sum_sjYsze = 0.00;
%>
	<tr>
		<td class="tdRowSplit" style="text-align: left;vertical-align: text-top;">
			<span style="margin-left: 15px;font-weight: bold;"><%=b3name %></span>
			<%=b3ArchiveHtml %>
		</td>
		<td class="tdRowSplit"><%=SystemEnv.getHtmlLabelName(628,user.getLanguage()) %></td><!-- 实际 -->
	<%for(int i=1;i<=qCount;i++){

		String budgetperiodslist = (String)periodsidKeyList.get(i-1);
		String startdate = (String)budgetPeriodMap.get(budgetperiodslist+"_startdate");
		String enddate = (String)budgetPeriodMap.get(budgetperiodslist+"_enddate");
		
		double _yfsys = 0.00;
		
		String sql3 = "select sum(a.amount) sum_amount  \n" +
				" from FnaExpenseInfo a \n" +
				" where a.status = 1 \n";
		if("crm".equals(organizationtype)){
			sql3 += " and a.relatedcrm = "+Util.getIntValue(organizationid)+" \n";
		}
		if("prj".equals(organizationtype)){
			sql3 += " and a.relatedprj = "+Util.getIntValue(organizationid)+" \n";
		}
		sql3 += " and a.subject = "+b3id+" \n" +
				" and (a.occurdate >= '"+startdate+"' and a.occurdate <= '"+enddate+"')";
		rs3.executeSql(sql3);
		if(rs3.next()){
			_yfsys = Util.getDoubleValue(rs3.getString("sum_amount"), 0.00);
		}
        
		_sum_yfsys = Util.getDoubleValue(df.format(_sum_yfsys + _yfsys));
	%>
		<td class="amtTd tdRowSplit"><%= df.format(_yfsys) %></td>
	<%}
	%>
		<td class="amtTd tdRowSplit"><%= df.format(_sum_yfsys) %></td>
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
	RCMenu += "{"+SystemEnv.getHtmlLabelName(1258,user.getLanguage())+",javascript:gotoPage(-1),_self} ";//上一�?
	RCMenuHeight += RCMenuHeightStep;
}
if(pageIndex < maxPageIndex){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(1259,user.getLanguage())+",javascript:gotoPage(1),_self} ";//下一�?
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
	window.location.href = "/fna/report/expense/Rpt1FnaBudgetViewData.jsp?<%=commonPara %>&pageIndex="+_pageIndex;
}

function jumpPage(_jumpPageIndex, _pageSize){
	if(_pageSize==null){
		_pageSize = "<%=pageSize %>";
	}
	window.location.href = "/fna/report/expense/Rpt1FnaBudgetViewData.jsp?<%=commonPara %>&pageIndex="+_jumpPageIndex+"&pageSize="+_pageSize;
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