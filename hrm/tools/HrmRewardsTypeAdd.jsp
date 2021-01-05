<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%
if(!HrmUserVarify.checkUserRight("HrmRewardsTypeAdd:Add", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</head>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(808,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(HrmUserVarify.checkUserRight("HrmRewardsTypeAdd:Add", user)){
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
<FORM id=weaver name=frmMain action="RewardsTypeOperation.jsp" method=post >
<TABLE class=viewform>
  <COLGROUP>
  <COL width="20%">
  <COL width="80%">
  <TBODY>
  <TR class=title>
    <TH colSpan=2><%=SystemEnv.getHtmlLabelName(808,user.getLanguage())%></TH></TR>
  <TR class=spacing>
    <TD class=line1 colSpan=2 ></TD></TR>
	<tr> 
          <td><%=SystemEnv.getHtmlLabelName(178,user.getLanguage())%></td>
            <td class=Field> 
              <select class=inputstyle id=flag name=flag>
                <option value="0" selected><%=SystemEnv.getHtmlLabelName(809,user.getLanguage())%></option>
                <option value="1" ><%=SystemEnv.getHtmlLabelName(810,user.getLanguage())%></option>
				<option value="2" ><%=SystemEnv.getHtmlLabelName(811,user.getLanguage())%></option>
              </select>
            </td>
    </tr>
    <TR><TD class=Line colSpan=2></TD></TR> 
  <TR>
          <TD><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
          <TD class=Field><input class=inputstyle type=text size=30 name="name" onchange='checkinput("name","nameimage")'>
          <SPAN id=nameimage><IMG src="/images/BacoError_wev8.gif" align=absMiddle></SPAN></TD>
        </TR>
        <TR><TD class=Line colSpan=2></TD></TR> 
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></TD>
          <TD class=Field><input class=inputstyle type=text size=60 name="description" onchange='checkinput("description","descriptionimage")'>
          <SPAN id=descriptionimage><IMG src="/images/BacoError_wev8.gif" align=absMiddle></SPAN></TD>
        </TR>
        <TR><TD class=Line colSpan=2></TD></TR> 
		<input class=inputstyle type="hidden" name=operation value=add>
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
 if(check_form(frmMain,'name,description')){
 frmMain.submit();
 }
}
</script>
</BODY>
</HTML>