<%@ page language="java" contentType="application/json" pageEncoding="UTF-8"%>
<%@page import="net.sf.json.*"%>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.file.*" %>
<%@ page import="weaver.hrm.*" %>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%@page import="weaver.fullsearch.util.RmiConfig"%>
<jsp:useBean id="fs" class="weaver.mobile.plugin.ecology.service.FullSearchService" scope="page" />
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

int userLanguage = user.getLanguage();
userLanguage = (userLanguage == 0) ? 7:userLanguage;

response.setContentType("application/json;charset=UTF-8");
FileUpload fu = new FileUpload(request);

Map result = new HashMap();

String sessionkey = Util.null2String(fu.getParameter("sessionkey"));
List schemas=fs.getAllSchemas(sessionkey);
if(RmiConfig.isSearchFile()&&schemas.size()>0){//有微搜配置文件,且有启用模块
	schemas.add(0,"DOC:"+SystemEnv.getHtmlLabelName(58, userLanguage));
}
result.put("list",schemas);

JSONObject jo = JSONObject.fromObject(result);
out.println(jo);
%>