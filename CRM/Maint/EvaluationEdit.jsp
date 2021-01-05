
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<% 
boolean canedit = HrmUserVarify.checkUserRight("CRM_EvaluationEdit:Edit",user);
%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
	String id = request.getParameter("id");

	RecordSet.executeProc("CRM_Evaluation_SelectById",id);

	if(RecordSet.getFlag()!=1)
	{
		response.sendRedirect("/CRM/DBError.jsp?type=FindData");
		return;
	}
	if(RecordSet.getCounts()<=0)
	{
		response.sendRedirect("/CRM/DBError.jsp?type=FindData");
		return;
	}
	RecordSet.first();
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(6070,user.getLanguage());
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

<FORM id=weaver action="/CRM/Maint/EvaluationOperation.jsp" method=post onsubmit='return check_form(this,"name,proportion")'>
<DIV>
<%
if(HrmUserVarify.checkUserRight("CRM_EvaluationEdit:Edit", user)){
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:weaver.mysave.click(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
	<BUTTON class=btnSave accessKey=S id=mysave  type=submit><U>S</U>-<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%></BUTTON>
<%
}
if(HrmUserVarify.checkUserRight("CRM_EvaluationDelete:Delete", user)){
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:weaver.Delete.click(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
	<BUTTON class=btnDelete id=Delete accessKey=D onclick='if(isdel()){location.href="/CRM/Maint/EvaluationOperation.jsp?method=delete&id=<%=id%>"}'><U>D</U>-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></BUTTON>
<%}
%>
</DIV>
<input type="hidden" name="method" value="edit">
<input type="hidden" name="id" value="<%=id%>">
<TABLE class=ViewForm>
  <COLGROUP>
  <COL width="100%">
  <TBODY>
  <TR>
    <TD vAlign=top>
      <TABLE class=ViewForm>
      <COLGROUP>
  	<COL width="20%">
  	<COL width="80%">
        <TBODY>
        <TR class=Title>
            <TH><%=SystemEnv.getHtmlLabelName(61,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(87,user.getLanguage())%></TH>
          </TR>
        <TR class=Spacing>
          <TD class=Line1 colSpan=2></TD></TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
          <TD class=Field><% if(canedit) {%><INPUT class=InputStyle maxLength=50 size=20 name="name" onchange='checkinput("name","nameimage")' value="<%=Util.toScreenToEdit(RecordSet.getString("name"),user.getLanguage())%>"><SPAN id=nameimage></SPAN><%}else {%><%=Util.toScreen(RecordSet.getString("name"),user.getLanguage())%><%}%></TD>
        </TR><tr><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(6071,user.getLanguage())%></TD>
          <TD class=Field><% if(canedit) {%><INPUT class=InputStyle maxLength=3 size=10 name="proportion" onchange='checkinput("proportion","proportionimage")' value="<%=Util.toScreenToEdit(RecordSet.getString(3),user.getLanguage())%>"  onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("proportion")'>%<SPAN id=proportionimage></SPAN><%}else {%><%=Util.toScreen(RecordSet.getString(3),user.getLanguage())%><%}%></TD>
         </TR><tr><td class=Line colspan=2></td></tr>        
        </TBODY></TABLE></TD>
    </TR></TBODY></TABLE>
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
</BODY>
</HTML>
