
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="weaver.general.*"%>
<%@ page import="java.util.*"%>
<%@ page import="weaver.hrm.*"%>
<%@ page import="net.sf.json.JSONArray"%>
<%@ page import="net.sf.json.JSONObject"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
       String txstatus = Util.null2String(request.getParameter("txstatus"));
       User user = HrmUserVarify.getUser(request, response);
       String userid = "" + user.getUID();
       //System.err.println("txstatus:"+txstatus+" userid:"+userid);
       RecordSet.executeSql("delete from WorkflowSignTXStatus where userid = "+userid);
       String sql = "insert into WorkflowSignTXStatus(status,userid) values ("+txstatus+","+userid+")";
       boolean b = RecordSet.executeSql(sql);
       //System.err.println("b:"+b);
       JSONObject json = new JSONObject();
       json.put("status", txstatus);
	   //System.err.println(sql);
	   out.println(json.toString());
%>

