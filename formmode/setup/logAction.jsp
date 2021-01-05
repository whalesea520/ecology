
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="net.sf.json.JSONArray"%>
<%@ page import="net.sf.json.JSONObject"%>
<%@ page import="weaver.formmode.service.LogService"%>
<%@ include file="/formmode/pub_init.jsp"%>
<%
response.reset();
out.clear();
LogService logService = new LogService();
String action = Util.null2String(request.getParameter("action"));
if(action.equalsIgnoreCase("getLogs")){
	String objid = Util.null2String(request.getParameter("objid"));
	String logmodule = Util.null2String(request.getParameter("logmodule"));
	String startdate = Util.null2String(request.getParameter("startdate"));
	String enddate = Util.null2String(request.getParameter("enddate"));
	
	Map<String,	Object> paramMap = new HashMap<String,	Object>();
	paramMap.put("objid", objid);
	paramMap.put("logmodule", logmodule);
	paramMap.put("startdate", startdate);
	paramMap.put("enddate", enddate);
	
	List<Map<String, Object>> logList = logService.getLogs(paramMap);
	
	JSONArray resultArr = JSONArray.fromObject(logList);
	response.setCharacterEncoding("UTF-8");
	out.print(resultArr.toString());
}
out.flush();
out.close();
%>