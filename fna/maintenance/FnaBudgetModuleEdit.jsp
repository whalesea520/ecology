<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</head>
<%
String id = Util.null2String(request.getParameter("id"));
int msgid = Util.getIntValue(request.getParameter("msgid"),-1);
RecordSet.executeProc("FnaBudgetModule_SelectByID",id);
RecordSet.next();
String thefnayear = Util.null2String(RecordSet.getString("fnayear"));
String budgetname = RecordSet.getString("budgetname");
String budgetdesc = RecordSet.getString("budgetdesc");
String periodsidfrom = Util.null2String(RecordSet.getString("periodsidfrom"));
String periodsidto = Util.null2String(RecordSet.getString("periodsidto"));
boolean canedit = HrmUserVarify.checkUserRight("FnaBudgetModuleEdit:Edit", user) ;

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(567,user.getLanguage())+" : "+Util.toScreen(budgetname,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
 if(canedit) {
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onEdit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(HrmUserVarify.checkUserRight("FnaBudgetModuleAdd:Add",user)) {
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",fna/maintenance/FnaBudgetModuleAdd.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(HrmUserVarify.checkUserRight("FnaBudgetModuleEdit:Delete",user)) {
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(HrmUserVarify.checkUserRight("FnaBudgetModule:Log",user)) {
RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem ="+38+" and relatedid="+id+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr style="height:0px">
<td height="0" colspan="3"></td>
</tr>
<tr>
<td ></td>
<td valign="top">
<TABLE class=Shadow>
<tr>
<td valign="top">

<%
if(msgid!=-1){
%>
<DIV>
<font color=red size=2>
<%=SystemEnv.getErrorMsgName(msgid,user.getLanguage())%>
</font>
</DIV>
<%}%>
<FORM id=frmMain action=FnaBudgetModuleOperation.jsp method=post>
  <input class=inputstyle type=hidden name=operation>
  <input class=inputstyle type=hidden name=id value="<%=id%>">
  <TABLE class=Form>
  <TBODY>
  <TR>
    <TH class=title align=left><%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%></TH></TR>
  <TR class=separator>
    </TBODY></TABLE>
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
      <TD class=FIELD><% if(canedit) {%>
        <input class=inputstyle id=budgetname name=budgetname maxlength="20" onchange='checkinput("budgetname","budgetnameimage")' size="15" value="<%=Util.toScreenToEdit(budgetname,user.getLanguage())%>">
        <SPAN id=budgetnameimage></SPAN>
		<%}else {%><%=Util.toScreen(budgetname,user.getLanguage())%><%}%>
		</TD>
      <TD><%=SystemEnv.getHtmlLabelName(445,user.getLanguage())%> </TD>
      <TD class=field><% if(canedit) {%>
        <select class=inputstyle name="fnayear">
<%
RecordSet.executeProc("FnaYearsPeriods_Select","");
while(RecordSet.next()) {
	String fnayear = RecordSet.getString("fnayear") ;
%>
          <option value="<%=fnayear%>" <% if(thefnayear.equals(fnayear)) {%>selected<%}%>><%=fnayear%></option>
<%}%>
        </select>
		<%} else {%><%=thefnayear%><%}%>
      </TD>
    </TR>
    <TR style="height:1px"><TD class=Line colSpan=6></TD></TR> 
    <TR> 
      <TD><%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%></TD>
      <TD class=FIELD><nobr><% if(canedit) {%>
        <input class=inputstyle id=budgetdesc name=budgetdesc maxlength="100" onchange='checkinput("budgetdesc","budgetdescimage")' size="30"  value="<%=Util.toScreenToEdit(budgetdesc,user.getLanguage())%>">
        <SPAN id=budgetdescimage></SPAN>
		<%}else {%><%=Util.toScreen(budgetdesc,user.getLanguage())%><%}%>
		</TD>
      <TD><%=SystemEnv.getHtmlLabelName(1459,user.getLanguage())%></TD>
      <TD class=field><% if(canedit) {%>
        <input class=inputstyle id=periodsidfrom name=periodsidfrom maxlength="2" onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("periodsidfrom");checkinput("periodsidfrom","periodsidfromimage")' size="8" value="<%=periodsidfrom%>">
        <SPAN id=periodsidfromimage></SPAN>
        <input class=inputstyle id=periodsidto name=periodsidto maxlength="2" onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("periodsidto");checkinput("periodsidto","periodsidtoimage")' size="8" value="<%=periodsidto%>">
        <SPAN id=periodsidtoimage></SPAN>
		<%}else {%><%=periodsidfrom%> - <%=periodsidto%><%}%>
		</TD>
    </TR>
<TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
    </TBODY>
  </TABLE>
</FORM>
</td>
</tr>
</TABLE>
</td>
<td></td>
</tr>
<tr  style="height:0px">
<td height="0" colspan="3"></td>
</tr>
</table>
<Script language=javascript>
function onEdit() {
	if(check_form(frmMain,"budgetname,budgetdesc,periodsidfrom,periodsidto")) {
		if(frmMain.periodsidfrom.value < 1 ||
		   frmMain.periodsidfrom.value > 13 ||
		   frmMain.periodsidto.value < 1 ||
		   frmMain.periodsidto.value >13 ) {
			alert("<%=SystemEnv.getHtmlNoteName(28,user.getLanguage())%>");
		}
		else {
			frmMain.operation.value="editbudgetmodule";
			frmMain.submit();
		}
	}
}
 function onDelete(){
		if(confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>")) {
			frmMain.operation.value="deletebudgetmodule";
			frmMain.submit();
		}
}
</script>
</BODY>
</HTML>