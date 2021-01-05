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

int subCompanyId = Util.getIntValue(request.getParameter("subCompanyId"));
int objId = subCompanyId;
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
RCMenu += "{"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+",checkFlowEdit.jsp?objId="+objId+"&objType="+objType+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

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
<TABLE class=ViewForm id="tblDeptTree">
<COLGROUP> <COL width=30%> <COL width=70%> <TBODY> 
<TR class=title> 
<TH colSpan=2 ><%=SystemEnv.getHtmlLabelName(15058,user.getLanguage())%></TH>
</TR>
<TR class=spacing> 
<TD class=line1 colSpan=2></TD>
</TR>
<tr>
	<td><%=SystemEnv.getHtmlLabelName(18102,user.getLanguage())%></td>
	<td class="field"><%=wf.getWorkflowname(String.valueOf(goalFlowId))%></td>
</tr>
<TR><TD class=Line colSpan=2></TD></TR>
<tr>
	<td><%=SystemEnv.getHtmlLabelName(18103,user.getLanguage())%></td>
	<td class="field"><%=wf.getWorkflowname(String.valueOf(planFlowId))%></td>
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
</body>
</html>