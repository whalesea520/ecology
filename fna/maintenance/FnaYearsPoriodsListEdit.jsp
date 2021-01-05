<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
</head>
<%
int msgid = Util.getIntValue(request.getParameter("msgid") , -1) ; 
String id = Util.null2String(request.getParameter("id")) ; 
RecordSet.executeProc("FnaYearsPeriodsList_SelectByID" , id) ; 
RecordSet.next() ; 
String periodsid = Util.null2String(RecordSet.getString("Periodsid")) ; 
String fnayearid = Util.null2String(RecordSet.getString("fnayearid")) ; 
String fnayear = Util.null2String(RecordSet.getString("fnayear")) ; 
String startdate = Util.null2String(RecordSet.getString("startdate")) ; 
String enddate = Util.null2String(RecordSet.getString("enddate")) ; 
String isclose = Util.null2String(RecordSet.getString("isclose")) ; 
String isactive = Util.null2String(RecordSet.getString("isactive")) ; 
String fnayearperiodsid = Util.null2String(RecordSet.getString("fnayearperiodsid")) ; 
String trancount = Util.null2String(RecordSet.getString("trancount")) ; 
boolean canedit = HrmUserVarify.checkUserRight("FnaYearsPeriodsEdit:Edit" , user) &&  isclose.equals("0") ; 
boolean caneditactive = canedit && trancount.equals("0") ; 

