<%@page import="weaver.email.domain.MailContact"%>
<%@page import="weaver.email.domain.MailGroup"%>

<%@ page language="java" contentType="text/html; charset=utf-8" %> 
<%@ include file="/page/maint/common/initNoCache.jsp"%>
<jsp:useBean id="cms" class="weaver.email.service.ContactManagerService" scope="page" />
<jsp:useBean id="gms" class="weaver.email.service.GroupManagerService" scope="page" />

<%
	String keyword = Util.null2String(request.getParameter("keyword"));
	int groupId = Util.getIntValue(request.getParameter("groupid"));
	int type = Util.getIntValue(request.getParameter("type"));
	int fx = Util.getIntValue(request.getParameter("fx"));
	int _pagenum=Util.getIntValue(request.getParameter("_pagenum"),1);
	String onlyNum=Util.null2String(request.getParameter("onlyNum"));
	boolean flag=false;
	if(type!=-1&&fx!=-1){
			flag=true;
	}
	
	ArrayList groupedContacts =null;
	int pagenum=1;
	int size=10;
	if(flag){
		pagenum=_pagenum;
	}
	if(groupId>0){
			//分组
			groupedContacts = cms.getGroupedContacts(1,groupId, user.getUID(),pagenum,size,keyword);
	}else  if(groupId==0){
			//未分组
			groupedContacts = cms.getGroupedContacts(2,groupId, user.getUID(),pagenum,size,keyword);
	}else if(groupId==-1){
			//所有
			groupedContacts = cms.getGroupedContacts(3,groupId, user.getUID(),pagenum,size,keyword);
	}
	out.clear();

		if(groupedContacts.size()>0){
%>
<%
		for(int j=0; j<groupedContacts.size(); j++) {
			MailContact mailContact = (MailContact)groupedContacts.get(j);
%>
		<div data-id="0" _mailaddress="<%=mailContact.getMailUserName() %><<%=mailContact.getMailAddress() %>>"  onclick="addAddress('<%=mailContact.getMailUserName() %><<%=mailContact.getMailAddress() %>>')" title="&quot;<%=mailContact.getMailUserName() %>&quot;&lt;<%=mailContact.getMailAddress() %>&gt;" class="hand contactsItem w-all " ><span class='overText w-100 p-l-15'><%=mailContact.getMailUserName() %></span></div>
		
<%
	}
		
		if(_pagenum<=1&&!"1".equals(onlyNum)){
				out.println("<div style=\"cursor: pointer;text-align: center;\" onclick=\"Spage("+groupId+","+_pagenum+",event,this)\"   class='more_class'>"+SystemEnv.getHtmlLabelName(17499, user.getLanguage())+"</div>");	
		}
		
	}
%>


