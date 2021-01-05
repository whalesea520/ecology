<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.file.FileUploadToPath" %>
<%@ page import="com.weaver.general.Util" %>
<%@ page import="com.shxiv.hfwh.service.MainServiceImpl" %>
<%
    FileUploadToPath fu = new FileUploadToPath(request) ;
    String userId= Util.null2String(fu.getParameter("userId"));
    String result="";
    MainServiceImpl mainService=new MainServiceImpl();
    result=mainService.getXsMsg(userId);
    /*Log logs= LogFactory.getLog("调试：");
    logs.error("结果："+result);*/
    //by Zsd end
    out.print(result);
%>




