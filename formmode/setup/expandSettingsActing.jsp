
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.net.URLDecoder"%>
<%@page import="weaver.formmode.service.ExpandInfoService"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="weaver.general.Util"%>
<%@page import="java.util.*"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="weaver.formmode.interfaces.dmlaction.commands.bases.DMLActionBase"%>
<%@page import="weaver.formmode.interfaces.action.WSActionManager"%>
<%@page import="weaver.formmode.interfaces.action.SapActionManager"%>
<%@page import="weaver.formmode.setup.ExpandBaseRightInfo"%>
<jsp:useBean id="expandBaseRightInfo" class="weaver.formmode.setup.ExpandBaseRightInfo" scope="page" />
<%
ExpandInfoService expandInfoService = new ExpandInfoService();

String id = Util.null2String(request.getParameter("id"));
String operation = Util.null2String(request.getParameter("operation"));
String sql = "";
Map<String,	Object> dataMap = new HashMap<String,Object>();
dataMap.put("modeid", Util.getIntValue(request.getParameter("modeid"),0));
dataMap.put("expendname", Util.null2String(request.getParameter("expendname")));
dataMap.put("showtype", Util.null2String(request.getParameter("showtype")));
dataMap.put("opentype", Util.getIntValue(request.getParameter("opentype"),1));
dataMap.put("hreftype", Util.getIntValue(request.getParameter("hreftype"),1));
dataMap.put("hrefid", Util.getIntValue(request.getParameter("hrefid"),0));
dataMap.put("fromhref", Util.getIntValue(request.getParameter("fromhref"),0));
dataMap.put("hreftarget", Util.null2String(request.getParameter("hreftarget")));
dataMap.put("isshow", Util.getIntValue(request.getParameter("isshow"),0));
dataMap.put("issystem", Util.getIntValue(request.getParameter("issystem"),0));
dataMap.put("createpage", Util.getIntValue(request.getParameter("createpage"),0));
dataMap.put("managepage", Util.getIntValue(request.getParameter("managepage"),0));
dataMap.put("viewpage", Util.getIntValue(request.getParameter("viewpage"),0));
dataMap.put("moniterpage", Util.getIntValue(request.getParameter("moniterpage"),0));
dataMap.put("isbatch", Util.getIntValue(request.getParameter("isbatch"),0));
dataMap.put("showorder", Util.getDoubleValue(request.getParameter("showorder"),0));
dataMap.put("id", id);
dataMap.put("istriggerwf", Util.getIntValue(request.getParameter("istriggerwf"),0));
dataMap.put("interfaceaction", Util.null2String(request.getParameter("interfaceaction")));
dataMap.put("showcondition2", Util.fromScreen(request.getParameter("showcondition2"),7));
dataMap.put("expenddesc", Util.null2String(request.getParameter("expenddesc")));
dataMap.put("javafilename", Util.null2String(request.getParameter("javafilename")));
dataMap.put("tabshowtype", Util.null2String(request.getParameter("tabshowtype")));
dataMap.put("isquickbutton", Util.getIntValue(request.getParameter("isquickbutton"),0));
dataMap.put("javafileAddress", Util.null2String(request.getParameter("javafileAddress")));
int modeid = Util.getIntValue(request.getParameter("modeid"),0);
if (operation.equals("add")) {
	id = expandInfoService.saveOrUpdateExpandInfo(dataMap);
	dataMap.put("id", id);
	expandInfoService.saveInterface(dataMap);
	//默认添加所有人可以查看：
	expandBaseRightInfo.init();
	expandBaseRightInfo.setModeid(Util.getIntValue(request.getParameter("modeid"),0));
	expandBaseRightInfo.setExpandid(Util.getIntValue(id,0));
	expandBaseRightInfo.setRighttype(5);
	expandBaseRightInfo.setRelatedids("0");
	
	expandBaseRightInfo.setShowlevel(0);
	expandBaseRightInfo.insertAddRight();
	response.sendRedirect("/formmode/setup/expandBase.jsp?id="+id);//新建完成后需重新刷新左侧以及顶部
	
}else if (operation.equals("edit")) {
	id = expandInfoService.saveOrUpdateExpandInfo(dataMap);
	expandInfoService.saveInterface(dataMap);
	response.sendRedirect("/formmode/setup/expandBase.jsp?id="+id);
}else if (operation.equals("del")) {
	expandInfoService.delExpandInfoAndInterface(dataMap);
	response.sendRedirect("/formmode/setup/expandList.jsp?modeid="+modeid);
}else if (operation.equals("getexpandlist")) {
	int language = Util.getIntValue(request.getParameter("language"));
	JSONArray jsonArray = new JSONArray();
	jsonArray = expandInfoService.getExpandInfoByModeIdWithJSON(modeid,language);
	response.getWriter().write(jsonArray.toString());
	return;
}else if (operation.equals("getexpand")) {
	int expandid = Util.getIntValue(request.getParameter("id"),0);
	Map<String, Object> data = expandInfoService.getExpandInfoById(expandid);
	JSONObject jsonObject = new JSONObject();
	String expendname = Util.null2String(data.get("expendname"));
	jsonObject.put("expendname",expendname);
	response.getWriter().write(jsonObject.toString());
	return;
}else if (operation.equals("saveinterface")) {//保存接口信息
	expandInfoService.saveInterface(dataMap);
	response.sendRedirect("/formmode/setup/expandBaseInterface.jsp?id="+id);//编辑完成后无需刷新
}else if (operation.equals("deletedmlaction")) {//删除接口详细
	String[] checkdmlids = request.getParameterValues("dmlid");
	if(null!=checkdmlids)
	{
		for(int i = 0;i<checkdmlids.length;i++)
		{
			int dmlid = Util.getIntValue(checkdmlids[i],0);
			if(dmlid>0)
			{
				int actiontype_t = Util.getIntValue(request.getParameter("actiontype"+dmlid), -1);
				if(actiontype_t == 0){
					DMLActionBase dmlActionBase = new DMLActionBase();
					dmlActionBase.deleteDmlActionFieldMapByActionid(dmlid);
					dmlActionBase.deleteDmlActionSqlSetByActionid(dmlid);
					dmlActionBase.deleteDmlActionSetByid(dmlid);
				}else if(actiontype_t == 1){
					WSActionManager wsActionManager = new WSActionManager();
					wsActionManager.setActionid(dmlid);
					wsActionManager.doDeleteWsAction();
				}else if(actiontype_t == 2){
					SapActionManager sapActionManager = new SapActionManager();
					sapActionManager.setActionid(dmlid);
					sapActionManager.doDeleteSapAction();
				}
			}
		}
	}
	response.sendRedirect("/formmode/setup/expandBase.jsp?id="+id);//编辑完成后无需刷新
}else if (operation.equals("deleteExpandBaseRight")) {//删除建模权限详细
	String[] expandBaseRightIds = request.getParameterValues("expandBaseRightIds");
	ExpandBaseRightInfo expandBaseRightInfo_ = new ExpandBaseRightInfo();
	if(null!=expandBaseRightIds)
	{
		for(int i = 0;i<expandBaseRightIds.length;i++)
		{
			int expandBaseRightId = Util.getIntValue(expandBaseRightIds[i],0);
			if(expandBaseRightId>0)
			{
				expandBaseRightInfo_.doDeleteExpandRightAction(expandBaseRightId);
			}
		}
	}
	response.sendRedirect("/formmode/setup/expandBase.jsp?id="+id);//编辑完成后无需刷新
}

%>