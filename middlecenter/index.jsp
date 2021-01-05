<!DOCTYPE HTML>
<%@page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="weaver.hrm.HrmUserVarify"%>
<%@ page import="weaver.hrm.User"%>
<%@ page import="java.util.*" %>
<%@ page import="java.awt.Toolkit" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.systeminfo.SystemEnv"%>
<%@ page import="weaver.login.Account,weaver.sitetour.PageTourCache" %>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="PluginUserCheck" class="weaver.license.PluginUserCheck" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page"/>
<%
	String selectIndex = request.getParameter("idx");
	if(selectIndex==null||selectIndex.equals(""))selectIndex="0";
	User user = HrmUserVarify.getUser (request , response) ;
	if(user==null) {
	  response.sendRedirect("/login/Login.jsp");
	  return;
	}
%>
<html>  
<head>
	<meta http-equiv="Content-Type" Content="text/html; charset=UTF-8" />
	<link href="/css/ecology8/middlebase_wev8.css" rel="stylesheet" />
	<link href="/css/ecology8/middleleftmenu_wev8.css" rel="stylesheet" />
	<link rel="stylesheet" href="/css/ecology8/middlecenter_wev8.css" type="text/css"></link>
	<link rel="stylesheet" type="text/css" href="/email/js/easyui/themes/default/easyui_wev8.css">
    <link rel="stylesheet" type="text/css" href="/email/js/easyui/themes/icon_wev8.css">
    
	<script type="text/javascript" src="/js/ecology8/jquery_wev8.js"></script>    
	<script type="text/javascript" src="/js/nicescroll/jquery.nicescroll_wev8.js"></script>
	<script type="text/javascript" src="/wui/theme/ecology8/page/perfect-scrollbar/perfect-scrollbar_wev8.js"></script>
	<script type="text/javascript" src="/wui/theme/ecology8/page/perfect-scrollbar/jquery.mousewheel_wev8.js"></script>  
	<script type="text/javascript" src="/js/ecology8/middlecenter_wev8.js"></script>   
	<script type="text/javascript" src="/js/ecology8/jQueryRotate_wev8.js"></script>    
	<script type="text/javascript" src="/wui/theme/ecology8/page/js/treeMenuForMiddleCenter_wev8.js"></script> 
	<script type="text/javascript" src="/email/js/easyui/jquery.easyui.min_wev8.js"></script> 
	<script type="text/javascript" src="/js/ecology8/lang/weaver_lang_<%=user.getLanguage()%>_wev8.js"></script>
	
	<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
	<script language="javascript" type="text/javascript" src="/js/init_wev8.js"></script>
	
	
	<script type="text/javascript">
		top.dataChange = false;
	</script> 
</head>

