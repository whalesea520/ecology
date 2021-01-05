
<%@ page language="java" contentType="application/json" pageEncoding="UTF-8"%>
<%@page import="java.net.*"%>
<%@page import="net.sf.json.*"%>
<%@ page import="java.util.*" %>
<%@ page import="org.apache.commons.lang.*" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.file.*" %>
<%@ page import="weaver.mobile.plugin.ecology.service.EMessageService" %>

<%
out.clearBuffer();
User user = HrmUserVarify.getUser (request , response) ;
if(user==null) {
	Map result = new HashMap();
	//未登录或登录超时
	result.put("error", "200001");
	
	JSONObject jo = JSONObject.fromObject(result);
	out.println(jo);
	
	return;
}

response.setContentType("application/json;charset=UTF-8");

FileUpload fu = new FileUpload(request);

String module = Util.null2String(fu.getParameter("module"));
String scope = Util.null2String(fu.getParameter("scope"));
String detailid = Util.null2String(fu.getParameter("detailid"));
String pageindex = Util.null2String(fu.getParameter("pageindex"));
String pagesize = Util.null2String(fu.getParameter("pagesize"));

String keywordurl = Util.null2String(fu.getParameter("keyword"));
String keyword = URLDecoder.decode(keywordurl, "UTF-8");

String sessionkey = Util.null2String(fu.getParameter("sessionkey"));
String setting = Util.null2String(fu.getParameter("setting"));
String mconfig = Util.null2String(fu.getParameter("config"));

int hrmorder = Util.getIntValue(fu.getParameter("_hrmorder_"), 0);

//因客户端使用GBK编码，故需要转码。
//keyword = new String(keyword.getBytes("iso8859-1"), "GBK");

List conditions = new ArrayList();
	
Map result = new HashMap();

if(module.equals("12")) {
	if(StringUtils.isNotEmpty(keyword)) {
		conditions.add(" (loginid like '%"+keyword+"%' or lastname like '%"+keyword+"%' or pinyinlastname like '%"+keyword+"%' or workcode like '%"+keyword+"%') ");
	}
	
	if(StringUtils.isNotEmpty(detailid)) {
		conditions.add(" (id = "+detailid+") ");
	}

	result = EMessageService.getInstance().getMessageUsers(conditions, Util.getIntValue(pageindex), Util.getIntValue(pagesize), hrmorder, user);
}

JSONObject jo = JSONObject.fromObject(result);
out.println(jo);

%>