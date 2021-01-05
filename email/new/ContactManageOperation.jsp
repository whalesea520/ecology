<%@page import="weaver.email.domain.MailContact"%>
<%@page import="org.apache.commons.lang.time.DateUtils"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.TimeUtil" %>

<%@ page language="java" contentType="text/html; charset=utf-8" %> 
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<jsp:useBean id="cms" class="weaver.email.service.ContactManagerService" scope="page" />
<jsp:useBean id="gms" class="weaver.email.service.GroupManagerService" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />

<%
	
	String method = Util.null2String(request.getParameter("method"));
	String id = Util.null2String(request.getParameter("id"));
	String groupName = Util.null2String(request.getParameter("groupName"));
	String idSet = Util.null2String(request.getParameter("idSet"));
	String groups = Util.null2String(request.getParameter("groups"));
	int sourceGroup = Util.getIntValue(request.getParameter("sourceGroup"));
	int destGroup = Util.getIntValue(request.getParameter("destGroup"));
	String tempIsTrDel = Util.null2String(request.getParameter("isTrDel"));
	boolean isTrDel = false;
	if(tempIsTrDel.equals("true")) {
		isTrDel = true;
	}
	
	String mailUserName = Util.null2String(request.getParameter("mailUserName"));
	String mailUserEmail = Util.null2String(request.getParameter("mailUserEmail"));
	String mailUserDesc = Util.null2String(request.getParameter("mailUserDesc"));
	String mailUserMobileP = Util.null2String(request.getParameter("mailUserMobileP"));
	String mailUserTelP = Util.null2String(request.getParameter("mailUserTelP"));
	String mailUserIMP = Util.null2String(request.getParameter("mailUserIMP"));
	String mailUserAddressP = Util.null2String(request.getParameter("mailUserAddressP"));
	String mailUserTelW = Util.null2String(request.getParameter("mailUserTelW"));
	String mailUserFaxW = Util.null2String(request.getParameter("mailUserFaxW"));
	String mailUserCompanyW = Util.null2String(request.getParameter("mailUserCompanyW"));
	String mailUserDepartmentW = Util.null2String(request.getParameter("mailUserDepartmentW"));
	String mailUserPostW = Util.null2String(request.getParameter("mailUserPostW"));
	String mailUserAddressW = Util.null2String(request.getParameter("mailUserAddressW"));
	
	MailContact mailContact = new MailContact();
	mailContact.setId(id);
	mailContact.setMailUserName(mailUserName);
	mailContact.setMailAddress(mailUserEmail);
	mailContact.setMailUserDesc(mailUserDesc);
	mailContact.setMailUserTel(mailUserMobileP);
	mailContact.setMailUserTelP(mailUserTelP);
	mailContact.setMailUserIMP(mailUserIMP);
	mailContact.setMailUserAddressP(mailUserAddressP);
	mailContact.setMailUserTelW(mailUserTelW);
	mailContact.setMailUserFaxW(mailUserFaxW);
	mailContact.setMailUserCompanyW(mailUserCompanyW);
	mailContact.setMailUserDepartmentW(mailUserDepartmentW);
	mailContact.setMailUserTmailUserPostWelP(mailUserPostW);
	mailContact.setMailUserTemailUserAddressWlP(mailUserAddressW);
    
	out.clear();
	if(method.equals("contacterAdd")){
		int tempId = cms.addContact(mailContact, user.getUID());
		if(tempId != -1) {
			cms.addGroupToContact(groups, tempId);
		}
	}else if(method.equals("delete")){
		if(isTrDel) {
			cms.deleteContacts(idSet, user.getUID());
		} else {
			cms.removeContactsFromGroup(idSet, sourceGroup);
		}
	}else if(method.equals("contacterEdit")){
		cms.editContact(mailContact, user.getUID());
		int tempId = Util.getIntValue(id);
		cms.addGroupToContact(groups, tempId);
	}else if(method.equals("move")){
		if(cms.removeContactsFromGroup(idSet, sourceGroup)) {
			cms.addContactToGroup(idSet, destGroup);
		} 
	}else if(method.equals("copy")){
		cms.addContactToGroup(idSet, destGroup);
	}else if(method.equals("cmtg")){ //新建分组并移动
		if(gms.isNameRepeat(groupName, user.getUID())) {
			out.print(0); //组名重复
		} else {
			int groupId = gms.createGroup(user.getUID(), groupName);
			if(groupId == -1) {
				out.print(-1); //失败
			} else {
				if(cms.removeContactsFromGroup(idSet, sourceGroup)) {
					cms.addContactToGroup(idSet, groupId);
					out.print(1); //成功
				} 
			}
		}
	}else if(method.equals("cctg")){ //新建分组并复制
		if(gms.isNameRepeat(groupName, user.getUID())) {
			out.print(0); //组名重复
		} else {
			int groupId = gms.createGroup(user.getUID(), groupName);
			if(groupId == -1) {
				out.print(-1); //失败
			} else {
				cms.addContactToGroup(idSet, groupId);
				out.print(1); //成功
			}
		}
	}else if(method.equals("cancel")){//将联系人从分组信息中删除
		if(!"".equals(idSet)){
			rs.execute("delete from GroupAndContact where groupId = "+sourceGroup+" and contactId in ("+idSet+")");
		}
	}
%>