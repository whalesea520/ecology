<%@page import="weaver.fna.general.FnaCommon"%>
<%@ page import="weaver.general.Util,java.text.SimpleDateFormat" %>
<%@ page import="weaver.workflow.request.RequestBrowser" %>
<%@ page import="weaver.workflow.workflow.WorkflowVersion" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page"/>
<jsp:useBean id="crmComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page"/>
<jsp:useBean id="sysInfo" class="weaver.system.SystemComInfo" scope="page"/>
<jsp:useBean id="Browsedatadefinition" class="weaver.workflow.request.Browsedatadefinition" scope="page"/>

<HTML>
<HEAD>
	<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
	<style type="text/css">
		.LayoutTable .fieldName {
			padding-left:20px!important;
		}
	</style>
</HEAD>
<%
SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");//设置日期格式
String currentdate = df.format(new Date());

String sqlwhere = " where 1=1 ";

int _bdf_wfid = Util.getIntValue(request.getParameter("bdf_wfid"));
int _bdf_fieldid = Util.getIntValue(request.getParameter("bdf_fieldid"));
String f_weaver_belongto_userid=Util.fromScreen(request.getParameter("f_weaver_belongto_userid"),user.getLanguage());
String f_weaver_belongto_usertype=request.getParameter("f_weaver_belongto_usertype");//需要增加的代码
user = HrmUserVarify.getUser(request, response, f_weaver_belongto_userid, f_weaver_belongto_usertype) ;//需要增加的代码
String userID = String.valueOf(user.getUID());
int userid=user.getUID();
String belongtoshow = "";				
		RecordSet.executeSql("select * from HrmUserSetting where resourceId = "+userID);
					if(RecordSet.next()){
						belongtoshow = RecordSet.getString("belongtoshow");
					}
String userIDAll = String.valueOf(user.getUID());	
String Belongtoids =user.getBelongtoids();
int Belongtoid=0;
String[] arr2 = null;
ArrayList<String> userlist = new ArrayList();
userlist.add(userid + "");
if(!"".equals(Belongtoids)){
userIDAll = userID+","+Belongtoids;
arr2 = Belongtoids.split(",");
for(int i=0;i<arr2.length;i++){
Belongtoid = Util.getIntValue(arr2[i]);
userlist.add(Belongtoid + "");
}
}
String usertype = "0";
if ("2".equals(user.getLogintype())) usertype = "1";
String fieldid = Util.null2String(request.getParameter("fieldid"));
String currworkflowid = Util.null2String(request.getParameter("currworkflowid"));
if ("".equals(currworkflowid)) {
	currworkflowid = Util.null2String(request.getParameter("workflowid"));
}
if(!"".equals(fieldid)){
	String newwfs[] = fieldid.split("_");
	fieldid = newwfs[0];
}

