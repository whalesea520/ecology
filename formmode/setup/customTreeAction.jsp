
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="net.sf.json.JSONArray"%>
<%@ page import="java.net.URLDecoder"%>
<%@ page import="net.sf.json.JSONObject"%>
<%@page import="weaver.formmode.service.LogService"%>
<%@page import="weaver.formmode.Module"%>
<%@page import="weaver.formmode.log.LogType"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.*" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.file.FileUpload" %>
<%@page import="weaver.formmode.service.CustomtreeService"%>
<%@ include file="/formmode/pub_init.jsp"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="InterfaceTransmethod" class="weaver.formmode.interfaces.InterfaceTransmethod" scope="page" />

<%
response.reset();
out.clear();
if(!HrmUserVarify.checkUserRight("FORMMODEAPP:All", user)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}
String operation = Util.null2String(request.getParameter("operation"));
CustomtreeService customtreeService = new CustomtreeService();
String modeid = Util.null2String(request.getParameter("modeid"));
if(operation.equals("getCustomtreeByModeIdWithJSON")){
	int subCompanyId = Util.getIntValue(request.getParameter("subCompanyId"), 0);
	int appId = Util.getIntValue(request.getParameter("modeid"), 0);
	JSONArray customtreeArr =  new JSONArray();
	if(fmdetachable.equals("1")){
		customtreeArr = customtreeService.getCustomtreeByModeIdWithJSONDetach(appId,user.getLanguage(),subCompanyId);
	}else{
		customtreeArr = customtreeService.getCustomtreeByModeIdWithJSON(appId,user.getLanguage());
	}
	response.setCharacterEncoding("UTF-8");
	out.println(customtreeArr.toString());
	out.flush();
	out.close();
	return;
}else if(operation.equals("copytree")){//复制树
	int treeid = Util.getIntValue(request.getParameter("id"), 0); 
	int newid = customtreeService.copyTree(treeid,user.getUID());
	JSONObject jsonObject = new JSONObject();
	jsonObject.put("id",newid);
	out.println(jsonObject.toString());
	out.flush();
	out.close();
	return;
}
FileUpload fu = new FileUpload(request);
operation = Util.null2String(fu.getParameter("operation"));
String sql = "";

String appid = Util.null2String(fu.getParameter("appid"));
String treename = InterfaceTransmethod.toHtmlForMode(fu.getParameter("treename"));
String treedesc = InterfaceTransmethod.toHtmlForMode(fu.getParameter("treedesc"));
String rootname = InterfaceTransmethod.toHtmlForMode(fu.getParameter("rootname"));
String rooticon = Util.null2String(fu.uploadFiles("rooticon"));
String oldrooticon = Util.null2String(fu.getParameter("oldrooticon"));
String defaultaddress = InterfaceTransmethod.toHtmlForMode(fu.getParameter("defaultaddress"));
String expandfirstnode = InterfaceTransmethod.toHtmlForMode(fu.getParameter("expandfirstnode"));
int id = Util.getIntValue(Util.null2String(fu.getParameter("id")),0);
String currentdate = TimeUtil.getCurrentDateString();
String currenttime = TimeUtil.getOnlyCurrentTimeString();
String treeremark = InterfaceTransmethod.toHtmlForMode(fu.getParameter("treeremark"));

