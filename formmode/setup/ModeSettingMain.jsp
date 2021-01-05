
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="weaver.formmode.tree.CustomTreeData" %>
<%
	if (!HrmUserVarify.checkUserRight("ModeSetting:All", user)) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
	String imagefilename = "/images/hdHRM_wev8.gif";
	String titlename = "";
	String needfav = "1";
	String needhelp = "";

	String id = Util.null2String(request.getParameter("id"));
	String searchkeyname = Util.null2String(request.getParameter("searchkeyname"));
	String isExpand = Util.null2String(request.getParameter("isExpand"), "1");
	String fieldname = Util.null2String(request.getParameter("fieldname"), "");
	String infoid = Util.null2String(request.getParameter("infoid"), "");
%>


<HTML><HEAD>

<script type="text/javascript" src="/js/ecology8/middlecenter_wev8.js"></script> 
<script type="text/javascript" src="/wui/theme/ecology8/page/js/treeMenuForMiddleCenter_wev8.js"></script>   

<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET />
<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />

<link href="/css/ecology8/middlebase_wev8.css" rel="stylesheet" />
	<link href="/css/ecology8/middleleftmenu_wev8.css" rel="stylesheet" />
<style type="text/css">
#treeSwitch{
 	background-image: url("/images/ecology8/leftHideDefault_wev8.png");
    bottom: 0;
    cursor: pointer;
    height: 48px;
    left: 210px;
    position: absolute;
    width: 15px;
}

#treeSwitch:hover{
    background-image: url("/images/ecology8/leftHide_wev8.png");
}

#treeSwitch.collapse{
	background-image: url("/wui/theme/ecology8/page/images/leftShowDefault_wev8.png");
}

#treeSwitch.collapse:hover{
	background-image: url("/wui/theme/ecology8/page/images/leftShow_wev8.png");
}


</style>

<STYLE TYPE="text/css">
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
	
	 .accoutSelect{
			 	padding-top:5px;
			 	padding-left:10px;
			 	position:relative;
			 	
			 	width:110px;
			 	background-image: url("/images/ecology8/doc/down_sel_wev8.png");
			 	background-repeat: no-repeat;
			 	background-position: center right;
			 	height:20px;
			 	line-height: 20px;
			 }
			 
			.accoutBg{
				background: #adadad;
			}
        	.accoutList{
        		display:none;
        		padding-top:5px;
        		position:absolute;
        		top:35px;
        		width:160px;
        		z-index:9;
        		background: #5D5D5D;
        		padding-bottom: 5px;
        		left:70px;
        	}
        	.accountItem{
        		height:40px;
        		padding:3px;
        		cursor:pointer;
        	}
        	
        	.accountItemOver{
        		background: #6E6E6E!important;
        	}
        	
        	
        	.accountIcon{
        		float: left;
        		width:20px;
        		height:30px;
        		padding-right:5px;
        		padding-left:5px;
        	}
        	.accountContext{
        		float: right;
        		
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
        	
        	#accountChange{
        		display:none;
        	}

</style>

<script language="JavaScript">

function changeRightUrl(currModelId){
	$("#submenucontent").load("/middlecenter/left.jsp?parentid=<%=infoid%>&t="+new Date().getTime(),function(){initSubMenu()});
}

