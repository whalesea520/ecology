<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Timestamp" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<jsp:useBean id="GroupAction" class="weaver.hrm.group.GroupAction" scope="page" />
<%
User user = HrmUserVarify.getUser(request,response);
if(user == null)  return ;
String method = Util.fromScreen(request.getParameter("method"),user.getLanguage());
String groupmemberid = Util.fromScreen(request.getParameter("groupmemberid"),user.getLanguage());
String userid = Util.fromScreen(request.getParameter("userid"),user.getLanguage());
String groupids = Util.fromScreen(request.getParameter("groupid"),user.getLanguage());
  
if(method.equals("delGroup")){
	String delGroupMembersSql = "delete from HrmGroupMembers where id = " + groupmemberid;
	boolean isFinish = false;
	isFinish = RecordSet.executeSql(delGroupMembersSql);
	
    if(isFinish){    	
    	out.print("1");
    	return ;
    }else{
    	out.print("0");
    	return ;
    }
  }
  
if("addGroupMember".equals(method)){

String[] groupidArr = groupids.split(",");
for(int i = 0 ; i < groupidArr.length; i++){
	GroupAction.addMembers(groupidArr[i]+"",userid);
} 

 	out.print("1");
}
%>