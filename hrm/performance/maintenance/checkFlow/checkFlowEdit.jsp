<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="wf" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(18043,user.getLanguage());
String needfav ="1";
String needhelp ="";

int userId = 0;
userId = user.getUID();
if(userId!=1){
    response.sendRedirect("/notice/noright.jsp");
    return;
}

int objId = Util.getIntValue(request.getParameter("objId"));
String objType = "1";
int goalFlowId = 0;
int planFlowId = 0;

String sql = "SELECT * FROM HrmPerformanceCheckFlow WHERE objId="+objId+" AND objType='"+objType+"'";
rs.executeSql(sql);
if(rs.next()){
	goalFlowId = rs.getInt("goalFlowId");
	planFlowId = rs.getInt("planFlowId");
}
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<link href="/css/Weaver.css" type=text/css rel=stylesheet>
<style>
</style>
<script type="text/javascript">

</script>
</head>

<body>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:checkSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<form name="frmMain" method="post" action="checkFlowOperation.jsp">
<input type="hidden" name="objId" value="<%=objId%>">
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
<td height="10" colspan="3"></td>
</tr>
<tr>
<td></td>
<td valign="top">
<TABLE class="Shadow">
<tr>
<td valign="top">
		
<!--=================================-->
<TABLE class=ViewForm>
<COLGROUP>
<COL width=30%> <COL width=70%> <TBODY> 
<TR class=title> 
<TH colSpan=2><%=SystemEnv.getHtmlLabelName(18102,user.getLanguage())%></TH>
</TR>
<TR class=spacing> 
<TD class=line1 colSpan=2></TD>
</TR>
<tr>
	<td><%=SystemEnv.getHtmlLabelName(18102,user.getLanguage())%></td>
	<td class="field">
		<BUTTON type="button" class=Browser id=SelectFlowID onClick="onShowFlowID('0')"></BUTTON> 
		<span id=goalFlowIdSpan name="goalFlowIdSpan"><%=wf.getWorkflowname(String.valueOf(goalFlowId))%></span> 
		<INPUT class=inputStyle id=goalFlowId type=hidden name=goalFlowId value="<%=goalFlowId%>">
	</td>
</tr>
<TR><TD class=Line colSpan=2></TD></TR>
<tr>
<td><%=SystemEnv.getHtmlLabelName(18240,user.getLanguage())%>下级分部</td>
<td class="field">
		<input type="checkbox" name="checkSubCompanyGoal" value="1">
</td>
</tr>
<TR><TD class=Line colSpan=2></TD></TR>
<tr>
<td><%=SystemEnv.getHtmlLabelName(18240,user.getLanguage())%>部门</td>
<td class="field">
		<input type="checkbox" name="checkDepartmentGoal" value="1">
</td>
</tr>
<TR><TD class=Line colSpan=2></TD></TR>
<tr>
<td><%=SystemEnv.getHtmlLabelName(18240,user.getLanguage())%>人员</td>
<td class="field">
		<input type="checkbox" name="checkHrmResourceGoal" value="1">
</td>
</tr>
<TR><TD class=Line colSpan=2></TD></TR>
</TABLE>




<TABLE class=ViewForm>
<COLGROUP>
<COL width=30%> <COL width=70%> <TBODY> 
<TR class=title> 
<TH colSpan=2><%=SystemEnv.getHtmlLabelName(18103,user.getLanguage())%></TH>
</TR>
<TR class=spacing> 
<TD class=line1 colSpan=2></TD>
</TR>
<tr>
	<td><%=SystemEnv.getHtmlLabelName(18103,user.getLanguage())%></td>
	<td class="field">
		<BUTTON type="button" class=Browser id=SelectFlowID onClick="onShowFlowID('1')"></BUTTON> 
		<span id=planFlowIdSpan name="planFlowIdSpan"><%=wf.getWorkflowname(String.valueOf(planFlowId))%></span> 
		<INPUT class=inputStyle id=planFlowId type=hidden name=planFlowId value="<%=planFlowId%>">
	</td>
</tr>
<TR><TD class=Line colSpan=2></TD></TR>
<tr>
<td><%=SystemEnv.getHtmlLabelName(18240,user.getLanguage())%>下级分部</td>
<td class="field">
		<input type="checkbox" name="checkSubCompanyPlan" value="1">
</td>
</tr>
<TR><TD class=Line colSpan=2></TD></TR>
<tr>
<td><%=SystemEnv.getHtmlLabelName(18240,user.getLanguage())%>部门</td>
<td class="field">
		<input type="checkbox" name="checkDepartmentPlan" value="1">
</td>
</tr>
<TR><TD class=Line colSpan=2></TD></TR>
<tr>
<td><%=SystemEnv.getHtmlLabelName(18240,user.getLanguage())%>人员</td>
<td class="field">
		<input type="checkbox" name="checkHrmResourcePlan" value="1">
</td>
</tr>
<TR><TD class=Line colSpan=2></TD></TR>
</TABLE>
<!--=================================-->

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

<script language="javascript">
function checkSubmit(){
	document.frmMain.submit();
}
</script>

<script language="vbs">
sub onShowFlowID(flowType) 
   id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/workflow/request/FlowBrowser.jsp?para="&flowType)
	if (Not IsEmpty(id)) then
		if id(0)<> "" then
			if flowType="0" then
				document.getElementById("goalFlowIdSpan").innerHTML = id(1)
				document.getElementById("goalFlowId").value = id(0)
			else
				document.getElementById("planFlowIdSpan").innerHTML = id(1)
				document.getElementById("planFlowId").value = id(0)
			end if
		else
			if flowType="1" then
				document.getElementById("goalFlowIdSpan").innerHTML = ""
				document.getElementById("goalFlowId").value = ""
			else
				document.getElementById("planFlowIdSpan").innerHTML = ""
				document.getElementById("planFlowId").value = ""
			end if
		end if
	end if
end sub
</script>


<%!
%>