<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="WorkTypeComInfo" class="weaver.workflow.workflow.WorkTypeComInfo" scope="page"/>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />

<html>
<head>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>

<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(60,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(17564,user.getLanguage());
String needfav ="1";
String needhelp ="";
String logintype = user.getLogintype();
String seclevel = user.getSeclevel();
int userid=user.getUID();
int usertype = 0;

if(logintype.equals("2"))
	usertype = 1;

//过滤crm用户
if(usertype ==1){
		response.sendRedirect("/notice/noright.jsp");
    return;
}
int wftypetotal=WorkTypeComInfo.getWorkTypeNum();
int wftotal=WorkflowComInfo.getWorkflowNum();
int rownum=(wftypetotal+2)/3;
%>

<body>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<form name=subform method=post>

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

<table class="ViewForm">

   <tr class=field>
        <td width="30%" align=left valign=top>
<%
 	int i=0;
 	int needtd=rownum;
 	while(WorkTypeComInfo.next()){	
 		String wftypename=WorkTypeComInfo.getWorkTypename();
 		String wftypeid = WorkTypeComInfo.getWorkTypeid();
 		needtd--;
 	%>
 	<table class="ViewForm">
		<tr>
		  <td>
 	<%
 	int isfirst = 1;
	while(WorkflowComInfo.next()){
		String wfname=WorkflowComInfo.getWorkflowname();
	 	String wfid = WorkflowComInfo.getWorkflowid();
	 	String curtypeid = WorkflowComInfo.getWorkflowtype();
	 	if(!curtypeid.equals(wftypeid)) continue;

	 	i++;
	 	
	 	if(isfirst ==1){
	 		isfirst = 0;
	%>
	<ul><li><b><%=Util.toScreen(wftypename,user.getLanguage())%></b>	
	<%}%>
		<ul><li><a href="javascript:onWfAgent(<%=wfid%>);">
		<%=Util.toScreen(wfname,user.getLanguage())%></a></ul></li>
	<%
		}
		WorkflowComInfo.setTofirstRow();
	%>
		</ul></li></td></tr>
	</table>
	<%
		if(needtd==0){
			needtd=rownum;
	%>
	</td><td width="30%" align=left valign=top>
	<%
		}
	}
	%>		
	</td>
  </tr>
</table>
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

</body>
</html>

<script language=javascript>
function onWfAgent(wfid){
	document.subform.action = "WfAgent.jsp?workflowid="+wfid;
	document.subform.submit();
}
</script>
