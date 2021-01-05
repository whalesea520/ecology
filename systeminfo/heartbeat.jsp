<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="weaver.login.LicenseCheckLogin" %>
<%@ page import="weaver.hrm.User"%>
<%@ page import="weaver.hrm.HrmUserVarify"%>
<%
User user = HrmUserVarify.getUser (request , response) ;
if(user==null)return;
LicenseCheckLogin onlineu = new LicenseCheckLogin();//更新人员在线统计时间戳
onlineu.setOutLineDate(user.getUID());
%>
