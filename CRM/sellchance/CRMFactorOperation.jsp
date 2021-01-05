<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SellsuccessComInfo" class="weaver.crm.sellchance.SellsuccessComInfo" scope="page" />
<jsp:useBean id="SellfailureComInfo" class="weaver.crm.sellchance.SellfailureComInfo" scope="page" />
<%
String method = request.getParameter("method");
String sign = request.getParameter("sign");
String id = request.getParameter("id");
String type = Util.fromScreen(request.getParameter("type"),user.getLanguage());
String desc = Util.fromScreen(request.getParameter("desc"),user.getLanguage());
if(!HrmUserVarify.checkUserRight("CrmSalesChance:Maintenance", user)){
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
if (method.equals("add")&&sign.equals("s"))
{
	char flag=2;
	boolean insertSuccess = false ;
	insertSuccess = RecordSet.executeProc("CRM_Successfactor_Insert",type+flag+desc);
	if(insertSuccess)
	{
		int cid = 0;
		RecordSet.executeSql("select MAX(ID) as maxid from CRM_Successfactor");
		RecordSet.first();
		cid = RecordSet.getInt(1);
		//设置OrderKey 排序字段为自动生成的ID(存储过程返回的ID);
		RecordSet.execute("update CRM_Successfactor set orderkey='"+cid+"' where id='"+cid+"'");
	}
    SellsuccessComInfo.removeSuccessCache();
    response.sendRedirect("/CRM/sellchance/AddCRMSuccessfactor.jsp?isclose=1");
    
}
else if (method.equals("edit")&&sign.equals("s"))
{
	char flag=2;
	RecordSet.executeProc("CRM_Successfactor_Update",id+flag+type+flag+desc); SellsuccessComInfo.removeSuccessCache();
	SellsuccessComInfo.removeSuccessCache();
	response.sendRedirect("/CRM/sellchance/EditSuccessfactor.jsp?isclose=1");
}

else if (method.equals("delete")&&sign.equals("s"))
{
	RecordSet.executeProc("CRM_Successfactor_Delete",id);
	// added by lupeng 2004-08-08 for TD791.
	if (RecordSet.next() && RecordSet.getInt(1) == -1) {
		//response.sendRedirect("/CRM/sellchance/EditSuccessfactor.jsp?id=" + id + "&msgid=20");
		 response.sendRedirect("/CRM/sellchance/ListCRMSuccessfactorInner.jsp?msgRes=err");

		return;
	}		
	// end.

    SellsuccessComInfo.removeSuccessCache();
    response.sendRedirect("/CRM/sellchance/ListCRMSuccessfactorInner.jsp");

}else if(method.equals("sort")&&sign.equals("s"))
{
	String tableids = Util.null2String(request.getParameter("ids"));
	String[] _tableid = Util.TokenizerString2(tableids,"_");
	//循环更新，用for循环不是很好，但貌似没有更好的办法，一般称呼的话数据量也不多
	for(int i=0;i<_tableid.length;i++)
	{
		RecordSet.execute("update CRM_Successfactor set orderkey='"+i+"' where id='"+_tableid[i]+"'");
	}
	
}


if (method.equals("add")&&sign.equals("f"))
{
    char flag=2;
    boolean insertSuccess = false ;
    insertSuccess = RecordSet.executeProc("CRM_Failfactor_Insert",type+flag+desc);
    if(insertSuccess)
    {
        int cid = 0;
        RecordSet.executeSql("select MAX(ID) as maxid from CRM_Failfactor");
        RecordSet.first();
        cid = RecordSet.getInt(1);
        RecordSet.execute("update CRM_Failfactor set orderkey='"+cid+"' where id='"+cid+"'");
    }
    //上面执行不成功执行下面insert插入
	if(!insertSuccess) {
	    int cid = 0;
	    RecordSet.executeSql("select MAX(ID) as maxid from CRM_Failfactor");
	    RecordSet.first();
	    cid = RecordSet.getInt(1);
	    if(cid==-1) {
            	cid=0;
            }
	    cid++;
	    RecordSet.execute("insert into CRM_Failfactor values("+cid+",'"+type+"','"+desc+"',"+cid+") "); 
	}
	SellfailureComInfo.removeFailureCache();
    response.sendRedirect("/CRM/sellchance/AddCRMFailfactor.jsp?isclose=1");
    
}

else if (method.equals("edit")&&sign.equals("f"))
{
	char flag=2;
	RecordSet.executeProc("CRM_Failfactor_Update",id+flag+type+flag+desc);
    SellfailureComInfo.removeFailureCache();
    response.sendRedirect("/CRM/sellchance/EditFailfactor.jsp?isclose=1");
    
}

else if (method.equals("delete")&&sign.equals("f"))
{
	RecordSet.executeProc("CRM_Failfactor_Delete",id);
	// added by lupeng 2004-08-08 for TD794.
	if (RecordSet.next() && RecordSet.getInt(1) == -1) {
		//response.sendRedirect("/CRM/sellchance/EditFailfactor.jsp?id=" + id + "&msgid=20");
		response.sendRedirect("/CRM/sellchance/ListCRMFailfactorInner.jsp?msgRes=err");
		return;
	}		
	// end.

    SellfailureComInfo.removeFailureCache();
    response.sendRedirect("/CRM/sellchance/ListCRMFailfactorInner.jsp");
    
}else if(method.equals("sort")&&sign.equals("f"))
{
	String tableids = Util.null2String(request.getParameter("ids"));
	String[] _tableid = Util.TokenizerString2(tableids,"_");
	//循环更新，用for循环不是很好，但貌似没有更好的办法，一般称呼的话数据量也不多
	for(int i=0;i<_tableid.length;i++)
	{
		RecordSet.execute("update CRM_Failfactor set orderkey='"+i+"' where id='"+_tableid[i]+"'");
	}
	
}

%>