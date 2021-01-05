
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="ProcessingTypeComInfo" class="weaver.proj.Maint.ProcessingTypeComInfo" scope="page" />
<jsp:useBean id="PlanSortComInfo" class="weaver.proj.Maint.PlanSortComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="PlanInfoComInfo" class="weaver.proj.Maint.PlanInfoComInfo" scope="page" />
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>

<% if(!HrmUserVarify.checkUserRight("EditProcessing:Edit",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
   }
%>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</HEAD>
<%
String id = Util.null2String(request.getParameter("id"));
RecordSet.executeProc("Prj_Processing_SelectByID",id);

String prjid="";
String planid="";
String title="";
String content="";
String type="";
String docid="";
String parentids="";
String submitdate="";
String submittime="";
String submiter	="";
String updatedate="";
String updatetime="";
String updater="";
String isprocessed="";
String processdate="";
String processtime="";
String processor="";

if(RecordSet.next()){
	 prjid=Util.toScreen(RecordSet.getString("prjid"),user.getLanguage());
	 planid=Util.toScreen(RecordSet.getString("planid"),user.getLanguage());
	 title=Util.toScreen(RecordSet.getString("title"),user.getLanguage());
	 content=Util.toScreen(RecordSet.getString("content"),user.getLanguage());
	 type=Util.toScreen(RecordSet.getString("type"),user.getLanguage());
	 docid=Util.toScreen(RecordSet.getString("docid"),user.getLanguage());
	 parentids=Util.toScreen(RecordSet.getString("parentids"),user.getLanguage());
	 submitdate=Util.toScreen(RecordSet.getString("submitdate"),user.getLanguage());
	 submittime=Util.toScreen(RecordSet.getString("submittime"),user.getLanguage());
	 submiter=Util.toScreen(RecordSet.getString("submiter"),user.getLanguage());
	 updatedate=Util.toScreen(RecordSet.getString("updatedate"),user.getLanguage());
	 updatetime=Util.toScreen(RecordSet.getString("updatetime"),user.getLanguage());
	 updater=Util.toScreen(RecordSet.getString("updater"),user.getLanguage());
	 isprocessed=Util.toScreen(RecordSet.getString("isprocessed"),user.getLanguage());
	 processdate=Util.toScreen(RecordSet.getString("processdate"),user.getLanguage());
	 processtime=Util.toScreen(RecordSet.getString("processtime"),user.getLanguage());
	 processor=Util.toScreen(RecordSet.getString("processor"),user.getLanguage());
}
%>

<%
String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(93,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(665,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>


<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:weaver.submit(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(589,user.getLanguage())+",javascript:weaver.reset(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<FORM id=weaver name=weaver action="/proj/process/ProcessingOperation.jsp" method=post>
  <input type="hidden" name="method" value="edit">
<input type="hidden" name="prjid" value="<%=prjid%>">  
<input type="hidden" name="id" value="<%=id%>">  
   
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

      <TABLE class=viewform>
      <COLGROUP>
  	<COL width="15%">
  	<COL width="35%">
  	<COL width="15%">
  	<COL width="35%">
        <TBODY>
        
        <TR class=spacing>
          <TD class=line1 colSpan=4></TD></TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(2239,user.getLanguage())%></TD>
          <TD class=Field>
          <select class=inputstyle  name="type">
          <%
          while(ProcessingTypeComInfo.next()){
          %>
          <option value="<%=ProcessingTypeComInfo.getProcessingTypeid()%>" <%if(ProcessingTypeComInfo.getProcessingTypeid().equals(type)){%> selected <%}%>><%=ProcessingTypeComInfo.getProcessingTypename()%></option>
          <%}%>
          </select>
          </TD>
           <td><%=SystemEnv.getHtmlLabelName(844,user.getLanguage())%></td>
         <td class=field >
         <BUTTON class=Browser onclick="showDoc()"></BUTTON>      
      <SPAN ID=docidname>
      <a href="/docs/docs/DocDsp.jsp?id=<%=docid%>"><%=Util.toScreen(DocComInfo.getDocname(docid),user.getLanguage())%></a>
      </SPAN>
        <INPUT class=inputstyle type=hidden name="docid" value="<%=docid%>">
         </td>
         </tr>       <TR class=spacing>
          <TD class=line colSpan=4></TD></TR>
          <tr>
           <TD><%=SystemEnv.getHtmlLabelName(344,user.getLanguage())%></TD>
          <TD class=Field colspan=3><INPUT class=inputstyle maxLength=150 size=50 name="title" value="<%=title%>"></TD>
         </TR>       <TR class=spacing>
          <TD class=line colSpan=4></TD></TR>
         <tr>
         <td colspan=4><%=SystemEnv.getHtmlLabelName(504,user.getLanguage())%></td>
         </tr>
         <tr>     <TR class=spacing>
          <TD class=line1 colSpan=4></TD></TR>
         <td colspan=4><TEXTAREA class=inputstyle NAME=content ROWS=10 STYLE="width:100%"><%=content%></textarea>
    </TR>
	     <TR class=spacing>
          <TD class=line1 colSpan=4></TD></TR>
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

</FORM>

<script language=vbs>
sub onShowPlanID()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/proj/plan/PlanBrowser.jsp?ProjID=<%=prjid%>")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	planspan.innerHtml = "<A href='/proj/plan/DspPlan.jsp?id="&id(0)&"'>"&id(1)&"</A>"
	weaver.planid.value=id(0)
	else 
	planspan.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
	weaver.planid.value="0"
	end if
	end if
end sub
sub showDoc()
	id = window.showModalDialog("/docs/DocBrowserMain.jsp?url=/docs/docs/DocBrowser.jsp")
	if Not isempty(id) then
		weaver.docid.value=id(0)&""
		docidname.innerHtml = "<a href='/docs/docs/DocDsp.jsp?id="&id(0)&"'>"&id(1)&"</a>"	
	end if	
end sub
</script>
</BODY>
</HTML>