function initSubMenu(){
		if($("#submenu").find("li").length==0){
			return;
		}
		var menuwidth = $("#submenu").width();
		var max = parseInt(menuwidth/100);
		
		$(".dropDownMenu").empty();
		$(".dropDownMenu").append($("#submenu").find("li:gt("+max+")"))
		$("#submenu").find("li:gt("+max+")").remove();
		if($(".dropDownMenu").find("li").length>0){
			$("#submenu").append("<li class='dropDown'><img src='/middlecenter/images/down_wev8.png'></li>")
		}
		$("#submenu").find(".dropDown").bind("click",function(){
			if(jQuery(".dropDownMenu").is(":hidden")){
		    	var top = jQuery(this).offset().top
		    	jQuery(".dropDownMenu").css("top",(top+35)+"px")
		    	jQuery(".dropDownMenu").css("left","225px")
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
	           var target =$(this).attr("target");
	           if(url!=""){
	           		if(target=="mainFrame"&&(menuid!=10128&&menuid!=10129&&menuid!=10130)){
	           			$("#mainFrame").attr("src",url);
	           		}else{
	           			window.open(url);
	           		}
	           }
			getDeployedApp($(this).attr("menuid"),true);
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
			var formEngineli = "<li class=\"menuitem formEngineSet\" onclick=\"formEngineSetup(this);\" title=\"<%=SystemEnv.getHtmlLabelName(126145, user.getLanguage()) %>\" style=\"float:right;\"></li>";
			jQuery("#submenu").append(formEngineli);
        }else if(menuid==10108){
			//移动引擎
       	   	loadMobileEngine(url);
       	}	
}

function loadFormEngine(url,isLoad){
	var formEnginFrame=jQuery("#formEngine");
	var formEngineDoc=jQuery(document.getElementById("formEngine").contentWindow.document);
	var rightFrameUrlObj=formEngineDoc.find("#rightFrameUrl");
	var currModelIdObj=formEngineDoc.find("#currModelId");
	if(currModelIdObj.length==0||!currModelIdObj.val()||currModelIdObj.val()==""){
		setTimeout(function (){
			loadFormEngine(url,isLoad);
		},500);
		return;
	}
	var t = new Date().getTime();
	url = url+"?t="+t;
	rightFrameUrlObj.val(url);
	jQuery("#mainFrame").attr("src",url+"&modelId="+currModelIdObj.val());
	if(isLoad){
		formEnginFrame.css("opacity", "1");
	}
}

function loadMobileEngine(url,isLoad){
	var mobileEngineFrame=jQuery("#mobileEngine");
	if(mobileEngineFrame.length>0){
		var mobileEngineDoc=jQuery(document.getElementById("mobileEngine").contentWindow.document);
		var rightFrameUrlObj=mobileEngineDoc.find("#rightFrameUrl");
		var currMobileAppIdObj=mobileEngineDoc.find("#currMobileAppId");
		rightFrameUrlObj.val(url);
		jQuery("#mainFrame").attr("src",url+"?id="+currMobileAppIdObj.val());
		if(isLoad){
			mobileEngineFrame.css("opacity", "1");
		}
	}else{
		var leftMenuHeight=jQuery("#leftMenu").height();
		//建模引擎
		var leftMenuFrame=jQuery("<iframe id='mobileEngine' frameborder='0' style='width: 100%;height:100%;opacity: 0;' onload='loadMobileEngine(\""+url+"\",true)'/>").attr("src","/mobilemode/MobileSettings.jsp");
		$("#drillmenu").empty().height(leftMenuHeight).append(leftMenuFrame);
	}
}

function formEngineSetup(obj){
	$(".selected").removeClass("selected");
	var formEngineDoc=jQuery(document.getElementById("formEngine").contentWindow.document);
	var rightFrameUrlObj=formEngineDoc.find("#rightFrameUrl");
	var currModelIdObj=formEngineDoc.find("#currModelId");
	jQuery("#mainFrame").attr("src","/formmode/setup/FormEngineSettings.jsp?modelId="+currModelIdObj.val());
}
	

function expandOrCollapse(){
	var treeSwitch = $("#treeSwitch");
	var leftFrameTd = $("#leftFrameTd");
	var isexpand = treeSwitch.attr("isexpand");
	if(isexpand==1){
		treeSwitch.addClass("collapse");
		treeSwitch.attr("isexpand","0");
		treeSwitch.css("left","0px");
	}else{
		treeSwitch.removeClass("collapse");
		treeSwitch.attr("isexpand","1");
		treeSwitch.css("left","210px");
	}
	leftFrameTd.toggle();
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
</script>
</HEAD>
<body  style="height: 100%;overflow: hidden;">
		<TABLE class=viewform width="100%" id=oTable1 height="100%" cellpadding="0px" cellspacing="0px" scroll="no">
			<colgroup>
				<col style="width: 225px;" >
				<col style="width: *" >
			</colgroup>
			<TBODY>
				<tr style="height: 40px;">
					<td>
					<div class="hrmInfo" style="width: 225px;overflow-x:hidden; " >
	                        <jsp:include page="/wui/theme/ecology8/page/hrmInfo.jsp"></jsp:include>
					</div>
					</td>
					<td>
					<div style="background:#f8f8f8;height:40px; " >
						<div id="submenucontent">
						</div>
						<ul class="dropDownMenu">
						</ul>
					</div>
					</td>
				</tr>
				<tr style="height: 100%">
					<td colspan="2" style="height: 100%">
						<table id="innerTable" style="width: 100%;height: 100%" border="0" >
							<colgroup>
								<col style="width: 225px;" >
								<col style="width: *" >
							</colgroup>
							<tr>
							
							<%if("10006".equals(infoid)){%>
								<td class="w-225" id="leftmenuTD" style="vertical-align: top; height: 535px;">
									<div id="leftMenu" tabindex="5000" style="height: 495px; overflow-y: hidden; outline: none;">
										<div id="drillmenu" class="w-all" style="height: 495px;">
											<IFRAME id="mobileEngine" src="/mobilemode/MobileSettings.jsp" width="100%" height="100%" frameborder=no scrolling=auto></IFRAME>
										</div>
									</div>
								</td>
							<%}else{%>
								<td id="leftFrameTd" name="leftFrameTd" height=100%  width="225px" style="padding: 0px; background-color: #53a2e0 !important">
								<IFRAME name="formEngine" id="formEngine" src="/formmode/setup/main.jsp?id=<%=id%>&searchkeyname=<%=URLEncoder.encode(searchkeyname, "utf-8")%>"
									width="100%" height="100%" frameborder=no scrolling=auto>
									<%=SystemEnv.getHtmlLabelName(15017, user.getLanguage())%></IFRAME>
								</td>
							<%}%>
							
							<td height=100% id=oTd2 name=oTd2 width="*">
								<IFRAME name="mainFrame" id="mainFrame"
									src=""
									width="100%" height="100%" frameborder=no scrolling=auto>
									<%=SystemEnv.getHtmlLabelName(15017, user.getLanguage())%></IFRAME>
									 
								<div id="treeSwitch" style="left: 210px; bottom:0px;"
									onclick="expandOrCollapse();"  isexpand="1"></div>
							</td>
							</tr>
						</table>
					</td>
				</tr>
			</TBODY>
		</TABLE>
	</body>

</html>
