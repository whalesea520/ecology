
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="TradeInfoComInfo" class="weaver.crm.Maint.TradeInfoComInfo" scope="page" />
<%
String method = Util.null2String(request.getParameter("method"));
String id = Util.null2String(request.getParameter("id"));
String name = Util.fromScreen(request.getParameter("name"),user.getLanguage());
String lowamount = Util.fromScreen(request.getParameter("lowamount"),user.getLanguage());
String highamount = Util.fromScreen(request.getParameter("highamount"),user.getLanguage());

if (method.equals("add"))
{
	if(!HrmUserVarify.checkUserRight("AddTradeInfo:Add", user)){
		response.sendRedirect("/notice/noright.jsp") ;
		return ;
	}
	char flag=2;
	boolean insertSuccess = false ;
	insertSuccess = RecordSet.executeProc("CRM_TradeInfo_Insert",name+flag+lowamount+flag+highamount);
	if(insertSuccess)
	{
		int cid = 0;
		RecordSet.executeSql("select MAX(ID) as maxid from CRM_TradeInfo");
		RecordSet.first();
		cid = RecordSet.getInt(1);
		//设置OrderKey 排序字段为自动生成的ID(存储过程返回的ID);
		RecordSet.execute("update CRM_TradeInfo set orderkey='"+cid+"' where id='"+cid+"'");
	}
	TradeInfoComInfo.removeTradeInfoCache();
	response.sendRedirect("/CRM/Maint/AddTradeInfo.jsp?isclose=1");
}
else if (method.equals("edit"))
{
	if(!HrmUserVarify.checkUserRight("EditTradeInfo:Edit", user)){
		response.sendRedirect("/notice/noright.jsp") ;
		return ;
	}
	char flag=2;
	RecordSet.executeProc("CRM_TradeInfo_Update",id+flag+name+flag+lowamount+flag+highamount);

	TradeInfoComInfo.removeTradeInfoCache();
	response.sendRedirect("/CRM/Maint/EditTradeInfo.jsp?isclose=1");
}
else if (method.equals("delete"))
{
	if(!HrmUserVarify.checkUserRight("EditTradeInfo:Delete", user)){
		response.sendRedirect("/notice/noright.jsp") ;
		return ;
	}
	RecordSet.executeProc("CRM_TradeInfo_Delete",id);
	if (RecordSet.next() && RecordSet.getInt(1) == -1) {
		response.sendRedirect("/CRM/Maint/ListTradeInfoInner.jsp?msgid=20");
		return;
	}	
	TradeInfoComInfo.removeTradeInfoCache();
	response.sendRedirect("/CRM/Maint/ListTradeInfoInner.jsp");
}else if(method.equals("sort"))
{
	String tableids = Util.null2String(request.getParameter("ids"));
	String[] _tableid = Util.TokenizerString2(tableids,"_");
	//循环更新，用for循环不是很好，但貌似没有更好的办法，一般称呼的话数据量也不多
	for(int i=0;i<_tableid.length;i++)
	{
		RecordSet.execute("update CRM_TradeInfo set orderkey='"+i+"' where id='"+_tableid[i]+"'");
	}
	
}
else
{
	response.sendRedirect("/CRM/DBError.jsp?type=Unknown");
	return;
}

%>