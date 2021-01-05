<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="CountryComInfo" class="weaver.hrm.country.CountryComInfo" scope="page"/>
<jsp:useBean id="AssetUnitComInfo" class="weaver.lgc.maintenance.AssetUnitComInfo" scope="page"/>
<jsp:useBean id="CurrencyComInfo" class="weaver.fna.maintenance.CurrencyComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page"/>
<jsp:useBean id="AssetComInfo" class="weaver.lgc.asset.AssetComInfo" scope="page"/>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<style type="text/css">
span.Step		{ font-weight: bold; color: black; }
span.StepActive	{ font-weight: bold; color: red; }
table.BtnBar	{ width: 100%; border-collapse: collapse; }
table.BtnBar TD	{ padding: 0px; }
</style>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</head>
<%
String id = Util.null2String(request.getParameter("id")) ;
RecordSet.executeProc("LgcWebShop_SelectById",id);
RecordSet.next();
int usertype = Util.getIntValue(RecordSet.getString("usertype")) ;
String userid = Util.null2String(RecordSet.getString("userid")) ;
String username = Util.toScreen(RecordSet.getString("userid"),user.getLanguage()) ;
String useremail = Util.toScreen(RecordSet.getString("useremail"),user.getLanguage()) ;
String receiveaddress = Util.toScreen(RecordSet.getString("receiveaddress"),user.getLanguage()) ;
String receivetype = Util.null2String(RecordSet.getString("receivetype")) ;
String postcode = Util.toScreen(RecordSet.getString("postcode"),user.getLanguage()) ;
String telephone1 = Util.toScreen(RecordSet.getString("telephone1"),user.getLanguage()) ;
String telephone2 = Util.toScreen(RecordSet.getString("telephone2"),user.getLanguage()) ;
String purchaseremark = Util.toScreen(RecordSet.getString("purchaseremark"),user.getLanguage()) ;
String paymentmode = Util.null2String(RecordSet.getString("paymentmode")) ;
String purchasedate = Util.null2String(RecordSet.getString("purchasedate")) ;
int purchasestatus = Util.getIntValue(RecordSet.getString("purchasestatus")) ;


String imagefilename = "/images/hdLOG_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(735,user.getLanguage()) ;
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_top} " ;
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
		<td valign="top"><form action="LgcWebSalesOperation.jsp" method="post" id=frmmain name=frmmain>
  <table class="BtnBar" width="100%">
    <tr>
		
      
    <td>
	<% if(purchasestatus < 1) {%>
	<button class="Btn" accesskey="1" onclick="changeStatus('1')"><u>1</u>-处理</button> <%}%>
	<% if(purchasestatus < 2) {%>
	<button class="Btn" accesskey="2" onclick="changeStatus('2')"><u>2</u>-发货</button> <%}%>
	<% if(purchasestatus < 3) {%>
	<button class="Btn" accesskey="3" onclick="changeStatus('3')"><u>3</u>-完成</button> <%}%>
	<BUTTON class=btnDelete id=Delete accessKey=D onclick="onDelete()"><U>D</U>-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></BUTTON>
	<button class="Btn" accesskey="4" onclick="location.href='LgcWebSales.jsp'"><u>4</u>-返回</button>
    </td>
	</tr>