<body scroll=no>
	<table class="w-all h-all">
		<colgroup>
			<col width="225" />
			<col width="*" />
		</colgroup>
		<tr class="h-50">
			<td colspan="2">
				<div class="" style="height:90px;">
					<table class="w-all h-all" id="headTable">
						<tr>
							<td class="w-225 colorfff font18 middleLogo">
								<div class="h-50 p-l-10 colorfff font15" style="line-height:50px;word-break: keep-all;text-overflow: ellipsis;white-space: nowrap;display: inline-block;width: 200px;overflow: hidden;" title="e-cology | <%=SystemEnv.getHtmlLabelName(127910,user.getLanguage())%>">e-cology | <%=SystemEnv.getHtmlLabelName(127910,user.getLanguage())%></div>
								<!--
								<img src="/images/ecology8/images/logo_wev8.png" class="m-t-2 m-l-20"/>
								-->
							<div class="hrmInfo">
										<!--放置即时通讯相关的东西-->
	                                                        			<jsp:include page="/wui/theme/ecology8/page/hrmInfo.jsp"></jsp:include>
									</div>
							</td>
							<td class="relative" style="vertical-align:80%;">
								<div class="h-50 hide">
									<!-- 这是菜单的浮动层 -->
									<div id="divFloatItem" class="hide absolute h-60">
										<table class="w-all h-all">
											<tr>
												<td style="background-color:rgb(0,32,96);"></td>
											</tr>
										</table>
										<div class="left" style="width:21px;"></div>
										<div class="left" style="width:21px;"></div>
										<div class="left" style="width:18px;"></div>
									</div>
									
									<!-- 以下是菜单 -->
									<!--泛微云商店  -->
									<div tabname="泛微云商店" id="weaverShop1" class="left w-110 h-all hand toptabitem" target="weaverShop" >
										<span class="topitemmiddle"><img width="19" src="/images/ecology8/cloud_wev8.png" style="vertical-align:middle;"></span>
										<span>云商店</span>
									</div>
									
									<!--泛微模板库  -->
									<div tabname="泛微模板库" id="moduleLib1" class="left w-110 h-all hand toptabitem" target="moduleLib">
									<span class="topitemmiddle"><img width="19" src="/images/ecology8/mould_wev8.png" style="vertical-align:middle;"></span>
									<span>模板库</span>
									</div>
									
									<!--已部署应用  -->
									<div tabname="已部署应用" id="deployedApp" class="left w-110 h-all hand toptabitem firstselected" onclick="getDeployedApp();">
									<span class="topitemmiddle"><img width="19" src="/images/ecology8/app_wev8.png" style="vertical-align:middle;"></span>
									<span>部署应用</span></div>
									
									<!--权限监控中心  -->
									<div tabname="权限监控中心" id="configCenter1" class="left w-110 h-all hand toptabitem" target="configCenter">
									<span class="topitemmiddle"><img width="19" src="/images/ecology8/qx_wev8.png" style="vertical-align:middle;"></span>
									<span>权限监控</div>
								</div>
								<div class="h-50">
									<%
									
									//int screenWidth = java.awt.Toolkit.getDefaultToolkit().getScreenSize().width; 
									%>
   								
   											<div id="mainmenu" class="easyui-tabs" style="">

												       <%@ include file="/middlecenter/top.jsp"%>
		   									 </div>
   										
   										<jsp:include page="/wui/theme/ecology8/page/toolbarForMiddle.jsp"></jsp:include>
								</div>
								<div style="background:#f8f8f8;height:40px; " >
									<div id="submenucontent">
									</div>
									<ul class="dropDownMenu">
									</ul>
								</div>
								
								
							</td>
							
						</tr>
						
					</table>
				</div>		
			</td>
		</tr>
		
		<tr>
			<td colspan="2">
				<div id="ecologyMoudel" class="colorbgfff h-all">
					<table class="w-all h-all" id="ecologyMoudelContent">
						<tr>
							<td class="w-225" id="leftmenuTD" style="vertical-align:top;">
									<div id="leftMenu">
										<div id="drillmenu" class='w-all'>
										</div>
									</div>
							</td>
							<td style='background:#ffffff;vertical-align:top;' >
								<div style="width:100%;height:100%;*height:auto;">
									<iframe src="blank.html"  onload="setFrameHeight();" id="mainFrame" name="mainFrame" align="top" BORDER="0" FRAMEBORDER="no" NORESIZE="NORESIZE" height="100%" width="100%" scrolling="auto" style="overflow:hidden;"></iframe>
								</div>
							</td>					
						</tr>
					</table>
				</div>
			</td>
		</tr>
	</table>
	<div id="submenuTr" style="display:none;">
		<div id="submenusDiv" ></div>
	</div>
	 <!-- 左侧区域隐藏 -->
     <div class="e8_leftToggle" title="<%=SystemEnv.getHtmlLabelName(20721,user.getLanguage())%>"></div>
    
