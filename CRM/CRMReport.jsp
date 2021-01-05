<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</HEAD>
<%
String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(147,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(351,user.getLanguage());
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
	<SELECT class=InputStyle  name=reporttype onchange="changetype()">
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

<table class=form>
  <COLGROUP>
  <COL width="49%">
  <COL width="2%">
  <COL width="49%">
  <TBODY>
  
	<TD vAlign=top>
		<TABLE class=Form>
	        <COLGROUP>
			<COL width="30%">
	  		<COL width="70%">
	        <TBODY>
		        <TR class=Section>
		            <TH colSpan=2><%=SystemEnv.getHtmlLabelName(1216,user.getLanguage())%></TH>
		          </TR>
		        <TR class=separator>
		          <TD class=Sep1 colSpan=2></TD></TR>
		        <TR>
			<%if(!software.equals("ALL")){%>
				<tr><td><a href="/org/OrgChartCRM.jsp">CRM:<%=SystemEnv.getHtmlLabelName(376,user.getLanguage())%></a></td></tr> 
			<%}%>
				<TR><TD><A href="/CRM/report/CustomerTypeRpSum.jsp"><%=SystemEnv.getHtmlLabelName(178,user.getLanguage())%></A></TD></TR>
				<TR><TD><A href="/CRM/report/CustomerStatusRpSum.jsp"><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></A></TD></TR>
				<TR><TD><A href="/CRM/report/PaymentTermRpSum.jsp"><%=SystemEnv.getHtmlLabelName(577,user.getLanguage())%></A></TD></TR>
<!--
				<TR><TD><A href="/CRM/report/CustomerRatingRpSum.jsp">级别</A></TD></TR>
-->

				<TR><TD><A href="/CRM/report/CustomerDescRpSum.jsp"><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></A></TD></TR>
<%if(!user.getLogintype().equals("2")){%>	
				<TR><TD><A href="/CRM/report/ManagerRpSum.jsp"><%=SystemEnv.getHtmlLabelName(144,user.getLanguage())%></A></TD></TR>
				<TR><TD><A href="/CRM/report/DepartmentRpSum.jsp"><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></A></TD></TR>
<%}%>
				<TR><TD><A href="/CRM/report/ContactWayRpSum.jsp"><%=SystemEnv.getHtmlLabelName(1219,user.getLanguage())%></A></TD></TR>
				<TR><TD><A href="/CRM/report/SectorInfoRpSum.jsp"><%=SystemEnv.getHtmlLabelName(575,user.getLanguage())%></A></TD></TR>
				<TR><TD><A href="/CRM/report/CustomerSizeRpSum.jsp"><%=SystemEnv.getHtmlLabelName(576,user.getLanguage())%></A></TD></TR>
                <TR><TD><A href="/CRM/report/AddressRpSum.jsp"><%=SystemEnv.getHtmlLabelName(1220,user.getLanguage())%></A></TD></TR>
		</TBODY>
		</TABLE>
		<br>	
<%if(!user.getLogintype().equals("2")){%>	
		<TABLE class=Form>
	        <COLGROUP>
			<COL width="30%">
	  		<COL width="70%">
	        <TBODY>
		        <TR class=Section>
		            <TH colSpan=2><%=SystemEnv.getHtmlLabelName(1217,user.getLanguage())%></TH>
		          </TR>
		        <TR class=separator>
		          <TD class=Sep1 colSpan=2></TD></TR>

          
 		        <TR>
				  <TD><A href="/CRM/sellchance/SellChanceRpSum.jsp"><%=SystemEnv.getHtmlLabelName(2227,user.getLanguage())%>:<%=SystemEnv.getHtmlLabelName(15112,user.getLanguage())%></A></TD></TR>  
                 <TR>
				  <TD><A href="/CRM/sellchance/SellStatusRpSum.jsp"><%=SystemEnv.getHtmlLabelName(2227,user.getLanguage())%>:<%=SystemEnv.getHtmlLabelName(2250,user.getLanguage())%></A></TD></TR>
 		        <TR>
				  <TD><A href="/CRM/sellchance/SuccessRpSum.jsp"><%=SystemEnv.getHtmlLabelName(2227,user.getLanguage())%>:<%=SystemEnv.getHtmlLabelName(15103,user.getLanguage())%></A></TD></TR> 
 		        <TR>
				  <TD><A href="/CRM/sellchance/FailureRpSum.jsp"><%=SystemEnv.getHtmlLabelName(2227,user.getLanguage())%>:<%=SystemEnv.getHtmlLabelName(15104,user.getLanguage())%></A></TD></TR>
                 <TR>
				  <TD><A href="/CRM/sellchance/SellTimeRpSum.jsp"><%=SystemEnv.getHtmlLabelName(2227,user.getLanguage())%>:<%=SystemEnv.getHtmlLabelName(15113,user.getLanguage())%></A></TD></TR>
                 <TR>
				  <TD><A href="/CRM/sellchance/SellAreaProRpSum.jsp"><%=SystemEnv.getHtmlLabelName(6146,user.getLanguage())%>:<%=SystemEnv.getHtmlLabelName(15114,user.getLanguage())%></A></TD></TR>
                 <TR>
				  <TD><A href="/CRM/sellchance/SellProductRpSum.jsp"><%=SystemEnv.getHtmlLabelName(6146,user.getLanguage())%>:<%=SystemEnv.getHtmlLabelName(15115,user.getLanguage())%></A></TD></TR>
                 <TR>
				  <TD><A href="/CRM/sellchance/SellManagerRpSum.jsp"><%=SystemEnv.getHtmlLabelName(6146,user.getLanguage())%>:<%=SystemEnv.getHtmlLabelName(15116,user.getLanguage())%></A></TD></TR>
                 <TR>
				  <TD><A href="/CRM/sellchance/SellClientRpSum.jsp"><%=SystemEnv.getHtmlLabelName(6146,user.getLanguage())%>:<%=SystemEnv.getHtmlLabelName(136,user.getLanguage())%></A></TD></TR>
		        <TR>
				<TR><TD><A href="/CRM/report/CreditInfoRpSum.jsp"><%=SystemEnv.getHtmlLabelName(580,user.getLanguage())%></A></TD></TR>
				<TR><TD><A href="/CRM/report/TradeInfoRpSum.jsp"><%=SystemEnv.getHtmlLabelName(581,user.getLanguage())%></A></TD></TR>
		</TBODY>
		</TABLE>
		<br>
<%}%>

	</TD>
	<TD></TD>
	<TD vAlign=top>


		<TABLE class=Form>
	        <COLGROUP>
			<COL width="30%">
	  		<COL width="70%">
	        <TBODY>
		        <TR class=Section>
		            <TH colSpan=2><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%></TH>
		          </TR>
		        <TR class=separator>
		          <TD class=Sep1 colSpan=2></TD></TR>
		        <TR>
				  <TD><A href="/CRM/report/CRMContactLogRp.jsp"><%=SystemEnv.getHtmlLabelName(1221,user.getLanguage())%></A></TD></TR>
			<%if(!user.getLogintype().equals("2")){%>	
		        <TR>
				  <TD><A href="/CRM/report/CRMShareLogRp.jsp"><%=SystemEnv.getHtmlLabelName(1222,user.getLanguage())%></A></TD></TR>
			<%}%>
				<TR>
				  <TD><A href="/lgc/search/LgcSearchProduct.jsp"><%=SystemEnv.getHtmlLabelName(15108,user.getLanguage())%></A></TD></TR>  
				<TR>
				  <TD><A href="/CRM/report/ContractReport.jsp"><%=SystemEnv.getHtmlLabelName(614,user.getLanguage())%></A></TD></TR> 
				<TR>
				  <TD><A href="/CRM/report/ContractFnaReport.jsp"><%=SystemEnv.getHtmlLabelName(15117,user.getLanguage())%></A></TD></TR> 
				 <TR>
				  <TD><A href="/CRM/report/ContractProReport.jsp"><%=SystemEnv.getHtmlLabelName(15118,user.getLanguage())%></A></TD></TR>  
                 <TR>
				  <TD><A href="/CRM/report/CRMEvaluationRp.jsp"><%=SystemEnv.getHtmlLabelName(6073,user.getLanguage())%></A></TD></TR>
 		        <TR>
				  <TD><A href="/CRM/sellchance/SellChanceReport.jsp"><%=SystemEnv.getHtmlLabelName(2227,user.getLanguage())%></A></TD></TR>   
		</TBODY>
		</TABLE>






		<br>
        <%if(HrmUserVarify.checkUserRight("LogView:View", user)){%>
		<TABLE class=Form>
	        <COLGROUP>
			<COL width="30%">
	  		<COL width="70%">
	        <TBODY>
		        <TR class=Section>
		            <TH colSpan=2><%=SystemEnv.getHtmlLabelName(83,user.getLanguage())%></TH>
		          </TR>
		        <TR class=separator>
		          <TD class=Sep1 colSpan=2></TD></TR>
		        <TR>
				  <TD><A href="/CRM/report/CRMLoginLogRp.jsp"><%=SystemEnv.getHtmlLabelName(1223,user.getLanguage())%></A></TD></TR>
		        <TR>
				  <TD><A href="/CRM/report/CRMModifyLogRp.jsp"><%=SystemEnv.getHtmlLabelName(1224,user.getLanguage())%></A></TD></TR>
		        <TR>
				  <TD><A href="/CRM/report/CRMViewLogRp.jsp"><%=SystemEnv.getHtmlLabelName(1225,user.getLanguage())%></A></TD></TR>
		</TBODY>
		</TABLE>
        <%}%>
		<br>
        
<!-- 动态读取固定报表 !-->
<!--
<TABLE class=Form width="100%" border=0>
<%
    int ishead=0;
    RecordSet.executeProc("Workflow_StaticReport_SByModu","3");
    while(RecordSet.next()){
        if(ishead==0){
%>
    <TR class=Section> 
          <TH><%=SystemEnv.getHtmlLabelName(1883,user.getLanguage())%>
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
</table>
<%}%>
-->
<!-- end !-->
	</TD>
  </TBODY>
</table>
</BODY>
</HTML>