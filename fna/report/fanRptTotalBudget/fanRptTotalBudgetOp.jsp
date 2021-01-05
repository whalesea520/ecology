<%@page import="weaver.fna.interfaces.thread.FnaFanRptTotalBudgetOpThread"%>
<%@page import="weaver.fna.maintenance.FnaSystemSetComInfo"%>
<%@page import="weaver.fna.maintenance.FnaYearsPeriodsComInfo"%>
<%@page import="weaver.fna.general.FnaCommon"%>
<%@page import="weaver.fna.general.FnaRptRuleSet"%><%@page import="weaver.fna.report.FnaReport"%>
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
String subjectIds = Util.null2String(request.getParameter("subjectIds")).trim();
int sumSubOrg=Util.getIntValue(request.getParameter("sumSubOrg"),0);
int groupFeeperiod=Util.getIntValue(request.getParameter("groupFeeperiod"),1);



FnaFanRptTotalBudgetOpThread fnaFanRptTotalBudgetOpThread = new FnaFanRptTotalBudgetOpThread();

fnaFanRptTotalBudgetOpThread.setUser(user);
fnaFanRptTotalBudgetOpThread.setGuid(_guid1);

fnaFanRptTotalBudgetOpThread.setFnayear(fnayear);
fnaFanRptTotalBudgetOpThread.setOrgType(orgType);
fnaFanRptTotalBudgetOpThread.setSubId(subId);
fnaFanRptTotalBudgetOpThread.setDepId(depId);
fnaFanRptTotalBudgetOpThread.setHrmId(hrmId);
fnaFanRptTotalBudgetOpThread.setFccId(fccId);
fnaFanRptTotalBudgetOpThread.setSubjectIds(subjectIds);
fnaFanRptTotalBudgetOpThread.setSumSubOrg(sumSubOrg);
fnaFanRptTotalBudgetOpThread.setGroupFeeperiod(groupFeeperiod);

fnaFanRptTotalBudgetOpThread.setIsprint(false);



Thread thread_1 = new Thread(fnaFanRptTotalBudgetOpThread);
thread_1.start();




































%>