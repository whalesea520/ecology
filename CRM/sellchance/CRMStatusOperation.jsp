<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.hrm.HrmUserVarify"%>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SellstatusComInfo" class="weaver.crm.sellchance.SellstatusComInfo" scope="page" />

<%

User user = HrmUserVarify.getUser (request , response) ;
if(!HrmUserVarify.checkUserRight("CrmSalesChance:Maintenance", user)){
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
String method = request.getParameter("method");
String id = request.getParameter("id");
String type = Util.fromScreen(request.getParameter("type"),user.getLanguage());
String desc = Util.fromScreen(request.getParameter("desc"),user.getLanguage());

if (method.equals("add"))
{
	char flag=2;
	boolean insertSuccess = false ;
	insertSuccess = RecordSet.executeProc("CRM_SellStatus_Insert",type+flag+desc);
	if(insertSuccess)
	{
		int cid = 0;
		RecordSet.executeSql("select MAX(ID) as maxid from CRM_SellStatus");
		RecordSet.first();
		cid = RecordSet.getInt(1);
		//设置OrderKey 排序字段为自动生成的ID(存储过程返回的ID);
		RecordSet.execute("update CRM_SellStatus set orderkey='"+cid+"' where id='"+cid+"'");
	}
    SellstatusComInfo.removeSuccessCache();
    response.sendRedirect("/CRM/sellchance/AddCRMStatus.jsp?isclose=1");
}
else if (method.equals("edit"))
{
    RecordSet.execute("update CRM_SellStatus set fullname='"+type+"',description = '"+desc+"' where id='"+id+"'");
    
    SellstatusComInfo.removeSuccessCache();
    response.sendRedirect("/CRM/sellchance/EditCRMStatus.jsp?isclose=1");
}

else if (method.equals("delete"))
{
	RecordSet.executeProc("CRM_SellStatus_Delete",id);
	// added by lupeng 2004-08-05 for TD764.
	if (RecordSet.next() && RecordSet.getInt(1) == -1) {
		out.println("occupy");
		return;
	}		
	// end.
    SellstatusComInfo.removeSuccessCache();
    response.sendRedirect("/CRM/sellchance/ListCRMStatusInner.jsp");
}else if(method.equals("sort"))
{
	String tableids = Util.null2String(request.getParameter("ids"));
	String[] _tableid = Util.TokenizerString2(tableids,"_");
	//循环更新，用for循环不是很好，但貌似没有更好的办法，一般称呼的话数据量也不多
	for(int i=0;i<_tableid.length;i++)
	{
		RecordSet.execute("update CRM_SellStatus set orderkey='"+i+"' where id='"+_tableid[i]+"'");
	}
	
}


%>