int showtype = Util.getIntValue(Util.null2String(fu.getParameter("showtype")),0);
int isselsub = Util.getIntValue(Util.null2String(fu.getParameter("isselsub")),0);
int isonlyleaf = Util.getIntValue(Util.null2String(fu.getParameter("isonlyleaf")),0);
int isRefreshTree = Util.getIntValue(Util.null2String(fu.getParameter("isRefreshTree")),0);
int isQuickSearch = Util.getIntValue(Util.null2String(fu.getParameter("isQuickSearch")),0);
int isshowsearchtab = Util.getIntValue(Util.null2String(fu.getParameter("isshowsearchtab")),0);
int searchbrowserid = Util.getIntValue(Util.null2String(fu.getParameter("searchbrowserid")),0);
if(rooticon.equals("")){
	rooticon = oldrooticon;
}
int creater = user.getUID();
LogService logService = new LogService();
if (operation.equals("save")) {
	if(showtype == 1){
		treeremark = "";
	}
	sql = "insert into mode_customtree(treeremark,treename,treedesc,creater,createdate,createtime,rootname,showtype,isselsub,isonlyleaf,rooticon,defaultaddress,expandfirstnode,appid,isRefreshTree,isshowsearchtab,searchbrowserid,isQuickSearch)"+
	" values ('"+treeremark+"','"+treename+"','"+treedesc+"','"+creater+"','"+currentdate+"','"+currenttime+"','"+rootname+"',"+showtype+","+isselsub+","+
	isonlyleaf+",'"+rooticon+"','"+defaultaddress+"','"+expandfirstnode+"','"+appid+"',"+isRefreshTree+","+isshowsearchtab+","+searchbrowserid+","+isQuickSearch+")";
	rs.executeSql(sql);
	
	sql = "select max(id) id from mode_customtree where creater = " + creater + " and treename = '"+treename+"'";
	rs.executeSql(sql);
	while(rs.next()){
		id = rs.getInt("id");
	}
	logService.log(id, Module.TREE, LogType.ADD);
	//response.sendRedirect("/formmode/setup/customTreeBase.jsp?id="+id+"&refreshType=save");
	response.getWriter().println("<script type=\"text/javascript\">parent.parent.refreshCustomtree("+id+");</script>");
}else if (operation.equals("edit")) {
	if(showtype == 1){
		treeremark = "";
	}
	sql = "update mode_customtree set";
	sql += " treename = '"+treename+"',";
	sql += " treedesc = '"+treedesc+"',";
	sql += " treeremark = '"+treeremark+"',";
	sql += " rootname = '"+rootname+"',";
	sql += " showtype = "+showtype+",";
	sql += " isselsub = "+isselsub+",";
	sql += " isonlyleaf = "+isonlyleaf+",";
	sql += " defaultaddress = '"+defaultaddress+"',";
	sql += " expandfirstnode = '"+expandfirstnode+"',";
	sql += " rooticon = '"+rooticon+"',";
	sql += " isshowsearchtab = '"+isshowsearchtab+"',";
	sql += " searchbrowserid = '"+searchbrowserid+"',";
	sql += " isRefreshTree = "+isRefreshTree+",";
	sql += " isQuickSearch = "+isQuickSearch;
	sql += " where id = " + id;

	rs.executeSql(sql);
	logService.log(id, Module.TREE, LogType.EDIT);
	//如果基础树的url为空，则需要关闭树形搜索栏的开关
    if(defaultaddress == null || defaultaddress.equals("")){
    	rs.executeSql("select * from mode_toolbar_search where mainid="+id);
   	    if(rs.next()){
   	    	rs.executeSql("update mode_toolbar_search set ISUSEDSEARCH = 0 where mainid="+id);
   	    }	
    }
	//response.sendRedirect("/formmode/setup/customTreeBase.jsp?id="+id+"&refreshType=edit");
	response.getWriter().println("<script type=\"text/javascript\">parent.parent.refreshCustomtree("+id+");</script>");
}else if (operation.equals("del")) {
	rs.executeSql("delete from mode_customtreedetail where mainid = "+id);
	sql = "delete from mode_customtree ";
	sql += " where id = " + id;
	rs.executeSql(sql);
	logService.log(id, Module.TREE, LogType.DELETE);
	
    //如果删除树，则该模块的搜索栏也要删除
	rs.executeSql("select * from mode_toolbar_search where mainid="+id);
    if(rs.next()){
    	rs.executeSql("delete from mode_toolbar_search where mainid="+id);
    }	
    
	//response.sendRedirect("/formmode/setup/customTreeBase.jsp?refreshType=del");
	List<Map<String,Object>> dataList = customtreeService.getCustomtreeByModeIds(Util.getIntValue(appid));
	
	String firstId = "";
	if (dataList != null && dataList.size() > 0) 
		firstId = Util.null2String(((Map<String,Object>)dataList.get(0)).get("id"));
	response.getWriter().println("<script type=\"text/javascript\">parent.parent.refreshCustomtree("+firstId+");</script>");
%>
	<!-- 
	<script language="javascript">
		var newwin = window.open("","_parent","").close();
	</script>
	-->
<%	
}

%>