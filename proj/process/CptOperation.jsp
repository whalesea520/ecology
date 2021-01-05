
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.sql.Timestamp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
char flag = 2 ;
String ProcPara = "";
String method = Util.null2String(request.getParameter("method"));
String ProjID=Util.null2String(request.getParameter("ProjID"));
String taskid=Util.null2String(request.getParameter("taskid"));
String requestid=Util.null2String(request.getParameter("requestid"));
String type=Util.null2String(request.getParameter("type"));

if (method.equals("add"))
{

	String tempsql="";
	tempsql="select * from Prj_Cpt where prjid='"+ProjID+"' and taskid='"+taskid+"' and requestid='"+requestid+"'";
	RecordSet.executeSql(tempsql);
	if(!RecordSet.next()){
		ProcPara = ProjID ;
		ProcPara += flag  + taskid ;
		ProcPara += flag  + requestid ;

		RecordSet.executeProc("Prj_Cpt_Insert",ProcPara);

		tempsql="update workflow_requestbase set prjids='"+ProjID+"' where requestid="+requestid;
		RecordSet.executeSql(tempsql);
	}

	if(type.equals("1"))
		response.sendRedirect("/proj/plan/ViewTask.jsp?log=n&taskrecordid="+taskid);
	else if(type.equals("2"))
		response.sendRedirect("/proj/process/ViewTask.jsp?log=n&taskrecordid="+taskid);

}

if (method.equals("del"))
{

	String id = Util.null2String(request.getParameter("id"));
	if(id.startsWith(",")){
		id=id.substring(1,id.length());
	}
	if(id.endsWith (",")){
		id=id.substring(0,id.length()-1);
	}
	
	String tempsql="delete Prj_Cpt  where id in ("+id+") ";
	RecordSet.executeSql(tempsql);
	
	if(type.equals("1"))
		response.sendRedirect("/proj/plan/ViewTask.jsp?log=n&taskrecordid="+taskid);
	else if(type.equals("2"))
		response.sendRedirect("/proj/process/ViewTask.jsp?log=n&taskrecordid="+taskid);

}

%>