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
boolean canedit = HrmUserVarify.checkUserRight("HrmResourceLanguageAbilityEdit:Edit", user) ;
String paraid = Util.null2String(request.getParameter("paraid")) ;
String languageabilityid = paraid ;

String applylanguageabilityid =  Util.null2String(request.getParameter("applylanguageabilityid")) ;
if (!(applylanguageabilityid.equals(""))){
	languageabilityid = applylanguageabilityid;
	canedit = true;
}

String fromapplyflag = Util.null2String(request.getParameter("fromapplyflag")) ; //judge if from HrmCareerApplyEdit.jsp
if (fromapplyflag.equals("1")){
	canedit = false;
}

RecordSet.executeProc("HrmLanguageAbility_SelectByID",languageabilityid);
RecordSet.next();

String resourceid = Util.null2String(RecordSet.getString("resourceid"));
String language = Util.toScreen(RecordSet.getString("language"),user.getLanguage());
String level = Util.toScreen(RecordSet.getString("level_n"),user.getLanguage());
String memo = Util.toScreenToEdit(RecordSet.getString("memo"),user.getLanguage());

String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(179,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(815,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(canedit){
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:OnSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(HrmUserVarify.checkUserRight("HrmResourceLanguageAbilityEdit:Delete", user)&&!(fromapplyflag.equals("1"))){
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:submitData(),_self} " ;
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
<FORM name=frmain action=HrmResourceLanguageAbilityOperation.jsp? method=post>
<input class=inputstyle type="hidden" name="operation">
<%if  (!(applylanguageabilityid.equals(""))){%>
	<input class=inputstyle type="hidden" name="applyid" value="<%=resourceid%>">
<%} else {%>
	<input class=inputstyle type="hidden" name="resourceid" value="<%=resourceid%>">
<%}%>
<input class=inputstyle type="hidden" name="languageabilityid" value="<%=languageabilityid%>">

  <TABLE class=viewForm>
    <COLGROUP> 
    <COL width="15%"> 
    <COL width="85%">
    <TBODY> 
  <TR class=title> 
    <TH colSpan=5><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%> <a href="HrmResource.jsp?id=<%=resourceid%>"><%=Util.toScreen(ResourceComInfo.getResourcename(resourceid),user.getLanguage())%></a></TH>
  </TR>
    <TR class=spacing> 
      <TD class=line1 colSpan=2></TD>
    </TR>
<TR> 
      <TD><%=SystemEnv.getHtmlLabelName(1954,user.getLanguage())%></TD>
      <TD class=Field>
	   <%if(canedit){%>
        <INPUT class=inputstyle maxLength=30 size=15 name=language value="<%=language%>" onchange='checkinput("language","languageimage")'> <SPAN id=languageimage></SPAN>
		 <%} else {%>
		<%=language%>
		<%}%>
      </TD>
    </TR>
   <TR><TD class=Line colSpan=2></TD></TR> 
		<TR> 
            <td><%=SystemEnv.getHtmlLabelName(139,user.getLanguage())%></td>
            <td class=Field> 
				<%if(canedit){%>
              <select class=inputstyle id=level name=level>
                <option value="0" <% if (level.equals("0")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(154,user.getLanguage())%></option>
                <option value="1" <% if (level.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(821,user.getLanguage())%></option>
				<option value="2" <% if (level.equals("2")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(822,user.getLanguage())%></option>
                <option value="3" <% if (level.equals("3")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(823,user.getLanguage())%></option>
               
              </select>
			   <%} else {%>
                <%if (level.equals("0")) {%><%=SystemEnv.getHtmlLabelName(154,user.getLanguage())%><%}%>
                <%if (level.equals("1")) {%><%=SystemEnv.getHtmlLabelName(821,user.getLanguage())%><%}%>
				<%if (level.equals("2")) {%><%=SystemEnv.getHtmlLabelName(822,user.getLanguage())%><%}%>
                <%if (level.equals("3")) {%><%=SystemEnv.getHtmlLabelName(823,user.getLanguage())%><%}%>
              <%}%>
            </td>
    </tr>
<TR><TD class=Line colSpan=2></TD></TR> 
    <TR> 
      <TD valign="top"><%=SystemEnv.getHtmlLabelName(454,user.getLanguage())%></TD>
      <TD class=Field> 
	  <%if(canedit){%>
        <textarea class=inputStyle style="width:90%"  name=memo rows="6"><%=memo%></textarea>
	 <%} else {%>
		<%=memo%>
		<%}%>
      </TD>
    </TR>
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
<script language=javascript>  
function submitData() {
  window.history.back(-1)'
}

function OnSubmit(){
    if(check_form(document.frmain,"language"))
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
</HTML>