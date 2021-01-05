<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%
 if(!HrmUserVarify.checkUserRight("WorkflowReportManage:All", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	} 
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</head>
<%
String imagefilename = "/images/hdHRMCard_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(15527,user.getLanguage()) ;
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>


<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:frmMain.submit(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>


<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>


<FORM id=weaver name=frmMain action="StaticReportOperation.jsp" method=post >
<input type="hidden" name=operation value=reportadd>

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
      <TH colSpan=2><%=SystemEnv.getHtmlLabelName(15436,user.getLanguage())%></TH>
    </TR>
  <TR class="Spacing">
    <TD class="Line1" colSpan=2 ></TD></TR>
  <TR>    
      <TD><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
      <TD class=Field>
        <INPUT type=text class=Inputstyle size=30 name="name" onchange='checkinput("name","namespan")'>
          <SPAN id=namespan><IMG src="/images/BacoError_wev8.gif" align=absMiddle></SPAN></TD>
  </TR>
    <TR class="Spacing">
    <TD class="Line" colSpan=2 ></TD></TR>
  <TR>   
      <TD><%=SystemEnv.getHtmlLabelName(15528,user.getLanguage())%></TD>    
      <TD class=Field>
        <INPUT type=text class=Inputstyle size=30 name="pagename" onchange='checkinput("pagename","pagenamespan")'>
          <SPAN id=pagenamespan><IMG src="/images/BacoError_wev8.gif" align=absMiddle></SPAN></TD>
  </TR>
      <TR class="Spacing">
    <TD class="Line" colSpan=2 ></TD></TR>
  <TR>    
      <TD><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></TD>
      <TD class=Field>
      <textarea  class=Inputstyle name="description" rows=5 cols=70></textarea>
      </TD>
  </TR>
      <TR class="Spacing">
    <TD class="Line" colSpan=2 ></TD></TR>
  <TR>
      <TD><%=SystemEnv.getHtmlLabelName(15529,user.getLanguage())%></TD>   
      <TD class=Field>
        <select class=inputstyle  name="module" size=1>
            <option value="1"><%=SystemEnv.getHtmlLabelName(2115,user.getLanguage())%></option>
            <option value="2"><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></option>
            <option value="3"><%=SystemEnv.getHtmlLabelName(2113,user.getLanguage())%></option>
            <option value="4"><%=SystemEnv.getHtmlLabelName(2116,user.getLanguage())%></option>
            <option value="5"><%=SystemEnv.getHtmlLabelName(2118,user.getLanguage())%></option>
            <option value="6"><%=SystemEnv.getHtmlLabelName(2114,user.getLanguage())%></option>
            <option value="7"><%=SystemEnv.getHtmlLabelName(2117,user.getLanguage())%></option>
        </select>
      </TD>
  </TR>
       <TR class="Spacing">
    <TD class="Line1" colSpan=2 ></TD></TR>     
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
 <script language="javascript">
function submitData()
{
		weaver.submit();
}
</script>
</BODY></HTML>