</body>
<link rel="stylesheet" type="text/css" href="/wui/theme/ecology8/page/perfect-scrollbar/perfect-scrollbar_wev8.css" />
<script type="text/javascript" src="/wui/theme/ecology8/page/perfect-scrollbar/perfect-scrollbar_wev8.js"></script>
<script type="text/javascript" src="/wui/theme/ecology8/page/perfect-scrollbar/jquery.mousewheel_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/lang/weaver_lang_<%=user.getLanguage()%>_wev8.js"></script>
<script type="text/javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<script type="text/javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<LINK href="/wui/theme/ecology8/jquery/js/e8_zDialog_btn_wev8.css" type=text/css rel=STYLESHEET>
 <STYLE TYPE="text/css">
 			.accoutBg{
				background: #adadad;
			}
        	.accoutList{
        		display:none;
        		padding-top:5px;
        		position:absolute;
        		top:35px;
        		width:200px;
        		z-index:100;
        		padding-bottom: 5px;
        	}
        	.accountItem{
        		height:65px;
        		cursor:pointer;
        	}
        	
        	.accoutListBox{
        		background: #ffffff;
        		border:1px solid #d4d4d4;
        		width:190px;
        		padding:0 5px;
        		top: 8px;
        		left:-18px;
        		position: absolute;
        		-moz-border-radius: 3px;
			    -webkit-border-radius: 3px;
			    border-radius:3px;
        	}
        	.accountText{
        		width:185px;
        		height: 56px;
        		margin-top:9px;
        		padding-left:5px;
        		line-height:28px;
        		white-space: nowrap;
        		overflow: hidden;
        		text-overflow:ellipsis;
        	}
        	.accountIcon{
        		width:20px;
        		height:20px;
        		right:5px;
        		position: absolute;
        		margin-top:-39px;
        	}
        	.accountContext{
        		float: right;
        		
        	}
	.leftBlockHrmDep{
	   	position: relative;
	    display: inline-block;
	    font-size: 11px;
	    cursor: pointer;
	    text-overflow: ellipsis;
	    white-space: nowrap;
	    max-width: 110px;
    }


	 .tabs-panels{
		display: none;
	}
	.tabs-container,.tabs-header{
		height:37px;
		background-color:transparent;
		border: none;
		padding-top: 0px;
		margin-left:5px;
	}
	
	.tabs-header{
		padding-top:13px!important;
	}
	
	.tabs{
		height:37px;
	}
	
	.tabs-selected .tabs-inner{
		background: #f8f8f8!important;
		height:37px;
		border-color: #f8f8f8!important;
		border: 1px!important;
		color:#6d7270!important;
	}
	
	.tabs-inner{
		background:transparent!important;
		height:37px!important;
		border: none!important;
		line-height:37px!important;
		padding-left:22px!important;
		padding-right:22px!important;
		color: #c8c8c8!important;
	}
	
	.tabs li{
		height:37px;
		border: none;
		
	}
	
	.tabs li a{
		filter:none!important;
		
	}
	
	
	.tabs-scroller-left{
		border:none;
		background: url("/wui/theme/ecology8/page/images/left_wev8.png") center 20% no-repeat;
	}
	.tabs-scroller-right{
		border:none;
		background: url("/wui/theme/ecology8/page/images/right_wev8.png") center 20% no-repeat;
	}
	#submenu{
		height: 39px;
		border-bottom: 1px solid #e5e5e5;
		padding-left: 10px
		
	}
	#submenu li{
		float:left;
		padding-left:15px;
		padding-right: 15px;
		height: 39px;
		line-height: 39px;
		color:#6c6c6c;
		cursor:pointer;
		
	}
	
	#submenu .selected{
		color:#2094ff;
	}
	
	.dropDownMenu .selected{
		color:#2094ff;
	}
	
	.dropDownMenu{
		padding-left:10px;
		display: none;
		position: absolute;
		background: #f8f8f8;
		width: 100%;
		border-bottom: 1px solid #e5e5e5;
	}
	
	.dropDownMenu li{
		float:left;
		padding-left:15px;
		padding-right:15px;
		height: 39px;
		line-height: 39px;
		color:#6c6c6c;
		cursor:pointer;
	}
	
	.dropDown{
		cursor: pointer;
		padding: 0px!important;
	}
	
	
        	.formEngineSet{
        		width: 40px; 
        		position: relative; 
        		background-image: url(/wui/theme/ecology8/page/images/plugin_wev8.png); 
        		background-attachment: scroll;
        		background-repeat: no-repeat;
        		background-position-x: center;
				background-position-y: center; 
				background-size: auto; 
				background-origin: padding-box; 
				background-clip: border-box; 
				background-color: transparent;
        	}
        	
        	.leftColor{
        		line-height: 40px;
        		height:40px;
        	}

