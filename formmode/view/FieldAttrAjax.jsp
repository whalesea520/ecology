<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="net.sf.json.JSONArray"%>
<%@ page import="net.sf.json.JSONObject"%>
<%@ page import="weaver.hrm.User"%>
<%@ page import="weaver.hrm.HrmUserVarify"%>
<%@ page import="weaver.formmode.manager.FieldAttrManager"%>
<%@ page import="weaver.file.FileUpload"%>
<%
FileUpload fu = new FileUpload(request);	//支持移动端POST请求，使用FileUpload
String f_weaver_belongto_userid = fu.getParameter("f_weaver_belongto_userid");
String f_weaver_belongto_usertype = fu.getParameter("f_weaver_belongto_usertype");
User user = HrmUserVarify.getUser(request, response);
if(user==null) {
    response.sendRedirect("/login/Login.jsp");
    return;
}

response.setContentType("text/plain;charset=UTF-8");
int layoutid = Util.getIntValue(fu.getParameter("layoutid"), 0);
int formid = Util.getIntValue(fu.getParameter("formid"), 0);
String billid = Util.null2String(fu.getParameter("billid"));
String wvals = Util.null2String(fu.getParameter("wvals"));

FieldAttrManager fieldAttrManager = new FieldAttrManager();
JSONArray datas = fieldAttrManager.parseFieldAttrRequest(user,layoutid, formid, billid, wvals);
JSONObject retjson = new JSONObject();
if(datas.size() > 0)
	retjson.put("datas", datas);
out.print(retjson.toString());

%>