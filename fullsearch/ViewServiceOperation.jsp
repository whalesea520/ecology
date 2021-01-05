
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.fullsearch.interfaces.rmi.SearchRmi"%>
<%@page import="weaver.fullsearch.interfaces.service.SearchRmiService"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
	String operate=request.getParameter("operate");
	User user = HrmUserVarify.getUser(request, response);
	if(user==null) return;
	if("createIndex".equals(operate)){
		if(!HrmUserVarify.checkUserRight("eAssistant:server", user))
		{
			out.print(false);
			return;
		}
	    SearchRmi localISearcher = SearchRmiService.getSearchRmi();
	    Map paraMap = new HashMap(); 
	    paraMap.put("action", "createIndex");
	  	paraMap.put("date", "2015-04");
	  	paraMap.put("contentType", "CSER");
	  	paraMap.put("loginid", user.getLoginid());
		paraMap.put("language", user.getLanguage());
	 
		if(localISearcher == null){
			out.print(SystemEnv.getHtmlLabelName(83416,user.getLanguage()));
		} else {
			Map map = localISearcher.creatIndex(paraMap);
			out.print(map.get("info"));
		}
	    return;
	}
%>
