<%@ page language="java" contentType="text/html; charset=UTF-8" %>
 <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.TimeUtil"%>
<%@ page import="weaver.conn.RecordSet"%>
<%@ page import="weaver.workflow.request.RequestAddShareInfo"%>
<%@ page import="weaver.general.GCONST" %> 
<%@ page import="weaver.general.IsGovProj" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.workflow.search.WfAdvanceSearchUtil" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="SearchClause" class="weaver.search.SearchClause" scope="session" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page"/>
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="WorkflowSearchCustom" class="weaver.workflow.search.WorkflowSearchCustom" scope="page"/>
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page" />
<jsp:useBean id="dateutil" class="weaver.general.DateUtil" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs4" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="wfAgentCondition" class="weaver.workflow.request.wfAgentCondition" scope="page" />
<%
int agentid = Util.getIntValue(request.getParameter("agentid"),-1);
String currentDate=TimeUtil.getCurrentDateString();
String currentTime=(TimeUtil.getCurrentTimeString()).substring(11,19);
String infoKey="0";;
int agenterid=0;
int beagenterid=0;
String workflowid="";
String _beginDate="";
String _beginTime="";
String _endDate="";
String _endTime="";
String _isCreateAgenter="";
String _isProxyDeal="";
String _isPendThing="";
String _agenttype="";
rs.executeSql("select workflowid,agenterid,beagenterid,beginDate,beginTime,endDate,endTime,ispending,isCreateAgenter,agenttype from workflow_Agent  where agentId="+agentid);
if(rs.next()){
	workflowid=Util.null2String(rs.getString("workflowid"));
	agenterid=Util.getIntValue(rs.getString("agenterid"),0);
	beagenterid=Util.getIntValue(rs.getString("beagenterid"),0);
	_beginDate=Util.null2String(rs.getString("beginDate"));
	_beginTime=Util.null2String(rs.getString("beginTime"));
	_endDate=Util.null2String(rs.getString("endDate"));
	_endTime=Util.null2String(rs.getString("endTime"));
	_isPendThing=Util.null2String(rs.getString("ispending"));
	//_isProxyDeal=Util.null2String(rs.getString("isProxyDeal"));
	_isCreateAgenter=Util.null2String(rs.getString("isCreateAgenter"));
	_agenttype=Util.null2String(rs.getString("agenttype"));
}
_isProxyDeal=wfAgentCondition.isProxyDeal(""+agentid,""+_agenttype);

