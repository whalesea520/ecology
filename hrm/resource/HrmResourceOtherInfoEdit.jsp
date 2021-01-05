<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="OtherInfoTypeComInfo" class="weaver.hrm.tools.OtherInfoTypeComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page"/>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</head>
<%
String id = Util.null2String(request.getParameter("id"));
RecordSet.executeProc("HrmResourceOtherInfo_SByID",id);
RecordSet.next();
String infoname = RecordSet.getString("infoname");
String inforemark = RecordSet.getString("inforemark");
String resourceid = Util.null2String(RecordSet.getString("resourceid"));
String startdate = Util.null2String(RecordSet.getString("startdate"));
String enddate = Util.null2String(RecordSet.getString("enddate"));
String docid = Util.null2String(RecordSet.getString("docid"));
String infotype = Util.null2String(RecordSet.getString("infotype"));
String seclevel = Util.null2String(RecordSet.getString("seclevel"));
String createrid = Util.null2String(RecordSet.getString("createid"));
String createdate = Util.null2String(RecordSet.getString("createdate"));
String lastmodid = Util.null2String(RecordSet.getString("lastmoderid"));
String lastmoddate = Util.null2String(RecordSet.getString("lastmoddate"));

String departmentid = Util.null2String(ResourceComInfo.getDepartmentID(resourceid)) ;

boolean canedit = HrmUserVarify.checkUserRight("HrmResourceOtherInfoEdit:Edit", user,departmentid) ;


