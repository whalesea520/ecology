<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<%
	int type = Util.getIntValue(request.getParameter("type"),1);
%>
<HTML>
	<HEAD>
		<LINK rel="stylesheet" type="text/css" href="/css/Weaver_wev8.css">
		<style type="text/css">
			.tab{width: 100px;float: left;line-height: 30px;text-align: center;cursor: pointer;font-size: 13px;margin-top: 0px;}
			.tab_hover{background: #F3F3F3;color: #000;}
			.tab_click{background: #ECECEC;color: #000;}
		</style>
	</HEAD>
	<BODY style="overflow: hidden;">
		<form id="menuform" name="menuform" action="" method="post" target="pageBottom">
		</form>
		<div style="width: 100%;height: 30px;border-bottom:2px #ECECEC solid;font-size: 14px;font-weight: bold;margin-bottom: 0px;">
			<div class="tab <%if(type==1){ %>tab_click<%} %>" _url="BaseFrame.jsp">基础设置</div>
			<div class="tab <%if(type==2){ %>tab_click<%} %>" _url="AccessItemList.jsp">考核指标项</div>
			<div class="tab <%if(type==2){ %>tab_click<%} %>" _url="ScoreSetting.jsp">分数段设置</div>
		</div>
		
		<script type="text/javascript">
			$(document).ready(function(){
				$("div.tab").bind("mouseover",function(){
					$(this).addClass("tab_hover");
				}).bind("mouseout",function(){
					$(this).removeClass("tab_hover");
				}).bind("click",function(){
					$("div.tab").removeClass("tab_click");
					$(this).addClass("tab_click");
					var _url = $(this).attr("_url");
					$("#menuform").attr("action",_url);
					$("#menuform").submit();
				});	
			});
		</script>
	</BODY>
</HTML>