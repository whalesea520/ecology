<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util,weaver.conn.*" %>
<%@page import="weaver.hrm.common.DbFunctionUtil"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page" />
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="HrmServiceManager" class="weaver.interfaces.hrm.HrmServiceManager" scope="page" />
<%!
/**
 * 判断同一个部门下是否有 相同简称的岗位
 *@param jobtitlemark 岗位简称
 *@param id 记录的编号， 新建是应传入 0
 *@author Charoes Huang
 *@Date June 3,2004
 */
private boolean isDuplicatedJobtitle(String jobtitlename,String jobactivityid,int id){
	boolean isDuplicated = false;
	RecordSet rs = new RecordSet();
	String sqlStr ="Select Count(*) From HrmJobTitles WHERE id<>"+id +" and jobactivityid="+jobactivityid +" and LTRIM(RTRIM(jobtitlename))='"+jobtitlename.trim()+"'";
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
String isBrowser = Util.fromScreen(request.getParameter("isBrowser"),user.getLanguage());
String operation = Util.fromScreen(request.getParameter("operation"),user.getLanguage());
String jobtitlemark = Util.fromScreen(request.getParameter("jobtitlemark"),user.getLanguage());
String jobtitlename = Util.fromScreen(request.getParameter("jobtitlename"),user.getLanguage());
String jobactivityid = Util.fromScreen(request.getParameter("jobactivityid"),user.getLanguage());
String jobresponsibility = Util.fromScreen(request.getParameter("jobresponsibility"),user.getLanguage());
String jobcompetency = Util.fromScreen(request.getParameter("jobcompetency"),user.getLanguage());
String jobtitleremark = Util.fromScreen(request.getParameter("jobtitleremark"),user.getLanguage());
String jobdoc = Util.fromScreen(request.getParameter("jobdoc"),user.getLanguage());
String[] strObj = {jobtitlemark,jobtitlename,jobactivityid,
					Util.null2String(request.getParameter("jobresponsibility")),
					Util.null2String(request.getParameter("jobcompetency")),
					Util.null2String(request.getParameter("jobtitleremark"))} ;

if(operation.equals("add")){
	if(!HrmUserVarify.checkUserRight("HrmJobTitlesAdd:Add", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
  char separator = Util.getSeparator() ;
  	
	/*
	检查是否存在同一个部门下相同简称的岗位
	*/
	if(isDuplicatedJobtitle(jobtitlename,jobactivityid,0)){
	  request.getSession().setAttribute("JobTitle.error",strObj);
		String url ="HrmJobTitlesAdd.jsp?message=1";
		response.sendRedirect(url);
	 	return;
	}
	String depid = "";
	 String para = jobtitlemark + separator + jobtitlename + separator + 
							depid + separator + jobactivityid + separator + 
							jobresponsibility+ separator + jobcompetency + separator + 
							jobtitleremark;
	
	RecordSet.executeProc("HrmJobTitles_Insert",para);
	int id=0;

  if(RecordSet.next()){
     id = RecordSet.getInt(1);
     RecordSet.execute("update HrmJobTitles set "+DbFunctionUtil.getInsertUpdateSetSql(RecordSet.getDBType(),user.getUID())+" where id="+id) ;
              if(!jobdoc.equals(""))
         RecordSet.executeSql("update HrmJobTitles set jobdoc="+jobdoc+" where id="+id);
  }
	
  SysMaintenanceLog.resetParameter();
  SysMaintenanceLog.setRelatedId(id);
  SysMaintenanceLog.setRelatedName(jobtitlename);
  SysMaintenanceLog.setOperateType("1");
  SysMaintenanceLog.setOperateDesc("HrmJobTitles_Insert,"+para);
  SysMaintenanceLog.setOperateItem("26");
  SysMaintenanceLog.setOperateUserid(user.getUID());
  SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
  SysMaintenanceLog.setSysLogInfo();

	HrmServiceManager.SynInstantJobtitle(""+id,"1");
	 
	JobTitlesComInfo.removeJobTitlesCache();
	response.sendRedirect("HrmJobTitlesAdd.jsp?isclose=1&isBrowser="+isBrowser+"&id="+id);
 }else if(operation.equals("edit")){    
	if(!HrmUserVarify.checkUserRight("HrmJobTitlesEdit:Edit", user)){
 		response.sendRedirect("/notice/noright.jsp");
 		return;
	}
  char separator = Util.getSeparator() ;
  int id = Util.getIntValue(request.getParameter("id"));	
	
  /*
	 检查是否存在同一个部门下相同简称的岗位
	 */
    if(isDuplicatedJobtitle(jobtitlename,jobactivityid,id)){
	    String url ="/hrm/jobtitles/HrmJobTitlesEdit.jsp?fromHrmDialogTab=1&id="+id+"&message=1";
		response.sendRedirect(url);
    	return;
	}

  String depid = "";
  	String para = ""+id + separator +jobtitlemark + separator + jobtitlename + separator + 
		depid + separator + jobactivityid + separator + 
		jobresponsibility+ separator + jobcompetency + separator + 
		jobtitleremark;	
	
	RecordSet.executeProc("HrmJobTitles_Update",para);
	
    if(!jobdoc.equals("")){
	    RecordSet.executeSql("update HrmJobTitles set jobdoc="+jobdoc+" where id="+id);
    }else{
    	RecordSet.executeSql("update HrmJobTitles set jobdoc=null where id="+id);
    }
    
    RecordSet.execute("update HrmJobTitles set "+DbFunctionUtil.getUpdateSetSql(RecordSet.getDBType(),user.getUID())+" where id="+id) ;

  	SysMaintenanceLog.resetParameter();
    SysMaintenanceLog.setRelatedId(id);
    SysMaintenanceLog.setRelatedName(jobtitlename);
    SysMaintenanceLog.setOperateType("2");
    SysMaintenanceLog.setOperateDesc("HrmJobTitles_Update,"+para);
    SysMaintenanceLog.setOperateItem("26");
    SysMaintenanceLog.setOperateUserid(user.getUID());
    SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
    SysMaintenanceLog.setSysLogInfo();

	  HrmServiceManager.SynInstantJobtitle(""+id,"2");

		JobTitlesComInfo.removeJobTitlesCache(); 
    response.sendRedirect("/hrm/jobtitles/HrmJobTitlesEdit.jsp?fromHrmDialogTab=1&isBrowser="+isBrowser+"&isclose=1&id="+id);
 }else if(operation.equals("delete")){
 	if(!HrmUserVarify.checkUserRight("HrmJobTitlesEdit:Delete", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
  
 	int id = Util.getIntValue(request.getParameter("id"));
	String para = ""+id;
	RecordSet.executeSql("select jobtitlename from HrmJobTitles where id = "+id);
	if(RecordSet.next()){
		jobtitlename = Util.null2String(RecordSet.getString("jobtitlename"));
	}
	String sql = "select count(id) from HrmResource where jobtitle = "+id;
	RecordSet.executeSql(sql);
	RecordSet.next();	
	if(RecordSet.getInt(1)>0){
		response.sendRedirect("HrmJobTitlesEdit.jsp?id="+id+"&msgid=20");
	}else{		
	RecordSet.executeProc("HrmJobTitles_Delete",para);
	}	
	
  SysMaintenanceLog.resetParameter();
  SysMaintenanceLog.setRelatedId(id);
  SysMaintenanceLog.setRelatedName(jobtitlename);
  SysMaintenanceLog.setOperateType("3");
  SysMaintenanceLog.setOperateDesc("HrmJobTitles_Delete,"+para);
  SysMaintenanceLog.setOperateItem("26");
  SysMaintenanceLog.setOperateUserid(user.getUID());
  SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
  SysMaintenanceLog.setSysLogInfo();

  HrmServiceManager.SynInstantJobtitle(""+id,"3");

	JobTitlesComInfo.removeJobTitlesCache();
  out.write("<script>window.close();opener.parent.location.reload();</script>");
   //response.sendRedirect("HrmJobTitles.jsp");
 }
%>
 <input type="button" name="Submit2" value="<%=SystemEnv.getHtmlLabelName(236,user.getLanguage())%>" onClick="javascript:history.go(-1)">