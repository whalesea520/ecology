<%@page import="weaver.email.domain.MailGroup"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/page/maint/common/initNoCache.jsp"%>
<jsp:useBean id="gms" class="weaver.email.service.GroupManagerService" scope="page" />
<jsp:useBean id="cms" class="weaver.email.service.ContactManagerService" scope="page" />
<%
	int allContactCount = cms.getAllContactCountById(user.getUID());
	int notGroupContactCount = cms.getNotGroupContactCountById(user.getUID());
%>
<div id="<%=Integer.MAX_VALUE %>" class="hand contactsGroup contactsAll h-30" title="<%=SystemEnv.getHtmlLabelName(25398,user.getLanguage()) %>">
	<div id="group" class="p-l-15">
		<span id="info" class="bold">
			<span class="overText left" ><%=SystemEnv.getHtmlLabelName(25398,user.getLanguage()) %></span>
			(<span class="countactCount"><%=allContactCount %></span>)
		</span>
	</div>
</div>
<div id="<%=Integer.MIN_VALUE %>" class="hand contactsGroup h-30" title="<%=SystemEnv.getHtmlLabelName(81307,user.getLanguage()) %>">
	<div id="group" class="p-l-15">	
		<span id="info" >
			<span class="overText left" ><%=SystemEnv.getHtmlLabelName(81307,user.getLanguage()) %></span>
			(<span class="countactCount"><%=notGroupContactCount %></span>)
		</span>
	</div>
</div>
<div class="line-1  m-l-5 m-r-5 m-t-5  m-t-5">&nbsp;</div>
<%
	ArrayList groupList = gms.getGroupsById(user.getUID());
	for(int i=0; i<groupList.size(); i++)
	{
		MailGroup mailGroup = (MailGroup)groupList.get(i);
%>
<div id="<%=mailGroup.getMailGroupId() %>" class="hand contactsGroup h-30" title="<%=mailGroup.getMailGroupName()%>">
	<div id="group" class="p-l-15">
		<span id="info" class="left">
			<span class="overText  left" style="width: 70;"><%=mailGroup.getMailGroupName() %></span>
			(<span class="countactCount"><%=mailGroup.getContactCount() %></span>)
		</span>
		<span id="action" class="m-t-5 right hide color666 m-r-15">
			<span id="edit" title="<%=SystemEnv.getHtmlLabelName(26473,user.getLanguage()) %>"><img src='/email/images/edit_wev8.png'></span>
			<span id="delete" title="<%=SystemEnv.getHtmlLabelName(23777,user.getLanguage()) %>">
				<img  src='/email/images/del_wev8.png'>
				<input id="groupId" type="hidden" value="<%=mailGroup.getMailGroupId() %>" />
			</span>
		</span>
		<div class="clear"></div>
	</div>
	<div id="editGroup" class="hide p-l-15" style="cursor: Default;">
		<span id="editInfo">
			<input id="groupId" type="hidden" value="<%=mailGroup.getMailGroupId() %>" />
			<input id="oldGroupName" type="hidden" value="<%=mailGroup.getMailGroupName() %>" />
			<input id="groupName" class="input" type="text" value="<%=mailGroup.getMailGroupName() %>" style="width: 110px; margin-top: 3px;">
		</span>
	</div>
</div>
<%
	}
%>
<input id="mailgroupid" type="hidden" value="<%=Integer.MAX_VALUE %>" / >
