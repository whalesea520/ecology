<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(564,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if (true) {
    response.sendRedirect("/notice/noright.jsp");
    return;
}
if(HrmUserVarify.checkUserRight("FnaIndicatorAdd:Add", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(365,user.getLanguage())+",/fna/indicator/FnaIndicatorAdd.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(HrmUserVarify.checkUserRight("FnaIndicator:Log", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem =42,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
<td ></td>
<td valign="top">
<TABLE class=Shadow>
<tr>
<td valign="top">

<TABLE class=ListStyle cellspacing=1 style="margin-bottom: 0px;">
  <TBODY>
  <TR class=Header>
    <TH><%=SystemEnv.getHtmlLabelName(564,user.getLanguage())%></TH>
  </TR>
  </TBODY></TABLE>
<TABLE class=ListStyle cellspacing=1 style="margin-top: 0px;">
  <THEAD>
  <COLGROUP>
  <COL width="40%" align=left>
  <COL width="60%"  align=left>
  <TR class=Header>
    <TH><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TH>
    <TH><%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%></TH>
    </TR>
    <TR style="height: 1px;"><TD class=Line colspan="2" style="padding: 0px;"></TD></TR> 
    </THEAD>
<%
int i= 0;
RecordSet.executeProc("FnaIndicator_Select","");
while(RecordSet.next()) {
	String id = RecordSet.getString("id") ;
	String indicatorname = Util.toScreen(RecordSet.getString("indicatorname"),user.getLanguage()) ;
	String indicatordesc = Util.toScreen(RecordSet.getString("indicatordesc"),user.getLanguage()) ;
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
      href="FnaIndicatorEdit.jsp?id=<%=id%>"><%=indicatorname%></A></TD>
    <TD><%=indicatordesc%></TD></TR>
<%}%>
</TABLE>
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
</BODY>
</HTML>