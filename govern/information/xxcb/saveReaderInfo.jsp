<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.hrm.User"%>
<%@ page import="org.json.JSONObject"%>
<%@ page import="org.json.JSONArray"%>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DateHelper" class="com.weaver.formmodel.util.DateHelper" scope="page" />

<%
//保存 已阅人员信息

User user = HrmUserVarify.getUser (request , response) ;

JSONObject obj = new JSONObject();

String billid = Util.null2String(request.getParameter("billid"));
String userid = user.getUID()+"";
String currTime = DateHelper.getCurrentDate()+" "+DateHelper.getCurrentTime();
//out.print("currTime="+currTime);


RecordSet.executeSql("select * from uf_xxcb_sbInfo_dt1 where ry="+userid+" and mainid="+billid);
if(!RecordSet.next()){
	RecordSet.executeSql("insert into uf_xxcb_sbInfo_dt1 (mainid,ry,time) values ("+billid+","+userid+",'"+currTime+"')");
}



obj.put("result", "1");	//放入表

out.clear();
out.print(obj.toString());
%>