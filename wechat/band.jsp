
<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@page import="weaver.wechat.request.QueryAction"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
//如果传过来的参数直接是有openid和publicid的直接取出来处理
String openid=request.getParameter("openid");
String publicid=request.getParameter("publicid");
String target=request.getParameter("target");
//以下通过微信授权页面过来
if(openid==null||"".equals(openid)){
	String code=request.getParameter("code");
	String state=request.getParameter("state");
	QueryAction qa=new QueryAction();
	openid=qa.queryBandOpendId(state,code);
	publicid=state;
}
if("".equals(openid)){
	response.sendRedirect("result.jsp?type=getopenid&msg=no");
    return;
}
//查看openid 是否已经绑定,提醒已经绑定,是否重新绑定,解绑等一系统操作
rs.execute("select id,userid,usertype from wechat_band where publicid='"+publicid+"' and openid='"+openid+"'");
if(rs.next()){
	response.sendRedirect("bandInfo.jsp?target="+target+"&id="+rs.getInt("id")+"&userid="+rs.getInt("userid")+"&usertype="+rs.getInt("usertype"));
}
 %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta name="viewport" content="width=device-width, initial-scale=1" />
<title></title>
<link rel="stylesheet" href="css/jquery.mobile-1.1.1.min_wev8.css" />
<link rel="stylesheet" href="css/my_wev8.css" />
<style>/* App custom styles */</style>
<script	src="js/jquery-1.7.1.min_wev8.js"></script>
<script	src="js/custom-jqm-mobileinit_wev8.js"></script>
<script	src="js/jquery.mobile-1.1.1.min_wev8.js"></script>
<script src="js/my_wev8.js"></script>
</head>
	<body>
        <!-- Home -->
		<div data-role="page" id="page1">
		    <div data-role="content">
		        <form id="loginForm" action="bandOperate.jsp" method="POST">
	                <input name="openid" id="openid" value="<%=openid %>" type="hidden">
	                <input name="state" id="state" value="<%=publicid %>" type="hidden">
	                <input name="operate" id="operate" value="band" type="hidden">
					<input name="target" id="target" value="<%=target%>" type="hidden">
		            <div data-role="fieldcontain">
		                <input name="username" id="username" placeholder="用户名" value="" type="text">
		            </div>
		            <div data-role="fieldcontain">
		                <input name="pwd" id="pwd" placeholder="密码" value="" type="password">
		                <input name="usertype" id="usertype" value="1" type="hidden">
		            </div>
		            <input type="button" data-theme="a" value="绑定" onclick="checkLogin()">
					<div data-role="fieldcontain" id="errormsg" style="color:red;" align="center">
		            </div>
		        </form>
		    </div>
		</div>
    </body>
     <script>
     function checkLogin(){
		 $('#errormsg').html("");
		 if($('#username').val()==""){
			$('#errormsg').html("用户名不能为空");
			return false;
		 }
		 if($('#pwd').val()==""){
			$('#errormsg').html("密码不能为空");
			return false;
		 }
     	 $('#loginForm').submit();
     }
     
      //App custom javascript
      $(document).ready(function() {
       
	     
      });
      </script>
</html>