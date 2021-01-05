<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.hrm.common.DbFunctionUtil"%> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="JobActivitiesComInfo" class="weaver.hrm.job.JobActivitiesComInfo" scope="page" />
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
String operation = Util.fromScreen(request.getParameter("operation"),user.getLanguage());
String jobactivitymark = Util.fromScreen(request.getParameter("jobactivitymark"),user.getLanguage());
String jobactivityname = Util.fromScreen(request.getParameter("jobactivityname"),user.getLanguage());
String joblevelfrom = Util.fromScreen(request.getParameter("joblevelfrom"),user.getLanguage());
String joblevelto = Util.fromScreen(request.getParameter("joblevelto"),user.getLanguage());
String jobgroupid = Util.fromScreen(request.getParameter("jobgroupid"),user.getLanguage());
String from = Util.fromScreen(request.getParameter("from"),user.getLanguage());
String isBrowser = Util.null2String(request.getParameter("isBrowser"));
String[] competency = request.getParameterValues("competency");

if(operation.equals("add")){
	if(!HrmUserVarify.checkUserRight("HrmJobActivitiesAdd:Add", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
	RecordSet.executeSql("select id from HrmJobActivities where jobactivityname='"+jobactivityname+"' and jobgroupid='"+jobgroupid+"'");
    if(RecordSet.next()){
    	response.sendRedirect("HrmJobActivitiesAdd.jsp?msgid=5&jobgroupid="+jobgroupid);
    	return;
    }	
     char separator = Util.getSeparator() ;
  	
	String para = jobactivitymark + separator + jobactivityname + separator + 
		joblevelfrom + separator + joblevelto + separator + jobgroupid;	
	RecordSet.executeProc("HrmJobActivities_Insert",para);
	int id=0;
	if(RecordSet.next()){
		id = RecordSet.getInt(1);
	}
	// add time
	RecordSet.execute("update HrmJobActivities set "+DbFunctionUtil.getInsertUpdateSetSql(RecordSet.getDBType(),user.getUID())+" where id="+id) ;
	
	if(competency != null) {
		for(int i=0;i < competency.length;i++){
			String para1 = ""+id + separator + competency[i];
			out.print("the competency:"+para1);
			RecordSet.executeProc("HrmActivitiesCompetency_Insert",para1);		
		}
	}

      SysMaintenanceLog.resetParameter();
      SysMaintenanceLog.setRelatedId(id);
      SysMaintenanceLog.setRelatedName(jobactivityname);
      SysMaintenanceLog.setOperateType("1");
      SysMaintenanceLog.setOperateDesc("HrmJobActivities_Insert,"+para);
      SysMaintenanceLog.setOperateItem("25");
      SysMaintenanceLog.setOperateUserid(user.getUID());
      SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
      SysMaintenanceLog.setSysLogInfo();

	JobActivitiesComInfo.removeJobActivitiesCache();
	response.sendRedirect("HrmJobActivitiesAdd.jsp?isBrowser="+isBrowser+"&isclose=1&id="+id+"&from="+from);
 }
 
else if(operation.equals("edit")){
	if(!HrmUserVarify.checkUserRight("HrmJobActivitiesEdit:Edit", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
	int id = Util.getIntValue(request.getParameter("id"));
	RecordSet.executeSql("select id from HrmJobActivities where jobactivityname='"+jobactivityname+"' and jobgroupid='"+jobgroupid+"' and id not in('"+id+"')");
    if(RecordSet.next()){
    	response.sendRedirect("HrmJobActivitiesEdit.jsp?id="+id+"&errid=5");
    	return;
    }	
     char separator = Util.getSeparator() ;
  	
	String para = ""+id + separator + jobactivitymark + separator + jobactivityname + separator + 
		joblevelfrom + separator + joblevelto + separator + 
		jobgroupid;		
	RecordSet.executeProc("HrmJobActivities_Update",para);
	
	//update time
	RecordSet.execute("update HrmJobActivities set "+DbFunctionUtil.getUpdateSetSql(RecordSet.getDBType(),user.getUID())+" where id="+id) ;
	
	
	RecordSet.executeProc("HrmActivitiesCompetency_Delete",""+id);	
	if(competency != null) {
		for(int i=0;i < competency.length;i++){
			String para1 = ""+id + separator + competency[i];
			out.print("the competency:"+para1);
			RecordSet.executeProc("HrmActivitiesCompetency_Insert",para1);		
		}
	}
      SysMaintenanceLog.resetParameter();
      SysMaintenanceLog.setRelatedId(id);
      SysMaintenanceLog.setRelatedName(jobactivityname);
      SysMaintenanceLog.setOperateType("2");
      SysMaintenanceLog.setOperateDesc("HrmJobActivities_Update,"+para);
      SysMaintenanceLog.setOperateItem("25");
      SysMaintenanceLog.setOperateUserid(user.getUID());
      SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
      SysMaintenanceLog.setSysLogInfo();

		JobActivitiesComInfo.removeJobActivitiesCache();
 	response.sendRedirect("HrmJobActivitiesEdit.jsp?isclose=1&id="+id);
 }
 else if(operation.equals("delete")){
 	if(!HrmUserVarify.checkUserRight("HrmJobActivitiesEdit:Delete", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
     char separator = Util.getSeparator() ;
  	int id = Util.getIntValue(request.getParameter("id"));
	String para = ""+id;
	
	String sql = "select count(id) from HrmJobTitles where jobactivityid = "+id;
	RecordSet.executeSql(sql);
	RecordSet.next();	
	if(RecordSet.getInt(1)>0){
		response.sendRedirect("HrmJobActivitiesEdit.jsp?isclose=1&id="+id+"&msgid=20");
	}else{		
	RecordSet.executeProc("HrmJobActivities_Delete",para);
	}	

	RecordSet.executeProc("HrmActivitiesCompetency_Delete",""+id);
      SysMaintenanceLog.resetParameter();
      SysMaintenanceLog.setRelatedId(id);
      SysMaintenanceLog.setRelatedName(jobactivityname);
      SysMaintenanceLog.setOperateType("3");
      SysMaintenanceLog.setOperateDesc("HrmJobActivities_Delete,"+para);
      SysMaintenanceLog.setOperateItem("25");
      SysMaintenanceLog.setOperateUserid(user.getUID());
      SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
      SysMaintenanceLog.setSysLogInfo();

	JobActivitiesComInfo.removeJobActivitiesCache();
 	response.sendRedirect("HrmJobActivities.jsp?isclose=1");
 }
%>
 <input type="button" name="Submit2" value="<%=SystemEnv.getHtmlLabelName(236,user.getLanguage())%>" onClick="javascript:history.go(-1)">