</style>
<script type="text/javascript"><!--
	var interval = null;
	var needSetInterval = false;
	jQuery(document).ready(function(){
		
		
		var width = document.body.clientWidth-400;
		$('#mainmenu').tabs({  
		  width: width,
	      border:false,   
	      onSelect:function(title){   
	           var tab = $(this).tabs('getTab', title); 
	           var menuid = $(tab).attr("menuid");
	           var url =$(tab).attr("url");
	           var target =$(tab).attr("target");
	           if(url!=""){
	           		if(target=="mainFrame"){
	           			$("#mainFrame").attr("src",url);
	           		}else{
	           			window.open(url);
	           		}
	           }
	           
	           jQuery(".dropDownMenu").hide();
	           $("#submenucontent").html("");
	          
	           $("#submenucontent").load("/middlecenter/left.jsp?parentid="+menuid+"&t="+new Date().getTime(),function(){initSubMenu()})
	   	  }   
      	});
		updateLeftMenuHeight();
		 //前中后端切换
		 jQuery("#e8NavDH").hover(function(){
		 	jQuery(".qzhNavSpanImg").data("isOpen",false);
		 },function(){
		 	jQuery("#e8NavDH").hide();
		 	jQuery(".qzhNavSpanImg").removeClass("qzhNavSpanImgup");
		 	jQuery(".qzhNavSpanImg").data("isOpen",false);
		 });
		 jQuery(".optionNormal").hover(function(){
		 	jQuery(this).addClass("colorfff").addClass("optionSelect");
		 	var fsrc = jQuery(this).find("#e8Current").attr("src");
		 	if(fsrc && fsrc.indexOf("_sel")==-1){
		 		fsrc = fsrc.replace(/\.png/,"_sel_wev8.png");
		 		jQuery(this).find("#e8Current").attr("src",fsrc);
		 	}
		 	var src = jQuery(this).find("img:last").attr("src");
		 	if(src.indexOf("_sel")==-1){
		 		src = src.replace(/\.png/,"_sel_wev8.png");
		 	}
		 	jQuery(this).find("img:last").attr("src",src);
		 },function(){
		 	var fsrc = jQuery(this).find("#e8Current").attr("src");
		 	if(fsrc && fsrc.indexOf("_sel")!=-1){
		 		fsrc = fsrc.replace(/_sel\.png/,".png");
		 		jQuery(this).find("#e8Current").attr("src",fsrc);
		 	}
		 	var src = jQuery(this).find("img:last").attr("src");
		 	src = src.replace(/_sel\.png/,".png");
		 	jQuery(this).find("img:last").attr("src",src);
		 	jQuery(this).removeClass("colorfff").removeClass("optionSelect");
		 });
		 
		 //更多菜单
		 jQuery("#toolbarMore").hover(function(){
		 	
		 },function(){
		 	jQuery("#toolbarMore").hide();
		 	jQuery("#toolbarMore").removeClass("moreBtnSel");
		 });
		 
		 //左侧区域隐藏
		 var leftTime = null;
		jQuery(".e8_leftToggle").click(function(){
			jQuery("#leftmenuTD").toggle();
			jQuery(".e8_leftToggle").removeClass("e8_leftToggleHover");
			jQuery(".e8_leftToggle").removeClass("e8_leftToggleShowHover");
			if(jQuery("#leftmenuTD").css("display")=="none"){
				jQuery(".e8_leftToggle").addClass("e8_leftToggleShow").show();
				jQuery(".e8_leftToggle").attr("title","<%=SystemEnv.getHtmlLabelName(15315,user.getLanguage())%>");
			}else{
				jQuery(".e8_leftToggle").removeClass("e8_leftToggleShow");
				jQuery(".e8_leftToggle").attr("title","<%=SystemEnv.getHtmlLabelName(20721,user.getLanguage())%>");
			}
			if(leftTime)
				clearTimeout(leftTime);
		}).hover(function(){
			//jQuery(".e8_leftToggle").data("isOpen",false);
			if(jQuery(".e8_leftToggle").hasClass("e8_leftToggleShow")){
				jQuery(".e8_leftToggle").addClass("e8_leftToggleShowHover");
			}else{
				jQuery(".e8_leftToggle").addClass("e8_leftToggleHover");
			}
			if(leftTime)
				clearTimeout(leftTime);
		},function(){
			if(!jQuery(".e8_leftToggle").hasClass("e8_leftToggleShow")){
				jQuery(".e8_leftToggle").removeClass("e8_leftToggleHover");
				//jQuery(".e8_leftToggle").hide();
			}else{
				jQuery(".e8_leftToggle").removeClass("e8_leftToggleShowHover");
			}
			if(leftTime)
				clearTimeout(leftTime);
			//jQuery(".e8_leftToggle").data("isOpen",false);
		});
		if(jQuery.browser.msie  && jQuery.browser.version == "11.0"){
			needSetInterval = true;
		}
		 
	});
	function initSubMenu(){
		if($("#submenu").find("li").length==0){
			return;
		}
		var menuwidth = $("#submenu").width();
		var max = parseInt(menuwidth/100);
		
		$(".dropDownMenu").empty();
		$(".dropDownMenu").append($("#submenu").find("li:gt("+max+")"))
		//$(".dropDownMenu").
		$("#submenu").find("li:gt("+max+")").remove();
		if($(".dropDownMenu").find("li").length>0){
			$("#submenu").append("<li class='dropDown'><img src='/middlecenter/images/down_wev8.png'></li>")
		}
		$("#submenu").find(".dropDown").bind("click",function(){
			if(jQuery(".dropDownMenu").is(":hidden")){
		    	var top = jQuery(this).offset().top
		    	jQuery(".dropDownMenu").css("top",(top+35)+"px")
		    	jQuery(".dropDownMenu").css("left","0px")
		    	jQuery(".dropDownMenu").show();
		    	$(this).find("img").attr("src","/middlecenter/images/up_wev8.png")
	    	}else{
	    		jQuery(".dropDownMenu").hide();
	    		$(this).find("img").attr("src","/middlecenter/images/down_wev8.png")
	    		
	    	}
		})
		
		$("#submenu").find(".menuitem").bind("click",function(){
			$(".selected").removeClass("selected");
			var url =$(this).attr("url");
			var menuid = $(this).attr("menuid");
	        var target =$(this).attr("target");
	      	var parentid =$(this).attr("parentid");
			if(parentid==10005){
				//表单引擎
	        	loadFormEngine(url);
	        }else if(menuid==10108){
				//移动引擎
	       	   	loadMobileEngine(url);
	       	}else{
				if(url!=""){
	           		if(target=="mainFrame"&&(menuid!=10128&&menuid!=10129&&menuid!=10130)){
	           			$("#mainFrame").attr("src",url);
	           		}else{
	           			window.open(url);
	           		}
	           	}
				getDeployedApp(menuid,true);
			}
			
			$(this).addClass("selected")
			$("#submenu").find(".dropDown").find("img").attr("src","/middlecenter/images/down_wev8.png")
			jQuery(".dropDownMenu").hide();
		})
		
		$(".dropDownMenu").find(".menuitem").bind("click",function(){
			
			$(".selected").removeClass("selected");
			 var url =$(this).attr("url");
			 var menuid = $(this).attr("menuid");
			// alert(url)
	           var target =$(this).attr("target");
				if(parentid==10005){
					//表单引擎
		        	loadFormEngine(url);
		        }else if(menuid==10108){
					//移动引擎
		       	   	loadMobileEngine(url);
		       	}else{
			           if(url!=""){
			           		if(target=="mainFrame"&&(menuid!=10128&&menuid!=10129&&menuid!=10130)){
			           			$("#mainFrame").attr("src",url);
			           		}else{
			           			window.open(url);
			           		}
			           }
					getDeployedApp($(this).attr("menuid"),true);
		       	}
			$(this).addClass("selected")
			jQuery(".dropDownMenu").hide();
			$("#submenu").find(".dropDown").find("img").attr("src","/middlecenter/images/down_wev8.png")
		})
		parentid =$("#submenu").find(".menuitem:first").attr("parentid");
		menuid	= $("#submenu").find(".menuitem:first").attr("menuid");
		url =  $("#submenu").find(".menuitem:first").attr("url");
		if(parentid==10005){
			//表单引擎
        	loadFormEngine(url);
			//建模设置
			var formEngineli = "<li class=\"menuitem formEngineSet\" onclick=\"formEngineSetup(this);\" title=\"<%=SystemEnv.getHtmlLabelName(68,user.getLanguage())%>\" style=\"float:right;\"></li>";
			jQuery("#submenu").append(formEngineli);
        }else if(menuid==10108){
			//移动引擎
       	   	loadMobileEngine(url);
       	}else{
       		target =$("#submenu").find(".menuitem:first").attr("target");
       		if(url!=""){
	           		if(target=="mainFrame"&&(menuid!=10128&&menuid!=10129&&menuid!=10130)){
	           			$("#mainFrame").attr("src",url);
	           		}else{
	           			window.open(url);
	           		}
	           	}
			var initMenuid = $("#submenu").find(".menuitem:first").attr("menuid");
			$("#submenu").find(".menuitem:first").addClass("selected");
			getDeployedApp(initMenuid,false);
		}	
	}
	
	$(window).resize(function() {
		updateLeftMenuHeight("update");
		setFrameHeight();
	});
	
	if(jQuery.browser.msie && jQuery.browser.version=="8.0"){
		//jQuery(".toptabitem").css("padding-top","13px");
		//jQuery(".option").css("padding-top","13px");
	}
	
	function setFrameHeight(){
		try{
			jQuery("#mainFrame").closest("div").css("height",jQuery(window).height()-jQuery("#headTable").height()-2);
			jQuery(jQuery("#mainFrame").get(0).contentWindow.document.body).height(jQuery("#mainFrame").closest("div").height()-2);
			if(needSetInterval){
				if(interval != null){
					clearInterval(interval);
					interval = null;
				}
				interval=setInterval(setSubFrameHeight,500)
			}
		}catch(e){
			//alert(e);
		}
	}
	function setSubFrameHeight(){
		try{
			var frame =  $(window.frames["mainFrame"].document).find('table>tbody>tr>td>iframe');
			if(frame){
				var height = jQuery(window).height()-jQuery("#headTable").height()-2 -2 
				var frameH = $(frame[1]).height()
				if(height != frameH){
					frame.each(function(tmp){$(frame[tmp]).height(height)});
				}
			}
		}catch(e){
		}
	}
	function updateLeftMenuHeight(option){
		jQuery("#leftMenu").height(jQuery(window).height()-jQuery("#headTable").height()-jQuery(".hrmInfo").height()-2);
		jQuery("#leftmenuTD").height(jQuery(window).height()-jQuery("#headTable").height()-2);
		try{
			changeDrillmenuHeight();
		}catch(e){}
		if(!!option){
			$('#leftMenu').perfectScrollbar(option);
		}else{
			$('#leftMenu').perfectScrollbar();
		}
	}
	
	function showSelectNav(){
		jQuery('#e8NavDH').toggle();
		if(jQuery("#e8NavDH").css("display")=="none"){
			jQuery(".qzhNavSpanImg").removeClass("qzhNavSpanImgup");
			jQuery(".qzhNavSpanImg").data("isOpen",false);
		}else{
			jQuery(".qzhNavSpanImg").addClass("qzhNavSpanImgup");
			jQuery(".qzhNavSpanImg").data("isOpen",true);
		}
	}
	
	jQuery(".qzhNavSpanImg").hover(function(){
	 },function(){
	 	window.setTimeout(function(){
	 		if(jQuery(".qzhNavSpanImg").data("isOpen")){
	 			jQuery("#e8NavDH").hide();
	 			jQuery(".qzhNavSpanImg").removeClass("qzhNavSpanImgup");
	 			jQuery(".qzhNavSpanImg").data("isOpen",false);
	 		}
	 	},600);
 	});
 	
 	//$(".tabs-scroller-left").hide();	
	$.fn.tabs.methods.scrollBy= function(jq, deltaX){	// scroll the tab header by the specified amount of pixels
			return jq.each(function(){
				var opts = $(this).tabs('options');
				var wrap = $(this).find('>div.tabs-header>div.tabs-wrap');
				var pos = Math.min(wrap._scrollLeft() + deltaX, getMaxScrollWidth());
				wrap.animate({scrollLeft: pos}, opts.scrollDuration);
				function getMaxScrollWidth(){
					var w = 0;
					var ul = wrap.children('ul');
					ul.children('li').each(function(){
						w += $(this).outerWidth(true);
					});
					return w - wrap.width() + (ul.outerWidth() - ul.width());
				}
				//alert(wrap._scrollLeft()+"!"+deltaX+"@"+getMaxScrollWidth())
				
				$(".tabs-scroller-left").show();	
				$(".tabs-scroller-right").show()
				if(wrap._scrollLeft()==0&&deltaX==0){
					$(".tabs-scroller-left").hide();	
				}
				if(deltaX<0){
					if(wrap._scrollLeft()==0||wrap._scrollLeft()+deltaX<0||wrap._scrollLeft()+deltaX==0){
						$(".tabs-scroller-left").hide()
					}else{
						$(".tabs-scroller-left").show();	
					}
				}else{
					
					if(wrap._scrollLeft()+deltaX==getMaxScrollWidth()||wrap._scrollLeft()+deltaX>getMaxScrollWidth()){
						$(".tabs-scroller-right").hide()
					}else{
						$(".tabs-scroller-right").show()
					}
				}
			});
		}
