<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%
/* if(!HrmUserVarify.checkUserRight("HrmProvinceAdd:Add", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	} */
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</head>
<%
String imagefilename = "/images/hdHRMCard_wev8.gif";
String titlename = Util.fromScreen2("<%=SystemEnv.getHtmlLabelName(15519,user.getLanguage())%>"，7,"0");
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",/workflow/report/ReportTypeManage.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<FORM id=weaver name=frmMain action="ReportTypeOperation.jsp" method=post>

<%
 // if(HrmUserVarify.checkUserRight("HrmProvinceAdd:Add", user)){
%>

<%
// }
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

<TABLE class="viewform">
  <COLGROUP>
  <COL width="20%">
  <COL width="80%">
  <TBODY>
  <TR class="Title">
      <TH colSpan=2><%=SystemEnv.getHtmlLabelName(15434,user.getLanguage())%></TH>
    </TR>
  <TR >
    <TD class="Line1" colSpan=2 ></TD></TR>
  <TR>
          
      <TD><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
          <TD class=Field>
        <INPUT type=text class=Inputstyle size=30 name="typename" onchange='checkinput("typename","typenameimage")'>
          <SPAN id=typenameimage><IMG src="/images/BacoError_wev8.gif" align=absMiddle></SPAN></TD>
        </TR>
        <TR>
           <TR >
    <TD class="Line1" colSpan=2 ></TD></TR> 
      <TD><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></TD>
          <TD class=Field><INPUT type=text  class=Inputstyle size=60 name="typedesc">
          <SPAN id=provincedescimage></SPAN></TD>
        </TR>  <TR >
    <TD class="Line1" colSpan=2 ></TD></TR>
  <TR>
          
      <TD><%=SystemEnv.getHtmlLabelName(15513,user.getLanguage())%></TD>
          
      <TD class=Field>
        <input type="text"   class=Inputstyle name="typeorder" size="7">
      </TD>
        </TR>  <TR >
    <TD class="Line1" colSpan=2 ></TD></TR>
        <input type="hidden" name=operation value=reporttypeadd>
 </TBODY></TABLE>
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


 </form>
 <script language=vbs>

sub onShowCountryID()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/country/CountryBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	countryidspan.innerHtml = id(1)
	frmMain.countryid.value=id(0)
	else 
	countryidspan.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
	frmMain.countryid.value=""
	end if
	end if
end sub


</script>
<script language="javascript">
function submitData()
{
	if (check_form(frmMain,'typenameimage'))
		frmMain.submit();
}
</script>

</BODY></HTML>
