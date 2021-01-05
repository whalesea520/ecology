
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>

<% if(!HrmUserVarify.checkUserRight("CrmSalesChance:Maintenance",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
   }
%>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(15244,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>

<SCRIPT language="JavaScript">

var dialog = parent.getDialog(window); 
var parentWin = parent.getParentWindow(window);
if("<%=isclose%>"=="1"){
	parentWin.location = "ListCustomerDescInner.jsp";
	parentWin.closeDialog();
}

function doSave() {
	if (check_form(document.weaver, "time,spannum"))
		document.weaver.submit();
}
</SCRIPT>

<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(),_top} " ;
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
		<TABLE class=Shadow>
		<tr>
		<td valign="top">

	<FORM name="weaver" action="/CRM/sellchance/CRMTimespanOperation.jsp" method=post>
	 <input type="hidden" name="method" value="add">
	<TABLE class=ViewForm>
	
	<TBODY>
	<TR>

	<TD vAlign=top>
	
	<TABLE class=ViewForm>
	<COLGROUP>
	<COL width="30%">
	<COL width="70%">
	<TBODY>
	<TR class=Title>
	<TH><%=SystemEnv.getHtmlLabelName(61,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(87,user.getLanguage())%></TH>
	</TR>
	 <TR class=Spacing style='height:1px'>
	<TD class=Line1 colSpan=2></TD></TR>
	<TR>
	<TD><%=SystemEnv.getHtmlLabelName(15237,user.getLanguage())%></TD>
	<TD class=Field><INPUT text class=InputStyle maxLength=50 size=20 name="time" onBlur='checkcount1(this);checkinput("time","timeimage")' onKeyPress="ItemCount_KeyPress()" ><SPAN id=timeimage><IMG src="/images/BacoError_wev8.gif" align=absMiddle></SPAN></TD>
	</TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
	<TR>
	<TD><%=SystemEnv.getHtmlLabelName(15238,user.getLanguage())%></TD>
	<TD class=Field><INPUT text class=InputStyle maxLength=50 size=20 name="spannum" onBlur='checkcount1(this);checkinput("spannum","spannumimage")' onKeyPress="ItemCount_KeyPress()" ><SPAN id=spannumimage><IMG src="/images/BacoError_wev8.gif" align=absMiddle></SPAN></TD>
	</TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>      

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


</BODY>
</HTML>