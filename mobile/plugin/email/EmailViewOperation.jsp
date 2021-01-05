<%@page import="org.apache.commons.lang.time.DateUtils"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.TimeUtil" %>

<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@page import="weaver.email.service.MailResourceService"%> 
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<jsp:useBean id="mss" class="weaver.email.service.MailResourceService" scope="page" />


<%
	
	String operation = Util.null2String(request.getParameter("operation"));
	String[] mailsId = Util.null2String(request.getParameter("mailsId")).split(",");
	String mailId = Util.null2String(request.getParameter("mailId"));
	String lableId = Util.null2String(request.getParameter("lableId"));
	String star = Util.null2String(request.getParameter("star"));
	String movetoFolder = Util.null2String(request.getParameter("movetoFolder"));
	String status = Util.null2String(request.getParameter("status"));
	if(operation.equals("addLable")) {
		mss.addLable(mailsId, lableId);
	} else if(operation.equals("removeLable")) {
		mss.removeLable(mailId, lableId);
	} else if(operation.equals("updateStar")) {
		mss.updateStar(mailId, star);
	}else if(operation.equals("move")){
		mss.moveMailToFolder(mailId, movetoFolder);
	}else if(operation.equals("delete")){
		 String emlPath=application.getRealPath("")+"email\\eml\\";
		// System.out.println(emlPath);
		 mss.deleteMail(mailId,user.getUID(),emlPath);
	}else if(operation.equals("updateStatus")){
		
		mss.updateMailResourceStatus(status,mailId,user.getUID());
	}else if(operation.equals("delMail")){
		MailResourceService mrs=new MailResourceService(); 
		String emlPath=application.getRealPath("")+"email\\eml\\";
		mrs.deleteMail(mailId,user.getUID(),emlPath);
	}
%>