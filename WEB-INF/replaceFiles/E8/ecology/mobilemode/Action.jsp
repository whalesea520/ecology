<%@page import="com.weaver.formmodel.mobile.manager.MobileUserInit"%>
<%@page import="weaver.hrm.User"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="com.weaver.formmodel.base.MobileAction"%>
<%@page import="java.lang.reflect.Constructor"%>
<%@page import="weaver.general.Util"%>
<%
//mobilemode/Action.jsp?invoker=com.weaver.formmodel.base.TestAction&action=save

String invoker = Util.null2String(request.getParameter("invoker")).trim();
if(invoker.equals("")){
	return;
}
try {
	User user = MobileUserInit.getUser(request, response);
	if(user == null){
		throw new RuntimeException("No user login, please try again later after login!");
	}
	Class clazz = Class.forName(invoker);
	Constructor ctor = clazz.getConstructor(new Class[] {HttpServletRequest.class, HttpServletResponse.class});
	Object actionObj = ctor.newInstance(new Object[] {request, response});
	if(actionObj instanceof MobileAction){
		MobileAction mobileAction = (MobileAction)actionObj;
		mobileAction.execute_proxy();
	}else{
		throw new RuntimeException(invoker + " must be extends MobileAction");
	}
} catch (Exception ex) {
	ex.printStackTrace();
	out.println(ex);
}
%>