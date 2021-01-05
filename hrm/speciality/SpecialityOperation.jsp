<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="SpecialityComInfo" class="weaver.hrm.job.SpecialityComInfo" scope="page" />
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
String operation = Util.fromScreen(request.getParameter("operation"),user.getLanguage());
String name = Util.fromScreen(request.getParameter("name"),user.getLanguage()).replaceAll("&nbsp","&amp;nbsp");
String description = Util.fromScreen(request.getParameter("description"),user.getLanguage()).replaceAll("&nbsp","&amp;nbsp");
if(operation.equals("add")){
	if(!HrmUserVarify.checkUserRight("HrmSpecialityAdd:Add", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
     char separator = Util.getSeparator() ;
  	
	String para = name + separator + description;
	RecordSet.executeProc("HrmSpeciality_Insert",para);
	int id=0;
	
	RecordSet.executeSql("Select max(ID) as ID From HrmSpeciality");
	if(RecordSet.next()){
		id = RecordSet.getInt(1);
		//out.print("id"+id);
	}
      SysMaintenanceLog.resetParameter();
      SysMaintenanceLog.setRelatedId(id);
      SysMaintenanceLog.setRelatedName(name);
      SysMaintenanceLog.setOperateType("1");
      SysMaintenanceLog.setOperateDesc("HrmSpeciality_Insert,"+para);
      SysMaintenanceLog.setOperateItem("63");
      SysMaintenanceLog.setOperateUserid(user.getUID());
      SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
      SysMaintenanceLog.setSysLogInfo();

	SpecialityComInfo.removeSpecialityCache();
 	response.sendRedirect("HrmSpecialityAdd.jsp?isclose=1");
 }
 
else if(operation.equals("edit")){
	if(!HrmUserVarify.checkUserRight("HrmSpecialityEdit:Edit", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
     char separator = Util.getSeparator() ;
  	int id = Util.getIntValue(request.getParameter("id"));
	String para = ""+id + separator + name + separator + description;
	RecordSet.executeProc("HrmSpeciality_Update",para);
	
      SysMaintenanceLog.resetParameter();
      SysMaintenanceLog.setRelatedId(id);
      SysMaintenanceLog.setRelatedName(name);
      SysMaintenanceLog.setOperateType("2");
      SysMaintenanceLog.setOperateDesc("HrmSpeciality_Update,"+para);
      SysMaintenanceLog.setOperateItem("63");
      SysMaintenanceLog.setOperateUserid(user.getUID());
      SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
      SysMaintenanceLog.setSysLogInfo();

		SpecialityComInfo.removeSpecialityCache();
 	response.sendRedirect("HrmSpecialityEdit.jsp?isclose=1");
 }
 else if(operation.equals("delete")){
 	if(!HrmUserVarify.checkUserRight("HrmSpecialityEdit:Delete", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
     char separator = Util.getSeparator() ;
  	int id = Util.getIntValue(request.getParameter("id"));
  	name = SpecialityComInfo.getSpecialityname(request.getParameter("id"));
	String para = ""+id;
	String sql = "select count(id) from HrmEducationInfo where speciality = "+id;
	RecordSet.executeSql(sql);
	RecordSet.next();	
	if(RecordSet.getInt(1)>0){
		response.sendRedirect("HrmSpecialityEdit.jsp?id="+id+"&msgid=20");
	}else{		
	RecordSet.executeProc("HrmSpeciality_Delete",para);
	}	
	
      SysMaintenanceLog.resetParameter();
      SysMaintenanceLog.setRelatedId(id);
      SysMaintenanceLog.setRelatedName(name);
      SysMaintenanceLog.setOperateType("3");
      SysMaintenanceLog.setOperateDesc("HrmSpeciality_Delete,"+para);
      SysMaintenanceLog.setOperateItem("63");
      SysMaintenanceLog.setOperateUserid(user.getUID());
      SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
      SysMaintenanceLog.setSysLogInfo();

	SpecialityComInfo.removeSpecialityCache();
 	response.sendRedirect("HrmSpeciality.jsp");
 }
%>
 <input type="button" name="Submit2" value="<%=SystemEnv.getHtmlLabelName(236,user.getLanguage())%>" onClick="javascript:history.go(-1)">