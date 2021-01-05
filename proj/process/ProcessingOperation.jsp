
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.sql.Timestamp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
String method = request.getParameter("method");

String id=Util.null2String(request.getParameter("id"));
String prjid=Util.null2String(request.getParameter("prjid"));
String planid=Util.null2String(request.getParameter("planid"));
String title=Util.null2String(request.getParameter("title"));
String content=Util.null2String(request.getParameter("content"));
String type=Util.null2String(request.getParameter("type"));
String docid=Util.null2String(request.getParameter("docid"));
String parentids=Util.null2String(request.getParameter("parentids"));

String CurrentUser = ""+user.getUID();
	Date newdate = new Date() ;
	long datetime = newdate.getTime() ;
	Timestamp timestamp = new Timestamp(datetime) ;
	String CurrentDate = (timestamp.toString()).substring(0,4) + "-" + (timestamp.toString()).substring(5,7) + "-" +(timestamp.toString()).substring(8,10);
	String CurrentTime = (timestamp.toString()).substring(11,13) + ":" + (timestamp.toString()).substring(14,16) + ":" +(timestamp.toString()).substring(17,19);

if(method.equals("archive")){
	char flag=2;
	String para = id + flag + "1"+flag + CurrentDate + flag + CurrentTime
	 + flag + CurrentUser;
	RecordSet.executeProc("Prj_Processing_Archive",para);
	if(RecordSet.getFlag()!=1)
	{
		response.sendRedirect("/proj/DBError.jsp?type=Archive");
		return;
	}
}
else if (method.equals("add"))
{
	char flag=2;

	String para = prjid + flag + planid + flag + title
	+ flag + content + flag + type+  flag + docid+flag + parentids +flag + CurrentDate + flag + CurrentTime
	 + flag + CurrentUser;
	out.print(para);
	RecordSet.executeProc("Prj_Processing_Insert",para);
	if(RecordSet.getFlag()!=1)
	{
		response.sendRedirect("/proj/DBError.jsp?type=Insert");
		return;
	}
}
else if(method.equals("edit"))
{
	char flag=2;

	String para = id + flag +  title
	+ flag + content + flag + type+  flag + docid+flag + CurrentDate + flag + CurrentTime
	 + flag + CurrentUser;
	out.print(para);
	RecordSet.executeProc("Prj_Processing_Update",para);
	if(RecordSet.getFlag()!=1)
	{
		response.sendRedirect("/proj/DBError.jsp?type=Update");
		return;
	}

}
else
{
	response.sendRedirect("/CRM/DBError.jsp?type=Unknown");
	return;
}
response.sendRedirect("/proj/process/ViewProcessing.jsp?ProjID="+prjid);
%>