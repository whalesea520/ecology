<%@ page import="weaver.general.Util,java.util.*,java.math.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</head>
<%
int msgid = Util.getIntValue(request.getParameter("msgid"),-1);
String applyid = Util.null2String(request.getParameter("applyid")) ;

char separator = Util.getSeparator() ;

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename =SystemEnv.getHtmlLabelName(773,user.getLanguage())+" : "+SystemEnv.getHtmlLabelName(365,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(815,user.getLanguage())+",../resource/HrmResourceLanguageAbilityAdd.jsp?applyid="+applyid+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(615,user.getLanguage())+",/hrm/career/HrmCareerApply.jsp?,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
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
<%if(msgid!=-1){%>
<DIV>
<font color=red size=2>
<%=SystemEnv.getErrorMsgName(msgid,user.getLanguage())%>
</font>
</DIV>
<%}%>
<TABLE class=ListStyle cellspacing=1 >
  <TBODY> 
  <TR class=Header> 
    <TH colSpan=5><%=SystemEnv.getHtmlLabelName(813,user.getLanguage())%></TH>
  </TR>
   <TR class=Header> 
    <TD width="20%"><%=SystemEnv.getHtmlLabelName(742,user.getLanguage())%></TD>
    <TD width="20%"><%=SystemEnv.getHtmlLabelName(743,user.getLanguage())%></TD>
    <TD width="50%"><%=SystemEnv.getHtmlLabelName(1850,user.getLanguage())%></TD>
	<TD width="10%"></TD>
  </TR>
  <TR class=Line><TD colspan="5" ></TD></TR> 
<%
int j=0;
RecordSet.executeProc("HrmEducationInfo_SByResourceID",applyid);

while(RecordSet.next()){
String id = RecordSet.getString("id");
String startdate = RecordSet.getString("startdate");
String enddate = RecordSet.getString("enddate");
String school = RecordSet.getString("school");
if(j==0){
		j=1;
%>
<TR class=DataLight>
<%
	}else{
		j=0;
%>
<TR class=DataDark>
<%
}
%>
	<td><%=Util.toScreen(startdate,user.getLanguage())%></td>
    <td><%=Util.toScreen(enddate,user.getLanguage())%></td>
    <td><%=Util.toScreen(school,user.getLanguage())%></td>
    <td><a href="../resource/HrmResourceEducationInfoEdit.jsp?applyeducationinfoid=<%=id%>">
	<%=SystemEnv.getHtmlLabelName(361,user.getLanguage())%></a></td>
</TR>
<%}
%>
  </TBODY> 
</TABLE>
<br>
<TABLE class=ListStyle cellspacing=1 >
  <TBODY> 
  <TR class=Header> 
    <TH colSpan=5><%=SystemEnv.getHtmlLabelName(812,user.getLanguage())%></TH>
  </TR>
   <TR class=Header> 
    <TD width="20%"><%=SystemEnv.getHtmlLabelName(742,user.getLanguage())%></TD>
    <TD width="20%"><%=SystemEnv.getHtmlLabelName(743,user.getLanguage())%></TD>
    <TD width="50%"><%=SystemEnv.getHtmlLabelName(1851,user.getLanguage())%></TD>
	<TD width="10%"></TD>
  </TR>
  <TR class=Line><TD colspan="5" ></TD></TR> 
<%
int i=0;
RecordSet.executeProc("HrmWorkResume_SByResourceID",applyid);

while(RecordSet.next()){
String id = RecordSet.getString("id");
String startdate = RecordSet.getString("startdate");
String enddate = RecordSet.getString("enddate");
String company = RecordSet.getString("company");
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
	<td><%=Util.toScreen(startdate,user.getLanguage())%></td>
    <td><%=Util.toScreen(enddate,user.getLanguage())%></td>
    <td><%=Util.toScreen(company,user.getLanguage())%></td>
    <td><a href="../resource/HrmResourceWorkResumeEdit.jsp?applyworkresumeid=<%=id%>">
	<%=SystemEnv.getHtmlLabelName(361,user.getLanguage())%></a></td>
</TR>
<%}
%>
  </TBODY> 
</TABLE>
<br>
<TABLE class=ListStyle cellspacing=1 >
  <TBODY> 
  <TR class=Header> 
    <TH colSpan=5><%=SystemEnv.getHtmlLabelName(815,user.getLanguage())%></TH>
  </TR>
   <TR class=Header> 
    <TD width="20%"><%=SystemEnv.getHtmlLabelName(1954,user.getLanguage())%></TD>
    <TD width="20%"><%=SystemEnv.getHtmlLabelName(139,user.getLanguage())%></TD>
    <TD width="50%"><%=SystemEnv.getHtmlLabelName(454,user.getLanguage())%></TD>
	<TD width="10%"></TD>
  </TR>
  <TR class=Line><TD colspan="5" ></TD></TR> 
<%
 i=0;
RecordSet.executeProc("HrmLanguageAbility_SByResourID",applyid);

while(RecordSet.next()){
String id = RecordSet.getString("id");
String language = RecordSet.getString("language");
String level = RecordSet.getString("level");
String memo = RecordSet.getString("memo");
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
	<td><%=language%></td>
    <td>
		<%if (level.equals("0")) {%><%=SystemEnv.getHtmlLabelName(154,user.getLanguage())%><%}%>
        <%if (level.equals("1")) {%><%=SystemEnv.getHtmlLabelName(821,user.getLanguage())%><%}%>
		<%if (level.equals("2")) {%><%=SystemEnv.getHtmlLabelName(822,user.getLanguage())%><%}%>
        <%if (level.equals("3")) {%><%=SystemEnv.getHtmlLabelName(823,user.getLanguage())%><%}%>
	</td>
    <td><%=Util.toScreen(memo,user.getLanguage())%></td>
    <td><a href="../resource/HrmResourceLanguageAbilityEdit.jsp?applylanguageabilityid=<%=id%>"><%=SystemEnv.getHtmlLabelName(361,user.getLanguage())%></a></td>
</TR>
<%}
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
</BODY>
</HTML>