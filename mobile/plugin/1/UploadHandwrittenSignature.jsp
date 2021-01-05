<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.file.FileUpload" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> 
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="HandwrittenSignatureManager" class="weaver.mobile.webservices.workflow.soa.HandwrittenSignatureManager" scope="page" />
<%
	HandwrittenSignatureManager.resetParameter();
	String opera = HandwrittenSignatureManager.UploadHandwrittenSignature(request);
	response.sendRedirect("HandwrittenSignatureList.jsp");
%>
