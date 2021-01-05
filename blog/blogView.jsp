 
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.hrm.settings.BirthdayReminder"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<HTML>
<HEAD>
<title></title>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<LINK href="css/blog_wev8.css" type=text/css rel=STYLESHEET>
<link type='text/css' rel='stylesheet'  href='js/treeviewAsync/eui.tree_wev8.css'/>
<script language='javascript' type='text/javascript' src='js/treeviewAsync/jquery.treeview_wev8.js'></script>
<script language='javascript' type='text/javascript' src='js/treeviewAsync/jquery.treeview.async_wev8.js'></script>

<script type="text/javascript" src="/wui/theme/ecology7/jquery/js/zDialog_wev8.js"></script>
<script type="text/javascript" src="/wui/theme/ecology7/jquery/js/zDrag_wev8.js"></script> 
<%@ include file="/systeminfo/leftMenuCommon.jsp" %>


<link rel="stylesheet" href="/css/ecology8/request/leftNumMenu_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/leftNumMenu_wev8.js"></script>
<script type="text/javascript" src="/js/weaver_wev8.js"></script>
<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
<link rel="stylesheet" href="/css/ecology8/request/searchInput_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/searchInput_wev8.js"></script>
<link rel="stylesheet" href="/css/ecology8/request/seachBody_wev8.css" type="text/css" />
<link rel="stylesheet" href="/css/ecology8/request/hoverBtn_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/hoverBtn_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/request/titleCommon_wev8.js"></script>

<jsp:include page="blogUitl.jsp"></jsp:include>

<style type="">
 .tabItem{
 	font-size: 12px;
 	color: white;
 	padding-left: 12px;
 }
</style>
</HEAD>
<%
int userid=user.getUID();
String item=Util.null2String(request.getParameter("item"));
String menuItem=Util.null2String(request.getParameter("menuItem"));
String blogid=Util.null2String(request.getParameter("blogid"));
String src="";
//BirthdayReminder birth_reminder = new BirthdayReminder();
//birth_reminder.remindAdministrator(100);

if("attention".equals(item))
	src="myAttentionFrame.jsp?"; 
else if("rdeploy".equals(item))
	src="myBlog.jsp?from=rdeploy&menuItem="+menuItem;
else if("viewBlog".equals(item))
	src="viewBlog.jsp?blogid="+blogid;
else 
	src="myBlog.jsp?menuItem="+menuItem;
src+="&"+request.getQueryString();
%>	
<body scroll=no style="overflow-y:hidden">
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<!--
 <table cellspacing="0" cellpadding="0" class="flowsTable" style="width:100%;"  >
