<%@ page language="java" contentType="text/html; charset=UTF-8"%>

<%@ page import="weaver.general.Util"%>
<%@ page import="weaver.general.BaseBean"%>
<%@ page import="weaver.govern.service.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.alibaba.fastjson.JSON"%>
<%@ page import="com.alibaba.fastjson.serializer.SerializerFeature"%>
<%@ page import="weaver.hrm.HrmUserVarify"%>
<%@ page import="weaver.hrm.User"%>
<%@ page import="weaver.govern.util.ParmUtil"%>
<%
	String action = Util.null2String(request.getParameter("action"));
	User user = HrmUserVarify.getUser(request, response);
	GovernService gs = new GovernService();
	String returnStr = "";
	if ("checkUser".equals(action)) {
		Map<String,Object> apidatas = new HashMap<String,Object>();
		apidatas.put("noUser", user == null);
		returnStr = JSON.toJSONString(apidatas,SerializerFeature.DisableCircularReferenceDetect);
	} else if ("menuBase".equals(action)) {
		// returnStr = gs.getMenu(user);
		 returnStr = gs.getMenuWithPermission(user);
	} else if ("getAssignTasks".equals(action)) {
		returnStr = gs.getAssignTasks(user, ParmUtil.getParms(request));
	} else if ("getGovernorList".equals(action)) {
		returnStr = gs.getGovernorList(user, ParmUtil.getParms(request));
	} else if ("getCateGory".equals(action)) {
		returnStr = gs.getCateGory(user);
	} else if ("getTaskStatusGroup".equals(action)) {
		returnStr = gs.getTaskStatusGroup(user ,ParmUtil.getParms(request));
	} else if ("assignTaskStatus".equals(action)) {
		returnStr = gs.getAssignTaskStatus(user ,ParmUtil.getParms(request));
	} else if ("getMyTasks".equals(action)) {
		returnStr = gs.getMyTasks(user, ParmUtil.getParms(request));
	} else if ("getFields".equals(action)) {
		returnStr = new GovernSettingService().getFields(user, ParmUtil.getParms(request));
	} else if ("initSet".equals(action)) {
		returnStr = new GovernSettingService().initSet(user, ParmUtil.getParms(request));
	} else if("saveSetting".equals(action)){
		returnStr = new GovernSettingService().saveSetting(user, ParmUtil.getParms(request));
	} else if ("initBaseSet".equals(action)) {
		returnStr = new GovernSettingService().initBaseSet(user, ParmUtil.getParms(request));
	} else if("saveBaseSetting".equals(action)){
		returnStr = new GovernSettingService().saveBaseSetting(user, ParmUtil.getParms(request));
	} else if ("initSplitSet".equals(action)) {
		returnStr = new GovernSettingService().initSplitSet();
	} else if ("saveSplitSetting".equals(action)){
		returnStr = new GovernSettingService().saveSplitSetting(user, ParmUtil.getParms(request));
	} else if ("initPortal".equals(action)) {
		returnStr = gs.initPortal(user);
	} else if ("reportMyTask".equals(action)) {
		GovernFlowService gfs = new GovernFlowService();
		String settype  = Util.null2String(request.getParameter("settype"));
	    String billid = Util.null2String(request.getParameter("key"));
	    returnStr = gfs.triggerFlow(user,settype ,billid ,ParmUtil.getParms(request));
	} else if ("distributionAll".equals(action)) {//下发全部
		boolean flag = true;
		String pid = Util.null2String(request.getParameter("id"));
		try {
			gs.distributionAll(pid,user.getUID());
		} catch (Exception e) {
			flag = false;
		}
		Map<String, Object> apidatas = new HashMap<String, Object>();
		apidatas.put("status", flag);
		returnStr = JSON.toJSONString(apidatas,
				SerializerFeature.DisableCircularReferenceDetect);
	} else if ("distribution".equals(action)) {//下发
		boolean flag = true;
		String pid = Util.null2String(request.getParameter("id"));
		try {
			gs.distribution(pid,user.getUID());
		} catch (Exception e) {
			flag = false;
		}
		Map<String, Object> apidatas = new HashMap<String, Object>();
		apidatas.put("status", flag);
		returnStr = JSON.toJSONString(apidatas,
				SerializerFeature.DisableCircularReferenceDetect);
	} else if ("reminderProject".equals(action)) {//催办流程触发
		//returnStr = gs.reminderProject(request, response);
		GovernFlowService gfs = new GovernFlowService();
		String settype  = Util.null2String(request.getParameter("settype"));
	    String billid = Util.null2String(request.getParameter("key"));
	    returnStr = gfs.triggerFlow(user,settype ,billid ,ParmUtil.getParms(request));
	} else if ("governorPostpone".equals(action)) {//变更流程触发
		//returnStr = gs.governorPostpone(request, response);
		GovernFlowService gfs = new GovernFlowService();
		String settype  = Util.null2String(request.getParameter("settype"));
	    String billid = Util.null2String(request.getParameter("key"));
	    returnStr = gfs.triggerFlow(user,settype ,billid ,ParmUtil.getParms(request));
	} else if ("finishTask".equals(action)) {//任务完结
		String id = Util.null2String(request.getParameter("id"));
		String msg = gs.finishTask(id, user);
		Map<String, Object> apidatas = new HashMap<String, Object>();
		apidatas.put("msg", msg);
		returnStr = JSON.toJSONString(apidatas,
				SerializerFeature.DisableCircularReferenceDetect);
	}else if ("cancelTask".equals(action)) {//任务完结
		String id = Util.null2String(request.getParameter("id"));
		String msg = gs.cancelTask(id, user);
		Map<String, Object> apidatas = new HashMap<String, Object>();
		apidatas.put("msg", msg);
		returnStr = JSON.toJSONString(apidatas,
				SerializerFeature.DisableCircularReferenceDetect);
	} else if ("getSplitUrl".equals(action)) {//获取分解链接
		String pid = Util.null2String(request.getParameter("id"));
		returnStr = gs.getSplitUrl(pid);
	} else if("buttons".equals(action)){
		String dealtype = Util.null2String(request.getParameter("dealtype"));
		returnStr = new GovernSettingService().getButtonShow(dealtype);
	} else if("titles".equals(action)){
		String type = Util.null2String(request.getParameter("type"));
		returnStr = gs.getTableTitle(type);
	} 

	//System.out.println(returnStr);
	response.setContentType("application/x-www-form-urlencoded; charset=utf-8");
	response.getWriter().write(returnStr);
	response.getWriter().flush();
	response.getWriter().close();
%>