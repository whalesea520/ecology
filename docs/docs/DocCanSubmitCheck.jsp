
<%@ page language="java" contentType="text/plain; charset=UTF-8" %>
<%@ page import="weaver.general.Util"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%@page import="weaver.hrm.*"%>
<%
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
User user = HrmUserVarify.getUser (request , response) ;
if(user == null)  return ;
int docid = Util.getIntValue(request.getParameter("docid"));

String sql = "";
int returnInt=0;
int doceditionid=0;
RecordSet.executeSql("select doceditionid from docdetail where id = " + docid);
if(RecordSet.next()){
	doceditionid=Util.getIntValue(RecordSet.getString("doceditionid"));
}
if(doceditionid>0){
	RecordSet.executeSql("select count(0) from docdetail where doceditionid > 0 and id<>"+docid+" and doceditionid = "+doceditionid+" and (docstatus <= 0 or docstatus in (3,4,6)) ");
	if(RecordSet.next()&&RecordSet.getInt(1)>0){
		 returnInt=1;
	}
}
out.println("checkCanSubmitCallBack("+returnInt+");");
%>