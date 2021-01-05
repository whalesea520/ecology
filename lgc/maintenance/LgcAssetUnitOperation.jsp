<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<jsp:useBean id="AssetUnitComInfo" class="weaver.lgc.maintenance.AssetUnitComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
String operation = Util.null2String(request.getParameter("operation"));
char separator = Util.getSeparator() ;

if(operation.equals("addunit")){
     
  	String unitdesc = Util.fromScreen(request.getParameter("unitdesc"),user.getLanguage());
	String unitname = Util.fromScreen(request.getParameter("unitname"),user.getLanguage());
	String unitmark = Util.fromScreen(request.getParameter("unitmark"),user.getLanguage());
	RecordSet.executeSql("select count(id) from LgcAssetUnit where unitname = '" + unitname.trim()+"'");
	if(RecordSet.next()){
		if(RecordSet.getInt(1)>0){
			response.sendRedirect("LgcAssetUnitAdd.jsp?message=failrepeat");
			return;
		}
	}
	String para = unitmark + separator + unitname + separator + unitdesc ;
	RecordSet.executeProc("LgcAssetUnit_Insert",para);
	
  	RecordSet.executeSql("select max(id) from LgcAssetUnit ") ;
	RecordSet.next() ;
	int	id = RecordSet.getInt(1);
	SysMaintenanceLog.resetParameter();
	SysMaintenanceLog.setRelatedId(id);
	SysMaintenanceLog.setRelatedName(unitname);
	SysMaintenanceLog.setOperateType("1");
	SysMaintenanceLog.setOperateDesc("LgcAssetUnit_Insert,"+para);
	SysMaintenanceLog.setOperateItem("45");
	SysMaintenanceLog.setOperateUserid(user.getUID());
	SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
	SysMaintenanceLog.setSysLogInfo();

	AssetUnitComInfo.removeAssetUnitCache() ;

	response.sendRedirect("LgcAssetUnitAdd.jsp?isclose=1");
 }
else if(operation.equals("editunit")){
  	int id = Util.getIntValue(request.getParameter("id"));
	String unitdesc = Util.fromScreen(request.getParameter("unitdesc"),user.getLanguage());
	String unitname = Util.fromScreen(request.getParameter("unitname"),user.getLanguage());
	String unitmark = Util.fromScreen(request.getParameter("unitmark"),user.getLanguage());
	RecordSet.executeSql("select count(id) from LgcAssetUnit where unitname = '" + unitname.trim()+"' and id !="+id);
	if(RecordSet.next()){
		if(RecordSet.getInt(1)>0){
			response.sendRedirect("LgcAssetUnitEdit.jsp?message=failrepeat&id="+id);
			return;
		}
	}
	String para = ""+id + separator + unitmark + separator + unitname + separator + unitdesc ;
	RecordSet.executeProc("LgcAssetUnit_Update",para);
	
    SysMaintenanceLog.resetParameter();
    SysMaintenanceLog.setRelatedId(id);
    SysMaintenanceLog.setRelatedName(unitname);
    SysMaintenanceLog.setOperateType("2");
    SysMaintenanceLog.setOperateDesc("LgcAssetUnit_Update,"+para);
    SysMaintenanceLog.setOperateItem("45");
    SysMaintenanceLog.setOperateUserid(user.getUID());
    SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
    SysMaintenanceLog.setSysLogInfo();
	AssetUnitComInfo.removeAssetUnitCache() ;

 	response.sendRedirect("LgcAssetUnitEdit.jsp?isclose=1&id="+id);
 }
 else if(operation.equals("deleteunit")){
  	int id = Util.getIntValue(request.getParameter("id"));
	String unitname = Util.fromScreen(request.getParameter("unitname"),user.getLanguage());
	String para = ""+id;
	RecordSet.executeProc("LgcAssetUnit_SelectByID",para);
	RecordSet.next();
	unitname = Util.null2String(RecordSet.getString("unitname"));
	RecordSet.executeProc("LgcAssetUnit_Delete",para);
	if(RecordSet.next() && RecordSet.getString(1).equals("-1")){
		response.sendRedirect("LgcAssetUnitEdit.jsp?id="+id+"&msgid=20");
		return ;
	}

      SysMaintenanceLog.resetParameter();
      SysMaintenanceLog.setRelatedId(id);
      SysMaintenanceLog.setRelatedName(unitname);
      SysMaintenanceLog.setOperateType("3");
      SysMaintenanceLog.setOperateDesc("LgcAssetUnit_Delete,"+para);
      SysMaintenanceLog.setOperateItem("45");
      SysMaintenanceLog.setOperateUserid(user.getUID());
      SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
      SysMaintenanceLog.setSysLogInfo();
	  
	AssetUnitComInfo.removeAssetUnitCache() ;

 	response.sendRedirect("LgcAssetUnit.jsp");
 }
%>
