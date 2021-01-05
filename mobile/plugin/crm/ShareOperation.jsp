
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.file.FileUpload"%> 
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<!--<jsp:useBean id="CrmViewer" class="weaver.crm.CrmViewer" scope="page"/>-->
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page"/>

<%
char flag = 2;
String ProcPara = "";
FileUpload fu=new FileUpload(request);
String id = Util.null2String(fu.getParameter("id"));
String method = Util.null2String(fu.getParameter("method"));
String CustomerID = Util.null2String(fu.getParameter("CustomerID")); 
String relatedshareid = Util.null2String(fu.getParameter("relatedshareid")); 
String sharetype = Util.null2String(fu.getParameter("sharetype")); 
String rolelevel = Util.null2String(fu.getParameter("rolelevel")); 
rolelevel="0";
String seclevel = Util.null2String(fu.getParameter("seclevel"));
String sharelevel = Util.null2String(fu.getParameter("sharelevel"));
String CurrentUser = ""+user.getUID();
String ClientIP = request.getRemoteAddr();
String SubmiterType = ""+user.getLogintype();

Date newdate = new Date() ;
long datetime = newdate.getTime() ;
Timestamp timestamp = new Timestamp(datetime) ;
String CurrentDate = (timestamp.toString()).substring(0,4) + "-" + (timestamp.toString()).substring(5,7) + "-" +(timestamp.toString()).substring(8,10);
String CurrentTime = (timestamp.toString()).substring(11,13) + ":" + (timestamp.toString()).substring(14,16) + ":" +(timestamp.toString()).substring(17,19);
boolean isfromtab =  Util.null2String(request.getParameter("isfromtab")).equals("true")?true:false;
String userid = "0" ;
String departmentid = "0" ;
String roleid = "0" ;
String foralluser = "0" ;

if(sharetype.equals("1")) userid = relatedshareid ;
if(sharetype.equals("2")) departmentid = relatedshareid ;
if(sharetype.equals("3")) roleid = relatedshareid ;
if(sharetype.equals("4")) foralluser = "1" ;

String module=Util.null2String((String)request.getParameter("module"));
String scope=Util.null2String((String)request.getParameter("scope"));

if(method.equals("delete"))
{
    String user_id = "";
	RecordSet.executeSql("select userid from CRM_ShareInfo where id = "+id);
    if(RecordSet.next()) user_id = RecordSet.getString(1);
	
	RecordSet.executeProc("CRM_ShareInfo_Delete",id);

	ProcPara = CustomerID;
	ProcPara += flag+"ds";
	ProcPara += flag+"0";
	ProcPara += flag+id;
	ProcPara += flag+CurrentDate;
	ProcPara += flag+CurrentTime;
	ProcPara += flag+CurrentUser;
	ProcPara += flag+SubmiterType;
	ProcPara += flag+ClientIP;
	RecordSet.executeProc("CRM_Log_Insert",ProcPara);   	
	
	CrmShareBase.resetContactShare(""+CustomerID);//重新计算该客户的客户联系的共享
}


