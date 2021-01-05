<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>

<jsp:useBean id="RecordSetType" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RecordSetInner" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="AssetComInfo" class="weaver.lgc.asset.AssetComInfo" scope="page"/>
<jsp:useBean id="CustomerTypeComInfo" class="weaver.crm.Maint.CustomerTypeComInfo" scope="page"/>
<jsp:useBean id="CountryComInfo" class="weaver.hrm.country.CountryComInfo" scope="page"/>
<jsp:useBean id="CurrencyComInfo" class="weaver.fna.maintenance.CurrencyComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page"/>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</head>
<%
int msgid = Util.getIntValue(request.getParameter("msgid"),-1);
char separator = Util.getSeparator() ;

String paraid = Util.null2String(request.getParameter("paraid")) ;
String assetid = paraid ;
String countryid = Util.null2String(request.getParameter("assetcountryid")) ;
String assetname = Util.toScreen(AssetComInfo.getAssetName(assetid),user.getLanguage());
String assetmark = Util.toScreen(AssetComInfo.getAssetMark(assetid),user.getLanguage());

String imagefilename = "/images/hdLOG_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(535,user.getLanguage())+" : "+SystemEnv.getHtmlLabelName(147,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%
if(msgid!=-1){
%>
<DIV>
<font color=red size=2>
<%=SystemEnv.getErrorMsgName(msgid,user.getLanguage())%>
</font>
</DIV>
<%}%>
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
		<td valign="top"><% if(HrmUserVarify.checkUserRight("LgcAssetCrmAdd:Add",user)){ %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(365,user.getLanguage())+",javascript:button1.click(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>

<BUTTON class=Btn id=button1 accessKey=1  style="display:none" 
onclick='location.href="LgcAssetCrmAdd.jsp?paraid=<%=assetid%>&countryid=<%=countryid%>"' 
name=button1><U>1</U>-<%=SystemEnv.getHtmlLabelName(365,user.getLanguage())%></BUTTON>
<% } %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(535,user.getLanguage())+",javascript:button2.click(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>

<BUTTON class=Btn id=button2 accessKey=2   style="display:none" 
onclick='location.href="LgcAsset.jsp?paraid=<%=assetid%>&assetcountryid=<%=countryid%>"' 
name=button2><U>2</U>-<%=SystemEnv.getHtmlLabelName(535,user.getLanguage())%></BUTTON>

<br><b><%=SystemEnv.getHtmlLabelName(535,user.getLanguage())%>:<A href="LgcAsset.jsp?paraid=<%=assetid%>&assetcountryid=<%=countryid%>"><%=assetmark%>-<%=assetname%></a></b>
<TABLE class=ListStyle cellspacing=1>
  <TBODY>
  <TR class=header>
    <TH colSpan=6>供应商</TH>
  </TR>
  <TR class=Header>
    <TD>CRM</TD>
    <TD>国家</TD>
    <TD>价格</TD>
    <TD>币种</TD>
    <TD>主要</TD>
   </TR>
   <TR class=Line><TD colSpan=6></TD></TR>
<% RecordSetType.executeProc("LgcAssetCrm_SelectType",assetid);
 while(RecordSetType.next()){
	 String type = RecordSetType.getString("type");
 %>
 <TR class=header><TH colSpan=8><%=Util.toScreen(CustomerTypeComInfo.getCustomerTypename(type),user.getLanguage())%></TH></TR>

 <%
int j=0;
RecordSetInner.executeProc("LgcAssetCrm_SelectByAsset",assetid+separator+type);

while(RecordSetInner.next()){
String id = RecordSetInner.getString("id");
String crmid = RecordSetInner.getString("crmid");
String tempcountryid = RecordSetInner.getString("countryid");
String purchaseprice = RecordSetInner.getString("purchaseprice");
String currencyid = RecordSetInner.getString("currencyid");
String ismain = RecordSetInner.getString("ismain");
if(j==0){
		j=1;
%>
<TR class=DataLight>
<%
	}else{
		j=0;
%>
<TR class=DataDark>
<%
}
%>
	<TD><A href="LgcAssetCrmEdit.jsp?paraid=<%=id%>"><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(crmid),user.getLanguage())%></A></TD>
    <TD> <%	if (tempcountryid.equals("0")) {%>
            全球 
            <% } else {%>
            <%=Util.toScreen(CountryComInfo.getCountrydesc(tempcountryid),user.getLanguage())%> 
            <%}%>
	</TD>
    <TD><%=Util.toScreen(purchaseprice,user.getLanguage())%> </TD>
    <TD><%=Util.toScreen(CurrencyComInfo.getCurrencyname(currencyid),user.getLanguage())%></TD>
    <TD><%if (ismain.equals("1")){%><img src="../../images/BacoCheck_wev8.gif" border=0><%}%></TD>
</TR>
<%}//inner while
}//outer while
%>
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
</BODY></HTML>