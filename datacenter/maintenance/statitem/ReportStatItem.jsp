<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>

<%
if(!HrmUserVarify.checkUserRight("DataCenter:Maintenance", user)) {
    response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
%>


<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</head>
<%
String imagefilename = "/images/hdHRM.gif";
String titlename = SystemEnv.getHtmlLabelName(16890,user.getLanguage()) ;
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",ReportStatItemAdd.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>

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
  <COL width="20%">
  <COL width="40%">
  <COL width="40%">
  <TBODY>
  <TR class=Header>
    <TH colSpan=3><%=SystemEnv.getHtmlLabelName(16890,user.getLanguage())%></TH></TR>
  <TR class=Header>
    <TD><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(15828,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></TD>
  </TR>
  <TR class=line >
    <TD colSpan=3 style="padding:0;"></TD></TR>
<%
      
      boolean isLight = false;
      rs.executeProc("T_Statitem_SelectAll","");
      while(rs.next()){
        String statitemid = Util.null2String(rs.getString("statitemid")) ;
	  	String statitemname = Util.toScreen(rs.getString("statitemname"),user.getLanguage()) ;
        String statitemexpress = Util.null2String(rs.getString("statitemexpress")) ;
        String statitemdesc = Util.toScreen(rs.getString("statitemdesc"),user.getLanguage()) ;
       	isLight = ! isLight ;
%>
  <TR class='<%=( isLight ? "datalight" : "datadark" )%>'>
    <TD><a href='ReportStatItemEdit.jsp?statitemid=<%=statitemid%>'><%=statitemname%></a></TD>
    <TD><%=statitemexpress%></TD>
    <TD><%=statitemdesc%></TD>
  </TR>
<%
    }
%>  
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
