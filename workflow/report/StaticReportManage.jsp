<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = Util.toScreen(SystemEnv.getHtmlLabelName(15527,user.getLanguage()),user.getLanguage(),"0") ;
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%
 if(HrmUserVarify.checkUserRight("WorkflowReportManage:All", user)){
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(365,user.getLanguage())+",StaticReportAdd.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%}%>


<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
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

<TABLE class=liststyle cellspacing=1  >
  <COLGROUP>
  <COL width="10%">
  <COL width="30%">
  <COL width="30%">
  <COL width="30%">
  <TBODY>
  <TR class="header">
    <TH colSpan=4><%=SystemEnv.getHtmlLabelName(15101,user.getLanguage())%></TH>
  </TR>

  <TR class=Header>
    <TD><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(15517,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(15531,user.getLanguage())%></TD>
	<TD><%=SystemEnv.getHtmlLabelName(15529,user.getLanguage())%></TD>
  </TR> <TR  class="Line">
    <TD colSpan=4 ></TD></TR>
<%  
    boolean islight=true;
    RecordSet.executeProc("Workflow_StaticReport_Select","");
    int needchange = 0;
    while(RecordSet.next()){
        int module = RecordSet.getInt("module");  
%>
  <tr <%if(islight) {%> class=datalight <%} else {%> class=datadark <%}%>>
    <TD><a href='StaticReportEdit.jsp?id=<%=RecordSet.getString("id")%>'><%=RecordSet.getString("id")%></a></TD>
    <TD><%=Util.toScreen(RecordSet.getString("name"),user.getLanguage())%></TD>
    <TD><%=Util.toScreen(RecordSet.getString("description"),user.getLanguage())%></TD>
	<TD><%if(module==1){%><%=SystemEnv.getHtmlLabelName(2115,user.getLanguage())%><%}%>
	    <%if(module==2){%><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%><%}%>
	    <%if(module==3){%><%=SystemEnv.getHtmlLabelName(2113,user.getLanguage())%><%}%>
	    <%if(module==4){%><%=SystemEnv.getHtmlLabelName(2116,user.getLanguage())%><%}%>
	    <%if(module==5){%><%=SystemEnv.getHtmlLabelName(2118,user.getLanguage())%><%}%>
	    <%if(module==6){%><%=SystemEnv.getHtmlLabelName(2114,user.getLanguage())%><%}%>
	    <%if(module==7){%><%=SystemEnv.getHtmlLabelName(2117,user.getLanguage())%><%}%>
	</TD>
  </TR>
<%}
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
