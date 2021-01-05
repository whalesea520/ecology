<%@ page import="java.util.*" %>


<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="ReportTypeComInfo" class="weaver.workflow.report.ReportTypeComInfo" scope="page" />
<jsp:useBean id="ReportComInfo" class="weaver.workflow.report.ReportComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</HEAD>
<%
ArrayList hasrightreports = new ArrayList() ;
ArrayList hasrightreportsbytypes = new ArrayList() ;

RecordSet.executeSql("select reportid from WorkflowReportShareDetail where userid="+user.getUID()+" and usertype=1 ");
while(RecordSet.next()) {
    String tempreportid = Util.null2String(RecordSet.getString(1)) ;
    hasrightreports.add(tempreportid) ;
}

String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(259,user.getLanguage())+SystemEnv.getHtmlLabelName(351,user.getLanguage());
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
<TABLE class="viewform">
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
	</TR>
</TABLE>
<%}%>



<TABLE class="viewform" width="100%">
  <COLGROUP>
  <COL width="48%">
  <COL width=24>
  <COL width="48%">
  <TBODY>
  <TR vAlign=top>
    <TD>
     <TABLE class="viewform">
        <COLGROUP>
        <COL width="100%">
        <TBODY>
        <TR class="Title">
          <TH><%=SystemEnv.getHtmlLabelName(648,user.getLanguage())%> － <%=SystemEnv.getHtmlLabelName(352,user.getLanguage())%></TH></TR>
        <TR class="Spacing">
          <TD class="Line1"></TD>
        <TR>
          <TD><A HREF="/workflow/report/PendingRequestRp.jsp"><%=SystemEnv.getHtmlLabelName(732,user.getLanguage())%></A></TD></TR>
        <!--TR>
          <TD><A HREF="/workflow/report/RequestQualityRp.jsp">质量分析</A></TD></TR-->
</TBODY></TABLE></TD>
    <TD></TD>
    <TD>
      <TABLE class="viewform">
        <COLGROUP>
        <COL width="100%">
        <TBODY>
        <TR class="Title">
          <TH><%=SystemEnv.getHtmlLabelName(648,user.getLanguage())%> － <%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%></TR>
        <TR class="Spacing">
          <TD class=line1></TD>
        <TR>
          <TD><A HREF="/workflow/search/WFSearch.jsp"><%=SystemEnv.getHtmlLabelName(154,user.getLanguage())%></A></TD></TR>
        <%if(HrmUserVarify.checkUserRight("LogView:View", user)){%>
        <TR>
          <TD><A HREF="/workflow/report/ViewLogRp.jsp"><%=SystemEnv.getHtmlLabelName(730,user.getLanguage())%> － <%=SystemEnv.getHtmlLabelName(679,user.getLanguage())%></A></TD></TR>
        
		<TR>
          <TD><A HREF="/workflow/report/OperateLogRp.jsp"><%=SystemEnv.getHtmlLabelName(104,user.getLanguage())%> － <%=SystemEnv.getHtmlLabelName(679,user.getLanguage())%></A></TD></TR>
       <%}%>
</TBODY></TABLE></TD></TR>
  <TR vAlign=top>
    <TD>
     <TABLE class="viewform">
        <COLGROUP>
        <COL width="100%">
        <TBODY>
        <TR class="Title">
          <TH><%=SystemEnv.getHtmlLabelName(259,user.getLanguage())%> － <%=SystemEnv.getHtmlLabelName(352,user.getLanguage())%></TH></TR>
        <TR class="Spacing">
          <TD class="Line1"></TD>
        <TR>
          <TD><A HREF="/workflow/report/WorkflowTypeRp.jsp"><%=SystemEnv.getHtmlLabelName(15433,user.getLanguage())%></A></TD></TR>
</TBODY></TABLE>

	  <br>
      <%
	 int theodd  = 0 ;
	 ReportTypeComInfo.setTofirstRow() ;
	 while(ReportTypeComInfo.next()) {
	 	if(theodd % 2 == 0) {
			theodd ++ ;
			continue ;
		}
        hasrightreportsbytypes.clear() ;
        ReportComInfo.setTofirstRow() ;
		while(ReportComInfo.next(ReportTypeComInfo.getReportTypeid())) {
            String tempreportid = ReportComInfo.getReportid() ;
            if(hasrightreports.indexOf(tempreportid) < 0) continue ;
            hasrightreportsbytypes.add(tempreportid) ;
        }
        if(hasrightreportsbytypes.size() == 0)  {
            theodd ++ ;
			continue ;
		}
        
		theodd ++ ;
		%>
      <table class="viewform">
        <colgroup> <col width="100%"> <tbody> 
        <tr class="Title"> 
          <th><%=Util.toScreen(ReportTypeComInfo.getReportTypename(),user.getLanguage())%>
        </tr>
        <tr class="Spacing"> 
          <td class=Sep3></td>
		 <%
		 for(int i = 0 ; i< hasrightreportsbytypes.size() ; i++) {
		%>  
        <tr> 
          <td><a href="/workflow/report/ReportCondition.jsp?id=<%=hasrightreportsbytypes.get(i)%>"><%=Util.toScreen(ReportComInfo.getReportname((String)hasrightreportsbytypes.get(i)),user.getLanguage())%></a></td>
        </tr>
		<%}%>
        </tbody>
      </table>
	  <br>
	  <%}%>


</TD>
    <TD></TD>
    <TD>
	<%
	 theodd  = 0 ;
	 ReportTypeComInfo.setTofirstRow() ;
	 while(ReportTypeComInfo.next()) {
	 	if(theodd % 2 != 0) {
			theodd ++ ;
			continue ;
		}
        hasrightreportsbytypes.clear() ;
        ReportComInfo.setTofirstRow() ;
		while(ReportComInfo.next(ReportTypeComInfo.getReportTypeid())) {
            String tempreportid = ReportComInfo.getReportid() ;
            if(hasrightreports.indexOf(tempreportid) < 0) continue ;
            hasrightreportsbytypes.add(tempreportid) ;
        }
        if(hasrightreportsbytypes.size() == 0)  {
            theodd ++ ;
			continue ;
		}

		theodd ++ ;
		%> 
      <table class="viewform">
        <colgroup> <col width="100%"> <tbody> 
        <tr class="Title"> 
          <th><%=Util.toScreen(ReportTypeComInfo.getReportTypename(),user.getLanguage())%> 
        </tr>
        <tr class="Spacing"> 
          <td class=Sep3></td>
		 <%
		 for(int i = 0 ; i< hasrightreportsbytypes.size() ; i++) {
		%>  
        <tr> 
          <td><a href="/workflow/report/ReportCondition.jsp?id=<%=hasrightreportsbytypes.get(i)%>"><%=Util.toScreen(ReportComInfo.getReportname((String)hasrightreportsbytypes.get(i)),user.getLanguage())%></a></td>
        </tr>
		<%}%>
        </tbody>
      </table>
	  <br>
	  <%}%>
	  
	  <!-- 动态读取固定报表 !-->
<TABLE class="viewform" width="100%" border=0>
<%
    int ishead=0;
    RecordSet.executeProc("Workflow_StaticReport_SByModu","5");
    while(RecordSet.next()){
        if(ishead==0){
%>
    <TR class="Title"> 
          <TH><%=SystemEnv.getHtmlLabelName(1883,user.getLanguage())%>
            <!--Reports-->
          </TH>
    </TR>
  <TR class="Spacing"> 
    <TD class="Line1"></TD>
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
  </TR>


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
