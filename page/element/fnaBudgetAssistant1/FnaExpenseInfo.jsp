<%@page import="weaver.conn.RecordSet"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.file.Prop" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.general.BaseBean" %>
<%@ page import="weaver.systeminfo.SystemEnv" %>
<%@page import="org.json.JSONObject"%>
<%@page import="org.apache.commons.lang.StringEscapeUtils"%>
<%@page import="weaver.fna.general.FnaCommon"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<%@page import="weaver.fna.maintenance.FnaCostCenter"%>
<%@page import="weaver.fna.budget.BudgetHandler"%>
<%@page import="weaver.fna.budget.BudgetPeriod"%>
<%@page import="weaver.hrm.resource.ResourceComInfo"%>
<%@page import="weaver.hrm.company.DepartmentComInfo"%>
<%@page import="weaver.hrm.company.SubCompanyComInfo"%>
<%@page import="weaver.general.TimeUtil"%>
<%@page import="weaver.fna.maintenance.BudgetfeeTypeComInfo"%>
<%@page import="weaver.fna.maintenance.FnaBudgetInfoComInfo"%>
<%@page import="weaver.fna.budget.Expense"%>
<%@page import="weaver.fna.maintenance.FnaBudgetControl"%>
<%@page import="weaver.systeminfo.label.LabelComInfo"%><html>
	<head>
	    <link href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
	    <script type="text/javascript" src="/js/ecology8/jquery_wev8.js"></script>
		<script type="text/javascript" src="/fna/js/e8Common_wev8.js?r=9"></script>
		<script type="text/javascript" src="/page/element/fnaBudgetAssistant1/js/highcharts_wev8.js"></script>
		<script type="text/javascript" src="/page/element/fnaBudgetAssistant1/js/exporting_wev8.js"></script>
		<script type="text/javascript" src="/page/element/fnaBudgetAssistant1/js/no-data-to-display_wev8.js"></script>
		<style type="text/css">
			.tdheader1{
				color: #707070;
				background-color:#D7D7D7;
			}
			.trheader1{
				background-color:#F1F1F1;
			}
			td{
				text-align:center;
			}
			img{
				cursor:pointer;
			}
		</style>
	</head>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = "";
String needfav = "1";
String needhelp = "";

User user = HrmUserVarify.getUser(request , response);
if(user==null){
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}

DecimalFormat df = new DecimalFormat("#######################################0.00");
FnaBudgetInfoComInfo fnaBudgetInfoComInfo = new FnaBudgetInfoComInfo();

String _guid1 = Util.null2String(request.getParameter("_guid1")).trim();
String orgTypeName = Util.null2String(request.getParameter("orgTypeName")).trim();
String fysqlc = Util.null2String(request.getParameter("fysqlc")).trim();
String poststr = Util.null2String(request.getParameter("poststr")).trim();

String _startdate_qry = Util.null2String(request.getParameter("_startdate_qry")).trim();
String _enddate_qry = Util.null2String(request.getParameter("_enddate_qry")).trim();
String orgId_qry = Util.null2String(request.getParameter("_orgId_qry")).trim();
int allSubject_qry = Util.getIntValue(request.getParameter("_allSubject_qry"), 0);//0：当前流程科目；1：全部科目；

String window_location_href = "/page/element/fnaBudgetAssistant1/FnaExpenseInfo.jsp?_guid1="+_guid1+
		"&orgTypeName="+orgTypeName+"&fysqlc="+fysqlc+"&poststr="+poststr;

Map<String, String> dataMap = (Map<String, String>)request.getSession().getAttribute("fnaBudgetAssistant1_View.jsp_dataMap_"+_guid1);
int creater = Util.getIntValue((String)request.getSession().getAttribute("fnaBudgetAssistant1_View.jsp_creater_"+_guid1));
int requestId = Util.getIntValue((String)request.getSession().getAttribute("fnaBudgetAssistant1_View.jsp_requestId_"+_guid1));
int workflowid = Util.getIntValue((String)request.getSession().getAttribute("fnaBudgetAssistant1_View.jsp_workflowid_"+_guid1));
String fnaWfType = (String)request.getSession().getAttribute("fnaBudgetAssistant1_View.jsp_fnaWfType_"+_guid1);

String currentDate = (String)request.getSession().getAttribute("fnaBudgetAssistant1_View.jsp_currentDate_"+_guid1);
String currentYYYY = (String)request.getSession().getAttribute("fnaBudgetAssistant1_View.jsp_currentYYYY_"+_guid1);
String currentMM = (String)request.getSession().getAttribute("fnaBudgetAssistant1_View.jsp_currentMM_"+_guid1);
String currentDD = (String)request.getSession().getAttribute("fnaBudgetAssistant1_View.jsp_currentDD_"+_guid1);
String currentLastYYYY = (String)request.getSession().getAttribute("fnaBudgetAssistant1_View.jsp_currentLastYYYY_"+_guid1);
String currentLastMM = (String)request.getSession().getAttribute("fnaBudgetAssistant1_View.jsp_currentLastMM_"+_guid1);

int formid = Util.getIntValue(dataMap.get("formid"), 0);
int formidABS = Math.abs(formid);
String fieldIdSubject_fieldName = Util.null2String(dataMap.get("fieldIdSubject_fieldName")).trim();//报销流程的报销明细的科目数据库字段
String fieldIdSubject_isDtl = Util.null2String(dataMap.get("fieldIdSubject_fieldId_isDtl"));

//out.println("fnaWfType="+fnaWfType+"<br />");
if(!"fnaFeeWf".equals(fnaWfType)){
	return;
}

if(requestId<=0&&workflowid<=0){
	return ;
}

if(creater<=0){
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}

ResourceComInfo rci = new ResourceComInfo();
DepartmentComInfo dci = new DepartmentComInfo();
SubCompanyComInfo scci = new SubCompanyComInfo();
BudgetfeeTypeComInfo bftci = new BudgetfeeTypeComInfo();

RecordSet rs1 = new RecordSet();
String isnull = "ISNULL";
if("oracle".equals(rs1.getDBType())){
	isnull = "NVL";
}
String sql = "";

int enableDispalyAll=0;
String separator ="";
rs1.executeSql("select enableDispalyAll,separator from FnaSystemSet");
if(rs1.next()){
	enableDispalyAll = rs1.getInt("enableDispalyAll");
	separator = Util.null2String(rs1.getString("separator"));
}

