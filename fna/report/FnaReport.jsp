<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>
<%
String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(189,user.getLanguage())+" : "+SystemEnv.getHtmlLabelName(351,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<DIV class=HdrProps>
<%if(!software.equals("ALL")){%>
<%
String reporttype = Util.null2String(request.getParameter("reporttype"));
%>
<TABLE class="Form">
	<TR>
		<TD align=right>
	<SELECT name=reporttype onchange="changetype()">
		<OPTION value=W <%if(reporttype.equals("W")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(259,user.getLanguage())%></OPTION>
		<OPTION value=D <%if(reporttype.equals("D")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%></OPTION>
		<OPTION value=H <%if(reporttype.equals("H")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></OPTION>
<%if(software.equals("ALL") || software.equals("CRM")){%>
		<OPTION value=C <%if(reporttype.equals("C")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(147,user.getLanguage())%></OPTION>
		<OPTION value=R <%if(reporttype.equals("R")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(101,user.getLanguage())%></OPTION>
<%}%>
<%if(software.equals("ALL") || software.equals("HRM")){%>
		<OPTION value=I <%if(reporttype.equals("I")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(535,user.getLanguage())%></OPTION>
<%}%>
<%if(software.equals("ALL") || software.equals("HRM") || software.equals("CRM")){%>
		<OPTION value=F <%if(reporttype.equals("F")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(189,user.getLanguage())%></OPTION>
<%}%>
	</SELECT>
	<script language=javascript>
		function changetype(){
		if(document.all("reporttype").value=="W") location = "/workflow/WFReport.jsp?reporttype=W";
		if(document.all("reporttype").value=="D") location = "/docs/report/DocRp.jsp?reporttype=D";
		if(document.all("reporttype").value=="H") location = "/hrm/report/HrmRp.jsp?reporttype=H";
		if(document.all("reporttype").value=="C") location = "/CRM/CRMReport.jsp?reporttype=C";
		if(document.all("reporttype").value=="R") location = "/proj/ProjReport.jsp?reporttype=R";
		if(document.all("reporttype").value=="F") location = "/fna/report/FnaReport.jsp?reporttype=F";
		if(document.all("reporttype").value=="I") location = "/cpt/report/CptRp.jsp?reporttype=I";
	}
	</script>
		</TD>
	</TR>
</TABLE>
<%}%>
</DIV>

<TABLE class=ViewForm>
  <COLGROUP>
  <COL width="48%">
  <COL width="4%">
  <COL width="48%">
  <TBODY>
  <TR vAlign=top>
    <TD>
    <TABLE class=ViewForm>
        <COLGROUP> <COL width="100%"> <TBODY> 
        <TR class=Title> 
          <TH><%=SystemEnv.getHtmlLabelName(386,user.getLanguage())%></TH>
        </TR>
        <TR class=Spacing> 
          <TD class=Line1></TD>
        </TR>
        <TR> 
          <TD><A href="/fna/report/budget/FnaBudgetDepartment.jsp"><%=SystemEnv.getHtmlLabelName(15401,user.getLanguage())%></A> / <A href="/fna/report/budget/FnaBudgetResource.jsp"><%=SystemEnv.getHtmlLabelName(15402,user.getLanguage())%></A></TD>
        </TR>
      </table>
    </TD>
    <TD></TD>
    <TD>
      <TABLE class=ViewForm>
        <COLGROUP> <COL width="100%"> <TBODY> 
        <TR class=Title> 
          <TH><%=SystemEnv.getHtmlLabelName(428,user.getLanguage())%></TH>
        </TR>
        <TR class=Spacing> 
          <TD class=Line1></TD>
        </TR>
        <TR> 
          <TD><A href="/fna/report/expense/FnaExpenseDepartment.jsp"><%=SystemEnv.getHtmlLabelName(15403,user.getLanguage())%></A> / 
          <A href="/fna/report/expense/FnaExpenseResource.jsp"><%=SystemEnv.getHtmlLabelName(15404,user.getLanguage())%></A> / 
          <A href="/fna/report/expense/FnaExpenseCrm.jsp"><%=SystemEnv.getHtmlLabelName(15405,user.getLanguage())%></A> / 
          <A href="/fna/report/expense/FnaExpenseProject.jsp"><%=SystemEnv.getHtmlLabelName(15406,user.getLanguage())%></A> 
          </TD>
        </TR>
      </table>
      <br>
<!-- 动态读取固定报表 !-->
<TABLE class=ViewForm width="100%" border=0>
<%
    int ishead=0;
    RecordSet.executeProc("Workflow_StaticReport_SByModu","7");
    while(RecordSet.next()){
        if(ishead==0){
%>
    <TR class=Title> 
          <TH><%=SystemEnv.getHtmlLabelName(1883,user.getLanguage())%>
            <!--Reports-->
          </TH>
    </TR>
  <TR class=Spacing> 
    <TD class=Line1></TD>
  </TR>
<%      ishead=1;  
        }
        String tmppagename=RecordSet.getString("pagename");
        String reportid=RecordSet.getString("reportid");
        String name=RecordSet.getString("name");
%>
    <TR> 
          <TD><A 
            href="/workflow/report/<%=tmppagename%>?reportid=<%=reportid%>"><%=Util.toScreen(name,user.getLanguage())%></A></TD>
    </TR>
<%
    }
%>
</table>
<!-- end !-->
    </TD></TR></TBODY></TABLE></BODY></HTML>
