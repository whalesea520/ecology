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
boolean canView = HrmUserVarify.checkUserRight("BudgetAuthorityRule:readOnly", user);//预算编制只读权限
boolean canEdit = (HrmUserVarify.checkUserRight("FnaBudget:View", user) || 
		HrmUserVarify.checkUserRight("FnaBudgetEdit:Edit", user) || 
		HrmUserVarify.checkUserRight("BudgetAuthorityRule:edit", user));//财务预算维护、预算编制权限
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

String organizationtype = Util.null2String(request.getParameter("organizationtype"));//组织类型
String organizationid = Util.null2String(request.getParameter("organizationid"));//组织ID
String[] historyRevisionArray = request.getParameterValues("historyRevision");//要对比的两个预算版本id
int budgetinfoid_1 = Util.getIntValue(request.getParameter("budgetinfoid_1"), -1);
int budgetinfoid_2 = Util.getIntValue(request.getParameter("budgetinfoid_2"), -1);

String tabFeeperiod = Util.null2String(request.getParameter("tabFeeperiod")).trim();//打开预算周期tab页类型
if("".equals(tabFeeperiod)){
	tabFeeperiod = "M";
}

String guid1 = Util.null2String(request.getParameter("guid1")).trim();

String nameQuery = Util.null2String((String)request.getSession().getAttribute("FnaBudgetCompareInner.jsp_nameQuery_"+guid1));

int qCount = 0;
int feeperiod = 0;

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

String commonPara = "organizationtype="+organizationtype+"&organizationid="+organizationid+"&budgetinfoid_1="+budgetinfoid_1+"&budgetinfoid_2="+budgetinfoid_2+
	"&tabFeeperiod="+tabFeeperiod+"&guid1="+guid1;

boolean fnaBudgetViewFlag = false;
if("0".equals(organizationtype)){
	if(FnaBudgetLeftRuleSet.isAllowCmp(user.getUID())){
		fnaBudgetViewFlag = true;
	}
}else if("1".equals(organizationtype)){
	List<String> allowOrgId_list = new ArrayList<String>();
	boolean allowOrgId = FnaBudgetLeftRuleSet.getAllowSubCmpId(user.getUID(), allowOrgId_list);
	if(allowOrgId || allowOrgId_list.contains(organizationid)){
		fnaBudgetViewFlag = true;
	}
}else if("2".equals(organizationtype)){
	List<String> allowOrgId_list = new ArrayList<String>();
	boolean allowOrgId = FnaBudgetLeftRuleSet.getAllowDepId(user.getUID(), allowOrgId_list);
	if(allowOrgId || allowOrgId_list.contains(organizationid)){
		fnaBudgetViewFlag = true;
	}
}else if("3".equals(organizationtype)){
	List<String> __orgId_list = new ArrayList<String>();
	__orgId_list.add(organizationid);
	List<String> allowOrgId_list = new ArrayList<String>();
	boolean allowOrgId = FnaBudgetLeftRuleSet.getAllowHrmId(user.getUID(), null, null, __orgId_list, allowOrgId_list);
	if(allowOrgId || allowOrgId_list.contains(organizationid)){
		fnaBudgetViewFlag = true;
	}
}else if((FnaCostCenter.ORGANIZATION_TYPE+"").equals(organizationtype)){
	List<String> allowOrgId_list = new ArrayList<String>();
	boolean allowOrgId = FnaBudgetLeftRuleSet.getAllowFccId(user.getUID(), allowOrgId_list);
	if(allowOrgId || allowOrgId_list.contains(organizationid)){
		fnaBudgetViewFlag = true;
	}
}
//如果没有传入具体哪个预算机构，或者有传入具体哪个预算机构，并判断为不允许允许查看的，则提示无权限
if(!fnaBudgetViewFlag){
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}

DecimalFormat df = new DecimalFormat("####################################################0.00");
FnaSplitPageTransmethod fnaSplitPageTransmethod = new FnaSplitPageTransmethod();
FnaBudgetInfoComInfo fnaBudgetInfoComInfo = new FnaBudgetInfoComInfo();
BudgetHandler budgetHandler = new BudgetHandler();



