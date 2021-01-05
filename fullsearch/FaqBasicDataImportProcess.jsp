<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.file.*"%>
<%@ page import="weaver.faq.excelImport.ImportProcess"%>
<%@page import="weaver.matrix.MatrixUtil"%>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<%
	/*已在外部控制
	if (!HrmUserVarify.checkUserRight("HrmResourceEdit:Edit",user)) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}*/
%>
<%
  FileUploadToPath fu = new FileUploadToPath(request) ; 
  String importtype = Util.null2String(fu.getParameter("importtype")); 
  //导入类型  添加|更新
  ImportProcess ImportProcess = new ImportProcess();
  ImportProcess.importXls(fu,session);
  session.setAttribute("importStatus","over");
%>


