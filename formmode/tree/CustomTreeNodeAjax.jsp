
<%@page import="weaver.formmode.virtualform.VirtualFormHandler"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@page import="weaver.workflow.form.FormManager"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
int sourceid = Util.getIntValue(request.getParameter("sourceid"),0);
int sourcefrom = Util.getIntValue(request.getParameter("sourcefrom"),0);
String tablename = "";
String sql = "";
if(sourcefrom==1){//模块
	FormManager fManager = new FormManager();
	sql = "select * from modeinfo where id = " +sourceid;
	rs.executeSql(sql);
	while(rs.next()){
		int formid = rs.getInt("formid");
		tablename = fManager.getTablename(formid);
		if(VirtualFormHandler.isVirtualForm(formid)){
			tablename = VirtualFormHandler.getRealFromName(tablename);
		}
		//tablename = "formtable_main_"+Math.abs(formid);
	}
}
%>
<%=tablename%>