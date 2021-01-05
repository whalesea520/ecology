<%@ page import="weaver.general.Util,java.util.*,java.math.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<% if(!HrmUserVarify.checkUserRight("FnaTransaction:All",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
   }
%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="CurrencyComInfo" class="weaver.fna.maintenance.CurrencyComInfo" scope="page"/>
<jsp:useBean id="LedgerComInfo" class="weaver.fna.maintenance.LedgerComInfo" scope="page"/>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</head>
<%
char separator = Util.getSeparator() ;
String ledgerid = Util.null2String(request.getParameter("ledgerid"));
String fnayearfrom = Util.null2String(request.getParameter("fnayearfrom"));
String periodsidfrom = Util.null2String(request.getParameter("periodsidfrom"));
String fnayearto = Util.null2String(request.getParameter("fnayearto"));
String periodsidto = Util.null2String(request.getParameter("periodsidto"));
String defcurrenyid = Util.null2String(request.getParameter("defcurrenyid"));
if(defcurrenyid.equals("")) {
RecordSet.executeProc("FnaCurrency_SelectByDefault","");
RecordSet.next();
defcurrenyid = RecordSet.getString(1);
}

if(fnayearfrom.equals("") || fnayearto.equals("")) {
	String currentyear = "" ;
	RecordSet.executeProc("FnaYearsPeriods_SelectMaxYear","");
	if(RecordSet.next()) currentyear = RecordSet.getString("fnayear") ;
	if(currentyear.equals("")) {
		Calendar today = Calendar.getInstance();
		currentyear = Util.add0(today.get(Calendar.YEAR), 4) ;
	}
	if(fnayearfrom.equals("")) fnayearfrom = currentyear ;
	if(fnayearto.equals("")) fnayearto = currentyear ;
}
if(periodsidfrom.equals("")) periodsidfrom = "1" ;
if(periodsidto.equals("")) periodsidto = "12" ;
	
String dbperiodsfrom = fnayearfrom + Util.add0(Util.getIntValue(periodsidfrom),2) ;
String dbperiodsto = fnayearto + Util.add0(Util.getIntValue(periodsidto),2) ;
if(dbperiodsfrom.compareTo(dbperiodsto) > 0) {
	String tempperiods = dbperiodsfrom ; dbperiodsfrom = dbperiodsto ; dbperiodsto = tempperiods ;
	tempperiods = fnayearfrom ; fnayearfrom = fnayearto ; fnayearto = tempperiods ;
	tempperiods = periodsidfrom ; periodsidfrom = periodsidto ; periodsidto = tempperiods ;
}
String para = ledgerid + separator + dbperiodsfrom + separator + dbperiodsto ;

String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(666,user.getLanguage());
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
		<td valign="top">
<FORM id=frmMain name=frmMain action=FnaRpGledger.jsp method=post>
  <div> 
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(354,user.getLanguage())+",javascript:frmMain.submit(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>  
  <BUTTON class=btnRefresh id=button1 accessKey=R name=button1 style="display:none"  type=submit><U>R</U>-<%=SystemEnv.getHtmlLabelName(354,user.getLanguage())%></BUTTON> 
  </div>
  <input id=defcurrenyid type=hidden name=defcurrenyid value="<%=defcurrenyid%>">
<TABLE class=ViewForm>
  <COLGROUP>
  <COL width="10%"></COL>
  <COL width="25%"></COL>
   <COL width="10%"></COL>
  <COL width="25%"></COL>
  <COL width="10%"></COL>
  <COL width="25%"></COL>
  <THEAD>
  <TR class=title>
    <TH colSpan=6><%=SystemEnv.getHtmlLabelName(324,user.getLanguage())%></TH></TR>
    <TR><TD class=Line1 colSpan=6></TD></TR>
    </THEAD>
  <TBODY>
  <TBODY>
  <TR>
      <TD><%=SystemEnv.getHtmlLabelName(585,user.getLanguage())%></TD>
    <TD class=Field><button class=Browser id=SelectLedger onClick='onShowLedger(ledgeridspan,ledgerid)'></button> 
        <span class=InputStyle id=ledgeridspan>
		<% if(!ledgerid.equals("")) {%>
		<%=Util.toScreen(LedgerComInfo.getLedgermark(ledgerid),user.getLanguage())%>-<%=Util.toScreen(LedgerComInfo.getLedgername(ledgerid),user.getLanguage())%>
		<%}%>
		</span> 
        <input id=ledgerid type=hidden name=ledgerid>
       </TD>
   
      <TD><%=SystemEnv.getHtmlLabelName(1812,user.getLanguage())%></TD>
    <TD class=Field>
	<select name="fnayearfrom" class=InputStyle >
		<%
		RecordSet.executeProc("FnaYearsPeriods_Select","");
		while(RecordSet.next()) {
			String thefnayear = RecordSet.getString("fnayear") ;
		%>
				  <option value="<%=thefnayear%>" <% if(thefnayear.equals(fnayearfrom)) {%>selected<%}%>><%=thefnayear%></option>
		<%}
		RecordSet.beforFirst() ;
		%>
    </select>
	<INPUT  class=InputStyle id=periodsidfrom name=periodsidfrom maxlength="2" onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("periodsidfrom")' size="8" value="<%=periodsidfrom%>">
    </TD>
	
      <TD><%=SystemEnv.getHtmlLabelName(1813,user.getLanguage())%></TD>
    <TD class=Field>
		<select   class=InputStyle name="fnayearto">
		<%
		while(RecordSet.next()) {
			String thefnayear = RecordSet.getString("fnayear") ;
		%>
				  <option value="<%=thefnayear%>" <% if(thefnayear.equals(fnayearto)) {%>selected<%}%>><%=thefnayear%></option>
		<%}%>
    </select>
	<INPUT   class=InputStyle id=periodsidto name=periodsidto maxlength="2" onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("periodsidto")' size="8" value="<%=periodsidto%>">
    </TD></TR><TR><TD class=Line colSpan=6></TD></TR></TBODY></TABLE>
  <br>