</table>

  <input name="operation" type="hidden">
  <input name="id" type="hidden" value="<%=id%>">
  <input name="purchasestatus" type="hidden">
 
 <% if( usertype != 0) {%>
  <table class=ViewForm id=tblScenarioCode>
    <thead> <colgroup> <col width="15%"> <col width="30%"> <col width="15%"> <col width="40%"></thead> 
    <tbody> 
    <tr class=Title> 
      <th colspan=4>用户信息</th>
    </tr>
    <tr class=Spacing> 
      <td colspan=4 class=Line1></td>
    </tr>
    <tr> 
      <td> 
        <% if( usertype ==9 ) {%>
        人力资源: 
        <%} else if( usertype == 2) {%>
        CRM： 
        <%} else if( usertype == 1 ) {%>
        用户： 
        <%}%>
      </td>
      <td class=FIELD> 
        <% if( usertype == 9) {%>
        <A href='/hrm/resource/HrmResource.jsp?id=<%=userid%>'><%=Util.toScreen(ResourceComInfo.getResourcename(userid),user.getLanguage())%></a> 
        <%} else if( usertype ==2 ) {%>
        <a href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=userid%>"><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(userid),user.getLanguage())%></a> 
        <%} else if( usertype == 1 ) {%>
        <%=userid%> 
        <%}%>
      </td>
      <td>订单日期：</td>
      <td class=field> <%=purchasedate%> </td>
    </TR><tr><td class=Line colspan=4></td></tr>
    </tbody> 
  </table>
  <%} else {%>
  <table class=ViewForm id=tblScenarioCode>
    <thead> <colgroup> <col width="15%"> <col width="45%"> <col width="15%"> <col width="25%"></thead> 
    <tbody> 
    <tr class=Title> 
      <th colspan=4>用户信息</th>
    </tr>
    <tr class=Spacing> 
      <td colspan=4 class=Line1></td>
    </tr>
    <tr> 
      <td>姓名:</td>
      <td class=FIELD> <%=username%> 
      </td>
      <td>E-mail:</td>
      <td class=field> <A href='mailto:<%=useremail%>'><%=useremail%></a>
      </td>
    </TR><tr><td class=Line colspan=4></td></tr>
    <tr> 
      <td>收货地址:</td>
      <td class=FIELD><nobr> <%=receiveaddress%></td>
      <td>联系电话1:</td>
      <td class=field> <%=telephone1%> 
      </td>
    </TR><tr><td class=Line colspan=4></td></tr>
    <tr> 
      <td>邮编:</td>
      <td class=FIELD><%=postcode%> 
      </td>
      <td>联系电话2:</td>
      <td class=field> <%=telephone2%> 
      </td>
    </TR><tr><td class=Line colspan=4></td></tr>
    <tr> 
      <td>备注</td>
      <td class=FIELD><%=purchaseremark%></td>
	   <td>订单日期：</td>
      <td class=field> <%=purchasedate%> </td>
    </TR><tr><td class=Line colspan=4></td></tr>
    </tbody> 
  </table>
  <%}%>
  <table class="ListStyle" cellspacing=1>
  <tr class="header"> 
    <th colspan="10">订单 </th>
  </tr>
  <tr class="Header"> 
    <td>物品</td>
    <td>单位</td>
    <td>国家</td>
    <td>数量</td>
    <td>价格</td>
	<td>税率</td>
    <td>总计</td>
  </tr>
<TR class=Line><TD colSpan=7></TD></TR>
  <%
  	boolean isLight = false;
	float pricecount = 0 ;
	String thecurrencyid = "" ;
  	RecordSet.executeProc("LgcWebShopDetail_SelectById",id);
	while(RecordSet.next()) {
		String assetid = Util.null2String(RecordSet.getString("assetid")) ;
		String countryid = Util.null2String(RecordSet.getString("countryid")) ;
		String currencyid = Util.null2String(RecordSet.getString("currencyid")) ;
		String assetprice = Util.null2String(RecordSet.getString("assetprice")) ;
		String taxrate = Util.null2String(RecordSet.getString("taxrate")) ;
		String purchasenum = Util.null2String(RecordSet.getString("purchasenum")) ;
		int tempprice = new Float(Util.getFloatValue(purchasenum) * Util.getFloatValue(assetprice) * (1+ Util.getFloatValue(taxrate)/100)*100 + 0.5).intValue() ;
		float unitpricecount = tempprice/100 ;
		pricecount += unitpricecount ;
		thecurrencyid = currencyid ;
		
		if(isLight) {%>
  <TR CLASS=DataLight> 
	<%} else { %>
  <TR class=DataDark>
	<%}%>
    <TD>
    <a href='/lgc/asset/LgcAsset.jsp?paraid=<%=assetid%>&assetcountryid=<%=countryid%>'><%=Util.toScreen(AssetComInfo.getAssetName(assetid),user.getLanguage())%></a></TD>
    <TD><%=Util.toScreen(AssetUnitComInfo.getAssetUnitname(Util.null2String(AssetComInfo.getAssetunitids(assetid))),user.getLanguage())%></TD>
    <TD>
	<% if(countryid.equals("0")) {%><%=SystemEnv.getHtmlLabelName(529,user.getLanguage())%>
	<%} else {%>
	<%=Util.toScreen(CountryComInfo.getCountrydesc(countryid),user.getLanguage())%><%}%> </TD>
    <TD align=right><%=purchasenum%></TD>
    <TD align=right><%=assetprice%></TD>
	<TD align=right><%=taxrate%>%</TD>
    <TD align=right><B><%=Util.toScreen(CurrencyComInfo.getCurrencyname(currencyid),user.getLanguage())%>&nbsp;<%=unitpricecount%></B></TD>
  </TR>
  <%	
		isLight = !isLight;
  }%>
  <TR class="header" > 

    <TD colspan=6 align=right><B>总计:</B></TD>
    <TD align=right><B><U><%=Util.toScreen(CurrencyComInfo.getCurrencyname(thecurrencyid),user.getLanguage())%>&nbsp; <%=pricecount%> </U></B></TD>
  </TR>
</table>
</form>
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
<script language="javascript">
function onDelete() {
	if(confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>")) {
		document.frmmain.operation.value="deletewebsales";
		document.frmmain.submit();
	}
}

function changeStatus(thestatus) {
	document.frmmain.operation.value="changewebsales";
	document.frmmain.purchasestatus.value= thestatus ;
	document.frmmain.submit();
}

</script>

</body></html>
