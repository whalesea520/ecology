<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.net.URLDecoder"%>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rc" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<%
	String clienttype = Util.null2String((String)request.getParameter("clienttype"));
	String clientlevel = Util.null2String((String)request.getParameter("clientlevel"));
	String module=Util.null2String((String)request.getParameter("module"));
	String scope=Util.null2String((String)request.getParameter("scope"));

	String taskId = Util.null2String(request.getParameter("taskId"));
	
	rs.executeSql("select principalid,creater from TM_TaskInfo where id="+taskId+" and (deleted=0 or deleted is null)");
	if(rs.getCounts()==0) return;
	rs.next();
	
	String principalid = rc.getLastname(Util.null2String(rs.getString("principalid")));
	String creater = rc.getLastname(Util.null2String(rs.getString("creater")));
	
%>
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<meta name="author" content="Weaver E-Mobile Dev Group" />
	<meta name="description" content="Weaver E-mobile" />
	<meta name="keywords" content="weaver,e-mobile" />
	<meta name="viewport" content="width=device-width,minimum-scale=1.0, maximum-scale=1.0" />
	<title></title>
	<script type='text/javascript' src='/mobile/plugin/task/js/jquery-1.8.3.js'></script>
	<script type='text/javascript' src='/mobile/plugin/task/js/task.js'></script>
	<link rel="stylesheet" href="/mobile/plugin/task/css/task.css" />
	<style type="text/css">
		<%if("".equals(clienttype)||clienttype.equals("Webclient")){%>
			#header{display: block;}
		<%}%>
	</style>
<%@ include file="/secondwev/common/head.jsp" %>
	</head>
<body>
	<table class="taskTable" cellpadding="0" cellspacing="0">
		<tr>
			<td width="100%" height="100%" valign="top" align="left">
				<div id="topmain" class="topmain">
					<div id="header">
							<table style="width: 100%;height: 40px;">
								<tr>
									<td width="10%" align="left" valign="middle" style="padding-left:5px;">
										<div class="taskTopBtn" onclick="doLeftButton()">返回</div>
									</td>
									<td align="center" valign="middle">
										<div id="title">任务</div>
									</td>
									<td width="10%" align="right" valign="middle" style="padding-right:5px;">
									&nbsp;
									</td>
								</tr>
							</table>
					</div>
				</div>
				<div id="tabblank" class="tabblank"></div>
				<div id="list" class="list">
					<div class="taskTips">
						很抱歉，您暂时没有权限查看此任务！<br>
						可联系任务创建人：<%=creater %>
						<%if(!principalid.equals("") && !principalid.equals(creater)){ %>
						或任务负责人：<%=principalid %>
						<%} %>进行分享！
					</div>
				</div>
		</td>
	</tr>
	</table>
	<script type="text/javascript">
		var param = "module=<%=module%>&scope=<%=scope%>";
		$(document).ready(function(){
			$("#tabblank").height($("#topmain").height());//占位fixed出来的空间
		});
	
		function getLeftButton(){ 
			return "1,<%=SystemEnv.getHtmlLabelName(1290,user.getLanguage()) %>";
		}
		function getRightButton(){ 
			return "1, ";
		}
		function doRightButton(){
			return "1";
		}
		function doLeftButton(){
			window.location = "/home.do";
		}
	</script>
</body>
</html>