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
/*
if((!HrmUserVarify.checkUserRight("HrmResourceWorkResumeInAdd:Add",user))&&applyid.equals("")) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
*/

String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(179,user.getLanguage())+" : "+SystemEnv.getHtmlLabelName(1503,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<DIV class=HdrProps></DIV>
<%
if(msgid!=-1){
%>
<DIV>
<font color=red size=2>
<%=SystemEnv.getErrorMsgName(msgid,user.getLanguage())%>
</font>
</DIV>
<%}%>
<FORM name=frmain action="HrmResourceWorkResumeInOperation.jsp?" method=post>
  <DIV><BUTTON class=btnSave accessKey=S onclick='OnSubmit()'><U>S</U>-<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%></BUTTON> </DIV>

<input type="hidden" name="resourceid" value="<%=resourceid%>">
<input type="hidden" name="operation" value="add">

  <TABLE class=Form>
    <COLGROUP> <COL width="15%"> <COL width="85%"><TBODY> 
    <TR class=Section> 
      <TH colSpan=5><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%> <a href="HrmResource.jsp?id=<%=resourceid%>"><%=Util.toScreen(ResourceComInfo.getResourcename(resourceid),user.getLanguage())%></a></TH>
    </TR>
    <TR class=Separator> 
      <TD class=Sep1 colSpan=2></TD>
    </TR>
    <tr> 
      <td><%=SystemEnv.getHtmlLabelName(742,user.getLanguage())%></td>
      <td class=Field><button class=Calendar type="button" id=selectdatefrom onClick="getDateFrom()"></button> 
        <span id=datefromspan ></span> 
        <input type="hidden" name="datefrom">
      </td>
    </tr>
    <tr> 
      <td><%=SystemEnv.getHtmlLabelName(743,user.getLanguage())%></td>
      <td class=Field><button class=Calendar type="button" id=selectdateto onClick="getDateTo()"></button> 
        <span id=datetospan ></span> 
        <input type="hidden" name="dateto">
      </td>
    </tr>
     <TR> 
       <TD><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></TD>
       <TD class=Field><button class=Browser id=SelectDeparment onClick="onShowDepartment()"></button> 
              <span class=saveHistory id=departmentspan></span> 
              <input id=departmentid type=hidden name=departmentid>
       </TD>
     </TR>
    <TR> 
       <TD><%=SystemEnv.getHtmlLabelName(357,user.getLanguage())%></TD>
            <TD class=Field><BUTTON class=Browser id=SelectJobTitle onclick="onShowJobtitle()"></BUTTON> 
              <SPAN id=jobtitlespan></SPAN> 
              <INPUT id=jobtitle type=hidden name=jobtitle>
            </TD>
     </TR>
    <tr> 
       <td><%=SystemEnv.getHtmlLabelName(484,user.getLanguage())%></td>
            <td class=Field> 
              <input class=saveHistory maxlength=3 size=5 
            name=joblevel onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("joblevel")' value="0">
            </td>
          </tr>
    </TBODY> 
  </TABLE>
</FORM>
<SCRIPT language=VBS>
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
