<%@ page import="weaver.general.Util,weaver.conn.*" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="DepartmentVirtualComInfo" class="weaver.hrm.companyvirtual.DepartmentVirtualComInfo" scope="page" />
<jsp:useBean id="SubCompanyVirtualComInfo" class="weaver.hrm.companyvirtual.SubCompanyVirtualComInfo" scope="page" />
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
String operation = Util.fromScreen(request.getParameter("operation"),user.getLanguage());
int id = Util.getIntValue(request.getParameter("id"),0);
String departmentmark = Util.fromScreen(request.getParameter("departmentmark"),user.getLanguage());
String departmentname = Util.fromScreen(request.getParameter("departmentname"),user.getLanguage());
String subcompanyid1 = Util.fromScreen(request.getParameter("subcompanyid1"),user.getLanguage());
String virtualtype = SubCompanyVirtualComInfo.getCompanyid(subcompanyid1);
String supdepid = Util.fromScreen(request.getParameter("supdepid"),user.getLanguage());
String showorder = Util.fromScreen(request.getParameter("showorder"),user.getLanguage());
String allsupdepid = "";
String departmentcode = Util.fromScreen(request.getParameter("departmentcode"),user.getLanguage());
String sql = "";
if(operation.equals("add")){
	sql = " INSERT INTO HrmDepartmentVirtual(departmentname ,departmentcode ,departmentmark ,supdepid ,allsupdepid ,subcompanyid1 , showorder,virtualtype)" + 
	      " values ('"+departmentname+"','"+departmentcode+"','"+departmentmark+"','"+supdepid+"','"+allsupdepid+"','"+subcompanyid1+"',"+showorder+","+virtualtype+")";
	rs.executeSql(sql);
	
	sql="select min(id) as id from HrmDepartmentVirtual ";
	rs.executeSql(sql);
	if(rs.next()){
		id=rs.getInt("id");
	}
	weaver.hrm.company.OrgOperationUtil OrgOperationUtil = new weaver.hrm.company.OrgOperationUtil();
	OrgOperationUtil.updateDepartmentLevel(""+id,"1");
	SysMaintenanceLog.resetParameter();
	SysMaintenanceLog.setRelatedId(id);
	SysMaintenanceLog.setRelatedName(departmentname);
	SysMaintenanceLog.setOperateType("1");
	SysMaintenanceLog.setOperateDesc(sql);
	SysMaintenanceLog.setOperateItem("414");
	SysMaintenanceLog.setOperateUserid(user.getUID());
	SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
	SysMaintenanceLog.setSysLogInfo();
	DepartmentVirtualComInfo.removeDepartmentCache();
 	response.sendRedirect("HrmDepartmentAdd.jsp?isclose=1&id="+id);
}else if(operation.equals("edit")){
	sql = " update HrmDepartmentVirtual set departmentname = '"+departmentname+"' ,departmentcode = '"+departmentcode+"' ,departmentmark='"+departmentmark+"' ,supdepid='"+supdepid+"' ,allsupdepid='"+allsupdepid+"' ,subcompanyid1='"+subcompanyid1+"' ,showorder='"+showorder+"'"+
				" where id = "+id;
	rs.executeSql(sql);
	weaver.hrm.company.OrgOperationUtil OrgOperationUtil = new weaver.hrm.company.OrgOperationUtil();
	OrgOperationUtil.updateDepartmentLevel(""+id,"1");
  
	ArrayList departmentlist = new ArrayList();
	departmentlist = DepartmentVirtualComInfo.getAllChildDeptByDepId(departmentlist,id+"");
  departmentlist.add(id+"");
  for(int i=0;i<departmentlist.size();i++){
  	String listdepartmenttemp = (String)departmentlist.get(i);
  	RecordSet.execute("update HrmDepartmentVirtual set subcompanyid1="+subcompanyid1+" where id="+listdepartmenttemp);
    //TD16048改为逐条修改
		rs.execute("select id, subcompanyid from hrmresourceVirtual where departmentid="+listdepartmenttemp);
    while(rs.next()){
    	int resourceid_tmp = Util.getIntValue(rs.getString(1), 0);
    	RecordSet.execute("update hrmresourcevirtual set subcompanyid="+subcompanyid1+" where id="+resourceid_tmp);
    }
  }

  SysMaintenanceLog.resetParameter();
	SysMaintenanceLog.setRelatedId(id);
	SysMaintenanceLog.setRelatedName(departmentname);
	SysMaintenanceLog.setOperateType("2");
	SysMaintenanceLog.setOperateDesc(sql);
	SysMaintenanceLog.setOperateItem("414");
	SysMaintenanceLog.setOperateUserid(user.getUID());
	SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
	SysMaintenanceLog.setSysLogInfo();
	DepartmentVirtualComInfo.removeDepartmentCache();
	response.sendRedirect("HrmDepartmentEdit.jsp?isclose=1&id="+id);
}else if(operation.equals("delete")){
	boolean canDelete = true;
	rs.executeSql(" select count(*) from HrmResourceVirtual where departmentid in ("+DepartmentVirtualComInfo.getAllChildDepartId(""+id,""+id)+") ");
	if(rs.next()){
		if(rs.getInt(1)>0){
			canDelete = false;
		}
	}
	if(canDelete){
		departmentname = DepartmentVirtualComInfo.getDepartmentname(""+id);
		rs.executeSql(" delete from HrmDepartmentVirtual where id = "+id);
		SysMaintenanceLog.resetParameter();
		SysMaintenanceLog.setRelatedId(id);
		SysMaintenanceLog.setRelatedName(departmentname);
		SysMaintenanceLog.setOperateType("3");
		SysMaintenanceLog.setOperateDesc(sql);
		SysMaintenanceLog.setOperateItem("414");
		SysMaintenanceLog.setOperateUserid(user.getUID());
		SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
		SysMaintenanceLog.setSysLogInfo();
		DepartmentVirtualComInfo.removeDepartmentCache();
	}
 	response.sendRedirect("HrmDepartmentList.jsp?isclose=1");
}
%>