String imagefilename = "/images/hdMaintenance_wev8.gif" ; 
String titlename = SystemEnv.getHtmlLabelName(446 , user.getLanguage()) + " : " + periodsid ; 
String needfav = "1" ; 
String needhelp = "" ; 
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(canedit) {
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onEdit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
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
if(msgid!=-1) {
%>
<DIV>
<font color=red size=2>
<%=SystemEnv.getErrorMsgName(msgid , user.getLanguage())%>
</font>
</DIV>
<%}%>
<FORM id=frmMain action=FnaYearsPeriodsOperation.jsp method=post>
    <!--以下部分被隐去
<DIV> 
    <% if(canedit) {%>
    <BUTTON class=btnSave accessKey=S onclick="onEdit()"><U>S</U>-<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%></BUTTON> 
    <% }
if(HrmUserVarify.checkUserRight("FnaYearsPeriods:Close", user)) {
if(isclose.equals("0")) { %>
    <!--BUTTON class=Btn id=Close accessKey=1 onclick="onClose()"><U>1</U>-<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%></BUTTON--> 
    <!--<%} else {%>-->
    <!--BUTTON  class=Btn id=Reopen accessKey=2 onclick="onReopen()"><U>2</U>-<%=SystemEnv.getHtmlLabelName(244,user.getLanguage())%></BUTTON--> 
    <%}}%>
  <!--</DIV>-->
  
<INPUT class=inputstyle id=fnayear type=hidden value="<%=fnayear%>" name=fnayear> 
<INPUT class=inputstyle id=id type=hidden value="<%=id%>" name=id>
  <input class=inputstyle type="hidden" name="operation">
  <input class=inputstyle id=fnayearid type=hidden value="<%=fnayearid%>" name=fnayearid>
  <input class=inputstyle id=fnayearperiodsid type=hidden value="<%=fnayearperiodsid%>" name=fnayearperiodsid>
  <TABLE class=ViewForm>
  <COLGROUP>
  <COL width="15%">
  <COL width="33%">
  <COL width=24>
  <COL width="15%">
  <COL width="33%">
  <TBODY>
  <TR class=Title>
      <TH><%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%></TH>
    </TR>
  <TR class=Spacing style="height:2px">
    <TD class=Line1 colSpan=5></TD></TR>
  <TR>
    <TD><%=SystemEnv.getHtmlLabelName(445,user.getLanguage())%></TD>
    <TD class=Field><B><%=fnayear%></B></TD>
    <TD></TD>
    <TD><%=SystemEnv.getHtmlLabelName(446,user.getLanguage())%></TD>
    <TD class=Field><B><%=periodsid%></B></TD></TR>
	<!--add by lupeng for TD496-->
  <TR style="height:1px"><TD class=Line colSpan=2></TD><TD></TD><TD class=Line colSpan=2></TR>
  <TR><TD colSpan=5 height=16></TD></TR>
  <!--end-->  
  <TR class=Title>
    <TH colSpan=5><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%></TH></TR>
  <TR class=Spacing style="height:2px">
    <TD class=Line1 colSpan=5></TD></TR>
  <TR>
    <TD><%=SystemEnv.getHtmlLabelName(740,user.getLanguage())%></TD>
      <TD class=Field colSpan=4>
	  <% if(caneditactive) {%>
	  <BUTTON class=Calendar type="button" id=selectstartdate onclick="onShowDate(startdatespan,startdate)"></BUTTON> 
              <SPAN id=startdatespan ><%=startdate%></SPAN> 
              <input type="hidden" name="startdate" value="<%=startdate%>">
		<%} else {%> <%=startdate%> <%}%>
       </TD></TR>
	   <!--add by lupeng for TD496-->
  <TR style="height:1px"><TD class=Line colSpan=2></TD><TD class=Line colSpan=4></TR>
  <!--end-->
  <TR>
    <TD><%=SystemEnv.getHtmlLabelName(741,user.getLanguage())%></TD>
    <TD class=Field colSpan=4>
	<% if(caneditactive) {%>
	<BUTTON class=Calendar type="button" id=selectstartdate onclick="onShowDate(enddatespan,enddate)"></BUTTON> 
              <SPAN id=enddatespan ><%=enddate%></SPAN> 
              <input type="hidden" name="enddate" value="<%=enddate%>">
			<%} else {%> <%=enddate%> <%}%>
       </TD></TR>
	   <!--add by lupeng for TD496-->
  <TR style="height:1px"><TD class=Line colSpan=2></TD><TD class=Line colSpan=4></TR>
  <!--end-->
	   <TR>
       <!-- 启用部分先隐掉 刘煜 2003－07－22 ， 并加入默认启用-->
       <input type="hidden" name="isactive" value="1">
      <!--TD><%=SystemEnv.getHtmlLabelName(1481,user.getLanguage())%></TD>
      <TD class=Field colSpan=4> 
        <% if(caneditactive) {%>
        <input type="checkbox" name="isactive" value="1" <%if(isactive.equals("1")) {%>checked<%}%>> 
        <%} else {%>
        <input type="checkbox" name="isactive" value="1" <%if(isactive.equals("1")) {%>checked<%}%> disabled> 
        <%}%>
      </TD-->
    </TR>
	   
	   </TBODY></TABLE>
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
<script language=javascript>
function StringToDate(DateStr){    
    var converted = Date.parse(DateStr);   
    var myDate = new Date(converted);
    if (isNaN(myDate)){    
        var arys= DateStr.split('-');
        myDate = new Date(arys[0],--arys[1],arys[2]);
    }
    return myDate;
}

 function onEdit() {
 	if(check_form(frmMain,"startdate,enddate")) {
 		if(StringToDate(frmMain.startdate.value)<=StringToDate(frmMain.enddate.value)){
			frmMain.operation.value = "edityearperiodslist";
			frmMain.submit() ; 
		} else {
			alert("<%=SystemEnv.getHtmlLabelName(16721,user.getLanguage())%>");
		}
	}
}
 function onClose() { 
		if(confirm("<%=SystemEnv.getHtmlNoteName(26,user.getLanguage())%>")) {
			frmMain.operation.value = "closeyearperiods";
			frmMain.submit();
		}
}
function onReopen() {
		if(confirm("<%=SystemEnv.getHtmlNoteName(27,user.getLanguage())%>")) {
			frmMain.operation.value = "reopenyearperiods" ; 
			frmMain.submit() ; 
		}
}
 </script>
</BODY>
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</HTML>
