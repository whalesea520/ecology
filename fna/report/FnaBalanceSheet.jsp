<%@ page import="weaver.general.Util,java.util.*,java.math.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<% if(!HrmUserVarify.checkUserRight("FnaBalanceSheet:All",user)) {
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

String defcurrenyid = Util.null2String(request.getParameter("defcurrenyid"));
if(defcurrenyid.equals("")) {
RecordSet.executeProc("FnaCurrency_SelectByDefault","");
RecordSet.next();
defcurrenyid = RecordSet.getString(1);
}

String fnayear = Util.null2String(request.getParameter("fnayear"));
if(fnayear.equals("")) {
	RecordSet.executeProc("FnaYearsPeriods_SelectMaxYear","");
	if(RecordSet.next()) fnayear = RecordSet.getString("fnayear") ;
	else {
		Calendar today = Calendar.getInstance();
		fnayear = Util.add0(today.get(Calendar.YEAR), 4) ;
	}
}

String periodsidfrom = Util.null2String(request.getParameter("periodsidfrom"));
String periodsidto = Util.null2String(request.getParameter("periodsidto"));
if(periodsidfrom.equals("")|| periodsidfrom.equals("0")) periodsidfrom = "1" ;
if(periodsidto.equals("")) periodsidto = "12" ;
if(Util.getIntValue(periodsidfrom) > Util.getIntValue(periodsidto)) {
String tempperiods ="" ;
tempperiods = periodsidfrom ; periodsidfrom = periodsidto ; periodsidto = tempperiods ;
}
String dbperiodsfrom = fnayear + Util.add0(Util.getIntValue(periodsidfrom),2) ;
String dbperiodsto = fnayear + Util.add0(Util.getIntValue(periodsidto),2) ;

int assetcount = Util.getIntValue(request.getParameter("assetcount"),-1);
int debtcount = Util.getIntValue(request.getParameter("debtcount"),-1);
int allcount = Util.getIntValue(request.getParameter("allcount"),-1);

if(allcount == -1) {
	RecordSet.executeProc("FnaLedger_SelectCountByBabance","");
	if(RecordSet.next()) {
		assetcount = Util.getIntValue(RecordSet.getString(1),0) ;
		debtcount = Util.getIntValue(RecordSet.getString(2),0) ;
	}
	if(assetcount > (debtcount+2) ) allcount = assetcount ;
	else allcount = (debtcount+2) ;
}
  

String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(736,user.getLanguage());
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
<FORM id=frmMain name=frmMain action=FnaBalanceSheet.jsp method=post>
  <div >
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(354,user.getLanguage())+",javascript:frmMain.submit(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>  
  <BUTTON class=btnRefresh id=button1 accessKey=R name=button1  style="display:none" type=submit><U>R</U>-<%=SystemEnv.getHtmlLabelName(354,user.getLanguage())%></BUTTON> 
  </div>
  <input id=defcurrenyid type=hidden name=defcurrenyid value="<%=defcurrenyid%>">
  <input id=assetcount type=hidden name=assetcount value="<%=assetcount%>">
  <input id=debtcount type=hidden name=debtcount value="<%=debtcount%>">
  <input id=allcount type=hidden name=allcount value="<%=allcount%>">
  <TABLE class=ViewForm>
    <COLGROUP> <COL width="15%"></COL> <COL width="40%"></COL><COL width="5%"></COL> 
    <COL width="15%"></COL> <COL width="25%"></COL> <THEAD> 
    <TR class=Title> 
      <TH colSpan=5><%=SystemEnv.getHtmlLabelName(154,user.getLanguage())%></TH>
    </TR>
    </THEAD> <TBODY> 
    <TR class=Spacing> 
      <TD class=Line1 colSpan=5></TD>
    </TR>
    <tr> 
      <td><%=SystemEnv.getHtmlLabelName(446,user.getLanguage())%></td>
      <td class=Field> 
        <select name="fnayear" class=InputStyle >
          <%
		RecordSet.executeProc("FnaYearsPeriods_Select","");
		while(RecordSet.next()) {
			String thefnayear = RecordSet.getString("fnayear") ;
		%>
          <option value="<%=thefnayear%>" <% if(thefnayear.equals(fnayear)) {%>selected<%}%>><%=thefnayear%></option>
          <%}
		%>
        </select>
        <%=SystemEnv.getHtmlLabelName(348,user.getLanguage())%> 
        <input class=InputStyle id=periodsidfrom name=periodsidfrom maxlength="2" onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("periodsidfrom")' size="5" value="<%=periodsidfrom%>">
        <%=SystemEnv.getHtmlLabelName(349,user.getLanguage())%> 
        <input class=InputStyle id=periodsidto name=periodsidto maxlength="2" onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("periodsidto")' size="5" value="<%=periodsidto%>">
      </td>
      <td>&nbsp;</td>
      <td><%=SystemEnv.getHtmlLabelName(406,user.getLanguage())%></td>
      <td class=Field> <%=Util.toScreen(CurrencyComInfo.getCurrencyname(defcurrenyid),user.getLanguage())%></td>
    </tr><TR><TD class=Line colSpan=5></TD></TR>
    </TBODY> 
  </TABLE>
