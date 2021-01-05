
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ReportShare" class="weaver.workflow.report.ReportShare" scope="page"/>
<%

char flag=Util.getSeparator();
String ProcPara = "";
String id = Util.null2String(request.getParameter("id"));
String method = Util.null2String(request.getParameter("method"));
String relatedshareid = Util.null2String(request.getParameter("relatedshareid")); 
String sharetype = Util.null2String(request.getParameter("sharetype")); 
String rolelevel = Util.null2String(request.getParameter("rolelevel")); 
String seclevel = Util.null2String(request.getParameter("seclevel"));
String sharelevel = Util.null2String(request.getParameter("sharelevel"));

String userid = "0" ;
String departmentid = "0" ;
String subcompanyid="0";
String roleid = "0" ;
String foralluser = "0" ;

if(sharetype.equals("1")) userid = relatedshareid ;//人力资源
if(sharetype.equals("2")) subcompanyid = relatedshareid ;
if(sharetype.equals("3")) departmentid = relatedshareid ;
if(sharetype.equals("4")) roleid = relatedshareid ;
if(sharetype.equals("5")) foralluser = "1" ;

if(method.equals("delete"))
{
	RecordSet.executeSql("DELETE  FROM HrmBirthdayShare WHERE   id = "+id);
	//RecordSet.executeProc("HrmBirthdayShare_Delete",id);
  out.print("ok");
}
else if(method.equals("add"))
{
	ProcPara = sharetype;
	ProcPara += flag+seclevel;
	ProcPara += flag+rolelevel;
	ProcPara += flag+sharelevel;
	ProcPara += flag+userid;
	ProcPara += flag+subcompanyid;
	ProcPara += flag+departmentid;
	ProcPara += flag+roleid;
	ProcPara += flag+foralluser;

	RecordSet.executeSql("INSERT  INTO HrmBirthdayShare ( sharetype , seclevel , rolelevel , sharelevel , userid , subcompanyid , departmentid , roleid , foralluser ) "
			+"VALUES  ( "+sharetype+" , "+seclevel+" , "+rolelevel+" , "+sharelevel+" , "+userid+" , "+subcompanyid+" , "+departmentid+" , "+roleid+" , "+foralluser+" )");
  //RecordSet.executeProc("HrmBirthdayShare_Insert",ProcPara);

	response.sendRedirect("BirthdayAdminSetting.jsp?isclose=1");
	    
}
%>
