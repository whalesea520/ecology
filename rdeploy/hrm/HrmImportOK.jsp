<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.general.Util"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
String result = Util.null2String(request.getParameter("result"));
String sumRecord = Util.null2String(request.getParameter("sumRecord"));
String successRecord = Util.null2String(request.getParameter("successRecord"));
%>
<script type="text/javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<script type="text/javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script type="text/javascript">
var parentWin = parent.getParentWindow(window);
if("<%=result%>"=="1"){
	<%if(successRecord.equals("0")){%>
	window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(125328,user.getLanguage())%>！");
	<%}else{%>
	window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(83698,user.getLanguage())+sumRecord+SystemEnv.getHtmlLabelName(125330,user.getLanguage()) %>,<%=successRecord+SystemEnv.getHtmlLabelName(125331,user.getLanguage())%>！");
	<%}%>
	parentWin.closeDialog();
}
</script>