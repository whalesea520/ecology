<%@page import="weaver.fna.interfaces.thread.FnaBudgetTypeBatchOpThread"%>
<%@page import="java.io.File"%>
<%@page import="weaver.fna.general.FnaSubjectInitE8"%>
<%@page import="weaver.file.FileUpload"%><%@page import="weaver.general.BaseBean"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %><%@ page import="weaver.general.Util" %>
<%@page import="weaver.hrm.HrmUserVarify"%><%@page import="weaver.hrm.User"%>
<%
BaseBean bb = new BaseBean();

User user = HrmUserVarify.getUser (request , response) ;

boolean canEdit = HrmUserVarify.checkUserRight("FnaLedgerAdd:Add",user) || HrmUserVarify.checkUserRight("FnaLedgerEdit:Edit",user);
if(!canEdit){
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}

FileUpload fu = new FileUpload(request,false);
String operation = Util.null2String(fu.getParameter("operation")).trim();
String _guid1 = Util.null2String(fu.getParameter("_guid1")).trim();
int keyWord = Util.getIntValue(fu.getParameter("keyWord"), -1);
int impType = Util.getIntValue(fu.getParameter("impType"), -1);

int fileid = Util.getIntValue(fu.uploadFiles("filename"),0);
String uploadFileName = fu.getFileName();
String excelfile_path = request.getRealPath(request.getServletPath().substring(0,request.getServletPath().lastIndexOf("/")));


FnaBudgetTypeBatchOpThread fnaBudgetTypeBatchOpThread = new FnaBudgetTypeBatchOpThread();

fnaBudgetTypeBatchOpThread.setUser(user);
fnaBudgetTypeBatchOpThread.setGuid(_guid1);

fnaBudgetTypeBatchOpThread.setOperation(operation);
fnaBudgetTypeBatchOpThread.setKeyWord(keyWord);
fnaBudgetTypeBatchOpThread.setImpType(impType);
fnaBudgetTypeBatchOpThread.setFileid(fileid);
fnaBudgetTypeBatchOpThread.setUploadFileName(uploadFileName);
fnaBudgetTypeBatchOpThread.setExcelfile_path(excelfile_path);

fnaBudgetTypeBatchOpThread.setIsprint(false);


Thread thread_1 = new Thread(fnaBudgetTypeBatchOpThread);
thread_1.start();

%>