
<%@ page language="java" contentType="application/json" pageEncoding="UTF-8"%>
<%@page import="net.sf.json.*"%>
<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>
<%@ page import="weaver.file.*" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.mobile.rong.*" %>
<%@ page import="weaver.mobile.plugin.ecology.service.*" %>

<%
request.setCharacterEncoding("UTF-8");
User user = HrmUserVarify.getUser (request , response) ;
if(user==null) {
	Map result = new HashMap();
	//未登录或登录超时
	result.put("error", "remote server session time out");
	
	JSONObject jo = JSONObject.fromObject(result);
	out.println(jo);
	
	return;
}

response.setContentType("application/json;charset=UTF-8");

FileUpload fu = new FileUpload(request);

String operation = Util.null2String(fu.getParameter("operation"));
String groupid = Util.null2String(fu.getParameter("groupid"));

Map result = new HashMap();
if(operation.equals("addgroupbook")){
	if(RongService.addGroupBook(user, groupid)){
		result.put("result",true);
	}else{
		result.put("result",false);
	}
}else  if(operation.equals("delgroupbook")){
	if(RongService.delGroupBook(user, groupid)){
		result.put("result",true);
	}else{
		result.put("result",false);
	}
}else if(operation.equals("getstatus")){
	if(RongService.getGroupStatus(user, groupid)){
		result.put("result",true);
	}else{
		result.put("result",false);
	}
}else if(operation.equals("getgrouplist")){
	List<String>  grouplist = RongService.getGroupList(user);
	result.put("list",grouplist);
}else if(operation.equals("addgroupnotice")){
	String targetid = Util.null2String(fu.getParameter("targetid"));
	String sendid = Util.null2String(fu.getParameter("sendid"));
	String content = Util.null2String(fu.getParameter("content"));
	String date = Util.null2String(fu.getParameter("date"));
	GroupNotice gn = new GroupNotice();
	gn.setTargetid(targetid);
	gn.setSendid(sendid);
	gn.setContent(content);
	gn.setDate(date);
	if(!RongService.addGroupNotice(gn).equals("")){
		result.put("result",true);
	}else{
		result.put("result",false);
	}
}else if(operation.equals("getgroupnotice")){	
	String targetid = Util.null2String(fu.getParameter("targetid"));
	List<GroupNotice>  groupNoticeList = RongService.getGroupNoticeList(targetid);
	List<GroupNotice>  groupChatList = RongService.getGroupVoteList(targetid);
	result.put("list",groupNoticeList);
	result.put("list2",groupChatList);
}else{
	return;
}

JSONObject jo = JSONObject.fromObject(result);
out.println(jo);

%>