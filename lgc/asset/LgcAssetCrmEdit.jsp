<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />
<jsp:useBean id="CurrencyComInfo" class="weaver.fna.maintenance.CurrencyComInfo" scope="page"/>
<jsp:useBean id="AssetUnitComInfo" class="weaver.lgc.maintenance.AssetUnitComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page"/>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</head>
<%
int msgid = Util.getIntValue(request.getParameter("msgid"),-1);
boolean canedit = HrmUserVarify.checkUserRight("LgcAssetCrmEdit:Edit", user) ;
String paraid = Util.null2String(request.getParameter("paraid")) ;
String assetcrmid = paraid ;
RecordSet.executeProc("LgcAssetCrm_SelectByID",assetcrmid);
RecordSet.next();

String assetid = RecordSet.getString("assetid");
String countryid = RecordSet.getString("countryid");
String crmid = RecordSet.getString("crmid");
String ismain = RecordSet.getString("ismain");
String assetcode = RecordSet.getString("assetcode");
String currencyid = RecordSet.getString("currencyid");
String purchaseprice = RecordSet.getString("purchaseprice");
String taxrate = RecordSet.getString("taxrate");
String unitid = RecordSet.getString("unitid");
String packageunit = RecordSet.getString("packageunit");
String supplyremark = RecordSet.getString("supplyremark");
String docid = RecordSet.getString("docid");

String imagefilename = "/images/hdLOG_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(535,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(147,user.getLanguage());
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
<FORM name=frmain action=LgcAssetCrmOperation.jsp?Action=2 method=post>
<%if(canedit){%>
<DIV style="display:none">
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:OnSubmit(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btnSave accessKey=S onclick='OnSubmit()'><U>S</U>-保存</BUTTON>
<% }
if(HrmUserVarify.checkUserRight("LgcAssetCrmEdit:Delete", user)){
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btnDelete id=Delete accessKey=D onclick="onDelete()"><U>D</U>-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></BUTTON>
<%}%>
 </DIV>
<input type="hidden" name="operation" value="editassetcrm">
<input type="hidden" name="assetid" value="<%=assetid%>">
<input type="hidden" name="countryid" value="<%=countryid%>">
<input type="hidden" name="assetcrmid" value="<%=assetcrmid%>">
 <TABLE class=ViewForm>
    <COLGROUP> <COL width="15%"> <COL width="85%"><TBODY> 
    <TR class=Title> 
      <TH colSpan=2>CRM</TH>
    </TR>
    <TR class=Spacing> 
      <TD class=Line1 colSpan=2></TD>
    </TR>
    <TR> 
      <TD>CRM</TD>
      <TD class=Field><%if(canedit){%> <button class=Browser id=SelectCrm onClick="onShowCrmId()"></button> 
              <span <input class=InputStyle  id=crmidspan><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(crmid),user.getLanguage())%></span>		  
              <input id=crmid type=hidden name=crmid value=<%=crmid%>>
			<%}else {%><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(crmid),user.getLanguage())%><%}%>
       </TD>
    </TR><tr><td class=Line colspan=3></td></tr>
    <TR> 
      <TD>主要</TD>
      <TD class=Field> <%if(canedit){%>
        <input type=checkbox  name="ismain" value="1" <%if (ismain.equals("1")) {%>checked <%}%>>
		<%}else {%>
		<input type=checkbox  name="ismain" value="1" <%if (ismain.equals("1")) {%>checked <%}%> disabled>
		<%}%>
      </TD>
    </TR><tr><td class=Line colspan=3></td></tr>
    <TR> 
      <TD>资产编号&nbsp;-&nbsp;CRM</TD>
      <TD class=Field> <%if(canedit){%>
        <INPUT <input class=InputStyle  maxLength=30 size=30 name=assetcode value=<%=assetcode%>>
		<%}else {%><%=Util.toScreen(assetcode,user.getLanguage())%><%}%>
      </TD>
    </TR><tr><td class=Line colspan=3></td></tr>
    <TR> 
      <TD>币种</TD>
       <TD class=Field><%if(canedit){%><BUTTON class=Browser 
            id=selectcurrency onClick="onShowCurrencyID()"></BUTTON> <SPAN <input class=InputStyle  
            id=currencyidspan><%=Util.toScreen(CurrencyComInfo.getCurrencyname(currencyid),user.getLanguage())%></SPAN> 
              <INPUT <input class=InputStyle  id=currencyid type=hidden value=2 name=currencyid value=<%=currencyid%>><%}else {%><%=Util.toScreen(CurrencyComInfo.getCurrencyname(currencyid),user.getLanguage())%><%}%>
       </TD>
    </TR><tr><td class=Line colspan=3></td></tr>
    <TR> 
      <TD>价格</TD>
      <TD class=Field> <%if(canedit){%>
        <INPUT <input class=InputStyle  maxLength=16 size=16 name=purchaseprice onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("purchaseprice")'  value=<%=purchaseprice%>>
		<%}else {%><%=Util.toScreen(purchaseprice,user.getLanguage())%><%}%>
      </TD>
    </TR><tr><td class=Line colspan=3></td></tr>
    <TR> 
      <TD>增值税&nbsp;%</TD>
      <TD class=Field> <%if(canedit){%>
        <INPUT <input class=InputStyle   size=13  name=taxrate value="<%=taxrate%>"         onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("taxrate")'>
	<%}else {%><%=Util.toScreen(taxrate,user.getLanguage())%><%}%>
      </TD>
    </TR><tr><td class=Line colspan=3></td></tr>
    <TR> 
      <TD>计量单位</TD>
      <td class=Field> <%if(canedit){%>
				<BUTTON class=Browser id=SelectAssetUnitID onClick="onShowAssetUnitID()"></BUTTON> 
              <span id=unitidspan><%=Util.toScreen(AssetUnitComInfo.getAssetUnitname(unitid),user.getLanguage())%></span> 
              <INPUT <input class=InputStyle  type=hidden name=unitid value=<%=unitid%>>
		<%}else {%><%=Util.toScreen(AssetUnitComInfo.getAssetUnitname(unitid),user.getLanguage())%><%}%>
      </TD>
    </TR><tr><td class=Line colspan=3></td></tr>
    <TR> 
      <TD>包装单位</TD>
      <TD class=Field> <%if(canedit){%>
        <INPUT <input class=InputStyle  maxLength=30 size=30 name=packageunit value=<%=packageunit%>>
	<%}else {%><%=Util.toScreen(packageunit,user.getLanguage())%><%}%>
      </TD>
    </TR><tr><td class=Line colspan=3></td></tr>
    <TR> 
      <TD valign="top">备注</TD>
      <TD class=Field> <%if(canedit){%>
        <textarea class=InputStyle cols="60" name=supplyremark rows="6"><%=Util.toScreen(supplyremark,user.getLanguage())%></textarea>
	<%}else {%><%=Util.toScreen(supplyremark,user.getLanguage())%><%}%>
      </TD>
    </TR><tr><td class=Line colspan=3></td></tr>
     <tr> 
      <td>文档</td>
      <td class=Field>  <%if(canedit){%><BUTTON class=Browser id=SelectDocID onClick="onShowDocID()"></BUTTON> 
              <span id=docidspan><%=Util.toScreen(DocComInfo.getDocname(docid),user.getLanguage())%></span> 
              <INPUT <input class=InputStyle  type=hidden name=docid value=<%=docid%>>
	<%}else {%><%=Util.toScreen(DocComInfo.getDocname(docid),user.getLanguage())%><%}%>
      </TD>
    </TR><tr><td class=Line colspan=3></td></tr>