int revision1 = -1;
int status1 = -1;
double sum_budgetaccount1 = 0.00;
String sql = "select a.revision, a.status, SUM (b.budgetaccount) sum_budgetaccount "+
		" from FnaBudgetInfo a "+
		" JOIN FnaBudgetInfoDetail b ON a.id = b.budgetinfoid "+ 
		" where a.id = "+budgetinfoid_1+" "+
		" GROUP BY a.revision, a.status ";
rs.executeSql(sql);
if(rs.next()){
	revision1 = rs.getInt("revision");
	status1 = rs.getInt("status");
	sum_budgetaccount1 = Util.getDoubleValue(df.format(Util.getDoubleValue(rs.getString("sum_budgetaccount"))), 0.00);
}
String revision1Name = "V"+revision1;
if(revision1==0){
	revision1Name=SystemEnv.getHtmlLabelName(220,user.getLanguage());//草稿
}
if(status1==3){
	revision1Name=SystemEnv.getHtmlLabelName(2242,user.getLanguage());//待审批
}

int revision2 = -1;
int status2 = -1;
double sum_budgetaccount2 = 0.00;
sql = "select a.revision, a.status, SUM (b.budgetaccount) sum_budgetaccount "+
	" from FnaBudgetInfo a "+
	" JOIN FnaBudgetInfoDetail b ON a.id = b.budgetinfoid "+ 
	" where a.id = "+budgetinfoid_2+" "+
	" GROUP BY a.revision, a.status ";
rs.executeSql(sql);
if(rs.next()){
	revision2 = rs.getInt("revision");
	status2 = rs.getInt("status");
	sum_budgetaccount2 = Util.getDoubleValue(df.format(Util.getDoubleValue(rs.getString("sum_budgetaccount"))), 0.00);
}
String revision2Name = "V"+revision2;
if(revision2==0){
	revision2Name=SystemEnv.getHtmlLabelName(220,user.getLanguage());//草稿
}
if(status2==3){
	revision2Name=SystemEnv.getHtmlLabelName(2242,user.getLanguage());//待审批
}


BudgetfeeTypeComInfo budgetfeeTypeComInfo = new BudgetfeeTypeComInfo();

FnaSystemSetComInfo fnaSystemSetComInfo = new FnaSystemSetComInfo();
boolean showHiddenSubject = 1==Util.getIntValue(fnaSystemSetComInfo.get_showHiddenSubject());
boolean subjectFilter = 1==Util.getIntValue(fnaSystemSetComInfo.get_subjectFilter());
String separator = Util.null2String(fnaSystemSetComInfo.get_separator());

if("".equals(separator)){
	separator = "/";
}

String _wImg = "<img alt=\"\" src=\"\" style=\"width: 80px; height: 0px;\" />";

%>

<%@page import="weaver.fna.domain.FnaBudgetfeeType"%><html>
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
if(!"".equals(nameQuery)){
	sql_rs_split.append(" and (b3.name like '%"+StringEscapeUtils.escapeSql(nameQuery)+"%') \n");
}
if(!showHiddenSubject){
	sql_rs_split.append(" and (b3.archive is null or b3.archive=0) ");
}
sql_rs_split.append(" and b3.feeperiod = "+feeperiod+" and b3.isEditFeeType = 1 ");

String backFields = " t1.* ";
String sqlFrom = " from ("+sql_rs_split.toString()+") t1 ";
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
new BaseBean().writeLog(sql1.toString());
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
	
	new BaseBean().writeLog("b3Archive="+b3Archive);
	
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

//bb.writeLog("5 FnaBudgetViewData.jsp>>>"+SDF.format(Calendar.getInstance().getTime()));
//得到指定范围内所有三级科目整期预算
HashMap<String, Map> b3BudgetTypeAmountHm_1 = fnaBudgetInfoComInfo.getBudgetAmountBySubjects_isEditFeeType(budgetinfoid_1, currentPage_isEditFeeTypeIds.toString());
HashMap<String, Map> b3BudgetTypeAmountHm_2 = fnaBudgetInfoComInfo.getBudgetAmountBySubjects_isEditFeeType(budgetinfoid_2, currentPage_isEditFeeTypeIds.toString());

