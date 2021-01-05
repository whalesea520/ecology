<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="LedgerComInfo" class="weaver.fna.maintenance.LedgerComInfo" scope="page"/>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</head>
<%
String id = Util.null2String(request.getParameter("id"));
int msgid = Util.getIntValue(request.getParameter("msgid"),-1);
RecordSet.executeProc("LgcCountType_SelectByID",id);
RecordSet.next();
String typename = RecordSet.getString("typename");
String typedesc = RecordSet.getString("typedesc");
String salesinid = Util.null2String(RecordSet.getString("salesinid"));
String salescostid = Util.null2String(RecordSet.getString("salescostid"));
String salestaxid = Util.null2String(RecordSet.getString("salestaxid"));
String purchasetaxid = Util.null2String(RecordSet.getString("purchasetaxid"));
String stockid = Util.null2String(RecordSet.getString("stockid"));
String stockdiffid = Util.null2String(RecordSet.getString("stockdiffid"));
String producecostid = Util.null2String(RecordSet.getString("producecostid"));

boolean canedit = HrmUserVarify.checkUserRight("LgcCountTypeEdit:Edit", user) ;

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(703,user.getLanguage())+" : "+ Util.toScreen(typename,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>


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
		<td valign="top"><%
if(msgid!=-1){
%>
<DIV>
<font color=red size=2>
<%=SystemEnv.getErrorMsgName(msgid,user.getLanguage())%>
</font>
</DIV>
<%}%>
  <FORM style="MARGIN-TOP: 0px" name=frmMain method=post action="LgcCountTypeOperation.jsp">
    <input type="hidden" name="operation">
    <input type="hidden" name="id" value="<%=id%>">
<div style="display:none">
<% if(canedit) {%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onEdit(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btn id=btnSave accessKey=S name=btnSave onclick="onEdit()"><U>S</U>-<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%></BUTTON> 
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:frmMain.reset(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btn id=btnClear accessKey=R name=btnClear type=reset><U>R</U>-<%=SystemEnv.getHtmlLabelName(199,user.getLanguage())%></BUTTON> 
<% } 
if(HrmUserVarify.checkUserRight("LgcCountTypeEdit:Delete", user)){
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btnDelete id=Delete accessKey=D onclick="onDelete()"><U>D</U>-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></BUTTON>
<%
}
 if(HrmUserVarify.checkUserRight("LgcCountType:Log", user)){
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",javascript:frmMain.myfun1.click(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=BtnLog accessKey=L name=button2 id=myfun1  onclick="location='/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem =47 and relatedid=<%=id%>'"><U>L</U>-<%=SystemEnv.getHtmlLabelName(83,user.getLanguage())%></BUTTON>
<%}
%>
</div>    <br>
   
  <TABLE class=ViewForm>
    <COLGROUP> <COL width="20%"> <COL width="80%"><TBODY> 
    <TR class=Title> 
      <TH colSpan=2>资产类型信息</TH>
    </TR>
    <TR class=Spacing> 
      <TD class=Line1 colSpan=2></TD>
    </TR>
    <TR> 
      <TD>名称</TD>
      <TD Class=Field> 
        <% if(canedit) { %>
        <input class=InputStyle  accesskey=Z name=typename size="30" onChange='checkinput("typename","typenameimage")' value="<%=Util.toScreenToEdit(typename,user.getLanguage())%>" maxlength="30">
        <span id=typenameimage></span> 
        <% } else {%>
        <%=Util.toScreen(typename,user.getLanguage())%> 
        <%}%>
      </TD>
    </TR><tr><td class=Line colspan=2></td></tr>
    <tr> 
      <td>说明</td>
      <td class=Field> 
        <% if(canedit) { %>
        <textarea class=InputStyle accesskey="Z" name="typedesc" cols="60"><%=Util.toScreenToEdit(typedesc,user.getLanguage())%></textarea>
        <% } else {%>
        <%=Util.toScreen(typedesc,user.getLanguage())%> 
        <%}%>
      </td>
    </TR><tr><td class=Line colspan=2></td></tr>
	<tr> 
      <td>销售收入科目</td>
      <td class=Field>
	  <% if(canedit) { %>
	  <button class=Browser 
            id=SelectLedger1 onClick='onShowLedger(salesinidspan,salesinid)'></button> 
        <span class=InputStyle id=salesinidspan>
		<% if(!salesinid.equals("") && !salesinid.equals("0")) {%>
		<%=LedgerComInfo.getLedgermark(salesinid)%>-<%=Util.toScreen(LedgerComInfo.getLedgername(salesinid),user.getLanguage())%><%}%></span>
		<input class=InputStyle  id=salesinid type=hidden name=salesinid value="<%=salesinid%>">
	<% } else {
	if(!salesinid.equals("") && !salesinid.equals("0")) {%>
	<%=LedgerComInfo.getLedgermark(salesinid)%>-<%=Util.toScreen(LedgerComInfo.getLedgername(salesinid),user.getLanguage())%>
	<%}}%>
	  </td>
    </TR><tr><td class=Line colspan=2></td></tr>
    <tr> 
      <td>销售成本科目</td>
      <td class=Field>
	  <% if(canedit) { %>
	  <button class=Browser id=SelectLedger2 onClick='onShowLedger(salescostidspan,salescostid)'></button> 
        <span class=InputStyle id=salescostidspan><% if(!salescostid.equals("") && !salescostid.equals("0")) {%><%=LedgerComInfo.getLedgermark(salescostid)%>-<%=Util.toScreen(LedgerComInfo.getLedgername(salescostid),user.getLanguage())%><%}%></span>
		<input class=InputStyle  id=salescostid type=hidden name=salescostid value="<%=salescostid%>">
	<% } else {
	if(!salescostid.equals("") && !salescostid.equals("0")) {%>
	<%=LedgerComInfo.getLedgermark(salescostid)%>-<%=Util.toScreen(LedgerComInfo.getLedgername(salescostid),user.getLanguage())%>
	<%}}%>
	  </td>
    </TR><tr><td class=Line colspan=2></td></tr>
    <tr> 
      <td>销项税科目</td>
      <td class=Field>
	  <% if(canedit) { %>
	  <button class=Browser id=SelectLedger3 onClick='onShowLedger(salestaxidspan,salestaxid)'></button> 
        <span class=InputStyle id=salestaxidspan><% if(!salestaxid.equals("") && !salestaxid.equals("0")) {%><%=LedgerComInfo.getLedgermark(salestaxid)%>-<%=Util.toScreen(LedgerComInfo.getLedgername(salestaxid),user.getLanguage())%><%}%></span>
		<input class=InputStyle  id=salestaxid type=hidden name=salestaxid value="<%=salestaxid%>">
	<% } else {
	if(!salestaxid.equals("") && !salestaxid.equals("0")) {%>
	<%=LedgerComInfo.getLedgermark(salestaxid)%>-<%=Util.toScreen(LedgerComInfo.getLedgername(salestaxid),user.getLanguage())%>
	<%}}%>
    </td>
    </TR><tr><td class=Line colspan=2></td></tr>
    <tr> 
      <td>进项税科目</td>
      <td class=Field>
	  <% if(canedit) { %>
	  <button class=Browser id=SelectLedger4 onClick='onShowLedger(purchasetaxidspan,purchasetaxid)'></button> 
        <span class=InputStyle id=purchasetaxidspan><% if(!purchasetaxid.equals("") && !purchasetaxid.equals("0")) {%><%=LedgerComInfo.getLedgermark(purchasetaxid)%>-<%=Util.toScreen(LedgerComInfo.getLedgername(purchasetaxid),user.getLanguage())%><%}%></span>
		<input class=InputStyle  id=purchasetaxid type=hidden name=purchasetaxid value="<%=purchasetaxid%>">
	<% } else {
	if(!purchasetaxid.equals("") && !purchasetaxid.equals("0")) {%>
	<%=LedgerComInfo.getLedgermark(purchasetaxid)%>-<%=Util.toScreen(LedgerComInfo.getLedgername(purchasetaxid),user.getLanguage())%>
	<%}}%>
	 </td>
    </TR><tr><td class=Line colspan=2></td></tr>
    <tr> 
      <td>存货核算科目</td>
      <td class=Field>
	  <% if(canedit) { %>
	  <button class=Browser id=SelectLedger5 onClick='onShowLedger(stockidspan,stockid)'></button> 
        <span class=InputStyle id=stockidspan><% if(!stockid.equals("") && !stockid.equals("0")) {%><%=LedgerComInfo.getLedgermark(stockid)%>-<%=Util.toScreen(LedgerComInfo.getLedgername(stockid),user.getLanguage())%><%}%></span>
		<input class=InputStyle  id=stockid type=hidden name=stockid value="<%=stockid%>">
	<% } else {
	if(!stockid.equals("") && !stockid.equals("0")) {%>
	<%=LedgerComInfo.getLedgermark(stockid)%>-<%=Util.toScreen(LedgerComInfo.getLedgername(stockid),user.getLanguage())%>
	<%}}%>
	  </td>
    </TR><tr><td class=Line colspan=2></td></tr>
    <TR> 
      <TD>存货差异科目</TD>
      <TD class=Field>
	  <% if(canedit) { %>
	  <button class=Browser id=SelectLedger6 onClick='onShowLedger(stockdiffidspan,stockdiffid)'></button> 
        <span class=InputStyle id=stockdiffidspan><% if(!stockdiffid.equals("") && !stockdiffid.equals("0")) {%><%=LedgerComInfo.getLedgermark(stockdiffid)%>-<%=Util.toScreen(LedgerComInfo.getLedgername(stockdiffid),user.getLanguage())%><%}%></span>
		<input class=InputStyle  id=stockdiffid type=hidden name=stockdiffid value="<%=stockdiffid%>">
	<% } else {
	if(!stockdiffid.equals("") && !stockdiffid.equals("0")) {%>
	<%=LedgerComInfo.getLedgermark(stockdiffid)%>-<%=Util.toScreen(LedgerComInfo.getLedgername(stockdiffid),user.getLanguage())%>
	<%}}%>
	 </TD>
    </TR><tr><td class=Line colspan=2></td></tr>
    <tr> 
      <td>生产成本科目</td>
      <td class=Field>
	  <% if(canedit) { %>
	  <button class=Browser id=SelectLedger7 onClick='onShowLedger(producecostidspan,producecostid)'></button> 
        <span class=InputStyle id=producecostidspan><% if(!producecostid.equals("") && !producecostid.equals("0")) {%><%=LedgerComInfo.getLedgermark(producecostid)%>-<%=Util.toScreen(LedgerComInfo.getLedgername(producecostid),user.getLanguage())%><%}%></span>
		<input class=InputStyle  id=producecostid type=hidden name=producecostid value="<%=producecostid%>">
	<% } else {
	if(!producecostid.equals("") && !producecostid.equals("0")) {%>
	<%=LedgerComInfo.getLedgermark(producecostid)%>-<%=Util.toScreen(LedgerComInfo.getLedgername(producecostid),user.getLanguage())%>
	<%}}%>
    </td>
    </TR><tr><td class=Line colspan=2></td></tr>
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
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<script language="VBS">
sub onShowLedger(spanname, inputname)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/fna/maintenance/FnaLedgerBrowser.jsp")
	if NOT isempty(id) then
	    if id(0)<> "" then
		spanname.innerHtml = id(1)
		inputname.value=id(0)
		else
		spanname.innerHtml = ""
		inputname.value=""
		end if
	end if
end sub
</script>

<script language=javascript>
 function onEdit(){
 	if(check_form(document.frmMain,'typename')){
 		document.frmMain.operation.value="edittype";
		document.frmMain.submit();
	}
 }
 function onDelete(){
		if(confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>")) {
			document.frmMain.operation.value="deletetype";
			document.frmMain.submit();
		}
}
 </script>
</BODY>
</HTML>
