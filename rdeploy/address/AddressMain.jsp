<!DOCTYPE HTML>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />

<HEAD>
<title>通讯录</title>

<script type="text/javascript" src="/js/select/script/jquery-1.8.3.min_wev8.js"></script>
<script> var jq183=$; </script>

<script type="text/javascript" src="/wui/common/jquery/jquery.min_wev8.js"></script>

<script type="text/javascript" src="/js/ecology8/jNice/jNice/jquery.jNice_wev8.js"></script>
<link rel="stylesheet" href="/js/ecology8/jNice/jNice/jNice_wev8.css" type="text/css" />

<link rel="stylesheet" href="/rdeploy/address/css/base_address_wev8.css" type="text/css" />
<jsp:include page="/social/SocialUtil.jsp"></jsp:include>

<LINK href="/social/js/jquery.atwho/css/jquery.atwho_wev8.css" type=text/css rel=STYLESHEET>
<script src="/social/js/jquery.atwho/js/jquery.atwho_wev8.js"></script>
<script src="/social/js/jquery.atwho/js/jquery.caret_wev8.js"></script>

<script type="text/javascript" src="/cowork/js/jquery.fancybox/fancybox/jquery.mousewheel-3.0.4.pack_wev8.js"></script>
<script type="text/javascript" src="/cowork/js/jquery.fancybox/fancybox/jquery.fancybox-1.3.4_wev8.js"></script>
<link rel="stylesheet" type="text/css" href="/cowork/js/jquery.fancybox/fancybox/jquery.fancybox-1.3.4_wev8.css" media="screen" />

<link type='text/css' rel='stylesheet'  href='/rdeploy/address/js/treeviewAsync/address.eui.tree_wev8.css'/>
<script language='javascript' type='text/javascript' src='/rdeploy/address/js/treeviewAsync/jquery.treeview_wev8.js'></script>
<script language='javascript' type='text/javascript' src='/rdeploy/address/js/treeviewAsync/jquery.treeview.async_wev8.js'></script>

<script type="text/javascript" src="/social/js/bootstrap/js/bootstrap.js"></script>
<link rel="stylesheet" type="text/css" href="/social/js/bootstrap/css/bootstrap.css" />

<script src="/social/js/imconfirm/IMConfirm.js"></script> 
<link rel="stylesheet" href="/social/js/imconfirm/IMConfirm.css"/>
<!-- 图片浏览处理库 -->
<script src="/social/js/drageasy/drageasy.js"></script>

<script src="/social/js/Social_wev8.js"></script>
<script src="/social/js/SocialGroup_wev8.js"></script>

<%@ include file="/social/SocialUploader.jsp" %>

<link rel="stylesheet" href="/rdeploy/address/css/address_wev8.css" type="text/css" />
<jsp:include page="/rdeploy/address/AddressUtil.jsp"></jsp:include> 
<script src="/social/im/js/IMUtil_wev8.js"></script>

</HEAD>
<%
int userid=user.getUID();
int pageSize = 999;
String item=Util.null2String(request.getParameter("item"));
String menuItem=Util.null2String(request.getParameter("menuItem"));

%>	
<body class="imMainbg">

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<style>
	.dataLoading{position:absolute;top:0px;bottom:0px;left:0px;right:0px;background: url('/express/task/images/bg_ahp_wev8.png');display: none;z-index:1000}
	.atwho-view{}
	.imMainbg{
	   /*background:url(/social/images/im_bg_wev8.jpg);*/
	   filter:progid:DXImageTransform.Microsoft.AlphaImageLoader(sizingMethod='scale');
	   -moz-background-size:100% 100%;
	   background-size:100% 100%;
	}
</style>
<!-- 右键菜单 -->
<div tabindex="9" class="rightMenudiv">
	
</div>
<!-- 图片预览 -->
<div class="IMConfirm"></div>
<!-- 聊天窗口图片浏览 -->
<!-- layer -->
<div class="mengbanLayer"></div>

