<%@ page import="weaver.general.Util,java.util.*,java.math.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page"/>


<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</head>
<%
int msgid = Util.getIntValue(request.getParameter("msgid"),-1);
String resourceid = Util.null2String(request.getParameter("resourceid")) ;
char separator = Util.getSeparator() ;

String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(179,user.getLanguage())+"-"+SystemEnv.getHtmlLabelName(1503,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%
if(msgid!=-1){
%>
<DIV>
<font color=red size=2>
<%=SystemEnv.getErrorMsgName(msgid,user.getLanguage())%>
</font>
</DIV>
<%}%>
<DIV class=HdrProps></DIV>
<BUTTON class=Btn id=button1 accessKey=A 
onclick='location.href="HrmResourceWorkResumeInAdd.jsp?resourceid=<%=resourceid%>"' name=button1><U>A</U>-<%=SystemEnv.getHtmlLabelName(365,user.getLanguage())%></BUTTON>

<TABLE class=ListShort>
  <TBODY> 
  <TR class=Section> 
    <TH colSpan=5><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%> <a href="HrmResource.jsp?id=<%=resourceid%>"><%=Util.toScreen(ResourceComInfo.getResourcename(resourceid),user.getLanguage())%></a></TH>
  </TR>
  <TR class=Separator> 
    <TD class=Sep1 colSpan=5></TD>
  </TR>
  <TR class=Header> 
    <TD width="22%"><%=SystemEnv.getHtmlLabelName(1908,user.getLanguage())%></TD>
    <TD width="22%"><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></TD>
    <TD width="22%"><%=SystemEnv.getHtmlLabelName(357,user.getLanguage())%></TD>
    <TD width="24%"><%=SystemEnv.getHtmlLabelName(484,user.getLanguage())%></TD>
	<TD width="10%"></TD>
  </TR>
<%
int i=0;
RecordSet.executeProc("HrmWorkResumeIn_SByResourceID",resourceid);

while(RecordSet.next()){
String id = RecordSet.getString("id");
String datefrom = RecordSet.getString("datefrom");
String dateto = RecordSet.getString("dateto");
String departmentid = RecordSet.getString("departmentid");
String jobtitle = RecordSet.getString("jobtitle");
String joblevel = RecordSet.getString("joblevel");
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
	<td>
	<%=Util.toScreen(datefrom,user.getLanguage())%>-<%=Util.toScreen(dateto,user.getLanguage())%>
	</td>
    <td><%=Util.toScreen(DepartmentComInfo.getDepartmentname(departmentid),user.getLanguage())%></td>
    <td><%=Util.toScreen(JobTitlesComInfo.getJobTitlesname(jobtitle),user.getLanguage())%></td>
    <td><%=joblevel%></td>
    <td><a href="HrmResourceWorkResumeInEdit.jsp?paraid=<%=id%>"><%=SystemEnv.getHtmlLabelName(361,user.getLanguage())%></a></td>
</TR>
<%}
%>
  </TBODY> 
</TABLE>

</BODY></HTML>