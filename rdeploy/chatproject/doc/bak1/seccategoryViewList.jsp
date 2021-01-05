<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@ page import="weaver.hrm.*" %>
<%
User user = HrmUserVarify.getUser (request , response) ;
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE HTML>
<html>
	<head>
		<base href="<%=basePath%>">
		<script type="text/javascript"
			src="/js/select/script/jquery-1.8.3.min_wev8.js"></script>
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<link rel="stylesheet" type="text/css"
			href="/rdeploy/assets/css/common.css">
		<link href="/rdeploy/assets/css/doc/chatproject_index.css" rel="stylesheet"
			type="text/css">
		<script type="text/javascript" src="/js/doc/upload_wev8.js"></script>
		<script type='text/javascript' src='/rdeploy/assets/js/doc/chatproject/menu_nav_wev8.js'></script>
			
	</head>
	<style type="text/css">

.divtab_menu ul {
	padding-left: 18px;
}

.divtab_menu ul li {
	float: left;
	height: 30px;
	list-style-type: none;
	line-height: 25px;
	font-size: 14px;
	cursor: pointer;
	text-align: center;
	color: #5F5F5F;
	padding: 0 18px 0 18px;
}

.divtab_menu ul li a {
	color: #939d9e;
	text-decoration: none;
}

.divtab_menu ul li a:visited {
	color: #626671;
	text-decoration: none;
}

.divtab_menu ul li a:hover {
	color: #626671;
	text-decoration: none;
}

.showrequestline {
	left: 18px;
	right: 25px;
	position: absolute;
	background-color: #FAFAFA;
	z-index: 9;
	border-bottom: 1px solid #e4e4e4;
}

.moveline {
	left: 35px;
	width: 88px;
	position: absolute;
	z-index: 10;
	border-bottom: 2px solid #4aabdf;
}

.uploadBtn {
    color: #fff;
	text-align: center;
	border-radius: 5px;
}

.e8MenuNav{
	position: absolute;
    width: 478px;
    height: 30px;
    overflow: hidden;
    color: #242424;
    vertical-align: middle;
    border: 1px solid #dadada;
    right: 38%;
}
	.e8MenuNav .e8Home{
		background-repeat:no-repeat;
		background-position:50% 5px;
		background-image:url(/images/ecology8/newdoc/home_wev8.png);
		height:100%;
		width:30px;
		cursor:pointer;
		top:0px;
		left:0px;
		position:absolute;
	}
	
	.e8MenuNav .e8Expand{
		background-repeat:no-repeat;
		background-position:50% 9px;
		background-image:url(/images/ecology8/newdoc/expand_wev8.png);
		height:100%;
		width:30px;
		cursor:pointer;
		top:0px;
		right:0px;
		position:absolute;
		display:none;
	}
	
	.e8MenuNav .e8ParentNav{
		width:100%;
		height:100%;
		padding-left:30px;
	}
	.e8MenuNav .e8ParentNav .e8ParentNavLine{
		background-image:url(/images/ecology8/newdoc/line_wev8.png);
		background-repeat: no-repeat;
		background-position: 50% 50%;
		width: 20px;
		height:30px;
		float:left;
	}
	.e8MenuNav .e8ParentNav .e8ParentNavContent{
		height:30px;
		line-height:30px;
		float:left;
	}
	
	
	.file-name {
    line-height: 28px;
    height: 28px;
	}
	.edit-name {
	margin-top: 8px;
	width: 180px;
}
.edit-name .box {
    width: 110px;
    height: 21px;
    vertical-align: middle;
    border: 1px solid #79ceff;
}

.edit-name .sure {
       background-image: url(/rdeploy/assets/img/cproj/doc/sure.png);
    background-repeat: no-repeat;
    background-position: 50% 50%;
    width: 23px;
    height: 23px;
    display: inline-block;
    vertical-align: middle;
    cursor: pointer;
    border: 1px solid #e4e4e4;
    margin-left: 7px;
}
.edit-name .cancel {
   background-image:url(/rdeploy/assets/img/cproj/doc/cancel.png);
   background-repeat: no-repeat;
   background-position: 50% 50%;
    width: 23px;
    height: 23px;
    display: inline-block;
    vertical-align: middle;
    cursor: pointer;
    border: 1px solid #e4e4e4;
    margin-left: 7px;
}



