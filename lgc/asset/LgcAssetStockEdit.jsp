<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="WarehouseComInfo" class="weaver.lgc.maintenance.WarehouseComInfo" scope="page"/>
<jsp:useBean id="AssetComInfo" class="weaver.lgc.asset.AssetComInfo" scope="page"/>
<jsp:useBean id="CurrencyComInfo" class="weaver.fna.maintenance.CurrencyComInfo" scope="page"/>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</head>
<%
int msgid = Util.getIntValue(request.getParameter("msgid"),-1);
char separator = Util.getSeparator() ;
boolean canedit = HrmUserVarify.checkUserRight("LgcAssetStockEdit:Edit", user) ;
String paraid = Util.null2String(request.getParameter("paraid")) ;
String assetstockid = paraid ;

RecordSet.executeProc("FnaCurrency_SelectByDefault","");
RecordSet.next();
String defcurrenyid = RecordSet.getString(1);

RecordSet.executeProc("LgcAssetStock_SelectByID",assetstockid);
RecordSet.next();

String warehouseid = Util.null2String(RecordSet.getString("warehouseid"));
String assetid = Util.null2String(RecordSet.getString("assetid"));
String stocknum = Util.null2String(RecordSet.getString("stocknum"));
String unitprice = Util.null2String(RecordSet.getString("unitprice"));

RecordSet.executeProc("LgcStockInOut_SelectByAsset",assetid+separator+warehouseid);
RecordSet.next();

String currencyid = Util.null2String(RecordSet.getString("currencyid"));
String exchangerate = Util.null2String(RecordSet.getString("exchangerate"));

String imagefilename = "/images/hdLOG_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(739,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(93,user.getLanguage());
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
<%if(canedit){%>
<DIV style="display:none">
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:OnSubmit(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btnSave accessKey=S onclick='OnSubmit()'><U>S</U>-保存</BUTTON>
<% }
if(HrmUserVarify.checkUserRight("LgcAssetStockEdit:Delete", user)){
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btnDelete id=Delete accessKey=D onclick="onDelete()"><U>D</U>-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></BUTTON>
<%}%>
 </DIV>
<input type="hidden" name="operation" value="editassetstock">
<input type="hidden" name="assetstockid" value="<%=assetstockid%>">
<input type="hidden" name="assetid" value="<%=assetid%>">
<input type="hidden" name="warehouseid" value="<%=warehouseid%>">
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
    </TR><tr><td class=Line colspan=2></td></tr>
    <TR> 
      <TD>仓库</TD><td class=Field> 
	  <%=Util.toScreen(WarehouseComInfo.getWarehousename(warehouseid),user.getLanguage())%></td>
	  </TD>
    </TR><tr><td class=Line colspan=2></td></tr>
	<TR> 
      <TD>币种</TD>
		<TD class=Field><BUTTON class=Browser id=selectcurrency onClick="onShowCurrencyID()"></BUTTON> <SPAN <input class=InputStyle            id=currencyidspan><%=Util.toScreen(CurrencyComInfo.getCurrencyname(currencyid),user.getLanguage())%></SPAN> 
              <input class=InputStyle  id=currencyid type=hidden value="<%=currencyid%>" name=currencyid>
        </TD>
    </TR><tr><td class=Line colspan=2></td></tr>
	<TR> 
      <TD valign="top">汇率</TD>
      <TD class=Field> 
        <input class=InputStyle  type="text"  name=exchangerate onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("exchangerate")' value=<%=exchangerate%>>
      </TD>
    </TR><tr><td class=Line colspan=2></td></tr>
    <tr> 
      <td valign="top">期初数</td>
      <td class=Field> 
        <input class=InputStyle  type="text"  name=stocknum onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("stocknum")' value=<%=stocknum%>>
      </td>
    </TR><tr><td class=Line colspan=2></td></tr>
    <TR> 
      <TD valign="top">期初单价</TD>
      <TD class=Field> 
        <input class=InputStyle  type="text"  name=unitprice onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("unitprice")' value=<%=unitprice%>>
      </TD>
    </TR><tr><td class=Line colspan=2></td></tr>
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
   		document.frmain.submit();
}

function onDelete(){
		if(confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>")) {
			document.frmain.operation.value="deleteassetstock";
			document.frmain.submit();
		}
}
</script>
</BODY></HTML>
