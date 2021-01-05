
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.hrm.HrmUserVarify" %>
<%@ page import="weaver.hrm.User" %>
<%@ page import="weaver.workflow.request.RequestManager" %>
<%@ page import="weaver.workflow.request.SubWorkflowTriggerService" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RequestSubwfTriggerManager" class="weaver.workflow.request.RequestSubwfTriggerManager" scope="page"/>

<%

User user = HrmUserVarify.getUser (request , response) ;
if(user == null)  return ;

String operation=Util.null2String(request.getParameter("operation"));

String returnString="";

if("triSubwf".equals(operation)){

    int requestId = Util.getIntValue(request.getParameter("requestId"),0);
    int nodeId = Util.getIntValue(request.getParameter("nodeId"),0);
	String triggerTime = "1";
	String hasTriggeredSubwf = "";
	String triggerType = "2";
	String paramSubwfSetId = Util.null2String(request.getParameter("paramSubwfSetId"));

	try {
		RequestManager mainRequest=new RequestManager();
        RecordSet.executeSql("select a.*,b.isbill,b.formid from workflow_requestbase a inner join workflow_base b on a.workflowid=b.id where a.requestid=" + requestId);
		if (RecordSet.next()) {
			mainRequest.setWorkflowid(Util.getIntValue(RecordSet.getString("workflowid"), 0));
			mainRequest.setCreater(Util.getIntValue(RecordSet.getString("creater"), 0));
			mainRequest.setCreatertype(Util.getIntValue(RecordSet.getString("createrType"), 0));
			mainRequest.setRequestid(requestId);
			mainRequest.setRequestname(RecordSet.getString("requestname"));
			mainRequest.setRequestlevel(RecordSet.getString("requestlevel"));
			mainRequest.setMessageType(RecordSet.getString("messagetype"));
			mainRequest.setSrc("submit");
			mainRequest.setIsbill(Util.getIntValue(RecordSet.getString("isbill"), 0));
			mainRequest.setFormid(Util.getIntValue(RecordSet.getString("formid"), 0));
        }
		//returnString=RequestSubwfTriggerManager.TriggerSubwf(mainRequest,nodeId,triggerTime, hasTriggeredSubwf,user,triggerType,paramSubwfSetId);
		SubWorkflowTriggerService triggerService = new SubWorkflowTriggerService(mainRequest, nodeId, hasTriggeredSubwf, user);
		returnString = triggerService.triggerSubWorkflow(triggerType, triggerTime, paramSubwfSetId);               
    } catch (Exception e) {

    }
}

%>
<script language="javascript">

<%if("triSubwf".equals(operation)){%>

window.parent.returnTriSubwf("<%=returnString%>");

<%}%>

</script>