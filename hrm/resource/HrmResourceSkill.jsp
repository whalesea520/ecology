<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="JobActivitiesComInfo" class="weaver.hrm.job.JobActivitiesComInfo" scope="page"/>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>
<%
String imagefilename = "/images/hdHRMCard_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(179,user.getLanguage())+": "+ SystemEnv.getHtmlLabelName(384,user.getLanguage());
String needfav ="1";
String needhelp ="";
String resourceid = Util.null2String(request.getParameter("id"));
String jobactivity = Util.null2String(request.getParameter("jobactivity"));
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(HrmUserVarify.checkUserRight("HrmResourceSkillAdd:Add", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(193,user.getLanguage())+",/hrm/resource/HrmResourceSkillAdd.jsp?resourceid="+resourceid+"&jobactivity="+jobactivity+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
<td height="10" colspan="3"></td>
</tr>
<tr>
<td ></td>
<td valign="top">
<TABLE class=Shadow>
<tr>
<td valign="top">
<FORM id=deleteskill name=deleteskill action=HrmResourceSkillOperation.jsp method=post>
<input type=hidden name="operation" value="deleteskill">
<input type=hidden name="resourceid" value="<%=resourceid%>">
<input type=hidden name="jobactivity" value="<%=jobactivity%>">
<input type=hidden name="id">
<TABLE class=ListStyle cellspacing=1 >
  <COLGROUP>
  <COL width="90%">
  <COL width="10%">
  <TBODY>
   <TR CLASS=Header> 
     <Th colSpan=2><%=SystemEnv.getHtmlLabelName(384,user.getLanguage())%></Th>
   </TR>
   <TR class=Header>
      <TH><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></TH>
      <TH><%=SystemEnv.getHtmlLabelName(104,user.getLanguage())%></TH>
    </TR>
    <TR class=Line><TD colspan="2" ></TD></TR> 
<%
int i = 0 ;
RecordSet.executeProc("HrmResourceSkill_Select",resourceid);
while(RecordSet.next()) {
String id = RecordSet.getString("id") ;
String skilldesc = Util.toScreen(RecordSet.getString("skilldesc"),user.getLanguage()) ;
if(i==0){
		i=1;
%>
<TR class=DataLight>
<%
	}else{
		i=0;
%>
<TR class=DataDark>
<%
}
%>
    <TD><A 
      href="HrmResourceSkillEdit.jsp?id=<%=id%>&resourceid=<%=resourceid%>&jobactivity=<%=jobactivity%>"><%=skilldesc%></A></TD>
    <TD><BUTTON class=DELROW title=<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%> 
  onclick='DeleteSkill("<%=id%>")'></BUTTON></TD></TR>
<% } %> 
</TBODY></TABLE>
<BR>
<TABLE>
  <TBODY>
  <TR>
      <TD><%=SystemEnv.getHtmlLabelName(382,user.getLanguage())%>: </TD>
    <TD><a href="/hrm/jobactivities/HrmJobActivitiesEdit.jsp?id=<%=jobactivity%>"><%=Util.toScreen(JobActivitiesComInfo.getJobActivitiesname(jobactivity),user.getLanguage())%></a>
    <TD></TD></TR></TBODY></TABLE></FORM>
<SCRIPT language=javascript>
function DeleteSkill(id) {
if(confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>")) {
document.deleteskill.id.value=id ;
document.deleteskill.submit();
}
}
</SCRIPT>
	
	</BODY></HTML>
