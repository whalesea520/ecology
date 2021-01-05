<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ page import="weaver.file.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.meeting.qrcode.MeetingSignUtil" %>
<%@ page import="weaver.systeminfo.SystemEnv" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
response.setContentType("application/json;charset=UTF-8");
User user = HrmUserVarify.getUser (request , response) ;

FileUpload fu = new FileUpload(request);
String method=fu.getParameter("method");
String meetingid=Util.null2String(fu.getParameter("meetingid"));

int code=-1024;
if("saveRemark".equals(method)){
	String signId=fu.getParameter("signId");
	String remark=fu.getParameter("remark");
	code=MeetingSignUtil.signMeetingConfirm(Util.getIntValue(signId),user,remark);
}else{
	if(meetingid.indexOf("/mobile/plugin/5/meetingsign.jsp?meetingid=")>-1){
		meetingid=meetingid.substring("/mobile/plugin/5/meetingsign.jsp?meetingid=".length());
	}
	code=MeetingSignUtil.signMeeting(meetingid,user);
}

String signmsg="";
if(code==0){
	signmsg=SystemEnv.getHtmlLabelName(129698,user.getLanguage());
}else if(code==-1){
	signmsg=SystemEnv.getHtmlLabelName(129699,user.getLanguage());
}else if(code==-2){
	signmsg=SystemEnv.getHtmlLabelName(129700,user.getLanguage());
}else if(code==-3){
	signmsg=SystemEnv.getHtmlLabelName(129701,user.getLanguage());
}else if(code==-4){
	signmsg=SystemEnv.getHtmlLabelName(129702,user.getLanguage());
}else if(code==-5){
	int minute=Util.getIntValue(rs.getPropValue("meetingSign", "minute"));
	minute=minute<0?0:minute;
	signmsg=SystemEnv.getHtmlLabelName(129704,user.getLanguage())+minute+SystemEnv.getHtmlLabelName(129705,user.getLanguage());
}else if(code==-6){
	signmsg=SystemEnv.getHtmlLabelName(129706,user.getLanguage());
}else if(code==-7){
	signmsg=SystemEnv.getHtmlLabelName(129707,user.getLanguage());
}else if(code==-8){
	signmsg=SystemEnv.getHtmlLabelName(129708,user.getLanguage());
}else if(code>0){
	//非参会人员签到.
}else if(code==-1024){
	signmsg=SystemEnv.getHtmlLabelName(129709,user.getLanguage());
}else{
	signmsg=SystemEnv.getHtmlLabelName(129710,user.getLanguage());
}


 
 %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta name="viewport" content="width=device-width, initial-scale=1" />
<title></title>
<link rel="stylesheet" href="/wechat/css/jquery.mobile-1.1.1.min_wev8.css" />
<style>/* App custom styles */</style>
<script	src="/wechat/js/jquery-1.7.1.min_wev8.js"></script>
<script	src="/wechatjs/custom-jqm-mobileinit_wev8.js"></script>
<script	src="/wechat/js/jquery.mobile-1.1.1.min_wev8.js"></script>
</head>
	<body>
        <!-- Home -->
		<div data-role="page" id="page1">
		    <div data-role="content">
				<%if(code>0){%>
		        <form id="loginForm" action="meetingsign.jsp" method="POST">
	                <input name="method" value="saveRemark" type="hidden">
					<input name="signId" value="<%=code%>" type="hidden">
					<input name="meetingid" id="meetingid" value="<%=meetingid %>" type="hidden">
		            <div data-role="fieldcontain">
		                <textarea name="remark" id="remark" placeholder="<%=SystemEnv.getHtmlLabelName(129711,user.getLanguage()) %>"></textarea>
		            </div>
		            <input type="button" data-theme="b" value="<%=SystemEnv.getHtmlLabelName(615,user.getLanguage()) %>" onclick="checkLogin()">
					<div data-role="fieldcontain" id="errormsg" style="color:red;" align="center">
		            </div>
		        </form>
				<%}else{%>
				<div data-role="fieldcontain" id="signmsg" style='<%=code<0?"color:red;":""%>' align="center">
					<%=signmsg%>
		        </div>
				<%}%>
		    </div>
		</div>
    </body>
     <script>
     function checkLogin(){
		 $('#errormsg').html("");
		 if($('#remark').val()==""){
			$('#errormsg').html("<%=SystemEnv.getHtmlLabelName(129711,user.getLanguage())%>");
			return false;
		 }
     	 $('#loginForm').submit();
     }
      </script>
</html>