
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<%
char flag = 2;
String ProcPara = "";

String method = Util.null2String(request.getParameter("method"));
String meetingtype=Util.null2String(request.getParameter("meetingtype"));

if(method.equals("add"))
{
	String addressid=Util.null2String(request.getParameter("addressid"));
	String desc=Util.null2String(request.getParameter("desc"));
	
	ProcPara =  meetingtype + flag + addressid + flag + desc;
	RecordSet.executeProc("Meeting_Address_Insert",ProcPara);

	response.sendRedirect("/meeting/Maint/MeetingAddress.jsp?meetingtype="+meetingtype);
	return;
}

String MeetingAddressIDs[]=request.getParameterValues("MeetingAddressIDs");
if(method.equals("delete"))
{
	if(MeetingAddressIDs != null)
	{
		for(int i=0;i<MeetingAddressIDs.length;i++)
		{
			ProcPara = MeetingAddressIDs[i];
			RecordSet.executeProc("Meeting_Address_Delete",ProcPara);

		}
	}

	response.sendRedirect("/meeting/Maint/MeetingAddress.jsp?meetingtype="+meetingtype);
	return;
}
%>
