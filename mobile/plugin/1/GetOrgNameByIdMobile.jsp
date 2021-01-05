
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.hrm.HrmUserVarify" %>
<%@ page import="weaver.hrm.User" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
User user = HrmUserVarify.getUser(request, response) ;
if(user==null){
    response.sendRedirect("/notice/noright.jsp") ;
    return ;
}
    request.getRequestDispatcher("/workflow/request/GetOrgNameById.jsp").forward(request,response);
%>