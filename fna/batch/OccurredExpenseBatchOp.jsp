<%@page import="weaver.fna.interfaces.thread.OccurredExpenseBatchOpThread"%>
<%@page import="java.util.regex.Matcher"%>
<%@page import="java.util.regex.Pattern"%>
<%@page import="weaver.fna.maintenance.BudgetfeeTypeComInfo"%>
<%@page import="org.apache.poi.hssf.usermodel.HSSFCell"%>
<%@page import="org.apache.poi.hssf.usermodel.HSSFRow"%>
<%@page import="org.apache.poi.hssf.usermodel.HSSFSheet"%>
<%@page import="org.apache.poi.hssf.usermodel.HSSFWorkbook"%>
<%@page import="org.apache.poi.poifs.filesystem.POIFSFileSystem"%>
<%@page import="java.io.FileInputStream"%>
<%@page import="java.util.*"%>
<%@page import="weaver.file.FileManage"%>
<%@page import="weaver.file.FileUpload"%>
<%@page import="java.lang.Exception"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%@page import="weaver.hrm.company.CompanyComInfo"%>
<%@page import="weaver.hrm.company.SubCompanyComInfo"%>
<%@page import="weaver.hrm.company.DepartmentComInfo"%>
<%@page import="weaver.hrm.resource.ResourceComInfo"%>
<%@page import="weaver.conn.RecordSet"%>
<%@page import="org.apache.commons.lang.StringEscapeUtils"%>
<%@page import="java.text.*"%>
<%@page import="weaver.general.BaseBean"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*,java.sql.Timestamp" %>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<%
User user = HrmUserVarify.getUser (request , response) ;

boolean canEdit = HrmUserVarify.checkUserRight("FnaOccurredExpenseImport:Add",user);
if(!canEdit){
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}

FileUpload fu = new FileUpload(request,false);
String operation = Util.null2String(fu.getParameter("operation")).trim();
String _guid1 = Util.null2String(fu.getParameter("_guid1")).trim();
int keyWord = Util.getIntValue(fu.getParameter("keyWord"), -1);
int keyWord2 = Util.getIntValue(fu.getParameter("keyWord2"), -1);
int fileid = Util.getIntValue(fu.uploadFiles("filename"),0);
String uploadFileName = fu.getFileName();
String excelfile_path = request.getRealPath(request.getServletPath().substring(0,request.getServletPath().lastIndexOf("/")));


OccurredExpenseBatchOpThread occurredExpenseBatchOpThread = new OccurredExpenseBatchOpThread();

occurredExpenseBatchOpThread.setUser(user);
occurredExpenseBatchOpThread.setGuid(_guid1);

occurredExpenseBatchOpThread.setOperation(operation);
occurredExpenseBatchOpThread.setKeyWord(keyWord);
occurredExpenseBatchOpThread.setKeyWord2(keyWord2);
occurredExpenseBatchOpThread.setFileid(fileid);
occurredExpenseBatchOpThread.setUploadFileName(uploadFileName);
occurredExpenseBatchOpThread.setExcelfile_path(excelfile_path);

occurredExpenseBatchOpThread.setIsprint(false);


Thread thread_1 = new Thread(occurredExpenseBatchOpThread);
thread_1.start();





%>