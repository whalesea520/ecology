<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>
<%
String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(179,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(351,user.getLanguage());
String needfav ="1";
String needhelp ="";

String userid=user.getUID()+"" ;
int userseclevel=Util.getIntValue(user.getSeclevel(),0) ;
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
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

<%if(!software.equals("ALL")){%>
<%
String reporttype = Util.null2String(request.getParameter("reporttype"));
%>
<TABLE class="viewForm">
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
<TABLE class=viewForm width="40%" border=0>
  <COLGROUP> <COL width="48%"> <COL width=24> <COL width="48%">

<TR>
	<TD VALIGN=Top>
		
      <TABLE CLASS=viewForm>
        <TR CLASS=title> 
          <TH><%=SystemEnv.getHtmlLabelName(376,user.getLanguage())%></TH>
        </TR>
        <%if(!software.equals("ALL")){%>
		<tr><td><a href="/org/OrgChartHRM.jsp"><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%>:<%=SystemEnv.getHtmlLabelName(376,user.getLanguage())%></a></td></tr> 
	<%}%>
        <TR> 
          <TD><A href="/hrm/search/HrmResourceSearchTmp.jsp"><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></A></TD>
<%if(software.equals("ALL") || software.equals("HRM")){%>          
        <TR> 
          <TD><A href="/hrm/schedule/HrmDeptScheduleList.jsp"><%=SystemEnv.getHtmlLabelName(369,user.getLanguage())%>:&nbsp;<%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></A></TD>
        </TR>
        <TR> 
          <TD><A href="/hrm/schedule/HrmResouceScheduleList.jsp"><%=SystemEnv.getHtmlLabelName(369,user.getLanguage())%>:&nbsp;<%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></A></TD>
        </TR>
<%}%>        
        <tr> 
          <td><a href="/hrm/schedule/HrmPubHoliday.jsp"><%=SystemEnv.getHtmlLabelName(516,user.getLanguage())%></a></td>
        </tr>
    
      </TABLE>
	</TD>
	<TD></TD>
	<TD VALIGN=Top>
		<TABLE CLASS=viewForm>
			<TR CLASS=title><TH><%=SystemEnv.getHtmlLabelName(407,user.getLanguage())%></TH></TR>
			<TR CLASS=spacing><TD CLASS=line1></TD></TR>
			<TR><TD><A href="/hrm/resource/HrmResourcePlan.jsp?resourceid=<%=user.getUID()%>"><%=SystemEnv.getHtmlLabelName(351,user.getLanguage())%></A></TD></TR>
			<TR><TD><A href="/workflow/request/RequestView.jsp?resourceid=<%=user.getUID()%>"><%=SystemEnv.getHtmlLabelName(259,user.getLanguage())%></A></TD></TR>
			<TR><TD><A href="/workflow/report/RequestRpPlan.jsp"><%=SystemEnv.getHtmlLabelName(15876,user.getLanguage())%></A></TD></TR>
			
			<!-- TR><TD><A href="#"><%=SystemEnv.getHtmlLabelName(411,user.getLanguage())%></A></TD></TR>
			<TR><TD><A HREF="#"><%=SystemEnv.getHtmlLabelName(442,user.getLanguage())%></A></TD></TR>
			<TR><TD><A href="#"><%=SystemEnv.getHtmlLabelName(515,user.getLanguage())%></A></TD></TR>
			<TR><TD><A href="#"><%=SystemEnv.getHtmlLabelName(517,user.getLanguage())%></a></TD></TR -->
		</TABLE>
	</TD>
</TR>


<TR>
	<TD VALIGN=Top>
		
      <TABLE CLASS=viewForm>
        <TR class=Title> 
          <TH><%=SystemEnv.getHtmlLabelName(15877,user.getLanguage())%></TH>
        </TR>
        <TR CLASS=spacing> 
          <TD CLASS=line1></TD>
        </TR>        
<!--
        <%if(userseclevel>=20){%>
        <tr> 
          <td><%=SystemEnv.getHtmlLabelName(834,user.getLanguage())%>:<a href="/hrm/report/HrmRpTrainPeoNumByType.jsp"><%=SystemEnv.getHtmlLabelName(1882,user.getLanguage())%></a>/<a href="/hrm/report/HrmRpTrainPeoNumByDep.jsp"><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></a></td>
        </tr>
        <tr> 
          <td><%=SystemEnv.getHtmlLabelName(833,user.getLanguage())%>:<a href="/hrm/report/HrmRpTrainHourByType.jsp"><%=SystemEnv.getHtmlLabelName(1882,user.getLanguage())%></a>/<a href="/hrm/report/HrmRpTrainHourByDep.jsp"><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></a></td>
        </tr>
-->
        <%}%>
        <TR> 
          <TD><A href="/hrm/report/HrmRpAbsense.jsp"><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%>: <%=SystemEnv.getHtmlLabelName(670,user.getLanguage())%></A></TD>
        </TR>

        <!-- TR><TD><A href="#"><%=SystemEnv.getHtmlLabelName(674,user.getLanguage())%></A></TD></TR -->
        <tr><TD><A  href="/hrm/report/hrmSexRp.jsp"> <%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%>: <%=SystemEnv.getHtmlLabelName(416,user.getLanguage())%></TD></tr>
        <tr><TD><A  href="/hrm/report/hrmAgeRp.jsp"> <%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%>: <%=SystemEnv.getHtmlLabelName(671,user.getLanguage())%></TD></tr>
        <tr><TD><A  href="/hrm/report/hrmWorkageRp.jsp"> <%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%>: <%=SystemEnv.getHtmlLabelName(15878,user.getLanguage())%></TD></tr>
        <tr><TD><A  href="/hrm/report/hrmEducationLevelRp.jsp"> <%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%>: <%=SystemEnv.getHtmlLabelName(818,user.getLanguage())%></TD></tr>
        <tr><TD><A  href="/hrm/report/hrmDepartmentRp.jsp"> <%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%>: <%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%> </TD></tr>
        <!--<tr><TD><A  href="/hrm/report/hrmCostcenterRp.jsp"> 人力资源: 成本中心 </TD></tr>-->
        <tr><TD><A  href="/hrm/report/HrmJobTitleRp.jsp"> <%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%>: <%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%> </TD></tr>
        <tr><TD><A  href="/hrm/report/HrmJobActivityRp.jsp"> <%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%>: <%=SystemEnv.getHtmlLabelName(1915,user.getLanguage())%> </TD></tr>
        <tr><TD><A  href="/hrm/report/HrmJobGroupRp.jsp"> <%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%>: <%=SystemEnv.getHtmlLabelName(805,user.getLanguage())%> </TD></tr>
        <tr><TD><A  href="/hrm/report/HrmJobCallRp.jsp"> <%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%>: <%=SystemEnv.getHtmlLabelName(806,user.getLanguage())%> </TD></tr>
        <tr><TD><A  href="/hrm/report/HrmJobLevelRp.jsp"> <%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%>: <%=SystemEnv.getHtmlLabelName(1909,user.getLanguage())%> </TD></tr>
        <tr><TD><A  href="/hrm/report/hrmStatusRp.jsp"> <%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%>: <%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%> </TD></tr>
        <tr><TD><A  href="/hrm/report/hrmUsekindRp.jsp"> <%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%>: <%=SystemEnv.getHtmlLabelName(804,user.getLanguage())%></TD></tr>
        <tr><TD><A  href="/hrm/report/hrmMarriedRp.jsp"> <%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%>: <%=SystemEnv.getHtmlLabelName(469,user.getLanguage())%></TD></tr>
        <tr><TD><A  href="/hrm/report/hrmSecLevelRp.jsp"> <%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></TD></tr>
</table>        
<%if(software.equals("ALL") || software.equals("HRM")){%>
<TABLE CLASS=viewForm>
        <TR CLASS=title> 
          <TH><%=SystemEnv.getHtmlLabelName(532,user.getLanguage())%></TH>
        </TR>
        <TR CLASS=spacing> 
          <TD CLASS=line1></TD>
        </TR>	
        <tr><TD><A  href="/hrm/report/HrmTrainLayoutReport.jsp"> <%=SystemEnv.getHtmlLabelName(6128,user.getLanguage())%> </TD></tr>
        <tr><TD><A  href="/hrm/report/HrmTrainReport.jsp"> <%=SystemEnv.getHtmlLabelName(6136,user.getLanguage())%> </TD></tr>
        <tr><TD><A  href="/hrm/report/HrmTrainResourceReport.jsp"> <%=SystemEnv.getHtmlLabelName(15879,user.getLanguage())%> </TD></tr>
      </TABLE>
<%}%>       
<TABLE CLASS=viewForm>
        <TR CLASS=title> 
          <TH><%=SystemEnv.getHtmlLabelName(15880,user.getLanguage())%></TH>
        </TR>
        <TR CLASS=spacing> 
          <TD CLASS=line1></TD>
        </TR>	
        <tr><TD><A  href="/hrm/report/schedulediff/HrmRpScheduleDiff.jsp"> <%=SystemEnv.getHtmlLabelName(352,user.getLanguage())%> </TD></tr>        
        <tr><TD><A  href="/hrm/report/schedulediff/HrmScheduleDiffReport.jsp"> <%=SystemEnv.getHtmlLabelName(15101,user.getLanguage())%> </TD></tr> 
        <tr><TD><A  href="/hrm/report/schedulediff/HrmRpTimecard.jsp"><%=SystemEnv.getHtmlLabelName(16673, user.getLanguage())%></TD></tr>
        <tr><TD><A  href="/hrm/report/schedulediff/HrmArrangeShiftReport.jsp"><%=SystemEnv.getHtmlLabelName(16674, user.getLanguage())%></TD></tr>
      </TABLE>           
	</TD>
	<TD></TD>
	<TD VALIGN=Top>
        <TABLE CLASS=viewForm>
		<TR CLASS=title>
          <TH><%=SystemEnv.getHtmlLabelName(15882,user.getLanguage())%></TH>
        </TR>
		<TR class= Spacing><TD class=Line1></TD></TR>
		<TR><TD><A href="/hrm/report/resource/HrmRpResource.jsp"><%=SystemEnv.getHtmlLabelName(352,user.getLanguage())%></A></TD></TR>
		<TR><TD><A href="HrmRpContact.jsp"><%=SystemEnv.getHtmlLabelName(1515,user.getLanguage())%></A></TD></TR>
		<TR><TD><A href="/hrm/report/redeploy/HrmRpRedeploy.jsp"><%=SystemEnv.getHtmlLabelName(6090,user.getLanguage())%></A></TD></TR>
		<TR><TD><A href="/hrm/report/resourceadd/HrmRpResourceAdd.jsp"><%=SystemEnv.getHtmlLabelName(15883,user.getLanguage())%></A></TD></TR>
		<TR><TD><A href="/hrm/report/hire/HrmRpHire.jsp"><%=SystemEnv.getHtmlLabelName(6088,user.getLanguage())%></A></TD></TR>
		<TR><TD><A href="/hrm/report/extend/HrmRpExtend.jsp"><%=SystemEnv.getHtmlLabelName(6089,user.getLanguage())%></A></TD></TR>
		<TR><TD><A href="/hrm/report/rehire/HrmRpRehire.jsp"><%=SystemEnv.getHtmlLabelName(15884,user.getLanguage())%></A></TD></TR>
		<TR><TD><A href="/hrm/report/retire/HrmRpRetire.jsp"><%=SystemEnv.getHtmlLabelName(6092,user.getLanguage())%></A></TD></TR>
		<TR><TD><A href="/hrm/report/dismiss/HrmRpDismiss.jsp"><%=SystemEnv.getHtmlLabelName(6091,user.getLanguage())%></A></TD></TR>
		<TR><TD><A href="/hrm/report/fire/HrmRpFire.jsp"><%=SystemEnv.getHtmlLabelName(6094,user.getLanguage())%></A></TD></TR>
		<TR><TD><A href="/hrm/report/contract/HrmRpContract.jsp"><%=SystemEnv.getHtmlLabelName(614,user.getLanguage())%></A></TD></TR>
        <!--tr> 
          <td><a href="/cpt/report/CptRpCarDriver.jsp"><%=SystemEnv.getHtmlLabelName(15328, user.getLanguage())%></a></td>
        </tr -->
		</TABLE>
<%if(software.equals("ALL") || software.equals("HRM")){%>		
		<TABLE class=ViewForm>
        <TR class=Title> 
          <TH><%=SystemEnv.getHtmlLabelName(6133,user.getLanguage())%></TH>
        </TR>
        <TR class= Spacing> 
          <TD class=Line1></TD>
        </TR>	
        <tr><TD><A  href="/hrm/report/usedemand/HrmRpUseDemand.jsp"> <%=SystemEnv.getHtmlLabelName(6131,user.getLanguage())%> </TD></tr>        
        <tr><TD><A  href="/hrm/report/careerapply/HrmRpCareerApply.jsp"> <%=SystemEnv.getHtmlLabelName(15885,user.getLanguage())%> </TD></tr>
      </TABLE> 
<%}%>	  
	  <TABLE class=ViewForm>
        <TR class=Title> 
          <TH><%=SystemEnv.getHtmlLabelName(2103,user.getLanguage())%></TH>
        </TR>
        <TR class= Spacing> 
          <TD class=Line1></TD>
        </TR>	
        <tr><TD><A  href="/meeting/report/MeetingRoomPlan.jsp"> <%=SystemEnv.getHtmlLabelName(15881,user.getLanguage())%> </a></TD></tr>  
      </TABLE> 

		<!--TABLE class=ViewForm>
			<TR class=Title><TH><%=SystemEnv.getHtmlLabelName(189,user.getLanguage())%></TH></TR>
			<TR class= Spacing><TD class=Line1></TD></TR>
			<TR><TD><A href="/hrm/resource/HrmResourceComponent.jsp?resourceid=<%=user.getUID()%>"><%=SystemEnv.getHtmlLabelName(503,user.getLanguage())%></A></TD></TR>
			<TR>
          <TD><a href="/fna/transaction/FnaTransactionDetail.jsp"><%=SystemEnv.getHtmlLabelName(187,user.getLanguage())%></a></TD>
        </TR>
			<TR><TD><A href="/fna/budget/FnaBudget.jsp"><%=SystemEnv.getHtmlLabelName(386,user.getLanguage())%></A></TD></TR>
			<!-- TR><TD><A href="#"><%=SystemEnv.getHtmlLabelName(675,user.getLanguage())%></A></TD></TR>
			<TR><TD><A href="#"><%=SystemEnv.getHtmlLabelName(676,user.getLanguage())%></A></TD></TR>
			
			<TR><TD><A href="#"><%=SystemEnv.getHtmlLabelName(485,user.getLanguage())%></A></TD></TR>
			
		</TABLE -->
	</TD>
</TR>	
<!------------------------------------------------------------------------------------------------------------------>
<TR>
	<TD VALIGN=Top>
				<!-- 动态读取固定报表 !-->
				
<TABLE class=ViewForm width="100%" border=0>
<%
    int ishead=0;
    RecordSet.executeProc("Workflow_StaticReport_SByModu","2");
    while(RecordSet.next()){
        if(ishead==0){
%>
    <TR class=Title> 
          <TH><%=SystemEnv.getHtmlLabelName(1883,user.getLanguage())%>
            <!--Reports-->
          </TH>
    </TR>
  <TR class= Spacing> 
    <TD class=Line1></TD>
  </TR>
<%      ishead=1;  
        }
        String tmppagename=RecordSet.getString("pagename");
        String reportid=RecordSet.getString("reportid");
        String name=RecordSet.getString("name");
%>
    <TR> 
          <TD><A href="/workflow/report/<%=tmppagename%>?reportid=<%=reportid%>"><%=Util.toScreen(name,user.getLanguage())%></A>
                </TD>

    </TR>
<%
   }
%>
</table>
<!-- end !-->


	</TD>
	<TD></TD>
	<TD VALIGN=Top>

		<!-- TABLE class=ViewForm>
			<TR class=Title><TH><%=SystemEnv.getHtmlLabelName(375,user.getLanguage())%></TH></TR>
			<TR class= Spacing><TD class=Line1></TD></TR>
			<TR><TD><A href="#"><%=SystemEnv.getHtmlLabelName(83,user.getLanguage())%></A>/<A href="#"><%=SystemEnv.getHtmlLabelName(83,user.getLanguage())%>:&nbsp;<%=SystemEnv.getHtmlLabelName(677,user.getLanguage())%></A></TD></TR>
			<TR><TD><A href="#"><%=SystemEnv.getHtmlLabelName(674,user.getLanguage())%></A></TD></TR>
			<TR><TD><A href="#"><%=SystemEnv.getHtmlLabelName(532,user.getLanguage())%></A></TD></TR>
			<TR><TD><A href="#"><%=SystemEnv.getHtmlLabelName(678,user.getLanguage())%></A></TD></TR>
			<TR><TD><A href="#"><%=SystemEnv.getHtmlLabelName(260,user.getLanguage())%> - <%=SystemEnv.getHtmlLabelName(679,user.getLanguage())%></A></TD></TR>
		</TABLE -->
	</TD>
</TR>

<TR>
	<TD VALIGN=Top>
		<!-- TABLE class=ViewForm>
			<TR class=Title><TH><%=SystemEnv.getHtmlLabelName(680,user.getLanguage())%></TH></TR>
			<TR class= Spacing><TD class=Line1></TD></TR>
			<TR><TD><A href="#"><%=SystemEnv.getHtmlLabelName(187,user.getLanguage())%></a></TD></TR>
			<TR><TD><A href="#"><%=SystemEnv.getHtmlLabelName(351,user.getLanguage())%>:&nbsp;<%=SystemEnv.getHtmlLabelName(187,user.getLanguage())%></a></TD></TR>
		</TABLE -->
	</TD>
</TR>
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