 <%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="java.security.*,weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.SessionOper" %>
<%
    if ((SessionOper.getAttribute(session,"hrm.objId")==null)||((""+SessionOper.getAttribute(session,"hrm.objId")).equals("")))
    {%>
    <script language=javascript>
	alert("系统超时，请重登录")
	window.top.location="/login/Login.jsp"
	</script>
	return;
    <%}
    %>