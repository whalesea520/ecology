<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="weaver.formmode.reply.InitCommentModule"%>
<%@page import="weaver.conn.RecordSet"%>
<%@page import="weaver.general.Util"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<%
User user = HrmUserVarify.getUser (request , response) ;
if (!HrmUserVarify.checkUserRight("ModeSetting:All", user)) {
	response.sendRedirect("/notice/noright.jsp");
	return;
}
RecordSet rs = new RecordSet();
String operate = Util.null2String(request.getParameter("operate"));
InitCommentModule initCommentModule = new InitCommentModule();
if(operate.equals("checkIsInitReplyToComment")){
	 rs.executeSql("select * from modeinfo where formid in (select id from workflow_bill where tablename='uf_Reply') and isdelete=0");
	 if(rs.getCounts()>0){
		 out.print(1);
		 return;
	 }
	 out.print(0);
}else if(operate.equals("initReplyToComment")){
	  initCommentModule.setUser(user);
	  initCommentModule.setRequest(request);
	  initCommentModule.intFormMode();
}
%>
