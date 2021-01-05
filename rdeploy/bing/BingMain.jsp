<!DOCTYPE HTML>
<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@page import="java.security.ProtectionDomain"%>
<%@ include file="/social/im/SocialIMInit.jsp"%>
<jsp:useBean id="MobileDingService" class="weaver.mobile.ding.MobileDingService" scope="page" />

<html>
  <head>
    <!-- <link rel="stylesheet" type="text/css" href="/rdeploy/assets/css/common.css"> -->
    <link rel="stylesheet" type="text/css" href="/rdeploy/bing/css/bing_wev8.css">
    
	<jsp:include page="/rdeploy/bing/BingUtil.jsp"></jsp:include> 
  <%
  String from=Util.null2String(request.getParameter("from"));
  String userid=user.getUID()+"";
  
  if(from.equals("chat")){%>
   <style>
	  	.bMain .bleft{width:auto !important;right:0px;}
	  	.bingBtn{
		  	float: right;
		  	margin-right: 10px;
		  	position: absolute;
    		right: 0;
		}
		.bSearchdiv .keyword{width:360px !important;}
		.nodata1{margin-left:45%;}
		.bright{width:0px;left:auto !important;background:#fff;z-index:100;border-left: 1px solid #e1e8f5;}
		.bMain .bSearchdiv{
			line-height: 27px;
			position: inherit;
			margin-right: 94px;
			float: left;
		}
		.bMain .imtitle {
			height:30px;line-height:30px;margin-top:5px;
		}
		
   </style>
  <%}else{%>
  	<script type="text/javascript" src="/js/select/script/jquery-1.8.3.min_wev8.js"></script>
  	<script type="text/javascript" src="/js/ecology8/jNice/jNice/jquery.jNice_wev8.js"></script>
  	<script src="/social/im/js/IMUtil_wev8.js"></script>
	<link rel="stylesheet" href="/js/ecology8/jNice/jNice/jNice_wev8.css" type="text/css" />
  <%}%>
    
  </head>
  
  <body>
  
  <div class="bMain" id="bMain">
  	<div class="bleft" id="bleft">
  		<div class="btops">
  			<div class="imtitle" style="display: none;">
				<span class="imtitleName" style="color: #3c4350;font-size: 14px;" title="<%=SystemEnv.getHtmlLabelName(126359, user.getLanguage())%>"><%=SystemEnv.getHtmlLabelName(126359, user.getLanguage())%></span><!-- 必达 -->
				<span class="imCloseSpan" onclick="closeChatWin(this)">×</span>
			</div>
	  		<div class="bSearchdiv">
	            <input type="text" name="q" onkeydown="if(event.keyCode==13) doSearchBing();" class="keyword" id="keyword" placeholder="<%=SystemEnv.getHtmlLabelName(127014, user.getLanguage())%>"><!-- 搜索内容 -->
	            <span class="input-group-btn" title="<%=SystemEnv.getHtmlLabelName(197, user.getLanguage())%>" onclick="doSearchBing(this)"></span><!-- 搜索 -->
	        </div>
	        <span class="bingBtn" onclick="addDing()"><%=SystemEnv.getHtmlLabelName(82, user.getLanguage())%></span><!-- 新建 -->
	        <div class="clear"></div>
        </div>
        
        <div class="btabs" id="btabs">
        	<div class="btabitem bactive" _datatype="all"><%=SystemEnv.getHtmlLabelName(332, user.getLanguage())%></div><!-- 全部 -->
        	<div class="btabitem" _datatype="send"><%=SystemEnv.getHtmlLabelName(127015, user.getLanguage())%></div><!-- 我发出的 -->
        	<div class="btabitem" _datatype="receive"><%=SystemEnv.getHtmlLabelName(127016, user.getLanguage())%></div><!-- 我接收的 -->
        	<div class="clear"></div>
        </div>
        
        <div class="bingList" id="bingList" style="overflow: auto;">
        	<!--
        	<div class="bitem">
        		<div class="btitle">使用帮助部分已完成，请看一下</div>
        		<div class="btime">董雷 2015-09-15 10:14：25</div>
        		<div class="m-t-5">
        			<div class="btn2 right" style="width:68px;margin-right:5px;">确认收到</div>
        			<div class="clear"></div>
        		</div>
        	</div>
        	
        	<div class="bitem bitemActive">
        		<div class="btitle">使用帮助部分已完成，请看一下</div>
        		<div class="btime">董雷 2015-09-15 10:14：25</div>
        		<div class="m-t-5">
        			<div class="bcomment">点击到详细页回复</div>
        			<div class="bok"></div>
        			<div class="clear"></div>
        		</div>
        	</div>
        	 -->
        </div>
        
  	</div>
  </div>
  <div class="bright" id="dingDetail" style="<%=from.equals("chat")?"display:none":""%>">
  		<div style="margin-left:45%;margin-top:280px;">
			<div>
				<img src="/rdeploy/address/img/noinfos_wev8.png">
			</div>
			<div style="color:#E4E4E4;margin-top:20px;font-size:16px;"><%=SystemEnv.getHtmlLabelName(127017, user.getLanguage())%></div><!-- 暂无信息 -->
		</div> 
  </div>
  
	<script>
		//获取页码
		function getPageNo(pagesize){
			var pageNo, totalLen = $("#bingList").find(".bitem").length;
			if(totalLen == 0){
				pageNo = 1;
			}else{
				pageNo = ~~(totalLen / pagesize);
				//正好是pagesize的整数,取下一页
				if(totalLen % pagesize == 0){
					pageNo++;
				}
				//不是pagesize的整数，说明上一次已经取完了
				else if(!isHasNextPage()){
					return -1;
				}
			}
			//alert(pageNo);
			return pageNo;
		}
		var pagesize = 10;//getPageSize();
		$(document).ready(function(){
			$("#btabs .btabitem").bind("click",function(){
				$("#btabs .bactive").removeClass("bactive");
				$(this).addClass("bactive");
				var datatype=$(this).attr("_datatype");
				var content=$("#keyword").val();
				var pageno = 1;
				
				getBingPageList(datatype,content,pageno,pagesize,true);
				
				try{
					var scrollbarid=IMUtil.imPerfectScrollbar($('#bingList'));
					IMUtil.showPerfectScrollbar($('#bingList'));
				}catch(e){
					$('#bingList').perfectScrollbar();
				}
				
			});
			
			$("#btabs .btabitem:first").click();
			
			//监听滚动条下拉
			initScrollLoader();
			//快速版布局调整
			if(top.versionTag == 'rdeploy' && "<%=from%>" == "chat"){
				$(".bMain .bSearchdiv").css({"float": "right"});
				$(".bMain .imtitle").show();
				bindCloseHover();
			}
		});
		
		function bindCloseHover(){
			$("#bMain").live("hover",function(event){
				if(event.type=='mouseenter'){ 
					$(this).find(".imCloseSpan").css("display", "inline-block");
				}else{ 
				  	$(this).find(".imCloseSpan").css("display", "none");
				} 
			});
			$("#bMain .bingList").hover(
				function(){
					
				},
				function(){
					var curChatwin = $(this).parents(".chatWin");
					curChatwin.find(".imCloseSpan").css("display", "none");
				}
			);
			$("#bMain .btops").hover(
				function(){
					var curChatwin = $(this).parents(".chatWin");
					curChatwin.find(".imCloseSpan").css("display", "inline-block");
				},
				function(){
				}
			);
		}
		
		function setBingListHeight(){
			var clientHeight=$(window).height();
  			var clientWidth=$(window).width();
			//alert("clientHeight:"+clientHeight + "  offsetHeight:"+$('body')[0].offsetHeight);
			$("#bingList").height(clientHeight-$("#bingList").offset().top);
		}
		
		function getBingPageList(datatype,content,pageno,pagesize,isflush,callback) {
			var blist = $("#bingList");
			var isloading = blist.attr("loading");
			if(isloading) 
				return;
			else 
				blist.attr("loading", "loading");
			//显示大loading效果
			var mystyle = {
        		"left": 0+"px", 
        		"bottom": 0+"px", 
        		"right": 0+"px",
        		"height": 20+"px",
        		"line-height": 20+"px",
        		"position": "absolute"
        	};
        	var gif = "/express/task/images/loading1_wev8.gif";
			if(pageno == 1){
				mystyle = {
					"left": 0+"px", 
		       		"bottom": 0+"px", 
		       		"right": 0+"px",
		       		"height": 600+"px",
		       		"line-height": 600+"px",
		       		"position": "absolute"
				}
				gif = "/express/task/images/loading1_wev8.gif";
			}
			//client.log("pageno:"+pageno, "pagesize:"+pagesize);
			$.post("/rdeploy/bing/BingList.jsp?datatype="+datatype,{"content":content,"pageno":pageno,"pagesize":pagesize},
				function(data){
					
					if(isflush){
						$("#bingList").html("");
					}
					//在列表没有数据并查到数据时追加
					//alert(data);
					//alert(data.indexOf("nodata1"));
					if(($.trim(data) != "" && data.indexOf("nodata1") == -1) || $("#bingList").html() == ""){
						//client.log("进行加载。。。");
						IMUtil.showLoading($("#bleft"),mystyle,gif,600,function(){
							$("#bingList").append(data);
							$('#bingList').perfectScrollbar("update");
							IMUtil.shutLoading();
							blist.removeAttr('loading');
						});
					}
					if(callback && typeof callback == 'function'){
						callback();
					}
					setBingListHeight();
			});
		}
		
		function initScrollLoader(){
			var blist = $('#bingList');
			blist.bind('mousewheel', function(event,delta, deltax, deltay){
		    	var scrollTop = $(this).perfectScrollbar("getScrollTop");
		    	var delta = IMUtil.getDeltaValue(event);
		    	var dir = delta > 0 ? 'Up' : 'Down',
		            vel = Math.abs(delta);
		        var scrollH = blist[0].scrollHeight;
		        var listH = blist[0].offsetHeight;
		        if(dir == 'Down' && scrollTop <= scrollH - listH && scrollTop >= scrollH - listH - 40){
		        //alert("scrollTop"+scrollTop);
		        //alert("scrollH"+scrollH);
		        //alert("listH"+listH);
		        	if(!isHasNextPage()){
		        		return false;
		        	}
		        	var bactive = $("#btabs .bactive");
					var datatype=bactive.attr("_datatype");
					var content=$("#keyword").val();
					var pageno = getPageNo(pagesize);
					if(pageno == -1){
						return false;
					}
        			getBingPageList(datatype,content,pageno,pagesize,false,function(){
        				//IMUtil.shutLoading();
        				blist.perfectScrollbar("update");
        			});
		        }
		        return false;
		    });
		}
		
		function isHasNextPage(){
			var blist = $('#bingList');
			if(blist.find(".bitem[_isHasNext='false']").length > 0){
				return false;
			}
			return true;
		}
		
		function closeStatusBox(){
			$("#statusDetail").css("display", "block").animate({
				'width': '0px'
			}, 400, function(){
				$(this).hide();
				$(document).unbind('click.statusdivhide');
			})
		}	
		
		//打开消息记录
		function addDing(obj){
			var title="新建必达";
		    var url="/rdeploy/bing/BingAdd.jsp";
			var diag=BingUtils.getPopDialog(title,500,450);
			diag.URL =url;
			diag.show();
			document.body.click();
		}
		
		function freshDingList(content){
			$("#btabs .btabitem:first").click();
			try{
				var senderInfo=getUserInfo(<%=userid%>);
				var targetid="bing_<%=userid%>";
				var targettype=3;
				var sendtime=new Date().getTime();
				content="<%=user.getLastname()%>:"+content;
				updateConversationList(senderInfo,targetid,targettype,content,sendtime);
			}catch(e){
			
			}
		}
		
		function doSearchBing(){
			$("#btabs .bactive").click();
		}
		
		//绑定点击事件
		function viewDing(obj){
			$("#bingList .bitemActive").removeClass("bitemActive");
			$(obj).addClass("bitemActive");
			var dingid=$(obj).attr("_dingid");
			var isNeedConfirm=$(obj).attr("_isNeedConfirm");
			if(isNeedConfirm=="0"){
				viewDetail(dingid);
			}
		}
		
		function loadStatusDetail(dingid){
			var detailUrl="/rdeploy/bing/BingConfirmStatus.jsp?dingid="+dingid;
			$("#statusDetail").load(detailUrl);
		}
		
		function viewDetail(dingid){
		
			var detailUrl="/rdeploy/bing/BingDetail.jsp?dingid="+dingid+"&from=<%=from%>";
			if("<%=from%>"=="chat"){
				
				$("#dingDetail").css("display", "block").animate({
						'width': '450px'
				}, 400, function(){
					$("#dingDetail").load(detailUrl,function(){
						loadStatusDetail(dingid);
						$(this).show();
					});
				})
				
			}else{
				$("#dingDetail").load(detailUrl,function(){
					loadStatusDetail(dingid);
					$(this).show();
				}); 
			}
		}
		
		function closeDetailBox(){
			$("#dingDetail").css("display", "block").animate({
				'width': '0px'
			}, 400, function(){
				$(this).hide();
			})
		}
		
		
		function doConfirm(obj){
			var bitem=$(obj).parents(".bitem");
			var dingid=bitem.attr("_dingid");
			$.post("/rdeploy/bing/BingOperation.jsp?operation=doConfirm",{"dingid":dingid},function(data){
				var count=Number($.trim(data));
				bitem.find(".bcomment").show();
				bitem.find(".bnew").hide();
				bitem.attr("_isNeedConfirm","0");
				$(obj).replaceWith("<div class='bok'></div>");
				BingUtils.stopEvent();
				//viewDetail(dingid);
			});
		}
		
    </script>

  </body>
</html>