String issearch = Util.null2String(request.getParameter("issearch"));
String requestname = Util.null2String(request.getParameter("requestname"));
String creater = Util.null2String(request.getParameter("creater"));
String createdatestart = Util.null2String(request.getParameter("createdatestart"));
String createdateend = Util.null2String(request.getParameter("createdateend"));
String isrequest = Util.null2String(request.getParameter("isrequest"));
String requestmark = Util.null2String(request.getParameter("requestmark"));
String prjids = Util.null2String(request.getParameter("prjids"));
String crmids = Util.null2String(request.getParameter("crmids"));
String workflowid = Util.null2String(request.getParameter("workflowid"));
String department = Util.null2String(request.getParameter("department"));
String status = Util.null2String(request.getParameter("status"));
String subid = Util.null2String(request.getParameter("subid"));
/*begin：处理还款流程请求浏览按钮过滤逻辑代码*/
int __requestid = Util.getIntValue(request.getParameter("__requestid"));
int _fna_wfid = Util.getIntValue(request.getParameter("fna_wfid"));
int _fna_fieldid = Util.getIntValue(request.getParameter("fna_fieldid"));
if(_bdf_wfid > 0 && _fna_wfid <= 0){
	_fna_wfid = _bdf_wfid;
}
if(Util.getIntValue(currworkflowid) > 0 && _fna_wfid <= 0){
	_fna_wfid = Util.getIntValue(currworkflowid);
}
if(_bdf_fieldid > 0 && _fna_fieldid <= 0){
	_fna_fieldid = _bdf_fieldid;
}
if(Util.getIntValue(fieldid) > 0 && _fna_fieldid <= 0){
	_fna_fieldid = Util.getIntValue(fieldid);
}
boolean _isEnableFnaWf = false;//是否是启用的Ecology8费控流程
HashMap<String, String> _isEnableFnaWfHm = FnaCommon.getIsEnableFnaWfHm(_fna_wfid);
_isEnableFnaWf = "true".equals(_isEnableFnaWfHm.get("isEnableFnaWfE8"));
int _formId = Util.getIntValue(_isEnableFnaWfHm.get("formId"), 0);
int _isbill = Util.getIntValue(_isEnableFnaWfHm.get("isbill"), -1);
if(!_isEnableFnaWf){
	HashMap<String, String> _isEnableFnaRepaymentWfHm = FnaCommon.getIsEnableFnaRepaymentWfHm(_fna_wfid);
	_isEnableFnaWf = "true".equals(_isEnableFnaRepaymentWfHm.get("isEnableFnaRepaymentWf"));
	_formId = Util.getIntValue(_isEnableFnaRepaymentWfHm.get("formId"), 0);
	_isbill = Util.getIntValue(_isEnableFnaRepaymentWfHm.get("isbill"), -1);
}
boolean isFnaWfFysqlcReq = false;//是否是报销流程的费用申请流程
boolean isFnaWfRepaymentBorrowReq = false;//是否是还款流程的冲销明细的借款流程浏览按钮
boolean isFnaWfAdvanceRepaymentAdvanceReq = false;//是否是还款流程的冲销预付款明细的预付款流程浏览按钮
if(_isEnableFnaWf){
	isFnaWfFysqlcReq = FnaCommon.checkFnaWfFieldFnaType(_fna_wfid, _fna_fieldid, 2, 0, "fnaFeeWf");
	isFnaWfRepaymentBorrowReq = (
			FnaCommon.checkFnaWfFieldFnaType(_fna_wfid, _fna_fieldid, 1, 2, "repayment")
			|| FnaCommon.checkFnaWfFieldFnaType(_fna_wfid, _fna_fieldid, 1, 2, "fnaFeeWf")
		);
	isFnaWfAdvanceRepaymentAdvanceReq = FnaCommon.checkFnaWfFieldFnaType(_fna_wfid, _fna_fieldid, 1, 4, "fnaFeeWf");
}
int borrowType = Util.getIntValue(request.getParameter("borrowType"), -1);
int ___main_fieldIdSqr_controlBorrowingWf = 0;
int ___main_fieldIdSqr_val = 0;
if(isFnaWfFysqlcReq){
	String sqlIsNull = "ISNULL";
	String sqlSubString = "SUBSTRING";
	if("oracle".equals(rs.getDBType())){
		sqlIsNull = "NVL";
		sqlSubString = "SUBSTR";
	}
	sqlwhere += " and exists ( "+
			" select 1 " +
			" from FnaExpenseInfo fei " +
			" where fei.budgetperiodslist is not null " +
			" and fei.sourceRequestid <> "+__requestid+" " +
			" and fei.status = 0 " +
			" and fei.requestid = workflow_requestbase.requestid " +
			" GROUP BY fei.organizationid, fei.organizationtype, fei.subject, fei.budgetperiods, fei.budgetperiodslist  " +
			" HAVING SUM("+sqlIsNull+"(fei.amount, 0.00)) > 0.00 " +
			" ) and workflow_requestbase.currentnodetype = 3 ";
}else if(isFnaWfRepaymentBorrowReq){
	//需要控制只能选择自己的个人借款流程和自己发起的公务借款流程进行冲账，不能冲销其他个人借款的流程，公务借款流程可以给有权限的人员、或者自己提交的公务借款进行选择冲销。
	int controlBorrowingWf_userId = user.getUID();
	___main_fieldIdSqr_controlBorrowingWf = Util.getIntValue(request.getParameter("main_fieldIdSqr_controlBorrowingWf"), -1);
	if(___main_fieldIdSqr_controlBorrowingWf==1){
		___main_fieldIdSqr_val = Util.getIntValue(request.getParameter("main_fieldIdSqr_val"), -1);
		controlBorrowingWf_userId = ___main_fieldIdSqr_val;
	}
	String _condBorrowType = "";
	if(borrowType==-1 || borrowType==0){
		_condBorrowType += " (fbi1.borrowType0 = 0 and fbi1.applicantid = "+controlBorrowingWf_userId+") \n";
	}
	if(borrowType==-1){
		_condBorrowType += " or \n";
	}
	if(borrowType==-1 || borrowType==1){
		_condBorrowType += " (fbi1.borrowType1 = 1) \n";
	}
	if("".equals(sqlwhere)){
		sqlwhere += " where 1=1 ";
	}
	sqlwhere += " and exists ( \n"+
			" select 1 from ( \n" +
			"	select fbi.borrowRequestId, fbi.borrowRequestIdDtlId, \n" +
			"		SUM(fbi.amountBorrow * fbi.borrowDirection) sum_amountBorrow, \n" +
			"		MAX(CASE WHEN fbi.recordType = 'borrow' THEN fbi.applicantid ELSE 0 END) applicantid, \n" +
			"		MAX(CASE WHEN fbi.recordType = 'borrow' THEN fbi.departmentid ELSE 0 END) departmentid, \n" +
			"		MAX(CASE WHEN fbi.recordType = 'borrow' THEN fbi.subcompanyid1 ELSE 0 END) subcompanyid1, \n" +
			"		MAX(CASE WHEN fbi.borrowType = 0 THEN fbi.borrowType ELSE -99999 END) borrowType0, \n" +
			"		MAX(CASE WHEN fbi.borrowType = 1 THEN fbi.borrowType ELSE -99999 END) borrowType1 \n" +
			"	from FnaBorrowInfo fbi \n" +
			"	where fbi.requestid <> "+__requestid+" \n" +
			"	GROUP BY fbi.borrowRequestId, fbi.borrowRequestIdDtlId \n" +
			" ) fbi1 \n" +
			" where fbi1.sum_amountBorrow > 0 \n" +
			" and fbi1.borrowRequestId = workflow_requestbase.requestId \n"+
			" and ("+_condBorrowType+") \n" +
			" ) \n";
}else if(isFnaWfAdvanceRepaymentAdvanceReq){
	//需要控制只能选择自己的个人借款流程和自己发起的公务借款流程进行冲账，不能冲销其他个人借款的流程，公务借款流程可以给有权限的人员、或者自己提交的公务借款进行选择冲销。
	if("".equals(sqlwhere)){
		sqlwhere += " where 1=1 ";
	}
	sqlwhere += " and exists ( \n"+
			" select 1 from ( \n" +
			"	select fbi.advanceRequestId, fbi.advanceRequestIdDtlId, \n" +
			"		SUM(fbi.amountAdvance * fbi.advanceDirection) sum_amountAdvance \n" +
			"	from FnaAdvanceInfo fbi \n" +
			"	where fbi.requestid <> "+__requestid+" \n" +
			"	GROUP BY fbi.advanceRequestId, fbi.advanceRequestIdDtlId \n" +
			" ) fbi1 \n" +
			" where fbi1.sum_amountAdvance > 0 \n" +
			" and fbi1.advanceRequestId = workflow_requestbase.requestId \n"+
			" ) \n";
}
/*end：处理还款流程请求浏览按钮过滤逻辑代码*/
int olddate2during = 0;
BaseBean baseBean = new BaseBean();
String date2durings = "";
try{
	date2durings = Util.null2String(baseBean.getPropValue("wfdateduring", "wfdateduring"));
} catch(Exception e) {}
String[] date2duringTokens = Util.TokenizerString2(date2durings, ",");
if (date2duringTokens.length > 0){
	olddate2during = Util.getIntValue(date2duringTokens[0], 0);
}
if (olddate2during < 0 || olddate2during > 36) {
	olddate2during = 0;
}
int date2during = Util.getIntValue(request.getParameter("date2during"), olddate2during);

List<Map<String, String>> list = null;
if (!"".equals(fieldid) && !"".equals(currworkflowid)) {
	if (Browsedatadefinition.read(currworkflowid, fieldid)) {
	   	list = Browsedatadefinition.getList();
	} else {
		list = new ArrayList<Map<String, String>>();
	}
} else {
	list = new ArrayList<Map<String, String>>();
}

if ("".equals(isrequest)){
	isrequest = "1";
}

