
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="PrjViewer" class="weaver.proj.PrjViewer" scope="page"/>
<jsp:useBean id="ProjectAccesory" class="weaver.proj.ProjectAccesory" scope="page" />

<%
char flag = 2;
String ProcPara = "";
String id = Util.null2String(request.getParameter("id"));
String method = Util.null2String(request.getParameter("method"));
String prjid = Util.null2String(request.getParameter("prjid")); 
String relatedshareid = Util.null2String(request.getParameter("relatedshareid")); 
String sharetype = Util.null2String(request.getParameter("sharetype")); 
String rolelevel = Util.null2String(request.getParameter("rolelevel")); 
String seclevel = Util.null2String(request.getParameter("seclevel"));
String sharelevel = Util.null2String(request.getParameter("sharelevel"));
String CurrentUser = ""+user.getUID();
String ClientIP = request.getRemoteAddr();
String SubmiterType = ""+user.getLogintype();

Date newdate = new Date() ;
long datetime = newdate.getTime() ;
Timestamp timestamp = new Timestamp(datetime) ;
String CurrentDate = (timestamp.toString()).substring(0,4) + "-" + (timestamp.toString()).substring(5,7) + "-" +(timestamp.toString()).substring(8,10);
String CurrentTime = (timestamp.toString()).substring(11,13) + ":" + (timestamp.toString()).substring(14,16) + ":" +(timestamp.toString()).substring(17,19);

String userid = "0" ;
String departmentid = "0" ;
String roleid = "0" ;
String foralluser = "0" ;

if(sharetype.equals("1")){
	userid = relatedshareid ;
	seclevel="0";
}
if(sharetype.equals("2")) departmentid = relatedshareid ;
if(sharetype.equals("3")) roleid = relatedshareid ;
if(sharetype.equals("4")) foralluser = "1" ;

if(method.equals("delete"))
{

	RecordSet.executeProc("Prj_ShareInfo_Delete",id);

	ProcPara = prjid;
	ProcPara += flag+"ds";
	ProcPara += flag+"0";
	ProcPara += flag+id;
	ProcPara += flag+CurrentDate;
	ProcPara += flag+CurrentTime;
	ProcPara += flag+CurrentUser;
	ProcPara += flag+SubmiterType;
	ProcPara += flag+ClientIP;
	RecordSet.executeProc("Prj_Log_Insert",ProcPara);

	PrjViewer.setPrjShareByPrj(""+prjid);
	
	ProjectAccesory.delAccesoryShareByProj(""+prjid);//项目里面的附件共享

	response.sendRedirect("/proj/data/AddShare.jsp?log=n&prjid="+prjid);
	return;
}


if(method.equals("add"))
{
	ProcPara = prjid;
	ProcPara += flag+sharetype;
	ProcPara += flag+seclevel;
	ProcPara += flag+rolelevel;
	ProcPara += flag+sharelevel;
	ProcPara += flag+userid;
	ProcPara += flag+departmentid;
	ProcPara += flag+roleid;
	ProcPara += flag+foralluser;
	
	String Remark="sharetype:"+sharetype+"seclevel:"+seclevel+"rolelevel:"+rolelevel+"sharelevel:"+sharelevel+"userid:"+userid+"departmentid:"+departmentid+"roleid:"+roleid+"foralluser:"+foralluser;

	RecordSet.executeProc("Prj_ShareInfo_Insert",ProcPara);

	ProcPara = prjid;
	ProcPara += flag+"ns";
	ProcPara += flag+"0";
	ProcPara += flag+Remark;
	ProcPara += flag+CurrentDate;
	ProcPara += flag+CurrentTime;
	ProcPara += flag+CurrentUser;
	ProcPara += flag+SubmiterType;
	ProcPara += flag+ClientIP;
	RecordSet.executeProc("Prj_Log_Insert",ProcPara);

	PrjViewer.setPrjShareByPrj(""+prjid);
	
	ProjectAccesory.setAccesoryShareByProj(""+prjid);//项目里面的附件共享

	response.sendRedirect("/proj/data/AddShare.jsp?log=n&prjid="+prjid);
	return;
}

if(method.equals("edit"))
{
	ProcPara = id;
	ProcPara += prjid;
	ProcPara += flag+sharetype;
	ProcPara += flag+seclevel;
	ProcPara += flag+rolelevel;
	ProcPara += flag+sharelevel;
	ProcPara += flag+userid;
	ProcPara += flag+departmentid;
	ProcPara += flag+roleid;
	ProcPara += flag+foralluser;

	RecordSet.executeProc("Prj_ShareInfo_Update",ProcPara);

	PrjViewer.setPrjShareByPrj(""+prjid);
	
	ProjectAccesory.setAccesoryShareByProj(""+prjid);//项目里面的附件共享

	response.sendRedirect("/proj/data/AddShare.jsp?prjid="+prjid);
	return;
}
%>
