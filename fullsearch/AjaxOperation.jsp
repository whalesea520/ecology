<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.general.Util"%>
<%@page import="weaver.fullsearch.dao.SearchSetDao"%>
<%@page import="weaver.fullsearch.dao.ViewSetDao"%>

<%
//用于
User user = HrmUserVarify.getUser (request , response) ;

if(user == null)  return ;

String method=Util.null2String(request.getParameter("method"));
if("saveSet".equals(method)){
	//记录条数
	ViewSetDao vsDao=new ViewSetDao();
	int numperpage=Util.getIntValue(Util.null2String(request.getParameter("numperpage")),10);
	vsDao.setNumPerPge(user.getUID(),numperpage);
	//高级设置
	SearchSetDao ssDao=new SearchSetDao();
	int searchField=Util.getIntValue(Util.null2String(request.getParameter("searchField")),0);
	int sortField=Util.getIntValue(Util.null2String(request.getParameter("sortField")),0);
	ssDao.createOrUpdate(user.getUID(),searchField,sortField);
}


%>
