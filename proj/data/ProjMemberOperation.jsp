
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Timestamp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<%
char flag = 2;
String ProcPara = "";
String CurrentUser = ""+user.getUID();
String ClientIP = request.getRemoteAddr();

Date newdate = new Date() ;
long datetime = newdate.getTime() ;
Timestamp timestamp = new Timestamp(datetime) ;
String CurrentDate = (timestamp.toString()).substring(0,4) + "-" + (timestamp.toString()).substring(5,7) + "-" +(timestamp.toString()).substring(8,10);
String CurrentTime = (timestamp.toString()).substring(11,13) + ":" + (timestamp.toString()).substring(14,16) + ":" +(timestamp.toString()).substring(17,19);

String method = Util.null2String(request.getParameter("method"));

String projid=Util.fromScreen(request.getParameter("projid"),user.getLanguage());
String resourceid=Util.fromScreen(request.getParameter("resourceid"),user.getLanguage());
String begindate=Util.null2String(request.getParameter("begindate"));
String enddate=Util.null2String(request.getParameter("enddate"));
String ismanager=Util.fromScreen(request.getParameter("ismanager"),user.getLanguage());

if(method.equals("add"))
{
	ProcPara = projid;
	ProcPara += flag+resourceid;
	ProcPara += flag+begindate;
	ProcPara += flag+enddate;
	ProcPara += flag+ismanager;
	RecordSet.executeProc("Prj_Member_Insert",ProcPara);

	ProcPara = projid+flag+"aMember";
	ProcPara += flag+resourceid+flag+CurrentDate+flag+CurrentTime+flag+""+flag+"";
	ProcPara += flag+CurrentUser+flag+ClientIP;
	RecordSet.executeProc("Prj_Modify_Insert",ProcPara);

	response.sendRedirect("/proj/data/ViewProject.jsp?ProjID="+projid);
	return;
}
if(method.equals("edit"))
{
	ProcPara = projid;
	ProcPara += flag+resourceid;
	ProcPara += flag+begindate;
	ProcPara += flag+enddate;
	RecordSet.executeProc("Prj_Member_Update",ProcPara);

	response.sendRedirect("/proj/data/ViewProject.jsp?ProjID="+projid);
	return;
}
if(method.equals("delete"))
{
	ProcPara = projid;
	ProcPara += flag+resourceid;
	ProcPara += flag+"0";
	RecordSet.executeProc("Prj_Member_Delete",ProcPara);

	ProcPara = projid+flag+"dMember";
	ProcPara += flag+resourceid+flag+CurrentDate+flag+CurrentTime+flag+""+flag+"";
	ProcPara += flag+CurrentUser+flag+ClientIP;
	RecordSet.executeProc("Prj_Modify_Insert",ProcPara);

	response.sendRedirect("/proj/data/ViewProject.jsp?ProjID="+projid);
	return;
}
%>