function showAccoutList(){
	jQuery('#accoutList').toggle();
	if(jQuery("#accoutList").css("display")=="none"){
		jQuery(".accoutSelect").removeClass("accoutBg");
	}else{
		jQuery(".accoutSelect").addClass("accoutBg");
	}
}

jQuery("#accoutList").hover(function(){
 },function(){
 	jQuery('#accoutList').toggle();
 	jQuery(".accoutSelect").removeClass("accoutBg");
 });
 
 jQuery("#accoutImg").hover(function(){
 	$(this).attr("src","/wui/theme/ecology8/page/images/hrminfo/accoutOver_wev8.png")
 },function(){
 	$(this).attr("src","/wui/theme/ecology8/page/images/hrminfo/accout_wev8.png")
 });
 
 jQuery(".accountItem").hover(function(){
 	$(this).addClass("accountItemOver")
 },function(){
 	$(this).removeClass("accountItemOver")
 });
function formEngineSetup(obj){
	$(".selected").removeClass("selected");
	var formEngineDoc=jQuery(document.getElementById("formEngine").contentWindow.document);
	var rightFrameUrlObj=formEngineDoc.find("#rightFrameUrl");
	var currModelIdObj=formEngineDoc.find("#currModelId");
	jQuery("#mainFrame").attr("src","/formmode/setup/FormEngineSettings.jsp?modelId="+currModelIdObj.val());
}
--></script>
</html>

