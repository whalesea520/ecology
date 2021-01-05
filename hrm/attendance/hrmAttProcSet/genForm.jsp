<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- Added by wcd 2015-05-22[生成表单] -->
<%@ include file="/hrm/header.jsp"%>
<%
	String imagefilename = "/images/hdHRMCard_wev8.gif", needfav ="1", needhelp ="";
	String titlename = SystemEnv.getHtmlLabelName(82797,user.getLanguage());
%>
<html>
	<head>
		<link type="text/css" rel="stylesheet" href="/css/Weaver_wev8.css">
		<script type="text/javascript" src="/js/weaver_wev8.js"></script>
	</head>
	<body style="overflow:hidden;">
		<SCRIPT LANGUAGE="JavaScript">
		<!-- Hide
		function killErrors() {
			return true;
		}
		window.onerror = killErrors;
		// -->
		</SCRIPT>
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<div style="margin-top:30px!important;">
			<wea:layout>
				<wea:group context="" attributes="{'groupDisplay':'none'}">
					<wea:item attributes="{'customAttrs':'nowrap=true'}"><%=SystemEnv.getHtmlLabelName(15451,user.getLanguage())%></wea:item>
					<wea:item>
						<wea:required id="titlespan" required="true">
							<input id="title"  name="title" style="width:80%" onchange="checkinput(this.title,'titlespan')"  >
						</wea:required>
					</wea:item>
				</wea:group>
			</wea:layout>
		</div>
	</body>
</html>
