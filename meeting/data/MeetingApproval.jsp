
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="MeetingSearchComInfo" class="weaver.meeting.search.SearchComInfo" scope="session" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CapitalComInfo" class="weaver.cpt.capital.CapitalComInfo" scope="page"/>
<jsp:useBean id="MeetingRoomComInfo" class="weaver.meeting.Maint.MeetingRoomComInfo" scope="page"/>

<%
//获得当前的日期和时间
Calendar today = Calendar.getInstance();
String currentdate = Util.add0(today.get(Calendar.YEAR), 4) + "-" +
                     Util.add0(today.get(Calendar.MONTH) + 1, 2) + "-" +
                     Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;
String userid = ""+user.getUID();
String logintype = ""+user.getLogintype();
String usertype ="0";
if(logintype.equals("1"))
	usertype = "0";
else usertype = "1";

String sqlstr ="";
//gzt update TD37320
sqlstr="Select distinct t1.requestid,t1.requestname,t1.workflowid,t1.currentnodeid,t1.currentnodetype,t3.approveid,t3.meetingname,t3.address,t3.caller,t3.contacter,t3.begindate,t3.begintime,t3.enddate,t3.endtime,t2.usertype,t4.meetingstatus, t4.customizeAddress from workflow_requestbase t1,workflow_currentoperator t2,bill_meeting t3,Meeting t4 WHERE t1.requestid = t3.requestid and t1.requestid = t2.requestid and t2.userid = "+userid+" and t2.usertype = "+usertype+" and t2.isremark in ('0','1') and (t1.deleted=0 or t1.deleted is null) and t1.currentnodetype ='1' and t3.approveid = t4.id";
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</HEAD>
<%
String imagefilename = "/images/hdDOC_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(16419,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%

RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;


%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
<td ></td>
<td valign="top">
<TABLE class=Shadow>
<tr>
<td valign="top">
<b>

</b>
<TABLE class=ListStyle cellspacing=1>
  <TBODY>

  <TR class=Header>
    <TH><%=SystemEnv.getHtmlLabelName(2151,user.getLanguage())%></TH>
    <TH><%=SystemEnv.getHtmlLabelName(2105,user.getLanguage())%></TH>
    <TH><%=SystemEnv.getHtmlLabelName(2152,user.getLanguage())%></TH>
    <TH><%=SystemEnv.getHtmlLabelName(572,user.getLanguage())%></TH>
	<TH><%=SystemEnv.getHtmlLabelName(2103,user.getLanguage())%>
        <%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></TH>
    <TH><%=SystemEnv.getHtmlLabelName(742,user.getLanguage())%></TH>
	<TH><%=SystemEnv.getHtmlLabelName(16419,user.getLanguage())%></TH>
  </TR>
  <TR style="height: 1px;"><TD class=Line colspan="7" style="padding:0 0 0 0"></TD></TR> 
<%
     
