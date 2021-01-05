
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
	RecordSet.executeProc("CRM_CustomerRating_SelectAll","");
	if(RecordSet.getFlag()!=1)
	{
		response.sendRedirect("/CRM/DBError.jsp?type=FindData");
		return;
	}
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(320,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(136,user.getLanguage())+SystemEnv.getHtmlLabelName(139,user.getLanguage());
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
<%
if(HrmUserVarify.checkUserRight("AddCustomerRating:add", user)){
%>
<DIV class=BtnBar style="display:none">
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javascript:myfun1.click(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON language=VBS class=BtnNew id=myfun1 accessKey=N name=button1 onclick="location='/CRM/Maint/AddCustomerRating.jsp'"><U>N</U>-<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%></BUTTON>
</DIV>
<%}
%>
<TABLE class=ListStyle cellspacing=1>
  <TBODY>
  <TR class=Header>
 <th><%=SystemEnv.getHtmlLabelName(139,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></th>
 <th><%=SystemEnv.getHtmlLabelName(139,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(259,user.getLanguage())%>11</th>
  <th><%=SystemEnv.getHtmlLabelName(259,user.getLanguage())%>12</th>
  <th><%=SystemEnv.getHtmlLabelName(259,user.getLanguage())%>21</th>
  <th><%=SystemEnv.getHtmlLabelName(259,user.getLanguage())%>22</th>
  <th><%=SystemEnv.getHtmlLabelName(259,user.getLanguage())%>31</th>
  <th><%=SystemEnv.getHtmlLabelName(259,user.getLanguage())%>32</th>
  </tr>
<TR class=Line><TD colSpan=6></TD></TR>
<%
boolean isLight = false;
	while(RecordSet.next())
	{
		if(isLight = !isLight)
		{%>	
	<TR CLASS=DataDark>
<%		}else{%>
	<TR CLASS=DataLight>
<%		}%>
		<TD><a href="/CRM/Maint/EditCustomerRating.jsp?id=<%=RecordSet.getString(1)%>"><%=Util.toScreen(RecordSet.getString(2),user.getLanguage())%></a></TD>
		<TD><%=Util.toScreen(RecordSet.getString(3),user.getLanguage())%></TD>
		<TD><a href="/workflow/workflow/addwf.jsp?src=editwf&wfid=<%=RecordSet.getString(4)%>"><%=Util.toScreen(WorkflowComInfo.getWorkflowname(RecordSet.getString(4)),user.getLanguage())%></a></TD>
		<TD><a href="/workflow/workflow/addwf.jsp?src=editwf&wfid=<%=RecordSet.getString(5)%>"><%=Util.toScreen(WorkflowComInfo.getWorkflowname(RecordSet.getString(5)),user.getLanguage())%></a></TD>
		<TD><a href="/workflow/workflow/addwf.jsp?src=editwf&wfid=<%=RecordSet.getString(6)%>"><%=Util.toScreen(WorkflowComInfo.getWorkflowname(RecordSet.getString(6)),user.getLanguage())%></a></TD>
        <TD><a href="/workflow/workflow/addwf.jsp?src=editwf&wfid=<%=RecordSet.getString(7)%>"><%=Util.toScreen(WorkflowComInfo.getWorkflowname(RecordSet.getString(7)),user.getLanguage())%></a></TD>
		<TD><a href="/workflow/workflow/addwf.jsp?src=editwf&wfid=<%=RecordSet.getString(8)%>"><%=Util.toScreen(WorkflowComInfo.getWorkflowname(RecordSet.getString(8)),user.getLanguage())%></a></TD>
		<TD><a href="/workflow/workflow/addwf.jsp?src=editwf&wfid=<%=RecordSet.getString(9)%>"><%=Util.toScreen(WorkflowComInfo.getWorkflowname(RecordSet.getString(9)),user.getLanguage())%></a></TD>
	</TR>
<%
	}
%>
 </TABLE>
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
</BODY>
</HTML>
