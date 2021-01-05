
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
if(!HrmUserVarify.checkUserRight("WorktaskManage:All", user)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}

String sql = "";
int wtid = Util.getIntValue(request.getParameter("wtid"), 0);
String operation = Util.null2String(request.getParameter("operation"));
if("editapprovewf".equals(operation)){
	int useapprovewf = Util.getIntValue(request.getParameter("useapprovewf"), 0);
	int approvewf = Util.getIntValue(request.getParameter("approvewf"), 0);
	if(useapprovewf == 0){
		approvewf = 0;
	}
	sql = "update worktask_base set useapprovewf="+useapprovewf+", approvewf="+approvewf+" where id="+wtid;
	//System.out.println(sql);
	rs.execute(sql);
	response.sendRedirect("WTApproveWfEdit.jsp?wtid="+wtid);
	return;
}


response.sendRedirect("WTApproveWfEdit.jsp?wtid="+wtid);

%>