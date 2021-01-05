<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</head>
<%
String resourceid = Util.null2String(request.getParameter("resourceid")) ;
String departmentid = Util.null2String(ResourceComInfo.getDepartmentID(resourceid)) ;

if(!HrmUserVarify.checkUserRight("HrmResourceComponentAdd:Add",user,departmentid)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
   
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(503,user.getLanguage())+" : "+SystemEnv.getHtmlLabelName(365,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onsave(),_self} " ;
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
<FORM id=frmMain action=HrmResourceComponentOperation.jsp method=post>
  <input class=inputstyle type=hidden name=operation value="addcomponent">
  <input class=inputstyle type=hidden name=resourceid value="<%=resourceid%>">
  <TABLE class=Form>
  <TBODY>
  <TR>
    <TH class=title align=left><%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%></TH></TR>
  <TR class=spacing>
    <TD class=line1 colSpan=4></TD></TR></TBODY></TABLE>
  <TABLE class=viewForm id=tblScenarioCode>
    <THEAD> 
    <COLGROUP> 
    <COL width="8%"> 
    <COL width="42%"> 
    <COL width="10%"> 
    <COL width="40%">
    </THEAD> 
    <TBODY> 
    <TR> 
      <TD><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></TD>
      <TD class=FIELD><A href="/hrm/resource/HrmResource.jsp?id=<%=resourceid%>"><%=Util.toScreen(ResourceComInfo.getResourcename(resourceid),user.getLanguage())%></A></TD>
      <TD><%=SystemEnv.getHtmlLabelName(740,user.getLanguage())%></TD>
      <TD class=field> <BUTTON class=Calendar id=selectstartdate onclick="getstartDate()"></BUTTON> 
        <SPAN id=startdatespan ></SPAN> 
        <input class=inputstyle type="hidden" name="startdate">
      </TD>
    </TR>
    <TR><TD class=Line colSpan=6></TD></TR> 
    <tr> 
      <td><%=SystemEnv.getHtmlLabelName(533,user.getLanguage())%></td>
      <td class=FIELD><BUTTON class=Browser 
            id=SelectCurrencyID onClick="onShowComponentID()"></BUTTON> <SPAN class=inputstyle 
            id=componentidspan><img src="/images/BacoError_wev8.gif" align=absMiddle></SPAN> 
        <input class=inputstyle id=componentid type=hidden name=componentid>
		<input class=inputstyle id=componentmark type=hidden name=componentmark>
		<input class=inputstyle id=canedit type=hidden name=canedit>
		</td>
      <td><%=SystemEnv.getHtmlLabelName(1323,user.getLanguage())%></td>
      <td class=field> <button class=Calendar id=selectenddate onClick="getHendDate()"></button> 
        <span id=enddatespan ></span> 
        <input class=inputstyle type="hidden" name="enddate">
      </td>
    </tr>
    <TR><TD class=Line colSpan=6></TD></TR> 
    <tr> 
      <td><%=SystemEnv.getHtmlLabelName(1941,user.getLanguage())%></td>
      <td class=FIELD> 
        <select class=inputstyle id=selbank name=selbank>
          <option value=1><%=SystemEnv.getHtmlLabelName(185,user.getLanguage())%> 1</option>
          <option value=2><%=SystemEnv.getHtmlLabelName(185,user.getLanguage())%> 2</option>
        </select>
      </td>
      <td><%=SystemEnv.getHtmlLabelName(406,user.getLanguage())%></td>
      <td class=field> <BUTTON class=Browser 
            id=SelectCurrencyID onClick="onShowCurrencyID()"></BUTTON> <SPAN class=inputstyle 
            id=currencyidspan><img src="/images/BacoError_wev8.gif" align=absMiddle></SPAN> 
        <input class=inputstyle id=currencyid type=hidden name=currencyid>
      </td>
    </tr>
    <TR><TD class=Line colSpan=6></TD></TR> 
    <tr> 
      <td valign="top"><%=SystemEnv.getHtmlLabelName(534,user.getLanguage())%></td>
      <td class=FIELD> 
        <input class=inputstyle maxlength=10 
            name=salarysum onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("salarysum");checkinput("salarysum","salarysumimage")'>
        <span id=salarysumimage><img src="/images/BacoError_wev8.gif" align=absMiddle></span> 
      </td>
      <td>&nbsp;</td>
      <td>
      </td>
    </tr>
    <TR><TD class=Line colSpan=2></TD></TR> 
    <tr> 
      <td valign="top" colspan="4"> <B><%=SystemEnv.getHtmlLabelName(504,user.getLanguage())%></B> </td>
    </tr>
	<TR class=spacing>
    <TD class=sep1 colSpan=4></TD></TR>
    <tr> 
      <td valign="top" colspan="4"> 
        <textarea name="remark" class=inputstyle style="WIDTH: 100%" rows="8"></textarea>
      </td>
    </tr>
    <TR><TD class=Line colSpan=2></TD></TR> 
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

<Script language=vbs>
canselectcurrency = true 
sub onShowCurrencyID()
	if canselectcurrency then
		id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/fna/maintenance/CurrencyBrowser.jsp")
		if NOT isempty(id) then
			if id(0)<> "" then
			currencyidspan.innerHtml = id(1)
			frmMain.currencyid.value=id(0)
			else
			currencyidspan.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
			frmMain.currencyid.value= ""
			end if
		end if
	end if
end sub

sub onShowComponentID()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/finance/HrmSalaryComponentBrowser.jsp")
	if NOT isempty(id) then
		if id(0)<> "" then
			componentidspan.innerHtml = id(3)
			salarysumimage.innerHtml = ""
			frmMain.componentid.value=id(0)
			frmMain.componentmark.value=id(1)
			currencyidspan.innerHtml = id(4)
			frmMain.currencyid.value=id(6)
			frmMain.salarysum.value=id(5)
			frmMain.canedit.value=id(2)
			if id(2) = "0" then
				frmMain.salarysum.disabled = true
				canselectcurrency = false 
			else 
				frmMain.salarysum.disabled = false
				canselectcurrency = true 
			end if
		else
			componentidspan.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
			salarysumimage.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
			frmMain.componentid.value= ""
			frmMain.componentmark.value= ""
			frmMain.salarysum.value= ""
			frmMain.canedit.value=""
			frmMain.salarysum.disabled = false
			canselectcurrency = true 
		end if
	end if
end sub

</script>
<Script language=javascript>
function onsave() {
	if(check_form(frmMain,"componentid,currencyid,salarysum")) {
		frmMain.salarysum.disabled = false ;
		frmMain.submit();
	}
}
</script>


</BODY>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</HTML>
