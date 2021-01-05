<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.meeting.qrcode.MeetingSignUtil"%> 
<%@ include file="/systeminfo/init_wev8.jsp" %>

<%
String ClientIP = Util.getIpAddr(request);

String method = Util.null2String(request.getParameter("method"));

if(method.equals("edit"))
{
String qrticket=Util.null2String(request.getParameter("qrticket"));
String userid=Util.null2String(request.getParameter("userid"));
MeetingSignUtil.signMeetingByHand(qrticket,userid,ClientIP,user);

%>
<script>
	 var parentWin = parent.parent.getParentWindow(window.parent);
     parentWin.refashSignList();
     parentWin.diag_vote.close();
</script>
<%
}else if("ajaxSave".equals(method)){
	String meetingid=Util.null2String(request.getParameter("meetingid"));
	String signid=Util.null2String(request.getParameter("signid"));
	out.print(MeetingSignUtil.signMeetingByHandOne(signid,meetingid,ClientIP,user));
}else if("delSign".equals(method)){
	String meetingid=Util.null2String(request.getParameter("meetingid"));
	String signid=Util.null2String(request.getParameter("signid"));
	out.print(MeetingSignUtil.delSign(signid,meetingid));
}
%>