
<%@ page language="java" contentType="application/x-json;charset=UTF-8" %>
<%@ page import="org.json.*" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*,weaver.hrm.*" %>
<%@ page import="weaver.workflow.workflow.WorkTypeComInfo" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rsIn" class="weaver.conn.RecordSet" scope="page"/>

<%
String node=Util.null2String(request.getParameter("node")); 

String arrNode[]=Util.TokenizerString2(node,"_");
String type=arrNode[0];
String value=arrNode[1];


ArrayList typeidList=new ArrayList();
ArrayList flowidList=new ArrayList();
boolean init = true;
User user = HrmUserVarify.getUser (request , response) ;
rs.executeSql("select ids from SysPoppupRemindInfoConfig where resourceid="+user.getUID()+" and id_type = 'typeids'");
while(rs.next()){
	typeidList.add(rs.getString("ids"));
}

rs.executeSql("select ids from SysPoppupRemindInfoConfig where resourceid="+user.getUID()+" and id_type = 'flowids'");
while(rs.next()){
	flowidList.add(rs.getString("ids"));
}

if(typeidList.size()==0&&flowidList.size()==0){
	init = false;
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
		if(init&&!typeidList.contains(wfTypeId)){
			jsonTypeObj.put("checked",false);	   
		} else {
			rs.executeSql("select count(*) as count from workflow_base where isvalid='1' and workflowtype="+wfTypeId);
			rs.next();
			if(rs.getInt("count")>0){
				jsonTypeObj.put("checked",true);
				jsonTypeObj.put("expanded",true);
			}else{
				jsonTypeObj.put("checked",false);
			}
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
		if(init&&!flowidList.contains(wfId)){
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
