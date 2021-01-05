<%@page import="weaver.general.BaseBean"%>
<%@page import="weaver.file.FileUpload"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<jsp:useBean id="mailSend" class="weaver.email.MailSend" scope="page" />
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<%
	 String isSent = "";
	 String folderid="";
	 String isInternal="";
	 String type="";
	 String menuid="";
	 String module="";
	 String scope="";
	 try{
		isSent = mailSend.sendMail(request, user) ;
	}catch(Exception e){
		e.printStackTrace();
		isSent="false";
	}
	folderid=mailSend.getFolderId();
	isInternal=mailSend.getIsInternal()+"";
	type=mailSend.getType();
	menuid=mailSend.getMenuid();
	module=mailSend.getModule();
	scope=mailSend.getScope();
	//手机版本不能重定向，重定向就报错
	String jie="/mobile/plugin/email/EmailDone.jsp?isSent="+isSent+"&folderid="+folderid+"&isInternal="+isInternal+"&type="+type+"&menuid="+menuid+"&module"+module+"&scope="+scope+"";
	//response.sendRedirect("/mobile/plugin/email/EmailDone.jsp?isSent="+isSent+"&folderid="+folderid+"&isInternal="+isInternal+"&type="+type+"&menuid="+menuid);
%>
<script>
		window.location.href="<%=jie%>";
</script>