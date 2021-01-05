<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.*" %>
<%@ page import="net.sf.json.*"%>
<%@ page import="weaver.hrm.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<%@ page import="weaver.workflow.workflow.WorkTypeComInfo" %>
<%
	User user = HrmUserVarify.getUser (request , response) ;
	if(user==null){
		return;
	}
%>
<%
	response.setContentType("text/html;charset=GBK");
	String types = Util.null2String(request.getParameter("types"));
	String flows = Util.null2String(request.getParameter("flows"));
	JSONArray js = new JSONArray();
	try{
		WorkTypeComInfo wftc=new WorkTypeComInfo();
		while(wftc.next()){
			JSONObject jsonTypeObj=new JSONObject();	
			String wfTypeId=wftc.getWorkTypeid();
			String wfTypeName=wftc.getWorkTypename();
			jsonTypeObj.put("id",wfTypeId);
			jsonTypeObj.put("name",wfTypeName);
			jsonTypeObj.put("pId",0);
			jsonTypeObj.put("type",1);
			if(types.indexOf(","+wfTypeId+",")>-1){
				jsonTypeObj.put("checked",true);
			} else {
				jsonTypeObj.put("checked",false);
			}
			js.add(jsonTypeObj);
			rs.executeSql("select id,workflowname from workflow_base where isvalid='1' and workflowtype="+wfTypeId);
			while(rs.next()){
				JSONObject j = new JSONObject();
				j.put("id","flow_"+rs.getString("id"));
				j.put("name",rs.getString("workflowname"));
				j.put("pId",wfTypeId);
				j.put("type",2);
				if(flows.indexOf(","+rs.getString("id")+",")>-1){
					j.put("checked",true);
				}else {
					j.put("checked",false);
				}
				js.add(j);
			}
		}
	}catch(Exception e){
		e.printStackTrace();
	}
	out.println(js.toString());
%>