
<%@ page language="java" import="java.util.*" pageEncoding="utf-8" contentType="text/html; charset=utf-8"%>
<%@ page import="weaver.general.Util"%>
<%@ page import="weaver.workflow.workflow.WFManager"%>

<% 
	response.setHeader("cache-control", "no-cache");
	response.setHeader("pragma", "no-cache");
	response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");

	String workflowID = Util.null2String((String)request.getParameter("wfid"));
	String userID = Util.null2String((String)request.getParameter("userid"));
	WFManager wfmgr = new WFManager();
	wfmgr.setWfid(Util.getIntValue(workflowID));
	wfmgr.getWfInfo();
	
	if(Util.null2String(wfmgr.getIsEdit()).equals("1") && wfmgr.getEditor() != Util.getIntValue(userID)){
		response.getWriter().write("1");
		return;
	}
	response.getWriter().write("0");
%>

