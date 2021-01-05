
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.hrm.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
User user = HrmUserVarify.getUser (request , response) ;
if(user == null)  return ;
int subcompanyid=Util.getIntValue(request.getParameter("subCompanyId"));
int departmentid=Util.getIntValue(request.getParameter("departmentid"));
int PieceYear =Util.getIntValue(request.getParameter("PieceYear"));
int PieceMonth =Util.getIntValue(request.getParameter("PieceMonth"));
if(departmentid>0){
    RecordSet.executeSql("select count(*) from HRM_PieceRateInfo where subcompanyid="+subcompanyid+" and departmentid="+departmentid+" and PieceYear="+PieceYear+" and PieceMonth="+PieceMonth);
}else{
    RecordSet.executeSql("select count(*) from HRM_PieceRateInfo where subcompanyid="+subcompanyid+" and PieceYear="+PieceYear+" and PieceMonth="+PieceMonth);
}
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