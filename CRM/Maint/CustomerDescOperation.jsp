
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="CustomerDescComInfo" class="weaver.crm.Maint.CustomerDescComInfo" scope="page" />
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<%
String method = Util.null2String(request.getParameter("method"));
String id = Util.null2String(request.getParameter("id"));
String name = Util.fromScreen(request.getParameter("name"),user.getLanguage());
String desc = Util.fromScreen(request.getParameter("desc"),user.getLanguage());

if (method.equals("add"))
{
	if(!HrmUserVarify.checkUserRight("AddCustomerDesc:add", user)){
		response.sendRedirect("/notice/noright.jsp") ;
		return ;
	}
	char flag=2;
	boolean insertSuccess = false ;
	insertSuccess = RecordSet.executeProc("CRM_CustomerDesc_Insert",name+flag+desc);
	int cid = 0;
	if(insertSuccess)
	{
		RecordSet.executeSql("Select Max(id) as maxid FROM CRM_CustomerDesc");
		RecordSet.next();
	    cid = RecordSet.getInt("maxid");
	    RecordSet.execute("update CRM_CustomerDesc set orderkey='"+cid+"' where id='"+cid+"'");
	}
      SysMaintenanceLog.resetParameter();
      SysMaintenanceLog.setRelatedId(cid);
      SysMaintenanceLog.setRelatedName(name);
      SysMaintenanceLog.setOperateType("1");
      SysMaintenanceLog.setOperateDesc("CustomerDesc_Insert,"+name+flag+desc);
      SysMaintenanceLog.setOperateItem("108");
      SysMaintenanceLog.setOperateUserid(user.getUID());
      SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
      SysMaintenanceLog.setSysLogInfo();
      
	CustomerDescComInfo.removeCustomerDescCache();
	response.sendRedirect("/CRM/Maint/AddCustomerDesc.jsp?isclose=1");
}
else if (method.equals("edit"))
{
	if(!HrmUserVarify.checkUserRight("AddCustomerDesc:add", user)){
		response.sendRedirect("/notice/noright.jsp") ;
		return ;
	}
	char flag=2;
	RecordSet.executeProc("CRM_CustomerDesc_Update",id+flag+name+flag+desc);

    SysMaintenanceLog.resetParameter();
      SysMaintenanceLog.setRelatedId(Util.getIntValue(id));
      SysMaintenanceLog.setRelatedName(name);
      SysMaintenanceLog.setOperateType("2");
      SysMaintenanceLog.setOperateDesc("CustomerDesc_Update,"+id+flag+name+flag+desc);
      SysMaintenanceLog.setOperateItem("108");
      SysMaintenanceLog.setOperateUserid(user.getUID());
      SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
      SysMaintenanceLog.setSysLogInfo();

	CustomerDescComInfo.removeCustomerDescCache();
	response.sendRedirect("/CRM/Maint/EditCustomerDesc.jsp?isclose=1");
}
else if (method.equals("delete"))
{
	if(!HrmUserVarify.checkUserRight("EditCustomerDesc:Delete", user)){
		response.sendRedirect("/notice/noright.jsp") ;
		return ;
	}
	if(name.equals(""))
	{
		RecordSet.executeSql("Select fullname FROM CRM_CustomerDesc where id ="+id);
		RecordSet.next();
    	name = RecordSet.getString("fullname"); 
	}

	RecordSet.execute("Select * FROM CRM_CustomerInfo WHERE description ='"+id+"' and deleted=0");
    if (RecordSet.next()) {
       out.println("该描述已经关联客户,不能删除");
       return;
    }
    RecordSet.execute("delete FROM CRM_CustomerDesc WHERE id="+id);     		
	// end.

    SysMaintenanceLog.resetParameter();
      SysMaintenanceLog.setRelatedId(Util.getIntValue(id));
      SysMaintenanceLog.setRelatedName(name);
      SysMaintenanceLog.setOperateType("3");
      SysMaintenanceLog.setOperateDesc("CustomerDesc_delete,"+id);
      SysMaintenanceLog.setOperateItem("108");
      SysMaintenanceLog.setOperateUserid(user.getUID());
      SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
      SysMaintenanceLog.setSysLogInfo();

	CustomerDescComInfo.removeCustomerDescCache();
	out.println("issuccess");
    return;
}
else if(method.equals("sort"))
{
	String tableids = Util.null2String(request.getParameter("ids"));
	String[] _tableid = Util.TokenizerString2(tableids,"_");
	//循环更新，用for循环不是很好，但貌似没有更好的办法，一般称呼的话数据量也不多
	for(int i=0;i<_tableid.length;i++)
	{
		RecordSet.execute("update CRM_CustomerDesc set orderkey='"+i+"' where id='"+_tableid[i]+"'");
	}
}
else
{
	response.sendRedirect("/CRM/DBError.jsp?type=Unknown");
	return;
}
%>