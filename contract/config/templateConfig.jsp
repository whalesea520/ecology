<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page language="java" import="weaver.contractn.util.Constant" pageEncoding="UTF-8"%>
<jsp:useBean id="template" class="weaver.contractn.serviceImpl.TemplateServiceImpl" scope="page" />
<%

	out.print(template.queryFieldByTableName(Constant.INFO_TABLENAME).toString());

%>
