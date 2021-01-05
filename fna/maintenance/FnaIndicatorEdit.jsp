<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="IndicatorComInfo" class="weaver.fna.maintenance.IndicatorComInfo" scope="page" />
<jsp:useBean id="LedgerComInfo" class="weaver.fna.maintenance.LedgerComInfo" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</head>
<%
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
<%
if(msgid!=-1){
%>
<DIV>
<font color=red size=2>
<%=SystemEnv.getErrorMsgName(msgid,user.getLanguage())%>
</font>
</DIV>
<%}%>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(canedit) {
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onEdit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(HrmUserVarify.checkUserRight("FnaIndicatorAdd:Add",user)) {
RCMenu += "{"+SystemEnv.getHtmlLabelName(365,user.getLanguage())+",/fna/maintenance/FnaIndicatorAdd.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(HrmUserVarify.checkUserRight("FnaIndicatorEdit:Delete",user)) {
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(HrmUserVarify.checkUserRight("FnaIndicator:Log",user)) {
RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem ="+42+" and relatedid="+id+",_self} " ;
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

<FORM id=frmMain action=FnaIndicatorOperation.jsp method=post>
  <input class=inputstyle type=hidden name=operation>
  <input class=inputstyle type=hidden name=id value="<%=id%>">
  <input class=inputstyle type=hidden name=oldindicatorname value="<%=indicatorname%>">
  <input class=inputstyle type=hidden name=indicatortype value="<%=indicatortype%>">
  <TABLE class=viewForm>
  <TBODY>
  <TR>
    <TH class=title align=left><%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%></TH></TR>
  <TR class=separator>
    <TD class=line1 colSpan=4></TD></TR>
    </TBODY></TABLE>
  <table class=viewForm id=tblScenarioCode>
    <thead> <colgroup> 
    <col width="15%"> 
    <col width="30%"> 
    <col width="15%"> 
    <col width="40%">
    </thead> 
    <tbody> 
    <tr> 
      <td><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></td>
      <td class=FIELD> <% if(canedit) {%>
        <input class=inputstyle id=indicatorname name=indicatorname maxlength="20" onChange='checkinput("indicatorname","indicatornameimage")' size="15" value="<%=Util.toScreenToEdit(indicatorname,user.getLanguage())%>">
        <span id=indicatornameimage></span>
		<%} else {%><%=Util.toScreen(indicatorname,user.getLanguage())%><%}%>
		</td>
      <td> 
        <% if(indicatortype.equals("0")) {%>
        <%=SystemEnv.getHtmlLabelName(1463,user.getLanguage())%> 
        <%} else if(indicatortype.equals("2")){%>
        <%=SystemEnv.getHtmlLabelName(1464,user.getLanguage())%> 
        <%}%>
      </td>
      <td <% if(indicatortype.equals("0") || indicatortype.equals("2")) {%> class=field <%}%>> 
        <% if(indicatortype.equals("0")) {%>
		<% if(canedit) {%>
        <select class=inputstyle id=indicatorbalance name=indicatorbalance>
          <option value=1 <%if(indicatorbalance.equals("1")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(1465,user.getLanguage())%></option>
          <option value=2 <%if(indicatorbalance.equals("2")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(1466,user.getLanguage())%></option>
        </select>
		<%} else {%> <%if(indicatorbalance.equals("1")) {%><%=SystemEnv.getHtmlLabelName(1465,user.getLanguage())%><%}%>
					<%if(indicatorbalance.equals("2")) {%><%=SystemEnv.getHtmlLabelName(1466,user.getLanguage())%><%}%>
		<%}%>
        <%} else if(indicatortype.equals("2")){%>
        <input class=inputstyle type="checkbox" name="haspercent" value="1" <%if(haspercent.equals("1")) {%> checked <%} if(!canedit) {%> disabled <%}%>>
        <%}%>
      </td>
    </tr>
   <TR><TD class=Line colSpan=2></TD></TR> 
    <tr> 
      <td><%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%></td>
      <td class=FIELD><nobr> <% if(canedit) {%>
        <input class=inputstyle id=indicatordesc name=indicatordesc maxlength="100" onChange='checkinput("indicatordesc","indicatordescimage")' size="30" value="<%=Util.toScreenToEdit(indicatordesc,user.getLanguage())%>">
        <span id=indicatordescimage></span>
		<%}else{%><%=Util.toScreen(indicatordesc,user.getLanguage())%><%}%>
	  </td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <TR><TD class=Line colSpan=2></TD></TR> 
    <tr> 
      <td><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></td>
      <td class=FIELD> 
        <%if(indicatortype.equals("0")) {%><%=SystemEnv.getHtmlLabelName(189,user.getLanguage())%>
        <%} else if(indicatortype.equals("1")) {%><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%>
		<%} else if(indicatortype.equals("2")) {%><%=SystemEnv.getHtmlLabelName(449,user.getLanguage())%>
		<%}%>
      </td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
  <TR><TD class=Line colSpan=2></TD></TR> 
    <% if(indicatortype.equals("2")) {%>
    <tr class=title> 
      <th colspan=4><%=SystemEnv.getHtmlLabelName(449,user.getLanguage())%></th>
    </tr>
    <tr class=spacing>
      <td colspan=4 class="sep2"></td>
    </tr>
    <tr> 
      <td>&nbsp;</td>
      <td> 
        <table width="100%">
          <colgroup> <col width="48%"> <col align=middle width="4%"> <col width="48%"> 
          <tbody> 
          <tr> 
            <td class=FIELD><button class=Browser id=SelectIndicator onClick="onShowIndicator(indicatoridfirstspan,indicatoridfirst)"></button> 
              <span class=inputstyle id=indicatoridfirstspan><%=Util.toScreen(IndicatorComInfo.getIndicatorname(indicatoridfirst),user.getLanguage())%></span> 
              <input class=inputstyle id=indicatoridfirst type=hidden name=indicatoridfirst value="<%=indicatoridfirst%>">
            </td>
            <td>/ </td>
            <td class=FIELD><button class=Browser id=SelectIndicator onClick="onShowIndicator(indicatoridlastspan,indicatoridlast)"></button> 
              <span class=inputstyle id=indicatoridlastspan><%=Util.toScreen(IndicatorComInfo.getIndicatorname(indicatoridlast),user.getLanguage())%></span> 
              <input class=inputstyle id=indicatoridlast type=hidden name=indicatoridlast value="<%=indicatoridlast%>">
            </td>
          </tr>
        <TR><TD class=Line colSpan=2></TD></TR> 
          </tbody> 
        </table>
      </td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <%}%>
    </tbody> 
  </table>
  <% if(indicatortype.equals("0")) {%>
  <br>
  <table class=ListStyle cellspacing=1>
    <colgroup>
   <col width="30%"> 
   <col width="55%"> 
    <% if(canedit) {%>
    <col width="15%"> 
    <% }%>
    <tbody> 
    <tr> 
      <td ><%=SystemEnv.getHtmlLabelName(585,user.getLanguage())%></td>
      <td align=right colspan=3>
        <% if(canedit) {%>
        <button class=Btn id=button1 accesskey=1 
      onClick='onShowLedger()' 
      name=button1><u>1</u>-<%=SystemEnv.getHtmlLabelName(193,user.getLanguage())%></button>
        <%}%>
      </td>
    </tr>
      <tr class=Header> 
      <td><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></td>
      <td><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></td>
      <% if(canedit) {%>
      <td><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></td>
      <%}%>
    </tr>
    <%
RecordSet.executeProc("FnaIndicatordetail_SelectByID",id);
int i=0;
while(RecordSet.next()) {
String theid = RecordSet.getString("id") ;
String ledgerid = RecordSet.getString("ledgerid") ;
if(i==0){
	i=1;
%>
    <tr class=DataLight> 
      <%
}else{
	i=0;
%>
    <tr class=DataDark> 
      <%
}
%>
      <td><%=Util.null2String(LedgerComInfo.getLedgermark(ledgerid))%></td>
      <td><%=Util.toScreen(LedgerComInfo.getLedgername(ledgerid),user.getLanguage())%></td>
      <% if(canedit) {%>
      <td><a href="FnaIndicatorOperation.jsp?operation=deleteledger&id=<%=theid%>&indicatorid=<%=id%>" ><img border=0 src="/images/icon_delete_wev8.gif"></a></td>
      <% }%>
    </tr>
    <%}%>
    </tbody>
  </table>
 <%}%>
  <br>
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
<Script language=vbs>
sub onShowLedger()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/fna/maintenance/FnaLedgerAllBrowser.jsp")
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

</script>
<Script language=javascript>
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
</script>
</BODY></HTML>
