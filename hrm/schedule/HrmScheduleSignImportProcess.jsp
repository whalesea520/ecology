
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util,weaver.file.*,java.util.*" %>
<%@page import="weaver.hrm.schedule.HrmScheduleSignImport"%>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<%
	if (!HrmUserVarify.checkUserRight("HrmDefaultScheduleEdit:Edit",
			user)) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
%>
<%
	StaticObj staticObj=StaticObj.getInstance(); 
  FileUploadToPath fu = new FileUploadToPath(request) ; 
	HrmScheduleSignImport hrmScheduleSignImport = new HrmScheduleSignImport(fu);
	hrmScheduleSignImport.setUserlanguage(user.getLanguage());
	List errorInfo =hrmScheduleSignImport.ScanFile(fu);
	hrmScheduleSignImport.ExcelToDB(fu);
	if(errorInfo.isEmpty()){
		errorInfo.add(SystemEnv.getHtmlLabelName(28450,user.getLanguage()));
		staticObj.putObject("signErrorInfo",errorInfo);
		response.sendRedirect("/hrm/schedule/HrmScheduleSignImportLog.jsp");
		return;
	}else{
		staticObj.putObject("signErrorInfo",errorInfo);
		response.sendRedirect("/hrm/schedule/HrmScheduleSignImportLog.jsp");
		return;
	}
%>