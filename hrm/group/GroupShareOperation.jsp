
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>

<jsp:useBean id="GroupAction" class="weaver.hrm.group.GroupAction" scope="page" />

<%
/*权限判断--Begin*/  
boolean cansave=HrmUserVarify.checkUserRight("CustomGroup:Edit", user);
int creatorid = Util.getIntValue(request.getParameter("ownerid"));
int operuid=user.getUID();
/*权限判断--End*/  
int id = Util.getIntValue(request.getParameter("id"));
String method = Util.null2String(request.getParameter("method"));
int groupid = Util.getIntValue(request.getParameter("groupid"));
//int relatedshareid = Util.getIntValue(request.getParameter("relatedshareid"));
String relatedshareid = Util.null2String(request.getParameter("relatedshareid"));
int sharetype = Util.getIntValue(request.getParameter("sharetype"));
//String sharetype = Util.null2String(request.getParameter("sharetype"));
//int rolelevel = Util.getIntValue(request.getParameter("rolelevel"));
String rolelevel = Util.null2String(request.getParameter("rolelevel"));
//int seclevel = Util.getIntValue(request.getParameter("seclevel"));
String seclevel = Util.null2String(request.getParameter("seclevel"));
String seclevelto = Util.null2String(request.getParameter("seclevelto"));
String jobtitlelevel = Util.null2String(request.getParameter("jobtitlelevel"));
String jobtitlesubcompany = Util.null2String(request.getParameter("jobtitlesubcompany"));
String jobtitledepartment = Util.null2String(request.getParameter("jobtitledepartment"));
String scopeid = "0";
if(jobtitlelevel.equals("1")){
	scopeid = jobtitledepartment;
}else if(jobtitlelevel.equals("2")){
	scopeid = jobtitlesubcompany;
}

int sharelevel = Util.getIntValue(request.getParameter("sharelevel"));
int crmid = Util.getIntValue(request.getParameter("crmid"),0); //客户类型从-1开始依次递减，0表示客户类型为空
String userid ="-1" ;
String departmentid = "-1" ;
String subcompanyid="-1";
String roleid = "-1" ;
String jobtitleid = "-1" ;
int foralluser = -1 ;
//int sharecrm=0;
if(sharetype==1){
	userid = relatedshareid ;
} 
if(sharetype==2) subcompanyid = relatedshareid ;
if(sharetype==3) departmentid = relatedshareid ;
if(sharetype==4) roleid = relatedshareid ;
if(sharetype==5) foralluser = 1 ;
if(sharetype==7) jobtitleid = relatedshareid ;
if(sharetype==8) sharetype = Util.getIntValue(relatedshareid,0) ;


if(method.equals("delete"))
{
	if(creatorid!=operuid&&!cansave){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
}
 GroupAction.deleteShare(id,groupid);



   

	

	
response.sendRedirect("GroupShare.jsp?isdialog=1&groupid="+groupid);
	return;
}


if(method.equals("add"))
{
	  
	if(creatorid!=operuid&&!cansave){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
}
//  crmid =0
    GroupAction.addShare(groupid,sharetype,seclevel,seclevelto,rolelevel,sharelevel,userid,subcompanyid,departmentid,roleid,foralluser,crmid, jobtitleid, jobtitlelevel, scopeid);




	response.sendRedirect("GroupShareAdd.jsp?isdialog=1&isclose=1&groupid="+groupid);
	return;
}
%>
