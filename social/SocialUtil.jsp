
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<%
	String userid=""+user.getUID();
%>
<script>
  var userid="<%=userid%>";
  var userLanguage = <%=user.getLanguage() %>;
  var _dynamic = "";  //动态类型
  function getUser(){
	var user=new Object();
	user.userid="<%=userid%>";
	user.username="<%=ResourceComInfo.getLastname(userid)%>";
	user.userimage="<%=ResourceComInfo.getMessagerUrls(userid)%>";	
	return user;
  }
  
  var diag=null;
  function addGroup(groupid){
	    var title="<%=SystemEnv.getHtmlLabelName(126909, user.getLanguage())%>"; // 新建群
	    var url="/social/group/SocialGroupSetting.jsp";
	    if(groupid){
	    	title="<%=SystemEnv.getHtmlLabelName(126910, user.getLanguage())%>"; //群设置
	    	url+="?groupid="+groupid;
	    }
		diag=getDialog(title,600,530);
		diag.URL =url;
		diag.show();
		document.body.click();
 } 
  
  function closeDialog(){
	if(diag){
		diag.close();
	}
  }
  
  //解散群
  function destoryGroup(groupid){
	groupid=groupid?groupid:"";
	window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(126913, user.getLanguage())%>",function(){ //确定解散该群？
		jQuery.post("/social/group/SocialGroupOperation.jsp?groupid="+groupid+"&operation=destoryGroup", {},function(data){
            // 解散成功！
	 	  	window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(126983, user.getLanguage())%>",function(){ 
	 	  		parent.parent.getDialog(parent.window).close();
	 	  		try{
	 	  		parent.parent.getParentWindow(parent.window).delGroupMenuItem(groupid);
	 	  		}catch(e){}
	 	  	});
     	});
 	});
  }
  
  /**刷新内容列表*/
  function doRefresh(){
  	getShareList(_module);
  }
  
  /**加载更多*/
  function doMoreMsg(obj) {
  	var imgType = $(obj).attr('_imgType');
  	var pageindex = $(obj).attr('_pageindex');
  	
  	displayLoading(1);
  	$.post("/social/SocialMsg.jsp?imgType="+imgType+"&operation=switch&pageindex="+pageindex,function(data){
  		$(obj).remove();
  		$("#msgcenter").append(data);
  		
  		displayLoading(0);
  	});
  }
  
  function doMore(pageindex, obj){
  	showMoreShare(_module,pageindex, obj);
  }
  
  function showMoreShare(target, pageindex, obj){
  	displayLoading(1);
  	$.post("/social/SocialShareRecord.jsp?target="+target+"&pageindex="+pageindex,function(data){
  		$(obj).remove();
  		$("#shareList").append(data);
  		
  		displayLoading(0);
  	})  	
  }

  function getShareList(target){
  	displayLoading(1);
  	$.post("/social/SocialShareRecord.jsp?target="+target+"&dyctype="+_dynamic,function(data){
  		$("#shareList").html(data);
  		if(target=="group"){
  			formateMsgImg("#shareList");
  		}	
  		displayLoading(0);
  	})
  }
  
  //格式化消息中的图片
  function formateMsgImg(target){
  	$(target+" .uimg").each(function(){
		$(this).replaceWith("[<%=SystemEnv.getHtmlLabelName(74, user.getLanguage()) %>]"); // 图片
	});
	$(target+" .faceicon").each(function(){
		$(this).replaceWith("[<%=SystemEnv.getHtmlLabelName(126865, user.getLanguage()) %>]"); //表情
	});
  }
  
  //提交回复时，提交等待
  function displayLoading(state,flag){
  
  	  //if(state==0) return ;
  	  	 
	  if(state==1){
	  		var loadingHeight=jQuery("#loadingMsg").height();
		    var loadingWidth=jQuery("#loadingMsg").width();
		    var winHeight=$(window).height();
		    var winWidth=$(window).width()
		    //alert($(window).height());
		    //alert(loadingHeight);
		    jQuery("#loadingMsg").css({"top":winHeight/2 - loadingHeight/2,"left":document.body.scrollLeft + winWidth/2 - loadingWidth/2});
		    jQuery("#dataLoading").show();
	    }else{
	        jQuery("#dataLoading").hide();
	    }
	}
  
  /**我的消息*/
  function changeMsgTypeTab(obj, imgType) {
	$("#msgcenter").load("/social/SocialMsg.jsp?imgType="+imgType+"&operation=switch").show();
	changeMsgTab(obj);
  }
  
   /**我的百科*/
  function changeBaikeTypeTab(obj, labelid) {
	$("#msgcenter").load("/social/SocialShareRecord.jsp?labelType="+labelid).show();
	changeMsgTab(obj);
  }  
  
  //切换消息类型
  function changeMsgTab(obj){
  	var msgtop=$(obj).parents(".msgtop");
 	var left=$(obj).position().left+36+($(obj).width()/2);
	var top=$(obj).position().top+54;
	msgtop.find(".msgArrow").css({"left":left,"top":top}).show();
	stopEvent();
  }
  
  //关闭消息窗口
  function closeMsgbox(obj){
  	$(obj).parents(".msgbox").hide();
  }
  
  /**我的消息*/
  
  /**我的百科*/
  var _baikeLabelid = 0;
  var _baiketype = "";
  
	//我的百科数据加载
	function changeMyDevote(obj,labelid,resourceid){
		var content = $(obj).parents(".myDevotediv").find('.seacrhinput').val();
		_baiketype = $(obj).attr("_type");
		var params = {"labelid": labelid,
					  "content": content,
					  "resourceid":resourceid};
		
		getShareListByParams(params);
		_baikeLabelid = labelid;
		$(".msgtop .moreOption").hide();
		changeMsgTab(obj);
	}	
  	
	//我的百科搜索
	function searchBaike(obj) {
		var content = $(obj).parent().find('.seacrhinput').val();
		var resourceid = $(obj).attr("_resourceid");
		var params = {"labelid": _baikeLabelid,
					  "content": content,
					  "resourceid":resourceid}
		getShareListByParams(params);
	}
  	
	//百科管理通用加载
	function getShareListByParams(params){
		var content = $("#shareList");   //所有百科页面
		var labelid = params.labelid;
		if(typeof(labelid) == 'undefined' || labelid == null || labelid == "")labelid = 0;
		_baikeLabelid = labelid;
		
		if(_baiketype == 'category')
			params.resourceid = '';
		
		if(!$('#msgbox').is(':hidden')){
			content = $('#myDevote').find('.msgcenter');   //我的百科页面
			params.listtype = 'date';
			params.type = _baiketype;
			params.target = 'baike';
		}
		
		displayLoading(1);
	 	$.post("SocialShareRecord.jsp",params,function(data){
	 		content.hide();
	 		content.html(data);
	 		content.fadeIn(500);
	 		displayLoading(0);
	 	})
	 }  
  /**我的百科 end*/
  
  
  function closeChat(obj){
  	$(obj).parents(".chatdivBox").hide();
  }
  
  //初始化左侧菜单
  function initLeftMenus(){
  	
  	$(".leftMenus .menuItemdiv").live("click",function(){
  	
  		var menuType=$(this).attr("_menuType");
  		var _url=$(this).attr("_url");
  		
  		if($(this).hasClass("menuActiveItemdiv")){
  			var status=$(this).attr("_status");
  			if($(this).find(".menugroupup").length>0||$(this).find(".menugroupdwon").length>0){
  				showChildrenMenu(this,status);
  			}	
  		}else{
  			var activeItem=$(".leftMenus .menuActiveItemdiv");
  			if($(this).find(".menugroupup").length>0){
  				showChildrenMenu($(this),0);
  			}
  			activeItem.removeClass("menuActiveItemdiv");
  			$(this).addClass("menuActiveItemdiv").css("border-left-color",_color);
  		}
  		/*	
  		if(menuType=="msg"){
  			$("#msgbox").load("/social/SocialMsg.jsp").show();
  		}
  		*/
  		if(_url){
  			$(".winbox").hide();
  			$("#msgbox").load(_url).show();
  		}
  		
  	});
  	
  	$(".leftMenus .childrenItem").live("click",function(){
  		var menuType=$(this).attr("_menuType");
  		var acceptId=$(this).attr("_acceptId");
  		
  		if($(this).hasClass("menuActiveItemdiv")){
  			if(menuType=="chat"){
  				$("#chatdivBox").show();
  			}
  			return;
  		}else{
  			var activeItem=$(".leftMenus .menuActiveItemdiv");
  			
  			activeItem.removeClass("menuActiveItemdiv");
  			$(this).addClass("menuActiveItemdiv").css("border-left-color",_color);
  			
  			if(activeItem.hasClass("childrenItem")){
  				activeItem.css("padding-left","65px");
  			}
  			if($(this).hasClass("childrenItem")){
  				$(this).css("padding-left","63px");
  			}
  			
  			$(".winbox").hide();
  			
  			if(menuType=="chat"){
  				var chatType=$(this).attr("_chatType");
				
				showChatpanel(chatType, acceptId);
  				//alert("currentTargetid:"+CHAT.currentTargetid);
				//alert("currentChatType:"+CHAT.currentChatType);
  			}
  			
  			if(menuType=="person"){
  				viewPerson(acceptId);
  			}
  		}	
  	});
  	
  	loadLeftMenus("home");
  }
  
  function viewPerson(resourceid){
  		$(".winbox").hide();
  		$("#viewdivBox").load("/social/SocialViewPerson.jsp?chatType=person&acceptId="+resourceid).show();
  }
  
  //显示聊天面板
  function showChatpanel(chatType, acceptId,chatName) {
  	var chatWinid="chatWin_"+chatType+"_"+acceptId;
  	$("#chatdivBox .chatWin").hide();
  	if($("#"+chatWinid).length==0){
  		$("#chatdivBox").append("<div id='"+chatWinid+"' class='chatWin'></div>");
  		$("#"+chatWinid).load("/social/group/SocialChat.jsp?chatType="+chatType+"&acceptId="+acceptId).show();
  	}else{
  		$("#"+chatWinid).show();
  	}
  	$("#chatdivBox").show();
	CHAT.currentTargetid=acceptId;
	CHAT.currentChatType=chatType;
	
	clearChatMsg(acceptId,userid,chatType);
  }
  
  //打开消息提醒中的聊天窗口
  function openChatWin(chatType,acceptId,chatName){
  	addChatMenuItem(chatType,acceptId,chatName);
    $("#chat_"+chatType+"_"+acceptId).click();
    
  }
  
  function addChatMenuItem(chatType,acceptId,chatName){
  	if($("#chat_"+chatType+"_"+acceptId).length==0){
  		var chatItem='<div class="childrenItem" id="chat_'+chatType+'_'+acceptId+'" _targetid="'+acceptId+'" _menuType="chat" _chatType="'+chatType+'" _acceptId="'+acceptId+'" >'+
				     '	<div class="menuName">'+chatName+'</div>'+
					 '	<div class="menuCount" style="display:none""></div>'+
					 '	<div class="clearchat" _chatType="'+chatType+'" _acceptId="'+acceptId+'"  ></div>'
					 '	<div class="clear"></div>'+
					 '</div>';
		$("#recentChatList").prepend(chatItem);			 
  	}
  }
  
  
  //人员卡片进入聊天
  function showChatpanelByCard(obj) {
  	 var chatType = $(obj).attr('_chatType');
  	 var acceptId = $(obj).attr('_acceptId');
  	 $(obj).parents('.hrmcard').hide();
  	 showChatpanel(chatType, acceptId);
  }
  
  function showMsgPanel(obj) {
 // 	 var _url = "/social/SocialMsg.jsp";
 // 	 $("#centerPopBox").load(_url).show();
 	if($(".socialremind").is(":hidden")){
		updateRemindInfo(true)
		var height;
		if($(".socialremindul").find("li").length>0){
			height= $(".socialremindul").find("li").length*35+45;
		}else{
			height = 75
		}
		$(".socialremind").css("left",$(obj).offset().left-15);
		$(".socialremind").show();
		$(".socialremind").animate({height:height+"px"})
		$(obj).removeClass("msg_note");
		$(obj).addClass("msg_none");
	}else{
		$(".socialremind").animate({height:"0px"})
		$(".socialremind").hide();
	}
	stopEvent();
  }
  
  function clearChatMsg(chatid,receiverid,chattype){
  
	var params={"chatid":chatid, "receiverid":receiverid,"chattype":chattype};
	
	jQuery.post("/social/group/SocialChatOperation.jsp?operation=markChatMsgRead",params,function(data){
		
	});
	
	$("#chat_"+chattype+"_"+chatid+" .menuCount").hide();
  }
  
  
  function loadLeftMenus(menuType){
	  	$.post("/social/SocialLeftMenu.jsp?menuType="+menuType,function(data){
	  		var menusid=menuType+"Menus";
	  		//$("#"+menusid).html(data);
	  		//$(".leftMenudiv").hide();
	  		//$("#"+menusid).show();
	  		$(".leftMenudiv").show();
	  		$(".leftMenudiv").html(data);
	  		if(menuType!="baike"){
		  		setTimeout(function(){
			  		$(".leftMenudiv").find(".menuItemdiv:first").click();
			  	},200);
		  	}
	  	});
	  	
  }
  
  function showChildrenMenu(obj,status){
  
  	if(status=="1"){
		$(obj).find(".menuItemName").removeClass("menugroupdwon").addClass("menugroupup");
		$(obj).next().hide();
		$(obj).attr("_status",0);
	}else{
		$(obj).find(".menuItemName").removeClass("menugroupup").addClass("menugroupdwon");
		$(obj).next().show();
		$(obj).attr("_status",1);
	}
  }
  
  //初始化顶部
  function initNavTop(){
  	$(".navToptab .tabitem").bind("click",function(){
  		
  			$(".navToptab .activeitem").removeClass("activeitem");
  			var target=$(this).attr("_target");
  			var rightUrl=$(this).attr("_url"); //右侧页面地址
  			
  			_color=$(this).attr("_color");
  			_module=target;
  			
  			$(this).addClass("activeitem").css("border-bottom-color",_color);
  			loadLeftMenus(target);
  			
  			$(".winbox").hide();
  			
  			displayLoading(1);
  			$("#centerRightbox").load(rightUrl,function(){
  			
  				getShareList(target);
	  			if(target=="group"){
	  				$("#remarkMain").hide();
	  				$("#msgdiv").hide();
	  			}else{
	  				$("#remarkMain").show();
	  				$("#msgdiv").show();
	  			}
	  			
  			}).show();
  			/*
  			if(target=="group"){
  				$("#centerRightbox").load("group/SocialGroupRight.jsp",function(){
  					
  				});
  			}else if(target=="workers"){
  				$("#centerRightbox").load("workers/SocialWorkersRight.jsp");
  			}else if(target=="baike"){
  				$("#centerRightbox").load("baike/SocialBaikeRight.jsp");
  			}else if(target=="home"){
  				$("#centerRightbox").load("SocialRight.jsp");
  			}
  			*/
  			showLeftSearch(target);
  	});
  }	
  
  //初始化页面单击事件
  function initBodyClick(){
  	$(document.body).bind("click",function(event){
  		$(".msgtop .moreOption").hide();
  		$('.msgcenter .searchpanel').hide(); 
  		$(".share_options .moreOption").hide();
  		$(".moreApp").hide(); //隐藏更多应用
  		$(".filterOptions .seletOptions").hide();
  		
  		$("ul.sf-menu").hide();
        $("#discussListNav").hide();
  		
  		//隐藏全部动态切换面板
  		if($(event.target).parents("#dyndiv").length==0){
  			hideDynitem();
  		}
  		
  		//隐藏权限选择面板
  		if($(event.target).parents(".rightdiv").length==0){
  			hideRight();
  		}
  		
  		if($(event.target).parents(".clickHide").length==0){
  			$(".clickHide").hide(); //点击页面就隐藏的公共方法
  		}
  		
  		if($(event.target).parents(".socialremind").length==0){
  			$('.socialremind').hide(); //隐藏消息提示框
  		}
  		
  		if($(event.target).parents("#remarkMain").length==1) 
  			return; //提交区域内不隐藏输入框
  		else if($(event.target).html()=="")   //点击标记关闭时不隐藏
  			return;
  		else
  		    hideRemark();	
  	});
  }
  
  function showRemark(){
  		if($("#content").attr("_status")=="1") return ;
		$("#content").height(80).html("").attr("_status","1").css({"color":"#000"});
		$("#remarkappdiv").show();
		$("#optiondiv").show();
		$("#sharelabel").show();
		stopEvent();
  }
  
  function hideRemark(){
  		if($("#content").html()!="") return;
  		$("#content").height(20).html("说点什么吧").attr("_status","0").css({"color":"#afbed8"});
		$("#remarkappdiv").hide();
		$("#optiondiv").hide();
		clearRemark();
  }
  
  function clearRemark() {
  	
  
  	emptyShareLabel();
  }
  
  function showMoreApp(obj){
		var left=$(obj).position().left;
		var top=$(obj).position().top+30;
		$(obj).parent().find(".moreApp").css({"left":left,"top":top}).show();
		stopEvent();
  }
  
  function showMoreOption(obj){
		var left=$(obj).position().left-64;
		var top=$(obj).position().top+22;
		$(obj).parent().find(".moreOption").css({"left":left,"top":top}).show();
		stopEvent();
  }
  
   function showMoreLabel(obj){
		var left=$(obj).position().left-10;
		var top=$(obj).position().top+55;
		$(obj).parent().find(".moreOption").css({"left":left,"top":top}).show();
		stopEvent();
  }
  
  //阻止事件冒泡
  function stopEvent() {
  	try{
	  	if(!window.event){
	  		im_event = getEvent();
	  		if(!im_event){
		  		return false;
		  	}
		  	if (im_event.stopPropagation) { 
				// this code is for Mozilla and Opera 
				im_event.stopPropagation();
			} 
		  	
	  	}else{
	  		im_event = window.event;
	  		im_event.cancelBubble = true;
	  	}
	}catch(err){
		console.log("stopEvent报错：",err);
	}
	return false;
  }
  function getEvent(){
     if(typeof window.event != 'undefined')    {return window.event;}
     var f=getEvent.caller;
     while(f!=null){
         var arg0=f.arguments[0];
         if(arg0){
             if((arg0.constructor==window.Event || arg0.constructor ==window.MouseEvent
                || arg0.constructor==window.KeyboardEvent)
                ||(typeof(arg0)=="object" && arg0.preventDefault
                && arg0.stopPropagation)){
                 return arg0;
             }
         }
         f=f.caller;
     }
     return null;
}
  //发表分享
  function addSocialShare() {
  		//alert($('#content').html());
  		
  		var hrmids = "";
  		//获取选取人人员
		$('#content').find('.hrmecho').each(function(){
			var hrmid = $(this).attr('_relatedid');
			if(hrmid !=null && typeof(hrmid) != 'undefined')
				hrmids += hrmid +',';
		});
		if(hrmids.length > 0)
			hrmids=hrmids.substring(0, hrmids.length-1);
  		
  		faceFormate($('#content'));
  		var content=$('#content').html();
  		if($.trim(content)==""){
            //内容不能为空
  			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(126984, user.getLanguage())%>",function(){
				$('#content').focus();
				stopEvent();
			});
			return ;
  		}
  		
  		var main = $('#remarkMain');
  		
  		var imageids=getImgids(main);
  		var accids=getAccids(main);
  		var isSyncBlog=$("#isSyncBlog").val();
  		var labelids=getLabels(main);
		jQuery.post("/social/SocialOperation.jsp?operation=addshare",{"content":content,"labelids":labelids,"imageids":imageids,"accids":accids,"hrmids":hrmids},function(info){
			var data = eval('('+info+')');
			$.post("SocialShareRecord.jsp?shareid="+data.SocialShare.id+"&target=share",function(data){
				$("#shareList .sharetable:first").before(data);
				$("#shareList .sharetable:first").hide();
				$("#shareList .sharetable:first").fadeIn(500);
  				$("#content").html("");
  				clearRemark();
  				$(".imgBox .fsUploadProgress .imgitemdiv").remove();
  				$(".accBox .fsUploadProgress .accitemdiv").remove();
			});
		});
  }
  
  function faceFormate(obj){
	 $(obj).find(".defFace").each(function(){
	 	 var faceCode=$(this).attr("_faceCode");
	 	 $(this).replaceWith(faceCode);
	 });
  }
  
  //获取选择的标签
  function getLabels(obj){
  	var labelids = "";
	$(obj).find('.grouplabellist').each(function(){
		labelid = jQuery(this).attr("name");
		labelids += labelid + ",";
	}); 
	if(labelids.length>0)labelids = labelids.substring(0, labelids.length-1);
  	return labelids;
  }
  
  //获取上传图片id
  function getImgids(obj){
	var imageids="";
	$(obj).find(".imgBox .fsUploadProgress .imgitemdiv").each(function(){
		imageids+=","+$(this).attr("_imageid");
	});
	imageids=imageids.length>0?imageids.substr(1):"";
	return imageids;
  }
  
  //获取上传附件id
  function getAccids(obj){
	var accids="";
	$(obj).find(".accBox .fsUploadProgress .accitemdiv").each(function(){
		accids+=","+$(this).attr("_accid");
	});
	accids=accids.length>0?accids.substr(1):"";
	return accids;
  }
  
  
  //下一批百科
  function nextBaike() {
  		var baikelistpage = $('#baikelistpage').val();
  		var baikelistcount = $('#baikelistcount').val();
  		var pageindex = parseInt(baikelistpage) + 1;
  		if(pageindex > baikelistcount)
  			pageindex = 1;
  			
  		$.post("/social/baike/SocialBaikeRecom.jsp", {"operation":"next", "pageIndex":pageindex}, function(date){
  			$('#recomcontentdiv').html(date);
	  		$('#baikelistpage').val(pageindex);
  		});
  }
  
  //下一批最热百科
  function nextHotWorkers() {
  		var baikelistpage = $('#baikelistpage').val();
  		var baikelistcount = $('#baikelistcount').val();
  		var pageindex = parseInt(baikelistpage) + 1;
  		if(pageindex > baikelistcount)
  			pageindex = 1;
  			
  		$.post("/social/workers/SocialWorkersRecom.jsp", {"operation":"next", "pageIndex":pageindex}, function(date){
  			$('#recomcontentdiv').html(date);
	  		$('#baikelistpage').val(pageindex);
  		});
  }
  
  //显示更多
  function showMoreDiv(id,moreid) {
  		$('#'+id).show();
  		$('#'+moreid).hide();
  }
  
  //插入聊天信息
  function insertChatDiv(lastTime, lastFormatTime, content,userimage,isShowTime) {
		//var html = $("#chatList").html();
		$('#chatitemdivmode').find('.chatContent').each(function(){
			$(this).html(content);
		})
		$('#chatitemdivmode').find('.chatTime').each(function(){
			if(isShowTime){                                             //是否显示当前发表聊天记录时间
				$(this).html(lastFormatTime).show();
			}else {
				$(this).html('').hide();
			}
		})
		//alert(userimage);
		$('#chatitemdivmode').find('.userimage').attr("src",userimage);
		$("#chatLastDateTime").val(lastTime);    							//更新最后发表时间
		$("#chatList").append($('#chatitemdivmode').html());
		scrollTOBottom('chatList');										    //滚动到最下 	
  
  }
  
  
  //滚动条显示在最下方
  function scrollTOBottom(targetid) {
  	 try{
  	 	$(targetid).perfectScrollbar("update");
  	 	setTimeout(function(){
  	 		if($(targetid)[0].scrollHeight!==undefined){
  	 		    $(targetid).scrollTop($(targetid)[0].scrollHeight);
  	 		}
  	 	}, 10);
	 }catch(e){
	 	
	 }
  }
  
  //点赞
  function insertPraises(obj, shareid, sendid) {
  
  		jQuery.post("/social/SocialOperation.jsp",{"sendid":sendid,"shareid":shareid,"operation":"addpraise"},function(info){
  			var rinfo = eval('('+info+')');
  			$.post("/social/SocialHtmlOperation.jsp?shareid="+shareid+"&operation=addpraise",function(data){
  					data=$.trim(data);
  					if(data=="")
  						$(obj).parents(".sharetable").find('.praisediv').html(data).hide();
  					else	
  						$(obj).parents(".sharetable").find('.praisediv').html(data).show();
  				  	if(rinfo.isadd) {             //是添加还是删除
						$(obj).addClass("zan2");
					}else {
						$(obj).removeClass("zan2");
					}
			});
  		});
  }
  
  function onPraises(obj) {
  		var sendid = $(obj).attr('_sendid');
  		var shareid = $(obj).attr('_shareid');
  		jQuery.post("/social/SocialOperation.jsp",{"sendid":sendid,"shareid":shareid,"operation":"addpraise"},function(info){
  			var rinfo = eval('('+info+')');  	
			var num = $(obj).parent().find('.praisenum').html();
		  	if(rinfo.isadd) {             //是添加还是删除
		  		$(obj).parent().find('.praisenum').html(parseInt(num) + 1);
			}else {
				$(obj).parent().find('.praisenum').html(parseInt(num) - 1);
			}  
  		});
  }
  
  
  //收藏
  function insertParovate(obj, shareid, sendid) {
 		jQuery.post("/social/SocialOperation.jsp",{"sendid":sendid,"shareid":shareid,"operation":"addparovate"},function(info){
			var rinfo = eval('('+info+')');
			
			if(rinfo.isadd) {             //是添加还是删除
				addClass(obj, 'farovate2');
			}else {
				removeClass(obj, 'farovate2');
			}  				  	
		});
  	
  
  }
  
	function hasClass(obj, cls) {
	     return obj.className.match(new RegExp('(\\s|^)' + cls + '(\\s|$)'));
	}
	
	function addClass(obj, cls) {
		if (!this.hasClass(obj, cls))obj.className += " " + cls;
	}
	
	function removeClass(obj, cls) {
		if (hasClass(obj, cls)) {
			var reg = new RegExp('(\\s|^)' + cls + '(\\s|$)');
			obj.className = obj.className.replace(reg, ' ');
		}
	}
	
  //下一批推荐群
  function nextGroup() {
  		var baikelistpage = $('#grouplistpage').val();
  		var baikelistcount = $('#grouplistcount').val();
  		var pageindex = parseInt(baikelistpage) + 1;
  		if(pageindex > baikelistcount)
  			pageindex = 1;
  			
  		$.post("/social/group/SocialGroupRecom.jsp", {"operation":"next", "pageIndex":pageindex}, function(date){
  			$('#grouplistrecomdiv').html(date);
	  		$('#grouplistpage').val(pageindex);
  		});
  }
  
  //下一批通用翻页 {next: {_pageindex, _pagecount, _url}, callback: function(data)}
  function nextPage(obj, callback){
	 var pageindex = $(obj).attr('_pageindex');
	 var pagecount = $(obj).attr('_pagecount');
	 var _url =  $(obj).attr('_url');
	 pageindex = parseInt(pageindex) + 1;
  	 if(pageindex > pagecount) pageindex = 1;   //最后一页之后跳到第一页
  	 $.post(_url, {"operation":"next", "pageIndex":pageindex}, function(data){
  	 		$(obj).attr('_pageindex', pageindex);
  	 		callback(data);
  	 });
  }
  
  var applygroupdialog = null;
  //申请进群
  function applyInGroup(groupid) {
  	$applygroupdiv = $("#applygroupdiv").clone();
    $applygroupdiv.find('.apply_group').attr("_groupid",groupid);
	applygroupdialog = new window.top.Dialog();
 	applygroupdialog.currentWindow = window;
 	applygroupdialog.Width = 360;
	applygroupdialog.Height = 180;
	applygroupdialog.Title = "<%=SystemEnv.getHtmlLabelName(126917, user.getLanguage())%>";  // 申请入群
	applygroupdialog.InnerHtml = $applygroupdiv.html();
	applygroupdialog.ShowButtonRow=false;
	applygroupdialog.isIframe = false;
	applygroupdialog.normalDialog= false;
	applygroupdialog.show();
  
  }
  
  function doapplygroup(obj){
    var groupid = $(obj).attr('_groupid');
    var content = $(obj).parents('.applygroupmain').find('.editremark').val();
	jQuery.post("/social/SocialOperation.jsp",{"groupid":groupid,"operation":"applyingroup","content":content},function(info){
		var rinfo = eval('('+info+')');
		if(rinfo.isapply) {            
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(126918, user.getLanguage())%>！");  // 申请成功
			applygroupdialog.close();
		}else {
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(126919, user.getLanguage())%>！");  //申请失败
		}  				  	
	});  
  
  }
  
  
  //申请进群消息处理
  function applyGroupMsg(obj) {
  		var senderid =$(obj).attr("_senderid");
  		var msgtype =$(obj).attr("_msgtype");
  		var groupid =$(obj).attr("_groupid");
  		var value =$(obj).attr("_value");
  		var msgitem =$(obj).parents(".msgitem");
  		
  		jQuery.post("/social/SocialOperation.jsp",{"msgtype":msgtype,"groupid":groupid,"value":value,"senderid":senderid,"operation":"applygroup"},function(info){
			var rinfo = eval('('+info+')');
			if(rinfo.isapply) {            
		  		$(obj).parent().hide();
		  		if(value == "2") {
			  		msgitem.find(".groupratify").show();
		  		}else if(value == "1") {
			  		msgitem.find(".groupreject").show();
		  		}
				window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(83323, user.getLanguage())%>");  // 处理成功！
			}else {
				window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(83322, user.getLanguage())%>");  // 处理失败！
			}  				  	
		});
  }
  
  var handleshareid = 0;
  function handleShareEdit(obj) {
  	var handle = $(obj).attr("_handle");
  	var shareid = $(obj).attr("_shareid");
  	var sendid = $(obj).attr("_sendid");
  	if($('#handleEditor').length>0) {
	  	$('#handleEditor').remove();
  	}
  	if(handleshareid != sendid+handle) {
		$.post("/social/SocialHtmlOperation.jsp?operation=addeditor",function(data){
		  	$(obj).parents(".sharetable").find(".replyboxdiv").append(data);
  			handleshareid = sendid+handle;
		  	$('#handleEditor').find('.replycontent').focus();
		  	if(handle == 1) 
			  	shareComment(handle, shareid, obj);
		  	else
		  		shareForword(handle, shareid, sendid);
		});
  	}else{
  		handleshareid = 0;
  	}  	
  
  }
  
  function closeReplyBox(obj){
  	$(obj).parents(".sharetable").find(".replyboxdiv").html("");
  	handleshareid = 0;
  }
  
  function showComment(obj){
  	var replybox=$("#replybox").clone();
  	replybox.show();
  	var replyboxdiv=$(obj).parents(".sharetable").find(".replyboxdiv")
  	replyboxdiv.append(replybox);
  	replyboxdiv.find(".replycontent").focus();
  }
  
  
  //评论
  function shareComment(handle, shareid, obj) {
  	$('#handleEditor').find('div[name=privilege]').hide();
  	$('#handleEditor').find('div[name=synchroniza]').hide();
  	$('#handleEditor').find('div[name=label]').hide();
  	$('#sharehandle').bind("click",function(){
		var content = $('#handleEditor').find('.replycontent').html();
		 jQuery.post("/social/SocialOperation.jsp",{"shareid":shareid,"content":content,"operation":"sharecomment"},function(info){
		 	var commentobj = eval('('+info+')');
  			$.post("/social/SocialHtmlOperation.jsp?commentid="+commentobj.commentid+"&operation=sharecomment",function(data){
			     var replylist = $(obj).parents(".sharetable").find('.share_replylist');
			  	 var html = replylist.html();
			  	 replylist.html(html+data);
		  		 $('#handleEditor').remove();
		  		 handleshareid = 0;
			});
		 });
  	}).html('<%=SystemEnv.getHtmlLabelName(675, user.getLanguage())%>');  // 评论
  	$(obj).parents(".sharetable").find(".replyboxdiv .replytitle").html("<%=SystemEnv.getHtmlLabelName(126920, user.getLanguage())%>");  // 评论本条分享
  }
  
  //转发
  function shareForword(handle, shareid, sendid) {
  	$('#sharehandle').bind("click",function(){
  		 var content = $('#handleEditor').find('.replycontent').html();
  		 jQuery.post("/social/SocialOperation.jsp",{"parentid":shareid,"sendid":sendid,"content":content,"operation":"addshare"},function(info){
			var data = eval('('+info+')');
			
			$.post("SocialShareRecord.jsp?shareid="+data.SocialShare.id+"&target=share",function(data){
				var html = $("#shareList").html();
				$("#shareList").html(data+html);
			});
	  		 $('#handleEditor').remove();
	  		 handleshareid = 0;
		});
  	}).html('<%=SystemEnv.getHtmlLabelName(6011, user.getLanguage())%>');  // 转发
  	$(obj).parents(".sharetable").find(".replyboxdiv .replytitle").html("<%=SystemEnv.getHtmlLabelName(126921, user.getLanguage())%>");  //转发本条分享
  }
  
  //显示所有评论
  function showAllreplyitem(obj) {
  	  var replylist = $(obj).parent().parent().find('.share_replylist');
  	  replylist.children('div').each(function() {	
  	  		$(this).show();
  	  });
  	   $(obj).parent().hide();
  }
  
  //百科右侧标签翻页
  function nextLabelBaikeRight(obj, pageindex) {
 	$.post("/social/SocialHtmlOperation.jsp?pageindex="+pageindex+"&operation=labelitem",function(data){
	     var labelItem = $(obj).parent().parent().parent().parent().parent().find('.labelItem');
	  	 labelItem.html(data);
	});  	
  }
  
  function nextLabelCollent(obj, pageindex) {
 	$.post("/social/SocialHtmlOperation.jsp?pageindex="+pageindex+"&operation=collentItem",function(data){
	     var collentlist = $(obj).parents(".visitdiv").find('.collentlist');
	  	 collentlist.html(data);
	});   
  }

