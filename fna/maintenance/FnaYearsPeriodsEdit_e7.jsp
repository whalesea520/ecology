<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="BudgetModuleComInfo" class="weaver.fna.maintenance.BudgetModuleComInfo" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
</head>
<%
String id = Util.null2String(request.getParameter("id")) ; 
int msgid = Util.getIntValue(request.getParameter("msgid") , -1) ; 
RecordSet.executeProc("FnaYearsPeriods_SelectByID" , id) ; 
RecordSet.next() ; 
String fnayear = Util.null2String(RecordSet.getString("fnayear")) ; 
String startdate = Util.null2String(RecordSet.getString("startdate")) ; 
String enddate = Util.null2String(RecordSet.getString("enddate")) ; 
String budgetid = Util.null2String(RecordSet.getString("budgetid")) ;

/* add by wangdongli */
String status=Util.null2o(RecordSet.getString("status"));
String showStatus = SystemEnv.getHtmlLabelName(18430,user.getLanguage());
if("0".equals(status)) showStatus=SystemEnv.getHtmlLabelName(18430,user.getLanguage());
else if("1".equals(status)) showStatus=SystemEnv.getHtmlLabelName(18431,user.getLanguage());
else if("-1".equals(status)) showStatus=SystemEnv.getHtmlLabelName(309,user.getLanguage());
/* end */

boolean canedit = HrmUserVarify.checkUserRight("FnaYearsPeriodsEdit:Edit" , user) ; 

