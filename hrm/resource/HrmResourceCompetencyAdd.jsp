<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CompetencyComInfo" class="weaver.hrm.job.CompetencyComInfo" scope="page"/>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</head>
<% if(!HrmUserVarify.checkUserRight("HrmResourceCompetencyAdd:Add",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
   }
%>
<%
String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(179,user.getLanguage())+": "+ SystemEnv.getHtmlLabelName(408,user.getLanguage());
String needfav ="1";
String needhelp ="";
String resourceid = Util.null2String(request.getParameter("resourceid"));
String jobactivity = Util.null2String(request.getParameter("jobactivity"));
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;
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

<FORM id=competencyadd name=frmMain action=HrmResourceCompetencyOperation.jsp method=post>
<input type=hidden name="operation" value="addcompetency">
<input type=hidden name="resourceid" value="<%=resourceid%>">
<TABLE class=viewFORM>
  <COLGROUP>
  <COL width="30%">
  <COL width="70%">
  <TBODY>
  <TR class=title>
      <TH colSpan=2><%=SystemEnv.getHtmlLabelName(87,user.getLanguage())%></TH>
    </TR>
  <TR class=spacing>
    <TD class=line1 colSpan=2></TD></TR>
  <TR>
      <TD><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></TD>
      <TD class=Field><%=Util.toScreen(ResourceComInfo.getResourcename(resourceid),user.getLanguage())%></TD>
    </TR>
    <TR><TD class=Line colSpan=2></TD></TR> 
<%
RecordSet.executeProc("HrmActivitiesCompetency_Select",jobactivity);
while(RecordSet.next()) {
String competencyid = RecordSet.getString("competencyid") ;
%>
  <TR>
    <TD><%=Util.toScreen(CompetencyComInfo.getCompetencyname(competencyid),user.getLanguage())%></TD>
    <TD class=FIELD><INPUT class=inputstyle 
      maxLength=6 size=10
      name="<%=competencyid%>" onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("<%=competencyid%>")'></TD></TR>
<%}%>
</TBODY>
</TABLE>
</FORM>
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
 frmMain.submit();
}
</script>

</BODY>
</HTML>