//打开附件
function opendoc(showid,shareid){
//   openFullWindowHaveBar("/docs/docs/DocDsp.jsp?pstate=sub&social=social&id="+showid);
	var url="/docs/docs/DocDsp.jsp?pstate=sub&id="+showid;
	if(shareid)
		url=url+"&socialshareid="+shareid;
	openFullWindowHaveBar(url);
}

//添加关注分享
function addAttentionShare(obj) {
	
	addAttention(obj, function(result){
		if(result.result) {
			$(obj).find('span').html('<%=SystemEnv.getHtmlLabelName(24957, user.getLanguage())%>');  //取消关注
			$(obj).parents('.share_contentdiv').find('.att').show();
		}else{
			$(obj).find('span').html('<%=SystemEnv.getHtmlLabelName(25436, user.getLanguage())%>');  //关注
			$(obj).parents('.share_contentdiv').find('.att').hide();
		}
	});

};

//添加关注（人）
function addAttentionPorson(obj) {
	addAttention(obj, function(result){
		if(result.result) {             //是添加还是删除
			updateGroupAttNum(1);
		}else {
			updateGroupAttNum(0);
		}	
	//	doRefresh();
		
	});
}

//从卡片添加关注
function addAttPorsonByCard(obj) {
	addAttention(obj, function(result){
		if(result.result) {             //是添加还是删除
			updateGroupAttNum(1);
		}else {
			updateGroupAttNum(0);
		}	
		$(obj).parents('.hrmcard').hide();
	});	
}