if(list.size() > 0) {
	if ("".equals(issearch)) {
		String requestname01 = Browsedatadefinition.getRequestname();
		String workflowtype = Browsedatadefinition.getWorkflowtype();
		String Processnumber = Browsedatadefinition.getProcessnumber();
		String createtype = Browsedatadefinition.getCreatetype();
		String createtypeid = Browsedatadefinition.getCreatetypeid();
		String createdepttype = Browsedatadefinition.getCreatedepttype();
		String department01 = Browsedatadefinition.getDepartment();
		String createsubtype = Browsedatadefinition.getCreatesubtype();
		String createsubid = Browsedatadefinition.getCreatesubid();
		String createdatetype = Browsedatadefinition.getCreatedatetype();
		String createdatestart01 = Browsedatadefinition.getCreatedatestart();
		String createdateend01 = Browsedatadefinition.getCreatedateend();
		String xgxmtype = Browsedatadefinition.getXgxmtype();
		String xgxmid = Browsedatadefinition.getXgxmid();
		String xgkhtype = Browsedatadefinition.getXgkhtype();
		String xgkhid = Browsedatadefinition.getXgkhid();
		String gdtype = Browsedatadefinition.getGdtype();
		String jsqjtype = Browsedatadefinition.getJsqjtype();

		if("".equals(requestname)){
			requestname = requestname01;
	    }

		if("".equals(workflowid)){
	   	 	workflowid = workflowtype;
	    }

		if("".equals(requestmark)){
			requestmark = Processnumber;
		}

		if ("".equals(creater)) {
			if("1".equals(createtype)) {
				creater = ""+user.getUID();
			} else if("2".equals(createtype)) {
				creater = createtypeid;
			} else if("3".equals(createtype)) {
				creater = Util.null2String(request.getParameter("cre"));
			}
		}

		if("".equals(department)) {
			if("1".equals(createdepttype)) {
				department = ""+user.getUserDepartment();
			} else if("2".equals(createdepttype)) {
				department = department01;
			} else if("3".equals(createdepttype)) {
				department = Browsedatadefinition.getDepartment(Util.null2String(request.getParameter("dep")));
			}
		}

		if("".equals(subid)) {
			if("1".equals(createsubtype)) {
				subid = ""+user.getUserSubCompany1();
			} else if("2".equals(createsubtype)) {
				subid = ""+createsubid;
			} else if ("3".equals(createsubtype)) {
				subid = Browsedatadefinition.getSubcompany(Util.null2String(request.getParameter("sub")));
			}
		}

		if("".equals(createdatestart) && "".equals(createdateend)){
			if("2".equals(createdatetype)) {//今天
				createdatestart = ""+currentdate;
				createdateend = ""+currentdate;
			} else if("3".equals(createdatetype)) {//本周
				createdatestart = df.format(Browsedatadefinition.getMonday());
				createdateend = df.format(Browsedatadefinition.getSunday());
			} else if("4".equals(createdatetype)){//本月
				createdatestart = df.format(Browsedatadefinition.getFirstDayOfMonth());
				createdateend = df.format(Browsedatadefinition.getLastDayOfMonth());
			} else if("5".equals(createdatetype)){//本季
				createdatestart = df.format(Browsedatadefinition.getFirstDayOfQuarter());
				createdateend = df.format(Browsedatadefinition.getLastDayOfQuarter());
			} else if("6".equals(createdatetype)){//本年
				createdatestart = Browsedatadefinition.getYearDateStart();
				createdateend = Browsedatadefinition.getYearDateEnd();
			} else if("7".equals(createdatetype)){//指定日期
				createdatestart = createdatestart01;
				createdateend = createdateend01; 
			} else if("8".equals(createdatetype)) {
				createdatestart = Util.null2String(request.getParameter("date"));
				createdateend = Util.null2String(request.getParameter("date"));
			}
		} else {
			if("".equals(createdatestart)){
				createdatestart = createdatestart01;
			}
			if("".equals(createdateend)){
				createdateend = createdateend01;
			}
		}

		if("".equals(prjids)) {
			if ("2".equals(xgxmtype)) {
				prjids = xgxmid;
			} else if ("3".equals(xgxmtype)) {
				prjids = Util.null2String(request.getParameter("xgxm"));
			}
		}

		if("".equals(crmids)) {
			if ("2".equals(xgkhtype)) {
				crmids = xgkhid;
			} else if ("3".equals(xgkhtype)) {
				crmids = Util.null2String(request.getParameter("xgkh"));
			}
		}

	    if("".equals(status)){
	   	 	status = gdtype;
	    }

	    date2during = Util.getIntValue(jsqjtype,0);
	}
}

if (!"".equals(requestname)) {
	sqlwhere += " and requestnamenew like '%" + Util.fromScreen2(requestname,user.getLanguage()) + "%'";
}
if(!"".equals(workflowid) && !"0".equals(workflowid)){
	sqlwhere += " and workflow_requestbase.workflowid in (" + WorkflowVersion.getAllVersionStringByWFIDs(workflowid) + ")";	
}
if (!"".equals(requestmark)) {
	sqlwhere += " and requestmark like '%" + requestmark +"%'";
}
if (!"".equals(creater)) {
		sqlwhere += " and creater in(" + creater + ") and creatertype=0 " ;
}
if (!"".equals(department) && !"0".equals(department)) {
	sqlwhere += " and workflow_requestbase.creater in (select id from hrmresource where departmentid in (" + department + "))";
}
if (!"".equals(subid) && !"0".equals(subid)) {
	sqlwhere += " and workflow_requestbase.creater in (select id from hrmresource where subcompanyid1 in (" + subid + "))";
}
if (!"".equals(createdatestart)) {
	sqlwhere += " and createdate >='" + createdatestart + "'";
}
if (!"".equals(createdateend)) {
	sqlwhere += " and createdate <='" + createdateend + "'";
}
if (!"".equals(prjids) && !"0".equals(prjids)) {
	String[] prjidAry = prjids.split(",");
	if (prjidAry.length > 0) {
		sqlwhere += " AND (";
		if ("oracle".equals(RecordSet.getDBType())) {
			for (int i = 0; i < prjidAry.length; i++) {
				if (i > 0) {
					sqlwhere += " OR ";
				}
				sqlwhere += "(concat(concat(',' , To_char(workflow_requestbase.prjids)) , ',') LIKE '%," + prjidAry[i] + ",%')";
			}
		} else {
			for (int i = 0; i < prjidAry.length; i++) {
				if (i > 0) {
					sqlwhere += " OR ";
				}
				sqlwhere += "(',' + CONVERT(varchar,workflow_requestbase.prjids) + ',' LIKE '%," + prjidAry[i] + ",%')";
			}
		}
		sqlwhere += ") ";
	}
}
if (!"".equals(crmids) && !"0".equals(crmids)) {
	String[] crmidAry = crmids.split(",");
	if (crmidAry.length > 0) {
		sqlwhere += " AND (";
		if ("oracle".equals(RecordSet.getDBType())) {
			for (int i = 0; i < crmidAry.length; i++) {
				if (i > 0) {
					sqlwhere += " OR ";
				}
				sqlwhere += "(concat(concat(',' , To_char(workflow_requestbase.crmids)) , ',') LIKE '%," + crmidAry[i] + ",%')";
			}
		} else {
			for (int i = 0; i < crmidAry.length; i++) {
				if (i > 0) {
					sqlwhere += " OR ";
				}
				sqlwhere += "(',' + CONVERT(varchar,workflow_requestbase.crmids) + ',' LIKE '%," + crmidAry[i] + ",%')";
			}
		}
		sqlwhere += ") ";
	}
}
if ("1".equals(status)) {
	sqlwhere += " and currentnodetype < 3 ";
} else if ("2".equals(status)) {
	sqlwhere += " and currentnodetype = 3 ";
}
sqlwhere += WorkflowComInfo.getDateDuringSql(date2during);

