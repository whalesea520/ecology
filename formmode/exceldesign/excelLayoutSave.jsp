
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.file.FileUpload,java.io.File"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ExcelLayoutManager" class="weaver.formmode.exceldesign.ExcelLayoutManager" scope="page"/>
<%
	FileUpload fu = new FileUpload(request, false, false, "filesystem/htmllayoutimages");

	int modeid = Util.getIntValue(fu.getParameter("modeid"), 0);
	int formid = Util.getIntValue(fu.getParameter("formid"), 0);
	int layouttype = Util.getIntValue(fu.getParameter("layouttype"), -1);
	int layoutid = Util.getIntValue(fu.getParameter("layoutid"), 0);
	int isdefault = Util.getIntValue(fu.getParameter("isdefault"), 0);

	int isform = Util.getIntValue(fu.getParameter("isform"), 0);
	//保存Excel模板
	ExcelLayoutManager.setFu(fu);
	ExcelLayoutManager.setUser(user);
	String operation=fu.getParameter("operation");
	if("saveExcel".equalsIgnoreCase(operation)){
		layoutid = ExcelLayoutManager.doSaveExcelInfo();
		String url="excelMain.jsp?modeid="+modeid+"&formid="+formid+"&layouttype="+layouttype+"&layoutid="+layoutid+"&isform="+isform+"&isdefault="+isdefault;
		response.sendRedirect(url);
	}
%>
