
<%@ page language="java" contentType="application/json;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="net.sf.json.*"%>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.file.*" %>
<jsp:useBean id="hrs" class="weaver.mobile.plugin.ecology.service.HrmResourceService" scope="page" />
<jsp:useBean id="ps" class="weaver.mobile.plugin.ecology.service.PluginServiceImpl" scope="page" />
<jsp:useBean id="history" class="weaver.mobile.plugin.ecology.service.HistoryMsgService" scope="page" />
<%
	out.clearBuffer();

	User user = HrmUserVarify.getUser (request , response) ;
	if(user==null) {
		Map result = new HashMap();
		//未登录或登录超时
		result.put("error", "005");
		
		JSONObject jo = JSONObject.fromObject(result);
		out.println(jo);
		
		return;
	}

	FileUpload fu = new FileUpload(request); 
	String type = Util.null2String(fu.getParameter("type"));
	
	Map result = new HashMap();
	
	if("HrmResource".equalsIgnoreCase(type)) {
		result = hrs.getAllUser(user);
	} else if("HrmDepartment".equalsIgnoreCase(type)) {
		result = hrs.getAllDepartment(user);
	} else if("HrmSubCompany".equalsIgnoreCase(type)) {
		result = hrs.getAllSubCompany(user);
	} else if("HrmCompany".equalsIgnoreCase(type)) {
		result = hrs.getAllCompany(user);
	} else if("HrmGroup".equalsIgnoreCase(type)) {
		result = hrs.getUserGroups(user);
	} else if("HrmGroupMember".equalsIgnoreCase(type)) {
		result = hrs.getGroupMember(user);
	} else if("WorkPlanType".equalsIgnoreCase(type)) {
		result = hrs.getWorkPlanType(user);
	} else if("WorkFlowType".equalsIgnoreCase(type)) {
		result = hrs.getWorkFlowType(user);
	} else if("getBlackWorkFlow".equalsIgnoreCase(type)) {
		result = hrs.getBlackWorkFlow(user);
	} else if("setBlackWorkFlow".equalsIgnoreCase(type)) {
		String workflows = fu.getParameter("workflow");
		result = hrs.setBlackWorkFlow(user, workflows);
	} else if("getHideModule".equalsIgnoreCase(type)) {
		result = hrs.getHideModule(user);
	} else if("setHideModule".equalsIgnoreCase(type)) {
		String hidemodule = fu.getParameter("hidemodule");
		result = hrs.setHideModule(user, hidemodule);
	} else if("getHrmSubCompanyTree".equalsIgnoreCase(type)) {
		result = hrs.getHrmSubCompanyTree(user);
	} else if("setAvatar".equalsIgnoreCase(type)) {
		result = hrs.setUserAvatar(fu,user);
	} else if("getHistoryMsg".equalsIgnoreCase(type)){
		String pageNum = Util.null2String(fu.getParameter("pageNum"));
		String perPage = Util.null2String(fu.getParameter("perPage"));
		String userid = Util.null2String(fu.getParameter("userid"));
		String targetid = Util.null2String(fu.getParameter("targetid"));
		String result1 = history.getMsgJson(pageNum,perPage,userid,targetid);
		out.println(result1);
		result = null;
	} else {
		String[] tablenames = fu.getParameters("tablename");
		String[] timestamps = fu.getParameters("timestamp");
		result = hrs.getTableStatus(tablenames, timestamps);
	}
	
	if(result!=null) {
		JSONObject jro = JSONObject.fromObject(result);
		out.println(jro);
	}
%>