if (" where 1=1 ".equals(sqlwhere)){
	sqlwhere += " and workflow_requestbase.requestid <> 0";
}
if("oracle".equals(RecordSet.getDBType())){
	sqlwhere += " and (nvl(workflow_requestbase.currentstatus,-1) = -1 or (nvl(workflow_requestbase.currentstatus,-1)=0 and workflow_requestbase.creater="+user.getUID()+"))";
} else {
	sqlwhere += " and (isnull(workflow_requestbase.currentstatus,-1) = -1 or (isnull(workflow_requestbase.currentstatus,-1)=0 and workflow_requestbase.creater="+user.getUID()+"))";
}
%>
<BODY style='overflow-x:hidden'>
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="workflow"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(648,user.getLanguage())%>"/>
</jsp:include>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>" class="e8_btn_top"  onclick="dosubmit()"/>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
	RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:dosubmit(),_self} " ;
	RCMenuHeight += RCMenuHeightStep;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:onResetwf(),_self} " ;
	RCMenuHeight += RCMenuHeightStep;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:btncancel_onclick(),_self} " ;
	RCMenuHeight += RCMenuHeightStep;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:submitClear(),_self} " ;
	RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<div class="zDialog_div_content">
<FORM NAME=SearchForm STYLE="margin-bottom:0" action="RequestBrowser.jsp" method=post>
<input type="hidden" name="fieldid" id="fieldid"  value="<%=fieldid %>">
<input type="hidden" name="issearch" id="issearch"  >
<input type="hidden" name="currworkflowid" id="currworkflowid"  value="<%=currworkflowid %>">
<%if (list.size() > 0) {
for (int j = 0; j < list.size(); j++) {
	Map<String, String> map = list.get(j);
	String type = map.get("type");
	boolean isHide = Browsedatadefinition.isHide(map.get("hide"));
	String inputName = "";
	String inputValue = "";
	if (isHide) {
		if ("1".equals(type)) {%>
<input type="hidden" name="requestname" value="<%=requestname%>" />
<%} else if ("2".equals(type)) {%>
<input type="hidden" name="workflowid" value="<%=workflowid%>" />
<%} else if ("3".equals(type)) {%>
<input type="hidden" name="requestmark" value="<%=requestmark%>" />
<%} else if ("4".equals(type)) {%>
<input type="hidden" name="creater" value="<%=creater%>" />
<%} else if ("5".equals(type)) {%>
<input type="hidden" name="department" value="<%=department%>" />
<%} else if ("6".equals(type)) {%>
<input type="hidden" name="subid" value="<%=subid%>" />
<%} else if ("7".equals(type)) {%>
<input type="hidden" name="createdatestart" value="<%=createdatestart%>" />
<input type="hidden" name="createdateend" value="<%=createdateend%>" />
<%} else if ("8".equals(type)) {%>
<input type="hidden" name="prjids" value="<%=prjids%>" />
<%} else if ("9".equals(type)) {%>
<input type="hidden" name="crmids" value="<%=crmids%>" />
<%} else if ("10".equals(type)) {%>
<input type="hidden" name="status" value="<%=status%>" />
<%} else if ("11".equals(type)) {%>
<input type="hidden" name="date2during" value="<%=date2during%>" />
<%}}}}%>
<input type="hidden" name="fna_wfid" id="fna_wfid"  value="<%=_fna_wfid %>" />
<input type="hidden" name="fna_fieldid" id="fna_fieldid"  value="<%=_fna_fieldid %>" />
<input type="hidden" name="__requestid" id="__requestid"  value="<%=__requestid %>" />

