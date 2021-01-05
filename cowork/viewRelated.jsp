<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="weaver.blog.BlogDao"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<html>
<head>
<link rel="stylesheet" href="/css/ecology8/request/seachBody_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/titleCommon_wev8.js"></script>
<script type="text/javascript">var languageid=<%=user.getLanguage()%>;</script>
<script type="text/javascript" src="/weaverEditor/kindeditor_wev8.js"></script>
<script type="text/javascript" charset="utf-8" src="/weaverEditor/kindeditor-Lang_wev8.js"></script>

<script type="text/javascript" src="/cowork/js/wheelmenu/jquery-1.9.1_wev8.js"></script>
<script type="text/javascript" src="/cowork/js/wheelmenu/jquery.wheelmenu_wev8.js"></script>
<link rel="stylesheet" href="/cowork/js/wheelmenu/wheelmenu_wev8.css" type="text/css" />

<style>
span{vertical-align:baseline}
.numdiv{color: #fff;width:40px;height:27px;line-height:27px;text-align: center;vertical-align:baseline}
.remarkdiv_show_b{border: 1px solid #dadada;border-top: 0px solid #dadada;}
#remarkdiv{background: #fff;font-size: 12px;vertical-align: middle;overflow: hidden;height: 0px;}

.remark_icon{float:left;background: url('/cowork/images/blue/down_wev8.png') no-repeat center;height:30px;width: 16px;cursor:pointer}

.discuss_item{margin-bottom:8px;}
.discuss_item .discuss{padding:5px;border: 1px solid #dadada;background: #fff;font-size: 12px;vertical-align: middle;}
.discuss .head{width:30px;float: left;position: absolute;}
.discuss .rightdiv{float: left;padding-left:8px;padding-left:40px;}
.discuss .content{color: #333;padding-top:8px;padding-bottom:8px}
.discuss .time{padding-left:8px;color: #929393}
.discuss .name{color: #929393}

.discuss_item .operations{padding-left: 5px;padding-top: 10px;padding-right: 5px;padding-bottom: 10px;border: 1px solid #dadada;border-top: 0px solid #dadada;font-size: 12px;vertical-align: middle;background:#f0eeee;}
.operations .comment{background-image:url('/cowork/images/gray/1_wev8.png');background-repeat: no-repeat;padding-left:16px;color: #9e9e9e;cursor: pointer;}
.operations .line{width: 1px;border-right:1px #a3bad1 solid;height: 11px;margin-left: 4px;margin-right: 4px;}
.operations .yinyong{background-image:url('/cowork/images/gray/2_wev8.png');background-repeat: no-repeat;padding-left:16px;color: #9e9e9e;cursor: pointer;}
.operations .totop{background-image:url('/cowork/images/gray/3_wev8.png');background-repeat: no-repeat;padding-left:16px;color: #9e9e9e;cursor: pointer;}
.operations .favoriate{background-image:url('/cowork/images/gray/4_wev8.png');background-repeat: no-repeat;padding-left:16px;color: #9e9e9e;cursor: pointer;}

.left{float:left}
.right{float:right}
.clear{clear:both}

.check_box{border: 1px solid #ccc;height:20px;width: 20px;padding:1px;}
.check_box:hover{  border: 2px solid #e4393c;height:20px;width:20px;}
.checkbox_selected{border: 2px solid #e4393c;height:20px;width:20px;}
.check_box .checkbox_check{display:none}

.checkbox_selected .checkbox_check{background: url('/cowork/images/blue/item_selected_wev8.gif');width: 10px;height: 10px;margin-top:10px;margin-left:10px;}

</style>
</head>
<body style="background:rgb(249, 249, 249);">
<div style="padding-left: 5px;width:98%;padding-right:5px;padding-top:5px;">

<style>
.signalletter{
	height: 45px;
	line-height: 45px;
	font-size: 16px;
    font-weight: 200;;
	border-bottom: 2px solid #e2e2e2;
			 
}
.letterline{
   height:2px;
   width:70px;
   margin-top: -2px;
}
.itemdetail{
  height:32px;
  line-height:32px;
  width: 30%;
  margin-right: 3%;
  float: left;
}
.centerItem a{font-size:9pt;}
</style>

<div class="lettercontainer">
     <div class="C  signalletter" style="color: rgb(158, 23, 182);">相关流程</div>
     	
	 <div class="letterline" style="background: rgb(158, 23, 182);"></div> 
	 
	 <div class="itemdetail">
		 <div class="centerItem" >
			 	<img name="esymbol" style="vertical-align: middle;" src="\images\ecology8\request\workflowTitle_wev8.png"/>
				<a style="color: grey; margin-right: 10px; margin-left: 8px; vertical-align: middle;" href="javascript:onNewRequest(187,0,0);"> 采购任务单-通用类 </a>
		 </div>
      </div> 
		
	  <div class="itemdetail">
			<div class="centerItem" >
			 	<img name="esymbol" style="vertical-align: middle;" src="\images\ecology8\request\workflowTitle_wev8.png"/>
			 	<a style="color: grey; margin-right: 10px; margin-left: 8px; vertical-align: middle;" href="javascript:onNewRequest(256,0,0);">采购任务单通用类-测试 </a>
			</div>
       </div> 
       <div class="clear"></div>
</div>

<div class="lettercontainer">
     <div class="C  signalletter" style="color:#166ca5;">相关文档</div>
     	
	 <div class="letterline" style="background:#166ca5;"></div> 
	 
	 <div class="itemdetail">
		 <div class="centerItem" >
			 	<img name="esymbol" style="vertical-align: middle;" src="\images\ecology8\request\workflowTitle_wev8.png"/>
				<a style="color: grey; margin-right: 10px; margin-left: 8px; vertical-align: middle;" href="javascript:onNewRequest(187,0,0);"> 采购任务单-通用类 </a>
		 </div>
      </div> 
		
	  <div class="itemdetail">
			<div class="centerItem" >
			 	<img name="esymbol" style="vertical-align: middle;" src="\images\ecology8\request\workflowTitle_wev8.png"/>
			 	<a style="color: grey; margin-right: 10px; margin-left: 8px; vertical-align: middle;" href="javascript:onNewRequest(256,0,0);">采购任务单通用类-测试 </a>
			</div>
       </div> 
       <div class="clear"></div>
</div>

<div class="lettercontainer">
     <div class="C  signalletter" style="color:#953735;">相关客户</div>
     	
	 <div class="letterline" style="background:#953735;"></div> 
	 
	 <div class="itemdetail">
		 <div class="centerItem">
			 	<img name="esymbol" style="vertical-align: middle;" src="\images\ecology8\request\workflowTitle_wev8.png"/>
				<a style="color: grey; margin-right: 10px; margin-left: 8px; vertical-align: middle;" href="javascript:onNewRequest(187,0,0);"> 采购任务单-通用类 </a>
		 </div>
      </div> 
		
	  <div class="itemdetail">
			<div class="centerItem">
			 	<img name="esymbol" style="vertical-align: middle;" src="\images\ecology8\request\workflowTitle_wev8.png"/>
			 	<a style="color: grey; margin-right: 10px; margin-left: 8px; vertical-align: middle;" href="javascript:onNewRequest(256,0,0);">采购任务单通用类-测试 </a>
			</div>
       </div> 
       <div class="clear"></div>
</div>

<br />
<br />
	 
</div>

</body>
</html>