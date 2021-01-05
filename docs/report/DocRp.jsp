<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="UserDefaultManager" class="weaver.docs.tools.UserDefaultManager" scope="page" />
<jsp:useBean id="MainCategoryComInfo" class="weaver.docs.category.MainCategoryComInfo" scope="page" />
<jsp:useBean id="SecCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="DocTypeComInfo" class="weaver.docs.type.DocTypeComInfo" scope="page" />
<jsp:useBean id="DocSearchManage" class="weaver.docs.search.DocSearchManage" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>
<%
String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(58,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(351,user.getLanguage());
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
	<SELECT  class=InputStyle name=reporttype onchange="changetype()">
		<OPTION value=W <%if(reporttype.equals("W")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(259,user.getLanguage())%></OPTION>
		<OPTION value=D <%if(reporttype.equals("D")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%></OPTION>
		<OPTION value=H <%if(reporttype.equals("H")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></OPTION>
<%if(software.equals("ALL") || software.equals("CRM")){%>
		<OPTION value=C <%if(reporttype.equals("C")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(147,user.getLanguage())%></OPTION>
		<OPTION value=R <%if(reporttype.equals("R")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(101,user.getLanguage())%></OPTION>
<%}%>
<%if(software.equals("ALL")){%>
		<OPTION value=I <%if(reporttype.equals("I")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(535,user.getLanguage())%></OPTION>
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

<TABLE class=ViewForm width="40%" border=0>
  <COLGROUP> <COL width="48%"> <COL width=24> <COL width="48%">
  <tr><td valign="top"> 
<TABLE class=ViewForm width="100%" border=0>
        <TR class=Title> 
          <TH><%=SystemEnv.getHtmlLabelName(351,user.getLanguage())%>
            <!--Reports-->
          </TH>
    </TR>
  <TR class=Spacing> 
    <TD class=Line1></TD>
  </TR>
  <%if(!software.equals("ALL")){%>
    <tr><td><a href="/org/OrgChartDoc.jsp"><%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%>:<%=SystemEnv.getHtmlLabelName(376,user.getLanguage())%></a></td></tr>  
<%}%>
  <TR> 
          <TD><A 
            href="DocRpCreater.jsp"><%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%>:<%=SystemEnv.getHtmlLabelName(79,user.getLanguage())%></A></TD>
  </TR>
  <TR> 
          <TD><A 
            href="DocRpRelative.jsp"><%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%>: 
            <%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></A></TD>
  </TR>
  <!-- TR><td><A HREF="BDView.asp?GroupID=-1&Layout=3&View=Documents&RestrictionField1=Company&RestrictionValue1=001&RestrictionTitle=地区: 001 Tech Dept">地区: 001 &nbsp;Tech Dept</A></td></TR -->
  <!--TR> 
          <TD><a 
            href="DocRpStatus.jsp"><%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%>: 
            <%=SystemEnv.getHtmlLabelName(169,user.getLanguage())%></a></TD>
  </TR -->

  <%if(HrmUserVarify.checkUserRight("LogView:View", user)){%>
  <TR> 
          <TD><A 
            href="/report/RpReadView.jsp?object=1"><%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%>: <%=SystemEnv.getHtmlLabelName(260,user.getLanguage())%></A></TD>
  </TR>
<%}%>
</TABLE>
<!-- 动态读取固定报表 !-->
<TABLE class=ViewForm width="100%" border=0>
<%
    int ishead=0;
    RecordSet.executeProc("Workflow_StaticReport_SByModu","1");
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

</td>
    <TD></TD>
    <TD vAlign=top>
      <TABLE class=ViewForm width="100%">
        <TBODY>
        <TR class=Title>
          <TH><%=SystemEnv.getHtmlLabelName(352,user.getLanguage())%></TH></TR>
        <TR class=Spacing>
          <TD class=Line1></TD></TR>
        <TR>
          <TD><a href="DocRpMainCategorySum.jsp"><%=SystemEnv.getHtmlLabelName(65,user.getLanguage())%></a></TD>
        </TR>
        <TR>
          <TD><A 
            href="DocRpDocSum.jsp"><%=SystemEnv.getHtmlLabelName(151,user.getLanguage())%> 
            50: <%=SystemEnv.getHtmlLabelName(16243,user.getLanguage())%></A></TD>
        </TR>
        <TR>
          <TD><a 
            href="DocRpCreaterSum.jsp"><%=SystemEnv.getHtmlLabelName(151,user.getLanguage())%> 
            20: <%=SystemEnv.getHtmlLabelName(79,user.getLanguage())%></a></TD>
        </TR>
        <TR>
          <TD><a 
            href="DocRpLanguageSum.jsp"><%=SystemEnv.getHtmlLabelName(151,user.getLanguage())%>
            20: <%=SystemEnv.getHtmlLabelName(231,user.getLanguage())%></a></TD>
        </TR>
        <TR>
          
          <TD height="21"><a 
            href="DocRpCrmSum.jsp"><%=SystemEnv.getHtmlLabelName(151,user.getLanguage())%> 
            20: <%=SystemEnv.getHtmlLabelName(147,user.getLanguage())%></a></TD>
    </TR>
        <TR>
          <TD><a 
            href="DocRpResourceSum.jsp"><%=SystemEnv.getHtmlLabelName(151,user.getLanguage())%>
            20: <%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></a></TD>
        </TR>
        <TR>
          <TD><a 
            href="DocRpProjectSum.jsp"><%=SystemEnv.getHtmlLabelName(151,user.getLanguage())%>
            20: <%=SystemEnv.getHtmlLabelName(101,user.getLanguage())%></a></TD>
        </TR>
        <TR>
          
          <TD><a 
            href="DocRpDepartmentSum.jsp"><%=SystemEnv.getHtmlLabelName(151,user.getLanguage())%>
            20: <%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></a></TD>
    </TR>
      <TR>
          
          <TD><a 
            href="DocRpAllDocSum.jsp"><%=SystemEnv.getHtmlLabelName(16244,user.getLanguage())%></a></TD>
    </TR>

        <!-- TR>
          
          <TD><a 
            href="DocRpItemSum.jsp"><%=SystemEnv.getHtmlLabelName(151,user.getLanguage())%>
            20: <%=SystemEnv.getHtmlLabelName(145,user.getLanguage())%></a></TD>
    </TR>
        <TR>
          <TD><a 
            href="DocRpStatusSum.jsp"><%=SystemEnv.getHtmlLabelName(169,user.getLanguage())%></a></TD>
        </TR --></TBODY></TABLE></TD></tr></table>
</BODY></HTML>
