
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%><%@ page contentType="text/html; charset=UTF-8"%><%@ page import="weaver.general.Util"%><%@page import="weaver.conn.RecordSet"%><%@page import="weaver.hrm.User"%>

<jsp:useBean id="xmlParser" class="weaver.workflow.layout.WorkflowXmlParser" scope="page" />

<% 
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
//response.setCharacterEncoding("UTF-8");
	String type = Util.null2String(request.getParameter("type"));
	int userid = Util.getIntValue(request.getParameter("userid"));
	
	User tuser = new User();
	tuser.setUid(userid);
	tuser.setLogintype("1");

	RecordSet rs = new RecordSet();
	String sql = "select departmentid, subcompanyid1, seclevel from hrmresource where id=" + userid;
	rs.executeSql(sql);
	
	if (rs.next()) {
		tuser.setSeclevel(rs.getString("seclevel"));
		tuser.setUserDepartment(Util.getIntValue(rs.getString("departmentid"), 0));
		tuser.setUserSubCompany1(Util.getIntValue(rs.getString("subcompanyid1"), 0));
	}
	
	String workflowId = Util.null2String((String)request.getParameter("wfid"));
	//String serverstr=request.getScheme()+"://"+request.getHeader("Host");
    xmlParser.setWorkflowId(workflowId);
    xmlParser.setUser(tuser);
    String xmlContent = xmlParser.parseWorkflowToXML(type);
//    System.out.println(new String(xmlContent.getBytes("utf-8"), "UTF-8"));
response.getWriter().write(new String(xmlContent.getBytes("UTF-8"), "UTF-8"));
%>