<wea:layout type="4col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(20331, user.getLanguage())%>'>
		<%if(list.size()>0){%>
			<%
 				for (int j = 0; j < list.size(); j++) {
			Map<String, String> map = list.get(j);
			boolean isHide = Browsedatadefinition.isHide(map.get("hide"));
			if (isHide) {
				continue;
			}
			String type = map.get("type");
			boolean isReadonly = Browsedatadefinition.isHide(map.get("readonly"));
 				%>
			<%if ("1".equals(type)) {%>
				<wea:item><%=SystemEnv.getHtmlLabelName(26876, user.getLanguage())%></wea:item>
				<wea:item><input name="requestname" class="Inputstyle" value='<%=requestname%>' <%if(isReadonly){%>readonly="readonly"<%}%>></wea:item>
			<%} else if ("2".equals(type)) {%>
				<%if (!"2".equals(user.getLogintype())) {
					String workflowids[] = Util.TokenizerString2(workflowid, ",");
					String workflowestr = "";
					for (int i = 0; i < workflowids.length; i++) {
						if (!"".equals(workflowids[i]) && !"0".equals(workflowids[i])) {
							workflowestr += (!"".equals(workflowestr) ? "," : "")
									+ Util.null2String(WorkflowComInfo.getWorkflowname(workflowids[i]));
						}
					}
				%>
					<wea:item><%=SystemEnv.getHtmlLabelName(33806, user.getLanguage())%></wea:item>
					<wea:item><span><brow:browser viewType="0" name="workflowid"
						browserValue='<%=workflowid%>'
						browserUrl="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/MutiWorkflowBrowser.jsp?selectedids="
						browserDialogHeight="650px;"
						hasInput='<%=isReadonly ? "false" : "true"%>' isSingle="false" hasBrowser="true"
						isMustInput='<%=isReadonly ? "0" : "1"%>' linkUrl="#"
						completeUrl="/data.jsp?type=workflowBrowser"
						browserSpanValue='<%=workflowestr%>'>
					</brow:browser></span></wea:item>
				<%}%>
			<%} else if ("3".equals(type)) {%>
				<wea:item><%=SystemEnv.getHtmlLabelName(714, user.getLanguage())%></wea:item>
				<wea:item><input name="requestmark" class="Inputstyle" value='<%=requestmark%>' <%if(isReadonly){%>readonly="readonly"<%}%> /></wea:item>
			<%} else if ("4".equals(type)) {
				String creates[] = Util.TokenizerString2(creater, ",");
				String createnames = "";
				for (int i = 0; i < creates.length; i++) {
					if (!"".equals(creates[i]) && !"0".equals(creates[i])) {
						createnames += (!"".equals(createnames) ? "," : "")
								+ ResourceComInfo.getResourcename(creates[i]);
					}
				}
			%>
				<%
					String hasInput = "true";
					String isMustInput = "1";
					if ("2".equals(user.getLogintype())) {
						isMustInput = "0";
						hasInput = "false";
					} else if (isReadonly) {
						isMustInput = "0";
						hasInput = "false";
					}
				%>
				<wea:item><%=SystemEnv.getHtmlLabelName(882, user.getLanguage())%></wea:item>
				<wea:item><span><brow:browser viewType="0" name="creater"
						browserValue='<%=creater%>'
						completeUrl="/data.jsp?type=1"
						browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids="
						hasInput='<%=hasInput%>' isSingle="false" hasBrowser="true"
						isMustInput='<%=isMustInput%>' linkUrl="#"
						browserSpanValue='<%=createnames%>'>
				</brow:browser></span></wea:item>
			<%} else if ("5".equals(type)) {
				String departments[] = Util.TokenizerString2(department, ",");
				String departmentnames = "";
				for (int i = 0; i < departments.length; i++) {
					if (!"".equals(departments[i]) && !"0".equals(departments[i])) {
						departmentnames += (!"".equals(departmentnames) ? "," : "")
								+ DepartmentComInfo.getDepartmentname(departments[i]);
					}
				}
			%>
				<wea:item><%=SystemEnv.getHtmlLabelName(19225, user.getLanguage())%></wea:item>
				<wea:item><span><brow:browser viewType="0" name="department"
						browserValue='<%=department%>'
						browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp?selectedids="
						hasInput='<%=isReadonly ? "false" : "true"%>' isSingle="false" hasBrowser="true"
						completeUrl="/data.jsp?type=4"
						isMustInput='<%=isReadonly ? "0" : "1"%>' linkUrl="#"
						browserSpanValue='<%=departmentnames%>'>
				</brow:browser></span></wea:item>
			<%} else if ("6".equals(type)) {
				String subids[] = Util.TokenizerString2(subid, ",");
				String subnames = "";
				for (int i = 0; i < subids.length; i++) {
					if (!"".equals(subids[i]) && !"0".equals(subids[i])) {
						subnames += (!"".equals(subnames) ? "," : "")
								+ SubCompanyComInfo.getSubCompanyname(subids[i]);
					}
				}
			%>
				<wea:item><%=SystemEnv.getHtmlLabelName(22788, user.getLanguage())%></wea:item>
				<wea:item><span><brow:browser viewType="0" name="subid"
						browserValue='<%=subid%>'
						browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser3.jsp?selectedids="
						hasInput='<%=isReadonly ? "false" : "true"%>' isSingle="false" hasBrowser="true"
						completeUrl="/data.jsp?type=164"
						isMustInput='<%=isReadonly ? "0" : "1"%>' linkUrl="#"
						browserSpanValue='<%=subnames%>'>
				</brow:browser></span></wea:item>
			<%} else if ("7".equals(type)) {%>
				<wea:item><%=SystemEnv.getHtmlLabelName(722, user.getLanguage())%></wea:item>
				<wea:item><button type="button" class=Calendar id=selectbirthday <%if(!isReadonly){%>onclick="getTheDate(createdatestart,createdatestartspan)"<%}%>></BUTTON>
				<SPAN id=createdatestartspan><%=createdatestart%></SPAN>
	  - &nbsp;<button type="button" class=Calendar id=selectbirthday1 <%if(!isReadonly){%>onclick="getTheDate(createdateend,createdateendspan)"<%}%>></BUTTON>
				<SPAN id=createdateendspan><%=createdateend%></SPAN>
				<input type="hidden" id="createdatestart" name="createdatestart" value="<%=createdatestart%>">
				<input type="hidden" id="createdateend" name="createdateend" value="<%=createdateend%>"></wea:item>
			<%} else if ("8".equals(type)) {
				String prjidss[] = Util.TokenizerString2(prjids, ",");
				String projnames = "";
				for (int i = 0; i < prjidss.length; i++) {
					if (!"".equals(prjidss[i]) && !"0".equals(prjidss[i])) {
						projnames += (!"".equals(projnames) ? "," : "")
					 			+ ProjectInfoComInfo.getProjectInfoname(prjidss[i]);
					}
				}
			%>
				<wea:item><%=SystemEnv.getHtmlLabelName(782, user.getLanguage())%></wea:item>
				<wea:item><span><brow:browser viewType="0" name="prjids"
						browserValue='<%=prjids%>'
						browserUrl="/systeminfo/BrowserMain.jsp?url=/proj/data/MultiProjectBrowser.jsp?resourceids="
						hasInput='<%=isReadonly ? "false" : "true"%>' isSingle="false" hasBrowser="true"
						isMustInput='<%=isReadonly ? "0" : "1"%>' linkUrl="#"
						completeUrl="/data.jsp?type=8"
						browserSpanValue='<%=projnames%>'>
				</brow:browser></span></wea:item>
			<%} else if ("9".equals(type)) {
				String crmidss[] = Util.TokenizerString2(crmids, ",");
				String crmnames = "";
				for (int i = 0; i < crmidss.length; i++) {
					if (!"".equals(crmidss[i]) && !"0".equals(crmidss[i])) {
						crmnames += (!"".equals(crmnames) ? "," : "")
					 			+ crmComInfo.getCustomerInfoname(crmidss[i]);
					}
				}
			%>
				<wea:item><%=SystemEnv.getHtmlLabelName(783, user.getLanguage())%></wea:item>
				<wea:item><span><brow:browser viewType="0" name="crmids"
						browserValue='<%=crmids%>'
						browserUrl="/systeminfo/BrowserMain.jsp?url=/CRM/data/MutiCustomerBrowser.jsp?resourceids="
						hasInput='<%=isReadonly ? "false" : "true"%>' isSingle="false" hasBrowser="true"
						completeUrl="/data.jsp?type=7"
						isMustInput='<%=isReadonly ? "0" : "1"%>' linkUrl="#"
						browserSpanValue='<%=crmnames%>'>
				</brow:browser></span></wea:item>
			<%} else if ("10".equals(type)) {%>
				<wea:item><%=SystemEnv.getHtmlLabelName(19061, user.getLanguage())%></wea:item>
				<wea:item><select <%if(isReadonly){%>disabled="true"<%}%> id=status name=status>
					<OPTION value="">&nbsp;</OPTION>
					<OPTION value="1" <%if (status.equals("1")) out.println("selected");%>><%=SystemEnv.getHtmlLabelName(23773, user.getLanguage())%></OPTION>
					<OPTION value="2" <%if (status.equals("2")) out.println("selected");%>><%=SystemEnv.getHtmlLabelName(23774, user.getLanguage())%></OPTION>
				</select></wea:item>
			<%} else if ("11".equals(type)) {%>
				<wea:item><%=SystemEnv.getHtmlLabelName(31787, user.getLanguage())%></wea:item>
				<wea:item><select <%if(isReadonly){%>disabled="true"<%}%> class=inputstyle size=1 id=date2during name=date2during>
					<%
						for (int i = 0; i < date2duringTokens.length; i++) {
							int tempdate2during = Util.getIntValue(date2duringTokens[i], 0);
							if (tempdate2during > 36 || tempdate2during < 1) {
								continue;
							}
					%>
					<!-- 最近个月 -->
					<option value="<%=tempdate2during%>" <%if (date2during == tempdate2during) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(24515,user.getLanguage())%><%=tempdate2during%><%=SystemEnv.getHtmlLabelName(26301,user.getLanguage())%></option>
					<%}%>
					<!-- 全部 -->
					<option value="38" <%if (date2during == 38) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(332, user.getLanguage())%></option>
				</select></wea:item>
			<%}%>
		<%}%>
			<%if (isFnaWfRepaymentBorrowReq) {%>
				<wea:item><%=SystemEnv.getHtmlLabelName(22138, user.getLanguage())%></wea:item>
				<wea:item>
					<select class="inputstyle" size="1" id="borrowType" name="borrowType">
						<option value="-1" <%if (borrowType == -1) {%> selected <%}%>></option>
						<option value="0" <%if (borrowType == 0) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(83306, user.getLanguage())%></option><!-- 个人借款 -->
						<option value="1" <%if (borrowType == 1) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(83305, user.getLanguage())%></option><!-- 公务借款 -->
					</select>
					<input name="main_fieldIdSqr_controlBorrowingWf" value="<%=___main_fieldIdSqr_controlBorrowingWf%>" type="hidden" />
					<input name="main_fieldIdSqr_val" value="<%=___main_fieldIdSqr_val%>" type="hidden" />
				</wea:item>
			<%}%>
			
<%}else{%>
					<wea:item><%=SystemEnv.getHtmlLabelName(1334, user.getLanguage())%></wea:item>
					<wea:item>
						<input name=requestname class=InputStyle value="<%=requestname%>">
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(33806, user.getLanguage())%></wea:item>
					<wea:item>
						<span> <brow:browser viewType="0" name="workflowid"
								browserValue='<%=workflowid%>'
								completeUrl="/data.jsp?type=workflowBrowser"
								browserUrl="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser.jsp"
								hasInput="true" isSingle="true" hasBrowser="true"
								isMustInput='1' linkUrl="#" width="80%"
								browserSpanValue='<%=WorkflowComInfo.getWorkflowname(workflowid)%>'></brow:browser>
						</span>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(19502, user.getLanguage())%></wea:item>
					<wea:item>
						<input name="requestmark" class=InputStyle value="<%=requestmark%>">
					</wea:item>
					<wea:item>
						<%
							if (!user.getLogintype().equals("2")) {
						%><%=SystemEnv.getHtmlLabelName(882, user.getLanguage())%>
						<%
							}
						%>
					</wea:item>
					<wea:item>
						<%
							if (!user.getLogintype().equals("2")) {
						%>
						<span> <brow:browser viewType="0" name="creater"
								browserValue='<%=creater%>'
								completeUrl="/data.jsp?type=1"
								browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp"
								hasInput="true" isSingle="false" hasBrowser="true"
								isMustInput='1' linkUrl="#" width="80%"
								browserSpanValue='<%=Util.toScreen(ResourceComInfo.getLastnameAllStatus(creater), user.getLanguage())%>'></brow:browser>
						</span>
						<%
							}
						%>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(19225, user.getLanguage())%></wea:item>
					<wea:item>
					<span> 
					<%
		 				String departments[] = Util.TokenizerString2(department, ",");
		 				String departmentnames = "";
		 				for (int i = 0; i < departments.length; i++) {
		 					if (!departments[i].equals("")&& !departments[i].equals("0")) {
		 						departmentnames += (!departmentnames.equals("") ? ",": "")+ DepartmentComInfo.getDepartmentname(departments[i]);
		 					}
		 				}
		 			%> 
						<brow:browser viewType="0" name="department"
							browserValue='<%=department%>'
							completeUrl="/data.jsp?type=4"
							browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp"
							hasInput="true" isSingle="false" hasBrowser="true"
							isMustInput='1' linkUrl="#" width="80%"
							browserSpanValue='<%=departmentnames%>'>
						</brow:browser> 
					</span>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(22788, user.getLanguage())%></wea:item>
					<wea:item>
						<%
							String subids[] = Util.TokenizerString2(subid, ",");
							String subnames = "";
							for (int i = 0; i < subids.length; i++) {
								if (!"".equals(subids[i]) && !"0".equals(subids[i])) {
									subnames += (!"".equals(subnames) ? "," : "")
											+ SubCompanyComInfo.getSubCompanyname(subids[i]);
								}
							}
						%>
						<span>
							<brow:browser viewType="0" name="subid"
								browserValue='<%=subid%>'
								browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser3.jsp?selectedids="
								hasInput='true' isSingle="false" hasBrowser="true"
								completeUrl="/data.jsp?type=164"
								isMustInput='1' linkUrl="#"
								browserSpanValue='<%=subnames%>'>
							</brow:browser>
						</span>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(722, user.getLanguage())%></wea:item>
					<wea:item>
						<button type="button" class=Calendar id=selectbirthday
							onclick="getTheDate(createdatestart,createdatestartspan)"></BUTTON>
						<SPAN id=createdatestartspan><%=createdatestart%></SPAN>
			  - &nbsp;<button type="button" class=Calendar id=selectbirthday1
							onclick="getTheDate(createdateend,createdateendspan)"></BUTTON>
						<SPAN id=createdateendspan><%=createdateend%></SPAN>
						<input type="hidden" id=createdatestart name="createdatestart"
							value="<%=createdatestart%>">
						<input type="hidden" id="createdateend" name="createdateend"
							value="<%=createdateend%>">
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(782, user.getLanguage())%></wea:item>
					<wea:item>
						<%
							String prjidss[] = Util.TokenizerString2(prjids, ",");
							String projnames = "";
							for (int i = 0; i < prjidss.length; i++) {
								if (!"".equals(prjidss[i]) && !"0".equals(prjidss[i])) {
									projnames += (!"".equals(projnames) ? "," : "")
								 			+ ProjectInfoComInfo.getProjectInfoname(prjidss[i]);
								}
							}
						%>
						<span>
							<brow:browser viewType="0" name="prjids"
								browserValue='<%=prjids%>'
								browserUrl="/systeminfo/BrowserMain.jsp?url=/proj/data/MultiProjectBrowser.jsp?resourceids="
								hasInput='true' isSingle="false" hasBrowser="true"
								isMustInput='1' linkUrl="#"
								completeUrl="/data.jsp?type=8"
								browserSpanValue='<%=projnames%>'>
							</brow:browser>
						</span>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(783, user.getLanguage())%>
					</wea:item>
					<wea:item>
						<%
							String crmidss[] = Util.TokenizerString2(crmids, ",");
							String crmnames = "";
							for (int i = 0; i < crmidss.length; i++) {
								if (!"".equals(crmidss[i]) && !"0".equals(crmidss[i])) {
									crmnames += (!"".equals(crmnames) ? "," : "")
								 			+ crmComInfo.getCustomerInfoname(crmidss[i]);
								}
							}
						%>
						<span>
							<brow:browser viewType="0" name="crmids"
									browserValue='<%=crmids%>'
									browserUrl="/systeminfo/BrowserMain.jsp?url=/CRM/data/MutiCustomerBrowser.jsp?resourceids="
									hasInput='true' isSingle="false" hasBrowser="true"
									completeUrl="/data.jsp?type=7"
									isMustInput='1' linkUrl="#"
									browserSpanValue='<%=crmnames%>'>
							</brow:browser> 
						</span>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(19061, user.getLanguage())%></wea:item>
					<wea:item>
						<select id=status name=status>
							<OPTION value=""></OPTION>
							<OPTION value="1"
							<%if (status.equals("1"))
								out.println("selected");%>><%=SystemEnv.getHtmlLabelName(23773, user.getLanguage())%>
							</OPTION>
							<OPTION value="2"
							<%if (status.equals("2"))
								out.println("selected");%>><%=SystemEnv.getHtmlLabelName(23774, user.getLanguage())%>
							</OPTION>
						</select>
					</wea:item>
					<%
						if (date2duringTokens.length > 0) {
					%>
					<wea:item><%=SystemEnv.getHtmlLabelName(31787, user.getLanguage()) %></wea:item>
					<wea:item>
						<select class=inputstyle size=1 id=date2during name=date2during>
							<%
								for (int i = 0; i < date2duringTokens.length; i++) {
													int tempdate2during = Util.getIntValue(
															date2duringTokens[i], 0);
													if (tempdate2during > 36 || tempdate2during < 1) {
														continue;
													}
							%>
							<!-- 最近个月 -->
							<option value="<%=tempdate2during%>"
								<%if (date2during == tempdate2during) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(24515,
												user.getLanguage())%><%=tempdate2during%><%=SystemEnv.getHtmlLabelName(26301,
												user.getLanguage())%></option>
							<%
								}
							%>
							<!-- 全部 -->
							<option value="38" <%if (date2during == 38) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(332, user
											.getLanguage())%></option>
						</select>
					</wea:item>
					<%
						}
					%>
			<%if (isFnaWfRepaymentBorrowReq) {%>
				<wea:item><%=SystemEnv.getHtmlLabelName(22138, user.getLanguage())%></wea:item>
				<wea:item>
					<select class="inputstyle" size="1" id="borrowType" name="borrowType">
						<option value="-1" <%if (borrowType == -1) {%> selected <%}%>></option>
						<option value="0" <%if (borrowType == 0) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(83306, user.getLanguage())%></option><!-- 个人借款 -->
						<option value="1" <%if (borrowType == 1) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(83305, user.getLanguage())%></option><!-- 公务借款 -->
					</select>
					<input name="main_fieldIdSqr_controlBorrowingWf" value="<%=___main_fieldIdSqr_controlBorrowingWf%>" type="hidden" />
					<input name="main_fieldIdSqr_val" value="<%=___main_fieldIdSqr_val%>" type="hidden" />
				</wea:item>
			<%}%>
<%} %>
</wea:group>
<wea:group context="" attributes="{'groupDisplay':'none'}">
	<wea:item attributes="{'colspan':'full','isTableList':'true'}">
		<% 
			String backfields = " * ";
			String formsql = "";
			if("1".equals(belongtoshow)){
			if (RecordSet.getDBType().equals("oracle") || RecordSet.getDBType().equals("db2")) {
					formsql=" from ("+
					" select distinct workflow_requestbase.requestid ,requestname,creater,creatertype,createdate,createtime,createdate||' '||createtime as createtimes from workflow_requestbase , workflow_currentoperator , workflow_base" +sqlwhere+
					" and workflow_currentoperator.requestid = workflow_requestbase.requestid and workflow_currentoperator.userid in (" +userIDAll + ") and workflow_currentoperator.usertype="+usertype+
					" and workflow_requestbase.workflowid = workflow_base.id and (workflow_base.isvalid='1' or workflow_base.isvalid='3') "+
					" ) t ";
				}else{
				formsql=" from ("+
					" select distinct workflow_requestbase.requestid ,requestname,creater,creatertype,createdate,createtime,createdate+' '+createtime as createtimes from workflow_requestbase , workflow_currentoperator , workflow_base" +sqlwhere+
					" and workflow_currentoperator.requestid = workflow_requestbase.requestid and workflow_currentoperator.userid in (" +userIDAll + ") and workflow_currentoperator.usertype="+usertype+
					" and workflow_requestbase.workflowid = workflow_base.id and (workflow_base.isvalid='1' or workflow_base.isvalid='3') "+
					" ) t ";
			}
			}else{
			if (RecordSet.getDBType().equals("oracle") || RecordSet.getDBType().equals("db2")) {
					formsql=" from ("+
					" select distinct workflow_requestbase.requestid ,requestname,creater,creatertype,createdate,createtime,createdate||' '||createtime as createtimes from workflow_requestbase , workflow_currentoperator , workflow_base" +sqlwhere+
					" and workflow_currentoperator.requestid = workflow_requestbase.requestid and workflow_currentoperator.userid=" +userid + " and workflow_currentoperator.usertype="+usertype+
					" and workflow_requestbase.workflowid = workflow_base.id and (workflow_base.isvalid='1' or workflow_base.isvalid='3') "+
					" ) t ";
				}else{
				formsql=" from ("+
					" select distinct workflow_requestbase.requestid ,requestname,creater,creatertype,createdate,createtime,createdate+' '+createtime as createtimes from workflow_requestbase , workflow_currentoperator , workflow_base" +sqlwhere+
					" and workflow_currentoperator.requestid = workflow_requestbase.requestid and workflow_currentoperator.userid=" +userid + " and workflow_currentoperator.usertype="+usertype+
					" and workflow_requestbase.workflowid = workflow_base.id and (workflow_base.isvalid='1' or workflow_base.isvalid='3') "+
					" ) t ";
			}
			}
			String orderby  = "createdate desc , createtime desc";
			String colString=
			 "<col width=\"0%\" hide=\"true\" transmethod=\"weaver.general.KnowledgeTransMethod.forHtml\" text=\"\" column=\"requestid\" />"+
			 "<col width=\"60%\" transmethod=\"weaver.workflow.request.RequestBrowser.getWfNewLink\" otherpara=\"column:requestid+"+user.getLanguage()+"\" text=\""+SystemEnv.getHtmlLabelName(648, user.getLanguage())+"\" column=\"requestname\"   />"+
			 "<col width=\"15%\" transmethod=\"weaver.workflow.request.RequestBrowser.getWfCreaterName\" otherpara=\"column:creatertype+"+user.getLanguage()+"\" text=\""+SystemEnv.getHtmlLabelName(882, user.getLanguage())+"\" column=\"creater\" />"+
			 "<col width=\"25%\" transmethod=\"weaver.general.KnowledgeTransMethod.forHtml\" text=\""+SystemEnv.getHtmlLabelName(1339, user.getLanguage())+"\" column=\"createtimes\" />";
			String tableString =
			" <table pageId=\""+PageIdConst.WF_WORKFLOW_REQUESTBROWSER+"\" instanceid=\"workflowbaseTable\" tabletype=\"none\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.WF_WORKFLOW_REQUESTBROWSER,user.getUID())+"\" >"+
			" <checkboxpopedom  id=\"checkbox\" />"+
            " <sql backfields=\""+backfields+"\" sqlform=\""+Util.toHtmlForSplitPage(formsql)+"\" sqlwhere=\"\" sqlorderby=\""+orderby+"\"  sqlprimarykey=\"requestid\" sqlsortway=\"ASC\" sqlisdistinct=\"true\" />"+
            " <head>"+colString+"</head>"+
            " </table>";
		%>
		<wea:SplitPageTag  tableString='<%=tableString%>' isShowTopInfo="false"  mode="run"/>
	</wea:item>
