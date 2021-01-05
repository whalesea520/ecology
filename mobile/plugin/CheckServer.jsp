
<%@ page language="java" contentType="application/json" pageEncoding="UTF-8"%>
<%@page import="net.sf.json.*"%>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.file.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.mobile.rong.*" %>
<jsp:useBean id="ps" class="weaver.mobile.plugin.ecology.service.PluginServiceImpl" scope="page" />
<%
	response.setContentType("application/json;charset=UTF-8");

	FileUpload fu = new FileUpload(request); 
	String type = Util.null2String(fu.getParameter("type"));
	
	Map result = new HashMap();
	
	if("checkPluginFile".equalsIgnoreCase(type)) {
		String fileHash = fu.getParameter("fileHash");
		result = ps.checkPluginFile(fileHash);
	} else if("mobileSetting".equalsIgnoreCase(type)) {
		String settings = fu.getParameter("settings");
		String timestamp = fu.getParameter("timestamp");
		result = ps.syncMobileSetting(settings, timestamp);
	} else if("serverSetting".equalsIgnoreCase(type)){
		RongConfig rc = RongService.getRongConfig();
	    result.put("rongAppUDID", rc.getAppUDID());
	    result.put("rongAppKey", rc.getAppKey());
	    result.put("rongAppSecret", rc.getAppSecret());
	    result.put("rongAppUDIDNew", rc.getAppUDIDNew());
	    result.put("openfireModule", rc.getOpenfire());
	    result.put("openfireServerSecrect", rc.getServerSecrect());
	    result.put("openfireDomain", rc.getOpenfireDomain());
	    result.put("openfireEMobileUrl", rc.getOpenfireEMobileUrl());
	    result.put("openfireMobileClientUrl", rc.getOpenfireMobileClientUrl());
	}else{
		result = ps.checkServerStatus();
	}
	
	if(result!=null) {
		JSONObject jo = JSONObject.fromObject(result);
		//System.out.println(jo);
		out.println(jo.toString());
	}
%>
