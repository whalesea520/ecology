<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<!DOCTYPE html>
<html>
  <head>
  <%
  	String groupid = Util.null2String(request.getParameter("groupid"));//群id
    String votingid = Util.null2String(request.getParameter("votingid"));//投票id
    String usertype = Util.null2String(request.getParameter("usertype"));//用户类型:0,已投票；1:未投票
    String optionid = Util.null2String(request.getParameter("optionid"));//投票选项id
    String skin = Util.null2String(request.getParameter("skin"));//皮肤颜色
  %>
    <meta charset="UTF-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="initial-scale=1.0, maximum-scale=2.0">
	<meta name="description" content="">
	<meta name="author" content="">
    <title>群聊投票</title>
	<script type="text/javascript" src="/voting/groupchatvote/js/jquery-1.8.3.min.js"></script>
	<link rel="stylesheet" type="text/css" href="/voting/groupchatvote/css/index.min-1.css">
	<link rel="stylesheet" type="text/css" href="/voting/groupchatvote/css/index.min-2.css">
	<script type="text/javascript" src="/voting/groupchatvote/js/react-with-addons.min.js"></script>
	<script type="text/javascript" src="/voting/groupchatvote/js/react-dom.min.js"></script>
	<script type="text/javascript" src="/voting/groupchatvote/js/index.min.js"></script>
	<script type="text/javascript" src="/js/ecology8/jNice/jNice/jquery.jNice_wev8.js"></script>
	<link rel="stylesheet" href="/js/ecology8/jNice/jNice/jNice_wev8.css" type="text/css" />
	<script>	
		window.__groupid = "<%=groupid%>";
		window.__votingid = "<%=votingid%>";
		window.__usertype = "<%=usertype%>";
		window.__optionid = "<%=optionid%>";
		window.__skin = "<%=skin%>";
		function refreshVoteList(){
			var href=window.location.href;
			window.location.reload();
		}
	</script>
  </head>
  <body>
  <input type="hidden" id="isNewPlugisCheckbox" value="0"/>
  
    <div id="container"></div>
    <script type="text/javascript" src="/voting/groupchatvote/js/index.js"></script>
  </body>
</html>