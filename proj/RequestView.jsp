<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.conn.RecordSet"%>
<%@ page import="weaver.general.*,java.util.*,org.apache.commons.lang3.*"%>
<%
User user = null ;
try{
	user = HrmUserVarify.getUser (request , response) ;
}catch(Exception e){
}
String uid = user.getUID()+"";
String requestid = Util.null2String(request.getParameter("requestid"));
RecordSet rs = new RecordSet();
try{
	String wfid = "";
	String currentnodeid = "";
	String creater = "";
	rs.executeSql("select creater,workflowid,currentnodeid from workflow_requestbase where requestid="+requestid);
	if(rs.next()){
		creater = rs.getString(1);
		wfid = rs.getString(2);
		currentnodeid = rs.getString(3);
	}

	rs.executeSql("select 1 from workflow_currentoperator where requestid="+requestid+" and userid="+uid);
	if(!rs.next()){
		String sql = "select wfid,userid from Workflow_SharedScope where wfid ="+wfid +" and requestid = "+requestid+" and iscanread = 1 and operator = '"+creater+"' and currentnodeid = "+currentnodeid+" and userid = "+uid ;
		rs.executeSql(sql)   ;
		if(!rs.next()){
		   sql = " insert into Workflow_SharedScope (wfid,requestid,permissiontype,userid,iscanread,operator,currentnodeid) values ("+wfid+","+requestid+",5,"+uid+",1,"+creater+","+currentnodeid+")"   ;
		   rs.executeSql(sql);
		   rs.executeSql("update workflow_base set isshared = 1 where id="+wfid);
		}
	}
}catch(Exception e){
	
}
response.sendRedirect("/workflow/request/ViewRequest.jsp?isovetiem=0&requestid="+requestid);
return ;
%>