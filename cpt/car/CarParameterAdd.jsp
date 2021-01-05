
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</head>
<% 
if(!HrmUserVarify.checkUserRight("Car:Maintenance",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
   }
%>
<%
String imagefilename = "/images/hdHRM_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(82,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(17633,user.getLanguage());
String needfav ="1";
String needhelp ="";

%>

<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
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
			
			<TABLE class="Shadow">
			<tr>
			<td valign="top">
			
<form name=frmmain action="CarParameterOperation.jsp">
<input type="hidden" name=operation value=add>

<TABLE class=viewform>
  <COLGROUP>
  <COL width="20%">
  <COL width="80%">
  <TBODY>
  <TR class=title>
    <TH colSpan=2><%=SystemEnv.getHtmlLabelName(17635,user.getLanguage())%></TH></TR>
  <TR class=spacing>
    <TD class=line1 colSpan=2></TD></TR>
  <TR>
    <TD><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
    <TD class=Field><INPUT class=inputstyle type=text size=30 name="name" onchange='checkinput("name","nameimage")'>
    <SPAN id=nameimage><IMG src="/images/BacoError_wev8.gif" align=absMiddle></SPAN></TD>
  </TR>
  <TR><TD class=Line colspan=2></TD></TR> 
  <TR>
    <TD><%=SystemEnv.getHtmlLabelName(17637,user.getLanguage())%></TD>
    <TD class=Field><INPUT class=inputstyle type=text size=10 name="paravalue" onKeyPress="ItemNum_KeyPress()" 
    onBlur="checknumber1(this);checkinput('paravalue','paravalueimage')">
    <SPAN id=paravalueimage><IMG src="/images/BacoError_wev8.gif" align=absMiddle></SPAN></TD>
  </TR>
  <TR><TD class=Line colspan=2></TD></TR> 
  <TR>
    <TD><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></TD>
    <TD class=Field><INPUT class=inputstyle type=text size=60 name="description"></TD>
  </TR>
  <TR><TD class=Line colspan=2></TD></TR> 
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




<script language="javascript">
function onSubmit()
{
    if(check_form(document.frmmain,'name,paravalue')){
	    document.frmmain.submit();
    }
}
</script>
</BODY>
</HTML>
