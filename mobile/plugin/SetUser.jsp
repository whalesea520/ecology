
<%@ page language="java" contentType="application/json" pageEncoding="UTF-8"%>
<%@page import="net.sf.json.*"%>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.file.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.systeminfo.setting.HrmUserSettingComInfo" %>
<jsp:useBean id="ps" class="weaver.mobile.plugin.ecology.service.PluginServiceImpl" scope="page" />
<%
response.setContentType("application/json;charset=UTF-8");

int belongtoshow  = Integer.parseInt(Util.null2String(request.getParameter("belongtoshow")));
String sessionkey = Util.null2String(request.getParameter("sessionkey"));
Map result = new HashMap();
if(ps.verify(sessionkey)) {
	User user = HrmUserVarify.getUser (request , response);
	HrmUserSettingComInfo husc =  new HrmUserSettingComInfo();
	husc.setHrmbelongtoshow(user,belongtoshow);
	result.put("success","true");
}
if(result!=null) {
	JSONObject jo = JSONObject.fromObject(result);

	out.println(jo);
}
%>