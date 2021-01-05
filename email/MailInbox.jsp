
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
response.setHeader("Cache-Control","no-store");
response.setHeader("Pragrma","no-cache");
response.setDateHeader("Expires",0);

String receivemail = Util.null2String(request.getParameter("receivemail"));

int userLayout = 0;
rs.executeSql("SELECT layout FROM MailSetting WHERE userId="+user.getUID()+"");
if(rs.next()){
	userLayout = rs.getInt("layout");
}

int folderId = Util.getIntValue(request.getParameter("groupId"), 0);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
	"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> 
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="zh-CN" lang="zh-CN"> 
<head>
<title></title>
<meta http-equiv="content-type" content="text/html; charset=UTF-8" />
</head>
</html>
<%if(userLayout==1){//上下排列%>
<frameset rows="40%,60%" border="1">
	<frame src="MailInboxList.jsp?folderId=<%=folderId%>&receivemail=<%=receivemail%>" name="mailInboxLeft" />
	<frame src="MailView.jsp?folderId=<%=folderId%>&receivemail=<%=receivemail%>" name="mailInboxRight" id="mailInboxRight" style="border-top:3px solid #B3B3B3" />
</frameset>
<%}else if(userLayout==2){//左右排列%>
<frameset cols="45%,55%" border="1">
	<frame src="MailInboxList.jsp?folderId=<%=folderId%>&receivemail=<%=receivemail%>" name="mailInboxLeft" />
	<frame src="MailView.jsp?folderId=<%=folderId%>" name="mailInboxRight" id="mailInboxRight" style="border-left:3px solid #B3B3B3" />
</frameset>
<%}else{//平铺
	response.sendRedirect("MailInboxList.jsp?folderId="+folderId+"&receivemail="+receivemail);
}
%>