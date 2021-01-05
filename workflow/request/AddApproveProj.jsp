<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/workflow/request/WorkflowAddRequestTitle.jsp" %>
<form name="frmmain" method="post" action="BillApproveProjOperation.jsp" enctype="multipart/form-data">
    <input type="hidden" name="f_weaver_belongto_userid" value="<%=request.getParameter("f_weaver_belongto_userid") %>">
    <input type="hidden" name="f_weaver_belongto_usertype" value="<%=request.getParameter("f_weaver_belongto_usertype") %>">
    <%@ include file="/workflow/request/WorkflowAddRequestBody.jsp" %>
</form>