//添加关注（群）
function addAttentionGroup(obj) {
	stopEvent();
	addAttention(obj, function(result){
		if(result.result) {             //是添加还是删除
			addClass(obj, 'groupMsgatt2');
			updateGroupAttNum(1);
		}else {
			removeClass(obj, 'groupMsgatt2');
			updateGroupAttNum(0);
		}	
	});
}

//添加关注 
function addAttention(obj, callback) {
	var tagertid = $(obj).attr("_tagertid");
	var type = $(obj).attr("_type");
	$.post("/social/SocialOperation.jsp?operation=addatt&tagertid="+tagertid+"&type="+type,function(result){
		callback(eval('('+result+')'));
	}); 	
}

//置顶群信息
function stickGroupMsg(obj) {

	stopEvent();
	var groupid = $(obj).attr("_groupid");
	$.post("/social/group/SocialGroupOperation.jsp?operation=groupMsgTop&groupid="+groupid,function(result){
		getShareList('group');
		/*
		var res = (eval('('+result+')'));
		if(res.result) {  //置顶
			addClass(obj, 'groupMsgup2');
			var table = $(obj).parents('table');
			var html = table.attr("outerHTML");
			table.parent().prepend(html);
			$(obj).parents('table').remove();
		}else {
			removeClass(obj, 'groupMsgup2');
		}	
		*/
	}); 
}

