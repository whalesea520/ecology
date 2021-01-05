<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="JobCallComInfo" class="weaver.hrm.job.JobCallComInfo" scope="page" />
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
String operation = Util.fromScreen(request.getParameter("operation"),user.getLanguage());
String name = Util.fromScreen(request.getParameter("name"),user.getLanguage()).replaceAll("&nbsp","&amp;nbsp");
String description = Util.fromScreen(request.getParameter("description"),user.getLanguage()).replaceAll("&nbsp","&amp;nbsp");
if(operation.equals("add")){
	if(!HrmUserVarify.checkUserRight("HrmJobCallAdd:Add", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
     char separator = Util.getSeparator() ;

	String para = name + separator + description;
	RecordSet.executeProc("HrmJobCall_Insert",para);
	int id=0;
	//得到刚刚插入的记录的id
    RecordSet.executeSql("select max(id) from HrmJobCall");
	if(RecordSet.next()){
		id = RecordSet.getInt(1);
		out.print("id"+id);
	}
      SysMaintenanceLog.resetParameter();
      SysMaintenanceLog.setRelatedId(id);
      SysMaintenanceLog.setRelatedName(name);
      SysMaintenanceLog.setOperateType("1");
      SysMaintenanceLog.setOperateDesc("HrmJobCall_Insert,"+para);
      SysMaintenanceLog.setOperateItem("65");
      SysMaintenanceLog.setOperateUserid(user.getUID());
      SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
      SysMaintenanceLog.setSysLogInfo();

	JobCallComInfo.removeJobCallCache();
 	response.sendRedirect("HrmJobCallAdd.jsp?id="+id+"&isclose=1");
 }

else if(operation.equals("edit")){
	if(!HrmUserVarify.checkUserRight("HrmJobCallEdit:Edit", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
     char separator = Util.getSeparator() ;
  	int id = Util.getIntValue(request.getParameter("id"));
	String para = ""+id + separator + name + separator + description;
	RecordSet.executeProc("HrmJobCall_Update",para);

      SysMaintenanceLog.resetParameter();
      SysMaintenanceLog.setRelatedId(id);
      SysMaintenanceLog.setRelatedName(name);
      SysMaintenanceLog.setOperateType("2");
      SysMaintenanceLog.setOperateDesc("HrmJobCall_Update,"+para);
      SysMaintenanceLog.setOperateItem("65");
      SysMaintenanceLog.setOperateUserid(user.getUID());
      SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
      SysMaintenanceLog.setSysLogInfo();

		JobCallComInfo.removeJobCallCache();
 	response.sendRedirect("HrmJobCallEdit.jsp?isclose=1");
 }
 else if(operation.equals("delete")){
 	if(!HrmUserVarify.checkUserRight("HrmJobCallEdit:Delete", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
     char separator = Util.getSeparator() ;
  	int id = Util.getIntValue(request.getParameter("id"));
	String para = ""+id;
	RecordSet.executeSql("select name from HrmJobCall where id = "+id);
	if(RecordSet.next()){
		name = Util.null2String(RecordSet.getString("name"));
	}
	String sql = "select count(id) from HrmResource where jobcall = "+id;
	RecordSet.executeSql(sql);
	RecordSet.next();
	if(RecordSet.getInt(1)>0){
		response.sendRedirect("HrmJobCallEdit.jsp?id="+id+"&msgid=20");
	}else{
	RecordSet.executeProc("HrmJobCall_Delete",para);
	}

      SysMaintenanceLog.resetParameter();
      SysMaintenanceLog.setRelatedId(id);
      SysMaintenanceLog.setRelatedName(name);
      SysMaintenanceLog.setOperateType("3");
      SysMaintenanceLog.setOperateDesc("HrmJobCall_Delete,"+para);
      SysMaintenanceLog.setOperateItem("65");
      SysMaintenanceLog.setOperateUserid(user.getUID());
      SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
      SysMaintenanceLog.setSysLogInfo();

	JobCallComInfo.removeJobCallCache();
 	response.sendRedirect("HrmJobCall.jsp");
 }
%>
 <input type="button" name="Submit2" value="<%=SystemEnv.getHtmlLabelName(236,user.getLanguage())%>" onClick="javascript:history.go(-1)">