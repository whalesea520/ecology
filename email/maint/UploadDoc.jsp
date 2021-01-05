<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="MailMouldManager" class="weaver.email.MailMouldManager" scope="page" />
<jsp:useBean id="MailMouldComInfo" class="weaver.docs.mail.MailMouldComInfo" scope="page" />
<%
	MailMouldManager.resetParameter();
  	MailMouldManager.setLanguageid(user.getLanguage());
	MailMouldManager.setClientAddress(request.getRemoteAddr());
	MailMouldManager.setUserid(user.getUID());

  	String message = MailMouldManager.UploadMailMould(request);
  	MailMouldComInfo.removeMailMouldCache();
  	if(message.startsWith("delete_")){  		
  		int id=MailMouldManager.getId();
  		String imgid=message.substring(7,8);
  		
  		response.sendRedirect("DocMouldDsp.jsp?messageid="+imgid+"&id="+id);
  		out.println("<script>parent.getParentWindow(window).closeDialog()</script>");
  	}
  	else{
  		if(MailMouldManager.getIsDialog().equals("1")){
  			out.println("<script>parent.getParentWindow(window).closeDialog()</script>");
	  		// response.sendRedirect("DocMouldAdd.jsp?isclose=1");
	  	}else if(MailMouldManager.getIsDialog().equals("2")){
	  		out.println("<script>parent.getParentWindow(window).closeDialog()</script>");
	  	}else{
	  		out.println("<script>parent.getParentWindow(window).closeDialog()</script>");
	  		return;
	  	}
	 }
	
%>
