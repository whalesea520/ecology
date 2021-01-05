
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="ContacterTitleComInfo" class="weaver.crm.Maint.ContacterTitleComInfo" scope="page" />
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />

<%
String method = Util.null2String(request.getParameter("method"));
String name = Util.fromScreen(request.getParameter("name"),user.getLanguage());
String desc = Util.fromScreen(request.getParameter("desc"),user.getLanguage());
String usage = Util.fromScreen(request.getParameter("usage"),user.getLanguage());
String language = Util.fromScreen(request.getParameter("language"),user.getLanguage());
String abbrev = Util.fromScreen(request.getParameter("abbrev"),user.getLanguage());
String id = Util.null2String(request.getParameter("id"));

if (method.equals("add"))
{
	if(!HrmUserVarify.checkUserRight("AddContacterTitle:Add",user)) {
		response.sendRedirect("/notice/noright.jsp") ;
		return ;
	}
	char flag=2;
	boolean insertSuccess = false ;
	insertSuccess = RecordSet.executeProc("CRM_ContacterTitle_Insert",name+flag+desc+flag+usage+flag+language+flag+abbrev);
	int cid=0;
	if (insertSuccess) {
		RecordSet.execute("SELECT max(id) from CRM_ContacterTitle");
		RecordSet.first();
		cid = RecordSet.getInt(1);
		//设置OrderKey 排序字段为自动生成的ID(存储过程返回的ID);
		RecordSet.execute("update CRM_ContacterTitle set orderkey='"+cid+"' where id='"+cid+"'");
		//ContacterTitleComInfo.removeContacterTitleCache();
	}
	
	char separator = Util.getSeparator() ;
	String para = name+separator+desc;
	SysMaintenanceLog.resetParameter();
    SysMaintenanceLog.setRelatedId(cid);
    SysMaintenanceLog.setRelatedName(name);
    SysMaintenanceLog.setOperateType("1");
    SysMaintenanceLog.setOperateDesc("CrmContacterTitle_Add,"+para);
    SysMaintenanceLog.setOperateItem("143");
    SysMaintenanceLog.setOperateUserid(user.getUID());
    SysMaintenanceLog.setOperateusertype(Util.getIntValue(user.getLogintype(),0));
    SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
    SysMaintenanceLog.setSysLogInfo();
	ContacterTitleComInfo.removeContacterTitleCache();
	response.sendRedirect("/CRM/Maint/AddContacterTitle.jsp?isclose=1");
}
else if (method.equals("edit"))
{
	if(!HrmUserVarify.checkUserRight("EditContacterTitle:Edit", user)){
		response.sendRedirect("/notice/noright.jsp") ;
		return ;
	}
	char flag=2;
	RecordSet.executeProc("CRM_ContacterTitle_Update",id+flag+name+flag+desc+flag+usage+flag+language+flag+abbrev);
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
    SysMaintenanceLog.setOperateDesc("CrmContacterTitle_Update,"+para);
    SysMaintenanceLog.setOperateItem("143");
    SysMaintenanceLog.setOperateUserid(user.getUID());
    SysMaintenanceLog.setOperateusertype(Util.getIntValue(user.getLogintype(),0));
    SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
    SysMaintenanceLog.setSysLogInfo();
	ContacterTitleComInfo.removeContacterTitleCache();
	response.sendRedirect("/CRM/Maint/EditContacterTitle.jsp?isclose=1");
}
else if (method.equals("delete"))
{
	if(!HrmUserVarify.checkUserRight("EditContacterTitle:Delete", user)){
		response.sendRedirect("/notice/noright.jsp") ;
		return ;
	}
	if(name.equals(""))
	{
		RecordSet.execute("select fullname from CRM_ContacterTitle where id=" + id);
		RecordSet.first();
		name = RecordSet.getString("fullname");
	}
	RecordSet.executeProc("CRM_ContacterTitle_Delete",id);
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
    SysMaintenanceLog.setOperateDesc("CrmContacterTitle_Delete,"+para);
    SysMaintenanceLog.setOperateItem("143");
    SysMaintenanceLog.setOperateUserid(user.getUID());
    SysMaintenanceLog.setOperateusertype(Util.getIntValue(user.getLogintype(),0));
    SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
    SysMaintenanceLog.setSysLogInfo();
	if (RecordSet.next() && RecordSet.getInt(1) == -1) {
		response.sendRedirect("/CRM/Maint/ListContacterTitleInner.jsp?msgid=20&id=" + id);
		return;
	}
	ContacterTitleComInfo.removeContacterTitleCache();
	response.sendRedirect("/CRM/Maint/ListContacterTitleInner.jsp");
}
else if(method.equals("sort"))
{
	String tableids = Util.null2String(request.getParameter("ids"));
	String[] _tableid = Util.TokenizerString2(tableids,"_");
	//循环更新，用for循环不是很好，但貌似没有更好的办法，一般称呼的话数据量也不多
	for(int i=0;i<_tableid.length;i++)
	{
		RecordSet.execute("update CRM_ContacterTitle set orderkey='"+i+"' where id='"+_tableid[i]+"'");
	}
	
}
else
{
	response.sendRedirect("/CRM/DBError.jsp?type=Unknown");
	return;
}

%>