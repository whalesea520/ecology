<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%
    request.getRequestDispatcher("/voting/groupchatvote/VotingOperator.jsp?method=detail")
        .forward(request, response);
%>