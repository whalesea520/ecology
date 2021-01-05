
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CrmViewer" class="weaver.crm.CrmViewer" scope="page"/>

<%
if(!HrmUserVarify.checkUserRight("EditCustomerType:Edit", user)){
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
char flag = 2;
String ProcPara = "";
String id = Util.null2String(request.getParameter("id"));
String method = Util.null2String(request.getParameter("method"));

String typeid = Util.null2String(request.getParameter("typeid"));
String relatedshareid = Util.null2String(request.getParameter("relatedshareid")); 
String sharetype = Util.null2String(request.getParameter("sharetype")); 
String rolelevel = Util.null2String(request.getParameter("rolelevel")); 
String seclevel = Math.min(Util.getIntValue(request.getParameter("seclevel")) , Util.getIntValue(request.getParameter("seclevelMax")))+"";
String seclevelMax = Math.max(Util.getIntValue(request.getParameter("seclevel")) , Util.getIntValue(request.getParameter("seclevelMax")))+"";

String sharelevel = Util.null2String(request.getParameter("sharelevel"));
String CurrentUser = ""+user.getUID();
String ClientIP = request.getRemoteAddr();
String SubmiterType = ""+user.getLogintype();

String seclevelto = Util.null2String(request.getParameter("seclevelto"));
String jobtitlelevel = Util.null2String(request.getParameter("jobtitlelevel"));
String jobtitlesubcompany = Util.null2String(request.getParameter("jobtitlesubcompany"));
String jobtitledepartment = Util.null2String(request.getParameter("jobtitledepartment"));
String scopeid = "0";
if(jobtitlelevel.equals("1")){
	scopeid = jobtitledepartment;
}else if(jobtitlelevel.equals("2")){
	scopeid = jobtitlesubcompany;
}

scopeid = ","+scopeid+","; 

String jobtitleid = "-1" ;

Date newdate = new Date() ;
long datetime = newdate.getTime() ;
Timestamp timestamp = new Timestamp(datetime) ;
String CurrentDate = (timestamp.toString()).substring(0,4) + "-" + (timestamp.toString()).substring(5,7) + "-" +(timestamp.toString()).substring(8,10);
String CurrentTime = (timestamp.toString()).substring(11,13) + ":" + (timestamp.toString()).substring(14,16) + ":" +(timestamp.toString()).substring(17,19);

String userid = "0" ;
String departmentid = "0" ;
String roleid = "0" ;
String foralluser = "0" ;
String subcompanyid = "0" ;

if(sharetype.equals("1")) {userid = relatedshareid ;seclevel="0";seclevelMax="0";}
if(sharetype.equals("2")) departmentid = relatedshareid ;
if(sharetype.equals("3")) roleid = relatedshareid ;
if(sharetype.equals("4")) foralluser = "1" ;
if(sharetype.equals("5")) subcompanyid = relatedshareid ;
if(sharetype.equals("6")) jobtitleid = relatedshareid ;

jobtitleid = ","+jobtitleid+",";

if(method.equals("delete"))
{
	RecordSet.executeProc("CRM_T_ShareInfo_Delete",id);
	System.err.println("/CRM/Maint/EditCustomerTypeInner.jsp?id=" + typeid + "&msgid=20");
	response.sendRedirect("/CRM/Maint/EditCustomerTypeInner.jsp?id=" + typeid + "&winfo=2");
	return;
}


if(method.equals("add"))
{
	String[] jobtitleids = Util.TokenizerString2(jobtitleid,",");
	for(String jobid : jobtitleids){
		if("".equals(jobid)||jobid == null)continue;
		ProcPara = typeid;
		ProcPara += flag+sharetype;
		ProcPara += flag+seclevel;
		ProcPara += flag+seclevelMax;
		ProcPara += flag+rolelevel;
		ProcPara += flag+sharelevel;
		ProcPara += flag+userid;
		ProcPara += flag+departmentid;
		ProcPara += flag+roleid;
		ProcPara += flag+foralluser;
		ProcPara += flag+subcompanyid;
		RecordSet.executeProc("CRM_T_ShareInfo_Insert",ProcPara);
		
		RecordSet.execute("select max(id) from CRM_T_ShareInfo where relateditemid = "+typeid+" and userid = "+userid);
		int sid = -1;
		if(RecordSet.next())
			sid = RecordSet.getInt(1);
		
		RecordSet.execute("update CRM_T_ShareInfo set jobtitleid='"+jobid+"', joblevel="+jobtitlelevel+", scopeid='"+scopeid+"' where id = "+sid);
			
	}
	
	response.sendRedirect("/CRM/data/AddTypeShare.jsp?typeid="+typeid+"&isclose=1");
	return;
}


%>
