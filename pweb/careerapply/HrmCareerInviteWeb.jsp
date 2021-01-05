
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ page import="weaver.general.Util" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page"/>
<jsp:useBean id="EduLevelComInfo" class="weaver.hrm.job.EducationLevelComInfo" scope="page"/>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>
<%
int language=7;
String sqlstr = "select * from HrmCareerInvite where isweb = 1";
%>
<BODY>
<DIV class=HdrProps></DIV>
<FORM NAME=frmain action="HrmCareerInvite.jsp" method=post>

<TABLE class=ListShort>
  <TBODY>
  <TR class=Section>
    <TH><%=SystemEnv.getHtmlLabelName(366,user.getLanguage())%></TH>
  </TR>
  <TR class=separator>
    <TD class=Sep1 colSpan=2></TD></TR></TBODY></TABLE>
<TABLE class=ListShort>
  <THEAD>
  <COLGROUP>
  <COL width="10%">
  <COL width="10%">
  <COL width="10%">
  <COL width="10%">
  <COL width="10%">
  <COL width="10%">
  <COL width="10%">  
  <TR class=Header>
    <TH><%=SystemEnv.getHtmlLabelName(714,user.getLanguage())%></TH>
	<TH><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%></TH>
	<TH><%=SystemEnv.getHtmlLabelName(1859,user.getLanguage())%></TH>
	<TH><%=SystemEnv.getHtmlLabelName(416,user.getLanguage())%></TH>
	<TH><%=SystemEnv.getHtmlLabelName(1860,user.getLanguage())%></TH>
	<TH><%=SystemEnv.getHtmlLabelName(17883,user.getLanguage())%></TH>	
	</TR></THEAD>
<%
int i= 0;
RecordSet.executeSql(sqlstr);
while(RecordSet.next()) {
	String id = RecordSet.getString("id") ;
	String careername = Util.toScreen(RecordSet.getString("careername"),7) ;
	String careerpeople = Util.null2String(RecordSet.getString("careerpeople")) ;
	String careersex = Util.null2String(RecordSet.getString("careersex")) ; 
	String careeredu = Util.null2String(RecordSet.getString("careeredu")) ;
	String createrid = Util.null2String(RecordSet.getString("createrid")) ;
	String createdate = Util.null2String(RecordSet.getString("createdate"));
	String careersexstr="";
	String careeredustr="";
	if (careersex.equals("0")) careersexstr = SystemEnv.getHtmlLabelName(417,language);
	else if	(careersex.equals("1")) careersexstr = SystemEnv.getHtmlLabelName(418,language);
	else if (careersex.equals("2")) careersexstr = SystemEnv.getHtmlLabelName(763,language);

	if (careeredu.equals("0")) careeredustr = SystemEnv.getHtmlLabelName(764,language);
	else if	(careeredu.equals("1")) careeredustr = SystemEnv.getHtmlLabelName(765,language);
	else if (careeredu.equals("2")) careeredustr = SystemEnv.getHtmlLabelName(766,language);
	else if (careeredu.equals("3")) careeredustr = SystemEnv.getHtmlLabelName(767,language);
	else if (careeredu.equals("4")) careeredustr = SystemEnv.getHtmlLabelName(768,language);
	else if (careeredu.equals("5")) careeredustr = SystemEnv.getHtmlLabelName(769,language);	
	else if (careeredu.equals("6")) careeredustr = SystemEnv.getHtmlLabelName(763,language);		

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
    <TD><a href='/pweb/careerapply/HrmCareerApplyViewDetail.jsp?paraid=<%=id%>'><%=Util.add0(Util.getIntValue(id),12)%></a></TD>
	<TD>
		<%=JobTitlesComInfo.getJobTitlesname(careername)%>
	</TD>
	<TD><%=careerpeople%> </TD>
	<TD><%=careersexstr%></TD>
	<TD><%=careeredustr%> </TD>	
	<TD><%=createdate%> </TD>
    </TR>
<%}%>
  </TABLE></FORM></BODY>
<SCRIPT language="vbs">  
sub onShowJobtitle()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/jobtitles/JobTitlesBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	jobtitlespan.innerHtml = id(1)
	frmain.jobtitle.value=id(0)
	else 
	jobtitlespan.innerHtml = ""
	frmain.jobtitle.value=""
	end if
	end if
end sub  
</SCRIPT>
<SCRIPT language="javascript">
function OnSubmit(){
		document.frmain.submit();
}
</script>
</HTML>