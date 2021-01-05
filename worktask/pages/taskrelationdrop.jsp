
<%@ page language="java" contentType="application/json;charset=UTF-8" %>
<%@ page import="weaver.general.*"%>
<%@ page import="weaver.hrm.*,weaver.conn.*,org.json.*,java.math.*,java.text.*,java.util.*,weaver.worktask.worktask.*"%>
<%@ page import="java.sql.Timestamp"%>
<%@ page import="weaver.general.Util,
                 weaver.docs.docs.CustomFieldManager,
                 weaver.docs.docs.FieldParam" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />

<%
out.clearBuffer();
User user = HrmUserVarify.getUser (request , response) ;
char flag=Util.getSeparator();
int userid=user.getUID();
request.setCharacterEncoding("UTF-8");
//任务清单id
String tasklistid = request.getParameter("tasklistid");
String requestid = request.getParameter("requestid");
String currentrequestid = request.getParameter("currentrequestid"); 
try{
    //删除关联关系
    String sql = "delete from worktask_list_request where reqeustid='"+requestid+"' and wtlistid='"+tasklistid+"'";
	rs.execute(sql);
	String itemsnew = WorkTaskResourceUtil.getWorktaskRelationTaskAsJson(rs,currentrequestid+"",user);
	out.println("{\"success\":\"1\",\"itemsnew\":"+itemsnew+"}");
}catch(Exception e){
	out.println("{\"success\":\"0\"}");
}

%>