
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Timestamp" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="SysWorkflow" class="weaver.system.SysWorkflow" scope="page" />

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
String meetingid=Util.null2String(request.getParameter("meetingid"));
String topicid=Util.null2String(request.getParameter("recorderid"));


if(method.equals("edit"))
{
	ProcPara =  meetingid;
	ProcPara += flag + topicid;
	RecordSet.executeProc("Meeting_TopicDate_Delete",ProcPara);

	int decisionrows=Util.getIntValue(Util.null2String(request.getParameter("decisionrows")),0);
	for(int i=0;i<decisionrows;i++){

		String begindate=Util.null2String(request.getParameter("begindate_"+i));
		String begintime=Util.null2String(request.getParameter("begintime_"+i));
		String enddate=Util.null2String(request.getParameter("enddate_"+i));
		String endtime=Util.null2String(request.getParameter("endtime_"+i));

        //modified by lupeng 2004.2.2
        //the orginal source code is: if(!begindate.equals("") {
		if(!begindate.equals("") && (!begintime.equals("") || !endtime.equals(""))){
        //end
			ProcPara =  meetingid;
			ProcPara += flag + topicid;
			ProcPara += flag + begindate;
			ProcPara += flag + begintime;
			ProcPara += flag + enddate;
			ProcPara += flag + endtime;

			RecordSet.executeProc("Meeting_TopicDate_Insert",ProcPara);	

		}
	}
}
%>

<script>
     var parentWin = parent.parent.getParentWindow(window.parent);
     parentWin.refashTopicList();
     parentWin.diag_vote.close();
</script>


