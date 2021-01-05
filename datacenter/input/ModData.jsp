<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs3" class="weaver.conn.RecordSet" scope="page" />


<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</head>
<%
int inprepid = Util.getIntValue(request.getParameter("inprepid"),0);
String type = Util.null2String(request.getParameter("type"));
String inprepbudget = Util.null2String(request.getParameter("inprepbudget"));
String crmid = ""+user.getUID();
String modtype = "" ;

String thedate = "" ;
String dspdate = "" ;

Calendar today = Calendar.getInstance();
String currentyear = Util.add0(today.get(Calendar.YEAR), 4) ;
String currentmonth = Util.add0(today.get(Calendar.MONTH) + 1, 2) ;
String currentday = Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;
String currentdate = currentyear + "-" + currentmonth + "-" + currentday ;

if(type.equals("1")) {      // 月修正
    modtype= "2" ;
    today.set(today.get(Calendar.YEAR), today.get(Calendar.MONTH), 1) ;
    today.add(Calendar.DATE, -1) ;
    currentyear = Util.add0(today.get(Calendar.YEAR), 4) ;
    currentmonth = Util.add0(today.get(Calendar.MONTH) + 1, 2) ;
    currentday = Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;
    dspdate = currentyear + "-" + currentmonth ;
    thedate = dspdate + "-" + currentday ;
}
else {
    modtype= "3" ;
    today.set(today.get(Calendar.YEAR), 11, 31) ;
    today.add(Calendar.YEAR, -1) ;
    currentyear = Util.add0(today.get(Calendar.YEAR), 4) ;
    currentmonth = Util.add0(today.get(Calendar.MONTH) + 1, 2) ;
    currentday = Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;
    dspdate = currentyear  ;
    thedate = dspdate + "-" + currentmonth + "-" + currentday ;
}

rs.executeProc("T_InputReport_SelectByInprepid",""+inprepid);
rs.next() ;

String inprepname = Util.toScreenToEdit(rs.getString("inprepname"),user.getLanguage()) ;
String inpreptablename = Util.null2String(rs.getString("inpreptablename")) ;
String inprepbugtablename = Util.null2String(rs.getString("inprepbugtablename")) ;


String thetable = "" ;
String inputid = "" ;
boolean canedit = true ;
boolean hasvalue = false ;

if(inprepbudget.equals("1")) thetable = inprepbugtablename ;
else thetable = inpreptablename ;


String sql =  "select * from "+ thetable + 
				  " where reportdate ='" +thedate+"' and crmid ="+crmid+" and modtype='"+modtype +"' " ;
	
rs2.executeSql(sql) ;
if(rs2.next()) {
    inputid = Util.null2String(rs2.getString("inputid")) ;
    hasvalue = true ;
}

String imagefilename = "/images/hdHRMCard.gif";
String titlename = Util.toScreen("报表修正",user.getLanguage(),"0") + inprepname;
if(inprepbudget.equals("1")) titlename += " " + Util.toScreen("预算",user.getLanguage(),"0") ;
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>

