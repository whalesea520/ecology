<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<jsp:useBean id="StockModeComInfo" class="weaver.lgc.maintenance.StockModeComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
String operation = Util.null2String(request.getParameter("operation"));
char separator = Util.getSeparator() ;

if(operation.equals("addmode")){
     
  	String modedesc = Util.fromScreen(request.getParameter("modedesc"),user.getLanguage());
	String modename = Util.fromScreen(request.getParameter("modename"),user.getLanguage());
	String modetype = Util.null2String(request.getParameter("modetype"));
	String modestatus = Util.null2String(request.getParameter("modestatus"));
	if(modestatus.equals("")) modestatus = "0" ;
	String para = modename + separator + modetype + separator + modestatus + separator + modedesc;
	RecordSet.executeProc("LgcStockMode_Insert",para);
	RecordSet.next() ;
	int	id = RecordSet.getInt(1);
	SysMaintenanceLog.resetParameter();
	SysMaintenanceLog.setRelatedId(id);
	SysMaintenanceLog.setRelatedName(modename);
	SysMaintenanceLog.setOperateType("1");
	SysMaintenanceLog.setOperateDesc("LgcStockMode_Insert,"+para);
	SysMaintenanceLog.setOperateItem("50");
	SysMaintenanceLog.setOperateUserid(user.getUID());
	SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
	SysMaintenanceLog.setSysLogInfo();

	StockModeComInfo.removeStockModeCache() ;

	response.sendRedirect("LgcStockMode.jsp");
 }
else if(operation.equals("editmode")){
  	int id = Util.getIntValue(request.getParameter("id"));
	String modedesc = Util.fromScreen(request.getParameter("modedesc"),user.getLanguage());
	String modename = Util.fromScreen(request.getParameter("modename"),user.getLanguage());
	String modetype = Util.null2String(request.getParameter("modetype"));
	String modestatus = Util.null2String(request.getParameter("modestatus"));
	if(modestatus.equals("")) modestatus = "0" ;
	String para = ""+id + separator + modename + separator + modetype + separator + modestatus + separator + modedesc;
	RecordSet.executeProc("LgcStockMode_Update",para);
	
    SysMaintenanceLog.resetParameter();
    SysMaintenanceLog.setRelatedId(id);
    SysMaintenanceLog.setRelatedName(modename);
    SysMaintenanceLog.setOperateType("2");
    SysMaintenanceLog.setOperateDesc("LgcStockMode_Update,"+para);
    SysMaintenanceLog.setOperateItem("50");
    SysMaintenanceLog.setOperateUserid(user.getUID());
    SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
    SysMaintenanceLog.setSysLogInfo();
	StockModeComInfo.removeStockModeCache() ;

 	response.sendRedirect("LgcStockMode.jsp");
 }
 else if(operation.equals("deletemode")){
  	int id = Util.getIntValue(request.getParameter("id"));
	String modestatus = Util.null2String(request.getParameter("modestatus"));
	if(modestatus.equals("2")){
		response.sendRedirect("LgcStockModeEdit.jsp?id="+id+"&msgid=20");
		return ;
	}

	String modename = Util.fromScreen(request.getParameter("modename"),user.getLanguage());
	String para = ""+id;
	RecordSet.executeProc("LgcStockMode_Delete",para);
	if(RecordSet.next() && RecordSet.getString(1).equals("-1")){
		response.sendRedirect("LgcStockModeEdit.jsp?id="+id+"&msgid=20");
		return ;
	}

      SysMaintenanceLog.resetParameter();
      SysMaintenanceLog.setRelatedId(id);
      SysMaintenanceLog.setRelatedName(modename);
      SysMaintenanceLog.setOperateType("3");
      SysMaintenanceLog.setOperateDesc("LgcStockMode_Delete,"+para);
      SysMaintenanceLog.setOperateItem("50");
      SysMaintenanceLog.setOperateUserid(user.getUID());
      SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
      SysMaintenanceLog.setSysLogInfo();
	  
	StockModeComInfo.removeStockModeCache() ;

 	response.sendRedirect("LgcStockMode.jsp");
 }
%>
