<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="DocUtil" class="weaver.docs.docs.DocUtil" scope="page" />
<%
	int secid = Util.getIntValue(request.getParameter("secid"),0);
	int maxUploadImageSize = DocUtil.getMaxUploadImageSize(secid);
	out.println(maxUploadImageSize);
%>
