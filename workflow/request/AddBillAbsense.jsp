
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/workflow/request/WorkflowAddRequestTitle.jsp" %>

<form name="frmmain" method="post" action="AbsenseOperation.jsp" enctype="multipart/form-data">
<input type="hidden" name="needwfback" id="needwfback" value="1" />
    <%@ include file="/workflow/request/WorkflowAddRequestBody.jsp" %>
</form>