List<String> subjectList = new ArrayList<String>();
List<String> subjectNameList = new ArrayList<String>();
List<String> orgTypeList = new ArrayList<String>();
List<String> orgTypeJsValueList = new ArrayList<String>();
List<String> orgIdList = new ArrayList<String>();
List<String> orgNameList = new ArrayList<String>();
List<String> budgetperiodList = new ArrayList<String>();
String startdate_firstRow = "";
String startdate = "";
String enddate = "";

String[] fnainfo = poststr.split("\\|");
int rowsum = fnainfo.length;
HashMap<String, HashMap<String, String>> reqFnaExpenseDataMap = FnaCommon.qryFnaExpenseInfoAllRowRecordHm(requestId);
for(int i=0;i<rowsum;i++) {
	String[] tempStr = fnainfo[i].split(",");//科目+报销类型+报销单位+报销日期+实报金额
	//报销单位
	int organizationid = 0;
	if(tempStr.length >= 3){
		organizationid = Util.getIntValue(tempStr[2],0);
	}
	//报销类型 个人部门分部  012-》321
    int orgTypeJsValue = -1;
    if(tempStr.length >= 2){
    	orgTypeJsValue = Util.getIntValue(tempStr[1],-1);
    }
    int organizationtype = 0;
    if(orgTypeJsValue==0){//个人
    	organizationtype=3;
    }else if(orgTypeJsValue==1){//部门
    	organizationtype=2;
    }else if(orgTypeJsValue==3){//成本中心
    	organizationtype=FnaCostCenter.ORGANIZATION_TYPE;
    }else{//分部
    	organizationtype=1;
    }
	//科目
	String subject = "";
	if(tempStr.length >= 1){
		subject = Util.null2String(tempStr[0]);
	}
    //报销日期
	String _budgetperiod = "";
	if(tempStr.length >= 4){
		_budgetperiod = Util.null2String(tempStr[3]);
	}
	//申报金额
	double applyamount= 0.00;
	if(tempStr.length >= 5){
		applyamount= Util.getDoubleValue(tempStr[4],0);
	}
	
	int dtl_id = 0;
	if(tempStr.length >= 6){
		dtl_id = Util.getIntValue(tempStr[5],0);
	}
	
	if("hrm".equals(orgTypeName) && organizationtype!=3){//个人
		continue;
	}else if("dep".equals(orgTypeName) && organizationtype!=2){//部门
		continue;
	}else if("subCmp".equals(orgTypeName) && organizationtype!=1){//分部
		continue;
	}else if("fcc".equals(orgTypeName) && organizationtype!=FnaCostCenter.ORGANIZATION_TYPE){//成本中心
		continue;
	}
	
	if(organizationtype<=0 || organizationid<=0 || Util.getIntValue(subject, 0)<=0){
		continue;
	}

	String budgetperiod = _budgetperiod;
    HashMap<String, String> occurdateHm = FnaCommon.getBudgetAutoMoveAfterOccurDate(budgetperiod, dtl_id, requestId, reqFnaExpenseDataMap.get(dtl_id+""));
    String date1 = occurdateHm.get(FnaCommon.BudgetAutoMoveAfterOccurDate1);
    String date3 = occurdateHm.get(FnaCommon.BudgetAutoMoveAfterOccurDate3);
    String date4 = occurdateHm.get(FnaCommon.BudgetAutoMoveAfterOccurDate4);
    int isBudgetAutoMove = Util.getIntValue(occurdateHm.get(FnaCommon.IsBudgetAutoMove));
    if(isBudgetAutoMove==1 && !"".equals(date1) && !"".equals(date4)){
    	if(date1.equals(date4)){
    		budgetperiod = date3;
    	}else{
    		budgetperiod = date1;
    	}
    }
	
	if("".equals(budgetperiod)){
		continue;
	}
	
	
	
	
    if(!subjectList.contains(subject+"_"+organizationtype+"_"+organizationid)){
    	String feeperiod = bftci.getBudgetfeeTypeperiod(subject+"");
    	String fullName = "";
    	if(enableDispalyAll==1){
        	fullName = bftci.getSubjectFullName(subject+"", separator);
    	}else{
    		fullName = bftci.getBudgetfeeTypename(subject+"");
    	}
    	subjectList.add(subject+"_"+organizationtype+"_"+organizationid+"_"+feeperiod);
    	subjectNameList.add(fullName);
    }
    if(!orgIdList.contains(organizationid+"")){
    	orgIdList.add(organizationid+"");
    	orgTypeList.add(organizationtype+"");
    	orgTypeJsValueList.add(orgTypeJsValue+"");
    	
    	if("hrm".equals(orgTypeName)){//个人
    		orgNameList.add(rci.getLastname(organizationid+""));
    	}else if("dep".equals(orgTypeName)){//部门
    		orgNameList.add(dci.getDepartmentName(organizationid+""));
    	}else if("subCmp".equals(orgTypeName)){//分部
    		orgNameList.add(scci.getSubCompanyname(organizationid+""));
    	}else if("fcc".equals(orgTypeName)){//成本中心
    		String orgName = "";
    		rs1.executeQuery("select name from FnaCostCenter where id=?", organizationid);
    		if(rs1.next()){
    			orgName = Util.null2String(rs1.getString("name")).trim();
    		}
    		orgNameList.add(orgName);
    	}else{
    		orgNameList.add("");
    	}

    	if("".equals(orgId_qry)){
    		orgId_qry = organizationid+"";
    	}
    }

	if("".equals(startdate) && !"".equals(_startdate_qry)){
		startdate = _startdate_qry;
    }
	if("".equals(enddate) && !"".equals(_enddate_qry)){
		enddate = _enddate_qry;
    }

	BudgetPeriod bp = BudgetHandler.getBudgetPeriod(budgetperiod, Integer.parseInt(subject));
	if(bp!=null){
		int budgetperiods = bp.getPeriod();
		int budgetperiodslist = bp.getPeriodlist();
		String startdateByBp = bp.getStartdate();
		String enddateByBp = bp.getEnddate();
	    if(!budgetperiodList.contains(budgetperiods+"_"+budgetperiodslist+"_"+startdateByBp)){
	    	budgetperiodList.add(budgetperiods+"_"+budgetperiodslist+"_"+startdateByBp);
	    }
		if("".equals(startdate)){
			startdate = startdateByBp;
			enddate = enddateByBp;
		}
	}
	
	if("".equals(startdate_firstRow)){
		startdate_firstRow = budgetperiod;
	}
}
//new BaseBean().writeLog("1>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
	
