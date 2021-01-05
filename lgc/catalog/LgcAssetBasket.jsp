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
		<td valign="top">
<form action="" method="post" id=frmmain>
  <input name="operation" type="hidden">
  <input name="thecookiename" type="hidden">
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
  <input name="theassetcountry" type="hidden">
  <input name="assetid" type="hidden">
</form>  
  <table class="BtnBar" width="100%">
    <tr>
		
      <td width="40%">
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(16632,user.getLanguage())+",javascript:myfun1.click(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>      
      <button class="Btn" accesskey="1" id=myfun1  onclick="location.href='LgcCatalogsView.jsp?id=<%=catalogid%>&theassortment=<%=theassortment%>&selectedid=<%=selectedid%>&thecountry=<%=thecountry%>&theattributes=<%=theattributes%>&isthenew=0&start=<%=start%>'"><u>1</u>-商店</button></td>
			
      <td align="right" width="60%">
	  <% if(webshoptype.equals("1")) {%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(16634,user.getLanguage())+",javascript:myfun2.click(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%> 
	  <button class="Btn" id=myfun2 accesskey="2" onclick="onConfirm()"><u>2</u>-确认&gt;</button>
	  <%} else {%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(16633,user.getLanguage())+"song-huo-xin-xi,javascript:myfun3.click(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%> 
	  <button class="Btn" id=myfun3 accesskey="2" onclick="onUserinfo()"><u>2</u>-送货信息&gt;</button>
	  <%}%>
	  </td>
	</tr>
</table>
<form action="" method="post" id=frmchange>
  <input name="operation" type="hidden">
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
  <tr class=Header> 
    <th colspan="8">订单 </th>
  </tr>
  <tr class="Header"> 
    <td>物品</td>
    <td>单位</td>
    <td>国家</td>
    <td>数量</td>
    <td>价格</td>
	<td>税率</td>
    <td>总计</td>
    <td>删除</td>
  </tr>
<TR class=Line><TD colSpan=8></TD></TR>
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
			String assetname = "";
			String assetunitid = "" ;
			if(RecordSet.next())  {
				assetname = Util.toScreen(RecordSet.getString("assetname"),user.getLanguage());
				assetunitid = Util.null2String(RecordSet.getString("assetunitid"));
			} 
			
			String assetcount = Util.null2String(Util.getCookie(request,cookiename)) ;
			para = assetid + separator + countryid + separator + assetcount ; 
			RecordSet.executeProc("LgcAssetPrice_Select",para);
			String unitprice = "" ;
			String taxrate = "" ;
			String currencyid = "" ;

			if(RecordSet.next())  {
				unitprice = Util.null2String(RecordSet.getString(1)) ;
				taxrate = Util.null2String(RecordSet.getString(2)) ;
				currencyid = Util.null2String(RecordSet.getString(3));
			}  
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
    <TD style="margin:0px"> 
      <INPUT name="<%=cookiename%>" value="<%=assetcount%>" size=6 >
    </TD>
    <TD align=right><%=unitprice%></TD>
	<TD align=right><%=taxrate%>%</TD>
    <TD align=right><B><%=Util.toScreen(CurrencyComInfo.getCurrencyname(currencyid),user.getLanguage())%>&nbsp;<%=unitpricecount%></B></TD>
    <TD style="margin:0px"><IMG src="\images\BacoDelete_wev8.gif" border=0 alt=Delete style="CURSOR:'HAND'" onclick="if(isdel()){onDelete('<%=cookiename%>');}"></TD>
  </TR>
  <%	
		isLight = !isLight;
  }%>
  <TR class="header" > 
    <TD colspan=5 align=right><SPAN style="font-size:8pt; color:black">如果你改变了订单数量,请点击该按钮进行计算</SPAN><BUTTON class=Calculate onclick="onCalculate()"></BUTTON></TD>
    <TD align=right><B>总计:</B></TD>
    <TD align=right><B><U><%=Util.toScreen(CurrencyComInfo.getCurrencyname(thecurrencyid),user.getLanguage())%>&nbsp; <%=pricecount%> </U></B></TD>
    <TD>&nbsp;</TD>
  </TR>
  <%}%>
