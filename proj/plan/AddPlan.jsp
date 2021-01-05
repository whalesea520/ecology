
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="PlanTypeComInfo" class="weaver.proj.Maint.PlanTypeComInfo" scope="page" />
<jsp:useBean id="PlanSortComInfo" class="weaver.proj.Maint.PlanSortComInfo" scope="page" />

<% if(!HrmUserVarify.checkUserRight("AddPlan:Add",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
   }
%>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script LANGUAGE="JavaScript" SRC="/js/checkinput_wev8.js"></script>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
</HEAD>
<%
String ProjID = Util.null2String(request.getParameter("ProjID"));
%>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(82,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(407,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>


<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<FORM id=weaver name=weaver action="/proj/plan/PlanOperation.jsp" method=post>
  <input type="hidden" name="method" value="add">
  <input type="hidden" name="ProjID" value="<%=ProjID%>">
  
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
            id=resourceidspan><IMG src='/images/BacoError_wev8.gif' align=absMiddle></span> 
              <INPUT class=inputstyle type=hidden name="resourceid">
           </TD>
          <TD><%=SystemEnv.getHtmlLabelName(344,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=inputstyle maxLength=150 size=20 name="subject" onChange="checkinput('subject','subjectspan')"> <span 
            id=subjectspan><IMG src='/images/BacoError_wev8.gif' align=absMiddle></span> </TD>
         </TR>        
             <TR class=spacing>
          <TD class=line colSpan=4></TD></TR>
          <TR>
          <TD><%=SystemEnv.getHtmlLabelName(842,user.getLanguage())%></TD>
          <TD class=Field>
          <select class=inputstyle  name="plantype">
          <%
          while(PlanTypeComInfo.next()){
          %>
          <option value="<%=PlanTypeComInfo.getPlanTypeid()%>"><%=PlanTypeComInfo.getPlanTypename()%></option>
          <%}%>
          </select>
          </TD>
          <TD><%=SystemEnv.getHtmlLabelName(843,user.getLanguage())%></TD>
          <TD class=Field><select class=inputstyle  name="plansort">
          <%
          while(PlanSortComInfo.next()){
          %>
          <option value="<%=PlanSortComInfo.getPlanSortid()%>"><%=PlanSortComInfo.getPlanSortname()%></option>
          <%}%>
          </select>
         </TD>
        </TR>    <TR class=spacing>
          <TD class=line colSpan=4></TD></TR>
        <tr>
        <TD><%=SystemEnv.getHtmlLabelName(1322,user.getLanguage())%></TD>
          <TD class=Field>
          <BUTTON class=Calendar onclick="getDate(begindatespan,begindate)"></BUTTON> 
              <SPAN id=begindatespan ></SPAN> 
              <input type="hidden" name="begindate" id="begindate">
              
          </td>
        <td><%=SystemEnv.getHtmlLabelName(404,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(277,user.getLanguage())%></td>
           <TD class=Field><INPUT class=inputstyle maxLength=8 size=10 name="begintime"></TD>
         </tr>    <TR class=spacing>
          <TD class=line colSpan=4></TD></TR>
        <tr>
        <TD><%=SystemEnv.getHtmlLabelName(741,user.getLanguage())%></TD>
          <TD class=Field>
          <BUTTON class=Calendar onclick="getDate(enddatespan,enddate)"></BUTTON> 
              <SPAN id=enddatespan ></SPAN> 
              <input type="hidden" name="enddate" id="enddate">
              
          </td>
        <td><%=SystemEnv.getHtmlLabelName(405,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(277,user.getLanguage())%></td>
           <TD class=Field><INPUT class=inputstyle maxLength=8 size=10 name="endtime"></TD>
         </tr>    <TR class=spacing>
          <TD class=line colSpan=4></TD></TR>
         <tr>
         <td><%=SystemEnv.getHtmlLabelName(844,user.getLanguage())%></td>
         <td class=field>
         <BUTTON class=Browser onclick="showDoc()"></BUTTON>      
      <SPAN ID=docidname>
      </SPAN>
        <INPUT class=inputstyle type=hidden name="docid">
         </td>
         <td><%=SystemEnv.getHtmlLabelName(845,user.getLanguage())%></td>
           <TD class=Field><INPUT class=inputstyle maxLength=8 size=10 name="budgetmoney"></TD>
         </tr>
         <tr>
         <td colspan=4><%=SystemEnv.getHtmlLabelName(504,user.getLanguage())%></td>
         </tr>
         <tr>
         <td colspan=4><TEXTAREA class=inputstyle NAME=content ROWS=10 STYLE="width:100%"></textarea>
         </tr>    <TR class=spacing>
          <TD class=line1 colSpan=4></TD></TR>
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
 <script language="javascript">
function submitData()
{if (check_form(weaver,'resourceid,subject'))
		weaver.submit();
}
</script>
</BODY>
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</HTML>
