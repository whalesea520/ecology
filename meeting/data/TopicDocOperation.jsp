
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />

<%

char flag = 2;
String ProcPara = "";

String method = Util.null2String(request.getParameter("method"));
String meetingid=Util.null2String(request.getParameter("meetingid"));
String topicid=Util.null2String(request.getParameter("topicid"));
String docid=Util.null2String(request.getParameter("docid"));
String id=Util.null2String(request.getParameter("id"));

if(method.equals("add"))
{
	ProcPara =  meetingid;
	ProcPara += flag + topicid;
	ProcPara += flag + docid;
	ProcPara += flag + "" + user.getUID();

	RecordSet.executeProc("Meeting_TopicDoc_Insert",ProcPara);

	//response.sendRedirect("/meeting/data/ViewMeeting.jsp?meetingid="+meetingid);
	//return;
	%>
	<script>
     	var parentWin = parent.getParentWindow(window);
     	parentWin.location="ProcessMeeting.jsp?tab=1&meetingid=<%=meetingid%>&showdiv=agendaDiv";
     	parentWin.diag_vote.close();
	</script>
	<%
}


if(method.equals("delete"))
{

	RecordSet.executeProc("Meeting_TopicDoc_Delete",id);

	response.sendRedirect("ProcessMeeting.jsp?tab=1&showdiv=agendaDiv&meetingid="+meetingid);
	return;
	
}

%>
