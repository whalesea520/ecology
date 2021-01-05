<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<% if(!HrmUserVarify.checkUserRight("FnaYearsPeriodsAdd:Add" , user)) {
	response.sendRedirect("/notice/noright.jsp") ; 
	return ; 
   }
%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
</head>
<%
int msgid = Util.getIntValue(request.getParameter("msgid") , -1) ; 
Calendar today = Calendar.getInstance() ; 
String currentyear = Util.add0(today.get(Calendar.YEAR) , 4) ; 
String currentdate = Util.add0(today.get(Calendar.YEAR), 4) + "-" + 
				 Util.add0(today.get(Calendar.MONTH) + 1 , 2) + "-" + 
				 Util.add0(today.get(Calendar.DAY_OF_MONTH) , 2) ; 
RecordSet.executeProc("FnaYearsPeriods_SelectMaxYear" , "") ; 
if(RecordSet.next()) { 
	String thelastyear = RecordSet.getString("fnayear") ; 
	String thelastdate = RecordSet.getString("enddate") ; 
	currentyear = Util.add0(Util.getIntValue(thelastyear) + 1 , 4) ; 
	int tempyear = Util.getIntValue(thelastdate.substring(0,4)) ; 
	int tempmonth = Util.getIntValue(thelastdate.substring(5 , 7)) - 1 ; 
	int tempdate = Util.getIntValue(thelastdate.substring(8,10)) ; 
	today.set(tempyear,tempmonth,tempdate) ; 
	today.add(Calendar.DATE , 1) ; 
	currentdate = Util.add0(today.get(Calendar.YEAR) , 4) + "-" + 
				  Util.add0(today.get(Calendar.MONTH) + 1 , 2) + "-" + 
				  Util.add0(today.get(Calendar.DAY_OF_MONTH) , 2) ; 
}

String imagefilename = "/images/hdMaintenance_wev8.gif" ; 
String titlename = SystemEnv.getHtmlLabelName(445 , user.getLanguage()) + " : "+SystemEnv.getHtmlLabelName(365 , user.getLanguage()) ; 
String needfav = "1" ; 
String needhelp = "" ; 
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:history.go(-1) ,_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr style="height:0px">
	<td height="0" colspan="3"></td>
</tr>
<tr>
<td ></td>
<td valign="top">
<TABLE class=Shadow>
<tr>
<td valign="top">

<%
if(msgid != -1) {
%>
<DIV>
<font color=red size=2>
<%=SystemEnv.getErrorMsgName(msgid , user.getLanguage())%>
</font>
</DIV>
<%}%>
<FORM id=frmMain action=FnaYearsPeriodsOperation.jsp method=post >
<input class=inputstyle type=hidden name=operation value="addyearperiods">
<TABLE class=ViewForm>
  <TBODY>
  <TR class=Title>
    <TH><%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%></TH></TR>
  <TR class=Spacing>
    <TD class=sep1></TD></TR></TBODY></TABLE>
  <TABLE class=ViewForm width="60%">
    <COLGROUP> <COL width="15%"> <COL width="85%"><TBODY> 
	<!--add by lupeng for TD433--><TR style="height:2px"><TD class=Line1 colSpan=2></TD></TR><!--end-->
    <TR> 
      <TD><%=SystemEnv.getHtmlLabelName(445,user.getLanguage())%></TD>
      <TD class=Field> 
        <input class=inputstyle id=fnayear name=fnayear value="<%=currentyear%>" maxlength="4" 
		onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("fnayear");checkinput("fnayear","fnayearimage")'>
              <SPAN id=fnayearimage></SPAN>
      </TD>
    </TR><!--add by lupeng for TD433--><TR style="height:1px"><TD class=Line colSpan=2></TD></TR><!--end-->
    <TR> 
      <TD><%=SystemEnv.getHtmlLabelName(740,user.getLanguage())%></TD>
      <TD class=Field><BUTTON class=Calendar type="button" id=selectstartdate onclick="onShowDate(startdatespan,startdate)"></BUTTON> 
              <SPAN id=startdatespan ><%=currentdate%></SPAN> 
              <input class=inputstyle type="hidden" name="startdate" value="<%=currentdate%>">
      </TD>
	  </TR>
	  
	<!--add by wangdongli-->
    <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
	<tr>
		<td><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></td>
		<td class="Field"><%=SystemEnv.getHtmlLabelName(18430,user.getLanguage())%><input name="status" id="status" class="inputstyle" type="hidden" value="0"/></td>
	</tr>
	<!--end-->
	  
	  
	  <!--add by lupeng for TD433--><TR style="height:1px"><TD class=Line colSpan=2></TD></TR><!--end-->
    </TBODY> 
  </TABLE>
</FORM>
</td>
</tr>
</TABLE>
</td>
<td></td>
</tr>
<tr style="height:0px">
	<td height="0" colspan="3"></td>
</tr>
</table>
<Script language=javascript>
function checkvalue() {
	if(!check_form(frmMain,"fnayear,startdate")) return false ;
	if(frmMain.fnayear.value.length != 4 ) {
		alert("<%=SystemEnv.getHtmlNoteName(25,user.getLanguage())%>");
		return false;
	}
	return true ;
}

function submitData() {
	if(checkvalue()) frmMain.submit();
}
</script>
</BODY>
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</HTML>