if("".equals(startdate_firstRow)){
	startdate_firstRow = TimeUtil.getCurrentDateString();
}

if("".equals(startdate) || "".equals(enddate)){
	rs1.executeSql("select * from FnaYearsPeriods "+
			" where startdate <= '"+StringEscapeUtils.escapeSql(startdate_firstRow)+"' and enddate >= '"+StringEscapeUtils.escapeSql(startdate_firstRow)+"'");
	if(rs1.next()){
		if("".equals(startdate)){
			startdate = Util.null2String(rs1.getString("startdate")).trim();
		}
		if("".equals(enddate)){
			enddate = Util.null2String(rs1.getString("enddate")).trim();
		}
	}
}
//new BaseBean().writeLog("2>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");

if(!"".equals(startdate) && !"".equals(enddate) && subjectList.size()>0){
	String[] _array = subjectList.get(0).split("_");
	String subject = Util.null2String(_array[0]).trim();

	int period_startdate = 0;
	int period_enddate = 0;

	BudgetPeriod bp_startdate = BudgetHandler.getBudgetPeriod(startdate, Integer.parseInt(subject));
	if(bp_startdate!=null){
		period_startdate = bp_startdate.getPeriod();
	}
	BudgetPeriod bp_enddate = BudgetHandler.getBudgetPeriod(enddate, Integer.parseInt(subject));
	if(bp_enddate!=null){
		period_enddate = bp_enddate.getPeriod();
	}
	
	if(period_startdate != period_enddate){
		enddate = startdate;
	}
}

int budgetperiods_startdate = 0;
if(!"".equals(startdate)){
	rs1.executeSql("select * from FnaYearsPeriods "+
			" where startdate <= '"+StringEscapeUtils.escapeSql(startdate)+"' and enddate >= '"+StringEscapeUtils.escapeSql(startdate)+"'");
	if(rs1.next()){
		budgetperiods_startdate = rs1.getInt("id");
	}
}
//new BaseBean().writeLog("3>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");


String td1Title = "/"+SystemEnv.getHtmlLabelNames("585",user.getLanguage());
if("hrm".equals(orgTypeName)){//个人
	td1Title = SystemEnv.getHtmlLabelNames("6087",user.getLanguage())+td1Title;
}else if("dep".equals(orgTypeName)){//部门
	td1Title = SystemEnv.getHtmlLabelNames("124",user.getLanguage())+td1Title;
}else if("subCmp".equals(orgTypeName)){//分部
	td1Title = SystemEnv.getHtmlLabelNames("141",user.getLanguage())+td1Title;
}else if("fcc".equals(orgTypeName)){//成本中心
	td1Title = SystemEnv.getHtmlLabelNames("515",user.getLanguage())+td1Title;
}
//new BaseBean().writeLog("4>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");

String currentSelectOrgName = "";
%>
<body>
<div id="tableDiv" style="height:243px;overflow-x:auto;overflow-y:auto">
<table style="height:auto;width:100%;" cellspacing="0">
	<colgroup>
		<col width="5px;">
		<col width="20%">
		<col width="20%">
		<col width="20%">
		<col width="20%">
		<col width="*">
	</colgroup>
	<tbody>
		<tr id="tableDiv_tr_qry">
			<td colspan="6" style="text-align: left;">
				<select id="orgId_qry" name="orgId_qry" onchange="orgId_qry_onchange();">
				<%
				for(int i=0;i<orgIdList.size();i++){
					String orgId = orgIdList.get(i);
					String orgName = orgNameList.get(i);
					if("".equals(currentSelectOrgName)){
						currentSelectOrgName = orgName;
					}
					String selected = "";
					if(orgId_qry.equals(orgId)){
						selected = "selected=\"selected\"";
						currentSelectOrgName = orgName;
					}
				%>
					<option value="<%=orgId %>" <%=selected %>><%=FnaCommon.escapeHtml(orgName) %></option>
				<%
				}
				%>
				</select>
				&nbsp;
				<button class="Calendar" type="button" id="startdateBtn" onclick="onShowDate_FnaExpenseInfo(startdateSpan, startdate)"></button>
				<span id="startdateSpan"><%=startdate %></span>
				<input class="inputstyle" type="hidden" name="startdate" id="startdate" value="<%=startdate %>" />
				~ 
				<button class="Calendar" type="button" id="enddateBtn" onclick="onShowDate_FnaExpenseInfo(enddateSpan, enddate)"></button>
				<span id="enddateSpan"><%=enddate %></span>
				<input class="inputstyle" type="hidden" name="enddate" id="enddate" value="<%=enddate %>" />
				&nbsp;
				<select id="allSubject_qry" name="allSubject_qry" onchange="allSubject_qry_onchange();">
					<option value="0" <%=allSubject_qry==0?"selected=\"selected\"":"" %>><%=SystemEnv.getHtmlLabelNames("127722",user.getLanguage()) %></option>
				</select>
			</td>
		</tr>
<%
int allSubject_qry_0_budgetinfoid = 0;
StringBuffer javaScriptStr = new StringBuffer();
double ys_hj = 0.0;
double sq_hj = 0.0;
double sj_hj = 0.0;

