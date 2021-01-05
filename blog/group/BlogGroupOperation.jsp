<%@page import="org.apache.commons.lang.time.DateUtils"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.TimeUtil" %>

<%@ page language="java" contentType="text/html; charset=utf-8" %> 
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<jsp:useBean id="gms" class="weaver.blog.service.BlogGroupService" scope="page" />

<%
	
	String method = Util.null2String(request.getParameter("method"));
	String groupName = Util.null2String(request.getParameter("groupName"));
	int id = Util.getIntValue(request.getParameter("id"));
	String idSet = Util.null2String(request.getParameter("idSet"));
	String sourceGroup = Util.null2String(request.getParameter("sourceGroup"));
	String destGroup = Util.null2String(request.getParameter("destGroup"));
	
	out.clear(); //清除不需要的内容
	if(method.equals("add")){
		if(gms.isNameRepeat(groupName, user.getUID())) {
			out.print(0); //组名重复
		} else {
			gms.createGroup(user.getUID(), groupName); 
			out.print(1); //创建成功
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
	}else if(method.equals("getGroupList")){
		String currentGroup = Util.null2String(request.getParameter("currentGroup"));
		ArrayList groupList = gms.getGroupsById(user.getUID());
		String htmlstr="";
		for(int i=0; i<groupList.size(); i++){
			Map groupMap=(Map)groupList.get(i);
			String groupid=(String)groupMap.get("id");
			String groupname=(String)groupMap.get("groupname");
			if(groupid==currentGroup){
				continue;
			}
			htmlstr+="<div class='w-all groupiteam hand' id='"+groupid+"'>"
					+"<span class='overText w-90'>"+groupname+"</span>"
					+"</div>";
		}
		htmlstr+="<div class='clear'></div>";
		out.print(htmlstr);
	}else if(method.equals("move")){
		if(gms.removeFromGroup(idSet, sourceGroup)) { 
			gms.addContactToGroup(idSet, destGroup);
		} 
	}else if(method.equals("copy")){
		gms.addContactToGroup(idSet, destGroup);
	}else if(method.equals("cmtg")){ //新建分组并移动
		if(gms.isNameRepeat(groupName, user.getUID())) {
			out.print(0); //组名重复
		} else {
			String groupId=gms.createGroup(user.getUID(), groupName); 
			if(gms.removeFromGroup(idSet, sourceGroup)) {
				gms.addContactToGroup(idSet, groupId);
				out.print(1); //成功
			} 
		}
	}else if(method.equals("cctg")){ //新建分组并复制
		if(gms.isNameRepeat(groupName, user.getUID())) {
			out.print(0); //组名重复
		} else {
			String groupId=gms.createGroup(user.getUID(), groupName);
			gms.addContactToGroup(idSet, groupId);
			out.print(1); //成功
		}
	}else if(method.equals("removeUser")){ //从组中移除关注的人
		gms.removeFromGroup(idSet, sourceGroup);
	}else if(method.equals("groupCheck")){
		String result="";
		ArrayList groupList = gms.getGroupsById(user.getUID());
		for(int i=0; i<groupList.size(); i++)
		{
			Map groupMap=(Map)groupList.get(i);
			String groupid=(String)groupMap.get("id");
			String groupname=(String)groupMap.get("groupname");
			result+=",{groupid:"+groupid+",groupname:'"+groupname+"'}";
		}	
		result=result.length()>0?result.substring(1):"";
		result="["+result+"]";
		out.println(result);
	}else if(method.equals("addToGroup")){
		gms.removeFromGroup(idSet, sourceGroup);
		gms.addUserToGroups(idSet, destGroup);
	}
%>