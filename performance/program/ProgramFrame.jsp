<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
	//是否含有下属人员
	int hassub = weaver.workrelate.util.TransUtil.hassub(user.getUID()+"");

	int showsub = Util.getIntValue(request.getParameter("showsub"),1);
	if(showsub==1) showsub = hassub;
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
	"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="zh-CN" lang="zh-CN">
	<head>
		<title>绩效考核方案</title>
		<meta http-equiv="content-type" content="text/html; charset=UTF-8" />
		<link href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET />
	<%@ include file="/secondwev/common/head.jsp" %>
	</head>
</html>
<frameset id="MainFrameSet" <%if(hassub==1 && showsub==1){ %>cols="180,8,*"<%}else{ %>cols="0,8,*"<%} %> border="0">
	<frame src="../util/CommOrg.jsp?type=1&hassub=<%=hassub %>" name="pageLeft" />
	<frame src="../util/Toggle.jsp?hassub=<%=showsub %>" noresize="yes"/>
	<frame src="ProgramView.jsp?<%=TimeUtil.getOnlyCurrentTimeString() %>" name="pageRight" />
</frameset>
