<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<% if(!HrmUserVarify.checkUserRight("FnaBudgetModuleAdd:Add",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
   }
%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</head>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(567,user.getLanguage())+" : "+SystemEnv.getHtmlLabelName(365,user.getLanguage());
String needfav ="1";
String needhelp ="";
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
<tr style="height:1px">
<td height="0" colspan="3"></td>
</tr>
<tr>
<td ></td>
<td valign="top">
<TABLE class=Shadow>
<tr>
<td valign="top">

<FORM id=frmMain action=FnaBudgetModuleOperation.jsp method=post onsubmit='return checkvalue()'>
  <input class=inputstyle type=hidden name=operation value="addbudgetmodule">
  <TABLE class=VIEWForm>
  <TBODY>
  <TR>
    <TH class=title align=left><%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%></TH></TR>
  <TR class=spacing>
    <TD class=sep1 colSpan=4></TD></TR></TBODY></TABLE>
  <TABLE class=viewForm id=tblScenarioCode>
    <THEAD> 
    <COLGROUP> 
    <COL width="15%"> 
    <COL width="30%"> 
    <COL width="15%"> 
    <COL width="40%">
    </THEAD> 
    <TBODY> 
    <TR> 
      <TD><%=SystemEnv.getHtmlLabelName(567,user.getLanguage())%></TD>
      <TD class=FIELD>
        <input class=inputstyle id=budgetname name=budgetname maxlength="20" onchange='checkinput("budgetname","budgetnameimage")' size="15">
        <SPAN id=budgetnameimage><IMG src="/images/BacoError_wev8.gif" align=absMiddle></SPAN></TD>
      <TD><%=SystemEnv.getHtmlLabelName(445,user.getLanguage())%> </TD>
      <TD class=field>
        <select class=inputstyle name="fnayear">
<%
RecordSet.executeProc("FnaYearsPeriods_Select","");
while(RecordSet.next()) {
	String fnayear = RecordSet.getString("fnayear") ;
%>
          <option value="<%=fnayear%>"><%=fnayear%></option>
<%}%>
        </select>
      </TD>
    </TR>
    <TR style="height:1px"><TD class=Line colSpan=6></TD></TR> 
    <TR> 
      <TD><%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%></TD>
      <TD class=FIELD><nobr>
        <input class=inputstyle id=budgetdesc name=budgetdesc maxlength="100" onchange='checkinput("budgetdesc","budgetdescimage")' size="30">
        <SPAN id=budgetdescimage><IMG src="/images/BacoError_wev8.gif" align=absMiddle></SPAN></TD>
      <TD><%=SystemEnv.getHtmlLabelName(1459,user.getLanguage())%></TD>
      <TD class=field> 
        <input class=inputstyle id=periodsidfrom name=periodsidfrom maxlength="2" onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("periodsidfrom");checkinput("periodsidfrom","periodsidfromimage")' size="8">
        <SPAN id=periodsidfromimage>
		<IMG src="/images/BacoError_wev8.gif" align=absMiddle></SPAN> 
        <input class=inputstyle id=periodsidto name=periodsidto maxlength="2" onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("periodsidto");checkinput("periodsidto","periodsidtoimage")' size="8">
        <SPAN id=periodsidtoimage><IMG src="/images/BacoError_wev8.gif" align=absMiddle></SPAN>
		</TD>
    </TR>
        <TR style="height:1px"><TD class=Line colSpan=6></TD></TR> 

    </TBODY>
  </TABLE>
</FORM>
</td>
</tr>
</TABLE>
</td>
<td></td>
</tr>
<tr style="height:0px">
<td height="0" colspan="3"></td>
</tr>
</table>
<script language=javascript>  
function submitData() {
 frmMain.submit();
}

function checkvalue() {
	if(!check_form(frmMain,"budgetname,budgetdesc,periodsidfrom,periodsidto")) return false ;
	if(frmMain.periodsidfrom.value < 1 ||
	   frmMain.periodsidfrom.value > 13 ||
	   frmMain.periodsidto.value < 1 ||
	   frmMain.periodsidto.value >13 ) {
		alert("<%=SystemEnv.getHtmlNoteName(28,user.getLanguage())%>");
		return false;
	}
	return true ;
}
</script>
</BODY></HTML>