String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(87,user.getLanguage())+" : "+Util.toScreen(infoname,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<DIV class=HdrProps><B><%=SystemEnv.getHtmlLabelName(125,user.getLanguage())%>:&nbsp;</B><%=createdate%>&nbsp;&nbsp; <b><%=SystemEnv.getHtmlLabelName(271,user.getLanguage())%>:&nbsp;</b><A 
href="HrmResource.jsp?id=<%=createrid%>"><%=Util.toScreen(ResourceComInfo.getResourcename(createrid),user.getLanguage())%></A>&nbsp;&nbsp;<B><%=SystemEnv.getHtmlLabelName(103,user.getLanguage())%>:&nbsp;</B><%=lastmoddate%>&nbsp;&nbsp;<B><%=SystemEnv.getHtmlLabelName(424,user.getLanguage())%>:&nbsp;</B><A 
href="HrmResource.jsp?id=<%=lastmodid%>"><%=Util.toScreen(ResourceComInfo.getResourcename(lastmodid),user.getLanguage())%></A>&nbsp;&nbsp;</DIV>

<FORM id=frmMain action=HrmResourceOtherInfoOperation.jsp method=post>
  <DIV>
  <% if(canedit) {%>
<BUTTON class=BtnSave id=saveB accessKey=S name=SaveB onclick="onEdit()"><U>S</U>-<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%></BUTTON>
<%}
if(HrmUserVarify.checkUserRight("HrmResourceOtherInfoAdd:Add",user,departmentid)) {%>
<BUTTON class=BtnNew id=AddNew accessKey=N onclick='location.href="HrmResourceOtherInfoAdd.jsp"'><U>N</U>-<%=SystemEnv.getHtmlLabelName(365,user.getLanguage())%></BUTTON>
<%}
if(HrmUserVarify.checkUserRight("HrmResourceOtherInfoEdit:Delete",user,departmentid)) {%>
<BUTTON class=BtnDelete id=Delete accessKey=D onclick="onDelete()"><U>D</U>-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></BUTTON>
<%}%>
  </div>
  <input type=hidden name=operation>
  <input type=hidden name=id value="<%=id%>">
  <input type=hidden name=resourceid value="<%=resourceid%>">
  <input type=hidden name=oldinfotype value="<%=infotype%>">
  <TABLE class=Form>
  <TBODY>
  <TR>
    <TH class=section align=left><%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%></TH></TR>
  <TR class=separator>
    <TD class=sep1 colSpan=4></TD></TR></TBODY></TABLE>
  <table class=Form id=tblScenarioCode>
    <thead> <colgroup> <col width="8%"> <col width="42%"> <col width="10%"> <col width="40%"></thead> 
    <tbody> 
    <tr> 
      <td><%=SystemEnv.getHtmlLabelName(344,user.getLanguage())%></td>
      <td class=FIELD> <% if(canedit) {%>
        <input id=infoname name=infoname maxlength="20" onChange='checkinput("infoname","infonameimage")' size="30" value="<%=Util.toScreenToEdit(infoname,user.getLanguage())%>">
        <span id=infonameimage></span>
		<%} else {%><%=Util.toScreen(infoname,user.getLanguage())%><%}%>
		</td>
      <td><%=SystemEnv.getHtmlLabelName(740,user.getLanguage())%></td><% if(canedit) {%>
      <td class=field> <button class=Calendar type="button" id=selectstartdate onClick="getstartDate()"></button> 
        <span id=startdatespan ><%=startdate%></span> 
        <input type="hidden" name="startdate" value="<%=startdate%>">
		<%} else {%><%=startdate%><%}%>
      </td>
    </tr>
    <tr> 
      <td><%=SystemEnv.getHtmlLabelName(178,user.getLanguage())%></td>
      <td class=FIELD> <% if(canedit) {%>
        <select class=saveHistory id=infotype name=infotype>
          <%
	while(OtherInfoTypeComInfo.next()) {
		String typeid = Util.null2String(OtherInfoTypeComInfo.getTypeid()) ;
	%>
          <option value=<%=typeid%> <% if(typeid.equals(infotype)) {%>selected<%}%>><%=Util.toScreen(OtherInfoTypeComInfo.getTypename(),user.getLanguage())%></option>
          <%}%>
        </select>
		<%} else {%><%=Util.toScreen(OtherInfoTypeComInfo.getTypename(infotype),user.getLanguage())%><%}%>
      </td>
      <td><%=SystemEnv.getHtmlLabelName(1323,user.getLanguage())%></td>
      <td class=field> <% if(canedit) {%>
	  <button class=Calendar type="button" id=selectenddate onClick="getHendDate()"></button> 
        <span id=enddatespan ><%=enddate%></span> 
        <input type="hidden" name="enddate" value="<%=enddate%>">
		<%} else {%><%=enddate%><%}%>
      </td>
    </tr>
    <tr> 
      <td rowspan="3" valign="top"><%=SystemEnv.getHtmlLabelName(87,user.getLanguage())%></td>
      <td class=FIELD rowspan="3"> <% if(canedit) {%>
        <textarea id="inforemark" name="inforemark" cols="60" rows="8"><%=Util.toScreenToEdit(inforemark,user.getLanguage())%></textarea>
      <%} else {%><%=Util.toScreen(inforemark,user.getLanguage())%><%}%>
	  </td>
      <td><%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%></td>
      <td class=field> 
	  <% if(canedit) {%>
	  <button class=Browser onClick="onShowDoc()"></button> <span id=docidspan><A href='/docs/docs/DocDsp.jsp?id=<%=docid%>'><%=Util.toScreen(DocComInfo.getDocname(docid),user.getLanguage())%></A></span> 
        <input type="hidden" name="docid" value="<%=docid%>">
		<%} else {%><A href='/docs/docs/DocDsp.jsp?id=<%=docid%>'><%=Util.toScreen(DocComInfo.getDocname(docid),user.getLanguage())%></A><%}%>
      </td>
    </tr>
    <tr> 
      <td height="17"><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></td>
      <td class=field height="17">  <% if(canedit) {%>
        <input class=saveHistory maxlength=3 size=5 
            name=seclevel onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("seclevel");checkinput("seclevel","seclevelimage")' value="<%=seclevel%>">
        <span id=seclevelimage></span>
		<%} else {%><%=seclevel%><%}%>
		 </td>
    </tr>
    <tr> 
      <td>&nbsp;</td>
      <td><img src="/images/1_wev8.gif" align=absMiddle width="1" height="50"></td>
    </tr>
    </tbody> 
  </table>
  <p>&nbsp;</p>
  </FORM>
<Script language=javascript>
function onEdit() {
	if(check_form(frmMain,"infoname,seclevel")) {
		frmMain.operation.value="editinfo";
		frmMain.submit();
	}
}
 function onDelete(){
		if(confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>")) {
			frmMain.operation.value="deleteinfo";
			frmMain.submit();
		}
}
</script>

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
