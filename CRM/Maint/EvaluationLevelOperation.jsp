
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="EvaluationLevelComInfo" class="weaver.crm.Maint.EvaluationLevelComInfo" scope="page" />
<%
String method = Util.null2String(request.getParameter("method"));
String id = Util.null2String(request.getParameter("id"));
String name = Util.fromScreen(request.getParameter("name"),user.getLanguage());
String levelvalue = Util.fromScreen(request.getParameter("levelvalue"),user.getLanguage());

if (method.equals("add"))
{
	if(!HrmUserVarify.checkUserRight("CRM_EvaluationAdd:Add", user)){
		response.sendRedirect("/notice/noright.jsp") ;
		return ;
	}
	char flag=2;
	boolean insertSuccess = false ;
	insertSuccess = RecordSet.executeProc("CRM_Evaluation_L_Insert",name+flag+levelvalue);
	int cid=0;
	if(insertSuccess)
	{
		RecordSet.executeSql("Select Max(id) as maxid FROM CRM_Evaluation_Level");
	    RecordSet.first();
	    cid = RecordSet.getInt(1);
		//设置OrderKey 排序字段为自动生成的ID(存储过程返回的ID);
		RecordSet.execute("update CRM_Evaluation_Level set orderkey='"+cid+"' where id='"+cid+"'");
	}
	EvaluationLevelComInfo.removeEvaluationLevelCache();
	response.sendRedirect("/CRM/Maint/AddEvaluationLevel.jsp?isclose=1");
}
else if (method.equals("edit"))
{
	if(!HrmUserVarify.checkUserRight("CRM_EvaluationEdit:Edit",user)){
		response.sendRedirect("/notice/noright.jsp") ;
		return ;
	}
	char flag=2;
	RecordSet.executeProc("CRM_Evaluation_L_Update",id+flag+name+flag+levelvalue);

	EvaluationLevelComInfo.removeEvaluationLevelCache();
	response.sendRedirect("/CRM/Maint/EditEvaluationLevel.jsp?isclose=1");
}
else if (method.equals("delete")) {
	if(!HrmUserVarify.checkUserRight("CRM_EvaluationDelete:Delete", user)){
		response.sendRedirect("/notice/noright.jsp") ;
		return ;
	}
	RecordSet.executeProc("CRM_Evaluation_L_Delete",id);
    
	if (RecordSet.next() && RecordSet.getInt(1) == -1) {
		response.sendRedirect("/CRM/Maint/EvaluationLevelList.jsp?msgid=20");
		return;
	}
	EvaluationLevelComInfo.removeEvaluationLevelCache();
	response.sendRedirect("/CRM/Maint/EvaluationLevelListInner.jsp");
}
else if(method.equals("sort"))
{
	String tableids = Util.null2String(request.getParameter("ids"));
	String[] _tableid = Util.TokenizerString2(tableids,"_");
	//循环更新，用for循环不是很好，但貌似没有更好的办法，一般称呼的话数据量也不多
	for(int i=0;i<_tableid.length;i++)
	{
		RecordSet.execute("update CRM_Evaluation_Level set orderkey='"+i+"' where id='"+_tableid[i]+"'");
	}
	
}
else
{
	response.sendRedirect("/CRM/DBError.jsp?type=Unknown");
	return;
}
%>