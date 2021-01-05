
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/page/maint/common/initNoCache.jsp" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="AddressTypeComInfo" class="weaver.crm.Maint.AddressTypeComInfo" scope="page" />
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<%
String method = Util.null2String(request.getParameter("method"));
String id = Util.null2String(request.getParameter("id"));
String type = Util.null2String(request.getParameter("type"));
String desc = Util.fromScreen(request.getParameter("desc"),user.getLanguage());

if (method.equals("add"))
{
	if(!HrmUserVarify.checkUserRight("AddAddressType:add", user)){
		response.sendRedirect("/notice/noright.jsp") ;
		return ;
	}
	char flag=2;
	boolean insertSuccess = false ;
	insertSuccess = RecordSet.executeProc("CRM_AddressType_Insert",type+flag+desc);
	int cid=0;
	if(insertSuccess)
	{
		RecordSet.execute("SELECT max(id) from CRM_AddressType");
		RecordSet.first();
		cid = RecordSet.getInt(1);
		//设置OrderKey 排序字段为自动生成的ID(存储过程返回的ID);
		RecordSet.execute("update CRM_AddressType set orderkey='"+cid+"' where id='"+cid+"'");
	}
	char separator = Util.getSeparator() ;
	String para = type+separator+desc;
	SysMaintenanceLog.resetParameter();
    SysMaintenanceLog.setRelatedId(cid);
    SysMaintenanceLog.setRelatedName(type);
    SysMaintenanceLog.setOperateType("1");
    SysMaintenanceLog.setOperateDesc("CrmAddressType_Add,"+para);
    SysMaintenanceLog.setOperateItem("144");
    SysMaintenanceLog.setOperateUserid(user.getUID());
    SysMaintenanceLog.setOperateusertype(Util.getIntValue(user.getLogintype(),0));
    SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
    SysMaintenanceLog.setSysLogInfo();
	AddressTypeComInfo.removeAddressTypeCache();
	response.sendRedirect("/CRM/Maint/AddAddressType.jsp?isclose=1");
}
else if (method.equals("edit"))
{
	if(!HrmUserVarify.checkUserRight("EditAddressType:Edit", user)){
		response.sendRedirect("/notice/noright.jsp") ;
		return ;
	}
	char flag=2;
	RecordSet.executeProc("CRM_AddressType_Update",id+flag+type+flag+desc);
	int cid=0;
	while(RecordSet.next()){
		cid = RecordSet.getInt(1);
		out.print("id"+id);
	}
	char separator = Util.getSeparator() ;
	String para = type+separator+desc;
	SysMaintenanceLog.resetParameter();
    SysMaintenanceLog.setRelatedId(Integer.valueOf(id).intValue());
    SysMaintenanceLog.setRelatedName(type);
    SysMaintenanceLog.setOperateType("2");
    SysMaintenanceLog.setOperateDesc("CrmAddressType_Update,"+para);
    SysMaintenanceLog.setOperateItem("144");
    SysMaintenanceLog.setOperateUserid(user.getUID());
    SysMaintenanceLog.setOperateusertype(Util.getIntValue(user.getLogintype(),0));
    SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
    SysMaintenanceLog.setSysLogInfo();
	AddressTypeComInfo.removeAddressTypeCache();
	response.sendRedirect("/CRM/Maint/EditAddressType.jsp?isclose=1");
}
else if (method.equals("delete"))
{
	if(!HrmUserVarify.checkUserRight("EditAddressType:Delete", user)){
		response.sendRedirect("/notice/noright.jsp") ;
		return ;
	}
	if(type.equals(""))
	{
		RecordSet.execute("select fullname from CRM_AddressType where id=" + id);
		RecordSet.first();
		type = RecordSet.getString("fullname");
	}
	RecordSet.execute("CRM_AddressType_Delete",id);
	//RecordSet.execute("delete from crm_addresstype where id = "+id);
	char separator = Util.getSeparator() ;
	String para = type+separator+desc;
	SysMaintenanceLog.resetParameter();
    SysMaintenanceLog.setRelatedId(Integer.valueOf(id).intValue());
    SysMaintenanceLog.setRelatedName(type);
    SysMaintenanceLog.setOperateType("3");
    SysMaintenanceLog.setOperateDesc("CrmAddressType_Delete,"+para);
    SysMaintenanceLog.setOperateItem("144");
    SysMaintenanceLog.setOperateUserid(user.getUID());
    SysMaintenanceLog.setOperateusertype(Util.getIntValue(user.getLogintype(),0));
    SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
    SysMaintenanceLog.setSysLogInfo();
	if (RecordSet.next() && RecordSet.getInt(1) == -1) {
		response.sendRedirect("/CRM/Maint/ListAddressTypeInner.jsp?msgid=20&id=" + id);
		return;
	}



	return;
}
else if(method.equals("sort"))
{
	String tableids = Util.null2String(request.getParameter("ids"));
	String[] _tableid = Util.TokenizerString2(tableids,"_");
	//循环更新，用for循环不是很好，但貌似没有更好的办法，一般称呼的话数据量也不多
	for(int i=0;i<_tableid.length;i++)
	{
		RecordSet.execute("update CRM_AddressType set orderkey='"+i+"' where id='"+_tableid[i]+"'");
	}
	
}
else
{
	response.sendRedirect("/CRM/DBError.jsp?type=Unknown");
	return;
}
%>
