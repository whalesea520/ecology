<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="UseKindComInfo" class="weaver.hrm.job.UseKindComInfo" scope="page" />
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
String operation = Util.fromScreen(request.getParameter("operation"),user.getLanguage());
String name = Util.fromScreen(request.getParameter("name"),user.getLanguage());
String description = Util.fromScreen(request.getParameter("description"),user.getLanguage());
if(operation.equals("add")){
	if(!HrmUserVarify.checkUserRight("HrmUseKindAdd:Add", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
     char separator = Util.getSeparator() ;
  	
	String para = name + separator + description;
	RecordSet.executeProc("HrmUseKind_Insert",para);
	int id=0;
	RecordSet.executeSql("Select max(ID) as ID From HrmUseKind");
	if(RecordSet.next()){
		id = RecordSet.getInt(1);
		out.print("id"+id);
	}
      SysMaintenanceLog.resetParameter();
      SysMaintenanceLog.setRelatedId(id);
      SysMaintenanceLog.setRelatedName(name);
      SysMaintenanceLog.setOperateType("1");
      SysMaintenanceLog.setOperateDesc("HrmUseKind_Insert,"+para);
      SysMaintenanceLog.setOperateItem("64");
      SysMaintenanceLog.setOperateUserid(user.getUID());
      SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
      SysMaintenanceLog.setSysLogInfo();

	UseKindComInfo.removeUseKindCache();
 	response.sendRedirect("HrmUseKindAdd.jsp?isclose=1");
 }
 
else if(operation.equals("edit")){
	if(!HrmUserVarify.checkUserRight("HrmUseKindEdit:Edit", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
     char separator = Util.getSeparator() ;
  	int id = Util.getIntValue(request.getParameter("id"));
	String para = ""+id + separator + name + separator + description;
	RecordSet.executeProc("HrmUseKind_Update",para);
	
      SysMaintenanceLog.resetParameter();
      SysMaintenanceLog.setRelatedId(id);
      SysMaintenanceLog.setRelatedName(name);
      SysMaintenanceLog.setOperateType("2");
      SysMaintenanceLog.setOperateDesc("HrmUseKind_Update,"+para);
      SysMaintenanceLog.setOperateItem("64");
      SysMaintenanceLog.setOperateUserid(user.getUID());
      SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
      SysMaintenanceLog.setSysLogInfo();

		UseKindComInfo.removeUseKindCache();
 	response.sendRedirect("HrmUseKindEdit.jsp?isclose=1");
 }
 else if(operation.equals("delete")){
 	if(!HrmUserVarify.checkUserRight("HrmUseKindEdit:Delete", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
     char separator = Util.getSeparator() ;
  	int id = Util.getIntValue(request.getParameter("id"));
	String para = ""+id;
	
	RecordSet.executeSql("select name from HrmUseKind where id = "+id);
	if(RecordSet.next()){
		name = Util.null2String(RecordSet.getString("name"));
	}	
	String sql = "select count(id) from HrmResource where usekind = "+id;
	RecordSet.executeSql(sql);
	RecordSet.next();	
	if(RecordSet.getInt(1)>0){
		response.sendRedirect("HrmUseKindEdit.jsp?id="+id+"&msgid=20");
	}else{		
	RecordSet.executeProc("HrmUseKind_Delete",para);
	}		
	
      SysMaintenanceLog.resetParameter();
      SysMaintenanceLog.setRelatedId(id);
      SysMaintenanceLog.setRelatedName(name);
      SysMaintenanceLog.setOperateType("3");
      SysMaintenanceLog.setOperateDesc("HrmUseKind_Delete,"+para);
      SysMaintenanceLog.setOperateItem("64");
      SysMaintenanceLog.setOperateUserid(user.getUID());
      SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
      SysMaintenanceLog.setSysLogInfo();

	UseKindComInfo.removeUseKindCache();
 	response.sendRedirect("HrmUseKind.jsp");
 }
%>
 <input type="button" name="Submit2" value="<%=SystemEnv.getHtmlLabelName(236,user.getLanguage())%>" onClick="javascript:history.go(-1)">