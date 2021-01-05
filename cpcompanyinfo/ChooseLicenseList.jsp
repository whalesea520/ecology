
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/page/maint/common/initNoCache.jsp"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />

<%
	String sql = "select affixindex,licenseaffixid,licensename,licensetype from CPLMLICENSEAFFIX order by affixindex";
	rs.execute(sql);
%>
<link rel="stylesheet" type="text/css" href="/cpcompanyinfo/style/wbox_wev8.css" />
<script type="text/javascript">
	jQuery(document).ready(function(){
		
	});
	
</script>
<table width="100%"  border="1" bordercolor="#F0F0F0" cellpadding="0" cellspacing="1"
	class="stripe OTable">
	<tr id="OTable2" class="cBlack">
		<td align="center">
			<strong><%=SystemEnv.getHtmlLabelName(15486,user.getLanguage()) %></strong>
		</td>
		<td align="center">
			<strong><%=SystemEnv.getHtmlLabelName(30945,user.getLanguage()) %></strong>
		</td>
	</tr>
	<%
	while(rs.next())
	{
	
	%>
	<tr>
		<td width="35px" height="25px"  align="center">
			<%=rs.getString("affixindex") %>
		</td>
		<td>
			<a href="javascript:clickLicenseName2List(<%=rs.getString("licenseaffixid")%>,'<%=rs.getString("licensename")%>','<%=rs.getString("licensetype")%>')"><%=rs.getString("licensename") %></a>
		</td>
	</tr>
	<%
	}
	%>	
</table>