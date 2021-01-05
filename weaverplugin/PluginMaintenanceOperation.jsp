
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
int NoCheck = Util.getIntValue(request.getParameter("NoCheckPlugin"),0);
rs.executeSql("delete from SysActivexCheck where userid = " + user.getUID()+" and logintype='"+user.getLogintype()+"'");
if(NoCheck==1){
    rs.executeSql("insert into SysActivexCheck(userid,logintype,NoCheckPlugin) values("+user.getUID()+",'"+user.getLogintype()+"','"+NoCheck+"')");
}
%>