.progressWrapper {
	
}

.rprogressContainer {
	background: #fff none repeat scroll 0 0;
	height: 50px;
	overflow: hidden;
}

.rgreen {
	
}

.fileIconDiv {
	float: left;
	padding-top: 15px;
	padding-left: 19px;
}

.rprogressName {
	float: left;
	padding-top: 15px;
	padding-left: 8px;
	white-space: nowrap;
	overflow: hidden;
	text-overflow: ellipsis;
	width: 220px;
	text-align: left;
}

.fileSize {
	float: left;
	color: #aaaaaa;
	padding-top: 15px;
	padding-left: 33px;
	text-align: left;
	width: 20px;
}

.rprogressBarStatus {
	float: left;
	padding-top: 15px;
	padding-left: 149px;
	color: #3fca6a;
}

.cancelDiv {
	float: left;
	padding-top: 16px;
	padding-left: 10px;
}

/*进度条*/
.rprogressBarInProgress {
    height: 10px;
    background: #5ec475;
    width: 0px;
    top: 51%;
    position: absolute;
    z-index: 100;
}
.rprogressBarInProgressDiv {
	height: 144px;
    Opacity: 0.5;
    width: 99%;
    background-color: #fff;
    border: 1px solid #e4e4e4;
    top: 1px;
    position: absolute;
}
.rprogressBarInProgressLine {
	height: 9px;
    border: 1px solid #e4e4e4;
    background-color: #fff;
    width: 99%;
    z-index: 99;
    top: 50%;
    position: absolute;
}
.itemtitleW {
	width: 90%;
    padding-left: 5%;
	text-overflow: ellipsis; 
	overflow: hidden; 
	white-space: nowrap; 
	margin-top: -2px;
}
.content .item {
    float: left;
    width: 156px;
    height: 161px;
    margin: 0px 38px;
    position: relative;
    border: 1px solid #fff;
    margin-top: 10px;
}
.folderOpDiv {
	text-align: center;
    margin-top: -145px;
    margin-left: 125px;
    background-color: #f4f4f4;
    height: 25px;
    width: 31px;
    line-height: 28px;
    display: none;
    cursor: pointer;
}
.docOpDiv {
	text-align: center;
    margin-top: -143px;
    margin-left: 75px;
    background-color: #f4f4f4;
    height: 25px;
    width: 81px;
    line-height: 28px;
    display: none;
}
.downloadDocDiv {
	    float: left;
    margin-left: 9px;
    cursor: pointer;
}
.shareDocDiv {
	    float: left;
    margin-left: 10px;
    cursor: pointer;
}
.delDocDiv {
	    float: left;
    margin-left: 10px;
    cursor: pointer;
}
.delDocDivNew {
	cursor: pointer;
    top: 5px;
    position: absolute;
    right: 5px;
    background-image:url(/rdeploy/assets/img/cproj/doc/op/del.png);
   background-repeat: no-repeat;
   background-position: 50% 50%;
    width: 23px;
    height: 23px;
}

.delDocDivNew:hover {
	cursor: pointer;
    top: 5px;
    position: absolute;
    right: 5px;
    background-image:url(/rdeploy/assets/img/cproj/doc/op/del_hot.png);
   background-repeat: no-repeat;
   background-position: 50% 50%;
    width: 23px;
    height: 23px;
}

.itemico {
	margin-top: 33px;
}
a {
	cursor:pointer;
	color: #474f60;
}

a:hover {
	color: #4ba9df;
}
.norecord {
    position: absolute;
    left: 45%;
    top: 30%;
    width: 75px;
    height: 130px;
}
.recordpicture {
    width: 94px;
    height: 85px;
    background-image: url("/rdeploy/assets/img/cproj/doc/f_no_data.png");
    background-repeat: no-repeat;
    background-position: center;
}
.recordmessage {
    width: 94px;
    height: 45px;
    line-height: 45px;
    text-align: center;
    font-size: 16px;
    color: #e4e4e4;
}
</style>
	<body>
		<div id="content" class="content" style="padding-top: 24px;padding-left: 60px;">
			<div id="itemsDiv">
			</div>
		</div>
	</body>
	</script>
</html>
