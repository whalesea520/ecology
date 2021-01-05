<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%
 if(!HrmUserVarify.checkUserRight("WorkflowReportManage:All", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	} 
%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</head>
<%
String imagefilename = "/images/hdHRMCard_wev8.gif";
String titlename =  SystemEnv.getHtmlLabelName(15527,user.getLanguage()) ;
String needfav ="1";
String needhelp ="";

String id = Util.null2String(request.getParameter("id"));
RecordSet.executeProc("Workflow_StaticReport_SByID",id);
RecordSet.next();

String name = Util.toScreen(RecordSet.getString("name"),user.getLanguage()) ;
String description = Util.toScreen(RecordSet.getString("description"),user.getLanguage());
String pagename1 = Util.toScreen(RecordSet.getString("pagename"),user.getLanguage());
String module = Util.null2String(RecordSet.getString("module"));
String reportid=Util.null2String(RecordSet.getString("reportid"));
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>


<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>

<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",StaticReportAdd.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>

<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(119,user.getLanguage())+",ReportShare.jsp?id="+reportid+",_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/workflow/report/StaticReportManage.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<FORM id=weaver name=frmMain action="StaticReportOperation.jsp" method=post>
<input type="hidden" name=operation value=reportedit>
<input type="hidden" name=id value=<%=id%>>
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

<TABLE class="viewform">
  <COLGROUP>
  <COL width="20%">
  <COL width="80%">
  <TBODY>
  <TR class="Title">
      <TH colSpan=2><%=SystemEnv.getHtmlLabelName(15436,user.getLanguage())%></TH>
    </TR>
  <TR >
    <TD class="Line1" colSpan=2 ></TD></TR>
  <TR>   
      <TD><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
      <TD class=Field>
        <INPUT type=text class=Inputstyle size=30 name="name" onchange='checkinput("name","namespan")' value="<%=name%>">
          <SPAN id=namespan></SPAN></TD>
  </TR>
   <TR >
    <TD class="Line" colSpan=2 ></TD></TR>
  <TR>   
      <TD><%=SystemEnv.getHtmlLabelName(15528,user.getLanguage())%></TD>    
      <TD class=Field>
        <INPUT type=text class=Inputstyle size=30 name="pagename" onchange='checkinput("pagename","pagenamespan")' value="<%=pagename1%>">
        <SPAN id=pagenamespan></SPAN></TD>
  </TR><TR >
    <TD class="Line" colSpan=2 ></TD></TR>
  <TR>   
      <TD><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></TD>    
      <TD class=Field>
      <textarea  class=Inputstyle name="description" rows=5 cols=70><%=description%></textarea>
      </TD>
  </TR>
  <TR >
    <TD class="Line" colSpan=2 ></TD></TR>
  <TR>
      <TD><%=SystemEnv.getHtmlLabelName(15529,user.getLanguage())%></TD>   
      <TD class=Field>
        <select class=inputstyle  name="module" size=1>
            <option value="1" <%if(module.equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(2115,user.getLanguage())%></option>
            <option value="2" <%if(module.equals("2")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></option>
            <option value="3" <%if(module.equals("3")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(2113,user.getLanguage())%></option>
            <option value="4" <%if(module.equals("4")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(2116,user.getLanguage())%></option>
            <option value="5" <%if(module.equals("5")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(2118,user.getLanguage())%></option>
            <option value="6" <%if(module.equals("6")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(2114,user.getLanguage())%></option>
            <option value="7" <%if(module.equals("7")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(2117,user.getLanguage())%></option>
        </select>
      </TD>
  </TR><TR >
    <TD class="Line1" colSpan=2 ></TD></TR> 
 </TBODY></TABLE>
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

</form>

<script>
function onDelete(){
		if(confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>")) {
			document.frmMain.operation.value="reportdelete";
			document.frmMain.submit();
		}
}
</script>
 <script language="javascript">
function submitData()
{if (check_form(weaver,'name,pagename'))
		weaver.submit();
}
</script>

</BODY></HTML>
