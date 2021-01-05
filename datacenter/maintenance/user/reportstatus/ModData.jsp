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
String crmid = Util.null2String(request.getParameter("crmid"));
String inprepname = Util.fromScreen(request.getParameter("inprepname"),user.getLanguage());
String inpreptablename = Util.null2String(request.getParameter("inpreptablename"));
String inprepbugtablename = Util.null2String(request.getParameter("inprepbugtablename"));
String inprepfrequence = Util.null2String(request.getParameter("inprepfrequence"));
String inprepbudget = Util.null2String(request.getParameter("inprepbudget"));
String currentyear = Util.null2String(request.getParameter("currentyear"));
String currentmonth = Util.null2String(request.getParameter("currentmonth"));
String currentday = Util.null2String(request.getParameter("currentday"));

String currentdate = Util.null2String(request.getParameter("currentdate"));
String year = Util.null2String(request.getParameter("year"));
String month = Util.null2String(request.getParameter("month"));

String modtype = "" ;

String thedate = "" ;
String dspdate = year ;
if(type.equals("1")) {
    dspdate += "-"+month ;
    thedate = dspdate+"-15" ;
    modtype= "2" ;
}
else {
    thedate = dspdate+"-12-15" ;
    modtype= "3" ;
}

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
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>

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

<DIV class=HdrProps></DIV>
<DIV>
<% if(canedit) {%>
<BUTTON class=btnSave accessKey=S type=submit><U>S</U>-<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%></BUTTON>
<%}%>
<BUTTON class=btn accessKey=R onClick="history.back(-1)"><U>R</U>-返回</BUTTON>
</DIV>
<br>
  <table class=liststyle cellspacing=1 >
  <COLGROUP>
  <COL width="15%">
  <COL width="85%">
    <tbody> 
    <tr class=title>
      <td><nobr><b>修正：<%=inprepname%> : <font color=red><%=dspdate%></font></b></td>
      <td align=right></td>
    </tr>
	<tr class=spacing> 
      <td class=Sep2 colspan=2></td>
    </tr>
	<% 
	rs.executeProc("T_IRItemtype_SelectByInprepid",""+inprepid);
	while(rs.next()) {
		String itemtypeid = Util.null2String(rs.getString("itemtypeid")) ;
		String itemtypename = Util.toScreen(rs.getString("itemtypename"),user.getLanguage()) ;
	%>
	<tr class=spacing> 
      <td colspan=2 height=8></td>
    </tr>
	<tr class=spacing> 
      <td colspan=2><%=itemtypename%></td>
    </tr>
    <tr class=spacing> 
      <td class=Sep2 colspan=2></td>
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
        <input type=text size=30 name=<%=modfieldname%> <% if(hasvalue  && Util.getIntValue(rs2.getString(itemfieldname),0) != 0 ) {%> value="<%=Util.toScreenToEdit(rs2.getString(itemfieldname),user.getLanguage())%>" <%}%> onKeyPress="ItemCount_KeyPress()" onBlur='checkcount1(this)'><%=itemfieldunit%>

		<%} else if(itemfieldtype.equals("3")) { %>
        <input type=text size=30 name=<%=modfieldname%> <% if(hasvalue  && Util.getDoubleValue(rs2.getString(itemfieldname),0) != 0 ) {%> value="<%=Util.toScreenToEdit(rs2.getString(itemfieldname),user.getLanguage())%>" <%}%> onKeyPress="ItemNum_KeyPress()" onBlur='checknumber1(this)'><%=itemfieldunit%>
        <%}%>
	  </td>
    </tr>
	<%}}%>
    </tbody>
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
