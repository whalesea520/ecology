<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="IndicatorComInfo" class="weaver.fna.maintenance.IndicatorComInfo" scope="page" />
<jsp:useBean id="BudgetfeeTypeComInfo" class="weaver.fna.maintenance.BudgetfeeTypeComInfo" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type="text/css" rel="STYLESHEET">
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></SCRIPT>
</HEAD>
<%
if (true) {
    response.sendRedirect("/notice/noright.jsp");
    return;
}
String id = Util.null2String(request.getParameter("id"));
int msgid = Util.getIntValue(request.getParameter("msgid"),-1);
RecordSet.executeProc("FnaIndicator_SelectByID",id);
RecordSet.next();
String indicatorname = RecordSet.getString("indicatorname") ;
String indicatordesc = RecordSet.getString("indicatordesc") ;
String indicatortype = Util.null2String(RecordSet.getString("indicatortype")) ;
String indicatorbalance = Util.null2String(RecordSet.getString("indicatorbalance")) ;
String haspercent = Util.null2String(RecordSet.getString("haspercent")) ;
String indicatoridfirst = Util.null2String(RecordSet.getString("indicatoridfirst")) ;
String indicatoridlast = Util.null2String(RecordSet.getString("indicatoridlast")) ;

boolean canedit = HrmUserVarify.checkUserRight("FnaIndicatorEdit:Edit", user) ;


