
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="weaver.general.Util"%>
<%@ page import="weaver.hrm.HrmUserVarify"%>
<%@ page import="weaver.hrm.User"%>
<%@page import="weaver.mobile.webservices.common.BrowserAction"%>
<%


String method = Util.null2String(request.getParameter("method"));
int browserTypeId = Util.getIntValue(request.getParameter("browserTypeId"), 0);
String customBrowType = Util.null2String(request.getParameter("customBrowType"));

int pageNo = Util.getIntValue(request.getParameter("pageno"), 1);
int pageSize = Util.getIntValue(request.getParameter("pageSize"), 10);
String keyword = Util.null2String(request.getParameter("keyword"));
keyword = java.net.URLDecoder.decode(keyword, "UTF-8");
boolean isDis = "1".equals(Util.null2String(request.getParameter("isDis"))) ? true : false;
if (!isDis) {
	request.getRequestDispatcher("/mobile/plugin/email/dialog.jsp").forward(request, response);
	return;
}
User user = HrmUserVarify.getUser (request , response);
BrowserAction braction = new BrowserAction(user, browserTypeId, pageNo, pageSize);
braction.setKeyword(keyword);
braction.setMethod(method);
//分权用
braction.setCustomBrowType(customBrowType);
String result = braction.getBrowserData();
response.getOutputStream().write(result.getBytes("UTF-8"));
response.getOutputStream().flush();
%>
