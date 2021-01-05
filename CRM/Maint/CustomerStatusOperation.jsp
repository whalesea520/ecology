
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="CustomerStatusComInfo" class="weaver.crm.Maint.CustomerStatusComInfo" scope="page" />
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<%
String method = Util.null2String(request.getParameter("method"));
String id = Util.null2String(request.getParameter("id"));
String name = Util.fromScreen(request.getParameter("name"),user.getLanguage());
String desc = Util.fromScreen(request.getParameter("desc"),user.getLanguage());
String cnname = Util.null2String(request.getParameter("cnname"));
String usname = Util.null2String(request.getParameter("usname"));
String twname = Util.null2String(request.getParameter("twname"));

if (method.equals("add"))
{
	char flag=2;
	RecordSet.executeProc("CRM_CustomerStatus_Insert",name+flag+desc);

    RecordSet.executeSql("Select Max(id) as maxid FROM CRM_CustomerStatus");
      RecordSet.next();

      SysMaintenanceLog.resetParameter();
      SysMaintenanceLog.setRelatedId(RecordSet.getInt("maxid"));
      SysMaintenanceLog.setRelatedName(name);
      SysMaintenanceLog.setOperateType("1");
      SysMaintenanceLog.setOperateDesc("CustomerStatus_Insert,"+name+flag+desc);
      SysMaintenanceLog.setOperateItem("109");
      SysMaintenanceLog.setOperateUserid(user.getUID());
      SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
      SysMaintenanceLog.setSysLogInfo();

	CustomerStatusComInfo.removeCustomerStatusCache();
}
else if (method.equals("edit"))
{
	if(!HrmUserVarify.checkUserRight("EditCustomerStatus:Edit",user)){
        response.sendRedirect("/notice/noright.jsp") ;
        return ;
    }
	char flag=2;
	RecordSet.executeProc("CRM_CustomerStatus_Update",id+flag+name+flag+desc+flag+cnname+flag+usname+flag+twname);

   SysMaintenanceLog.resetParameter();
      SysMaintenanceLog.setRelatedId(Util.getIntValue(id));
      SysMaintenanceLog.setRelatedName(name);
      SysMaintenanceLog.setOperateType("2");
      SysMaintenanceLog.setOperateDesc("CustomerStatus_Update,"+id+flag+name+flag+desc+flag+cnname+flag+usname+flag+twname);
      SysMaintenanceLog.setOperateItem("109");
      SysMaintenanceLog.setOperateUserid(user.getUID());
      SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
      SysMaintenanceLog.setSysLogInfo();

	CustomerStatusComInfo.removeCustomerStatusCache();
	response.sendRedirect("/CRM/Maint/EditCustomerStatusInner.jsp?isclose=1");
}
else if (method.equals("delete"))
{
   RecordSet.executeSql("Select fullname FROM CRM_CustomerStatus where id ="+id);
	RecordSet.next();
    String statusName = RecordSet.getString("fullname"); 

	RecordSet.executeProc("CRM_CustomerStatus_Delete",id);

    SysMaintenanceLog.resetParameter();
      SysMaintenanceLog.setRelatedId(Util.getIntValue(id));
      SysMaintenanceLog.setRelatedName(statusName);
      SysMaintenanceLog.setOperateType("2");
      SysMaintenanceLog.setOperateDesc("CustomerStatus_Delete,"+id);
      SysMaintenanceLog.setOperateItem("109");
      SysMaintenanceLog.setOperateUserid(user.getUID());
      SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
      SysMaintenanceLog.setSysLogInfo();

	CustomerStatusComInfo.removeCustomerStatusCache();
}
else
{
	response.sendRedirect("/CRM/DBError.jsp?type=Unknown");
	return;
}
%>