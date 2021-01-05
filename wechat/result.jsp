
<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%
String type=request.getParameter("type");
String msg=request.getParameter("msg");
if("getopenid".equals(type)){
	msg="获取OpendId失败";
}else if("band".equals(type)){
	if("success".equals(msg)){
		msg="绑定成功";
	}else{
		msg="绑定失败";
	}
}else if("cancelBand".equals(type)){
	if("success".equals(msg)){
		msg="解绑成功";
	}else{
		msg="解绑失败";
	}
}else if("system".equals(type)){
	if("operate".equals(msg)){
		msg="错误操作";
	}else{
		msg="未知操作";
	}
}else if("param".equals(type)){
	if("invalid".equals(msg)){
		msg="无效参数";
	}else if("nomodeurl".equals(msg)){
		msg="没有模块查看地址";
	}else if("nosupport".equals(msg)){
		msg="不支持的查看类型";
	}  else{
		msg="未知操作";
	}
}else if("news".equals(type)){
	if("405".equals(msg)){
		msg="无效参数";
	}
}
else if("user".equals(type)){
	if("noband".equals(msg)){
		msg="未绑定用户";
	}else{
		msg="未知操作";
	}
}
else{
	msg="未知操作";
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
		    <div data-role="content" style="text-align:center">
		        <%if("news".equals(type)&&"404".equals(msg)){%>
				<p>
					曾经有一份真正的<strong>页面</strong>放在我面前，<br />我没有珍惜。<br />等我失去的时候，<br />我才后悔莫及。<br />
					<br />人世间最痛苦的事莫过于此。<br />
					<br />如果上天能够给我一个<strong>再来一次的机<br />会</strong>，我会对那个页面说三个字：
				</p>

				<h2 style="font-size: 24px;">四零四</h2>

				<h3 style="color:red">对不起,您访问的页面未找到！</h3>

				<p style="font-size: 12px">
					画外音：跟你说过叫你不要乱扔东西，你怎么又...你看<br />我还没说完你又把页面扔掉了！你把他扔掉会污染花花<br />草草也是不对的
				</p>

				<%}else{%>
		        <h3>
		            <%=msg %>
		        </h3>
				<%}%>
		    </div>
		</div>
    </body>
</html>