</wea:group>
</wea:layout>
<input type="hidden" name="pageId" id="pageId" _showCol="false" value="<%=PageIdConst.WF_WORKFLOW_REQUESTBROWSER %>"/>
<input type="hidden" name="f_weaver_belongto_userid" value="<%=f_weaver_belongto_userid %>">
			<input type="hidden" name="f_weaver_belongto_usertype" value="f_weaver_belongto_usertype">
</FORM>
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout needImportDefaultJsAndCss="false">
		<wea:group context="" attributes='{\"groupDisplay\":\"none\"}'>
			<wea:item type="toolbar">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(311, user.getLanguage())%>"
					 accessKey="2" id="btnclear" class="zd_btn_submit" onclick="submitClear()" />
				
					  <input type="button" class=zd_btn_submit  id=btncancel onclick="btncancel_onclick();" value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>">
			</wea:item>
		</wea:group>
	</wea:layout>
	<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);
		});
	</script>
</div>
<script type="text/javascript" src="/js/browser/WorkFlowBrowser_wev8.js"></script>
<script type="text/javascript">
var parentWin = null;
var dialog = null;
try{
	parentWin = parent.parent.getParentWindow(parent);
	dialog = parent.parent.getDialog(parent);
}catch(e){}

function onResetwf(){
	document.SearchForm.reset();
	var workflowidname=document.getElementById("workflowidname").value;
	jQuery("#workflowspan").html(workflowidname);
	
	var creaternamest=document.getElementById("creaternamest").value;
	jQuery("#createrspan").html(creaternamest);
	 
	var departmentname=document.getElementById("departmentname").value;
	jQuery("#departmentspan").html(departmentname);
	 
	var subidname=document.getElementById("subidname").value;
	jQuery("#subentspan").html(subidname);
	 
	var createdatestarts01=document.getElementById("createdatestarts01").value;
	jQuery("#createdatestartspan").html(createdatestarts01);
	 
	var createdateends02=document.getElementById("createdateends02").value;
	jQuery("#createdateendspan").html(createdateends02);
	
	var crmidsnames=document.getElementById("crmidsnames").value;
	jQuery("#crmidsSpan").html(crmidsnames);
	 
	var prjidsnames=document.getElementById("prjidsnames").value;
	jQuery("#prjidsSpan").html(prjidsnames);
}

