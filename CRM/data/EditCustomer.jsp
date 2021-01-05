
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetFF" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetShare" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetCre" class="weaver.conn.RecordSet" scope="page" />

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
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page"/>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%
String CustomerID = Util.null2String(request.getParameter("CustomerID"));

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

response.sendRedirect("/CRM/data/ViewCustomer.jsp?CustomerID="+CustomerID);
//request.getRequestDispatcher("/CRM/data/ViewCustomer.jsp").forward(request,response);

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
	if(document.all("Type").value == 0 || document.all("Description").value == 0 || document.all("Size").value == 0 || document.all("Sector").value == 0){
		alert("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage())%>");
		return;
	}
	if(check_form(weaver,'Name,Abbrev,Address1,Language,Type,Description,Size,Source,Sector,Manager,Department,Email,seclevel')){
		var amounttemp = document.getElementById("CreditAmount").value;
		var timetemp = document.getElementById("CreditTime").value;
		if(amounttemp==''){
			if(<%=hasCre%>){
				document.getElementById("CreditAmount").value = <%=creditamountStr%>;
			}else{
				alert("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage())%>");
				return;
			}
		}
		if(timetemp==''){
			if(<%=hasCre%>){
				document.getElementById("CreditTime").value = <%=credittimeStr%>;
			}else{
				alert("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage())%>");
				return;
			}
		}
		obj.disabled=true;
		weaver.submit();
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
		alert('<%=SystemEnv.getHtmlLabelName(83439,user.getLanguage())%>100');
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
            <INPUT class=InputStyle maxLength=50 name="Name" id="Name" onchange='checkinput("Name","Nameimage"),checkCustomerNameFun()' value="<%=Util.toScreenToEdit(RecordSet.getString("name"),user.getLanguage())%>" SIZE="35" onkeydown="if(event.keyCode==222){return false;}">
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
          <TD><%=SystemEnv.getHtmlLabelName(479,user.getLanguage())%>, <%=SystemEnv.getHtmlLabelName(493,user.getLanguage())%></TD>
          <TD class=Field>
             <span STYLE="float: left;padding-right: 20px;"><INPUT class=InputStyle maxLength=10 name="Zipcode" STYLE="width:100%;" value="<%=Util.toScreenToEdit(RecordSet.getString("zipcode"),user.getLanguage())%>"></span>         
             <brow:browser viewType="0" name="City" 
	         browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/city/CityBrowser.jsp"
	         browserValue='<%=RecordSet.getString("city") %>' 
	         browserSpanValue = '<%=CityComInfo.getCityname(RecordSet.getString("city"))%>'
	         isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='1'
	         completeUrl="/data.jsp?type=58" width="150px" ></brow:browser>
		  </TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>        
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(377,user.getLanguage())%>, <%=SystemEnv.getHtmlLabelName(643,user.getLanguage())%></TD>
          <TD class=Field>
             <brow:browser viewType="0" name="Country" 
	         browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/country/CountryBrowser.jsp"
	         browserValue='<%=RecordSet.getString("country") %>' 
	         browserSpanValue = '<%=CountryComInfo.getCountrydesc(RecordSet.getString("country"))%>'
	         isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='1'
	         completeUrl="/data.jsp?type=1111" width="150px" ></brow:browser>  
             <SPAN STYLE="width:1%"></SPAN>
		  </TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>        
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(644,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=50 name="County" value="<%=Util.toScreenToEdit(RecordSet.getString("county"),user.getLanguage())%>" SIZE="35"></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>        
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(231,user.getLanguage())%></TD>
          <TD class=Field>
        	<brow:browser viewType="0" name="Language" 
	         browserUrl="/systeminfo/BrowserMain.jsp?url=/systeminfo/language/LanguageBrowser.jsp"
	         browserValue='<%=RecordSet.getString("language") %>' 
	         browserSpanValue = '<%=Util.toScreen(LanguageComInfo.getLanguagename(RecordSet.getString("language")),user.getLanguage())%>'
	         isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='1'
	         completeUrl="/data.jsp?type=-99998" width="150px" ></brow:browser>  
       	  </TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>        
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(421,user.getLanguage())%>, <%=SystemEnv.getHtmlLabelName(494,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=50 size=14 name="Phone" value="<%=Util.toScreenToEdit(RecordSet.getString("phone"),user.getLanguage())%>" STYLE="width:45%"><SPAN STYLE="width:5%"></SPAN><INPUT class=InputStyle maxLength=50 size=14 name="Fax" value="<%=Util.toScreenToEdit(RecordSet.getString("fax"),user.getLanguage())%>" STYLE="width:45%"></TD>
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
        </TR>
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
          
			<%
			String spanStr="";
            spanStr+=Util.toScreen(CustomerTypeComInfo.getCustomerTypename(RecordSet.getString("type")),user.getLanguage());
            %>
         	<brow:browser viewType="0" name="Type" 
	        browserUrl="/systeminfo/BrowserMain.jsp?url=/CRM/Maint/CustomerTypeBrowser.jsp"
	        browserValue='<%=RecordSet.getString("type").equals("0")?"":RecordSet.getString("type")%>'
	        browserSpanValue='<%=spanStr %>'
	        isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='2'
	        completeUrl="/data.jsp?type=customerType" width="150px" ></brow:browser>
         </TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></TD>
          <TD class=Field>
                <%
                spanStr="";
                spanStr+=Util.toScreen(CustomerDescComInfo.getCustomerDescname(RecordSet.getString("description")),user.getLanguage());
                %>
              <brow:browser viewType="0" name="Description" 
	        	browserUrl="/systeminfo/BrowserMain.jsp?url=/CRM/Maint/CustomerDescBrowser.jsp"
	        	browserValue='<%=RecordSet.getString("description").equals("0")?"":RecordSet.getString("description")%>'
	        	browserSpanValue='<%=spanStr %>'
	        	isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='2'
	        	completeUrl="/data.jsp?type=customerDesc" width="150px" ></brow:browser>	
	        </TD>	
         </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>        
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(576,user.getLanguage())%></TD>
          <TD class=Field>
          	<brow:browser viewType="0" name="Size" 
	        	browserUrl="/systeminfo/BrowserMain.jsp?url=/CRM/Maint/CustomerSizeBrowser.jsp"
	        	browserValue='<%=RecordSet.getString("size_n").equals("0")?"":RecordSet.getString("size_n")%>'
	        	browserSpanValue='<%=Util.toScreen(CustomerSizeComInfo.getCustomerSizedesc(RecordSet.getString("size_n")),user.getLanguage())%>'
	        	isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='2'
	        	completeUrl="/data.jsp?type=customerSize" width="150px" ></brow:browser>	
          </TD>
              
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>        
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(645,user.getLanguage())%></TD>
          <TD class=Field>
             <brow:browser viewType="0" name="Source" 
		        browserUrl="/systeminfo/BrowserMain.jsp?url=/CRM/Maint/ContactWayBrowser.jsp"
		        browserValue='<%=RecordSet.getString("source")%>'
		        browserSpanValue='<%=Util.toScreen(ContactWayComInfo.getContactWayname(RecordSet.getString("source")),user.getLanguage())%>'
		        isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='2'
		        completeUrl="/data.jsp?type=contactWay" width="150px" ></brow:browser>
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
                <brow:browser viewType="0" name="Sector" 
	        	browserUrl="/systeminfo/BrowserMain.jsp?url=/CRM/Maint/SectorInfoBrowser.jsp"
	        	browserValue='<%=RecordSet.getString("sector").equals("0")?"":RecordSet.getString("sector")%>'
		        browserSpanValue='<%=seclist %>'
	        	isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='2'
	        	completeUrl="/data.jsp?type=sector" width="150px" ></brow:browser>
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
          	<brow:browser viewType="0" name="Manager" 
	         browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
	         browserValue = '<%=RecordSet.getString("manager")%>' 
	         browserSpanValue='<%=Util.toScreen(ResourceComInfo.getResourcename(RecordSet.getString("manager")),user.getLanguage())%>'
	         isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='2'
	         completeUrl="/data.jsp" width="150px" ></brow:browser>
          
          </TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>        
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(132,user.getLanguage())%></TD>
          <TD class=Field>
          	 <brow:browser viewType="0" name="Agent" 
	         browserUrl="/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp?sqlwhere=where t1.type in (3,4)"
	         browserValue = '<%=RecordSet.getString("agent")%>' 
	         browserSpanValue='<%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(RecordSet.getString("agent")),user.getLanguage())%>'
	         isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='1'
	         completeUrl="/data.jsp?type=agent" width="150px" ></brow:browser>	
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
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(591,user.getLanguage())%></TD>
          <TD class=Field>
				<%if(!isCustomerSelf){%>
					 <brow:browser viewType="0" name="Parent" 
			         browserUrl="/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp"
			         browserValue = '<%=RecordSet.getString("parentid")%>' 
		             browserSpanValue='<%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(RecordSet.getString("parentid")),user.getLanguage())%>'
			         isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='1'
			         completeUrl="/data.jsp?type=7" width="150px" ></brow:browser>	
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
				<brow:browser viewType="0" name="Document" 
		         browserUrl="/docs/DocBrowserMain.jsp?url=/docs/docs/DocBrowser.jsp"
		         browserValue = '<%=RecordSet.getString("documentid")%>' 
		         browserSpanValue='<%=Util.toScreen(DocComInfo.getDocname(RecordSet.getString("documentid")),user.getLanguage())%>'
			     isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='1'
		         completeUrl="/data.jsp?type=9" width="150px" ></brow:browser>	
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
				<brow:browser viewType="0" name="introductionDocid" 
		         browserUrl="/docs/DocBrowserMain.jsp?url=/docs/docs/DocBrowser.jsp"
		         browserValue = '<%=RecordSet.getString("introductionDocid")%>' 
		         browserSpanValue='<%=Util.toScreen(DocComInfo.getDocname(RecordSet.getString("introductionDocid")),user.getLanguage())%>'
		         isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='1'
		         completeUrl="/data.jsp?type=9" width="150px" ></brow:browser>	
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
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/city/CityBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	cityidspan.innerHtml = id(1)
	weaver.City.value=id(0)
	else 
	cityidspan.innerHtml = ""
	weaver.City.value=""
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

sub onShowAgent()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp?sqlwhere=where t1.type in (3,4)")
	
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	Agentspan.innerHtml = "<A href='/CRM/data/ViewCustomer.jsp?CustomerID="&id(0)&"'>"&id(1)&"</A>"
	weaver.Agent.value=id(0)
	else 
	Agentspan.innerHtml = ""
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
</script>

</BODY>
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</HTML>
<!-- added by cyril on 2008-06-13 for TD:8828 -->
<script language=javascript src="/js/checkData_wev8.js"></script>
<!-- end by cyril on 2008-06-13 for TD:8828 -->
