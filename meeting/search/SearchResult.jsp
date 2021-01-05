
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<%@ include file="/systeminfo/init_wev8.jsp" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />

<jsp:useBean id="MeetingSearchComInfo" class="weaver.meeting.search.SearchComInfo" scope="session" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CapitalComInfo" class="weaver.cpt.capital.CapitalComInfo" scope="page"/>
<jsp:useBean id="MeetingRoomComInfo" class="weaver.meeting.Maint.MeetingRoomComInfo" scope="page"/>
<%@ page import="java.sql.Timestamp" %>

<%
String userid = ""+user.getUID();
String logintype = ""+user.getLogintype();

String sqlWhere = MeetingSearchComInfo.FormatSQLSearch(user.getLanguage());
String mstatus1=Util.null2String(request.getParameter("mstatus1"));
String mstatus2=Util.null2String(request.getParameter("mstatus2"));

Date newdate = new Date() ;
long datetime = newdate.getTime() ;
Timestamp timestamp = new Timestamp(datetime) ;
String CurrentDate = (timestamp.toString()).substring(0,4) + "-" + (timestamp.toString()).substring(5,7) + "-" +(timestamp.toString()).substring(8,10);
String CurrentTime = (timestamp.toString()).substring(11,13) + ":" + (timestamp.toString()).substring(14,16);

if(!sqlWhere.equals(""))
{
	sqlWhere +=" AND (";
    sqlWhere +=" (t1.id = t2.meetingId) AND ";
	sqlWhere +=" ((t2.userId = " + userid + " AND t2.shareLevel in (1,4))" ;
	sqlWhere +=" OR (t1.meetingStatus IN (2, 4) AND (t2.userId=" + userid + ")))";
	sqlWhere +=")";
}
else
{
	sqlWhere =" WHERE ";
    sqlWhere +=" (t1.id = t2.meetingId) AND";
	sqlWhere +=" ((t2.userId = " + userid + " AND t2.shareLevel in (1,4))" ;
	sqlWhere +=" OR (t1.meetingStatus IN (2, 4) AND (t2.userId=" + userid + ")))";
}
if(mstatus1.equals("5")&&!mstatus2.equals("2")){
  sqlWhere +=" and ( enddate<'"+CurrentDate+"' or (t1.endDate = '"+CurrentDate+"' AND t1.endTime < '"+CurrentTime+"') or t1.isdecision=2) ";
}
if(mstatus2.equals("2")&&!mstatus1.equals("5")){
  sqlWhere +=" and ( enddate>'"+CurrentDate+"' or (t1.endDate = '"+CurrentDate+"' AND t1.endTime >= '"+CurrentTime+"')) and t1.isdecision<>2 ";
}

String sqlFrom = "Meeting t1, Meeting_ShareDetail t2";
%>

<HTML>
<HEAD>
	<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</HEAD>
<%
	String imagefilename = "/images/hdDOC_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(197,user.getLanguage())+SystemEnv.getHtmlLabelName(356,user.getLanguage())+" - "+SystemEnv.getHtmlLabelName(2103,user.getLanguage());
	String needfav ="1";
	String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
	RCMenu += "{"+SystemEnv.getHtmlLabelName(364,user.getLanguage())+",javascript:onReSearch(),_self}";
	RCMenuHeight += RCMenuHeightStep;
	
	RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:submitData(),_self}";
	RCMenuHeight += RCMenuHeightStep;
%>	


<TABLE width=100% height=100% border="0" cellspacing="0" cellpadding="0">
	<COLGROUP>
		<COL width="7px">
		<COL width="">
		<COL width="7px">
	</COLGROUP>
	<TR>
		<TD height="10" colspan="3"></TD>
	</TR>
	<TR>
		<TD ></TD>
		<TD valign="top">
			<TABLE class=Shadow>
				<TR>
					<TD valign="top">					
					<%
						String tableString=""+
					    "<table pagesize=\"10\" tabletype=\"none\">"+
					    "<sql backfields=\"t1.id,t1.name,t1.address,t1.customizeAddress,t1.caller,t1.contacter,t1.begindate,t1.begintime,t1.enddate,t1.endtime,t1.meetingstatus,t1.isdecision,1 AS status\" sqlisdistinct=\"true\" sqlform=\"" + sqlFrom + "\" sqlprimarykey=\"t1.id\" sqlorderby=\"t1.id\" sqlsortway=\"DESC\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"/>"+
					    "<head>"+
					    "<col width=\"15%\" text=\""+SystemEnv.getHtmlLabelName(2151,user.getLanguage())+"\" column=\"name\" orderkey=\"name\" transmethod=\"weaver.splitepage.transform.SptmForMeeting.getMeetingName\" otherpara=\"column:id+column:status+"+userid+"\" />"+
					    "<col width=\"15%\" text=\""+SystemEnv.getHtmlLabelName(2105,user.getLanguage())+"\" column=\"address\" orderkey=\"address\" transmethod=\"weaver.splitepage.transform.SptmForMeeting.getMeetingRoomAddress\" otherpara=\"column:customizeAddress\"/>"+
					    "<col width=\"14%\" text=\""+SystemEnv.getHtmlLabelName(2152,user.getLanguage())+"\" column=\"caller\" orderkey=\"caller\" transmethod=\"weaver.splitepage.transform.SptmForMeeting.getHrmResource\" />"+			    
					    "<col width=\"14%\" text=\""+SystemEnv.getHtmlLabelName(572,user.getLanguage())+"\" column=\"contacter\" orderkey=\"contacter\" transmethod=\"weaver.splitepage.transform.SptmForMeeting.getHrmResource\" />"+						    
					    "<col width=\"14%\" text=\""+SystemEnv.getHtmlLabelName(2103,user.getLanguage())+SystemEnv.getHtmlLabelName(602,user.getLanguage())+"\" column=\"meetingStatus\" orderkey=\"meetingStatus\" transmethod=\"weaver.splitepage.transform.SptmForMeeting.getMeetingStatus\" otherpara=\""+user.getLanguage()+"+column:endDate+column:endTime+column:isdecision\" />"+			    
					    "<col width=\"14%\" text=\""+SystemEnv.getHtmlLabelName(742,user.getLanguage())+"\" column=\"beginDate\" orderkey=\"beginDate,beginTime\" transmethod=\"weaver.splitepage.transform.SptmForMeeting.getDateTime\" otherpara=\"column:beginTime\" />"+
					    "<col width=\"14%\" text=\""+SystemEnv.getHtmlLabelName(743,user.getLanguage())+"\" column=\"endDate\" orderkey=\"endDate,endTime\" transmethod=\"weaver.splitepage.transform.SptmForMeeting.getDateTime\" otherpara=\"column:endTime\" />"+
					    "</head>"+
					    "</table>";
					%>
					
					<wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" isShowTopInfo="true"/>
						
					</TD>
				</TR>
			</TABLE>
		</TD>
		<TD></TD>
	</TR>
	<TR>
		<TD height="10" colspan="3"></TD>
	</TR>
</TABLE>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

</BODY>
</HTML>

<SCRIPT language=javascript>  
function submitData() 
{
	window.history.back();
}

function onReSearch()
{
	location.href="/meeting/search/Search.jsp";
}
</SCRIPT>
