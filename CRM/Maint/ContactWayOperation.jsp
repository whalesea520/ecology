
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="ContactWayComInfo" class="weaver.crm.Maint.ContactWayComInfo" scope="page" />
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<%
String method = Util.null2String(request.getParameter("method"));
String id = Util.null2String(request.getParameter("id"));
String name = Util.fromScreen(request.getParameter("type"),user.getLanguage());
String desc = Util.fromScreen(request.getParameter("desc"),user.getLanguage());

if (method.equals("add"))
{
	if(!HrmUserVarify.checkUserRight("AddContactWay:add", user)){
		response.sendRedirect("/notice/noright.jsp") ;
		return ;
	}
	char flag=2;
	boolean insertSuccess = false ;
	insertSuccess = RecordSet.executeProc("CRM_ContactWay_Insert",name+flag+desc);
	int cid=0;
	if(insertSuccess)
	{
		RecordSet.execute("SELECT max(id) from CRM_ContactWay");
		RecordSet.first();
		cid = RecordSet.getInt(1);
		//设置OrderKey 排序字段为自动生成的ID(存储过程返回的ID);
		RecordSet.execute("update CRM_ContactWay set orderkey='"+cid+"' where id='"+cid+"'");
	}
	char separator = Util.getSeparator() ;
	String para = name+separator+desc;
	SysMaintenanceLog.resetParameter();
    SysMaintenanceLog.setRelatedId(cid);
    SysMaintenanceLog.setRelatedName(name);
    SysMaintenanceLog.setOperateType("1");
    SysMaintenanceLog.setOperateDesc("CrmContactWay_Add,"+para);
    SysMaintenanceLog.setOperateItem("145");
    SysMaintenanceLog.setOperateUserid(user.getUID());
    SysMaintenanceLog.setOperateusertype(Util.getIntValue(user.getLogintype(),0));
    SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
    SysMaintenanceLog.setSysLogInfo();
	ContactWayComInfo.removeContactWayCache();
	response.sendRedirect("/CRM/Maint/AddContactWay.jsp?isclose=1");
}
else if (method.equals("edit"))
{
	if(!HrmUserVarify.checkUserRight("EditContactWay:Edit",user)){
		response.sendRedirect("/notice/noright.jsp") ;
		return ;
	}
	char flag=2;
	RecordSet.executeProc("CRM_ContactWay_Update",id+flag+name+flag+desc);
	int cid=0;
	while(RecordSet.next()){
		cid = RecordSet.getInt(1);
		out.print("id"+id);
	}
	char separator = Util.getSeparator() ;
	String para = name+separator+desc;
	SysMaintenanceLog.resetParameter();
    SysMaintenanceLog.setRelatedId(Integer.valueOf(id).intValue());
    SysMaintenanceLog.setRelatedName(name);
    SysMaintenanceLog.setOperateType("2");
    SysMaintenanceLog.setOperateDesc("CrmContactWay_Update,"+para);
    SysMaintenanceLog.setOperateItem("145");
    SysMaintenanceLog.setOperateUserid(user.getUID());
    SysMaintenanceLog.setOperateusertype(Util.getIntValue(user.getLogintype(),0));
    SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
    SysMaintenanceLog.setSysLogInfo();
	ContactWayComInfo.removeContactWayCache();
	response.sendRedirect("/CRM/Maint/EditContactWay.jsp?isclose=1");
}
else if (method.equals("delete"))
{
	if(!HrmUserVarify.checkUserRight("EditContactWay:Delete", user)){
		response.sendRedirect("/notice/noright.jsp") ;
		return ;
	}
	if(name.equals(""))
	{
		RecordSet.execute("select fullname from CRM_ContactWay where id=" + id);
		RecordSet.first();
		name = RecordSet.getString("fullname");
	}
	RecordSet.executeProc("CRM_ContactWay_Delete",id);
	int cid=0;
	while(RecordSet.next()){
		cid = RecordSet.getInt(1);
		out.print("id"+id);
	}
	char separator = Util.getSeparator() ;
	String para = name+separator+desc;
	SysMaintenanceLog.resetParameter();
    SysMaintenanceLog.setRelatedId(Integer.valueOf(id).intValue());
    SysMaintenanceLog.setRelatedName(name);
    SysMaintenanceLog.setOperateType("3");
    SysMaintenanceLog.setOperateDesc("CrmContactWay_Delete,"+para);
    SysMaintenanceLog.setOperateItem("145");
    SysMaintenanceLog.setOperateUserid(user.getUID());
    SysMaintenanceLog.setOperateusertype(Util.getIntValue(user.getLogintype(),0));
    SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
    SysMaintenanceLog.setSysLogInfo();	
	// added by lupeng 2004-08-05 for TD750.
	if (RecordSet.next() && RecordSet.getInt(1) == -1) {
		response.sendRedirect("/CRM/Maint/ListContactWayInner.jsp?id=" + id + "&msgid=20");
		return;
	}
	ContactWayComInfo.removeContactWayCache();
	response.sendRedirect("/CRM/Maint/ListContactWayInner.jsp");
}
else if(method.equals("sort"))
{
	String tableids = Util.null2String(request.getParameter("ids"));
	String[] _tableid = Util.TokenizerString2(tableids,"_");
	//循环更新，用for循环不是很好，但貌似没有更好的办法，一般称呼的话数据量也不多
	for(int i=0;i<_tableid.length;i++)
	{
		RecordSet.execute("update CRM_ContactWay set orderkey='"+i+"' where id='"+_tableid[i]+"'");
	}
	
}
else
{
	response.sendRedirect("/CRM/DBError.jsp?type=Unknown");
	return;
}
%>