String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(564,user.getLanguage())+" : "+Util.toScreen(indicatorname,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%
if(canedit){
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onEdit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(HrmUserVarify.checkUserRight("FnaIndicatorAdd:Add",user)) {
RCMenu += "{"+SystemEnv.getHtmlLabelName(365,user.getLanguage())+",/fna/indicator/FnaIndicatorAdd.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(HrmUserVarify.checkUserRight("FnaIndicatorEdit:Delete",user)) {
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(HrmUserVarify.checkUserRight("FnaIndicator:Log",user)) {
RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem =42 and relatedid="+id+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<TABLE width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
<COLGROUP>
<COL width="10">
<COL width="">
<COL width="10">
<TR>
	<TD height="10" colspan="3"></TD>
</TR>
<TR>
	<TD></TD>
	<TD valign="top">
		<TABLE class="Shadow">
		<TR>
		<TD valign="top">

<%
if(msgid!=-1){
%>
<DIV>
<FONT color="red" size="2">
<%=SystemEnv.getErrorMsgName(msgid,user.getLanguage())%>
</FONT>
</DIV>
<%}%>
<FORM id="frmMain" action="FnaIndicatorOperation.jsp" method="post">
  
  <INPUT type="hidden" name="operation">
  <INPUT type="hidden" name="id" value="<%=id%>">
  <INPUT type="hidden" name="oldindicatorname" value="<%=indicatorname%>">
  <INPUT type="hidden" name="indicatortype" value="<%=indicatortype%>">
  <TABLE class="ViewForm">
  <TBODY>
  <TR>
    <TH class="Title" align="left"><%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%></TH></TR>
  <TR class="Spacing" style="height: 1px;">
    <TD class="Line1" colSpan="4" style="padding: 0px;"></TD></TR></TBODY></TABLE>
  <TABLE class="ViewForm" id="tblScenarioCode">
    <THEAD> <COLGROUP> <COL width="15%"> <COL width="30%"> <COL width="15%"> <COL width="40%"></THEAD> 
    <TBODY> 
    <TR> 
      <TD><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
      <TD class="FIELD"> <% if(canedit) {%>
        <INPUT class="inputstyle" id="indicatorname" name="indicatorname" maxlength="20" onChange='checkinput("indicatorname","indicatornameimage")' size="15" value="<%=Util.toScreenToEdit(indicatorname,user.getLanguage())%>">
        <SPAN id="indicatornameimage"></SPAN>
		<%} else {%><%=Util.toScreen(indicatorname,user.getLanguage())%><%}%>
		</TD>
      <TD> 
        <% if(indicatortype.equals("0")) {%>
        <%=SystemEnv.getHtmlLabelName(1463,user.getLanguage())%> 
        <%} else if(indicatortype.equals("2")){%>
        <%=SystemEnv.getHtmlLabelName(1464,user.getLanguage())%>
        <%}%>
      </TD>
      <TD <% if(indicatortype.equals("0") || indicatortype.equals("2")) {%> class="field" <%}%>> 
        <% if(indicatortype.equals("0")) {%>
		<% if(canedit) {%>
        <SELECT class="inputstyle" class="inputstyle" id="indicatorbalance" name="indicatorbalance">
          <OPTION value="1" <%if(indicatorbalance.equals("1")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(566,user.getLanguage())%></OPTION>
          <OPTION value="2" <%if(indicatorbalance.equals("2")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(629,user.getLanguage())%></OPTION>
        </SELECT>
		<%} else {%> <%if(indicatorbalance.equals("1")) {%><%=SystemEnv.getHtmlLabelName(1465,user.getLanguage())%><%}%>
					<%if(indicatorbalance.equals("2")) {%><%=SystemEnv.getHtmlLabelName(1466,user.getLanguage())%><%}%>
		<%}%>
        <%} else if(indicatortype.equals("2")){%>
        <INPUT class="inputstyle" type="checkbox" name="haspercent" value="1" <%if(haspercent.equals("1")) {%> checked <%} if(!canedit) {%> disabled <%}%>>
        <%}%>
      </TD>
    </TR><TR style="height: 1px;"><TD class="Line" colSpan="2" style="padding: 0px;"></TD><TD></TD><TD class="Line" colSpan="2" style="padding: 0px;"></TD></TR>
    <TR> 
      <TD><%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%></TD>
      <TD class="FIELD"><NOBR> <% if(canedit) {%>
        <INPUT class="inputstyle" id="indicatordesc" name="indicatordesc" maxlength="100" onChange='checkinput("indicatordesc","indicatordescimage")' size="30" value="<%=Util.toScreenToEdit(indicatordesc,user.getLanguage())%>">
        <SPAN id=indicatordescimage></SPAN>
		<%}else{%><%=Util.toScreen(indicatordesc,user.getLanguage())%><%}%>
	  </TD>
      <TD>&nbsp;</TD>
      <TD>&nbsp;</TD>
    </TR><TR style="height: 1px;"><TD class="Line" colSpan="2" style="padding: 0px;"></TD><TD colSpan="3"></TD></TR>
	
    <% if(indicatortype.equals("2")) {%>
    <TR class="Title"> 
      <TH colspan="4"><%=SystemEnv.getHtmlLabelName(449,user.getLanguage())%></TH>
    </TR>
    <TR class="Seperator">
      <TD colspan="4" class="sep2"></TD>
    </TR>
    <TR> 
      <TD>&nbsp;</TD>
      <TD> 
        <TABLE width="100%">
          <COLGROUP> <COL width="48%"> <COL align="middle" width="4%"> <COL width="48%"> 
          <TBODY> 
          <TR> 
            <TD class="FIELD"><BUTTON class="Browser" id="SelectIndicator" onClick="onShowIndicator(indicatoridfirstspan,indicatoridfirst)"></BUTTON> 
              <SPAN class="inputstyle" id="indicatoridfirstspan"><%=Util.toScreen(IndicatorComInfo.getIndicatorname(indicatoridfirst),user.getLanguage())%></SPAN> 
              <INPUT id="indicatoridfirst" type="hidden" name="indicatoridfirst" value="<%=indicatoridfirst%>">
            </TD>
            <TD>/ </TD>
            <TD class="FIELD"><BUTTON class="Browser" id="SelectIndicator" onClick="onShowIndicator(indicatoridlastspan,indicatoridlast)"></BUTTON> 
              <SPAN class="inputstyle" id="indicatoridlastspan"><%=Util.toScreen(IndicatorComInfo.getIndicatorname(indicatoridlast),user.getLanguage())%></SPAN> 
              <INPUT id="indicatoridlast" type="hidden" name="indicatoridlast" value="<%=indicatoridlast%>">
            </TD>
          </TR>
          </TBODY> 
        </TABLE>
      </TD>
      <TD>&nbsp;</TD>
      <TD>&nbsp;</TD>
    </TR>
    <%}%>
    </TBODY> 
  </TABLE>
  <% if(indicatortype.equals("0")) {%>
  <BR>
  <TABLE class="ListStyle" cellspacing="1">
    <COLGROUP>
	<% if (canedit) {%>
	<COL width="85%">    
    <COL width="15%"> 
    <%} else {%>
	<COL width="100%">
	<%}%>
    <TBODY> 
    <TR class="Header">
      <TD><%=SystemEnv.getHtmlLabelName(15385,user.getLanguage())%></TD>
	  <%if (canedit) {%>
      <TD><%=SystemEnv.getHtmlLabelName(193,user.getLanguage())%>:<BUTTON class="Browser" id="SelectBudgetType" onClick="onShowBudgetType()"></BUTTON></TD><%}%>
    </TR>
    <TR class="Spacing" style="height: 1px;"> 
      <TD class="Line1" colspan="<%=(canedit ? "2" : "1")%>" style="padding: 0px;"></TD>
    </TR>
    <TR class="Header"> 
      <TD><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
      <% if(canedit) {%>
      <TD><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></TD>
      <%}%>
    </TR>
    <%
RecordSet.executeProc("FnaIndicatordetail_SelectByID",id);
int i=0;
while(RecordSet.next()) {
String theid = RecordSet.getString("id") ;
String ledgerid = RecordSet.getString("ledgerid") ;
if(i==0){
	i=1;
%>
    <TR class="DataLight"> 
      <%
}else{
	i=0;
%>
    <TR class="DataDark"> 
      <%
}
%>
      <TD><%=Util.toScreen(BudgetfeeTypeComInfo.getBudgetfeeTypename(ledgerid),user.getLanguage())%></TD>
      <% if(canedit) {%>
      <TD><A href="FnaIndicatorOperation.jsp?operation=deleteledger&id=<%=theid%>&indicatorid=<%=id%>" ><IMG border="0" src="/images/icon_delete_wev8.gif"></A></TD>
      <% }%>
    </TR>
    <%}%>
    </TBODY>
  </TABLE>
 <%}%>
  <BR>
</FORM>
    </TD>
		</TR>
		</TABLE>
	</TD>
	<TD></TD>
</TR>
<TR>
	<TD height="10" colspan="3"></TD>
</TR>
</TABLE>

<SCRIPT language="vbs">
sub onShowBudgetType()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/fna/maintenance/BudgetfeeTypeBrowser.jsp")
	if NOT isempty(id) then
	    if id(0)<> "" then
		location.href="FnaIndicatorOperation.jsp?operation=addledger&ledgerid="&id(0)&"&indicatorid=<%=id%>"
		end if
	end if
end sub

sub onShowIndicator(spanname,inputename)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/fna/maintenance/FnaIndicatorBrowser.jsp?sqlwhere=where indicatortype !='2'")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	spanname.innerHtml = id(1)
	inputename.value=id(0)
	else
	spanname.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
	inputename.value=""
	end if
	end if
end sub
</SCRIPT>

<SCRIPT language="javascript">
function onEdit() {
	parastr = "indicatorname,indicatordesc" ;
	if(frmMain.indicatortype.value == 2) parastr = parastr + ",indicatoridfirst,indicatoridlast" ;
	if(check_form(frmMain,parastr)) {
		frmMain.operation.value="editindicator";
		frmMain.submit() ;
	}
}
 function onDelete(){
		if(confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>")) {
			frmMain.operation.value="deleteindicator";
			frmMain.submit();
		}
}
</SCRIPT>
</BODY></HTML>