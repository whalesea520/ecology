<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.hrm.HrmUserVarify"%>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SelltypesComInfo" class="weaver.crm.sellchance.SelltypesComInfo" scope="page" />

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
	RecordSet.execute("insert into CRM_SellTypes(fullname ,description) values('"+type+"','"+desc+"')");
	SelltypesComInfo.removeSuccessCache();
    response.sendRedirect("/CRM/sellchance/AddCRMTypes.jsp?isclose=1");
}
else if (method.equals("edit"))
{
	char flag=2;
	RecordSet.execute("update CRM_SellTypes set fullname = '"+type+"' , description = '"+desc+"' where id = '"+id+"'");
	SelltypesComInfo.removeSuccessCache();
    response.sendRedirect("/CRM/sellchance/EditCRMTypes.jsp?isclose=1");
}

else if (method.equals("delete"))
{
	RecordSet.execute("SELECT * FROM CRM_SellChance WHERE selltypesid = '"+id+"'");
	// added by lupeng 2004-08-05 for TD764.
	if (RecordSet.getCounts()>0) {
		out.println("occupy");
		return;
	}		
	// end.
	RecordSet.execute("delete FROM CRM_SellTypes WHERE id = '"+id+"'");
	SelltypesComInfo.removeSuccessCache();
    //response.sendRedirect("/CRM/sellchance/ListCRMTypesInner.jsp");
    return;
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