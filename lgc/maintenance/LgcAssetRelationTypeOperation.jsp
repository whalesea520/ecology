<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<jsp:useBean id="AssetRelationTypeComInfo" class="weaver.lgc.maintenance.AssetRelationTypeComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
String operation = Util.null2String(request.getParameter("operation"));
char separator = Util.getSeparator() ;

if(operation.equals("addtype")){
     
  	String typename = Util.fromScreen(request.getParameter("typename"),user.getLanguage());
	String typedesc = Util.fromScreen(request.getParameter("typedesc"),user.getLanguage());
	String typekind = Util.null2String(request.getParameter("typekind"));
	String shopadvice = Util.null2String(request.getParameter("shopadvice"));
	String contractlimit = Util.null2String(request.getParameter("contractlimit"));
	if(shopadvice.equals("")) shopadvice = "0" ;
	if(contractlimit.equals("")) contractlimit = "0" ;

	String para = typename + separator + typedesc + separator + typekind + separator + shopadvice + separator + contractlimit ;
	RecordSet.executeProc("LgcAssetRelationType_Insert",para);
	RecordSet.next() ;
	int	id = RecordSet.getInt(1);
	
	SysMaintenanceLog.resetParameter();
	SysMaintenanceLog.setRelatedId(id);
	SysMaintenanceLog.setRelatedName(typename);
	SysMaintenanceLog.setOperateType("1");
	SysMaintenanceLog.setOperateDesc("LgcAssetRelationType_Insert,"+para);
	SysMaintenanceLog.setOperateItem("46");
	SysMaintenanceLog.setOperateUserid(user.getUID());
	SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
	SysMaintenanceLog.setSysLogInfo();
	AssetRelationTypeComInfo.removeAssetRelationTypeCache();
	response.sendRedirect("LgcAssetRelationType.jsp");
 }
else if(operation.equals("edittype")){
  	int id = Util.getIntValue(request.getParameter("id"));
	String typename = Util.fromScreen(request.getParameter("typename"),user.getLanguage());
	String typedesc = Util.fromScreen(request.getParameter("typedesc"),user.getLanguage());
	String typekind = Util.null2String(request.getParameter("typekind"));
	String shopadvice = Util.null2String(request.getParameter("shopadvice"));
	String contractlimit = Util.null2String(request.getParameter("contractlimit"));
	if(shopadvice.equals("")) shopadvice = "0" ;
	if(contractlimit.equals("")) contractlimit = "0" ;

	String para = ""+id + separator + typename + separator + typedesc + separator + typekind + separator + shopadvice + separator + contractlimit ;
	
	RecordSet.executeProc("LgcAssetRelationType_Update",para);
	
    SysMaintenanceLog.resetParameter();
    SysMaintenanceLog.setRelatedId(id);
    SysMaintenanceLog.setRelatedName(typename);
    SysMaintenanceLog.setOperateType("2");
    SysMaintenanceLog.setOperateDesc("LgcAssetRelationType_Update,"+para);
    SysMaintenanceLog.setOperateItem("46");
    SysMaintenanceLog.setOperateUserid(user.getUID());
    SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
    SysMaintenanceLog.setSysLogInfo();
	
	AssetRelationTypeComInfo.removeAssetRelationTypeCache();
 	response.sendRedirect("LgcAssetRelationType.jsp");
 }
 else if(operation.equals("deletetype")){
  	int id = Util.getIntValue(request.getParameter("id"));
	String typename = Util.fromScreen(request.getParameter("typename"),user.getLanguage());
	String para = ""+id;
	RecordSet.executeProc("LgcAssetRelationType_Delete",para);
	if(RecordSet.next()){
		response.sendRedirect("LgcAssetRelationTypeEdit.jsp?id="+id+"&msgid=20");
		return ;
	}

      SysMaintenanceLog.resetParameter();
      SysMaintenanceLog.setRelatedId(id);
      SysMaintenanceLog.setRelatedName(typename);
      SysMaintenanceLog.setOperateType("3");
      SysMaintenanceLog.setOperateDesc("LgcAssetRelationType_Delete,"+para);
      SysMaintenanceLog.setOperateItem("46");
      SysMaintenanceLog.setOperateUserid(user.getUID());
      SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
      SysMaintenanceLog.setSysLogInfo();
	
	AssetRelationTypeComInfo.removeAssetRelationTypeCache();
 	response.sendRedirect("LgcAssetRelationType.jsp");
 }

%>
