<%@page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.email.MailReceiveThread"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.email.MailReciveStatusUtils"%>
<%@page import="weaver.email.MailCommonUtils"%>
<%@page import="weaver.file.Prop"%>
<%	
    String isTimeOutLogin1 = Prop.getPropValue("Others","isTimeOutLogin");
    if("2".equals(isTimeOutLogin1)){
        return;
    }

    if (MailReciveStatusUtils.isCanExecAutoRecive()) {
        User user = HrmUserVarify.getUser(request, response) ;
		MailReceiveThread mailReceiveThread = new MailReceiveThread();
		mailReceiveThread.setUser(user);
    	MailCommonUtils.mailReceivePool.execute(mailReceiveThread);
    }
%>