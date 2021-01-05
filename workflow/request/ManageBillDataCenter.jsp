
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/workflow/request/WorkflowManageRequestTitle.jsp" %>

<%
String isaffirmanceForThisJsp=Util.null2String(request.getParameter("isaffirmance"));//是否需要提交确认
String reEditForThisJsp=Util.null2String(request.getParameter("reEdit"));//是否为编辑
%>


<form name="frmmain" method="post" action="BillDataCenterOperation.jsp" enctype="multipart/form-data">
    <%@ include file="/workflow/request/WorkflowManageRequestBodyDataCenter.jsp" %>
<%
boolean  hasdetailb=false;
if(isbill.equals("0")) {
    RecordSet.executeSql("select count(*) from workflow_formfield  where isdetail='1' and formid="+formid);
}else{
    RecordSet.executeSql("select count(*) from workflow_billfield  where viewtype=1 and billid="+formid);
}
if(RecordSet.next()){
    if(RecordSet.getInt(1)>0) hasdetailb=true;
}
if(hasdetailb){
%>
    <jsp:include page="WorkflowManageRequestDetailBodyBill.jsp" flush="true">
    <jsp:param name="requestid" value="<%=requestid%>" />
    <jsp:param name="billid" value="<%=billid%>" />
    <jsp:param name="workflowid" value="<%=workflowid%>" />
    <jsp:param name="workflowtype" value="<%=workflowtype%>" />
    <jsp:param name="formid" value="<%=formid%>" />
    <jsp:param name="nodeid" value="<%=nodeid%>" />
    <jsp:param name="nodetype" value="<%=nodetype%>" />
    <jsp:param name="newdocid" value="<%=newdocid%>" />
    <jsp:param name="isremark" value="<%=isremark%>" />
	<jsp:param name="currentdate" value="<%=currentdate%>" />
	<jsp:param name="docfileid" value="<%=docfileid%>" />
    <jsp:param name="needcheck" value="<%=needcheck%>" />
    <jsp:param name="isaffirmance" value="<%=isaffirmanceForThisJsp%>" />
    <jsp:param name="reEdit" value="<%=reEditForThisJsp%>" />
    </jsp:include>
<%
    }
%>
    <jsp:include page="WorkflowManageSign1.jsp" flush="true">
    <jsp:param name="requestid" value="<%=requestid%>" />
    <jsp:param name="requestlevel" value="<%=requestlevel%>" />
    <jsp:param name="requestmark" value="<%=requestmark%>" />
    <jsp:param name="creater" value="<%=creater%>" />
    <jsp:param name="creatertype" value="<%=creatertype%>" />
    <jsp:param name="deleted" value="<%=deleted%>" />
    <jsp:param name="billid" value="<%=billid%>" />
	<jsp:param name="isbill" value="<%=isbill%>" />
    <jsp:param name="workflowid" value="<%=workflowid%>" />
    <jsp:param name="workflowtype" value="<%=workflowtype%>" />
    <jsp:param name="formid" value="<%=formid%>" />
    <jsp:param name="nodeid" value="<%=nodeid%>" />
    <jsp:param name="nodetype" value="<%=nodetype%>" />
    <jsp:param name="isreopen" value="<%=isreopen%>" />
    <jsp:param name="isreject" value="<%=isreject%>" />
    <jsp:param name="isremark" value="<%=isremark%>" />
	<jsp:param name="currentdate" value="<%=currentdate%>" />
	<jsp:param name="currenttime" value="<%=currenttime%>" />
    <jsp:param name="needcheck" value="<%=needcheck%>" />
    <jsp:param name="newReportUserId" value="<%=newReportUserId%>" />
    <jsp:param name="newCrmId" value="<%=newCrmId%>" />    
    </jsp:include>
</form>





