<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ page import="weaver.file.Prop" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="weaver.hrm.HrmUserVarify"%>
<%@ page import="weaver.hrm.User"%>

<%@ page import="java.util.*" %>

<%@ page import="weaver.odoc.workflow.request.utils.TableTextUtil" %>
<%@ page import="weaver.odoc.workflow.request.beans.RequestConditionInfo" %>

<%

int workflowId = Util.getIntValue(request.getParameter("workflowid"));
int requestId = Util.getIntValue(request.getParameter("requestid"));
int nodeId = Util.getIntValue(request.getParameter("nodeid"));
int formId = Util.getIntValue(request.getParameter("formid"));
User user = HrmUserVarify.getUser(request, response);

RequestConditionInfo requestConditionInfo = new RequestConditionInfo();
requestConditionInfo.setWorkflowId(workflowId);
requestConditionInfo.setRequestId(requestId);
requestConditionInfo.setUser(user);
requestConditionInfo.setNodeId(nodeId);
requestConditionInfo.setFormId(formId);
requestConditionInfo.setFromFlowDoc(1);
response.sendRedirect(TableTextUtil.getTargetUrl(requestConditionInfo));

%>