function afterDoWhenLoaded(){
	jQuery(".ListStyle").children("tbody").find("tr[class!='Spacing']").bind("click",function(){
	    var name = $(this).find("td:eq(2)").html().trim();
	    if(name.indexOf("<font>")!=-1){
	        name = name.substring(0,name.indexOf("<font>"));
	    }
		var returnjson = {id:$(this).find("td:eq(1)").text().trim(),name:name};
		if(dialog){
		    try{
		        dialog.callback(returnjson);
		    }catch(e){}
			try{
		        dialog.close(returnjson);
			}catch(e){}
		}else{  
		    window.parent.returnValue  = returnjson;
		    window.parent.close();
		}		
	});
};

function submitClear(){
	var returnjson = {id:"",name:""}; 
	if(dialog){
	    try{
	        dialog.callback(returnjson);
	    }catch(e){}
		try{
	        dialog.close(returnjson);
		}catch(e){}
	}else{ 
	   	window.parent.returnValue = returnjson;
		window.parent.close();
	 }
}

function dosubmit(){
	document.getElementById("issearch").value="issearch";
	jQuery('select:disabled').attr('disabled', false);
	document.SearchForm.submit();
}

function btncancel_onclick(){
	if(dialog){
		dialog.close();
	}else{
			window.parent.close();
	}
}
</script>
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</BODY>
</HTML>
