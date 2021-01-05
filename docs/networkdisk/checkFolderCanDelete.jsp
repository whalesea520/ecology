<%@ page language="java" contentType="application/json" pageEncoding="utf-8"%>
<%@ page import="java.util.*" %>
<%@ page import="net.sf.json.JSONArray" %>
<%@ page import="weaver.conn.*" %>
<%
	String folderids = request.getParameter("folderids");
	RecordSet rs = new RecordSet();
	Map<String ,String> map = new HashMap<String,String>();
	String sql = "select id,categoryname from DocPrivateSecCategory where id in (select parentid from DocPrivateSecCategory where parentid in("+folderids+"))";
	System.out.println(sql);
	rs.executeSql(sql);
	while(rs.next())
	{
	    String id = rs.getString("id");
	    String categoryname = rs.getString("categoryname");
	    map.put(id,categoryname);
	}
	sql = "select id,categoryname from DocPrivateSecCategory d where d.id in "+
		"(select i.categoryid from ImageFileRef i where i.categoryid in("+folderids+") group by i.categoryid)";
		System.out.println(sql);
	rs.executeSql(sql);
	while(rs.next())
	{
	    String id = rs.getString("id");
	    String categoryname = rs.getString("categoryname");
	    map.put(id,categoryname);
	}
	JSONArray jo = JSONArray.fromObject(map);
	System.out.println(jo.toString());
	out.println(jo.toString());
%>