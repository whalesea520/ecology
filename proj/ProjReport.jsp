
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</HEAD>
<%
String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(101,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(351,user.getLanguage());
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
String reporttype = Util.null2String(request.getParameter("reporttype"));
%>
<TABLE class="Form">
	<TR>
		<TD align=right>
	<select class=inputstyle  name=reporttype onchange="changetype()">
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
	</TR><TR><TD class=Line></TD></TR> 
</TABLE>
<%}%>



<table class=viewform>
  <COLGROUP>
  <COL width="49%">
  <COL width="2%">
  <COL width="49%">
  <TBODY>
  <tr>
	<TD vAlign=top>
		<TABLE class=viewform>
	        <COLGROUP>
			<COL width="30%">
	  		<COL width="70%">
	        <TBODY>
		        <TR class=title>
		            <TH colSpan=2><%=SystemEnv.getHtmlLabelName(352,user.getLanguage())%></TH>
		          </TR>
		        <TR class=spacing>
		          <TD class=line1 colSpan=2></TD></TR>
			<%if(!software.equals("ALL")){%>
				<tr><td><a href="/org/OrgChartProj.jsp"><%=SystemEnv.getHtmlLabelName(101,user.getLanguage())%>:<%=SystemEnv.getHtmlLabelName(376,user.getLanguage())%></a></td></tr> 
			<%}%>
		        <TR>
			   <tr><td><a href="/proj/report/ProjectTypeRpSum.jsp"><%=SystemEnv.getHtmlLabelName(586,user.getLanguage())%></a></td></tr>  
			   <tr><td><a href="/proj/report/WorkTypeRpSum.jsp"><%=SystemEnv.getHtmlLabelName(432,user.getLanguage())%></a></td></tr>  
			   <tr><td><a href="/proj/report/ProjectStatusRpSum.jsp"><%=SystemEnv.getHtmlLabelName(587,user.getLanguage())%></a></td></tr>
			</TR>
		</TBODY>
		</TABLE>
<%if(user.getLogintype().equals("1")){%>		
		<TABLE class=viewform>
	        <COLGROUP>
			<COL width="30%">
	  		<COL width="70%">
	        <TBODY>
		        <TR class=title>
		            <TH colSpan=2><%=SystemEnv.getHtmlLabelName(1217,user.getLanguage())%></TH>
		          </TR>
		        <TR class=spacing>
		          <TD class=line1 colSpan=2></TD></TR>
		        <TR>
			   <tr><td><a href="/proj/report/ManagerRpSum.jsp"><%=SystemEnv.getHtmlLabelName(144,user.getLanguage())%></a></td></tr>  
			   <tr><td><a href="/proj/report/DepartmentRpSum.jsp"><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></a></td></tr>  
			</TR>
		</TBODY>
		</TABLE>
<%}%>
	</TD>
	<TD></TD>
	<TD vAlign=top>
    <%if(HrmUserVarify.checkUserRight("LogView:View", user)){%>
		<TABLE class=viewform>
	        <COLGROUP>
			<COL width="30%">
	  		<COL width="70%">
	        <TBODY>
		        <TR class=title>
		            <TH colSpan=2><%=SystemEnv.getHtmlLabelName(83,user.getLanguage())%></TH>
		          </TR>
		        <TR class=spacing>
		          <TD class=line1 colSpan=2></TD></TR>
		        <TR>
				  <TD><A href="/proj/report/ProjectModifyLogRp.jsp"><%=SystemEnv.getHtmlLabelName(1224,user.getLanguage())%></A></TD></TR>
		        <TR>
			      <td><a href="/proj/report/ProjectViewLogRp.jsp"><%=SystemEnv.getHtmlLabelName(1225,user.getLanguage())%></a></td>
			    </TR>
		</TBODY>
		</TABLE>
   <%}%>
		<br>
<!-- 动态读取固定报表 !-->
<TABLE class=viewform width="100%" border=0>
<%
    int ishead=0;
    RecordSet.executeProc("Workflow_StaticReport_SByModu","6");
    while(RecordSet.next()){
        if(ishead==0){
%>
    <TR class=title> 
          <TH><%=SystemEnv.getHtmlLabelName(1883,user.getLanguage())%>
            <!--Reports-->
          </TH>
    </TR>
  <TR class=spacing> 
    <TD class=line1></TD>
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
	</TD>
  </tr>
  </TBODY>
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

</BODY>
</HTML>