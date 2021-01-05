<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page"/>
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page"/>
<jsp:useBean id="MeetingComInfo" class="weaver.meeting.Maint.MeetingComInfo" scope="page"/>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/workflow/request/WorkflowViewRequestTitle.jsp" %>
<form name="frmmain" method="post" action="BillMeetingOperation.jsp">
    <%@ include file="/workflow/request/WorkflowViewRequestBody.jsp" %>

	 
<br>
<br>
<jsp:include page="WorkflowViewSignAction.jsp" flush="true">
    <jsp:param name="workflowid" value="<%=workflowid%>" />
    <jsp:param name="languageid" value="<%=user.getLanguage()%>" />
    <jsp:param name="requestid" value="<%=requestid%>" />
    <jsp:param name="userid" value="<%=userid%>" />
    <jsp:param name="usertype" value="<%=usertype%>" />
    <jsp:param name="isprint" value="<%=isprint%>" />
    <jsp:param name="nodeid" value="<%=nodeid%>" />
   
    <jsp:param name="desrequestid" value="<%=desrequestid%>" />
    <jsp:param name="isurger" value="<%=isurger%>" />
    <jsp:param name="wfmonitor" value="<%=wfmonitor%>" />
</jsp:include>
</form>

</body>
</html>
