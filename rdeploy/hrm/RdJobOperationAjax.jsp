<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@page import="weaver.conn.RecordSet"%>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="OrganisationCom" class="weaver.rtx.OrganisationCom" scope="page" />
<jsp:useBean id="HrmServiceManager" class="weaver.interfaces.hrm.HrmServiceManager" scope="page" />
<%!

/**
 * 判断同一个部门下是否有 相同简称的岗位
 *@param departmentid 部门编号
 *@param jobtitlemark 岗位简称
 *@param id 记录的编号， 新建是应传入 0
 *@author Charoes Huang
 *@Date June 3,2004
 */
private boolean isDuplicatedJobtitle(String departmentid,String jobtitlemark,int id){
	boolean isDuplicated = false;
	RecordSet rs = new RecordSet();
	String sqlStr ="Select Count(*) From HrmJobTitles WHERE id<>"+id +" and jobdepartmentid="+departmentid+" and LTRIM(RTRIM(jobtitlemark))='"+jobtitlemark.trim()+"'";

	rs.executeSql(sqlStr);
	if(rs.next()){
		if(rs.getInt(1) > 0){
			isDuplicated = true;
		}
	}
	return isDuplicated;

}
%>
<%
HttpServletRequest fu = request;
String departmentid = Util.null2String(fu.getParameter("departmentid"));
String jobname = Util.null2String(fu.getParameter("jobname"));

if(isDuplicatedJobtitle(departmentid,jobname,0)){
    out.print("{\"success\":\"1\"}");
}else{
    out.print("{\"success\":\"0\"}");
}
   return ;    
%>