String imagefilename = "/images/hdMaintenance_wev8.gif" ; 
String titlename = SystemEnv.getHtmlLabelName(445 , user.getLanguage()) + " : " + fnayear ; 
String needfav = "1" ; 
String needhelp = "" ; 
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%
if(HrmUserVarify.checkUserRight("FnaYearsPeriodsAdd:Add",user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(365,user.getLanguage())+",/fna/maintenance/FnaYearsPeriodsAdd.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}

if(HrmUserVarify.checkUserRight("FnaYearsPeriodsEdit:Delete",user)) {
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
/*add by DS*/
if(HrmUserVarify.checkUserRight("FnaYearsPeriodsEdit:Delete",user)&&"-1".equals(status)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(244,user.getLanguage())+",javascript:onReopenDD(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
/* add by wangdongli */
if(HrmUserVarify.checkUserRight("FnaYearsPeriodsEdit:Delete",user)&&"0".equals(status)) {
RCMenu += "{"+SystemEnv.getHtmlLabelName(18431,user.getLanguage())+",javascript:onTakeEffect(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(HrmUserVarify.checkUserRight("FnaYearsPeriodsEdit:Delete",user)&&"1".equals(status)) {
RCMenu += "{"+SystemEnv.getHtmlLabelName(309,user.getLanguage())+",javascript:onCloseDown(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
/* end */
if(HrmUserVarify.checkUserRight("FnaYearsPeriods:Log",user)) {
if(RecordSet.getDBType().equals("db2")){
RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where int(operateitem) =37 and relatedid="+id+",_self} " ;   
}else{
RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem =37 and relatedid="+id+",_self} " ;
}

RCMenuHeight += RCMenuHeightStep ;
}
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
if(msgid!=-1){
%>
<DIV>
<font color=red size=2>
<%=SystemEnv.getErrorMsgName(msgid , user.getLanguage())%>
</font>
</DIV>
<%}%>
<FORM id=frmMain action=FnaYearsPeriodsOperation.jsp method=post onsubmit='return checkvalue()'>
<DIV>
<input class=inputstyle id=fnayear type=hidden value="<%=fnayear%>" name=fnayear>
<input class=inputstyle type="hidden" name="operation">
<input class=inputstyle type="hidden" name="id" value="<%=id%>">
  <TABLE class=ViewForm>
  <TBODY>
  <TR class=Title>
      <TH><%=SystemEnv.getHtmlLabelName(1361 , user.getLanguage())%></TH>
    </TR>
  <TR class=Spacing style="height:2px">
    <TD class=Line1></TD></TR></TBODY></TABLE>
<TABLE class=ViewForm>
  <COLGROUP>
  <COL width="15%">
  <COL width="33%">
  <COL width=24>
  <COL width="15%">
  <COL width="33%">
  <TBODY>
  <TR>
    <TD><%=SystemEnv.getHtmlLabelName(445 , user.getLanguage())%></TD>
      <TD class=Field colSpan=2><B><%=fnayear%><B> </B></B></TD>
    <TR style="height:1px">
    <TD class=Line colSpan=4></TD>
    </TR>
  <TR>
    <TD><%=SystemEnv.getHtmlLabelName(740 , user.getLanguage())%>, <%=SystemEnv.getHtmlLabelName(741 , user.getLanguage())%></TD>
      <TD class=Field colSpan=2><%=startdate%> - <%=enddate%> </TD>
   </TR>
    <TR style="height:1px"><TD class=Line colSpan=4></TD>
    </TR>

  
  <!--add by wangdongli-->
  <TR>
    <TD><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></TD>
      <TD class=Field colSpan=2><%=showStatus%></TD>
    </TR>
    <TR style="height:1px"><TD class=Line colSpan=4></TD>
    </TR>

  <!--end-->
  
  <!--TR>
    <TD><%=SystemEnv.getHtmlLabelName(567,user.getLanguage())%></TD>
    <TD class=field colSpan=2>
	<% if(canedit) {  %>
	<SELECT class=fieldshort id=budgetid name=budgetid> 
	<OPTION value=""></OPTION>
	<% while(BudgetModuleComInfo.next(fnayear)) { 
	String tmpbudgetmoduleid = BudgetModuleComInfo.getBudgetModuleid() ;
	String tmpbudgetmodulename = Util.toScreen(BudgetModuleComInfo.getBudgetModulename(), user.getLanguage()) ;
	%> 
	<OPTION value=<%=tmpbudgetmoduleid%> <% if(budgetid.equals(tmpbudgetmoduleid)) {%>selected <%}%>><%=tmpbudgetmodulename%></OPTION>
	<%}%>
	</SELECT>
	<%} else {%><%=Util.toScreen(BudgetModuleComInfo.getBudgetModulename(budgetid), user.getLanguage())%><%}%>
	</TD>
    <TD colSpan=2></TD></TR--></TBODY></TABLE></FORM>
    
	<BR>
<TABLE class=ViewForm>
  <TBODY>
  <TR>
    <TH class=Title align=left><%=SystemEnv.getHtmlLabelName(446,user.getLanguage())%></TH></TR>        
  <!--add by lupeng for TD435-->
  <TR style="height:2px"><TD class=Line1 colSpan=2></TD></TR>
  <!--end--></TBODY>
  </TABLE>
<TABLE class=ListStyle cellspacing=1>
  <COLGROUP>
  <COL width="20%">
  <COL width="30%">
  <COL width="30%">
  <!--COL width="20%"-->
  <THEAD>
  <TR class=Header align=left>
    <TH><%=SystemEnv.getHtmlLabelName(446,user.getLanguage())%></TH>
    <TH><%=SystemEnv.getHtmlLabelName(740,user.getLanguage())%></TH>
    <TH><%=SystemEnv.getHtmlLabelName(741,user.getLanguage())%></TH>
	<!--TD><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></TD-->
	</TR>
    <TR class=Line><TD colSpan=3></TD></TR> 
<%
int i= 0;
RecordSet.executeProc("FnaYearsPeriodsList_SByFnayear",id);
while(RecordSet.next()) {
	String pid = RecordSet.getString("id") ;
	String periodsid = RecordSet.getString("Periodsid") ;
	String tmpstartdate = RecordSet.getString("startdate") ;
	String tmpenddate = RecordSet.getString("enddate") ;
	String isclose = RecordSet.getString("isclose") ;

    if( periodsid.equals("13") ) continue ;   // 先隐掉期间为13的项， 刘煜 2003－07－22
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
      href="FnaYearsPoriodsListEdit.jsp?id=<%=pid%>"><%=periodsid%></A></TD>
    <TD><%=tmpstartdate%></TD>
    <TD><%=tmpenddate%></TD>
	<!--TD>
	<% if(isclose.equals("0")) {%><%=SystemEnv.getHtmlLabelName(360,user.getLanguage())%>
	<%} else {%><%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%> <%}%>
	</TD-->
	</TR>
<%}%>
</TABLE>
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
 function onEdit(){
	frmMain.operation.value="edityearperiods" ; 
	frmMain.submit() ; 
}
function onDelete() {
		if(confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>")) {
			frmMain.operation.value="deleteyearperiods" ; 
			frmMain.submit() ; 
		}
}
<!--add by wangdongli-->
function onTakeEffect() {
		frmMain.operation.value="takeeffectyearperiods" ; 
		frmMain.submit() ; 
}
function onCloseDown() {
	if(confirm("<%=SystemEnv.getHtmlNoteName(75,user.getLanguage())%>")) {
		frmMain.operation.value="closedownyearperiods" ; 
		frmMain.submit() ; 
	}
}
function onReopenDD() {
	if(confirm("<%=SystemEnv.getHtmlLabelName(18900,user.getLanguage())%>")) {
		frmMain.operation.value="reopenDD" ; 
		frmMain.submit() ; 
	}
}
<!--end-->
</script>
 
</BODY></HTML>