String workflowname=WorkflowComInfo.getWorkflowname(String.valueOf(workflowid));
String formid="";
String isbill="";
rs.executeSql("select formid,isbill from workflow_base where id='"+workflowid+"'");
if(rs.next()){//formid,isbill
	formid=Util.null2String(rs.getString("formid"));
	isbill=Util.null2String(rs.getString("isbill"));
}
String types= Util.null2String(request.getParameter("types"));
String method=Util.null2String(request.getParameter("method"));
int overlapAgenttypes=Util.getIntValue(request.getParameter("overlapAgenttypes"),-1);
String overlapagentstrids=Util.null2String(request.getParameter("overlapagentstrids"));
if(method.equals("addAgent")){
	if(overlapAgenttypes>0){
		if(overlapAgenttypes==1){ 
			 wfAgentCondition.deleteConditSet(""+agentid,workflowid);
			 String[] check_node = request.getParameterValues("check_node"); 
			 int rowsum = Util.getIntValue(Util.null2String(request.getParameter("groupnum")));
				 for(int i=0;i<rowsum;i++){
				 	String group_agenterId=Util.null2String(request.getParameter("group_"+i+"_agenterId"));
				 	String group_isCreateAgenter=Util.null2String(request.getParameter("group_"+i+"_isCreateAgenter"));
				 	String group_isProxyDeal=Util.null2String(request.getParameter("group_"+i+"_isProxyDeal"));
				 	String group_isPendThing=Util.null2String(request.getParameter("group_"+i+"_isPendThing"));
				 	String group_conditionss=Util.null2String(request.getParameter("group_"+i+"_conditionss"));
				 	String group_conditioncn=Util.null2String(request.getParameter("group_"+i+"_conditioncn"));
				 	String group_conditionkeyid=Util.null2String(request.getParameter("group_"+i+"_conditionkeyid"));
				 	String group_ruleRelationship=Util.null2String(request.getParameter("group_"+i+"_ruleRelationship"));
				 	String group_beagenterid=Util.null2String(request.getParameter("group_"+i+"_beagenterid"));
				 	String group_agentid=Util.null2String(request.getParameter("group_"+i+"_agentid"));
				 	String group_beginDate=Util.null2String(request.getParameter("group_"+i+"_beginDate"));
				 	String group_beginTime=Util.null2String(request.getParameter("group_"+i+"_beginTime"));
				 	String group_endDate=Util.null2String(request.getParameter("group_"+i+"_endDate"));
				 	String group_endTime=Util.null2String(request.getParameter("group_"+i+"_endTime"));
				 	String group_agentbatch=Util.null2String(request.getParameter("group_"+i+"_agentbatch"));
				 	if(!group_beagenterid.equals("")&&!group_agenterId.equals("")){
				 		String overlapAgent=wfAgentCondition.getIsAgent_agein(""+group_beagenterid,"",group_beginDate,group_beginTime,group_endDate,group_endTime,""+workflowid,""+group_isCreateAgenter,""+group_isProxyDeal,""+group_isPendThing);
				 		if(Util.getIntValue(overlapAgent,0)>0){ 
			        		continue;
			        	}else{
				 		   wfAgentCondition.insertAgentConditionSet(group_agenterId,group_isCreateAgenter,group_isProxyDeal,group_isPendThing,group_conditionss,group_conditioncn,group_beagenterid,group_beginDate,group_beginTime,group_endDate,group_endTime,group_agentbatch,""+agentid,group_conditionkeyid,workflowid,""+user.getUID(),currentDate,currentTime,"","","",_agenttype,group_ruleRelationship);
			        	}
				 	}
					infoKey="1";
			 	}
				 String retustr=wfAgentCondition.getAgentType(""+agentid);
				 if(retustr.equals("1")){
				 	wfAgentCondition.again_agent_wf(""+beagenterid,""+workflowid,_beginDate,_beginTime,_endDate,_endTime,user,"agentconditonset",""+agentid);
				 }
			
		}else{  
			 rs4.executeSql("select workflowid,agentid,bagentuid,agentuid from workflow_agentConditionSet where agentid in("+overlapagentstrids+") and agenttype='1' ");
	   		 while(rs4.next()){
	   			 String workflowidold=Util.null2String(rs4.getString("workflowid"));
	   			 String agentidold=Util.null2String(rs4.getString("agentid"));
	   		 	 String bagentuidold=Util.null2String(rs4.getString("bagentuid"));
	   		 	 String agentuidold=Util.null2String(rs4.getString("agentuid"));
	   		     wfAgentCondition.Agent_to_recover(bagentuidold,workflowid,agentidold,"agentcondittype",agentuidold);
	   		 }	
			 wfAgentCondition.deleteConditSet(""+agentid,workflowid);
			 String[] check_node = request.getParameterValues("check_node"); 
			 int rowsum = Util.getIntValue(Util.null2String(request.getParameter("groupnum")));
				 for(int i=0;i<rowsum;i++){
				 	String group_agenterId=Util.null2String(request.getParameter("group_"+i+"_agenterId"));
				 	String group_isCreateAgenter=Util.null2String(request.getParameter("group_"+i+"_isCreateAgenter"));
				 	String group_isProxyDeal=Util.null2String(request.getParameter("group_"+i+"_isProxyDeal"));
				 	String group_isPendThing=Util.null2String(request.getParameter("group_"+i+"_isPendThing"));
				 	String group_conditionss=Util.null2String(request.getParameter("group_"+i+"_conditionss"));
				 	String group_conditioncn=Util.null2String(request.getParameter("group_"+i+"_conditioncn"));
				 	String group_conditionkeyid=Util.null2String(request.getParameter("group_"+i+"_conditionkeyid"));
				 	String group_ruleRelationship=Util.null2String(request.getParameter("group_"+i+"_ruleRelationship"));
				 	String group_beagenterid=Util.null2String(request.getParameter("group_"+i+"_beagenterid"));
				 	String group_agentid=Util.null2String(request.getParameter("group_"+i+"_agentid"));
				 	String group_beginDate=Util.null2String(request.getParameter("group_"+i+"_beginDate"));
				 	String group_beginTime=Util.null2String(request.getParameter("group_"+i+"_beginTime"));
				 	String group_endDate=Util.null2String(request.getParameter("group_"+i+"_endDate"));
				 	String group_endTime=Util.null2String(request.getParameter("group_"+i+"_endTime"));
				 	String group_agentbatch=Util.null2String(request.getParameter("group_"+i+"_agentbatch"));
				 	if(!group_beagenterid.equals("")&&!group_agenterId.equals("")){
				 		wfAgentCondition.insertAgentConditionSet(group_agenterId,group_isCreateAgenter,group_isProxyDeal,group_isPendThing,group_conditionss,group_conditioncn,group_beagenterid,group_beginDate,group_beginTime,group_endDate,group_endTime,group_agentbatch,""+agentid,group_conditionkeyid,workflowid,""+user.getUID(),currentDate,currentTime,"","","",_agenttype,group_ruleRelationship);
				 	}
					infoKey="1";
			 	}
				 String retustr=wfAgentCondition.getAgentType(""+agentid);
				 if(retustr.equals("1")){
				 	wfAgentCondition.again_agent_wf(""+beagenterid,""+workflowid,_beginDate,_beginTime,_endDate,_endTime,user,"agentconditonset",""+agentid);
				 }
		}
		
	}else{
		 wfAgentCondition.deleteConditSet(""+agentid,workflowid);
		 String[] check_node = request.getParameterValues("check_node"); 
		 int rowsum = Util.getIntValue(Util.null2String(request.getParameter("groupnum")));
			 for(int i=0;i<rowsum;i++){
			 	String group_agenterId=Util.null2String(request.getParameter("group_"+i+"_agenterId"));
			 	String group_isCreateAgenter=Util.null2String(request.getParameter("group_"+i+"_isCreateAgenter"));
			 	String group_isProxyDeal=Util.null2String(request.getParameter("group_"+i+"_isProxyDeal"));
			 	String group_isPendThing=Util.null2String(request.getParameter("group_"+i+"_isPendThing"));
			 	String group_conditionss=Util.null2String(request.getParameter("group_"+i+"_conditionss"));
			 	String group_conditioncn=Util.null2String(request.getParameter("group_"+i+"_conditioncn"));
			 	String group_conditionkeyid=Util.null2String(request.getParameter("group_"+i+"_conditionkeyid"));
				String group_ruleRelationship=Util.null2String(request.getParameter("group_"+i+"_ruleRelationship"));
			 	
			 	String group_beagenterid=Util.null2String(request.getParameter("group_"+i+"_beagenterid"));
			 	String group_agentid=Util.null2String(request.getParameter("group_"+i+"_agentid"));
			 	String group_beginDate=Util.null2String(request.getParameter("group_"+i+"_beginDate"));
			 	String group_beginTime=Util.null2String(request.getParameter("group_"+i+"_beginTime"));
			 	String group_endDate=Util.null2String(request.getParameter("group_"+i+"_endDate"));
			 	String group_endTime=Util.null2String(request.getParameter("group_"+i+"_endTime"));
			 	String group_agentbatch=Util.null2String(request.getParameter("group_"+i+"_agentbatch"));
			 	if(!group_beagenterid.equals("")&&!group_agenterId.equals("")){
			 		wfAgentCondition.insertAgentConditionSet(group_agenterId,group_isCreateAgenter,group_isProxyDeal,group_isPendThing,group_conditionss,group_conditioncn,group_beagenterid,group_beginDate,group_beginTime,group_endDate,group_endTime,group_agentbatch,""+agentid,group_conditionkeyid,workflowid,""+user.getUID(),currentDate,currentTime,"","","",_agenttype,group_ruleRelationship);
			 	}
				infoKey="1";
		 	}
			 String retustr=wfAgentCondition.getAgentType(""+agentid);
			 if(retustr.equals("1")){
			 	wfAgentCondition.again_agent_wf(""+beagenterid,""+workflowid,_beginDate,_beginTime,_endDate,_endTime,user,"agentconditonset",""+agentid);
			 }
	}
}
  response.sendRedirect("/workflow/request/wfAgentCondition.jsp?types="+types+"&infoKey="+infoKey+"&isclose=1&agentid="+agentid);
    return;  //xwj for td3218 20051201		 
		 

%>