</FORM>
<table class=ListStyle cellspacing=1>
  <colgroup> 
  <col width="10%"> 
  <col width="15%"> 
  <col width="15%"> 
  <col align=right width="20%"> 
  <col align=right width="20%"> 
  <col align=right width="20%"> 
  <tbody> <thead> 
  <tr class=header> 
    <th colspan=3 style="TEXT-ALIGN: left"> <%=SystemEnv.getHtmlLabelName(666,user.getLanguage())%> 
    </th>
    <th colspan=3 style="TEXT-ALIGN: right"><%=SystemEnv.getHtmlLabelName(406,user.getLanguage())%>: <%=Util.toScreen(CurrencyComInfo.getCurrencyname(defcurrenyid),user.getLanguage())%></th>
  </tr>

  <tr class=Header> 
    <td align="left"><%=SystemEnv.getHtmlLabelName(714,user.getLanguage())%></td>
    <td><%=SystemEnv.getHtmlLabelName(585,user.getLanguage())%></td>
    <td><%=SystemEnv.getHtmlLabelName(446,user.getLanguage())%></td>
    <td style="TEXT-ALIGN: right"><%=SystemEnv.getHtmlLabelName(1465,user.getLanguage())%></td>
    <td style="TEXT-ALIGN: right"><%=SystemEnv.getHtmlLabelName(1466,user.getLanguage())%></td>
    <td style="TEXT-ALIGN: right"><%=SystemEnv.getHtmlLabelName(1811,user.getLanguage())%></td>
  </tr><TR class=Line><TD colSpan=6></TD></TR>
  </thead> <tbody> 
  <%
int i=0 ;
String tempid = "" ;
BigDecimal  tempzero = new BigDecimal("0") ;
RecordSet.executeProc("FnaAccount_Select",para);
while(RecordSet.next()){
String ids = Util.null2String(RecordSet.getString("ledgerid")) ;
String tranperiodss = Util.null2String(RecordSet.getString("tranperiods")) ;
String trandaccounts = Util.null2String(RecordSet.getString("trandaccount")) ;
String trancaccounts = Util.null2String(RecordSet.getString("trancaccount")) ;
String tranremains = Util.null2String(RecordSet.getString("tranremain")) ;
if(!tranperiodss.equals(""))  {
	if(!trandaccounts.equals("")) {
		BigDecimal  tempaccount = new BigDecimal(trandaccounts) ;
		if(tempaccount.compareTo(tempzero) == 0) trandaccounts = "" ;
	}
	if(!trancaccounts.equals("")) {
		BigDecimal  tempaccount = new BigDecimal(trancaccounts) ;
		if(tempaccount.compareTo(tempzero) == 0) trancaccounts = "" ;
	}
}
if(tranremains.equals("")) tranremains ="0.000";

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
    <td> 
      <% if(!tempid.equals(ids)) {%>
	  <a href="FnaRpLedger.jsp?ledgerid=<%=ids%>&fnayearfrom=<%=fnayearfrom%>&periodsidfrom=<%=periodsidfrom%>&fnayearto=<%=fnayearto%>&periodsidto=<%=periodsidto%>&defcurrenyid=<%=defcurrenyid%>">
	  <%=Util.toScreen(LedgerComInfo.getLedgermark(ids),user.getLanguage())%></a>
      <%}%>
    </td>
    <td><% if(!tempid.equals(ids)) { %>
	<%=Util.toScreen(LedgerComInfo.getLedgername(ids),user.getLanguage())%> 
	<%tempid = ids; }%>
	</td>
    <td>
	<%if(tranperiodss.equals("")) {%><%=SystemEnv.getHtmlLabelName(1810,user.getLanguage())%>
	<%} else {%>
	<a href="FnaRpLedger.jsp?ledgerid=<%=ids%>&fnayearfrom=<%=fnayearfrom%>&periodsidfrom=<%=periodsidfrom%>&fnayearto=<%=fnayearto%>&periodsidto=<%=periodsidto%>&defcurrenyid=<%=defcurrenyid%>&tranperiods=<%=tranperiodss%>">
	<%=tranperiodss.substring(0,4)%>-<%=Util.getIntValue(tranperiodss.substring(4,6))%></a><%}%>
	</td>
    <td> 
      <%if(!trandaccounts.equals("")) {%>
      <%=Util.getFloatStr(trandaccounts,3)%> 
      <%}%>
    </td>
    <td> 
      <%if(!trancaccounts.equals("")) {%>
      <%=Util.getFloatStr(trancaccounts,3)%> 
      <%}%>
    </td>
    <td><%=Util.getFloatStr(tranremains,3)%></td>
  </tr>
  <%}%>
  </tbody> 
</table>
<br>
<script language=vbs>
sub onShowLedger(spanname, inputname)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/fna/maintenance/FnaLedgerAllBrowser.jsp")
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
</BODY></HTML>