</table>
</form>
<br>
<TABLE class=ListStyle cellspacing=1>
  <TR class=header> 
    <TH colspan=6>相关物品</TH>
  </TR>
<TR class=Line><TD colSpan=6></TD></TR>
 <%
 for(int i=0 ; i< assetids.size() ; i++) {
 	String theassetid = (String)assetids.get(i) ;
	String thecountryid = (String)countryids.get(i) ;
	RecordSet.executeProc("LgcConfiguration_SByWebshop",theassetid);
	while(RecordSet.next()) {
		String relassetid = Util.null2String(RecordSet.getString(1)) ;
		String relname = Util.toScreen(RecordSet.getString(2),user.getLanguage()) ;
		String para = relassetid + separator + thecountryid ;
		RecordSet2.executeProc("LgcAsset_SelectById",para);
		String assetname = "";
		String assetunitid = "";
		String currencyid = "";
		String salesprice = "";

		if(RecordSet2.next()) {
			assetname = Util.toScreen(RecordSet2.getString("assetname"),user.getLanguage());
			assetunitid = Util.null2String(RecordSet2.getString("assetunitid"));
			currencyid = Util.null2String(RecordSet2.getString("currencyid"));
			salesprice = Util.null2String(RecordSet2.getString("salesprice"));
	
		}
 if(isLight) {%>
  <TR CLASS=DataLight> 
	<%} else { %>
  <TR class=DataDark>
	<%}%>
    <TD> <a href='/lgc/asset/LgcAsset.jsp?paraid=<%=relassetid%>&assetcountryid=<%=thecountryid%>'><%=assetname%></a></TD>
    <TD><%=Util.toScreen(AssetUnitComInfo.getAssetUnitname(assetunitid),user.getLanguage())%></TD>
    <TD> 
      <% if(thecountryid.equals("0")) {%>
      <%=SystemEnv.getHtmlLabelName(529,user.getLanguage())%> 
      <%} else {%>
      <%=Util.toScreen(CountryComInfo.getCountrydesc(thecountryid),user.getLanguage())%> 
      <%}%>
    </TD>
    <TD><%=relname%></TD>
    <TD align=right><B><%=Util.toScreen(CurrencyComInfo.getCurrencyname(currencyid),user.getLanguage())%>&nbsp;<%=salesprice%></B></TD>
    <TD style="margin:0px"><IMG src="\images\ShopAddToCart_wev8.gif" border=0 alt="Add to basket" style="CURSOR:'HAND'" onclick="onAdd('<%=relassetid%>','<%=thecountryid%>')"></TD>
  </TR>
 <%}}%>
</TABLE>
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
function onDelete(thecookname) {
	frmmain.thecookiename.value = thecookname ;
	frmmain.action = "LgcAssetBasketOperation.jsp" ;
	frmmain.operation.value = "delete" ;
	frmmain.submit() ;
}
function  onAdd(theassetid,thecountryid) {
	frmmain.assetid.value = theassetid ;
	frmmain.theassetcountry.value = thecountryid ;
	frmmain.action = "LgcAssetBasketOperation.jsp" ;
	frmmain.operation.value = "addasset" ;
	frmmain.submit() ;
}
function onCalculate() {
	frmchange.action = "LgcAssetBasketOperation.jsp" ;
	frmchange.operation.value = "change" ;
	frmchange.submit() ;
}

function  onUserinfo() {
	frmchange.action = "LgcAssetBasketOperation.jsp" ;
	frmchange.operation.value = "userinfo" ;
	frmchange.submit() ;
}

function  onConfirm() {
	frmchange.action = "LgcAssetBasketOperation.jsp" ;
	frmchange.operation.value = "confirm" ;
	frmchange.submit() ;
}

</script>

</body></html>
