<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<% if(!HrmUserVarify.checkUserRight("ShowColumn:Operate",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
   }
%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</head>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(6002,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/hrm/tools/HrmValidate.jsp,_self} " ;
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
<FORM id=weaver name=frmMain action="HrmValidateOperation.jsp" method=post >
<input class=inputstyle type=hidden name=method value="add">
<%
int id=0;
RecordSet.executeSql("select max(id) from hrmlistvalidate");
if(RecordSet.next())
    id=RecordSet.getInt(1)+1;
%>
<TABLE class=Viewform>
  <COLGROUP>
  <COL width="20%">
  <COL width="80%">
  <TBODY>
  <TR class=Title>
    <TH colSpan=2><%=SystemEnv.getHtmlLabelName(361,user.getLanguage())%></TH></TR>
  <TR class=Spacing>
    <TD class=Line1 colSpan=2 ></TD></TR>
  <TR>
    <TD>id</TD>
    <TD class=field><%=id%><input class=inputstyle type=hidden name=id value="<%=id%>"></TD>
  </TR>
  <TR><TD class=Line colSpan=2></TD></TR> 
  <TR>
    <TD><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
    <TD class=field><input class=inputstyle type=text name=name size="30" maxlength="30" onchange="checkinput('name','namespan')">
    <span id="namespan"><IMG src="/images/BacoError_wev8.gif" align=absMiddle></span>
    </TD>
  </TR>
  <TR><TD class=Line colSpan=2></TD></TR> 
  <TR>
    <TD><%=SystemEnv.getHtmlLabelName(15603,user.getLanguage())%></TD>
    <TD class=field><input class=inputstyle type=checkbox name=validate value="1" checked >
    </TD>
  </TR>
  <TR><TD class=Line colSpan=2></TD></TR> 
 </TBODY>
 </TABLE>
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
 if(check_form(frmMain,'name')){
 frmMain.submit();
 }
}
</script>

 </form>
</BODY></HTML>