if(allSubject_qry==0){//当前流程科目
%>
		<tr style='background-color:#E7F3FC;padding:0;height:27px;font-weight: bolder;'>
			<td style="text-align: right;">&nbsp;</td>
			<td><%=td1Title %></td><!-- 部门/科目 -->
			<td><%=SystemEnv.getHtmlLabelNames("386",user.getLanguage()) %></td><!-- 科目 -->
			<td><%=SystemEnv.getHtmlLabelNames("129",user.getLanguage()) %></td><!-- 申请 -->
			<td><%=SystemEnv.getHtmlLabelNames("628",user.getLanguage()) %></td><!-- 实际 -->
			<td><%=SystemEnv.getHtmlLabelNames("127732",user.getLanguage()) %></td><!-- 是否超额度 -->
		</tr>
<%
	int subjectListLen = subjectList.size();
	int orgIdListLen = orgIdList.size();
	for(int i=0;i<orgIdListLen;i++){
		String orgTypeJsValue = orgTypeJsValueList.get(i);
		String orgType = orgTypeList.get(i);
		String orgId = orgIdList.get(i);

		//new BaseBean().writeLog("orgId_qry="+orgId_qry+";orgId="+orgId);
		if(!orgId_qry.equals(orgId)){
			continue;
		}
		
		int budgetinfoid = 0;
		rs1.executeQuery("select a.id from FnaBudgetInfo a "+
				" where a.status=1 and a.budgetperiods=? and a.organizationtype=? and a.budgetorganizationid=?", 
				budgetperiods_startdate, Util.getIntValue(orgType), Util.getIntValue(orgId));
		if(rs1.next()){
			budgetinfoid = rs1.getInt("id");
		}
		
		out.println("<tr id=\"tableDiv_tr_"+orgId+"\" style='height:18px;font-weight: bolder;'>");
		out.println("	<td style=\"text-align: right;\" onclick=\"_toggle_FnaExpenseInfo('"+orgId+"');\">");
		out.println(		"<span id=\"tableDiv_tdPointer_"+orgId+"\" style=\"cursor: pointer;\">-</span>");
		out.println("	</td>");
		out.println("	<td>");
		out.println(		FnaCommon.escapeHtml(orgNameList.get(i)));//已发生费用
		out.println("	</td>");
		out.println("	<td>");
		out.println(		"<span id=\"ys_"+orgId+"\"></span>");
		out.println("	</td>");
		out.println("	<td>");
		out.println(		"<span id=\"sq_"+orgId+"\"></span>");
		out.println("	</td>");
		out.println("	<td>");
		out.println(		"<span id=\"sj_"+orgId+"\"></span>");
		out.println("	</td>");
		out.println("	<td>");
		out.println(		"<span id=\"sfcb_"+orgId+"\"></span>");
		out.println("	</td>");
		out.println("</tr>");


		List<String> isEditFeeTypeId_list = new ArrayList<String>();
		int subjectIdsLevel3_cnt = 0;
		StringBuffer subjectIdsLevel3 = new StringBuffer();
		for(int j=0;j<subjectListLen;j++){
			String[] _array = subjectList.get(j).split("_");
			String subject = Util.null2String(_array[0]).trim();
			String isEditFeeTypeId_subject = bftci.getIsEditFeeTypeId(subject);
			String _orgType = Util.null2String(_array[1]).trim();
			String _orgId = Util.null2String(_array[2]).trim();
			if(_orgType.equals(orgType) && _orgId.equals(orgId) && Util.getIntValue(subject, 0)>0 && !isEditFeeTypeId_list.contains(isEditFeeTypeId_subject)){
				isEditFeeTypeId_list.add(isEditFeeTypeId_subject);
				if(subjectIdsLevel3.length()>0){
					subjectIdsLevel3.append(",");
				}
				subjectIdsLevel3.append(Util.getIntValue(isEditFeeTypeId_subject, 0));
				subjectIdsLevel3_cnt++;
			}
		}

		//得到指定范围内所有三级科目整期预算
		HashMap<String, Map> b3BudgetTypeAmountHm = null;
		//得到指定范围内三级科目整期已分配预算
		HashMap<String, Map> b3DistributiveBudgetTypeAmountHm = null;
		//得到指定范围内三级科目、时间范围内已发生、审批中费用
		HashMap<String, HashMap<String, Expense>> b3BudgetTypeExpenseHm = new HashMap<String, HashMap<String, Expense>>();
		if(subjectIdsLevel3.length()>0){
	    	List<String> subjectIds_list = FnaCommon.initData1(subjectIdsLevel3.toString().split(","));
	    	int subjectIds_list_len = subjectIds_list.size();
	    		
			//得到指定范围内所有三级科目整期预算
			b3BudgetTypeAmountHm = fnaBudgetInfoComInfo.getBudgetAmountBySubjects_isEditFeeType(budgetinfoid, subjectIdsLevel3.toString());

			//得到指定范围内三级科目整期已分配预算
			b3DistributiveBudgetTypeAmountHm = fnaBudgetInfoComInfo.getDistributiveBudgetAmountBySubjects_isEditFeeType(budgetperiods_startdate, 
					Util.getIntValue(orgType), Util.getIntValue(orgId), subjectIdsLevel3.toString(), df);

			//得到指定范围内三级科目、时间范围内已发生、审批中费用
			StringBuffer sql_rs1 = new StringBuffer();
			sql_rs1.append("select b.isEditFeeTypeId subject, a.status, SUM("+isnull+"(a.amount, 0.0)) amount \n");
			sql_rs1.append(" from FnaExpenseInfo a \n");
			sql_rs1.append(" join FnaBudgetfeeType b on a.subject = b.id \n");
			sql_rs1.append(" where a.organizationtype = "+Util.getIntValue(orgType)+" and a.organizationid = "+Util.getIntValue(orgId)+" \n");
			sql_rs1.append(" and (1=2 \n");
	    	for(int j=0;j<subjectIds_list_len;j++){
	    		String sqlCond_subjectIds = Util.null2String(subjectIds_list.get(j));
				sql_rs1.append(" or b.isEditFeeTypeId in ("+sqlCond_subjectIds+") \n");
	    	}
			sql_rs1.append(" ) \n");
			sql_rs1.append(" and (a.occurdate >= '"+StringEscapeUtils.escapeSql(startdate)+"' and a.occurdate <= '"+StringEscapeUtils.escapeSql(enddate)+"') \n");
			sql_rs1.append(" GROUP BY b.isEditFeeTypeId, a.status");
			//out.println(sql_rs1.toString());
			rs1.executeSql(sql_rs1.toString());
			while(rs1.next()){
	    	    String _subject = Util.null2String(rs1.getString("subject"));
	    	    int _status = rs1.getInt("status");
	    	    double _amount = Util.getDoubleValue(rs1.getString("amount"), 0);

	    	    HashMap<String, Expense> _subjectHm = null;
	    	    if(b3BudgetTypeExpenseHm.containsKey(_subject)){
	    	    	_subjectHm = b3BudgetTypeExpenseHm.get(_subject);
	    	    }else{
	    	    	_subjectHm = new HashMap<String, Expense>();
	    	    	b3BudgetTypeExpenseHm.put(_subject, _subjectHm);
	    	    	
    	    		Expense expense_sq = new Expense();
    	    		expense_sq.setPendingExpense(0.00);
    	    		expense_sq.setRealExpense(0.00);
    	    		_subjectHm.put("expense", expense_sq);
	    	    }

	    	    Expense expense = _subjectHm.get("expense");
	    	    if (_status == 1){
	    	    	double realExpense = Util.getDoubleValue(df.format(_amount + expense.getRealExpense()));
	    			expense.setRealExpense(realExpense);
	    	    }else if (_status == 0){
	    	    	double pendingExpense = Util.getDoubleValue(df.format(_amount + expense.getPendingExpense()));
	    			expense.setPendingExpense(pendingExpense);
	    	    }
			}
		}
		if(b3BudgetTypeAmountHm==null){
			b3BudgetTypeAmountHm = new HashMap<String, Map>();
		}
		if(b3DistributiveBudgetTypeAmountHm==null){
			b3DistributiveBudgetTypeAmountHm = new HashMap<String, Map>();
		}
		if(b3BudgetTypeExpenseHm==null){
			b3BudgetTypeExpenseHm = new HashMap<String, HashMap<String, Expense>>();
		}

		int _subjectIdsLevel3_cnt = 0;
		for(int j=0;j<subjectListLen;j++){
			String[] _array = subjectList.get(j).split("_");
			String subject = Util.null2String(_array[0]).trim();
			String _orgType = Util.null2String(_array[1]).trim();
			String _orgId = Util.null2String(_array[2]).trim();
			int feeperiod = Util.getIntValue(_array[3]);
			if(_orgType.equals(orgType) && _orgId.equals(orgId) && Util.getIntValue(subject, 0)>0){
				//String groupCtrlSubject = FnaBudgetInfoComInfo.getGroupCtrlSubjectId(subject);
				String isEditFeeTypeId = bftci.getIsEditFeeTypeId(subject);
				
				String subjectName = subjectNameList.get(j);
				double ys = 0.00;
				
				int i_budgetperiodslist_cnt = 0;
				if(feeperiod==1){
					i_budgetperiodslist_cnt = 12;
				}else if(feeperiod==2){
					i_budgetperiodslist_cnt = 4;
				}else if(feeperiod==3){
					i_budgetperiodslist_cnt = 2;
				}else if(feeperiod==4){
					i_budgetperiodslist_cnt = 1;
				}

				int budgetperiodslist_startdate = 0;
				int budgetperiodslist_enddate = 0;

				BudgetPeriod bp_startdate = BudgetHandler.getBudgetPeriod(startdate, Util.getIntValue(isEditFeeTypeId));
				if(bp_startdate!=null){
					budgetperiodslist_startdate = bp_startdate.getPeriodlist();
				}
				BudgetPeriod bp_enddate = BudgetHandler.getBudgetPeriod(enddate, Util.getIntValue(isEditFeeTypeId));
				if(bp_enddate!=null){
					budgetperiodslist_enddate = bp_enddate.getPeriodlist();
				}

				if(feeperiod==1){
				}else if(feeperiod==2){
					if(budgetperiodslist_startdate>=1 && budgetperiodslist_startdate<=3){
						budgetperiodslist_startdate = 1;
					}else if(budgetperiodslist_startdate>=4 && budgetperiodslist_startdate<=6){
						budgetperiodslist_startdate = 2;
					}else if(budgetperiodslist_startdate>=7 && budgetperiodslist_startdate<=9){
						budgetperiodslist_startdate = 3;
					}else if(budgetperiodslist_startdate>=10 && budgetperiodslist_startdate<=12){
						budgetperiodslist_startdate = 4;
					}

					if(budgetperiodslist_enddate>=1 && budgetperiodslist_enddate<=3){
						budgetperiodslist_enddate = 1;
					}else if(budgetperiodslist_enddate>=4 && budgetperiodslist_enddate<=6){
						budgetperiodslist_enddate = 2;
					}else if(budgetperiodslist_enddate>=7 && budgetperiodslist_enddate<=9){
						budgetperiodslist_enddate = 3;
					}else if(budgetperiodslist_enddate>=10 && budgetperiodslist_enddate<=12){
						budgetperiodslist_enddate = 4;
					}
				}else if(feeperiod==3){
					if(budgetperiodslist_startdate>=1 && budgetperiodslist_startdate<=6){
						budgetperiodslist_startdate = 1;
					}else if(budgetperiodslist_startdate>=7 && budgetperiodslist_startdate<=12){
						budgetperiodslist_startdate = 2;
					}
					
					if(budgetperiodslist_enddate>=1 && budgetperiodslist_enddate<=6){
						budgetperiodslist_enddate = 1;
					}else if(budgetperiodslist_enddate>=7 && budgetperiodslist_enddate<=12){
						budgetperiodslist_enddate = 2;
					}
				}else if(feeperiod==4){
					budgetperiodslist_startdate = 1;
					budgetperiodslist_enddate = 1;
				}
				

				Map budgetTypeAmount = b3BudgetTypeAmountHm.get(isEditFeeTypeId);
				if(budgetTypeAmount==null){
					budgetTypeAmount = new HashMap();
				}
				Map distributiveBudgetAmount = b3DistributiveBudgetTypeAmountHm.get(isEditFeeTypeId);
				if(distributiveBudgetAmount==null){
					distributiveBudgetAmount = new HashMap();
				}
				
				//new BaseBean().writeLog("budgetTypeAmount>>>>>>>>>"+budgetTypeAmount);
				for(int i_budgetperiodslist=1;i_budgetperiodslist<=i_budgetperiodslist_cnt;i_budgetperiodslist++){
					//new BaseBean().writeLog("i_budgetperiodslist>>>>>>>>>"+i_budgetperiodslist+";budgetperiodslist_startdate>>>>>>>>>"+budgetperiodslist_startdate);
					//new BaseBean().writeLog("i_budgetperiodslist>>>>>>>>>"+i_budgetperiodslist+";budgetperiodslist_enddate>>>>>>>>>"+budgetperiodslist_enddate);
					if(i_budgetperiodslist>=budgetperiodslist_startdate && i_budgetperiodslist<=budgetperiodslist_enddate){
						double _ys = Util.getDoubleValue((String)budgetTypeAmount.get(i_budgetperiodslist+""), 0.00);
						ys+=_ys;
						ys = Util.getDoubleValue(df.format(ys));

						double _yfpys = Util.getDoubleValue((String)distributiveBudgetAmount.get(i_budgetperiodslist+""), 0.00);
						ys-=_yfpys;
						ys = Util.getDoubleValue(df.format(ys));
					}
				}
				
				HashMap<String, Expense> subjectHm = b3BudgetTypeExpenseHm.get(isEditFeeTypeId);
				if(subjectHm==null){
					subjectHm = new HashMap<String, Expense>();
				}
	    	    Expense expense = subjectHm.get("expense");
	    	    if(expense==null){
	    	    	expense = new Expense();
	    	    	expense.setPendingExpense(0.00);
	    	    	expense.setRealExpense(0.00);
	    	    }
				
	    	    _subjectIdsLevel3_cnt++;
	    	    
	    	    StringBuffer errorInfo = new StringBuffer();
	    	    FnaBudgetControl fnaBudgetControl = new FnaBudgetControl();
	    	    fnaBudgetControl.setCheckFnaIfOver_flag(true);
	    	    
	    	    boolean fnaIfNotOver_flag = true;
				for(int i_budgetperiodslist=1;i_budgetperiodslist<=i_budgetperiodslist_cnt;i_budgetperiodslist++){
					if(i_budgetperiodslist>=budgetperiodslist_startdate && i_budgetperiodslist<=budgetperiodslist_enddate){
						String[] retDate = BudgetHandler.getBudgetPeriodArray(budgetperiods_startdate, feeperiod+"", i_budgetperiodslist);
				    	String _poststr = subject+","+orgTypeJsValue+","+_orgId+","+retDate[0]+",0.0,0,postStrEnd";
						//new BaseBean().writeLog("_poststr>>>>>>>>>"+_poststr);
						if(fnaIfNotOver_flag){
							//第一次进行《预申请预算校验》
							if(fnaIfNotOver_flag){
								boolean doValidateApplication = true;
								String returnStr = fnaBudgetControl.fnaWfValidator4Expense(user, _poststr, "", "",  "", 
															0, workflowid, doValidateApplication, fysqlc, 0.0, 0, false);
								//new BaseBean().writeLog("1returnStr>>>>>>>>>"+returnStr);
								JSONObject json = new JSONObject(returnStr);
								if(!json.getBoolean("flag")){
									String errorType = json.getString("errorType");
									if(errorType=="alert"){
										fnaIfNotOver_flag = false;
									}else if(errorType=="confirm"){
									}else{
										fnaIfNotOver_flag = false;
									}
								}
							}
		
							if(fnaIfNotOver_flag){
								boolean doValidateApplication = false;
								String returnStr = fnaBudgetControl.fnaWfValidator4Expense(user, _poststr, "", "",  "", 
															0, workflowid, doValidateApplication, fysqlc, 0.0, 0, false);
								//new BaseBean().writeLog("2returnStr>>>>>>>>>"+returnStr);
								JSONObject json = new JSONObject(returnStr);
								json = new JSONObject(json.getString("fna"));
								if(!json.getBoolean("flag")){
									fnaIfNotOver_flag = false;
								}
							}
						}
						if(!fnaIfNotOver_flag){
							break;
						}
					}
	    	    }
				//new BaseBean().writeLog("fnaIfNotOver_flag>>>>>>>>>"+fnaIfNotOver_flag);
	    	    
	    	    String fnaIfOver_showName = SystemEnv.getHtmlLabelNames("161",user.getLanguage());//否
	    	    if(!fnaIfNotOver_flag){
	    	    	fnaIfOver_showName = SystemEnv.getHtmlLabelNames("163",user.getLanguage());//是
	    	    }
				
	    	    String trName = " name=\"tableDiv_tr_"+orgId+"_xxxxxtrsp\"";
	    	    String backgroundColor = "#DADADA";//灰色
	    	    if(_subjectIdsLevel3_cnt==subjectIdsLevel3_cnt){
	    	    	backgroundColor = "#90BADD";
	    	    	trName = "";
	    	    }

	    	    ys_hj += ys;
	    	    ys_hj = Util.getDoubleValue(df.format(ys_hj));
	    	    sq_hj += expense.getPendingExpense();
	    	    sq_hj = Util.getDoubleValue(df.format(sq_hj));
	    	    sj_hj += expense.getRealExpense();
	    	    sj_hj = Util.getDoubleValue(df.format(sj_hj));
				
				out.println("<tr id=\"tableDiv_tr_"+orgId+"_"+subject+"\" style='height:18px;'>");
				out.println("	<td style=\"text-align: right;border-bottom: 1px;border-bottom-color: #90BADD;\" onclick=\"alert(1);\">");
				out.println(		"");
				out.println("	</td>");
				out.println("	<td style=\"text-align: right;border-bottom: 1px;border-bottom-color: #90BADD;\">");
				out.println(		FnaCommon.escapeHtml(subjectName));
				out.println("	</td>");
				out.println("	<td style=\"border-bottom: 1px;border-bottom-color: #90BADD;\">");
				out.println(		"<span id=\"ys_"+orgId+"_"+subject+"\">"+df.format(ys)+"</span>");
				out.println("	</td>");
				out.println("	<td style=\"border-bottom: 1px;border-bottom-color: #90BADD;\">");
				out.println(		"<span id=\"sq_"+orgId+"_"+subject+"\">"+df.format(expense.getPendingExpense())+"</span>");
				out.println("	</td>");
				out.println("	<td style=\"border-bottom: 1px;border-bottom-color: #90BADD;\">");
				out.println(		"<span id=\"sj_"+orgId+"_"+subject+"\">"+df.format(expense.getRealExpense())+"</span>");
				out.println("	</td>");
				out.println("	<td style=\"border-bottom: 1px;border-bottom-color: #90BADD;\">");
				out.println(		"<span id=\"sfcb_"+orgId+"\">"+FnaCommon.escapeHtml(fnaIfOver_showName)+"</span>");
				out.println("	</td>");
				out.println("</tr>");
				out.println("<tr"+trName+" style=\"height: 1px;\"><td class=\"Line\" colSpan=\"1\"></td><td class=\"Line\" colSpan=\"5\" style=\"background-color: "+backgroundColor+";\"></td></tr>");
			}
		}

		if(orgId_qry.equals(orgId)){
			break;
		}
	}
}else{//全部科目
	int orgIdListLen = orgIdList.size();
	for(int i=0;i<orgIdListLen;i++){
		String orgTypeJsValue = orgTypeJsValueList.get(i);
		String orgType = orgTypeList.get(i);
		String orgId = orgIdList.get(i);

		//new BaseBean().writeLog("orgId_qry="+orgId_qry+";orgId="+orgId);
		if(!orgId_qry.equals(orgId)){
			continue;
		}
		
		allSubject_qry_0_budgetinfoid = 0;
		rs1.executeQuery("select a.id from FnaBudgetInfo a "+
				" where a.status=1 and a.budgetperiods=? and a.organizationtype=? and a.budgetorganizationid=?", 
				budgetperiods_startdate, Util.getIntValue(orgType), Util.getIntValue(orgId));
		if(rs1.next()){
			allSubject_qry_0_budgetinfoid = rs1.getInt("id");
		}
		
		int subject = -1;
		String appendAfterTrId = "tableDiv_tr_qry";
		
		javaScriptStr.append("getFnaInfoData_fnaBudgetAssistant1('"+orgType+"', '"+orgId+"', '"+startdate+"', '"+enddate+"', '"+allSubject_qry_0_budgetinfoid+"', '"+subject+"', '"+appendAfterTrId+"')"+"\r\n");
		
		if(orgId_qry.equals(orgId)){
			break;
		}
	}
}
%>
	</tbody>
