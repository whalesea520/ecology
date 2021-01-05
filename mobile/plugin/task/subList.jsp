<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.net.URLDecoder"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<%@page import="weaver.file.FileUpload"%>
<%
	response.setHeader("Cache-Control","no-store");
	response.setHeader("Pragrma","no-cache");
	response.setDateHeader("Expires",0);
	FileUpload fu = new FileUpload(request);
	String clienttype = Util.null2String((String)fu.getParameter("clienttype"));
	String clientlevel = Util.null2String((String)fu.getParameter("clientlevel"));
	String module=Util.null2String((String)fu.getParameter("module"));
	String scope=Util.null2String((String)fu.getParameter("scope"));
	
	int LIST_TYPE = Util.getIntValue(fu.getParameter("LIST_TYPE"),5);
	int STATUS = Util.getIntValue(fu.getParameter("STATUS"),0);
	String param = "clienttype="+clienttype+"&clientlevel="+clientlevel+"&module="+module+"&scope="+scope;
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html;charset=UTF-8">
	<meta http-equiv="Cache-Control" content="no-cache,must-revalidate"/>
	<meta http-equiv="Pragma" content="no-cache"/>
	<meta http-equiv="Expires" content="0"/>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<meta name="author" content="Weaver E-Mobile Dev Group" />
	<meta name="description" content="Weaver E-mobile" />
	<meta name="keywords" content="weaver,e-mobile" />
	<meta name="viewport" content="width=device-width,minimum-scale=1.0, maximum-scale=1.0" />
	<title></title>
	<script type='text/javascript' src='/mobile/plugin/task/js/jquery-1.8.3.js'></script>
	<script type='text/javascript' src='/mobile/plugin/task/js/task.js'></script>
	<script type='text/javascript' src='/mobile/plugin/task/js/showLoading/js/jquery.showLoading.js'></script>
	<link rel="stylesheet" href="/mobile/plugin/task/js/showLoading/css/showLoading.css" />
	<link rel="stylesheet" href="/mobile/plugin/task/css/task.css" />
	
	<style type="text/css">
		<%if("".equals(clienttype)||clienttype.equals("Webclient")){%>
			#header{display: block;}
		<%}%>
	</style>
<%@ include file="/secondwev/common/head.jsp" %>
	</head>
<body id="body">
	<table class="taskTable" cellpadding="0" cellspacing="0">
		<tr>
			<td valign="top">
				<div id="topmain" class="topmain"><!-- 顶部 -->
					<div id="header">
						<table style="width: 100%;height: 40px;">
							<tr>
								<td width="10%" align="left" valign="middle" style="padding-left:5px;">
									<div class="taskTopBtn" onclick="doLeftButton()">返回</div>
								</td>
								<td align="center" valign="middle">
									<div id="title">选择下属</div>
								</td>
								<td width="10%" align="right" valign="middle" style="padding-right:5px;">
									&nbsp;
								</td>
							</tr>
						</table>
					</div>
				</div>
				<div id="tabblank" class="tabblank"></div><!-- 站位顶部导航FIXED的空白 -->
				<div id="list" class="list"><!-- 数据展示 -->
					<div class="taskTips">加载中...</div>
				</div>
		</td>
	</tr>
	</table>
	
	<script type="text/javascript">
		var param = "<%=param%>";
		$(document).ready(function(){
			$("#tabblank").height($("#topmain").height());//占位fixed出来的空间
			
			getSubList(<%=user.getUID()%>,1);//触发一次加载下属方法
			
			$("div.subClick").live("click",function(){//加载下属点击触发事件
				var userid = $(this).attr("userid");
				if($(this).attr("ifShow")==0){//没有加载过
					$(this).attr("ifShow",1).addClass("subClicked");
					getSubList(userid,2);
				}else if($(this).attr("ifShow")==1){//已经加载并且展示在
					$(this).attr("ifShow",2).removeClass("subClicked");
					$(".subTr_"+userid).hide();
				}else if($(this).attr("ifShow")==2){//已经加载并且隐藏
					$(this).attr("ifShow",1).addClass("subClicked");
					$(".subTr_"+userid).show();
				}
			});
			
			$(".hrmName").live("click",function(){//选择人员触发事件
				var userid = $(this).attr("userid");
				window.location = "/mobile/plugin/task/taskMain.jsp?"+param+"&hrmid="+userid+"&MENUTYPE=0";
			});
		});

		function getSubList(userid,type){
			$("#list").showLoading();
			$.ajax({
				type: "post",
				url:"/mobile/plugin/task/getSubList.jsp",
				data:{"userid":userid,"type":type},
				success:function(data){
					if(type==1)
						$("#list").html(data);
					else
						$("#listTr_"+userid).after(data);	
				},
				complete:function(){
					$("#list").hideLoading();
				}
			});
		}
	
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
			window.location = "/mobile/plugin/task/taskMain.jsp?"+param;
			return "1";
		}
	</script>
</body>
</html>