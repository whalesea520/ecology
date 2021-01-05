<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ include file="/mobilemode/init.jsp"%>
<%
String type = Util.null2String(request.getParameter("type"));
String url = Util.null2String(request.getParameter("url"));
%>
<!DOCTYPE>
<html>
<head>
<style type="text/css">
*{
	font-family: 'Microsoft YaHei', Arial;
}
div#main {
    padding: 10px;
}
#main ul {
    list-style: none;
    margin: 0px;
    padding: 0px;
}
#main ul li {
    margin-bottom: 10px;
    font-size: 16px;
    position: relative;
    padding-left: 22px;
}
#main ul li.error {
    color: red;
}
#main ul li.error:before {
	content: '×';
    font-size: 24px;
    position: absolute;
    top: -1px;
    left: 0px;
    line-height: 24px;
}
#main ul li.success {
    color: #16a122;
}
#main ul li.success:before {
	content: '√';
    font-size: 22px;
    position: absolute;
    top: 1px;
    left: 1px;
    line-height: 22px;
}
.url-wrap {
    position: relative;
    margin-top: 20px;
}
.url {
    height: 40px;
    line-height: 38px;
    font-size: 14px;
    padding: 0px 0px 0px 80px;
    border: 1px solid #ccc;
    box-sizing: border-box;
    border-radius: 5px;
    color: #999;
    background-color: rgb(245, 245, 245);
}
.url_8 {
    padding: 0px 0px 0px 125px;
}
.btn {
	position: absolute;
    background-color: #007aff;
    color: #fff;
    height: 40px;
    line-height: 40px;
    padding: 0px 15px;
    font-size: 14px;
    right: 0px;
    top: 0px;
    border-bottom-right-radius: 5px;
    border-top-right-radius: 5px;
    cursor: pointer;
}
.btn:hover {
    opacity: 0.8;
}
.label{
	position: absolute;
    left: 0px;
    top: 0px;
    width: 74px;
    height: 40px;
    background: #eeeeee;
    color: #333;
    border: 1px solid #cccccc;
    box-sizing: border-box;
    line-height: 38px;
    text-align: center;
    font-size: 14px;
}
.label_8{
	width: 120px;
}
.desc {
    color: #999;
    margin-top: 12px;
    padding-left: 3px;
}
</style>
</head>
<body>
	<div id="main">
		<ul>
			<%if("0".equals(type)){ %>
			<li class="error"><%=SystemEnv.getHtmlNoteName(4964,user.getLanguage())%></li><!-- 不能将该地址配置在Emobile中使用  -->
			<li class="error"><%=SystemEnv.getHtmlNoteName(4965,user.getLanguage())%></li><!-- 不能将该地址作为云桥中企业号/钉钉的菜单地址 -->
			<li class="success"><%=SystemEnv.getHtmlNoteName(4966,user.getLanguage())%></li><!-- 该地址一般用于移动建模各页面之间的跳转  -->
			<%}else{ %>
			<li class="error"><%=SystemEnv.getHtmlNoteName(4967,user.getLanguage())%></li><!-- 不能将该地址用于移动建模各页面之间的跳转  -->
			<li class="success"><%=SystemEnv.getHtmlNoteName(4968,user.getLanguage())%></li><!-- 可以将该地址配置在Emobile中使用  -->
			<li class="success"><%=SystemEnv.getHtmlNoteName(4969,user.getLanguage())%></li><!-- 可以将该地址作为云桥中企业号/钉钉的菜单地址  -->
			<%} %>
		</ul>
		
		<div class="url-wrap">
			<div class="label label_<%=user.getLanguage()%>"><%=("0".equals(type) ? SystemEnv.getHtmlNoteName(4695,user.getLanguage()) : SystemEnv.getHtmlNoteName(4702,user.getLanguage())) %></div><!-- 页面地址 发布地址 -->
			<div class="url url_<%=user.getLanguage()%>"><%=url %></div>
			<div class="btn"><%=SystemEnv.getHtmlNoteName(3874,user.getLanguage())%></div><!-- 复制  -->
		</div>
		
		<div class="desc">*<%=SystemEnv.getHtmlNoteName(4970,user.getLanguage())%></div><!-- 点击复制按钮将地址复制到剪切板，并关闭当前窗口  -->
	</div>
	<script type="text/javascript" src="/mobilemode/js/zclip/jquery.zclip.js"></script>
	<script type="text/javascript">
	$(function(){
		$(".btn").zclip({
			path : "/mobilemode/js/zclip/ZeroClipboard.swf",
			copy : function(){
				return "<%=url %>";
			},
			afterCopy : function(){
				top.closeTopDialog();
			}
		});
	});
	</script>
</body>
</html>

