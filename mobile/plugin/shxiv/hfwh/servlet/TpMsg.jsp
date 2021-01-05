<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.file.FileUploadToPath" %>
<%@ page import="com.weaver.general.Util" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="com.shxiv.hfwh.service.dto.MessageDto" %>
<%@ page import="com.shxiv.hfwh.service.MainServiceImpl" %>
<%@ page import="com.google.gson.Gson" %>
<%
    FileUploadToPath fu = new FileUploadToPath(request) ;
    String userId= Util.null2String(fu.getParameter("userId"));
    String tcId= Util.null2String(fu.getParameter("tcId"));

    //by Zsd begin
    List<MessageDto> list=new ArrayList<MessageDto>();
    MainServiceImpl mainService=new MainServiceImpl();
    list=mainService.getTpMsg(userId,tcId);
    //by Zsd end
    Gson gson = new Gson();
    String jsonStr = gson.toJson(list);
    out.print(jsonStr);
%>



