
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@page import="net.sf.json.JSONObject"%>
<%@ page import="weaver.systeminfo.SystemEnv"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />

<%
	 String reminddatefield = request.getParameter("reminddatefield");
     String remindtimefield = request.getParameter("remindtimefield");
     String detailtable = "";
     String flag = "false";
     String sql = "select detailtable from workflow_billfield where id in("+reminddatefield+","+remindtimefield+")"; 
     RecordSet.executeSql(sql);
     while(RecordSet.next()){
    	 String tempdetailtable = Util.null2String(RecordSet.getString("detailtable"));
   		 if(detailtable.equals(tempdetailtable)){
   			 flag = "true";
   		 }else{
   			 flag = "false"; 
   		 }
    	 detailtable = tempdetailtable;
     }
     
     JSONObject jsonObject = new JSONObject();
     jsonObject.accumulate("flag",flag);
     response.getWriter().write(jsonObject.toString());
%>