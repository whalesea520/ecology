<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CustomerDescComInfo" class="weaver.crm.Maint.CustomerDescComInfo" scope="page"/>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</head>
<%
int msgid = Util.getIntValue(request.getParameter("msgid"),-1);
char separator = Util.getSeparator() ;
boolean canedit = HrmUserVarify.checkUserRight("HrmResourceWorkResumeEdit:Edit", user) ;
String paraid = Util.null2String(request.getParameter("paraid")) ;
String workresumeid = paraid ;
String applyworkresumeid =  Util.null2String(request.getParameter("applyworkresumeid")) ;
if (!(applyworkresumeid.equals(""))){
	workresumeid = applyworkresumeid;
	canedit = true;
}

String fromapplyflag = Util.null2String(request.getParameter("fromapplyflag")) ; //judge if from HrmCareerApplyEdit.jsp
if (fromapplyflag.equals("1")){
	canedit = false;
}

RecordSet.executeProc("HrmWorkResume_SelectByID",workresumeid);
RecordSet.next();

String resourceid = Util.null2String(RecordSet.getString("resourceid"));
String startdate = Util.toScreen(RecordSet.getString("startdate"),user.getLanguage());
String enddate = Util.toScreen(RecordSet.getString("enddate"),user.getLanguage());
String company = Util.toScreenToEdit(RecordSet.getString("company"),user.getLanguage());
String companystyle = Util.null2String(RecordSet.getString("companystyle"));
String jobtitle = Util.toScreenToEdit(RecordSet.getString("jobtitle"),user.getLanguage());
String workdesc = Util.toScreenToEdit(RecordSet.getString("workdesc"),user.getLanguage());
String leavereason = Util.toScreenToEdit(RecordSet.getString("leavereason"),user.getLanguage());

String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(179,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(812,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%
if(msgid!=-1){
%>
<DIV>
<font color=red size=2>
<%=SystemEnv.getErrorMsgName(msgid,user.getLanguage())%>
</font>
</DIV>
<%}%>
<FORM name=frmain action=HrmResourceWorkResumeOperation.jsp? method=post>
<%if(canedit){%>
<DIV>
<BUTTON class=btnSave accessKey=S onclick='OnSubmit()'><U>S</U>-<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%></BUTTON>
<% }
if(HrmUserVarify.checkUserRight("HrmResourceWorkResumeEdit:Delete", user)&&!(fromapplyflag.equals("1"))){
%>
<BUTTON class=btnDelete id=Delete accessKey=D onclick="onDelete()"><U>D</U>-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></BUTTON>
<%}%>

<BUTTON class=btn id=back accessKey=B onclick="window.history.back(-1)"><U>B</U>-<%=SystemEnv.getHtmlLabelName(1290,user.getLanguage())%></BUTTON>

 </DIV>
<input type="hidden" name="operation">
<%if  (!(applyworkresumeid.equals(""))){%>
	<input type="hidden" name="applyid" value="<%=resourceid%>">
<%} else {%>
	<input type="hidden" name="resourceid" value="<%=resourceid%>">
<%}%>
<input type="hidden" name="workresumeid" value="<%=workresumeid%>">

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
          <td class=Field>
			  <%if(canedit){%>
			  <button class=Calendar type="button" id=selectstartdate onClick="getstartDate()"></button> 
              <span id=startdatespan ><%=startdate%></span> 
			  <input type="hidden" name="startdate" value="<%=startdate%>">
			  <%} else {%>
			  <%=startdate%>
			  <%}%>
          </td>
          </tr>
          <tr> 
            <td><%=SystemEnv.getHtmlLabelName(743,user.getLanguage())%></td>
			<td class=Field>
            <%if(canedit){%>
			  <button class=Calendar type="button" id=selectenddate onClick="getHendDate()"></button> 
              <span id=enddatespan ><%=enddate%></span> 
			  <input type="hidden" name="enddate" value="<%=enddate%>">
			  <%} else {%>
			  <%=enddate%>
			  <%}%>
			</td>
          </tr>
		<TR> 
      <TD><%=SystemEnv.getHtmlLabelName(357,user.getLanguage())%></TD>
      <TD class=Field>
	   <%if(canedit){%>
        <INPUT class=saveHistory maxLength=30 size=30 name=jobtitle value="<%=jobtitle%>">
		 <%} else {%>
		<%=jobtitle%>
		<%}%>
      </TD>
    </TR>
	 <tr> 
      <td><%=SystemEnv.getHtmlLabelName(1975,user.getLanguage())%></td>
       <TD class=Field>
	   <%if(canedit){%>
	   <BUTTON class=Browser id=selectcompanystyle onClick="onShowCompanyStyle()"></BUTTON> <SPAN class=saveHistory             id=companystylespan><%=Util.toScreen(CustomerDescComInfo.getCustomerDescname(companystyle),user.getLanguage())%></SPAN> 
       <INPUT class=saveHistory id=companystyle type=hidden name=companystyle value="<%=companystyle%>">
		 <%} else {%>
			  <%=Util.toScreen(CustomerDescComInfo.getCustomerDescname(companystyle),user.getLanguage())%>
		<%}%>
       </TD>
    </tr>

    <TR> 
      <TD><%=SystemEnv.getHtmlLabelName(1976,user.getLanguage())%></TD>
      <TD class=Field>
	   <%if(canedit){%>
        <INPUT class=saveHistory maxLength=100 size=30 name=company value="<%=company%>">
		 <%} else {%>
		<%=company%>
		<%}%>
      </TD>
    </TR>
    
    <TR> 
      <TD valign="top"><%=SystemEnv.getHtmlLabelName(1977,user.getLanguage())%></TD>
      <TD class=Field> 
	  <%if(canedit){%>
        <textarea class="saveHistory" style="width:90%"  name=workdesc rows="6"><%=workdesc%></textarea>
	 <%} else {%>
		<%=workdesc%>
		<%}%>
      </TD>
    </TR>
     <TR> 
      <TD valign="top"><%=SystemEnv.getHtmlLabelName(1978,user.getLanguage())%></TD>
      <TD class=Field> 
	   <%if(canedit){%>
        <textarea class="saveHistory" style="width:90%"  name=leavereason rows="6"><%=leavereason%></textarea>
		<%} else {%>
		<%=leavereason%>
		<%}%>
      </TD>
    </TR>
    </TBODY> 
  </TABLE>
</FORM>
<SCRIPT language=VBS>
sub onShowCompanyStyle()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/Maint/CustomerDescBrowser.jsp")
	if NOT isempty(id) then
		if id(0)<> "" then
		companystylespan.innerHtml = id(1)
		frmain.companystyle.value=id(0)
		else
		companystylespan.innerHtml = ""
		frmain.companystyle.value= ""
		end if
	end if
end sub


</SCRIPT>

<SCRIPT language="javascript">
function OnSubmit(){
    if(check_form(document.frmain,"company"))
	{	
		document.frmain.operation.value="edit";
		document.frmain.submit();
	}
}
function onDelete(){
		if(confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>")) {
			document.frmain.operation.value="delete";
			document.frmain.submit();
		}
}
</script>

</BODY>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</HTML>
