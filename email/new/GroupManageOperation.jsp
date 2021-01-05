<%@page import="org.apache.commons.lang.time.DateUtils"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.TimeUtil" %>

<%@ page language="java" contentType="text/html; charset=utf-8" %> 
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<jsp:useBean id="gms" class="weaver.email.service.GroupManagerService" scope="page" />


<%
	
	String method = Util.null2String(request.getParameter("method"));
	String groupName = Util.null2String(request.getParameter("groupName"));
	int id = Util.getIntValue(request.getParameter("id"));
	
	
	out.clear(); //清除不需要的内容
	if(method.equals("add")){
		if(gms.isNameRepeat(groupName, user.getUID())) {
			out.print(0); //组名重复
		} else {
			int groupId = gms.createGroup(user.getUID(), groupName);
			if(groupId == -1) {
				out.print(-1); //创建失败
			} else {
				out.print(1); //创建成功
			}
		}
	}else if(method.equals("delete")){
		gms.deleteGroup(user.getUID(), id);
	}else if(method.equals("edit")) {
		if(gms.isNameRepeat(groupName, user.getUID())) {
			out.print(0); //组名重复
		} else {
			if(gms.editGroupName(groupName, id, user.getUID())) {
				out.print(1); //修改成功
			} else {
				out.print(2); //修改失败
			}
		}
	}else if(method.equals("getGroupCount")) {
		out.print(gms.getGroupCount(user.getUID()));
	}
%>