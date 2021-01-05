<%@ page import="weaver.general.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<%@ page import="weaver.file.Prop" %>
<%@ page import="weaver.filter.MultiLangFilter" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.systeminfo.language.LanguageComInfo" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />

<%
    User user = HrmUserVarify.getUser(request,response);
	boolean canedit = HrmUserVarify.checkUserRight("SystemSetEdit:Edit", user) ;
	if(!canedit){
		response.sendRedirect("/notice/noright.jsp") ;
		return ;
	}
	Object command = request.getParameter("command");
	if(command!=null&&command.toString().equals("refresh")){
		MultiLangFilter.reloadConfig();
		out.print("1");
		return ;
	}
	String activelangs = (String)request.getParameter("activelangs");
	String inactivelangs = (String)request.getParameter("inactivelangs");
    String logswitch  = (String)request.getParameter("logswitch");

	String activesql = "update syslanguage set activable='1' where id in ( "+activelangs+" )";
	String inactivesql = "update syslanguage set activable='0' where id in ( "+inactivelangs+" )";
	RecordSet.executeUpdate(activesql);
	RecordSet.executeUpdate(inactivesql);
	new LanguageComInfo().removeLanguageCache();
	String[] activelangsArray = activelangs.split(",");
	String[] inactivelangsArray = inactivelangs.split(",");

	Prop  prop = Prop.getInstance();
	for(int i=0;i<activelangsArray.length;i++){
		if(Util.getIntValue(activelangsArray[i])==8){
			prop.setPropValue("MutilLanguageProp","EN_LANGUAGE", "1");
		}else if(Util.getIntValue(activelangsArray[i])==9){
			prop.setPropValue("MutilLanguageProp","ZH_TW_LANGUAGE", "1");
		}
	}
	for(int i=0;i<inactivelangsArray.length;i++){
		if(Util.getIntValue(inactivelangsArray[i])==8){
			prop.setPropValue("MutilLanguageProp","EN_LANGUAGE", "0");
		}else if(Util.getIntValue(inactivelangsArray[i])==9){
			prop.setPropValue("MutilLanguageProp","ZH_TW_LANGUAGE", "0");
		}
	}

	if( logswitch!=null && logswitch.trim().equals("1")){
		prop.setPropValue("weaver_multi_lang","isLog", "1");
	}else{
		prop.setPropValue("weaver_multi_lang","isLog", "0");
	}
	MultiLangFilter.reloadConfig();
	response.sendRedirect("managelanguage.jsp");	
%>
