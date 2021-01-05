
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="weaver.general.*" %>
<%
request.setCharacterEncoding("UTF-8");
response.setContentType("text/html;charset=UTF-8");
String location = Util.null2String(request.getParameter("location"));
String userInfo = Util.null2String(request.getParameter("userInfo"));
String returnSre = "";
if(!"".equals(location)){
    String[] infos = location.split(",");
    if(infos.length == 4){
        returnSre +="emoible:openaddress";
        returnSre +=":" + infos[1];
        returnSre +=":" + infos[2];
        returnSre +=":" + infos[3];
    }
    out.println(returnSre);
}
if(!"".equals(userInfo)){
    returnSre = userInfo;
    out.println(returnSre);
}
%>