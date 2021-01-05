<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<jsp:useBean id="DocChangeManager" class="weaver.docs.change.DocChangeManager" scope="page" />
<%@ include file="/systeminfo/init_wev8.jsp" %>
<% 
if(!HrmUserVarify.checkUserRight("DocChange:Setting", user)){
	response.sendRedirect("/notice/noright.jsp");
    return;
}
%>

<%
boolean isok = DocChangeManager.saveChangeFields(request, user.getUID());
if(isok) {
%>
<script>
//top.Dialog.alert('<%=SystemEnv.getHtmlLabelName(18758,user.getLanguage())%>');
location.href = 'DocChangeField.jsp?isEdit=1&isclose=1&&wfid=<%=request.getParameter("wfid")%>&changeid=<%=request.getParameter("changeid")%>';
</script>
<%
}
else {
%>
<script>
top.Dialog.alert('<%=SystemEnv.getHtmlLabelName(21809,user.getLanguage())%>');
location.href = 'DocChangeField.jsp?isEdit=1&wfid=<%=request.getParameter("wfid")%>&changeid=<%=request.getParameter("changeid")%>';
</script>
<%
}
%>