<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</head>
<%
String paraid = Util.null2String(request.getParameter("paraid")) ;
int msgid = Util.getIntValue(request.getParameter("msgid"),-1);
String paraids[] = Util.TokenizerString2(paraid,"_") ;
String ledgerid = paraids[1] ;

RecordSet.executeProc("FnaLedger_SelectByID",ledgerid);
RecordSet.next();
String ledgermark = RecordSet.getString("ledgermark");
String ledgername = RecordSet.getString("ledgername");
String ledgertype = RecordSet.getString("ledgertype");
String ledgergroup = RecordSet.getString("ledgergroup");	

String ledgerbalance = RecordSet.getString("ledgerbalance");
String autosubledger = RecordSet.getString("autosubledger");			
String ledgercurrency = RecordSet.getString("ledgercurrency");
String subledgercount = RecordSet.getString("subledgercount");

String supledgerid = RecordSet.getString("supledgerid");
String categoryid = RecordSet.getString("categoryid");
String initaccount = RecordSet.getString("initaccount");
String accountnum = RecordSet.getString("accountnum");

boolean canedit = HrmUserVarify.checkUserRight("FnaLedgerEdit:Edit", user) ;
boolean caneditinit = subledgercount.equals("0") && accountnum.equals("0") && canedit ;
String doinit ="0" ;
if(caneditinit) doinit ="1" ;


