<%@ page import="weaver.general.Util,weaver.conn.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="JobTitlesTempletComInfo" class="weaver.hrm.job.JobTitlesTempletComInfo" scope="page" />
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%!

/**
 * 判断同一个职务下是否有 相同简称的岗位
 *@param departmentid 部门编号
 *@param jobtitlemark 岗位简称
 *@param id 记录的编号， 新建是应传入 0
 *@author Charoes Huang
 *@Date June 3,2004
 */
private boolean isDuplicatedJobtitle(String jobactivityid,String jobtitlemark,int id){
	boolean isDuplicated = false;
	RecordSet rs = new RecordSet();
	String sqlStr ="Select Count(*) From HrmJobTitlesTemplet WHERE id<>"+id +" and jobactivityid="+jobactivityid+" and LTRIM(RTRIM(jobtitlemark))='"+jobtitlemark.trim()+"'";

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
String operation = Util.fromScreen(request.getParameter("operation"),user.getLanguage());
String isBrowser = Util.fromScreen(request.getParameter("isBrowser"),user.getLanguage());
String jobtitlemark = Util.fromScreen(request.getParameter("jobtitlemark"),user.getLanguage());
String jobtitlename = Util.fromScreen(request.getParameter("jobtitlename"),user.getLanguage());
String jobactivityid = Util.fromScreen(request.getParameter("jobactivityid"),user.getLanguage());
String jobresponsibility = Util.fromScreen(request.getParameter("jobresponsibility"),user.getLanguage());
String jobcompetency = Util.fromScreen(request.getParameter("jobcompetency"),user.getLanguage());
String jobtitleremark = Util.fromScreen(request.getParameter("jobtitleremark"),user.getLanguage());
String jobdoc = Util.fromScreen(request.getParameter("jobdoc"),user.getLanguage());
String[] strObj = {jobtitlemark,jobtitlename,jobactivityid,jobresponsibility,jobdoc,jobcompetency,jobtitleremark} ;
if(operation.equals("add")){
	if(!HrmUserVarify.checkUserRight("HrmJobTitlesAdd:Add", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
     char separator = Util.getSeparator() ;

	/*
	 检查是否存在同一个部门下相同简称的岗位
	 */
    if(isDuplicatedJobtitle(jobactivityid,jobtitlemark,0)){
	    request.getSession().setAttribute("JobTitle.error",strObj);
		String url ="HrmJobTitlesTempletAdd.jsp?message=1&isBrowser="+isBrowser+"";
		response.sendRedirect(url);
    	return;
	}

	String para = jobtitlemark + separator + jobtitlename + separator + jobactivityid + separator + 
		jobresponsibility+ separator + jobcompetency + separator + 
		jobtitleremark;
	
	RecordSet.executeProc("HrmJobTitlesTemplet_Insert",para);
	int id=0;

    if(RecordSet.next()){
                id = RecordSet.getInt(1);
                if(!jobdoc.equals(""))
         RecordSet.executeSql("update HrmJobTitlesTemplet set jobdoc="+jobdoc+" where id="+id);
    }
	
      SysMaintenanceLog.resetParameter();
      SysMaintenanceLog.setRelatedId(id);
      SysMaintenanceLog.setRelatedName(jobtitlename);
      SysMaintenanceLog.setOperateType("1");
      SysMaintenanceLog.setOperateDesc("HrmJobTitlesTemplet_Insert,"+para);
      SysMaintenanceLog.setOperateItem("157");
      SysMaintenanceLog.setOperateUserid(user.getUID());
      SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
      SysMaintenanceLog.setSysLogInfo();


	JobTitlesTempletComInfo.removeJobTitlesTempletCache();
	response.sendRedirect("HrmJobTitlesTempletAdd.jsp?isBrowser="+isBrowser+"&isclose=1&id="+id+"&jobactivityid="+jobactivityid);
 }
 
else if(operation.equals("edit")){   
	if(!HrmUserVarify.checkUserRight("HrmJobTitlesEdit:Edit", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
     char separator = Util.getSeparator() ;
  	int id = Util.getIntValue(request.getParameter("id"));	
	
	/*
	 检查是否存在同一个职务下相同简称的岗位
	 */
    if(isDuplicatedJobtitle(jobactivityid,jobtitlemark,id)){
	    String url ="HrmJobTitlesTempletEdit.jsp?message=1&fromHrmDialogTab=1&id="+id+"";
		response.sendRedirect(url);
    	return;
	}

	String para = ""+id + separator +jobtitlemark + separator + jobtitlename + separator + jobactivityid + separator + 
		jobresponsibility+ separator + jobcompetency + separator + 
		jobtitleremark;	
	
	RecordSet.executeProc("HrmJobTitlesTemplet_Update",para);
    if(!jobdoc.equals("")){
	    RecordSet.executeSql("update HrmJobTitlesTemplet set jobdoc="+jobdoc+" where id="+id);
    }else{
    	RecordSet.executeSql("update HrmJobTitlesTemplet set jobdoc=null where id="+id);
    }

      SysMaintenanceLog.resetParameter();
      SysMaintenanceLog.setRelatedId(id);
      SysMaintenanceLog.setRelatedName(jobtitlename);
      SysMaintenanceLog.setOperateType("2");
      SysMaintenanceLog.setOperateDesc("HrmJobTitlesTemplet_Update,"+para);
      SysMaintenanceLog.setOperateItem("157");
      SysMaintenanceLog.setOperateUserid(user.getUID());
      SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
      SysMaintenanceLog.setSysLogInfo();

		JobTitlesTempletComInfo.removeJobTitlesTempletCache(); 
    response.sendRedirect("HrmJobTitlesTempletEdit.jsp?fromHrmDialogTab=1&isclose=1&id="+id);
 }
 else if(operation.equals("delete")){
 	if(!HrmUserVarify.checkUserRight("HrmJobTitlesEdit:Delete", user)){
  		response.sendRedirect("/notice/noright.jsp");
  		return;
	}
  int id = Util.getIntValue(request.getParameter("id"));
	String para = ""+id;
	RecordSet.executeProc("HrmJobTitlesTemplet_Delete",para);
  SysMaintenanceLog.resetParameter();
  SysMaintenanceLog.setRelatedId(id);
  SysMaintenanceLog.setRelatedName(JobTitlesTempletComInfo.getJobTitlesname(""+id));
  SysMaintenanceLog.setOperateType("3");
  SysMaintenanceLog.setOperateDesc("HrmJobTitlesTemplet_Delete,"+para);
  SysMaintenanceLog.setOperateItem("157");
  SysMaintenanceLog.setOperateUserid(user.getUID());
  SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
  SysMaintenanceLog.setSysLogInfo();

	JobTitlesTempletComInfo.removeJobTitlesTempletCache();
  //out.write("<script>window.close();opener.parent.location.reload();</script>");
 }
%>