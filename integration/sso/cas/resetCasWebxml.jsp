<%@ page buffer="4kb" autoFlush="true" errorPage="/notice/error.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="casUtil" class="weaver.interfaces.sso.cas.CasUtil" scope="page" />
<%
if(!HrmUserVarify.checkUserRight("CAS:ALL",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
casUtil.deleteFilter();
out.print("reset web.xml casconfig ok!");
%>
