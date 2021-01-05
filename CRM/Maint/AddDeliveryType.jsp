
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<% if(!HrmUserVarify.checkUserRight("AddDeliveryType:Add",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
   }
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
String titlename = SystemEnv.getHtmlLabelName(82,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(597,user.getLanguage())+SystemEnv.getHtmlLabelName(63,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:checkSubmit(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/CRM/Maint/ListDeliveryType.jsp,_self} " ;
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
<FORM id=weaver action="/CRM/Maint/DeliveryTypeOperation.jsp" method=post onsubmit='return check_form(this,"name,desc,send,move,get")'>

  <input type="hidden" name="method" value="add">
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
          <TD><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=50 size=20 name="name" onchange='checkinput("name","nameimage")'><SPAN id=nameimage><IMG src="/images/BacoError_wev8.gif" align=absMiddle></SPAN></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=150 size=50 name="desc" onchange='checkinput("desc","descimage")'><SPAN id=descimage><IMG src="/images/BacoError_wev8.gif" align=absMiddle></SPAN></TD>
         </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>        
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(598,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(599,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=150 size=50 name="send" onchange='checkinput("send","sendimage")'><SPAN id=sendimage><IMG src="/images/BacoError_wev8.gif" align=absMiddle></SPAN></TD>
         </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>        
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(600,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(599,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=150 size=50 name="move" onchange='checkinput("move","moveimage")'><SPAN id=moveimage><IMG src="/images/BacoError_wev8.gif" align=absMiddle></SPAN></TD>
         </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>        
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(601,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(599,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=150 size=50 name="get" onchange='checkinput("get","getimage")'><SPAN id=getimage><IMG src="/images/BacoError_wev8.gif" align=absMiddle></SPAN></TD>
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
</BODY>
</HTML>
