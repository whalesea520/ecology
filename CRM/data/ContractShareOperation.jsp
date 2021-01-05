
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ContractViewer" class="weaver.crm.ContractViewer" scope="page"/>
<jsp:useBean id="ContacterShareBase" class="weaver.crm.ContacterShareBase" scope="page"/>

<%
char flag = 2;
String ProcPara = "";
String id = Util.null2String(request.getParameter("id"));
String method = Util.null2String(request.getParameter("method"));
String contractId = Util.null2String(request.getParameter("contractId")); 
String CustomerID = Util.null2String(request.getParameter("CustomerID")); 

String isfromtab  = Util.null2String(request.getParameter("isfromtab"),"false");
String CurrentUser = ""+user.getUID();
String ClientIP = request.getRemoteAddr();
String SubmiterType = ""+user.getLogintype();

Date newdate = new Date() ;
long datetime = newdate.getTime() ;
Timestamp timestamp = new Timestamp(datetime) ;
String CurrentDate = (timestamp.toString()).substring(0,4) + "-" + (timestamp.toString()).substring(5,7) + "-" +(timestamp.toString()).substring(8,10);
String CurrentTime = (timestamp.toString()).substring(11,13) + ":" + (timestamp.toString()).substring(14,16) + ":" +(timestamp.toString()).substring(17,19);



if(method.equals("delete"))
{

	RecordSet.executeProc("Contract_ShareInfo_Del",id);

	ContractViewer.setContractShareById(""+contractId);

	// response.sendRedirect("/CRM/data/ContractShareAdd.jsp?contractId="+contractId+"&CustomerID="+CustomerID);
	return;
}

String userid = "0" ;
String departmentid = "0" ;
String roleid = "0" ;
String foralluser = "0" ;
String subcompanyid = "0" ;

if(method.equals("add"))
{
	
	String deleteIds = Util.null2String(request.getParameter("deleteIds"));
	if(!"".equals(deleteIds)){
		RecordSet.execute("delete from Contract_ShareInfo where id in ("+deleteIds+")");
	}
	
	
	int rownum = Util.getIntValue(request.getParameter("rownum"),0);
	 for(int i=0; i<rownum; i++){
         String sharetype = request.getParameter("sharetype_"+i);
         if(sharetype != null){
             String relatedshareid = Util.null2String(request.getParameter("relatedshareid_"+i));
             String rolelevel = Util.null2String(request.getParameter("rolelevel_"+i));
             String seclevel = Math.min(Util.getIntValue(request.getParameter("seclevel_"+i)) , Util.getIntValue(request.getParameter("seclevelMax_"+i)))+"";
         	 String seclevelMax = Math.max(Util.getIntValue(request.getParameter("seclevel_"+i)) , Util.getIntValue(request.getParameter("seclevelMax_"+i)))+"";

             
             String sharelevel = Util.null2String(request.getParameter("sharelevel_"+i));
				

             if(sharetype.equals("1")) userid = relatedshareid ;
             if(sharetype.equals("2")) departmentid = relatedshareid ;
             if(sharetype.equals("3")) roleid = relatedshareid ;
             if(sharetype.equals("4")) foralluser = "1" ;
             if(sharetype.equals("5")) subcompanyid = relatedshareid ;
             
            ProcPara = contractId;
         	ProcPara += flag+sharetype;
         	ProcPara += flag+seclevel;
         	ProcPara += flag+seclevelMax;
         	ProcPara += flag+rolelevel;
         	ProcPara += flag+sharelevel;
         	ProcPara += flag+userid;
         	ProcPara += flag+departmentid;
         	ProcPara += flag+subcompanyid;
         	ProcPara += flag+roleid;
         	ProcPara += flag+foralluser;
         	RecordSet.executeProc("Contract_ShareInfo_Ins",ProcPara);
         }
	 }
             
	

	//ContractViewer.setContractShareById(""+contractId);
	// response.sendRedirect("/CRM/data/ContractShareAdd.jsp?isfromtab="+isfromtab+"&contractId="+contractId+"&CustomerID="+CustomerID);
	return;
}

%>
