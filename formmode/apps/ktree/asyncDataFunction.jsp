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
	String pid = Util.null2String(request.getParameter("id"));
	String shownew = Util.null2String(request.getParameter("shownew"));
	boolean isshownew = shownew.equals("1");
	String sql = "select f1.id,f1.functionName,"
				+"(select top 1 '1' from uf_ktree_function f2 where f2.pid=f1.id  ) as havsub, "
				+" f1.pid from uf_ktree_function f1 where versionids like '%"+versionid+"%'";
	if("".equals(pid)){
	   sql += " and (pid is null or pid='')" ;
	}else{
	   sql += " and pid ='"+pid+"'";
	}
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
		}else if(isshownew){
			continue;
		}
		obj.put("name", functionName);
		obj.put("isclick",true);
		if(Util.null2String(rs.getString("havsub")).equals("1")){
			obj.put("isParent", "true");
			obj.put("isclick",false);
		}
		obj.put("pid", Util.getIntValue(rs.getString("pid"),0));
		obj.put("versionid",versionid);
		functionarray.add(obj);
	}
	out.print(functionarray);
%>