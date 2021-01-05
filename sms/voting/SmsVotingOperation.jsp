
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="weaver.conn.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="smsVotingManager" class="weaver.smsvoting.SmsVotingManager" scope="page" />
<jsp:useBean id="CommunicateLog" class="weaver.sms.CommunicateLog" scope="page" />
<%
if(!HrmUserVarify.checkUserRight("SmsVoting:Manager", user)){
	response.sendRedirect("/notice/noright.jsp");
	return ;
}
int retInt = 0;
String method = Util.null2String(request.getParameter("method"));
int smsvotingid = Util.getIntValue(request.getParameter("id"), 0);
smsVotingManager.setRequest(request);
smsVotingManager.setUser(user);
String ip=Util.getIpAddr(request);
if("add".equalsIgnoreCase(method)){
	retInt = smsVotingManager.addSmsVoting();
	CommunicateLog.resetParameter();
    CommunicateLog.insSysLogInfo(user,retInt,Util.null2String(request.getParameter("subject")),SystemEnv.getHtmlLabelName(1421,user.getLanguage())+SystemEnv.getHtmlLabelName(22304,user.getLanguage()),"397","1",1,ip);
	%>
	<script type="text/javascript">
		var parentWin = null;
		try{
		parentWin = parent.parent.getParentWindow(parent);
		}catch(e){}
		parentWin.closeDlgARfsh();
	</script>
	<%
	return;
}else if("edit".equalsIgnoreCase(method)){
	rs.execute("select * from smsvoting where status=0 and creater="+user.getUID()+" and id="+smsvotingid);
	if(rs.next()){
		retInt = smsVotingManager.editSmsVoting();
	}
	CommunicateLog.resetParameter();
    CommunicateLog.insSysLogInfo(user,smsvotingid,Util.null2String(request.getParameter("subject")),SystemEnv.getHtmlLabelName(103,user.getLanguage())+SystemEnv.getHtmlLabelName(22304,user.getLanguage()),"397","2",1,ip);
	%>
	<script type="text/javascript">
		var parentWin = null;
		try{
		parentWin = parent.parent.getParentWindow(parent);
		}catch(e){}
		parentWin.closeDlgARfsh();
	</script>
	<%
	return;
}else if("delete".equalsIgnoreCase(method)){
	  rs.execute("select * from smsvoting where creater="+user.getUID()+" and id="+smsvotingid);
	  String subject="";
	  if(rs.next()){
		 subject=rs.getString("subject");
		 retInt = smsVotingManager.deleteSmsVoting();
	  }
	  CommunicateLog.resetParameter();
      CommunicateLog.insSysLogInfo(user,smsvotingid,subject,SystemEnv.getHtmlLabelName(91,user.getLanguage())+SystemEnv.getHtmlLabelName(22304,user.getLanguage()),"397","3",1,ip);
	%>
	<script type="text/javascript">
		var parentWin = null;
		try{
		parentWin = parent.getParentWindow(window);
		parentWin.closeDlgARfsh();
		}catch(e){

		}
		
	</script>
	<%
	return;
}else if("end".equalsIgnoreCase(method)){
	rs.execute("select * from smsvoting where creater="+user.getUID()+" and status=1 and id="+smsvotingid);
	String subject="";
	if(rs.next()){
		subject=rs.getString("subject");
		retInt = smsVotingManager.endSmsVoting();
	}
	CommunicateLog.resetParameter();
    CommunicateLog.insSysLogInfo(user,smsvotingid,subject,SystemEnv.getHtmlLabelName(405,user.getLanguage())+SystemEnv.getHtmlLabelName(22304,user.getLanguage()),"397","2",1,ip);
}else if("reopen".equalsIgnoreCase(method)){
	rs.execute("select * from smsvoting where creater="+user.getUID()+" and status=2 and id="+smsvotingid);
	String subject="";
	if(rs.next()){
		subject=rs.getString("subject");
		retInt = smsVotingManager.reopenSmsVoting();
	}
	CommunicateLog.resetParameter();
    CommunicateLog.insSysLogInfo(user,smsvotingid,subject,SystemEnv.getHtmlLabelName(127892,user.getLanguage())+SystemEnv.getHtmlLabelName(22304,user.getLanguage()),"397","2",1,ip);
	%>
	<script type="text/javascript">
		var parentWin = null;
		try{
		parentWin = parent.getParentWindow(window);
		parentWin.closeDlgARfsh();
		}catch(e){}
		
	</script>
	<%
	return;
}




response.sendRedirect("SmsVotingList.jsp");
%>