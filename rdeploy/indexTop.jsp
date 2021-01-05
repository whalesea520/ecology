<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@page import="weaver.general.Util"%>
<%
String modename = Util.null2String(request.getParameter("modename"));
String modeurl = Util.null2String(request.getParameter("modeurl"));
%>
	<style type="text/css">
		body {
			margin:0px;
			padding:0px;
		}
		.topHead {
			padding:0px 35px;font-size:14px;font-family:'微软雅黑';
		}
		.topSpace {
			height:15px;
		}
		.topContent {
			height:55px;
		}
		.toptitle {
			padding:0px 15px;color:#526268;line-height:55px;
		}
		.topoperator {
			float:right;line-height:35px;margin:10px;padding:0px 18px;background:#6abc50;color:#fff;cursor:pointer;
		}
		.topspitline {
			width:100%;height:1px!important;background:#d8e0e5;
		}
		.topoperatorslt {
			background:#6ad04a!important;
		}
	</style>
	
	<script type="text/javascript">
	$(function () {
		$("#inadvancedmode").hover(function () {
			$(this).addClass("topoperatorslt");
		}, function () {
			$(this).removeClass("topoperatorslt");
		});
		
		$("#inadvancedmode").bind("click", function () {
			window.open("<%=modeurl %>");
		});
	});
	</script>
	
	
    <div class="topHead">
    	<div class="topSpace"></div>
    	<div class="topContent">
    		<span class="toptitle"><%=modename %></span>
    		<span class="topoperator" id="inadvancedmode">进入高级模式</span>
    	</div>
    	<div class="topspitline" style=""></div>
    </div>
