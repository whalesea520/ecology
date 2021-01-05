<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.docs.office.DocDbServerForAttachment" %>
<%

try{
    DocDbServerForAttachment dos = new DocDbServerForAttachment(request,response);
    out.clear() ;
    dos.doCommand();
}catch(Exception ex){
    throw ex;
}
%>