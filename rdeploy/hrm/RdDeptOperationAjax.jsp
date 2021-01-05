<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@page import="weaver.conn.RecordSet"%>
<%@page import="weaver.matrix.MatrixUtil"%>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="OrganisationCom" class="weaver.rtx.OrganisationCom" scope="page" />
<jsp:useBean id="HrmServiceManager" class="weaver.interfaces.hrm.HrmServiceManager" scope="page" />
<%!
private void deleteInto(int departmentid){
    if(departmentid <= 0){
        return;
    }
    RecordSet rs = new RecordSet();
    String sql = "select f.matrixid from MatrixFieldInfo f inner join MatrixInfo m on f.matrixid = m.id where m.issystem = 2";
    rs.executeSql(sql);
    int matrixid = -1;
    if(rs.next()){
        matrixid = rs.getInt(1);
    }
    if(matrixid != -1){
        String insertMSql = "delete from Matrixtable_"+matrixid+"  where id = '"+departmentid+"'";
        rs.executeSql(insertMSql);
    }
}

%>
<%
HttpServletRequest fu = request;
int userId = Util.getIntValue(fu.getParameter("other"),0);
String departmentname = Util.null2String(fu.getParameter("departmentname"));


String allsupdepid = "";
String sURL="";
String msg="";

	boolean canDelete = true;
	int id = Util.getIntValue(fu.getParameter("id"),0);
     char separator = Util.getSeparator() ;
	String para = ""+id;
/*
    原有的判断数据中心删除部门去掉
    String sql = "select count(id) from HrmCostcenter where departmentid = "+id;
	RecordSet.executeSql(sql);
	RecordSet.next();
	if(RecordSet.getInt(1)>0){
	    canDelete = false;
		response.sendRedirect("HrmDepartmentEdit.jsp?id="+id+"&msgid=20");
	} */

	String sql = "select count(id) from HrmJobTitles where jobdepartmentid ="+id;
	RecordSet.executeSql(sql);
	RecordSet.next();
	if(RecordSet.getInt(1)>0){
	    canDelete = false;
	    out.print("{\"success\":\"1\",\"flag\":\"1\"}");
        return ;
	}

/*
    原有的判断部门工作时间删除部门去掉
	 sql = "select count(id) from HrmSchedule where relatedid ="+id+" and scheduletype = 1";
	RecordSet.executeSql(sql);
	RecordSet.next();
	if(RecordSet.getInt(1)>0){
	    canDelete = false;
		response.sendRedirect("HrmDepartmentEdit.jsp?id="+id+"&msgid=20");
	} */

/*
    原有的判断部门下面人力资源删除部门去掉，由控制岗位来实现
	 sql = "select count(id) from HrmResource where departmentid ="+id;
	RecordSet.executeSql(sql);
	RecordSet.next();
	if(RecordSet.getInt(1)>0){
	    canDelete = false;
		response.sendRedirect("HrmDepartmentEdit.jsp?id="+id+"&msgid=20");
	} */

	if(canDelete){
	    RecordSet.executeProc("HrmDepartment_Delete",para);
        //add by wjy
        //同步RTX端部门信息
        OrganisationCom.deleteDepartment(id);

		//OA与第三方接口单条数据同步方法开始
        HrmServiceManager.SynInstantDepartment(""+id,"3");
        //OA与第三方接口单条数据同步方法结束
	}else{
	    out.print("{\"success\":\"1\",\"flag\":\"3\"}");
	    return ; 
	}
      SysMaintenanceLog.resetParameter();
      SysMaintenanceLog.setRelatedId(id);
      SysMaintenanceLog.setRelatedName(departmentname);
      SysMaintenanceLog.setOperateType("3");
      SysMaintenanceLog.setOperateDesc("HrmDepartment_Delete,"+para);
      SysMaintenanceLog.setOperateItem("12");
      SysMaintenanceLog.setOperateUserid(userId);
      SysMaintenanceLog.setClientAddress(fu.getRemoteAddr());
      SysMaintenanceLog.setSysLogInfo();
    String supid=DepartmentComInfo.getDepartmentsupdepid(""+id);
	DepartmentComInfo.removeCompanyCache();
    RecordSet.executeSql("update orgchartstate set needupdate=1");

    //同步部门数据到矩阵
    deleteInto(id);
    
    out.print("{\"success\":\"0\"}");
    
    return ;    
%>