%>

<input id="organizationtype" name="organizationtype" value="<%=organizationtype%>" type="hidden" />
<input id="organizationid" name="organizationid" value="<%=organizationid%>" type="hidden" />
<input id="budgetinfoid_1" name="budgetinfoid_1" value="<%=budgetinfoid_1%>" type="hidden" />
<input id="budgetinfoid_2" name="budgetinfoid_2" value="<%=budgetinfoid_2%>" type="hidden" />
<input id="tabFeeperiod" name="tabFeeperiod" value="<%=tabFeeperiod%>" type="hidden" />
<input id="qCount" name="tabFeeperiod" value="<%=qCount%>" type="hidden" />
<input id="pageIndex" name="pageIndex" value="<%=pageIndex%>" type="hidden" />
<input id="pageSize" name="pageSize" value="<%=pageSize%>" type="hidden" />
<input id="guid1" name="guid1" value="<%=guid1%>" type="hidden" />

<table class="tb" style="width: 100%;" cellpadding="5" cellspacing="0">
	<tr style="height: 0px; background-color: #F2F2F2; border: 0px; margin: 0px; padding: 0px; color: #F2F2F2; font-size: 0px; visibility: hidden;" height="0px">
		<th style="height: 0px; font-size: 0px;" height="0px"><%=_wImg %></th>
		<th style="height: 0px; font-size: 0px;" height="0px"><%=_wImg %></th>
	<%for(int i=1;i<=qCount;i++){%>
		<th style="height: 0px; font-size: 0px;" height="0px"><%=_wImg %></th>
	<%}%>
		<th style="height: 0px; font-size: 0px;" height="0px"><%=_wImg %></th>
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
List<String> b2id_distinct_list = new ArrayList<String>();
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
new BaseBean().writeLog(sql2.toString());
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
%>
	<tr>
		<td class="tdRowSplit" colspan="15">
			<span style="margin-left: 15px;">
				<span style="font-weight: bold;"><%=b2name %></span>
			</span>
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
		String b3name = _b3Hm.get("b3name");
		String b3id = _b3Hm.get("b3id");
		boolean b3Archive = 1==Util.getIntValue(_b3Hm.get("b3Archive"), 0);
		String b3Alertvalue = _b3Hm.get("b3Alertvalue");
	
		String colorRed2 = "";
		
		String b3ArchiveHtml = "";
		if(b3Archive){
			b3ArchiveHtml = "<br /><span style=\"margin-left: 15px;font-weight: bold;color: red;\">("+SystemEnv.getHtmlLabelName(22151,user.getLanguage())+")</span>";//封存
		}

		//得到某科目整期预算
		Map budgetTypeAmount1 = b3BudgetTypeAmountHm_1.get(b3id);
		if(budgetTypeAmount1==null){
			budgetTypeAmount1 = new HashMap();
		}
		Map budgetTypeAmount2 = b3BudgetTypeAmountHm_2.get(b3id);
		if(budgetTypeAmount2==null){
			budgetTypeAmount2 = new HashMap();
		}

	    double _sum_ysze1 = 0.00;
	    double _sum_ysze2 = 0.00;
