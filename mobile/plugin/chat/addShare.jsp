<%@ page language="java" pageEncoding="utf-8"%>
<%@ page import="weaver.file.*" %>
<%@ page import="weaver.general.*" %>
<%@page import="weaver.mobile.webservices.common.ChatResourceShareManager"%>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.social.rdeploy.im.IMService" %>
<jsp:useBean id="SocialIMService" class="weaver.social.service.SocialIMService" scope="page" />
<%
FileUpload fu = new FileUpload(request);
User user = HrmUserVarify.getUser (request , response) ;
if(user == null)  return ;

int resourcetype = Util.getIntValue(Util.null2String(fu.getParameter("resourcetype")));
int resourceid = Util.getIntValue(Util.null2String(fu.getParameter("resourceid")));
int sharer = user.getUID();
//int sharertype = Util.getIntValue(Util.null2String(fu.getParameter("sharertype")));
String sharegroupid = Util.null2String(fu.getParameter("sharegroupid"));
String resources = Util.null2String(fu.getParameter("resourceids"));
boolean result = false,result_0 = false;
try {
	result = ChatResourceShareManager.addShare(resourcetype, resourceid, sharer, sharegroupid, resources);
	result_0 = IMService.saveChatResource(sharer, sharegroupid, resourceid, resourcetype, resources); 
} catch (Exception e) {
}
if (result) {
	response.getWriter().write("{\"msg\":\"0\"}");
} else {
    response.getWriter().write("{\"msg\":\"1\"}");
}

%>