<!-- 文件下载 -->
<iframe id="downloadFrame" style="display: none"></iframe>

<div id="IMbg" class="IMbg" style="display:none;"></div>
<div class="imMainbox" id="imMainbox">
	<div class="addrRightdiv">
		<div class="imTopTitle">详细信息</div>
		<div class="clearConfirmBtn flexbox-container" style="display:none" onclick="clearUpheadCells();">
			<img src="/rdeploy/address/img/clear_ico_wev8.png"/>
			清空
		</div>	
		<div class="defaultdiv" id="imDefaultdiv">
			<div id="displaypane" class="displayPane">
				<!-- 暂无信息显示 -->
				<div class="noInfoDis dis">
					<div style="margin-top:200px;">
						<img src="/rdeploy/address/img/noinfos_wev8.png">
					</div>
					<div style="color:#E4E4E4;margin-top:20px;font-size:16px;">暂无信息</div>
				</div>
				<!-- 个人名片显示 -->
				<div class="personInfoDis dis" style="display: none">
					<div class="personInfoCard">
					</div>
					<div class="sendPMsgBtn" onclick="openIMChat(this, '0');">发消息</div>
				</div>
				<!-- 群名片显示 -->
				<div class="groupInfoDis dis" style="display: none">
					<div class="groupInfoCard">
					</div>
					<div class="sendPMsgBtn" onclick="openIMChat(this, '1');">进入群聊</div>
				</div>
				<!-- 头像列阵显示 -->
				<div class="userHeadsDis dis" style="display: none">
					
				</div>
			</div>
		</div>
	</div>
	<div class="addrLeftdiv">
			<div class="imTopBox">
				<div class="imSearchdiv">
					<div class="imInputdivWrap">
						<input type="text" value="  姓名/首字母/移动电话" onfocus="dropRecent(event, this)" 
							onclick="javascript:$(this).select();" class="imInputdiv"/>
						<div class="imSearchBtn" onclick="doSearch();"></div> 
						<div class="clear"></div>
					</div>
				</div>
				<div class="imAddMemberBtn" onclick="doAddNewMember();">添加人员</div>
				<div class="clear"></div>
			</div 
			<!-- 顶部导航 -->
			<div class="imToptab" id="imToptab">
				<div class="tabitem" _target="recent">
					<div class="tabname">最近</div>
				</div>
				
				<div class="tabitem activeitem" _target="dept">
					<div class="tabname">同部门</div>
				</div>
				
				<div class="tabitem" _target="lower">
					<div class="tabname">下属</div>
				</div>
				
				<div class="tabitem" _target="hrmOrg">
					<div class="tabname">组织</div>
				</div>
				
				<div class="tabitem" _target="hrmGroup">
					<div class="tabname">常用组</div>
				</div>
				<div class="clear"></div>
			</div>
			<div class="clear"></div>
			<!-- 顶部导航 -->
			
			<!-- 左侧菜单 -->
			<div class="leftMenus">
				<div id="searchResultListDiv" class="leftMenudiv">
					<input type="text" value="姓名/首字母/移动电话" maxlength="50" onkeyup="doHandleKeyUpdown(event);doSearch($(this).val())" onclick="javascript:$(this).select();" class="imSearchInputdiv">
					<div class="imSearchClose"></div>
					<div id="imSearchList" class="imSearchList _hideit scrollbar"></div>
				</div>
				<div id="recentListdiv" class="leftMenudiv scrollbar" style="height:478px;background:#FFF;overflow:auto;display:block;">
					<div class='dataloading' style='text-align:center;height:50%;padding-top:50%;'>
						<img src='/express/task/images/loading1_wev8.gif'/>
					</div>
				</div>
				<div id="deptListdiv" class="leftMenudiv scrollbar" style="height:100%;overflow:auto;display:none;">
					
				</div>
				<div id="lowerListdiv" class="leftMenudiv scrollbar" style="height:100%;background:#FFF;overflow:auto;display:none;">
					
				</div>
				<div id="hrmOrgListdiv" class="leftMenudiv scrollbar" style="height:100%;background:#FFF;overflow:auto;display:none;">
					
				</div>
				<div id="hrmGroupListdiv" class="leftMenudiv scrollbar" style="height:100%;background:#FFF;overflow:auto;display:none;">
					
				</div>
			</div>
			
	</div>
	<!-- 底部区域 -->
	<div class="addrBottomdiv">
		<div class="imBottomBox flexbox-container">
			<div onclick="changeLaunchState(this);/*DiscussUtil.addDiscuss();*/" class="adddiscussDiv" >
				<div id="launchIco" class="launchIco"></div>
				<div style="float:left">发起群聊</div>
				<div class="clear"></div>
			</div>
		</div>
		<div class="imBootomPane">
			<div class="addComfirmBtn" style="display:none" onclick="confirmLaunchDisc();">确定</div>
			<div class="addComfirmBtn cancelStyle" style="display:none" onclick="cancelLaunchDisc();">取消</div>
		</div>
	</div>
