<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.file.FileUploadToPath" %>
<%@ page import="com.weaver.general.Util" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="com.shxiv.hfwh.service.dto.MessageDto" %>
<%@ page import="com.shxiv.hfwh.service.MainServiceImpl" %>
<%@ page import="com.google.gson.Gson" %>
<%@ page import="org.apache.commons.logging.LogFactory" %>
<%@ page import="org.apache.commons.logging.Log" %>
<%
    /*Log log= LogFactory.getLog("图库信息：");*/
    FileUploadToPath fu = new FileUploadToPath(request) ;
    String userId= Util.null2String(fu.getParameter("userId"));
    String name= Util.null2String(fu.getParameter("name"));
    String xs= Util.null2String(fu.getParameter("zt"));
    String tkb= Util.null2String(fu.getParameter("tkb"));
    //by Zsd begin
    List<MessageDto> list=new ArrayList<MessageDto>();
    MainServiceImpl mainService=new MainServiceImpl();
    list=mainService.getTkMsg(userId,name,xs,tkb);
    //by Zsd end
    Gson gson = new Gson();
    String jsonStr = gson.toJson(list);
    out.print(jsonStr);
%>



