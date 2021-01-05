
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<%
String src = "CustomerIntentList.jsp";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
	"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> 
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="zh-CN" lang="zh-CN"> 
<head>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<title></title>
<meta http-equiv="content-type" content="text/html; charset=UTF-8" />
<link rel="stylesheet" type="text/css" href="" />
</head>
</html>
<frameset id="top" rows="27,*" border="0">
		<frame name="top" scrolling="no"  src="BaseItemTop.jsp" >
		<frameset id="mailFrameSet" cols="160,6,*" border="0">
			<frame src="BaseItemMenu.jsp" name="pageLeft" />
			<frame src="/email/MailToggle.jsp" noresize="noresize"/>
			<frame src="<%=src%>" name="pageRight" />
		</frameset>
	</frameset>
