<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</head>
<%
String imagefilename = "/images/hdHRMCard_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(179,user.getLanguage())+": "+ SystemEnv.getHtmlLabelName(384,user.getLanguage());
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
<FORM id=skilladd name=frmMain action=HrmResourceSkillOperation.jsp method=post >
<input class=inputstyle type=hidden name="operation" value="addskill">
<input class=inputstyle type=hidden name="resourceid" value="<%=resourceid%>">
<input class=inputstyle type=hidden name="jobactivity" value="<%=jobactivity%>">
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
    <TD class=Field><%=Util.toScreen(ResourceComInfo.getResourcename(resourceid),user.getLanguage())%> - <%=jobactivity%>
    </TD>
    </TR>
<TR><TD class=Line colSpan=2></TD></TR> 
  <TR>
    <TD><%=SystemEnv.getHtmlLabelName(384,user.getLanguage())%></TD>
    <TD class=FIELD id=Skill><INPUT class=inputstyle 
      maxLength=60 onchange='checkinput("skilldesc","skilldescimage")' size=60 
      name=skilldesc><SPAN id=skilldescimage><IMG 
      src="/images/BacoError_wev8.gif" align=absMiddle></SPAN></TD>
      </TR>
<TR><TD class=Line colSpan=2></TD></TR> 
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
 if(check_form(frmMain,"skilldesc")){
 frmMain.submit();
 }
}
</script>
</BODY>
</HTML>