</table>
</div>
<div style="width:810px;height:309px;overflow:hidden;margin-top:22px;">
	<div style="width:800px;height:250px;position:relative;" id="chartdiv"></div>
</div>

<script type="text/javascript">
var __requestid = "<%=requestId %>";

<%if(allSubject_qry==0){%>
//当前流程科目
jQuery(document).ready(function(){
	getChart();
});

function _toggle_FnaExpenseInfo(_orgId){
	var _tableDiv_trName_array = jQuery("tr[name='tableDiv_tr_"+_orgId+"_xxxxxtrsp']");
	var _tableDiv_tr_array = jQuery("tr[id^='tableDiv_tr_"+_orgId+"_']");
	var _tdPointer_html = jQuery("#tableDiv_tdPointer_"+_orgId).html();
	if(_tdPointer_html=="+"){
		jQuery("#tableDiv_tdPointer_"+_orgId).html("-");
		_tableDiv_trName_array.show();
		_tableDiv_tr_array.show();
	}else if(_tdPointer_html=="-"){
		jQuery("#tableDiv_tdPointer_"+_orgId).html("+");
		_tableDiv_trName_array.hide();
		_tableDiv_tr_array.hide();
	}
}

function getChart(){
	//['预算','申请','实际']
	var categories1 = <%="['"+SystemEnv.getHtmlLabelNames("386",user.getLanguage())+"','"+SystemEnv.getHtmlLabelNames("129",user.getLanguage())+"','"+SystemEnv.getHtmlLabelNames("628",user.getLanguage())+"']" %>;
	var sum_amt_str = "[<%=df.format(ys_hj) %>,<%=df.format(sq_hj) %>,<%=df.format(sj_hj) %>]"; 
	
	var _categories1 = eval(categories1);
	var _series = eval("[{"+
		"name: '<%=FnaCommon.escapeHtml(currentSelectOrgName) %>',"+//汇总
		"data: "+sum_amt_str+
	"}]");
	jQuery('#chartdiv').html("");
	jQuery('#chartdiv').highcharts({
		chart: {type: 'column'},
		title: {text: ''},
		xAxis: {categories: _categories1},
		yAxis: {title: {text: '<%=SystemEnv.getHtmlLabelName(534,user.getLanguage())+"("+SystemEnv.getHtmlLabelName(15279,user.getLanguage())+")"%>'}},
		tooltip: {useHTML: true},
		plotOptions: {
			column: {borderWidth:0}
		},
		exporting: {enabled: false},
		series: _series
	});
}
<%}else{%>
//全部科目
jQuery(document).ready(function(){
});

function _toggle_FnaExpenseInfo(_orgType, _orgId, _startdate, _enddate, _subject, _supSubjectId, _doClose){
	if(_doClose==null){
		_doClose = "false";
	}
	var _tdPointer = jQuery("#tableDiv_tdPointer_"+_orgId+"_"+_subject);
	var _tdPointer_html = _tdPointer.html();
	if(_doClose=="true" || _tdPointer_html=="-"){
		var _tableDiv_trName_array = jQuery("tr[name='tableDiv_tr_"+_orgId+"_xxxxxtrsp']");
		var _tableDiv_tr_array = jQuery("tr[id^='tableDiv_tr_"+_orgId+"_']");

		if(_doClose!="true"){
			_tdPointer.html("+");
		}
		
		for(var i=0;i<_tableDiv_trName_array.length;i++){
			var _tableDiv_trName = jQuery(_tableDiv_trName_array[i]);
			if(_tableDiv_trName.attr("_supSubjectId")==_subject){
				_tableDiv_trName.remove();
			}
		}
		for(var i=0;i<_tableDiv_tr_array.length;i++){
			var _tableDiv_tr = jQuery(_tableDiv_tr_array[i]);
			if(_tableDiv_tr.attr("_supSubjectId")==_subject){
				try{
					var _tableDiv_tr_id = _tableDiv_tr.attr("id");//tableDiv_tr_1_8
					_toggle_FnaExpenseInfo(_orgType, _orgId, _startdate, _enddate, _tableDiv_tr_id.split("_")[3], "", "true");
				}catch(ex1){}
				_tableDiv_tr.remove();
			}
		}
	}else if(_tdPointer_html=="+"){
		_tdPointer.html("-");

		getFnaInfoData_fnaBudgetAssistant1(_orgType, _orgId, _startdate, _enddate, '<%=allSubject_qry_0_budgetinfoid %>', _subject, "tableDiv_tr_"+_orgId+"_"+_subject);
		
	}
}

function getChart(categories1, series){
	var _categories1 = eval(categories1);
	var _series = eval(series);
	jQuery('#chartdiv').html("");
	jQuery('#chartdiv').highcharts({
		chart: {type: 'column'},
		title: {text: ''},
		xAxis: {categories: _categories1},
		yAxis: {title: {text: '<%=SystemEnv.getHtmlLabelName(534,user.getLanguage())+"("+SystemEnv.getHtmlLabelName(15279,user.getLanguage())+")"%>'}},
		tooltip: {useHTML: true},
		plotOptions: {
			column: {borderWidth:0}
		},
		exporting: {enabled: false},
		series: _series
	});
}

function getFnaInfoData_fnaBudgetAssistant1(orgtype, orgid, startdate, enddate, budgetinfoid, supSubject, appendAfterTrId){
	jQuery.ajax({
		url : "/page/element/fnaBudgetAssistant1/FnaExpenseInfoAjax.jsp",
		type : "post",
		processData : false,
		data : "ajaxType=1&orgtype="+orgtype+"&orgid="+orgid+
			"&startdate="+startdate+"&enddate="+enddate+"&budgetinfoid="+budgetinfoid+
			"&supSubject="+supSubject+"&appendAfterTrId="+appendAfterTrId,
		dataType : "json",
		success: function do4Success(_jsonResult){
			var _appendAfterTrId = _jsonResult.appendAfterTrId;
			var _appendAfterTrHtml = "";
			var _resultArray = _jsonResult.resultArray;
			var _resultArray_length = _resultArray.length;
			for(var i=0;i<_resultArray_length;i++){
				var _json = _resultArray[i];
				var _subjectName_prefix = _json.subjectName_prefix;
				var _subject = _json.subject;
				var _subjectName = _json.subjectName;
				var _orgType = _json.orgType;
				var _orgId = _json.orgId;
				var _ys = _json.ys;
				var _sj = _json.sj;
				var _trName = _json.trName;
				var _backgroundColor = _json.backgroundColor;
				var _textAlign = _json.textAlign;
				var _supSubjectId = _json.supSubjectId;
				var _startdate = _json.startdate;
				var _enddate = _json.enddate;
				var _feelevel = _json.feelevel;
				var _fontColor = _json.fontColor;
	
				_appendAfterTrHtml += "<tr id=\"tableDiv_tr_"+_orgId+"_"+_subject+"\" _supSubjectId=\""+_supSubjectId+"\" style='height:18px;color:"+_fontColor+"'>"+
					"	<td style=\""+_textAlign+";border-bottom: 1px;border-bottom-color: #90BADD;font-weight: bolder;cursor: pointer;\" "+
						"onclick=\"_toggle_FnaExpenseInfo('"+_orgType+"','"+_orgId+"','"+_startdate+"','"+_enddate+"','"+_subject+"','"+_supSubjectId+"');\" colSpan=\"2\">"+
							_subjectName_prefix;
				if(_feelevel!="3"){
					_appendAfterTrHtml += "		<span id=\"tableDiv_tdPointer_"+_orgId+"_"+_subject+"\">+</span>";
				}
				_appendAfterTrHtml += _subjectName+
					"	</td>"+
					"	<td style=\"border-bottom: 1px;border-bottom-color: #90BADD;font-weight: bolder;\">"+
					"		<span><%=SystemEnv.getHtmlLabelName(386,user.getLanguage()) %></span>"+//预算
					"	</td>"+
					"	<td style=\"border-bottom: 1px;border-bottom-color: #90BADD;\">"+
					"		<span id=\"ys_"+_orgId+"_"+_subject+"\">"+_ys+"</span>"+
					"	</td>"+
					"	<td style=\"border-bottom: 1px;border-bottom-color: #90BADD;font-weight: bolder;\">"+
					"		<span><%=SystemEnv.getHtmlLabelName(628,user.getLanguage()) %></span>"+//实际
					"	</td>"+
					"	<td style=\"border-bottom: 1px;border-bottom-color: #90BADD;\">"+
					"		<span id=\"sj_"+_orgId+"_"+_subject+"\">"+_sj+"</span>"+
					"	</td>"+
					"</tr>"+
					"<tr"+_trName+" _supSubjectId=\""+_supSubjectId+"\" style=\"height: 1px;\"><td class=\"Line\" colSpan=\"6\" style=\""+_backgroundColor+";\"></td></tr>";
			}
			jQuery("#"+_appendAfterTrId).after(_appendAfterTrHtml);

			if(_jsonResult.getChart=="1"){
				jQuery('#chartdiv').html("");
				getChart(_jsonResult.categories1, _jsonResult.series);
			}
		}
	});	
}

<%}%>



