
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/page/maint/common/initNoCache.jsp"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%@page import="weaver.general.BaseBean"%>
<link href="/cpcompanyinfo/style/Operations_wev8.css" rel="stylesheet"
			type="text/css" />
		<link href="/cpcompanyinfo/style/Public_wev8.css" rel="stylesheet"
			type="text/css" />
		<link href="/cpcompanyinfo/style/Business_wev8.css" rel="stylesheet"
			type="text/css" />
		<link href="/newportal/style/Contacts_wev8.css" rel="stylesheet"
			type="text/css" />
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script type="text/javascript" src="/js/jquery/jquery-1.4.2.min_wev8.js"></script>
<table id="webTable2version" width="100%"cellpadding="0" cellspacing="1"
	class="stripe OTable" bordercolor="#F0F0F0">
	<tr id="OTable2" height=25 class="cBlack">
		<td width="40%" align="center">
			<strong><%=SystemEnv.getHtmlLabelName(30946,user.getLanguage()) %></strong>
		</td>
		<td width="20%" align="center">
			<strong><%=SystemEnv.getHtmlLabelName(882,user.getLanguage()) %></strong>
		</td>
		<td width="20%" align="center">
			<strong><%=SystemEnv.getHtmlLabelName(722,user.getLanguage()) %></strong>
		</td>
		<td width="20%" align="center">
			<strong><%=SystemEnv.getHtmlLabelName(1339,user.getLanguage()) %></strong>
		</td>
	</tr>
	<% 
		String requestName = Util.null2String(request.getParameter("requestname"));
		String _workflowid = new BaseBean().getPropValue("companyinfobyworkflow","workflowid");
		String sql = "select wr.requestid,wr.requestname,(select lastname from hrmresource where id=wr.creater) as creater,wr.createdate,wr.createtime from workflow_requestbase wr where wr.workflowid in ("+_workflowid+") and wr.currentnodetype=3 and wr.status<>'强制归档'";
		if(!requestName.equals("")){
			sql+=" and wr.requestname like '%"+requestName+"%'";
		}
		rs.execute(sql);
		while(rs.next()){
	 %>
	<tr >
		<td width="40%" align="center">
			<a href="javascript:parent.onLicenseDivClose();parent.clickWorkflow('<%=rs.getString("requestid") %>','<%=rs.getString("requestname") %>');"><%=rs.getString("requestname") %></a>
		</td>
		<td width="20%" align="center">
			<%=rs.getString("creater") %>
		</td>
		<td width="20%" align="center">
			<%=rs.getString("createdate") %>
		</td>
		<td width="20%" align="center">
			<%=rs.getString("createtime") %>
		</td>
	</tr>
	<%} %>
</table>
