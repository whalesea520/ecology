<%@ page import="weaver.general.Util,java.util.*,java.math.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>

<% if(!HrmUserVarify.checkUserRight("LgcAssetStockAdd:Add",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
   }
%>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="AssetComInfo" class="weaver.lgc.asset.AssetComInfo" scope="page"/>
<jsp:useBean id="WarehouseComInfo" class="weaver.lgc.maintenance.WarehouseComInfo" scope="page"/>
<jsp:useBean id="CurrencyComInfo" class="weaver.fna.maintenance.CurrencyComInfo" scope="page"/>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</head>
<%
int msgid = Util.getIntValue(request.getParameter("msgid"),-1);
String assetid = Util.null2String(request.getParameter("paraid")) ;
char separator = Util.getSeparator() ;

RecordSet.executeProc("FnaCurrency_SelectByDefault","");
RecordSet.next();
String defcurrenyid = RecordSet.getString(1);

String imagefilename = "/images/hdLOG_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(739,user.getLanguage())+"-"+SystemEnv.getHtmlLabelName(365,user.getLanguage());
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
<FORM name=frmain action=LgcAssetStockOperation.jsp?Action=2 method=post>
  <%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:OnSubmit(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
  <input type="hidden" name="assetid" value="<%=assetid%>">
  <input type="hidden" name="operation" value="addassetstock">
  <input type=hidden name="trandefcurrencyid" value="<%=defcurrenyid%>">

<TABLE class=ViewForm>
    <COLGROUP> <COL width="10%"> <COL width="90%"> <TBODY> 
    <TR class=Title> 
      <TH colSpan=2>基本信息</TH>
    </TR>
    <TR class=Spacing> 
      <TD class=Line1 colSpan=2></TD>
    </TR>
    <tr> 
      <td>资产</td>
      <td class=Field> <a href="LgcAsset.jsp?paraid=<%=assetid%>"><%=Util.toScreen(AssetComInfo.getAssetName(assetid),user.getLanguage())%></a></td>
    </tr>
    <TR> 
      <TD>仓库</TD>
     <td class=Field><button class=Browser id=selectwarehouse onClick="onShowWarehouseID()"></button> 
	 <input class=InputStyle  id=warehouseidspan><IMG src='/images/BacoError_wev8.gif' align=absMiddle></span> 
       <input class=InputStyle  id=warehouseid type=hidden name=warehouseid>
	  </TD>
    </TR>
    <TR> 
      <TD>币种</TD>
		<TD class=Field><BUTTON class=Browser 
            id=selectcurrency onClick="onShowCurrencyID()"></BUTTON> <input class=InputStyle  
            id=currencyidspan><%=Util.toScreen(CurrencyComInfo.getCurrencyname(defcurrenyid),user.getLanguage())%></SPAN> 
               <input class=InputStyle  id=currencyid type=hidden value="<%=defcurrenyid%>" name=currencyid>
        </TD>
    </TR>
	<TR> 
      <TD valign="top">汇率</TD>
      <TD class=Field> 
        <input class=InputStyle  type="text"  name=exchangerate value="1" onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("exchangerate")'>
      </TD>
    </TR>
	<tr> 
      <td valign="top">期初数</td>
      <td class=Field> 
        <input class=InputStyle  type="text" name=stocknum value="0" onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("stocknum")'>
      </td>
    </tr>
    <TR> 
      <TD valign="top">期初单价</TD>
      <TD class=Field> 
        <input class=InputStyle  type="text"  name=unitprice value="0.00" onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("unitprice")'>
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
<SCRIPT language=VBS>
sub onShowWarehouseID()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/lgc/maintenance/LgcWarehouseBrowser.jsp")
	if NOT isempty(id) then
		if id(0)<> "" then
		warehouseidspan.innerHtml = id(1)
		frmain.warehouseid.value=id(0)
		else
		warehouseidspan.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
		frmain.warehouseid.value= ""
		end if
	end if
end sub
sub onShowCurrencyID()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/fna/maintenance/CurrencyBrowser.jsp")
	if NOT isempty(id) then
		if id(0)<> "" then
		currencyidspan.innerHtml = id(1)
		frmain.currencyid.value=id(0)
		else
		currencyidspan.innerHtml = ""
		frmain.currencyid.value= ""
		end if
	end if
end sub
</SCRIPT>

<SCRIPT language="javascript">
function OnSubmit(){
    if(check_form(document.frmain,"warehouseid"))
	{	
		document.frmain.submit();
	}
}
</script>
</BODY></HTML>
