
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="weaver.file.Prop" %>
<%@ page import="javax.crypto.spec.DESKeySpec" %>
<%@ page import="javax.crypto.*" %>
<%
	String conStr=Prop.getPropValue("weaver","ecology.url");
%>