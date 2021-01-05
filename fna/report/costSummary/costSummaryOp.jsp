<%@page import="weaver.fna.interfaces.thread.FnaCostSummaryOpThread"%>
<%@page import="weaver.fna.maintenance.FnaYearsPeriodsComInfo"%>
<%@page import="weaver.fna.maintenance.FnaSystemSetComInfo"%>
<%@page import="weaver.fna.general.FnaRptRuleSet"%><%@page import="weaver.fna.general.FnaCommon"%>
<%@page import="weaver.fna.report.FnaReport"%>
<%@page import="weaver.fna.budget.Expense"%>
<%@page import="weaver.fna.maintenance.FnaCostCenter"%>
<%@page import="weaver.fna.general.FnaBudgetLeftRuleSet"%>
<%@page import="weaver.fna.budget.FnaBudgetBatchObj"%><%@page import="weaver.fna.maintenance.BudgetfeeTypeComInfo"%><%@page import="org.apache.poi.hssf.usermodel.HSSFCell"%><%@page import="org.apache.poi.hssf.usermodel.HSSFRow"%><%@page import="org.apache.poi.hssf.usermodel.HSSFSheet"%><%@page import="org.apache.poi.hssf.usermodel.HSSFWorkbook"%><%@page import="org.apache.poi.poifs.filesystem.POIFSFileSystem"%><%@page import="java.io.FileInputStream"%><%@page import="weaver.file.FileManage"%><%@page import="weaver.file.FileUpload"%><%@page import="java.lang.Exception"%><%@page import="weaver.systeminfo.SystemEnv"%><%@page import="weaver.fna.budget.FnaBudgetUtil"%><%@page import="weaver.fna.maintenance.FnaBudgetInfoComInfo"%><%@page import="weaver.fna.budget.BudgetHandler"%><%@page import="weaver.fna.maintenance.FnaBudgetControl"%><%@page import="weaver.hrm.company.CompanyComInfo"%><%@page import="weaver.hrm.company.SubCompanyComInfo"%><%@page import="weaver.hrm.company.DepartmentComInfo"%><%@page import="weaver.hrm.resource.ResourceComInfo"%><%@page import="weaver.conn.RecordSet"%><%@page import="org.apache.commons.lang.StringEscapeUtils"%><%@page import="java.text.DecimalFormat"%><%@ page import="weaver.fna.maintenance.FnaBudgetInfo" %><%@page import="java.text.SimpleDateFormat"%><%@page import="weaver.general.BaseBean"%><%@page import="weaver.general.TimeUtil"%><%@page import="org.json.JSONObject"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %><%@ page import="weaver.general.Util" %><%@ page import="java.util.*,java.sql.Timestamp" %><%@ page import="weaver.general.GCONST" %><%@page import="weaver.hrm.HrmUserVarify"%><%@page import="weaver.hrm.User"%>
<%
BaseBean bb = new BaseBean();


User user = HrmUserVarify.getUser (request , response) ;
String _guid1 = Util.null2String(request.getParameter("_guid1")).trim();


int fnayear=Util.getIntValue(request.getParameter("fnayear"),0);
int orgType = Util.getIntValue(request.getParameter("orgType"), -1);
String subId = Util.null2String(request.getParameter("subId")).trim();
String depId = Util.null2String(request.getParameter("depId")).trim();
String hrmId = Util.null2String(request.getParameter("hrmId")).trim();
String fccId = Util.null2String(request.getParameter("fccId")).trim();
String subjectId = Util.null2String(request.getParameter("subjectId")).trim();
int sumSubOrg=Util.getIntValue(request.getParameter("sumSubOrg"),0);
int groupFeeperiod=Util.getIntValue(request.getParameter("groupFeeperiod"),1);
String fromdate=Util.null2String(request.getParameter("fromdate")).trim();
String todate=Util.null2String(request.getParameter("todate")).trim();
String createdateselect = Util.getIntValue(request.getParameter("createdateselect"), 6)+"";
String qAll = Util.null2String(request.getParameter("qAll")).trim();

List<Integer> mQ_list = new ArrayList<Integer>();
for(int i=1;i<=12;i++){
	int _q = Util.getIntValue(request.getParameter("mQ"+i), 0);
	mQ_list.add(_q);
}
List<Integer> qQ_list = new ArrayList<Integer>();
for(int i=1;i<=4;i++){
	int _q = Util.getIntValue(request.getParameter("qQ"+i), 0);
	qQ_list.add(_q);
}
List<Integer> hQ_list = new ArrayList<Integer>();
for(int i=1;i<=2;i++){
	int _q = Util.getIntValue(request.getParameter("hQ"+i), 0);
	hQ_list.add(_q);
}
List<Integer> yQ_list = new ArrayList<Integer>();
if(true){
	int _q = Util.getIntValue(request.getParameter("yQ1"), 0);
	yQ_list.add(_q);
}



FnaCostSummaryOpThread fnaCostSummaryOpThread = new FnaCostSummaryOpThread();

fnaCostSummaryOpThread.setUser(user);
fnaCostSummaryOpThread.setGuid(_guid1);

fnaCostSummaryOpThread.setOrgType(orgType);
fnaCostSummaryOpThread.setSubId(subId);
fnaCostSummaryOpThread.setDepId(depId);
fnaCostSummaryOpThread.setHrmId(hrmId);
fnaCostSummaryOpThread.setFccId(fccId);
fnaCostSummaryOpThread.setSubjectId(subjectId);
fnaCostSummaryOpThread.setFnayear(fnayear);
fnaCostSummaryOpThread.setqAll(qAll);
fnaCostSummaryOpThread.setSumSubOrg(sumSubOrg);
fnaCostSummaryOpThread.setmQ_list(mQ_list);
fnaCostSummaryOpThread.setqQ_list(qQ_list);
fnaCostSummaryOpThread.sethQ_list(hQ_list);
fnaCostSummaryOpThread.setyQ_list(yQ_list);

fnaCostSummaryOpThread.setGroupFeeperiod(groupFeeperiod);
fnaCostSummaryOpThread.setFromdate(fromdate);
fnaCostSummaryOpThread.setTodate(todate);
fnaCostSummaryOpThread.setCreatedateselect(createdateselect);

fnaCostSummaryOpThread.setIsprint(false);



Thread thread_1 = new Thread(fnaCostSummaryOpThread);
thread_1.start();





































%>