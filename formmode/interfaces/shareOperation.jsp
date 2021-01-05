<%@ page language="java" pageEncoding="utf-8"%>
<%@ page import="weaver.general.Util" %>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%@page import="weaver.hrm.User"%>
<%@page import="java.net.URLDecoder"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="weaver.formmode.setup.ShareRuleBusiness"%>
<%@page import="weaver.formmode.setup.ModeRightInfo"%>
<%@page import="java.util.Map"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
User user = HrmUserVarify.getUser(request,response);
if (!HrmUserVarify.checkUserRight("ModeSetting:All", user)) {
	response.sendRedirect("/notice/noright.jsp");
	return;
}

String action = Util.null2String(request.getParameter("action"));
if(action.equals("getSelectItem")){
	JSONArray jsonArray = new JSONArray();
	String fieldid = Util.null2String(request.getParameter("fieldid"));
	String sql = "select selectvalue,selectname from workflow_SelectItem where fieldid="+fieldid+" order by selectvalue";
	RecordSet.executeSql(sql);
	while(RecordSet.next()){
		String selectvalue = RecordSet.getString("selectvalue");
		String selectname = RecordSet.getString("selectname");
		JSONObject jsonObject = new JSONObject();
		jsonObject.put("selectvalue",selectvalue);
		jsonObject.put("selectname",selectname);
		jsonArray.add(jsonObject);
	}
	JSONObject jsonObject = new JSONObject();
	jsonObject.put("selectvalue","null");
	jsonObject.put("selectname","null");
	jsonArray.add(jsonObject);
	response.getWriter().write(jsonArray.toString());
	return;
}else if(action.equals("saveCondition")){
	int modeid = Util.getIntValue(request.getParameter("modeid"), -1);
	int rightid = Util.getIntValue(request.getParameter("rightid"), -1);
	int conditiontype = Util.getIntValue(request.getParameter("conditiontype"), -1);
	String rid = "";
	if(conditiontype==1){
		String conditionsql = Util.null2String(request.getParameter("conditionsql"));
		String conditiontext = Util.null2String(request.getParameter("conditiontext"));
		
		String rulexml = request.getParameter("rulexml");
		
		ShareRuleBusiness shareRuleBusiness = new ShareRuleBusiness();
	    rid = shareRuleBusiness.persistenceRule2db(rulexml,modeid,rightid,conditiontype,conditionsql,conditiontext);
	}else{
		//------sql类型重置------
		String sql = "delete from  mode_expressions where rightid="+rightid;
		RecordSet.executeSql(sql);
		sql = "delete from  mode_expressionbase where rightid="+rightid;
		RecordSet.executeSql(sql);
		String conditionsql = Util.null2String(request.getParameter("conditionsqlText"));
		conditionsql = conditionsql.replace("'","''");
		sql = "update moderightinfo set conditiontype=2,conditionsql='"+conditionsql+"',conditiontext=null where id="+rightid;
		RecordSet.executeSql(sql);
		rid = "2";
	}
    
    JSONObject jsonObject = new JSONObject();
	jsonObject.put("ruleid",rid);
	response.getWriter().write(jsonObject.toString());
	return;
}else if(action.equals("cleanCondition")){
	int modeid = Util.getIntValue(request.getParameter("modeid"), -1);
	int rightid = Util.getIntValue(request.getParameter("rightid"), -1);
	
	String sql = "delete from  mode_expressions where rightid="+rightid;
	RecordSet.executeSql(sql);
	sql = "delete from  mode_expressionbase where rightid="+rightid;
	RecordSet.executeSql(sql);
	sql = "update moderightinfo set conditiontype=null,conditionsql=null,conditiontext=null where id="+rightid;
	RecordSet.executeSql(sql);
	
    JSONObject jsonObject = new JSONObject();
	jsonObject.put("rightid",rightid);
	response.getWriter().write(jsonObject.toString());
	return;
}else if(action.equals("checkSQL")){
	int rightid = Util.getIntValue(request.getParameter("rightid"), -1);
	ModeRightInfo modeRightInfo = new ModeRightInfo();
	JSONObject jsonObject = modeRightInfo.checkShareSQL(rightid);
	response.getWriter().write(jsonObject.toString());
	return;
}
%>


