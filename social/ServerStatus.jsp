<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="weaver.social.im.SocialImLogin"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<%-- 
     p：
        1、n，客户端正常监测服务器是否正常。
        2、logout,客户端退出。
--%>
<%
    String p = request.getParameter("p");
    if("n".equals(p)) {
        User user = HrmUserVarify.checkUser(request, response);
        if(user != null) {
            //更新PC端登陆时间
            SocialImLogin.updatePCLoginTime(user.getUID());
        }
    } else if("logout".equals(p)) {
        String sessionkey = request.getParameter("sessionkey");
        SocialImLogin.pcLogout(sessionkey);
    }
%>
