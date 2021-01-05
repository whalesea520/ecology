<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="LanguageComInfo" class="weaver.systeminfo.language.LanguageComInfo" scope="page"/>
<jsp:useBean id="RightComInfo" class="weaver.systeminfo.systemright.RightComInfo" scope="page"/>
<%
  String operation = Util.null2String(request.getParameter("operation"));
  char separator = Util.getSeparator() ;
  if(operation.equalsIgnoreCase("deleteright")){ 
  	String ids[] = request.getParameterValues("delete_right_id") ;
	if(ids != null) {
		for(int i=0;i<ids.length;i++) {
			if(ids[i] != null) RecordSet.executeProc("SystemRights_Delete",ids[i]);
		}
	}
  	RightComInfo.removeRightCache();
  	response.sendRedirect("SystemRight.jsp");
  	return ;
  }
  else if(operation.equalsIgnoreCase("addright")){ 
  	
  	String rightdescown = Util.fromScreen(request.getParameter("rightdescown"),user.getLanguage());
	String righttype = Util.null2String(request.getParameter("righttype"));
  	RecordSet.executeProc("SystemRights_Insert",rightdescown+separator+righttype);
	RecordSet.next();
	String id =RecordSet.getString(1);

	while(LanguageComInfo.next()){
		String langid = LanguageComInfo.getLanguageid();
	  	String rightname = Util.fromScreen(request.getParameter("rightname"+langid),user.getLanguage());
		String rightdesc = Util.fromScreen(request.getParameter("rightdesc"+langid),user.getLanguage());
		String procedurepara=id+separator+langid+separator+rightname+separator+rightdesc ;
	  	RecordSet.executeProc("SystemRightsLanguage_Insert",procedurepara);
	}
	RightComInfo.removeRightCache();
  	response.sendRedirect("SystemRight.jsp");
  	return ;
 }
 else if(operation.equalsIgnoreCase("editright")){ 
  	String rightdescown = Util.fromScreen(request.getParameter("rightdescown"),user.getLanguage());
	String righttype = Util.null2String(request.getParameter("righttype"));
  	String id = Util.null2String(request.getParameter("id"));
  	RecordSet.executeProc("SystemRights_Update",id+separator+rightdescown+separator+righttype);
	
	while(LanguageComInfo.next()){
		String langid = LanguageComInfo.getLanguageid();
	  	String rightname = Util.fromScreen(request.getParameter("rightname"+langid),user.getLanguage());
		String rightdesc = Util.fromScreen(request.getParameter("rightdesc"+langid),user.getLanguage());
		String procedurepara=id+separator+langid+separator+rightname+separator+rightdesc ;
	  	RecordSet.executeProc("SystemRightsLanguage_Update",procedurepara);
	}
	RightComInfo.removeRightCache();
 	response.sendRedirect("SystemRight.jsp");
 	return ;
 }
%>
