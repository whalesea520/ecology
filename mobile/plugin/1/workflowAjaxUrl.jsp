<%@page import="weaver.systeminfo.SystemEnv"%>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@ page import="weaver.conn.*" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.*"%>
<%@ page import="weaver.mobile.webservices.workflow.WorkflowCheckCharacter"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="org.json.JSONArray"%>
<%@page import="org.json.JSONObject"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>


<%
User user = HrmUserVarify.getUser (request , response) ;
if(user==null) {
    response.sendRedirect("/login/Login.jsp");
    return;
}

String operator = Util.null2String(request.getParameter("operator"));
String signtype = Util.null2String(request.getParameter("signtype"));
String currentNodeType = Util.null2String(request.getParameter("currentNodeType"));
String freeNodeId = Util.null2String(request.getParameter("freeNodeId"));
int requestid = Util.getIntValue(request.getParameter("requestid"), -1);
String messagerurl = "";
String sex = "";
String isemptyurl = "0";//是否有图像
String afternode = "0";//是否审批过，0、1、2  未审批、审批、当前节点
String currentoperator = "";//流程当前节点操作者
boolean needcheck = false;

String approvalpersons = "";//未操作者
if(requestid > 0 && "2".equals(signtype)){
	String agentsql = "";
	if(RecordSet.getDBType().equals("oracle")){
		agentsql = "select receivedpersons from WORKFLOW_AGENTPERSONS where requestid = "+requestid + " and receivedpersons is not null and groupdetailid in ( " +
				" SELECT id FROM workflow_groupdetail WHERE groupid IN ( SELECT id FROM workflow_nodegroup WHERE nodeid = " + freeNodeId + ") )";
	}else{
		agentsql = "select receivedpersons from WORKFLOW_AGENTPERSONS where requestid = "+requestid + " and receivedpersons != '' and groupdetailid in ( " +
				" SELECT id FROM workflow_groupdetail WHERE groupid IN ( SELECT id FROM workflow_nodegroup WHERE nodeid = " + freeNodeId + ") )";
	}
	RecordSet.executeSql(agentsql);
	while(RecordSet.next()){
		approvalpersons = Util.null2String(RecordSet.getString("receivedpersons"));
	}
	if(!"".equals(approvalpersons) || !"0".equals(currentNodeType)){
		needcheck = true;
	}
	RecordSet.executeSql("select userid from workflow_currentoperator where requestid = "+requestid+" and isremark = '0'");
	while(RecordSet.next()){
		currentoperator += Util.null2String(RecordSet.getString("userid"));
	}
}
approvalpersons = "," + approvalpersons;

String rtnstring = "[";
if(operator.indexOf(",") > -1){
	String [] array = Util.TokenizerString2(operator, ",");
	for(int i=0;i<array.length;i++){
		String sql = "select id,lastname,messagerurl,sex from hrmresource where id in ("+array[i]+")";
		//System.out.println("创建新节点sql"+sql);
		RecordSet.executeSql(sql);
		while(RecordSet.next()){
			messagerurl = Util.null2String(RecordSet.getString(3));
			sex = Util.null2String(RecordSet.getString(4));
			if("".equals(messagerurl)){
				if("0".equals(sex)){
					messagerurl = "/messager/images/icon_m_wev8.jpg";
				}else{
					messagerurl = "/messager/images/icon_w_wev8.jpg";
				}
				isemptyurl = "1";
				//System.out.println("needcheck = "+needcheck+"::::"+i);
				if(needcheck){
					if(approvalpersons.indexOf(","+array[i]+",") > -1){
						afternode = "0";
					}else if(currentoperator.equals(array[i])){
						afternode = "2";
					}else{
						afternode = "1";
					}
				}
			}else{
				isemptyurl = "0";
				if(needcheck){
					if(approvalpersons.indexOf(","+array[i]+",") > -1){
						afternode = "0";
					}else if(currentoperator.equals(array[i])){
						afternode = "2";
					}else{
						afternode = "1";
					}
				}
			}
			rtnstring +="{";
			rtnstring += "\"id\":"+RecordSet.getString(1)+",";
			rtnstring += "\"operatname\":\""+RecordSet.getString(2)+"\",";
			rtnstring += "\"pattenname\":\""+WorkflowCheckCharacter.getCharacterName(Util.null2String(RecordSet.getString(2)))+"\",";
			rtnstring += "\"messagerurl\":\""+messagerurl+"\",";
			rtnstring += "\"afternode\":\""+afternode+"\",";
			rtnstring += "\"isemptyurl\":\""+isemptyurl+"\"";
			rtnstring += "}";
			rtnstring += ",";
		}
	}
	if(rtnstring.length() > 1){
		rtnstring = rtnstring.substring(0,rtnstring.length()-1);
	}
}else{
	String sql = "select id,lastname,messagerurl from hrmresource where id in ("+operator+")";
	//System.out.println("创建新节点sql"+sql);
	RecordSet.executeSql(sql);
	while(RecordSet.next()){
		messagerurl = Util.null2String(RecordSet.getString(3));
		sex = Util.null2String(RecordSet.getString(4));
		if("".equals(messagerurl)){
			if("0".equals(sex)){
				messagerurl = "/messager/images/icon_m_wev8.jpg";
			}else{
				messagerurl = "/messager/images/icon_w_wev8.jpg";
			}
			isemptyurl = "1";
			if(needcheck){
				if(approvalpersons.indexOf(","+operator+",") > -1){
					afternode = "0";
				}else if(currentoperator.equals(operator)){
					afternode = "2";
				}else{
					afternode = "1";
				}
			}
		}else{
			isemptyurl = "0";
			if(needcheck){
				if(approvalpersons.indexOf(","+operator+",") > -1){
					afternode = "0";
				}else if(currentoperator.equals(operator)){
					afternode = "2";
				}else{
					afternode = "1";
				}
			}
		}
		rtnstring +="{";
		rtnstring += "\"id\":"+RecordSet.getString(1)+",";
		rtnstring += "\"operatname\":\""+RecordSet.getString(2)+"\",";
		rtnstring += "\"pattenname\":\""+WorkflowCheckCharacter.getCharacterName(Util.null2String(RecordSet.getString(2)))+"\",";
		rtnstring += "\"messagerurl\":\""+messagerurl+"\",";
		rtnstring += "\"afternode\":\""+afternode+"\",";
		rtnstring += "\"isemptyurl\":\""+isemptyurl+"\"";
		rtnstring += "}";
	}
}
rtnstring += "]";
//System.out.println("rtnstring = "+rtnstring);
//out.print(rtnstring);
rtnstring = rtnstring.replaceAll("\\\\", "\\\\\\\\");
response.setContentType("application/json; charset=UTF-8");
java.io.PrintWriter writer = response.getWriter();
writer.write(rtnstring);
writer.flush();
writer.close();
%>
