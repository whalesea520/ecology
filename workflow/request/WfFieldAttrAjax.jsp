<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="net.sf.json.JSONArray"%>
<%@ page import="net.sf.json.JSONObject"%>
<%@ page import="weaver.hrm.User"%>
<%@ page import="weaver.hrm.HrmUserVarify"%>
<%@ page import="weaver.workflow.html.FieldAttrManager"%>
<%@ page import="weaver.file.FileUpload"%>
<%
FileUpload fu = new FileUpload(request);	//支持移动端POST请求，使用FileUpload
String f_weaver_belongto_userid = fu.getParameter("f_weaver_belongto_userid");
String f_weaver_belongto_usertype = fu.getParameter("f_weaver_belongto_usertype");
User user = HrmUserVarify.getUser(request, response, f_weaver_belongto_userid, f_weaver_belongto_usertype);
if(user==null) {
    response.sendRedirect("/login/Login.jsp");
    return;
}

response.setContentType("text/plain;charset=UTF-8");
int nodeid = Util.getIntValue(fu.getParameter("nodeid"), 0);
int formid = Util.getIntValue(fu.getParameter("formid"), 0);
int isbill = Util.getIntValue(fu.getParameter("isbill"), 0);
int requestid = Util.getIntValue(fu.getParameter("requestid"));
String wvals = Util.null2String(fu.getParameter("wvals"));

FieldAttrManager fieldAttrManager = new FieldAttrManager();
JSONArray datas = fieldAttrManager.parseFieldAttrRequest(user, nodeid, formid, isbill, requestid, wvals);
JSONObject retjson = new JSONObject();
if(datas.size() > 0)
	retjson.put("datas", datas);
out.print(retjson.toString());

%>