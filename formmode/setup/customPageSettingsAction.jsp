
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.formmode.service.CustomPageService"%>
<%@page import="net.sf.json.JSONArray"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.hrm.HrmUserVarify"%>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ReportComInfo" class="weaver.workflow.report.ReportComInfo" scope="page" />
<%
out.clear();
User user = HrmUserVarify.getUser (request , response) ;
if(!HrmUserVarify.checkUserRight("FORMMODEAPP:All", user)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}
String operation = Util.null2String(request.getParameter("operation"));

CustomPageService customPageService = new CustomPageService();
if(operation.equals("saveorupdate")) {
	String id = customPageService.saveOrUpdate(request,user);
	response.getWriter().println("<script type=\"text/javascript\">parent.parent.refreshCustomPage("+id+");</script>");
} else if(operation.equals("customdelete")) {
  	int id = Util.getIntValue(request.getParameter("id"));
  	customPageService.delete(id);
  	String appid = request.getParameter("appid");
	List<Map<String,Object>> dataList = customPageService.getCustomPageByModeIds(Util.getIntValue(appid));
	
	String firstId = "";
	if (dataList != null && dataList.size() > 0) 
		firstId = Util.null2String(((Map<String,Object>)dataList.get(0)).get("id"));
	response.getWriter().println("<script type=\"text/javascript\">parent.parent.refreshCustomPage("+firstId+");</script>");
}else if(operation.equals("getCustomPageByModeIdWithJSON")){
	int appId = Util.getIntValue(request.getParameter("appid"));
	int subCompanyId = Util.getIntValue(request.getParameter("subCompanyId"));
	int fmdetachable = Util.getIntValue(request.getParameter("fmdetachable"), 0);
	JSONArray pageCustomtreeArr = new JSONArray();
	if(fmdetachable==1){
		pageCustomtreeArr = customPageService.getCustomPageByModeIdWithJSONDetach(appId,user.getLanguage(),subCompanyId);
	}else{
		pageCustomtreeArr = customPageService.getCustomPageByModeIdWithJSON(appId,user.getLanguage());
	}
	out.print(pageCustomtreeArr.toString());
	out.flush();
	out.close();
	return;
}
%>