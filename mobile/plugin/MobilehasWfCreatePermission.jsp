
<%@ page language="java" contentType="application/json" pageEncoding="UTF-8"%>
<%@page import="net.sf.json.*"%>
<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.file.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.hrm.attendance.manager.*" %>
<%@ page import="weaver.hrm.attendance.domain.*" %>
<%@ page import="weaver.hrm.attendance.domain.HrmScheduleSign.*" %>
<%@ page import="weaver.hrm.report.schedulediff.*" %>

<jsp:useBean id="sm" class="weaver.share.ShareManager" scope="page" />
<%
	response.setContentType("application/json;charset=UTF-8");

	FileUpload fu = new FileUpload(request); 
	Map result = new HashMap();


	User user = HrmUserVarify.getUser(request, response);
	if(user==null) {
		result.put("error", "005");
		JSONObject jo = JSONObject.fromObject(result);
		out.println(jo);
		return;
	}
	String workflowid = Util.null2String(fu.getParameter("workflowid"));
	if("".equals(workflowid)){
		result.put("error", "005");
		JSONObject jo = JSONObject.fromObject(result);
		out.println(jo);
		return;
	}
	boolean flag = sm.hasWfCreatePermission(user,Integer.parseInt(workflowid));
	result.put("flag", flag);
	JSONObject jo = JSONObject.fromObject(result);
	out.println(jo);
%>
