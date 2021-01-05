
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />

<%

int hrmid_1 = Util.getIntValue(request.getParameter("hrmid_1"),-1);
int hrmid_2 = Util.getIntValue(request.getParameter("hrmid_2"),-1);
int hrmid_3 = Util.getIntValue(request.getParameter("hrmid_3"),-1);
int hrmid_4 = Util.getIntValue(request.getParameter("hrmid_4"),-1);
int hrmid_5 = Util.getIntValue(request.getParameter("hrmid_5"),-1);
int hrmid_6 = Util.getIntValue(request.getParameter("hrmid_6"),-1);
int hrmid_7 = Util.getIntValue(request.getParameter("hrmid_7"),-1);
int hrmid_8 = Util.getIntValue(request.getParameter("hrmid_8"),-1);
int hrmid_9 = Util.getIntValue(request.getParameter("hrmid_9"),-1);
int hrmid_10 = Util.getIntValue(request.getParameter("hrmid_10"),-1);


String sql_1 = "update HrmInfoMaintenance set hrmid="+hrmid_1+" where id=1 ";
rs.executeSql(sql_1);
String sql_2 = "update HrmInfoMaintenance set hrmid="+hrmid_2+" where id=2 ";
rs.executeSql(sql_2);
String sql_3 = "update HrmInfoMaintenance set hrmid="+hrmid_3+" where id=3 ";
rs.executeSql(sql_3);
String sql_4 = "update HrmInfoMaintenance set hrmid="+hrmid_4+" where id=4 ";
rs.executeSql(sql_4);
String sql_5 = "update HrmInfoMaintenance set hrmid="+hrmid_5+" where id=5 ";
rs.executeSql(sql_5);
String sql_6 = "update HrmInfoMaintenance set hrmid="+hrmid_6+" where id=6 ";
rs.executeSql(sql_6);
String sql_7 = "update HrmInfoMaintenance set hrmid="+hrmid_7+" where id=7 ";
rs.executeSql(sql_7);
String sql_8 = "update HrmInfoMaintenance set hrmid="+hrmid_8+" where id=8 ";
rs.executeSql(sql_8);
String sql_9 = "update HrmInfoMaintenance set hrmid="+hrmid_9+" where id=9 ";
rs.executeSql(sql_9);
String sql_10 = "update HrmInfoMaintenance set hrmid="+hrmid_10+" where id=10 ";
rs.executeSql(sql_10);
%>
<script>
window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(18758,user.getLanguage())%>")
window.location="/hrm/employee/EmployeeInfoMaintenance.jsp"
</script>
