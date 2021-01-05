
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetFF" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetShare" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetCre" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetP" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetE" class="weaver.conn.RecordSet" scope="page" />

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
<jsp:useBean id="CitytwoComInfo" class="weaver.hrm.city.CitytwoComInfo" scope="page"/>

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
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page"/>
<jsp:useBean id="RecordSetBase" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetDemand" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetImportant" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetCompetitor" class="weaver.conn.RecordSet" scope="page" />
<%
String CustomerID = Util.null2String(request.getParameter("CustomerID"));
if(!user.getLogintype().equals("2")){//跳转到新客户卡片
	response.sendRedirect("/CRM/manage/customer/CustomerBaseView.jsp?nolog=1&CustomerID="+CustomerID);
	return;
}
String Creater = "";
String CreaterType = "";
String CreateDate = "";
boolean isfromtab =  Util.null2String(request.getParameter("isfromtab")).equals("true")?true:false;
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
//判断是否设置额度期间
String hasCre = "false";
String creditamountStr = "1";
String credittimeStr = "2";
String sqlstrCre = " select creditamount,credittime from  CRM_CustomerCredit " ;
RecordSetCre.executeSql(sqlstrCre);
if(RecordSetCre.next()){
	hasCre = "true";
	creditamountStr = RecordSetCre.getString("creditamount");
	credittimeStr = RecordSetCre.getString("credittime");
}

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
<script language=javascript >
function onSave(obj){
	window.onbeforeunload=null;
	if($G("Type").value == 0 || $G("Description").value == 0 || $G("Size").value == 0 || $G("Sector").value == 0){
		alert("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage())%>");
		return;
	}
	if(check_form(weaver,'Name,Abbrev,Address1,Language,Type,Description,Size,Source,Sector,Manager,Department,Email,seclevel,City,Phone')){
		var amounttemp = $G("CreditAmount").value;
		var timetemp = $G("CreditTime").value;
		if(amounttemp==''){
			if(<%=hasCre%>){
				$G("CreditAmount").value = <%=creditamountStr%>;
			}else{
				alert("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage())%>");
				return;
			}
		}
		if(timetemp==''){
			if(<%=hasCre%>){
				$G("CreditTime").value = <%=credittimeStr%>;
			}else{
				alert("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage())%>");
				return;
			}
		}
		//-----增加必填判断-----
		
		var source = $G("Source").value;
		if(source==1 || source==18){//如果为电话开拓则开拓人员为必填
			if(check_form(weaver,"exploiterIds")){
				obj.disabled = true;
				weaver.submit();
			}
		}
		<%if(!user.getLogintype().equals("2")){%>//如果为代理商伙伴类则中介机构为必填
			else if(source==22 || source==23 || source==24 || source==25 || source==26 || source==27){
				if(check_form(weaver,"Agent")){
					obj.disabled = true;
					weaver.submit();
				}
			}
		<%}%>
		else{
			obj.disabled=true;
			weaver.submit();
		}
	}
}
function protectCus(){
try{
	if(!checkDataChange())//added by cyril on 2008-06-13 for TD:8828
		event.returnValue="<%=SystemEnv.getHtmlLabelName(18675,user.getLanguage())%>";
} catch(e) {
}
}
function onBack(obj){
try{
	//window.onbeforeunload=null;
	if('<%=isfromtab%>'!='true')
	{
		location.href="/CRM/data/ViewCustomer.jsp?log=n&CustomerID=<%=CustomerID%>";
	}else{
		location.href="/CRM/data/ViewCustomer.jsp?log=n&CustomerID=<%=CustomerID%>";
	}
} catch(e) {
}
}
function checktext(){
	if(document.all("introduction").value.length>100){
	document.all("introduction").value=document.all("introduction").value.substring(0,99);
		alert('最大长度为100');
		return;
	
	}


}
</script>

