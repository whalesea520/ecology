<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<% if(!HrmUserVarify.checkUserRight("LgcAssetMarkChg:Chg",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
   }
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</head>
<%
int msgid = Util.getIntValue(request.getParameter("msgid"),-1);  
String imagefilename = "/images/hdLOG_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(535,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(715,user.getLanguage());
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
<FORM id=frmmain action=LgcToolsOperation.jsp method=post onsubmit="return check_form(this,'assetid,assetmark')">
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:frmmain.myfun1.click(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON language=VBS class=Btn accessKey=1 id=myfun1 type=submit style="display:none"><U>1</U>-确定</BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:location='../LgcMaintenance.jsp',_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=Btn accessKey=2 onclick='location="../LgcMaintenance.jsp"'  style="display:none"><U>2</U>-取消</BUTTON> 
  <input type="hidden" name="operation" value="markchange">
  <p></p>
  <TABLE class=ViewForm >
    <COLGROUP> <COL width="10%"> <COL width="90%"> <TBODY> 
    <tr><td class=Line1 colspan=2></td></tr>
    <TR>
      <TD>资产编号: 旧</TD>
    <TD class=Field>
	<button class=Browser id=SelectAssortment onClick="SelectAssetID()"></button> 
        <span class=InputStyle id=assetidspan><IMG src='/images/BacoError_wev8.gif' align=absMiddle></span> 
        <input id=assetid type=hidden name=assetid>
       </TD>
  </TR>
  <TR>
      <TD>资产编号: 新</TD>
    <TD class=Field><INPUT class=InputStyle maxLength=30 size=50 name=assetmark onChange='checkinput("assetmark","assetmarkimage")'> 
	<span id=assetmarkimage><img src="/images/BacoError_wev8.gif" align=absMiddle></span> 
	</TD></TR><tr><td class=Line colspan=2></td></tr></TBODY></TABLE>
   		</td>
		</TR><tr><td class=Line colspan=2></td></tr>
		</TABLE>
	</td>
	<td></td>
</TR><tr><td class=Line colspan=2></td></tr>
<tr>
	<td height="10" colspan="3"></td>
</tr>
</table>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

   
   </FORM>
<script language="vbs">
sub SelectAssetID()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/lgc/asset/LgcAssetBrowser.jsp ")
	if NOT isempty(id) then
	    if id(0)<> "" then
			assetidspan.innerHtml = id(1)
			frmmain.assetid.value=id(0)
		else
			assetidspan.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
			frmmain.assetid.value=""
		end if
	end if
end sub
</script>
</BODY></HTML>
