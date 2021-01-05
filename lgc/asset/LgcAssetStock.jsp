<%@ page import="weaver.general.Util,java.util.*,java.math.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RecordSetInner" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="AssetComInfo" class="weaver.lgc.asset.AssetComInfo" scope="page"/>
<jsp:useBean id="WarehouseComInfo" class="weaver.lgc.maintenance.WarehouseComInfo" scope="page"/>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</head>
<%
int msgid = Util.getIntValue(request.getParameter("msgid"),-1);
String assetid = Util.null2String(request.getParameter("paraid")) ;
char separator = Util.getSeparator() ;

String imagefilename = "/images/hdLOG_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(535,user.getLanguage())+"-"+SystemEnv.getHtmlLabelName(739,user.getLanguage());
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
<% if(HrmUserVarify.checkUserRight("LgcAssetPriceAdd:Add",user)){ %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(365,user.getLanguage())+",javascript:button1.click(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=Btn id=button1 accessKey=A  style="display:none" 
onclick='location.href="LgcAssetStockAdd.jsp?paraid=<%=assetid%>"' name=button1><U>A</U>-<%=SystemEnv.getHtmlLabelName(365,user.getLanguage())%></BUTTON>
<% } %>

<TABLE class=ListStyle cellspacing=1>
  <TBODY> 
  <TR class=header> 
    <TH colSpan=5><%=SystemEnv.getHtmlLabelName(739,user.getLanguage())%> <a href="LgcAsset.jsp?paraid=<%=assetid%>"><%=Util.toScreen(AssetComInfo.getAssetName(assetid),user.getLanguage())%></a></TH>
  </TR>
  <TR class=Header> 
    <TD>仓库</TD>
    <TD style="TEXT-ALIGN: right">库存</TD>
    <TD style="TEXT-ALIGN: right">加权价</TD>
    <TD style="TEXT-ALIGN: right">库存总价</TD>   
  </TR>
<TR class=Line><TD colSpan=5></TD></TR>

<%
int i=0;
float  stocknumtotal = 0;
boolean edit;
BigDecimal  unitpricetotal = new BigDecimal("0") ;
RecordSet.executeProc("LgcAssetStock_SelectByAsset",assetid);

while(RecordSet.next()){
String id = RecordSet.getString("id");
String warehouseid = RecordSet.getString("warehouseid");
String stocknum = RecordSet.getString("stocknum");
String unitprice = RecordSet.getString("unitprice");
String unitpriceall = RecordSet.getString("unitpriceall");
stocknumtotal+=Util.getFloatValue(stocknum);
unitpricetotal = unitpricetotal.add(new BigDecimal(unitpriceall)) ;
RecordSetInner.executeProc("LgcAssetStock_EditOrView",assetid+separator+warehouseid);
RecordSetInner.next();
if ((RecordSetInner.getString(1)).equals("1")) edit=true;
else edit=false;

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
	<td>
	<%if (edit){%><a href="LgcAssetStockEdit.jsp?paraid=<%=id%>"><%}else{%>
	<a href="LgcStockDetailView.jsp?assetid=<%=assetid%>&warehouseid=<%=warehouseid%>"><%}%>
	<%=Util.toScreen(WarehouseComInfo.getWarehousename(warehouseid),user.getLanguage())%>
	</a>
	</td>
      <td align=right><%=Util.getFloatStr(stocknum,3)%></td>
      <td align=right><%=unitprice%></td>
      <td align=right><%=unitpriceall%></td>
      
</TR>
<%}
%>
<TR  class=header >
	<td>总计</td>
      <td align=right><%=Util.getFloatStr(""+stocknumtotal,3)%>&nbsp;</td>
      <td align=right></td>
      <td align=right><%=Util.getFloatStr(unitpricetotal.toString(),3)%>&nbsp;</td>
      
</TR>
  </TBODY> 
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
</BODY></HTML>