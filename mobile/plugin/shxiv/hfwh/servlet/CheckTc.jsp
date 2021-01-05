<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.file.FileUploadToPath" %>
<%@ page import="com.weaver.general.Util" %>
<%@ page import="com.shxiv.hfwh.service.MainServiceImpl" %>
<%
    FileUploadToPath fu = new FileUploadToPath(request) ;
    String userId= Util.null2String(fu.getParameter("userId"));
    String tcId= Util.null2String(fu.getParameter("tcId"));
    String tcIp= Util.null2String(fu.getParameter("tcIp"));
    String tpbm= Util.null2String(fu.getParameter("tpbm"));
    String tpmc= Util.null2String(fu.getParameter("tpmc"));
    boolean result=false;
    MainServiceImpl mainService=new MainServiceImpl();
    result=mainService.checkTc(userId,tcIp,tcId,tpbm,tpmc);
    //by Zsd end
    out.print(result);
%>



