
<%@ page language="java" contentType="application/x-json;charset=UTF-8" %>
<%@ page import="org.json.*" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.workflow.workflow.WorkTypeComInfo" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rsIn" class="weaver.conn.RecordSet" scope="page"/>

<%
String node=Util.null2String(request.getParameter("node"));
String arrNode[]=Util.TokenizerString2(node,"_");
String type=arrNode[0];
String value=arrNode[1];

String flowids="";
ArrayList flowidList=new ArrayList();

String scope = Util.null2String(request.getParameter("scope"));
String initvalue = Util.null2String(request.getParameter("initvalue"));
String formids = Util.null2String(request.getParameter("formids"));

rs.executeSql("select * from mobileconfig where mc_type=5 and mc_scope="+scope+" and mc_name='flowids' ");
if(rs.next()){
	flowids=Util.null2String(rs.getString("mc_value"));
}

if(initvalue!=null&&!"".equals(initvalue)){
	flowids += ","+initvalue;
	flowidList=Util.TokenizerString(flowids,",");
}

JSONArray jsonArrayReturn= new JSONArray();

if("root".equals(type)){ //主目录下的数据
	WorkTypeComInfo wftc=new WorkTypeComInfo();
	while(wftc.next()){	
		JSONObject jsonTypeObj =null;	
		String wfTypeId=wftc.getWorkTypeid();
		String wfTypeName=wftc.getWorkTypename();
		//if("1".equals(wfTypeId)) continue; 
		rs.executeSql("select id,workflowname from workflow_base where isvalid='1' and workflowtype="+wfTypeId +" and  ( isbill=0 or (isbill=1 and formid<0) or (isbill=1 and formid in ("+formids+")))");
		while (rs.next()){
			jsonTypeObj=new JSONObject();
			String wfId=Util.null2String(rs.getString("id"));
			if(flowidList.contains(wfId)){
				jsonTypeObj.put("expanded",true); 
				break;
			}
			
		}
		if(jsonTypeObj!=null){
			jsonTypeObj.put("id","wftype_"+wfTypeId);
			jsonTypeObj.put("text",wfTypeName);
			jsonTypeObj.put("checked",false);	   
			jsonTypeObj.put("draggable",false);
			jsonTypeObj.put("leaf",false);
			jsonArrayReturn.put(jsonTypeObj);
		}
	}
} else if ("wftype".equals(type)){
	rs.executeSql("select id,workflowname from workflow_base where isvalid='1' and workflowtype="+value+" and ( isbill=0 or (isbill=1 and formid<0) or (isbill=1 and formid in ("+formids+")))");
	
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
}
out.println(jsonArrayReturn.toString());
%>
