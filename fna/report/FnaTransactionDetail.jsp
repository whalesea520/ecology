<%@ page import="weaver.general.Util" %>
<%@ page import="java.math.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<% if(!HrmUserVarify.checkUserRight("FnaTransaction:All",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
   }
%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="CurrencyComInfo" class="weaver.fna.maintenance.CurrencyComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</head>
<%
int msgid = Util.getIntValue(request.getParameter("msgid"),-1);
String departmentid = Util.null2String(request.getParameter("departmentid"));
String tranperiods = Util.null2String(request.getParameter("tranperiods"));
String fnayear = "" ;
String periodsid = "" ;
if(!tranperiods.equals("")) {
fnayear = tranperiods.substring(0,4) ;
periodsid = ""+Util.getIntValue(tranperiods.substring(4,6)) ;
}
else {
fnayear = Util.null2String(request.getParameter("fnayear"));
periodsid = Util.null2String(request.getParameter("periodsid"));
}
if(periodsid.equals("0")) periodsid ="";
String transtatus = Util.null2String(request.getParameter("transtatus"));
String dbperiods = "" ;
if(!fnayear.equals("") && !periodsid.equals("")) dbperiods = fnayear+Util.add0(Util.getIntValue(periodsid),2);

String sqlstr =" select *  from FnaTransaction " ;
boolean haswhere = false ;
if(!departmentid.equals("")) {
	sqlstr +=" where trandepartmentid = "+ departmentid ;
	haswhere = true ;
}
if(!dbperiods.equals("")) {
	if(!haswhere) sqlstr +=" where tranperiods = '"+ dbperiods + "' " ;
	else sqlstr +=" and tranperiods = '"+ dbperiods + "' " ;
	haswhere = true ;
}
if(!transtatus.equals("")) {
	if(!haswhere) sqlstr +=" where transtatus = '"+ transtatus + "' " ;
	else sqlstr +=" and transtatus = '"+ transtatus + "' " ;
}

sqlstr += " order by tranmark desc " ;

boolean canprocess = HrmUserVarify.checkUserRight("FnaTransaction:Process", user) && (transtatus.equals("") || transtatus.equals("1")) ;

String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(663,user.getLanguage())+" : "+ SystemEnv.getHtmlLabelName(361,user.getLanguage());
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
<%
if(msgid!=-1){
%>
<DIV>
<font color=red size=2>
<%=SystemEnv.getErrorMsgName(msgid,user.getLanguage())%>
</font>
</DIV>
<%}%>
<FORM id=frmMain name=frmMain action=FnaTransactionDetail.jsp method=post>
  <DIV class=Btnbar style="display:none">
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(354,user.getLanguage())+",javascript:frmMain.submit(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>    
<BUTTON class=btnRefresh id=btnRefresh 
accessKey=R name=btnRefresh type=submit><U>R</U>-<%=SystemEnv.getHtmlLabelName(354,user.getLanguage())%></BUTTON> 
    <%
if(HrmUserVarify.checkUserRight("FnaTransactionAdd:Add", user)){
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(365,user.getLanguage())+",javascript:frmMain.AddNew.click(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
    <BUTTON class=BtnNew id=AddNew accessKey=N 
onclick='location.href="FnaTransactionAdd.jsp?departmentid=<%=departmentid%>"'><U>N</U>-<%=SystemEnv.getHtmlLabelName(365,user.getLanguage())%></BUTTON> 
    <%}
if( canprocess){
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(664,user.getLanguage())+",javascript:doprocess(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
    <BUTTON class=Btn id=Process accessKey=1 onclick="doprocess()"><U>1</U>-<%=SystemEnv.getHtmlLabelName(664,user.getLanguage())%></BUTTON> 
    <%}%>
  </DIV>
