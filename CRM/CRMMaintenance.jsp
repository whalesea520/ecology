
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(147,user.getLanguage())+SystemEnv.getHtmlLabelName(60,user.getLanguage());
String needfav ="";
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
	<SELECT class=InputStyle  name=mainttype onchange="changetype()">
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
<TABLE class=Form width="100%">
  <COLGROUP>
  <COL width="48%">
  <COL width=24>
  <COL width="48%">
  <TBODY>
  <TR vAlign=top>
    <TD>
     <TABLE class=Form>
        <COLGROUP>
        <COL width="100%">
        <TBODY>
        <TR class=Section>
          <TH><%=SystemEnv.getHtmlLabelName(154,user.getLanguage())%></TH></TR>
        <TR class=Separator>
          <TD class=Sep1></TD>
        <TR>
          <TD><A 
            href="/CRM/Maint/ListContacterTitle.jsp"><%=SystemEnv.getHtmlLabelName(462,user.getLanguage())%></A></TD></TR>
        <TR>
          <TD><A 
            href="/CRM/Maint/ListAddressType.jsp"><%=SystemEnv.getHtmlLabelName(110,user.getLanguage())%>:<%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></A></TD></TR>
        <TR>
          <TD><A 
            href="/CRM/Maint/ListContactWay.jsp"><%=SystemEnv.getHtmlLabelName(569,user.getLanguage())%></A></TD></TR>
        <TR>
          <TD><A 
            href="/base/ffield/ListCustomerFreeField.jsp"><%=SystemEnv.getHtmlLabelName(570,user.getLanguage())%>:<%=SystemEnv.getHtmlLabelName(571,user.getLanguage())%></A></TD></TR>
        <TR>
          <TD><A 
            href="/base/ffield/ListContacterFreeField.jsp"><%=SystemEnv.getHtmlLabelName(570,user.getLanguage())%>:<%=SystemEnv.getHtmlLabelName(572,user.getLanguage())%></A></TD></TR>
        <TR>
          <TD><A 
            href="/base/ffield/ListAddressFreeField.jsp"><%=SystemEnv.getHtmlLabelName(570,user.getLanguage())%>:<%=SystemEnv.getHtmlLabelName(110,user.getLanguage())%></A></TD></TR>
        <TR>
          <TD><A 
            href="/CRM/Maint/ListDeliveryType.jsp"><%=SystemEnv.getHtmlLabelName(573,user.getLanguage())%></A></TD></TR>

			<TR>
          <TD><A 
            href="/CRM/Maint/EvaluationLevelList.jsp"><%=SystemEnv.getHtmlLabelName(6070,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(324,user.getLanguage())%></A></TD></TR>

			<TR>
          <TD><A 
            href="/CRM/Maint/EvaluationList.jsp"><%=SystemEnv.getHtmlLabelName(6070,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(101,user.getLanguage())%></A></TD></TR>
			<TR>
          <TD><A 
            href="/CRM/Maint/CRMContractTypeList.jsp"><%=SystemEnv.getHtmlLabelName(6083,user.getLanguage())%></A></TD></TR>

           <TR>
          <TD><A 
            href="/CRM/sellchance/ListCRMStatus.jsp"><%=SystemEnv.getHtmlLabelName(2227,user.getLanguage())%></A></TD></TR>
           <TR>
          <TD><A 
            href="/CRM/sellchance/ListCRMTimespan.jsp"><%=SystemEnv.getHtmlLabelName(15102,user.getLanguage())%></A></TD></TR>
           <TR>
          <TD><A 
            href="/CRM/sellchance/ListCRMSuccessfactor.jsp"><%=SystemEnv.getHtmlLabelName(15103,user.getLanguage())%></A></TD></TR>
           <TR>
          <TD><A 
            href="/CRM/sellchance/ListCRMFailfactor.jsp"><%=SystemEnv.getHtmlLabelName(15104,user.getLanguage())%></A></TD></TR>
			 <TR>
          <TD><A 
            href="/CRM/Maint/CustomerCredit.jsp"><%=SystemEnv.getHtmlLabelName(6097,user.getLanguage())+"/"+SystemEnv.getHtmlLabelName(6098,user.getLanguage())%></A></TD></TD></TR>

			</TBODY></TABLE>
		
	  <br>
      <TABLE class=Form>
        <COLGROUP>
        <COL width="100%">
        <TBODY>
        <TR class=Section>
          <TH><%=SystemEnv.getHtmlLabelName(578,user.getLanguage())%>:<%=SystemEnv.getHtmlLabelName(579,user.getLanguage())%></TH></TR> 
        <TR class=Separator>
          <TD class=Sep3></TD>
<!--       
		<TR>
          <TD><A href="/CRM/Maint/ListCustomerRating.jsp"><%=SystemEnv.getHtmlLabelName(139,user.getLanguage())%></A></TD></TR>
-->
         <TR>
          <TD><A href="/CRM/Maint/ListCreditInfo.jsp"><%=SystemEnv.getHtmlLabelName(580,user.getLanguage())%></A></TD></TR>
        <TR>
          <TD><A href="/CRM/Maint/ListTradeInfo.jsp"><%=SystemEnv.getHtmlLabelName(581,user.getLanguage())%></A></TD></TR></TBODY></TABLE>
		
		<br>
<!--
		<TABLE class=Form>
        <COLGROUP>
        <COL width="100%">
        <TBODY>
        <TR class=Section>
          <TH>客户整理</TH></TR>
        <TR class=Separator>
          <TD class=Sep3></TD>
        <TR>
          <TD><A href="/CRM/data/CustomerNoContacter.jsp">数据清理</A></TD></TR></TBODY></TABLE>	
-->
	</TD>
    <TD></TD>
    <TD>
      <TABLE class=Form>
        <COLGROUP>
        <COL width="100%">
        <TBODY>
        <TR class=Section>
          <TH><%=SystemEnv.getHtmlLabelName(574,user.getLanguage())%></TH></TR>
        <TR class=Separator>
          <TD class=Sep3></TD>
  <!--      <TR class=Separator>
          <TD><A 
            href="#">地区</A></TD>
   -->     <TR>
          <TD><A 
            href="/CRM/Maint/ListSectorInfo.jsp"><%=SystemEnv.getHtmlLabelName(575,user.getLanguage())%></A></TD></TR>
        <TR>
          <TD><A 
            href="/CRM/Maint/ListCustomerSize.jsp"><%=SystemEnv.getHtmlLabelName(576,user.getLanguage())%></A></TD></TR>
        <TR>
          <TD><A 
          href="/CRM/Maint/ListCustomerType.jsp"><%=SystemEnv.getHtmlLabelName(178,user.getLanguage())%></A></TD></TR>
        <TR>
          <TD><A 
          href="/CRM/Maint/ListCustomerDesc.jsp"><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></A></TD></TR>

        <TR>
          <TD><A 
          href="/CRM/Maint/ListCustomerStatus.jsp"><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></A></TD></TR>

        <TR>
          <TD><A 
          href="/CRM/Maint/ListPaymentTerm.jsp"><%=SystemEnv.getHtmlLabelName(577,user.getLanguage())%></A></TD></TR></TBODY></TABLE>

		<br>
		<TABLE class=Form>
        <COLGROUP>
        <COL width="100%">
        <TBODY>
        <TR class=Section>
          <TH><%=SystemEnv.getHtmlLabelName(15105,user.getLanguage())%></TH></TR>
        <TR class=Separator>
          <TD class=Sep3></TD>
        <TR><TD><A href="/lgc/maintenance/LgcAssortment.jsp?addorsub=3"><%=SystemEnv.getHtmlLabelName(15106,user.getLanguage())%></A></TD></TR>
        <TR><TD><A href="/lgc/asset/LgcAssetAdd.jsp"><%=SystemEnv.getHtmlLabelName(15107,user.getLanguage())%></A></TD></TR>	
        <TR><TD><A href="/lgc/search/LgcSearchProduct.jsp"><%=SystemEnv.getHtmlLabelName(15108,user.getLanguage())%></A></TD></TR>		
		</TBODY></TABLE>	
		<BR>
        <TABLE class=Form>
	        <COLGROUP>
			<COL width="30%">
	  		<COL width="70%">
	        <TBODY>
		        <TR class=Section>
		            <TH colSpan=2><%=SystemEnv.getHtmlLabelName(15109,user.getLanguage())%></TH>
		          </TR>
		        <TR class=separator>
		          <TD class=Sep1 colSpan=2></TD></TR>
		        <TR>
				  <TD><A href="/CRM/investigate/InputReport.jsp"><%=SystemEnv.getHtmlLabelName(15110,user.getLanguage())%></A></TD></TR>
		        <TR>
				  <TD><A href="/CRM/investigate/SurveyForm.jsp"><%=SystemEnv.getHtmlLabelName(15111,user.getLanguage())%></A></TD></TR>
		        
		</TBODY>
		</TABLE>

	</TD></TR>
  <TR vAlign=top>
<!--    <TD>
      <TABLE class=Form>
        <TBODY>
        <TR class=Section>
          <TH>其它</TH></TR>
        <TR class=Separator>
          <TD class=Sep3></TD>
        <TR>
          <TD><A href="#">设定</A></TD></TR>
        <TR>
          <TD><A href="#">帐户: 
            字段</A></TD></TR>
        <TR>
          <TD><A href="#">字段长度</A></TD></TR>
        <TR>
          <TD><A href="#">邮件模板</A></TD></TR></TBODY></TABLE></TD>
    <TD></TD>
  -->  <TD>
  
		  
		  </TD>

  <TR>
    <TD>
	<!--
      <TABLE class=Form>
        <COLGROUP>
        <COL width="100%">
        <TBODY>
        <TR class=Section>
          <TH><%=SystemEnv.getHtmlLabelName(582,user.getLanguage())%></TH></TR>
        <TR class=Separator>
          <TD class=Sep3></TD>
        <TR>
          <TD><A href="#"><%=SystemEnv.getHtmlLabelName(136,user.getLanguage())%>:  
            页 - 支持</A></TD></TR></TBODY></TABLE>
           -->		
	
		</TD>

   </TR></TBODY></TABLE></BODY></HTML> 
