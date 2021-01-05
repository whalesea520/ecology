
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetCT" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CRMSearchComInfo" class="weaver.crm.search.SearchComInfo" scope="session" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="CityComInfo" class="weaver.hrm.city.CityComInfo" scope="page"/>
<jsp:useBean id="ProvinceComInfo" class="weaver.hrm.province.ProvinceComInfo" scope="page"/>
<jsp:useBean id="CountryComInfo" class="weaver.hrm.country.CountryComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="SectorInfoComInfo" class="weaver.crm.Maint.SectorInfoComInfo" scope="page" />
<jsp:useBean id="CustomerDescComInfo" class="weaver.crm.Maint.CustomerDescComInfo" scope="page" />
<jsp:useBean id="TradeInfoComInfo" class="weaver.crm.Maint.TradeInfoComInfo" scope="page" />
<jsp:useBean id="CreditInfoComInfo" class="weaver.crm.Maint.CreditInfoComInfo" scope="page" />
<jsp:useBean id="CustomerStatusComInfo" class="weaver.crm.Maint.CustomerStatusComInfo" scope="page" />
<jsp:useBean id="ContactWayComInfo" class="weaver.crm.Maint.ContactWayComInfo" scope="page" />
<jsp:useBean id="CustomerSizeComInfo" class="weaver.crm.Maint.CustomerSizeComInfo" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page"/>




<%
//add by 徐蔚绛 2005-03-09 TD:1546
String actionKey=Util.null2String(request.getParameter("actionKey"));
String method=Util.null2String(request.getParameter("method"));
//  if(method.equals("empty"))        // modify by liuyu to empty any where
//{
	CRMSearchComInfo.resetSearchInfo();
//}

