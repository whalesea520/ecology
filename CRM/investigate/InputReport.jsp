<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>

<%
if(!HrmUserVarify.checkUserRight("DataCenter:Maintenance", user)) {
    response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
%>


<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>
<%
String imagefilename = "/images/hdHRM_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(15184,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javascript:location.href='InputReportAdd.jsp',_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>

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
<TABLE class=ListStyle cellspacing=1>
  <COLGROUP>
  <COL width="50%">
  <COL width="50%">
  
  <TBODY>
  <TR class=header>
    <TH colSpan=4><%=SystemEnv.getHtmlLabelName(15184,user.getLanguage())%></TH></TR>
  <TR class=Header>
    <TD><%=SystemEnv.getHtmlLabelName(15185,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(15186,user.getLanguage())%></TD>
	
  </TR>
<TR class=Line><TD colSpan=2></TD></TR>
<%
      rs.executeProc("T_SurveyItem_SelectAll","");
      int needchange = 0;
      while(rs.next()){
	    String inprepid = Util.null2String(rs.getString("inprepid")) ;
	  	String inprepname = Util.toScreen(rs.getString("inprepname"),user.getLanguage()) ;
		String inpreptablename = Util.null2String(rs.getString("inpreptablename")) ;
       	if(needchange ==0){
       		needchange = 1;
%>
  <TR class=datalight>
  <%
  	}else{
  		needchange=0;
  %><TR class=datadark>
  <%}%>
    <TD><a href='InputReportEdit.jsp?inprepid=<%=inprepid%>'><%=inprepname%></a></TD>
    <TD>
	<%=inpreptablename%>
	</TD>
    
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
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
</BODY></HTML>