<TABLE class=ViewForm>
  <COLGROUP>
  <COL width="12%"></COL>
  <COL width="40%"></COL>
  <COL width=24></COL>
  <COL width="12%"></COL>
  <COL width="25%"></COL>
  <THEAD>
  <TR class=Title>
    <TH colSpan=6><%=SystemEnv.getHtmlLabelName(324,user.getLanguage())%></TH></TR></THEAD>
  <TBODY>
  <TR class=Spacing>
    <TD class=Line1 colSpan=6></TD></TR>
  <TBODY>
  <TR>
    <TD><%=SystemEnv.getHtmlLabelName(1814,user.getLanguage())%></TD>
    <TD class=Field>
	<select class=InputStyle name="fnayear">
		<option value=""></option>
		<%
		RecordSet.executeProc("FnaYearsPeriods_Select","");
		while(RecordSet.next()) {
			String thefnayear = RecordSet.getString("fnayear") ;
		%>
				  <option value="<%=thefnayear%>" <% if(thefnayear.equals(fnayear)) {%>selected<%}%>><%=thefnayear%></option>
		<%}%>
    </select>
	<INPUT  class=InputStyle id=periodsid name=periodsid maxlength="2" onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("periodsid")' size="8" value="<%=periodsid%>">
	</TD>
    <TD></TD>
      <TD><%=SystemEnv.getHtmlLabelName(169,user.getLanguage())%></TD>  <TD class=Field>
        <select class=InputStyle  name=transtatus>
          <option value=""> </option>
          <option value=0 <% if(transtatus.equals("0")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(360,user.getLanguage())%></option>
          <option value=1 <% if(transtatus.equals("1")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(142,user.getLanguage())%></option>
          <option value=2 <% if(transtatus.equals("2")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(1815,user.getLanguage())%></option>
          <option value=3 <% if(transtatus.equals("3")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(1816,user.getLanguage())%></option>
         </select>
      </TD>
    </TR><TR><TD class=Line colSpan=2></TD></TR>
  <TR>
      <TD><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></TD>
    <TD class=Field><button class=Browser id=SelectDeparment onClick="onShowDepartment()"></button> 
	 <span class=InputStyle id=departmentspan><%=Util.toScreen(DepartmentComInfo.getDepartmentname(departmentid),user.getLanguage())%></span> 
              		<input id=departmentid type=hidden name=departmentid value="<%=departmentid%>">
       </TD>
    <TD></TD>
      <TD>&nbsp;</TD>
      <TD>&nbsp; </TD>
    </TR><TR><TD class=Line colSpan=2></TD></TR></TBODY></TABLE></FORM>
<TABLE class=ListStyle cellspacing=1>
  <COLGROUP>
  <COL width="15%">
   <COL width="8%">
  <COL width="20%">
  <COL width="15%">
  <COL width="12%">
  <COL align=right width="15%">
  <COL align=right width="15%">
  <COL width="10%">
  <TBODY>
  <THEAD>
  <TR class=header>
    <TH colSpan=8>
      <P align=left><b><%=SystemEnv.getHtmlLabelName(361,user.getLanguage())%></b></P>
    </TH></TR>
  <TR class=Header align=left>
    <TD><%=SystemEnv.getHtmlLabelName(714,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(169,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(341,user.getLanguage())%></TD>
    <TD style="TEXT-ALIGN: right"><%=SystemEnv.getHtmlLabelName(1465,user.getLanguage())%></TD>
    <TD style="TEXT-ALIGN: right"><%=SystemEnv.getHtmlLabelName(1466,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(1817,user.getLanguage())%></TD>
    <TD></TD>
    <TD></TD>
    </TR>
    <TR class=Line><TD colSpan=8></TD></TR>
    </THEAD>
  <TBODY>
 <%
int i=0 ;
RecordSet.executeSql(sqlstr);
BigDecimal  trandaccountsall = new BigDecimal("0") ;
BigDecimal  trancaccountsall = new BigDecimal("0") ;

while(RecordSet.next()){
String ids = RecordSet.getString("id") ;
String tranmarks= RecordSet.getString("tranmark") ;
String transtatuss = RecordSet.getString("transtatus") ;
String trandepartmentids = RecordSet.getString("trandepartmentid") ;
String trandates = RecordSet.getString("trandate") ;
String createrids = RecordSet.getString("createrid") ;
String trandaccounts = RecordSet.getString("trandaccount") ;
String trancaccounts = RecordSet.getString("trancaccount") ;
String trancurrencyids = RecordSet.getString("trancurrencyid") ;
trandaccountsall = trandaccountsall.add(new BigDecimal(trandaccounts));
trancaccountsall = trancaccountsall.add(new BigDecimal(trancaccounts));

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
    <TD><A 
      href="FnaTransactionEdit.jsp?id=<%=ids%>"><%=tranmarks%></A></TD>
   
    <TD>
	<% if(transtatuss.equals("0")) {%> <%=SystemEnv.getHtmlLabelName(360,user.getLanguage())%> 
	<%} else if(transtatuss.equals("1")) {%> <%=SystemEnv.getHtmlLabelName(142,user.getLanguage())%>
	<%} else if(transtatuss.equals("2")) {%> <%=SystemEnv.getHtmlLabelName(1815,user.getLanguage())%>
	<%} else if(transtatuss.equals("3")) {%> <%=SystemEnv.getHtmlLabelName(1816,user.getLanguage())%>
	<%}%> 
	</TD>
    <TD><a href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=trandepartmentids%>"><%=Util.toScreen(DepartmentComInfo.getDepartmentname(trandepartmentids),user.getLanguage())%></a></TD>
    <TD><%=trandates%></TD>
    <TD><a href="/hrm/resource/HrmResource.jsp?id=<%=createrids%>"><%=Util.toScreen(ResourceComInfo.getResourcename(createrids),user.getLanguage())%></a></TD>
    <TD><%=Util.getFloatStr(trandaccounts.toString(),3)%></TD>
    <TD><%=Util.getFloatStr(trancaccounts.toString(),3)%></TD>
    <TD><%=Util.toScreen(CurrencyComInfo.getCurrencyname(trancurrencyids),user.getLanguage())%></TD>
    </TR>
<%}%>
        <tr class=header>
    <TD><B><%=SystemEnv.getHtmlLabelName(523,user.getLanguage())%></B></TD>
    <TD></TD>
    <TD></TD>
    <TD></TD>
    <TD></TD>
    <TD><B><%=Util.getFloatStr(trandaccountsall.toString(),3)%></B></TD>
    <TD><B><%=Util.getFloatStr(trancaccountsall.toString(),3)%></B></TD>
    <TD></TD>
</TR></TBODY></TABLE>
<script language=vbs>
sub onShowDepartment()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="&frmMain.departmentid.value)
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	departmentspan.innerHtml = id(1)
	frmMain.departmentid.value=id(0)
	else
	departmentspan.innerHtml = ""
	frmMain.departmentid.value=""
	end if
	end if
end sub 
</script>
<script language=javascript>
function doprocess() {
	if(frmMain.departmentid.value=="") {
		alert("<%=SystemEnv.getHtmlNoteName(33,user.getLanguage())%>") ;
		return ;
	}
	if(frmMain.periodsid.value=="") {
		alert("<%=SystemEnv.getHtmlNoteName(34,user.getLanguage())%>") ;
		return ;
	}
	if(confirm("<%=SystemEnv.getHtmlNoteName(35,user.getLanguage())%>")) {
		location.href="FnaTransactionOperation.jsp?operation=processtransaction&departmentid="
		+frmMain.departmentid.value+"&tranperiods=<%=dbperiods%>" ;
	}
}
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
