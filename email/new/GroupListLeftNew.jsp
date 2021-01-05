
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.email.domain.MailGroup"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
<jsp:useBean id="gms" class="weaver.email.service.GroupManagerService" scope="page" />
<jsp:useBean id="cms" class="weaver.email.service.ContactManagerService" scope="page" />
<%
User user = HrmUserVarify.getUser(request , response) ;
int allContactCount = cms.getAllContactCountById(user.getUID());
int notGroupContactCount = cms.getNotGroupContactCountById(user.getUID());

String leftMenus="";
leftMenus +="{name:'"+SystemEnv.getHtmlLabelName(25398,user.getLanguage())+"',hasChildren:false,attr:{id:'"+Integer.MAX_VALUE+"'},numbers:{flowAll:"+allContactCount+"}}";	
leftMenus +=",{name:'"+SystemEnv.getHtmlLabelName(81307,user.getLanguage())+"',hasChildren:false,attr:{id:'"+Integer.MIN_VALUE+"'},numbers:{flowAll:"+notGroupContactCount+"}}";	

ArrayList groupList = gms.getGroupsById(user.getUID());
for(int i=0; i<groupList.size(); i++){
	MailGroup mailGroup = (MailGroup)groupList.get(i);
	leftMenus +=",{name:'"+mailGroup.getMailGroupName()+"',hasChildren:false,attr:{id:'"+mailGroup.getMailGroupId()+"',name:'"+mailGroup.getMailGroupName()+"'},"+
			"numbers:{flowAll:"+mailGroup.getContactCount()+"}}";	
}
	
leftMenus="["+leftMenus+"]";
out.print(leftMenus);

%>
