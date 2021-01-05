<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(58,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(60,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<DIV class=HdrProps>
<%if(!software.equals("ALL")){%>
<%
String mainttype = Util.null2String(request.getParameter("mainttype"));
%>
<TABLE class="Form">
	<TR>
		<TD align=right>
	<SELECT name=mainttype onchange="changetype()">
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
</TABLE>
<%}%>
</DIV>
<TABLE class=Form>
  <COLGROUP>
  <COL width="48%">
  <COL width=24>
  <COL width="48%">
  <TBODY>
  <TR>
    <TD vAlign=top>
      <TABLE class=Form width="100%">
        <TBODY> 
        <TR class=Section> 
          <TH><%=SystemEnv.getHtmlLabelName(61,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(68,user.getLanguage())%></TH>
        </TR>
        <TR class=Separator> 
          <TD class=Sep1>&nbsp;</TD>
        </TR>
        <tr class=Separator> 
          <td><a 
            href="/docs/category/DocMainCategory.jsp"><%=SystemEnv.getHtmlLabelName(65,user.getLanguage())%>/<%=SystemEnv.getHtmlLabelName(66,user.getLanguage())%>/<%=SystemEnv.getHtmlLabelName(67,user.getLanguage())%></a></td>
        </tr>

        </TBODY> 
      </TABLE>
      <BR><BR>
      <TABLE class=Form width="100%">
        <TBODY> 
        <TR class=Section> 
          <TH><%=SystemEnv.getHtmlLabelName(64,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(68,user.getLanguage())%></TH>
        </TR>
        <TR class=Separator> 
          <TD class=Sep1>&nbsp;</TD>
        </TR>
        <TR> 
          <TD><A 
          href="/docs/news/DocNews.jsp"><%=SystemEnv.getHtmlLabelName(70,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(68,user.getLanguage())%></A></TD>
        </TR>
        <TR> 
          <TD><A 
            href="/docs/mouldfile/DocMould.jsp"><%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(64,user.getLanguage())%></A></TD>
        </TR>
		<TR> 
          <TD><A 
            href="/docs/mould/DocMould.jsp"><%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(89,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(64,user.getLanguage())%></A></TD>
        </TR>
        <TR> 
          <TD><A 
            href="/docs/mail/DocMould.jsp"><%=SystemEnv.getHtmlLabelName(71,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(64,user.getLanguage())%></A></TD>
        </TR>
        <TR> 
          <TD>&nbsp;</TD>
        </TR>
        </TBODY> 
      </TABLE>
    </TD>
    <TD></TD>
    <TD vAlign=top>
      <TABLE class=Form width="100%">
        <TBODY> 
        <TR class=Section> 
          <TH><%=SystemEnv.getHtmlLabelName(72,user.getLanguage())%></TH>
        </TR>
        <TR class=Separator> 
          <TD class=Sep2>&nbsp;</TD>
        </TR>
        <TR> 
          <TD><A 
        href="/docs/tools/DocSysDefaults.jsp"><%=SystemEnv.getHtmlLabelName(68,user.getLanguage())%></A></TD>
        </TR>
        <tr> 
          <td><a 
            href="/docs/tools/DocUserDefault.jsp"><%=SystemEnv.getHtmlLabelName(73,user.getLanguage())%></a></td>
        </tr>
        <TR> 
          <TD><A         href="/docs/tools/DocPicUpload.jsp"><%=SystemEnv.getHtmlLabelName(74,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(75,user.getLanguage())%></A></TD>
        </TR>
       <!-- TR>
          <TD><A 
        href="http://server-weaver/test/docs/BDWebsites.asp"><%=SystemEnv.getHtmlLabelName(76,user.getLanguage())%></A></TD>
        </TR -->
        <TR> 
          <TD><A 
            href="/docs/tools/DocCopyMove.jsp?Action=INPUT"><%=SystemEnv.getHtmlLabelName(1983,user.getLanguage())%><%// =SystemEnv.getHtmlLabelName(772,user.getLanguage())%></A></TD>
        </TR>
          <TR> 
          <TD><A 
            href="/weaverplugin/pluginMaintenance.jsp"><%=SystemEnv.getHtmlLabelName(16170,user.getLanguage())%></A></TD>
        </TR>
       
        </TBODY> 
      </TABLE>
    </TD></TR></TBODY></TABLE></BODY></HTML>
