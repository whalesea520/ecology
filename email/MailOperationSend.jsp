
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<jsp:useBean id="mailSend" class="weaver.email.MailSend" scope="page" />
<%@ include file="/page/maint/common/initNoCache.jsp" %>

<%

String isSent = "";
try{
	isSent = mailSend.sendMail(request, user) ;
}catch(Exception e){
	out.println(e);
	e.printStackTrace();
	return;
}

request.setAttribute("isSent", isSent);
request.setAttribute("errorMess",mailSend.getErrorMessInfo());
request.setAttribute("mailaccid",Util.getIntValue(request.getParameter("mailAccountId")));
//out.println(isSent);
String savedraft =mailSend.getSavedraft();
String autoSave = mailSend.getAutoSave();
String timingsubmitType = mailSend.getTimingsubmitType();
String timingdate = "";
if("1".equals(autoSave)&&!"submit".equals(timingsubmitType)) {
	out.print(mailSend.getMailId()+"");
	return;
}


if("false".equals(isSent)){
	request.getRequestDispatcher("/email/new/MailDone.jsp").forward(request, response);
	return;
}
else if("submit".equals(timingsubmitType)){
	response.sendRedirect("/email/new/MailDone.jsp?isSent=timingdate");
	return;
}
else if(savedraft.equals("1") && "".equals(timingdate)){
	response.sendRedirect("/email/new/MailAdd.jsp?flag=4&id="+mailSend.getMailId());
	return;
	
}else{
	request.getRequestDispatcher("/email/new/MailDone.jsp").forward(request, response);
}
%>
