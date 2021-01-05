<%@ page language="java" contentType="application/json" pageEncoding="UTF-8"%>
<%@page import="net.sf.json.*"%>
<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>
<%@ page import="weaver.file.*" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.hrm.*" %>
<%@page import="weaver.meeting.MeetingMobileUtil"%>
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
Map result = new HashMap();
if("reHrm".equals(operation)){
	String meetingid = Util.null2String(fu.getParameter("meetingid"));//回执id
	String receiptId = Util.null2String(fu.getParameter("receiptId"));//回执id
	String isattend = Util.null2String(fu.getParameter("isattend"));//是否参加
	String recRemark = Util.null2String(fu.getParameter("recRemark"));//备注信息
	boolean ret=MeetingMobileUtil.saveRe(meetingid,receiptId,Util.getIntValue(isattend),recRemark);
	result.put("ret",ret);
}
JSONObject jo = JSONObject.fromObject(result);
out.println(jo);
%>