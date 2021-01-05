<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.sql.Timestamp" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SysRemindWorkflow" class="weaver.system.SysRemindWorkflow" scope="page" />
<jsp:useBean id="MeetingViewer" class="weaver.meeting.MeetingViewer" scope="page"/>
<jsp:useBean id="meetingSetInfo" class="weaver.meeting.Maint.MeetingSetInfo" scope="page"/>

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

String Sql="";

char flag = 2;
String ProcPara = "";

String method = Util.null2String(request.getParameter("method"));
String meetingid=Util.null2String(request.getParameter("meetingid"));
String recorderid=Util.null2String(request.getParameter("recorderid"));
String isattend=Util.null2String(request.getParameter("isattend"));
String begindate=Util.null2String(request.getParameter("begindate"));
String begintime=Util.null2String(request.getParameter("begintime"));
String enddate=Util.null2String(request.getParameter("enddate"));
String endtime=Util.null2String(request.getParameter("endtime"));
String bookroom=Util.null2String(request.getParameter("bookroom"));
String roomstander=Util.null2String(request.getParameter("roomstander"));
String bookticket=Util.null2String(request.getParameter("bookticket"));
String ticketstander=Util.null2String(request.getParameter("ticketstander"));
String othermember=Util.null2String(request.getParameter("othermember"));
String recRemark=Util.null2String(request.getParameter("recRemark"));
int counts=0;
String sqlstr="";
if(method.equals("edit"))
{
	ProcPara =  recorderid;
	ProcPara += flag + isattend;
	ProcPara += flag + begindate;
	ProcPara += flag + begintime;
	ProcPara += flag + enddate;
	ProcPara += flag + endtime;
	ProcPara += flag + bookroom;
	ProcPara += flag + roomstander;
	ProcPara += flag + bookticket;
	ProcPara += flag + ticketstander;
	ProcPara += flag + othermember;

	/*查看是否有改变记录*/
    sqlstr="select count(id) counts from Meeting_Member2 where id="+recorderid+" and othermember='"+othermember+"'";
    RecordSet.executeSql(sqlstr);
    RecordSet.next();
    counts=RecordSet.getInt("counts");

    RecordSet.executeProc("Meeting_Member2_Update",ProcPara);
    //更新备注
    RecordSet.execute("update Meeting_Member2 set recRemark='"+recRemark+"' where id="+recorderid);
    
    /*假如没改变记录就不做限表变更*/
    if (counts==0) MeetingViewer.setMeetingShareById(meetingid);
    //查询会议应用设置 是否启用回执提醒
    if(meetingSetInfo.getReMeetingRemindChk()==1){
		String SWFTitle="";
		String SWFRemark="";
		String SWFSubmiter="";
		String SWFAccepter="";

		SWFAccepter="";
		Sql="select * from Meeting where id="+meetingid;
		RecordSet.executeSql(Sql);
		while(RecordSet.next()){
			SWFAccepter=RecordSet.getString("contacter");
			String strtmp = SystemEnv.getHtmlLabelName(2160,user.getLanguage());//文字
			SWFTitle=Util.toScreen(strtmp+RecordSet.getString("name"),user.getLanguage());
			SWFTitle += "-"+CurrentUserName;
			SWFTitle += "-"+CurrentDate;
		}
		if(!SWFAccepter.equals("") && !SWFAccepter.equals(CurrentUser)){
		SWFRemark="";
		SWFSubmiter=CurrentUser;
		SysRemindWorkflow.setMeetingSysRemind(SWFTitle,Util.getIntValue(meetingid),Util.getIntValue(SWFSubmiter),SWFAccepter,SWFRemark);	
		}
    }
}

%>
<script>
	 var parentWin = parent.parent.getParentWindow(window.parent);
     parentWin.refashMemberList();
     parentWin.diag_vote.close();
</script>


