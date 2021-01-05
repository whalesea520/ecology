
<%@ page language="java" contentType="application/json" pageEncoding="UTF-8"%>
<%@page import="java.net.*"%>
<%@page import="net.sf.json.*"%>
<%@ page import="java.util.*" %>
<%@ page import="org.apache.commons.lang.*" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.file.*" %>
<%@page import="com.weaver.ecology.search.model.MobileResultItem"%>
<jsp:useBean id="ps" class="weaver.mobile.plugin.ecology.service.PluginServiceImpl" scope="page" />
<jsp:useBean id="ps1" class="weaver.mobile.plugin.ecology.service.FullSearchService" scope="page" />
<jsp:useBean id="log" class="weaver.general.BaseBean" scope="page" /> 
<%
out.clearBuffer();

response.setContentType("application/json;charset=UTF-8");
FileUpload fu = new FileUpload(request);
String contentType=Util.null2String(fu.getParameter("contentType"));
String pageindex = Util.null2String(fu.getParameter("pageindex"));
String pagesize = Util.null2String(fu.getParameter("pagesize"));
String keywordurl = Util.null2String(fu.getParameter("keyword"));
String keyword = URLDecoder.decode(keywordurl, "UTF-8");
String sessionkey = Util.null2String(fu.getParameter("sessionkey"));
String titleurl = Util.null2String(fu.getParameter("title"));
String title = URLDecoder.decode(titleurl, "UTF-8");
String noauth=Util.null2String(fu.getParameter("noauth"));
String voice=Util.null2String(fu.getParameter("voice"));
String lastkey=Util.null2String(fu.getParameter("lastkey"));
String otherJson=Util.null2String(fu.getParameter("otherJson"));
boolean hideHead="true".equals(Util.null2String(fu.getParameter("hideHead")));
//因客户端使用GBK编码，故需要转码。
//keyword = new String(keyword.getBytes("iso8859-1"), "UTF-8");
if(ps.verify(sessionkey)) {
	Map result = new HashMap();	 
	if(StringUtils.isNotEmpty(keyword) || StringUtils.isNotEmpty(otherJson)) {
		result = ps1.getFullSearchList(title,contentType,keyword, Util.getIntValue(pageindex), Util.getIntValue(pagesize), sessionkey,noauth,voice,lastkey,hideHead,otherJson);
	}else{
		result.put("pagesize", "10");
		result.put("result", "");
		result.put("ishavepre", "0");
		result.put("ishavenext", "0");
		result.put("list", new ArrayList());
		result.put("count", "0");
		result.put("pagecount", "1");
		result.put("pageindex", "1");
	}	
	JSONObject jo = JSONObject.fromObject(result);
	//log.writeLog(jo.toString());
	out.println(jo);
}
%>