<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.file.FileUploadToPath" %>
<%@ page import="com.weaver.general.Util" %>
<%@ page import="com.shxiv.hfwh.service.MainServiceImpl" %>
<%
    FileUploadToPath fu = new FileUploadToPath(request) ;
    String userId= Util.null2String(fu.getParameter("userId"));
    String tcId= Util.null2String(fu.getParameter("tcId"));
    boolean result=true;
    MainServiceImpl mainService=new MainServiceImpl();
    result=mainService.deleteSc(userId,tcId);
    //by Zsd end
    out.print(result);
%>



