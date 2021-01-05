
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />

<%@ include file="/systeminfo/init_wev8.jsp" %>
<link type="text/css" rel="stylesheet" href="/css/Weaver_wev8.css" />
<script type="text/javascript" src="/js/ecology8/browserCommon_wev8.js"></script>
<script type="text/javascript" src="/wui/common/jquery/plugin/wuiform/jquery.wuiform_wev8.js"></script>
<script type='text/javascript' src='/js/jquery-autocomplete/browser_wev8.js'></script>
<script type="text/javascript" src="/js/init_wev8.js"></script>
<script type="text/javascript" src="/wui/common/jquery/plugin/wuiform/jquery.wuiform_wev8.js"></script>

<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<jsp:include page="/social/im/SocialIMUtil.jsp"></jsp:include>
<html>
<head>
	<link rel="stylesheet" href="/social/css/im_fav_wev8.css"/>
	<link rel="stylesheet" href="/social/css/base_public_wev8.css" type="text/css" />
	<link rel="stylesheet" href="/js/ecology8/jNice/jNice/jNice_wev8.css" type="text/css" />
	<script type="text/javascript" src="/js/ecology8/jNice/jNice/jquery.jNice_wev8.js"></script>
</head>
<%
	String userid=""+user.getUID();
	
%>

<body>

<div class='dataloading' style='text-align:center;position:relative;top:50%;display: none;'>
	<img src='/social/images/loading_large_wev8.gif'/>
</div>

<div id="zDialog_div_content" class="zDialog_div_content chatFavList">
	<jsp:include page="/favourite/MyFavourite.jsp?favtype=6"></jsp:include>
</div>
<!-- 浮动提示 -->
<div id="warn">
	<div class="title"></div>
</div>
<!-- user scripts -->
</body>
</html>
<script type="text/javascript">
	$(".dataloading").hide();
	parentwin = top.topWin.Dialog._Array[0].openerWin;
	client = parentwin.client;
	userid = '<%=userid%>';
	$(function(){
		$('.chatFavList').perfectScrollbar();
		
	});
	function showMsg(msg){
		jQuery("#warn").find(".title").html(msg);
		jQuery("#warn").css("display","block");
		setTimeout(function (){
			jQuery("#warn").css("display","none");
		},1500);
	  }
</script>




