
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page"/>
<%
boolean canedit = HrmUserVarify.checkUserRight("EditCustomerRating:Edit",user);
%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
	String id = request.getParameter("id");

	RecordSet.executeProc("CRM_CustomerRating_SelectByID",id);

	if(RecordSet.getFlag()!=1)
	{
		response.sendRedirect("/CRM/DBError.jsp?type=FindData");
		return;
	}
	if(RecordSet.getCounts()<=0)
	{
		response.sendRedirect("/CRM/DBError.jsp?type=FindData");
		return;
	}
	RecordSet.first();
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(93,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(136,user.getLanguage())+SystemEnv.getHtmlLabelName(603,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>


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

<FORM id=weaver name=frmMain action="/CRM/Maint/CustomerRatingOperation.jsp" method=post onsubmit='return check_form(this,"name,desc,workflow11,workflow12,workflow21,workflow22,workflow31,workflow32")'>
<DIV style="display:none">
<%
if(HrmUserVarify.checkUserRight("EditCustomerRating:Edit", user)){
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:weaver.myfun1.click(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
	<BUTTON class=btnSave accessKey=S id=myfun1  type=submit><U>S</U>-<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%></BUTTON>
<%}
if(HrmUserVarify.checkUserRight("EditCustomerRating:Delete", user)){
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:weaverDelete.click(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btnDelete id=Delete accessKey=D onclick='if(isdel()){location.href="/CRM/Maint/CustomerRatingOperation.jsp?method=delete&id=<%=id%>"}'><U>D</U>-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></BUTTON>
<%}
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:weaver.myfun2.click(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btn accessKey=1  id=myfun2  onclick="location='/CRM/Maint/ListCustomerRating.jsp'"><U>1</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>
</DIV>
<input type="hidden" name="method" value="edit">
<input type="hidden" name="id" value="<%=id%>">
<TABLE class=ViewForm>
  <COLGROUP>
  <COL width="100%">
  <TBODY>
  <TR>
    <TD vAlign=top>
      <TABLE class=ViewForm>
      <COLGROUP>
  	<COL width="20%">
  	<COL width="80%">
        <TBODY>
        <TR class=Title>
            <TH><%=SystemEnv.getHtmlLabelName(61,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(87,user.getLanguage())%></TH>
          </TR>
        <TR class=Spacing>
          <TD class=Line1 colSpan=2></TD></TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>	
          <TD class=Field><% if(canedit) {%>
		<INPUT class=InputStyle maxLength=50 size=20 name="name" onchange='checkinput("name","nameimage")' value="<%=Util.toScreenToEdit(RecordSet.getString(2),user.getLanguage())%>"><SPAN id=nameimage></SPAN>
		<%} else {%> <%=Util.toScreen(RecordSet.getString(2),user.getLanguage())%><%}%>
		</TD>
        </TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></TD>
          <TD class=Field><% if(canedit) {%><INPUT class=InputStyle maxLength=150 size=50 name="desc" onchange='checkinput("desc","descimage")' value="<%=Util.toScreenToEdit(RecordSet.getString(3),user.getLanguage())%>"><SPAN id=descimage></SPAN></TD><%}else{%><%=Util.toScreen(RecordSet.getString(3),user.getLanguage())%><%}%>
         </TR>   
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(259,user.getLanguage())%>11</TD>
          <TD class=Field><BUTTON class=Browser id=SelectWorkflow11 onclick="onShowWorkflow11()"></BUTTON> 
              <SPAN id=workflow11span><%=Util.toScreen(WorkflowComInfo.getWorkflowname(RecordSet.getString(4)),user.getLanguage())%></SPAN> 
              <INPUT id=Workflow11 type=hidden name=workflow11 value="<%=RecordSet.getString(4)%>"></TD>
         </TR>   
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(259,user.getLanguage())%>12</TD>
          <TD class=Field><BUTTON class=Browser id=SelectWorkflow12 onclick="onShowWorkflow12()"></BUTTON> 
              <SPAN id=workflow12span><%=Util.toScreen(WorkflowComInfo.getWorkflowname(RecordSet.getString(5)),user.getLanguage())%></SPAN> 
              <INPUT id=Workflow12 type=hidden name=workflow12 value="<%=RecordSet.getString(5)%>"></TD>
         </TR>  
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(259,user.getLanguage())%>21</TD>
          <TD class=Field><BUTTON class=Browser id=SelectWorkflow21 onclick="onShowWorkflow21()"></BUTTON> 
              <SPAN id=workflow21span><%=Util.toScreen(WorkflowComInfo.getWorkflowname(RecordSet.getString(6)),user.getLanguage())%></SPAN> 
              <INPUT id=Workflow21 type=hidden name=workflow21 value="<%=RecordSet.getString(6)%>"></TD>
         </TR>  
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(259,user.getLanguage())%>22</TD>
          <TD class=Field><BUTTON class=Browser id=SelectWorkflow22 onclick="onShowWorkflow22()"></BUTTON> 
              <SPAN id=workflow22span><%=Util.toScreen(WorkflowComInfo.getWorkflowname(RecordSet.getString(7)),user.getLanguage())%></SPAN> 
              <INPUT id=Workflow22 type=hidden name=workflow22 value="<%=RecordSet.getString(7)%>"></TD>
         </TR>  
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(259,user.getLanguage())%>31</TD>
          <TD class=Field><BUTTON class=Browser id=SelectWorkflow31 onclick="onShowWorkflow31()"></BUTTON> 
              <SPAN id=workflow31span><%=Util.toScreen(WorkflowComInfo.getWorkflowname(RecordSet.getString(8)),user.getLanguage())%></SPAN> 
              <INPUT id=Workflow31 type=hidden name=workflow31 value="<%=RecordSet.getString(8)%>"></TD>
         </TR>  
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(259,user.getLanguage())%>32</TD>
          <TD class=Field><BUTTON class=Browser id=SelectWorkflow32 onclick="onShowWorkflow32()"></BUTTON> 
              <SPAN id=workflow32span><%=Util.toScreen(WorkflowComInfo.getWorkflowname(RecordSet.getString(9)),user.getLanguage())%></SPAN> 
              <INPUT id=Workflow32 type=hidden name=workflow32 value="<%=RecordSet.getString(9)%>"></TD>
         </TR>  
        <TR>
          <TD>CanUpgrade</TD>
          <TD class=Field>
			<select name=canupgrade size=1 class=InputStyle>
				 <option >yes</option>
				 <option value="n" <%if ((RecordSet.getString(10)).equals("n")) {%>selected<%}%>>no</option>
			</select>
		  
		  </TD>
         </TR> 			  
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
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
</FORM>
 <script language=vbs>

sub onShowWorkflow11()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	workflow11span.innerHtml = id(1)
	frmMain.workflow11.value=id(0)
	else 
	workflow11span.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
	frmMain.workflow11.value=""
	end if
	end if
end sub

sub onShowWorkflow12()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	workflow12span.innerHtml = id(1)
	frmMain.workflow12.value=id(0)
	else 
	workflow12span.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
	frmMain.workflow12.value=""
	end if
	end if
end sub
sub onShowWorkflow21()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	workflow21span.innerHtml = id(1)
	frmMain.workflow21.value=id(0)
	else 
	workflow21span.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
	frmMain.workflow21.value=""
	end if
	end if
end sub
sub onShowWorkflow22()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	workflow22span.innerHtml = id(1)
	frmMain.workflow22.value=id(0)
	else 
	workflow22span.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
	frmMain.workflow22.value=""
	end if
	end if
end sub
sub onShowWorkflow31()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	workflow31span.innerHtml = id(1)
	frmMain.workflow31.value=id(0)
	else 
	workflow31span.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
	frmMain.workflow31.value=""
	end if
	end if
end sub
sub onShowWorkflow32()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	workflow32span.innerHtml = id(1)
	frmMain.workflow32.value=id(0)
	else 
	workflow32span.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
	frmMain.workflow32.value=""
	end if
	end if
end sub

</script>

</BODY>
</HTML>