RecordSetCT.executeProc("CRM_CustomerType_SelectAll","");
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</HEAD>
<%
String imagefilename = "/images/hdDOC_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(197,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(136,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:onGoSearch(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(343,user.getLanguage())+",javascript:location.href='/CRM/search/Customize.jsp',_top} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(589,user.getLanguage())+",javascript:document.weaver.reset(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(347,user.getLanguage())+"&lt;&lt;,javascript:onToSimple(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
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

<FORM id=weaver name="weaver" action="/CRM/search/SearchOperation.jsp" method=post>
<input type="hidden" name="destination" value="no">
<input type="hidden" name="searchtype" value="advanced">
<%//add by 徐蔚绛 2005-03-09 TD:1546%>
<input type="hidden" name="actionKey" value="<%=actionKey%>"> 

<TABLE class=ViewForm>
  <COLGROUP>
  <COL width="49%">
  <COL width=10>
  <COL width="49%">
  <TBODY>
  <TR class=Spacing  style="height: 1px">
    <TD class=Line1 colSpan=3></TD></TR>
  <TR>
	<TD colSpan=3>
	<table>
	  <COLGROUP>
	  <COL width="20%">
	  <COL width="80%">
	  <TBODY>
		<tr>
			<td><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></td>
			<td>
<%
	int nCount = 0;
	while(RecordSetCT.next())
	{
		String tmpid=RecordSetCT.getString("id");
		nCount++;
if(CRMSearchComInfo.isCustomerTypeSel(Util.getIntValue(tmpid))){%>
				<INPUT name="CustomerTypes" type="checkbox" value="<%=tmpid%>" checked><%=Util.toScreen(RecordSetCT.getString("fullname"),user.getLanguage())%>
<%}else{%>
				<INPUT name="CustomerTypes" type="checkbox" value="<%=tmpid%>"><%=Util.toScreen(RecordSetCT.getString("fullname"),user.getLanguage())%>
<%}
}%>
			</td>
		</TR>
	  </TBODY>
	</table>
	</TD>
  </TR><tr  style="height: 1px"><td class=Line colspan=4></td></tr>
  <TR>

	<TD vAlign=top>

	  <TABLE class=ViewForm>
        <COLGROUP>
		<COL width="30%">
  		<COL width="70%">
        <TBODY>
        <TR class=Title>
            <TH colSpan=2><%=SystemEnv.getHtmlLabelName(136,user.getLanguage())%></TH>
          </TR>
        <TR class=Spacing  style="height: 1px">
          <TD class=Line1 colSpan=2></TD></TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=50 size=30 name="CustomerName" value="<%=CRMSearchComInfo.getCustomerName()%>"></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
        
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(377,user.getLanguage())%></TD>
          <TD class=Field>
            <INPUT class="wuiBrowser" _displayText="<%=CountryComInfo.getCountrydesc(CRMSearchComInfo.getCustomerCountry())%>" _url="/systeminfo/BrowserMain.jsp?url=/hrm/country/CountryBrowser.jsp" id=CustomerCountry type=hidden name="CustomerCountry" value="<%=CRMSearchComInfo.getCustomerCountry()%>"></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(800,user.getLanguage())%></TD>
          <TD class=Field>
                 <INPUT class="wuiBrowser" _displayText="<%=ProvinceComInfo.getProvincename(CRMSearchComInfo.getCustomerProvince())%>" _url="/systeminfo/BrowserMain.jsp?url=/hrm/province/ProvinceBrowser.jsp" id=CustomerProvince type=hidden name="CustomerProvince" value="<%=CRMSearchComInfo.getCustomerProvince()%>"></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
		<TR>
          <TD><%=SystemEnv.getHtmlLabelName(493,user.getLanguage())%></TD>
          <TD class=Field>
	           <INPUT class="wuiBrowser" _displayText="<%=CityComInfo.getCityname(CRMSearchComInfo.getCustomerCity())%>" _url="/systeminfo/BrowserMain.jsp?url=/hrm/city/CityBrowser.jsp" id=CityCode type=hidden name="CustomerCity" value="<%=CRMSearchComInfo.getCustomerCity()%>">

		  </TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
		<TR>
          <TD><%=SystemEnv.getHtmlLabelName(277,user.getLanguage())%></TD>
          <TD class=Field>
			  <BUTTON type="button" class=calendar id=SelectDate onclick=getfromDate()></BUTTON>&nbsp;
			  <SPAN id=fromdatespan ><%=CRMSearchComInfo.getFromDate()%></SPAN>
			  <input type="hidden" name="fromdate" value=<%=CRMSearchComInfo.getFromDate()%>>
			  －<BUTTON type="button" class=calendar id=SelectDate onclick=getendDate()></BUTTON>&nbsp;
			  <SPAN id=enddatespan ><%=CRMSearchComInfo.getEndDate()%></SPAN>
			  <input type="hidden" name="enddate" value=<%=CRMSearchComInfo.getEndDate()%>>

		  </TD>
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(101,user.getLanguage())%></TD>
          <TD class=Field>
              <input class="wuiBrowser" _displayText="<A href='/proj/data/ViewProject.jsp?ProjID=<%=CRMSearchComInfo.getPrjID()%>'><%=ProjectInfoComInfo.getProjectInfoname(CRMSearchComInfo.getPrjID())%>" _displayTemplate="<A href='/proj/data/ViewProject.jsp?ProjID=#b{id}'>#b{name}</A>" _url="/systeminfo/BrowserMain.jsp?url=/proj/data/ProjectBrowser.jsp" type=hidden name="PrjID" value="<%=CRMSearchComInfo.getPrjID()%>"></TD>
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>
        </TBODY>
	  </TABLE>

	  <TABLE class=ViewForm>
        <COLGROUP>
		<COL width="30%">
  		<COL width="70%">
        <TBODY>
        <TR class=Title>
            <TH colSpan=2><%=SystemEnv.getHtmlLabelName(572,user.getLanguage())%></TH>
          </TR>
        <TR class=Spacing style="height: 1px">
          <TD class=Line1 colSpan=2></TD></TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=50 size=30 name="ContacterFirstName" value="<%=CRMSearchComInfo.getContacterFirstName()%>"></TD>
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(475,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=50 size=30 name="ContacterLastName" value="<%=CRMSearchComInfo.getContacterLastName()%>"></TD>
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(671,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=inputstyle name=age size=5 maxlength=3  onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("age")' value=""><%=SystemEnv.getHtmlLabelName(15864,user.getLanguage())%>－
            <INPUT class=inputstyle name=ageTo size=5 maxlength=3  onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("ageTo")' value=""><%=SystemEnv.getHtmlLabelName(15864,user.getLanguage())%>
          </TD>
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(1887,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=100 size=30 name="IDCard" onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("IDCard")'  value="<%=CRMSearchComInfo.getContacterIDCard()%>"></TD>
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>
        </TBODY>
	  </TABLE>

	</TD>

	<td></td>
	<TD vAlign=top>

	  <TABLE class=ViewForm>
        <COLGROUP>
		<COL width="30%">
  		<COL width="70%">
        <TBODY>
        <TR class=Title>
            <TH colSpan=2><%=SystemEnv.getHtmlLabelName(574,user.getLanguage())%></TH>
          </TR>
        <TR class=Spacing style="height: 1px">
          <TD class=Line1 colSpan=2></TD></TR>
	<%if(!user.getLogintype().equals("2")){%>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></TD>
          <TD class=Field>
               <input class="wuiBrowser" id=CustomerRegion _displayText="<%=DepartmentComInfo.getDepartmentname(CRMSearchComInfo.getCustomerRegion())%>" _url="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp" type=hidden name="CustomerRegion" value="<%=CRMSearchComInfo.getCustomerRegion()%>"></TD>
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(136,user.getLanguage())%>: <%=SystemEnv.getHtmlLabelName(144,user.getLanguage())%></TD>
          <TD class=Field>
             <INPUT class=wuiBrowser _displayText="<%=ResourceComInfo.getResourcename(CRMSearchComInfo.getAccountManager())%>" _displayTemplate="<A href='/hrm/resource/HrmResource.jsp?id=#b{id}'>#b{name}</A>" _url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp" type=hidden name="AccountManager" value="<%=CRMSearchComInfo.getAccountManager()%>"></TD>
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>
	<%}%>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(132,user.getLanguage())%></TD>
          <TD class=Field>
              <input class="wuiBrowser" _displayTemplate="<A href='/CRM/data/ViewCustomer.jsp?CustomerID=#b{id}'>#b{name}</A>" _displayText="<%=CustomerInfoComInfo.getCustomerInfoname(CRMSearchComInfo.getCustomerOrigin())%>" _url="/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp?sqlwhere=where t1.type in (3,4)" type=hidden name="CustomerOrigin" value="<%=CRMSearchComInfo.getCustomerOrigin()%>"></TD>
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></TD>
          <TD class=Field>
              <INPUT type=hidden class="wuiBrowser" _displayText="<%=CustomerStatusComInfo.getCustomerStatusname(CRMSearchComInfo.getCustomerStatus())%>" _url="/systeminfo/BrowserMain.jsp?url=/CRM/Maint/CustomerStatusBrowser.jsp" name="CustomerStatus" value="<%=CRMSearchComInfo.getCustomerStatus()%>"></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(575,user.getLanguage())%></TD>
          <TD class=Field>
               <INPUT type=hidden class="wuiBrowser" _displayText="<%=SectorInfoComInfo.getSectorInfoname(CRMSearchComInfo.getCustomerSector())%>" _url="/systeminfo/BrowserMain.jsp?url=/CRM/Maint/SectorInfoBrowser.jsp" name="CustomerSector" value="<%=CRMSearchComInfo.getCustomerSector()%>"></TD>
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></TD>
          <TD class=Field>
              <INPUT type=hidden class="wuiBrowser" _displayText="<%=CustomerDescComInfo.getCustomerDescname(CRMSearchComInfo.getCustomerDesc())%>" _url="/systeminfo/BrowserMain.jsp?url=/CRM/Maint/CustomerDescBrowser.jsp" name="CustomerDesc" value="<%=CRMSearchComInfo.getCustomerDesc()%>"></TD>
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(15240,user.getLanguage())%></TD>
          <TD class=Field>
 			<INPUT type=hidden class="wuiBrowser" _displayText="<%=ContactWayComInfo.getContactWaydesc(CRMSearchComInfo.getContactWay())%>" _url="/systeminfo/BrowserMain.jsp?url=/CRM/Maint/ContactWayBrowser.jsp" name="ContactWay" value="<%=CRMSearchComInfo.getContactWay()%>">
 </TD>        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(576,user.getLanguage())%></TD>
          <TD class=Field>
              <INPUT type=hidden class="wuiBrowser" _displayText="<%=CustomerSizeComInfo.getCustomerSizedesc(CRMSearchComInfo.getCustomerSize())%>" _url="/systeminfo/BrowserMain.jsp?url=/CRM/Maint/CustomerSizeBrowser.jsp" name="CustomerSize" value="<%=CRMSearchComInfo.getCustomerSize()%>"></TD>
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>
        </TBODY>
	  </TABLE>

	</TD>
  </TR>
  </TBODY>
</TABLE>


<TABLE class=ViewForm>
  <COLGROUP>
  <COL width="49%">
  <COL width=10>
  <COL width="49%">
  <TBODY>
  <TR class=Title>
      <TH colSpan=3><%=SystemEnv.getHtmlLabelName(347,user.getLanguage())%></TH>
  </TR>
  <TR class=Spacing style="height: 1px">
      <TD class=Line1 colSpan=3></TD></TR>
  <TR>

	<TD vAlign=top>

	  <TABLE class=ViewForm>
        <COLGROUP>
		<COL width="30%">
  		<COL width="70%">
        <TBODY>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(581,user.getLanguage())%></TD>
          <TD class=Field>
      
              <INPUT type=hidden class="wuiBrowser" _displayText="<%=TradeInfoComInfo.getTradeInfoname(CRMSearchComInfo.getDebtorNumber())%>" _url="/systeminfo/BrowserMain.jsp?url=/CRM/Maint/TradeInfoBrowser.jsp" name="DebtorNumber" value="<%=CRMSearchComInfo.getDebtorNumber()%>"></TD>
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(580,user.getLanguage())%></TD>
          <TD class=Field>
        
              <INPUT type=hidden class="wuiBrowser" _displayText="<%=CreditInfoComInfo.getCreditInfoname(CRMSearchComInfo.getCreditorNumber())%>" _url="/systeminfo/BrowserMain.jsp?url=/CRM/Maint/CreditInfoBrowser.jsp" name="CreditorNumber" value="<%=CRMSearchComInfo.getCreditorNumber()%>"></TD>
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(110,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=50 size=30 name="CustomerAddress1" value="<%=CRMSearchComInfo.getCustomerAddress1()%>"></TD>
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(479,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=50 size=30 name="CustomerPostcode" value="<%=CRMSearchComInfo.getCustomerPostcode()%>"></TD>
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(421,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=50 size=30 name="CustomerTelephone" value="<%=CRMSearchComInfo.getCustomerTelephone()%>"></TD>
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(591,user.getLanguage())%></TD>
          <TD class=Field>
              <input type=hidden name="CustomerParent" class="wuiBrowser" _displayText="<%=CustomerInfoComInfo.getCustomerInfoname(CRMSearchComInfo.getCustomerParent())%>" _displayTemplate="<A href='/CRM/data/ViewCustomer.jsp?CustomerID=#b{id '>#b{name}</A>" _url="/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp" value="<%=CRMSearchComInfo.getCustomerParent()%>"></TD>
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>
       


        </TBODY>
	  </TABLE>

	</TD>

<td/>
	<TD vAlign=top>

	  <TABLE class=ViewForm>
        <COLGROUP>
		<COL width="30%">
  		<COL width="70%">
        <TBODY>
	<%if(!user.getLogintype().equals("2")){%>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(572,user.getLanguage())%>: <%=SystemEnv.getHtmlLabelName(144,user.getLanguage())%></TD>
          <TD class=Field>
              <INPUT class=wuiBrowser _displayTemplate="<A href='/hrm/resource/HrmResource.jsp?id=#b{id}'>#b{name}</A>" _displayText="<%=ResourceComInfo.getResourcename(CRMSearchComInfo.getContacterManager())%>" _url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp" type=hidden name="ContacterManager" value="<%=CRMSearchComInfo.getContacterManager()%>"></TD>
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>
	<%}%>
       
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(572,user.getLanguage())%>: <%=SystemEnv.getHtmlLabelName(477,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=50 size=30 name="ContacterEmail" value="<%=CRMSearchComInfo.getContacterEmail()%>"></TD>
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>

       
	  <input name="FirstNameDesc" type="hidden" value="2"><%//Modify by 杨国生 2004-10-25 For TD1259%>
	  <input name="LastNameDesc" type="hidden" value="2">

  </TBODY>
</TABLE>
</FORM>

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
<script language=javascript>


function onToSimple(){
weaver.destination.value="toSimple";
weaver.submit();
}
function onGoSearch(){
weaver.destination.value="goSearch";
weaver.submit();
}
</script>
</BODY>
</HTML>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>