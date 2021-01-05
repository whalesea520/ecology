<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.systeminfo.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page"/>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<LINK href="/web/css/style_wev8.css" type=text/css rel=STYLESHEET>
</head>
<%

String sqlstr = "select * from HrmCareerInvite where isweb = 1";

%>
<BODY>
<FORM NAME=frmain action="HrmCareerInvite.jsp" method=post>
  <div align="center"><font color="#FF0000"><b>请点击职位编号应聘该职位，无需注册，谢谢您的关注！</b></font></div> 
  <TABLE cellspacing="1" bgcolor="#CCCCCC">
  <THEAD>
  <COLGROUP>
  <COL width="10%">
  <COL width="10%">
  <COL width="10%">
  <COL width="10%">
  <COL width="10%">
  <COL width="10%">
  <COL width="10%">  
  <TR bgcolor="F6F6F6" height="25">
    <TH><%=SystemEnv.getHtmlLabelName(714,7)%></TH>
	<TH>岗位</TH>
	<TH><%=SystemEnv.getHtmlLabelName(1859,7)%></TH>
	<TH><%=SystemEnv.getHtmlLabelName(416,7)%></TH>
	<TH><%=SystemEnv.getHtmlLabelName(1860,7)%></TH>
	<TH><%=SystemEnv.getHtmlLabelName(1862,7)%></TH>	
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
	if (careersex.equals("0")) careersexstr = SystemEnv.getHtmlLabelName(417,7);
	else if	(careersex.equals("1")) careersexstr = SystemEnv.getHtmlLabelName(418,7);
	else if (careersex.equals("2")) careersexstr = SystemEnv.getHtmlLabelName(763,7);
	if (careeredu.equals("0")) careeredustr = SystemEnv.getHtmlLabelName(764,7);
	else if	(careeredu.equals("1")) careeredustr = SystemEnv.getHtmlLabelName(765,7);
	else if (careeredu.equals("2")) careeredustr = SystemEnv.getHtmlLabelName(766,7);
	else if (careeredu.equals("3")) careeredustr = SystemEnv.getHtmlLabelName(767,7);
	else if (careeredu.equals("4")) careeredustr = SystemEnv.getHtmlLabelName(768,7);
	else if (careeredu.equals("5")) careeredustr = SystemEnv.getHtmlLabelName(769,7);	
	else if (careeredu.equals("6")) careeredustr = SystemEnv.getHtmlLabelName(763,7);	

if(i==0){
		i=1;
%>
<TR bgcolor="#FFFFFF">
<%
	}else{
		i=0;
%>
<TR bgcolor="#F6F6F6">
<%
}
%>
    <TD><a href='/web/HrmCareerApplyViewDetail.jsp?paraid=<%=id%>'><%=Util.add0(Util.getIntValue(id),12)%></a></TD>
	<TD><%=JobTitlesComInfo.getJobTitlesname(careername)%> </TD>
	<TD>
        <div align="center">
        <%=careerpeople%></div></TD>
	<TD><div align="center"><%=careersexstr%></div></TD>
	<TD><div align="center"><%=careeredustr%></div></TD>	
	<TD><div align="center"><%=createdate%></div></TD>
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