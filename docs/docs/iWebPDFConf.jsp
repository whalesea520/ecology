
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<jsp:useBean id="BaseBean" class="weaver.general.BaseBean" scope="page" />
<%
	String mServerName="PDFServer.jsp";

	String mClientName=BaseBean.getPropValue("weaver_iWebPDF","iWebPDFClientName");
	if(mClientName==null||mClientName.trim().equals("")){
		mClientName="iWebPDF.ocx#version=7,1,0,206";
	}
	
	String mClassId=BaseBean.getPropValue("weaver_iWebPDF","iWebPDFClassId");
	if(mClassId==null||mClassId.trim().equals("")){
		mClassId="clsid:39E08D82-C8AC-4934-BE07-F6E816FD47A1";
	}

%>