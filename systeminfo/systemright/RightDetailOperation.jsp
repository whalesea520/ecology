<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="CheckUserRight" class="weaver.systeminfo.systemright.CheckUserRight" scope="page" />
<%
  String operation = Util.null2String(request.getParameter("operation"));
  if(operation.equalsIgnoreCase("deleterightdetail")){ 
	String ids[] = request.getParameterValues("delete_rightdetail_id") ;
	if(ids != null) {
		for(int i=0;i<ids.length;i++) {
			if(ids[i] != null) RecordSet.executeProc("SystemRightDetail_Delete",ids[i]);
		}
	}
  }
  else if(operation.equalsIgnoreCase("addrightdetail")){ 
  	String rightdetailname = Util.fromScreen(request.getParameter("rightdetailname"),user.getLanguage());
	String rightdetail = Util.fromScreen(request.getParameter("rightdetail"),user.getLanguage());
	String rightid = Util.null2String(request.getParameter("rightid"));
	char separator = Util.getSeparator() ;
	String rightdetailpara = rightdetailname + separator + rightdetail + separator + rightid  ;
	RecordSet.executeProc("SystemRightDetail_Insert",rightdetailpara);
 }
 else if(operation.equalsIgnoreCase("updaterightdetail")){ 
	String id = Util.null2String(request.getParameter("id"));
  	String rightdetailname = Util.fromScreen(request.getParameter("rightdetailname"),user.getLanguage());
	String rightdetail = Util.fromScreen(request.getParameter("rightdetail"),user.getLanguage());
	String rightid = Util.fromScreen(request.getParameter("rightid"),user.getLanguage());
  	char separator = Util.getSeparator() ;
	String rightdetailpara = id + separator + rightdetailname + separator + rightdetail + separator + rightid ;
	RecordSet.executeProc("SystemRightDetail_Update",rightdetailpara);
 } 
 CheckUserRight.removeRoleRightdetailCache();
 response.sendRedirect("ManageRightDetail.jsp");
%>