<% if(canedit) {%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:frmMain.submit(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%}%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:history.back(-1),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>

<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<FORM id=weaver name=frmMain action="ModDataOperation.jsp" method=post>
<input type="hidden" name="inprepid" value="<%=inprepid%>">
<input type="hidden" name="inprepname" value="<%=inprepname%>">
<input type="hidden" name="thetable" value="<%=thetable%>">
<input type="hidden" name="thedate" value="<%=thedate%>">
<input type="hidden" name="currentdate" value="<%=currentdate%>">
<input type="hidden" name="dspdate" value="<%=dspdate%>">
<input type="hidden" name="hasvalue" value="<%=hasvalue%>">
<input type="hidden" name="inputid" value="<%=inputid%>">
<input type="hidden" name="inprepbudget" value="<%=inprepbudget%>">
<input type="hidden" name="crmid" value="<%=crmid%>">
<input type="hidden" name="type" value="<%=type%>">
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


  <table class=liststyle cellspacing=1 >
  <COLGROUP>
  <COL width="15%">
  <COL width="85%">
    <tbody> 
    <tr class=header>
      <td><nobr><b>修正：<%=inprepname%> <% if(inprepbudget.equals("1")) {%> 预算 <%}%> : <font color=red><%=dspdate%></font></b></td>
      <td align=right></td>
    </tr>
	<% 
	rs.executeProc("T_IRItemtype_SelectByInprepid",""+inprepid);
	while(rs.next()) {
		String itemtypeid = Util.null2String(rs.getString("itemtypeid")) ;
		String itemtypename = Util.toScreen(rs.getString("itemtypename"),user.getLanguage()) ;
	%>
	<tr class=header> 
      <td colspan=2><%=itemtypename%></td>
    </tr>
    <tr class=line> 
      <td  colspan=2></td>
    </tr>
    <%
	int i = 0 ;
	rs1.executeProc("T_IRItem_SelectByItemtypeid",""+itemtypeid);
	while(rs1.next()) {
		String itemid = Util.null2String(rs1.getString("itemid")) ;
		String itemdspname = Util.toScreen(rs1.getString("itemdspname"),user.getLanguage()) ;
		String itemfieldname = Util.null2String(rs1.getString("itemfieldname")) ;
		String itemfieldtype = Util.null2String(rs1.getString("itemfieldtype")) ;
		String itemfieldscale = Util.null2String(rs1.getString("itemfieldscale")) ;
		String itemexcelsheet = Util.toScreen(rs1.getString("itemexcelsheet"),user.getLanguage()) ;
		String itemexcelrow = Util.null2String(rs1.getString("itemexcelrow")) ;
		String itemexcelcolumn = Util.null2String(rs1.getString("itemexcelcolumn")) ;
        String itemfieldunit = Util.toScreen(rs1.getString("itemfieldunit"),user.getLanguage()) ;
        String modfieldname = itemfieldname + "_mod" ;

        if(!itemfieldtype.equals("2") && !itemfieldtype.equals("3")) continue ;
		
  	if(i==0){ 
  		i=1;
  	%>
    <tr class=datalight> 
      <%}else{
  		i=0;
  	%>
    <tr class=datadark> 
    <% }%>
      <td><%=itemdspname%>(修正)</td>
	  <td>
		<%if(itemfieldtype.equals("2")) {%>
        <input type=text class="InputStyle" size=30 name=<%=modfieldname%> <% if(hasvalue  && Util.getIntValue(rs2.getString(itemfieldname),0) != 0 ) {%> value="<%=Util.toScreenToEdit(rs2.getString(itemfieldname),user.getLanguage())%>" <%}%> onKeyPress="ItemCount_KeyPress()" onBlur='checkcount1(this)'><%=itemfieldunit%>

		<%} else if(itemfieldtype.equals("3")) { %>
        <input type=text class="InputStyle"  size=30 name=<%=modfieldname%> <% if(hasvalue  && Util.getDoubleValue(rs2.getString(itemfieldname),0) != 0 ) {%> value="<%=Util.toScreenToEdit(rs2.getString(itemfieldname),user.getLanguage())%>" <%}%> onKeyPress="ItemNum_KeyPress()" onBlur='checknumber1(this)'><%=itemfieldunit%>
        <%}%>
	  </td>
    </tr>
	<%}}%>
    </tbody>
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

</form>

<script language=javascript>
 function onSave(){
	if(check_form(document.frmMain,'inprepname')){
	 	document.frmMain.operation.value="edit";
		document.frmMain.submit();
	}
 }
 function onDelete(){
		if(confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>")) {
			document.frmMain.operation.value="delete";
			document.frmMain.submit();
		}
}
 </script>
 
 <script language=vbs>
 
sub onShowCustomer()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
		window.location = "InputReportOperation.jsp?operation=addcrm&inprepid=<%=inprepid%>&crmid=" & id(0)
	end if
	end if
end sub

</script>
 
</BODY></HTML>
