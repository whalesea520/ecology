<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<%@page import="org.json.JSONObject"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%


String Id =request.getParameter("id");

User user = HrmUserVarify.getUser(request, response);

String sql = "select capitalspec,startprice from cptcapital where id = " + Id ;
RecordSet.executeSql(sql);
String spec = "";
String price ="";
JSONObject jsonObj = new JSONObject();
if(RecordSet.next()){
	spec = RecordSet.getString("capitalspec");
	price = RecordSet.getString("startprice");
}
jsonObj.put("spec",spec);
jsonObj.put("price",price);

out.print(jsonObj.toString());

%>