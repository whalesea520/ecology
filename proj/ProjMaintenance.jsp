
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(101,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(60,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

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

<%if(!software.equals("ALL")){%>
<%
String mainttype = Util.null2String(request.getParameter("mainttype"));
%>

<TABLE class="Form">
	<TR>
		<TD align=right>
	<select class=inputstyle  name=mainttype onchange="changetype()">
		<OPTION value=S <%if(mainttype.equals("S")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(468,user.getLanguage())%></OPTION>
		<OPTION value=W <%if(mainttype.equals("W")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(259,user.getLanguage())%></OPTION>
		<OPTION value=D <%if(mainttype.equals("D")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%></OPTION>
		<OPTION value=H <%if(mainttype.equals("H")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></OPTION>
<%if(software.equals("ALL") || software.equals("CRM")){%>
		<OPTION value=C <%if(mainttype.equals("C")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(147,user.getLanguage())%></OPTION>
		<OPTION value=R <%if(mainttype.equals("R")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(101,user.getLanguage())%></OPTION>
<%}%>
<%if(software.equals("ALL") || software.equals("HRM")){%>
		<OPTION value=I <%if(mainttype.equals("I")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(535,user.getLanguage())%></OPTION>
<%}%>
<%if(software.equals("ALL") || software.equals("HRM") || software.equals("CRM")){%>
		<OPTION value=F <%if(mainttype.equals("F")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(189,user.getLanguage())%></OPTION>
<%}%>
	</SELECT>
	<script language=javascript>
		function changetype(){
		if(document.all("mainttype").value=="S") location = "/system/SystemMaintenance.jsp?mainttype=S";
		if(document.all("mainttype").value=="W") location = "/workflow/WFMaintenance.jsp?mainttype=W";
		if(document.all("mainttype").value=="D") location = "/docs/DocMaintenance.jsp?mainttype=D";
		if(document.all("mainttype").value=="H") location = "/hrm/HrmMaintenance.jsp?mainttype=H";
		if(document.all("mainttype").value=="C") location = "/CRM/CRMMaintenance.jsp?mainttype=C";
		if(document.all("mainttype").value=="R") location = "/proj/ProjMaintenance.jsp?mainttype=R";
		if(document.all("mainttype").value=="F") location = "/fna/FnaMaintenance.jsp?mainttype=F";
		if(document.all("mainttype").value=="I") location = "/cpt/CptMaintenance.jsp?mainttype=I";
	}
	</script>
		</TD>
	</TR>
	<TR><TD class=Line ></TD></TR> 
</TABLE>
<%}%>


<TABLE class=viewform width="100%">
  <COLGROUP>
  <COL width="48%">
  <COL width=24>
  <COL width="48%">
  <TBODY>
  <TR vAlign=top>
    <TD>
      <TABLE class=viewform>
        <COLGROUP>
        <COL width="100%">
        <TBODY>
        <TR class=title>
          <TH><%=SystemEnv.getHtmlLabelName(154,user.getLanguage())%></TH></TR>
        <TR class=spacing>
          <TD class=line1></TD>
        <TR>
          <TD><A 
            href="/proj/Maint/ListProjectType.jsp"><%=SystemEnv.getHtmlLabelName(586,user.getLanguage())%></A></TD></TR>
        <TR>
          <TD><A 
            href="/proj/Maint/ListWorkType.jsp"><%=SystemEnv.getHtmlLabelName(432,user.getLanguage())%></A></TD></TR>

        <TR>
          <TD><A 
            href="/base/ffield/ListProjectFreeField.jsp"><%=SystemEnv.getHtmlLabelName(570,user.getLanguage())%>：<%=SystemEnv.getHtmlLabelName(101,user.getLanguage())%></A></TD></TR>
        <TR>
		</TBODY>
	  </TABLE>
	</TD>
	<TD></TD>
	<td>


	  </td>
  </TR>
  </TBODY>
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