//分享置顶
function stickShare(obj) {
	var shareid = $(obj).attr("_shareid");
	$.post("/social/SocialOperation.jsp?operation=sharetopup&shareid="+shareid,function(result){
		doRefresh();
	}); 

}

//分享已读
function markRead(obj) {
	
	var isRead=$(obj).attr("_isRead");
	if(isRead!="0"){
		$(obj).attr("_isRead","0");	
		var shareid = $(obj).attr("_shareid");
		$.post("/social/SocialOperation.jsp?operation=shareread&shareid="+shareid,function(result){
			var isReadobj = eval('('+result+')');
			$(obj).find('.new').hide();
		}); 
	}
}

//更新群关注数量 operation : 1 添加 0 减少
function updateGroupAttNum(operation) {
	var num = $('#groupattentionnum').html();
	if(num == null || typeof(num) == 'undefined')num = 0;
	var number = parseInt(num);
	if(operation == 1)
		number++;
	else
		number--;
		
	$('#groupattentionnum').html(number);
}


//加载关注列表
function showSocialAttList(obj) {
	var _url = $(obj).attr("_url");
	var _taget = $(obj).attr("_taget");
	var _type = $(obj).attr("_type");
	_url += '?taget=' + _taget + '&type=' +_type;
	$("#centerPopBox").load(_url).show();
}

