<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp"%>
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
	"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="zh-CN" lang="zh-CN">
	<head>
		<title>绩效考核基础设置</title>
		<meta http-equiv="content-type" content="text/html; charset=UTF-8" />
		<link href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET />
	<%@ include file="/secondwev/common/head.jsp" %>
	</head>
</html>
<frameset id="MainFrameSet" cols="180,8,*" border="0">
	<frame src="BaseOrg.jsp" name="pageLeft" />
	<frame src="../util/Toggle.jsp" noresize="yes"/>
	<frame src="BaseInit.jsp" name="pageRight" />
</frameset>
