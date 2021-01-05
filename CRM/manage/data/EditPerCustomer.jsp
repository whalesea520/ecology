
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetFF" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetShare" class="weaver.conn.RecordSet" scope="page" />

<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="CheckUserRight" class="weaver.systeminfo.systemright.CheckUserRight" scope="page" />

<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="CustomerTypeComInfo" class="weaver.crm.Maint.CustomerTypeComInfo" scope="page" />
<jsp:useBean id="CustomerDescComInfo" class="weaver.crm.Maint.CustomerDescComInfo" scope="page" />
<jsp:useBean id="CustomerSizeComInfo" class="weaver.crm.Maint.CustomerSizeComInfo" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="ContactWayComInfo" class="weaver.crm.Maint.ContactWayComInfo" scope="page" />
<jsp:useBean id="SectorInfoComInfo" class="weaver.crm.Maint.SectorInfoComInfo" scope="page" />
<jsp:useBean id="CustomerRatingComInfo" class="weaver.crm.Maint.CustomerRatingComInfo" scope="page" />
<jsp:useBean id="CustomerStatusComInfo" class="weaver.crm.Maint.CustomerStatusComInfo" scope="page" />
<jsp:useBean id="CountryComInfo" class="weaver.hrm.country.CountryComInfo" scope="page"/>
<jsp:useBean id="ProvinceComInfo" class="weaver.hrm.province.ProvinceComInfo" scope="page"/>
<jsp:useBean id="CityComInfo" class="weaver.hrm.city.CityComInfo" scope="page"/>
<jsp:useBean id="LanguageComInfo" class="weaver.systeminfo.language.LanguageComInfo" scope="page"/>
<jsp:useBean id="ContacterTitleComInfo" class="weaver.crm.Maint.ContacterTitleComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />
<jsp:useBean id="CurrencyComInfo" class="weaver.fna.maintenance.CurrencyComInfo" scope="page"/>
<jsp:useBean id="TradeInfoComInfo" class="weaver.crm.Maint.TradeInfoComInfo" scope="page" />
<jsp:useBean id="CreditInfoComInfo" class="weaver.crm.Maint.CreditInfoComInfo" scope="page" />
<jsp:useBean id="DeliveryTypeComInfo" class="weaver.crm.Maint.DeliveryTypeComInfo" scope="page" />
<jsp:useBean id="PaymentTermComInfo" class="weaver.crm.Maint.PaymentTermComInfo" scope="page" />
<jsp:useBean id="RecordSetV" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page" />

<%
String CustomerID = Util.null2String(request.getParameter("CustomerID"));
boolean isfromtab = "true".equals(Util.null2String(request.getParameter("isfromtab")));
String Creater = "";
String CreaterType = "";
String CreateDate = "";
RecordSet.executeProc("CRM_Find_Creater",CustomerID);
if(RecordSet.first()){
	Creater = Util.toScreen(RecordSet.getString("submiter"),user.getLanguage());
	CreaterType = Util.toScreen(RecordSet.getString("submitertype"),user.getLanguage());
	CreateDate = RecordSet.getString("submitdate");
}

String Modifier = "";
String ModifierType = "";
String ModifyDate = "";
//RecordSet.executeProc("CRM_Find_LastModifier",CustomerID); Modified by xwj for td:1242 on 2005-03-16
String sqlModifier = "select submiter,submitdate,submitertype,submittime from CRM_Log " +
"where customerid ='" + CustomerID + "' and logtype <> 'n' and submitdate = (select max(submitdate) from CRM_Log where customerid ='" + CustomerID + "' and logtype <> 'n') " +
"order by submittime desc";
RecordSet.executeSql(sqlModifier);
if(RecordSet.first()){
	Modifier = Util.toScreen(RecordSet.getString("submiter"),user.getLanguage());
	ModifierType = Util.toScreen(RecordSet.getString("submitertype"),user.getLanguage());
	ModifyDate = RecordSet.getString("submitdate");
}

RecordSet.executeProc("CRM_CustomerInfo_SelectByID",CustomerID);
if(RecordSet.getCounts()<=0)
{
	response.sendRedirect("/base/error/DBError.jsp?type=FindData");
	return;
}
RecordSet.first();

String bankName = RecordSet.getString("bankName");
String accountName = RecordSet.getString("accountName");
String accounts = RecordSet.getString("accounts");
String crmCode = RecordSet.getString("crmcode");

/*权限判断－－Begin*/

String useridcheck=""+user.getUID();
String customerDepartment=""+RecordSet.getString("department") ;
boolean canedit=false;
boolean isCustomerSelf=false;

//String ViewSql="select * from CrmShareDetail where crmid="+CustomerID+" and usertype=1 and userid="+user.getUID();

//RecordSetV.executeSql(ViewSql);

//if(RecordSetV.next())
//{
//	 if(RecordSetV.getString("sharelevel").equals("2") || RecordSetV.getString("sharelevel").equals("3") || RecordSetV.getString("sharelevel").equals("4")){
//		canedit=true;	
//	 }
//}
int sharelevel = CrmShareBase.getRightLevelForCRM(""+user.getUID(),CustomerID);
if(sharelevel>1) canedit=true;	

if(user.getLogintype().equals("2") && CustomerID.equals(useridcheck)){
isCustomerSelf = true ;
}
if(useridcheck.equals(RecordSet.getString("agent"))){ 
	 canedit=true;
 }

if(RecordSet.getInt("status")==7 || RecordSet.getInt("status")==8){
	canedit=false;
}

/*权限判断－－End*/

if(!canedit && !isCustomerSelf) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
 }

boolean hasFF = true;
RecordSetFF.executeProc("Base_FreeField_Select","c1");
if(RecordSetFF.getCounts()<=0)
	hasFF = false;
else
	RecordSetFF.first();
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
<script language=javascript >
function checkSubmit(obj){
	window.onbeforeunload=null;
	if(check_form(weaver,"Name,Phone")){
		obj.disabled = true; 
		weaver.submit();
	}else {
		var poneValue=weaver.Phone.value;
		if(poneValue==""){
			checkinput("Phone","Phoneimage")
		}
	}
}
function ondelete(){
	if(isdel()){
	window.onbeforeunload=null;
	weaver.method.value="delete";
	weaver.submit();
	}
}

