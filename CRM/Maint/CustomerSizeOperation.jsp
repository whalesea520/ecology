
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="CustomerSizeComInfo" class="weaver.crm.Maint.CustomerSizeComInfo" scope="page" />
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<%
String method = Util.null2String(request.getParameter("method"));
String id = Util.null2String(request.getParameter("id"));
String name = Util.fromScreen(request.getParameter("name"),user.getLanguage());
String desc = Util.fromScreen(request.getParameter("desc"),user.getLanguage());

if (method.equals("add"))
{
	if(!HrmUserVarify.checkUserRight("AddCustomerSize:add", user)){
		response.sendRedirect("/notice/noright.jsp") ;
		return ;
	}
	char flag=2;
	boolean insertSuccess = false ;
	insertSuccess = RecordSet.executeProc("CRM_CustomerSize_Insert",name+flag+desc);
	int cid = 0;
	if(insertSuccess)
	{
		RecordSet.executeSql("Select Max(id) as maxid FROM CRM_CustomerSize");
	    RecordSet.next();
	    cid = RecordSet.getInt("maxid");
	    RecordSet.execute("update CRM_CustomerSize set orderkey='"+cid+"' where id='"+cid+"'");
	}
	SysMaintenanceLog.resetParameter();
   	SysMaintenanceLog.setRelatedId(cid);
   	SysMaintenanceLog.setRelatedName(name);
   	SysMaintenanceLog.setOperateType("1");
   	SysMaintenanceLog.setOperateDesc("CustomerSize_Insert,"+name+flag+desc);
   	SysMaintenanceLog.setOperateItem("106");
   	SysMaintenanceLog.setOperateUserid(user.getUID());
   	SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
   	SysMaintenanceLog.setSysLogInfo();

	CustomerSizeComInfo.removeCustomerSizeCache();
	response.sendRedirect("/CRM/Maint/AddCustomerSize.jsp?isclose=1");
}
else if (method.equals("edit"))
{
	if(!HrmUserVarify.checkUserRight("EditCustomerSize:Edit", user)){
		response.sendRedirect("/notice/noright.jsp") ;
		return ;
	}
	char flag=2;
	RecordSet.executeProc("CRM_CustomerSize_Update",id+flag+name+flag+desc);
 
	SysMaintenanceLog.resetParameter();
	SysMaintenanceLog.setRelatedId(Util.getIntValue(id));
	SysMaintenanceLog.setRelatedName(name);
	SysMaintenanceLog.setOperateType("2");
	SysMaintenanceLog.setOperateDesc("HrmConType_Update,"+id+flag+name+flag+desc);
	SysMaintenanceLog.setOperateItem("106");
	SysMaintenanceLog.setOperateUserid(user.getUID());
	SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
	SysMaintenanceLog.setSysLogInfo();

	CustomerSizeComInfo.removeCustomerSizeCache();
	response.sendRedirect("/CRM/Maint/EditCustomerSize.jsp?isclose=1");
}
else if (method.equals("delete")) {
	if(!HrmUserVarify.checkUserRight("EditCustomerSize:Delete", user)){
		response.sendRedirect("/notice/noright.jsp") ;
		return ;
	}
    RecordSet.execute("Select * FROM CRM_CustomerInfo WHERE size_n ='"+id+"' and deleted=0");
    if (RecordSet.next()) {
        out.println("该规模已经关联客户,不能删除");
        return;
    }
    
    RecordSet.execute("delete FROM CRM_CustomerSize WHERE id="+id);
	
	// end.
    SysMaintenanceLog.resetParameter();
    SysMaintenanceLog.setRelatedId(Util.getIntValue(id));
    SysMaintenanceLog.setRelatedName(name);
    SysMaintenanceLog.setOperateType("3");
  	SysMaintenanceLog.setOperateDesc("HrmConType_Delete,"+id);
    SysMaintenanceLog.setOperateItem("106");
 	SysMaintenanceLog.setOperateUserid(user.getUID());
	SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
	SysMaintenanceLog.setSysLogInfo();

	CustomerSizeComInfo.removeCustomerSizeCache();
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
		RecordSet.execute("update CRM_CustomerSize set orderkey='"+i+"' where id='"+_tableid[i]+"'");
	}
}
else
{
	response.sendRedirect("/CRM/DBError.jsp?type=Unknown");
	return;
}
%>