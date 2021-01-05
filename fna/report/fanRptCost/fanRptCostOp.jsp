
<%@page import="weaver.fna.interfaces.thread.FnaFanRptCostOpThread"%>
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



String requestmark=Util.null2String(request.getParameter("requestmark")).trim();
String requestname=Util.null2String(request.getParameter("requestname")).trim();
String creater=Util.null2String(request.getParameter("creater")).trim();
String fromdate=Util.null2String(request.getParameter("fromdate")).trim();
String todate=Util.null2String(request.getParameter("todate")).trim();
int feeType=Util.getIntValue(request.getParameter("feeType"),-1);
String sumAmt1=Util.null2String(request.getParameter("sumAmt1"));
String sumAmt2=Util.null2String(request.getParameter("sumAmt2"));
int orgType = Util.getIntValue(request.getParameter("orgType"), -1);
String subId = Util.null2String(request.getParameter("subId")).trim();
String depId = Util.null2String(request.getParameter("depId")).trim();
String hrmId = Util.null2String(request.getParameter("hrmId")).trim();
String fccId = Util.null2String(request.getParameter("fccId")).trim();
String subjectId = Util.null2String(request.getParameter("subjectId")).trim();
String crmids=Util.null2String(request.getParameter("crmids")).trim();
String prjids=Util.null2String(request.getParameter("prjids")).trim();

String fromOccurDate=Util.null2String(request.getParameter("fromOccurDate")).trim();
String toOccurDate=Util.null2String(request.getParameter("toOccurDate")).trim();

String fromReceivedate=Util.null2String(request.getParameter("fromReceivedate")).trim();
String toReceivedate=Util.null2String(request.getParameter("toReceivedate")).trim();
String receivedateselect = Util.getIntValue(request.getParameter("receivedateselect"), 6)+"";

String createdateselect = Util.getIntValue(request.getParameter("createdateselect"), 6)+"";






FnaFanRptCostOpThread fnaFanRptCostOpThread = new FnaFanRptCostOpThread();

fnaFanRptCostOpThread.setUser(user);
fnaFanRptCostOpThread.setGuid(_guid1);

fnaFanRptCostOpThread.setRequestmark(requestmark);
fnaFanRptCostOpThread.setRequestname(requestname);
fnaFanRptCostOpThread.setCreater(creater);
fnaFanRptCostOpThread.setFromdate(fromdate);
fnaFanRptCostOpThread.setTodate(todate);
fnaFanRptCostOpThread.setFeeType(feeType);
fnaFanRptCostOpThread.setSumAmt1(sumAmt1);
fnaFanRptCostOpThread.setSumAmt2(sumAmt2);
fnaFanRptCostOpThread.setOrgType(orgType);
fnaFanRptCostOpThread.setSubId(subId);
fnaFanRptCostOpThread.setDepId(depId);
fnaFanRptCostOpThread.setHrmId(hrmId);
fnaFanRptCostOpThread.setFccId(fccId);
fnaFanRptCostOpThread.setSubjectId(subjectId);
fnaFanRptCostOpThread.setCrmids(crmids);
fnaFanRptCostOpThread.setPrjids(prjids);
fnaFanRptCostOpThread.setFromOccurDate(fromOccurDate);
fnaFanRptCostOpThread.setToOccurDate(toOccurDate);
fnaFanRptCostOpThread.setFromReceivedate(fromReceivedate);
fnaFanRptCostOpThread.setToReceivedate(toReceivedate);
fnaFanRptCostOpThread.setReceivedateselect(receivedateselect);
fnaFanRptCostOpThread.setCreatedateselect(createdateselect);




fnaFanRptCostOpThread.setIsprint(false);



Thread thread_1 = new Thread(fnaFanRptCostOpThread);
thread_1.start();































%>