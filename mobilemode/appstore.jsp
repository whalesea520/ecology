
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@page import="com.weaver.formmodel.mobile.manager.MobileAppBaseManager"%>
<%@page import="com.weaver.formmodel.mobile.model.MobileAppBaseInfo"%>
<%
MobileAppBaseManager mobileAppBaseManager=MobileAppBaseManager.getInstance();
List<MobileAppBaseInfo> applist = mobileAppBaseManager.getPublishAppList();
%>

<HTML><HEAD>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<style type="text/css">
	*{
		font-family: 'Microsoft YaHei', Arial;
		
	}
	html,body{background-color:#fff;margin:0;padding:0;}
	h1{border:1px solid #aaa;font-weigh: normal;}
	
	.clearfix:after {
	visibility: hidden;
	display: block;
	content: "";
	clear: both;
}
.gallery{
	float: left;
	width:100%;
}
.gallery-entries{ 
	list-style:none;
	padding:0;
	float: left;
}
.gallery-entries .gallery-item{
	float: left;
}
.gallery-entries .gallery-item img{
	border: 0;
	width: 60px;
	height: 60px;
}
.gallery-entries .gallery-item a{
	text-decoration:none;
	color: #000;
}
.gallery-entries .gallery-item a div{
	width: 60px;
	text-align: center;
	white-space:nowrap;
	overflow: hidden;
	text-overflow:ellipsis;
	font-family: 'Microsoft YaHei', Arial;
	font-size: 12px;
}

	</style>
<script>
window.onload = function(){
	document.getElementById("divWidthHeight").innerHTML = window.screen.availWidth + "*" + window.screen.height + "," + window.localStorage;
}
function openAppBaseInfo(appid){
	location.href="/mobilemode/appHomepageViewWrap.jsp?appid="+appid;
}
</script>	
</HEAD>
<body>
<div data-role="page" data-theme="a" id="jqm-home">
		<div data-role="header" data-theme="a">
			<h1>Test</h1> 
			        <!-- 
			        <a href="grid-listview.html" data-shadow="false" data-iconshadow="false" data-icon="arrow-l" data-iconpos="notext" data-rel="back" data-ajax="false">Back</a>
			         -->
			<div id="divWidthHeight"></div>
		</div>
		<div data-role="content" data-theme="a">
			<section class="gallery">
			    <ul class="gallery-entries clearfix">
				<%for(MobileAppBaseInfo iappinfo : applist){
					MobileAppBaseInfo appinfo = (MobileAppBaseInfo)iappinfo;%>
					<li class="gallery-item" >
		                <a href="#" onclick="openAppBaseInfo(<%=appinfo.getId()%>)"><img src="<%=appinfo.getPicpath() %>" >
		                <div><%=appinfo.getAppname() %></div>
		            	</a>
		            </li>
					<%} %>
				</ul>
	</div>
</div>
</body>
</html>