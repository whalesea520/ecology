
<%@ page language="java" contentType="text/plain; charset=UTF-8" %>
<%@page import="weaver.conn.RecordSet"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<jsp:useBean id="ModeRightInfo" class="weaver.formmode.setup.ModeRightInfo" scope="page"/>
<%
User user = HrmUserVarify.getUser (request , response) ;
RecordSet rs=new RecordSet();
JSONArray jsonArray=new JSONArray();
String sql="select id,modename,formid from modeinfo order by modetype";
rs.executeSql(sql);
while(rs.next()){
	int id=rs.getInt("id");
	String modename=rs.getString("modename");
	String formid=rs.getString("formid");
	ModeRightInfo.setUser(user);
	ModeRightInfo.setModeId(id);
	boolean flag=ModeRightInfo.checkUserRight(1);
	if(flag){
		JSONObject jsonObject=new JSONObject();
		jsonObject.put("modeid", id);
		jsonObject.put("modename",modename);
		jsonObject.put("formid",formid);
		jsonArray.add(jsonObject);
	}
}
out.print(jsonArray.toString());
%>
