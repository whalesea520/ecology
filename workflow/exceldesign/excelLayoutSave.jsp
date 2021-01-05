
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.file.FileUpload,java.io.File"%>
<%@ page import="weaver.workflow.workflow.WfRightManager"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ExcelLayoutManager" class="weaver.workflow.exceldesign.ExcelLayoutManager" scope="page"/>
<%
	FileUpload fu = new FileUpload(request, false, false, "filesystem/htmllayoutimages");

	int wfid = Util.getIntValue(fu.getParameter("wfid"), 0);
	WfRightManager wfrm = new WfRightManager();
	boolean haspermission = wfrm.hasPermission3(wfid, 0, user, WfRightManager.OPERATION_CREATEDIR);
	if (!HrmUserVarify.checkUserRight("WorkflowManage:All", user) && !haspermission) {
	    response.sendRedirect("/notice/noright.jsp") ;
	    return ;
	}
	int formid = Util.getIntValue(fu.getParameter("formid"), 0);
	int nodeid = Util.getIntValue(fu.getParameter("nodeid"), 0);
	int isbill = Util.getIntValue(fu.getParameter("isbill"), -1);
	int layouttype = Util.getIntValue(fu.getParameter("layouttype"), -1);

	int isform = Util.getIntValue(fu.getParameter("isform"), 0);
	//保存Excel模板
	ExcelLayoutManager.setFu(fu);
	ExcelLayoutManager.setUser(user);
	String operation=fu.getParameter("operation");
	if("saveExcel".equalsIgnoreCase(operation)){
		int modeid = ExcelLayoutManager.doSaveExcelInfo();
		String url="excelMain.jsp?wfid="+wfid+"&formid="+formid+"&nodeid="+nodeid+"&isbill="+isbill+"&layouttype="+layouttype+"&modeid="+modeid+"&isform="+isform;
		response.sendRedirect(url);
	}
%>
