<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.hrm.attendance.manager.HrmPaidLeaveManager"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
HrmPaidLeaveManager aa = new HrmPaidLeaveManager();
aa.initData();
%>