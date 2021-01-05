<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ page import="com.cloudstore.api.controller.ActionFactory"%>
<%@ page import="com.cloudstore.api.util.Util_Action"%>
<%@ page import="weaver.hrm.HrmUserVarify"%>
<%@ page import="weaver.hrm.User"%>
<%@ page import="com.alibaba.fastjson.JSONObject"%>
<%
User user = (User) request.getSession(true).getAttribute("weaver_user@bean");
if(user!=null){
	ActionFactory af = ActionFactory.getInstance();
	af.setBaseActionName(request.getParameter("action"));
	out.print(af.getBaseAction().execute(request,response));
}else{
	Util_Action utilAction = new Util_Action(); 
	JSONObject jb=new JSONObject();
	jb=utilAction.getWrongCode(401, jb);
	out.print(JSONObject.toJSONString(jb));
}
%>