</FORM>
<table width="100%" border="0" cellspacing="0" cellpadding="0"  class=ListStyle cellspacing=1>
<COLGROUP> <col width="50%"> <col width="50%">
<tr class=header> 
          <th colspan="2"> 
           <%=SystemEnv.getHtmlLabelName(736,user.getLanguage())%>
          </th>
        </tr>
  <tr>
    <td valign="top"> 
      <table class=ListStyle cellspacing=1>
        <colgroup> 
        <col width="35%"> 
        <col width="10%"> 
        <col align=right width="28%"> 
        <col align=right width="28%"> 
        <tbody> <thead> 
        <tr class=Header align=left> 
          <td>-<%=SystemEnv.getHtmlLabelName(535,user.getLanguage())%></td>
          <td><%=SystemEnv.getHtmlLabelName(1486,user.getLanguage())%></td>
          <td style="TEXT-ALIGN: right"><%=SystemEnv.getHtmlLabelName(1482,user.getLanguage())%></td>
          <td style="TEXT-ALIGN: right"><%=SystemEnv.getHtmlLabelName(1483,user.getLanguage())%></td>
        </tr><TR class=Line><TD colSpan=4></TD></TR>
        </thead> <tbody> 
        <%
int i=0 ;
int rowcount = 0 ;
char separator = Util.getSeparator() ;
BigDecimal  preassetcount = new BigDecimal("0") ;
BigDecimal  lastassetcount = new BigDecimal("0") ;
String para = dbperiodsfrom + separator + dbperiodsto + separator + "1" ;
RecordSet.executeProc("FnaAccount_SelectBalance", para);
while(RecordSet.next()){
	String ledgerid = Util.null2String(RecordSet.getString(1)) ;
	String preasset = Util.null2String(RecordSet.getString(2)) ;
	String lastasset = Util.null2String(RecordSet.getString(3)) ;
	if(preasset.equals("")) preasset = "0.000" ;
	if(lastasset.equals("")) lastasset = "0.000" ;
	preassetcount = preassetcount.add(new BigDecimal(preasset)) ;
	lastassetcount = lastassetcount.add(new BigDecimal(lastasset)) ;
	rowcount ++ ;

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
          <td > <%=LedgerComInfo.getLedgermark(ledgerid)%>-<%=Util.toScreen(LedgerComInfo.getLedgername(ledgerid),user.getLanguage())%> 
          </td>
          <td><%=rowcount%></td>
          <td align=right><%=Util.getFloatStr(preasset,3)%></td>
          <td align=right><%=Util.getFloatStr(lastasset,3)%></td>
        </tr>
        <%} if(assetcount < allcount) {
			for(int k=allcount-assetcount; k>0 ; k--) {
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
		<td colspan=4 >&nbsp;</td>
		</tr>
		<%}}
		rowcount ++ ;
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
		<td ><%=SystemEnv.getHtmlLabelName(1484,user.getLanguage())%></td>
          <td><%=rowcount%></td>
          <td align=right><%=Util.getFloatStr(preassetcount.toString(),3)%></td>
          <td align=right><%=Util.getFloatStr(lastassetcount.toString(),3)%></td>
        </tr>
        </tbody> 
      </table>
    </td>
    <td valign="top"> 
      <table class=ListStyle cellspacing=1>
        <colgroup> 
        <col width="35%"> 
        <col width="10%"> 
        <col align=right width="28%"> 
        <col align=right width="28%">
        <tbody> <thead> 
        <tr class=Header align=left> 
          <td><%=SystemEnv.getHtmlLabelName(1485,user.getLanguage())%></td>
          <td><%=SystemEnv.getHtmlLabelName(1486,user.getLanguage())%></td>
          <td style="TEXT-ALIGN: right"><%=SystemEnv.getHtmlLabelName(1482,user.getLanguage())%></td>
          <td style="TEXT-ALIGN: right"><%=SystemEnv.getHtmlLabelName(1483,user.getLanguage())%></td>
        </tr><TR class=Line><TD colSpan=4></TD></TR>
        </thead> <tbody> 