boolean isLight = false;
int totalline=1;
String meetingstatus ="";
String workflowid = "";
String nodeid = "";
String nodetype = "";
String requestname = "";
//gzt update TD37320
String address = "";
String begindate = "";
String enddate = "";
RecordSet.executeSql(sqlstr);
if(RecordSet.last()){
	do{
		meetingstatus = RecordSet.getString("meetingstatus");
		workflowid = RecordSet.getString("workflowid");
		nodeid = RecordSet.getString("currentnodeid");
		nodetype = RecordSet.getString("currentnodetype");
		requestname = RecordSet.getString("requestname");
		//gzt update TD37320
		address = RecordSet.getString("address");
		begindate = RecordSet.getString("begindate") + " " + RecordSet.getString("begintime");
		enddate = RecordSet.getString("enddate") + " " + RecordSet.getString("endtime");
		if(isLight)
		{%>	
	<TR CLASS=DataDark>
<%		}else{%>
	<TR CLASS=DataLight>
<%		}%>
    <TD><a href="/meeting/data/ViewMeeting.jsp?meetingid=<%=RecordSet.getString("approveid")%>"><%=Util.forHtml(RecordSet.getString("meetingname"))%></a></TD>
    <TD class=Field><A href="/meeting/Maint/MeetingRoom.jsp"><%=MeetingRoomComInfo.getMeetingRoomInfoname(RecordSet.getString("address"))%></a><%= Util.null2String(RecordSet.getString("customizeAddress")) %></TD>
    <TD><A href='/hrm/resource/HrmResource.jsp?id=<%=RecordSet.getString("caller")%>'><%=ResourceComInfo.getResourcename(RecordSet.getString("caller"))%></a></TD>
    <TD><A href='/hrm/resource/HrmResource.jsp?id=<%=RecordSet.getString("contacter")%>'><%=ResourceComInfo.getResourcename(RecordSet.getString("contacter"))%></a></TD>
	<TD>
		<%if(meetingstatus.equals("1")){%>
			<%=SystemEnv.getHtmlLabelName(2242,user.getLanguage())%>
		<%}%>
		<%if(meetingstatus.equals("2")){%>
			<%=SystemEnv.getHtmlLabelName(225,user.getLanguage())%>
		<%}%>
		<%if(meetingstatus.equals("3")){%>
			<%=SystemEnv.getHtmlLabelName(1010,user.getLanguage())%>
		<%}%>
	</TD>
    <TD><%=begindate %></TD>
	<TD>
	<a href="javascript:checkaddress('<%=address %>','<%=begindate %>','<%=enddate %>','/workflow/request/BillMeetingOperation.jsp?requestid=<%=RecordSet.getString("requestid")%>&workflowid=<%=workflowid%>&nodeid=<%=nodeid%>&nodetype=<%=nodetype%>&approvemeeting=1&isfrommeeting=1&requestname=<%=requestname%>')"><%=SystemEnv.getHtmlLabelName(142,user.getLanguage())%></a>
	</TD>
  </TR>
<%
	isLight = !isLight;
	
}while(RecordSet.previous());
}
%>  
 </TBODY>
 </TABLE>
 	
</td>
</tr>
</TABLE>
</td>
<td></td>
</tr>
<tr>
<td height="10" colspan="3"></td>
</tr>
</table>
<script language=javascript>  
function submitData() {
window.history.back();
}

//gzt update TD37320 begin
function checkuse(address,begindate,enddate){
    <%
    String tempbegindate="";
    String tempenddate="";
    String tempbegintime="";
    String tempendtime="";
    String tempAddress="0";
    RecordSet.executeSql("select Address,begindate,enddate,begintime,endtime from meeting where meetingstatus=2 and isdecision<2 and (cancel is null or cancel<>'1') and    (begindate>='"+currentdate+"' or EndDate >= '"+currentdate+"') AND address <> 0 AND address IS NOT null");
    while(RecordSet.next()){
        tempAddress=RecordSet.getString("Address");
        tempbegindate=RecordSet.getString("begindate");
        tempenddate=RecordSet.getString("enddate");
        tempbegintime=RecordSet.getString("begintime");
        tempendtime=RecordSet.getString("endtime");
   %>
   if(address == "<%=tempAddress%>"){
       if(!(begindate > "<%=tempenddate+' '+tempendtime%>" || enddate < "<%=tempbegindate+' '+tempbegintime%>")){
           return true;
       }
   }
   <%
    }
    %>
    return false;
}
//检查是否有会议室使用冲突
function checkaddress(address,begindate,enddate,url){
	if(checkuse(address,begindate,enddate)){
		if(confirm("<%=SystemEnv.getHtmlLabelName(19095,user.getLanguage())%>")){
				location.href=url;
    }
	}else{
		location.href=url;
	}
}
//gzt update TD37320 end

function onReSearch(){
	location.href="/meeting/search/Search.jsp";
}
</script>
</body>
</html>