-->
	<div id="blogLeftdiv" style="position:absolute;left:0px;width:280px;border-right:1px solid #BDBDBD;display:<%=item.equals("rdeploy")?"none":""%>;height:100%;">
		<div style="border-bottom: 1px solid #dadada;">
			<div class="topMenuTitle" style="border:0px !important;">
				<div class="" style="margin-left: 0px !important;width: 100%">
					<div style="width: 135px;position:relative;" onmouseleave="if(!jQuery('#moreInfo').is(':hidden')) showTab();">
						<div>
							<div id="typeTitle" _seltype="attention" style="padding-left:10px;cursor: pointer;height:40px;line-height:40px;color:#000;font-weight:bold;font-size:15px;" onclick="showTab(this)">
							    <img src="/blog/images/attention_sel_wev8.png" id="selectImg" align="absmiddle">
							    <span id="selectSpan" style="font-size:15px;"><%=SystemEnv.getHtmlLabelName(26469,user.getLanguage())%></span>
							    <img src="/images/ecology8/doc/down_wev8.png" id="moreImg" align="absmiddle" style="margin-left:8px;">
							</div>
						</div>
						<div style="display: none;background-color: #adadad;" id="moreInfo" >
							<!-- 我关注的 -->
							<div  style="cursor: pointer;height:40px;line-height:40px;padding-left:10px;" id="attention" _itemtype="attention" onclick="changeTab(this)">
								<span style="width:10px;display:inline-block;">
									<img src="/images/ecology8/doc/current_wev8.png" class="seltype_img" id="attention_sel">
								</span>
							    <img src="/blog/images/attention_wev8.png" align="absmiddle" style="padding-left:10px;">
							    <span class="tabItem" style="font-weight:normal;"><%=SystemEnv.getHtmlLabelName(26469,user.getLanguage())%></span>
							</div>
						
							<!-- 组织机构 -->
							<div  style="cursor: pointer;height:40px;line-height:40px;padding-left:10px;" id="hrmOrg" _itemtype="hrmOrg" onclick="changeTab(this)">
							    <span style="width:10px;display:inline-block;">
							    	<img src="/images/ecology8/doc/current_wev8.png" class="seltype_img" id="hrmOrg_sel"  style="display:none;">
							    </span>
							    <img src="/blog/images/hrmOrg_wev8.png" align="absmiddle" style="padding-left:10px;">
							    <span class="tabItem" style="font-weight:normal;"><%=SystemEnv.getHtmlLabelName(16455,user.getLanguage())%></span>
							</div>
						
							<!-- 可查看的 -->
							<div  style="cursor: pointer;height:40px;line-height:40px;padding-left:10px;" id="canview" _itemtype="share" onclick="changeTab(this)">
							   <span style="width:10px;display:inline-block;">
							   		<img src="/images/ecology8/doc/current_wev8.png" class="seltype_img" id="share_sel" style="display:none;">
							   </span>
							   <img src="/blog/images/share_wev8.png" align="absmiddle" style="padding-left:10px;">
							   <span class="tabItem" style="font-weight:normal;"><%=SystemEnv.getHtmlLabelName(33311,user.getLanguage())%></span>
							</div>
						
						</div>
					</div>
				</div>
				
			</div>
			<div id="searchInput" class="blogsearch">
				<div class="searchdiv" >
					<input type="text"  class="searchInput" id="searchUserName">
					<div class="middle searchImg" onclick="searchAttention()">
						<img class="middle" style="vertical-align:top;margin-top:2px;" src="/images/ecology8/request/search-input_wev8.png">
					</div>
				</div>
			</div>
		</div>
		
		<div>
			<table border=0 id="itmeList" height=100% class="liststyle" style="margin:0px;" width=100% cellpadding="0" cellspacing="0">
				<tr>
					<td style="margin:0px;padding:0px;height:100%" id="blogListTD"> 
						<div id="divListContentContaner" style="position: static;height: 100%;width: 280px;overflow:auto;">
							<div id="listItems" style="padding-bottom: 15px;"></div>
                            <div id="loadingdiv" title="<%=SystemEnv.getHtmlLabelName(81558,user.getLanguage())%>" style="width: 100%;margin-bottom:10px;margin-top:10px;" align="center">
							         <img src='/express/task/images/loading1_wev8.gif' align="absMiddle">
							 </div>
						</div>
					</td>
				</tr>
			</table>
		</div>
		
	</div>
	
	<div id="blogRightdiv" style="position:absolute;right:0px;left:<%=item.equals("rdeploy")?"0px":"281px"%>;bottom:0px;top:0px;">
		<iframe id='ifmBlogItemContent' src="<%=src%>" frameborder="0" height="100%" width="100%"></iframe>
	</div>
	
<!--	
	<tr>
		<td style="width:23%;background:#fff !important;width:280px !important;height:556px;" class="flowMenusTd">
			<div class="flowMenuDiv">
				<div style="height:100%;position:relative;" id="overFlowDiv1">
					<table border=0 id="itmeList" height=100% class="liststyle" style="margin:0px;display:<%=item.equals("attention")?"":"none"%>" width=100% cellpadding="0" cellspacing="0">
						<tr>
							<td style="margin:0px;padding:0px;height:100%" id="blogListTD"> 
								<div id="divListContentContaner" style="position: static;height: 100%;width: 280px;overflow:auto;">
									<div id="listItems" style="padding-bottom: 15px;"></div>
		                            <div id="loadingdiv" title="<%=SystemEnv.getHtmlLabelName(81558,user.getLanguage())%>" style="width: 100%;margin-bottom:10px;margin-top:10px;" align="center">
									         <img src='/express/task/images/loading1_wev8.gif' align="absMiddle">
									 </div>
								</div>
							</td>
						</tr>
					</table>
				</div>
			</div>
		</td>
	</tr>
