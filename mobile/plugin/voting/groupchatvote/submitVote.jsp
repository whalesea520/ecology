<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%
    String selectIds = Util.null2String(request.getParameter("selectIds"));
   
    request.getRequestDispatcher("/voting/groupchatvote/VotingOperator.jsp?method=voteresult&votooptioncheck=" + selectIds)
        .forward(request, response);
%>