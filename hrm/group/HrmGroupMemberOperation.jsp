
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

String memebers = Util.null2String(request.getParameter("memebers"));

String scopeid = "0";
if(jobtitlelevel.equals("1")){
	scopeid = jobtitledepartment;
}else if(jobtitlelevel.equals("2")){
	scopeid = jobtitlesubcompany;
}

int sharelevel = Util.getIntValue(request.getParameter("sharelevel"));
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
 GroupAction.deleteMember(id,groupid);
	response.sendRedirect("HrmGroupMember.jsp?isdialog=1&groupid="+groupid);
	return;
}


if(method.equals("saveDsporder"))
{
	String[] ids = request.getParameterValues("id");
	String[] dsporders = request.getParameterValues("dsporder");
	for(int i = 0 ;ids != null && i< ids.length;i++){
 		GroupAction.saveMemberDsporder(ids[i],groupid,dsporders[i]);
	}
	response.sendRedirect("HrmGroupMember.jsp?isdialog=1&groupid="+groupid);
	return;
}

if(method.equals("add"))
{
	  
	if(creatorid!=operuid&&!cansave){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
}
    GroupAction.addMember(groupid,sharetype,seclevel,seclevelto,rolelevel,sharelevel,userid,subcompanyid,departmentid,roleid,foralluser, jobtitleid, jobtitlelevel, scopeid);

	response.sendRedirect("HrmGroupMemberAdd.jsp?isdialog=1&isclose=1&groupid="+groupid);
	return;
}

if(method.equals("addMemebers"))
{
	  
    GroupAction.addMembers(groupid+"",memebers);
}
%>