</table>
  -->
</body>
<script>
  window.notExecute = true;
  var listType = "attention";//默认选中tab类型
  var menuItem = '<%=menuItem%>';
  var item = '<%=item%>';
  jQuery(function(){
        if(item != 'attention') {
            $("#blogLeftdiv").hide();
            $("#blogRightdiv").css({"left":"0px"});
        }
  
      	jQuery("#moreInfo").find("div").mouseover(function(){
      		jQuery(this).css("background-color","#8a8a8a");
      	});
      	jQuery("#moreInfo").find("div").mouseout(function(){
      		jQuery(this).css("background-color","#adadad");
      	})
  });

  function showTab(obj){
	  	if(jQuery("#moreInfo").is(":hidden")){
	  		jQuery("#moreInfo").show();
	  		jQuery("#moreImg").attr("src","/images/ecology8/doc/down_sel_wev8.png");
	  		jQuery("#typeTitle").css("background-color","#adadad").css("color","#fff");
	  		var seltype=jQuery("#typeTitle").attr("_seltype");
	  		jQuery("#selectImg").attr("src","/blog/images/"+seltype+"_wev8.png");
	  	}else{
	  		jQuery("#moreInfo").hide();
	  		jQuery("#moreImg").attr("src","/images/ecology8/doc/down_wev8.png");
	  		jQuery("#typeTitle").css("background-color","#f5f5f5").css("color","#000");
	  		var seltype=jQuery("#typeTitle").attr("_seltype");
	  		jQuery("#selectImg").attr("src","/blog/images/"+seltype+"_sel_wev8.png");
	  	}
  }
  
  function changeTab(obj){
	  	showTab();
	  	var itemType =$(obj).attr("_itemtype");
	  	listType=obj.id;
	  	if(itemType=='share'||itemType=="attention"){
	  		jQuery("#searchInput").show();
	  	}else{
	  		jQuery("#searchInput").hide();
	  	}
	  	
	  	jQuery("#typeTitle").attr("_seltype",itemType);
	  	
	  	jQuery(".seltype_img").hide();
	  	jQuery("#"+itemType+"_sel").show();
	  	
	  	jQuery("#selectImg").attr("src","/blog/images/"+itemType+"_sel_wev8.png");
	  	jQuery("#selectSpan").html(jQuery(obj).find("span").text());
		
	    if(itemType=="attention"){
	       initScroll();
	    }else{
	       removeScroll();
	    }   
	    initContentHeight();
	    loadCoworkItemList(itemType);  
   }
  
  function initContentHeight(){
    	if($("#searchInput").is(":hidden"))
    		$("#divListContentContaner").height(document.body.clientHeight-50);
    	else
    		$("#divListContentContaner").height(document.body.clientHeight-70);	
  }
  
  jQuery(document).ready(function(){
    if("<%=item%>"=="attention"||"<%=item%>"=="rdeploy"){
       initScroll();
       $("#divListContentContaner").height(document.body.clientHeight-70);
       loadCoworkItemList();
    }
    
    $(".blogItem").live("mouseenter",function(){
    	$(this).addClass("blogItem_hover");
    	$(this).find(".blogbtn").fadeIn();
    }).live("mouseleave",function(){
    	$(this).removeClass("blogItem_hover");
    	$(this).find(".blogbtn").fadeOut();
    });
    
	//绑定tab页点击事件
	jQuery(".item").bind("click", function(){
  		var itemType=jQuery(this).attr("type");
		if(itemType=="coworkArea"){
		  dropDownCoworkAreas();
		}
		if(jQuery("#itmeList").is(":hidden")){
			jQuery("#itmeList").show();
	    }
		
  		if(jQuery(this).hasClass("itemSelected"))
  			return;
	  	else{
	  		jQuery(".itemSelected").removeClass("itemSelected");
	  		jQuery(this).addClass("itemSelected");
	  	    initData();
            if(itemType!="coworkArea")
	  	       loadCoworkItemList(itemType);
	  	}
  	});
  	
  	$("#searchUserName").bind("keypress",function(event){
  		if(event.keyCode==13)
  			searchAttention();
  	});
});
  function dblclickTree(blogid,type,obj){
  	openBlog(blogid, type, obj);
  }				     
  function openBlog(blogid,type,obj){
  	if(type==2||type==3) return ;
	var url="/blog/myAttentionFrame.jsp?type="+type+"&blogid="+blogid;
	if(type==1)
		url="/blog/viewBlog.jsp?blogid="+blogid;
	displayLoading(1,"page"); 
	var attentionframe=$("#ifmBlogItemContent").contents().find("#attentionframe");
	attentionframe.attr("height","100%");
	if(attentionframe.length==1){
		attentionframe.attr("src",url);
	}else{
		jQuery("#ifmBlogItemContent").attr("src",url);
	}
	afterLoading();
	if(obj){
		 var status=$(obj).attr("_status");
		 if(status!="0") //无查看权限状态下，不改变阅读状态
		 	jQuery(obj).find(".newimg").hide();
		 jQuery(obj).parent().find(".blogItem_selected").removeClass("blogItem_selected");
		 jQuery(obj).addClass("blogItem_selected");
	}
 }

    //添加到收藏夹
    function openFavouriteBrowser(){
	   var fav_uri=jQuery("#ifmBlogItemContent").attr("src");
	   fav_uri=fav_uri.replace("from=cowork","");
	   fav_uri = escape(fav_uri); 
	   var fav_pagename=jQuery("title", document.frames("ifmBlogItemContent").document).html();
	   fav_pagename = encodeURI(fav_pagename);
	   window.showModalDialog("/favourite/FavouriteBrowser.jsp?fav_pagename="+fav_pagename+"&fav_uri="+fav_uri+"&fav_querystring=");
    }
    //显示帮助
    function showHelp(){
       var operationPage = "http://help.e-cology.com.cn/help/RemoteHelp.jsp";
       var screenWidth = window.screen.width*1;
       var screenHeight = window.screen.height*1;
       var isEnableExtranetHelp = <%=isEnExtranetHelp%>;
       if(isEnableExtranetHelp==1){
    		//operationPage = "/formmode/apps/ktree/ktreeHelp.jsp";
    		operationPage = '<%=KtreeHelp.getInstance().extranetUrl%>';
       }
       window.open(operationPage+"?pathKey=blog/myAttention.jsp","_blank","top=0,left="+(screenWidth-800)/2+",height="+(screenHeight-90)+",width=900,status=no,scrollbars=yes,toolbar=yes,menubar=no,location=no");
    }
    
  //提交回复时，提交等待
  function displayLoading(state,flag){
  if(state==1){
        //遮照打开
        var bgHeight=document.body.scrollHeight; 
        var bgWidth=window.parent.document.body.offsetWidth;
        jQuery("#bg").css("height",bgHeight,"width",bgWidth);
        jQuery("#bg").show();
        
        if(flag=="save")
           jQuery("#loadingMsg").html("<%=SystemEnv.getHtmlLabelName(23278,user.getLanguage())%>");   //正在保存，请稍等...
        else if(flag=="page")
           jQuery("#loadingMsg").html("<%=SystemEnv.getHtmlLabelName(19945,user.getLanguage())%>");   //页面加载中，请稍候...
        else if(flag=="data"||flag=="search")
           jQuery("#loadingMsg").html("<%=SystemEnv.getHtmlLabelName(19205,user.getLanguage())%>");   //正在获取数据,请稍等...  
              
        //显示loading
	    var loadingHeight=jQuery("#loading").height();
	    var loadingWidth=jQuery("#loading").width();
	    jQuery("#loading").css({"top":'45%',"left":'51%'});
	    jQuery("#loading").show();
    }else{
        jQuery("#loading").hide();
        jQuery("#bg").hide(); //遮照关闭
    }
}

	function searchAttention(){
		var itemType=jQuery("#typeTitle").attr("_seltype");
		var searchUserName=$("#searchUserName").val();
		if(searchUserName==""){
			listType=itemType;
	    }else{
	    	listType="searchList";
	    }
	    if(listType=="attention"){
		     initScroll();
		}else{
			 removeScroll();
		}
        loadCoworkItemList(itemType);
	}

   /*滚动加载处理*/  
    var index=0;           //起始读取下标
	var hght=0;             //初始化滚动条总长
	var top=0;              //初始化滚动条的当前位置
	var preTop=0;
	var currentpage=0;       //当前页初始值
	var total=0;
	var flag=true;         //每次请求是否完成标记，避免网速过慢协作类型无法区分 成功返回数据为true
	var pagesize=0;
	
	//初始化滚动
	function initScroll(){
	      index=30;           //起始读取下标
		  hght=0;             //初始化滚动条总长
		  top=0;              //初始化滚动条的当前位置
		  preTop=0;
		  currentpage=1;       //当前页初始值
		  total=0;
		  flag=true;         //每次请求是否完成标记，避免网速过慢协作类型无法区分 成功返回数据为true
		  pagesize=30;
	     
	     //获取主页记录总数，如果index大于total则绑定滚动加载事件
	     jQuery.post("blogOperation.jsp",{"operation":"getMyAttentionCount","searchUserName":jQuery("#searchUserName").val()},function(data){
            total=jQuery.trim(data);
	        if(index<total){
	         	// alert($("#overFlowDiv").height());
			 jQuery("#divListContentContaner").bind("scroll",function(){
				  hght=this.scrollHeight;//得到滚动条总长，赋给hght变量
				  top=this.scrollTop;//得到滚动条当前值，赋给top变量
				  //判断滚动条当前位置是否超过总长的1/3，parseInt为取整函数,向下滚动时才加载数据
				  if(this.scrollTop>parseInt(this.scrollHeight/10)&&preTop<this.scrollTop){
				   	 show();
				  }
			      preTop=this.scrollTop;//记录上一个位置
			 });
			
	       }		 
	     });
	}
	
	//删除滚动
	function removeScroll(){
	    jQuery("#divListContentContaner").unbind("scroll");     
	}
	
	//按类别加载协作列表
	function loadCoworkItemList(itemType){
		var url = "blogList.jsp?listType="+listType+"&searchUserName="+encodeURI(encodeURI(jQuery("#searchUserName").val()));
        if(itemType) {
            url += "&itemType=" + itemType;
        }
		jQuery("#loadingdiv").show();
		jQuery("#listItems").html(""); 
		if(listType=="hrmOrg"){
			$("#divListContentContaner").css("background-color","#f5f5f5").css("padding-top","10px");
		}else{
			$("#divListContentContaner").css("background-color","#fff").css("padding-top","0px");
		}
		jQuery.post(url,function(data){
            jQuery("#listItems").html(data);	
            jQuery("#loadingdiv").hide();	
		});
	}
	
	function show(){
	    if(flag){
			index=index+pagesize;
			if(index>total){                    //当读取数量大于总数时
			   index=total;                     //页面数据量等于数据总数
			   jQuery("#divListContentContaner").unbind("scroll"); 
			}
			
			flag=false;
			currentpage=currentpage+1;          //取下一页
			jQuery("#loadingdiv").show();  
		    jQuery.post("blogList.jsp",
		    		{"listType":"attention","currentpage":currentpage,"pagesize":pagesize,"total":total,"searchUserName":encodeURI(encodeURI(jQuery("#searchUserName").val()))},
		    		function(data){
				    jQuery("#listItems").append(data);
				    hght=0;
				    top=0;
				    flag=true;
				    jQuery("#loadingdiv").hide();  
				    
			});
		}
	} 
/*滚动加载处理*/	
   
   function afterLoading(){
		var iframe=$("#ifmBlogItemContent")[0];
		if (iframe.attachEvent){   
			 iframe.attachEvent("onload", function(){        
			 	displayLoading(0);
		     });
	    }else {   
			iframe.onload = function(){      
			    displayLoading(0);
		    };
		}
	}
   
</script>