//切换关注列表
function changeAttTab(obj, pageindex) {
	var _taget = $(obj).attr("_taget");
	var _type = $(obj).attr("_type");
	
	loadAttentionList(pageindex, _type, _taget);
	changeMsgTab(obj);
	stopEvent();
}

//加载关注数据
function loadAttentionList(pageindex, _type, _taget) {
	var lastname = $("#attentSearchinput").val();
	var param = {"pageindex":pageindex,"operation":"attentlist","type":_type,"taget":_taget, "lastname":lastname};
	displayLoading(1);
	$.post("/social/SocialHtmlOperation.jsp",param,function(data){
	     var listobj =  $('#attentionList');
	  	 listobj.html(data);
	  	 
	  	 $('#attentionList').find('.msgitem').hover(function(){
			$(this).find('.attbtn').show();
		}, function(){
			$(this).find('.attbtn').hide();
		});
	  	 
	  	 displayLoading(0);
	}); 
}

//刷新关注列表
function attentionHandler(obj) {
	
	addAttention(obj, function(result) {
		var taget = $(obj).attr("_taget");
		if(taget == 'att')
			changeAttTab($('#atttab'));
		else
			changeAttTab($('#fanstab'));
	})

}

function showSeacrh(obj) {
	$(obj).hide();
	var searchinput = $(obj).parent().find('.searchinput').show();
	//searchinput.parents('.searchbaike').css("border","1px #B1E8FC solid");
	searchinput.show();
	searchinput.focus();
	
}

