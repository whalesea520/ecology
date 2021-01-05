<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%
    User user = HrmUserVarify.getUser (request , response) ;
	String from = request.getParameter("from");
	boolean ifFromPc = "pc".equalsIgnoreCase(from);
%>

<link rel="stylesheet" type="text/css" href="/social/js/bootstrap/css/bootstrap.css" />
<link rel="stylesheet" type="text/css" href="/social/js/bootstrap/css/bs.base.wev8.css" />
<script src="/social/js/drageasy/drageasy.js"></script>
<script type="text/javascript" src="/social/js/bootstrap/js/bootstrap.js"></script>
<script type="text/javascript" src="/social/im/js/IMUtil_wev8.js"></script>
<script type="text/javascript" src="/social/js/imcarousel/imcarousel.js"></script>
<script type="text/javascript" src="/social/js/imcarousel/i18n.js"></script>
<style>
	<%if(!ifFromPc){ %>
	.carousel-fullpane .control-pane {width: 200px;}
	<%}%>
</style>

<!-- 聊天窗口图片浏览 -->
<!-- layer -->
<div class="mengbanLayer"></div>
<div class="chatImgPagWrap" onclick="IMCarousel.doScannerEscape(event, this);">
	<div class="pcDragArea" style='height:60px;'></div>
	<div id="myCarousel" class="chatImgPag carousel slide" data="carousel">
	   <!-- 轮播（Carousel）指标 -->
	   
	   <ol class="carousel-indicators" style="display: none;">
	   
	   </ol>
	   
	   <!-- 轮播（Carousel）项目 -->
	   <div class="carousel-inner">
	   
	   </div>
	   <!-- 轮播（Carousel 控制面板 -->
	   <div class="carousel-fullpane">
	   		<div class="control-pane">
	   			<div class="ctrlbtn enlarge" onclick="IMCarousel.scaleImg(this, 'enlarge')" data-toggle="tooltip" title="<%=SystemEnv.getHtmlLabelName(126977, user.getLanguage())%>"><!-- 放大此图片 -->
	   			</div>
	   			<div class="ctrlbtn shrink" onclick="IMCarousel.scaleImg(this, 'shrink')" data-toggle="tooltip" title="<%=SystemEnv.getHtmlLabelName(126978, user.getLanguage())%>"><!-- 缩小此图片 -->
	   			</div>
	   			<div class="ctrlbtn rotate" onclick="IMCarousel.rotateImg(this)" data-toggle="tooltip" title="<%=SystemEnv.getHtmlLabelName(126979, user.getLanguage())%>"><!-- 旋转此图片 -->
	   			</div>
	   			<%if(ifFromPc){ %>
	   			<div class="ctrlbtn copy" onclick="IMCarousel.copyImg(this)" data-toggle="tooltip" title="<%=SystemEnv.getHtmlLabelName(131907, user.getLanguage())%>"><!-- 旋转此图片 -->
	   			</div>
	   			<%} %>
	   			<div class="ctrlbtn download" onclick="IMCarousel.downloadImg(this)" data-toggle="tooltip" title="<%=SystemEnv.getHtmlLabelName(126980, user.getLanguage())%>"><!-- 下载此图片 -->
	   			</div>
	   		</div>
	   </div>
	   <!-- 轮播（Carousel）导航 -->
	   <a class="carousel-control left" data-slide="prev" onmouseover="IMCarousel.showImgIndexNo(this, 'prev')" onclick="IMCarousel.slideImg(this, 'prev');">&lsaquo;</a>
	   <a class="carousel-control right" data-slide="next" onmouseover="IMCarousel.showImgIndexNo(this, 'next')" onclick="IMCarousel.slideImg(this, 'next');">&rsaquo;</a>
	</div> 
	<div class="miniClose" data-toggle="tooltip" data-placement="bottom" title="<%=SystemEnv.getHtmlLabelName(309, user.getLanguage())%>" onclick="IMCarousel.showImgScanner(event, 0, '')">×</div><!-- 关闭图片浏览 -->
</div>
