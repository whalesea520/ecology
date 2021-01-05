
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>


<html>
<head>
   <link href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
   <link rel="stylesheet" href="/voting/surveydesign/css/surveyresult_wev8.css">
   <link rel="stylesheet" href="/voting/surveydesign/css/popup_wev8.css">
</head>
  <body>

	  <script src="../js/jquery_wev8.js"></script>
	  <script>
	     jQuery(document).ready(function(){
		      $(document.body).append(window.top.votecontainer);
		 });
	  </script>
  </body>
</html>

