<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<jsp:useBean id="WarehouseComInfo" class="weaver.lgc.maintenance.WarehouseComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
String operation = Util.null2String(request.getParameter("operation"));
char separator = Util.getSeparator() ;

if(operation.equals("addwarehouse")){
     
  	String warehousedesc = Util.fromScreen(request.getParameter("warehousedesc"),user.getLanguage());
	String warehousename = Util.fromScreen(request.getParameter("warehousename"),user.getLanguage());
	String roleid = Util.null2String(request.getParameter("roleid"));
	

	String para = warehousename + separator + warehousedesc + separator + roleid ;
	
	RecordSet.executeProc("LgcWarehouse_Insert",para);
	RecordSet.next() ;
	int	id = RecordSet.getInt(1);
	SysMaintenanceLog.resetParameter();
	SysMaintenanceLog.setRelatedId(id);
	SysMaintenanceLog.setRelatedName(warehousename);
	SysMaintenanceLog.setOperateType("1");
	SysMaintenanceLog.setOperateDesc("LgcWarehouse_Insert,"+para);
	SysMaintenanceLog.setOperateItem("49");
	SysMaintenanceLog.setOperateUserid(user.getUID());
	SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
	SysMaintenanceLog.setSysLogInfo();

	WarehouseComInfo.removeWarehouseCache() ;
	response.sendRedirect("LgcWarehouse.jsp");
 }
else if(operation.equals("editwarehouse")){
  	int id = Util.getIntValue(request.getParameter("id"));
	String warehousedesc = Util.fromScreen(request.getParameter("warehousedesc"),user.getLanguage());
	String warehousename = Util.fromScreen(request.getParameter("warehousename"),user.getLanguage());
	String roleid = Util.null2String(request.getParameter("roleid"));
	

	String para = ""+id + separator + warehousename + separator + warehousedesc + separator + roleid ;

	RecordSet.executeProc("LgcWarehouse_Update",para);
	
    SysMaintenanceLog.resetParameter();
    SysMaintenanceLog.setRelatedId(id);
    SysMaintenanceLog.setRelatedName(warehousename);
    SysMaintenanceLog.setOperateType("2");
    SysMaintenanceLog.setOperateDesc("LgcWarehouse_Update,"+para);
    SysMaintenanceLog.setOperateItem("49");
    SysMaintenanceLog.setOperateUserid(user.getUID());
    SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
    SysMaintenanceLog.setSysLogInfo();
	WarehouseComInfo.removeWarehouseCache() ;

 	response.sendRedirect("LgcWarehouse.jsp");
 }
 else if(operation.equals("deletewarehouse")){
  	int id = Util.getIntValue(request.getParameter("id"));
	String warehousename = Util.fromScreen(request.getParameter("warehousename"),user.getLanguage());
	String para = ""+id;
	RecordSet.executeProc("LgcWarehouse_Delete",para);
	if(RecordSet.next() && RecordSet.getString(1).equals("-1")){
		response.sendRedirect("LgcWarehouseEdit.jsp?id="+id+"&msgid=20");
		return ;
	}

      SysMaintenanceLog.resetParameter();
      SysMaintenanceLog.setRelatedId(id);
      SysMaintenanceLog.setRelatedName(warehousename);
      SysMaintenanceLog.setOperateType("3");
      SysMaintenanceLog.setOperateDesc("LgcWarehouse_Delete,"+para);
      SysMaintenanceLog.setOperateItem("49");
      SysMaintenanceLog.setOperateUserid(user.getUID());
      SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
      SysMaintenanceLog.setSysLogInfo();
	  
	WarehouseComInfo.removeWarehouseCache() ;

 	response.sendRedirect("LgcWarehouse.jsp");
 }
%>
