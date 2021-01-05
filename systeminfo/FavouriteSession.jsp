<%@ page language="java" contentType="text/json; charset=utf-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.hrm.User" %>
<%@ page import="weaver.hrm.HrmUserVarify" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Map" %>
<%@ page import="net.sf.json.JSONObject" %>
<%
    String pagename = Util.null2String(request.getParameter("pagename"));
    User user = HrmUserVarify.getUser(request, response);
    int userid = user.getUID();
    String sessionKey = String.valueOf(System.currentTimeMillis());
    if (userid > 0) {
        sessionKey = String.valueOf(userid) + sessionKey;
    }
    session.setAttribute(sessionKey, pagename);
    Map map = new HashMap();
    map.put("sessionKey", sessionKey);
    JSONObject jsonObject = JSONObject.fromObject(map);

    out.clear();
    out.print(jsonObject.toString());
    out.flush();
%>