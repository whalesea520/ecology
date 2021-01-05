
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="net.sf.json.JSONArray"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.formmode.servelt.SelectItemAction"%>
<%@page import="weaver.formmode.service.SelectItemPageService"%>
<%@page import="net.sf.json.JSONObject"%>

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
SelectItemPageService selectItemPageService = new SelectItemPageService();
if(operation.equals("saveorupdate")) {
	int rowno = Util.getIntValue(request.getParameter("rowno"),0);//行号
	String pid = Util.null2String(request.getParameter("pid"));
	String statelev = Util.null2String(request.getParameter("statelev"));
	String id = selectItemPageService.saveOrUpdate(request,user);
	response.getWriter().println("<script type=\"text/javascript\">parent.parent.refreshSelectItem("+id+","+pid+","+statelev+");</script>");
}else if(operation.equals("getSelectItemsWithJSON")){
	int appId = Util.getIntValue(request.getParameter("appid"));
	int subCompanyId = Util.getIntValue(request.getParameter("subCompanyId"));
	int fmdetachable = Util.getIntValue(request.getParameter("fmdetachable"), 0);
	JSONArray selectItemArr = new JSONArray();
	if(fmdetachable==1){
		selectItemArr = selectItemPageService.getSelectItemPageByModeIdWithJSONDetach(appId,user.getLanguage(),subCompanyId);
	}else{
		selectItemArr = selectItemPageService.getSelectItemPageByModeIdWithJSON(appId,user.getLanguage());
	}
	out.print(selectItemArr.toString());
	out.flush();
	out.close();
	return;
}else if(operation.equals("notcancel")){//解封
	int detailid = Util.getIntValue(request.getParameter("detailid"));
	ArrayList<String> arrayList = new ArrayList<String>();
	arrayList = selectItemPageService.getAllSubSelectItemId(arrayList, ""+detailid, -1);
	String allSubIds = "";//所有子项id
	for(int j=0;j<arrayList.size();j++){
		allSubIds += ","+arrayList.get(j);
	}
	String allids = detailid + allSubIds;
	String sql = "update mode_selectitempagedetail set cancel=0 where id in ("+allids+")";
	rs.executeSql(sql);
	JSONObject jsonObject = new JSONObject();
	jsonObject.put("detailid",detailid);
	response.getWriter().write(jsonObject.toString());
	return;
}
%>