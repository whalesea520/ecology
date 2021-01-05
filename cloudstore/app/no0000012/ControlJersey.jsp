<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ page import="com.cloudstore.app.no0000012.controller.Action_Controller" %>
<%@ page import="com.cloudstore.api.util.Util_Log"%>
 <%
 Util_Log l = new Util_Log();
 l.write("in Control Jersey");
 Action_Controller ac=new Action_Controller();
 String result = ac.execute(request, response);
 l.write("out Control Jersey");
 out.print(result);
 %>
  