</div>

<div id="msgbox" class="msgbox winbox"></div>

<div id="viewdivBox" class="chatdivBox winbox" style="display:none;overflow:auto;z-index: 11"></div>

<style>
.popbox{position:fixed;left:223px;right:319px;top:0px;bottom:0px;background:#fff;display:none;}
</style>


<div id="relatedMsgdiv" class="chatgroupmsga" style="position: absolute;height: 25px;background-color: #D6E8F9;top: 61px;z-index: 1;margin: 5px;display:none;" >
	<div class="msghead" style="float: left;margin-left: 15px;margin-top: 1px;">
		<img src="" class="head22 userhead">
	</div>
	<div class="msghead msgContent" style="float: left;line-height: 25px;margin-left: 10px;">11111111111111111111</div>
	<div class="clearmsg" onclick="cleargroupmsg(this)" ></div>
	<div class="clear"></div>
</div>

<!-- 会话模板 -->
<div class="converTemp chatItem" style="display:none;" onclick="showConverChatpanel(this)" onmousedown="goMounseHandler(this,event)" >
	<div class="itemleft">
		<img src="/messager/usericon/loginid20150415172144.jpg" class="head35 targetHead"/>
	</div>
	<div class="itemconverright">
		<div>
			<div class="targetName ellipsis left"></div>
			<div class="latestTime right"></div>
			<div class="clear"></div>
		</div>
		<div style="margin-top:3px;">
			<div class="msgcontent ellipsis left"></div>
			<div class="msgcount right">0</div>
			<div class="clear"></div>
		</div>
	</div>
	<div class="clear"></div>
</div>

<!-- 聊天记录模板 -->
<div id="tempChatItem" class="chatItemdiv" style="display:none;">
	<div class="chatRItem">
			<div class="chatHead">
				<img src="" class="head35 userimage" onclick="showConverChatpanel($(this).parents('.chatItemdiv'))">
			</div>
			<div class="chattd">
				<div class="chatName"></div>
				<div class="clear"></div>
				<div class="chatArrow"></div>
				<div class="chatContentdiv">
					<div class="chatContent"></div>
					<div class="clear"></div>
				</div>
				<div class="clear"></div>
			</div>
			<div class="clear"></div>
	</div>	
</div>

<!-- 附件发送模板 -->
<div class="accitem" id="accMsgTemp" style="display:none;">		
	<div class="accicon" style="background:url('/social/images/acc_doc_wev8.png') no-repeat center center;"></div>										
	<div class="accContent">							
	  <div>
	  	<div class="filename ellipsis opdiv" style="width:180px;float:left;" _fileId="0" onclick="viewIMFile(this)">社交平台需求说明书.doc</div>							
	    <div class="filesize" style="float:left;">(4.82M)</div>	
	    <div class="clear"></div>
	  </div>
	  <div class="sendok">
	  文件发送成功				
	  </div>
	  <div class="accline"></div>
	  <div class="optiondiv">
	    <a href="javascript:void(0)" class="opdiv" _fileId="0" onclick="viewIMFile(this)">查看</a>						
	    <a href="javascript:void(0)" class="opdiv" _fileId="0" onclick="downAccFile(this)" >下载</a>
	  </div>
	</div>
	<div class="clear"></div>  
	<div class="acccomplete"></div>		
</div>

<!-- 附件列表模板 -->
<div class="accitem" id="accFileItemTemp" _fileid="0" style="display:none;">
	<div class="accicon" style="background:url('/social/images/acc_default_wev8.png') no-repeat center center;"></div>
	<div class="acccdiv">
		<div>
			<a href="javascript:void(0)" class="fileName opdiv" onclick="viewIMFile(this)">文件名称</a>
		</div>
		<div style="margin-top:10px;">
			<span class="fileSize">大小</span>
			<span class="senderName">发送人&nbsp;&nbsp;发送日期</span>
		</div>
	</div>
	<div class="btn1 download imDownload opdiv"  onclick="downAccFile(this)">下载</div>
	<div class="clear"></div>
</div>
<!-- 头像模板 -->
<div id="headCellTemp" class="headCellItem" style="display:none;" 
	onmouseenter="$(this).find('.mremove').show();"
	onmouseleave="$(this).find('.mremove').hide();">
	<div>
		<img src="/social/images/head_group.png" class="head35 mhead" onclick="DiscussUtil.showPersonalInfo(this);">
	</div>
	<div class="mname">曾东平</div>
	<div class="mremove" title="移除此人" onclick="removeCurCell(this);">-</div>
</div>
<!-- 分享消息模板 -->
<div id="shareMsgTemp" class="shareMsgItem" style="display:none;">
	<div class="shareTitle">
		 流程		
	</div>
	<div class="shareContentdiv">
		<div class="shareContent">
			
		</div>
		<div class="shareDetail opdiv" onclick="viewShare(this)" _shareid="0" _sharetype="">
			详细信息&nbsp;&nbsp;>
		</div>
	</div>
</div>

<div id="relateddivTemp" class="chatgroupmsga" style="position: absolute;height: 25px;background-color: #D6E8F9;top: 61px;z-index: 1;width:100%;display:none;" >
	<div style="float: left;margin-left: 15px;margin-top: 1px;">
		<img _hrmid="1" src="" class="userHead head22">
	</div>
	<div class="msgContent" style="float: left;line-height: 25px;margin-left: 10px;">余海群:&nbsp;&nbsp;test</div>
	<div class="clearmsg" onclick="cleargroupmsg(this)" ></div>
	<div class="clear"></div>
</div>


<div id="hrmcard" class="hrmcard"></div>

<audio style="width: 0px;height: 0px;display: none;" src="http://webim.demo.rong.io/WebIMDemo/static/images/sms-received.mp3" controls="controls"></audio>

</body>

<script type="text/javascript">

  var _color="#995dd8"; //模块基本色
  var _module="home";   //模块
  var _localhost="";
  var labelcount = 0;
  var pageIndex = 1;
  var dialog = null;
  
  //监听窗口状态
	$(window.self).focus(function(){
		IMUtil.cache.isWindowFocus = 1;
	}).blur(function(){
		IMUtil.cache.isWindowFocus = 0;
	});
  
  $(document).ready(function(){	
  	parentWin = window.parent;
  	loginuserid = '<%=userid%>';
  	//初始化中间区域高度
  	var clientHeight=$(window).height();
  	var clientWidth=$(window).width();
  	
  	$("#imMainbox .leftMenus").height(clientHeight-$("#imMainbox .leftMenus").offset().top-50);
  	
  	//$("#imMainbox .defaultdiv").width(clientWidth-312);
  	
  	/*
  	var imMainTop=(clientHeight-$("#imMainbox").height())/2;
  	var imMainLeft=(clientWidth-$("#imMainbox").width())/2;
  	$("#imMainbox").css({"top":imMainTop,"left":imMainLeft});
  	
  	$("#centerLeftbox").css("min-height",clientHeight-20);
  	*/
  	//getConversationList(); //获取最近聊天
  	
  	//loadUserInfo(); //加载人员信息
  	
  	//loadSettingInfo();//加载设置信息
  	
  	loadRecent(); //加载最近
  	
  	initIMNavTop(); //初始化顶部
  	
	initBodyClick(); //初始化页面单击事件 	
	
	initPageEvent();
	
  	$('#imMainbox .scrollbar').perfectScrollbar();
  	$('#content').perfectScrollbar();
  	
	initHrmCard(); //初始化人员卡片
	//绑定滚动条事件，保证当前窗口滚动条处于最上层
	$("#imMainbox .chatListbox").live('hover',function(event){ 
		if(event.type=='mouseenter'){ 
			var scrollbarid=$(this).attr("_scrollbarid");
			if($(this).hasClass("fileList")){
				scrollbarid=$(this).find(".acclist").attr("_scrollbarid");
			}
			$("#imMainbox .chatListScrollbar").css({"z-index":"1000"});
			$("#"+scrollbarid).css({"z-index":"10001"}).show();
		}else{ 
			//doSomething... 
		} 
	})
	
	//发起群聊移动效果绑定
	$(".addrBottomdiv .adddiscussDiv").live("hover", function(event){
		var launchIcon = $(this).find('.launchIco');
		if(event.type=='mouseenter'){
			if(!launchIcon.hasClass("launchOn"))
				launchIcon.addClass("launchHover");
		}else{ 
			launchIcon.removeClass("launchHover");
		} 
	});
  });
  
	function dosearch(obj) {
		$(obj).parent().hide();
		var keyword = $(obj).text();
		$('#groupsearchinput').val(keyword);
		$('#groupsearchinput').parents('.searchRdiv').find('.searchbtn2').click();
	}
	
	function showSearchReulst(keyword){
		var searchpanel = $('.msgcenter .searchpanel');
		var left=24;
		var top=57;
		var param = {"operation":"searchGroupname","keyword":keyword}
			 
		displayLoading(1);
		$.post("/social/group/SocialGroupHtmlOperation.jsp",param,function(data){
			if(data == '') return;
			searchpanel.html(data);
		  	searchpanel.fadeIn(500);
		  	displayLoading(0);
		});
		
		searchpanel.css({"left":left,"top":top}).show();
		stopEvent();
	}
  
  function delImg(obj){
  	$(obj).parents(".imgitemdiv").remove();	
  	var imgCount = $(".imgBox .fsUploadProgress .imgitemdiv").length;
	if(imgCount<9 && 0<imgCount){
  		$(".imgBox .imgAdddiv").show();
  		$("#centerLeftbox").find('.appimg').addClass('appimg2');
  	}else {
  		$("#centerLeftbox").find('.appimg').removeClass('appimg2');
  	}
  }
  
  function remarkImgUploadCallback(contentTarget,docid,file){
  			//alert("file.id："+file.id);
  		var swffileid=file.id;
  		var swffile=$("#"+swffileid);
  		var url="/weaver/weaver.file.FileDownload?fileid="+docid;
  		$(".imgBox #"+swffileid+" .defimg").attr("src",url).attr("href",url);
  		$(".imgBox #"+swffileid+" .fileProgress").remove();
  		$(".imgBox #"+swffileid).attr("_imageid",docid);
  		
  		initFancyImg($(".imgBox #"+swffileid+" .defimg"));
  		
  		if($(".imgBox .fsUploadProgress .imgitemdiv").length==9){
  			$(".imgBox .imgAdddiv").hide();
  		}
  		
  		$("#centerLeftbox").find('.appimg').addClass('appimg2');
  }		
  
  function remarkAccUploadCalssback(contentTarget,docid,file){
  		$("#centerLeftbox").find('.appacc').addClass('appacc2');
  		
  		var swffileid=file.id;
  		var swffile=$("#"+swffileid);
  		$(".accBox #"+swffileid+" .fileProgress").remove();
  		$(".accBox #"+swffileid).attr("_accid",docid);
  		
  }
  
  function showPopBox(obj){
  	hidePopBox();
  	$(".imgBox .imgArrow").css("left",$(obj).offset().left-240);
  	$(".appacc .accArrow").css("left",$(obj).offset().left-240);
  	$(obj).find(".popBox").show();
  	stopEvent();
  }
  
  function hidePopBox(obj){
  	$(".popBox").hide();
  	stopEvent();
  }
  
  //解散群或者退出群删除群菜单
  function delGroupMenuItem(groupid){
  	$("#chat_1_"+groupid).remove();
  }
  
  //加载通讯录数据
  function loadIMDataList(target, userid){
  	  if(target=="hrmOrg"||target=="hrmGroup"){
  			$("#"+target+"Listdiv").html("<ul id='"+target+"Tree' class='"+target+"' style='width: 100%'></ul>");
  			$("#"+target+"Tree").treeview({
		       url:"/rdeploy/address/AddressHrmOrgTree.jsp?operation="+target
		    });
  	  }else if(target=="tempSearch") {
      		var keyword = getKeyword();
      		var url = "/social/im/SocialIMLeft.jsp?menuType="+target+"&keyword="+keyword;
      		$.post(encodeURI(url),function(data){
		  		$("#searchResultListDiv>.imSearchList").html(data);
		  		var searchRestSize = parseInt($("#hrmListSize").val());
		  		$("#imSearchList .chatItem").on("click", function(){
		  			doItemClick(this);
		  		});
		  		if(searchRestSize <= 0) {
		  			showEmptyResultDiv(1, "imSearchList", "未查到联系人", 200);
		  		}else{
		  			showEmptyResultDiv(0, "imSearchList", "");
		  		}
		  	});
      }else{
      		if(userid == undefined) userid = "";
		  	$.post("/rdeploy/address/AddressLeft.jsp?menuType="+target+"&uId="+userid,function(data){
		  		var trimData = $.trim(data);
		  		$("#"+target+"Listdiv").html(trimData);
		  		$("#"+target+"Listdiv .chatItem").on("click", function(){
		  			doItemClick(this);
		  		});
		  		if(target == 'recent'){
		  			var listdiv = $('#recentListdiv');
		  			if(trimData.indexOf('class=\"chatItem') == -1){
		  				listdiv.addClass('noContactBg');
		  				listdiv.append("<div class='noContactTip'>您还没有联系人哦，快邀请大家加入吧</div>");
		  				listdiv.append("<div class='addMemberNormal' onclick='doInvitationResource();'>+  邀请成员</div>");
		  			}else{
		  				listdiv.removeClass('noContactBg');
		  				listdiv.find('.addMemberNormal').remove();
		  				listdiv.find('.noContactTip').remove();
		  			}
		  		}
		  	});
	 }
  }
function hrmOrgOnmouseOver(nodeid, obj)
{
	var nid = unescape(nodeid);
	if(nid.indexOf('person') < 0)
	{
		$img = $("<img />");
		$img.attr("id",nid+"Img");
		$img.css("right","15px");
		$img.css("margin-top","-4px");
		$img.css("position","absolute");
		$img.css("cursor","pointer");
		$img.attr("src","/rdeploy/address/img/hrmtree_launchchat_wev8.png");
		$img.hover(
			function(){
				$(this).attr("src","/rdeploy/address/img/hrmtree_launchchat_hot_wev8.png");
			},
			function(){
				$(this).attr("src","/rdeploy/address/img/hrmtree_launchchat_wev8.png");
			}
		);
		$img.click(function() {
	        doLaunchChat(nid, 'hrmOrg');
	        event.cancelBubble = true;
	        return false;
	    });
	    $(obj).children("span").append($img); 
	}
	$(obj).children('span').find("a").addClass("hrmBlueStyle");
	try{
		event.stopPropagation();
	}catch(e){
		event.cancelBubble = true;
	}
}

function hrmOrgOnmouseOut(nodeid)
{
	var nid = unescape(nodeid);
	if(nid.indexOf('person') < 0)
	{
		 $(document.getElementById(nid+"Img")).remove();
	}
	$(document.getElementById(nid)).children('span').find("a").removeClass("hrmBlueStyle");
}


function hrmGroupOnmouseOver(nodeid, obj)
{
	var nid = unescape(nodeid);
	if(nid == 'privateGroup')
	{
		$addgroup = $("<img />");
		$addgroup.attr("id",nid+"groupImg");
		$addgroup.css("right","15px");
		$addgroup.css("position","absolute");
		$addgroup.attr("src","/rdeploy/address/img/hrmtree_addprivategroup_wev8.png");
		$addgroup.hover(
			function(){
				$(this).attr("src","/rdeploy/address/img/hrmtree_addprivategroup_hot_wev8.png");
			},
			function(){
				$(this).attr("src","/rdeploy/address/img/hrmtree_addprivategroup_wev8.png");
			}
		);
		$addgroup.click(function() {
	        doAdd(nid);
	        event.cancelBubble = true;
	        return false;
	    });
	    $(obj).children("span").append($addgroup);
	}
	else if(nid.indexOf('|') < 0)
	{
		$img = $("<img />");
		$img.attr("id",nid+"Img");
		$img.css("right","15px");
		$img.css("margin-top","-4px");
		$img.css("position","absolute");
		$img.css("cursor","pointer");
		$img.attr("src","/rdeploy/address/img/hrmtree_launchchat_wev8.png");
		$img.hover(
			function(){
				$(this).attr("src","/rdeploy/address/img/hrmtree_launchchat_hot_wev8.png");
			},
			function(){
				$(this).attr("src","/rdeploy/address/img/hrmtree_launchchat_wev8.png");
			}
		);
		$img.click(function() {
	        doLaunchChat(nid, 'hrmGroup');
	        event.cancelBubble = true;
	        return false;
	    });
	    
	    $(obj).children("span").append($img);
	    var hasEditRight = $(obj).attr("_haseditright");
	    if(hasEditRight == undefined) hasEditRight = 'true';
	    if(hasEditRight == "true"){
		    	
		    $editImg = $("<img />");
			$editImg.attr("id",nid+"editImg");
			$editImg.css("right","62px");
			$editImg.css("position","absolute");
			$editImg.attr("src","/rdeploy/address/img/hrmtree_edit_wev8.png");
			$editImg.hover(
				function(){
					$(this).attr("src","/rdeploy/address/img/hrmtree_edit_hot_wev8.png");
				},
				function(){
					$(this).attr("src","/rdeploy/address/img/hrmtree_edit_wev8.png");
				}
			);
			$editImg.click(function() {
		        doEdit(nid);
		        event.cancelBubble = true;
		        return false;
		    });
		    
		    $delImg = $("<img />");
			$delImg.attr("id",nid+"delImg");
			$delImg.css("right","43px");
			$delImg.css("position","absolute");
			$delImg.attr("src","/rdeploy/address/img/hrmtree_del_wev8.png");
			$delImg.hover(
				function(){
					$(this).attr("src","/rdeploy/address/img/hrmtree_del_hot_wev8.png");
				},
				function(){
					$(this).attr("src","/rdeploy/address/img/hrmtree_del_wev8.png");
				}
			);
			$delImg.click(function() {
		        doDelGroup(nid);
		        event.cancelBubble = true;
		        return false;
		    });
		    
		    $(obj).children("span").append($editImg).append($delImg);
	    }
	}
	//添加文字样式
	$(obj).children('span').find("a").addClass("hrmBlueStyle");
	try{
		event.stopPropagation();
	}catch(e){
		event.cancelBubble = true;
	}
}

function hrmGroupOnmouseOut(nodeid)
{
	var nid = unescape(nodeid);
	if(nid == 'privateGroup')
	{
		 $(document.getElementById(nid+"groupImg")).remove();
	}
	else if(nid.indexOf('|') < 0)
	{
		$(document.getElementById(nid+"Img")).remove();
		$(document.getElementById(nid+"editImg")).remove();
		$(document.getElementById(nid+"delImg")).remove();
	}
	$(document.getElementById(nid)).children('span').find("a").removeClass("hrmBlueStyle");
}

//////////////////////////////////////////////////
			var dialog = null;
			var dWidth = 700;
			var dHeight = 500;
			
			function doDelGroup(id){
				window.top.Dialog.confirm("你确定要删除这条记录吗?",function(){
						jQuery.ajax({
							url:"/hrm/group/GroupOperation.jsp?operation=deletegroup&groupid="+id,
							type:"post",
							async:true,
							complete:function(xhr,status){
								refreshHrmList();
							}
						});
				});
			}
			
			
			function doOpen(url,title,_dWidth,_dHeight){
				if(dialog==null){
					dialog = new window.top.Dialog();
				}
				dialog.currentWindow = window;
				dialog.Title = title;
				dialog.Width = _dWidth ? _dWidth : dWidth;
				dialog.Height = _dHeight ? _dHeight : dHeight;
				dialog.Drag = true;
				dialog.maxiumnable = true;
				dialog.URL = url;
				dialog.closeHandle = function(){refreshHrmList();};
				dialog.show();
			}
			
			function doAdd(){
				doOpen("/rdeploy/address/group/HrmDialogTab.jsp?_fromURL=hrmGroup&method=HrmGroupAdd&isdialog=1","新建自定义组");
			}
			
			function doEdit(id){
				doOpen("/hrm/HrmDialogTab.jsp?_fromURL=hrmGroup&method=HrmGroupAdd&isdialog=1&id="+id,"编辑自定义组");
			}
			//发起聊天
			function doLaunchChat(id, target){
				var current = $(document.getElementById(id));
				if(current.hasClass("personNode")){
					var targetid = id.substring(0, id.indexOf("|"));
					openP2PChat(targetid, current);
					
				}else{
					getAllPersonList(id, target, function(persons){
						var ids = [], names = [];
						//console.log(persons);
						//return;
						for(var i = 0; i < persons.length; ++i){
							var psn = persons[i];
							var targetid = psn.id;
							targetid = targetid.substring(0, targetid.indexOf("|"));
							var targetname = psn.targetname;
							ids.push(targetid);
							names.push(targetname);
						}
						if(persons.length > 0){
							openGroupChat(ids, names);
						}
					});
				}
			}
			//点击组织人员
			function doOrgPersonClick(id, obj){
				if(launchOn()){
					var current = $(obj).parents(".personNode");
					var targetname = current.attr("_targetname");
					var targethead = current.attr("_targethead");
					addPersonToPaneBase(id, targetname, targethead);
				}else{
					showPersonInfo(id, obj);
				}
			}
			//展示人员头像
			function showPersonHead(id, target, obj){
				if(!launchOn()) return;
				var current = $(document.getElementById(id));
				getAllPersonList(id, target, function(persons){
					for(var i = 0; i < persons.length; ++i){
						var psn = persons[i];
						var targetid = psn.id;
						targetid = targetid.substring(0, targetid.indexOf("|"));
						var targetname = psn.targetname;
						var targethead = psn.targethead;
						addPersonToPaneBase(targetid, targetname, targethead);
					}
				});
				
			}
			//点击私人讨论组
			
			function doOrgDiscussClick(targetid, obj){
				
			}
			///////////////////////////////////////////////////


  function closeAddress(){
	$("#addressdiv",window.parent).hide();
	$("#IMbg",window.parent).hide();
  }
	  
</script>