function onReturn(){
	window.onbeforeunload=null;
	window.location="/CRM/data/ViewPerCustomer.jsp?log=n&CustomerID=<%=CustomerID%>"
	
}

function protectCus(){
	if(!checkDataChange())//added by cyril on 2008-06-13 for TD:8828
		event.returnValue="<%=SystemEnv.getHtmlLabelName(18675,user.getLanguage())%>";
}
</script>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(136,user.getLanguage())+SystemEnv.getHtmlLabelName(647,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+" - "+Util.toScreen(RecordSet.getString("name"),user.getLanguage());


String temStr="";
/* ------Modified by XWJ	for td:1242 on 2005-03-16 --------- begin ----------*/
	
	temStr+="<B>"+SystemEnv.getHtmlLabelName(401,user.getLanguage())+":</B>"+CreateDate+"<B> "+SystemEnv.getHtmlLabelName(623,user.getLanguage())+":</B>";
		temStr+=ResourceComInfo.getClientDetailModifier(Creater,CreaterType,user.getLogintype());
		/*
		if(!user.getLogintype().equals("2")){
			if(!CreaterType.equals("2")){
				temStr+=Util.toScreen(ResourceComInfo.getResourcename(Creater),user.getLanguage());
			}else{
                temStr+=Util.toScreen(ResourceComInfo.getResourcename(Creater),user.getLanguage());
			}
		}else{
			if(!CreaterType.equals("2")){
				temStr+=Util.toScreen(ResourceComInfo.getResourcename(Creater),user.getLanguage()) ;
			}else{
                temStr+=Util.toScreen(ResourceComInfo.getResourcename(Creater),user.getLanguage());
			} 
		}
		*/
	temStr+="<B>"+SystemEnv.getHtmlLabelName(103,user.getLanguage())+":</B>"+ModifyDate+"<B> "+SystemEnv.getHtmlLabelName(623,user.getLanguage())+":</B>";
		temStr+=ResourceComInfo.getClientDetailModifier(Modifier,ModifierType,user.getLogintype());
		/*
		if(!user.getLogintype().equals("2")){
			if(!ModifierType.equals("2")){
				temStr+=Util.toScreen(ResourceComInfo.getResourcename(Modifier),user.getLanguage());
			}else{
                temStr+=Util.toScreen(ResourceComInfo.getResourcename(Modifier),user.getLanguage());
			}
		}else{
			if(!ModifierType.equals("2")){
				temStr+=Util.toScreen(ResourceComInfo.getResourcename(Creater),user.getLanguage()) ;
			}else{
                temStr+=Util.toScreen(ResourceComInfo.getResourcename(Creater),user.getLanguage());
			} 
		}
    */
/* ------Modified by XWJ	for td:1242 on 2005-03-16 --------- end ----------*/





titlename += "  "+temStr;


String needfav ="1";
String needhelp ="";
%>
<BODY onbeforeunload="protectCus()">
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:checkSubmit(this),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(589,user.getLanguage())+",javascript:document.weaver.reset(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:onReturn(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>

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



<FORM id=weaver name="weaver" action="/CRM/data/CustomerPerOperation.jsp" method=post onsubmit='return check_form(this,"Name,Phone")'>
<input type="hidden" name="method" value="editPer">
<input type="hidden" name="CustomerID" value="<%=CustomerID%>">
<input type="hidden" name="isfromtab" value="<%=isfromtab%>">
<DIV>
	<BUTTON class=btnSave accessKey=S  style="display:none" id=domysave  type=submit><U>S</U>-<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%></BUTTON>
<% 
	if(HrmUserVarify.checkUserRight("EditCustomer:Delete",user,customerDepartment)){
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:ondelete(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
	<BUTTON type="button" class=btnDelete id=Delete accessKey=D  style="display:none" id=domysave  onclick="ondelete();"><U>D</U>-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></BUTTON>
<%}%>
</DIV>


  <TABLE class=ViewForm>
        <COLGROUP>
		<COL width="30%">
  		<COL width="70%">
        <TBODY>
        <TR class=Title>
            <TH colSpan=2><%=SystemEnv.getHtmlLabelName(154,user.getLanguage())%></TH>
          </TR>
         <TR class=Spacing style='height:1px'>
          <TD class=Line1 colSpan=2></TD></TR>
        
    
     <%--Modified by xwj for td1552 on 2005-03-22
		<TR>
          <TD><%=SystemEnv.getHtmlLabelName(412,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=50 name="PortalLoginID" onchange='checkinput("PortalLoginID","PortalLoginIDimage")' STYLE="width:95%" value='<%=Util.null2String(RecordSet.getString("PortalLoginID"))%>'>
		  <SPAN id=PortalLoginIDimage></SPAN></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
        
      <%--Modified by xwj for td1552 on 2005-03-22
	  <TR> 
		 <TD><%=SystemEnv.getHtmlLabelName(409,user.getLanguage())%></TD>
          <TD class=Field><INPUT onchange='checkinput("PortalPassword","PortalPasswordimage")' class=InputStyle maxLength=50 name="PortalPassword" STYLE="width:95%" value="<%=Util.null2String(RecordSet.getString("PortalPassword"))%>">
		  <SPAN id=PortalPasswordimage></SPAN></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
    --%>
        
	   <%--????--%>
	   
	
		<%--??--%>
		<TR>
          <TD><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=50 name="Name" onchange='checkinput("Name","Nameimage")' STYLE="width:95%" value='<%=Util.toScreen(Util.null2String(RecordSet.getString("name")),user.getLanguage(),"0")%>'>
		  <SPAN id=Nameimage><%if("".equals(Util.null2String(RecordSet.getString("Name")))) {%><IMG src="/images/BacoError_wev8.gif" align=absMiddle><%}%></SPAN></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
		<%--??--%>
		<TR>
          <TD><%=SystemEnv.getHtmlLabelName(416,user.getLanguage())%></TD>
		  <TD class="Field">
		  <Select name="Sex">
			<option value="0" <%if("0".equals(Util.null2String(RecordSet.getString("Sex")))){%>Selected<%}%>><%=SystemEnv.getHtmlLabelName(417,user.getLanguage())%></option>
			<option value="1" <%if("1".equals(Util.null2String(RecordSet.getString("Sex")))){%>Selected<%}%>><%=SystemEnv.getHtmlLabelName(418,user.getLanguage())%></option>
		  </Select></TD>
		  
		</TR>
		<%--????--%>
		<TR>
          <TD>公司名称和职务<!-- <%=SystemEnv.getHtmlLabelName(1887,user.getLanguage())%> --></TD>
		  <TD class="Field">
			<INPUT maxLength=150 class=InputStyle name="IDCardNo" STYLE="width:95%" onKeyPress="" <%--onchange='checkinput("IDCardNo","IDCardNoimage")'--%> value="<%=Util.null2String(RecordSet.getString("IDCardNo"))%>">
			 <SPAN id=IDCardNoimage><%--if("".equals(Util.null2String(RecordSet.getString("IDCardNo")))) {%><IMG src="/images/BacoError_wev8.gif" align=absMiddle><%}--%> </SPAN>
		  </TD>
		</TR>
		<tr  style="height: 1px"><td class=Line colspan=2></td></tr>
		<%--??--%>
		<TD><%=SystemEnv.getHtmlLabelName(493,user.getLanguage())%></TD>
          <TD class=Field>
              <INPUT id=CityCode class="wuiBrowser" _displayText="<%=CityComInfo.getCityname(Util.null2String(RecordSet.getString("City")))%>"
               _url="/systeminfo/BrowserMain.jsp?url=/hrm/city/CityBrowser.jsp" type=hidden name=City value="<%=Util.toScreenToEdit(RecordSet.getString("city"),user.getLanguage())%>">          
            <SPAN STYLE="width:1%"></SPAN></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>    
       <%--????--%>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(421,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=50 name="Phone" STYLE="width:45%" onKeyPress="ItemPhone_KeyPress()" onBlur='<%--checknumber("Phone");--%>checkinput("Phone","Phoneimage")' value="<%=Util.null2String(RecordSet.getString("Phone"))%>"><SPAN id=Phoneimage><%--if("".equals(Util.null2String(RecordSet.getString("Phone")))) {%><IMG src="/images/BacoError_wev8.gif" align=absMiddle><%}--%></SPAN></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>  
	    <%--??--%>
		<TR>
          <TD><%=SystemEnv.getHtmlLabelName(110,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=50 name="Address1" onchange='<%--checkinput("Address1","Address1image")--%>' STYLE="width:95%" value="<%=Util.null2String(RecordSet.getString("Address1"))%>"><SPAN id=Address1image><%--if("".equals(Util.null2String(RecordSet.getString("Address1")))) {%><IMG src="/images/BacoError_wev8.gif" align=absMiddle><%}--%></SPAN></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>        
           
          <TR>
          <TD><%=SystemEnv.getHtmlLabelName(477,user.getLanguage())%></TD>
          <TD class=Field>
		  <INPUT maxLength=150 class=InputStyle name="Email" onblur='checkinput_email_only("Email","Emailimage",false)' STYLE="width:95%" value="<%=Util.null2String(RecordSet.getString("Email"))%>">
		  <SPAN id=Emailimage> <%--if("".equals(Util.null2String(RecordSet.getString("Email")))) {%><IMG src="/images/BacoError_wev8.gif" align=absMiddle><%}--%> </SPAN>
		  </TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>    
     
        </TBODY>
	  </TABLE>

<%--
<TABLE class=ViewForm>
  <COLGROUP>
  <COL width="49%">
  <COL width=10>
  <COL width="49%">
  <TBODY>
  <TR>

	<TD vAlign=top>
	
	  <TABLE class=ViewForm>
        <COLGROUP>
		<COL width="30%">
  		<COL width="70%">
        <TBODY>
        <TR class=Title>
            <TH colSpan=2><%=SystemEnv.getHtmlLabelName(154,user.getLanguage())%></TH>
          </TR>
         <TR class=Spacing style='height:1px'>
          <TD class=Line1 colSpan=2></TD></TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=50 size=30 name="Name"  onchange='checkinput("Name","Nameimage")' value="<%=Util.toScreenToEdit(RecordSet.getString("name"),user.getLanguage())%>" STYLE="width:95%"><SPAN id=Nameimage></SPAN></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
        <!--add CRM CODE by lupeng 2004.03.30-->
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(17080,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=50 name="crmcode" value="<%=Util.toScreenToEdit(crmCode, user.getLanguage())%>" STYLE="width:95%"></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(399,user.getLanguage())%>（<%=SystemEnv.getHtmlLabelName(642,user.getLanguage())%>）</TD>
          <TD class=Field><INPUT class=InputStyle maxLength=50 size=30 name="Abbrev"  onchange='checkinput("Abbrev","Abbrevimage")' value="<%=Util.toScreenToEdit(RecordSet.getString("engname"),user.getLanguage())%>" STYLE="width:95%"><SPAN id=Abbrevimage></SPAN></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>        
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(110,user.getLanguage())%>1</TD>
          <TD class=Field><INPUT class=InputStyle maxLength=50 size=30 name="Address1"  onchange='checkinput("Address1","Address1image")' value="<%=Util.toScreenToEdit(RecordSet.getString("address1"),user.getLanguage())%>" STYLE="width:95%"><SPAN id=Address1image></SPAN></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>        
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(110,user.getLanguage())%>2&nbsp;</TD>
          <TD class=Field><INPUT class=InputStyle maxLength=50 size=30 name="Address2" value="<%=Util.toScreenToEdit(RecordSet.getString("address2"),user.getLanguage())%>" STYLE="width:95%"></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>        
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(110,user.getLanguage())%>3&nbsp;</TD>
          <TD class=Field><INPUT class=InputStyle maxLength=50 size=30 name="Address3" value="<%=Util.toScreenToEdit(RecordSet.getString("address3"),user.getLanguage())%>" STYLE="width:95%"></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>        
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(479,user.getLanguage())%>, <%=SystemEnv.getHtmlLabelName(493,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=10 size=14 name="Zipcode" value="<%=Util.toScreenToEdit(RecordSet.getString("zipcode"),user.getLanguage())%>" STYLE="width:47%"><SPAN STYLE="width:5%"></SPAN>
		  <BUTTON class=Browser id=SelectCityID onclick="onShowCityID()"></BUTTON> 
              <SPAN id=cityidspan STYLE="width=30%"><%=CityComInfo.getCityname(RecordSet.getString("city"))%></SPAN> 
              <INPUT id=CityCode type=hidden name="City" value="<%=Util.toScreenToEdit(RecordSet.getString("city"),user.getLanguage())%>">  
              
              <SPAN STYLE="width:1%"></SPAN>
		  </TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>        
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(377,user.getLanguage())%>, <%=SystemEnv.getHtmlLabelName(643,user.getLanguage())%></TD>
          <TD class=Field>
          <BUTTON class=Browser id=SelectCountryID onclick="onShowCountryID()"></BUTTON> 
              <SPAN id=countryidspan STYLE="width=40%"><%=CountryComInfo.getCountrydesc(RecordSet.getString("country"))%></SPAN> 
              <INPUT id=CountryCode type=hidden name="Country" value="<%=Util.toScreenToEdit(RecordSet.getString("country"),user.getLanguage())%>">  
              
              <SPAN STYLE="width:1%"></SPAN>
          <!--BUTTON class=Browser id=SelectProvinceID onclick="onShowProvinceID()"></BUTTON> 
              <SPAN id=provinceidspan STYLE="width=30%"><%=ProvinceComInfo.getProvincename(RecordSet.getString("province"))%></SPAN> 
              <INPUT id=ProvinceCode type=hidden name="Province" value="<%=Util.toScreenToEdit(RecordSet.getString("province"),user.getLanguage())%>">  
              
              <SPAN STYLE="width:1%"></SPAN -->
		  </TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>        
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(644,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=50 size=30 name="County" value="<%=Util.toScreenToEdit(RecordSet.getString("county"),user.getLanguage())%>" STYLE="width:95%"></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>        
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(231,user.getLanguage())%></TD>
          <TD class=Field><BUTTON class=Browser onclick="onShowLanguageID()"></BUTTON> 
              <SPAN id=languageidspan><%=Util.toScreen(LanguageComInfo.getLanguagename(RecordSet.getString("language")),user.getLanguage())%></SPAN> 
              <INPUT type=hidden name="Language" value="<%=Util.toScreenToEdit(RecordSet.getString("language"),user.getLanguage())%>"></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>        
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(421,user.getLanguage())%>, <%=SystemEnv.getHtmlLabelName(494,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=50 size=14 name="Phone" value="<%=Util.toScreenToEdit(RecordSet.getString("phone"),user.getLanguage())%>" STYLE="width:45%"><SPAN STYLE="width:5%"></SPAN><INPUT class=InputStyle maxLength=50 size=14 name="Fax" value="<%=Util.toScreenToEdit(RecordSet.getString("fax"),user.getLanguage())%>" STYLE="width:45%"></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>        
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(477,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=150 size=30 name="Email"  onblur='checkinput_email("Email","Emailimage")' value="<%=Util.toScreenToEdit(RecordSet.getString("email"),user.getLanguage())%>" STYLE="width:95%"><SPAN id=Emailimage></SPAN></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>        
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(76,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=150 size=30 name="Website" value="<%=Util.toScreenToEdit(RecordSet.getString("website"),user.getLanguage())%>" STYLE="width:95%"></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>        
        </TBODY>
	  </TABLE>
--%>



	  <TABLE class=ViewForm>
        <COLGROUP>
		<COL width="30%">
  		<COL width="70%">
        <TBODY>
        <TR class=Title>
            <TH colSpan=2><%=SystemEnv.getHtmlLabelName(570,user.getLanguage())%></TH>
          </TR>
         <TR class=Spacing style='height:1px'>
          <TD class=Line1 colSpan=2></TD></TR>
<%
if(hasFF)
{
	for(int i=1;i<=5;i++)
	{
		if(RecordSetFF.getString(i*2+1).equals("1"))
		{%>
        <TR>
          <TD><%=Util.toScreen(RecordSetFF.getString(i*2),user.getLanguage())%></TD>
          <TD class=Field><BUTTON type="button" class=Calendar onclick="getCrmDate(<%=i%>)"></BUTTON> 
              <SPAN id=datespan<%=i%> ><%=RecordSet.getString("datefield"+i)%></SPAN> 
              <input type="hidden" name="dff0<%=i%>" id="dff0<%=i%>" value="<%=RecordSet.getString("datefield"+i)%>"></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
		<%}
	}
	for(int i=1;i<=5;i++)
	{
		if(RecordSetFF.getString(i*2+11).equals("1"))
		{%>
        <TR>
          <TD><%=Util.toScreen(RecordSetFF.getString(i*2+10),user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=30 size=30 name="nff0<%=i%>" value="<%=RecordSet.getString("numberfield"+i)%>" STYLE="width:95%"></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
		<%}
	}
	for(int i=1;i<=5;i++)
	{
		if(RecordSetFF.getString(i*2+21).equals("1"))
		{%>
        <TR>
          <TD><%=Util.toScreen(RecordSetFF.getString(i*2+20),user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=100 size=30 name="tff0<%=i%>" value="<%=Util.toScreen(RecordSet.getString("textfield"+i),user.getLanguage())%>" STYLE="width:95%"></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
		<%}
	}
	for(int i=1;i<=5;i++)
	{
		if(RecordSetFF.getString(i*2+31).equals("1"))
		{%>
        <TR>
          <TD><%=Util.toScreen(RecordSetFF.getString(i*2+30),user.getLanguage())%></TD>
          <TD class=Field><INPUT type=checkbox name="bff0<%=i%>" value="1" <%if(RecordSet.getString("tinyintfield"+i).equals("1")){%> checked<%}%>></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
		<%}
	}
}
%>
        </TBODY>
	  </TABLE>



	  <!--TABLE class=ViewForm>
        <COLGROUP>
		<COL width="30%">
  		<COL width="70%">
        <TBODY>
        <TR class=Title>
            <TH colSpan=4><%=SystemEnv.getHtmlLabelName(454,user.getLanguage())%></TH>
          </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
         <TR class=Spacing style='height:1px'>
          <TD class=Line1 colSpan=2></TD></TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
		<TR>
		  <TD rowspan="1" colspan=2><TEXTAREA class=InputStyle NAME=Remark ROWS=3 STYLE="width:100%"></TEXTAREA>
		  </TD>
		</TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(454,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%></TD>
          <TD class=Field>
          
      <BUTTON class=Browser onclick="showRemarkDoc()"></BUTTON>      
      <SPAN ID=RemarkDocname></SPAN>
        <INPUT class=InputStyle type=hidden name="RemarkDoc" value=0></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
        </TBODY>
	  </TABLE -->

	</TD>

    <TD></TD>
    
	<TD vAlign=top>
      
	  <TABLE class=ViewForm>
        <COLGROUP>
		<COL width="30%">
  		<COL width="70%">
        <TBODY>
        <TR class=Title>
            <TH colSpan=2><%=SystemEnv.getHtmlLabelName(574,user.getLanguage())%></TH>
          </TR>
         <TR class=Spacing style='height:1px'>
          <TD class=Line1 colSpan=2></TD></TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%>, <%=SystemEnv.getHtmlLabelName(139,user.getLanguage())%></TD>
          <TD class=Field>
              <SPAN id=Statusspan class=fontred><%=Util.toScreen(CustomerStatusComInfo.getCustomerStatusname(RecordSet.getString("status")),user.getLanguage())%></SPAN> 
              <INPUT type=hidden name=Status value=<%=RecordSet.getString("status")%>>  
<!--            
			 <%if(RecordSet.getInt("status")!=1){%>
			  <BUTTON class=Browser onclick="onShowRatingID()"></BUTTON> 
			 <%}%>
              <SPAN id=Ratingspan><%=Util.toScreen(RecordSet.getString("rating"),user.getLanguage())%></SPAN> 
              <INPUT type=hidden name=Rating value=<%=RecordSet.getString("rating")%>> 
-->
		 <select class=InputStyle  name=Rating <%if(isCustomerSelf){%>disabled<%}%>>
		  <option value="1" <%if(RecordSet.getString("rating").equals("1")){%>selected<%}%>>1</option>
		  <option value="2" <%if(RecordSet.getString("rating").equals("2")){%>selected<%}%>>2</option>
		  <option value="3" <%if(RecordSet.getString("rating").equals("3")){%>selected<%}%>>3</option>
		  <option value="4" <%if(RecordSet.getString("rating").equals("4")){%>selected<%}%>>4</option>
		  <option value="5" <%if(RecordSet.getString("rating").equals("5")){%>selected<%}%>>5</option>
		  <option value="6" <%if(RecordSet.getString("rating").equals("6")){%>selected<%}%>>6</option>
		  <option value="7" <%if(RecordSet.getString("rating").equals("7")){%>selected<%}%>>7</option>
 
		  </select>
		  <%if(isCustomerSelf){%><input type=hidden name=Rating value=<%=RecordSet.getString("rating")%>><%}%>
              </TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>        

		    
		    <TR>
          <TD><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></TD>
          <TD class=Field>
	<!--
<%if(RecordSet.getInt("status")<4){%>
          <BUTTON class=Browser onclick="onShowTypeID()"></BUTTON> 
<%}%>-->
              <SPAN id=Typespan><%=Util.toScreen(CustomerTypeComInfo.getCustomerTypename(RecordSet.getString("type")),user.getLanguage())%></SPAN> 
              <INPUT type=hidden name="Type" value=<%=RecordSet.getString("type")%>> 
               </TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
        
        
       
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></TD>
          <TD class=Field>
              <INPUT class="wuiBrowser" _url="/systeminfo/BrowserMain.jsp?url=/CRM/Maint/CustomerDescBrowser.jsp"
              _displayText="<%=Util.toScreen(CustomerDescComInfo.getCustomerDescname(RecordSet.getString("description")),user.getLanguage())%>"
              type=hidden name=Description value=<%=RecordSet.getString("description")%>></TD>
         </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>       
          
         <%-- xwj for td1552 on 2005-03-22
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(576,user.getLanguage())%></TD>
          <TD class=Field><BUTTON class=Browser onclick="onShowSizeID()"></BUTTON> 
              <SPAN id=Sizespan><%=Util.toScreen(CustomerSizeComInfo.getCustomerSizedesc(RecordSet.getString("size_n")),user.getLanguage())%></SPAN> 
              <INPUT type=hidden name=Size value=<%=RecordSet.getString("size_n")%>></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>        
       --%> 
       <TR>
          <TD><%=SystemEnv.getHtmlLabelName(645,user.getLanguage())%></TD>
          <TD class=Field>
              <INPUT type=hidden class="wuiBrowser" _url="/systeminfo/BrowserMain.jsp?url=/CRM/Maint/ContactWayBrowser.jsp"
              _displayText="<%=Util.toScreen(ContactWayComInfo.getContactWayname(RecordSet.getString("source")),user.getLanguage())%>"
              name=Source value=<%=RecordSet.getString("source")%>></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>        
       
       
       
       
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(575,user.getLanguage())%></TD>
          <TD class=Field>
          <%
          String seclist = "";
          String tmpsecid = RecordSet.getString("sector");
          String tmpparid = SectorInfoComInfo.getSectorInfoParentid(tmpsecid);
         while(!tmpsecid.equals("0")&&!tmpparid.equals("")){
         	if(seclist.equals(""))
         		seclist = SectorInfoComInfo.getSectorInfoname(tmpsecid) + seclist;
         	else
         		seclist = SectorInfoComInfo.getSectorInfoname(tmpsecid) +"->"+ seclist;
       
          tmpsecid = tmpparid;
          tmpparid = SectorInfoComInfo.getSectorInfoParentid(tmpsecid);
         }
          %>
         
              <INPUT type=hidden class="wuiBrowser" _url="/systeminfo/BrowserMain.jsp?url=/CRM/Maint/SectorInfoBrowser.jsp"
              _displayText="  <%=seclist%>"
               name=Sector value=<%=RecordSet.getString("sector")%>></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr> 

<%if(!user.getLogintype().equals("2")) {%>			
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(1278,user.getLanguage())%></TD>
          <TD class=Field>
           <INPUT class=wuiBrowser _url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
           _displayText="<a href='/hrm/resource/HrmResource.jsp?id=<%=RecordSet.getString("manager")%>'><%=Util.toScreen(ResourceComInfo.getResourcename(RecordSet.getString("manager")),user.getLanguage())%></a>"
           _displayTemplate="<A href='/hrm/resource/HrmResource.jsp?id=#b{id}'>#b{name}</A>"
            type=hidden name=Manager value=<%=RecordSet.getString("manager")%>></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>        
        <%--xwj for td1552 on 2005-03-22
        <!--TR>
          <TD><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></TD>
          <TD class=Field><button class=Browser id=SelectDeparment onClick="onShowDepartment()"></button> 
              <span class=InputStyle id=departmentspan><a href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=RecordSet.getString("department")%>"><%=Util.toScreen(DepartmentComInfo.getDepartmentname(RecordSet.getString("department")),user.getLanguage())%></a></span> 
              <input id=departmentid type=hidden name=Department value=<%=RecordSet.getString("department")%>></TD>
        </TR -->        
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(132,user.getLanguage())%></TD>
          <TD class=Field> <button class=Browser id=SelectDeparment onClick="onShowAgent()"></button> 
              <span class=InputStyle id=Agentspan> <a href="/CRM/data/Viewcustomer.jsp?CustomerID=<%=RecordSet.getString("agent")%>"><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(RecordSet.getString("agent")),user.getLanguage())%></a></span> 
              <input type=hidden name=Agent value=<%=RecordSet.getString("agent")%>></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>   
        --%>
<%} else {%>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(1278,user.getLanguage())%></TD>
          <TD class=Field> <span 
            id=manageridspan><%=Util.toScreen(ResourceComInfo.getResourcename(RecordSet.getString("manager")),user.getLanguage())%></span> 
              <INPUT class=InputStyle type=hidden name=Manager value=<%=RecordSet.getString("manager")%>></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>        
       
        <%--xwj for td1552 on 2005-03-22
         <TR>
          <TD><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></TD>
          <TD class=Field> 
              <span class=InputStyle id=departmentspan><%=Util.toScreen(DepartmentComInfo.getDepartmentname(RecordSet.getString("department")),user.getLanguage())%></span> 
              <input id=departmentid type=hidden name=Department value=<%=RecordSet.getString("department")%>></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>        
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(132,user.getLanguage())%></TD>
          <TD class=Field>  
              <span class=InputStyle id=Agentspan> <a href="/CRM/data/Viewcustomer.jsp?CustomerID=<%=RecordSet.getString("agent")%>"><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(RecordSet.getString("agent")),user.getLanguage())%></a></span> 
              <input type=hidden name=Agent value=<%=RecordSet.getString("agent")%>></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>  
        --%>
<%}%>
        <%-- xwj for td1552 on 2005-03-22
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(591,user.getLanguage())%></TD>
          <TD class=Field>
				<%if(!isCustomerSelf){%><button class=Browser id=SelectDeparment onClick="onShowParent()"></button> <%}%>
              <span class=InputStyle id=Parentspan><a href="/CRM/data/Viewcustomer.jsp?CustomerID=<%=RecordSet.getString("parentid")%>"><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(RecordSet.getString("parentid")),user.getLanguage())%></a></span> 
              <input type=hidden name=Parent value=<%=RecordSet.getString("parentid")%>></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>        
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%></TD>
          <TD class=Field>
				<%if(!isCustomerSelf){%><BUTTON class=Browser onclick="showDoc()"></BUTTON><%}%>      
      <SPAN ID=Documentname><a href="/docs/docs/DocDsp.jsp?id=<%=RecordSet.getString("documentid")%>"><%=Util.toScreen(DocComInfo.getDocname(RecordSet.getString("documentid")),user.getLanguage())%></a></SPAN>
        <INPUT class=InputStyle type=hidden name=Document value=<%=RecordSet.getString("documentid")%>></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr> 
		
		   <TR>
          <TD><%=SystemEnv.getHtmlLabelName(6069,user.getLanguage())%></TD>
          <TD class=Field>
				<%if(!isCustomerSelf){%><BUTTON class=Browser onclick="showRemarkdocName()"></BUTTON><%}%>      
      <SPAN ID=introductionDocname><a href="/docs/docs/DocDsp.jsp?id=<%=RecordSet.getString("introductionDocid")%>"><%=Util.toScreen(DocComInfo.getDocname(RecordSet.getString("introductionDocid")),user.getLanguage())%></a></SPAN>
        <INPUT class=InputStyle type=hidden name=introductionDocid value=<%=RecordSet.getString("introductionDocid")%>></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr> 
       --%>
	
	<%if(!user.getLogintype().equals("2")){%>
        <TR>
		  <TD><%=SystemEnv.getHtmlLabelName(120,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(139,user.getLanguage())%></TD>
		  <TD class=Field> <INPUT class=InputStyle maxLength=3 size=5 	name=seclevel onKeyPress="ItemCount_KeyPress()" onBlur='<%--checknumber("seclevel");checkinput("seclevel","seclevelimage")--%>' value="<%=RecordSet.getString("seclevel")%>">
		   <SPAN id=seclevelimage></SPAN>
		  </TD>
	    </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>		
	<%}else{%>
		 <INPUT type=hidden name=seclevel value="<%=RecordSet.getString("seclevel")%>">
	<%}%>				
    <!--    <TR>
          <TD>图片</TD>
          <TD class=Field><INPUT class=InputStyle maxLength=5 size=5 name="Photo" value=<%=RecordSet.getString("picid")%>></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
      -->  </TBODY>
	  </TABLE>
      
     
      <TABLE class=ViewForm>
        <COLGROUP>
		<COL width="30%">
  		<COL width="70%">
        <TBODY>
        <TR class=Title>
            <TH colspan = 2><%=SystemEnv.getHtmlLabelName(15125,user.getLanguage())%></TH>
          </TR>
         <TR class=Spacing style='height:1px'>
          <TD class=Line1 colSpan=2></TD></TR>
<%if(!user.getLogintype().equals("2")){%>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(6097,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=11 size=20 name="CreditAmount" onchange='<%--checkinput("CreditAmount","CreditAmountimage");--%>checkdecimal_length("CreditAmount",8)' onKeyPress="ItemNum_KeyPress()" <%--onBlur='checknumber("CreditAmount")'--%> value = "<%=RecordSet.getString("CreditAmount")%>"><SPAN id=CreditAmountimage></SPAN></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(6098,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=3 size=20 name="CreditTime" <%--onchange='checkinput("CreditTime","CreditTimeimage")'--%> onKeyPress="ItemCount_KeyPress()" <%--onBlur='checknumber("CreditTime")'--%> value = "<%=RecordSet.getString("CreditTime")%>"><SPAN id=CreditTimeimage></SPAN></TD>
         </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>       

<%}else{%>
		<INPUT type=hidden class=InputStyle name="CreditAmount"  value = "<%=RecordSet.getString("CreditAmount")%>">	
		<INPUT type=hidden class=InputStyle name="CreditTime"  value = "<%=RecordSet.getString("CreditTime")%>">	
<%}%>
         <TR>
          <TD><%=SystemEnv.getHtmlLabelName(17084,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=200 size=20 name="bankname" value="<%=bankName%>"></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
		<TR>
          <TD><%=SystemEnv.getHtmlLabelName(571,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=20 size=20 name="accountname" value="<%=accountName%>"></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(17085,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=200 size=20 name="accounts" onKeyPress="ItemCount_KeyPress()" value="<%=accounts%>"></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
       </TABLE>



<%if(RecordSet.getInt("status")>=4 && !isCustomerSelf && 0!=0){ //0!=0屏蔽到财务信息%>
	  <TABLE class=ViewForm>
        <COLGROUP>
		<COL width="30%">
  		<COL width="70%">
        <TBODY>
        <TR class=Title>
            <TH colSpan=2><%=SystemEnv.getHtmlLabelName(189,user.getLanguage())%></TH>
          </TR>
         <TR class=Spacing style='height:1px'>
          <TD class=Line1 colSpan=2></TD></TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(189,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(590,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=5 size=5 name="Fincode" value="<%=Util.toScreenToEdit(RecordSet.getString("fincode"),user.getLanguage())%>" STYLE="width:95%"></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(649,user.getLanguage())%></TD>
          <TD class=Field>
          <INPUT class=wuiBrowser _displayText="<%=Util.toScreen(CurrencyComInfo.getCurrencyname(RecordSet.getString("currency")),user.getLanguage())%>"
          _url="/systeminfo/BrowserMain.jsp?url=/fna/maintenance/CurrencyBrowser.jsp"
           type=hidden maxLength=5 size=5 name="Currency" value="<%=Util.toScreen(RecordSet.getString("currency"),user.getLanguage())%>"></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(581,user.getLanguage())%></TD>
          <TD class=Field>
          <INPUT class=wuiBrowser _url="/systeminfo/BrowserMain.jsp?url=/CRM/Maint/TradeInfoBrowser.jsp" 
          _displayText="<%=Util.toScreen(TradeInfoComInfo.getTradeInfoname(RecordSet.getString("contractlevel")),user.getLanguage())%>"
           type=hidden name="ContractLevel" value="<%=Util.toScreenToEdit(RecordSet.getString("contractlevel"),user.getLanguage())%>"></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(580,user.getLanguage())%></TD>
          <TD class=Field>
          <INPUT class=wuiBrowser _url="/systeminfo/BrowserMain.jsp?url=/CRM/Maint/CreditInfoBrowser.jsp" 
          _displayText="<%=Util.toScreen(CreditInfoComInfo.getCreditInfoname(RecordSet.getString("creditlevel")),user.getLanguage())%>"
          type=hidden name="CreditLevel" value="<%=Util.toScreen(RecordSet.getString("creditlevel"),user.getLanguage())%>"></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(650,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=50 size=15 name="CreditOffset" onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("CreditOffset")' value="<%=Util.toScreenToEdit(RecordSet.getString("creditoffset"),user.getLanguage())%>" STYLE="width:95%"></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(651,user.getLanguage())%>(%)</TD>
          <TD class=Field><INPUT class=InputStyle maxLength=10 size=5 name="Discount" onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("Discount")' value="<%=Util.toScreenToEdit(RecordSet.getString("discount"),user.getLanguage())%>" STYLE="width:95%"></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(653,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=50 size=30 name="TaxNumber" value="<%=Util.toScreenToEdit(RecordSet.getString("taxnumber"),user.getLanguage())%>" STYLE="width:95%"></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(654,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=50 size=30 name="BankAccount" value="<%=Util.toScreenToEdit(RecordSet.getString("bankacount"),user.getLanguage())%>" STYLE="width:95%"></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(655,user.getLanguage())%></TD>
          <TD class=Field>
          <INPUT class=wuiBrowser _url="/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp"
          _displayText="<a href='ViewCustomer.jsp?CustomerID=<%=RecordSet.getString("invoiceacount")%>'><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(RecordSet.getString("invoiceacount")),user.getLanguage())%></a>"
          _displayTemplate="<A href='/CRM/data/ViewCustomer.jsp?CustomerID=#b{id}'>#b{name}</A>"
           type=hidden name="InvoiceAcount" value="<%=Util.toScreen(RecordSet.getString("invoiceacount"),user.getLanguage())%>"></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(657,user.getLanguage())%></TD>
          <TD class=Field>
          <INPUT class=wuiBrowser _url="/systeminfo/BrowserMain.jsp?url=/CRM/Maint/DeliveryTypeBrowser.jsp"
           _displayText="<%=Util.toScreen(DeliveryTypeComInfo.getDeliveryTypename(RecordSet.getString("deliverytype")),user.getLanguage())%>"
           type=hidden name="DeliveryType" value="<%=Util.toScreen(RecordSet.getString("deliverytype"),user.getLanguage())%>"></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(658,user.getLanguage())%></TD>
          <TD class=Field>
          <INPUT class=wuiBrowser _url="/systeminfo/BrowserMain.jsp?url=/CRM/Maint/PaymentTermBrowser.jsp" 
          	_displayText="<%=Util.toScreen(PaymentTermComInfo.getPaymentTermname(RecordSet.getString("paymentterm")),user.getLanguage())%>"
          type=hidden name="PaymentTerm" value="<%=Util.toScreen(RecordSet.getString("paymentterm"),user.getLanguage())%>"></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(652,user.getLanguage())%></TD>
          <TD class=Field><SELECT class=InputStyle  NAME="PaymentWay" STYLE="width:95%">
          <OPTION VALUE="0"></OPTION>
          <OPTION VALUE="1"<%if(RecordSet.getString("paymentway").equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(1243,user.getLanguage())%></OPTION>
          <OPTION VALUE="2"<%if(RecordSet.getString("paymentway").equals("2")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(185,user.getLanguage())%></OPTION>
          <OPTION VALUE="3"<%if(RecordSet.getString("paymentway").equals("3")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(1246,user.getLanguage())%></OPTION>
          <OPTION VALUE="4"<%if(RecordSet.getString("paymentway").equals("4")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(1244,user.getLanguage())%></OPTION>
          <OPTION VALUE="5"<%if(RecordSet.getString("paymentway").equals("5")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(1247,user.getLanguage())%></OPTION>
          <OPTION VALUE="6"<%if(RecordSet.getString("paymentway").equals("6")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(1248,user.getLanguage())%></OPTION>
          <OPTION VALUE="7"<%if(RecordSet.getString("paymentway").equals("7")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(1249,user.getLanguage())%></OPTION>
          <OPTION VALUE="8"<%if(RecordSet.getString("paymentway").equals("8")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(1250,user.getLanguage())%></OPTION>
          <OPTION VALUE="9"<%if(RecordSet.getString("paymentway").equals("9")){%> selected <%}%>>BACS</OPTION>
          <OPTION VALUE="10"<%if(RecordSet.getString("paymentway").equals("10")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(1251,user.getLanguage())%></OPTION>
          <OPTION VALUE="11"<%if(RecordSet.getString("paymentway").equals("11")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(1252,user.getLanguage())%></OPTION>
          <OPTION VALUE="12"<%if(RecordSet.getString("paymentway").equals("12")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(1245,user.getLanguage())%></OPTION>
          <OPTION VALUE="13"<%if(RecordSet.getString("paymentway").equals("13")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(1253,user.getLanguage())%></OPTION>
          <OPTION VALUE="14"<%if(RecordSet.getString("paymentway").equals("14")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(1254,user.getLanguage())%></OPTION>
          </SELECT></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(646,user.getLanguage())%></TD>
          <TD class=Field><SELECT  class=InputStyle NAME="SaleConfirm" STYLE="width:95%">
          <OPTION VALUE="0"></OPTION>
          <OPTION VALUE="1" <%if(RecordSet.getString("saleconfirm").equals("1")){%> selected <%}%>>Always sales order confirmation</OPTION>
          <OPTION VALUE="2" <%if(RecordSet.getString("saleconfirm").equals("2")){%> selected <%}%>>Only for back orders</OPTION>
          <OPTION VALUE="3" <%if(RecordSet.getString("saleconfirm").equals("3")){%> selected <%}%>>No sales order confirmation</OPTION>
          </SELECT></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(487,user.getLanguage())%>，<%=SystemEnv.getHtmlLabelName(488,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=50 size=14 name="Credit" value="<%=Util.toScreenToEdit(RecordSet.getString("creditcard"),user.getLanguage())%>" STYLE="width:45%"><SPAN STYLE="width:5%"></SPAN><button type="button" class=calendar onclick="getCreditDate()"></button><span id=creditexpirespan><%=Util.toScreen(RecordSet.getString("creditexpire"),user.getLanguage())%></span><INPUT class=InputStyle type=hidden name="CreditExpire" value="<%=Util.toScreen(RecordSet.getString("creditexpire"),user.getLanguage())%>" STYLE="width:45%"></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
        </TBODY>
	  </TABLE>
<%}else{%>
	    <INPUT type=hidden class=InputStyle maxLength=5 size=5 name="Fincode" value="<%=Util.toScreenToEdit(RecordSet.getString("fincode"),user.getLanguage())%>" STYLE="width:95%">
		<INPUT type=hidden class=InputStyle type=hidden maxLength=5 size=5 name="Currency" value="<%=Util.toScreen(RecordSet.getString("currency"),user.getLanguage())%>">
		<INPUT type=hidden class=InputStyle  type=hidden name="ContractLevel" value="<%=Util.toScreenToEdit(RecordSet.getString("contractlevel"),user.getLanguage())%>">
		<INPUT type=hidden class=InputStyle type=hidden name="CreditLevel" value="<%=Util.toScreen(RecordSet.getString("creditlevel"),user.getLanguage())%>">
		<INPUT type=hidden class=InputStyle maxLength=50 size=15 name="CreditOffset" onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("CreditOffset")' value="<%=Util.toScreenToEdit(RecordSet.getString("creditoffset"),user.getLanguage())%>" STYLE="width:95%">
		<INPUT type=hidden class=InputStyle maxLength=10 size=5 name="Discount" onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("Discount")' value="<%=Util.toScreenToEdit(RecordSet.getString("discount"),user.getLanguage())%>" STYLE="width:95%">
		<INPUT type=hidden class=InputStyle maxLength=50 size=30 name="TaxNumber" value="<%=Util.toScreenToEdit(RecordSet.getString("taxnumber"),user.getLanguage())%>" STYLE="width:95%">
		<INPUT type=hidden class=InputStyle maxLength=50 size=30 name="BankAccount" value="<%=Util.toScreenToEdit(RecordSet.getString("bankacount"),user.getLanguage())%>" STYLE="width:95%">
		<INPUT class=InputStyle type=hidden name="InvoiceAcount" value="<%=Util.toScreen(RecordSet.getString("invoiceacount"),user.getLanguage())%>">
		<INPUT class=InputStyle type=hidden name="DeliveryType" value="<%=Util.toScreen(RecordSet.getString("deliverytype"),user.getLanguage())%>">
		<INPUT class=InputStyle type=hidden name="PaymentTerm" value="<%=Util.toScreen(RecordSet.getString("paymentterm"),user.getLanguage())%>">
		<INPUT type=hidden class=InputStyle maxLength=50 size=14 name="PaymentWay" value="<%=Util.toScreenToEdit(RecordSet.getString("paymentway"),user.getLanguage())%>" STYLE="width:45%">
		<INPUT type=hidden class=InputStyle maxLength=50 size=14 name="SaleConfirm" value="<%=Util.toScreenToEdit(RecordSet.getString("saleconfirm"),user.getLanguage())%>" STYLE="width:45%">
		<INPUT type=hidden class=InputStyle maxLength=50 size=14 name="Credit" value="<%=Util.toScreenToEdit(RecordSet.getString("creditcard"),user.getLanguage())%>" STYLE="width:45%">
		<INPUT type=hidden class=InputStyle type=hidden name="CreditExpire" value="<%=Util.toScreen(RecordSet.getString("creditexpire"),user.getLanguage())%>" STYLE="width:45%">
<%}%>
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
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<!-- added by cyril on 2008-06-13 for TD:8828 -->
<script language=javascript src="/js/checkData_wev8.js"></script>
<!-- end by cyril on 2008-06-13 for TD:8828 -->
</BODY>
</HTML>
