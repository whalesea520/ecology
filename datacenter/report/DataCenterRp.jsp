<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</head>
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = Util.toScreen("报表",7,"0") ;
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>

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



<table class=viewform width="100%">
  <tbody> 
  <tr class=title> 
    <th>报表</th>
  </tr>
  <tr> 
    <td  class=line1></td>
  </tr>
  <%
		String userid = ""+user.getUID() ;
		char separator = Util.getSeparator() ;
		String para = userid + separator + "1" ;
		
		if(HrmUserVarify.checkUserRight("DataCenter:Maintenance", user)) 
			RecordSet.executeProc("T_OutReport_SelectAll","");
		else
			RecordSet.executeProc("T_OutReport_SelectByUserid",para);
			
		while(RecordSet.next()) {
			String outrepid =  Util.null2String(RecordSet.getString("outrepid")) ;
			String outrepname = Util.toScreen(RecordSet.getString("outrepname"),user.getLanguage()) ;
		%>
  <tr class="spacing"> 
    <td><a 
            href="/datacenter/report/OutReportSel.jsp?outrepid=<%=outrepid%>"><%=outrepname%></a></td>
  </tr>
    <tr> 
    <td  class=line></td>
  </tr>
  <%}%>
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


</BODY></HTML>
