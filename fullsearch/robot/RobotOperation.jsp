
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
	if("state".equals(operate)){//禁用,启用
		String state=request.getParameter("state");
		String id=request.getParameter("id");
		if("0".equals(state)){//启用公众平台
			//判断账号等是否正常
			String temStr = "update FullSearch_Robot set state='0' where id = "+id;
			if(rs.executeSql(temStr)){
				out.print(true);
			}else{
				out.print(false);
			}
		}else{
			String temStr = "update FullSearch_Robot set state='1' where id = "+id;
			if(rs.executeSql(temStr)){
				out.print(true);
			}else{
				out.print(false);
			}
		}
	}else if("delReceiveEvent".equals(operate)){
		 
	}else if("createIndex".equals(operate)){
		if(!HrmUserVarify.checkUserRight("searchIndex:manager", user))
		{
			out.print(false);
			return;
		}
	    SearchRmi localISearcher = SearchRmiService.getSearchRmi();
	    Map paraMap = new HashMap(); 
	    paraMap.put("action", "createIndex");
	  	paraMap.put("date", "2015-04");
	  	paraMap.put("contentType", "ROBOT");
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
