<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="EducationLevelComInfo" class="weaver.hrm.job.EducationLevelComInfo" scope="page" />
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
String operation = Util.fromScreen(request.getParameter("operation"),user.getLanguage());
String name = Util.fromScreen(request.getParameter("name"),user.getLanguage());
String description = Util.fromScreen(request.getParameter("description"),user.getLanguage());
if(operation.equals("add")){
	if(!HrmUserVarify.checkUserRight("HrmEducationLevelAdd:Add", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
     char separator = Util.getSeparator() ;
  	
	String para = name + separator + description;
	RecordSet.executeProc("HrmEducationLevel_Insert",para);
	int id=0;
	
	RecordSet.executeSql("Select max(ID) as ID From HrmEducationLevel");
	if(RecordSet.next()){
		id = RecordSet.getInt(1);
	}
      SysMaintenanceLog.resetParameter();
      SysMaintenanceLog.setRelatedId(id);
      SysMaintenanceLog.setRelatedName(name);
      SysMaintenanceLog.setOperateType("1");
      SysMaintenanceLog.setOperateDesc("HrmEducationLevel_Insert,"+para);
      SysMaintenanceLog.setOperateItem("80");
      SysMaintenanceLog.setOperateUserid(user.getUID());
      SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
      SysMaintenanceLog.setSysLogInfo();

      EducationLevelComInfo.removeEducationLevelCache();
 	response.sendRedirect("HrmEduLevelAdd.jsp?isclose=1");
 }
 
else if(operation.equals("edit")){
	if(!HrmUserVarify.checkUserRight("HrmEducationLevelEdit:Edit", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
     char separator = Util.getSeparator() ;
  	int id = Util.getIntValue(request.getParameter("id"));
	String para = ""+id + separator + name + separator + description;
	RecordSet.executeProc("HrmEducationLevel_Update",para);
	
      SysMaintenanceLog.resetParameter();
      SysMaintenanceLog.setRelatedId(id);
      SysMaintenanceLog.setRelatedName(name);
      SysMaintenanceLog.setOperateType("2");
      SysMaintenanceLog.setOperateDesc("HrmEducationLevel_Update,"+para);
      SysMaintenanceLog.setOperateItem("80");
      SysMaintenanceLog.setOperateUserid(user.getUID());
      SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
      SysMaintenanceLog.setSysLogInfo();

      EducationLevelComInfo.removeEducationLevelCache();
 	response.sendRedirect("HrmEduLevelEdit.jsp?isclose=1");
 }
 else if(operation.equals("delete")){
 	if(!HrmUserVarify.checkUserRight("HrmEducationLevelDelete:Delete", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
     char separator = Util.getSeparator() ;
  	int id = Util.getIntValue(request.getParameter("id"));
	String para = ""+id;
	int flag = 0;
	String sql = "select count(id) from HrmEducationInfo where educationlevel = "+id;
	RecordSet.executeSql(sql);
	RecordSet.next();	
	if(RecordSet.getInt(1)>0){
	        flag =1;
		response.sendRedirect("HrmEduLevelEdit.jsp?id="+id+"&msgid=20");
	}
	
	RecordSet.executeSql("select name from HrmEducationLevel where id = "+id);
	if(RecordSet.next()){
		name = Util.null2String(RecordSet.getString("name"));
	}	
	sql = "select count(id) from HrmResource where educationlevel = "+id;
	RecordSet.executeSql(sql);
	RecordSet.next();	
	if(RecordSet.getInt(1)>0){
	flag =1;
		response.sendRedirect("HrmEduLevelEdit.jsp?id="+id+"&msgid=20");
	}
	
	sql = "select count(id) from HrmCareerApply where educationlevel = "+id;
	RecordSet.executeSql(sql);
	RecordSet.next();	
	if(RecordSet.getInt(1)>0){
	flag =1;
		response.sendRedirect("HrmEduLevelEdit.jsp?id="+id+"&msgid=20");
	}
	
	if(flag == 0){
	RecordSet.executeProc("HrmEducationLevel_Delete",para);
	}
	
      SysMaintenanceLog.resetParameter();
      SysMaintenanceLog.setRelatedId(id);
      SysMaintenanceLog.setRelatedName(name);
      SysMaintenanceLog.setOperateType("3");
      SysMaintenanceLog.setOperateDesc("HrmEducationLevel_Delete,"+para);
      SysMaintenanceLog.setOperateItem("80");
      SysMaintenanceLog.setOperateUserid(user.getUID());
      SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
      SysMaintenanceLog.setSysLogInfo();

    EducationLevelComInfo.removeEducationLevelCache();
 	response.sendRedirect("HrmEduLevel.jsp");
 }
%>
 <input type="button" name="Submit2" value="<%=SystemEnv.getHtmlLabelName(236,user.getLanguage())%>" onClick="javascript:history.go(-1)">