if(method.equals("add"))
{
	
	String[] relatedshareids=relatedshareid.split(",");
	for(int i=0;i<relatedshareids.length;i++){
		
		if(relatedshareids[i].equals("")) continue;
		String sharevalue=relatedshareids[i];
		
	    if(sharetype.equals("4")) 
	    	sharevalue = "1" ;
	    
	    if(sharetype.equals("1")) userid = sharevalue ;
	    if(sharetype.equals("2")) departmentid = sharevalue ;
	    if(sharetype.equals("3")) roleid = sharevalue ;
	    if(sharetype.equals("4")) foralluser = "1" ;
	    
	    String sql="INSERT INTO CRM_ShareInfo ( relateditemid, sharetype, seclevel, rolelevel, sharelevel, userid, departmentid, roleid, foralluser,contents )"+ 
	    			"VALUES ("+CustomerID+" ,"+sharetype+" ,"+seclevel+" , "+rolelevel+" , "+sharelevel+", "+userid+", "+departmentid+", "+roleid+", "+foralluser+", "+sharevalue+")";
	    
		if(RecordSet.execute(sql)){
			String shareid = "";
			RecordSet.execute("select max(id) as id from CRM_ShareInfo where relateditemid="+CustomerID+"  and contents="+sharevalue);
			if(RecordSet.next()){
				shareid = RecordSet.getString("id");
			}
		
		if(sharetype.equals("3")){
		    String crm_manager = "";
		    RecordSet.executeSql("select manager from crm_customerinfo where id="+CustomerID);
		    if(RecordSet.next()) crm_manager = RecordSet.getString("manager");
		    int crm_manager_dept = Util.getIntValue(ResourceComInfo.getDepartmentID(crm_manager),-1);//部门id
		    int crm_manager_com = Util.getIntValue(ResourceComInfo.getSubCompanyID(crm_manager),-1);//分部id
		    if(rolelevel.equals("0"))
		        RecordSet.executeSql("update CRM_ShareInfo set deptorcomid="+crm_manager_dept+" where relateditemid="+CustomerID+" and id="+shareid);
		    else if(rolelevel.equals("1"))
		        RecordSet.executeSql("update CRM_ShareInfo set deptorcomid="+crm_manager_com+" where relateditemid="+CustomerID+" and id="+shareid);
		}
	}
    
	//打印日志
	String Remark="sharetype:"+sharetype+"seclevel:"+seclevel+"rolelevel:"+rolelevel+"sharelevel:"+sharelevel+"userid:"+userid+"departmentid:"+departmentid+"roleid:"+roleid+"foralluser:"+foralluser;
	ProcPara = CustomerID;
	ProcPara += flag+"ns";
	ProcPara += flag+"0";
	ProcPara += flag+Remark;
	ProcPara += flag+CurrentDate;
	ProcPara += flag+CurrentTime;
	ProcPara += flag+CurrentUser;
	ProcPara += flag+SubmiterType;
	ProcPara += flag+ClientIP;
	RecordSet.executeProc("CRM_Log_Insert",ProcPara);

	//CrmViewer.setCrmShareByCrm(""+CustomerID);
	RecordSet.executeSql("select max(id) as shareobjid from CRM_ShareInfo where relateditemid="+CustomerID+"  and contents="+sharevalue);
	RecordSet.next();
	String shareobjid = RecordSet.getString("shareobjid");
	CrmShareBase.setCRM_WPShare_newCRMShare(""+CustomerID,shareobjid);
	
	}
	//System.out.println("/mobile/plugin/crm/CrmAddShare.jsp?module="+module+"&scope="+scope+"&CustomerID="+CustomerID);
	//response.sendRedirect("/mobile/plugin/crm/CrmAddShare.jsp?module="+module+"&scope="+scope+"&CustomerID="+CustomerID);
	//String url="/mobile/plugin/crm/CrmAddShare.jsp?module="+module+"&scope="+scope+"&customerid="+CustomerID;
	//out.println("<script>window.location.href='"+url+"'</script>");
}

if(method.equals("edit"))
{
	String oldsharetype = "";
	String oldcontents = "";
	String oldroleid = "";
	String oldrolelevel = "";
	String oldforalluser = "";
	String oldseclevel = "";
	RecordSet.executeSql("select * from CRM_ShareInfo where id="+id);
	if(RecordSet.next()){
	    oldsharetype = RecordSet.getString("sharetype");
	    oldcontents = RecordSet.getString("contents");
	    oldroleid = RecordSet.getString("roleid");
	    oldrolelevel = RecordSet.getString("rolelevel");
	    oldforalluser = RecordSet.getString("foralluser");
	    oldseclevel = RecordSet.getString("seclevel");
	}
	
	ProcPara = id;
	ProcPara += CustomerID;
	ProcPara += flag+sharetype;
	ProcPara += flag+seclevel;
	ProcPara += flag+rolelevel;
	ProcPara += flag+sharelevel;
	ProcPara += flag+userid;
	ProcPara += flag+departmentid;
	ProcPara += flag+roleid;
	ProcPara += flag+foralluser;
	String tempcontents="";
    if(sharetype.equals("1")) tempcontents = userid ;
    if(sharetype.equals("2")) tempcontents = departmentid ;
    if(sharetype.equals("3")) tempcontents = roleid ;
    if(sharetype.equals("4")) tempcontents = "1" ;
    ProcPara += flag+tempcontents;
	RecordSet.executeProc("CRM_ShareInfo_Update",ProcPara);
	if(sharetype.equals("3")){
	    String crm_manager = "";
	    RecordSet.executeSql("select manager from crm_customerinfo where id="+CustomerID);
	    if(RecordSet.next()) crm_manager = RecordSet.getString("manager");
	    int crm_manager_dept = Util.getIntValue(ResourceComInfo.getDepartmentID(crm_manager),-1);//部门id
	    int crm_manager_com = Util.getIntValue(ResourceComInfo.getSubCompanyID(crm_manager),-1);//分部id
	    if(rolelevel.equals("0"))
	        RecordSet.executeSql("update CRM_ShareInfo set deptorcomid="+crm_manager_dept+" where relateditemid="+CustomerID+" and id="+id);
	    else if(rolelevel.equals("1"))
	        RecordSet.executeSql("update CRM_ShareInfo set deptorcomid="+crm_manager_com+" where relateditemid="+CustomerID+" and id="+id);
	}
	//CrmViewer.setCrmShareByCrm(""+CustomerID);
	//编辑共享时重新计算客户联系的共享。
	if(!sharetype.equals(oldsharetype)||!tempcontents.equals(oldcontents)||!roleid.equals(oldroleid)||!rolelevel.equals(oldrolelevel)||!foralluser.equals(oldforalluser)||!seclevel.equals(oldseclevel)) 
	    CrmShareBase.resetContactShare(""+CustomerID);

	response.sendRedirect("/CRM/data/ViewCustomer.jsp?CustomerID="+CustomerID);
	return;
}
%>
