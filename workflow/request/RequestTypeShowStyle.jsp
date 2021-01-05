<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/plain; charset=UTF-8" %> 
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RequestDefaultComInfo" class="weaver.system.RequestDefaultComInfo" scope="page" />

<%
int userid=Util.getIntValue(request.getParameter("userid"),0);

String showtype = Util.null2String(request.getParameter("showtype"));

String action;
//System.out.print();
RecordSet.executeProc("workflow_RUserDefault_Select",""+userid);
if(RecordSet.next()){
    action="update";
}else{
    action="insert";
}
if(action.equals("insert"))
{
    RecordSet.execute("insert into  workflow_RequestUserDefault(userid,showtype)  values("+userid+",'"+showtype+"')");
	//新曾缓存
    RequestDefaultComInfo.addRequestDefaultComInfoCache(""+userid);
}
else
{
    RecordSet.execute("update workflow_RequestUserDefault  set  showtype='"+showtype+"'  where userid="+userid+"");
    //更新缓存
    RequestDefaultComInfo.updateRequestDefaultComInfoCache(""+userid);
}
//System.out.println("save success!!!");
out.println("success");

%>
