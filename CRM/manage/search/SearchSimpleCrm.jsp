
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
<jsp:useBean id="CustomerStatusComInfo" class="weaver.crm.Maint.CustomerStatusComInfo" scope="page" />
<jsp:useBean id="ContactWayComInfo" class="weaver.crm.Maint.ContactWayComInfo" scope="page" />
<jsp:useBean id="CustomerSizeComInfo" class="weaver.crm.Maint.CustomerSizeComInfo" scope="page" />
<jsp:useBean id="CustomerDescComInfo" class="weaver.crm.Maint.CustomerDescComInfo" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page"/>



<%
//add by 徐蔚绛 2005-03-09 TD:1546
String actionKey=Util.null2String(request.getParameter("actionKey"));
String method=Util.null2String(request.getParameter("method"));
// if(method.equals("empty"))               // modify by liuyu to empty any where
// {
	CRMSearchComInfo.resetSearchInfo();
// }

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
session.setAttribute("serachrmmanager","");
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:onGoSearch(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(343,user.getLanguage())+",javascript:location.href='/CRM/search/Customize.jsp',_top} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(589,user.getLanguage())+",javascript:weaver.reset(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(347,user.getLanguage())+"&gt;&gt;,javascript:onToAdvanced(),_top} " ;
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

<FORM id=weaver action="/CRM/search/SearchOperationCrm.jsp" method=post>
<input type="hidden" name="destination" value="no">
<input type="hidden" name="searchtype" value="simple">
<input name="FirstNameDesc" type="hidden" value="2"><%//Modify by 杨国生 2004-10-25 For TD1259%>
<input name="LastNameDesc" type="hidden" value="2"> 
<%//add by 徐蔚绛 2005-03-09 TD:1546%>
<input name="actionKey" type="hidden" value="<%=actionKey%>"> 

<TABLE class=ViewForm>
  <COLGROUP>
  <COL width="49%">
  <COL width=10>
  <COL width="49%">
  <TBODY>
  <TR class=Spacing>
    <TD class=Line1 colSpan=3></TD></TR>
  <TR>

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
		</TR><tr><td class=Line1 colspan=2></td></tr>
	  </TBODY>
	</table>
	</TD>
  </TR>
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
        <TR class=Spacing>
          <TD class=Line1 colSpan=2></TD></TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=50 size=30 name="CustomerName" value="<%=CRMSearchComInfo.getCustomerName()%>"></TD>
        </TR><tr><td class=Line colspan=2></td></tr>

        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(377,user.getLanguage())%></TD>
          <TD class=Field>
          <BUTTON class=Browser id=SelectCountryID onclick="onShowCountryID()"></BUTTON>
              <SPAN id=countryidspan><%=CountryComInfo.getCountrydesc(CRMSearchComInfo.getCustomerCountry())%>
			  </SPAN>
              <INPUT id=CustomerCountry type=hidden name="CustomerCountry" value="<%=CRMSearchComInfo.getCustomerCountry()%>"></TD>
        </TR><tr><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(800,user.getLanguage())%></TD>
          <TD class=Field>
          <BUTTON class=Browser id=SelectProvinceID onclick="onShowProvinceID()"></BUTTON>
              <SPAN id=provinceidspan><%=ProvinceComInfo.getProvincename(CRMSearchComInfo.getCustomerProvince())%>
			  </SPAN>
              <INPUT id=CustomerProvince type=hidden name="CustomerProvince" value="<%=CRMSearchComInfo.getCustomerProvince()%>"></TD>
        </TR><tr><td class=Line colspan=2></td></tr>
		<TR>
          <TD><%=SystemEnv.getHtmlLabelName(493,user.getLanguage())%></TD>
          <TD class=Field>
	       <BUTTON class=Browser id=SelectCityID onclick="onShowCityID()"></BUTTON>
              <SPAN id=cityidspan STYLE="width=30%"><%=CityComInfo.getCityname(CRMSearchComInfo.getCustomerCity())%></SPAN>
              <INPUT id=CityCode type=hidden name="CustomerCity" value="<%=CRMSearchComInfo.getCustomerCity()%>">

		  </TD>
        </TR><tr><td class=Line colspan=2></td></tr>
        
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(25223,user.getLanguage())%></TD>
          <TD class=Field>
	       <INPUT id=citytwoCode class="wuiBrowser"  _url="/systeminfo/BrowserMain.jsp?url=/hrm/city/CityTwoBrowser.jsp" type=hidden name=citytwoCode >
	       <!--BUTTON class=Browser id=SelectCityTwoID onclick="onShowCityTwoID()"></BUTTON>
              <SPAN id=citytwoidspan STYLE="width=30%"></SPAN>
              <INPUT id=citytwoCode type=hidden name="citytwoCode" -->

		  </TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
        
		<TR>
          <TD><%=SystemEnv.getHtmlLabelName(277,user.getLanguage())%></TD>
          <TD class=Field>
			  <BUTTON class=calendar id=SelectDate onclick=getfromDate()></BUTTON>&nbsp;
			  <SPAN id=fromdatespan ><%=CRMSearchComInfo.getFromDate()%></SPAN>
			  <input type="hidden" name="fromdate" value=<%=CRMSearchComInfo.getFromDate()%>>
			  －<BUTTON class=calendar id=SelectDate onclick=getendDate()></BUTTON>&nbsp;
			  <SPAN id=enddatespan ><%=CRMSearchComInfo.getEndDate()%></SPAN>
			  <input type="hidden" name="enddate" value=<%=CRMSearchComInfo.getEndDate()%>>

		  </TD>
        </TR><tr><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(101,user.getLanguage())%></TD>
          <TD class=Field>
          <button class=Browser id=SelectProject onClick="onShowProject()"></button>
              <span class=InputStyle id=projectidspan><A href='/proj/data/ViewProject.jsp?ProjID=<%=CRMSearchComInfo.getPrjID()%>'><%=ProjectInfoComInfo.getProjectInfoname(CRMSearchComInfo.getPrjID())%></a>
			 </span>
              <input type=hidden name="PrjID" value="<%=CRMSearchComInfo.getPrjID()%>"></TD>
        </TR><tr><td class=Line colspan=2></td></tr>
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
        <TR class=Spacing>
          <TD class=Line1 colSpan=2></TD></TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=50 size=30 name="ContacterFirstName" value="<%=CRMSearchComInfo.getContacterFirstName()%>"></TD>
        </TR><tr><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(475,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=50 size=30 name="ContacterLastName" value="<%=CRMSearchComInfo.getContacterLastName()%>"></TD>
        </TR><tr><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(671,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=inputstyle name=age size=5 maxlength=3  onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("age")' value=""><%=SystemEnv.getHtmlLabelName(15864,user.getLanguage())%>－
            <INPUT class=inputstyle name=ageTo size=5 maxlength=3  onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("ageTo")' value=""><%=SystemEnv.getHtmlLabelName(15864,user.getLanguage())%>
          </TD>
        </TR><tr><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(1887,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=100 size=30 name="IDCard" onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("IDCard")'  value="<%=CRMSearchComInfo.getContacterIDCard()%>"></TD>
        </TR><tr><td class=Line colspan=2></td></tr>
        </TBODY>
	  </TABLE>

	</TD>


	<TD vAlign=top>

	  <TABLE class=ViewForm>
        <COLGROUP>
		<COL width="30%">
  		<COL width="70%">
        <TBODY>
        <TR class=Title>
            <TH colSpan=2><%=SystemEnv.getHtmlLabelName(16378,user.getLanguage())%></TH>
          </TR>
        <TR class=Spacing>
          <TD class=Line1 colSpan=2></TD></TR>
	<%if(!user.getLogintype().equals("2")){%>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></TD>
          <TD class=Field>
          <button class=Browser id=SelectDeparment onClick="onShowDepartment()"></button>
              <span class=InputStyle id=departmentspan><%=DepartmentComInfo.getDepartmentname(CRMSearchComInfo.getCustomerRegion())%></span>
              <input id=CustomerRegion type=hidden name="CustomerRegion" value="<%=CRMSearchComInfo.getCustomerRegion()%>"></TD>
        </TR><tr><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(136,user.getLanguage())%>: <%=SystemEnv.getHtmlLabelName(144,user.getLanguage())%></TD>
          <TD class=Field>
          <BUTTON class=Browser id=SelectManagerID onClick="onShowAccountManager()"></BUTTON> <span
            id=AccountManagerspan><%=ResourceComInfo.getResourcename(CRMSearchComInfo.getAccountManager())%></span>
              <INPUT class=InputStyle type=hidden name="AccountManager" value="<%=CRMSearchComInfo.getAccountManager()%>"><INPUT name="notmanager" type="checkbox" value="1">不等于</TD>
        </TR><tr><td class=Line colspan=2></td></tr>
	<%}%>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(15239,user.getLanguage())%></TD>
          <TD class=Field><button class=Browser id=SelectDeparment onClick="onShowAgent()"></button>
              <span class=InputStyle id=Agentspan><%=CustomerInfoComInfo.getCustomerInfoname(CRMSearchComInfo.getCustomerOrigin())%></span>
              <input type=hidden name="CustomerOrigin" value="<%=CRMSearchComInfo.getCustomerOrigin()%>"></TD>
        </TR><tr><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></TD>
          <TD class=Field><BUTTON class=Browser onclick="onShowStatusID()"></BUTTON>
              <SPAN id=Statusspan><%=CustomerStatusComInfo.getCustomerStatusname(CRMSearchComInfo.getCustomerStatus())%>
			  </SPAN>
              <INPUT type=hidden name="CustomerStatus" value="<%=CRMSearchComInfo.getCustomerStatus()%>"></TD>
        </TR><tr><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(575,user.getLanguage())%></TD>
          <TD class=Field>
          <BUTTON class=Browser onclick="onShowSectorID()"></BUTTON>
              <SPAN id=Sectorspan><%=SectorInfoComInfo.getSectorInfoname(CRMSearchComInfo.getCustomerSector())
			  %>
			  </SPAN>
              <INPUT type=hidden name="CustomerSector" value="<%=CRMSearchComInfo.getCustomerSector()%>"></TD>
        </TR><tr><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></TD>
          <TD class=Field>
          <BUTTON class=Browser onclick="onShowDescriptionID()"></BUTTON>
              <SPAN id=Descriptionspan><%=CustomerDescComInfo.getCustomerDescname(CRMSearchComInfo.getCustomerDesc())%></SPAN>
              <INPUT type=hidden name="CustomerDesc" value="<%=CRMSearchComInfo.getCustomerDesc()%>"></TD>
        </TR><tr><td class=Line colspan=2></td></tr>

        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(15240,user.getLanguage())%></TD>
          <TD class=Field><BUTTON class=Browser onclick="onShowSourceID()"></BUTTON>
              <SPAN id=Sourcespan><%=ContactWayComInfo.getContactWaydesc(CRMSearchComInfo.getContactWay())%>
			  </SPAN>
              <INPUT type=hidden name="ContactWay" value="<%=CRMSearchComInfo.getContactWay()%>"></TD>
        </TR><tr><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(576,user.getLanguage())%></TD>
          <TD class=Field><BUTTON class=Browser onclick="onShowSizeID()"></BUTTON>
              <SPAN id=Sizespan><%=CustomerSizeComInfo.getCustomerSizedesc(CRMSearchComInfo.getCustomerSize())
			  %></SPAN>
              <INPUT type=hidden name="CustomerSize" value="<%=CRMSearchComInfo.getCustomerSize()%>"></TD>
        </TR><tr><td class=Line colspan=2></td></tr>
        </TBODY>
	  </TABLE>

	</TD>
  </TR>
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
function onToAdvanced(){
weaver.destination.value="toAdvanced";
weaver.submit();
}
function onGoSearch(){
weaver.destination.value="goSearch";
weaver.submit();
}
</script>

<script language=vbs>
sub onShowCountryID()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/country/CountryBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	countryidspan.innerHtml = id(1)
	weaver.CustomerCountry.value=id(0)
	else
	countryidspan.innerHtml = ""
	weaver.CustomerCountry.value="0"
	end if
	end if
end sub

sub onShowDepartment()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="&weaver.CustomerRegion.value)
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	departmentspan.innerHtml = id(1)
	weaver.CustomerRegion.value=id(0)
	else
	departmentspan.innerHtml = ""
	weaver.CustomerRegion.value="0"
	end if
	end if
end sub

sub onShowSizeID()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/Maint/CustomerSizeBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	Sizespan.innerHtml = id(1)
	weaver.Size.value=id(0)
	else
	Sizespan.innerHtml = ""
	weaver.Size.value="0"
	end if
	end if
end sub

sub onShowSourceID()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/Maint/ContactWayBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	Sourcespan.innerHtml = id(1)
	weaver.Source.value=id(0)
	else
	Sourcespan.innerHtml = ""
	weaver.Source.value="0"
	end if
	end if
end sub

sub onShowSectorID()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/Maint/SectorInfoBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	Sectorspan.innerHtml = id(1)
	weaver.CustomerSector.value=id(0)
	else
	Sectorspan.innerHtml = ""
	weaver.CustomerSector.value=""
	end if
	end if
end sub

sub onShowDescriptionID()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/Maint/CustomerDescBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	Descriptionspan.innerHtml = id(1)
	weaver.CustomerDesc.value=id(0)
	else
	Descriptionspan.innerHtml = ""
	weaver.CustomerDesc.value="0"
	end if
	end if
end sub
sub onShowCityID()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/city/CityBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	cityidspan.innerHtml = id(1)
	weaver.CustomerCity.value=id(0)
	else
	cityidspan.innerHtml = ""
	weaver.CustomerCity.value=""
	end if
	end if
end sub

sub onShowProvinceID()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/province/ProvinceBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	provinceidspan.innerHtml = id(1)
	weaver.CustomerProvince.value=id(0)
	else
	provinceidspan.innerHtml = ""
	weaver.CustomerProvince.value=""
	end if
	end if
end sub
sub onShowStatusID()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/Maint/CustomerStatusBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	Statusspan.innerHtml = id(1)
	weaver.CustomerStatus.value=id(0)
	else
	Statusspan.innerHtml = ""
	weaver.CustomerStatus.value="0"
	end if
	end if
end sub
sub onShowAccountManager()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	AccountManagerspan.innerHtml = "<A href='/hrm/resource/HrmResource.jsp?id="&id(0)&"'>"&id(1)&"</A>"
	resourceids = Mid(id(0),2,len(id(0)))
	weaver.AccountManager.value=resourceids
	else
	AccountManagerspan.innerHtml = ""
	weaver.AccountManager.value="0"
	end if
	end if
end sub
sub onShowAgent()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp?sqlwhere=where t1.type in (3,4,11,12,13,14,15,16,17,18,20,21,25,19)")

	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	Agentspan.innerHtml = "<A href='/CRM/data/ViewCustomer.jsp?CustomerID="&id(0)&"'>"&id(1)&"</A>"
	weaver.CustomerOrigin.value=id(0)
	else
	Agentspan.innerHtml = ""
	weaver.CustomerOrigin.value="0"
	end if
	end if
end sub
sub onShowSourceID()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/Maint/ContactWayBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	Sourcespan.innerHtml = id(1)
	weaver.ContactWay.value=id(0)
	else
	Sourcespan.innerHtml = ""
	weaver.ContactWay.value="0"
	end if
	end if
end sub
sub onShowSizeID()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/Maint/CustomerSizeBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	Sizespan.innerHtml = id(1)
	weaver.CustomerSize.value=id(0)
	else
	Sizespan.innerHtml = ""
	weaver.CustomerSize.value="0"
	end if
	end if
end sub

sub onShowProject()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/proj/data/ProjectBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	projectidspan.innerHtml = "<A href='/proj/data/ViewProject.jsp?ProjID="&id(0)&"'>"&id(1)&"</A>"
	weaver.PrjID.value=id(0)
	else
	projectidspan.innerHtml = ""
	weaver.PrjID.value="0"
	end if
	end if
end sub
</script>
</BODY>
</HTML>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>