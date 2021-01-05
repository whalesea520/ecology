
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%
String formname=Util.null2String(request.getParameter("formname"));
int formid=Util.getIntValue(Util.null2String(request.getParameter("formid")),0);
%>
<script language="javascript">
parent.upselect("<%=formname%>","<%=formid%>");
</script>
