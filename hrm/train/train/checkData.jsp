<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Timestamp" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<jsp:useBean id="TrainComInfo" class="weaver.hrm.train.TrainComInfo" scope="page" />
<%
User user = HrmUserVarify.getUser(request,response);
if(user == null)  return ;
String operation = Util.fromScreen(request.getParameter("operation"),user.getLanguage());
String id = Util.fromScreen(request.getParameter("id"),user.getLanguage());
  
if(operation.equals("canDelete")){ 
	String[] ids = id.split(",");
	boolean isFinish = false;
    for(int i = 0;i <ids.length;i++){
	    isFinish = TrainComInfo.isFinish(ids[i]);
	    if(isFinish){
	    	isFinish = true;
	    	break;
	    }
    }
    if(isFinish){
    	System.out.println("1");
    	out.print("1");
    	return ;
    }else{
    	out.print("0");
    	return ;
    }
  }
%>