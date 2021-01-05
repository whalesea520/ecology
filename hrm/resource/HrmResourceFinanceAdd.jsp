<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<% //if(!HrmUserVarify.checkUserRight("HrmResourceAdd:Add",user)) {
if(!HrmUserVarify.checkUserRight("'HrmResourceWelfareAdd:Add",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
   }
%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<HTML><HEAD>
<STYLE>.SectionHeader {
	FONT-WEIGHT: bold; COLOR: white; BACKGROUND-COLOR: teal
}
</STYLE>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</HEAD>
<%
String id = request.getParameter("id");

int msgid = Util.getIntValue(request.getParameter("msgid"),-1);

boolean hasFF = true;
RecordSet.executeProc("Base_FreeField_Select","hr");
if(RecordSet.getCounts()<=0)
	hasFF = false;
else
	RecordSet.first();
	
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(82,user.getLanguage())+": "+ SystemEnv.getHtmlLabelName(179,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%
/*登录名冲突*/
if(msgid!=-1){
%>
<DIV>
<font color=red size=2>
<%=SystemEnv.getErrorMsgName(msgid,user.getLanguage())%>
</font>
</DIV>
<%}%>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
<td height="0" colspan="3"></td>
</tr>
<tr>
<td ></td>
<td valign="top">
<TABLE class=Shadow>
<tr>
<td valign="top">

<FORM name=resource id=resource action="HrmResourceOperation.jsp" method=post enctype="multipart/form-data">
	
	<input type=hidden name=operation value="addresourcefinanceinfo">
        <input type=hidden name=id value="<%=id%>"> 
  <TABLE class=viewForm>
    <COLGROUP> 
    <COL width="49%"> 
    <COL width=10> 
    <COL width="49%"> 
    <TBODY> 
    <TR> 
      <TD vAlign=top>    
    <TR> 
      <TD vAlign=top> 
        <TABLE width="100%">
          <COLGROUP>
          <COL width=30%> 
          <COL width=70%> 
          <TBODY> 
          <TR class=title> 
            <TH colSpan=2><%=SystemEnv.getHtmlLabelName(15805,user.getLanguage())%></TH>
          </TR>
          <TR class=spacing style="height:2px"> 
            <TD class=line1 colSpan=2></TD>
          </TR>
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(15812,user.getLanguage())%></TD>
            <TD class=Field>

              <input class="wuiBrowser" id=bankid1 type=hidden name=bankid1
			  _url="/systeminfo/BrowserMain.jsp?url=/hrm/finance/bank/BankBrowser.jsp">
            </TD>
          </TR>
          <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(16084,user.getLanguage())%></TD>
            <TD class=Field> 
              <INPUT class=inputstyle maxLength=34 size=30 
            name=accountid1>
            </TD>
          </TR>
          <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
          <tr> 
            <td><%=SystemEnv.getHtmlLabelName(1939,user.getLanguage())%></td>
            <td class=Field> 
              <input class=inputstyle maxlength=60 size=30 
            name=accumfundaccount>
            </td>
          </tr>
          <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
          </TBODY> 
        </TABLE>
      </TD>      
    </TR>
    </TBODY> 
  </table>
  </FORM>
</td>
</tr>
</TABLE>
</td>
<td></td>
</tr>
<tr>
<td height="0" colspan="3"></td>
</tr>
</table>
<script language=vbs>

sub onShowBank(spanname,inputname)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/finance/BankBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	spanname.innerHtml = id(1)
	inputname.value=id(0)
	else 
	spanname.innerHtml = ""
	inputname.value=""
	end if
	end if
end sub

</script> 

<script language=javascript>
function doSave() {
		document.resource.submit() ;	
}
</script>

</BODY>
</HTML>
