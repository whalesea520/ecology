<jsp:useBean id="CapitalComInfo" class="weaver.cpt.capital.CapitalComInfo" scope="page"/>
<jsp:useBean id="CapitalAssortmentComInfo" class="weaver.cpt.maintenance.CapitalAssortmentComInfo" scope="page"/>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/workflow/request/WorkflowViewRequestTitle.jsp" %>
<form name="frmmain" method="post" action="BillCptFetchOperation.jsp">
    <%@ include file="/workflow/request/WorkflowViewRequestBody.jsp" %>

	<jsp:include page="/workflow/request/ViewBillCptFetchAssistant.jsp" flush="true">
		<jsp:param name="requestid" value="<%=requestid%>" />
	    <jsp:param name="requestlevel" value="<%=requestlevel%>" />
	    <jsp:param name="requestmark" value="<%=requestmark%>" />
	    <jsp:param name="creater" value="<%=creater%>" />
	    <jsp:param name="creatertype" value="<%=creatertype%>" />
	    <jsp:param name="deleted" value="<%=deleted%>" />
	    <jsp:param name="billid" value="<%=billid%>" />
	    <jsp:param name="workflowid" value="<%=workflowid%>" />
	    <jsp:param name="formid" value="<%=formid%>" />
	    <jsp:param name="nodeid" value="<%=nodeid%>" />
	    <jsp:param name="nodetype" value="<%=nodetype%>" />
	</jsp:include>

<%@ include file="/workflow/request/WorkflowViewSign.jsp" %>
</form>

</body>
</html>
