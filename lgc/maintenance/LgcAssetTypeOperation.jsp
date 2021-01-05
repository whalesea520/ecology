<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<jsp:useBean id="AssetTypeComInfo" class="weaver.lgc.maintenance.AssetTypeComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
String operation = Util.null2String(request.getParameter("operation"));
char separator = Util.getSeparator() ;

if(operation.equals("addtype")){
     
  	String typedesc = Util.fromScreen(request.getParameter("typedesc"),user.getLanguage());
	String typename = Util.fromScreen(request.getParameter("typename"),user.getLanguage());
	String typemark = Util.fromScreen(request.getParameter("typemark"),user.getLanguage());
	String para = typemark + separator + typename + separator + typedesc ;
	RecordSet.executeProc("LgcAssetType_Insert",para);
	RecordSet.next() ;
	int	id = RecordSet.getInt(1);
	SysMaintenanceLog.resetParameter();
	SysMaintenanceLog.setRelatedId(id);
	SysMaintenanceLog.setRelatedName(typename);
	SysMaintenanceLog.setOperateType("1");
	SysMaintenanceLog.setOperateDesc("LgcAssetType_Insert,"+para);
	SysMaintenanceLog.setOperateItem("44");
	SysMaintenanceLog.setOperateUserid(user.getUID());
	SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
	SysMaintenanceLog.setSysLogInfo();

	AssetTypeComInfo.removeAssetTypeCache() ;

	response.sendRedirect("LgcAssetType.jsp");
 }
else if(operation.equals("edittype")){
  	int id = Util.getIntValue(request.getParameter("id"));
	String typedesc = Util.fromScreen(request.getParameter("typedesc"),user.getLanguage());
	String typename = Util.fromScreen(request.getParameter("typename"),user.getLanguage());
	String typemark = Util.fromScreen(request.getParameter("typemark"),user.getLanguage());
	String para = ""+id + separator + typemark + separator + typename + separator + typedesc ;
	RecordSet.executeProc("LgcAssetType_Update",para);
	
    SysMaintenanceLog.resetParameter();
    SysMaintenanceLog.setRelatedId(id);
    SysMaintenanceLog.setRelatedName(typename);
    SysMaintenanceLog.setOperateType("2");
    SysMaintenanceLog.setOperateDesc("LgcAssetType_Update,"+para);
    SysMaintenanceLog.setOperateItem("44");
    SysMaintenanceLog.setOperateUserid(user.getUID());
    SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
    SysMaintenanceLog.setSysLogInfo();
	AssetTypeComInfo.removeAssetTypeCache() ;

 	response.sendRedirect("LgcAssetType.jsp");
 }
 else if(operation.equals("deletetype")){
  	int id = Util.getIntValue(request.getParameter("id"));
	String typename = Util.fromScreen(request.getParameter("typename"),user.getLanguage());
	String para = ""+id;
	RecordSet.executeProc("LgcAssetType_Delete",para);
	if(RecordSet.next() && RecordSet.getString(1).equals("-1")){
		response.sendRedirect("LgcAssetTypeEdit.jsp?id="+id+"&msgid=20");
		return ;
	}

      SysMaintenanceLog.resetParameter();
      SysMaintenanceLog.setRelatedId(id);
      SysMaintenanceLog.setRelatedName(typename);
      SysMaintenanceLog.setOperateType("3");
      SysMaintenanceLog.setOperateDesc("LgcAssetType_Delete,"+para);
      SysMaintenanceLog.setOperateItem("44");
      SysMaintenanceLog.setOperateUserid(user.getUID());
      SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
      SysMaintenanceLog.setSysLogInfo();
	  
	AssetTypeComInfo.removeAssetTypeCache() ;

 	response.sendRedirect("LgcAssetType.jsp");
 }
%>
