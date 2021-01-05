
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="ContractTypeComInfo" class="weaver.crm.Maint.ContractTypeComInfo" scope="page" />
<%
if(!HrmUserVarify.checkUserRight("CRM_ContractTypeAdd:Add", user)){
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
//added by XWJ on 2005-03-16 for td:1549
String propertyOfApproveWorkFlow = Util.null2String(request.getParameter("propertyOfApproveWorkFlow"));

String method = Util.null2String(request.getParameter("method"));
String id = Util.null2String(request.getParameter("id"));
String name = Util.fromScreen(request.getParameter("name"),user.getLanguage());
String contractdesc = Util.fromScreen(request.getParameter("contractdesc"),user.getLanguage());
String workflowid = "" + Util.getIntValue(request.getParameter("workflowid"),0);
String para = "";
if (method.equals("add"))
{
	char flag=2;
	para = name;
	para += flag + contractdesc;
	para += flag + workflowid;
	boolean insertSuccess = false ;
	insertSuccess = RecordSet.executeProc("CRM_ContractType_Insert",para);
	if(insertSuccess)
	{
		int cid = 0;
		RecordSet.executeSql("select MAX(ID) as maxid from CRM_ContractType");
		RecordSet.first();
		cid = RecordSet.getInt(1);
		//设置OrderKey 排序字段为自动生成的ID(存储过程返回的ID);
		RecordSet.execute("update CRM_ContractType set orderkey='"+cid+"' where id='"+cid+"'");
	}
	ContractTypeComInfo.removeContractTypeCache();
	response.sendRedirect("/CRM/Maint/AddCRMContractType.jsp?isclose=1");
}
else if (method.equals("edit"))
{
	char flag=2;
	para = id;
	para += flag + name;
	para += flag + contractdesc;
	para += flag + workflowid;
	RecordSet.executeProc("CRM_ContractType_Update",para);

	ContractTypeComInfo.removeContractTypeCache();
	response.sendRedirect("/CRM/Maint/EditCRMContractType.jsp?isclose=1");
}
else if (method.equals("delete"))
{	
	RecordSet.executeProc("CRM_ContractType_Delete",id);
	
	if (RecordSet.next() && RecordSet.getInt(1) == -1) {
		response.sendRedirect("/CRM/Maint/CRMContractTypeListInner.jsp?msgRes=err");
		return;
	}		
	ContractTypeComInfo.removeContractTypeCache();	
	response.sendRedirect("/CRM/Maint/CRMContractTypeListInner.jsp");
}else if(method.equals("sort"))
{
	String tableids = Util.null2String(request.getParameter("ids"));
	String[] _tableid = Util.TokenizerString2(tableids,"_");
	//循环更新，用for循环不是很好，但貌似没有更好的办法，一般称呼的话数据量也不多
	for(int i=0;i<_tableid.length;i++)
	{
		RecordSet.execute("update CRM_ContractType set orderkey='"+i+"' where id='"+_tableid[i]+"'");
	}
	
}
else
{
	response.sendRedirect("/CRM/DBError.jsp?type=Unknown");
	return;
}
%>