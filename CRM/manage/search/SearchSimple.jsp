
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

<FORM id=weaver name="weaver" action="/CRM/search/SearchOperation.jsp" method=post>
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
  <TR class=Spacing style="height: 1px">
    <TD class=Line1 colSpan=3></TD>
  </TR>

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
		</TR><tr style="height: 1px"><td class=Line1 colspan=2></td></tr>
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
        <TR class=Spacing style="height: 1px">
          <TD class=Line1 colSpan=2></TD></TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=50 size=30 name="CustomerName" value="<%=CRMSearchComInfo.getCustomerName()%>"></TD>
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>

        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(377,user.getLanguage())%></TD>
          <TD class=Field>
          <INPUT class="wuiBrowser" _displayText="<%=CountryComInfo.getCountrydesc(CRMSearchComInfo.getCustomerCountry())%>" _url="/systeminfo/BrowserMain.jsp?url=/hrm/country/CountryBrowser.jsp" id=CustomerCountry type=hidden name="CustomerCountry" value="<%=CRMSearchComInfo.getCustomerCountry()%>"></TD>
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>



        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(800,user.getLanguage())%></TD>
          <TD class=Field>
          
              <INPUT class="wuiBrowser" _displayText="<%=ProvinceComInfo.getProvincename(CRMSearchComInfo.getCustomerProvince())%>" _url="/systeminfo/BrowserMain.jsp?url=/hrm/province/ProvinceBrowser.jsp" id=CustomerProvince type=hidden name="CustomerProvince" value="<%=CRMSearchComInfo.getCustomerProvince()%>"></TD>
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>


		<TR>
          <TD><%=SystemEnv.getHtmlLabelName(493,user.getLanguage())%></TD>
          <TD class=Field>
	       <INPUT class="wuiBrowser" _displayText="<%=CityComInfo.getCityname(CRMSearchComInfo.getCustomerCity())%>" _url="/systeminfo/BrowserMain.jsp?url=/hrm/city/CityBrowser.jsp" id=CityCode type=hidden name="CustomerCity" value="<%=CRMSearchComInfo.getCustomerCity()%>">



		  </TD>
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>
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
			  <BUTTON type="button" class=calendar id=SelectDate onclick=getfromDate()></BUTTON>&nbsp;
			  <SPAN id=fromdatespan ><%=CRMSearchComInfo.getFromDate()%></SPAN>
			  <input type="hidden" name="fromdate" value=<%=CRMSearchComInfo.getFromDate()%>>
			  －<BUTTON type="button" class=calendar id=SelectDate onclick=getendDate()></BUTTON>&nbsp;
			  <SPAN id=enddatespan ><%=CRMSearchComInfo.getEndDate()%></SPAN>
			  <input type="hidden" name="enddate" value=<%=CRMSearchComInfo.getEndDate()%>>

		  </TD>
        </TR><tr style="height: 1px"> <td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(101,user.getLanguage())%></TD>
          <TD class=Field>
      
              <input class="wuiBrowser" _displayText="<A href='/proj/data/ViewProject.jsp?ProjID=<%=CRMSearchComInfo.getPrjID()%>'><%=ProjectInfoComInfo.getProjectInfoname(CRMSearchComInfo.getPrjID())%>" _displayTemplate="<A href='/proj/data/ViewProject.jsp?ProjID=#b{id}'>#b{name}</A>" _url="/systeminfo/BrowserMain.jsp?url=/proj/data/ProjectBrowser.jsp" type=hidden name="PrjID" value="<%=CRMSearchComInfo.getPrjID()%>"></TD>
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>

		<!-- 增加客户编号及其他名称查询条件 QC58544 -->
		<TR>
          <TD><%=SystemEnv.getHtmlLabelName(17080,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=50 size=30 name="crmcode" value="<%=CRMSearchComInfo.getCustomerCode()%>"></TD>
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>
        <TR>
          <TD>正式名称</TD>
          <TD class=Field><INPUT class=InputStyle maxLength=50 size=30 name="othername" value=""></TD>
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>
        <TR>
          <TD>签约名称</TD>
          <TD class=Field><INPUT class=InputStyle maxLength=50 size=30 name="signname" value=""></TD>
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>
		<TR title="对客户名称、正式名称、签约名称进行查询，其中任何一个满足条件即可">
          <TD>所有名称</TD>
          <TD class=Field><INPUT class=InputStyle maxLength=50 size=30 name="allname" value=""></TD>
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
            <TH colSpan=2><%=SystemEnv.getHtmlLabelName(16378,user.getLanguage())%></TH>
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
          <TD><%=SystemEnv.getHtmlLabelName(15239,user.getLanguage())%></TD>
          <TD class=Field>
              <input class="wuiBrowser" _displayTemplate="<A href='/CRM/data/ViewCustomer.jsp?CustomerID=#b{id}'>#b{name}</A>" _displayText="<%=CustomerInfoComInfo.getCustomerInfoname(CRMSearchComInfo.getCustomerOrigin())%>" _url="/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp?sqlwhere=where t1.type in (3,4,11,12,13,14,15,16,17,18,20,21,25,19)" type=hidden name="CustomerOrigin" value="<%=CRMSearchComInfo.getCustomerOrigin()%>"></TD>
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>

        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%>, <%=SystemEnv.getHtmlLabelName(139,user.getLanguage())%></TD>
          <TD class=Field>
              <INPUT type=hidden class="wuiBrowser" _displayText="<%=CustomerStatusComInfo.getCustomerStatusname(CRMSearchComInfo.getCustomerStatus())%>" _url="/systeminfo/BrowserMain.jsp?url=/CRM/Maint/CustomerStatusBrowser.jsp" name="CustomerStatus" value="<%=CRMSearchComInfo.getCustomerStatus()%>">
          	  &nbsp;&nbsp;
          	  <select name="CustomerRating">
          	  	  <option value=""></option>
		  	  	  <option value="1" <%if(CRMSearchComInfo.getCustomerRating().equals("1")){%>selected<%}%>>1</option>
				  <option value="2" <%if(CRMSearchComInfo.getCustomerRating().equals("2")){%>selected<%}%>>2</option>
				  <option value="3" <%if(CRMSearchComInfo.getCustomerRating().equals("3")){%>selected<%}%>>3</option>
				  <option value="4" <%if(CRMSearchComInfo.getCustomerRating().equals("4")){%>selected<%}%>>4</option>
				  <option value="5" <%if(CRMSearchComInfo.getCustomerRating().equals("5")){%>selected<%}%>>5</option>
				  <option value="6" <%if(CRMSearchComInfo.getCustomerRating().equals("6")){%>selected<%}%>>6</option>
				  <option value="7" <%if(CRMSearchComInfo.getCustomerRating().equals("7")){%>selected<%}%>>7</option>
			  </select>    
          </TD>
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>


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
              <INPUT type=hidden class="wuiBrowser" _displayText="<%=ContactWayComInfo.getContactWaydesc(CRMSearchComInfo.getContactWay())%>" _url="/systeminfo/BrowserMain.jsp?url=/CRM/Maint/ContactWayBrowser.jsp" name="ContactWay" value="<%=CRMSearchComInfo.getContactWay()%>"></TD>
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>


        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(576,user.getLanguage())%></TD>
          <TD class=Field>
              <INPUT type=hidden class="wuiBrowser" _displayText="<%=CustomerSizeComInfo.getCustomerSizedesc(CRMSearchComInfo.getCustomerSize())%>" _url="/systeminfo/BrowserMain.jsp?url=/CRM/Maint/CustomerSizeBrowser.jsp" name="CustomerSize" value="<%=CRMSearchComInfo.getCustomerSize()%>"></TD>
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>
        
        <%if("batchShare".equals(actionKey)){//批量共享增加是否有客服负责人查询条件 %>
        	<TR>
          		<TD>是否有客服负责人</TD>
          		<TD class=Field>
              		<select name="iscs">
              			<option value=""></option>
              			<option value="1"><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%></option>
              			<option value="0"><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%></option>
              		</select>
              	</TD>
        	</TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>
        <%} %>
        
        <!-- 联系记录相关查询条件 edited by 丁坤宇 2011-10-31 TD:16057 -->
        <%if(!user.getLogintype().equals("2")){%>
        <TR class=Title>
            <TH colSpan=2><%=SystemEnv.getHtmlLabelName(17532,user.getLanguage())%></TH>
        </TR>
        <TR class=Spacing><TD class=Line1 colSpan=2></TD></TR>
        <TR title="联系无效是指由于电话无效或无人接听等原因没有和客户的关键人员取得有效联系（可在客户卡片“客户联系提醒”页面中进行设置）">
        	<TD>是否联系无效</TD>
          	<TD class=Field>
          		<select name="invalid">
          			<option value=""></option>
					<option value="1"><%=SystemEnv.getHtmlLabelName(163, user.getLanguage())%></option>
					<option value="0"><%=SystemEnv.getHtmlLabelName(161, user.getLanguage())%></option>
				</select>
		  	</TD>
		</TR>
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>
        <TR title="是否需再联系是指后续是否需要再次与用户进行联系，可按联系日期进行查询（可在客户卡片“客户联系提醒”页面中进行设置）">
        	<TD>是否需再联系</TD>
			<TD class=Field>
				<select id="isContact" name="isContact" onchange="changeContactStatus()">
					<option value="" ></option>
					<option value="1" ><%=SystemEnv.getHtmlLabelName(163, user.getLanguage())%></option>
					<option value="0" ><%=SystemEnv.getHtmlLabelName(161, user.getLanguage())%></option>
				</select>
				&nbsp;&nbsp;
				<span id="contactDateSpan" style="display: none">
					再联系日期：
					<BUTTON type="button" class=Calendar onclick="gettheDate(contactDateFrom,contactDateFromSpan)"></BUTTON>
					<SPAN id=contactDateFromSpan></SPAN>
					<input class=inputstyle type="hidden" id="contactDateFrom" name="contactDateFrom"/>
					-
					&nbsp;
					<BUTTON type="button" class=Calendar onclick="gettheDate(contactDateTo,contactDateToSpan)"></BUTTON>
					<SPAN id=contactDateToSpan></SPAN>
					<input class=inputstyle type="hidden" id="contactDateTo" name="contactDateTo"/>
				</span>
			</TD>
        </TR>
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>
        <TR title="未联系日期是指查询某段时间内没有联系记录的客户">
        	<TD><%=SystemEnv.getHtmlLabelName(25348,user.getLanguage())%></TD>
        	<TD class=Field>
			  <BUTTON type="button" class=calendar id=SelectDate onclick="gettheDate('noContactFrom','noContactFromSpan')"></BUTTON>&nbsp;
			  <SPAN id=noContactFromSpan ></SPAN>
			  <input type="hidden" name="noContactFrom" >
			  －<BUTTON type="button" class=calendar id=SelectDate onclick="gettheDate('noContactTo','noContactToSpan')"></BUTTON>&nbsp;
			  <SPAN id=noContactToSpan ></SPAN>
			  <input type="hidden" name="noContactTo" >
		  	</TD>
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>
        <%} %>
	
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
function changeContactStatus(){
	var v = $("#isContact").val();
	if(v==1){
		$("#contactDateSpan").show();
	}else{
		$("#contactDateSpan").hide();
		$("#contactDateFrom").val("");
		$("#contactDateFromSpan").html("");
		$("#contactDateTo").val("");
		$("#contactDateToSpan").html("");
	}
}
</script>

</BODY>
</HTML>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>