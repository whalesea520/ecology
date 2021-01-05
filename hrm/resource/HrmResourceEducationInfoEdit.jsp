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
char separator = Util.getSeparator() ;
boolean canedit = HrmUserVarify.checkUserRight("HrmResourceEducationInfoEdit:Edit", user) ;
String paraid = Util.null2String(request.getParameter("paraid")) ;
String educationinfoid = paraid ;
String applyeducationinfoid =  Util.null2String(request.getParameter("applyeducationinfoid")) ;
if (!(applyeducationinfoid.equals(""))){
	educationinfoid = applyeducationinfoid;
	canedit = true;
}

String fromapplyflag = Util.null2String(request.getParameter("fromapplyflag")) ; //judge if from HrmCareerApplyEdit.jsp
if (fromapplyflag.equals("1")){
	canedit = false;
}

RecordSet.executeProc("HrmEducationInfo_SelectByID",educationinfoid);
RecordSet.next();

String resourceid = Util.null2String(RecordSet.getString("resourceid"));
String startdate = Util.toScreen(RecordSet.getString("startdate"),user.getLanguage());
String enddate = Util.toScreen(RecordSet.getString("enddate"),user.getLanguage());
String school = Util.toScreenToEdit(RecordSet.getString("school"),user.getLanguage());
String speciality = Util.toScreenToEdit(RecordSet.getString("speciality"),user.getLanguage());
String educationlevel = Util.null2String(RecordSet.getString("educationlevel"));
String studydesc = Util.toScreenToEdit(RecordSet.getString("studydesc"),user.getLanguage());

String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(179,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(813,user.getLanguage());
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
<FORM name=frmain action=HrmResourceEducationInfoOperation.jsp? method=post>
<%if(canedit){%>
<DIV>
<BUTTON class=btnSave accessKey=S onclick='OnSubmit()'><U>S</U>-<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%></BUTTON>
<% }
if(HrmUserVarify.checkUserRight("HrmResourceEducationInfoEdit:Delete", user)&&!(fromapplyflag.equals("1"))){
%>
<BUTTON class=btnDelete id=Delete accessKey=D onclick="onDelete()"><U>D</U>-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></BUTTON>
<%}%>

<BUTTON class=btn id=back accessKey=B onclick="window.history.back(-1)"><U>B</U>-<%=SystemEnv.getHtmlLabelName(1290,user.getLanguage())%></BUTTON>

 </DIV>
<input type="hidden" name="operation">
<%if  (!(applyeducationinfoid.equals(""))){%>
	<input type="hidden" name="applyid" value="<%=resourceid%>">
<%} else {%>
	<input type="hidden" name="resourceid" value="<%=resourceid%>">
<%}%>
<input type="hidden" name="educationinfoid" value="<%=educationinfoid%>">

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
	<tr> 
            <td><%=SystemEnv.getHtmlLabelName(818,user.getLanguage())%></td>
            <td class=Field> 
				<%if(canedit){%>
              <select class=saveHistory id=educationlevel name=educationlevel>
                <option value="0" <% if (educationlevel.equals("0")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(811,user.getLanguage())%></option>
                <option value="1" <% if (educationlevel.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(819,user.getLanguage())%></option>
				<option value="2" <% if (educationlevel.equals("2")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(764,user.getLanguage())%></option>
                <option value="3" <% if (educationlevel.equals("3")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(820,user.getLanguage())%></option>
                <option value="4" <% if (educationlevel.equals("4")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(765,user.getLanguage())%></option>
                <option value="5" <% if (educationlevel.equals("5")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(766,user.getLanguage())%></option>
                <option value="6" <% if (educationlevel.equals("6")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(767,user.getLanguage())%></option>
                <option value="7" <% if (educationlevel.equals("7")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(768,user.getLanguage())%></option>
                <option value="8" <% if (educationlevel.equals("8")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(769,user.getLanguage())%></option>
              </select>
			   <%} else {%>
                <%if (educationlevel.equals("0")) {%><%=SystemEnv.getHtmlLabelName(811,user.getLanguage())%><%}%>
                <%if (educationlevel.equals("1")) {%><%=SystemEnv.getHtmlLabelName(819,user.getLanguage())%><%}%>
				<%if (educationlevel.equals("2")) {%><%=SystemEnv.getHtmlLabelName(764,user.getLanguage())%><%}%>
                <%if (educationlevel.equals("3")) {%><%=SystemEnv.getHtmlLabelName(820,user.getLanguage())%><%}%>
                <%if (educationlevel.equals("4")) {%><%=SystemEnv.getHtmlLabelName(765,user.getLanguage())%><%}%>
                <%if (educationlevel.equals("5")) {%><%=SystemEnv.getHtmlLabelName(766,user.getLanguage())%><%}%>
                <%if (educationlevel.equals("6")) {%><%=SystemEnv.getHtmlLabelName(767,user.getLanguage())%><%}%>
                <%if (educationlevel.equals("7")) {%><%=SystemEnv.getHtmlLabelName(768,user.getLanguage())%><%}%>
                <%if (educationlevel.equals("8")) {%><%=SystemEnv.getHtmlLabelName(769,user.getLanguage())%><%}%>
			  <%}%>
            </td>
    </tr>
	<TR>
      <TD><%=SystemEnv.getHtmlLabelName(803,user.getLanguage())%></TD>
       <TD class=Field>
	   <%if(canedit){%>
        <INPUT class=saveHistory maxLength=60 size=30 name=speciality value="<%=speciality%>">
		 <%} else {%>
			 <%=speciality%>
		<%}%>
       </TD>
    </TR>

    <TR> 
      <TD><%=SystemEnv.getHtmlLabelName(1850,user.getLanguage())%></TD>
      <TD class=Field>
	   <%if(canedit){%>
        <INPUT class=saveHistory maxLength=100 size=30 name=school value="<%=school%>" onchange='checkinput("school","schoolimage")'>
		 <SPAN id=schoolimage></SPAN>
		 <%} else {%>
		<%=school%>
		<%}%>
      </TD>
    </TR>
    
   
    <TR> 
      <TD valign="top"><%=SystemEnv.getHtmlLabelName(1942,user.getLanguage())%></TD>
      <TD class=Field> 
	  <%if(canedit){%>
        <textarea class="saveHistory" style="width:90%"  name=studydesc rows="6"><%=studydesc%></textarea>
	 <%} else {%>
		<%=studydesc%>
		<%}%>
      </TD>
    </TR>
    
	</TBODY> 
  </TABLE>
</FORM>
<SCRIPT language=VBS>
/////////////////////////////////////////////////////////////////////////////////
sub onShowonShowCompanyStyle()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/fna/maintenance/CurrencyBrowser.jsp")
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