//百科推荐
function showRemarkFaceBox(obj){
  	$(obj).parents(".remarkappdiv").find(".faceBox").show();
  	stopEvent();
}

//推荐分享
function recommendShare(obj) {
	var _shareid = $(obj).attr("_shareid");
	var _isRecommend = $(obj).attr("_isRecommend");
	
	$.post("/social/maint/SocialSettingOperation.jsp",{"bids":_shareid,"operation":"updateEncyclopedia", "isRecommend":_isRecommend},function(e){
			if(_isRecommend == 1) {
				$(obj).attr("_isRecommend", '0');
				$(obj).find('span').html('<%=SystemEnv.getHtmlLabelName(126923, user.getLanguage())%>');  //取消推荐
				$(obj).parents('.share_contentdiv').find('.recom').show();
			}else{
				$(obj).attr("_isRecommend", '1');
				$(obj).find('span').html('<%=SystemEnv.getHtmlLabelName(126922, user.getLanguage())%>');  //推荐
				$(obj).parents('.share_contentdiv').find('.recom').hide();
			}
	});	
}

	function clickShowremark(){
			$("#content").height(80).html("").attr("_status","1").css({"color":"#000"});
			$("#remarkappdiv").show();
			$("#optiondiv").show();
			$("#sharelabel").show();
			$("#content").focus();
			stopEvent();
	}
	
	function hideRemarkRelatedBox(obj){
 		$(obj).parents(".remarkappdiv").find(".relatedHrmBox").hide();
   }
   
   function showRemarkImgBox(obj){
 		$(obj).parents(".remarkappdiv").find(".imgBox").show();
 		stopEvent();
   }
   
   function addRemarkRelatedHrm(obj){
	  	var htmlstr="";
	  	$(obj).parents(".relatedHrmBox:first").find(".relatedList input:checked").each(function(){
	  		var resourceid=$(this).val();
	  		var resourceName=$(this).parents(".mitem").find(".mname").text();
	  		htmlstr+='<a href="javascript:void(0)" _relatedid='+resourceid+' contenteditable="false" unselectable="off" style="cursor:pointer;text-decoration:none !important;margin-right:8px;" target="_blank">@'+resourceName+'</a>';
	  	});
	  	if(htmlstr==""){
	  		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(126924, user.getLanguage())%>");  // 请选择被提醒人
	  		return;
	  	}
	  	$(obj).parents(".chatAppdiv").find(".relatedHrmBox").hide();
	  	$('#content').append(htmlstr);
	}

	function createTopic(obj){
		hidePopBox(obj);
		var htmlstr="#<%=SystemEnv.getHtmlLabelName(126925, user.getLanguage())%>#";  // 请输入话题
		//var topic=$("<span contenteditable='false'>#<span id='topic' style='outline:none;' onclick='$(this).removeClass(\"topic_sel\")' class='topic_sel' contenteditable='true'>"+htmlstr+"</span>#</span>");
	    $('#content').append(htmlstr);
	};
	
	
	function showShareeditor(obj) {
		var _shareid =  $(obj).attr('_shareid');
		$("#centerPopBox").load("/social/baike/SocialBaikeEdit.jsp?shareid="+_shareid).show();
	}
	
	function showBaikeLog(obj) {
		var _modifyid =  $(obj).attr('_modifyid');
		$("#centerPopBox2").load("/social/baike/SocialBaikeView.jsp?modifyid="+_modifyid).show();
	}
	
	
	function shareEditor(obj) {
		var editmain = $('#baikeeditmain');
	
		var baikeid = $(obj).attr('_shareid');
	  	var imageids=getImgids(editmain);
  		var accids=getAccids(editmain);
  		var labelids=getLabels(editmain);
	
		var content = editmain.find('.sharecontent').html();
		var remark = $(obj).parents('.editremarkmain').find('.editremark').val();
		var params = {"baikeid":baikeid,
					  "operation":"baikeupdate",
					  "content":content,
					  "imageids":imageids,
					  "accids":accids,
					  "labelids":labelids,
					  "remark":remark};
					  
		$.post("/social/baike/SocialbaikeOperation.jsp",params,function(result){
				var result = eval('('+result+')');
				if(result.isupdate) {
					window.top.Dialog.alert('<%=SystemEnv.getHtmlLabelName(126926, user.getLanguage())%>');  //已提交审批！
				}else{
					window.top.Dialog.alert('<%=SystemEnv.getHtmlLabelName(19134, user.getLanguage())%>');  //审批中！
				}
				editremarkdialog.close();
		});		
	}
	
	//groupsearch hrmsearch
	function showLeftSearch(taget){
		if(taget == 'group') {
			$('#groupsearch').show();
			$('#hrmsearch').hide();
			
		}else if(taget == 'workers') {
			$('#groupsearch').hide();
			$('#hrmsearch').show();
		}else {
			$('#groupsearch').hide();
			$('#hrmsearch').hide();
		}
	}
	
	function showdynamic(obj){
		var value = $(obj).attr('_value');
		
		$(obj).parent().addClass("dynmain2");
		$(obj).parent().find('.selitem').each(function(){
			if($(this).attr('_value') != value)
				$(this).show();
		});
	}
	
	//全部动态、我的关注切换
	function selDynamicitem(obj) {
		$(obj).hide();
		var value = $(obj).attr('_value');
		var text = $(obj).html();
		_dynamic = value;
		$(obj).parent().find('.showdyn').attr('_value', value);
		$(obj).parent().find('.dynamicName').html(text);
		hideDynitem();
		
		displayLoading(1);
		$.post("SocialShareRecord.jsp?dyctype="+value+"&target="+_module,function(data){
			$("#shareList").hide();
			$("#shareList").html(data);
			$("#shareList").fadeIn(500);
			displayLoading(0);
		});
	}
	
	function closelabelDialog(labelid, labelname){
		if(dialog)
			dialog.close();
			
		if(labelid != "") {
			$('#grouplabelitem').find('.addlabel').before('<div class="grouplabeldiv" _labelname="'+labelname+'" _labelid="'+labelid+'" onclick="insertLabel(this)">'+labelname+'</div>');
		}
	}
	function addLabel(obj){
	    dialog = new window.top.Dialog();
		dialog.currentWindow = window;
		var url = "/social/maint/SocialLabelAdd.jsp";
		dialog.Title = "<%=SystemEnv.getHtmlLabelNames("82,176",user.getLanguage()) %>";
		dialog.Width = 420;
		dialog.Height = 280;
		dialog.normalDialog= false;
		dialog.Drag = true;
		dialog.URL = url;
		dialog.show();				 			
	}
		
	function closelabelitem(){
		$("#grouplabelitem").hide();
	}
	function emptyShareLabel(){
		labelcount = 0;
  		$("#sharelabel").hide();
 		$("#labeltitle").hide();
		$("#grouplabelitem").hide();
		$("#grouplabellist").html("");
		$("#grouplabelitem").find('.grouplabeldiv').css('background-color','#fff').css('color','#000');
		}
		function deletelabel(obj){
		labelcount--;
		if(labelcount == 0)$('#labeltitle').hide();
		$(obj).parent().remove();
		var labelid = $(obj).attr('_labelid');
		$('#grouplabelitem').find('.grouplabeldiv').each(function(){
			if(labelid == $(this).attr('_labelid')) {
				$(this).css('background-color','#fff');
				$(this).css('color','#000');
			}
		});
	}
	function showlabel(obj){
		if($("#grouplabelitem").is(":hidden")) {
			var left=$(obj).position().left-170;
			var top=$(obj).position().top+150;
			jQuery("#grouplabelitem").css({"left":left,"top":top}).show();
		} else {
			jQuery("#grouplabelitem").hide();
		}
		stopEvent();
	}
	function insertLabel(obj) {
		var labelname = $(obj).attr('_labelname');
		var labelid = $(obj).attr('_labelid');
		var labelspan = jQuery("#grouplabellist").find('.grouplabellist[name='+labelid+']');
		if(labelspan.length > 0) {
			labelspan.remove();
			$(obj).css('background-color','#fff');
			$(obj).css('color','#000');
			labelcount--;
			if(labelcount == 0)$('#labeltitle').hide();
			return;
		}
		if(labelcount > 4) {
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(126927, user.getLanguage())%>"); // 最多只能添加5个标签！
			return;
		}
		
		$(obj).css('background-color','#ABB1D5');
		$(obj).css('color','#fff');
		$('#labeltitle').show();
		/*
		jQuery("#grouplabellist").append('<span class="grouplabellist" name="'+labelid+'" style="margin-right:5px">'+labelname+'</span>');
					*/
		$("#grouplabellist").append("<div class='grouplabellist' name='"+labelid+"' style='margin-right:5px;position: relative;padding-right: 16px;'>"+
					"<div _labelid='"+labelid+"' class='labeldel' onclick='deletelabel(this)'>"+
					"</div>"+labelname+"</div>");
		
		showlabeldel();			
		labelcount++;
	}
	function showlabeldel(){
		$("#grouplabellist").find('.grouplabellist').hover(function(){
			$(this).find('.labeldel').show();
		},function(){
			$(this).find('.labeldel').hide();
		});
	}
	
	function showRemarkFaceBox(obj){
	  	$(obj).parents(".remarkappdiv").find(".faceBox").show();
	  	stopEvent();
	}
	
	function addRemarkFace(obj){
		var target=$(obj).attr("_target");
	  	var faceCode=$(obj).attr("_faceCode");
	  	var faceImg=$(obj).attr("_faceImg");
	  	var imgstr="<img src='"+faceImg+"' _faceCode='"+faceCode+"' class='defFace'/>";
	  	$('#'+target).append(imgstr);
	  	$(obj).parents(".remarkappdiv").find(".faceBox").hide();
	  	$(".popBox").hide();
	  	stopEvent();
	}
	
	function hideRemarkRelatedBox(obj){
  		$(obj).parents(".remarkappdiv").find(".relatedHrmBox").hide();
    }
	
	function hideDynitem() {
		$("#dyndiv").find('.selitem').hide();
		$("#dyndiv").find('.dynmain').removeClass("dynmain2");
//		$(obj).parent().css("border":"0").css("background-color":"#EFF6FB");
	
	}
    
    function addRemarkRelatedHrm(obj){
	  	var htmlstr="";
	  	$(obj).parents(".relatedHrmBox:first").find(".relatedList input:checked").each(function(){
	  		var resourceid=$(this).val();
	  		var resourceName=$(this).parents(".mitem").find(".mname").text();
	  		htmlstr+='<a href="javascript:void(0)" _relatedid='+resourceid+' contenteditable="false" unselectable="off" style="cursor:pointer;text-decoration:none !important;margin-right:8px;" target="_blank">@'+resourceName+'</a>';
	  	});
	  	if(htmlstr==""){
	  		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(126924, user.getLanguage())%>"); // 请选择被提醒人
	  		return;
	  	}
	  	$(obj).parents(".chatAppdiv").find(".relatedHrmBox").hide();
	  	$('#content').append(htmlstr);
	}
	
	function showRight(obj){
		$(obj).css({"height":"55px"});
		var right=$(obj).attr("_right");
		$(obj).find(".rightItem").show();
		$(obj).find(".rightItem[_value="+right+"]").hide();
	}
	
	function hideRight(){
		$(".optiondiv .rightdiv .rightd").css({"height":"25px"});
		$(".optiondiv .rightdiv .rightItem").hide();
		
	}
	
	function checkRight(obj){
		var _right=$(obj).attr("_value");
		$(obj).parents(".rightd").attr("_right",_right).find(".rightName").html($(obj).html());
		stopEvent();
		hideRight();
	}
	
	//消息提醒
	function updateRemindInfo(flag){
		jQuery.ajax({
            url: "/wui/theme/ecology8/page/getRemindInfo.jsp?1=" + new Date().getTime() + "=",
            dataType: "text", 
            contentType : "charset=UTF-8", 
            error:function(ajaxrequest){
				
			}, 
            success:function(content){
            	//alert(content)
            	if($.trim(content)!=""&&content.indexOf("nodata")==-1){
            		if(!flag){
            			$(".remindsetting").addClass("msg_note");
            			$(".remindsetting").removeClass("msg_none")
            		}
            		$(".socialremindul").html(content);
            		$(".socialremindul").find("li").hover(function(){
            			$(this).addClass("liOver")
            		},function(){
            			$(this).removeClass("liOver")
            		})
            		$(".socialremindul").find("li").bind("click",function(){
           				openFullWindowHaveBar($(this).attr("url"));
            			$(".socialremind").animate({height:"0px"})
						$(".socialremind").hide();
            		})
            		
            	}else{
            		$(".socialremindul").html(content);
            		$(".remindsetting").removeClass("msg_note");
            		$(".remindsetting").addClass("msg_none");
            	}
			}
	});
	
}

