<%@page import="com.weaver.formmodel.apps.ktree.KtreeFunction"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="net.sf.json.util.JSONBuilder"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="weaver.general.Util"%>
<%@ page import="weaver.hrm.*" %>

<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
	User user = (User)request.getSession(true).getAttribute("weaver_user@bean") ;
	KtreeFunction ktreeFunction = new KtreeFunction();
	String versionid = Util.null2String(request.getParameter("versionid"));
	String sql = "select f1.id,f1.functionName,"
				//+" ISNULL(pid,0) as havsub, "
				+" f1.pid from uf_ktree_function f1 where versionids like '%"+versionid+"%'";
	sql+= " order by disorder ";
	System.out.println(sql+"<<<<<<<");
	rs.executeSql(sql);
	JSONArray functionarray = new JSONArray();
	while(rs.next()){
		JSONObject obj = new JSONObject();
		String functionid = Util.null2String(rs.getString("id"));
		obj.put("id", functionid);
		boolean isnew =ktreeFunction.isnew(versionid, functionid, user.getUID());
		String functionName = Util.null2String(rs.getString("functionName"));
		if(isnew){
			obj.put("isNewFlag", "1");
		}
		obj.put("name", functionName);
// 		obj.put("isclick",true);
// 		if(Util.null2String(rs.getString("havsub")).equals("1")){
// 			obj.put("isParent", "true");
// 			obj.put("isclick",false);
// 		}
		obj.put("pId", Util.getIntValue(rs.getString("pid"),0));
		obj.put("versionid",versionid);
		functionarray.add(obj);
	}
	out.print(functionarray);
%>