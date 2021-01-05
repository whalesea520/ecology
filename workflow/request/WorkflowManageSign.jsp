<%--所有单据JSP过大的修改--%>
<%
	//请勿定义为int submit,重复报错
	int req_submit=Util.getIntValue(Util.null2String(request.getParameter("submit")), 0);
	int forward=Util.getIntValue(Util.null2String(request.getParameter("forward")), 0);
%>
<jsp:include page="/workflow/request/WorkflowManageSignForBill.jsp" flush="true">
	<jsp:param name="submit" value="<%=req_submit%>" />
	<jsp:param name="forward" value="<%=forward%>" />
</jsp:include>