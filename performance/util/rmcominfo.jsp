<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<jsp:useBean id="AccessItemComInfo" class="weaver.gp.cominfo.AccessItemComInfo" scope="page" />
<%
AccessItemComInfo.removeCache();
%>
考核指标项缓存已清除！
