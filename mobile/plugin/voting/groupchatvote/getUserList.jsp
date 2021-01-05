<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%
      int listType = Util.getIntValue(request.getParameter("listType"),0); //0-已投票，1-未投票，2-某选项
      
      String url = "/voting/groupchatvote/VotingOperator.jsp";
      
      switch(listType){
         case 0 :
             url += "?method=groupuser&usertype=0";
             break;
         case 1 :
             url += "?method=groupuser&usertype=1";
             break;
         case 2 : 
             url += "?method=optiondetail";
             break;
      }
      
      request.getRequestDispatcher(url).forward(request, response);
 %>