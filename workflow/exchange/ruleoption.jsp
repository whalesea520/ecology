<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.hrm.*" %>
<%@page import="weaver.workflow.exchange.ExchangeUtil"%>
<%
out.clear();
User user = HrmUserVarify.getUser (request , response) ;
String htmltype = Util.null2String(request.getParameter("htmltype"));
String ruletype =  Util.null2String(request.getParameter("ruletype"));
int isrdata = Util.getIntValue(request.getParameter("isrdata"),0);
int isdetail = Util.getIntValue(request.getParameter("isdetail"),0);
ExchangeUtil ExchangeUtil = new ExchangeUtil();
ExchangeUtil.setLanguageid(user.getLanguage());
out.println(ExchangeUtil.getRuleOption(ruletype,htmltype,isrdata,isdetail));
%>
