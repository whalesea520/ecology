<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<jsp:useBean id="ConfigurationComInfo" class="weaver.lgc.asset.ConfigurationComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
String operation = Util.null2String(request.getParameter("operation"));

char separator = Util.getSeparator() ;

if(operation.equals("addconfiguration")||operation.equals("editconfiguration")){ 
	String theassetid = Util.null2String(request.getParameter("theassetid"));
	String relation = Util.null2String(request.getParameter("relation"));
	String relateassetid = Util.null2String(request.getParameter("relateassetid"));
	String relationtypeid = Util.null2String(request.getParameter("relationtypeid"));

 if(operation.equals("addconfiguration")){

	String para = "";
	if (relation.equals("1")) para = theassetid+separator+relateassetid+separator+relationtypeid;
	if (relation.equals("2")) para = relateassetid+separator+theassetid+separator+relationtypeid;
	
	RecordSet.executeProc("LgcConfiguration_Insert",para);
	RecordSet.next() ;
	int	id = RecordSet.getInt(1);
	if(id == -1)  {
		response.sendRedirect("LgcConfigurationAdd.jsp?paraid="+theassetid+"&relation="+relation+"&msgid=28");
		return ;
	}

	SysMaintenanceLog.resetParameter();
	SysMaintenanceLog.setRelatedId(id);
	SysMaintenanceLog.setRelatedName("");
    SysMaintenanceLog.setOperateItem("55");
    SysMaintenanceLog.setOperateUserid(user.getUID());
    SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
	SysMaintenanceLog.setOperateType("1");
	SysMaintenanceLog.setOperateDesc("LgcConfiguration_Insert,"+para);
	SysMaintenanceLog.setSysLogInfo();

	ConfigurationComInfo.removeConfigurationCache() ;
	response.sendRedirect("LgcConfiguration.jsp?paraid="+theassetid);
 } //end 
  else if(operation.equals("editconfiguration")){
	String id = Util.null2String(request.getParameter("id"));

	String para = "";
	if (relation.equals("1")) para = id+separator+theassetid+separator+relateassetid+separator+relationtypeid;
	if (relation.equals("2")) para = id+separator+relateassetid+separator+theassetid+separator+relationtypeid;
	
	RecordSet.executeProc("LgcConfiguration_Update",para);
	RecordSet.next();
	int	ids = RecordSet.getInt(1);
	if(ids == -1)  {
		response.sendRedirect("LgcConfigurationEdit.jsp?paraid="+id+"&relation="+relation+"&assetid="+theassetid+"&msgid=13");
		return ;
	}

    SysMaintenanceLog.resetParameter();
	SysMaintenanceLog.setRelatedId(Util.getIntValue(id));
	SysMaintenanceLog.setRelatedName("");
	SysMaintenanceLog.setOperateType("2");
	SysMaintenanceLog.setOperateDesc("LgcConfiguration_Update,"+para);
	SysMaintenanceLog.setOperateItem("55");
	SysMaintenanceLog.setOperateUserid(user.getUID());
	SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
	SysMaintenanceLog.setSysLogInfo();

	ConfigurationComInfo.removeConfigurationCache() ;
	response.sendRedirect("LgcConfiguration.jsp?paraid="+theassetid);
 }///end if 
}//end if 
 else if(operation.equals("deleteconfiguration")){
  	int id = Util.getIntValue(request.getParameter("id"));
	String theassetid = Util.null2String(request.getParameter("theassetid"));
	String para = ""+id;
	RecordSet.executeProc("LgcConfiguration_Delete",para);
	RecordSet.next();

      SysMaintenanceLog.resetParameter();
      SysMaintenanceLog.setRelatedId(id);
      SysMaintenanceLog.setRelatedName("");
      SysMaintenanceLog.setOperateType("3");
      SysMaintenanceLog.setOperateDesc("LgcConfiguration_Delete,"+para);
      SysMaintenanceLog.setOperateItem("55");
      SysMaintenanceLog.setOperateUserid(user.getUID());
      SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
      SysMaintenanceLog.setSysLogInfo();
	  
	ConfigurationComInfo.removeConfigurationCache() ;

	response.sendRedirect("LgcConfiguration.jsp?paraid="+theassetid);
 }
%>
