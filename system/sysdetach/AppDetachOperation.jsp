<jsp:useBean id="adci" class="weaver.hrm.appdetach.AppDetachComInfo" scope="page" />
<%@page import="org.apache.commons.lang.StringEscapeUtils"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%@page import="org.json.JSONObject"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<%
User user = HrmUserVarify.getUser (request , response) ;
if(user==null){
	out.println("{\"flag\":false,\"msg\":"+JSONObject.quote(SystemEnv.getHtmlLabelName(2012,user.getLanguage())+"1")+"}");//对不起，您暂时没有权限！
	out.flush();
	return;
}else{
	if(!HrmUserVarify.checkUserRight("AppDetach:All", user)) {
		out.println("{\"flag\":false,\"msg\":"+JSONObject.quote(SystemEnv.getHtmlLabelName(2012,user.getLanguage())+"2")+"}");//对不起，您暂时没有权限！
		out.flush();
		return;
	}
	
	String operation = Util.null2String(request.getParameter("operation"));
	
	if(operation.equals("add")){//新建
		String returnFlag = "";
	
		String id = "";
		String name = Util.null2String(request.getParameter("name"));
		String description = Util.null2String(request.getParameter("description"));
		
		rs.execute("select count(*) cnt from SysDetachInfo a where a.name = '"+StringEscapeUtils.escapeSql(name)+"'");
		if(rs.next() && rs.getInt("cnt")>0){
			returnFlag = SystemEnv.getHtmlLabelNames("195,18082", user.getLanguage());//名称重复
		}

		if("".equals(returnFlag)){
			rs.executeSql("insert into SysDetachInfo(name,description) values('"+StringEscapeUtils.escapeSql(name)+"','"+StringEscapeUtils.escapeSql(description)+"')");
			rs.executeSql("select max(id) id from SysDetachInfo where name = '"+name+"'");
			rs.next();
			id = rs.getString("id");
		}
		
		if("".equals(returnFlag)){
			out.println("{\"flag\":true,\"msg\":"+JSONObject.quote(SystemEnv.getHtmlLabelName(18758,user.getLanguage()))+",\"id\":\""+id+"\"}");//保存成功
		}else{
			out.println("{\"flag\":false,\"msg\":"+JSONObject.quote(returnFlag)+",\"id\":\""+id+"\"}");//保存失败
		}
		out.flush();
		return;
		
	}else if(operation.equals("editBase")){//保存基本信息
		String returnFlag = "";
	
		int id = Util.getIntValue(request.getParameter("id"));
		String name = Util.null2String(request.getParameter("name"));
		String description = Util.null2String(request.getParameter("description"));
		
		rs.execute("select count(*) cnt from SysDetachInfo a where id<>"+id+" and a.name = '"+StringEscapeUtils.escapeSql(name)+"'");
		if(rs.next() && rs.getInt("cnt")>0){
			returnFlag = SystemEnv.getHtmlLabelNames("195,18082", user.getLanguage());//名称重复
		}

		if("".equals(returnFlag)){
			rs.executeSql("update SysDetachInfo set name = '"+StringEscapeUtils.escapeSql(name)+"', description = '"+StringEscapeUtils.escapeSql(description)+"' where id = "+id);
		}
		
		if("".equals(returnFlag)){
			out.println("{\"flag\":true,\"msg\":"+JSONObject.quote(SystemEnv.getHtmlLabelName(18758,user.getLanguage()))+",\"id\":\""+id+"\"}");//保存成功
		}else{
			out.println("{\"flag\":false,\"msg\":"+JSONObject.quote(returnFlag)+",\"id\":\""+id+"\"}");//保存失败
		}
		out.flush();
		return;
		
	}else if(operation.equals("saveRange")){//保存范围设置
		int mainId = Util.getIntValue(request.getParameter("mainId"));
		int id = Util.getIntValue(request.getParameter("id"));
		String type1 = Util.null2String(request.getParameter("type1")).trim();
		String hrmId = Util.null2String(request.getParameter("hrmId")).trim();
		String subId = Util.null2String(request.getParameter("subId")).trim();
		String depId = Util.null2String(request.getParameter("depId")).trim();
		String roleId = Util.null2String(request.getParameter("roleId")).trim();
		String operator = Util.null2String(request.getParameter("operator")).trim();
		String seclevel = Util.null2String(request.getParameter("seclevel")).trim();
		String seclevelto = Util.null2String(request.getParameter("seclevelto")).trim();
		String rolelevel = Util.null2String(request.getParameter("rolelevel")).trim();
		String iscontains = "";
		String subiscontains = Util.null2String(request.getParameter("subiscontains")).trim();
		String depiscontains = Util.null2String(request.getParameter("depiscontains")).trim();
		
		if(Util.getIntValue(seclevel, -987564) == -987564){
			seclevel = "null";
			operator = "";
		}
		
		if(Util.getIntValue(seclevelto, -987564) == -987564){
			seclevelto = "null";
			operator = "";
		}
		
		String content = "";
		if(type1.equals("1")){//人力资源
			content = hrmId;
			operator = "";
			seclevel = "null";
			seclevelto = "null";
		}else if(type1.equals("2")){//分部
			content = subId;
			iscontains=subiscontains;
		}else if(type1.equals("3")){//部门
			content = depId;
			iscontains=depiscontains;
		}else if(type1.equals("4")){//角色
			content = roleId;
		}
		if(iscontains.length()==0)iscontains="0";
		
		if(id>0){
			rs.executeSql("update SysDetachDetail "+
						" set sourcetype = 1, "+
						" 	content = '"+StringEscapeUtils.escapeSql(content)+"', "+
						" 	seclevel = "+seclevel+", "+
						" 	seclevelto = "+seclevelto+", "+
						" 	type1 = "+Util.getIntValue(type1)+", "+
						" 	operator = '"+StringEscapeUtils.escapeSql(operator)+"', "+
						" 	rolelevel = '"+StringEscapeUtils.escapeSql(rolelevel)+"', "+
						" 	iscontains = "+iscontains+
						" where id = "+id);
		}else{
			rs.executeSql("insert into SysDetachDetail (infoid, sourcetype, content, seclevel, seclevelto, type1, operator, rolelevel,iscontains) values ( "+
					" "+mainId+", "+
					" 1, "+
					" '"+StringEscapeUtils.escapeSql(content)+"', "+
					" "+seclevel+", "+
					" "+seclevelto+", "+
					" "+Util.getIntValue(type1)+", "+
					" '"+StringEscapeUtils.escapeSql(operator)+"', "+
					" '"+StringEscapeUtils.escapeSql(rolelevel)+"', "+
					" "+iscontains+
					" )");
		}
		
		out.println("{\"flag\":true,\"msg\":"+JSONObject.quote(SystemEnv.getHtmlLabelName(18758,user.getLanguage()))+",\"id\":\""+id+"\"}");//保存成功
		out.flush();
		adci.resetAppDetachInfo();
		return;
		
	}else if(operation.equals("saveMembers")){//保存成员设置
		int mainId = Util.getIntValue(request.getParameter("mainId"));
		int id = Util.getIntValue(request.getParameter("id"));
		String type1 = Util.null2String(request.getParameter("type1")).trim();
		String hrmId = Util.null2String(request.getParameter("hrmId")).trim();
		String subId = Util.null2String(request.getParameter("subId")).trim();
		String depId = Util.null2String(request.getParameter("depId")).trim();
		String roleId = Util.null2String(request.getParameter("roleId")).trim();
		String operator = Util.null2String(request.getParameter("operator")).trim();
		String seclevel = Util.null2String(request.getParameter("seclevel")).trim();
		String seclevelto = Util.null2String(request.getParameter("seclevelto")).trim();
		String rolelevel = Util.null2String(request.getParameter("rolelevel")).trim();
		String iscontains = "";
		String subiscontains = Util.null2String(request.getParameter("subiscontains")).trim();
		String depiscontains = Util.null2String(request.getParameter("depiscontains")).trim();
		
		if(Util.getIntValue(seclevel, -987564) == -987564){
			seclevel = "null";
			operator = "";
		}
		
		if(Util.getIntValue(seclevelto, -987564) == -987564){
			seclevelto = "null";
			operator = "";
		}
		
		String content = "";
		if(type1.equals("1")){//人力资源
			content = hrmId;
			operator = "";
			seclevel = "null";
			seclevelto = "null";
		}else if(type1.equals("2")){//分部
			content = subId;
			iscontains = subiscontains;
		}else if(type1.equals("3")){//部门
			content = depId;
			iscontains = depiscontains;
		}else if(type1.equals("4")){//角色
			content = roleId;
		}
		if(iscontains.length()==0)iscontains="0";
		
		if(id>0){
			rs.executeSql("update SysDetachDetail "+
						" set type1 = "+Util.getIntValue(type1)+", "+
						" 	content = '"+StringEscapeUtils.escapeSql(content)+"', "+
						" 	seclevel = "+seclevel+", "+
						" 	seclevelto = "+seclevelto+", "+
						" 	sourcetype = 2, "+
						" 	operator = '"+StringEscapeUtils.escapeSql(operator)+"', "+
						" 	rolelevel = '"+StringEscapeUtils.escapeSql(rolelevel)+"', "+
						" 	iscontains = "+iscontains+
						" where id = "+id);
		}else{
			rs.executeSql("insert into SysDetachDetail (infoid, sourcetype, content, seclevel, seclevelto, type1, operator, rolelevel,iscontains) values ( "+
					" "+mainId+", "+
					" 2, "+
					" '"+StringEscapeUtils.escapeSql(content)+"', "+
					" "+seclevel+", "+
					" "+seclevelto+", "+
					" "+Util.getIntValue(type1)+", "+
					" '"+StringEscapeUtils.escapeSql(operator)+"', "+
					" '"+StringEscapeUtils.escapeSql(rolelevel)+"', "+
					" "+iscontains+
					" )");
		}
		
		out.println("{\"flag\":true,\"msg\":"+JSONObject.quote(SystemEnv.getHtmlLabelName(18758,user.getLanguage()))+",\"id\":\""+id+"\"}");//保存成功
		out.flush();
		adci.resetAppDetachInfo();
		return;
		
	}else if(operation.equals("delete") || operation.equals("batchDelete")){//删除
		String batchDelIds = Util.null2String(request.getParameter("ids"));
		if(operation.equals("delete")){
			batchDelIds = Util.null2String(request.getParameter("id"));
		}
		String[] batchDelIdsArray = batchDelIds.split(",");
		
		for(int i=0;i<batchDelIdsArray.length;i++){
			int _delId = Util.getIntValue(batchDelIdsArray[i], 0);
			if(_delId > 0){
				rs.execute("delete from SysDetachDetail where infoid = "+_delId);
				rs.execute("delete from SysDetachInfo where id = "+_delId);
			}
		}

		out.println("{\"flag\":true,\"msg\":"+JSONObject.quote(SystemEnv.getHtmlLabelName(18758,user.getLanguage()))+"}");//保存成功
		out.flush();
		adci.resetAppDetachInfo();
		return;
		
	}else if(operation.equals("rangeDel") || operation.equals("rangeBatchDel")){//删除
		String batchDelIds = Util.null2String(request.getParameter("ids"));
		if(operation.equals("rangeDel")){
			batchDelIds = Util.null2String(request.getParameter("id"));
		}
		String[] batchDelIdsArray = batchDelIds.split(",");
		
		for(int i=0;i<batchDelIdsArray.length;i++){
			int _delId = Util.getIntValue(batchDelIdsArray[i], 0);
			if(_delId > 0){
				rs.execute("delete from SysDetachDetail where id = "+_delId);
			}
		}

		out.println("{\"flag\":true,\"msg\":"+JSONObject.quote(SystemEnv.getHtmlLabelName(18758,user.getLanguage()))+"}");//保存成功
		out.flush();
		adci.resetAppDetachInfo();
		return;
		
	}else if(operation.equals("membersDel") || operation.equals("membersBatchDel")){//删除
		String batchDelIds = Util.null2String(request.getParameter("ids"));
		if(operation.equals("membersDel")){
			batchDelIds = Util.null2String(request.getParameter("id"));
		}
		String[] batchDelIdsArray = batchDelIds.split(",");
		
		for(int i=0;i<batchDelIdsArray.length;i++){
			int _delId = Util.getIntValue(batchDelIdsArray[i], 0);
			if(_delId > 0){
				rs.execute("delete from SysDetachDetail where id = "+_delId);
			}
		}

		out.println("{\"flag\":true,\"msg\":"+JSONObject.quote(SystemEnv.getHtmlLabelName(18758,user.getLanguage()))+"}");//保存成功
		out.flush();
		adci.resetAppDetachInfo();
		return;
		
	}else{
		out.println("{\"flag\":false,\"msg\":"+JSONObject.quote(SystemEnv.getHtmlLabelName(2012,user.getLanguage())+"3")+"}");//对不起，您暂时没有权限！
		out.flush();
		return;
		
	}
}
%>