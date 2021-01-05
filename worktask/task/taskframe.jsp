<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<%@ page import="weaver.general.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
	//是否含有下属人员
	int hassub = 0;
	rs.executeSql("select count(id) as amount from hrmresource where loginid<>'' and loginid is not null and (status =0 or status = 1 or status = 2 or status = 3) and managerid=" + user.getUID());
	if (rs.next() && rs.getInt(1) > 0) {
		hassub = 1;
	}
	
	int showsub = Util.getIntValue(request.getParameter("showsub"),1);
	if(showsub==1) showsub = hassub;
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
	"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="zh-CN" lang="zh-CN">
	<head>
		<title><%=SystemEnv.getHtmlLabelName(81944,user.getLanguage())%></title>
		<meta http-equiv="content-type" content="text/html; charset=UTF-8" />
	</head>
</html>
<frameset id="MainFrameSet" cols="0,*" border="0">
	<frame src="/worktask/task/SubordinateTree.jsp?id=<%=user.getUID() %>" id="pageLeft" name="pageLeft" resize="no"/>
	<frame src="/worktask/task/tasktab.jsp?<%=TimeUtil.getOnlyCurrentTimeString() %>" id="pageRight" name="pageRight" />
</frameset>
