<%@page import="com.weaver.formmodel.apps.ktree.KtreeFunction"%>
<%@page import="weaver.hrm.User"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="net.sf.json.util.JSONBuilder"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="weaver.general.Util"%>

<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
	User user = (User)request.getSession(true).getAttribute("weaver_user@bean") ;
	KtreeFunction ktreeFunction = new KtreeFunction();
	String versionid = Util.null2String(request.getParameter("versionid"));
	String search = Util.null2String(request.getParameter("search"));
// 	System.out.println(versionid+">>>>>"+search);
	String sql = "select f1.id,f1.functionName,'' as havsub,f1.pid "
				+" from uf_ktree_function f1 where versionids like '%"+versionid+"%'";
	   sql += " and functionName like '%"+search+"%' and (pid is not null and pid<>'') " ;
	sql+= " order by disorder ";
// 	System.out.println("二级菜单sql："+sql);
	rs.executeSql(sql);
	JSONArray functionarray = new JSONArray();
	String pids = "";
	String functionids = "";
	while(rs.next()){
		JSONObject obj = new JSONObject();
		String id = Util.null2String(rs.getString("id"));
		obj.put("id", id);
		String functionName = Util.null2String(rs.getString("functionName"));
		boolean isnew =ktreeFunction.isnew(versionid, id, user.getUID(),"");
		if(isnew){
			obj.put("isNewFlag", "1");
		}
		obj.put("name", functionName);
		obj.put("isclick","true");
		if(Util.null2String(rs.getString("havsub")).equals("1")){
			obj.put("isParent", "true");
			obj.put("isclick","false");
		}
		
		String tmpPid = Util.getIntValue(rs.getString("pid"),0)+"";
		obj.put("pId", tmpPid);
		pids+=","+tmpPid;
		
		obj.put("versionid",versionid);
		functionids+=","+id;
		functionarray.add(obj);
	}
	if(pids.length()>0){
		pids = pids.substring(1);
	}
	
	sql = "select f1.id,f1.functionName, '1' as havsub,f1.pid "
				+" from uf_ktree_function f1 where versionids like '%"+versionid+"%'";
	   sql += " and (functionName like '%"+search+"%' and (pid is null or pid='')) " ;
	if(pids.length()>0){
		sql+=" or id in("+pids+")";
	}
	sql+= " order by disorder ";
// 	System.out.println("一级菜单sql："+sql);
	rs.executeSql(sql);
	String strs = "";
	while(rs.next()){
		JSONObject obj = new JSONObject();
		String id = Util.null2String(rs.getString("id"));
		obj.put("id", id);
		String functionName = Util.null2String(rs.getString("functionName"));
		boolean isnew =ktreeFunction.isnew(versionid, id, user.getUID(),"");
		if(isnew){
			obj.put("isNewFlag", "1");
		}
		obj.put("name", functionName);
		obj.put("isclick","true");
		if(Util.null2String(rs.getString("havsub")).equals("1")){
			obj.put("isParent", "true");
			obj.put("isclick","false");
		}
		
		String tmpPid = Util.getIntValue(rs.getString("pid"),0)+"";
		obj.put("pId", tmpPid);
		obj.put("versionid",versionid);
		functionarray.add(obj);
		functionids+=","+id;
		if(pids.indexOf(id)==-1){
			strs += ","+id;
		}
	}
	if(strs.length()>0){
		strs = strs.substring(1);
		sql = "select f1.id,f1.functionName, '0' as havsub,f1.pid "
				+" from uf_ktree_function f1 where versionids like '%"+versionid+"%'";
	   		sql += " and pid in("+strs+") order by disorder " ;
	   		System.out.println("ddd:"+sql);
			rs.executeSql(sql);
		while(rs.next()){
			JSONObject obj = new JSONObject();
			String id = Util.null2String(rs.getString("id"));
			obj.put("id", id);
			String functionName = Util.null2String(rs.getString("functionName"));
			boolean isnew =ktreeFunction.isnew(versionid, id, user.getUID(),"");
			if(isnew){
				obj.put("isNewFlag", "1");
			}
			obj.put("name", functionName);
			obj.put("isclick","false");
			if(Util.null2String(rs.getString("havsub")).equals("1")){
				obj.put("isParent", "true");
				obj.put("isclick","false");
			}
			
			String tmpPid = Util.getIntValue(rs.getString("pid"),0)+"";
			obj.put("pId", tmpPid);
			obj.put("versionid",versionid);
			if(functionids.indexOf(id)==-1){
				functionarray.add(obj);
			}
		}
	}
// 	System.out.println(functionarray);
	out.print(functionarray);
%>