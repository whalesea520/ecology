
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ page import="weaver.systeminfo.SystemEnv"%>
<%@ page import="weaver.hrm.*" %>
<%
User user = HrmUserVarify.getUser (request , response);
%>
<html>

	<head>

		<title>div布局</title>

		<meta http-equiv="Content-Type" content="text/html;charset=UTF-8" />


		<style type="text/css">

/*各模块具体*/
#divBody {
	width: 100%;
	height: 100%;
	position: relative;
}

#header {
	height: 52px;
	background-color: #77a7cc;
	width: 100%;
	height: 52px;
	position: absolute;
	top: 0;
	left: 0;
	z-index: 99;
}


#main {
	overflow: auto;
	width: 100%;
	height: 100%;
	padding-top: 82px;
	padding-bottom: 100px;
	background-color: #FFFFCC;
	z-index: 96;
	-moz-box-sizing: border-box;
	-webkit-box-sizing: border-box;
}

#main .content {
	overflow: auto;
	width: 100%;
	height: 100%;
	background-color: #F7E8FF;
	z-index: 96;
	box-sizing: border-box;
	-moz-box-sizing: border-box;
	-webkit-box-sizing: border-box;
}

#main div {
	background-color: #669999
}

#footer {
	width: 100%;
	position: absolute;
	bottom: 0;
	left: 0;
	height: 100px;
	z-index: 93;
	background-color: #CCFFFF;
}
</style>



	</head>



	<body>

		<div id="divBody">

			<div id="header">
			</div>
			<div id="main">
				<div class="content">
				</div>
			</div>
			<div id="footer">
				<%=SystemEnv.getHtmlLabelName(129409, user.getLanguage())%>
			</div>
		</div>

	</body>

</html>