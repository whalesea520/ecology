<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.meeting.defined.MeetingFieldManager"%> 
<%@page import="weaver.meeting.MeetingShareUtil"%> 
<jsp:useBean id="meetingSetInfo" class="weaver.meeting.Maint.MeetingSetInfo" scope="page"/>
<%@ include file="/systeminfo/init_wev8.jsp" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="MeetingUtil" class="weaver.meeting.MeetingUtil" scope="page" />

<%
String method = Util.null2String(request.getParameter("method"));
String meetingid=Util.null2String(request.getParameter("meetingid"));
String Sql="";

int userPrm = meetingSetInfo.getCallerPrm();

String allUser=MeetingShareUtil.getAllUser(user);
String userid=user.getUID()+"";
boolean ismanager=false;
boolean ismember=false;
boolean isdecisioner=false;
boolean iscontacter=false;
boolean canview=false;
String caller="";
String contacter="";
String meetingstatus="";
String requestid="";
String isapproved="";
String isdecision="";
String creater="";
RecordSet.execute("select * from meeting where id="+meetingid);
if(RecordSet.next()){
	caller=RecordSet.getString("caller");
	isapproved=RecordSet.getString("isapproved");
	isdecision=RecordSet.getString("isdecision");
	contacter=RecordSet.getString("contacter");
	creater=RecordSet.getString("creater");
}

if(MeetingShareUtil.containUser(allUser,caller)){
	userPrm = meetingSetInfo.getCallerPrm();
	if(userPrm != 3) userPrm = 3;
}else{
	if( MeetingShareUtil.containUser(allUser,contacter)){
		userPrm = meetingSetInfo.getContacterPrm();
	}
	
	if( MeetingShareUtil.containUser(allUser,creater)&&userPrm<3){
		if(userPrm < meetingSetInfo.getCreaterPrm()){
			userPrm = meetingSetInfo.getCreaterPrm();
		}
	}
}
if(userPrm == 3 || MeetingShareUtil.containUser(allUser,caller)){
 	ismanager=true;
}
if(meetingstatus.equals("2")){
	if(RecordSet.getDBType().equals("oracle")){
		Sql="select memberid from Meeting_Member2 where meetingid="+meetingid+" and ( membermanager in ("+allUser+") " ;
		String[] belongs=allUser.split(",");
		for(int i=0;i<belongs.length;i++){
			if("".equals(belongs[i])) continue;
			Sql+=" or ','|| othermember|| ',' like '%,"+belongs[i]+",%' ";
		}
		Sql+=")";
	}else{
		Sql="select memberid from Meeting_Member2 where meetingid="+meetingid+" and ( membermanager in ("+allUser+" )";
		String[] belongs=allUser.split(",");
		for(int i=0;i<belongs.length;i++){
			if("".equals(belongs[i])) continue;
			Sql+=" or ','+othermember+',' like '%,"+belongs[i]+",%' ";
		}
		Sql+=")";
	}
	RecordSet.executeSql(Sql);
	if(RecordSet.next()) {
		ismember=true;
	}
}

/***检查通过审批流程查看会议***/
RecordSet.executeSql("select userid from workflow_currentoperator where requestid = "+requestid+" and userid in ("+allUser+")" ) ;
if(RecordSet.next()){
	canview=true;
}

if(!canview && (isapproved.equals("3")||isapproved.equals("4"))){
	if(RecordSet.getDBType().equals("oracle")){
		Sql="select * from Meeting_Decision where meetingid="+meetingid+" and ( hrmid02 in ("+allUser+")  ";
		String[] belongs=allUser.split(",");
		for(int i=0;i<belongs.length;i++){
			if("".equals(belongs[i])) continue;
			Sql+=" or ','|| hrmid01|| ',' like '%,"+belongs[i]+",%' ";
		}
		Sql+=")";
	}else if(RecordSet.getDBType().equals("db2")){
        Sql="select * from Meeting_Decision where meetingid="+meetingid+" and ( hrmid02 in ("+allUser+") ";
        String[] belongs=allUser.split(",");
		for(int i=0;i<belongs.length;i++){
			if("".equals(belongs[i])) continue;
			Sql+=" or concat(concat(',',hrmid01),',') like '%,"+belongs[i]+",%' ";
		}
		Sql+=")";
	}else{
		Sql="select * from Meeting_Decision where meetingid="+meetingid+" and ( hrmid02 in ("+allUser+") ";
		String[] belongs=allUser.split(",");
		for(int i=0;i<belongs.length;i++){
			if("".equals(belongs[i])) continue;
			Sql+=" or ','+hrmid01+',' like '%,"+belongs[i]+",%' ";
		}
		Sql+=")";
	}
	
	RecordSet.executeSql(Sql);
	if(RecordSet.next()) {
		canview=true;
		isdecisioner=true;
	}
}
if(MeetingShareUtil.containUser(allUser,contacter) || (userPrm==2&&(!ismember||!isdecisioner)))
    iscontacter=true;

if(method.equals("edit"))
{	
	if(!((ismanager||iscontacter) && !isdecision.equals("1") && !isdecision.equals("2"))){
		out.println("<script>wfforward(\"/notice/noright.jsp\");</script>");
		return;
	}
	//会议议程
	int topicrows=Util.getIntValue(Util.null2String(request.getParameter("topicrows")),0);
	if(topicrows>0){
		String recordsetids="";
		for(int i=1;i<=topicrows;i++){
			String recordsetid=Util.null2String(request.getParameter("topic_data_"+i));
			if(!recordsetid.equals("")) recordsetids+=","+recordsetid;
		}
		if(!recordsetids.equals("")){
			recordsetids=recordsetids.substring(1);
			Sql = "delete from Meeting_Topic WHERE ( meetingid = "+meetingid+" and id not in ("+recordsetids+"))";
			RecordSet.executeSql(Sql);
		}else{
			Sql = "delete from Meeting_Topic WHERE ( meetingid = "+meetingid+")";
			RecordSet.executeSql(Sql);
		}
		MeetingFieldManager mfm2=new MeetingFieldManager(2);
		for(int i=1;i<=topicrows;i++){
			String recordsetid=Util.null2String(request.getParameter("topic_data_"+i));
			mfm2.editCustomDataDetail(request,Util.getIntValue(recordsetid),i,Util.getIntValue(meetingid));
		}
		
	}
	
	MeetingUtil.meetingDocShare(meetingid);
}

%>
<script>
     var parentWin = parent.parent.getParentWindow(window.parent);
     parentWin.refashTopicList();
     parentWin.diag_vote.close();
</script>


