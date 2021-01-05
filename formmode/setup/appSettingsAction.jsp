
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="net.sf.json.JSONArray"%>
<%@ page import="java.net.URLDecoder"%>
<%@ page import="net.sf.json.JSONObject"%>
<%@ page import="weaver.formmode.dao.BaseDao"%>
<%@ page import="weaver.conn.RecordSetTrans"%>
<%@ page import="java.net.URLEncoder"%>
<%@ page import="weaver.formmode.service.CommonConstant"%>
<%@ page import="weaver.conn.RecordSet"%>
<%@ page import="weaver.systeminfo.label.LabelComInfo"%>
<%@ page import="weaver.systeminfo.SystemEnv"%>
<%@ page import="weaver.formmode.service.AppInfoService"%>
<%@page import="weaver.docs.category.DocTreeDocFieldConstant"%>
<%@page import="weaver.formmode.setup.ModeTreeFieldComInfo"%>
<%@page import="weaver.formmode.service.LogService"%>
<%@page import="weaver.formmode.Module"%>
<%@page import="weaver.formmode.log.LogType"%>
<%@ include file="/formmode/pub_init.jsp"%>
<jsp:useBean id="RecordSetTrans" class="weaver.conn.RecordSetTrans" scope="page" />
<%
if (!HrmUserVarify.checkUserRight("FORMMODEAPP:ALL", user)) {
	response.sendRedirect("/notice/noright.jsp");
	return;
}
response.reset();
out.clear();
AppInfoService appInfoService = new AppInfoService();
String action = Util.null2String(request.getParameter("action"));
RecordSetTrans rsTrans = new RecordSetTrans();
RecordSet rs = new RecordSet();
LogService logService = new LogService();
int subCompanyId = Util.getIntValue(request.getParameter("subCompanyId"),-1);
rs.executeSql("select fmdetachable from SystemSet");
if(rs.next()){
	fmdetachable = rs.getString(1);
}
if(action.equalsIgnoreCase("editAppinfo")){
	int appId = Util.getIntValue(request.getParameter("appId"));
	String treeFieldName = Util.fromScreen(request.getParameter("treeFieldName"),user.getLanguage());
	String showOrder = Util.null2String(request.getParameter("showOrder"));
	String treeFieldDesc = Util.null2String(request.getParameter("treeFieldDesc"));
	
	String superFieldId = Util.null2String(request.getParameter("superFieldId"));
	String treelevel = Util.null2String(request.getParameter("treelevel"));
	
	Map<String,	Object> dataMap = new HashMap<String,	Object>();
	dataMap.put("id", appId);
	dataMap.put("treeFieldName", treeFieldName);
	dataMap.put("showOrder", showOrder);
	dataMap.put("treeFieldDesc", treeFieldDesc);
	
	dataMap.put("superFieldId", superFieldId);
	dataMap.put("treelevel", treelevel);
	dataMap.put("subCompanyId", subCompanyId);
	
	appInfoService.saveOrUpdateAppInfo(dataMap);
	
	logService.log(appId, Module.APP, LogType.EDIT);
	
	ModeTreeFieldComInfo modeTreeFieldComInfo = new ModeTreeFieldComInfo();
	modeTreeFieldComInfo.removeDocTreeDocFieldCache();
	
	String editFromRightMenu = Util.null2String(request.getParameter("editFromRightMenu"));
	if(editFromRightMenu.equals("1")){
		out.print("<script type=\"text/javascript\">top.closeTopDialog("+appId+");</script>");
	}else{
		out.print("<script type=\"text/javascript\">parent.parent.refreshApp("+appId+");</script>");
	}
}else if(action.equalsIgnoreCase("getAllAppInfoForTree")){
	if(fmdetachable.equals("1")){
		Map map = new HashMap();
		map.put("subCompanyId",subCompanyId);
		map.put("user",user);
		JSONArray appinfoArr = appInfoService.getAllAppInfoForTreeParam(map);
		response.setCharacterEncoding("UTF-8");
		out.print(appinfoArr.toString());
	}else{
		JSONArray appinfoArr = appInfoService.getAllAppInfoForTree();
		response.setCharacterEncoding("UTF-8");
		out.print(appinfoArr.toString());
	}
}else if(action.equalsIgnoreCase("getAllAppInfoForTreeSearch")){
	String searchText = Util.null2String(request.getParameter("searchtext"));
	Map map = new HashMap();
	map.put("searchText", searchText);
	if(fmdetachable.equals("1")){
		map.put("subCompanyId",subCompanyId);
		map.put("user",user);
		JSONArray appinfoArr = appInfoService.getAllAppInfoForTreeParam(map);
		response.setCharacterEncoding("UTF-8");
		out.print(appinfoArr.toString());
	}else{
		JSONArray appinfoArr = appInfoService.getAllAppInfoForTreeParam(map);
		response.setCharacterEncoding("UTF-8");
		out.print(appinfoArr.toString());
	}
}else if(action.equalsIgnoreCase("addAppinfo")){
	
	if(subCompanyId==-1||subCompanyId==0){//分权分部的取得。如果页面没有，则首先从分权设置的默认机构取得，如果默认机构没有设置则取所有分部中id最小的那个分部。
  		RecordSetTrans.executeSql("select fmdftsubcomid,dftsubcomid from SystemSet");
  		if(fmdetachable.equals("1")){
			RecordSetTrans.executeSql("select fmdftsubcomid,dftsubcomid from SystemSet");
	  		if(RecordSetTrans.next()){
	  			subCompanyId = Util.getIntValue(RecordSetTrans.getString("fmdftsubcomid"),-1);
	  			if(subCompanyId==-1||subCompanyId==0){
		  			subCompanyId = Util.getIntValue(RecordSetTrans.getString("dftsubcomid"),-1);
	  			}
	  		}	  	
	  		if(subCompanyId==-1||subCompanyId==0){
	  			RecordSetTrans.executeSql("select min(id) as id from HrmSubCompany");
	  			if(RecordSetTrans.next()) subCompanyId = RecordSetTrans.getInt("id");
	  		}
		}
  	}
	
	int appId = Util.getIntValue(request.getParameter("appId"));
	String treeFieldName = Util.fromScreen(request.getParameter("treeFieldName"),user.getLanguage());
	String showOrder = Util.null2String(request.getParameter("showOrder"));
	String treeFieldDesc = Util.null2String(request.getParameter("treeFieldDesc"));
	
	String superFieldId = Util.null2String(request.getParameter("superFieldId"));
	
	String allSuperFieldId;
	String treelevel;
	
	if(superFieldId.equals("") || superFieldId.equals(DocTreeDocFieldConstant.TREE_DOC_FIELD_ROOT_ID)){
		superFieldId = DocTreeDocFieldConstant.TREE_DOC_FIELD_ROOT_ID;
		allSuperFieldId = superFieldId;
		treelevel = "1";
	}else{
		Map<String, Object> superAppInfo = appInfoService.getAppInfoById(Util.getIntValue(superFieldId));
		//allSuperFieldId = Util.null2String(superAppInfo.get("superfieldid")) + "," + superFieldId;
		allSuperFieldId = appInfoService.getAllSuperFieldIdBySuperId(Util.getIntValue(superFieldId),superFieldId);
		treelevel = String.valueOf(Util.getIntValue(Util.null2String(superAppInfo.get("treelevel"))) + 1);
	}
	
	Map<String,	Object> dataMap = new HashMap<String,	Object>();
	dataMap.put("id", appId);
	dataMap.put("treeFieldName", treeFieldName);
	dataMap.put("showOrder", showOrder);
	dataMap.put("treeFieldDesc", treeFieldDesc);
	
	dataMap.put("superFieldId", superFieldId);
	dataMap.put("treelevel", treelevel);
	dataMap.put("allSuperFieldId", allSuperFieldId);
	dataMap.put("subCompanyId", subCompanyId);
	
	int createdAppid = appInfoService.saveOrUpdateAppInfo(dataMap);
	
	logService.log(createdAppid, Module.APP, LogType.ADD);
	
	ModeTreeFieldComInfo modeTreeFieldComInfo = new ModeTreeFieldComInfo();
	modeTreeFieldComInfo.removeDocTreeDocFieldCache();
	
	out.print("<script type=\"text/javascript\">top.closeTopDialog("+createdAppid+");</script>");
}else if(action.equalsIgnoreCase("deleteApp")){
	try{
		int appId = Util.getIntValue(request.getParameter("appId"));
		appInfoService.deleteAppInfo(appId);
		
		logService.log(appId, Module.APP, LogType.DELETE);
		
		ModeTreeFieldComInfo modeTreeFieldComInfo = new ModeTreeFieldComInfo();
		modeTreeFieldComInfo.removeDocTreeDocFieldCache();
		out.print("1");
	}catch(Exception ex){
		ex.printStackTrace();
		out.print(ex.getMessage());
	}
}else if("wasteApp".equalsIgnoreCase(action)){
	try{
		int appId = Util.getIntValue(request.getParameter("appId"));
		appInfoService.wasteAppInfo(appId);
		logService.log(appId, Module.APP, LogType.DELETE);
		ModeTreeFieldComInfo modeTreeFieldComInfo = new ModeTreeFieldComInfo();
		modeTreeFieldComInfo.removeDocTreeDocFieldCache();
		out.print("1");
	}catch(Exception ex){
		ex.printStackTrace();
		out.print(ex.getMessage());
	}
}
out.flush();
out.close();
%>