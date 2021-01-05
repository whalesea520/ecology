<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp"%>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";

    String modename = SystemEnv.getHtmlLabelName(431, user.getLanguage());
    String modeurl = "/middlecenter/index.jsp";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<link href="/rdeploy/assets/css/index.css" rel="stylesheet"
			type="text/css">
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<script language="javascript"
			src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
	</head>
	<body style="overflow: hidden;">
		<div style="text-align: center; width: 100%; height: 50px; background-color: #f1f6f7;">
			<center>
				<div style="width: 820px;">
					<span class="dbtn" style="float: right;">
						<input type="text" class="" height="" id="searchName" style="width: 200px; height: 30px;" /> 
						<span id="searchBox" class="" style="position: relative; right: 38px; padding: 10px 0 3px 8px; height: 40px; width: 40px; background-color: ; top: 5px;" onclick="search()" onmouseover="addBackColor()" onmouseout="removeBackColor()"> <img id="searchImg" class="" src="/images/ecology8/request/search-input_wev8.png"></span>
					</span>
					<span class="dbtn bggreen" id="inadvancedmode"> <img src="/rdeploy/assets/img/hrm/import.png" width="14px" height="14px" align="absMiddle"><%=SystemEnv.getHtmlLabelName(26601, user.getLanguage())%> </span>
					<span class="dbtn bgblue" id="inadvancedmode" onclick="doAdd()">
						<img src="/rdeploy/assets/img/add.png" width="14px" height="14px" align="absMiddle"><%=SystemEnv.getHtmlLabelName(125217, user.getLanguage())%> 
					</span>
				</div>
			</center>
		</div>

		<div style="position:absolute;width:100%;top:50px;bottom:0px;">
			<div style="">
			</div>
			<div style="">
			</div>
		</div>
	</body>
</html>
