<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="MailMouldManager" class="weaver.docs.mail.MailMouldManager" scope="page" />
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
  	}
  	else{
  		if(MailMouldManager.getIsDialog().equals("1")){
	  		response.sendRedirect("DocMouldAdd.jsp?isclose=1");
	  	}else if(MailMouldManager.getIsDialog().equals("2")){
	  		response.sendRedirect("DocMouldEdit.jsp?isclose=1");
	  	}else{
	  		response.sendRedirect("DocMould.jsp");
	  	}
	 }
	
%>
 <input type="button" name="Submit2" value="<%=SystemEnv.getHtmlLabelName(236,user.getLanguage())%>" onClick="javascript:history.go(-1)">