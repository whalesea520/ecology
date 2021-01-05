
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@page import="weaver.crm.customer.CustomerShareUtil"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*"%>
<%@ page import="java.sql.Timestamp"%>
<%@ page import="weaver.general.Util"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page" />

<%
	char flag = 2;
	String ProcPara = "";
	String id = Util.null2String(request.getParameter("id"));
	String method = Util.null2String(request.getParameter("method"));
	String CustomerID = Util.null2String(request.getParameter("CustomerID"));
	String relatedshareid = Util.null2String(request.getParameter("relatedshareid"));
	String sharetype = Util.null2String(request.getParameter("sharetype"));
	String rolelevel = Util.null2String(request.getParameter("rolelevel")); //角色对应的级别【部门，分部，总部】
	String seclevel = Math.min(Util.getIntValue(request.getParameter("seclevel")) , Util.getIntValue(request.getParameter("seclevelMax")))+"";
	String seclevelMax = Math.max(Util.getIntValue(request.getParameter("seclevel")) , Util.getIntValue(request.getParameter("seclevelMax")))+"";
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
	
	String sharelevel = Util.null2String(request.getParameter("sharelevel"));
	String CurrentUser = "" + user.getUID();
	String ClientIP = request.getRemoteAddr();
	String SubmiterType = "" + user.getLogintype();

	Date newdate = new Date();
	long datetime = newdate.getTime();
	Timestamp timestamp = new Timestamp(datetime);
	String CurrentDate = (timestamp.toString()).substring(0, 4) + "-"+ (timestamp.toString()).substring(5, 7) + "-"+ (timestamp.toString()).substring(8, 10);
	String CurrentTime = (timestamp.toString()).substring(11, 13) + ":"+ (timestamp.toString()).substring(14, 16) + ":"+ (timestamp.toString()).substring(17, 19);
	boolean isfromtab = Util.null2String(request.getParameter("isfromtab")).equals("true") ? true : false;
	String userid = "0";
	String departmentid = "0";
	String roleid = "0";
	String foralluser = "0";
	String subcompanyid = "0";
	if (sharetype.equals("1"))
		userid = relatedshareid;
	if (sharetype.equals("2"))
		departmentid = relatedshareid;
	if (sharetype.equals("3"))
		roleid = relatedshareid;
	if (sharetype.equals("4"))
		foralluser = "1";
	if(sharetype.equals("6")) jobtitleid = relatedshareid ;
	
	jobtitleid = ","+jobtitleid+",";
	
	if (method.equals("delete")) {

		RecordSet.executeProc("CRM_ShareInfo_Delete", id);

		ProcPara = CustomerID;
		ProcPara += flag + "ds";
		ProcPara += flag + "0";
		ProcPara += flag + id;
		ProcPara += flag + CurrentDate;
		ProcPara += flag + CurrentTime;
		ProcPara += flag + CurrentUser;
		ProcPara += flag + SubmiterType;
		ProcPara += flag + ClientIP;
		RecordSet.executeProc("CRM_Log_Insert", ProcPara);

		//CrmViewer.setCrmShareByCrm(""+CustomerID);
		CrmShareBase.resetContactShare("" + CustomerID);//重新计算该客户的客户联系的共享

		response.sendRedirect("/CRM/data/ViewCustomer.jsp?log=n&CustomerID=" + CustomerID);
		return;
	}
	if (method.equals("batchDelete")) {
		
		RecordSet.executeSql("delete from CRM_ShareInfo where id in ("+id+")");
		
		ArrayList delidsArray = Util.TokenizerString(id,",");
	  	for(int i=0;i<delidsArray.size();i++){//删除指定的字段
			ProcPara = CustomerID;
			ProcPara += flag + "ds";
			ProcPara += flag + "0";
			ProcPara += flag + delidsArray.get(i).toString();
			ProcPara += flag + CurrentDate;
			ProcPara += flag + CurrentTime;
			ProcPara += flag + CurrentUser;
			ProcPara += flag + SubmiterType;
			ProcPara += flag + ClientIP;
			RecordSet.executeProc("CRM_Log_Insert", ProcPara);
		}	

		response.sendRedirect("/CRM/data/ViewCustomer.jsp?log=n&CustomerID=" + CustomerID);
		return;
	}


	if (method.equals("add")) {
		CustomerShareUtil.addCustomerShare(CurrentUser,CustomerID,sharetype,relatedshareid,seclevel,seclevelMax,sharelevel,"0",jobtitleid,jobtitlelevel,scopeid);  
		if (!isfromtab)
			response.sendRedirect("/CRM/data/ViewCustomer.jsp?log=n&CustomerID="+ CustomerID);
		else
			out.print("<script>parent.getParentWindow(window).addShareCallback();</script>");
		return;
	}

	if (method.equals("edit")) {
		String oldsharetype = "";
		String oldcontents = "";
		String oldroleid = "";
		String oldrolelevel = "";
		String oldforalluser = "";
		String oldseclevel = "";
		RecordSet.executeSql("select * from CRM_ShareInfo where id="+ id);
		if (RecordSet.next()) {
			oldsharetype = RecordSet.getString("sharetype");
			oldcontents = RecordSet.getString("contents");
			oldroleid = RecordSet.getString("roleid");
			oldrolelevel = RecordSet.getString("rolelevel");
			oldforalluser = RecordSet.getString("foralluser");
			oldseclevel = RecordSet.getString("seclevel");
		}

		ProcPara = id;
		ProcPara += CustomerID;
		ProcPara += flag + sharetype;
		ProcPara += flag + seclevel;
		ProcPara += flag + rolelevel;
		ProcPara += flag + sharelevel;
		ProcPara += flag + userid;
		ProcPara += flag + departmentid;
		ProcPara += flag + roleid;
		ProcPara += flag + foralluser;
		String tempcontents = "";
		if (sharetype.equals("1"))
			tempcontents = userid;
		if (sharetype.equals("2"))
			tempcontents = departmentid;
		if (sharetype.equals("3"))
			tempcontents = roleid;
		if (sharetype.equals("4"))
			tempcontents = "1";
		ProcPara += flag + tempcontents;
		RecordSet.executeProc("CRM_ShareInfo_Update", ProcPara);
		if (sharetype.equals("3")) {
			String crm_manager = "";
			RecordSet.executeSql("select manager from crm_customerinfo where id="+ CustomerID);
			if (RecordSet.next())
				crm_manager = RecordSet.getString("manager");
			int crm_manager_dept = Util.getIntValue(ResourceComInfo
					.getDepartmentID(crm_manager), -1);//部门id
			int crm_manager_com = Util.getIntValue(ResourceComInfo
					.getSubCompanyID(crm_manager), -1);//分部id
			if (rolelevel.equals("0"))
				RecordSet.executeSql("update CRM_ShareInfo set deptorcomid="
								+ crm_manager_dept
								+ " where relateditemid="
								+ CustomerID
								+ " and id=" + id);
			else if (rolelevel.equals("1"))
				RecordSet.executeSql("update CRM_ShareInfo set deptorcomid="
								+ crm_manager_com
								+ " where relateditemid="
								+ CustomerID
								+ " and id=" + id);
		}
		//CrmViewer.setCrmShareByCrm(""+CustomerID);
		//编辑共享时重新计算客户联系的共享。
		if (!sharetype.equals(oldsharetype)
				|| !tempcontents.equals(oldcontents)
				|| !roleid.equals(oldroleid)
				|| !rolelevel.equals(oldrolelevel)
				|| !foralluser.equals(oldforalluser)
				|| !seclevel.equals(oldseclevel))
			CrmShareBase.resetContactShare("" + CustomerID);

		response.sendRedirect("/CRM/data/ViewCustomer.jsp?CustomerID="
				+ CustomerID);
		return;
	}
%>
