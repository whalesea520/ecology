<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="TrainTypeComInfo" class="weaver.hrm.tools.TrainTypeComInfo" scope="page" />
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
String operation = Util.fromScreen(request.getParameter("operation"),user.getLanguage());
char separator = Util.getSeparator() ;

String name = Util.fromScreen(request.getParameter("name"),user.getLanguage());
String description = Util.fromScreen(request.getParameter("description"),user.getLanguage());
String typecontent = Util.fromScreenForCpt(request.getParameter("typecontent"),user.getLanguage());
String typeaim = Util.fromScreenForCpt(request.getParameter("typeaim"),user.getLanguage());
String typedocurl = Util.fromScreen(request.getParameter("typedocurl"),user.getLanguage());
String typetesturl = Util.fromScreen(request.getParameter("typetesturl"),user.getLanguage());
String typeoperator = Util.fromScreen(request.getParameter("typeoperator"),user.getLanguage());
if(operation.equals("add")){
	if(!HrmUserVarify.checkUserRight("HrmTrainTypeAdd:Add", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
  	
	String para = name + separator + description+ separator +typecontent+ separator +typeaim+ separator +typedocurl+ separator +typetesturl+ separator +typeoperator;
	RecordSet.executeProc("HrmTrainType_Insert",para);
	int id=0;
	
	if(RecordSet.next()){
		id = RecordSet.getInt(1);
	}
      SysMaintenanceLog.resetParameter();
      SysMaintenanceLog.setRelatedId(id);
      SysMaintenanceLog.setRelatedName(name);
      SysMaintenanceLog.setOperateType("1");
      SysMaintenanceLog.setOperateDesc("HrmTrainType_Insert,"+para);
      SysMaintenanceLog.setOperateItem("66");
      SysMaintenanceLog.setOperateUserid(user.getUID());
      SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
      SysMaintenanceLog.setSysLogInfo();

	TrainTypeComInfo.removeTrainTypeCache();
	
 	response.sendRedirect("HrmTrainTypeAdd.jsp?isclose=1");
 }
 
else if(operation.equals("edit")){
	if(!HrmUserVarify.checkUserRight("HrmTrainTypeEdit:Edit", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}

	String id = Util.null2String(request.getParameter("id"));

		String para = ""+id + separator + name + separator + description+ separator +typecontent+ separator +typeaim+ separator +typedocurl+ separator +typetesturl+ separator +typeoperator;	
		RecordSet.executeProc("HrmTrainType_Update",para);
		
		  SysMaintenanceLog.resetParameter();
		  SysMaintenanceLog.setRelatedId(Util.getIntValue(id));
		  SysMaintenanceLog.setRelatedName(name);
		  SysMaintenanceLog.setOperateType("2");
		  SysMaintenanceLog.setOperateDesc("HrmTrainType_Update,"+para);
		  SysMaintenanceLog.setOperateItem("66");
		  SysMaintenanceLog.setOperateUserid(user.getUID());
		  SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
		  SysMaintenanceLog.setSysLogInfo();

		  TrainTypeComInfo.removeTrainTypeCache();

 	response.sendRedirect("HrmTrainTypeEditDo.jsp?isclose=1&id="+id);
 }
 else if(operation.equals("delete")){
 	if(!HrmUserVarify.checkUserRight("HrmTrainTypeEdit:Delete", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
     
  	String id = Util.null2String(request.getParameter("id"));
	String sql ="Select ID From HrmTrainLayout where TypeID = "+id;
	RecordSet.executeSql(sql);
	RecordSet.next();
	if(Util.null2String(RecordSet.getString("ID")).equals("")){
		String para = ""+id;
		RecordSet.executeProc("HrmTrainType_Delete",para);
		name = TrainTypeComInfo.getTrainTypename(id);
		  SysMaintenanceLog.resetParameter();
		  SysMaintenanceLog.setRelatedId(Util.getIntValue(id));
		  SysMaintenanceLog.setRelatedName(name);
		  SysMaintenanceLog.setOperateType("3");
		  SysMaintenanceLog.setOperateDesc("HrmTrainType_Delete,"+para);
		  SysMaintenanceLog.setOperateItem("66");
		  SysMaintenanceLog.setOperateUserid(user.getUID());
		  SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
		  SysMaintenanceLog.setSysLogInfo();

		TrainTypeComInfo.removeTrainTypeCache();
	}
 	response.sendRedirect("HrmTrainType.jsp");
 }
%>
