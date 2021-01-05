<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="weaver.general.Util"%>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.formmode.reply.InitCommentModule"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<%
User user = HrmUserVarify.getUser (request , response) ;
if (!HrmUserVarify.checkUserRight("ModeSetting:All", user)) {
	response.sendRedirect("/notice/noright.jsp");
	return;
}
int formEngineSetid = Util.getIntValue(request.getParameter("formEngineSetid"),0);
int isEnFormModeReply = Util.getIntValue(request.getParameter("isEnFormModeReply"),0);
InitCommentModule initCommentModule = new InitCommentModule();
if(formEngineSetid==0){
	RecordSet.executeSql("select * from formEngineSet where isdelete=0");
	if(RecordSet.next()){
		formEngineSetid = RecordSet.getInt("id");
		RecordSet.executeSql("update formEngineSet set isEnFormModeReply="+isEnFormModeReply+" where id="+formEngineSetid);
	}else{
		RecordSet.executeSql("insert into formEngineSet(appid,modeid,initformModeReply,isEnFormModeReply,isdelete) values(0,0,0,"+isEnFormModeReply+",0)");
		RecordSet.executeSql("select * from formEngineSet where isdelete=0");
		if(RecordSet.next()){
			formEngineSetid = RecordSet.getInt("id");
		}
	}
}else{
	RecordSet.executeSql("update formEngineSet set isEnFormModeReply="+isEnFormModeReply+" where id="+formEngineSetid);
}
if(isEnFormModeReply==1){
	initCommentModule.setUser(user);
	initCommentModule.setRequest(request);
	initCommentModule.intFormMode(formEngineSetid);
}
response.sendRedirect("/formmode/setup/FormEngineSettings.jsp?formEngineSetid="+formEngineSetid);
%>
