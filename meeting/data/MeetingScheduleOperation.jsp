
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Timestamp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="SysRemindWorkflow" class="weaver.system.SysRemindWorkflow" scope="page" />
<%
String CurrentUser = ""+user.getUID();
String CurrentUserName = ""+user.getUsername();
String SubmiterType = ""+user.getLogintype();
String ClientIP = request.getRemoteAddr();

Date newdate = new Date() ;
long datetime = newdate.getTime() ;
Timestamp timestamp = new Timestamp(datetime) ;
String CurrentDate = (timestamp.toString()).substring(0,4) + "-" + (timestamp.toString()).substring(5,7) + "-" +(timestamp.toString()).substring(8,10);
String CurrentTime = (timestamp.toString()).substring(11,13) + ":" + (timestamp.toString()).substring(14,16) + ":" +(timestamp.toString()).substring(17,19);

String meetingid=Util.fromScreen(request.getParameter("meetingid"),user.getLanguage());
String method=Util.fromScreen(request.getParameter("method"),user.getLanguage());
String address=Util.fromScreen(request.getParameter("address"),user.getLanguage());
String begindate=Util.fromScreen(request.getParameter("begindate"),user.getLanguage());
String begintime=Util.fromScreen(request.getParameter("begintime"),user.getLanguage());
String enddate=Util.fromScreen(request.getParameter("enddate"),user.getLanguage());
String endtime=Util.fromScreen(request.getParameter("endtime"),user.getLanguage());
enddate=begindate ;
if(method.equals("save")){
    String updatesql="update meeting set address="+address+",begindate='"+begindate+"',begintime='"+
                begintime+"',enddate='"+enddate+"',endtime='"+endtime+"' where id="+meetingid ;
    RecordSet.executeSql(updatesql) ;
    
    RecordSet.executeProc("Meeting_SelectByID",meetingid);
	RecordSet.next();
	String name=RecordSet.getString("name");
	String caller=RecordSet.getString("caller");
	String contacter=RecordSet.getString("contacter");
	String approver=RecordSet.getString("approver");

	String SWFTitle="";
	String SWFRemark="";
	String SWFSubmiter="";
	String SWFAccepter="";
    
	SWFAccepter="";
	String Sql="select distinct membermanager from Meeting_Member2 where meetingid="+meetingid;
	RecordSet.executeSql(Sql);
	while(RecordSet.next()){
		if(!RecordSet.getString(1).equals(caller) && !RecordSet.getString(1).equals(contacter) && !RecordSet.getString(1).equals(approver) ){
		    SWFAccepter+=","+RecordSet.getString(1);
		}
	}
	Sql="select distinct hrmid from Meeting_Service2 where meetingid="+meetingid;
	RecordSet.executeSql(Sql);
	while(RecordSet.next()){
	    if(!RecordSet.getString(1).equals(caller) && !RecordSet.getString(1).equals(contacter) && !RecordSet.getString(1).equals(approver) ){
		    SWFAccepter+=","+RecordSet.getString(1);
		}
	}
	SWFAccepter+=","+caller;
	SWFAccepter+=","+contacter;
	SWFAccepter+=","+approver;
	if(!SWFAccepter.equals("")){
		SWFAccepter=SWFAccepter.substring(1); 
		SWFTitle=SystemEnv.getHtmlLabelName(127871,user.getLanguage());
		SWFTitle += name;
		SWFTitle += "-"+ResourceComInfo.getResourcename(contacter);
		SWFTitle += "-"+CurrentDate;		
		SWFRemark="";
		SWFSubmiter=contacter;
		SysRemindWorkflow.setMeetingSysRemind(SWFTitle,Util.getIntValue(meetingid),Util.getIntValue(SWFSubmiter),SWFAccepter,SWFRemark);	
	}
		
    response.sendRedirect("/meeting/report/MeetingRoomPlan.jsp");
	return;
}
if(method.equals("end")){
    String updatesql="update meeting set address="+address+",begindate='"+begindate+"',begintime='"+
                begintime+"',enddate='"+enddate+"',endtime='"+endtime+"',isapproved='4' where id="+meetingid ;
    RecordSet.executeSql(updatesql) ;
    response.sendRedirect("/meeting/report/MeetingRoomPlan.jsp");
	return;
}
%>