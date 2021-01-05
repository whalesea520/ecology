<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util,java.util.*" %>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
String inprepid = Util.null2String(request.getParameter("inprepid"));
String type = Util.null2String(request.getParameter("type"));

rs.executeProc("T_InputReport_SelectByInprepid",""+inprepid);
rs.next() ;

String inprepname = Util.toScreenToEdit(rs.getString("inprepname"),user.getLanguage()) ;
String inpreptablename = Util.null2String(rs.getString("inpreptablename")) ;
String inprepbugtablename = Util.null2String(rs.getString("inprepbugtablename")) ;
String inprepfrequence = Util.null2String(rs.getString("inprepfrequence")) ;
String inprepbudget = Util.null2String(rs.getString("inprepbudget")) ;
String inprepbudgetstatus = Util.null2String(rs.getString("inprepbudgetstatus")) ;

String thecloseperiod = "" ;
rs.executeSql("select fnayearperiodsid from FnaYearsPeriodsList where isclose='1' ");
while(rs.next()) {
    thecloseperiod += "," + Util.null2String(rs.getString(1)) ;
}

thecloseperiod += "," ;

Calendar today = Calendar.getInstance();
String currentyear = Util.add0(today.get(Calendar.YEAR), 4) ;
String currentmonth = Util.add0(today.get(Calendar.MONTH) + 1, 2) ;
String currentday = Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;
String currentdate = currentyear + "-" + currentmonth + "-" + currentday ;

String imagefilename = "/images/hdCRMAccount.gif";
String titlename = Util.toScreen("报表输入选择项",user.getLanguage(),"0");
String needfav ="1";
String needhelp ="";

%>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver.js"></script>
</HEAD>

<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<DIV class=HdrProps></DIV>
<FORM id=frmMain name= frmMain action="ModData.jsp" method=post onSubmit="return doSubmit();">
<input type="hidden" name="inprepid" value="<%=inprepid%>">
<input type="hidden" name="inprepname" value="<%=inprepname%>">
<input type="hidden" name="inpreptablename" value="<%=inpreptablename%>">
<input type="hidden" name="inprepbugtablename" value="<%=inprepbugtablename%>">
<input type="hidden" name="inprepfrequence" value="<%=inprepfrequence%>">
<input type="hidden" name="currentyear" value="<%=currentyear%>">
<input type="hidden" name="currentmonth" value="<%=currentmonth%>">
<input type="hidden" name="currentday" value="<%=currentday%>">
<input type="hidden" name="currentdate" value="<%=currentdate%>">
<input type="hidden" name="type" value="<%=type%>">

<DIV>
<BUTTON class=btn accessKey=C type=submit><U>C</U>-<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%></BUTTON>
<BUTTON class=btn accessKey=R onClick="history.back(-1)"><U>R</U>-返回</BUTTON>
</DIV>
<br>
	  <TABLE class=viewform width=250>
        <COLGROUP>
		<COL width="50">
  		<COL width="200">
        <TBODY>
		<% if(inprepbudget.equals("1") && inprepbudgetstatus.equals("1")) {%>
        <TR>
          <TD>是否预算</TD>
          <td class=Field id=txtLocation> 
            <input type="radio" name="inprepbudget" value="0" checked>
            否
            <input type="radio" name="inprepbudget" value="1">
            是</TD>
            </TR>
        <% }
        else { %>
        <input type="hidden" name="inprepbudget" value="0"> 
        <%} %>
          <TR>
          <TD>基层单位</TD>
          <td class=Field id=txtLocation> 
          <button class=Browser onClick="onShowCustomer('crmspan','crmid')"></button>
          <SPAN id=crmspan><IMG src="/images/BacoError.gif" align=absMiddle> </SPAN>
        <input type="hidden" id="crmid" name="crmid">
        <TR>
          <TD>修正日期</TD>
          <TD class=Field>
		  年：<select name="year">
		  <% for(int i=2 ; i>-3;i--) {
		  		int tempyear = Util.getIntValue(currentyear) - i ;
				String selected = "" ;
				if( type.equals("1") && !currentmonth.equals("01") && i==0) selected = "selected" ;
                else if( type.equals("1") && currentmonth.equals("01") && i==1) selected = "selected" ;
                else if( type.equals("2") && i==1) selected = "selected" ;
		  %>
          <option value="<%=tempyear%>" <%=selected%>><%=tempyear%></option>
		  <%}%>
		  </select>
		  <% if(type.equals("1")) { %>
		  月：<select name="month">
          <option value="01" <%if(currentmonth.equals("02")) {%>selected<%}%>>1</option>
		  <option value="02" <%if(currentmonth.equals("03")) {%>selected<%}%>>2</option>
		  <option value="03" <%if(currentmonth.equals("04")) {%>selected<%}%>>3</option>
		  <option value="04" <%if(currentmonth.equals("05")) {%>selected<%}%>>4</option>
		  <option value="05" <%if(currentmonth.equals("06")) {%>selected<%}%>>5</option>
		  <option value="06" <%if(currentmonth.equals("07")) {%>selected<%}%>>6</option>
		  <option value="07" <%if(currentmonth.equals("08")) {%>selected<%}%>>7</option>
		  <option value="08" <%if(currentmonth.equals("09")) {%>selected<%}%>>8</option>
		  <option value="09" <%if(currentmonth.equals("10")) {%>selected<%}%>>9</option>
		  <option value="10" <%if(currentmonth.equals("11")) {%>selected<%}%>>10</option>
		  <option value="11" <%if(currentmonth.equals("12")) {%>selected<%}%>>11</option>
		  <option value="12" <%if(currentmonth.equals("01")) {%>selected<%}%>>12</option>
		  </select>
          <%}%>
		  </TD>
        </TR>
	  </TBODY>
	 </TABLE>
</FORM>

          
<script language=vbs>
sub getDate()
	returndate = window.showModalDialog("/systeminfo/Calendar.jsp",,"dialogHeight:320px;dialogwidth:275px")
	if returndate <> "" then
		window.document.frmMain.date.value= returndate
		datespan.innerHtml = returndate
	end if
end sub

sub onShowCustomer(tdname,inputename)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp")
	if NOT isempty(id) then
        if id(0)<> "" then
		document.all(tdname).innerHtml = id(1)
		document.all(inputename).value = id(0)
		else
		document.all(tdname).innerHtml = "<IMG src='/images/BacoError.gif' align=absMiddle>"
		document.all(inputename).value =""
		end if
	end if
end sub

</script>

<script language=javascript>

function doSubmit() {
    if(check_form(document.frmMain,'crmid')) {
        selectedperiod = document.frmMain.year.value ;
        <% if(type.equals("2")) { %> selectedperiod = selectedperiod+"13" ; 
        <%} else { %> selectedperiod = selectedperiod+ document.frmMain.month.value ; <%}%>

        if('<%=thecloseperiod%>'.indexOf(','+selectedperiod+',') >= 0 ) {
            alert("你选择的期间已经关闭") ;
            return false ;
        }
        return true ;
    }
    return false ;
}
</script>


</BODY>
</HTML>
