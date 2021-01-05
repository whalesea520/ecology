
<%@ page language="java" contentType="application/json" pageEncoding="UTF-8"%>
<%@ page import="java.net.*"%>
<%@ page import="net.sf.json.*"%>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.file.*" %>
<%@ page import="weaver.hrm.*" %>
<jsp:useBean id="wcs" class="weaver.mobile.plugin.ecology.service.WorkCenterService" scope="page" />
<%
response.setContentType("application/json;charset=UTF-8");

Map<String, Object> result = new HashMap<String, Object>();

User user = HrmUserVarify.getUser(request, response);
if(user==null) {
	//未登录或登录超时
	result.put("error", "005");
	JSONObject jo = JSONObject.fromObject(result);
	out.println(jo);
	return;
}

FileUpload fu = new FileUpload(request);

int pageindex = Util.getIntValue(fu.getParameter("pageindex"), 1);
int pagesize = Util.getIntValue(fu.getParameter("pagesize"), 10);

String keywordurl = Util.null2String(fu.getParameter("keyword"));
String keyword = URLDecoder.decode(keywordurl, "UTF-8");

String modules = Util.null2String(fu.getParameter("modules"));
modules = URLDecoder.decode(modules, "UTF-8");

String func = Util.null2String(fu.getParameter("func"));
int userid = Util.getIntValue(fu.getParameter("userid"));

if("getCount".equals(func)) {
	result = wcs.getWorkCenterCount(user, userid, modules);
} else {
	result = wcs.getWorkCenterList(user, modules, keyword, pageindex, pagesize);
}
JSONObject jo = JSONObject.fromObject(result);
out.println(jo);
%>