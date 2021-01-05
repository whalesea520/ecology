<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/social/im/SocialIMCommon.jsp" %>
<link rel="stylesheet" href="/rdeploy/im/css/base_wev8.css" type="text/css" />
<link rel="stylesheet" href="/rdeploy/im/css/im_wev8.css" type="text/css" />

<%
String userid=""+user.getUID();
int pageSize = 999;
String item=Util.null2String(request.getParameter("item"));
String menuItem=Util.null2String(request.getParameter("menuItem"));

//获取本地人员信息
String localUserInfo=SocialIMService.getLocalUserInfo(userid);

%>	
<body class="imMainbg">

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<style>
	.dataLoading{position:absolute;top:0px;bottom:0px;left:0px;right:0px;background: url('/express/task/images/bg_ahp_wev8.png');display: none;z-index:1000}
	.atwho-view{}
	.imMainbg{
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

<!-- 文件下载 -->
<iframe id="downloadFrame" style="display: none"></iframe>

<!-- 聊天窗口 模板 -->
<iframe id="chatDivFrm" src="/rdeploy/im/IMChatTp.jsp?from=<%=from %>" style="display:none;">
</iframe>

<div id="IMbg" class="IMbg" style="display:none;"></div>
<div class="imMainbox" id="imMainbox">

	<div class="defaultdiv" id="imDefaultdiv">
		<div style="margin-top:200px;">
			<img src="/social/images/im/im_nochat_wev8.png">
		</div>
		<div style="color:ababab;margin-top:20px;font-size:16px;">未选择聊天</div>
	</div>
	<!-- 
	<div id="imLeftdiv" class="imLeftdiv scrollbar" style="display:none !imporant;">
		<div id="chatIMTabs" class="chatIMTabs">
			
		</div>
	</div>
	 -->
	<div id="imCenterdiv" class="imCenterdiv">
		<div id="chatIMdivBox" class="chatdivBox winbox chatIMdivBox"></div>
	</div>
	<!-- 右侧弹出区域 -->
	<div id="imSlideDiv" class="imSlideDiv">
		<jsp:include page="/rdeploy/im/IMDiscussSetting.jsp"></jsp:include>
		<iframe frameborder="0" scrolling="no" width="100%" height="100%"></iframe>
	</div>

	<div class="imRightdiv">
			
			<div class="imsearchdiv">
				<div class="filterOptions">
					<div id="filterSelector" value="all" onclick="IM_Ext.doDropOptions(this);">
						全部
					</div>
					<div class="seletOptions" target="filterSelector" style="display:none;">
						<div class="optionItem" value="all" onclick="IM_Ext.doSelectOption(this, 'filterSelector');">全部</div>
						<div class="optionItem" value="interest" onclick="IM_Ext.doSelectOption(this, 'filterSelector');">关注</div>
					</div>
				</div>
		  		<div class="searchdiv">
		            <input type="text" name="q" id="converSearchbox" onfocus="$(this).parent().attr('_openLock', 'true')" onkeyup="IM_Ext.doSearchConver(this, event);"
		            	onkeydown="IM_Ext.moveConverCursor(this, event);" class="keyword" id="keyword" placeholder="搜索会话标题">
		            <span class="input-group-btn" title="搜索" onclick="$(this).parent().attr('_openLock', 'true');IM_Ext.doSearchConver(this, event)"></span>
		        </div>
		        <div class="clear"></div>
	        </div>
			
			<!-- 顶部导航 -->
			
			<!-- 左侧菜单 -->
			<div class="leftMenus" style="padding-top:0px;background:#fff;height:420px;">
				
				<div id="searchResultListDiv" class="leftMenudiv" style="height:564px;padding-left:15px;background:#f4f9f8;display:none;z-index:100;display:none;">
					<input type="text" value="请输入关键字" maxlength="50" onkeyup="doSearch($(this).val())" onclick="javascript:$(this).select();" class="imSearchInputdiv">
					<div class="imSearchClose"></div>
					<div id="imSearchList" class="imSearchList _hideit scrollbar"></div>
				</div>
				<div id="recentListdiv" class="leftMenudiv scrollbar" style="height:420px;overflow:auto;display:block;">
					<div class='dataloading' style='text-align:center;height:50%;padding-top:50%;'>
						<img src='/express/task/images/loading1_wev8.gif'/>
					</div>
				</div>
			</div>
			<!-- 左侧菜单 -->
			
			<div style="height:30px;background:#5cb5d8;display:none;">
				<div onclick="DiscussUtil.addDiscuss();"class="adddiscussDiv">
					<span style="margin-left:30px;">发起群聊</span>
				</div>
			</div>
			
	</div>
</div>

<div id="msgbox" class="msgbox winbox"></div>

<div id="viewdivBox" class="chatdivBox winbox" style="display:none;overflow:auto;z-index: 11"></div>

<style>
.popbox{position:fixed;left:223px;right:319px;top:0px;bottom:0px;background:#fff;display:none;}
</style>


<!-- @提醒 -->
<div id="relatedMsgdiv" class="chatgroupmsga" style="position: absolute;background-color: #D6E8F9;top: 61px;z-index: 1;width:100%;display:none;" >
	<div style="float: left;margin-left: 15px;margin-top: 1px;">
		<img _hrmid="1" src="" class="userHead head22">
	</div>
	<div class="msgContent" style="float: left;margin-left: 10px;word-break: break-all;max-width:460px;">余海群:&nbsp;&nbsp;test</div>
	<div class="clearmsg" onclick="cleargroupmsg(this)" ></div>
	<div class="clear"></div>
</div>
<!-- R版会话模板 -->
<div class="converTemp_rdeploy chatItem" style="display:none;" onclick="IM_Ext.updateRecent(this);showConverChatpanel(this)" onmousedown="goMounseHandler(this,event)" >
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
	<div class="interestSwitch" islight="0" title="关注或取消关注" onclick="IM_Ext.lightUpItem(this);">
		<img src="/rdeploy/im/img/lightoff_wev8.png"/>
	</div>
	<div class="clear"></div>
</div>

<!-- 聊天记录模板 -->
<div id="tempChatItem" class="chatItemdiv" style="display:none;">
	<div class="chatRItem">
			<div class="chatHead">
				<img src="" class="head35 userimage" onclick="IM_Ext.updateRecent(this);showConverChatpanel($(this).parents('.chatItemdiv'))">
			</div>
			<div class="chattd">
				<div class="chatName"></div>
				<div class="clear"></div>
				<div class="chatArrow"></div>
				<div class="chatContentdiv">
					<div class="chatContent" 
						onmouseover="IM_Ext.showFloatMenu(event,this)"
						onmouseout="IM_Ext.hideFloatMenu(event,this);"></div>
					<div class="msgUnreadCount" onclick="ChatUtil.showMsgReadStatus(this)"></div>
					<div class="clear"></div>
				</div>
				<div class="clear"></div>
			</div>
			<div class="clear"></div>
	</div>	
</div>
<!-- 浮动提示 -->
<div id="warn">
	<div class="title"></div>
</div>
<!-- 消息浮动菜单模板 -->
<div id="tempchatFloatmenu" class="chatFloatmenuWrap"  style="display:none;"
		onmouseover="if(IM_Ext.isMouseLeaveOrEnter(event, this)) $(this).data('isLocked', 1).show();"
		onmouseout="if(IM_Ext.isMouseLeaveOrEnter(event, this)) $(this).data('isLocked', 0).hide();">
	<div class="chatFloatmenu" >
		<div class="floatmenuItem opCollect imShowOn" onclick="IM_Ext.doFloatMenuClick('opCollect', this);">收藏<span class="rightSplit"></span></div>
		<div class="floatmenuItem opForward imShowOn" onclick="IM_Ext.doFloatMenuClick('opForward', this);" >转发<span class="rightSplit"></span></div>
		<div class="floatmenuItem opBing imShowOn" onclick="IM_Ext.doFloatMenuClick('opBing', this);" >必达<span class="rightSplit"></span></div>
		<div class="floatmenuItem opDelete" style="display: none;" onclick="IM_Ext.doFloatMenuClick('opDelete', this);">删除</div>
		<div class="floatmenuItem opMore imShowOn" onclick="IM_Ext.imDropMenu(this);">更多</div>
		<!-- 更多子菜单 -->
		<div class="imFloatSubMenu" style="display:none;">
			<div class="floatSubMenuItem opSendToBlog imShowOn"
				onclick="IM_Ext.doSubMenuItemClick('opSendToBlog', 'opMore', this);">
				<img src="/rdeploy/im/img/floatsubmenu_golog_wev8.png">	
				<span>发送到日志<span>
			</div>
			<div class="floatSubMenuItem opSendToTask imShowOn lastItem" 
				onclick="IM_Ext.doSubMenuItemClick('opSendToTask', 'opMore', this);">
				<img src="/rdeploy/im/img/floatsubmenu_gotask_wev8.png">
				<span>转为任务</span>
			</div>
		</div>
	</div>
</div>

<!-- 附件发送模板 -->
<div class="accitem" id="accMsgTemp" style="display:none;">		
	<div class="accicon" style="background:url('/social/images/acc_doc_wev8.png') no-repeat center center;"></div>										
	<div class="accContent">							
	  <div>
	  	<div class="filename ellipsis opdiv" style="width:180px;float:left;text-align: left;" _fileId="0" onclick="viewIMFile(this)">社交平台需求说明书.doc</div>							
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
	<div class="accItemLeftPad"></div>
	<div class="accchk"><input type="checkbox"/></div>
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
	<!--<div class="btn1 download imDownload opdiv"  onclick="downAccFile(this)">下载</div> -->
	<div class="clear"></div>
	<div class="accItemRightPad"></div>
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
<!-- 任务消息模板 -->
<div id="taskMsgTemp" class="taskMsgItem" style="display:none;">
	<div class="taskMsgTitle">
		 任务<div class="taskStateTip"></div>
	</div>
	<div class="taskMsgContentdiv">
		<div class="taskMsgContent">
			<div class="taskTitle ellipsis"></div>
			<div class="taskCreator"></div>
			<div class="taskCreatime"></div>
		</div>
		<div class="taskMsgDetail opdiv" onclick="">
			<div class="taskComplete taskState" onclick="ChatUtil.completeTask(this);">完成</div>
		</div>
	</div>
</div>
<!-- 必达消息模板 -->
<div id="dingMsgTemp" class="dingMsgItem" style="display:none;">
	<div class="dingMsgTitle">
		 必达<div class="dingStateTip"></div>
	</div>
	<div class="dingMsgContentdiv">
		<div class="dingMsgContent">
			<div class="dingTitle ellipsis"></div>
			<div class="dingCreator"></div>
			<div class="dingCreatime"></div>
		</div>
		<div class="dingMsgDetail opdiv" onclick="">
			<div class="dingComfirm dingState" onclick="ChatUtil.comfirmDing(this);">确认收到</div>
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
<!-- 图文消息模板 -->
<div id="tempTextImg" class="textImgMsgItem" title="打开分享" style="display:none;">
	<div class="content">
		<div class="imgcot">
			
		</div>
		<div class="textcot ellipsis">
			
		</div>
	</div>
</div>	

<div id="hrmcard" class="hrmcard"></div>

<audio style="width: 0px;height: 0px;display: none;" src="http://webim.demo.rong.io/WebIMDemo/static/images/sms-received.mp3" controls="controls"></audio>
<script type="text/javascript">
	localconverids = [];
	localconverList = [];
	var versionTag = "rdeploy";
	var from = "<%=from%>";
</script>
<jsp:include page="/social/im/SocialIMClient.jsp"></jsp:include>
</body>

<script type="text/javascript">

  var _color="#995dd8"; //模块基本色
  var _module="home";   //模块
  var _localhost="";
  var labelcount = 0;
  var pageIndex = 1;
  var dialog = null;
  var searchConverList={};  //会话搜索信息缓存
  
  //监听窗口状态
  /*
	$(window.top).focus(function(){
		IMUtil.cache.isWindowFocus = 1;
		checkClearUnreadStatus();
	}).blur(function(){
		IMUtil.cache.isWindowFocus = 0;
	});
  */
  $(document).ready(function(){	
  	//初始化中间区域高度
  	var clientHeight=$(window).height();
  	var clientWidth=$(window).width();
  	
  	$("#recentListdiv").height(clientHeight-$("#recentListdiv").offset().top);
  	
  	/*
  	var imMainTop=(clientHeight-$("#imMainbox").height())/2;
  	var imMainLeft=(clientWidth-$("#imMainbox").width())/2;
  	$("#imMainbox").css({"top":imMainTop,"left":imMainLeft});
  	
  	$("#centerLeftbox").css("min-height",clientHeight-20);
  	*/
  	//getConversationList(); //获取最近聊天
  	
  	loadLocalUserInfo('<%=localUserInfo%>');
  	
  	loadUserInfo(); //加载人员信息
  	
  	loadLocalConvers('rdeploy');//加载本地会话
  	
  	loadSettingInfo();//加载设置信息
  	
  	initIMNavTop(); //初始化顶部
  	
	initBodyClick(); //初始化页面单击事件 	
	
	initPageEvent();
	
  	$('#imMainbox .scrollbar').perfectScrollbar();
  	$('#content').perfectScrollbar();
  	
	initHrmCard(); //初始化人员卡片
	
	//加载消息提醒监听
	initNotifHandler();
	
	//加载网页窗口监听
	initBrowerTabHandler(window.self);
	
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
	//初始化本地数据库
	ChatUtil.initLocalDB(); 
	
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
			if(data == '')
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
  
  //解散群或者退出群删除群菜单
  function delGroupMenuItem(groupid){
  	$("#chat_1_"+groupid).remove();
  }
  
  //加载通讯录数据
  function loadIMDataList(target){
  	  if(target=="hrmOrg"||target=="hrmGroup"){
  			$("#contactListdiv").html("<ul id='hrmOrgTree' class='hrmOrg' style='width: 100%'></ul>");
  			$("#hrmOrgTree").treeview({
		       url:"/social/im/SocialHrmOrgTree.jsp?operation="+target
		    });
  	  }else if(target=="recent"){ //最近
  			
      }else if(target=="tempSearch") {
      		var keyword = getKeyword();
      		var url = "/social/im/SocialIMLeft.jsp?menuType="+target+"&keyword="+keyword;
      		$.post(encodeURI(url),function(data){
		  		$("#searchResultListDiv>.imSearchList").html(data);
		  		var searchRestSize = parseInt($("#hrmListSize").val());
		  		if(searchRestSize <= 0) {
		  			showEmptyResultDiv(1, "imSearchList", "未查到联系人", 200);
		  		}else{
		  			showEmptyResultDiv(0, "imSearchList", "");
		  		}
		  	});
      }else{
		  	$.post("/social/im/SocialIMLeft.jsp?menuType="+target,function(data){
		  		
		  		if(target=="discuss"){
		  			$("#discussListdiv").html(data);
		  			$("#discussListdiv .groupItem").each(function(){
		  				var targetid=$(this).attr("_targetid");
		  				var targetObj=$(this);
		  				client.getDiscussionName(targetid,function(data){
					    	var targetName=data;
						    var targetHead="/social/images/head_group.png";
					    	targetObj.attr("_targetName",targetName).find(".groupName").html(targetName);
					    	targetObj.show();
					    });
		  			
		  			});
		  		}else{
		  			$("#contactListdiv").html(data);
		  		}
		  	});
	 }
  }
  
  function closeAddress(){
	$("#addressdiv",window.parent).hide();
	$("#IMbg",window.parent).hide();
  }
  /*关闭聊天窗口*/
  function closeChatWin(btnObj){
  	$(btnObj).parents(".chatWin").remove();
  	var curChatWins = $("#chatIMdivBox .chatWin");
  	if(curChatWins.length == 0){
  		$("#imDefaultdiv ").show();
  		$("#imCenterdiv").hide();
  	}else{
  		var firstChatwin = curChatWins.first();
  		var targetid = firstChatwin.attr("_targetid");
  		var targettype = firstChatwin.attr("_targettype");
  		var converid = getConverId(targettype, targetid);
  		$("#"+converid).click();
  	}
  }
  
</script>

