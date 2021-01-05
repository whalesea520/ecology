<%@ page import="java.util.*"%>
<%@ page import="weaver.general.Util"%>
<%@ page import="weaver.hrm.HrmUserVarify"%>
<%@ page import="weaver.hrm.User"%>
<%@ page import="weaver.systeminfo.SystemEnv"%>
<%@ page import="weaver.formmode.ThreadLocalUser"%>
<%@page import="weaver.systeminfo.systemright.CheckSubCompanyRight"%>
<%@page import="java.io.IOException"%>
<%
int isIncludeToptitle = 0;
User user = HrmUserVarify.getUser (request , response) ;
if(user==null) {
    response.sendRedirect("/login/Login.jsp");
    return;
}
ThreadLocalUser.setUser(user);
%>
<%@ include file="/formmode/pub_function.jsp"%>