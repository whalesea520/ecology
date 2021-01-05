<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.workflow.action.WorkflowActionManager"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%

String operation = Util.null2String(request.getParameter("operation"));
int isremind = Util.getIntValue(Util.null2String(request.getParameter("isremind")),0); 
int remindtype = Util.getIntValue(Util.null2String(request.getParameter("remindtype")),0); 
if(operation.equals("saveset")){
	String sql = "delete from mode_carremindset";
	RecordSet.execute(sql);
	sql = "insert into mode_carremindset(isremind,remindtype) values ('"+isremind+"','"+remindtype+"')";
	RecordSet.execute(sql);
	//设置信息
	//sql = "select * from carbasic";
	//RecordSet.executeSql(sql);
	//while(RecordSet.next()){
	//	int workflowid = RecordSet.getInt("workflowid");
	//	if (rs.getDBType().equals("oracle")||rs.getDBType().equals("db2")) {
	//		rs.executeSql(" select b.id as triggerNodeId,a.nodeType as triggerNodeType,b.nodeName as triggerNodeName from workflow_flownode a,workflow_nodebase b where (b.IsFreeNode is null or b.IsFreeNode!='1') and a.nodeId=b.id and a.workFlowId is not null and a.workFlowId= "+workflowid+"  order by a.nodeType,a.nodeId  ");
	//	}else{
	//		rs.executeSql(" select b.id as triggerNodeId,a.nodeType as triggerNodeType,b.nodeName as triggerNodeName from workflow_flownode a,workflow_nodebase b where (b.IsFreeNode is null or b.IsFreeNode!='1') and a.nodeId=b.id and a.workFlowId !='' and a.workFlowId= "+workflowid+"  order by a.nodeType,a.nodeId  ");
	//	}
	//	while(rs.next()) { //循环节点
	//		int triggerNodeId = rs.getInt("triggerNodeId");
	//		int triggerType = rs.getInt("triggerNodeType");
	//		int actionid = 0;
	//		sql = "select id from workflowactionset where workflowid="+workflowid+" and nodeid="+triggerNodeId+" and  actionname='WFCarAction' and Nodelinkid=0";
	//		rs1.executeSql(sql);
	//		if(rs1.next()){
	//			actionid = Util.getIntValue(rs1.getString("id"), 0);
	//		}
	//		String actionname = "WFCarAction";
	//    	WorkflowActionManager workflowActionManager = new WorkflowActionManager();
	//    	workflowActionManager.setActionid(actionid);//新建 actionid==0
	//		workflowActionManager.setWorkflowid(workflowid);
	//		workflowActionManager.setNodeid(triggerNodeId);
	//		workflowActionManager.setActionorder(0);
	//		workflowActionManager.setNodelinkid(0);
	//		workflowActionManager.setIspreoperator(triggerType);
	//		workflowActionManager.setActionname(actionname);
	//		workflowActionManager.setInterfaceid(actionname);
	//		workflowActionManager.setInterfacetype(3);
	//		if(isremind==1){
	//			workflowActionManager.setIsused(1);//是否启用 0不启用 1启用
	//		}else{
	//			workflowActionManager.setIsused(0);//是否启用 0不启用 1启用
	//		}
	//		workflowActionManager.doSaveWsAction();
	//	}
	//}
}
response.sendRedirect("CarSetIframe.jsp");
%>
