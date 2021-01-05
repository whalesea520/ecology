<%@ page import="weaver.hrm.HrmUserVarify" %>
<%@ page import="weaver.hrm.User" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%
    User user = HrmUserVarify.getUser(request, response) ;
    if(user==null){
        response.sendRedirect("/notice/noright.jsp") ;
        return ;
}
    request.getRequestDispatcher("/workflow/request/FnaBudgetInfoAjax.jsp").forward(request,response);
%>   
