<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.hrm.attendance.manager.WorkflowBillfieldManager"%>
<%@page import="weaver.conn.RecordSet"%>
<jsp:useBean id="attProcSetManager" class="weaver.hrm.attendance.manager.HrmAttProcSetManager" scope="page" />
<%
	int field002 = -35 ;
	int field001 = 63 ;
	String[] fieldList = attProcSetManager.getFieldList(63, -35);	
	//out.print(fieldList[0]);
	
	WorkflowBillfieldManager manager = new WorkflowBillfieldManager();
	//out.print(manager.find("[map]billid:"+field002));
	//out.print("<br />");
	//out.print(attProcSetManager.getFieldList(0, true, "select id from hrm_att_proc_set where field001 = "+field001+" and field002 = "+field002));
	
	RecordSet rs = new RecordSet();
	rs.execute( "select id from hrm_att_proc_set where field001 = "+field001+" and field002 = "+field002) ;
	while(rs.next()){
		out.print(rs.getString("id"));
	}
%>