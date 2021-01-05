<%@ page contentType="text/html; charset=UTF-8" %>

<%@ page import="weaver.workflow.request.RevisionServer" %>
<%@ page import="weaver.workflow.request.RevisionDbServer" %>

<%
try{
    RevisionServer res = new RevisionDbServer(request,response);
    out.clear() ;
    res.doCommand();
}catch(Exception ex){
    throw ex;
}
%>