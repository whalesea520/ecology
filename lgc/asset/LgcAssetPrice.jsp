<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="CountryComInfo" class="weaver.hrm.country.CountryComInfo" scope="page"/>
<jsp:useBean id="CurrencyComInfo" class="weaver.fna.maintenance.CurrencyComInfo" scope="page"/>
<jsp:useBean id="AssetComInfo" class="weaver.lgc.asset.AssetComInfo" scope="page"/>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</head>
<%
int msgid = Util.getIntValue(request.getParameter("msgid"),-1);
String assetid = Util.null2String(request.getParameter("paraid")) ;
String assetcountryid = Util.null2String(request.getParameter("assetcountryid")) ;
char separator = Util.getSeparator() ;

String imagefilename = "/images/hdLOG_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(726,user.getLanguage());
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
<%
if(msgid!=-1){
%>
<DIV>
<font color=red size=2>
<%=SystemEnv.getErrorMsgName(msgid,user.getLanguage())%>
</font>
</DIV >
<%}%>
<div style="display:none">
<% if(HrmUserVarify.checkUserRight("LgcAssetPriceAdd:Add",user)){ %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(365,user.getLanguage())+",javascript:button1.click(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=Btn id=button1 accessKey=A 
onclick='location.href="LgcAssetPriceAdd.jsp?paraid=<%=assetid%>&assetcountryid=<%=assetcountryid%>"' 
name=button1><U>A</U>-<%=SystemEnv.getHtmlLabelName(365,user.getLanguage())%></BUTTON>
<% } %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(535,user.getLanguage())+",javascript:button2.click(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=Btn id=button2 accessKey=R 
onclick='location.href="LgcAsset.jsp?paraid=<%=assetid%>&assetcountryid=<%=assetcountryid%>"' 
name=button2><U>R</U>-<%=SystemEnv.getHtmlLabelName(535,user.getLanguage())%></BUTTON>
</div>

  <table class=ViewForm width="100%">
    <colgroup> <col width=10%> <col width="90%"> <tbody> 
    <tr class=Title> 
      <th colspan=2>资产</th>
    </tr>
    <tr class=Spacing> 
      <td class=Line1 colspan=2></td>
    </tr>
    <tr> 
      <td>标识</td>
      <td class=Field><b><%=Util.toScreen(AssetComInfo.getAssetMark(assetid),user.getLanguage())%></b></td>
    </TR><tr><td class=Line colspan=2></td></tr>
    <tr> 
      <td>名称</td>
      <td class=Field><%=Util.toScreen(AssetComInfo.getAssetName(assetid),user.getLanguage())%></td>
    </TR><tr><td class=Line colspan=2></td></tr>
    <tr> 
      <td>国家</td>
     <td class=Field> 
            <%	if (assetcountryid.equals("0")) {%>
            全球 
            <% } else {%>
            <%=Util.toScreen(CountryComInfo.getCountrydesc(assetcountryid),user.getLanguage())%> 
            <%}%>
    </TR><tr><td class=Line colspan=2></td></tr>
    </tbody> 
  </table>
  <br>
  <table class=ListStyle cellspacing=1>
    <tbody> 
    <tr class=header> 
      <th colspan=6>价格</th>
    </tr>
    <tr class=Header> 
      <td style="TEXT-ALIGN: right">数量，从</td>
      <td style="TEXT-ALIGN: right">数量，到</td>
      <td>说明</td>
      <td >币种</td>
      <td>单价</td>
      <td>增值税 (百分率)</td>
    </tr>
<TR class=Line><TD colSpan=6></TD></TR>

<%
int i=0;
RecordSet.executeProc("LgcAssetPrice_SelectByAsset",assetid+separator+assetcountryid);

while(RecordSet.next()){
String id = RecordSet.getString("id");
String pricedesc = RecordSet.getString("pricedesc");
String numfrom = Util.null2String(RecordSet.getString("numfrom"));
String numto = Util.null2String(RecordSet.getString("numto"));
String currencyid = RecordSet.getString("currencyid");
String unitprice = RecordSet.getString("unitprice");
String taxrate = RecordSet.getString("taxrate");
if(numfrom.equals("0")) numfrom= "" ;
if(numto.equals("0")) numto= "" ;

if(i==0){
		i=1;
%>
<TR class=DataLight>
<%
	}else{
		i=0;
%>
<TR class=DataDark>
<%
}
%>
	<td style="TEXT-ALIGN: right"><%=numfrom%></td>
      <td style="TEXT-ALIGN: right"><%=numto%></td>
      <td><%=Util.toScreen(pricedesc,user.getLanguage())%></td>
      <td ><%=Util.toScreen(CurrencyComInfo.getCurrencyname(currencyid),user.getLanguage())%></td>
      <td><a href="LgcAssetPriceEdit.jsp?paraid=<%=id%>&redirect=2"><%=Util.toScreen(unitprice,user.getLanguage())%></a></td>
      <td><%=Util.toScreen(taxrate,user.getLanguage())%></td>
</TR>
<%}
%>


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
  </body></html>