<!--    <TR> 
      <TD>合同</TD>
      <TD class=Field> <BUTTON class=Browser id=SelectDocumentID></BUTTON> <A 
      <input class=InputStyle  id=DocumentIDLink 
      href="http://server-weaver/new/docs/BDDocument.asp?Action=View&amp;ID="></A> 
      </TD>
    </TR><tr><td class=Line colspan=3></td></tr> -->
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
/////////////////////////////////////////////////////////////////////////////////
sub onShowCrmId()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	crmidspan.innerHtml = id(1)
	frmain.crmid.value=id(0)
	else 
	crmidspan.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
	frmain.crmid.value="" 
	end if
	end if
end sub

sub onShowDocID()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/docs/DocBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	docidspan.innerHtml = id(1)
	frmain.docid.value=id(0)
	else
	docidspan.innerHtml = ""
	frmain.docid.value=""
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

sub onShowAssetUnitID()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/lgc/maintenance/LgcAssetUnitBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	unitidspan.innerHtml = id(1)
	frmain.unitid.value=id(0)
	else 
	unitidspan.innerHtml = ""
	frmain.unitid.value=""
	end if
	end if
end sub
</SCRIPT>

<SCRIPT language="javascript">
function OnSubmit(){
    if(check_form(document.frmain,"crmid"))
	{	
		document.frmain.ismain.disabled = false;
		document.frmain.submit();
	}
}
function onDelete(){
		if(confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>")) {
			document.frmain.operation.value="deleteassetcrm";
			document.frmain.submit();
		}
}

</script>
</BODY></HTML>