function onShowResourceBrowser() {
	
	var dialogurl ="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp";
	var id1 = null;
	
	var othparam = "";
	//othparam = browUtil.getBrowData(id);
	if (othparam.indexOf(",") == 0) {
		othparam = othparam.substr(1);
	}
	if (dialogurl.indexOf("?") != -1) {
		dialogurl += "?";
	} else {
		dialogurl += "&";
	}
	dialogurl += "workflow=1&selectedids=" + othparam;
	
	var dialog = new window.top.Dialog();
	dialog.currentWindow = window;

	dialog.URL = "/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?workflow=1&selectedids=1&f_weaver_belongto_userid=&f_weaver_belongto_usertype=null%26bdf_wfid%3D36%26bdf_fieldid%3D5770%26bdf_viewtype%3D0";
	dialog.callbackfun = function (paramobj, id1) {
	
			if (id1 != undefined && id1 != null) {
				var resourceids = wuiUtil.getJsonValueByIndex(id1, 0);
				var resourcename = wuiUtil.getJsonValueByIndex(id1, 1);
				var sHtml = ""
				var _rtvjson =paserBrowData(id1,0,100);
				//缓存数据
				//browUtil.saveBrowData(id, testjson, _rtvjson.id);
				resourceids = _rtvjson.id;
				sHtml = _rtvjson.html;
				
				
				$("#txtPrincipalspan").html(sHtml);
								
				//alert("resourceids:"+resourceids);
				//alert("sHtml:"+sHtml);
				
				//jQuery($GetEle(_fieldStr+id+"span")).html(sHtml);
				//$GetEle(_fieldStr + id).value= resourceids;
			
			}
	}		
	
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(18214, user.getLanguage())%>";  //请选择
  	dialog.Width=648;
  	dialog.Height = 600;
	dialog.Drag = true;
	//dialog.maxiumnable = true;
	dialog.show();
	
}

