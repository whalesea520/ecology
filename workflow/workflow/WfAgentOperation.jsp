
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.workflow.workflow.WFAgentManager" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RequestCheckUser" class="weaver.workflow.request.RequestCheckUser" scope="page" />

<%
String method=request.getParameter("method");
String haveAgentAllRight = request.getParameter("haveAgentAllRight");
int workflowId = Util.getIntValue(request.getParameter("workflowid"),0);
WFAgentManager mWFAgentManager=new WFAgentManager();

if(method.equals("add")){
  if(haveAgentAllRight.equals("true")){
    //具有公共流程代理维护权限，由明细行提交数据
    mWFAgentManager.setWorkflowId(workflowId);
    mWFAgentManager.delAIFbyWfid();
    int rowsum= Util.getIntValue(request.getParameter("rowsum"),0);
    for(int i=0;i<rowsum;i++){
      int beagenterId = Util.getIntValue(request.getParameter("agent_"+i+"_beagenterId"),0);
      int agenterId = Util.getIntValue(request.getParameter("agent_"+i+"_agenterId"),0);
      String beginDate = Util.fromScreen(request.getParameter("agent_"+i+"_beginDate"),user.getLanguage());
      String beginTime = Util.fromScreen(request.getParameter("agent_"+i+"_beginTime"),user.getLanguage());
      String endDate = Util.fromScreen(request.getParameter("agent_"+i+"_endDate"),user.getLanguage());
      String endTime = Util.fromScreen(request.getParameter("agent_"+i+"_endTime"),user.getLanguage());
      int isCreateAgenter= Util.getIntValue(request.getParameter("agent_"+i+"_isCreateAgenter"),0);
      if(beagenterId!=0){
        mWFAgentManager.setWorkflowId(workflowId);
        mWFAgentManager.setBeagenterId(beagenterId);
        mWFAgentManager.setAgenterId(agenterId);
        mWFAgentManager.setBeginDate(beginDate);
        mWFAgentManager.setBeginTime(beginTime);
        mWFAgentManager.setEndDate(endDate);
        mWFAgentManager.setEndTime(endTime);
        mWFAgentManager.setIsCreateAgenter(isCreateAgenter);

        mWFAgentManager.saveAgentInfo();
      }
    }
  }else{
    //具有个人流程代理维护权限，由单据头提交数据
    int beagenterId = Util.getIntValue(request.getParameter("beagenterId"),0);
    int agenterId = Util.getIntValue(request.getParameter("agenterId"),0);
    String beginDate = Util.fromScreen(request.getParameter("beginDate"),user.getLanguage());
    String beginTime = Util.fromScreen(request.getParameter("beginTime"),user.getLanguage());
    String endDate = Util.fromScreen(request.getParameter("endDate"),user.getLanguage());
    String endTime = Util.fromScreen(request.getParameter("endTime"),user.getLanguage());
    int isCreateAgenter= Util.getIntValue(request.getParameter("isCreateAgenter"),0);
    mWFAgentManager.setWorkflowId(workflowId);
    mWFAgentManager.setBeagenterId(beagenterId);
    mWFAgentManager.setAgenterId(agenterId);
    mWFAgentManager.setBeginDate(beginDate);
    mWFAgentManager.setBeginTime(beginTime);
    mWFAgentManager.setEndDate(endDate);
    mWFAgentManager.setEndTime(endTime);
    mWFAgentManager.setIsCreateAgenter(isCreateAgenter);

    mWFAgentManager.delAIFbyWfidBeagenterid();
    mWFAgentManager.saveAgentInfo();
  }
}

if(method.equals("delete")){
  int beagenterId = Util.getIntValue(request.getParameter("beagenterId"),0);
  mWFAgentManager.setWorkflowId(workflowId);
  mWFAgentManager.setBeagenterId(beagenterId);
  mWFAgentManager.delAIFbyWfidBeagenterid();
}

//更新创建人列表
rs.executeSql("select a.nodeid,b.id from workflow_flownode a,workflow_nodegroup b where a.workflowid="+workflowId+" and a.nodetype=0 and a.nodeid=b.nodeid");
if(rs.next()){
  int groupid=rs.getInt("id");
  int nodeid=rs.getInt("nodeid");
  RequestCheckUser.setWorkflowid(workflowId);
  RequestCheckUser.setNodeid(nodeid);
  RequestCheckUser.updateCreateList(groupid);
}

response.sendRedirect("WfAgentList.jsp");

%>