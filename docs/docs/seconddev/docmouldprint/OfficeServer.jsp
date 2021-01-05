<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.io.*" %>
<%@ page import="java.text.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="weaver.docs.docs.seconddev.docmouldprint.DocMouldServer" %>
<%@ page import="weaver.docs.docs.*" %>
<%@ page import="weaver.hrm.*" %>

<%
User user = HrmUserVarify.getUser (request , response) ;
if(user == null)  return ;
try{
    DocServer dos = new DocMouldServer(request,response);
    out.clear() ;
    dos.doCommand();
}catch(Exception ex){
    throw ex;
}
%>