
<%@ page language="java" contentType="application/json" pageEncoding="UTF-8"%>
<%@page import="net.sf.json.*"%>
<%@ page import="java.util.*" %>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<%@ page import="weaver.general.*" %>
<jsp:useBean id="ps" class="weaver.mobile.plugin.ecology.service.PluginServiceImpl" scope="page" />
<jsp:useBean id="mrs" class="weaver.email.service.MailResourceService" scope="page" />
<%
response.setContentType("application/json;charset=UTF-8");

String module = Util.null2String(request.getParameter("module"));
String scope = Util.null2String(request.getParameter("scope"));
String sessionkey = Util.null2String(request.getParameter("sessionkey"));
		
if(ps.verify(sessionkey)) {
//http://localhost:8082/email/new/MailInboxList.jsp?isInternal=-1&receivemailid=&star=&labelid=&folderid=0&receivemail=&status=&clickObj=&checkuser=true
	mrs.resetParameter();
	//总邮件数
	mrs.setResourceid(user.getUID()+"");
	mrs.setFolderid("0");
	mrs.selectMailResourceOnlyCount();
	String MailCount = Util.getIntValue(mrs.getRecordCount()+"",0)+"";
	mrs.setStatus("0");
	mrs.selectMailResourceOnlyCount();
	String unreadMailCount = Util.getIntValue(mrs.getRecordCount()+"",0)+"";	
	Map result = new HashMap();
	result.put("count", MailCount);
	result.put("unread", unreadMailCount);
	JSONObject jo = JSONObject.fromObject(result);
	out.println(jo);
}
%>