String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(585,user.getLanguage())+" : "+ Util.toScreen(ledgername,user.getLanguage());
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
if(HrmUserVarify.checkUserRight("FnaLedgerEdit:Delete", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
} if(HrmUserVarify.checkUserRight("FnaLedger:Log", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem ="+36+" and relatedid="+ledgerid+",_self} " ;
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

<FORM id=frmMain action=FnaLedgerOperation.jsp method=post name=frmMain>
 <input class=inputstyle type="hidden" name="ledgerid" value="<%=ledgerid%>">
 <input class=inputstyle type="hidden" name="operation">
  <input class=inputstyle type="hidden" name="supledgerid" value="<%=supledgerid%>">
  <input class=inputstyle type="hidden" name="categoryid" value="<%=categoryid%>">
  <input class=inputstyle type="hidden" name="doinit" value="<%=doinit%>">
  <table class=viewForm>
    <colgroup> 
    <col width="14%"> 
    <col width="27%"> 
    <col width="4%"> 
    <col width="14%"> 
    <col width="27%"> 
    <tbody> 
    <tr class=title> 
      <th colspan=7><%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%></th>
    </tr>
    <tr> 
      <td class=line1 colspan=7></td>
    </tr>
    <input class=inputstyle type=hidden value=0 name=BCValidate>
    <tr> 
      <td>-<%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></td>
      <td class=FIELD> <% if(canedit) {%>
        <input class=inputstyle accesskey=Z name=ledgermark size="15" onChange='checkinput("ledgermark","ledgermarkimage")' value="<%=Util.toScreenToEdit(ledgermark,user.getLanguage())%>">
        <span id=ledgermarkimage></span> 
		<%} else {%><%=Util.toScreen(ledgermark,user.getLanguage())%><%}%>
	</td>
    </tr>
   <TR><TD class=Line colSpan=2></TD></TR> 
    <tr> 
      <td><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></td>
      <td class=FIELD><nobr><% if(canedit) {%>
        <input class=inputstyle accesskey=Z name=ledgername size="30" onChange='checkinput("ledgername","ledgernameimage")' value="<%=Util.toScreenToEdit(ledgername,user.getLanguage())%>">
        <span id=ledgernameimage></span> 
		<%} else {%><%=Util.toScreen(ledgername,user.getLanguage())%><%}%>
	</td>
    <td></td>
      <td>-<%=SystemEnv.getHtmlLabelName(1467,user.getLanguage())%></td>
      <td class=FIELD> <% if(canedit) {%>
        <select class=InputStyle id=autosubledger 
      style="WIDTH: 150px" name=autosubledger>
          <option value=0 
        <% if(autosubledger.equals("0")) {%> selected <%}%>>-<%=SystemEnv.getHtmlLabelName(557,user.getLanguage())%></option>
          <option value=1 <% if(autosubledger.equals("1")) {%> selected <%}%>>-<%=SystemEnv.getHtmlLabelName(1468,user.getLanguage())%></option>
          <option value=2 <% if(autosubledger.equals("2")) {%> selected <%}%>>-<%=SystemEnv.getHtmlLabelName(1469,user.getLanguage())%></option>
		  <option value=3 <% if(autosubledger.equals("3")) {%> selected <%}%>>-<%=SystemEnv.getHtmlLabelName(1470,user.getLanguage())%></option>
		  <option value=4 <% if(autosubledger.equals("4")) {%> selected <%}%>>-<%=SystemEnv.getHtmlLabelName(1471,user.getLanguage())%></option>
        </select>
		<%} else if(autosubledger.equals("0")){%><%=SystemEnv.getHtmlLabelName(557,user.getLanguage())%>
		<%} else if(autosubledger.equals("1")){%><%=SystemEnv.getHtmlLabelName(1468,user.getLanguage())%>
		<%} else if(autosubledger.equals("2")){%><%=SystemEnv.getHtmlLabelName(1469,user.getLanguage())%>
		<%} else if(autosubledger.equals("3")){%><%=SystemEnv.getHtmlLabelName(1470,user.getLanguage())%>
		<%} else if(autosubledger.equals("4")){%>-<%=SystemEnv.getHtmlLabelName(1471,user.getLanguage())%><%}%>
      </td>
    </tr>
   <TR><TD class=Line colSpan=6></TD></TR> 
    <tr> 
      <td>-<%=SystemEnv.getHtmlLabelName(1472,user.getLanguage())%></td>
      <td class=FIELD>  <% if(canedit) {%>
        <select class=InputStyle id=ledgergroup 
      style="WIDTH: 150px" name=ledgergroup>
          <option value=1 
        <% if(ledgergroup.equals("1")) {%> selected <%}%>>-<%=SystemEnv.getHtmlLabelName(535,user.getLanguage())%></option>
          <option value=2 <% if(ledgergroup.equals("2")) {%> selected <%}%>>-<%=SystemEnv.getHtmlLabelName(1473,user.getLanguage())%></option>
          <option 
        value=3 <% if(ledgergroup.equals("3")) {%> selected <%}%>>-<%=SystemEnv.getHtmlLabelName(1474,user.getLanguage())%></option>
          <option value=4 <% if(ledgergroup.equals("4")) {%> selected <%}%>>-<%=SystemEnv.getHtmlLabelName(425,user.getLanguage())%></option>
          <option value=5 <% if(ledgergroup.equals("5")) {%> selected <%}%>>-<%=SystemEnv.getHtmlLabelName(1475,user.getLanguage())%></option>
         </select>
		<%} else if(ledgergroup.equals("1")){%><%=SystemEnv.getHtmlLabelName(535,user.getLanguage())%>
		<%} else if(ledgergroup.equals("2")){%><%=SystemEnv.getHtmlLabelName(1473,user.getLanguage())%>
		<%} else if(ledgergroup.equals("3")){%><%=SystemEnv.getHtmlLabelName(1474,user.getLanguage())%>
		<%} else if(ledgergroup.equals("4")){%><%=SystemEnv.getHtmlLabelName(425,user.getLanguage())%>
		<%} else if(ledgergroup.equals("5")){%>-<%=SystemEnv.getHtmlLabelName(1475,user.getLanguage())%><%}%>
        &nbsp; 
		<% if(caneditinit) {%>
        <select 
      class=InputStyle id=ledgerbalance name=ledgerbalance>
          <option 
        value=1 <% if(ledgerbalance.equals("1")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(1465,user.getLanguage())%></option>
          <option value=2 <% if(ledgerbalance.equals("2")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(1466,user.getLanguage())%></option>
        </select>
		<%} else { if(ledgerbalance.equals("1")){%><%=SystemEnv.getHtmlLabelName(1465,user.getLanguage())%>
		<%} if(ledgerbalance.equals("2")){%><%=SystemEnv.getHtmlLabelName(1466,user.getLanguage())%><%}%>
		<input class=inputstyle type="hidden" name="ledgerbalance" value="<%=ledgerbalance%>">
		<%}%>
      
	  </td>
      <td></td>
      <td><%=SystemEnv.getHtmlLabelName(1476,user.getLanguage())%></td>
      <td class=FIELD> <% if(canedit) {%>
        <select class=InputStyle id=ledgercurrency 
      style="WIDTH: 150px" name=ledgercurrency>
          <option 
        value=3 <% if(ledgercurrency.equals("3")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(1460,user.getLanguage())%></option>
          <option value=2 <% if(ledgercurrency.equals("2")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(526,user.getLanguage())%></option>
          <option 
        value=1 <% if(ledgercurrency.equals("1")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(1477,user.getLanguage())%></option>
        </select>
		<%} else if(ledgercurrency.equals("3")){%><%=SystemEnv.getHtmlLabelName(1460,user.getLanguage())%>
		<%} else if(ledgercurrency.equals("2")){%><%=SystemEnv.getHtmlLabelName(526,user.getLanguage())%>
		<%} else if(ledgercurrency.equals("1")){%><%=SystemEnv.getHtmlLabelName(1477,user.getLanguage())%><%}%>
      </td>
    </tr>
    <TR><TD class=Line colSpan=6></TD></TR> 
    <tr> 
      <td><%=SystemEnv.getHtmlLabelName(1480,user.getLanguage())%></td>
	  <td class=FIELD> 
        <input class=inputstyle type="text" name="initaccount" maxlength="10" size="10" onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("initaccount")' value="<%=initaccount%>" <% if(!caneditinit) {%>disabled<%}%>>
      </td>
    </tr>
 <TR><TD class=Line colSpan=2></TD></TR> 
    </tbody> 
  </table>
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
 function onEdit(){
 	if(check_form(document.frmMain,'ledgermark,ledgername')){
 		document.frmMain.operation.value="editledger";
		document.frmMain.initaccount.disabled = false ;
		document.frmMain.submit();
	}
 }
 function onDelete(){
		if(confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>")) {
			document.frmMain.operation.value="deleteledger";
			document.frmMain.submit();
		}
}
 </script>
</BODY>
</HTML>