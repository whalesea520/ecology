<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="OtherInfoTypeComInfo" class="weaver.hrm.tools.OtherInfoTypeComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</head>
<%
String resourceid = Util.null2String(request.getParameter("resourceid")) ;
String infotype = Util.null2String(request.getParameter("infotype")) ;
String departmentid = Util.null2String(ResourceComInfo.getDepartmentID(resourceid)) ;

if(!HrmUserVarify.checkUserRight("HrmResourceOtherInfoAdd:Add",user,departmentid)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
   
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(87,user.getLanguage())+" : "+SystemEnv.getHtmlLabelName(365,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<DIV class=HdrProps></DIV>

<FORM id=frmMain action=HrmResourceOtherInfoOperation.jsp method=post onsubmit='return check_form(this,"infoname,seclevel")'>
  <DIV><BUTTON class=btnSave accessKey=S type=submit><U>S</U>-<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%></BUTTON></div>
  <input type=hidden name=operation value="addinfo">
  <input type=hidden name=resourceid value="<%=resourceid%>">
  <TABLE class=Form>
  <TBODY>
  <TR>
    <TH class=section align=left><%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%></TH></TR>
  <TR class=separator>
    <TD class=sep1 colSpan=4></TD></TR></TBODY></TABLE>
  <TABLE class=Form id=tblScenarioCode>
    <THEAD> <COLGROUP> <COL width="8%"> <COL width="42%"> <COL width="10%"> <COL width="40%"></THEAD> 
    <TBODY> 
    <TR> 
      <TD><%=SystemEnv.getHtmlLabelName(344,user.getLanguage())%></TD>
      <TD class=FIELD> 
        <INPUT id=infoname name=infoname maxlength="20" onchange='checkinput("infoname","infonameimage")' size="30">
        <SPAN id=infonameimage><IMG src="/images/BacoError_wev8.gif" align=absMiddle></SPAN></TD>
      <TD><%=SystemEnv.getHtmlLabelName(740,user.getLanguage())%></TD>
      <TD class=field> <BUTTON class=Calendar type="button" id=selectstartdate onclick="getstartDate()"></BUTTON> 
        <SPAN id=startdatespan ></SPAN> 
        <input type="hidden" name="startdate">
      </TD>
    </TR>
    <tr> 
      <td><%=SystemEnv.getHtmlLabelName(178,user.getLanguage())%></td>
      <td class=FIELD> 
        <select class=saveHistory id=infotype name=infotype>
          <%
	while(OtherInfoTypeComInfo.next()) {
		String typeid = Util.null2String(OtherInfoTypeComInfo.getTypeid()) ;
	%>
          <option value=<%=typeid%> <% if(typeid.equals(infotype)) {%>selected<%}%>><%=Util.toScreen(OtherInfoTypeComInfo.getTypename(),user.getLanguage())%></option>
          <%}%>
        </select>
      </td>
      <td><%=SystemEnv.getHtmlLabelName(1323,user.getLanguage())%></td>
      <td class=field> <button class=Calendar type="button" id=selectenddate onClick="getHendDate()"></button> 
        <span id=enddatespan ></span> 
        <input type="hidden" name="enddate">
      </td>
    </tr>
    <tr> 
      <td rowspan="3" valign="top"><%=SystemEnv.getHtmlLabelName(87,user.getLanguage())%></td>
      <td class=FIELD rowspan="3"> 
        <textarea id="inforemark" name="inforemark" cols="60" rows="8"></textarea>
      </td>
      <td><%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%></td>
      <td class=field> <button class=Browser onClick="onShowDoc()"></button> <span id=docidspan></span> 
        <input type="hidden" name="docid">
      </td>
    </tr>
    <tr> 
      <td height="17"><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></td>
      <td class=field height="17"> 
        <INPUT class=saveHistory maxLength=3 size=5 
            name=seclevel onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("seclevel");checkinput("seclevel","seclevelimage")' value="10">
        <SPAN id=seclevelimage></SPAN> 
      </td>
    </tr>
    <tr> 
      <td>&nbsp;</td>
      <td><img src="/images/1_wev8.gif" align=absMiddle width="1" height="50"></td>
    </tr>
    </TBODY> 
  </TABLE>
</FORM>

<Script language=vbs>
sub onShowDoc()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/docs/DocBrowser.jsp")
	if NOT isempty(id) then
		if id(0)<> 0 then
		docidspan.innerHtml = "<A href='/docs/docs/DocDsp.jsp?id="&id(0)&"'>"&id(1)&"</A>"
		frmMain.docid.value=id(0)
		else
		docidspan.innerHtml = Empty
		frmMain.docid.value=""
		end if
	end if
end sub

</script>


</BODY>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</HTML>
