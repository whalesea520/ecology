<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<% if(!HrmUserVarify.checkUserRight("LgcAssetPriceAdd:Add",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
   }
%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="CurrencyComInfo" class="weaver.fna.maintenance.CurrencyComInfo" scope="page"/>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</head>
<%
int msgid = Util.getIntValue(request.getParameter("msgid"),-1);
String paraid = Util.null2String(request.getParameter("paraid")) ;
String assetid = paraid ;
String assetcountryid = Util.null2String(request.getParameter("assetcountryid")) ;

RecordSet.executeProc("FnaCurrency_SelectByDefault","");
RecordSet.next();
String defcurrenyid = RecordSet.getString(1);

String imagefilename = "/images/hdLOG_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(726,user.getLanguage())+" : "+SystemEnv.getHtmlLabelName(365,user.getLanguage());
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
</DIV>
<%}%>
<FORM name=frmain action=LgcAssetPriceOperation.jsp?Action=2 method=post>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:OnSubmit(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>    
  <input type="hidden" name="assetid" value="<%=assetid%>">
  <input type="hidden" name="assetcountryid" value="<%=assetcountryid%>">
  <input type="hidden" name="operation" value="addassetprice">
 <TABLE class=ViewForm width="100%">
    <COLGROUP> <COL width="10%"> <COL width="90%"> <TBODY> 
    <TR class=Title> 
      <TH colSpan=2>价格</TH>
    </TR>
    <TR class=Spacing> 
      <TD class=Line1 colSpan=2></TD>
    </TR>
    <tr> 
      <td>数量，从</td>
      <td class=Field> 
        <input type=text <input class=InputStyle  id=Type size=10 name=numfrom>
      </td>
    </TR><tr><td class=Line colspan=2></td></tr>
    <TR> 
      <TD>数量，到</TD>
      <TD class=Field> 
        <input type=text <input class=InputStyle  id=Type size=10 name=numto>
      </TD>
    </TR><tr><td class=Line colspan=2></td></tr>
    <TR> 
      <TD>说明</TD>
      <TD class=Field> 
        <input type=text <input class=InputStyle  id=Type size=60 name=pricedesc maxLength=60>
      </TD>
    </TR><tr><td class=Line colspan=2></td></tr>
    <tr> 
      <td>币种</td>
      <td class=Field><button class=Browser 
            id=selectcurrency onClick="onShowCurrencyID()"></button> <span <input class=InputStyle  
            id=currencyidspan><%=Util.toScreen(CurrencyComInfo.getCurrencyname(defcurrenyid),user.getLanguage())%></span> 
              <input <input class=InputStyle  id=currencyid type=hidden value=<%=defcurrenyid%> name=currencyid>
       </td>
    </TR><tr><td class=Line colspan=2></td></tr>
    <TR> 
      <TD>单价</TD>
      <TD class=Field><input type=text <input class=InputStyle  id=Type size=20 value=0.00 name=unitprice onChange='checkinput("unitprice","unitpriceimage")'><span id=unitpriceimage></span> </TD>
    </TR><tr><td class=Line colspan=2></td></tr>
    <TR> 
      <TD>增值税率</TD>
      <TD class=Field> 
        <input type=text <input class=InputStyle  id=Type size=10 name=taxrate>%</TD>
    </TR><tr><td class=Line colspan=2></td></tr>
    </TBODY> 
  </TABLE>
</form>
</BODY>
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
		currencyidspan.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
		frmain.currencyid.value= ""
		end if
	end if
end sub
</SCRIPT>

<SCRIPT language="javascript">
function OnSubmit(){
    if(check_form(document.frmain,"currencyid,unitprice"))
	{	
		document.frmain.submit();
	}
}
</script>
</HTML>
