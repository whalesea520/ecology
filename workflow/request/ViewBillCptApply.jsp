<jsp:useBean id="CapitalComInfo" class="weaver.cpt.capital.CapitalComInfo" scope="page"/>
<jsp:useBean id="CapitalAssortmentComInfo" class="weaver.cpt.maintenance.CapitalAssortmentComInfo" scope="page"/>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/workflow/request/WorkflowViewRequestTitle.jsp" %>
<form name="frmmain" method="post" action="BillCptApplyOperation.jsp">
<%@ include file="/workflow/request/WorkflowViewRequestBody.jsp" %>

<jsp:include page="ViewBillCptApply0.jsp" flush="true">
    <jsp:param name="billid" value="<%=billid%>" />
    <jsp:param name="formid" value="<%=formid%>" />
    <jsp:param name="nodeid" value="<%=nodeid%>" />
</jsp:include>

<%@ include file="/workflow/request/WorkflowViewSign.jsp" %>
</form> 
</body>
</html>
