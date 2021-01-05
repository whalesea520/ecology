<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>


<%
if(!HrmUserVarify.checkUserRight("DataCenter:Maintenance", user)) {
    response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
%>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</head>
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = Util.toScreen("数据中心",7,"0") ;
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
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


<TABLE class=liststyle cellspacing=1 >
  <COLGROUP>
  <COL width="48%">
   <TBODY>
   
        <TR class=header> 
          <TH>报表监控</TH>
        </TR>
		<TR class=Line><Th colSpan=2></Th></TR> 
		<%
		      boolean isLight = false;
		RecordSet.executeProc("T_InputReport_SelectAll","");
		while(RecordSet.next()) {
			String inprepid =  Util.null2String(RecordSet.getString("inprepid")) ;
			String inprepname = Util.toScreen(RecordSet.getString("inprepname"),user.getLanguage()) ;
		
		 isLight = !isLight ;
		%>
	
        <tr class='<%=( isLight ? "datalight" : "datadark" )%>'> 
          <td><a 
            href="ReportDetailStatus.jsp?inprepid=<%=inprepid%>"><%=inprepname%></a></td>
        </tr>
		<%}%>
      
	  </TBODY></TABLE>




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
