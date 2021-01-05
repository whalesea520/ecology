
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<%
char flag = 2;
String ProcPara = "";

String method = Util.null2String(request.getParameter("method"));
String meetingtype=Util.null2String(request.getParameter("meetingtype"));
int subcompanyid = Util.getIntValue(request.getParameter("subcompanyid"),user.getUserSubCompany1());
if(method.equals("add"))
{
	String memberid=Util.null2String(request.getParameter("memberid"));
	String membertype=Util.null2String(request.getParameter("membertype"));
	String desc=Util.null2String(request.getParameter("desc"));
	
	ProcPara =  meetingtype + flag + membertype + flag + memberid + flag + desc;
	RecordSet.executeProc("Meeting_Member_Insert",ProcPara);

	response.sendRedirect("/meeting/Maint/MeetingMember.jsp?meetingtype="+meetingtype+"&subCompanyId="+subcompanyid);
	return;
}

String MeetingMemberIDs[]=request.getParameterValues("MeetingMemberIDs");
if(method.equals("delete"))
{
	if(MeetingMemberIDs != null)
	{
		for(int i=0;i<MeetingMemberIDs.length;i++)
		{
			ProcPara = MeetingMemberIDs[i];
			RecordSet.executeProc("Meeting_Member_Delete",ProcPara);

		}
	}

	response.sendRedirect("/meeting/Maint/MeetingMember.jsp?meetingtype="+meetingtype+"&subCompanyId="+subcompanyid);
	return;
}
%>
