
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.ArrayList" %>
<%@page import="java.io.PrintWriter"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="WFNodePortalMainManager" class="weaver.workflow.workflow.WFNodePortalMainManager" scope="page" />
<%
	int workflowid = Util.getIntValue(Util.null2String(request.getParameter("workflowid")),0);
	PrintWriter writer = response.getWriter();
	JSONArray array = new JSONArray();
	if (workflowid > 0) {
	    WFNodePortalMainManager.resetParameter();
		WFNodePortalMainManager.setWfid(workflowid);
		WFNodePortalMainManager.selectWfNodePortal();
		while(WFNodePortalMainManager.next()){
			int tmpid = WFNodePortalMainManager.getId();
			String tmpname = WFNodePortalMainManager.getLinkname();
			JSONObject object2 = new JSONObject();
			object2.put("exportname",tmpname);
			object2.put("exportvalue",tmpid);
			array.add(object2);
		}
	}
	writer.print(array.toString());
	return;
%>