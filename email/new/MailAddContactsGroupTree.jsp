<%@page import="weaver.email.domain.MailContact"%>
<%@page import="weaver.email.domain.MailGroup"%>

<%@ page language="java" contentType="text/html; charset=utf-8" %> 
<%@ include file="/page/maint/common/initNoCache.jsp"%>
<jsp:useBean id="cms" class="weaver.email.service.ContactManagerService" scope="page" />
<jsp:useBean id="gms" class="weaver.email.service.GroupManagerService" scope="page" />

<%
	String keyword = Util.null2String(request.getParameter("keyword"));
	int tempsize=10;
	ArrayList<MailGroup> groups = gms.getGroupsById(user.getUID());
	for(int i=0; i<groups.size(); i++) {
		MailGroup mailGroup = groups.get(i);
		int groupId = mailGroup.getMailGroupId();
		ArrayList<MailContact> groupedContacts = cms.getGroupedContacts(groupId, user.getUID(),keyword);
		if(groupedContacts.size()>0){
			int _number = ((groupedContacts.size()%tempsize)==0)?(groupedContacts.size()/tempsize):((groupedContacts.size()/tempsize))+1;
%>
<div class="contactsTree-item contactsFold">
	<div class="hand contactsGroup relative" target="customGroup" groupid='<%=groupId %>' ondblclick="dblclickGroupTree(this,<%=_number%>)" onclick="showOrHideContactList(this,<%=_number%>)" _pagenum=1 _pagesize="<%=((groupedContacts.size()%tempsize)==0)?(groupedContacts.size()/tempsize):((groupedContacts.size()/tempsize))+1%>">
		<span class=" m-t-15 p-l-5">
			<b  class="iconRArr" title="<%=SystemEnv.getHtmlLabelName(15315, user.getLanguage())%>">&nbsp;</b>  <!-- 展开 -->
			<b  class="iconDArr hide" title="<%=SystemEnv.getHtmlLabelName(20721, user.getLanguage())%>">&nbsp;</b>  <!-- 收缩 -->
		</span>
		<span title="<%=mailGroup.getMailGroupName() %>" class="overText w-120 p-l-10"><%=Util.getMoreStr(mailGroup.getMailGroupName(), 6, "..") %>&nbsp;(<%=groupedContacts.size() %>)</span>
		<!-- 
		<span class="hand hide"   name="SH"  onclick="Spage(1,1,<%=groupId%>,event,this)"   title="<%=SystemEnv.getHtmlLabelName(1258, user.getLanguage())%>"><img src="/email/images/1_wev8.png"></span>
		<span class="hand hide"   name="SH"  onclick="Spage(1,2,<%=groupId%>,event,this)"   title="<%=SystemEnv.getHtmlLabelName(1259, user.getLanguage())%>"><img src="/email/images/2_wev8.png"></span>
		-->
	</div>
	<div id="customGroup" class="contactsGroupContent hide"></div>
</div>
<%
	   }
	}
%>

<%
	ArrayList ungroupedContacts = cms.getUngroupedContacts(user.getUID(),keyword);
	if(ungroupedContacts.size() > 0) {
%>
<div class="contactsTree-item contactsFold">
	<div class="hand contactsGroup relative" target="customGroup" groupid='0' onclick="showOrHideContactList(this,<%=((ungroupedContacts.size()%tempsize)==0)?ungroupedContacts.size()/tempsize:(ungroupedContacts.size()/tempsize+1)%>)"  _pagenum=1   _pagesize="<%=((ungroupedContacts.size()%tempsize)==0)?ungroupedContacts.size()/tempsize:(ungroupedContacts.size()/tempsize+1)%>">
		<span class=" m-t-15 p-l-5">
		<b  class="iconRArr" title="<%=SystemEnv.getHtmlLabelName(15315, user.getLanguage())%>">&nbsp;</b>  <!-- 展开 -->
		<b  class="iconDArr hide" title="<%=SystemEnv.getHtmlLabelName(20721, user.getLanguage())%>">&nbsp;</b>  <!-- 收缩 -->
	</span>
        <!-- 未分组 -->
		<span title="<%=SystemEnv.getHtmlLabelName(81307, user.getLanguage())%>" class="p-l-10  w-120"><%=SystemEnv.getHtmlLabelName(81307, user.getLanguage())%>&nbsp;(<%=ungroupedContacts.size() %>)</span>
		<!--  
		<span class="hand  hide"   name="SH"  onclick="Spage(2,1,'0',event,this)"  title="<%=SystemEnv.getHtmlLabelName(1258, user.getLanguage())%>"><img src="/email/images/1_wev8.png"></span>
		<span class="hand  hide"  name="SH"   onclick="Spage(2,2,'0',event,this)"   title="<%=SystemEnv.getHtmlLabelName(1259, user.getLanguage())%>"><img src="/email/images/2_wev8.png"></span>
		-->
	</div>
	<div id="customGroup" class="contactsGroupContent hide"></div>
</div>
<%		
	}
%>

<div class="line-1 m-t-5">&nbsp;</div>

<%
	ArrayList<MailContact> allContact = cms.getAllContacts(user.getUID());
%>
<div class="contactsTree-item contactsFold">
	<div class="hand contactsGroup relative" target="customGroup" groupid='-1' onclick="showOrHideContactList(this,<%=((allContact.size()%tempsize)==0)?allContact.size()/tempsize:(allContact.size()/tempsize+1)%>)" _pagenum=1   _pagesize="<%=((allContact.size()%tempsize)==0)?allContact.size()/tempsize:(allContact.size()/tempsize+1)%>">
		<span class=" m-t-15 p-l-5">
			<b  class="iconRArr" title="<%=SystemEnv.getHtmlLabelName(15315, user.getLanguage())%>">&nbsp;</b>  <!-- 展开 -->
			<b  class="iconDArr hide" title="<%=SystemEnv.getHtmlLabelName(20721, user.getLanguage())%>">&nbsp;</b>  <!-- 收缩 -->
		</span>
        <!-- 所有 -->
		<span title="<%=SystemEnv.getHtmlLabelName(235, user.getLanguage())%>" class="p-l-10 w-120"><%=SystemEnv.getHtmlLabelName(235, user.getLanguage())%>&nbsp; (<%=allContact.size() %>)</span>
		<!--  
		<span class="hand  hide"  name="SH"   onclick="Spage(3,1,'-1',event,this)"  title="<%=SystemEnv.getHtmlLabelName(1258, user.getLanguage())%>"><img src="/email/images/1_wev8.png"></span>
		<span class="hand hide"  name="SH"   onclick="Spage(3,2,'-1',event,this)"   title="<%=SystemEnv.getHtmlLabelName(1259, user.getLanguage())%>"><img src="/email/images/2_wev8.png"></span>
		-->
	</div>
	<div id="customGroup" class="contactsGroupContent hide"></div>
</div>