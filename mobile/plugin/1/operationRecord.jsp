
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.systeminfo.*"%>
<%@page import="org.apache.commons.logging.Log"%>
<%@page import="org.apache.commons.logging.LogFactory"%>
<%@ page import="weaver.mobile.webservices.workflow.soa.RequestStatusLog" %>
<%@page import="net.sf.json.JSONObject"%>
<%
Log log = LogFactory.getLog(page.getClass());
request.setCharacterEncoding("UTF-8");
response.setContentType("text/html;charset=UTF-8");
log.info("Follow is the QueryString:\t" + request.getQueryString());



//User user = HrmUserVarify.getUser(request , response) ;

String f_weaver_belongto_userid=Util.null2String(request.getParameter("f_weaver_belongto_userid"));//需要增加的代码
String f_weaver_belongto_usertype=Util.null2String(request.getParameter("f_weaver_belongto_usertype"));//需要增加的代码
User user  = HrmUserVarify.getUser(request, response, f_weaver_belongto_userid, f_weaver_belongto_usertype) ;//需要增加的代码

String error = Util.null2String(request.getParameter("error"));
if("error".equals(error)){
    Map errorresult = new HashMap();
    //抱歉,您没有流程内容查看权限...
    errorresult.put("error",SystemEnv.getHtmlLabelName(126351,user.getLanguage()));
    errorresult.put("errorno","126351");
    JSONObject errorjo = JSONObject.fromObject(errorresult);
    response.getWriter().write(errorjo.toString());
    return;
}
String workflowid = request.getParameter("workflowid");
String requestid = request.getParameter("requestid");
int desrequestid = Util.getIntValue(request.getParameter("desrequestid"), 0);
String isurger = Util.null2String(request.getParameter("isurger"));

int newversion = Util.getIntValue(request.getParameter("newversion"), 0);
if (newversion == 1) {
    RequestStatusLog reqstatusLog = new RequestStatusLog(workflowid, requestid);
	reqstatusLog.setUser(user);
	reqstatusLog.setDesrequestid(desrequestid);
	reqstatusLog.setIsurger(isurger);
	String str = reqstatusLog.getStatusLog4json();
	out.println(str);
} else {
	LinkedHashMap jsonskv = RequestStatusLog.getRequestStatusForMobile(workflowid, requestid, desrequestid, isurger, user);
	JSONObject jo = JSONObject.fromObject(jsonskv);
	out.println(jo);
}
%>