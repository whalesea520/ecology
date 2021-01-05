<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<% if(!HrmUserVarify.checkUserRight("LgcConfigurationAdd:Add",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
   }
%>
<jsp:useBean id="AssetComInfo" class="weaver.lgc.asset.AssetComInfo" scope="page" />

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</head>
<%
int msgid = Util.getIntValue(request.getParameter("msgid"),-1);
String paraid = Util.null2String(request.getParameter("paraid")) ;
String assetid = paraid ;
String relation = Util.null2String(request.getParameter("relation")) ;
String assetmark = Util.toScreen(AssetComInfo.getAssetMark(assetid),user.getLanguage());
String assetname = Util.toScreen(AssetComInfo.getAssetName(assetid),user.getLanguage());
String supassetid = "";
String subassetid = "";


String imagefilename = "/images/hdLOG_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(535,user.getLanguage())+" : "+SystemEnv.getHtmlLabelName(729,user.getLanguage());
if (relation.equals("1")) titlename +="-"+SystemEnv.getHtmlLabelName(728,user.getLanguage());
if (relation.equals("2")) titlename +="-"+SystemEnv.getHtmlLabelName(596,user.getLanguage());
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
<FORM name=frmain action="LgcConfigurationOperation.jsp?" method=post>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:OnSubmit(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>    
  <input type="hidden" name="theassetid" value="<%=assetid%>">
  <input type="hidden" name="relation" value="<%=relation%>">
  <input type="hidden" name="operation" value="addconfiguration">
 <TABLE class=ViewForm width="100%">
    <COLGROUP> <COL width="10%"> <COL width="90%"> <TBODY> 
    <tr><td class=Line1 colspan=2></td></tr>
    <TR>
	  <td><%if(relation.equals("1")){%><%=SystemEnv.getHtmlLabelName(596,user.getLanguage())%>资产
		  <%}else{%><%=SystemEnv.getHtmlLabelName(728,user.getLanguage())%>资产<%}%></td>
      <td class=Field> 
		<%=assetmark%>-<%=assetname%>
      </td>
	</TR><tr><td class=Line colspan=2></td></tr>
	<TR class=Title> 
      <TH colSpan=2>关系</TH>
    </TR>
    <TR class=Spacing> 
      <TD class=Line1 colSpan=2></TD>
    </TR>
    <tr> 
      <td>类型</td>
        <td class=Field> <BUTTON class=Browser id=SelectRelationTypeID onClick="onShowRelationTypeID()"></BUTTON> 
              <span id=relationtypeidspan><IMG src='/images/BacoError_wev8.gif' align=absMiddle></span> 
              <INPUT <input class=InputStyle  type=hidden name=relationtypeid>
            </TD>
    </TR><tr><td class=Line colspan=2></td></tr>
    <td><%if(relation.equals("2")){%><%=SystemEnv.getHtmlLabelName(596,user.getLanguage())%>资产
		  <%}else{%><%=SystemEnv.getHtmlLabelName(728,user.getLanguage())%>资产<%}%></td>
    <td class=Field> <BUTTON class=Browser id=SelectRelateAssetID onClick="onShowRelateAssetID()"></BUTTON> 
       <span id=relateassetidspan><IMG src='/images/BacoError_wev8.gif' align=absMiddle></span> 
         <INPUT <input class=InputStyle  type=hidden name=relateassetid>
    </td></TR><tr><td class=Line colspan=2></td></tr>
    </TBODY> 
  </TABLE>
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
</BODY>
<SCRIPT language=VBS>
sub onShowRelationTypeID()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/lgc/maintenance/LgcAssetRelationTypeBrowser.jsp")
	if NOT isempty(id) then
		if id(0)<> "" then
		relationtypeidspan.innerHtml = id(1)
		frmain.relationtypeid.value=id(0)
		else
		relationtypeidspan.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
		frmain.relationtypeid.value= ""
		end if
	end if
end sub

sub onShowRelateAssetID()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/lgc/asset/LgcAssetBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	relateassetidspan.innerHtml = id(1)
	frmain.relateassetid.value=id(0)
	else 
	relateassetidspan.innerHtml = ""
	frmain.relateassetid.value="<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
	end if
	end if
end sub
</SCRIPT>

<SCRIPT language="javascript">
function OnSubmit(){
    if(check_form(document.frmain,"relationtypeid,relateassetid"))
	{	
		document.frmain.submit();
	}
}
</script>
</HTML>
