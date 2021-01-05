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
String titlename = SystemEnv.getHtmlLabelName(731,user.getLanguage()) ;
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
		<td valign="top"><form action="LgcAssetBasketOperation.jsp" method="post" id=frmchange onsubmit='return check_form(this,"username,useremail,receiveaddress,postcode,telephone1")'>
  <table class="BtnBar" width="100%">
    <tr>
		
      
    <td width="40%">
    <div style="display:none">
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
      <u>2</u>-购物车</button> </td>
			
      <td align="right" width="60%">
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(16634,user.getLanguage())+",javascript:frmchange.myfun3.click(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
	  <button class="Btn" accesskey="3" id=myfun3  style="display:none" type="submit"><u>3</u>-确认&gt;</button>
      </div>
	  </td>
	</TR><tr><td class=Line1 colspan=4></td></tr>
</table>

  <input class=InputStyle  name="operation" type="hidden" value="adduserinfo">
  <input class=InputStyle  name="catalogid" type="hidden" value="<%=catalogid%>">
  <input class=InputStyle  name="theassortment" type="hidden" value="<%=theassortment%>">
  <input class=InputStyle  name="selectedid" type="hidden" value="<%=selectedid%>">
  <input class=InputStyle  name="thecountry" type="hidden" value="<%=thecountry%>">
  <input class=InputStyle  name="theattributes" type="hidden" value="<%=theattributes%>">
  <input class=InputStyle  name="isthenew" type="hidden" value="<%=isthenew%>">
  <input class=InputStyle  name="start" type="hidden" value="<%=start%>">
  <input class=InputStyle  name="webshoptype" type="hidden" value="<%=webshoptype%>">
  <input class=InputStyle  name="webshopmanageid" type="hidden" value="<%=webshopmanageid%>">
  <input class=InputStyle  name="webshopreturn" type="hidden" value="0">
  <table class=ViewForm id=tblScenarioCode>
    <thead> <colgroup> <col width="15%"> <col width="30%"> <col width="15%"> <col width="40%"></thead> 
    <tbody> 
    <tr> 
      <td>姓名:</td>
      <td class=FIELD> 
        <input class=InputStyle  id=username name=username maxlength="20" onBlur='checkinput("username","usernameimage")' size="15" value="<%=Util.toScreenToEdit(user.getUsername(),user.getLanguage())%>">
        <span id=usernameimage><IMG src="/images/BacoError_wev8.gif" align=absMiddle></span> 
      </td>
      <td>E-mail:</td>
      <td class=field> 
        <input class=InputStyle  id=useremail name=useremail maxlength="20" onBlur='checkinput("useremail","useremailimage")' size="15" value="<%=Util.toScreenToEdit(user.getEmail(),user.getLanguage())%>">
        <span id=useremailimage><img src="/images/BacoError_wev8.gif" align=absMiddle></span> 
      </td>
    </TR><tr><td class=Line colspan=4></td></tr>
    <tr> 
      <td>收货地址:</td>
      <td class=FIELD><nobr> 
        <input class=InputStyle  id=receiveaddress name=receiveaddress maxlength="100" onBlur='checkinput("receiveaddress","receiveaddressimage")' size="50"  value="<%=Util.toScreenToEdit(user.getReceiveaddress(),user.getLanguage())%>">
        <span id=receiveaddressimage><img src="/images/BacoError_wev8.gif" align=absMiddle></span></td>
      <td>联系电话1:</td>
      <td class=field> 
        <input class=InputStyle  id=telephone1 name=telephone1 maxlength="20" onBlur='checkinput("telephone1","telephone1image")' size="15" value="<%=Util.toScreenToEdit(user.getTelephone(),user.getLanguage())%>">
        <span id=telephone1image><img src="/images/BacoError_wev8.gif" align=absMiddle></span> 
      </td>
    </TR><tr><td class=Line colspan=4></td></tr>
    <tr> 
      <td>邮编:</td>
      <td class=FIELD><nobr> 
        <input class=InputStyle  id=postcode name=postcode maxlength="10" onChange='checkinput("postcode","postcodeimage")' size="10"  value="<%=Util.toScreenToEdit(user.getPostcode(),user.getLanguage())%>">
        <span id=postcodeimage><img src="/images/BacoError_wev8.gif" align=absMiddle></span> 
      </td>
      <td>联系电话2:</td>
      <td class=field> 
        <input class=InputStyle  id=telephone2 name=telephone2 maxlength="20" size="15" value="<%=Util.toScreenToEdit(user.getMobile(),user.getLanguage())%>">
      </td>
    </TR><tr><td class=Line colspan=4></td></tr>
    <tr> 
      <td>备注:</td>
      <td class=FIELD colspan="3"><nobr> 
        <textarea id="purchaseremark" name="purchaseremark" rows="6" style='width:100%'><%=Util.toScreenToEdit(user.getRemark(),user.getLanguage())%></textarea>
      </td>
    </TR><tr><td class=Line colspan=4></td></tr>
    </tbody> 
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
</body></html>
