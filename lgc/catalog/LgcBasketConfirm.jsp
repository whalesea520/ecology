<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RecordSet2" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="CountryComInfo" class="weaver.hrm.country.CountryComInfo" scope="page"/>
<!-- jsp:useBean id="AssetTypeComInfo" class="weaver.lgc.maintenance.AssetTypeComInfo" scope="page"/ -->
<jsp:useBean id="AssetUnitComInfo" class="weaver.lgc.maintenance.AssetUnitComInfo" scope="page"/>
<jsp:useBean id="CurrencyComInfo" class="weaver.fna.maintenance.CurrencyComInfo" scope="page"/>
<!--jsp:useBean id="AssetAssortmentComInfo" class="weaver.lgc.maintenance.AssetAssortmentComInfo" scope="page" / -->

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
String catalogid = Util.null2String(request.getParameter("catalogid"));
String theassortment = Util.null2String(request.getParameter("theassortment"));
String selectedid = Util.null2String(request.getParameter("selectedid"));
String thecountry = Util.null2String(request.getParameter("thecountry"));
String theattributes = Util.null2String(request.getParameter("theattributes"));
String isthenew = Util.null2String(request.getParameter("isthenew"));
String start = Util.null2String(request.getParameter("start"));
String webshoptype = Util.null2String(request.getParameter("webshoptype"));
String webshopmanageid = Util.null2String(request.getParameter("webshopmanageid"));

String imagefilename = "/images/hdLOG_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(727,user.getLanguage()) ;
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>


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
		<td valign="top"><form action="LgcAssetBasketOperation.jsp" method="post" id=frmchange>
  <table class="BtnBar" width="100%">
    <tr>
		
      
    <td width="70%"><div style="display:none" >
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(16632,user.getLanguage())+",javascript:frmchange.myfun1.click(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>    
    <button class="Btn" accesskey="1" id=myfun1  onclick="location.href='LgcCatalogsView.jsp?id=<%=catalogid%>&theassortment=<%=theassortment%>&selectedid=<%=selectedid%>&thecountry=<%=thecountry%>&theattributes=<%=theattributes%>&isthenew=0&start=<%=start%>'"><u>1</u>-商店</button> 
      
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(727,user.getLanguage())+",javascript:frmchange.myfun2.click(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>      
      <button class="Btn" accesskey="2" id=myfun2  onclick="location.href='LgcAssetBasket.jsp?catalogid=<%=catalogid%>&theassortment=<%=theassortment%>&selectedid=<%=selectedid%>&thecountry=<%=thecountry%>&theattributes=<%=theattributes%>&isthenew=0&start=<%=start%>&webshoptype=<%=webshoptype%>&webshopmanageid=<%=webshopmanageid%>'">&lt; 
      <u>2</u>-购物车</button> 
      <% if(webshoptype.equals("0")) {%>
      
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(16633,user.getLanguage())+",javascript:frmchange.myfun3.click(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>      
      <button class="Btn" accesskey="3" id=myfun3  onclick="location.href='LgcBasketUserInfo.jsp?catalogid=<%=catalogid%>&theassortment=<%=theassortment%>&selectedid=<%=selectedid%>&thecountry=<%=thecountry%>&theattributes=<%=theattributes%>&isthenew=0&start=<%=start%>&webshoptype=<%=webshoptype%>&webshopmanageid=<%=webshopmanageid%>'">&lt;<u>3</u>-送货信息</button> 
      <%}%>
    </td>
			
      <td align="right" width="30%">
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(615,user.getLanguage())+",javascript:checkvalue(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%> 
	  <button class="Btn" accesskey="4" style="display:none" onclick="checkvalue()"><u>4</u>-提交&gt;</button>
      </div>
	  </td>
	</tr>
</table>

  <input name="operation" type="hidden" value="endsubmit">
  <input name="catalogid" type="hidden" value="<%=catalogid%>">
  <input name="theassortment" type="hidden" value="<%=theassortment%>">
  <input name="selectedid" type="hidden" value="<%=selectedid%>">
  <input name="thecountry" type="hidden" value="<%=thecountry%>">
  <input name="theattributes" type="hidden" value="<%=theattributes%>">
  <input name="isthenew" type="hidden" value="<%=isthenew%>">
  <input name="start" type="hidden" value="<%=start%>">
  <input name="webshoptype" type="hidden" value="<%=webshoptype%>">
  <input name="webshopmanageid" type="hidden" value="<%=webshopmanageid%>">
  <input name="webshopreturn" type="hidden" value="0">
