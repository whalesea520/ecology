
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="java.net.*"%>
<%
request.setCharacterEncoding("UTF-8");
response.setContentType("text/html;charset=UTF-8");

String detailid = Util.null2String((String)request.getParameter("detailid"));
String module = Util.null2String((String)request.getParameter("module"));
String scope = Util.null2String((String)request.getParameter("scope"));

String titleurl = Util.null2String((String)request.getParameter("title"));
String title = URLDecoder.decode(titleurl,"UTF-8");
titleurl = URLEncoder.encode(titleurl, "UTF-8");

String clienttype = Util.null2String((String)request.getParameter("clienttype"));
String clientlevel = Util.null2String((String)request.getParameter("clientlevel"));

User user = HrmUserVarify.getUser (request , response) ;
if(user == null)  return ;

%>
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<meta name="author" content="Weaver E-Mobile Dev Group" />
	<meta name="description" content="Weaver E-mobile" />
	<meta name="keywords" content="weaver,e-mobile" />
	<meta name="viewport" content="width=device-width, initial-scale=1.0" />
	<title><%=title %></title>
	<script type='text/javascript' src='/mobile/plugin/js/jquery/jquery_wev8.js'></script>
	<link rel="stylesheet" href="/mobile/plugin/css/mobile_wev8.css" type="text/css">
	<style type="text/css">
	#header {
		width:100%;
		background: -moz-linear-gradient(top, white, #ECECEC);
		filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#FFFFFF', endColorstr='#ececec');
		background: -webkit-gradient(linear, left top, left bottom, from(#FFFFFF), to(#ECECEC));
		background: -moz-linear-gradient(top, white, #ECECEC);
		border-bottom: #CCC solid 1px;
		filter: alpha(opacity=70);
		-moz-opacity: 0.70;
		opacity: 0.70;
		position:relative;
	}
	#title {
		font-size:16pt;
		font-weight:bold;
		color:#000;
		padding:10px 10px 6px 10px;
		overflow:hidden;
	}
	</style>
	<script type="text/javascript">
	function doLeftButton() {
	}
	function doBack() {
		var result = doLeftButton();
		if(result==null||result=="BACK"){
			location = "/list.do?module=<%=module%>&scope=<%=scope%>";
		}
	}
	</script>
</head>
<body>

<div id="view_page">

	<div id="view_header" style="<%if (clienttype.equals("Webclient")) {%>display:block;<%} else {%>display:none;<%}%>">
		<a href="javascript:doBack();">
			<div style="position:absolute;left:5px;top:6px;width:56px;height:26px;background:url('/images/bg-top-btn_wev8.png') no-repeat;text-align:center;line-height:26px;color:#000;">
			返回
			</div>
		</a>
		<div id="view_title" style="position:absolute;left:65px;top:6px;right:65px;"><%=title %></div>
		
	</div>

	<div id="header">
		
	</div>

	<div id="content">
		该功能目前仅支持客户端。
	</div>

	<div id="bottom">
	</div>

</div>

</body>
</html>