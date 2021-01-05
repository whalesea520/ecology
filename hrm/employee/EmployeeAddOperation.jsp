<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Timestamp" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SysRemindWorkflow" class="weaver.system.SysRemindWorkflow" scope="page" />

<%
String name = Util.fromScreen(request.getParameter("name"),user.getLanguage());
String sex = Util.fromScreen(request.getParameter("sex"),user.getLanguage());
String workday =Util.fromScreen(request.getParameter("workday"),user.getLanguage());			/*到职日期*/
String departmentid = Util.fromScreen(request.getParameter("departmentid"),user.getLanguage());
String joblevel = Util.fromScreen(request.getParameter("joblevel"),user.getLanguage());
String jobtitle = Util.fromScreen(request.getParameter("jobtitle"),user.getLanguage());
String managerid =Util.fromScreen(request.getParameter("managerid"),user.getLanguage());
//out.print(name+"&&"+sex+"&&"+workday+"&&"+departmentid+"&&"+joblevel+"&&"+managerid);

String resourceid ="";
RecordSet.executeProc("SequenceIndex_Update","resourceid");
RecordSet.next();

resourceid = RecordSet.getString("currentid");

char flag = 2;
String ProcPara = "";

ProcPara =  resourceid;
ProcPara += flag + name;
ProcPara += flag + sex;
ProcPara += flag + workday;
ProcPara += flag + departmentid;
ProcPara += flag + joblevel;
ProcPara += flag + jobtitle;
ProcPara += flag + managerid;
RecordSet.executeProc("Employee_Insert",ProcPara);
//将新员工的个人信息插入人力资源表中:HrmResource。

String sql_1=("insert into HrmInfoStatus (itemid,hrmid) values(1,"+resourceid+")");
RecordSet.executeSql(sql_1);
String sql_2=("insert into HrmInfoStatus (itemid,hrmid) values(2,"+resourceid+")");
RecordSet.executeSql(sql_2);
String sql_3=("insert into HrmInfoStatus (itemid,hrmid) values(3,"+resourceid+")");
RecordSet.executeSql(sql_3);
String sql_4=("insert into HrmInfoStatus (itemid,hrmid) values(4,"+resourceid+")");
RecordSet.executeSql(sql_4);
String sql_5=("insert into HrmInfoStatus (itemid,hrmid) values(5,"+resourceid+")");
RecordSet.executeSql(sql_5);
String sql_6=("insert into HrmInfoStatus (itemid,hrmid) values(6,"+resourceid+")");
RecordSet.executeSql(sql_6);
String sql_7=("insert into HrmInfoStatus (itemid,hrmid) values(7,"+resourceid+")");
RecordSet.executeSql(sql_7);
String sql_8=("insert into HrmInfoStatus (itemid,hrmid) values(8,"+resourceid+")");
RecordSet.executeSql(sql_8);
String sql_9=("insert into HrmInfoStatus (itemid,hrmid) values(9,"+resourceid+")");
RecordSet.executeSql(sql_9);
String sql_10=("insert into HrmInfoStatus (itemid,hrmid) values(10,"+resourceid+")");
RecordSet.executeSql(sql_10);
response.sendRedirect("/hrm/employee/EmployeeView.jsp");
//在状态表中添加记录，此时所有状态为0。

 
//以下是给相应的人员触发工作流
/**/
String CurrentUser = ""+user.getUID();
String CurrentUserName = ""+user.getUsername();
Date newdate = new Date() ;
long datetime = newdate.getTime() ;
Timestamp timestamp = new Timestamp(datetime) ;
String CurrentDate = (timestamp.toString()).substring(0,4) + "-" + (timestamp.toString()).substring(5,7) + "-" +(timestamp.toString()).substring(8,10);

String SWFAccepter="";
String SWFTitle="";
String SWFRemark="";
String SWFSubmiter="";
String Subject="";
Subject=SystemEnv.getHtmlLabelName(15670,user.getLanguage());
Subject+=":"+name;




String thesql="select hrmid from HrmInfoMaintenance ";
RecordSet.executeSql(thesql);
String members="";
while(RecordSet.next()){
members += ","+RecordSet.getString("hrmid");
}
//out.print(members);
if(!members.equals("")){
    members = members.substring(1);

    SWFAccepter=members;
    SWFTitle=SystemEnv.getHtmlLabelName(15670,user.getLanguage());
    SWFTitle += ":"+name;
    SWFTitle += "-"+CurrentUserName;
    SWFTitle += "-"+CurrentDate;
    SWFRemark="<a href=/hrm/employee/EmployeeManage.jsp?hrmid="+resourceid+">"+Util.fromScreen2(Subject,user.getLanguage())+"</a>";
    SWFSubmiter=CurrentUser;

    SysRemindWorkflow.setPrjSysRemind(SWFTitle,0,Util.getIntValue(SWFSubmiter),SWFAccepter,SWFRemark);	
} 
%>