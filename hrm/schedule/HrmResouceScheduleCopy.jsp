<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%

if(!HrmUserVarify.checkUserRight("HrmResourceScheduleCopy:Copy", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language=vbs>
sub onShowMould(tdname,inputename)
	
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	if NOT isempty(id) then
		document.all(tdname).innerHtml = id(1)
		document.all(inputename).value=id(0)
	end if
end sub
</script>
</head>
<%
String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(77,user.getLanguage())+"-"+SystemEnv.getHtmlLabelName(369,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(179,user.getLanguage());
String needfav ="1";
String needhelp ="";

boolean CanCopy = HrmUserVarify.checkUserRight("HrmResourceScheduleCopy:Copy", user);
String toid=Util.fromScreen(request.getParameter("id"),user.getLanguage());
String toResouce_id=Util.fromScreen(request.getParameter("Resouce_id"),user.getLanguage());
String toResouce_name=Util.toScreen(ResourceComInfo.getResourcename(toResouce_id+""),user.getLanguage());
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(CanCopy){
RCMenu += "{"+SystemEnv.getHtmlLabelName(77,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/hrm/schedule/HrmResouceScheduleList.jsp,_self} " ;
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
<FORM id=weaver name=frmmain action="HrmResouceScheduleOperation.jsp" method=post onsubmit="return check_form(this,'fromResouce_id,toResouce_id')">
<input class=inputstyle type="hidden" name="operation" value="copy">
<table class=Viewform>
  <colgroup>
  <col width="30%">
  <col width="70%">
  <tbody>
    <tr class=Title>
      <TH colSpan=2><%=SystemEnv.getHtmlLabelName(324,user.getLanguage())%></TH>
    </TR>
    <TR class=Spacing> 
      <TD class=Line1 colSpan=2></TD>
    </TR>
    <tr>
      <td><%=SystemEnv.getHtmlLabelName(348,user.getLanguage())%></td>
      <td class=field><button class=Browser onclick="onShowMould('fromResoucename','fromResouce_id')"></button>
      <span id=fromResoucename></span>
      <input class=inputstyle type="hidden" name="fromResouce_id"></td>
    </tr>
    <TR><TD class=Line colSpan=2></TD></TR>
    <tr>
      <td><%=SystemEnv.getHtmlLabelName(349,user.getLanguage())%></td>
      <td class=field><% if(toResouce_id.equals("")){%><button class=Browser onclick="onShowMould('toResoucename','toResouce_id')"></button>
      <%}%><span id=toResoucename><%=toResouce_name%></span>
      <input class=inputstyle type="hidden" name="toResouce_id" value="<%=toResouce_id%>"></td>
    </tr> 
    <TR><TD class=Line colSpan=2></TD></TR>
  </tbody>
</table>
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
 if(check_form(frmmain,'fromResouce_id,toResouce_id')){
 frmmain.submit();
 }
}
</script>
</body>
</html>