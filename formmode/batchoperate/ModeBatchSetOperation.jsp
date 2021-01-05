
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="InterfaceTransmethod" class="weaver.formmode.interfaces.InterfaceTransmethod" scope="page" />
<jsp:useBean id="DMLActionBase" class="weaver.formmode.interfaces.dmlaction.commands.bases.DMLActionBase" scope="page" />
<jsp:useBean id="wsActionManager" class="weaver.formmode.interfaces.action.WSActionManager" scope="page" />
<jsp:useBean id="sapActionManager" class="weaver.formmode.interfaces.action.SapActionManager" scope="page" />
<jsp:useBean id="baseAction" class="weaver.formmode.interfaces.action.BaseAction" scope="page" />

<%
if(!HrmUserVarify.checkUserRight("FORMMODEAPP:ALL", user)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}

String operation = Util.null2String(request.getParameter("operation"));
String sql = "";

int customsearchid = Util.getIntValue(request.getParameter("id"),0);
int nLogCount = Util.getIntValue(request.getParameter("nLogCount"),0);

//先删除数据再重新保存
if (operation.equals("edit")) {
	sql = "delete from mode_batchset where customsearchid = " + customsearchid;
	rs.executeSql(sql);
	for(int i=0;i<nLogCount;i++){
		int expandid = Util.getIntValue(request.getParameter("expandid_"+i),0);
		double showorder = Util.getDoubleValue(request.getParameter("showorder_"+i),0);
		int isuse = Util.getIntValue(request.getParameter("isuse_"+i),0);
		int isshortcutbutton = Util.getIntValue(request.getParameter("isshortcutbutton_"+i),0);
		String listbatchname = InterfaceTransmethod.toHtmlForMode(request.getParameter("listbatchname_"+i));
		sql = "insert into mode_batchset(expandid,showorder,customsearchid,isuse,listbatchname,isshortcutbutton) ";
		sql += "values ("+expandid+",'"+showorder+"','"+customsearchid+"','"+isuse+"','"+listbatchname+"','"+isshortcutbutton+"')";
		rs.executeSql(sql);
	}
}
response.sendRedirect("/formmode/batchoperate/ModeBatchSet.jsp?id="+customsearchid);
%>