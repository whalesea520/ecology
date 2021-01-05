
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.sql.Timestamp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetDB" class="weaver.conn.RecordSet" scope="page" />
<%
char flag = 2 ;
String ProcPara = "";
String method = request.getParameter("method");
String taskrecordid = request.getParameter("taskrecordid");
String ProjID=Util.null2String(request.getParameter("ProjID"));
String version=Util.null2String(request.getParameter("version"));
String wbscoding=Util.null2String(request.getParameter("wbscoding"));
String subject=Util.null2String(request.getParameter("subject"));
String begindate=Util.null2String(request.getParameter("begindate"));
String enddate=Util.null2String(request.getParameter("enddate"));
String workday=Util.null2String(request.getParameter("workday"));
String fixedcost=Util.null2String(request.getParameter("fixedcost"));
String content=Util.null2String(request.getParameter("content"));
String finish=Util.null2String(request.getParameter("finish"));
if(begindate.equals("")) begindate = "x" ;
if(enddate.equals("")) enddate = "-" ;
if(workday.equals("")) workday = "1" ;
if(Util.getDoubleValue(workday)<=0) workday = "1" ;
if(fixedcost.equals("")) fixedcost = "0" ;
if(finish.equals("")) finish = "0" ;

//db2--add by wzhh
String hrmidSearch ="select hrmid from Prj_TaskProcess where id ="+taskrecordid ;
rs.executeSql(hrmidSearch);
String hrmid = rs.getString("hrmid");

if (method.equals("edit"))
{
	ProcPara += taskrecordid ;
	ProcPara += flag + "" + begindate ;
	ProcPara += flag + "" + enddate ;
	ProcPara += flag + "" + workday ;
	ProcPara += flag + "" + content ;
	ProcPara += flag + "" + fixedcost ;
	ProcPara += flag + "" + finish ;
	RecordSet.executeProc("Prj_TaskProcess_Update",ProcPara);

    //db2 trigger->procedure
    /*
    CREATE PROCEDURE Trigger_Proc_02 
    (
    in begindate char(10),
    in enddate char(10),
    in isdelete smallint ,
    in hrmid integer
    ) 
    */



    if (RecordSetDB.getDBType().equals("db2")){


        ProcPara = begindate ;
        ProcPara += flag + "" + enddate ;
        ProcPara += flag + "" + '0' ;
        ProcPara += flag + "" + hrmid ;
   //   RecordSet.executeProc("Trigger_Proc_02",ProcPara);
    }


	response.sendRedirect("/proj/plan/ViewTaskProcess.jsp?taskrecordid="+taskrecordid);
}

%>