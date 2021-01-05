<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.file.*"%>
<%@ page import="weaver.hrm.excelimport.ImportProcess"%>
<%@page import="weaver.matrix.MatrixUtil"%>
<%@page import="weaver.hrm.group.HrmGroupMemberImport"%>
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
  //导入类型  添加|更新
  
	HrmGroupMemberImport hrmGroupMemberImport = new HrmGroupMemberImport(fu);
	hrmGroupMemberImport.setUserlanguage(user.getLanguage());
	hrmGroupMemberImport.ExcelToDB(fu,session);
  	session.setAttribute("importStatus","over");
%>


