
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.meeting.MeetingShareUtil"%> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Timestamp" %>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="MeetingFieldComInfo" class="weaver.meeting.defined.MeetingFieldComInfo" scope="page"/>
<%
Date newdate = new Date() ;
long datetime = newdate.getTime() ;
Timestamp timestamp = new Timestamp(datetime) ;
String CurrentDate = (timestamp.toString()).substring(0,4) + "-" + (timestamp.toString()).substring(5,7) + "-" +(timestamp.toString()).substring(8,10);
String CurrentTime = (timestamp.toString()).substring(11,13) + ":" + (timestamp.toString()).substring(14,16);


String userid = ""+user.getUID();
String logintype = ""+user.getLogintype();
String usertype ="0";
if(logintype.equals("1"))
	usertype = "0";
else usertype = "1";
String allUser=MeetingShareUtil.getAllUser(user);
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</HEAD>
<%
String imagefilename = "/images/hdDOC_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(16420,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="meeting"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(30902,user.getLanguage())+SystemEnv.getHtmlLabelName(2103,user.getLanguage()) %>"/>
</jsp:include>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; ">
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu middle"></span>
		</td>
	</tr>
</table>
<div id="tabDiv" >
	<span id="hoverBtnSpan" class="hoverBtnSpan">
			
	</span>
</div>

<%
	int  perpage=10;
	String backfields = " t1.id, t1.name, t1.caller, t1.contacter, t1.address,t1.beginDate, t1.beginTime, t1.endDate, t1.endTime, t1.meetingStatus, t1.customizeAddress,t3.status as status";
	String fromSql  = " Meeting t1 left join Meeting_View_Status t3 on t3.meetingId = t1.id and t3.userId in ("+allUser+") , Meeting_Member2 t2";
	String whereSql = " where t1.repeatType = 0 and t1.id=t2.meetingid and t1.isdecision<>2 AND t1.meetingStatus = 2 ";
	whereSql+=" AND (t2.memberId in ("+allUser+") OR t1.caller in("+allUser+") OR t1.contacter in("+allUser+")  ";
	String[] belongs=allUser.split(",");
	if(RecordSet.getDBType().equals("oracle")){
		for(int i=0;i<belongs.length;i++){
			if("".equals(belongs[i])) continue;
			whereSql+=" or ','|| t2.othermember|| ',' like '%,"+belongs[i]+",%' ";
		}
	}else{
		for(int i=0;i<belongs.length;i++){
			if("".equals(belongs[i])) continue;
			whereSql+=" or ','+t2.othermember+',' like '%,"+belongs[i]+",%' ";
		}
	}	
	whereSql+=")  AND (t1.endDate > '"+CurrentDate+"' OR (t1.endDate = '"+CurrentDate+"' AND t1.endTime > '"+CurrentTime+"'))";
	
	
	String orderby = " t1.beginDate desc ,t1.beginTime DESC " ;
	String tableString = "";
	tableString =" <table instanceid=\"meetingTable\" tabletype=\"none\" pagesize=\""+perpage+"\" >"+ 
			    "	   <sql sqlisdistinct=\"true\" backfields=\""+backfields+"\" sqlform=\""+fromSql+"\"  sqlwhere=\""+Util.toHtmlForSplitPage(whereSql)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"t1.id\" sqlsortway=\"Desc\" />"+
			    "			<head>"+
			    "				<col width=\"20%\"   text=\""+SystemEnv.getHtmlLabelName(Util.getIntValue(MeetingFieldComInfo.getLabel("2")),user.getLanguage())+"\" column=\"name\" orderkey=\"t1.name\" transmethod=\"weaver.meeting.Maint.MeetingTransMethod.getMeetingName\" otherpara=\"column:id+column:status\" />"+
			    "				<col width=\"17%\"   text=\""+SystemEnv.getHtmlLabelName(Util.getIntValue(MeetingFieldComInfo.getLabel("5")),user.getLanguage())+"\" column=\"address\" orderkey=\"address\" otherpara=\""+user.getLanguage()+"+column:customizeaddress\" transmethod=\"weaver.meeting.Maint.MeetingTransMethod.getMeetingAddress\" />"+
			    "				<col width=\"10%\"   text=\""+SystemEnv.getHtmlLabelName(Util.getIntValue(MeetingFieldComInfo.getLabel("3")),user.getLanguage())+"\" column=\"caller\" orderkey=\"caller\" transmethod=\"weaver.meeting.Maint.MeetingTransMethod.getMeetingResource\" />"+
			    "				<col width=\"13%\"   text=\""+SystemEnv.getHtmlLabelName(Util.getIntValue(MeetingFieldComInfo.getLabel("4")),user.getLanguage())+"\" column=\"contacter\" orderkey=\"contacter\"  transmethod=\"weaver.meeting.Maint.MeetingTransMethod.getMeetingResource\"/>"+
				"				<col width=\"15%\"   text=\""+SystemEnv.getHtmlLabelName(Util.getIntValue(MeetingFieldComInfo.getLabel("17")),user.getLanguage())+"\" column=\"begindate\"  orderkey=\"begindate,begintime\" otherpara=\"column:begintime\" transmethod=\"weaver.meeting.Maint.MeetingTransMethod.getMeetingDateTime\"/>"+
			    "				<col width=\"15%\"   text=\""+SystemEnv.getHtmlLabelName(Util.getIntValue(MeetingFieldComInfo.getLabel("19")),user.getLanguage())+"\" column=\"enddate\"  orderkey=\"enddate,endtime\" otherpara=\"column:endtime\" transmethod=\"weaver.meeting.Maint.MeetingTransMethod.getMeetingDateTime\"/>"+
			    "				<col width=\"10%\"   text=\""+SystemEnv.getHtmlLabelName(602,user.getLanguage())+"\" column=\"meetingstatus\" otherpara=\""+user.getLanguage()+"+column:endDate+column:endTime+column:isdecision\" orderkey=\"meetingstatus\"  transmethod=\"weaver.meeting.Maint.MeetingTransMethod.getMeetingStatus\" />"+
			    "			</head>"+
			    "</table>";
 %>
 <wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" />
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>   
<script language=javascript>  
function submitData() {
window.history.back();
}

function onReSearch(){
	location.href="/meeting/search/Search.jsp";
}
var diag_vote;
function view(id)
{
	if(id!="0" && id !=""){
		if(window.top.Dialog){
			diag_vote = new window.top.Dialog();
		} else {
			diag_vote = new Dialog();
		}
		diag_vote.currentWindow = window;
		diag_vote.Width = 800;
		diag_vote.Height = 550;
		diag_vote.Modal = true;
		diag_vote.maxiumnable = true;
		diag_vote.checkDataChange = false;
		diag_vote.Title = "<%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(2103,user.getLanguage())%>";
		diag_vote.URL = "/meeting/data/ViewMeetingTab.jsp?meetingid="+id;
		diag_vote.show();
	}
}

function closeDialog(){
	diag_vote.close();
}

function closeDlgARfsh(){
	diag_vote.close();
	dataRfsh();
}

function dataRfsh(){
	_table.reLoad();
}
</script>
</body>
</html>
