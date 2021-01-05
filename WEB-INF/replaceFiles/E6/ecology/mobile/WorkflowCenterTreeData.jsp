
<%@ page language="java" contentType="application/x-json;charset=UTF-8" %>
<%@ page import="org.json.*" %>
<%@ page import="weaver.general.Util,weaver.hrm.*" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.workflow.workflow.WorkTypeComInfo" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rsIn" class="weaver.conn.RecordSet" scope="page"/>

<%

User user = HrmUserVarify.getUser(request, response);
if(user==null) {
	return;
}

String node=Util.null2String(request.getParameter("node")); 

String arrNode[]=Util.TokenizerString2(node,"_");
String type=arrNode[0];
String value=arrNode[1];

String scope = Util.null2String(request.getParameter("scope"));


if(!"".equals(scope) && !scope.matches("^[a-z0-9_A-Z]*$")){
	rs.writeLog("workflowcentertreedata.jsp intercept: scope = "+scope);
	return;
}

if(!"".equals(node) && !node.matches("^[a-z0-9_A-Z]*$")){
	rs.writeLog("workflowcentertreedata.jsp intercept: node = "+node);
	return;
}

String typeids="";
String flowids="";
String nodeids="";
ArrayList typeidList=new ArrayList();
ArrayList flowidList=new ArrayList();
ArrayList nodeidList=new ArrayList();

rs.executeSql("select * from mobileconfig where mc_type=5 and mc_scope="+scope+" and mc_name='typeids' ");
if(rs.next()){
	typeids=Util.null2String(rs.getString("mc_value")); 
	typeidList=Util.TokenizerString(typeids,",");
}

rs.executeSql("select * from mobileconfig where mc_type=5 and mc_scope="+scope+" and mc_name='flowids' ");
if(rs.next()){
	flowids=Util.null2String(rs.getString("mc_value"));
	flowidList=Util.TokenizerString(flowids,",");
}

rs.executeSql("select * from mobileconfig where mc_type=5 and mc_scope="+scope+" and mc_name='nodeids' ");
if(rs.next()){
	nodeids=Util.null2String(rs.getString("mc_value")); 
	nodeidList=Util.TokenizerString(nodeids,",");
}


JSONArray jsonArrayReturn= new JSONArray();

if("root".equals(type)){ //主目录下的数据
	WorkTypeComInfo wftc=new WorkTypeComInfo();
	while(wftc.next()){	
		JSONObject jsonTypeObj=new JSONObject();	
		String wfTypeId=wftc.getWorkTypeid();
		String wfTypeName=wftc.getWorkTypename();
		//if("1".equals(wfTypeId)) continue; 
		jsonTypeObj.put("id","wftype_"+wfTypeId);
		jsonTypeObj.put("text",wfTypeName);
		if(!typeidList.contains(wfTypeId)){
			jsonTypeObj.put("checked",false);	   
		} else {
			jsonTypeObj.put("checked",true);
			jsonTypeObj.put("expanded",true);
		}
	    jsonTypeObj.put("draggable",false);
	    jsonTypeObj.put("leaf",false);
		jsonArrayReturn.put(jsonTypeObj);
	}
} else if ("wftype".equals(type)){
	rs.executeSql("select id,workflowname from workflow_base where isvalid='1' and workflowtype="+value);
	
	while (rs.next()){
		
		JSONObject jsonWfObj=new JSONObject();	
		String wfId=Util.null2String(rs.getString("id"));
		String wfName=Util.null2String(rs.getString("workflowname"));
		jsonWfObj.put("id","wf_"+wfId);
		jsonWfObj.put("text",wfName);
		jsonWfObj.put("draggable",false);

		if(!flowidList.contains(wfId)){
			jsonWfObj.put("checked",false);	   
		} else {
			jsonWfObj.put("checked",true);
			jsonWfObj.put("expanded",true);
		}
		jsonWfObj.put("leaf",true);
		jsonArrayReturn.put(jsonWfObj);
	} 	
}else {
	rsIn.executeSql("select a.nodeId,b.nodeName,a.nodeType from  workflow_flownode a,workflow_nodebase b where (b.IsFreeNode is null or b.IsFreeNode!='1') and a.nodeId=b.id  and a.workflowId="+value+" order by nodetype");

	JSONArray jsonNodeArrayObj= new JSONArray();
	while (rsIn.next()){
		int nodeType=Util.getIntValue(rsIn.getString("nodeType"));

		JSONObject jsonNodeObj=new JSONObject();	
		String nodeId=Util.null2String(rsIn.getString("nodeId"));
		String nodeName=Util.null2String(rsIn.getString("nodeName"));
		jsonNodeObj.put("id","node_"+nodeId);
		jsonNodeObj.put("text",nodeName);
		jsonNodeObj.put("leaf",true);
		jsonNodeObj.put("draggable",false);			
		
		if(!nodeidList.contains(nodeId)){
			jsonNodeObj.put("checked",false);	   
		} else {
			jsonNodeObj.put("checked",true);
			jsonNodeObj.put("expanded",true);
		}
		jsonNodeObj.put("leaf",true);
		
		jsonArrayReturn.put(jsonNodeObj);		
	}
}
out.println(jsonArrayReturn.toString());
%>
