<%@page import="weaver.email.domain.MailGroup"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/page/maint/common/initNoCache.jsp"%>

<jsp:useBean id="gms" class="weaver.email.service.GroupManagerService" scope="page" />

<%
	int currentGroup = Util.getIntValue(request.getParameter("currentGroup"),0);
	ArrayList groupList = gms.getGroupsById(user.getUID());
	for(int i=0; i<groupList.size(); i++){
		MailGroup mailGroup = (MailGroup)groupList.get(i);
		if(mailGroup.getMailGroupId()==currentGroup){
			continue;
		}
%>
	<div class="w-all groupiteam hand" id="<%=mailGroup.getMailGroupId()%>">
		<span class="overText w-90"><%=mailGroup.getMailGroupName()%></span>
	</div>
<%
	}
%>
	<div class="clear"></div>
