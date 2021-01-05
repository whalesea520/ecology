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
		<title>工作计划报告审批</title>
		<meta http-equiv="content-type" content="text/html; charset=UTF-8" />
		<link href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET />
	<%@ include file="/secondwev/common/head.jsp" %>
	</head>
	<body style="overflow: hidden;" id="bodyId">
	    <div id="dLeft" style="width:180px;height:100%;background: #fff;float:left;">
			<iframe name="pageLeft" src="AuditOrg.jsp?hassub=<%=hassub %>" style="width: 100%;height:100%;" scrolling="auto" frameborder="0"></iframe>
	    </div>
		<div id="dCenter" style="width:8px;height:100%;background: #fff;float:left;">
			<iframe name="pageCenter" src="../util/Toggle.jsp?iframeset=1&hassub=<%=showsub %>" style="width: 100%;height:100%;" scrolling="auto" frameborder="0"></iframe>
		</div>
		<div id="dRight" style="height:100%;background: #fff;float:right;">
			<iframe name="pageRight" src="AuditList.jsp?<%=TimeUtil.getOnlyCurrentTimeString() %>" style="width: 100%;height:100%;" scrolling="auto" frameborder="0"></iframe>
		</div>
	<script type="text/javascript">
			$(document).ready(function(){
			    if(<%=hassub%>==1 && <%=showsub%>==1){
			       $("#dLeft").width("180px");
			    }else{
			       $("#dLeft").width("0px");
			    }
			    $("#dRight").width($("BODY").width()-$("#dCenter").width()-$("#dLeft").width()-5);
			    $(window).resize(function(){
				   $("#dRight").width($("BODY").width()-$("#dCenter").width()-$("#dLeft").width()-5);
			    });
			});
		</script>
	</body>
</html>