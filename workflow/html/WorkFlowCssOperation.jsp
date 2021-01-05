
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="cssFileManager" class="weaver.workflow.html.CssFileManager" scope="page" />
<%
if(!HrmUserVarify.checkUserRight("WorkflowManage:All", user)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}
int id = Util.getIntValue(request.getParameter("cssid"));//id是保留字符，所以没办法用
String opttype = Util.null2String(request.getParameter("opttype"));
String isadd = Util.null2String(request.getParameter("isadd"));
if("save".equals(opttype)){
	id = cssFileManager.updateCssDetail(request);
	if("1".equals(isadd)){
		response.sendRedirect("/workflow/html/WorkFlowCssListTab.jsp");
	}else{
		response.sendRedirect("/workflow/html/WorkFlowCssList.jsp");		
	}	
	return;
}else if("delete".equals(opttype)){
	cssFileManager.deleteCssFiles(""+id);
	response.sendRedirect("/workflow/html/WorkFlowCssListTab.jsp");
	return;
}

%>