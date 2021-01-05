
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.hrm.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<%
User user = HrmUserVarify.getUser (request , response) ;
if(user == null)  return ;
int subcompanyid=Util.getIntValue(request.getParameter("subCompanyId"));
int departmentid=Util.getIntValue(request.getParameter("departmentid"));
String yearmonth =Util.null2String(request.getParameter("yearmonth"));
if(departmentid<1){
    String subcompanystr= SubCompanyComInfo.getSubCompanyTreeStr(""+subcompanyid)+subcompanyid;
   RecordSet.executeSql("select count(*) from HrmSalarypay a,HrmSalarypaydetail b where a.id=b.payid and b.departmentid in(select id from Hrmdepartment where subcompanyid1 in("+subcompanystr+")) and a.paydate='"+yearmonth+"'");
}else{
   String departmentstr = SubCompanyComInfo.getDepartmentTreeStr("" + departmentid) + departmentid;
   RecordSet.executeSql("select count(*) from HrmSalarypay a,HrmSalarypaydetail b where a.id=b.payid and b.departmentid in("+departmentstr+") and a.paydate='"+yearmonth+"'");
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