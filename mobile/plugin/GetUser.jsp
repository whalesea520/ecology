
<%@ page language="java" contentType="application/json" pageEncoding="UTF-8"%>
<%@page import="net.sf.json.*"%>
<%@ page import="java.util.*" %>
<%@ page import="org.apache.commons.lang.*" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.file.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.mobile.plugin.ecology.service.*" %>
<jsp:useBean id="ps" class="weaver.mobile.plugin.ecology.service.PluginServiceImpl" scope="page" />
<%
response.setContentType("application/json;charset=UTF-8");

String id = Util.null2String(request.getParameter("id"));
String userid = Util.null2String(request.getParameter("userid"));
String sessionkey = Util.null2String(request.getParameter("sessionkey"));
if(ps.verify(sessionkey)) {
	User user = HrmUserVarify.getUser (request , response) ;
	Map result = new HashMap();
	if(userid!=null&&!userid.equals("")&&StringUtils.isNumeric(userid)){
		HrmResourceService hrs = new HrmResourceService();
		result = hrs.getUserByUserid(Integer.parseInt(userid),user);
	}else{
		if(id.equals("")) {
			result = ps.getCurrUser(sessionkey);
		} else {
			result = ps.getUser(id, sessionkey);
		}
		}
	if(result!=null) {
		JSONObject jo = JSONObject.fromObject(result);
		out.println(jo);
	}
}
%>