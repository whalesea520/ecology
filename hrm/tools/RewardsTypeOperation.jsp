<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RewardsTypeComInfo" class="weaver.hrm.tools.RewardsTypeComInfo" scope="page" />
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
String operation = Util.fromScreen(request.getParameter("operation"),user.getLanguage());
String flag = Util.fromScreen(request.getParameter("flag"),user.getLanguage());
String name = Util.fromScreen(request.getParameter("name"),user.getLanguage());
String description = Util.fromScreen(request.getParameter("description"),user.getLanguage());
if(operation.equals("add")){
	if(!HrmUserVarify.checkUserRight("HrmRewardsTypeAdd:Add", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
     char separator = Util.getSeparator() ;
  	
	String para = flag + separator + name + separator + description;
	RecordSet.executeProc("HrmRewardsType_Insert",para);
	int id=0;
	
	if(RecordSet.next()){
		id = RecordSet.getInt(1);
		out.print("id"+id);
	}
      SysMaintenanceLog.resetParameter();
      SysMaintenanceLog.setRelatedId(id);
      SysMaintenanceLog.setRelatedName(name);
      SysMaintenanceLog.setOperateType("1");
      SysMaintenanceLog.setOperateDesc("HrmRewardsType_Insert,"+para);
      SysMaintenanceLog.setOperateItem("67");
      SysMaintenanceLog.setOperateUserid(user.getUID());
      SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
      SysMaintenanceLog.setSysLogInfo();

	RewardsTypeComInfo.removeRewardsTypeCache();
 	response.sendRedirect("HrmRewardsType.jsp");
 }
 
else if(operation.equals("edit")){
	if(!HrmUserVarify.checkUserRight("HrmRewardsTypeEdit:Edit", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
     char separator = Util.getSeparator() ;
  	int id = Util.getIntValue(request.getParameter("id"));
	String para = ""+id + separator + flag + separator + name + separator + description;
	RecordSet.executeProc("HrmRewardsType_Update",para);
	
      SysMaintenanceLog.resetParameter();
      SysMaintenanceLog.setRelatedId(id);
      SysMaintenanceLog.setRelatedName(name);
      SysMaintenanceLog.setOperateType("2");
      SysMaintenanceLog.setOperateDesc("HrmRewardsType_Update,"+para);
      SysMaintenanceLog.setOperateItem("67");
      SysMaintenanceLog.setOperateUserid(user.getUID());
      SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
      SysMaintenanceLog.setSysLogInfo();

		RewardsTypeComInfo.removeRewardsTypeCache();
 	response.sendRedirect("HrmRewardsType.jsp");
 }
 else if(operation.equals("delete")){
 	if(!HrmUserVarify.checkUserRight("HrmRewardsTypeEdit:Delete", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
     char separator = Util.getSeparator() ;
  	int id = Util.getIntValue(request.getParameter("id"));
	String para = ""+id;
	RecordSet.executeProc("HrmRewardsType_Delete",para);
	
      SysMaintenanceLog.resetParameter();
      SysMaintenanceLog.setRelatedId(id);
      SysMaintenanceLog.setRelatedName(name);
      SysMaintenanceLog.setOperateType("3");
      SysMaintenanceLog.setOperateDesc("HrmRewardsType_Delete,"+para);
      SysMaintenanceLog.setOperateItem("67");
      SysMaintenanceLog.setOperateUserid(user.getUID());
      SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
      SysMaintenanceLog.setSysLogInfo();

	RewardsTypeComInfo.removeRewardsTypeCache();
 	response.sendRedirect("HrmRewardsType.jsp");
 }
%>
 <input type="button" name="Submit2" value="<%=SystemEnv.getHtmlLabelName(236,user.getLanguage())%>" onClick="javascript:history.go(-1)">