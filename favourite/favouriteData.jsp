<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8"%>
<%@page import="weaver.general.Util"%>
<%@page import="weaver.hrm.*" %>
<%@ page import="weaver.systeminfo.*" %>
<jsp:useBean id="browserManager" class="weaver.general.browserData.BrowserManager" scope="page"/>

<%
	User user = HrmUserVarify.getUser (request , response) ;
    String keyName = Util.null2String(request.getParameter("q"));
	String result = "";
	if(!"".equals(keyName)){
		String condition = "resourceid='" + user.getUID() + "'";
		browserManager.setType("favourite");
		String defaultName = result = SystemEnv.getHtmlLabelName(18030,user.getLanguage());   //默认目录，"我的收藏";
		String tableName = " (select id,favouritename from favourite where resourceid='" + user.getUID() + "' "
						 + " union select -1 as id,'" + defaultName + "' as favouritename from favourite) t";   //默认目录在数据库不存在，这样处理，能够通过模糊搜索搜到默认目录
		result = browserManager.getResult(request,"id,favouritename",tableName,"",30);
	}
	out.print(result);
%>
