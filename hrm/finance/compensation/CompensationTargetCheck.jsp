
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.hrm.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
User user = HrmUserVarify.getUser (request , response);
if(user == null)  return ;
int subcompanyid=Util.getIntValue(request.getParameter("subCompanyId"));
int departmentid=Util.getIntValue(request.getParameter("departmentid"));
int CompensationYear =Util.getIntValue(request.getParameter("CompensationYear"));
int CompensationMonth =Util.getIntValue(request.getParameter("CompensationMonth"));
RecordSet.executeSql("select count(*) from HRM_CompensationTargetInfo where subcompanyid="+subcompanyid+" and departmentid="+departmentid+" and CompensationYear="+CompensationYear+" and CompensationMonth="+CompensationMonth);

int counts=0;
if(RecordSet.next()){
    counts=RecordSet.getInt(1);
}
if(counts>0){
    out.println("0");
}else{
    out.println("1");
}
%>