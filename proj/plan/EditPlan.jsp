
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="PlanTypeComInfo" class="weaver.proj.Maint.PlanTypeComInfo" scope="page" />
<jsp:useBean id="PlanSortComInfo" class="weaver.proj.Maint.PlanSortComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />


<% if(!HrmUserVarify.checkUserRight("EditPlan:Edit",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
   }
%>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</HEAD>
<%
String id = Util.null2String(request.getParameter("id"));
RecordSet.executeProc("Prj_PlanInfo_SelectByID",id);
String prjid = "";
String subject = "";
String begindate = "";
String enddate = "";
String begintime = "";
String endtime = "";
String resourceid = "";
String content = "";
String budgetmoney = "";
String docid = "";
String plansort = "";
String plantype = "";
String validate="";
if(RecordSet.next()){
	 prjid = Util.toScreen(RecordSet.getString("prjid"),user.getLanguage());
	 subject = Util.toScreen(RecordSet.getString("subject"),user.getLanguage());
	 begindate = Util.toScreen(RecordSet.getString("begindate"),user.getLanguage());
	 enddate = Util.toScreen(RecordSet.getString("enddate"),user.getLanguage());
	 begintime = Util.toScreen(RecordSet.getString("begintime"),user.getLanguage());
	 endtime = Util.toScreen(RecordSet.getString("endtime"),user.getLanguage());
	 resourceid = Util.toScreen(RecordSet.getString("resourceid"),user.getLanguage());
	 content = Util.toScreen(RecordSet.getString("content"),user.getLanguage());
	 budgetmoney = Util.toScreen(RecordSet.getString("budgetmoney"),user.getLanguage());
	 docid = Util.toScreen(RecordSet.getString("docid"),user.getLanguage());
	 plansort = Util.toScreen(RecordSet.getString("plansort"),user.getLanguage());
	 plantype = Util.toScreen(RecordSet.getString("plantype"),user.getLanguage());
	 validate=Util.toScreen(RecordSet.getString("validate_n"),user.getLanguage());
}

if(plantype.equals("")) plantype = "0";
if(plansort.equals("")) plansort = "0";
if(validate.equals("")) validate = "0";

%>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(93,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(407,user.getLanguage());
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
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<FORM id=weaver name=weaver action="/proj/plan/PlanOperation.jsp" method=post>
  <input type="hidden" name="method" value="edit">
  <input type="hidden" name="ProjID" value="<%=prjid%>">
  <input type="hidden" name="id" value="<%=id%>">
  <input type="hidden" name="validate" value="<%=validate%>">
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
  <COL width="100%">
  <TBODY>
  <TR>
    <TD vAlign=top>
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
          <TD><%=SystemEnv.getHtmlLabelName(362,user.getLanguage())%></TD>
          <TD class=Field>
          <BUTTON class=Browser id=SelectManagerID onClick="onShowResourceID()"></BUTTON> <span 
            id=resourceidspan><A href="/hrm/resource/HrmResource.jsp?id=<%=resourceid%>"><%=Util.toScreen(ResourceComInfo.getResourcename(resourceid),user.getLanguage())%></A>
            </span> 
              <INPUT class=inputstyle type=hidden name="resourceid" value="<%=resourceid%>">
           </TD>
          <TD><%=SystemEnv.getHtmlLabelName(344,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=inputstyle maxLength=150 size=20 name="subject" value="<%=subject%>"></TD>
         </TR>        
             <TR class=spacing>
          <TD class=line colSpan=4></TD></TR>
          <TR>
          <TD><%=SystemEnv.getHtmlLabelName(843,user.getLanguage())%></TD>
          <TD class=Field>
          <select class=inputstyle  name="plantype">
          <%
          while(PlanTypeComInfo.next()){
          %>
          <option value="<%=PlanTypeComInfo.getPlanTypeid()%>" <%if(PlanTypeComInfo.getPlanTypeid().equals(plantype)){%> selected <%}%>><%=PlanTypeComInfo.getPlanTypename()%></option>
          <%}%>
          </select>
          </TD>
          <TD><%=SystemEnv.getHtmlLabelName(843,user.getLanguage())%></TD>
          <TD class=Field><select class=inputstyle  name="plansort">
          <%
          while(PlanSortComInfo.next()){
          %>
          <option value="<%=PlanSortComInfo.getPlanSortid()%>" <%if(PlanSortComInfo.getPlanSortid().equals(plansort)){%> selected <%}%>><%=PlanSortComInfo.getPlanSortname()%></option>
          <%}%>
          </select>
         </TD>
        </TR> <TR class=spacing>
          <TD class=line colSpan=4></TD></TR>
        <tr>
        <TD><%=SystemEnv.getHtmlLabelName(1322,user.getLanguage())%></TD>
          <TD class=Field>
          <BUTTON class=Calendar onclick="getDate(begindatespan,begindate)"></BUTTON> 
              <SPAN id=begindatespan ><%=begindate%>
              </SPAN> 
              <input type="hidden" name="begindate" id="begindate" value="<%=begindate%>">
              
          </td>
        <td><%=SystemEnv.getHtmlLabelName(404,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(277,user.getLanguage())%></td>
           <TD class=Field><INPUT class=inputstyle maxLength=8 size=10 name="begintime" value="<%=begintime%>"></TD>
         </tr> <TR class=spacing>
          <TD class=line colSpan=4></TD></TR>
        <tr>
        <TD><%=SystemEnv.getHtmlLabelName(741,user.getLanguage())%></TD>
          <TD class=Field>
          <BUTTON class=Calendar onclick="getDate(enddatespan,enddate)"></BUTTON> 
              <SPAN id=enddatespan ><%=enddate%></SPAN> 
              <input type="hidden" name="enddate" id="enddate" value="<%=enddate%>">
              
          </td>
        <td><%=SystemEnv.getHtmlLabelName(743,user.getLanguage())%></td>
           <TD class=Field><INPUT class=inputstyle maxLength=8 size=10 name="endtime" value="<%=endtime%>"></TD>
         </tr> <TR class=spacing>
          <TD class=line colSpan=4></TD></TR>
         <tr>
         <td><%=SystemEnv.getHtmlLabelName(844,user.getLanguage())%></td>
         <td class=field>
         <BUTTON class=Browser onclick="showDoc()"></BUTTON>      
      <SPAN ID=docidname> <a href="/docs/docs/DocDsp.jsp?id=<%=docid%>">      <%=Util.toScreen(DocComInfo.getDocname(docid),user.getLanguage())%></a>
      </SPAN>
        <INPUT class=inputstyle type=hidden name="docid" value="<%=docid%>">
         </td>
         <td><%=SystemEnv.getHtmlLabelName(845,user.getLanguage())%></td>
           <TD class=Field><INPUT class=inputstyle maxLength=8 size=10 name="budgetmoney" value="<%=budgetmoney%>"></TD>
         </tr> <TR class=spacing>
          <TD class=line colSpan=4></TD></TR>
         <tr>
         <td colspan=4><%=SystemEnv.getHtmlLabelName(504,user.getLanguage())%></td>
         </tr>
         <tr>
         <td colspan=4><TEXTAREA class=inputstyle NAME=content ROWS=10 STYLE="width:100%">
         <%=content%></textarea>
         </tr>
         </TBODY></TABLE></TD>
    </TR></TBODY></TABLE>
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
<script language=javascript>
function onDelete(){
	weaver.method.value="delete";
	weaver.submit();
}
</script>
<script language=vbs>
sub onShowResourceID()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	resourceidspan.innerHtml = "<A href='/hrm/resource/HrmResource.jsp?id="&id(0)&"'>"&id(1)&"</A>"
	weaver.resourceid.value=id(0)
	else 
	resourceidspan.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
	weaver.resourceid.value="0"
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
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</HTML>
