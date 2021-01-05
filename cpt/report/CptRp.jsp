<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>
<%
String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(535,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(351,user.getLanguage());
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

<TABLE class=Form>
  <COLGROUP>
  <COL width="48%">
  <COL width=24>
  <COL width="48%"></COLGROUP>
  <TBODY>
  <TR>
    <TD vAlign=top>
      <TABLE width="100%">
        <TBODY> 
        <TR class=Section> 
          <TH><%=SystemEnv.getHtmlLabelName(352,user.getLanguage())%></TH>
        </TR>
        <TR class=Separator> 
          <TD class=sep1></TD>
        </TR>
	<%if(!software.equals("ALL")){%>
		<tr><td><a href="/org/OrgChartCpt.jsp"><%=SystemEnv.getHtmlLabelName(535,user.getLanguage())%>:<%=SystemEnv.getHtmlLabelName(376,user.getLanguage())%></a></td></tr> 
	<%}%>
        <TR> 
          <TD><A 
            href="CptRpCapitalGroupSum.jsp"><%=SystemEnv.getHtmlLabelName(831,user.getLanguage())%></A></TD>
        </TR>
        <!--    <TR> 
          <TD><a 
        href="CptRpCapitalTypeSum.jsp">类型</a></TD>
        </TR>
 -->
        <tr> 
          <td><a 
            href="CptRpCapitalResourceSum.jsp"><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></a></td>
        </tr>
        <tr> 
          <td><a 
            href="CptRpCapitalDepartmentSum.jsp"><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></a></td>
        </tr>
        <TR> 
          <TD><A 
            href="CptRpCapitalStateSum.jsp"><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></A></TD>
        </TR>
        <tr>
          <td>&nbsp;</td>
        </tr>
<!--
        <TR class=Section> 
          <TH>资产需求统计表</TH>
        </TR>
        <TR class=Separator> 
          <TD class=sep1></TD>
        </TR>
        <tr> 
          <td><a href="/cpt/report/CptRpCptCompare.jsp">计划实际比较表</a></td>
        </tr>
        <tr> 
          <td><a href="/cpt/report/CptRpCptDepart.jsp">部门需求统计表</a></td>
        </tr>
        <tr>
          <td>&nbsp;</td>
        </tr>
-->
        </TBODY> 
      </TABLE>
    </TD>
    <TD></TD>
    <TD vAlign=top>
      <TABLE width="100%">
        <TBODY> 
        <TR class=Section> 
          <TH><%=SystemEnv.getHtmlLabelName(535,user.getLanguage())%></TH>
        </TR>
        <TR class=Separator> 
          <TD class=sep1></TD>
        </TR>
        <tr> 
          <td><a href="/cpt/report/CptRpCapital.jsp"><%=SystemEnv.getHtmlLabelName(1439,user.getLanguage())%></a></td>
        </tr>
        <tr> 
          <td><a href="/cpt/report/CptRpCapitalFlow.jsp"><%=SystemEnv.getHtmlLabelName(1501,user.getLanguage())%></a></td>
        </tr>
<!--
        <tr> 
          <td><a href="/cpt/report/CptRpCapitalCheckStock.jsp"><%=SystemEnv.getHtmlLabelName(1506,user.getLanguage())%></a></td>
        </tr> 
         <tr> 
          <td><a href="/cpt/report/CptRpCapitalApportion.jsp"><%=SystemEnv.getHtmlLabelName(1511,user.getLanguage())%></a></td>
        </tr> 
        <tr> 
          <td><a href="/cpt/report/CptRpOfficeSupply.jsp"><%=SystemEnv.getHtmlLabelName(1513,user.getLanguage())%></a></td>
        </tr> 
        <tr><td>&nbsp;</td></tr>
        <TR class=Section> 
          <TH>车辆管理</TH>
        </TR>
        <TR class=Separator> 
          <TD class=sep1></TD>
        </TR>
        <tr> 
          <td><a href="/cpt/report/CptRpCptCar.jsp">车辆统计表</a></td>
        </tr>
-->
        <tr><td>&nbsp;</td></tr>
       </TBODY> 
      </TABLE>
      
<!-- 动态读取固定报表 !-->
<TABLE class=Form width="100%" border=0>
<%
    int ishead=0;
    RecordSet.executeProc("Workflow_StaticReport_SByModu","4");
    while(RecordSet.next()){
        if(ishead==0){
%>
    <TR class=Section> 
          <TH><%=SystemEnv.getHtmlLabelName(1883,user.getLanguage())%>
            <!--Reports-->
          </TH>
    </TR>
  <TR class=separator> 
    <TD class=Sep1></TD>
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
    </TD></TR>
  
</TBODY></TABLE></BODY></HTML>
