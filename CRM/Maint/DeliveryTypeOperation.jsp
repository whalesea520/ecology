
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="DeliveryTypeComInfo" class="weaver.crm.Maint.DeliveryTypeComInfo" scope="page" />
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<%
String method = Util.null2String(request.getParameter("method"));
String id = Util.null2String(request.getParameter("id"));
String name = Util.fromScreen(request.getParameter("name"),user.getLanguage());
String desc = Util.fromScreen(request.getParameter("desc"),user.getLanguage());
String send = Util.fromScreen(request.getParameter("send"),user.getLanguage());
String move = Util.fromScreen(request.getParameter("move"),user.getLanguage());
String get = Util.fromScreen(request.getParameter("get"),user.getLanguage());

if (method.equals("add"))
{
	char flag=2;
	RecordSet.executeProc("CRM_DeliveryType_Insert",name+flag+desc+flag+send+flag+move+flag+get);
	int cid=0;
	while(RecordSet.next()){
		cid = RecordSet.getInt(1);
		out.print("id"+id);
	}
	char separator = Util.getSeparator() ;
	String para = name+separator+desc;
	SysMaintenanceLog.resetParameter();
    SysMaintenanceLog.setRelatedId(cid);
    SysMaintenanceLog.setRelatedName(name);
    SysMaintenanceLog.setOperateType("1");
    SysMaintenanceLog.setOperateDesc("CrmDeliveryType_Add,"+para);
    SysMaintenanceLog.setOperateItem("146");
    SysMaintenanceLog.setOperateUserid(user.getUID());
    SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
    SysMaintenanceLog.setSysLogInfo();
	DeliveryTypeComInfo.removeDeliveryTypeCache();
}
else if (method.equals("edit"))
{
	char flag=2;
	RecordSet.executeProc("CRM_DeliveryType_Update",id+flag+name+flag+desc+flag+send+flag+move+flag+get);
	int cid=0;
	while(RecordSet.next()){
		cid = RecordSet.getInt(1);
		out.print("id"+id);
	}

	char separator = Util.getSeparator() ;
	String para = name+separator+desc;
	SysMaintenanceLog.resetParameter();
    SysMaintenanceLog.setRelatedId(cid);
    SysMaintenanceLog.setRelatedName(name);
    SysMaintenanceLog.setOperateType("2");
    SysMaintenanceLog.setOperateDesc("CrmDeliveryType_Update,"+para);
    SysMaintenanceLog.setOperateItem("146");
    SysMaintenanceLog.setOperateUserid(user.getUID());
    SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
    SysMaintenanceLog.setSysLogInfo();
    
	DeliveryTypeComInfo.removeDeliveryTypeCache();
}
else if (method.equals("delete"))
{
	RecordSet.executeProc("CRM_DeliveryType_Delete",id);
	int cid=0;
	while(RecordSet.next()){
		cid = RecordSet.getInt(1);
		out.print("id"+id);
	}
	char separator = Util.getSeparator() ;
	String para = name+separator+desc;
	SysMaintenanceLog.resetParameter();
    SysMaintenanceLog.setRelatedId(cid);
    SysMaintenanceLog.setRelatedName(name);
    SysMaintenanceLog.setOperateType("3");
    SysMaintenanceLog.setOperateDesc("CrmDeliveryType_Delete,"+para);
    SysMaintenanceLog.setOperateItem("146");
    SysMaintenanceLog.setOperateUserid(user.getUID());
    SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
    SysMaintenanceLog.setSysLogInfo();
   
	DeliveryTypeComInfo.removeDeliveryTypeCache();
}
else
{
	response.sendRedirect("/CRM/DBError.jsp?type=Unknown");
	return;
}
response.sendRedirect("/CRM/Maint/ListDeliveryType.jsp");
%>