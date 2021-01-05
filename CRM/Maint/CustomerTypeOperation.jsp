
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="CustomerTypeComInfo" class="weaver.crm.Maint.CustomerTypeComInfo" scope="page" />
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<%
String method = Util.null2String(request.getParameter("method"));
String id = Util.null2String(request.getParameter("id"));
String name = Util.fromScreen(request.getParameter("name"),user.getLanguage());
String desc = Util.fromScreen(request.getParameter("desc"),user.getLanguage());
String workflowid = Util.null2String(request.getParameter("workflowid"));

if (method.equals("add"))
{
	if(!HrmUserVarify.checkUserRight("AddCustomerType:add", user)){
		response.sendRedirect("/notice/noright.jsp") ;
		return ;
	}
	String indetail = Util.null2String(request.getParameter("indetail"));
	//added by xwj on 2005-03-22 for td1552
	RecordSet.executeSql("select * from CRM_CustomerType where fullname = '" + name + "'");
	if(!RecordSet.next()){
		char flag=2;
		boolean insertSuccess = false ;
		insertSuccess = RecordSet.executeProc("CRM_CustomerType_Insert",name+flag+desc+flag+workflowid);
		int cid=0;
		if(insertSuccess)
		{
			RecordSet.executeSql("Select Max(id) as maxid FROM CRM_CustomerType");
			RecordSet.first();
			cid = RecordSet.getInt(1);
			//设置OrderKey 排序字段为自动生成的ID(存储过程返回的ID);
			RecordSet.execute("update CRM_CustomerType set orderkey='"+cid+"' where id='"+cid+"'");
		}
	   	

      	SysMaintenanceLog.resetParameter();
      	SysMaintenanceLog.setRelatedId(cid);
      	SysMaintenanceLog.setRelatedName(name);
      	SysMaintenanceLog.setOperateType("1");
      	SysMaintenanceLog.setOperateDesc("CustomerType_Insert,"+name+flag+desc+flag+workflowid);
      	SysMaintenanceLog.setOperateItem("107");
      	SysMaintenanceLog.setOperateUserid(user.getUID());
      	SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
      	SysMaintenanceLog.setSysLogInfo();

    	CustomerTypeComInfo.removeCustomerTypeCache();
    	response.sendRedirect("/CRM/Maint/AddCustomerType.jsp?isclose=1&id="+cid+"&indetail="+indetail);
	}
	else{
    	response.sendRedirect("/CRM/Maint/AddCustomerType.jsp?msgid=17626");
	}

}
else if (method.equals("edit"))
{
	if(!HrmUserVarify.checkUserRight("EditCustomerType:Edit", user)){
		response.sendRedirect("/notice/noright.jsp") ;
		return ;
	}
	char flag=2;
	RecordSet.executeProc("CRM_CustomerType_Update",id+flag+name+flag+desc+flag+workflowid);

     SysMaintenanceLog.resetParameter();
      SysMaintenanceLog.setRelatedId(Util.getIntValue(id));
      SysMaintenanceLog.setRelatedName(name);
      SysMaintenanceLog.setOperateType("2");
      SysMaintenanceLog.setOperateDesc("CustomerType_Update,"+id+flag+name+flag+desc+flag+workflowid);
      SysMaintenanceLog.setOperateItem("107");
      SysMaintenanceLog.setOperateUserid(user.getUID());
      SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
      SysMaintenanceLog.setSysLogInfo();


	CustomerTypeComInfo.removeCustomerTypeCache();
	response.sendRedirect("/CRM/Maint/EditCustomerTypeInner.jsp?isclose=1");
}
else if (method.equals("delete"))
{
	if(!HrmUserVarify.checkUserRight("EditCustomerType:Delete", user)){
		response.sendRedirect("/notice/noright.jsp") ;
		return ;
	}
    RecordSet.executeSql("Select fullname FROM CRM_CustomerType where id ="+id);
	RecordSet.next();
    String typeName = RecordSet.getString("fullname"); 

    RecordSet.execute("Select * FROM CRM_CustomerInfo WHERE type ='"+id+"' and deleted=0");
    if (RecordSet.next()) {
        out.println("该类型已经关联客户,不能删除");
        return;
    }
    RecordSet.execute("delete FROM CRM_CustomerType WHERE id="+id);		
	// end.
    
   SysMaintenanceLog.resetParameter();
      SysMaintenanceLog.setRelatedId(Util.getIntValue(id));
      SysMaintenanceLog.setRelatedName(typeName);
      SysMaintenanceLog.setOperateType("3");
      SysMaintenanceLog.setOperateDesc("CustomerType_delete,"+id);
      SysMaintenanceLog.setOperateItem("107");
      SysMaintenanceLog.setOperateUserid(user.getUID());
      SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
      SysMaintenanceLog.setSysLogInfo();

	CustomerTypeComInfo.removeCustomerTypeCache();
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
		RecordSet.execute("update CRM_CustomerType set orderkey='"+i+"' where id='"+_tableid[i]+"'");
	}
	
}
else
{
	response.sendRedirect("/CRM/DBError.jsp?type=Unknown");
	return;
}
%>