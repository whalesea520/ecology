<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
</head>
<%
String imagefilename = "/images/hdHRMCard_wev8.gif";
String titlename =SystemEnv.getHtmlLabelName(365,user.getLanguage())+" ："+SystemEnv.getHtmlLabelName(15187,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:weaver.domysave.click(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>

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
<FORM id=weaver name=frmMain action="InputReportOperation.jsp" method=post onSubmit="return check_form(this,'inprepname,inpreptablename')">

<DIV>
<BUTTON class=btnSave accessKey=S  style="display:none" id=domysave  type=submit><U>S</U>-<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%></BUTTON>
</DIV>
<br>

<TABLE class=ViewForm>
  <COLGROUP>
  <COL width="20%">
  <COL width="80%">
  <TBODY>
  <TR class=Title>
      <TH colSpan=2><%=SystemEnv.getHtmlLabelName(15188,user.getLanguage())%></TH>
    </TR>
  <TR class=Spacing>
    <TD class=Line1 colSpan=2 ></TD></TR>
  <TR>
          <TD><%=SystemEnv.getHtmlLabelName(15189,user.getLanguage())%></TD>
          <TD class=Field><INPUT type=text class=InputStyle size=50 name="inprepname" onchange='checkinput("inprepname","inprepnameimage")'>
          <SPAN id=inprepnameimage><IMG src="/images/BacoError_wev8.gif" align=absMiddle></SPAN></TD>
        </TR><tr><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(15190,user.getLanguage())%></TD>
          <TD class=Field><INPUT type=text  class=InputStyle size=40 name="inpreptablename" onchange='checkinput("inpreptablename","inpreptablenameimage")'>
          <SPAN id=inpreptablenameimage><IMG src="/images/BacoError_wev8.gif" align=absMiddle></SPAN>（<%=SystemEnv.getHtmlLabelName(15191,user.getLanguage())%>："T_"+"<%=SystemEnv.getHtmlLabelName(15186,user.getLanguage())%>"[<%=SystemEnv.getHtmlLabelName(642,user.getLanguage())%>]，<%=SystemEnv.getHtmlLabelName(15192,user.getLanguage())%>。）</TD>
        </TR><tr><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(15193,user.getLanguage())%></TD>
          <TD class=Field><INPUT type=text class=InputStyle  size=40 name="urlname" onchange='checkinput("urlname","urlnameimage")'>
          <SPAN id=urlnameimage><IMG src="/images/BacoError_wev8.gif" align=absMiddle></SPAN>     <%=SystemEnv.getHtmlLabelName(15194,user.getLanguage())%>：www.e-cology.com.cn</TD>
        </TR><tr><td class=Line colspan=2></td></tr>
        <tr>
        <td><%=SystemEnv.getHtmlLabelName(15195,user.getLanguage())%></td>
        <td class=Field>
        <BUTTON class=Browser ID=SelectLayout name=SelectLayout onclick="showMailMould()"> </BUTTON>
		<SPAN ID=DisplayLayout></SPAN>
		<INPUT TYPE=HIDDEN ID=mailid NAME="mailid" ></INPUT></td>
        </TR><tr><td class=Line colspan=2></td></tr>
        <input type="hidden" name=operation value=add>
 </TBODY></TABLE>

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
 <script language=vbs>
sub showMailMould()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/mail/DocMouldBrowser.jsp")
	if (Not IsEmpty(id)) then
		if id(0)<> "0" then
			DisplayLayout.innerHtml = "<A href='/docs/mail/DocMouldDsp.jsp?id="&id(0)&"'>"&id(1)&"</A>"
			weaver.mailid.value=id(0)
		else 
			DisplayLayout.innerHtml =""
			weaver.mailid.value=""
		end if
	end if
end sub
</script>
</BODY></HTML>
