<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp"%>
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<% 
	//判断是否有权限
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
	"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> 
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="zh-CN" lang="zh-CN"> 
<head>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<title>目标管理基础设置</title>
<meta http-equiv="content-type" content="text/html; charset=UTF-8" />
<link rel="stylesheet" type="text/css" href="" />
<%@ include file="/secondwev/common/head.jsp" %>
	</head>
	<body style="overflow: hidden;" id="bodyId">
	    <div id="dLeft" style="width:200px;height:100%;background: #fff;float:left;">
			<iframe name="pageLeft" src="Right_Left.jsp" style="width: 100%;height:100%;" scrolling="auto" frameborder="0"></iframe>
	    </div>
		<div id="dCenter" style="width:8px;height:100%;background: #fff;float:left;">
			<iframe name="pageCenter" src="../util/Toggle.jsp?iframeset=1" style="width: 100%;height:100%;" scrolling="auto" frameborder="0"></iframe>
		</div>
		<div id="dRight" style="height:100%;background: #fff;float:right;">
			<iframe name="pageRight" src="BaseSetting.jsp" style="width: 100%;height:100%;" scrolling="auto" frameborder="0"></iframe>
		</div>
	<script type="text/javascript">
			$(document).ready(function(){
			    //$("#dLeft").width("200px");
			    $("#dRight").width($("BODY").width()-$("#dCenter").width()-$("#dLeft").width());
			    $(window).resize(function(){
				   $("#dRight").width($("BODY").width()-$("#dCenter").width()-$("#dLeft").width());
			    });
			});
		</script>
	</body>
</html>