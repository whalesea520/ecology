
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<%

String src = "MailInBox.jsp?receivemail=true";
String act = Util.null2String(request.getParameter("act"));

if(true){
	response.sendRedirect("/email/new/MailFrame.jsp?act="+act);
	return ;
}

if(act.equals("search")){
	src = "MailSearch.jsp?act=" + act;
}else if(act.equals("add")){
	src = "MailAdd.jsp";
}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
	"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> 
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="zh-CN" lang="zh-CN"> 
<head>
<title></title>
<meta http-equiv="content-type" content="text/html; charset=UTF-8" />
<link rel="stylesheet" type="text/css" href="" />
</head>
</html>
<frameset id="mailFrameSet" cols="160,8,*" border="0">
	<frame src="MailMenu.jsp" name="mailFrameLeft" frameborder=no />
	<frame src="MailToggle.jsp" frameborder=no scrolling=no />  
	<frame src="" name="mailFrameRight" id="mailFrameRight" frameborder=no />
</frameset>
