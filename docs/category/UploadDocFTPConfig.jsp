
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 


<jsp:useBean id="DocFTPConfigManager" class="weaver.docs.category.DocFTPConfigManager" scope="page" />
<jsp:useBean id="DocFTPConfigComInfo" class="weaver.docs.category.DocFTPConfigComInfo" scope="page" />

<%@ include file="/systeminfo/init_wev8.jsp" %>
<%

  	String message = DocFTPConfigManager.UploadDocFTPConfig(request);
  	DocFTPConfigComInfo.removeCache();

	response.sendRedirect("DocFTPConfig.jsp");

	
%>
