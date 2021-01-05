
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Timestamp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<%
char flag = 2;
String ProcPara = "";
String CurrentUser = ""+user.getUID();
String SubmiterType = ""+user.getLogintype();
String ClientIP = request.getRemoteAddr();

Date newdate = new Date() ;
long datetime = newdate.getTime() ;
Timestamp timestamp = new Timestamp(datetime) ;
String CurrentDate = (timestamp.toString()).substring(0,4) + "-" + (timestamp.toString()).substring(5,7) + "-" +(timestamp.toString()).substring(8,10);
String CurrentTime = (timestamp.toString()).substring(11,13) + ":" + (timestamp.toString()).substring(14,16) + ":" +(timestamp.toString()).substring(17,19);

String method = Util.null2String(request.getParameter("method"));

String ProjID=Util.null2String(request.getParameter("ProjID"));

if(method.equals("add"))
{
	String CustomerID=Util.null2String(request.getParameter("CustomerID"));
	int powerlevel=Util.getIntValue(Util.null2String(request.getParameter("powerlevel")),0);
	String reasondesc=Util.null2String(request.getParameter("reasondesc"));
	
	if(CustomerID.equals("0"))
	{
		response.sendRedirect("/proj/data/ViewCustomer.jsp?ProjID="+ProjID);
		return;
	}

	ProcPara = ProjID + flag + CustomerID + flag + powerlevel + flag + reasondesc;
	RecordSet.executeProc("Prj_Customer_Insert",ProcPara);

	ProcPara = ProjID+flag+"aCustomer";
	ProcPara += flag+CustomerID+flag+CurrentDate+flag+CurrentTime+flag+""+flag+"";
	ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
	RecordSet.executeProc("Prj_Modify_Insert",ProcPara);

	response.sendRedirect("/proj/data/ViewCustomer.jsp?ProjID="+ProjID);
	return;
}

String CustomerIDs[]=request.getParameterValues("CustomerIDs");
if(method.equals("delete"))
{
	if(CustomerIDs != null)
	{
		for(int i=0;i<CustomerIDs.length;i++)
		{
			ProcPara = ProjID + flag + CustomerIDs[i];
			RecordSet.executeProc("Prj_Customer_Delete",ProcPara);

			ProcPara = ProjID+flag+"dCustomer";
			ProcPara += flag+CustomerIDs[i]+flag+CurrentDate+flag+CurrentTime+flag+""+flag+"";
			ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
			RecordSet.executeProc("Prj_Modify_Insert",ProcPara);
		}
	}

	response.sendRedirect("/proj/data/ViewCustomer.jsp?ProjID="+ProjID);
	return;
}
%>
