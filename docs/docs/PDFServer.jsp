<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.io.*" %>
<%@ page import="java.text.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.docs.docs.*" %>
<%
User user = HrmUserVarify.getUser (request , response) ;
if(user == null)  return ;
try{
    PDFServer ps = new PDFServer(request,response);
    out.clear() ;
    ps.doCommand();
}catch(Exception ex){
    throw ex;
}
%>