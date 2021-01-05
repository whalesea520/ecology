<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.hrm.common.DbFunctionUtil" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="JobGroupsComInfo" class="weaver.hrm.job.JobGroupsComInfo" scope="page" />
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
String operation = Util.fromScreen(request.getParameter("operation"),user.getLanguage());
String isBrowser = Util.null2String(request.getParameter("isBrowser"));
String getjobgroupname = Util.fromScreen(request.getParameter("jobgroupname"),user.getLanguage());
String getjobgroupremark = Util.fromScreen(request.getParameter("jobgroupremark"),user.getLanguage());
String jobgroupname=Util.forHtml(getjobgroupname);
String jobgroupremark=Util.forHtml(getjobgroupremark);
if(operation.equals("add")){
	if(!HrmUserVarify.checkUserRight("HrmJobGroupsAdd:Add", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
     char separator = Util.getSeparator() ;
  	
	String para = jobgroupname + separator  + jobgroupremark;	
	RecordSet.executeProc("HrmJobGroups_Insert",para);
	int id=0;
	
	if(RecordSet.next()){
		id = RecordSet.getInt(1);
	}
	
	 RecordSet.execute("update hrmjobgroups set "+DbFunctionUtil.getInsertUpdateSetSql(RecordSet.getDBType(),user.getUID())+" where id="+id) ;
      SysMaintenanceLog.resetParameter();
      SysMaintenanceLog.setRelatedId(id);
      SysMaintenanceLog.setRelatedName(jobgroupname);
      SysMaintenanceLog.setOperateType("1");
      SysMaintenanceLog.setOperateDesc("HrmJobGroups_Insert,"+para);
      SysMaintenanceLog.setOperateItem("24");
      SysMaintenanceLog.setOperateUserid(user.getUID());
      SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
      SysMaintenanceLog.setSysLogInfo();

	JobGroupsComInfo.removeCompanyCache();
	if(isBrowser.equals("1")){
 		response.sendRedirect("HrmJobGroupsAddBrowser.jsp?isclose=1&id="+id);
	}else{
		response.sendRedirect("HrmJobGroupsAdd.jsp?isclose=1&id="+id);
	}
 }
 
else if(operation.equals("edit")){
	if(!HrmUserVarify.checkUserRight("HrmJobGroupsEdit:Edit", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
     char separator = Util.getSeparator() ;
  	int id = Util.getIntValue(request.getParameter("id"));
	String para = ""+id +  separator + jobgroupname + separator + jobgroupremark;
	out.println(para);
	out.println(RecordSet.executeProc("HrmJobGroups_Update",para));
	
	RecordSet.execute("update hrmjobgroups set "+DbFunctionUtil.getUpdateSetSql(RecordSet.getDBType(),user.getUID())+" where id="+id) ;
	
      SysMaintenanceLog.resetParameter();
      SysMaintenanceLog.setRelatedId(id);
      SysMaintenanceLog.setRelatedName(jobgroupname);
      SysMaintenanceLog.setOperateType("2");
      SysMaintenanceLog.setOperateDesc("HrmJobGroups_Update,"+para);
      SysMaintenanceLog.setOperateItem("24");
      SysMaintenanceLog.setOperateUserid(user.getUID());
      SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
      SysMaintenanceLog.setSysLogInfo();

		JobGroupsComInfo.removeCompanyCache();
 	response.sendRedirect("HrmJobGroupsEdit.jsp?isclose=1&id="+id);
 }
 else if(operation.equals("delete")){
 	if(!HrmUserVarify.checkUserRight("HrmJobGroupsEdit:Delete", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
     char separator = Util.getSeparator() ;
  	int id = Util.getIntValue(request.getParameter("id"));
	String para = ""+id;
	
	String sql = "select count(id) from HrmJobActivities where jobgroupid = "+id;
	RecordSet.executeSql(sql);
	RecordSet.next();	
	if(RecordSet.getInt(1)>0){
		response.sendRedirect("HrmJobGroups.jsp?jobgroup="+id+"&msgid=20");
		return;
	}else{		
		RecordSet.executeProc("HrmJobGroups_Delete",para);
	}	
      SysMaintenanceLog.resetParameter();
      SysMaintenanceLog.setRelatedId(id);
      SysMaintenanceLog.setRelatedName(jobgroupname);
      SysMaintenanceLog.setOperateType("3");
      SysMaintenanceLog.setOperateDesc("HrmJobGroups_Delete,"+para);
      SysMaintenanceLog.setOperateItem("24");
      SysMaintenanceLog.setOperateUserid(user.getUID());
      SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
      SysMaintenanceLog.setSysLogInfo();

	JobGroupsComInfo.removeCompanyCache();
 	response.sendRedirect("HrmJobGroupsEdit.jsp?isclose=1");
 }
%>
 <input type="button" name="Submit2" value="<%=SystemEnv.getHtmlLabelName(236,user.getLanguage())%>" onClick="javascript:history.go(-1)">