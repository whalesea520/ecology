
<%@page import="java.io.File"%><%@page import="weaver.systeminfo.SystemEnv"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.BaseBean" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@page import="weaver.fna.general.FnaSubjectInitE8"%>
<%@page import="org.json.JSONObject"%>
<%
User user = HrmUserVarify.getUser (request , response) ;

// || HrmUserVarify.checkUserRight("FnaBudgetfeeTypeEdit:Edit",user)
boolean canEdit = HrmUserVarify.checkUserRight("FnaLedgerAdd:Add",user) || HrmUserVarify.checkUserRight("FnaLedgerEdit:Edit",user);
if(!canEdit){
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}

String operation = Util.null2String(request.getParameter("operation"));

BaseBean base = new BaseBean();

if(operation.equals("initSubjectE8")){
	//String fnaBatch_filepath = request.getRealPath(request.getServletPath().substring(0,request.getServletPath().lastIndexOf("/")))+"\\";
	String fnaBatch_filepath = request.getRealPath(request.getServletPath().substring(0,request.getServletPath().lastIndexOf("/")))+File.separatorChar;
	String result = FnaSubjectInitE8.initSubjectE8(user.getLanguage(), fnaBatch_filepath, user.getUID());
	
	if("".equals(result)){
		out.println("{\"flag\":true}");//成功
	}else{
		out.println("{\"flag\":false, \"msg\":"+JSONObject.quote(result)+"}");//成功
	}
	out.flush();
	return;
}else{
	response.sendRedirect("/notice/noright.jsp") ;
}
%>