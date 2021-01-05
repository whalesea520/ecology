<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<% if(!HrmUserVarify.checkUserRight("HrmResourceAbsense1Edit:Edit",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
   }
%>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</head>
<%
int msgid = Util.getIntValue(request.getParameter("msgid"),-1);
char separator = Util.getSeparator() ;

String paraid = Util.null2String(request.getParameter("paraid")) ;
String absense1id = paraid ;

RecordSet.executeProc("HrmAbsense1_SelectByID",absense1id);
RecordSet.next();

String resourceid = Util.null2String(RecordSet.getString("resourceid"));
String datefrom = Util.toScreen(RecordSet.getString("startdate"),user.getLanguage());
String dateto = Util.toScreen(RecordSet.getString("enddate"),user.getLanguage());
//与中文字串比较,用fromScreen2
String absensetype = Util.fromScreen2(RecordSet.getString("workflowname"),user.getLanguage());
String absenseday = Util.toScreenToEdit(RecordSet.getString("absenseday"),user.getLanguage());

String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(179,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(1505,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:OnSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
if(HrmUserVarify.checkUserRight("HrmResourceAbsense1Edit:Delete", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:onReturn(),_self} " ;
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
<%
if(msgid!=-1){
%>
<DIV>
<font color=red size=2>
<%=SystemEnv.getErrorMsgName(msgid,user.getLanguage())%>
</font>
</DIV>
<%}%>
<FORM name=frmain action=HrmResourceAbsense1Operation.jsp? method=post>
<input class=inputstyle type="hidden" name="operation">
<input class=inputstyle type="hidden" name="resourceid" value="<%=resourceid%>">
<input class=inputstyle type="hidden" name="absense1id" value="<%=absense1id%>">

  <table class=VIEWForm>
    <colgroup> <col width="15%"> <col width="85%"><tbody> 
    <tr class=TITLE> 
      <th colspan=5><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%> <a href="HrmResource.jsp?id=<%=resourceid%>"><%=Util.toScreen(ResourceComInfo.getResourcename(resourceid),user.getLanguage())%></a></th>
    </tr>
    <tr class=SPACING> 
      <td class=LINE1 colspan=2></td>
    </tr>
    <tr> 
      <td><%=SystemEnv.getHtmlLabelName(742,user.getLanguage())%></td>
      <td class=Field><button class=Calendar type="button" id=selectdatefrom onClick="getDateFrom()"></button> 
        <span id=datefromspan ><%=datefrom%></span> 
        <input class=inputstyle type="hidden" name="datefrom" value="<%=datefrom%>">
      </td>
    </tr>
    <TR><TD class=Line colSpan=2></TD></TR> 
    <tr> 
      <td><%=SystemEnv.getHtmlLabelName(743,user.getLanguage())%></td>
      <td class=Field><button class=Calendar id=selectdateto onClick="getDateTo()"></button> 
        <span id=datetospan ><%=dateto%></span> 
        <input class=inputstyle type="hidden" name="dateto" value="<%=dateto%>">
      </td>
    </tr>
    <TR><TD class=Line colSpan=2></TD></TR> 
	<tr> 
            <td><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></td>
            <td class=Field> 
              <select class=inputStyle id=absensetype name=absensetype>
                <option value="<%=SystemEnv.getHtmlLabelName(1919,user.getLanguage())%>" <% if(absensetype.equals(SystemEnv.getHtmlLabelName(1919,user.getLanguage()))) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(1919,user.getLanguage())%></option>
                <option value="<%=SystemEnv.getHtmlLabelName(1920,user.getLanguage())%>" <% if(absensetype.equals(SystemEnv.getHtmlLabelName(1920,user.getLanguage()))) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(1920,user.getLanguage())%></option>
                <option value="<%=SystemEnv.getHtmlLabelName(1921,user.getLanguage())%>" <% if(absensetype.equals(SystemEnv.getHtmlLabelName(1921,user.getLanguage()))) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(1921,user.getLanguage())%></option>
                <option value="<%=SystemEnv.getHtmlLabelName(1922,user.getLanguage())%>" <% if(absensetype.equals(SystemEnv.getHtmlLabelName(1922,user.getLanguage()))) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(1922,user.getLanguage())%></option>
                <option value="<%=SystemEnv.getHtmlLabelName(1923,user.getLanguage())%>" <% if(absensetype.equals(SystemEnv.getHtmlLabelName(1923,user.getLanguage()))) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(1923,user.getLanguage())%></option>
                <option value="<%=SystemEnv.getHtmlLabelName(1924,user.getLanguage())%>" <% if(absensetype.equals(SystemEnv.getHtmlLabelName(1924,user.getLanguage()))) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(1924,user.getLanguage())%></option>
                <option value="<%=SystemEnv.getHtmlLabelName(811,user.getLanguage())%>" <% if(absensetype.equals(SystemEnv.getHtmlLabelName(811,user.getLanguage()))) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(811,user.getLanguage())%></option>
              </select>
            </td>
    <tr> 
      <td><%=SystemEnv.getHtmlLabelName(496,user.getLanguage())%></td>
      <td class=Field> 
        <input class=inputstyle  maxlength=13 size=5 
            name=absenseday onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("absenseday")' value="<%=absenseday%>">
      </td>
    </tr>
    <TR><TD class=Line colSpan=2></TD></TR> 
    </tbody> 
  </table>
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
<SCRIPT language="javascript">
function OnSubmit(){
	document.frmain.operation.value="edit";
	document.frmain.submit();
}
function onDelete(){
	if(confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>")) {
        document.frmain.operation.value="delete";
        document.frmain.submit();
		}
}
function onReturn(){
   window.history.back(-1);
}
</script>

</BODY>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</HTML>