function getQryParam(){
	var _startdate_qry = jQuery("#startdate").val();
	var _enddate_qry = jQuery("#enddate").val();
	var _orgId_qry = jQuery("#orgId_qry").val();
	var _allSubject_qry = jQuery("#allSubject_qry").val();
	return "&_startdate_qry="+_startdate_qry+"&_enddate_qry="+_enddate_qry+"&_orgId_qry="+_orgId_qry+"&_allSubject_qry="+_allSubject_qry;
}

function allSubject_qry_onchange(){
	window.location.href = "<%=window_location_href %>"+getQryParam();
}

function orgId_qry_onchange(){
	window.location.href = "<%=window_location_href %>"+getQryParam();
}

function onShowDate_FnaExpenseInfo(spanname,inputname){	
	var returnvalue;
	var oncleaingFun = function(){
		$ele4p(spanname).innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"; 
		$ele4p(inputname).value = '';
	}
	WdatePicker({lang:languageStr,el:spanname,onpicked:function(dp){
		returnvalue = dp.cal.getDateStr();	
		$dp.$(spanname).innerHTML = returnvalue;
		$dp.$(inputname).value = returnvalue;
		window.location.href = "<%=window_location_href %>"+getQryParam();
	},oncleared:oncleaingFun});
	var hidename = $ele4p(inputname).value;
	if(hidename != ""){
		$ele4p(inputname).value = hidename; 
		$ele4p(spanname).innerHTML = hidename;
	}else{
		$ele4p(spanname).innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
	}
}

<%=javaScriptStr.toString() %>
</script>
</body>
<script language="javascript" src="/js/datetime_wev8.js"></script>
<script language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</html>



















































