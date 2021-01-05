
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.task.TaskUtil"%>
<%@page import="weaver.conn.RecordSet"%>
<%@page import="weaver.share.ShareManager"%>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%@ page import="weaver.docs.docs.DocImageManager"%>
<jsp:useBean id="cmutil" class="weaver.task.CommonTransUtil" scope="page"/>
<jsp:useBean id="resourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="taskUtil" class="weaver.task.TaskUtil" scope="page" />
<script type="text/javascript" src="/wui/common/jquery/jquery.min_wev8.js"></script>
<script type="text/javascript" src="/blog/js/raty/js/jquery.raty_wev8.js"></script>
<LINK href="/blog/css/blog_wev8.css" type=text/css rel=STYLESHEET>
<script type="text/javascript">var languageid=<%=user.getLanguage()%>;</script>
<script type="text/javascript" src="/weaverEditor/kindeditor_wev8.js"></script>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link rel="stylesheet" href="/express/css/base_wev8.css" />
<title>message</title>
<%
String userid=user.getUID()+"";

%>
<style type="text/css">
	.imgDiv{
		clear:both;
		width:40px;
		height:40px;
		border-radius:5px;
		background-color:#666666;
		background-image:url('/express/images/1_wev8.jpg');
	}
	.taskItems{
		width:440px;
		margin-top:14px;
		color:#999999;
		white-space:nowrap;  
    	text-overflow:ellipsis;  
    	-o-text-overflow:ellipsis;  
    	overflow: hidden;  
	}
	.taskContend{
		background-color:#F3F3F3;
		border-radius:5px;
		margin-right:18px;
		color:#666666;
	}
	.taskImg{ 
		background:url('/express/task/images/meg_three_wev8.png');
		clear:both;
		height:15px;
		width:20px;
		overflow:hidden;
		background-repeat:no-repeat;
		margin-bottom:-10px;
		margin-left:20px;
	}
	.message_contend{
			clear:both;
			border-bottom-style:dashed ;
			border-width: 1px;
			border-bottom-color:#d6d7d8;
			margin-left:8px;
			margin-right:19px;
	}
	a.a1{color:#666666;;text-decoration:none;}
	a.a1:hover{color:#0080ff;text-decoration:underline;}
	
	#fbdiv a.item{height: 20px;padding:3px 6px 0px 6px;color:#759aad;text-decoration:none}
	#fbdiv a.item:hover{background:rgb(172, 191, 201);color:#fff}
	#fbdiv a.active{background:rgb(172, 191, 201);color:#fff}
	
	.moreFoot A {
			BACKGROUND: url(/blog/images/more_bg_wev8.png) repeat-x;
	}
	.moreFoot .loading EM.ico_load {
		BACKGROUND-IMAGE: url(/blog/image/loading_wev8.gif); 
		BACKGROUND-REPEAT: no-repeat;
	}
	
	.moreFoot {
		 POSITION: relative;
		 MARGIN-BOTTOM: -1px; 
		 HEIGHT: 37px; 
		 OVERFLOW: hidden; TOP: -1px;
	     FONT-SIZE: 14px !important; 
	     FONT-WEIGHT: bold;
	}
	
	.moreFoot A {
		TEXT-ALIGN: center; LINE-HEIGHT: 19px; WIDTH: 100%; DISPLAY: block; BACKGROUND-REPEAT: repeat-x;HEIGHT: 37px; COLOR: #333 !important; PADDING-TOP: 10px
	}
	.moreFoot A:hover {
		/*BACKGROUND-POSITION: 0px -99px;*/ TEXT-DECORATION: none;
		BACKGROUND: url(/blog/images/more_bg_hover_wev8.png) repeat-x;
		COLOR: #333 !important;
	}
	
	.moreFoot EM {
		PADDING-LEFT: 10px; WIDTH: 9px; DISPLAY: inline-block;HEIGHT: 16px; VERTICAL-ALIGN: text-top; OVERFLOW: hidden; CURSOR: pointer
	}
	.moreFoot EM.ico_load {
		POSITION: absolute; WIDTH: 16px; DISPLAY: none; MARGIN-LEFT: -50px; TOP: 12px; LEFT: 50%
	}
	.moreFoot .more_down{background: url('/blog/images/more_down_wev8.png') no-repeat 50% 50%;margin-left: 3px;width: 15px;}
	.moreFoot .loading EM.ico_load {
		DISPLAY: inline-block
	}
	
	.moreFoot {
		border-radius: 0 0 0 5px; -moz-border-radius: 0 0 0 5px; -webkit-border-radius: 0 0 0 5px
	}
	.moreFoot A {
		border-radius: 0 0 0 5px; -moz-border-radius: 0 0 0 5px; -webkit-border-radius: 0 0 0 5px
	}
	.moreFoot .more_down{background: url('/blog/images/more_down_wev8.png') no-repeat 50% 50%;margin-left: 3px;width: 15px;}
		
	#loading{position: absolute;top: 0px;bottom: 0px;left: 0px;right: 0px;background: url(../images/bg_ahp_wev8.png) repeat;display: none;}
	#loading div{position: absolute;top: 0px;bottom: 0px;left: 0px;right: 0px;background:url(../images/loading1_wev8.gif) center no-repeat}
</style>
<jsp:include page="/blog/blogUitl.jsp"></jsp:include>
<script type="text/javascript">
    var isTotal=false;
	jQuery(document).ready(function(){
		$(".reportItem").live("mousemove",function(){
			var isReady = $(this).attr("isReady");
			if(isReady == "0"){
				$(this).attr("isReady","1");
				var blogNum = $("#blogtotal").html();
				var newNum = blogNum -1;
				if(blogNum == "0"){
					newNum = 0;
				}
				$("#blogtotal").html(newNum);
			}
		});
	
	
	    $("#fbdiv").height($("#rightinfo").height()-70);
	    var fbWidth = $("#fbdiv").width();
	    var nameWidth = fbWidth - 150;
	    $(".taskItems").css({"width":nameWidth+"px"});
	    var loadstr = "<div style='position: absolute;top: 0px;bottom: 0px;left: 0px;right: 0px;background: url(../images/bg_ahp_wev8.png) repeat;' align='center'>"
					+"<div style='position: absolute;top: 0px;bottom: 0px;left: 0px;right: 0px;background:url(../images/loading1_wev8.gif) center no-repeat'></div></div>";
		
		jQuery(".right_items").bind('click',function(){
			jQuery(".right_items_focus").removeClass("right_items_focus");
			jQuery(this).addClass("right_items_focus");
			var tasktype=jQuery(this).attr("_type");
			if(tasktype != "feedback"){
				 $("#fblist").css({"padding-right": "0px"});
			}
			$("#moreList").remove();
			if(tasktype=="feedback"){
			   jQuery("#fbchild").show();
			   jQuery("#fbchild .item:first").click();
			}else{
			   jQuery("#fblist").html(loadstr).load("UpdateData.jsp?type="+tasktype);
			   jQuery("#fbchild").hide();
			}   
			
		});
	    
	    jQuery("#fbchild .item").bind('click',function(){
			jQuery("#fbchild .active").removeClass("active");
	        jQuery(this).addClass("active");
	        var type=jQuery(this).attr("_type");
	        $("#moreList").remove();
	        jQuery("#fblist").html(loadstr);
	        $.post("UpdateData.jsp?type="+type,function(data){
	         if(type != "blog"){
	           jQuery("#fblist").html(data);
	         }
	           if(!isTotal){
	              setTimeout("getTotal()",1000); 
	              isTotal=true;
	           }   
	        });
		});
	    
	    jQuery(".right_items_focus").click();
	});
	
	function getTotal(){
	    $.post("TaskOperation.jsp?operation=getFeedbackTotal",function(data){
	       data=eval("("+data+")");
	       $("#blogtotal").text(data.blogtotal);
	       $("#wftotal").text(data.wftotal);
	       $("#coworktotal").text(data.coworktotal);
	       $("#tasktotal").text(data.tasktotal);
	       $("#alltotal").html(""+data.alltotal+"");
	       $("#newstotal").html(""+data.newstotal+"");
	       $("#doctotal").html(""+data.doctotal+"");
	       jQuery(".right_items").addClass("right_items");
	    })
	}
	
	function getMore(obj){
	    var type=$(obj).attr("_type");
	    var totalpage=parseInt($(obj).attr("_totalpage"));
	    var pageindex=parseInt($(obj).attr("_pageindex"));
	    $("#loading").show();
	    $.post("UpdateData.jsp?operation=listmore&type="+type+"&totalpage="+totalpage+"&pageindex="+pageindex,null,function(data){
	        $(obj).before(data);
	        pageindex=pageindex+1;
	        if(pageindex>totalpage)
	           $(obj).remove();
	        else   
	           $(obj).attr("_pageindex",pageindex);
	        $("#loading").hide();   
	    });;
	}
	
	function openTask(taskid,tasktype){
	   var url="";
	   if(tasktype=="1")      //任务
	       url="/express/task/data/DetailView.jsp?taskid="+taskid;
	   else if(tasktype=="2") //流程
	       url="/workflow/request/ViewRequest.jsp?requestid="+taskid+"&isovertime=0"; 
	   else if(tasktype=="4") //文档
	       url="/docs/docs/DocDsp.jsp?fromFlowDoc=&blnOsp=false&topage=&pstate=sub&id="+taskid;
	   else if(tasktype=="5") //协作
	       url="/cowork/viewCowork.jsp?id="+taskid;   
	   else if(tasktype=="7")
	       url="/blog/viewBlog.jsp?blogid="+taskid;  
	   openFullWindowHaveBar(url);        
	}
	
	function viewUnreadMsg(msgType,event){
	    displayLoading(1,"page");
	    jQuery.post("/blog/discussList.jsp?blogid=<%=userid%>&requestType=homepageNew",function(a){
	      $("#fblist").css({"padding-right": "10px"});
	   	  jQuery("#fblist").html(a);
	      jQuery(".menuItem").each(function(){
				jQuery(this).removeClass("selected");
		  }); 
		  jQuery("#homepage").addClass("selected");
		  jQuery("#searchBtn").attr("from","homepage");  //修改搜索来源页
	      jQuery("#myBlogMenu").hide();      
	      jQuery("#reportBody").html(a.replace(/<link.*?>.*?/, ''));
		  //初始化处理图片
		  jQuery('.reportContent img').each(function(){
			  initImg(this);
		  });
		  jQuery(".blog_raty").each(function(){ //上级评分初始化
		     managerScore(this);
		     jQuery(this).attr("isRaty","true"); 
		  });
		  removeScroll();
	      displayLoading(0);
	   });
	   stopBubble(event);
	   jQuery("#loading").hide();
	}
	
	//阻止事件冒泡函数
	 function stopBubble(e)
	 {
	 	//alert(2222);
	     if (e && e.stopPropagation){
	         e.stopPropagation()
	         }
	     else{
	         window.event.cancelBubble=true
	 		}
	}
	
	//删除滚动
	function removeScroll(){
	    jQuery("#myBlogdiv").unbind("scroll");     
	}
	
	
	 function displayLoading(state,flag){
	  	if(state==1){
	        //遮照打开
	        var bgHeight=document.body.scrollHeight; 
	        var bgWidth=window.parent.document.body.offsetWidth;
	        jQuery("#bg").css("height",bgHeight,"width",bgWidth);
	        jQuery("#bg").show();
	        //alert(1);
	        if(flag=="save")
	           jQuery("#loadingMsg").html("<%=SystemEnv.getHtmlLabelName(23278,user.getLanguage())%>");   //正在保存，请稍等...
	        else if(flag=="page")
	           jQuery("#loadingMsg").html("<%=SystemEnv.getHtmlLabelName(19945,user.getLanguage())%>");   //页面加载中，请稍候...
	        else if(flag=="data")
	           jQuery("#loadingMsg").html("<%=SystemEnv.getHtmlLabelName(19205,user.getLanguage())%>");   //正在获取数据,请稍等...  
	              
	        //显示loading
		    var loadingHeight=jQuery("#loading").height();
		    var loadingWidth=jQuery("#loading").width();
		    jQuery("#loading").css({"top":'40%',"left":'30%'});
		    jQuery("#loading").show();
	    }else{
	        jQuery("#loading").hide();
	        jQuery("#bg").hide(); //遮照关闭
	    }
	}
	
</script>
</head>

<body>

<div id="rightinfo" style="width: 100%;height: 100%;position: absolute;overflow: hidden;left: 0;top: 0;right: 0;bottom: 0">
		<div style="height: 40px;line-height: 38px;"><span style=" color:#666666; font-size:12px; font-weight:600; padding-left:14px; "><%=SystemEnv.getHtmlLabelName(30902,user.getLanguage())%></span></div><!-- 最新 -->
		<div id="message" class="right_message">
			<div class="right_items right_items_focus" style="margin-left:5px;" _type="feedback"><div><%=SystemEnv.getHtmlLabelName(21950,user.getLanguage())%>(<span id="alltotal">0</span>)</div></div><!-- 反馈 -->
			<div class="right_items" _type="news"><div><%=SystemEnv.getHtmlLabelName(316,user.getLanguage())%>(<span id="newstotal">0</span>)</div></div><!-- 新闻 -->
			<div class="right_items" _type="doc"><div><%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%>(<span id="doctotal">0</span>)</div></div><!-- 文档 -->
		</div>
		<div id="fbdiv" style="overflow: auto;width: 100%">
			<div id="fbchild" style="margin-left: 15px;padding-top:5px;">
			    <a href="javascript:void(0)" _type="blog"  onclick="viewUnreadMsg('update',event)"   class="item"><%=SystemEnv.getHtmlLabelName(26467,user.getLanguage())%>(<span id="blogtotal">0</span>)</a><!-- 微博 -->
			    <a href="javascript:void(0)" _type="wf"       class="item"><%=SystemEnv.getHtmlLabelName(18015,user.getLanguage())%>(<span id="wftotal">0</span>)</a><!-- 流程 -->
			    <a href="javascript:void(0)" _type="cowork"   class="item"><%=SystemEnv.getHtmlLabelName(17855,user.getLanguage())%>(<span id="coworktotal">0</span>)</a><!-- 协作 -->
			    <a href="javascript:void(0)" _type="task"     class="item"><%=SystemEnv.getHtmlLabelName(1332,user.getLanguage())%>(<span id="tasktotal">0</span>)</a><!-- 任务 -->
			</div>
			<div id="fblist" style="overFlow-x: hidden;">
		         
		    </div>
	    </div>
	    <div id="loading" align='center'><div></div></div>
</div>		
</body>
</html>
