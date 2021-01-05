<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp"%>
<%
	int type = Util.getIntValue(request.getParameter("type"),1);
	String defaultpage = "BaseFrame.jsp";
	if(type==2){
		defaultpage = "AccessItemList.jsp";
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
	"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="zh-CN" lang="zh-CN">
	<head>
		<title>绩效考核方案基础设置</title>
		<meta http-equiv="content-type" content="text/html; charset=UTF-8" />
		<link href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET />
	<%@ include file="/secondwev/common/head.jsp" %>
	</head>
</html>
<frameset id="MainFrameSet" rows="36,*" border="0">
	<frame src="BaseMenu.jsp?type=<%=type %>" name="pageTop" resize="no"/>
	<frame src="<%=defaultpage %>" name="pageBottom" />
</frameset>
