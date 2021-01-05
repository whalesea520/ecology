<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif" ; 
String titlename = SystemEnv.getHtmlLabelName(446 , user.getLanguage()) ; 
String needfav = "1" ; 
String needhelp = "" ; 
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(HrmUserVarify.checkUserRight("FnaYearsPeriodsAdd:Add" , user)) { 
RCMenu += "{"+SystemEnv.getHtmlLabelName(365 , user.getLanguage())+",/fna/maintenance/FnaYearsPeriodsAdd.jsp,_self} " ; 
RCMenuHeight += RCMenuHeightStep ;
}
//modified by lupeng 2004.05.12 for TD429
if(HrmUserVarify.checkUserRight("FnaYearsPeriods:Log", user)){
if(RecordSet.getDBType().equals("db2")){
RCMenu +="{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where int(operateitem)=37,_self}";   
}else{
RCMenu +="{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem=37,_self}";
}

RCMenuHeight += RCMenuHeightStep ;
}
//end
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
<TABLE class=Form>
  <TBODY>
 <!-- <TR>
    <TH class=section align=left colSpan=2><%=SystemEnv.getHtmlLabelName(445 , user.getLanguage())%></TH></TR>-->
  <TR class=separator>
    <TD class=Line1 colSpan=2></TD></TR></TBODY></TABLE>
<TABLE class=ListStyle cellspacing=1>
  <COLGROUP>
  <COL width="20%">
  <COL width="25%">
  <COL width="25%">
  <!--add by wangdongli-->
  <COL width="15%">
  <!--end-->
  <!--COL width="30%"-->
  <TBODY>
  <TR class=Header align=left>
    <TH><%=SystemEnv.getHtmlLabelName(445,user.getLanguage())%></TH>
    <TH><%=SystemEnv.getHtmlLabelName(740,user.getLanguage())%></TH>
    <TH><%=SystemEnv.getHtmlLabelName(741,user.getLanguage())%></TH>
    
	<!--add by wangdongli-->
    <TH><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></TH>
	<!--end-->
	
    <!--TH><%=SystemEnv.getHtmlLabelName(567,user.getLanguage())%></TH--></TR>

<%
	RecordSet.executeProc("FnaYearsPeriods_Select","");
	int i = 0 ;
	while(RecordSet.next()){
		String id =RecordSet.getString("id");
		String fnayear=Util.toScreen(RecordSet.getString("fnayear"),user.getLanguage());
		String startdate=Util.null2String(RecordSet.getString("startdate"));
		String enddate=Util.null2String(RecordSet.getString("enddate"));
		String budgetid=Util.null2String(RecordSet.getString("budgetid"));
		
		/* add by wangdongli */
		String status=Util.null2o(RecordSet.getString("status"));
		String showStatus = SystemEnv.getHtmlLabelName(18430,user.getLanguage());
		if("0".equals(status)) showStatus=SystemEnv.getHtmlLabelName(18430,user.getLanguage());
		else if("1".equals(status)) showStatus=SystemEnv.getHtmlLabelName(18431,user.getLanguage());
		else if("-1".equals(status)) showStatus=SystemEnv.getHtmlLabelName(309,user.getLanguage());
		/* end */
		
if(i==0) {
		i=1 ; 
%>
<TR class=DataLight>
<%
	}else{
		i=0 ; 
%>
<TR class=DataDark>
<%
}
%>
    <TD><A href="FnaYearsPeriodsEdit.jsp?id=<%=id%>"><%=fnayear%></A></TD>
    <TD><%=startdate%></TD>
    <TD><%=enddate%></TD>
    <!--TD><%=budgetid%></TD-->
    
	<!--add by wangdongli-->
    <TD><%=showStatus%></TD>
	<!--end-->
    
    </TR>
<%}%>
</TBODY></TABLE>
    
</td>
</tr>
	</TABLE>
	</td>
	<td></td>
</tr>
<tr style="height:0px">
	<td height="0" colspan="4"></td>
</tr>
</table>
</BODY>
</HTML>
