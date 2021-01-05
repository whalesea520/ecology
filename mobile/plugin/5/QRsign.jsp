
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="java.net.*"%>
<%@ page import="weaver.general.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>
<%@ page import="weaver.hrm.*" %>

<%
request.setCharacterEncoding("UTF-8");
response.setContentType("text/html;charset=UTF-8");
User user = HrmUserVarify.getUser(request , response);
if(user==null) return;
%>
<html>
<head>
<script type='text/javascript' src='/mobile/plugin/js/jquery/jquery_wev8.js'></script>
<meta name="viewport" content="width=device-width,height=device-height, initial-scale=1.0,minimum-scale=1.0,maximum-scale=1.0,user-scalable=no" />
<meta name="apple-mobile-web-app-capable" content="yes">
<meta name="apple-mobile-web-app-status-bar-style" content="black">
<meta name="format-detection" content="telephone=no">
</head>
<body>
	<div style="width:100%;height:280px;text-align:center;margin:auto">
		<div style="width:50%;height:140px;margin:auto; margin-top:100px;line-height:280px;line-height: 140px;border: 1px solid #e5e4ec;" onclick="qr()">
		 扫描签到
		</div>
	</div>

	<FORM id=mf name=mf action="/mobile/plugin/5/meetingsign.jsp" method=post>
		<input id="meetingid" type="hidden" name="meetingid" value="">
    </FORM>
</body>
</html>
	<script type="text/javascript">
	
		
	function qr() {
		var url = "emobile:QRCode:signmeeting";			
    	location = url; 
	}
	
	function test(){
		$('#meetingid').val(ticket);
		$('#mf').submit();
	}

	function signmeeting(ticket) {
		if(ticket!=""){
			if(ticket.indexOf("/mobile/plugin/5/meetingsign.jsp?meetingid=")>-1){
				ticket=ticket.substring("/mobile/plugin/5/meetingsign.jsp?meetingid=".length);
			}
			$('#meetingid').val(ticket);
			$('#mf').submit();
		}else{
			alert("error");
		}
	}
	
	
	</script>