<table class=ListStyle cellspacing=1>
  <tr class=header> 
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
<TR class=Line><TD colSpan=10></TD></TR>

  <%
  	Cookie thecookies[] = request.getCookies() ;
	String userid = ""+user.getUID() ;
	char separator = Util.getSeparator() ;
	float pricecount = 0 ;
	boolean isLight = false;
	String thecurrencyid = "" ;
	ArrayList assetids = new ArrayList() ;
	ArrayList countryids = new ArrayList() ;

	if(thecookies != null) {
		for(int i=0 ; i<thecookies.length ; i++) {
			String cookiename = thecookies[i].getName() ;
			if(cookiename.indexOf("CoItem_"+userid+"_") <0) continue ;
			String tempstr[] = Util.TokenizerString2(cookiename,"_") ;
			String assetid = tempstr[2] ;
			String countryid = tempstr[3] ;
			assetids.add(assetid) ;
			countryids.add(countryid) ;
			String para = assetid+separator+ countryid ;
			RecordSet.executeProc("LgcAsset_SelectById",para);
			RecordSet.next() ;
			String assetname = Util.toScreen(RecordSet.getString("assetname"),user.getLanguage());
			String assetunitid = Util.null2String(RecordSet.getString("assetunitid"));
			
			String assetcount = Util.null2String(Util.getCookie(request,cookiename)) ;
			para = assetid + separator + countryid + separator + assetcount ; 
			RecordSet.executeProc("LgcAssetPrice_Select",para);
			RecordSet.next() ;
			String unitprice = Util.null2String(RecordSet.getString(1)) ;
			String taxrate = Util.null2String(RecordSet.getString(2)) ;
			String currencyid = Util.null2String(RecordSet.getString(3));
			thecurrencyid = currencyid ;
			int tempprice = new Float(Util.getFloatValue(assetcount) * Util.getFloatValue(unitprice) * (1+ Util.getFloatValue(taxrate)/100)*100 + 0.5).intValue() ;
			float unitpricecount = tempprice/100 ;
			pricecount += unitpricecount ;
			if(isLight) {%>
  <TR CLASS=DataLight> 
	<%} else { %>
  <TR class=DataDark>
	<%}%>
    <TD>
    <a href='/lgc/asset/LgcAsset.jsp?paraid=<%=assetid%>&assetcountryid=<%=countryid%>'><%=assetname%></a></TD>
    <TD><%=Util.toScreen(AssetUnitComInfo.getAssetUnitname(assetunitid),user.getLanguage())%></TD>
    <TD>
	<% if(countryid.equals("0")) {%><%=SystemEnv.getHtmlLabelName(529,user.getLanguage())%>
	<%} else {%>
	<%=Util.toScreen(CountryComInfo.getCountrydesc(countryid),user.getLanguage())%><%}%> </TD>
    <TD align=right><%=assetcount%></TD>
    <TD align=right><%=unitprice%></TD>
	<TD align=right><%=taxrate%>%</TD>
    <TD align=right><B><%=Util.toScreen(CurrencyComInfo.getCurrencyname(currencyid),user.getLanguage())%>&nbsp;<%=unitpricecount%></B></TD>
  </TR>
  <%	
		isLight = !isLight;
  }%>
  <TR class="header"> 

    <TD align=right colspan=6 ><B>总计:</B></TD>
    <TD align=right ><B><U><%=Util.toScreen(CurrencyComInfo.getCurrencyname(thecurrencyid),user.getLanguage())%>&nbsp; <%=pricecount%> </U></B></TD>
  </TR>
  <%}%>
</table>
  <input name="thecurrencyid" type="hidden" value="<%=thecurrencyid%>">
  <input name="pricecount" type="hidden" value="<%=pricecount%>">
</form>

<table class=ViewForm id=tblScenarioCode>
  <thead> <colgroup> <col width="15%"> <col width="30%"> <col width="15%"> <col width="40%"></thead> 
  <tbody> 
  <TR class=Title> 
    <TH colspan=4>用户信息</TH>
  </TR>
  <TR class=Spacing> 
    <TD colspan=4 class=Line1></TD>
  </TR>
  <tr> 
    <td>姓名:</td>
    <td class=FIELD> <%=Util.toScreen(user.getUsername(),user.getLanguage())%> 
    </td>
    <td>E-mail:</td>
    <td class=field> <%=Util.toScreen(user.getEmail(),user.getLanguage())%> </td>
  </TR><tr><td class=Line colspan=4></td></tr>
  <tr> 
    <td>收货地址:</td>
    <td class=FIELD><nobr> <%=Util.toScreen(user.getReceiveaddress(),user.getLanguage())%></td>
    <td>联系电话1:</td>
    <td class=field> <%=Util.toScreen(user.getTelephone(),user.getLanguage())%> 
    </td>
  </TR><tr><td class=Line colspan=4></td></tr>
  <tr> 
    <td>邮编:</td>
    <td class=FIELD><nobr> <%=Util.toScreen(user.getPostcode(),user.getLanguage())%> 
    </td>
    <td>联系电话2:</td>
    <td class=field> <%=Util.toScreen(user.getMobile(),user.getLanguage())%> </td>
  </TR><tr><td class=Line colspan=4></td></tr>
  <tr> 
    <td>备注</td>
    <td class=FIELD colspan="3"><%=Util.toScreen(user.getRemark(),user.getLanguage())%></td>
  </TR><tr><td class=Line colspan=4></td></tr>
  </tbody> 
</table>

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

function checkvalue() {
	if(frmchange.pricecount.value == 0.0) {
		alert("<%=SystemEnv.getHtmlNoteName(41,user.getLanguage())%>") ;
	}
	else 
	frmchange.submit() ;
}

</script>

</body></html>
