
<%@page import="weaver.fna.interfaces.thread.FnaBudgetBatchImportOpThread"%>
<%@page import="weaver.fna.general.FnaSynchronized"%>
<%@page import="weaver.fna.general.FnaLanguage"%><%@page import="weaver.fna.maintenance.FnaCostCenter"%>
<%@page import="weaver.fna.general.FnaBudgetLeftRuleSet"%>
<%@page import="weaver.fna.budget.FnaBudgetBatchObj"%><%@page import="weaver.fna.maintenance.BudgetfeeTypeComInfo"%><%@page import="org.apache.poi.hssf.usermodel.HSSFCell"%><%@page import="org.apache.poi.hssf.usermodel.HSSFRow"%><%@page import="org.apache.poi.hssf.usermodel.HSSFSheet"%><%@page import="org.apache.poi.hssf.usermodel.HSSFWorkbook"%><%@page import="org.apache.poi.poifs.filesystem.POIFSFileSystem"%><%@page import="java.io.FileInputStream"%><%@page import="weaver.file.FileManage"%><%@page import="weaver.file.FileUpload"%><%@page import="java.lang.Exception"%><%@page import="weaver.systeminfo.SystemEnv"%><%@page import="weaver.fna.budget.FnaBudgetUtil"%><%@page import="weaver.fna.maintenance.FnaBudgetInfoComInfo"%><%@page import="weaver.fna.budget.BudgetHandler"%><%@page import="weaver.fna.maintenance.FnaBudgetControl"%><%@page import="weaver.hrm.company.CompanyComInfo"%><%@page import="weaver.hrm.company.SubCompanyComInfo"%><%@page import="weaver.hrm.company.DepartmentComInfo"%><%@page import="weaver.hrm.resource.ResourceComInfo"%><%@page import="weaver.conn.RecordSet"%><%@page import="org.apache.commons.lang.StringEscapeUtils"%><%@page import="java.text.DecimalFormat"%><%@ page import="weaver.fna.maintenance.FnaBudgetInfo" %><%@page import="java.text.SimpleDateFormat"%><%@page import="weaver.general.BaseBean"%><%@page import="weaver.general.TimeUtil"%><%@page import="org.json.JSONObject"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %><%@ page import="weaver.general.Util" %><%@ page import="java.util.*,java.sql.Timestamp" %><%@ page import="weaver.general.GCONST" %><%@page import="weaver.hrm.HrmUserVarify"%><%@page import="weaver.hrm.User"%>
<%
BaseBean bb = new BaseBean();
String result = "";

User user = HrmUserVarify.getUser (request , response) ;

boolean imp = HrmUserVarify.checkUserRight("BudgetDraftBatchImport:imp", user);//预算草稿批量导入
if(!imp){
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}


FileUpload fu = new FileUpload(request,false);


String operation = Util.null2String(fu.getParameter("operation")).trim();
String _guid1 = Util.null2String(fu.getParameter("_guid1")).trim();
String budgetperiods = Util.null2String(fu.getParameter("budgetperiods")).trim();
int impType = Util.getIntValue(fu.getParameter("impType"));
int keyWord = Util.getIntValue(fu.getParameter("keyWord"), -1);//承担主体重复验证字段
int keyWord2 = Util.getIntValue(fu.getParameter("keyWord2"), -1);//科目重复验证字段

int fileid = Util.getIntValue(fu.uploadFiles("filename"),0);
String uploadFileName = fu.getFileName();
String excelfile_path = request.getRealPath(request.getServletPath().substring(0,request.getServletPath().lastIndexOf("/")));


FnaBudgetBatchImportOpThread fnaBudgetBatchImportOpThread = new FnaBudgetBatchImportOpThread();

fnaBudgetBatchImportOpThread.setUser(user);

fnaBudgetBatchImportOpThread.setImp(imp);

fnaBudgetBatchImportOpThread.setOperation(operation);
fnaBudgetBatchImportOpThread.setGuid(_guid1);
fnaBudgetBatchImportOpThread.setBudgetperiods(budgetperiods);
fnaBudgetBatchImportOpThread.setImpType(impType);
fnaBudgetBatchImportOpThread.setKeyWord(keyWord);
fnaBudgetBatchImportOpThread.setKeyWord2(keyWord2);

fnaBudgetBatchImportOpThread.setFileid(fileid);
fnaBudgetBatchImportOpThread.setUploadFileName(uploadFileName);
fnaBudgetBatchImportOpThread.setExcelfile_path(excelfile_path);

fnaBudgetBatchImportOpThread.setIsprint(false);


Thread thread_1 = new Thread(fnaBudgetBatchImportOpThread);
thread_1.start();



























%><%=result %>