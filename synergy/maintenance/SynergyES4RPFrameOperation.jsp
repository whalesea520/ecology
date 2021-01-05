
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSetTrans" class="weaver.conn.RecordSetTrans" scope="page" />
<%@ page import="weaver.synergy.SynergyExpressionBean" %>
<%
String method = Util.null2String(request.getParameter("method"));
String eid = Util.null2String(request.getParameter("eid"));
String valueType = Util.null2String(request.getParameter("valueTypeObj"));
String value = Util.null2String(request.getParameter("paramvalueObj"));
String valuename = Util.null2String(request.getParameter("paramvaluenameObj"));

String name = Util.null2String(request.getParameter("paramdatafield"));
String type = Util.null2String(request.getParameter("ptype"));
String browid = Util.null2String(request.getParameter("pbrowid"));
String spid = Util.null2String(request.getParameter("psysid"));
String formid = Util.null2String(request.getParameter("pformid"));
String isbill = Util.null2String(request.getParameter("pisbill"));
String desc = Util.null2String(request.getParameter("desc"));
if (method.equals("add"))
{
	RecordSetTrans.setAutoCommit(false);
	if(browid.equals(""))
		browid = "-1";
	if(spid.equals("0"))
	{
		formid = "-1";
		isbill = "-1";
	}
	RecordSetTrans.executeSql(" select count(id) from sypara_expressionbase where eid="+eid);
	RecordSetTrans.first();
	int valuevariableid = RecordSetTrans.getInt(1);
	int id = SynergyExpressionBean.getdbid(RecordSetTrans);
	int variableid = 0;
	RecordSetTrans.executeSql("select max(id) as id from sypara_variablebase");
	if (RecordSetTrans.next()) {
		variableid = Util.getIntValue(RecordSetTrans.getString("id"), 0);
    }
	variableid += 1;
	RecordSetTrans.executeSql("insert into sypara_variablebase (id,name,type,browsertype,eid,spid,formid,isbill)"+
			" values ("+variableid+",'"+name+"','"+type+"','"+browid+"','"+eid+"','"+spid+"','"+formid+"','"+isbill+"')");
	
	RecordSetTrans.executeSql("insert into sypara_expressionbase (id,eid,variableid,valuetype,value,valueName,valuevariableid,systemparam)"+
	" values("+id+",'"+eid+"','"+variableid+"','"+valueType+"','"+value+"','"+valuename+"','"+valuevariableid+"','"+desc+"')");
	
	RecordSetTrans.commit();
	//response.sendRedirect("/CRM/Maint/AddAddressType.jsp?isclose=1");
}
else if (method.equals("edit"))
{
	
}
else if (method.equals("delete"))
{
	
}
%>
