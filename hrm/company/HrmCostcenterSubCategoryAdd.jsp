<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%
if(!HrmUserVarify.checkUserRight("HrmCostCenterSubCategoryAdd:Add", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</head>
<%
int ccmaincategoryid = Util.getIntValue(request.getParameter("id"),0);

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(6084,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(365,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(HrmUserVarify.checkUserRight("HrmCostCenterSubCategoryAdd:Add", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
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
<TABLE class=Shadow>
<tr>
<td valign="top">

<FORM id=weaver name=frmMain action="CcSubOperation.jsp" method=post >
<TABLE class=viewform>
  <COLGROUP>
  <COL width="20%">
  <COL width="80%">
  <TBODY>
  <TR class=title>
    <TH colSpan=2><%=SystemEnv.getHtmlLabelName(6084,user.getLanguage())%></TH></TR>
  <TR class=spacing>
    <TD class=line1 colSpan=2 ></TD></TR>
  <TR>
          <TD><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
          <TD class=Field><input class=inputstyle type=text size=30 name="ccsubcategoryname" onchange='checkinput("ccsubcategoryname","ccsubcategorynameimage")'>
          <SPAN id=ccsubcategorynameimage><IMG src="/images/BacoError_wev8.gif" align=absMiddle></SPAN></TD>
        </TR>
        <TR><TD class=Line colSpan=2></TD></TR> 
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></TD>
          <TD class=Field><input class=inputstyle type=text size=60 name="ccsubcategorydesc" onchange='checkinput("ccsubcategorydesc","ccsubcategorydescimage")'>
          <SPAN id=ccsubcategorydescimage><IMG src="/images/BacoError_wev8.gif" align=absMiddle></SPAN></TD>
        </TR>
        <input class=inputstyle type="hidden" name=ccmaincategoryid value="<%=ccmaincategoryid%>">
        <input class=inputstyle type="hidden" name=operation value=add>
        <TR><TD class=Line colSpan=2></TD></TR> 
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
<script language=javascript>  
function submitData() {
if(check_form(frmMain,'ccsubcategoryname,ccsubcategorydesc')){
 frmMain.submit();
 }
}
</script>
</BODY>
</HTML>