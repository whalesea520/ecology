
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.sql.Timestamp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
char flag = 2 ;
String ProcPara = "";
String method = Util.null2String(request.getParameter("method"));
String taskrecordid = Util.null2String(request.getParameter("taskrecordid"));
String ProjID=Util.null2String(request.getParameter("ProjID"));
String taskid=Util.null2String(request.getParameter("taskid"));
String version=Util.null2String(request.getParameter("version"));
String isactived=Util.null2String(request.getParameter("isactived"));
String docid=Util.null2String(request.getParameter("docid"));
String type=Util.null2String(request.getParameter("type"));

if (method.equals("add"))
{
	ProcPara = ProjID ;
	ProcPara += flag  + taskid ;
	ProcPara += flag  + version ;
	ProcPara += flag  + isactived ;
	ProcPara += flag  + docid ;
	ProcPara += flag  + type ;

	RecordSet.executeProc("Prj_Doc_Insert",ProcPara);

	if(type.equals("1"))
		response.sendRedirect("/proj/plan/ViewTask.jsp?log=n&taskrecordid="+taskrecordid);
	else if(type.equals("2"))
		response.sendRedirect("/proj/plan/ViewTaskProcess.jsp?log=n&taskrecordid="+taskrecordid);

}

%>