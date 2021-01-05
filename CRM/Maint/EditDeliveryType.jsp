
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%
boolean canedit = HrmUserVarify.checkUserRight("EditDeliveryType:Edit",user);
%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
	String id = request.getParameter("id");

	RecordSet.executeProc("CRM_DeliveryType_SelectByID",id);

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
<script language=javascript >
function checkSubmit(){
    if(check_form(weaver,'name,desc,send,move,get')){
        weaver.submit();
    }
}
</script>

</HEAD>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = "";
if (canedit)
	titlename = SystemEnv.getHtmlLabelName(93,user.getLanguage())+":&nbsp;"+SystemEnv.getHtmlLabelName(16375,user.getLanguage());
else
	titlename = SystemEnv.getHtmlLabelName(367,user.getLanguage())+":&nbsp;"+SystemEnv.getHtmlLabelName(16375,user.getLanguage());

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

<FORM id=weaver action="/CRM/Maint/DeliveryTypeOperation.jsp" method=post onsubmit='return check_form(this,"name,desc,send,move,get")'>
<DIV>
<%
if(HrmUserVarify.checkUserRight("EditDeliveryType:Edit", user)){
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:checkSubmit(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%
}
if(HrmUserVarify.checkUserRight("EditDeliveryType:Delete", user)){
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:doDel(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
	<BUTTON class=btnDelete id=Delete accessKey=D style="display:none"  onclick='doDel()'><U>D</U>-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></BUTTON>
<%}
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/CRM/Maint/ListDeliveryType.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
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
         <TR class=Spacing style='height:1px'>
          <TD class=Line1 colSpan=2></TD></TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(599,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
          <TD class=Field><% if(canedit) {%><INPUT class=InputStyle maxLength=50 size=20 name="name" onchange='checkinput("name","nameimage")' value="<%=Util.toScreenToEdit(RecordSet.getString(2),user.getLanguage())%>"><SPAN id=nameimage></SPAN><%}else {%><%=Util.toScreen(RecordSet.getString(2),user.getLanguage())%><%}%></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(599,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></TD>
          <TD class=Field><% if(canedit) {%><INPUT class=InputStyle maxLength=150 size=50 name="desc" onchange='checkinput("desc","descimage")' value="<%=Util.toScreenToEdit(RecordSet.getString(3),user.getLanguage())%>"><SPAN id=descimage></SPAN><%}else {%><%=Util.toScreen(RecordSet.getString(3),user.getLanguage())%><%}%></TD>
         </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>        
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(598,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(599,user.getLanguage())%></TD>
          <TD class=Field><% if(canedit) {%><INPUT class=InputStyle maxLength=150 size=50 name="send" onchange='checkinput("send","sendimage")' value="<%=Util.toScreenToEdit(RecordSet.getString(4),user.getLanguage())%>"><SPAN id=sendimage></SPAN><%}else {%><%=Util.toScreen(RecordSet.getString(4),user.getLanguage())%><%}%></TD>
         </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>        
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(600,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(599,user.getLanguage())%></TD>
          <TD class=Field><% if(canedit) {%><INPUT class=InputStyle maxLength=150 size=50 name="move" onchange='checkinput("move","moveimage")' value="<%=Util.toScreenToEdit(RecordSet.getString(5),user.getLanguage())%>"><SPAN id=moveimage></SPAN><%}else {%><%=Util.toScreen(RecordSet.getString(5),user.getLanguage())%><%}%></TD>
         </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>        
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(601,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(599,user.getLanguage())%></TD>
          <TD class=Field><% if(canedit) {%><INPUT class=InputStyle maxLength=150 size=50 name="get" onchange='checkinput("get","getimage")' value="<%=Util.toScreenToEdit(RecordSet.getString(6),user.getLanguage())%>"><SPAN id=getimage></SPAN><%}else {%><%=Util.toScreen(RecordSet.getString(6),user.getLanguage())%><%}%></TD>
         </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>        
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
<script type="text/javascript">
function doDel(){
	if(isdel()){location.href="/CRM/Maint/DeliveryTypeOperation.jsp?method=delete&id=<%=id%>&name=<%=Util.toScreenToEdit(RecordSet.getString(2),user.getLanguage())%>"}
}
</script>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
</BODY>
</HTML>