%>
	<tr>
		<td class="tdRowSplit" rowspan="3" style="text-align: left;vertical-align: text-top;<%=border_bottom_color %>">
			<span style="margin-left: 15px;font-weight: bold;"><%=FnaCommon.escapeHtml(b3name) %></span>
			<%=b3ArchiveHtml %>
			<input id="b2id_<%=b2id %>" name="b2id" value="<%=b2id%>" type="hidden" />
			<input id="b3id_<%=b3id %>" name="b3id" value="<%=b3id%>" type="hidden" />
		</td>
		<td><%=SystemEnv.getHtmlLabelName(18501,user.getLanguage())%>(<%=revision1Name %>)</td><!-- 预算总额 V1 -->
	<%for(int i=1;i<=qCount;i++){
		//预算总额
		double _ysze1 = Util.getDoubleValue((String)budgetTypeAmount1.get(i+""), 0.00);
		//预算总额
		double _ysze2 = Util.getDoubleValue((String)budgetTypeAmount2.get(i+""), 0.00);

		_sum_ysze1 = Util.getDoubleValue(df.format(_sum_ysze1 + _ysze1));

		colorRed2 = "";
		if(_ysze2 != _ysze1){
			colorRed2 = "background-color: yellow;";
		}
	%>
		<td class="amtTd" style="<%=colorRed2 %>"><%= fnaSplitPageTransmethod.fmtAmountQuartile(_ysze1) %></td>
	<%}
	%>
		<td class="amtTd"><%= fnaSplitPageTransmethod.fmtAmountQuartile(_sum_ysze1) %></td>
	</tr>
	<tr>
		<td><%=SystemEnv.getHtmlLabelName(18501,user.getLanguage())%>(<%=revision2Name %>)</td><!-- 预算总额V2 -->
	<%for(int i=1;i<=qCount;i++){
		//预算总额
		double _ysze1 = Util.getDoubleValue((String)budgetTypeAmount1.get(i+""), 0.00);
		//预算总额
		double _ysze2 = Util.getDoubleValue((String)budgetTypeAmount2.get(i+""), 0.00);

		_sum_ysze2 = Util.getDoubleValue(df.format(_sum_ysze2 + _ysze2));

		colorRed2 = "";
		if(_ysze2 != _ysze1){
			colorRed2 = "background-color: yellow;";
		}
	%>
		<td class="amtTd" style="<%=colorRed2 %>"><%= fnaSplitPageTransmethod.fmtAmountQuartile(_ysze2) %></td>
	<%}
	%>
		<td class="amtTd"><%= fnaSplitPageTransmethod.fmtAmountQuartile(_sum_ysze2) %></td>
	</tr>
	<tr>
		<td class="tdRowSplit" style="<%=border_bottom_color %>"><%=SystemEnv.getHtmlLabelName(18751,user.getLanguage())%></td><!-- 变更差额 -->
	<%for(int i=1;i<=qCount;i++){
		//预算总额
		double _ysze1 = Util.getDoubleValue((String)budgetTypeAmount1.get(i+""), 0.00);
		double _ysze2 = Util.getDoubleValue((String)budgetTypeAmount2.get(i+""), 0.00);
		double _ysze_diff = _ysze1 - _ysze2;

		colorRed2 = "";
		if(_ysze_diff > 0){
			colorRed2 = "color:blue;";
		}else if(_ysze_diff < 0){
			colorRed2 = "color:red;";
		}
	%>
		<td class="amtTd tdRowSplit" style="<%=colorRed2 %><%=border_bottom_color %>"><%= fnaSplitPageTransmethod.fmtAmountQuartile(_ysze_diff) %></td>
	<%}
	double _sum_ysze_diff = _sum_ysze1 - _sum_ysze2;

	colorRed2 = "";
	if(_sum_ysze_diff > 0){
		colorRed2 = "color:blue;";
	}else if(_sum_ysze_diff < 0){
		colorRed2 = "color:red;";
	}
	%>
		<td class="amtTd tdRowSplit" style="<%=colorRed2 %><%=border_bottom_color %>"><%= fnaSplitPageTransmethod.fmtAmountQuartile(_sum_ysze_diff) %></td>
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
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>


<!-- advanced search -->
<div class="advancedSearchDiv" id="advancedSearchDiv" style="display: none;">
</div>

<script language="javascript">
function gotoPage(_addPageIndex){
	var _pageIndex = jQuery("#pageIndex").val();
	_pageIndex = fnaRound2(_pageIndex, 0) + _addPageIndex;
	window.location.href = "/fna/budget/FnaBudgetCompareInner.jsp?<%=commonPara %>&pageIndex="+_pageIndex;
}

function jumpPage(_jumpPageIndex, _pageSize){
	if(_pageSize==null){
		_pageSize = "<%=pageSize %>";
	}
	window.location.href = "/fna/budget/FnaBudgetCompareInner.jsp?<%=commonPara %>&pageIndex="+_jumpPageIndex+"&pageSize="+_pageSize;
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