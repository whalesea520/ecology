<%@ page language="java" contentType="text/xml ; charset=UTF-8" %><%@ page import="java.util.ArrayList,weaver.hrm.*" %><jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/><%
	response.setHeader("Cache-Control","no-store");
	response.setHeader("Pragrma","no-cache");
	response.setDateHeader("Expires",0);%><%User user = HrmUserVarify.getUser(request,response);%><?xml version="1.0" encoding="UTF-8"?><tree><%
	if(user == null)  return ;
	String s = "", sql="";
	ArrayList menuIds = new ArrayList();
//MainMenuInfo > News
	sql = "SELECT * FROM MainMenuInfo WHERE defaultParentId=1 ORDER BY defaultIndex";
	rs.executeSql(sql);
	while(rs.next()){
		//TD4519
		//added by hubo,2006-06-13
		if(rs.getInt("labelid")==16390) continue;

		if(menuIds.contains(rs.getString("id"))) continue;
		menuIds.add(rs.getString("id"));

		s += "<tree text='"+rs.getString("menuName")+"' icon='/images_face/ecologyFace_2/LeftMenuIcon/level3_wev8.gif' action='"+rs.getString("linkAddress")+"'>";
		s += "</tree>";
	}
	out.print(s+"</tree>");
%>