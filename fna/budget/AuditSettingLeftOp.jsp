<%@page import="weaver.systeminfo.SystemEnv"%>
<%@page import="org.json.JSONObject"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*,java.sql.Timestamp" %>
<%@ page import="weaver.general.GCONST" %>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<%
String result = "{\"flag\":false,\"msg\":\"\"}";

User user = HrmUserVarify.getUser (request , response) ;
boolean hasPriv = HrmUserVarify.checkUserRight("FnaBudget:All", user);
if (!hasPriv) {
    response.sendRedirect("/notice/noright.jsp");
    return;
}
if(user == null){
	result = "{\"flag\":false,\"msg\":\""+SystemEnv.getHtmlLabelName(83328, user.getLanguage())+"\"}";
}else{
	String nodeId = Util.null2String(request.getParameter("nodeId")).trim();
	int wfId = Util.getIntValue(request.getParameter("wfId"), 0);
	boolean synSubOrg = "true".equalsIgnoreCase(Util.null2String(request.getParameter("synSubOrg")).trim());
	//System.out.println("nodeId="+nodeId+";wfId="+wfId+";synSubOrg="+synSubOrg);
	
	String orgType = nodeId.split("_")[0];
	int orgId = Util.getIntValue(nodeId.split("_")[1], 0);
	
	if("c".equalsIgnoreCase(orgType)){
		if(wfId == 0){
			String sql1 = "delete from BudgetAuditMapping where subcompanyid = 0";
			rs1.executeSql(sql1);
			if(synSubOrg){
				sql1 = "delete from BudgetAuditMapping";
				rs1.executeSql(sql1);
			}
		}else{
			String sql1 = "delete from BudgetAuditMapping where subcompanyid = 0";
			rs1.executeSql(sql1);
			sql1 = "insert into BudgetAuditMapping (subcompanyid, workflowid) values (0, "+wfId+")";
			rs1.executeSql(sql1);
			if(synSubOrg){
				sql1 = "select id from HrmSubCompany";
				rs1.executeSql(sql1);
				while(rs1.next()){
					int subcompanyid = rs1.getInt("id");

					String dsql2 = "delete from BudgetAuditMapping where subcompanyid = "+subcompanyid+" ";
					rs2.executeSql(dsql2);

					String sql2 = "insert into BudgetAuditMapping (subcompanyid, workflowid) values ("+subcompanyid+", "+wfId+")";
					rs2.executeSql(sql2);
				}
			}
		}
		result = "{\"flag\":true,\"msg\":"+JSONObject.quote(SystemEnv.getHtmlLabelName(18758,user.getLanguage()))+",\"reloadId\":\"c_0\"}";//保存成功
	}else if("s".equalsIgnoreCase(orgType)){
		if(wfId == 0){
			String sql1 = "delete from BudgetAuditMapping where subcompanyid = "+orgId;
			rs1.executeSql(sql1);
			
			if(synSubOrg){
				sql1 = "WITH allsub(id,subcompanyname,supsubcomid)\n" +
					" as (\n" +
					" SELECT id,subcompanyname ,supsubcomid FROM HrmSubCompany where id="+orgId+" \n" +
					"  UNION ALL SELECT a.id,a.subcompanyname,a.supsubcomid FROM HrmSubCompany a,allsub b where a.supsubcomid = b.id\n" +
					" ) select * from allsub";
				if("oracle".equals(rs1.getDBType())){
					sql1 = "select a.id from hrmsubcompany a \n" +
						" start with a.id="+orgId+" \n" +
						" connect by prior a.id = a.supsubcomid";
				}
				rs1.executeSql(sql1);
				while(rs1.next()){
					int subcompanyid = rs1.getInt("id");

					String dsql2 = "delete from BudgetAuditMapping where subcompanyid = "+subcompanyid+" ";
					rs2.executeSql(dsql2);
				}
			}
			
		}else{
			String sql1 = "delete from BudgetAuditMapping where subcompanyid = "+orgId;
			rs1.executeSql(sql1);
			sql1 = "insert into BudgetAuditMapping (subcompanyid, workflowid) values ("+orgId+", "+wfId+")";
			rs1.executeSql(sql1);
			
			if(synSubOrg){
				sql1 = "WITH allsub(id,subcompanyname,supsubcomid)\n" +
					" as (\n" +
					" SELECT id,subcompanyname ,supsubcomid FROM HrmSubCompany where id="+orgId+" \n" +
					"  UNION ALL SELECT a.id,a.subcompanyname,a.supsubcomid FROM HrmSubCompany a,allsub b where a.supsubcomid = b.id\n" +
					" ) select * from allsub";
				if("oracle".equals(rs1.getDBType())){
					sql1 = "select a.id from hrmsubcompany a \n" +
						" start with a.id="+orgId+" \n" +
						" connect by prior a.id = a.supsubcomid";
				}
				rs1.executeSql(sql1);
				while(rs1.next()){
					int subcompanyid = rs1.getInt("id");

					String dsql2 = "delete from BudgetAuditMapping where subcompanyid = "+subcompanyid+" ";
					rs2.executeSql(dsql2);

					String sql2 = "insert into BudgetAuditMapping (subcompanyid, workflowid) values ("+subcompanyid+", "+wfId+")";
					rs2.executeSql(sql2);
				}
			}
		}
		
		String reloadId = "c_0";
		String sql1 = "select a.supsubcomid from HrmSubCompany a where a.id = "+orgId;
		rs1.executeSql(sql1);
		if(rs1.next()){
			int supsubcomid = rs1.getInt("supsubcomid");
			if(supsubcomid > 0){
				reloadId = "s_"+supsubcomid;
			}
		}
		result = "{\"flag\":true,\"msg\":"+JSONObject.quote(SystemEnv.getHtmlLabelName(18758,user.getLanguage()))+",\"reloadId\":\""+reloadId+"\"}";//保存成功
		
	}else if("fcc".equalsIgnoreCase(orgType)){
		String sql1 = "delete from BudgetAuditMapping where fccId = "+orgId;
		rs1.executeSql(sql1);
		sql1 = "insert into BudgetAuditMapping (fccId, workflowid) values ("+orgId+", "+wfId+")";
		rs1.executeSql(sql1);
		
		if(synSubOrg){
			sql1 = "WITH allsub(id,name,supFccId)\n" +
				" as (\n" +
				" SELECT id,name ,supFccId FROM FnaCostCenter where id="+orgId+" \n" +
				"  UNION ALL SELECT a.id,a.name,a.supFccId FROM FnaCostCenter a,allsub b where a.supFccId = b.id\n" +
				" ) select * from allsub";
			if("oracle".equals(rs1.getDBType())){
				sql1 = "select a.id from FnaCostCenter a \n" +
					" start with a.id="+orgId+" \n" +
					" connect by prior a.id = a.supFccId";
			}
			rs1.executeSql(sql1);
			while(rs1.next()){
				int fccId = rs1.getInt("id");

				String dsql2 = "delete from BudgetAuditMapping where fccId = "+fccId+" ";
				rs2.executeSql(dsql2);

				String sql2 = "insert into BudgetAuditMapping (fccId, workflowid) values ("+fccId+", "+wfId+")";
				rs2.executeSql(sql2);
			}
		}


		String dsql2 = "DELETE from BudgetAuditMapping \n" +
				" where EXISTS (select 1 from FnaCostCenter a where a.id = fccId and a.type = 0) "+
				" and fccId is not null";
		rs2.executeSql(dsql2);
	
		String reloadId = "fcc_"+orgId;
		result = "{\"flag\":true,\"msg\":"+JSONObject.quote(SystemEnv.getHtmlLabelName(18758,user.getLanguage()))+",\"reloadId\":\""+reloadId+"\"}";//保存成功
		
	}


	String dsql2 = "DELETE from BudgetAuditMapping \n" +
			" where workflowid = 0 or workflowid is null";
	rs2.executeSql(dsql2);
}
//System.out.println("result="+result);
%><%=result %>