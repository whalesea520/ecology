<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<% if(!HrmUserVarify.checkUserRight("HrmResourceAdd:Add",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
   }
%>
<HTML><HEAD>
<STYLE>.SectionHeader {
	FONT-WEIGHT: bold; COLOR: white; BACKGROUND-COLOR: teal
}
</STYLE>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</HEAD>
<%
String name = "";			/*名*/
String sex = "";
/*
性别:
0:男性
1:女性
2:未知
*/
String workday = "";			/*到职日期*/
String departmentid = "";
String joblevel = "";
String jobtitle = "";
String managerid = "" ;


String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = "";

String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:OnSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(15796,user.getLanguage())+",/hrm/employee/EmployeeView.jsp,_self} " ;
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

<FORM name=resource id=resource action="/hrm/employee/EmployeeAddOperation.jsp" method=post>
   <TABLE class=ViewForm>
    <COLGROUP> 
    <COL width="50%"> 
    <COL width="50%"> 
    <TBODY> 
    <TR> 
      <TD vAlign=top> 
        <TABLE width="100%">
          <COLGROUP> <COL width=10%> <COL width=70%> <TBODY> 
          <TR class=title> 
            <TH colSpan=2 ><%=SystemEnv.getHtmlLabelName(411,user.getLanguage())%></TH>
          </TR>
          <TR class=spacing> 
            <TD class=line1 colSpan=2></TD>
          </TR>
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></TD>
            <TD class=Field> 
              <input class=inputstyle  maxLength=30 size=30 
            name="name" value="<%=name%>" onchange='checkinput("name","nameimage")'>
			<SPAN id=nameimage><%if (name.equals("")) {%><IMG src='/images/BacoError_wev8.gif' align=absMiddle><%}%></SPAN>
            </TD>
          </TR>
        <TR><TD class=Line colSpan=2></TD></TR> 
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(416,user.getLanguage())%></TD>
            <TD class=Field> 
              <select class=inputStyle id=sex 
              name=sex>
                <option value=0 <% if(sex.equals("0")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(417,user.getLanguage())%></option>
                <option value=1 <% if(sex.equals("1")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(418,user.getLanguage())%></option>
                <option value=2 <% if(sex.equals("2")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(463,user.getLanguage())%></option>
              </select>
            </TD>
          </TR>
          <TR><TD class=Line colSpan=2></TD></TR> 
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(15797,user.getLanguage())%></TD>
            <TD class=Field><BUTTON class=Calendar type="button" id=selectworkday onclick="getworkdayDate()"></BUTTON> 
              <SPAN id=workdayspan style="FONT-SIZE: x-small"><%if (workday.equals("")) {%><IMG src="/images/BacoError_wev8.gif"  align=absMiddle><%}%></SPAN> 
              <input class=inputstyle type=hidden name="workday" value="<%=workday%>">
            </TD>
          </TR>
          <TR><TD class=Line colSpan=2></TD></TR> 
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></TD>
            <TD class=Field><button class=Browser id=SelectDeparment onClick="onShowDepartment()"></button> 
              <span class=inputStyle id=departmentspan><IMG src="/images/BacoError_wev8.gif" 
            align=absMiddle></span> 
              <input class=inputstyle id=departmentid type=hidden name=departmentid>
            </TD>
          </TR>
          <TR><TD class=Line colSpan=2></TD></TR> 
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(357,user.getLanguage())%></TD>
            <TD class=Field><BUTTON class=Browser id=SelectJobTitle onclick="onShowJobtitle()"></BUTTON> 
              <SPAN id=jobtitlespan><IMG src="/images/BacoError_wev8.gif" 
            align=absMiddle></SPAN> 
              <input class=inputstyle id=jobtitle type=hidden name=jobtitle>
            </TD>
          </TR>
         <TR><TD class=Line colSpan=2></TD></TR> 
          <tr> 
            <td><%=SystemEnv.getHtmlLabelName(484,user.getLanguage())%></td>
            <td class=Field> 
              <input class=inputstyle  maxlength=3 size=5 
            name=joblevel onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("joblevel")' value="0">
            </td>
          </tr>	
          <TR><TD class=Line colSpan=2></TD></TR> 
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(2120,user.getLanguage())%></TD>
            <TD class=Field><BUTTON class=Browser id=SelectManagerID onClick="onShowManagerID()"></BUTTON> 
              <span 
            id=manageridspan><img src="/images/BacoError_wev8.gif" 
            align=absMiddle></span> 
              <INPUT class=inputStyle id=managerid 
            type=hidden name=managerid>
            </TD>
          </TR>
          <TR><TD class=Line colSpan=2></TD></TR> 
          </TBODY> 
        </TABLE>
      </TD>
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
<script language=vbs>

sub onShowDepartment()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="&resource.departmentid.value)

	if (Not IsEmpty(id)) then
	if id(0)<> 0 then

	departmentspan.innerHtml = id(1)
	resource.departmentid.value=id(0)
	else
	departmentspan.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
	resource.departmentid.value=""
	end if
	end if
end sub

sub onShowManagerID()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	manageridspan.innerHtml = "<A href='/hrm/resource/HrmResource.jsp?id="&id(0)&"'>"&id(1)&"</A>"
	resource.managerid.value=id(0)
	else 
	manageridspan.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
	resource.managerid.value=""
	end if
	end if
end sub

sub onShowJobtitle()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/jobtitles/JobTitlesBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	jobtitlespan.innerHtml = id(1)
	resource.jobtitle.value=id(0)
	else 
	jobtitlespan.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
	resource.jobtitle.value=""
	end if
	end if
end sub
</script>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
<SCRIPT language="javascript">
function OnSubmit(){
    if(check_form(document.resource,"name,workday,departmentid,managerid"))
	{	
		document.resource.submit();
	}
}
</script>
</BODY>
</HTML>