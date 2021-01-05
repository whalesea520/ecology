<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</head>
<%
int msgid = Util.getIntValue(request.getParameter("msgid"),-1);
String resourceid = Util.null2String(request.getParameter("resourceid")) ;

 if(!HrmUserVarify.checkUserRight("HrmResourceAbsense1Add:Add",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
   }


String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(179,user.getLanguage())+" : "+SystemEnv.getHtmlLabelName(1505,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:OnSubmit(),_self} " ;
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
<FORM name=frmain action="HrmResourceAbsense1Operation.jsp?" method=post>
 
<input class=inputstyle type="hidden" name="resourceid" value="<%=resourceid%>">
<input class=inputstyle type="hidden" name="operation" value="add">

  <TABLE class=viewForm>
    <COLGROUP> <COL width="15%"> <COL width="85%"><TBODY> 
    <TR class=title> 
      <TH colSpan=5><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%> <a href="HrmResource.jsp?id=<%=resourceid%>"><%=Util.toScreen(ResourceComInfo.getResourcename(resourceid),user.getLanguage())%></a></TH>
    </TR>
    <TR class=spacing> 
      <TD class=line1 colSpan=2></TD>
    </TR>
    <TR><TD class=Line colSpan=2></TD></TR> 
    <tr> 
      <td><%=SystemEnv.getHtmlLabelName(742,user.getLanguage())%></td>
      <td class=Field><button class=Calendar id=selectdatefrom onClick="getDateFrom()"></button> 
        <span id=datefromspan ></span> 
        <input class=inputstyle type="hidden" name="datefrom">
      </td>
    </tr>
    <TR><TD class=Line colSpan=2></TD></TR> 
    <tr> 
      <td><%=SystemEnv.getHtmlLabelName(743,user.getLanguage())%></td>
      <td class=Field><button class=Calendar id=selectdateto onClick="getDateTo()"></button> 
        <span id=datetospan ></span> 
        <input class=inputstyle type="hidden" name="dateto">
      </td>
    </tr>
    <TR><TD class=Line colSpan=2></TD></TR> 
	<tr> 
            <td><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></td>
            <td class=Field> 
              <select class=inputstyle  id=absensetype name=absensetype>
                <option value="<%=SystemEnv.getHtmlLabelName(1919,user.getLanguage())%>" selected><%=SystemEnv.getHtmlLabelName(1919,user.getLanguage())%></option>
                <option value="<%=SystemEnv.getHtmlLabelName(1920,user.getLanguage())%>"><%=SystemEnv.getHtmlLabelName(1920,user.getLanguage())%></option>
                <option value="<%=SystemEnv.getHtmlLabelName(1921,user.getLanguage())%>"><%=SystemEnv.getHtmlLabelName(1921,user.getLanguage())%></option>
                <option value="<%=SystemEnv.getHtmlLabelName(1922,user.getLanguage())%>"><%=SystemEnv.getHtmlLabelName(1922,user.getLanguage())%></option>
				<option value="<%=SystemEnv.getHtmlLabelName(1923,user.getLanguage())%>"><%=SystemEnv.getHtmlLabelName(1923,user.getLanguage())%></option>
				<option value="<%=SystemEnv.getHtmlLabelName(1924,user.getLanguage())%>"><%=SystemEnv.getHtmlLabelName(1924,user.getLanguage())%></option>
				<option value="<%=SystemEnv.getHtmlLabelName(811,user.getLanguage())%>"><%=SystemEnv.getHtmlLabelName(811,user.getLanguage())%></option>
              </select>
            </td>
          </tr>
          <TR><TD class=Line colSpan=2></TD></TR> 
    <tr> 
      <td><%=SystemEnv.getHtmlLabelName(496,user.getLanguage())%></td>
      <td class=Field> 
        <input class=inputstyle  maxlength=13 size=5 
            name=absenseday onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("absenseday")' value="0">
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

<SCRIPT language=VBS>
/////////////////////////////////////////////////////////////////////////////////
sub onShowDepartment()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="&frmain.departmentid.value)
	issame = false 
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	if id(0) = frmain.departmentid.value then
		issame = true 
	end if
	departmentspan.innerHtml = id(1)
	frmain.departmentid.value=id(0)
	else
	departmentspan.innerHtml = ""
	frmain.departmentid.value=""
	end if
	end if
end sub

sub onShowJobtitle()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/jobtitles/JobTitlesBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	jobtitlespan.innerHtml = id(1)
	frmain.jobtitle.value=id(0)
	else 
	jobtitlespan.innerHtml = ""
	frmain.jobtitle.value=""
	end if
	end if
end sub

</SCRIPT>

<SCRIPT language="javascript">
function OnSubmit(){
		document.frmain.submit();
}
</script>

</BODY>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</HTML>
