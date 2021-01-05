<%@page import="weaver.fna.budget.FnaWfSetCache"%>
<%@page import="weaver.fna.budget.FnaWfSet"%>
<%@page import="weaver.general.BaseBean"%>
<%@page import="org.apache.commons.lang.StringEscapeUtils"%>
<%@page import="java.util.Calendar"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<%@ page import="weaver.general.Util" %>
<%@page import="org.json.JSONObject"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
User user = HrmUserVarify.getUser (request , response) ;

if(!HrmUserVarify.checkUserRight("fnaControlScheme:set", user)){
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}

Calendar today = Calendar.getInstance();
String currentdate = Util.add0(today.get(Calendar.YEAR), 4) + "-" +
		Util.add0(today.get(Calendar.MONTH) + 1, 2) + "-" +
		Util.add0(today.get(Calendar.DAY_OF_MONTH), 2);
String currenttime = Util.add0(today.get(Calendar.HOUR_OF_DAY), 2) + ":" +
		Util.add0(today.get(Calendar.MINUTE), 2) + ":" +
		Util.add0(today.get(Calendar.SECOND), 2);

String operation = Util.null2String(request.getParameter("operation"));

if(operation.equals("add")){//新增：费控方案 基本信息
	String name = Util.null2String(request.getParameter("name")).trim();
	String code = Util.null2String(request.getParameter("code")).trim();
	int fnayearid = Util.getIntValue(request.getParameter("fnayearid"), 0);
	int fnayearidEnd = Util.getIntValue(request.getParameter("fnayearidEnd"), 0);
	int enabled = Util.getIntValue(request.getParameter("enabled"), 0);
	String FeeWfInfoIds = Util.null2String(request.getParameter("FeeWfInfoIds")).trim();
	
	String fnayearidEndStr = "NULL";
	if(fnayearidEnd>0){
		fnayearidEndStr = fnayearidEnd+"";
	}
	
	String sql = "select count(*) cnt from fnaControlScheme where name = '"+StringEscapeUtils.escapeSql(name)+"'";
	rs.executeSql(sql);
	if(rs.next() && rs.getInt("cnt") > 0){
		out.println("{\"flag\":false,\"msg\":"+JSONObject.quote(SystemEnv.getHtmlLabelName(26603,user.getLanguage()))+"}");//名称重复
		out.flush();
		return;
		
	}else{
		sql = "select count(*) cnt from fnaControlScheme where code = '"+StringEscapeUtils.escapeSql(code)+"'";
		rs.executeSql(sql);
		if(!"".equals(code) && rs.next() && rs.getInt("cnt") > 0){
			out.println("{\"flag\":false,\"msg\":"+JSONObject.quote(SystemEnv.getHtmlLabelName(33168,user.getLanguage()))+"}");//编码重复
			out.flush();
			return;
			
		}else{
			sql = "INSERT INTO fnaControlScheme \n" +
				" (name, code, fnayearid, fnayearidEnd, enabled)\n" +
				" VALUES\n" +
				" ('"+StringEscapeUtils.escapeSql(name)+"', '"+StringEscapeUtils.escapeSql(code)+"', "+fnayearid+", "+fnayearidEndStr+", "+enabled+")";
			rs.executeSql(sql);
		
			int id = -1;
			sql = "select id from fnaControlScheme where name = '"+StringEscapeUtils.escapeSql(name)+"'";
			rs.executeSql(sql);
			if(rs.next()){
				id = rs.getInt("id");
			}
			
			//清除所有费用报销流程-校验方案/校验规则-SQL数据存对象
			FnaWfSetCache.clearAllFnaControlSchemeAll();

			out.println("{\"flag\":true,\"msg\":"+JSONObject.quote(SystemEnv.getHtmlLabelName(18758,user.getLanguage()))+",\"id\":"+id+"}");//保存成功
			out.flush();
			return;
		}
	}
	
}else if(operation.equals("edit")){//编辑：费控方案 基本信息
	int id = Util.getIntValue(request.getParameter("id"), 0);
	String name = Util.null2String(request.getParameter("name")).trim();
	String code = Util.null2String(request.getParameter("code")).trim();
	int fnayearid = Util.getIntValue(request.getParameter("fnayearid"), 0);
	int fnayearidEnd = Util.getIntValue(request.getParameter("fnayearidEnd"), 0);
	int enabled = Util.getIntValue(request.getParameter("enabled"), 0);
	String FeeWfInfoIds = Util.null2String(request.getParameter("FeeWfInfoIds")).trim();
	
	String fnayearidEndStr = "NULL";
	if(fnayearidEnd>0){
		fnayearidEndStr = fnayearidEnd+"";
	}
	
	String sql = "select count(*) cnt from fnaControlScheme where name = '"+StringEscapeUtils.escapeSql(name)+"' and id <> "+id;
	rs.executeSql(sql);
	if(rs.next() && rs.getInt("cnt") > 0){
		out.println("{\"flag\":false,\"msg\":"+JSONObject.quote(SystemEnv.getHtmlLabelName(26603,user.getLanguage()))+"}");//名称重复
		out.flush();
		return;
		
	}else{
		sql = "select count(*) cnt from fnaControlScheme where code = '"+StringEscapeUtils.escapeSql(code)+"' and id <> "+id;
		rs.executeSql(sql);
		if(!"".equals(code) && rs.next() && rs.getInt("cnt") > 0){
			out.println("{\"flag\":false,\"msg\":"+JSONObject.quote(SystemEnv.getHtmlLabelName(33168,user.getLanguage()))+"}");//编码重复
			out.flush();
			return;
			
		}else{
			sql = "update fnaControlScheme \n" +
				" set name='"+StringEscapeUtils.escapeSql(name)+"', "+
				" code='"+StringEscapeUtils.escapeSql(code)+"', "+
				" fnayearid="+fnayearid+", "+
				" fnayearidEnd="+fnayearidEndStr+", "+
				" enabled="+enabled+" " +
				" where id = "+id;
			rs.executeSql(sql);
			
			//清除所有费用报销流程-校验方案/校验规则-SQL数据存对象
			FnaWfSetCache.clearAllFnaControlSchemeAll();

			out.println("{\"flag\":true,\"msg\":"+JSONObject.quote(SystemEnv.getHtmlLabelName(18758,user.getLanguage()))+",\"id\":"+id+"}");//保存成功
			out.flush();
			return;
		}
	}
	
}else if(operation.equals("del") || operation.equals("batchDel")){//删除、批量删除费控流程
	String ids = Util.null2String(request.getParameter("ids"))+"-1";
	if(operation.equals("del")){
		ids = Util.null2String(request.getParameter("id"));
	}
	
	String sql = "";

	sql = "delete from fnaControlScheme_FeeWfInfo where fnaControlSchemeId in ("+ids+")";
	rs.executeSql(sql);

	sql = "delete from fnaControlSchemeDtl where mainid in ("+ids+")";
	rs.executeSql(sql);

	sql = "delete from fnaControlScheme where id in ("+ids+")";
	rs.executeSql(sql);
	
	//清除所有费用报销流程-校验方案/校验规则-SQL数据存对象
	FnaWfSetCache.clearAllFnaControlSchemeAll();
	
	out.println("{\"flag\":true,\"msg\":"+JSONObject.quote(SystemEnv.getHtmlLabelName(20461,user.getLanguage()))+"}");//删除成功
	out.flush();
	return;
	
}else if(operation.equals("enable")){//启用、禁用 费控流程
	int id = Util.getIntValue(request.getParameter("id"));
	int enabled = 0;
	
	String sql = "select enabled from fnaControlScheme where id = "+id;
	rs.executeSql(sql);
	if(rs.next()){
		enabled = rs.getInt("enabled");
		
		if(enabled == 1){
			enabled = 0;
		}else{
			enabled = 1;
		}

		sql = "update fnaControlScheme set enabled = "+enabled+" where id = "+id;
		rs.executeSql(sql);
	}
	
	out.println("{\"flag\":true,\"msg\":"+JSONObject.quote("")+",\"enable\":"+enabled+"}");
	out.flush();
	return;
	
}else if(operation.equals("FnaControlSchemeSetLogic")){//保存：校验逻辑设置
	int mainId = Util.getIntValue(request.getParameter("mainId"), 0);
	int id = Util.getIntValue(request.getParameter("id"), 0);
	int workflowid = Util.getIntValue(request.getParameter("workflowid"), 0);

	int intensity = Util.getIntValue(request.getParameter("intensity"), 0);
	int kmIdsCondition = Util.getIntValue(request.getParameter("kmIdsCondition"), 0);
	int orgIdsCondition = Util.getIntValue(request.getParameter("orgIdsCondition"), 0);
	String subjectId = Util.null2String(request.getParameter("subjectId")).trim();
	int orgType = Util.getIntValue(request.getParameter("orgType"), 0);
	String subId = Util.null2String(request.getParameter("subId")).trim();
	String depId = Util.null2String(request.getParameter("depId")).trim();
	String hrmId = Util.null2String(request.getParameter("hrmId")).trim();
	String fccId = Util.null2String(request.getParameter("fccId")).trim();
	String promptSC = Util.null2String(request.getParameter("promptSC")).trim();
	String promptEN = Util.null2String(request.getParameter("promptEN")).trim();
	String promptTC = Util.null2String(request.getParameter("promptTC")).trim();
	
	String sql = "";
	
	FnaWfSet.saveFnaControlSchemeSetLogic(mainId, id, 
			intensity, kmIdsCondition, subjectId, 
			orgIdsCondition, orgType, subId, depId, hrmId, fccId, 
			promptSC, promptEN, promptTC);
	
	//清除所有费用报销流程-校验方案/校验规则-SQL数据存对象
	FnaWfSetCache.clearAllFnaControlSchemeAll();
	
	out.println("{\"flag\":true,\"msg\":"+JSONObject.quote(SystemEnv.getHtmlLabelName(18758,user.getLanguage()))+"}");//保存成功
	out.flush();
	return;
	
}else if(operation.equals("FnaControlSchemeSetLogicDel") || operation.equals("batchFnaControlSchemeSetLogicDel")){//删除：校验逻辑设置
	int mainId = Util.getIntValue(request.getParameter("mainId"), 0);

	String ids = Util.null2String(request.getParameter("ids"))+"-1";
	if(operation.equals("FnaControlSchemeSetLogicDel")){
		ids = Util.null2String(request.getParameter("id"));
	}
	
	String sql = "";

	sql = "delete from fnaControlSchemeDtl where id in ("+ids+")";
	rs.executeSql(sql);
	
	//清除所有费用报销流程-校验方案/校验规则-SQL数据存对象
	FnaWfSetCache.clearAllFnaControlSchemeAll();
	
	out.println("{\"flag\":true,\"msg\":"+JSONObject.quote(SystemEnv.getHtmlLabelName(20461,user.getLanguage()))+"}");//删除成功
	out.flush();
	return;
	
}
%>