<%
i=0 ;
BigDecimal predebtcount = new BigDecimal("0") ;
BigDecimal lastdebtcount = new BigDecimal("0") ;
para = dbperiodsfrom + separator + dbperiodsto + separator + "2" ;
RecordSet.executeProc("FnaAccount_SelectBalance", para);
while(RecordSet.next()){
	String ledgerid = Util.null2String(RecordSet.getString(1)) ;
	String preasset = Util.null2String(RecordSet.getString(2)) ;
	String lastasset = Util.null2String(RecordSet.getString(3)) ;
	if(preasset.equals("")) preasset = "0.000" ;
	if(lastasset.equals("")) lastasset = "0.000" ;
	predebtcount = predebtcount.add(new BigDecimal(preasset)) ;
	lastdebtcount = lastdebtcount.add(new BigDecimal(lastasset)) ;
	rowcount ++ ;

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
          <td > 
            <%=LedgerComInfo.getLedgermark(ledgerid)%>-<%=Util.toScreen(LedgerComInfo.getLedgername(ledgerid),user.getLanguage())%> 
          </td>
          <td><%=rowcount%></td>
          <td align=right><%=Util.getFloatStr(preasset,3)%></td>
          <td align=right><%=Util.getFloatStr(lastasset,3)%></td>
        </tr>
        <%}
		rowcount ++ ;
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
		<td ><%=SystemEnv.getHtmlLabelName(1487,user.getLanguage())%></td>
          <td><%=rowcount%></td>
          <td align=right><%=Util.getFloatStr(predebtcount.toString(),3)%></td>
          <td align=right><%=Util.getFloatStr(lastdebtcount.toString(),3)%></td>
        </tr>
<% 
BigDecimal predefitcount = new BigDecimal("0") ;
BigDecimal lastdefitcount = new BigDecimal("0") ;
para = dbperiodsfrom + separator + dbperiodsto + separator + "3" ;
RecordSet.executeProc("FnaAccount_SelectBalance", para);
while(RecordSet.next()){
	String ledgerid = Util.null2String(RecordSet.getString(1)) ;
	String preasset = Util.null2String(RecordSet.getString(2)) ;
	String lastasset = Util.null2String(RecordSet.getString(3)) ;
	if(preasset.equals("")) preasset = "0.000" ;
	if(lastasset.equals("")) lastasset = "0.000" ;
	predefitcount = predefitcount.add(new BigDecimal(preasset)) ;
	lastdefitcount = lastdefitcount.add(new BigDecimal(lastasset)) ;
	rowcount ++ ;

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
		<td > 
            <%=LedgerComInfo.getLedgermark(ledgerid)%>-<%=Util.toScreen(LedgerComInfo.getLedgername(ledgerid),user.getLanguage())%> 
          </td>
          <td><%=rowcount%></td>
          <td align=right><%=Util.getFloatStr(preasset,3)%></td>
          <td align=right><%=Util.getFloatStr(lastasset,3)%></td>
        </tr>
        <%}	
		rowcount ++ ;
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
		<td ><%=SystemEnv.getHtmlLabelName(1488,user.getLanguage())%></td>
          <td><%=rowcount%></td>
          <td align=right><%=Util.getFloatStr(predefitcount.toString(),3)%></td>
          <td align=right><%=Util.getFloatStr(lastdefitcount.toString(),3)%></td>
        </tr>
<% 
		
		if((debtcount+2) < allcount) {
			for(int k=allcount-(debtcount+2); k>0 ; k--) {
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
		<td colspan=4 >&nbsp;</td>
		</tr>
		<%}}
		rowcount ++ ;
		predefitcount = predefitcount.add(predebtcount) ;
		lastdefitcount = lastdefitcount.add(lastdebtcount) ;
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
		<td ><%=SystemEnv.getHtmlLabelName(1489,user.getLanguage())%></td>
          <td><%=rowcount%></td>
          <td align=right><%=Util.getFloatStr(predefitcount.toString(),3)%></td>
          <td align=right><%=Util.getFloatStr(lastdefitcount.toString(),3)%></td>
        </tr>
        </tbody> 
      </table>
    </td>
  </tr>
</table>
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
