
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="weaver.general.Util"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DepartmentVirtualComInfo" class="weaver.hrm.companyvirtual.DepartmentVirtualComInfo" scope="page" />
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<jsp:useBean id="SubCompanyVirtualComInfo" class="weaver.hrm.companyvirtual.SubCompanyVirtualComInfo" scope="page" />
<%
	String cancelFlag = request.getParameter("cancelFlag");
	int deptorsupid = Util.getIntValue(request.getParameter("deptorsupid"));
	int userid = Util.getIntValue(request.getParameter("userid"));
	String operation = Util.null2String(request.getParameter("operation"));
	String deptorsubname = "";
	String sqlname = "";
	if ("subcompany".equals(operation)) {
	    sqlname = "select subcompanyname from HrmSubCompanyVirtual where id = "+deptorsupid;
	    rs.executeSql(sqlname);
	    if(rs.next()) deptorsubname = rs.getString("subcompanyname");
		if ("1".equals(cancelFlag)) {
			RecordSet.executeSql("select id from HrmSubCompanyVirtual where canceled ='1' and id = (select supsubcomid from HrmSubCompanyVirtual where id ="+deptorsupid+")");
			if(RecordSet.next()) {
				out.println("0");
			} else {
				RecordSet.executeSql("update HrmSubCompanyVirtual set canceled = '0' where id ="+ deptorsupid);
				SubCompanyVirtualComInfo.removeSubCompanyCache();
				
				SysMaintenanceLog.resetParameter();
				SysMaintenanceLog.setRelatedId(deptorsupid);
				SysMaintenanceLog.setRelatedName(deptorsubname);
				SysMaintenanceLog.setOperateType("11");
				SysMaintenanceLog.setOperateItem("413");
				SysMaintenanceLog.setOperateUserid(userid);
				SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
				SysMaintenanceLog.setSysLogInfo();
				
				out.println("1");
			}
		} else {
			String sqlstr = "select id from hrmdepartmentVirtual where (canceled = '0' or canceled is null) "
			+ " and exists (select 1 from HrmSubCompanyVirtual b where hrmdepartmentVirtual.subcompanyid1 = b.id and b.id ="
			+ deptorsupid
			+ ")"
			+ " union"
			+ " select id from HrmSubCompanyVirtual where (canceled = '0' or canceled is null) and id in (select id from HrmSubCompanyVirtual where supsubcomid ="
			+ deptorsupid + ")";
			
			RecordSet.executeSql(sqlstr);
			if (RecordSet.next()) {
				out.println("0");
			} else {
				RecordSet.executeSql("update HrmSubCompanyVirtual set canceled = '1' where id ="+ deptorsupid);
				SubCompanyVirtualComInfo.removeSubCompanyCache();
				
				SysMaintenanceLog.resetParameter();
				SysMaintenanceLog.setRelatedId(deptorsupid);
				SysMaintenanceLog.setRelatedName(deptorsubname);
				SysMaintenanceLog.setOperateType("10");
				SysMaintenanceLog.setOperateItem("413");
				SysMaintenanceLog.setOperateUserid(userid);
				SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
				SysMaintenanceLog.setSysLogInfo();
				
				out.println("1");
			}
		}
	} else {
	    sqlname = "select departmentname from hrmdepartmentVirtual where id = "+deptorsupid;
	    rs.executeSql(sqlname);
	    if(rs.next()) deptorsubname = rs.getString("departmentname");
	    
		if ("1".equals(cancelFlag)) {
			RecordSet.executeSql("select id from HrmSubCompanyVirtual where canceled ='1' and id = (select subcompanyid1 from hrmdepartmentVirtual where id = "+deptorsupid+")");
			if(RecordSet.next()){
				out.println("0");
			} else {
				RecordSet.executeSql("select id from hrmdepartmentVirtual where canceled ='1' and id = (select supdepid from hrmdepartmentVirtual where id = "+deptorsupid+")");
				if(RecordSet.next()) {
					out.println("2");
				} else {
					RecordSet.executeSql("update hrmdepartmentVirtual set canceled = '0' where id ="+ deptorsupid);
					DepartmentVirtualComInfo.removeDepartmentCache();
		
					SysMaintenanceLog.resetParameter();
					SysMaintenanceLog.setRelatedId(deptorsupid);
					SysMaintenanceLog.setRelatedName(deptorsubname);
					SysMaintenanceLog.setOperateType("11");
					SysMaintenanceLog.setOperateItem("414");
					SysMaintenanceLog.setOperateUserid(userid);
					SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
					SysMaintenanceLog.setSysLogInfo();
					out.println("1");
				}
			}
		} else {
			String sqlstr = "select id from hrmresourceVirtaul where "
			+ " EXISTS (select 1 from hrmdepartmentVirtual b where hrmresourceVirtaul.departmentid=b.id and b.id = "
			+ deptorsupid
			+ ")"
			+ " union"
			+ " select id from hrmdepartmentVirtual where (canceled = '0' or canceled is null) and id in (select id from hrmdepartmentVirtual where supdepid = "
			+ deptorsupid + ")";
			RecordSet.executeSql(sqlstr);
			if (RecordSet.next()) {
		        out.println("0");
			} else {
				RecordSet.executeSql("update hrmdepartmentVirtual set canceled = '1' where id ="+ deptorsupid);
				DepartmentVirtualComInfo.removeDepartmentCache();
		
				SysMaintenanceLog.resetParameter();
				SysMaintenanceLog.setRelatedId(deptorsupid);
				SysMaintenanceLog.setRelatedName(deptorsubname);
				SysMaintenanceLog.setOperateType("10");
				SysMaintenanceLog.setOperateItem("414");
				SysMaintenanceLog.setOperateUserid(userid);
				SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
				SysMaintenanceLog.setSysLogInfo();
		
				out.println("1");
			}
		}
	}
%>