</HEAD>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(136,user.getLanguage())+SystemEnv.getHtmlLabelName(647,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+" - "+Util.toScreen(RecordSet.getString("name"),user.getLanguage());


String temStr="";
/* ------Modified by XWJ	for td:1242 on 2005-03-16 --------- begin ----------*/
if(!Creater.equals(""))	{	
	temStr+="<B>"+SystemEnv.getHtmlLabelName(401,user.getLanguage())+":</B>"+CreateDate+"<B> "+SystemEnv.getHtmlLabelName(623,user.getLanguage())+":</B>";
	temStr+=ResourceComInfo.getClientDetailModifier(Creater,CreaterType,user.getLogintype());
}
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
if(!Modifier.equals("")){
	temStr+="<B>"+SystemEnv.getHtmlLabelName(103,user.getLanguage())+":</B>"+ModifyDate+"<B> "+SystemEnv.getHtmlLabelName(623,user.getLanguage())+":</B>";
	temStr+=ResourceComInfo.getClientDetailModifier(Modifier,ModifierType,user.getLogintype());
}
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
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(this),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(589,user.getLanguage())+",javascript:window.location.reload(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:onBack(this),_top} " ;
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



<FORM id=weaver action="/CRM/data/CustomerOperation.jsp" method=post 
onsubmit='return check_form(this,"Name,Abbrev,Address1,Language,Type,Description,Size,Source,Sector,Manager,Department,Email,seclevel,CreditAmount,CreditTime")'>
<input type="hidden" name="method" value="edit">
<input type="hidden" name="CustomerID" value="<%=CustomerID%>">
<input type="hidden" name="isfromtab" value="<%=isfromtab %>">
<DIV>
<% 
	if(HrmUserVarify.checkUserRight("EditCustomer:Delete",user,customerDepartment)){
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:doDel(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
	<BUTTON class=btnDelete id=Delete accessKey=D  style="display:none" id=domysave  onclick='doDel()'><U>D</U>-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></BUTTON>
<%}%>
</DIV>

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
        <TR class=Spacing style="height: 1px">
          <TD class=Line1 colSpan=2></TD></TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
          <TD class=Field>
            <INPUT class=InputStyle maxLength=50 name="Name" id="Name" onchange='checkinput("Name","Nameimage"),checkCustomerNameFun()' value="<%=Util.toScreenToEdit(RecordSet.getString("name"),user.getLanguage())%>" SIZE="35">
            <SPAN id=Nameimage></SPAN>
          </TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
        <!--add CRM CODE by lupeng 2004.03.30-->
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(17080,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=50 name="crmcode" value="<%=Util.toScreenToEdit(crmCode, user.getLanguage())%>" SIZE="35"></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(399,user.getLanguage())%>（<%=SystemEnv.getHtmlLabelName(642,user.getLanguage())%>）</TD>
          <TD class=Field>
            <INPUT class=InputStyle maxLength=50 name="Abbrev"  onchange='checkinput("Abbrev","Abbrevimage")' value="<%=Util.toScreenToEdit(RecordSet.getString("engname"),user.getLanguage())%>" SIZE="35">
            <SPAN id=Abbrevimage><%if(RecordSet.getString("engname").equals("")){%><IMG src="/images/BacoError_wev8.gif" align=absMiddle><%}%></SPAN>
          </TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>  
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(110,user.getLanguage())%>1</TD>
          <TD class=Field>
            <INPUT class=InputStyle maxLength=120 name="Address1"  onchange='checkinput("Address1","Address1image")' value="<%=Util.toScreenToEdit(RecordSet.getString("address1"),user.getLanguage())%>" SIZE="35">
            <SPAN id=Address1image>
                <%if(RecordSet.getString("address1").equals("")){%><IMG src="/images/BacoError_wev8.gif" align=absMiddle><%}%>
            </SPAN>
          </TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr> 
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(110,user.getLanguage())%>2&nbsp;</TD>
          <TD class=Field><INPUT class=InputStyle maxLength=120 name="Address2" value="<%=Util.toScreenToEdit(RecordSet.getString("address2"),user.getLanguage())%>" SIZE="35"></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>  
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(110,user.getLanguage())%>3&nbsp;</TD>
          <TD class=Field><INPUT class=InputStyle maxLength=120 name="Address3" value="<%=Util.toScreenToEdit(RecordSet.getString("address3"),user.getLanguage())%>" SIZE="35"></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
		 <TR>
		 <%
		 String citytwo="";
		 String cityts="";
		 if (!RecordSet.getString("county").equals("0"))  citytwo=RecordSet.getString("county");
		 if (!RecordSet.getString("city").equals("0"))  cityts=RecordSet.getString("city");

		 %>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(479,user.getLanguage())%>, <%=SystemEnv.getHtmlLabelName(493,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=10 size=14 name="Zipcode" value="<%=Util.toScreenToEdit(RecordSet.getString("zipcode"),user.getLanguage())%>" STYLE="width:47%"><SPAN STYLE="width:5%"></SPAN>
		   <INPUT id=CityCode class="wuiBrowser" _displayText="<%=CityComInfo.getCityname(RecordSet.getString("city"))%>" _url="/systeminfo/BrowserMain.jsp?url=/hrm/city/CityBrowser.jsp" type=hidden name=City value="<%=Util.toScreenToEdit(RecordSet.getString("city"),user.getLanguage())%>" _request="yes">


              <SPAN STYLE="width:1%"></SPAN>
		  </TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>       

          <TD><%=SystemEnv.getHtmlLabelName(25223,user.getLanguage())%></TD>
          <TD class=Field>
          <INPUT id=citytwoCode class="wuiBrowser" _displayText="<%=CitytwoComInfo.getCityname(RecordSet.getString("county"))%>" _url="/systeminfo/BrowserMain.jsp?url=/hrm/city/CityTwoBrowser.jsp" type=hidden name=citytwoCode value="<%=Util.toScreenToEdit(citytwo,user.getLanguage())%>">
          	<!-- 
          	<BUTTON class=Browser id=SelectcitytwoID onclick="onShowCityTwoID()"></BUTTON> 
              <SPAN id=citytwoidspan STYLE="width:34%"><%=CitytwoComInfo.getCityname(RecordSet.getString("county"))%>
			  <%if(RecordSet.getString("county").equals("")||RecordSet.getString("county").equals("0")){%><IMG src="/images/BacoError_wev8.gif" align=absMiddle><%}%></SPAN>
              <INPUT id=citytwoCode type=hidden name=citytwoCode value="<%=Util.toScreenToEdit(citytwo,user.getLanguage())%>"> 
               -->         
            <SPAN STYLE="width:5%"></SPAN></TD>
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>  
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(377,user.getLanguage())%>, <%=SystemEnv.getHtmlLabelName(643,user.getLanguage())%></TD>
          <TD class=Field>
             <INPUT id=CountryCode class="wuiBrowser" _displayText="<%=CountryComInfo.getCountrydesc(RecordSet.getString("country"))%>" _url="/systeminfo/BrowserMain.jsp?url=/hrm/country/CountryBrowser.jsp" type=hidden name=Country value="<%=Util.toScreenToEdit(RecordSet.getString("country"),user.getLanguage())%>">          


              
              <SPAN STYLE="width:1%"></SPAN>
          <!--BUTTON class=Browser id=SelectProvinceID onclick="onShowProvinceID()"></BUTTON> 
              <SPAN id=provinceidspan STYLE="width=30%"><%=ProvinceComInfo.getProvincename(RecordSet.getString("province"))%></SPAN> 
              <INPUT id=ProvinceCode type=hidden name="Province" value="<%=Util.toScreenToEdit(RecordSet.getString("province"),user.getLanguage())%>">  
              
              <SPAN STYLE="width:1%"></SPAN -->
		  </TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>  
        <!--TR>
          <TD><%=SystemEnv.getHtmlLabelName(644,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=50 name="County" value="<%=Util.toScreenToEdit(RecordSet.getString("county"),user.getLanguage())%>" SIZE="35"></TD>
        </TR><tr><td class=Line colspan=2></td></tr-->        
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(231,user.getLanguage())%></TD>
          <TD class=Field><BUTTON class=Browser onClick="onShowLanguageID()"></BUTTON> 
              <INPUT type=hidden class="wuiBrowser" _displayText="<%=Util.toScreen(LanguageComInfo.getLanguagename(RecordSet.getString("language")),user.getLanguage())%>" _required="yes"  _url="/systeminfo/BrowserMain.jsp?url=/systeminfo/language/LanguageBrowser.jsp" name=Language value="<%=Util.toScreenToEdit(RecordSet.getString("language"),user.getLanguage())%>"> 
        	  </TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>        
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(421,user.getLanguage())%>, <%=SystemEnv.getHtmlLabelName(494,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=50 size=14 name="Phone" value="<%=Util.toScreenToEdit(RecordSet.getString("phone"),user.getLanguage())%>" STYLE="width:45%"  onchange='checkinput("Phone","PhoneImage")'>
          	<SPAN id="PhoneImage">
                <%if("".equals(RecordSet.getString("phone"))){%><IMG src="/images/BacoError_wev8.gif" align=absMiddle><%}%>
            </SPAN>
          	<SPAN STYLE="width:5%"></SPAN><INPUT class=InputStyle maxLength=50 size=14 name="Fax" value="<%=Util.toScreenToEdit(RecordSet.getString("fax"),user.getLanguage())%>" STYLE="width:45%"></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>        
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(477,user.getLanguage())%></TD>
          <TD class=Field>
            <INPUT class=InputStyle maxLength=150 name="Email"  onblur='checkinput_email("Email","Emailimage")' value="<%=Util.toScreenToEdit(RecordSet.getString("email"),user.getLanguage())%>" SIZE="35">
            <SPAN id=Emailimage>
                <%if(RecordSet.getString("email").equals("")){%><IMG src="/images/BacoError_wev8.gif" align=absMiddle><%}%>
            </SPAN>
          </TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>        
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(76,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=150 name="Website" value="<%=Util.toScreenToEdit(RecordSet.getString("website"),user.getLanguage())%>" SIZE="35"></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>        
        <!-- 介绍 -->
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(634,user.getLanguage())%></TD>
          <TD class=Field>
        <textarea class=inputstyle  name ="introduction"  cols=20  wrap="hard" id="introduction" STYLE="height:50;width:330;overflow-x:hidden" onKeyPress="checktext();" ><%=Util.toScreenToEdit(RecordSet.getString("introduction"),user.getLanguage())%></textarea>
          </TD>
        </TR>
         <!-- /介绍 -->
        <tr  style="height: 1px"><td class=Line colspan=2></td></tr>        
        </TBODY>
	  </TABLE>

	  <TABLE class=ViewForm>
        <COLGROUP>
		<COL width="30%">
  		<COL width="70%">
        <TBODY>
        <TR class=Title>
            <TH colSpan=2><%=SystemEnv.getHtmlLabelName(570,user.getLanguage())%></TH>
          </TR>
        <TR class=Spacing style="height: 1px">
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
          <TD class=Field><BUTTON type="button" class=Calendar onClick="getCrmDate(<%=i%>)"></BUTTON> 
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
          <TD class=Field><INPUT class=InputStyle maxLength=30 onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("nff0<%=i%>")' name="nff0<%=i%>" value="<%=RecordSet.getString("numberfield"+i)%>" SIZE="35"></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
		<%}
	}
	for(int i=1;i<=5;i++)
	{
		if(RecordSetFF.getString(i*2+21).equals("1"))
		{%>
        <TR>
          <TD><%=Util.toScreen(RecordSetFF.getString(i*2+20),user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=100 name="tff0<%=i%>" value="<%=Util.toScreen(RecordSet.getString("textfield"+i),user.getLanguage())%>" SIZE="35"></TD>
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
        <TR class=Spacing style="height: 1px">
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
        <TR class=Spacing style="height: 1px">
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
<%if(!isCustomerSelf){%>
		<TR>
          <TD><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></TD>
          <TD class=Field>
              <INPUT type=hidden class="wuiBrowser" _required="yes" _displayText="<%=Util.toScreen(CustomerTypeComInfo.getCustomerTypename(RecordSet.getString("type")),user.getLanguage()) %>" _url="/systeminfo/BrowserMain.jsp?url=/CRM/Maint/CustomerTypeBrowser.jsp" name=Type value="<%="0".equals(RecordSet.getString("type"))?"":Util.null2String(RecordSet.getString("type"))%>">  
               </TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></TD>
          <TD class=Field>
              <INPUT class="wuiBrowser" _displayText="<%=Util.toScreen(CustomerDescComInfo.getCustomerDescname(RecordSet.getString("description")),user.getLanguage()) %>" _url="/systeminfo/BrowserMain.jsp?url=/CRM/Maint/CustomerDescBrowser.jsp" _required="yes" type=hidden name=Description value="<%="0".equals(RecordSet.getString("description"))?"":Util.null2String(RecordSet.getString("description"))%>"></TD>
              
         </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>       
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(576,user.getLanguage())%></TD>
          <TD class=Field>
          	<INPUT class="wuiBrowser" _displayText="<%=Util.toScreen(CustomerSizeComInfo.getCustomerSizedesc(RecordSet.getString("size_n")),user.getLanguage())%>" _url="/systeminfo/BrowserMain.jsp?url=/CRM/Maint/CustomerSizeBrowser.jsp" _required="yes" type=hidden name=Size value="<%="0".equals(RecordSet.getString("size_n"))?"":Util.null2String(RecordSet.getString("size_n"))%>">   
          </TD>
              
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>          
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(645,user.getLanguage())%></TD>
          <TD class=Field>
            	<%
            	//试用申请类分配客户来源只有客户管理员能修改
            	if("8".equals(RecordSet.getString("source"))||"19".equals(RecordSet.getString("source"))||"30".equals(RecordSet.getString("source"))
            			||"31".equals(RecordSet.getString("source"))||"32".equals(RecordSet.getString("source"))||"20".equals(RecordSet.getString("source"))){ 
            		rs.executeSql("select id from HrmRoleMembers where  roleid = 8 and rolelevel = 2 and resourceid = " + user.getUID());
        			if(rs.next()) {
        		%>
              <INPUT class="wuiBrowser" _displayText="<%=Util.toScreen(ContactWayComInfo.getContactWayname(RecordSet.getString("source")),user.getLanguage())%>" _url="/systeminfo/BrowserMain.jsp?url=/CRM/Maint/ContactWayBrowser.jsp" _required="yes" type=hidden name=Source value="<%="0".equals(RecordSet.getString("source"))?"":Util.null2String(RecordSet.getString("source"))%>" _callBack="changeSource">
              	<%		
        			}else{
            	%>
            	<%=Util.toScreen(ContactWayComInfo.getContactWayname(RecordSet.getString("source")),user.getLanguage())%>
            	<input type="hidden" name=Source value="<%=Util.null2String(RecordSet.getString("source")) %>" />
              <%}}else{ %>
               <INPUT class="wuiBrowser" _displayText="<%=Util.toScreen(ContactWayComInfo.getContactWayname(RecordSet.getString("source")),user.getLanguage())%>" _url="/systeminfo/BrowserMain.jsp?url=/CRM/Maint/ContactWayBrowser.jsp" _required="yes" type=hidden name=Source value="<%="0".equals(RecordSet.getString("source"))?"":Util.null2String(RecordSet.getString("source"))%>" _callBack="changeSource">
              <%} %>
              </TD>
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
              <INPUT class="wuiBrowser" _displayText=" <%=seclist %>" _url="/systeminfo/BrowserMain.jsp?url=/CRM/Maint/SectorInfoBrowser.jsp" _required="yes" type=hidden name=Sector value="<%="0".equals(RecordSet.getString("sector"))?"":Util.null2String(RecordSet.getString("sector"))%>">
              </TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr> 
<%}else{ %>
		<TR>
          <TD><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></TD>
          <TD class=Field><%=Util.toScreen(CustomerTypeComInfo.getCustomerTypename(RecordSet.getString("type")),user.getLanguage())%>
          <input type="hidden" name="Type" value="<%=Util.null2String(RecordSet.getString("type"))%>"/></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></TD>
          <TD class=Field><%=Util.toScreen(CustomerDescComInfo.getCustomerDescname(RecordSet.getString("description")),user.getLanguage())%>
          <input type="hidden" name="Description" value="<%=Util.null2String(RecordSet.getString("description"))%>"/></TD>
         </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(576,user.getLanguage())%></TD>
          <TD class=Field><%=Util.toScreen(CustomerSizeComInfo.getCustomerSizedesc(RecordSet.getString("size_n")),user.getLanguage())%>
          <input type="hidden" name="Size" value="<%=Util.null2String(RecordSet.getString("size_n"))%>"/></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(645,user.getLanguage())%></TD>
          <TD class=Field><%=Util.toScreen(ContactWayComInfo.getContactWayname(RecordSet.getString("source")),user.getLanguage())%>
          <input type="hidden" name="Source" value="<%=Util.null2String(RecordSet.getString("source"))%>"/></TD>
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
          <%=seclist%>
          <input type="hidden" name="Sector" value="<%=Util.null2String(RecordSet.getString("sector"))%>"/>
          </TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
<%} %>  
<%if(!user.getLogintype().equals("2")) {%>			
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(1278,user.getLanguage())%></TD>
          <TD class=Field>
              <INPUT class="wuiBrowser" _displayText="<a href='/hrm/resource/HrmResource.jsp?id=<%=RecordSet.getString("manager")%>'><%=Util.toScreen(ResourceComInfo.getResourcename(RecordSet.getString("manager")),user.getLanguage())%></a>" _displayTemplate="<A href='/hrm/resource/HrmResource.jsp?id=#b{id}'>#b{name}</A>" _required="yes" _displayText="<%=user.getUsername()%>" _url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp" type=hidden name=Manager value="<%=RecordSet.getString("manager")%>">
              </TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>        
        <!--TR>
          <TD><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></TD>
          <TD class=Field><button class=Browser id=SelectDeparment onClick="onShowDepartment()"></button> 
              <span id=departmentspan><a href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=RecordSet.getString("department")%>"><%=Util.toScreen(DepartmentComInfo.getDepartmentname(RecordSet.getString("department")),user.getLanguage())%></a></span> 
              <input class=InputStyle id=departmentid type=hidden name=Department value=<%=RecordSet.getString("department")%>></TD>
        </TR -->        
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(132,user.getLanguage())%></TD>
          <TD class=Field>
               <input class=wuiBrowser _displayText="<a href='/CRM/data/Viewcustomer.jsp?CustomerID=<%=RecordSet.getString("agent")%>'><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(RecordSet.getString("agent")),user.getLanguage())%></a>" _displayTemplate="<A href='/CRM/data/ViewCustomer.jsp?CustomerID=#b{id}'>#b{name}</A>" _url="/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp?sqlwhere=where t1.type in (3,4,11,12,13,14,15,16,17,18,20,21,25)" type=hidden id=Agent name=Agent value="<%="0".equals(RecordSet.getString("agent"))?"":Util.null2String(RecordSet.getString("agent"))%>" 
               <%if("22".equals(RecordSet.getString("source"))||"23".equals(RecordSet.getString("source"))
               		||"24".equals(RecordSet.getString("source"))||"25".equals(RecordSet.getString("source"))
               		||"26".equals(RecordSet.getString("source"))||"27".equals(RecordSet.getString("source"))){%>
          	 			_required="yes"
          	 		<%}else{%>
          	 			_required="no"
          	 		<%}%>
               >
              </TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>   
<%} else {%>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(1278,user.getLanguage())%></TD>
          <TD class=Field> <span 
            id=manageridspan><%=Util.toScreen(ResourceComInfo.getResourcename(RecordSet.getString("manager")),user.getLanguage())%></span> 
              <INPUT class=InputStyle type=hidden name=Manager value=<%=RecordSet.getString("manager")%>></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>        
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></TD>
          <TD class=Field> 
              <span id=departmentspan>
                <%if(RecordSet.getString("department").equals("")){%><IMG src="/images/BacoError_wev8.gif" align=absMiddle><%}%>
                <%=Util.toScreen(DepartmentComInfo.getDepartmentname(RecordSet.getString("department")),user.getLanguage())%>
              </span> 
              <input class=InputStyle id=departmentid type=hidden name=Department value=<%=RecordSet.getString("department")%>></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>        
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(132,user.getLanguage())%></TD>
          <TD class=Field>  
              <span id=Agentspan> <a href="/CRM/data/Viewcustomer.jsp?CustomerID=<%=RecordSet.getString("agent")%>"><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(RecordSet.getString("agent")),user.getLanguage())%></a></span> 
              <input class=InputStyle type=hidden name=Agent value=<%=RecordSet.getString("agent")%>></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>  
<%}%>

		<% 
			//取得开拓人员
			String exploiterIds = "";
			String exploiterNames = "";
			RecordSetE.executeSql("select exploiterId from CRM_CustomerExploiter where customerId = "+ CustomerID);
			while(RecordSetE.next()){
				exploiterIds += ","+RecordSetE.getInt("exploiterId");
				exploiterNames += "<a href='javaScript:openhrm("+RecordSetE.getInt("exploiterId")+")' onclick='pointerXY(event)'>"+ResourceComInfo.getLastname(""+RecordSetE.getInt("exploiterId"))+"</a>&nbsp;";
			}
			if(!exploiterIds.equals("")){
				exploiterIds = exploiterIds.substring(1);
			}
		%>

		<TR>
          <TD><%=SystemEnv.getHtmlLabelName(25171,user.getLanguage())%><!-- 开拓人员 --></TD>
          <TD class=Field>
          <%if(!user.getLogintype().equals("2")) {%>
          	  	<INPUT class="wuiBrowser" _displayTemplate="<A href='javaScript:openhrm(#b{id})' onclick='pointerXY(event)'>#b{name}</A>" 
          	 		_displayText="<%=exploiterNames%>" _param="resourceids" id="exploiterIds"
          	 		_url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp" type="hidden" name="exploiterIds" value="<%=exploiterIds%>"
          	 		<%if("1".equals(RecordSet.getString("source"))||"18".equals(RecordSet.getString("source"))){%>
          	 			_required="yes"
          	 		<%}else{%>
          	 			_required="no"
          	 		<%}%>
          	 		>
		  <%}else{ %>
			<%=exploiterNames %>
			<input type="hidden" name="exploiterIds" value="<%=exploiterIds%>"/>
		  <%} %>          	   
          </TD>
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>
		<% 
			//取得客服负责人
			String principalIds = "";
			String principalNames = "";
			RecordSetP.executeSql("select principalId from CS_CustomerPrincipal where customerId = "+ CustomerID);
			while(RecordSetP.next()){
				principalIds += ","+RecordSetP.getInt("principalId");
				principalNames += "<a href='/hrm/resource/HrmResource.jsp?id="+RecordSetP.getInt("principalId")+"' target='_blank'>"+ResourceComInfo.getLastname(""+RecordSetP.getInt("principalId"))+"</a>&nbsp;";
			}
			if(!principalIds.equals("")){
				principalIds = principalIds.substring(1);
			}
		%>
		<TR>
          <TD><%=SystemEnv.getHtmlLabelName(24976,user.getLanguage())%><!-- 客服负责人 --></TD>
          <TD class=Field>
          	<%if(!user.getLogintype().equals("2")) {%>
          		<INPUT class="wuiBrowser" _displayTemplate="<A href='javaScript:openhrm(#b{id})' onclick='pointerXY(event)'>#b{name}</A>" 
          	 		_displayText="<%=principalNames%>" _param="resourceids" id=principalIds
          	 		_url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp" type=hidden name=principalIds value="<%=principalIds%>">
         	<%}else{ %>
				<%=principalNames %>
				<input type="hidden" name="principalIds" value="<%=principalIds%>"/>
		  	<%} %>   
          </TD>
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>
		
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(591,user.getLanguage())%></TD>
          <TD class=Field>
				<%if(!isCustomerSelf){%>
				 
				<input class="wuiBrowser" _displayText="<a href='/CRM/data/Viewcustomer.jsp?CustomerID=<%=RecordSet.getString("parentid")%>'><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(RecordSet.getString("parentid")),user.getLanguage())%></a>" type=hidden _displayTemplate="<A href='/CRM/data/ViewCustomer.jsp?CustomerID=#b{id}'>#b{name}</A>" _url="/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp" name=Parent value=<%=RecordSet.getString("parentid")%>>
				<%}else{%>
              <span id=Parentspan><a href="/CRM/data/Viewcustomer.jsp?CustomerID=<%=RecordSet.getString("parentid")%>"><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(RecordSet.getString("parentid")),user.getLanguage())%></a></span> 
              <input type=hidden name=Parent value=<%=RecordSet.getString("parentid")%>>
              <%} %>
              </TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>      
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%></TD>
          <TD class=Field>
				<%if(!isCustomerSelf){%>
				
				<INPUT class=wuiBrowser _displayText="<a href='/docs/docs/DocDsp.jsp?id=<%=RecordSet.getString("documentid")%>'><%=Util.toScreen(DocComInfo.getDocname(RecordSet.getString("documentid")),user.getLanguage())%></a>" _displayTemplate="<a href='/docs/docs/DocDsp.jsp?id=#b{id}'>#b{name}</a>" _url="/docs/DocBrowserMain.jsp?url=/docs/docs/DocBrowser.jsp" type=hidden name=Document value=<%=RecordSet.getString("documentid")%>>
				
				<%}else{%>      
     	 <SPAN ID=Documentname><a href="/docs/docs/DocDsp.jsp?id=<%=RecordSet.getString("documentid")%>"><%=Util.toScreen(DocComInfo.getDocname(RecordSet.getString("documentid")),user.getLanguage())%></a></SPAN>
        <INPUT class=InputStyle type=hidden name=Document value=<%=RecordSet.getString("documentid")%>>
        <%} %>
        </TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr> 
		
		<TR>
          <TD><%=SystemEnv.getHtmlLabelName(6069,user.getLanguage())%></TD>
          <TD class=Field>
				<%if(!isCustomerSelf){%>
				
				<INPUT class=wuiBrowser _displayText="<a href='/docs/docs/DocDsp.jsp?id=<%=RecordSet.getString("introductionDocid")%>'><%=Util.toScreen(DocComInfo.getDocname(RecordSet.getString("introductionDocid")),user.getLanguage())%></a>" _displayTemplate="<a href='/docs/docs/DocDsp.jsp?id=#b{id}'>#b{name}</a>" _url="/docs/DocBrowserMain.jsp?url=/docs/docs/DocBrowser.jsp" type=hidden name=introductionDocid value=<%=RecordSet.getString("introductionDocid")%>>
				
				<%}else{%>      
      	<SPAN ID=introductionDocname><a href="/docs/docs/DocDsp.jsp?id=<%=RecordSet.getString("introductionDocid")%>"><%=Util.toScreen(DocComInfo.getDocname(RecordSet.getString("introductionDocid")),user.getLanguage())%></a></SPAN>
        <INPUT class=InputStyle type=hidden name=introductionDocid value=<%=RecordSet.getString("introductionDocid")%>>
        <%} %>
        </TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr> 

	<%if(!user.getLogintype().equals("2")){%>
        <TR>
		  <TD><%=SystemEnv.getHtmlLabelName(120,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(139,user.getLanguage())%></TD>
		  <TD class=Field> 
            <INPUT class=InputStyle maxLength=3 size=5 	name=seclevel onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("seclevel");checkinput("seclevel","seclevelimage")' value="<%=RecordSet.getString("seclevel")%>">
		    <SPAN id=seclevelimage>
                <%if(RecordSet.getString("seclevel").equals("")){%><IMG src="/images/BacoError_wev8.gif" align=absMiddle><%}%>
            </SPAN>
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
        <TR class=Spacing style="height: 1px">
          <TD class=Line1 colSpan=2></TD></TR>
<%if(!user.getLogintype().equals("2")){%>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(6097,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=11 size=20 name="CreditAmount" id="CreditAmount" onchange='checkinput("CreditAmount","CreditAmountimage");checkdecimal_length("CreditAmount",8)' onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("CreditAmount")' value = "<%=RecordSet.getString("CreditAmount")%>"><SPAN id=CreditAmountimage><%if (RecordSet.getString("CreditAmount").equals("")) {%><IMG src="/images/BacoError_wev8.gif" align=absMiddle><%}%></SPAN></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(6098,user.getLanguage())%></TD>
           <TD class=Field><INPUT class=InputStyle maxLength=3 size=20 name="CreditTime" id="CreditTime" onchange='checkinput("CreditTime","CreditTimeimage")' onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("CreditTime")' value = "<%=RecordSet.getString("CreditTime")%>"><SPAN id=CreditTimeimage><%if (RecordSet.getString("CreditTime").equals("")) {%><IMG src="/images/BacoError_wev8.gif" align=absMiddle><%}%></SPAN></TD>
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
          <TD class=Field><INPUT class=InputStyle maxLength=50 size=20 name="accountname" value="<%=accountName%>"></TD>
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
        <TR class=Spacing style="height: 1px">
          <TD class=Line1 colSpan=2></TD></TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(189,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(590,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=5 size=5 name="Fincode" value="<%=Util.toScreenToEdit(RecordSet.getString("fincode"),user.getLanguage())%>" SIZE="35"></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(649,user.getLanguage())%>11</TD>
          <TD class=Field><button class=browser onClick="onShowCurrency()"></button><span id=currencyspan><%=Util.toScreen(CurrencyComInfo.getCurrencyname(RecordSet.getString("currency")),user.getLanguage())%>
          </span><INPUT class=InputStyle type=hidden maxLength=5 size=5 name="Currency" value="<%=Util.toScreen(RecordSet.getString("currency"),user.getLanguage())%>"></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(581,user.getLanguage())%></TD>
          <TD class=Field><button class=browser onClick="onShowTradeInfo()"></button><span id=tradeinfospan><%=Util.toScreen(TradeInfoComInfo.getTradeInfoname(RecordSet.getString("contractlevel")),user.getLanguage())%></span><INPUT class=InputStyle  type=hidden name="ContractLevel" value="<%=Util.toScreenToEdit(RecordSet.getString("contractlevel"),user.getLanguage())%>"></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(580,user.getLanguage())%></TD>
          <TD class=Field><button class=browser onClick="onShowCreditInfo()"></button><span id=creditinfospan><%=Util.toScreen(CreditInfoComInfo.getCreditInfoname(RecordSet.getString("creditlevel")),user.getLanguage())%></span><INPUT class=InputStyle type=hidden name="CreditLevel" value="<%=Util.toScreen(RecordSet.getString("creditlevel"),user.getLanguage())%>"></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(650,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=50 size=15 name="CreditOffset" onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("CreditOffset")' value="<%=Util.toScreenToEdit(RecordSet.getString("creditoffset"),user.getLanguage())%>" SIZE="35"></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(651,user.getLanguage())%>(%)</TD>
          <TD class=Field><INPUT class=InputStyle maxLength=10 size=5 name="Discount" onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("Discount")' value="<%=Util.toScreenToEdit(RecordSet.getString("discount"),user.getLanguage())%>" SIZE="35"></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(653,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=50 name="TaxNumber" value="<%=Util.toScreenToEdit(RecordSet.getString("taxnumber"),user.getLanguage())%>" SIZE="35"></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(654,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=50 name="BankAccount" value="<%=Util.toScreenToEdit(RecordSet.getString("bankacount"),user.getLanguage())%>" SIZE="35"></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(655,user.getLanguage())%></TD>
          <TD class=Field><button class=browser onClick="onShowInvoiceAcount()"></button><span id=invoiceacountspan><a href="ViewCustomer.jsp?CustomerID=<%=RecordSet.getString("invoiceacount")%>"><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(RecordSet.getString("invoiceacount")),user.getLanguage())%></a></span><INPUT class=InputStyle type=hidden name="InvoiceAcount" value="<%=Util.toScreen(RecordSet.getString("invoiceacount"),user.getLanguage())%>"></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(657,user.getLanguage())%></TD>
          <TD class=Field><button class=browser onClick="onShowDeliveryType()"></button><span id=deliveryspan><%=Util.toScreen(DeliveryTypeComInfo.getDeliveryTypename(RecordSet.getString("deliverytype")),user.getLanguage())%></span><INPUT class=InputStyle type=hidden name="DeliveryType" value="<%=Util.toScreen(RecordSet.getString("deliverytype"),user.getLanguage())%>"></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(658,user.getLanguage())%></TD>
          <TD class=Field><button class=browser onClick="onShowPaymentTerm()"></button><span id=paymentspan><%=Util.toScreen(PaymentTermComInfo.getPaymentTermname(RecordSet.getString("paymentterm")),user.getLanguage())%></span><INPUT class=InputStyle type=hidden name="PaymentTerm" value="<%=Util.toScreen(RecordSet.getString("paymentterm"),user.getLanguage())%>"></TD>
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
          <TD class=Field><INPUT class=InputStyle maxLength=50 size=14 name="Credit" value="<%=Util.toScreenToEdit(RecordSet.getString("creditcard"),user.getLanguage())%>" STYLE="width:45%"><SPAN STYLE="width:5%"></SPAN><button class=calendar onClick="getCreditDate()"></button><span id=creditexpirespan><%=Util.toScreen(RecordSet.getString("creditexpire"),user.getLanguage())%></span><INPUT class=InputStyle type=hidden name="CreditExpire" value="<%=Util.toScreen(RecordSet.getString("creditexpire"),user.getLanguage())%>" STYLE="width:45%"></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
        </TBODY>
	  </TABLE>
<%}else{%>
	    <INPUT type=hidden class=InputStyle maxLength=5 size=5 name="Fincode" value="<%=Util.toScreenToEdit(RecordSet.getString("fincode"),user.getLanguage())%>" SIZE="35">
		<INPUT type=hidden class=InputStyle type=hidden maxLength=5 size=5 name="Currency" value="<%=Util.toScreen(RecordSet.getString("currency"),user.getLanguage())%>">
		<INPUT type=hidden class=InputStyle  type=hidden name="ContractLevel" value="<%=Util.toScreenToEdit(RecordSet.getString("contractlevel"),user.getLanguage())%>">
		<INPUT type=hidden class=InputStyle type=hidden name="CreditLevel" value="<%=Util.toScreen(RecordSet.getString("creditlevel"),user.getLanguage())%>">
		<INPUT type=hidden class=InputStyle maxLength=50 size=15 name="CreditOffset" onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("CreditOffset")' value="<%=Util.toScreenToEdit(RecordSet.getString("creditoffset"),user.getLanguage())%>" SIZE="35">
		<INPUT type=hidden class=InputStyle maxLength=10 size=5 name="Discount" onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("Discount")' value="<%=Util.toScreenToEdit(RecordSet.getString("discount"),user.getLanguage())%>" SIZE="35">
		<INPUT type=hidden class=InputStyle maxLength=50 name="TaxNumber" value="<%=Util.toScreenToEdit(RecordSet.getString("taxnumber"),user.getLanguage())%>" SIZE="35">
		<INPUT type=hidden class=InputStyle maxLength=50 name="BankAccount" value="<%=Util.toScreenToEdit(RecordSet.getString("bankacount"),user.getLanguage())%>" SIZE="35">
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

<% 

String budget="";
String expectedDate="";
/**
String baseSql = "select baseinfoid,budget,expecteddate,projectname,hasbuild,company,cost,situation,evaluate,ifpartners from crm_baseinfo where crmid = "+CustomerID+" order by baseinfoid";
RecordSetBase.executeSql(baseSql);
 
if(RecordSetBase.next()){
	 budget = RecordSetBase.getString("budget");
	 expectedDate = RecordSetBase.getString("expecteddate");
}
RecordSetBase.beforFirst();

String demandSql = "select demandinfoid,description,ifKeydemand,ifHelpus from crm_demandinfo where crmid = "+CustomerID+" order by demandinfoid";
RecordSetDemand.executeSql(demandSql);
String importantSql = "select importantmanid,role,name,department,post,telephone,mobile,ifagree,point from crm_importantman where crmid = "+CustomerID+" order by importantmanid";
RecordSetImportant.executeSql(importantSql);
String competitorSql = "select competitorsid,oppname,oppadvantage,oppdisadvantage from crm_competitorsinfo where crmid = "+CustomerID+" order by competitorsid";
RecordSetCompetitor.executeSql(competitorSql);
*/
%>

<SCRIPT language="javascript"  type='text/javascript' src="/js/ArrayList_wev8.js"></SCRIPT>
<script type="text/javascript">
function onShowResource(inputname,spanname) {
    tmpids = document.all(inputname).value;
    if(tmpids!="-1"){ 
     url="/hrm/resource/MutiResourceBrowser.jsp?resourceids="+tmpids;
    }else{
     url="/hrm/resource/MutiResourceBrowser.jsp";
    }
    id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url="+url);
    try {
        jsid = new VBArray(id).toArray();
    } catch(e) {
        return;
    }
    if (jsid != null) {
        if (jsid[0] != "0" && jsid[1]!="") {
            document.all(spanname).innerHTML = jsid[1].substring(1);
            document.all(inputname).value = jsid[0].substring(1);
        } else {
            document.all(spanname).innerHTML = "";
            document.all(inputname).value = "";
        }
    }
}


var baseIndex = <%=RecordSetBase.getCounts()%>;
function addBaseInfoRow(){
	//var spaceRow = baseInfoTable.insertRow(); 
	//spaceRow.className="Line";  
	//var spaceCell = spaceRow.insertCell();
	//spaceCell.colSpan = 8;

	var oRow;      
	oRow = baseInfoTable.insertRow();     
    oRow.className="DataLight";  
    for (var i = 1; i <= 8; i++) {
    	oCell = oRow.insertCell();
 		oCell.align = "left";
        
    	var oDiv = document.createElement("div");
     	var sHtml=""; 
     	switch (i){               
        	case 1:  
            	//oCell.style.backgroundColor="#e7e7e7";
            	sHtml="<input type=\"checkbox\" id=\"baseCheck\"><input type=\"hidden\" name=\"baseIndex\" value=\""+baseIndex+"\" />"; 
            	break ;
             case 2:  	                    
                 sHtml="<input name=\"projectName"+baseIndex+"\" class=InputStyle style='width:98%' maxLength=50 />";                   
                 break ;
			 case 3:  	
                 sHtml="<select size=\"1\" name=\"hasBuild"+baseIndex+"\" class=InputStyle><option></option><option value=1><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%></option><option value=0><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%></option></select>";  
                 break ;
             case 4:  						
                 sHtml="<input name=\"company"+baseIndex+"\" class=InputStyle style='width:98%' maxLength=50 />"; 
                 break ;
             case 5:  						
                 sHtml="<input name=\"cost"+baseIndex+"\" class=InputStyle style='width:98%' maxLength=25 />"; 
                 break ;
             case 6:  						
                 sHtml="<input name=\"situation"+baseIndex+"\" class=InputStyle style='width:98%' maxLength=250 />"; 
                 break ;
             case 7:  						
                 sHtml="<input name=\"evaluate"+baseIndex+"\" class=InputStyle style='width:98%' maxLength=250 />"; 
                 break ;
             case 8:  						
                 sHtml="<select size=\"1\" name=\"ifPartners"+baseIndex+"\" class=InputStyle><option></option><option value=1><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%></option><option value=0><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%></option></select>";  
                 break ;
             default:
                 sHtml=" ";                
                 break ;
         }        
         oDiv.innerHTML = sHtml;
		 oCell.appendChild(oDiv);              
     }
     baseIndex++;
}

var demandIndex = <%=RecordSetDemand.getCounts()%>;
function addDemandRow(){ 
	//var spaceRow = demandTable.insertRow(); 
	//spaceRow.className="Line";  
	//var spaceCell = spaceRow.insertCell();
	//spaceCell.colSpan = 4;

	var oRow;      
	oRow = demandTable.insertRow();     
    oRow.className="DataLight";  

        for (var i = 1; i <= 4; i++) {
            oCell = oRow.insertCell();
    		oCell.align = "left";
           
            var oDiv = document.createElement("div");
            var sHtml=""; 
            switch (i){               
               case 1:  
                    //oCell.style.backgroundColor="#e7e7e7";
                    sHtml="<input type=\"checkbox\" id=\"demandCheck\" value=''><input type=\"hidden\" name=\"demandIndex\" value=\""+demandIndex+"\" />"; 
                    break ;
                case 2:  	                    
                    sHtml="<input name=\"description"+demandIndex+"\" class=InputStyle style='width:98%' maxLength=250/>";                   
                    break ;
				case 3:  	
                 	sHtml="<select size=\"1\" name=\"ifKeydemand"+demandIndex+"\" class=InputStyle><option></option><option value=1><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%></option><option value=0><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%></option></select>";  
                    break ;
                case 4:  						
                 	sHtml="<select size=\"1\" name=\"ifHelpus"+demandIndex+"\" class=InputStyle><option></option><option value=1><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%></option><option value=0><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%></option></select>";  
                    break ;
                default:
                    sHtml=" ";                
                    break ;
            }        
            oDiv.innerHTML = sHtml;
			oCell.appendChild(oDiv);              
        }
        demandIndex++;
}

var importantIndex = <%=RecordSetImportant.getCounts()%>;
function addImportantRow(){
	//var spaceRow = importantTable.insertRow(); 
	//spaceRow.className="Line";  
	//var spaceCell = spaceRow.insertCell();
	//spaceCell.colSpan = 9;

	var oRow;      
	oRow = importantTable.insertRow();     
    oRow.className="DataLight";  
    for (var i = 1; i <= 9; i++) {
    	oCell = oRow.insertCell();
 		oCell.align = "left";
        
    	var oDiv = document.createElement("div");
     	var sHtml=""; 
     	switch (i){               
        	case 1:  
            	//oCell.style.backgroundColor="#e7e7e7";
            	sHtml="<input type=\"checkbox\" id=\"importantCheck\"><input type=\"hidden\" name=\"importantIndex\" value=\""+importantIndex+"\" />"; 
            	break ;
             case 2:  	                    
                 sHtml="<input name=\"role"+importantIndex+"\" class=InputStyle style='width:98%' maxLength=50 />";                   
                 break ;
			 case 3:  	
                 sHtml="<input name=\"name"+importantIndex+"\" class=InputStyle style='width:98%' maxLength=50 />"; 
                 break ;
             case 4:  						
                 sHtml="<input name=\"department"+importantIndex+"\" class=InputStyle style='width:98%' maxLength=50 />"; 
                 break ;
             case 5:  						
                 sHtml="<input name=\"post"+importantIndex+"\" class=InputStyle style='width:98%' maxLength=50 />"; 
                 break ;
             case 6:  						
                 sHtml="<input name=\"telephone"+importantIndex+"\" class=InputStyle style='width:98%' maxLength=50 />"; 
                 break ;
             case 7:  						
                 sHtml="<input name=\"mobile"+importantIndex+"\" class=InputStyle style='width:98%' maxLength=50 />"; 
                 break ;
             case 8:  						
                 sHtml="<select size=\"1\" name=\"ifAgree"+importantIndex+"\" class=InputStyle><option></option><option value=1><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%></option><option value=0><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%></option></select>";  
                 break ;
             case 9:  						
                 sHtml="<input name=\"point"+importantIndex+"\" class=InputStyle style='width:98%' maxLength=50/>"; 
                 break ;
             default:
                 sHtml=" ";                
                 break ;
         }        
         oDiv.innerHTML = sHtml;
	     oCell.appendChild(oDiv);              
     }
     importantIndex++;
}

var competitorIndex = <%=RecordSetCompetitor.getCounts()%>;
function addCompetitorRow(){ 
	//var spaceRow = competitorTable.insertRow(); 
	//spaceRow.className="Line";  
	//var spaceCell = spaceRow.insertCell();
	//spaceCell.colSpan = 4;

	var oRow;      
	oRow = competitorTable.insertRow();     
    oRow.className="DataLight";  

        for (var i = 1; i <= 4; i++) {
            oCell = oRow.insertCell();
    		oCell.align = "left";
           
            var oDiv = document.createElement("div");
            var sHtml=""; 
            switch (i){               
               case 1:  
                    //oCell.style.backgroundColor="#e7e7e7";
                    sHtml="<input type=\"checkbox\" id=\"competitorCheck\" value=''><input type=\"hidden\" name=\"competitorIndex\" value=\""+competitorIndex+"\" />"; 
                    break ;
                case 2:  	                    
                    sHtml="<input name=\"oppName"+competitorIndex+"\" class=InputStyle style='width:98%' maxLength=50/>";                   
                    break ;
				case 3:  	
                    sHtml="<input name=\"oppAdvantage"+competitorIndex+"\" class=InputStyle style='width:98%' maxLength=50/>";                   
                    break ;
                case 4:  						
                    sHtml="<input name=\"oppDisadvantage"+competitorIndex+"\" class=InputStyle style='width:98%' maxLength=50/>";                   
                    break ;
                default:
                    sHtml=" ";                
                    break ;
            }        
            oDiv.innerHTML = sHtml;
			oCell.appendChild(oDiv);              
        }
        competitorIndex++;
}

function deleteRow(tableId,rowId,chkAllObj){
		var message="确定要删除？";
        if(!confirm(message)) return  ;
        try { 
            var taskItems = document.getElementsByName(rowId);
			var delList = new ArrayList();
			var len = taskItems.length;
			for (var i=0;i<len;i++)	{
				if (taskItems[i].checked){
					//document.getElementById(tableId).deleteRow(2*i+1);
					document.getElementById(tableId).deleteRow(i+1);
					len=len-1;
					i=i-1;
				}		
			}
            document.getElementById(chkAllObj).checked = false ;
        } catch(ex){}
}

function onCheckAll(obj,checkId){
    var taskItems = document.getElementsByName(checkId);
    for (var i=0;i<taskItems.length;i++){
        taskItems[i].checked= obj.checked ;
    }
}

 function onHiddenImgClick(divObj,imgObj){
     if (imgObj.objStatus=="show"){
        divObj.style.display='none' ;       
        imgObj.src="/images/down_wev8.jpg";
		if(readCookie("languageidweaver")==8){
			imgObj.title="click then expand";
		}
		else if(readCookie("languageidweaver")==9){ 
			imgObj.title="點擊展開"; 
		}
		else {
			imgObj.title="点击展开";
		}	       
        imgObj.objStatus="hidden";
     } else {        
        divObj.style.display='' ;    
        imgObj.src="/images/up_wev8.jpg";
		if(readCookie("languageidweaver")==8){
			imgObj.title="click then hidden";
		}
		else if(readCookie("languageidweaver")==9){ 
			imgObj.title="點擊隱藏"; 
		}
		else {
			imgObj.title="点击隐藏";
		}        
        imgObj.objStatus="show";
     }
 }
 function onShowDiv(id){
		var spanId = id+"Span";
		if(document.getElementById(id).style.display == ""){
			document.getElementById(id).style.display = "none";
			document.all(spanId).outerHTML = "<span id='"+spanId+"' style='font-size: 10'>▲</span>";
		}else{
			document.getElementById(id).style.display = "";
			document.all(spanId).outerHTML = "<span id='"+spanId+"' style='font-size: 10'>▼</span>";
		}
}
</script>
<br/>
<!-- 
<table class=ViewForm style="display: none">
  <TBODY>
  <TR>
	<TD vAlign=top>
	<div id="divInfoList" style="display:''">
		<TABLE  CLASS="viewForm"  valign="top">
            <TR CLASS="title">
                <TH  WIDTH="80%" style="color: #003F7D">客户基础信息表</TH>
                <TD WIDTH="20%">
                    <div align="right">
                        <span id="divAddAndDel">
                            <a  style="cursor:hand" onclick="addBaseInfoRow()"><%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></a>&nbsp;
                            <a  style="cursor:hand" onclick="deleteRow('baseInfoTable','baseCheck','baseChkAllObj')"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a>&nbsp;  
                        </span>
                    <div>
                </TD>
             </TR>
		    <TR style="height: 1px"><TD CLASS="line1" colspan="2"></TD></TR>                
		 </TABLE>
		<TABLE class=ViewForm>
			<TBODY>
				<TR>
					<td width="15%">客户方预算</td>
					<td class=Field width="35%">
						<select name="budget">
							<option value=""></option>
							<option value="10万以下" <%if(budget.equals("10万以下")){%> selected="selected" <%}%>>10万以下</option>
							<option value="10-20万" <%if(budget.equals("10-20万")){%> selected="selected" <%}%>>10-20万</option>
							<option value="20-30万" <%if(budget.equals("20-30万")){%> selected="selected" <%}%>>20-30万</option>
							<option value="30-50万" <%if(budget.equals("30-50万")){%> selected="selected" <%}%>>30-50万</option>
							<option value="50-100万" <%if(budget.equals("50-100万")){%> selected="selected" <%}%>>50-100万</option>
							<option value="100万以上" <%if(budget.equals("100万以上")){%> selected="selected" <%}%>>100万以上</option>
						</select>
					</td>
					<td width="2%"></td>
					<td  width="15%">客户希望上线时间</td>
					<TD class=Field width="35%">
						<BUTTON class=Calendar onclick="gettheDate('expectedDate','expectedDateSpan')"></BUTTON> 
					    <SPAN id="expectedDateSpan" ><%=expectedDate %></SPAN> 
					    <input type="hidden" name="expectedDate" id="expectedDate" value="<%=expectedDate %>">
					</TD>
				</TR>
			</TBODY>
		</TABLE>    
         <TABLE CLASS="ListStyle" valign="top" cellspacing=1 id="baseInfoTable">
             <colgroup>
             <col width="3%">
             <col width="15%">
             <col width="8%">
             <col width="15%">
             <col width="10%">
             <col width="15%">                       
             <col width="20%">                       
             <col width="14%">                       
             <TR class="Header">
             	 <TH><input type="checkbox" onclick="javaScript:onCheckAll(this,'baseCheck')" id="baseChkAllObj"></TH>
                 <TH>项目名称</TH>
                 <TH>是否建设</TH>
                 <TH>供应商厂商</TH>
                 <TH>投入费用</TH>
                 <TH>目前运行情况</TH>
                 <TH>客户方内部评价</TH>
                 <TH>是否是我们的合作伙伴</TH>
             </TR>
<%
int baseIndex=0; 
String baseIds="";
while(RecordSetBase.next()){ 
%>
             <tr class="DataLight">
             	<td><input type="checkbox" id="baseCheck"></td>
             	<td>
	             	<input name="projectName<%=baseIndex%>" class=InputStyle style="width:98%" maxLength=50 value="<%=RecordSetBase.getString("projectname")%>"/>
	             	<input type="hidden" name="baseIndex" value="<%=baseIndex%>" />
             	</td>
             	<td>
             		<select size="1" name="hasBuild<%=baseIndex%>" class=InputStyle>
             			<option></option>
             			<option value=1 <%if(RecordSetBase.getString("hasbuild") !=null && "1".equals(RecordSetBase.getString("hasbuild"))){%> selected="selected" <%}%> >
             				<%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%>
             			</option>
             			<option value=0 <%if(RecordSetBase.getString("hasbuild") !=null && "0".equals(RecordSetBase.getString("hasbuild"))){%> selected="selected" <%}%> >
             				<%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%>
             			</option>
					</select>
             	</td>
             	<td><input name="company<%=baseIndex%>" class=InputStyle style="width:98%" maxLength=50 value="<%=RecordSetBase.getString("company")%>"/></td>
             	<td><input name="cost<%=baseIndex%>" class=InputStyle style="width:98%" maxLength=25 value="<%=RecordSetBase.getString("cost")%>"/></td>
             	<td><input name="situation<%=baseIndex%>" class=InputStyle style="width:98%" maxLength=250 value="<%=RecordSetBase.getString("situation")%>"/></td>
             	<td><input name="evaluate<%=baseIndex%>" class=InputStyle style="width:98%" maxLength=250 value="<%=RecordSetBase.getString("evaluate")%>"/></td>
             	<td>
             		<select size="1" name="ifPartners<%=baseIndex%>" class=InputStyle>
             			<option></option>
             			<option value=1 <%if(RecordSetBase.getString("ifPartners") !=null && "1".equals(RecordSetBase.getString("ifPartners"))){%> selected="selected" <%}%> >
             				<%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%>
             			</option>
             			<option value=0 <%if(RecordSetBase.getString("ifPartners") !=null && "0".equals(RecordSetBase.getString("ifPartners"))){%> selected="selected" <%}%> >
             				<%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%>
             			</option>
					</select>
             	</td>
             </tr>
<% 
	if(baseIndex==0){
		baseIds += " baseinfoid ="+RecordSetBase.getString("baseinfoid");
	}else{
		baseIds += " or baseinfoid = "+RecordSetBase.getString("baseinfoid");
	}
	baseIndex++;
} 
%>       <input type="hidden" name="baseIds" value="<%=baseIds%>" />                 
         </TABLE>
       <TABLE  CLASS="viewForm"  valign="top">
           <TR style="height: 1px"><TD CLASS="line1" colspan="2"></TD></TR>                
        </TABLE>
        <br/>
        <TABLE  CLASS="viewForm"  valign="top">
            <TR CLASS="title">
                <TH  WIDTH="80%" style="color: #003F7D">客户需求信息表</TH>
                <TD WIDTH="20%">
                    <div align="right">
                        <span id="divAddAndDel">
                            <a  style="cursor:hand" onclick="addDemandRow()"><%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></a>&nbsp;
                            <a  style="cursor:hand" onclick="deleteRow('demandTable','demandCheck','demandChkAllObj')"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a>&nbsp;  
                        </span>
                    <div>
                </TD>
             </TR>
            <TR style="height: 1px">
            <TD CLASS="line1" colspan="2"></TD></TR>                
         </TABLE>
            <TABLE CLASS="ListStyle" valign="top" cellspacing=1 id="demandTable">
                <colgroup>
                <col width="3%">
                <col width="60%">
                <col width="16%">
                <col width="16%">                       
                <TR class="Header">
                    <TH><input type="checkbox" onclick="javaScript:onCheckAll(this,'demandCheck')" id="demandChkAllObj"></TH>
                    <TH>需求描述</TH>
                    <TH>是否为客户关键需求</TH>
                    <TH>是否对我们有利</TH>     
                </TR>
<% 
int demandIndex=0; 
String demandIds="";
while(RecordSetDemand.next()){ 
%>
                <tr>
                	<td>
						<input type="checkbox" id="demandCheck" value=''><input type="hidden" name="demandIndex" value="<%=demandIndex%>" />
	                </td>
	                <td> 
	                	<input name="description<%=demandIndex%>" class=InputStyle style="width:98%" maxLength=250 value="<%=RecordSetDemand.getString("description")%>"/>
	                </td>
	                <td>
	             		<select size="1" name="ifKeydemand<%=demandIndex%>" class=InputStyle>
	             			<option></option>
	             			<option value=1 <%if(RecordSetDemand.getString("ifKeydemand") !=null && "1".equals(RecordSetDemand.getString("ifKeydemand"))){%> selected="selected" <%}%> >
	             				<%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%>
	             			</option>
	             			<option value=0 <%if(RecordSetDemand.getString("ifKeydemand") !=null && "0".equals(RecordSetDemand.getString("ifKeydemand"))){%> selected="selected" <%}%> >
	             				<%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%>
	             			</option>
						</select>
	                </td>
	                <td>
	             		<select size="1" name="ifHelpus<%=demandIndex%>" class=InputStyle>
	             			<option></option>
	             			<option value=1 <%if(RecordSetDemand.getString("ifHelpus") !=null && "1".equals(RecordSetDemand.getString("ifHelpus"))){%> selected="selected" <%}%> >
	             				<%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%>
	             			</option>
	             			<option value=0 <%if(RecordSetDemand.getString("ifHelpus") !=null && "0".equals(RecordSetDemand.getString("ifHelpus"))){%> selected="selected" <%}%> >
	             				<%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%>
	             			</option>
						</select>
	                </td>
                </tr>
<% 
	if(demandIndex==0){
		demandIds += " demandinfoid ="+RecordSetDemand.getString("demandinfoid");
	}else{
		demandIds += " or demandinfoid = "+RecordSetDemand.getString("demandinfoid");
	}
	demandIndex++;
} 
%>       <input type="hidden" name="demandIds" value="<%=demandIds%>" />    
            </TABLE>
	       <TABLE  CLASS="viewForm"  valign="top">
	           <TR style="height: 1px"><TD CLASS="line1" colspan="2"></TD></TR>                
	        </TABLE>
        <br/>
        <TABLE  CLASS="viewForm"  valign="top">
            <TR CLASS="title">
                <TH  WIDTH="80%" style="color: #003F7D">关键人信息</TH>
                <TD WIDTH="20%">
                    <div align="right">
                        <span id="divAddAndDel">
                            <a  style="cursor:hand" onclick="addImportantRow()"><%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></a>&nbsp;
                            <a  style="cursor:hand" onclick="deleteRow('importantTable','importantCheck','importantChkAllObj')"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a>&nbsp;  
                        </span>
                    <div>
                </TD>
             </TR>
            <TR style="height: 1px"><TD CLASS="line1" colspan="2"></TD></TR>                
         </TABLE>
            <TABLE CLASS="ListStyle" valign="top" cellspacing=1 id="importantTable">
                <colgroup>
                <col width="3%">
                <col width="15%">
                <col width="11%">
                <col width="12%">
                <col width="12%">
                <col width="11%">                       
                <col width="11%">                       
                <col width="10%">                       
                <col width="15%">                       
                <TR class="Header">
                    <TH><input type="checkbox" onclick="javaScript:onCheckAll(this,'importantCheck')" id="importantChkAllObj"></TH>
                    <TH>项目中的角色</TH>
                    <TH>人名</TH>
                    <TH>部门</TH>
                    <TH>职务</TH>
                    <TH>办公电话</TH>
                    <TH>手机</TH>
                    <TH>是否已加入我们</TH>
                    <TH>他们每一个人的关注点</TH>     
                </TR>
<% 
int importantIndex=0; 
String importantIds="";
while(RecordSetImportant.next()){ 
%>
                <tr class="DataLight">
					<td><input type="checkbox" id="importantCheck"></td>                
	             	<input type="hidden" name="importantIndex" value="<%=importantIndex%>" />
                	<td><input name="role<%=importantIndex%>" class=InputStyle style="width:98%" maxLength=50 value="<%=RecordSetImportant.getString("role")%>"/></td>
                	<td><input name="name<%=importantIndex%>" class=InputStyle style="width:98%" maxLength=50 value="<%=RecordSetImportant.getString("name")%>"/></td>
                	<td><input name="department<%=importantIndex%>" class=InputStyle style="width:98%" maxLength=50 value="<%=RecordSetImportant.getString("department")%>"/></td>
                	<td><input name="post<%=importantIndex%>" class=InputStyle style="width:98%" maxLength=50 value="<%=RecordSetImportant.getString("post")%>"/></td>
                	<td><input name="telephone<%=importantIndex%>" class=InputStyle style="width:98%" maxLength=50 value="<%=RecordSetImportant.getString("telephone")%>"/></td>
                	<td><input name="mobile<%=importantIndex%>" class=InputStyle style="width:98%" maxLength=50 value="<%=RecordSetImportant.getString("mobile")%>"/></td>
	                <td>
	             		<select size="1" name="ifAgree<%=importantIndex%>" class=InputStyle>
	             			<option></option>
	             			<option value=1 <%if(RecordSetImportant.getString("ifAgree") !=null && "1".equals(RecordSetImportant.getString("ifAgree"))){%> selected="selected" <%}%> >
	             				<%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%>
	             			</option>
	             			<option value=0 <%if(RecordSetImportant.getString("ifAgree") !=null && "0".equals(RecordSetImportant.getString("ifAgree"))){%> selected="selected" <%}%> >
	             				<%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%>
	             			</option>
						</select>
	                </td>
                	<td><input name="point<%=importantIndex%>" class=InputStyle style="width:98%" maxLength=50 value="<%=RecordSetImportant.getString("point")%>"/></td>
                </tr>
<% 
	if(importantIndex==0){
		importantIds += " importantmanid ="+RecordSetImportant.getString("importantmanid");
	}else{
		importantIds += " or importantmanid = "+RecordSetImportant.getString("importantmanid");
	}
	importantIndex++;
} 
%>       <input type="hidden" name="importantIds" value="<%=importantIds%>" />    
            </TABLE>
          <TABLE  CLASS="viewForm"  valign="top">
              <TR style="height: 1px"><TD CLASS="line1" colspan="2"></TD></TR>                
           </TABLE>
           <br/>
	       <TABLE  CLASS="viewForm"  valign="top">
	           <TR CLASS="title">
	               <TH  WIDTH="80%" style="color: #003F7D">竞争对手动态跟进</TH>
	               <TD WIDTH="20%">
	                   <div align="right">
	                       <span id="divAddAndDel">
	                           <a  style="cursor:hand" onclick="addCompetitorRow()"><%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></a>&nbsp;
	                           <a  style="cursor:hand" onclick="deleteRow('competitorTable','competitorCheck','competitorChkAllObj')"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a>&nbsp;  
	                       </span>
	                   <div>
	               </TD>
	            </TR>
	           <TR style="height: 1px"><TD CLASS="line1" colspan="2"></TD></TR>                
	        </TABLE>
	           <TABLE CLASS="ListStyle" valign="top" cellspacing=1 id="competitorTable" >
	               <colgroup>
	               <col width="3%">
	               <col width="18%">
	               <col width="39%">
	               <col width="40%">                       
	               <TR class="Header">
	                   <TH><input type="checkbox" onclick="javaScript:onCheckAll(this,'competitorCheck')" id="competitorChkAllObj"></TH>
	                   <TH>对手名称</TH>
	                   <TH>竞争对手优势</TH>
	                   <TH>竞争对手劣势</TH>     
	               </TR>
<%
int competitorIndex=0; 
String competitorIds="";
 while(RecordSetCompetitor.next()){ 
%>
	                <tr>
	                	<td>
							<input type="checkbox" id="competitorCheck" value=''><input type="hidden" name="competitorIndex" value="<%=competitorIndex%>" />
		                </td>
		                <td>
		                	<input name="oppName<%=competitorIndex%>" class=InputStyle style="width:98%" maxLength=50 value="<%=RecordSetCompetitor.getString("oppname")%>"/>
		                </td>
		                <td>
		                	<input name="oppAdvantage<%=competitorIndex%>" class=InputStyle style="width:98%" maxLength=50 value="<%=RecordSetCompetitor.getString("oppadvantage")%>"/>
		                </td>
		                <td>
		                	<input name="oppDisadvantage<%=competitorIndex%>" class=InputStyle style="width:98%" maxLength=50 value="<%=RecordSetCompetitor.getString("oppdisadvantage")%>"/>
		                </td>
	                </tr>   
<% 
	if(competitorIndex==0){
		competitorIds += " competitorsid ="+RecordSetCompetitor.getString("competitorsid");
	}else{
		competitorIds += " or competitorsid = "+RecordSetCompetitor.getString("competitorsid");
	}
	competitorIndex++;
} 
%>       <input type="hidden" name="competitorIds" value="<%=competitorIds%>" />    
	           </TABLE>
	         <TABLE  CLASS="viewForm"  valign="top">
	             <TR style="height: 1px"><TD CLASS="line1" colspan="2"></TD></TR>                
	          </TABLE>
	          <br/>
	     </div>     
	</TD>
</TR>
</TBODY>
</TABLE>
 -->
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
<script language=vbs>


Sub onShowMultiHrmResource(inputname, spanname ,needed)
    
	tmpIds = document.getElementById(inputname).value
	retValue = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids="&tmpIds)
	If (Not IsEmpty(retValue)) Then
		If retValue(0) <> "" Then
			resourceids = retValue(0)
			resourcename = retValue(1)
			sHtml = ""
			resourceids = Mid(resourceids,2,len(resourceids))
			document.getElementById(inputname).value = resourceids
			resourcename = Mid(resourcename,2,len(resourcename))
			While InStr(resourceids,",") <> 0
				curid = Mid(resourceids,1,InStr(resourceids,",")-1)
				curname = Mid(resourcename,1,InStr(resourcename,",")-1)
				resourceids = Mid(resourceids,InStr(resourceids,",")+1,Len(resourceids))
				resourcename = Mid(resourcename,InStr(resourcename,",")+1,Len(resourcename))
				sHtml = sHtml&"<A href=/hrm/resource/HrmResource.jsp?id="&curid&" target=_blank>"&curname&"</A>&nbsp;"
			Wend
			sHtml = sHtml&"<A href=/hrm/resource/HrmResource.jsp?id="&resourceids&" target=_blank>"&resourcename&"</A>&nbsp;"
			document.getElementById(spanname).innerHtml = sHtml			
		Else
			document.getElementById(inputname).value = ""
			If needed Then
				document.getElementById(spanname).innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
			Else
				document.getElementById(spanname).innerHtml = ""
			End If
		End If
	End If
End Sub

sub onShowCurrency()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/fna/maintenance/CurrencyBrowser.jsp")
	if NOT isempty(id) then
	        if id(0)<> "" then
		currencyspan.innerHtml = id(1)
		weaver.Currency.value=id(0)
		else
		currencyspan.innerHtml = ""
		weaver.Currency.value=""
		end if
	end if
end sub

sub onShowTradeInfo()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/Maint/TradeInfoBrowser.jsp")
	if NOT isempty(id) then
	        if id(0)<> 0 then
		tradeinfospan.innerHtml = id(1)
		weaver.ContractLevel.value=id(0)
		else
		tradeinfospan.innerHtml = ""
		weaver.ContractLevel.value=""
		end if
	end if
end sub

sub onShowCreditInfo()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/Maint/CreditInfoBrowser.jsp")
	if NOT isempty(id) then
	        if id(0)<> 0 then
		creditinfospan.innerHtml = id(1)
		weaver.CreditLevel.value=id(0)
		else
		creditinfospan.innerHtml = ""
		weaver.CreditLevel.value=""
		end if
	end if
end sub

sub onShowDeliveryType()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/Maint/DeliveryTypeBrowser.jsp")
	if NOT isempty(id) then
	        if id(0)<> 0 then
		deliveryspan.innerHtml = id(1)
		weaver.DeliveryType.value=id(0)
		else
		deliveryspan.innerHtml = ""
		weaver.DeliveryType.value=""
		end if
	end if
end sub

sub onShowPaymentTerm()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/Maint/PaymentTermBrowser.jsp")
	if NOT isempty(id) then
	        if id(0)<> 0 then
		paymentspan.innerHtml = id(1)
		weaver.PaymentTerm.value=id(0)
		else
		paymentspan.innerHtml = ""
		weaver.PaymentTerm.value=""
		end if
	end if
end sub

sub onShowInvoiceAcount()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	invoiceacountspan.innerHtml = "<A href='/CRM/data/ViewCustomer.jsp?CustomerID="&id(0)&"'>"&id(1)&"</A>"
	weaver.InvoiceAcount.value=id(0)
	else 
	invoiceacountspan.innerHtml = ""
	weaver.InvoiceAcount.value=""
	end if
	end if
end sub

sub onShowCountryID()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/country/CountryBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	countryidspan.innerHtml = id(1)
	weaver.Country.value=id(0)
	else 
	countryidspan.innerHtml = ""
	weaver.Country.value=""
	end if
	end if
end sub

sub onShowProvinceID()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/province/ProvinceBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	provinceidspan.innerHtml = id(1)
	weaver.Province.value=id(0)
	else 
	provinceidspan.innerHtml = ""
	weaver.Province.value=""
	end if
	end if
end sub

sub onShowCityID()
    cityid=trim(weaver.City.value)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/city/CityBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	cityidspan.innerHtml = id(1)
	weaver.City.value=id(0)

	if (cityid<>id(0)) then
	citytwoidspan.innerHtml = ""
	weaver.citytwoCode.value=""
	end if
	
	else 
	cityidspan.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
	weaver.City.value=""
	end if
	end if
end sub
sub clearcity()
cityidspan.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
weaver.City.value=""

end sub
sub onShowCityTwoID()
     pid=weaver.City.value
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/city/CityTwoBrowser.jsp?pid="&pid)
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	citytwoidspan.innerHtml = id(1)
	weaver.citytwoCode.value=id(0)

	getCity(id(0))
	else 
	citytwoidspan.innerHtml = ""
	weaver.citytwoCode.value=""

	end if
	end if
end sub
sub onShowLanguageID()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/systeminfo/language/LanguageBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	languageidspan.innerHtml = id(1)
	weaver.Language.value=id(0)
	else 
	languageidspan.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
	weaver.Language.value=""
	end if
	end if
end sub

sub onShowTitleID()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/Maint/ContacterTitleBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	Titlespan.innerHtml = id(1)
	weaver.Title.value=id(0)
	else 
	Titlespan.innerHtml = ""
	weaver.Title.value=""
	end if
	end if
end sub

sub onShowTypeID()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/Maint/CustomerTypeBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	Typespan.innerHtml = id(1)
	weaver.Type.value=id(0)
	else 
	Typespan.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
	weaver.Type.value=""
	end if
	end if
end sub

sub onShowDescriptionID()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/Maint/CustomerDescBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	Descriptionspan.innerHtml = id(1)
	weaver.Description.value=id(0)
	else 
	Descriptionspan.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
	weaver.Description.value=""
	end if
	end if
end sub

sub onShowStatusID()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/Maint/CustomerStatusBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	Statusspan.innerHtml = id(1)
	weaver.Status.value=id(0)
	else 
	Statusspan.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
	weaver.Status.value=""
	end if
	end if
end sub

sub onShowRatingID()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/Maint/CustomerRatingBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	Ratingspan.innerHtml = id(1)
	weaver.Rating.value=id(0)
	else 
	Ratingspan.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
	weaver.Rating.value=""
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
	Sizespan.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
	weaver.Size.value=""
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
	Sourcespan.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
	weaver.Source.value=""
	end if
	end if
end sub

sub onShowSectorID()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/Maint/SectorInfoBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	Sectorspan.innerHtml = id(1)
	weaver.Sector.value=id(0)
	else 
	Sectorspan.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
	weaver.Sector.value=""
	end if
	end if
end sub

sub onShowManagerID()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	manageridspan.innerHtml = "<A href='/hrm/resource/HrmResource.jsp?id="&id(0)&"'>"&id(1)&"</A>"
	weaver.Manager.value=id(0)
	else 
	manageridspan.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
	weaver.Manager.value=""
	end if
	end if
end sub

sub onShowDepartment()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="&weaver.Department.value)
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	departmentspan.innerHtml = id(1)
	weaver.Department.value=id(0)
	else
	departmentspan.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
	weaver.Department.value=""
	end if
	end if
end sub

sub onShowAgent(needed)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp?sqlwhere=where t1.type in (3,4,11,12,13,14,15,16,17,18,20,21,25)")
	
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	Agentspan.innerHtml = "<A href='/CRM/data/ViewCustomer.jsp?CustomerID="&id(0)&"'>"&id(1)&"</A>"
	weaver.Agent.value=id(0)
	else
		If needed Then
			Agentspan.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
		Else
			Agentspan.innerHtml = ""
		End If 
	weaver.Agent.value=""
	end if
	end if
end sub

sub onShowParent()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	Parentspan.innerHtml = "<A href='/CRM/data/ViewCustomer.jsp?CustomerID="&id(0)&"'>"&id(1)&"</A>"
	weaver.Parent.value=id(0)
	else 
	Parentspan.innerHtml = ""
	weaver.Parent.value=""
	end if
	end if
end sub

sub showDoc()
	id = window.showModalDialog("/docs/DocBrowserMain.jsp?url=/docs/docs/DocBrowser.jsp")
	if Not isempty(id) then
		weaver.Document.value=id(0)&""
		Documentname.innerHtml = "<a href='/docs/docs/DocDsp.jsp?id="&id(0)&"'>"&id(1)&"</a>"	
	end if	
end sub

sub showRemarkDoc()
	id = window.showModalDialog("/docs/DocBrowserMain.jsp?url=/docs/docs/DocBrowser.jsp")
	if Not isempty(id) then
		weaver.RemarkDoc.value=id(0)&""
		RemarkDocname.innerHtml = "<a href='/docs/docs/DocDsp.jsp?id="&id(0)&"'>"&id(1)&"</a>"	
	end if	
end sub

sub showRemarkdocName()
	id = window.showModalDialog("/docs/DocBrowserMain.jsp?url=/docs/docs/DocBrowser.jsp")
	if Not isempty(id) then
		weaver.introductionDocid.value=id(0)&""
		introductionDocname.innerHtml = "<a href='/docs/docs/DocDsp.jsp?id="&id(0)&"'>"&id(1)&"</a>"	
	end if	
end sub
</script>
<script language=javascript>
function ondelete(){
	weaver.method.value="delete";
	weaver.submit();
	
}
function doDel(){
	if(isdel()){ondelete();}
	
}
function ajaxinit(){
	var ajax=false;
	try {
		ajax = new ActiveXObject("Msxml2.XMLHTTP");
	} catch (e) {
		try {
			ajax = new ActiveXObject("Microsoft.XMLHTTP");
		} catch (E) {
			ajax = false;
		}
	}
	if (!ajax && typeof XMLHttpRequest!='undefined') {
	   ajax = new XMLHttpRequest();
	}
	return ajax;
}

function checkCustomerNameFun(){
var nametemp = document.getElementById("Name").value;
  var ajax=ajaxinit();
  ajax.open("POST", "CustomerOperation.jsp?method=checkCusName&name="+nametemp,true);
  ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
  ajax.send();
  ajax.onreadystatechange = function() {
   if (ajax.readyState == 4) {
	 if(ajax.status == 200){
		try{
			if(ajax.responseText != null || ajax.responseText != ""){
				var str_temp = (ajax.responseText).replace(/^\s+/,'').replace(/\s+$/,'');
				var retstr = str_temp.substring(str_temp.indexOf("begin")+5,str_temp.indexOf("begin")+6);
				if(retstr == 1){
				  if(!window.confirm("<%=SystemEnv.getHtmlLabelName(23303,user.getLanguage())%>")){
					document.getElementById("Name").value = "";
				    document.getElementById("Nameimage").innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
				  }
				}
			}
	    }catch(e){
			return false;
	    }
	  }else{
	   return false;
	  }
    }
  }
}


function getCity(cityid){
  
    var ajax=ajaxinit();
	
    ajax.open("POST", "getCity.jsp", true);
    ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
    ajax.send("cityid="+cityid);
    //获取执行状态
    //alert(ajax.readyState);
	//alert(ajax.status);
    ajax.onreadystatechange = function() {
        //如果执行状态成功，那么就把返回信息写到指定的层里
        if (ajax.readyState==4&&ajax.status == 200) {
            try{
			var citynames=ajax.responseText;
			citynames=citynames.replace(/^\s*|\s*$/,'');
			

            cityidspan.innerHTML = citynames.substr(citynames.indexOf("----")+4);
            weaver.City.value=citynames.substr(0,citynames.indexOf("----"));
            }catch(e){}
      
        } 
    } 
}
//增加选择客户来源时如果为电话开拓，则开拓人员为必填，如果为代理商报备等，则中介机构为必填
function changeSource(){
	
	var value = $G("Source").value;
	if(value==1 || value==18){//电话开拓
		if($G("exploiterIds").value==""){
			$G("exploiterIdsSpan").innerHTML="<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
			jQuery("#exploiterIds").attr("_required","yes");
		}
	}else{
		if($G("exploiterIds").value==""){
			$G("exploiterIdsSpan").innerHTML="";
			jQuery("#exploiterIds").attr("_required","no");
		}
	}
	<%if(!user.getLogintype().equals("2")){%>
	if(value==22 || value==23 || value==24 || value==25 || value==26 || value==27){
		if($G("Agent").value==""){
			$G("AgentSpan").innerHTML="<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
			jQuery("#Agent").attr("_required","yes");
		}
	}else{
		if($G("Agent").value==""){
			$G("AgentSpan").innerHTML="";
			jQuery("#Agent").attr("_required","no");
		}
	}
	<%}%>
}
</script>

</BODY>
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</HTML>
<!-- added by cyril on 2008-06-13 for TD:8828 -->
<script language=javascript src="/js/checkData_wev8.js"></script>
<!-- end by cyril on 2008-06-13 for TD:8828 -->
