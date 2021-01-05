<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="CostcenterComInfo" class="weaver.hrm.company.CostCenterComInfo" scope="page"/>
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page"/>
<jsp:useBean id="BankComInfo" class="weaver.hrm.finance.BankComInfo" scope="page"/>
<jsp:useBean id="CurrencyComInfo" class="weaver.fna.maintenance.CurrencyComInfo" scope="page"/>
<jsp:useBean id="SalaryComponentComInfo" class="weaver.hrm.finance.SalaryComponentComInfo" scope="page"/>
<jsp:useBean id="LedgerComInfo" class="weaver.fna.maintenance.LedgerComInfo" scope="page"/>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>
<%
String resourceid = Util.null2String(request.getParameter("resourceid"));
String departmentid = ResourceComInfo.getDepartmentID(resourceid) ;
String jobtitle = ResourceComInfo.getJobTitle(resourceid) ;
String costcenterid = ResourceComInfo.getCostcenterID(resourceid) ;
if(!resourceid.equals(""+user.getUID()) && !HrmUserVarify.checkUserRight("HrmResourceComponent:All",user,departmentid)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(503,user.getLanguage())+": "+ Util.toScreen(ResourceComInfo.getResourcename(resourceid),user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<DIV class=HdrProps></DIV>
<div> 
  <%
if(HrmUserVarify.checkUserRight("HrmResourceComponentAdd:Add", user,departmentid)){
%>
  <BUTTON class=Btn id=Addbtn accessKey=A 
onclick='location.href="HrmResourceComponentAdd.jsp?resourceid=<%=resourceid%>"'><U>A</U>-<%=SystemEnv.getHtmlLabelName(193,user.getLanguage())%></BUTTON>
<%}%>
</div>
<TABLE class=FORM>
  <COLGROUP> <COL width="15%"> <COL width="33%"> <COL width=24> <COL width="15%"> 
  <COL width="33%"> <TBODY> 
  <TR class=SECTION> 
    <TH colSpan=5><%=SystemEnv.getHtmlLabelName(154,user.getLanguage())%></TH>
  </TR>
  <TR class=Separator> 
    <TD class=Sep1 colSpan=5></TD>
  </TR>
  <TR> 
    <TD><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></TD>
    <TD class=FIELD> 
      <% if(HrmUserVarify.checkUserRight("HrmResourceComponent:All",user)) {%>
      <BUTTON class=Browser id=SelecResourceid onClick="onShowResourceID()"></BUTTON> 
      <span id=resourceidspan> <A href="/hrm/resource/HrmResource.jsp?id=<%=resourceid%>"><%=Util.toScreen(ResourceComInfo.getResourcename(resourceid),user.getLanguage())%></A></span> 
      <%} else {%>
      <A href="/hrm/resource/HrmResource.jsp?id=<%=resourceid%>"><%=Util.toScreen(ResourceComInfo.getResourcename(resourceid),user.getLanguage())%></A>
      <%}%>
      <input class=inputstyle id=resourceid type=hidden name=resourceid >
    </TD>
    <TD>&nbsp;</TD>
    <TD><%=SystemEnv.getHtmlLabelName(357,user.getLanguage())%></TD>
    <TD class=FIELD> <A href="/hrm/jobtitles/HrmJobTitlesEdit.jsp?id=<%=jobtitle%>"><%=Util.toScreen(JobTitlesComInfo.getJobTitlesname(jobtitle),user.getLanguage())%></A>&nbsp;&nbsp;&nbsp;</TD>
  </TR>
  <TR> 
    <TD><%=SystemEnv.getHtmlLabelName(515,user.getLanguage())%></TD>
    <TD class=FIELD><a 
      href="/hrm/company/HrmCostcenterDsp.jsp?id=<%=costcenterid%>"><%=Util.toScreen(CostcenterComInfo.getCostCentername(costcenterid),user.getLanguage())%></a></TD>
    <TD>&nbsp;</TD>
    <TD>&nbsp;</TD>
    <TD></TD>
  </TR>
  </TBODY> 
</TABLE>
<TABLE class=ListShort>
  <COL WIDTH=15%>
  <COL WIDTH=8%>
  <COL WIDTH=10%>
  <COL WIDTH=10%>
  <COL WIDTH=10%>
  <COL WIDTH=15%>
  <COL WIDTH=15%>
  <COL WIDTH=20%>
  <TBODY> 
  <TR class=SECTION> 
    <TH colSpan=8><%=SystemEnv.getHtmlLabelName(361,user.getLanguage())%></TH>
  </TR>
  <TR> 
    <TD class=Sep2 colSpan=8></TD>
  </TR>
  <TR class=Header> 
    <TD><%=SystemEnv.getHtmlLabelName(533,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(446,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(481,user.getLanguage())%></TD>
	<TD><%=SystemEnv.getHtmlLabelName(733,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(406,user.getLanguage())%></TD>
    <TD align=right><%=SystemEnv.getHtmlLabelName(534,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(1941,user.getLanguage())%></TD>
	<TD><%=SystemEnv.getHtmlLabelName(550,user.getLanguage())%></TD>

  </TR>
<%
int i= 0;
RecordSet.executeProc("HrmResourceComponent_SByResour",resourceid);
while(RecordSet.next()) {
	String id = RecordSet.getString("id") ;
	String componentid = Util.null2String(RecordSet.getString("componentid")) ;
	String componentperiod = Util.null2String(RecordSet.getString("componentperiod")) ;
	String bankid = Util.null2String(RecordSet.getString("bankid")) ;
	String salarysum = Util.null2String(RecordSet.getString("salarysum")) ;
	String currencyid = Util.null2String(RecordSet.getString("currencyid")) ;
	String startdate = Util.null2String(RecordSet.getString("startdate")) ;
	String enddate = Util.null2String(RecordSet.getString("enddate")) ;
	String ledgerid = Util.null2String(RecordSet.getString("ledgerid")) ;
	
if(i==0){
		i=1;
%>
<TR class=DataLight>
<%
	}else{
		i=0;
%>
<TR class=DataDark>
<%
}
%>
    <TD><A href="HrmResourceComponentEdit.jsp?id=<%=id%>"><%=Util.toScreen(SalaryComponentComInfo.getComponentname(componentid),user.getLanguage())%></A></TD>
    <TD>
			<% if(componentperiod.equals("0")){%><%=SystemEnv.getHtmlLabelName(538,user.getLanguage())%><%}
  			if(componentperiod.equals("1")){%><%=SystemEnv.getHtmlLabelName(539,user.getLanguage())%><%}
  			if(componentperiod.equals("2")){%><%=SystemEnv.getHtmlLabelName(540,user.getLanguage())%><%}
  			if(componentperiod.equals("3")){%><%=SystemEnv.getHtmlLabelName(541,user.getLanguage())%><%}
  			if(componentperiod.equals("4")){%><%=SystemEnv.getHtmlLabelName(542,user.getLanguage())%><%}
  			if(componentperiod.equals("5")){%><%=SystemEnv.getHtmlLabelName(543,user.getLanguage())%><%}
  			if(componentperiod.equals("6")){%><%=SystemEnv.getHtmlLabelName(544,user.getLanguage())%><%}
  			if(componentperiod.equals("7")){%><%=SystemEnv.getHtmlLabelName(545,user.getLanguage())%><%}
  			if(componentperiod.equals("8")){%><%=SystemEnv.getHtmlLabelName(546,user.getLanguage())%><%}%>
	</TD>
    <TD><%=startdate%></TD>
	<TD><%=enddate%></TD>
    <TD><%=Util.toScreen(CurrencyComInfo.getCurrencyname(currencyid),user.getLanguage())%></TD>
    <TD align=right><%=Util.getFloatStr(salarysum,3)%></TD>
    <TD><a href="/hrm/finance/HrmBankEdit.jsp?id=<%=bankid%>"><%=Util.toScreen(BankComInfo.getBankname(bankid),user.getLanguage())%></a></TD>
  	<TD><%=LedgerComInfo.getLedgermark(ledgerid)%>-<%=Util.toScreen(LedgerComInfo.getLedgername(ledgerid),user.getLanguage())%></TD>
  </TR>
  <%}%>
  </TBODY>
</TABLE>
<script language=vbs>

sub onShowResourceID()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	if (Not IsEmpty(id)) then
		if id(0)<> "" then
			if id(0) <> resourceid.value then
				resourceid.value = id(0)
				location.href="HrmResourceComponent.jsp?resourceid="&id(0)
			end if
		end if
	end if
end sub
</script>
</BODY></HTML>