function paserBrowData(jsonsdata, viewtype, fieldid) {
		var ids = "";
		var sHtml = "";
		for (var _i=0; _i<jsonsdata.length; _i++) {
			var _item = jsonsdata[_i];
			
			var _title = _item.title;
			var _type = _item.type;
			var _typeid = _item.typeid;
			var _ids = array2string(_item.ids);
			var _names = array2string(_item.names);
			var _jobtitles = array2string(_item.jobtitle);
			
			ids += "," + _ids;
			//单个人力资源
			if (_type == 1) {
				sHtml += wrapshowhtml0(viewtype, "<a href=javaScript:openhrm(" + _ids + "); onclick='pointerXY(event);'>" + _title + "</a>&nbsp", _ids);
			} else if (_type == 2 || _type == 3 || _type == 4 || _type == 5) { //分部/部门/公共组/虚拟组织
			    //生成隐藏域，用于提交至后台保存
				sHtml += wrapshowhtml0(viewtype, "<a href='javascript:void 0;' onclick='showDetail(this, " + fieldid + ");' _ids='" + _ids + "' _names='" + _names + "' _jobtitles='" + _jobtitles + "'><input type='hidden' name='field" + fieldid + "_group' value='" + _type + "|" +  _typeid + "|" + _ids + "'/> " + _title + "(" + _item.ids.length + "人)</a>&nbsp", _ids);
			}
		}
		
		if (ids.length > 1) {
			ids = ids.substr(1);
		}
		return {id:ids, html:sHtml};
	}


function wrapshowhtml0(viewtype, ahtml, id) {
	var ismust = 1;
	if (viewtype == '1') {
		ismust = 2;
	}

	var str = "<span class=\"e8_showNameClass\">";
	str += ahtml;
	str += "<span class=\"e8_delClass\" id=\"" + id + "\" onclick=\"del(event,this," + ismust + ",false,{});\" style=\"opacity: 0; visibility: hidden;\">&nbsp;x&nbsp;</span></span>";
	return str;
}

function array2string(array, separator) {
	var result = "";
	if (!!!separator) {
		separator = ",";
	}
	try {
		if (!!array) {
			for (var _i=0; _i<array.length; _i++) {
				result += separator + array[_i];
			}
			if (result.length > 1) {
				result = result.substr(1);
			}
			return result;
		}
	} catch (e) {}
	
	return result;
}


function initHrmCard(){

	$(".head35").live("mouseenter",function(){
	
		var left=$(this).offset().left;
		var top=$(this).offset().top+45;
		
		var winHeight=$(window).height();
		var winWidth=$(window).width();
		if(top+260>winHeight)
			top=top-260-35-15;
		if(left+285-20>winWidth)
			left=left-(left+285-winWidth)-20;
		var hrmid=$(this).attr("_hrmid");
		if(hrmid){
			var headid=$(this).attr("id");
			if(!headid){
				var headid=hrmid+"_"+new Date().getTime();
				$(this).attr("id",headid);
			}
			setTimeout(function(){
	  			if($('#'+headid).is(":hover")){
	  				$("#hrmcard").load("/social/SocialHtmlOperation.jsp?operation=getHrmCard&hrmid="+hrmid,function(){
						$("#hrmcard").css({"left":left,"top":top}).show();
					});
	  			}	
			},1000);
		}
		
	}).live("mouseleave",function(event){
		setTimeout(function(){
  			if(!$('#hrmcard').is(":hover")){
  				$("#hrmcard").hide();
  			}	
		},500);
	}).live("click",function(){
		var hrmid=$(this).attr("_hrmid");
		if(hrmid){
			viewPerson(hrmid);
		}
	});
	
	$("#hrmcard").live("mouseenter",function(){
		$("#hrmcard").show();
	}).live("mouseleave",function(){
		$("#hrmcard").hide();
	});

}

  
</script>
