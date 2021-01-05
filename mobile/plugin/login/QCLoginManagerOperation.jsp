
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>

<jsp:useBean id="qrCode" class="weaver.mobile.plugin.ecology.QRCodeComInfo" scope="page"/>
<%
String loginkey = request.getParameter("loginkey");


User user = HrmUserVarify.getUser (request , response) ;
if(user==null) {
	response.getWriter().write("0");
    return;
}


String operateflag = request.getParameter("operateflag");
if (loginkey != null && !"".equals(loginkey)) {
	String retStr = "1";
	//qrCode.addQRCodeComInfo(loginkey, user); //标准方式
	qrCode.insertUserToDb(loginkey, user);//db方式

//	application.setAttribute(loginkey, user);
	response.getWriter().write(retStr);
} else {
	response.getWriter().write("0");
}
%>
