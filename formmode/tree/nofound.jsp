<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<HTML>
<HEAD>
<LINK rel="stylesheet" type="text/css" href="/css/Weaver_wev8.css">
</HEAD>

<%
String titlename = SystemEnv.getHtmlLabelName(2011,user.getLanguage())+"...";//没有权限
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<div style="width:100%;position:absolute;top:20%;text-align:center;vertical-align:middle;">
	<img src="/images/ecology8/noright_wev8.png" width="162px" height="162px"/>
	<span class="info"><%=SystemEnv.getHtmlLabelName(82272,user.getLanguage())%><!-- 根据树形treesqlwhere条件未找到对应模块数据！ --></span>
</div>
    
  

</BODY>
<style type="text/css">
	.info{
		padding:10px;
		padding-left:30px;
	    color: #8e8e8e;
	    display: block;
	    font-size: 16px;
	    font-weight: normal;
	    margin: 0;
	}
</style>
</HTML>