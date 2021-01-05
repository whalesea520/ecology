<%@page import="weaver.fna.interfaces.thread.FnaLoanRepaymentAnalysisOpThread"%>
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

int datetype = Util.getIntValue(Util.null2String(request.getParameter("datetype")));
String fromdate = Util.null2String(request.getParameter("fromdate")).trim();
String todate = Util.null2String(request.getParameter("todate")).trim();

String subId = Util.null2String(request.getParameter("subId")).trim();
String deptId = Util.null2String(request.getParameter("deptId")).trim();
String hrmId = Util.null2String(request.getParameter("hrmId")).trim();






FnaLoanRepaymentAnalysisOpThread fnaLoanRepaymentAnalysisOpThread = new FnaLoanRepaymentAnalysisOpThread();

fnaLoanRepaymentAnalysisOpThread.setUser(user);
fnaLoanRepaymentAnalysisOpThread.setGuid(_guid1);

fnaLoanRepaymentAnalysisOpThread.setDatetype(datetype);
fnaLoanRepaymentAnalysisOpThread.setFromdate(fromdate);
fnaLoanRepaymentAnalysisOpThread.setTodate(todate);
fnaLoanRepaymentAnalysisOpThread.setSubId(subId);
fnaLoanRepaymentAnalysisOpThread.setDeptId(deptId);
fnaLoanRepaymentAnalysisOpThread.setHrmId(hrmId);




fnaLoanRepaymentAnalysisOpThread.setIsprint(false);



Thread thread_1 = new Thread(fnaLoanRepaymentAnalysisOpThread);
thread_1.start();





































%>