
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.email.domain.MailGroup"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
<jsp:useBean id="gms" class="weaver.blog.service.BlogGroupService" scope="page" />
<jsp:useBean id="blogDao" class="weaver.blog.BlogDao" scope="page" />
<%
User user = HrmUserVarify.getUser(request , response) ;
int allContactCount = blogDao.getMyAttentionCount(user.getUID()+"","all");
int notGroupContactCount = blogDao.getMyAttentionCount(user.getUID()+"","nogroup");

String leftMenus="";
leftMenus +="{name:'"+SystemEnv.getHtmlLabelName(25398,user.getLanguage())+"',hasChildren:false,attr:{id:'all'},numbers:{flowAll:"+allContactCount+"}}";	
leftMenus +=",{name:'"+SystemEnv.getHtmlLabelName(81307,user.getLanguage())+"',hasChildren:false,attr:{id:'nogroup'},numbers:{flowAll:"+notGroupContactCount+"}}";	

ArrayList groupList = gms.getGroupsById(user.getUID());
for(int i=0; i<groupList.size(); i++){
	Map groupMap=(Map)groupList.get(i);
	String groupid=(String)groupMap.get("id");
	String groupname=(String)groupMap.get("groupname");
	
	int groupCount = blogDao.getMyAttentionCount(user.getUID()+"",groupid);
	
	leftMenus +=",{name:'"+groupname+"',hasChildren:false,attr:{id:'"+groupid+"',name:'"+groupname+"'},numbers:{flowAll:"+groupCount+"}}";	
}
	
leftMenus="["+leftMenus+"]";
// System.err.println(leftMenus);
out.print(leftMenus);

%>
