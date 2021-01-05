
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<jsp:useBean id="BaseBean" class="weaver.general.BaseBean" scope="page" />
<%
	String mServerName="OfficeServer.jsp";
	String mClientName=BaseBean.getPropValue("weaver_obj","iWebOfficeClientName");
    if(mClientName==null||mClientName.trim().equals("")){
		mClientName="iWebOffice2003.ocx#version=6,6,0,0";
	}
	String mClassId=BaseBean.getPropValue("weaver_obj","iWebOfficeClassId");
    if(mClassId==null||mClassId.trim().equals("")){
		mClassId="clsid:23739A7E-5741-4D1C-88D5-D50B18F7C347";
	}
	boolean isIWebOffice2006 = (mClientName.indexOf("iWebOffice2006")>-1||mClientName.indexOf("iWebOffice2009")>-1)?true:false;
	boolean isIWebOffice2003 = (mClientName.indexOf("iWebOffice2003")>-1)?true:false;
	boolean isIWebOffice2009 = (mClientName.indexOf("iWebOffice2009")>-1)?true:false;
    String isHandWriteForIWebOffice2009=BaseBean.getPropValue("weaver_obj","isHandWriteForIWebOffice2009");
	String isNoComment="";
	if(isIWebOffice2006){
		isNoComment="1".equals(isHandWriteForIWebOffice2009)?"false":"true";
	}
    String isUseET=BaseBean.getPropValue("weaver_obj","isUseET");
%>