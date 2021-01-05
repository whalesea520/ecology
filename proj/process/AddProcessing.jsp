
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="ProcessingTypeComInfo" class="weaver.proj.Maint.ProcessingTypeComInfo" scope="page" />
<jsp:useBean id="PlanSortComInfo" class="weaver.proj.Maint.PlanSortComInfo" scope="page" />
<jsp:useBean id="PlanInfoComInfo" class="weaver.proj.Maint.PlanInfoComInfo" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</HEAD>


<% if(!HrmUserVarify.checkUserRight("AddProcessing:Add",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
   }
%>

<%
String prjid = Util.null2String(request.getParameter("ProjID"));
String planid = Util.null2String(request.getParameter("planid"));
String parentids = Util.null2String(request.getParameter("parentids"));
if(parentids.equals(""))
	parentids = "0";
%>

<%
String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(82,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(665,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:weaver.submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<FORM id=weaver name=weaver action="/proj/process/ProcessingOperation.jsp" method=post >
  <input type="hidden" name="method" value="add">
<input type="hidden" name="prjid" value="<%=prjid%>">
  <input type="hidden" name="parentids" value="<%=parentids%>">
  
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
          <TD><%=SystemEnv.getHtmlLabelName(407,user.getLanguage())%></TD>
          <TD class=Field>
          <%if(planid.equals("")){%>
          <BUTTON class=Browser onClick="onShowPlanID()"></BUTTON> <span 
            id=planspan><IMG src='/images/BacoError_wev8.gif' align=absMiddle></span> 
              <%}else{%>
             <a href="/proj/plan/DspPlan.jsp?id=<%=planid%>"><%=PlanInfoComInfo.getPlanInfoSubject(planid)%></a>
           
             <%}%>
              <INPUT class=inputstyle type=hidden name="planid" value="<%=planid%>">
           </TD>
         
          <TD><%=SystemEnv.getHtmlLabelName(2239,user.getLanguage())%></TD>
          <TD class=Field>
          <select class=inputstyle  name="type">
          <%
          while(ProcessingTypeComInfo.next()){
          %>
          <option value="<%=ProcessingTypeComInfo.getProcessingTypeid()%>"><%=ProcessingTypeComInfo.getProcessingTypename()%></option>
          <%}%>
          </select>
          </TD></tr>
		    <TR class=spacing>
          <TD class=line colSpan=4></TD></TR>
          <tr>
           <TD><%=SystemEnv.getHtmlLabelName(344,user.getLanguage())%></TD>
          <TD class=Field colspan=3><INPUT class=inputstyle maxLength=150 size=50 name="title" onchange='checkinput("title","titleimage")'><SPAN id=titleimage><IMG src="/images/BacoError_wev8.gif" align=absMiddle></SPAN></TD>
         </TR>   <TR class=spacing>
          <TD class=line colSpan=4></TD></TR>     
         <tr>
         <td><%=SystemEnv.getHtmlLabelName(844,user.getLanguage())%></td>
         <td class=field colspan=3>
         <BUTTON class=Browser onclick="showDoc()"></BUTTON>      
      <SPAN ID=docidname>
      </SPAN>
        <INPUT class=inputstyle type=hidden name="docid">
         </td>
         </tr><TR class=spacing>
          <TD class=line colSpan=4></TD></TR>
          <TR>
         <tr>
         <td colspan=4><%=SystemEnv.getHtmlLabelName(504,user.getLanguage())%></td>
         </tr><TR class=spacing>
          <TD class=line colSpan=4></TD></TR>
         <tr>
         <td colspan=4><TEXTAREA class=inputstyle NAME=content ROWS=10 STYLE="width:100%"></textarea>
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
 <script language="javascript">
function submitData()
{if (check_form(weaver,'planid,title'))
		weaver.submit();
}
</script>
</BODY>
</HTML>
