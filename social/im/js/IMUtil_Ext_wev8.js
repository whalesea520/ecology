/*这个是IMUtil_wev8.js的功能扩展*/
var IM_Ext = 
{
	//加载相关资源页面
	loadIcrJsp: function(obj, isflush){ 
		var target=$(obj).attr("_target");
		var chatdiv=ChatUtil.getchatdiv(obj);
		var chatwin = ChatUtil.getchatwin(obj);
		var targetid = chatwin.attr('_targetid');
		var targettype = chatwin.attr("_targettype");
		var icrwrapdiv = chatdiv.find("."+target);
		if(isflush || icrwrapdiv.find(".icrMainBox").length <= 0){
			icrwrapdiv.load("/rdeploy/im/IMChatResource.jsp?" +
					"targetid="+targetid+"&targettype="+targettype, function(){
						chatdiv.find(".icrnavActive").click();
					});
		}else{
			icrwrapdiv.find(".icrnavActive").click();
		}
	},
	//缓存会话信息
	getSearchConverList: function(jsconverList){
		var targetid, targetname,targettype,py="",conver;
		for (var i = 0; i <jsconverList.length; i++) {
			conver = jsconverList[i];
			targetid = conver.targetid;
			targetname = conver.targetname;
			targettype = conver.targettype;
			if(targettype==0&&targetid!="undefined"){
				try{
					targetname=getUserInfo(targetid).userName;
					py=getUserInfo(targetid).py;
				}catch(e){
					targetname="";
				}
			}
			searchConverList[targetid] = {"targetname": targetname, "py": py};
		}
	},
	//更新缓存的会话信息
	updateSearchConverList: function(realTargetid){
		var chatitem = $("#recentListdiv .chatItem[_targetid='"+realTargetid+"']");
		searchConverList[realTargetid] = {"targetname": chatitem.find(".targetName ").html()}; //标题	
	},
	//获取关注设定
	getIMAttention: function(jsconverList){
		var targetids = [],targetid,conver;
		var targettypes = [],targettype;
		for (var i = 0; i <jsconverList.length; i++) {
			conver = jsconverList[i];
			targetid = conver.targetid;
			targetids.push(targetid);
			targettype = conver.targettype;
			targettypes.push(targettype);
		}
		$.post("/social/im/SocialIMOperation.jsp?operation=getIMAttention&targetids="+targetids.join(",")+"&targettypes="+targettypes.join(","), 
			function(data){
				var json = $.parseJSON(data);
				IMUtil.sleep(2000);
				var items = $("#recentListdiv .chatItem"),item,switchIco;
				$.each(items, function(i, item){
					var $item = $(item);
					switchIco = $item.find(".interestSwitch");
					if(json[$item.attr("_targetid")]){
						switchIco.attr("islight", "1");
						$item.attr("islight", "1");
						switchIco.find("img").attr("src","/rdeploy/im/img/lightup_wev8.png");
					}else{
						switchIco.attr("islight", "0");
						$item.attr("islight", "0");
						switchIco.find("img").attr("src","/rdeploy/im/img/lightoff_wev8.png");
					}
				});
			});
	},
	/*更新关注表*/
	updateImAttention: function(chatitem, isOn){
	  	var targetid = $(chatitem).attr("_targetid");
	  	var targettype = $(chatitem).attr("_targettype");
	  	$.post("/social/im/SocialIMOperation.jsp?operation=updateImAttention&isOn="+isOn+"&targetid="+targetid+"&targettype="+targettype);
	},
	/*显示下拉框*/
	doDropOptions: function(obj){
		var selet = $(obj);
		var optiondiv = selet.nextAll("div[target='"+selet.attr("id")+"']");
		if(optiondiv.is(":hidden")){
			optiondiv.show();
			//绑定自动隐藏
			optiondiv.autoHide();
		}else 
			optiondiv.hide();
		stopEvent();
	},
	/*选择下拉选项*/
	doSelectOption: function(obj, target){
		var val = $(obj).attr("value");
		$("#"+target).attr("value", val).html(CONST.optionMap[val]);
		$(obj).parent().hide();
		IM_Ext.doConverFilter($("#"+target));
	},
	/*过滤会话列表*/
	doConverFilter: function (obj){
	  	var selectVal = $(obj).attr("value");
	  	var recentlist = $("#recentListdiv");
	  	switch(selectVal){
	  	case "interest":  //关注
	  		var switches = recentlist.find(".interestSwitch");
	  		var sw;
	  		for(var i = 0; i < switches.length; ++i){
	  			sw = $(switches[i]);
	  			var islight = sw.attr("islight");
	  			if(islight == '0'){
	  				$(sw.parents(".chatItem").get(0)).hide();
	  			}
	  		}
	  	break;
	  	case "all":  //全部
	  		recentlist.find(".chatItem").show();
	  	break;
	  	}
	  },
	  /*移动选择*/
	  moveConverCursor: function(obj,evt){
	  	var ev = evt || window.event;
	  	if(ev.keyCode != 38 && ev.keyCode != 40){
	  		return false;
	  	}
	  	//debugger;
	  	$(obj).parent().attr("_openLock", "false");
	  	var recentlist = $("#recentListdiv");
	  	recentlist.find(".activeChatItem:hidden").removeClass("activeChatItem");
	  	var curCursorItem = recentlist.find(".activeChatItem:visible");
	  	var chatitems = recentlist.find(".chatItem:visible");
	  	if(ev.keyCode == 38){  //up
	  		if(curCursorItem.length <= 0){
		  		if(chatitems.length > 0){
		  			curCursorItem = recentlist.find(".chatItem:visible:last");
		  			recentlist.find(".chatItem:visible:last").addClass("activeChatItem");
		  		}
		  	}else{
		  		var prev = curCursorItem.prevAll(".chatItem:visible").first();
		  		if(prev.length > 0){
		  			curCursorItem.removeClass("activeChatItem");
		  			prev.addClass("activeChatItem");
		  		}
		  	}
	  		
	  	}else if(ev.keyCode == 40){  //down
	  		if(curCursorItem.length <= 0){
		  		if(chatitems.length > 0){
		  			curCursorItem = recentlist.find(".chatItem:visible:first");
		  			recentlist.find(".chatItem:visible:first").addClass("activeChatItem");
		  		}
		  	}else{
		  		var next = curCursorItem.nextAll(".chatItem:visible").first();
		  		if(next.length > 0){
		  			curCursorItem.removeClass("activeChatItem");
		  			next.addClass("activeChatItem");
		  		}
		  	}
	  	}
	  },
	  /*过滤显示*/
	  showFiltedItems: function(list){
	  	var filtKey = $("#filterSelector").attr('value');
	  	var isLight = filtKey=="interest"? 1:0;
	  	if(isLight == 1){
	  		list.find(".chatItem[islight="+isLight+"]").show();
	  	}else{
	  		list.find(".chatItem").show();
	  	}
	  	
	  },
	  /*搜索会话*/
	  doSearchConver: function (obj, evt){
	  	var ev = evt || window.event;
	  	if(ev.keyCode != 13 && ev.type != 'click'){
	  		return false;
	  	}
	  	var searchbox = $("#converSearchbox");
	  	var recentlist = $("#recentListdiv");
	  	var keyword = $.trim(searchbox.val());
	  	if("" == keyword){
	  		IM_Ext.showFiltedItems(recentlist);
	  		IM_Ext.openActiveItem(obj);
	  		return;
	  	}
	  	IM_Ext.showFiltedItems(recentlist);
	  	var chatitems = recentlist.find(".chatItem:visible");
	  	for(var i = 0; i < chatitems.length; ++i){
	  		var item = $(chatitems[i]);
	  		var name = item.attr("_targetname");
	  		var id = item.attr("_targetid");
	  		var py = "";
	  		try{
	  			py   = searchConverList[id].py;
	  		}catch(e){
	  			py = "";
	  		}finally{
	  			if(py == undefined) py = '';
		  		var item = recentlist.find(".chatItem[_targetid='"+id+"']");
		  		if(name && name.indexOf(keyword) != -1 || py.indexOf(keyword) != -1){
		  			item.show();
		  		}else{
		  			item.hide();
		  		}
	  		}
	  	}
	  	IM_Ext.openActiveItem(obj);
	  },
	  openActiveItem: function(obj){
	  	var isopenLock = $(obj).parent().attr("_openLock");
	  	if(isopenLock ==  "true")
	  		return;
	  	var recentlist = $("#recentListdiv");
	  	var curCursorItem = recentlist.find(".activeChatItem");
		if(curCursorItem.length == 1 && curCursorItem.is(":visible")){
  			curCursorItem.click();
  		}
	  },
	  /*点亮五角星*/
	  lightUpItem: function (obj){
	  	var item = $(obj);
	  	var chatitem = item.parents(".chatItem");
	  	if(item.attr("islight")=='1'){
	  		item.find("img").attr("src","/rdeploy/im/img/lightoff_wev8.png");
	  		item.attr("islight", '0');
	  		chatitem.attr("islight", '0');
	  		IM_Ext.updateImAttention(chatitem.get(0), 0);
	  		//判断过滤条件
	  		var filtKey = $("#filterSelector").attr('value');
	  		if(filtKey == "interest"){
	  			$(item.parents(".chatItem")[0]).hide();
	  		}
	  	}else{
	  		item.find("img").attr("src","/rdeploy/im/img/lightup_wev8.png");
	  		item.attr("islight", '1');
	  		chatitem.attr("islight", '1');
	  		IM_Ext.updateImAttention(chatitem.get(0), 1);
	  	}
	  	event.stopPropagation();
	  	event.cancelBubble = true;
	  },
	  //更新最近列表
	  updateRecent: function (obj) {
	  	var targetid = $(obj).attr("_targetid");
	  	var targettype = $(obj).attr("_targettype");
		$.post("/social/im/SocialIMOperation.jsp?operation=updateRecent"+
			"&targetid="+targetid+"&targettype="+targettype, 
			function(data){
				
			});
	  },
	  //显示大图
	  showBigImg: function(obj){
	  	var fileid = $(obj).attr("_fileid");
	  	var activeIndex = IM_Ext.icrResIds.indexOf(fileid);
	  	IMCarousel.showImgScanner4Pool(true, IM_Ext.icrimgPool, activeIndex, undefined, window.top);
	  },
	  //消息后台发送
	  sendMsgBack: function(obj){
	  	
	  },
	  //分享接口
	  imCustomerShare: function (shareid,sharetitle,targetids,appType,callback){
	  	var objectName = "FW:CustomShareMsg";
		var data={"shareid":shareid,"sharetitle":sharetitle,"sharetype":appType,"objectName":objectName};
		var resourceid = shareid;
		var targettype = '0';		//暂时不考虑讨论组情况
		var sharegroupid = targettype=='1'?targettype:"";
		var resourcetype = 0;
		
		if(appType == "task"){
			resourcetype = 2;
		}else if(appType = "doc"){
			resourcetype = 1;
		}
		var ids = targetids.split(",");
		for(var i = 0; i < ids.length; ++i){
	  		var extra=$.extend({"msg_id":IMUtil.guid(),"receiverids":ids[i]},data);
	  		var strExtra = JSON.stringify(extra);
		  	var timestamp = new Date().getTime();
		  	var msgObj={"content":sharetitle,"objectName":objectName,"extra":strExtra,"timestamp":timestamp};
		  //	alert(JSON.stringify(msgObj));
		  //	continue;
		  if(ChatUtil.isFromPc()&&WindowDepartUtil.isAllowWinDepart()){
		      ClientUtil.sendMessageToUser(ids[i],msgObj,6,targettype,function(result){
                callback(result);
                if(result.issuccess){       //消息同步
                    ChatUtil.publishMessage(msgObj);
                    var resourceids=ChatUtil.getMemberids(targettype, ids[i],true);
                    $.post("/mobile/plugin/chat/addShare.jsp?resourcetype="+resourcetype+"&resourceid="+resourceid+"&sharegroupid="+sharegroupid,{"resourceids":resourceids},function(){
                        //client.log("分享通用接口，添加权限返回");
                    });
                }
            });
		  }else{
		      client.sendMessageToUser(ids[i],msgObj,6,function(result){
                callback(result);
                if(result.issuccess){       //消息同步
                    ChatUtil.publishMessage(msgObj);
                    var resourceids=ChatUtil.getMemberids(targettype, ids[i],true);
                    $.post("/mobile/plugin/chat/addShare.jsp?resourcetype="+resourcetype+"&resourceid="+resourceid+"&sharegroupid="+sharegroupid,{"resourceids":resourceids},function(){
                        //client.log("分享通用接口，添加权限返回");
                    });
                }
            });
		  }
	  	}
	  },
	  //检查浮动菜单显示
	  checkFloatMenuShow: function(obj, floatmenu){
	  	var chatitem = IM_Ext.getChatItem(obj);
	  	var msgObj = chatitem.data("msgObj");
	  	var objName = msgObj.objectName;
	  	var recordType = chatitem.data("recordType");
	  	var msgType = msgObj.msgType;
		var flag = true;//标识是否云盘分享会出现撤回按钮
		try{
			var msgObjExtra = eval("("+msgObj.extra+")");
		}catch(e){}
	  	if((msgType == 1 || objName == 'RC:PublicNoticeMsg')/*&& versionTag == "rdeploy"*/){
	  		var msgtag = chatitem.attr('msgtag');
			//必达消息不能撤回
			if(msgtag==1){
				floatmenu.find(".opWithDraw").removeClass("imShowOn").hide();
			}
	  		if(recordType == 'send' && typeof(msgtag)=="undefined"){
	  			floatmenu.find(".opBing").addClass("imShowOn").show();
			}else{
				floatmenu.find(".opBing").removeClass("imShowOn").hide();
			}
	  		if(versionTag == "rdeploy"){
	  			floatmenu.find(".opMore").addClass("imShowOn").show();
	  		}else{
	  			floatmenu.find(".opMore").removeClass("imShowOn").hide();
	  		}
	  	}else{
	  		floatmenu.find(".opBing").removeClass("imShowOn").hide();
	  		floatmenu.find(".opMore").removeClass("imShowOn").hide();
	  	}
		
		//暂时先屏蔽掉名片、图文、位置、语音类消息收藏入口
	  	if(false/*objName == 'FW:PersonCardMsg' || objName == 'FW:richTextMsg' || objName == 'RC:LBSMsg' || objName == 'RC:VcMsg'*/){
	  		floatmenu.find(".opCollect").removeClass("imShowOn").hide();
	  	}else{
	  		floatmenu.find(".opCollect").addClass("imShowOn").show();
	  	}
		//取消分享网盘后的不要显示收藏转发
		if(objName.toLowerCase().indexOf('fw:infontf:cancelshare') != -1){
			 flag = false;
			 floatmenu.find(".opCollect").removeClass("imShowOn").hide();
			 floatmenu.find(".opForward").removeClass("imShowOn").hide()
		}else{
			floatmenu.find(".opCollect").addClass("imShowOn").show();
			floatmenu.find(".opForward").addClass("imShowOn").show();
		}
		//取消网盘分享按钮出现
		if(objName =="FW:CustomShareMsg"&&typeof msgObjExtra.sharetype !=="undefined"&& msgType ==6 ){
			if(msgObjExtra.sharetype =="pdoc"||msgObjExtra.sharetype =="folder"){
				if(recordType =="send"){
				  flag = false;
				  floatmenu.find(".opSaveDisk").removeClass("imShowOn").hide();
				  floatmenu.find(".opCancelDisk").addClass("imShowOn").show()
				}else if(recordType =="receive"){
				  floatmenu.find(".opSaveDisk").addClass("imShowOn").show();
			      floatmenu.find(".opCancelDisk").removeClass("imShowOn").hide();
				}
				floatmenu.find(".opCollect").removeClass("imShowOn").hide();
			}else{
				floatmenu.find(".opCollect").addClass("imShowOn").show();
				floatmenu.find(".opSaveDisk").removeClass("imShowOn").hide();
				floatmenu.find(".opCancelDisk").removeClass("imShowOn").hide();
			}
	  	}else{
			floatmenu.find(".opSaveDisk").removeClass("imShowOn").hide();
			floatmenu.find(".opCancelDisk").removeClass("imShowOn").hide();
		}
		//图片附件可以另存
		if(objName =="FW:attachmentMsg"||objName =="RC:ImgMsg"){
		    floatmenu.find(".opSaveDisk").addClass("imShowOn").show();
		}
		if(recordType == 'send'&& flag){
			floatmenu.find(".opWithDraw").addClass("imShowOn").show();
		}else{
			floatmenu.find(".opWithDraw").removeClass("imShowOn").hide();
		}
	  	//检查复制按钮
		var msgObj = chatitem.data("msgObj");
        var msgType = msgObj.msgType;
	  	if(ChatUtil.isFromPc()) {
            if(msgType == 1 || msgType == 2) {  //文本或图片才有复制
                floatmenu.find(".opCopy").addClass("imShowOn").show();
            } else {
                floatmenu.find(".opCopy").removeClass("imShowOn").hide();
            };
        }
        else if(msgType == 1) {
	        floatmenu.find(".opCopy").addClass("imShowOn").show();
        }
        else{
        	 floatmenu.find(".opCopy").removeClass("imShowOn").hide();
        }
        // 撤回三分钟检查
        try{
        	var sendtime = chatitem.attr('_sendtime');
			sendtime = Number(sendtime);
			var ts = M_CURRENTTIME||sendtime;
			// 超过两分钟，不显示‘撤回’按钮
			if(ClientSet && ClientSet.maxWithdrawTime != '0' && (ts-sendtime)/(1000*60)>parseInt(ClientSet.maxWithdrawTime)) {
				floatmenu.find(".opWithDraw").removeClass("imShowOn").hide();
			}else if(recordType == 'send'&&flag){
			  	floatmenu.find(".opWithDraw").addClass("imShowOn").show();
			}
		}catch(e){
			IM_Ext.showMsg('服务器连接异常');
		}
		if(objName =="FW:CustomShareMsgVote"&&typeof msgObjExtra.sharetype !=="undefined"&&msgObjExtra.sharetype=='vote'){
			floatmenu.find(".opWithDraw").removeClass("imShowOn").hide();
			floatmenu.find(".opCollect").removeClass("imShowOn").hide();
			floatmenu.find(".opForward").removeClass("imShowOn").hide()
		}
		if(msgObjExtra.isPrivate ==1){
			floatmenu.find(".opCollect").removeClass("imShowOn").hide();
			floatmenu.find(".opForward").removeClass("imShowOn").hide();
			floatmenu.find(".opCopy").removeClass("imShowOn").hide();
			floatmenu.find(".opBing").removeClass("imShowOn").hide();
			floatmenu.find(".opSaveDisk").removeClass("imShowOn").hide();
            floatmenu.find(".opCancelDisk").removeClass("imShowOn").hide();
		}
		
		// 屏蔽流程分享
		if(objName == "FW:CustomShareMsg" && typeof msgObjExtra.sharetype !=="undefined"&&msgObjExtra.sharetype=='workflow') {
			floatmenu.find(".opForward").removeClass("imShowOn").hide();
		}
	  	var len = floatmenu.find(".floatmenuItem.imShowOn").length;
	  	//alert(len);
	  	floatmenu.find(".chatFloatmenu").width(len * 50);
	  	floatmenu.width(len * 50);
	  	return len;
	  },
	  //显示浮动菜单
	  showFloatMenu: function(e, obj) {
	  	e = e || window.event;
	  	if(!IM_Ext.isMouseLeaveOrEnter(e, obj)) return;
	  	var contentdiv = $(obj);
	  	var timerid = window.setTimeout(function(){
	  		
	  		var chatitem = contentdiv.parents('.chatItemdiv');
	  		var chatFloatMenu = $("#tempchatFloatmenu");
	  		var len = IM_Ext.checkFloatMenuShow(obj, chatFloatMenu);
	  		if(len == 0){
	  			return;
	  		}
	  		//获取元素窗口坐标
	  		var cord = IMUtil.getDomCord(obj, false);
	  		var left,top;
	  		top = obj.offsetHeight + cord.top;
	  		//判断左右
	  		if(chatitem.find(".chatRItem").length > 0) {
	  			left = cord.left + obj.offsetWidth - chatFloatMenu.width();
	  		}else{
	  			left = cord.left;
	  		}
	  		//判断和消息列表的相对位置
	  		var chatlist = $(obj).parents('.chatList');
	  		cord = IMUtil.getDomCord(chatlist, false);
	  		//被选消息气泡底部隐藏
	  		if(chatlist.height() + cord.top < top) {
	  			top = top - obj.offsetHeight - chatFloatMenu.outerHeight();
	  		}
	  		//被选消息气泡顶部隐藏,则气泡紧靠聊天窗口顶部显示
	  		if(top < cord.top){
	  			top = cord.top;
	  		}
	  		//定位菜单
	  		chatFloatMenu.css({
	  			left: left,
	  			top: top
	  		});
            
	  		chatFloatMenu.attr("_chatitemid", chatitem.attr('id')).show();
	  		//隐藏子菜单
	  		chatFloatMenu.find(".imFloatSubMenu").hide();
	  		chatFloatMenu.find(".floatSubMenuItem").hide();
	  		/*
	  		contentdiv.parent().find(".imFloatSubMenu").hide();
	  		IM_Ext.checkFloatMenuShow(obj);
	  		contentdiv.parent().find('.chatFloatmenuWrap').show();
	  		IM_Ext.ajustChatList(obj);
	  		*/
	  	},600);
	  	contentdiv.data("timerid", timerid);
	  },
	  //隐藏浮动菜单
	  hideFloatMenu: function(e, obj){
	  	e = e || window.event;
	  	if(!IM_Ext.isMouseLeaveOrEnter(e, obj)) return;
	  	var contentdiv = $(obj);
	  	window.clearTimeout(contentdiv.data("timerid")); 
	  	window.setTimeout(function(){
	  		/*
	  		var floatwrap = contentdiv.parent().find('.chatFloatmenuWrap')
	  		*/
	  		var floatwrap = $("#tempchatFloatmenu");
	  		//var chatitem = contentdiv.parents('.chatItemdiv');
	  		if(!floatwrap.data("isLocked"))
	  			floatwrap.hide();
	  	}, 100);
	  },
	  //弹出下拉菜单
	  imDropMenu: function(obj){
	  	var subMenu = $(obj).next();
	  	if(subMenu.is(":visible")){
	  		subMenu.hide();
	  	}else{
	  		var chatitem = IM_Ext.getChatItem(obj);
	  		var msgObj = chatitem.data("msgObj");
	  		var objName = msgObj.objectName;
	  		var msgType = msgObj.msgType;
	  		//只有纯文本才显示
	  		if(msgType == 1 || objName == 'RC:PublicNoticeMsg'){
	  			var msgtag = chatitem.attr('msgtag');
	  			if(typeof(msgtag)=="undefined"){
	  				subMenu.find(".opSendToTask").addClass("imShowOn").show();
	  			}else{
	  				subMenu.find(".opSendToTask").removeClass("imShowOn").hide();
	  			}
	  			subMenu.find(".opSendToBlog").addClass("imShowOn").show();
	  		}else{
	  			subMenu.find(".floatSubMenuItem").removeClass("imShowOn").hide();
	  		}
	  		if(subMenu.find(".imShowOn").length > 0){
	  			subMenu.show();
	  		}
	  	}
	  	IM_Ext.ajustChatList(obj);
	  },
	  //从msgObj中获取收藏信息
	  getFavInfo: function(msgObj, chatitem){
	  	var msgobjname = msgObj.objectName;
	  	var content = msgObj.content;
	  	var detail = msgObj.detail;
	  	var contentDom = $("<div>"+content+"</div>")[0];
	  	//格式化表情
	  	ChatUtil.imFaceFormate(contentDom);
	  	content = contentDom.innerHTML;
	  	//content = content.replace(/<br>/gim, '\r\n');
	  	content = content.replace(/\s/gim, '&nbsp;').replace(/&nbsp;/gim, ' ');
	  	content = IM_Ext.getPlainText(content);
	  	if(M_SDK_VER == 2){
			content = getEmotionText(content);
		}
		content = getEmotionObj(content);
		if("RC:TxtMsg" == msgobjname) {
	  		content = encodeURI(content);
		}
	  	//对象id
		var favid = "";
		var favtype = "6";
		//发送人id
		var senderid = chatitem.attr("_senderid");
		//发送时间
		var sendtime = chatitem.attr("_sendtime");
		var contentHtml = "";
		var favExtra = {};
		var extraObj = {};
		var extra = msgObj.extra;
		var msgtag = msgObj.msgtag;
		if(msgtag == 1){
			msgobjname += "_ding";
		}
	  	try{
	  		extraObj=eval("("+extra+")");
	  	}catch(err){
	  		//client.error("转换extra失败",err);
	  	}
	  	if("RC:ImgMsg" == msgobjname){
	  		favid = msgObj.imgUrl;
	  		if(favid == undefined){
	  			favid = extraObj.imgUrl;
	  			if(!favid){
	  				favid = detail.imageUri;
	  			}
	  		}
	  		//favtype = "7";
	  	}else if("FW:CustomShareMsg" == msgobjname){
	  		favid = extraObj.shareid;
	  		var sharetype = extraObj.sharetype;
	  		msgobjname = msgobjname + "_" + sharetype;
	  	}else if("RC:PublicNoticeMsg" == msgobjname){
	  		msgobjname = "RC:TxtMsg";
	  	}else if("FW:attachmentMsg" == msgobjname){
  			favid = extraObj.fileid;
	  	}else if("RC:LBSMsg" == msgobjname){
	  		favExtra["latitude"] = detail.latitude;
	  		favExtra["longitude"] = detail.longitude;
	  		favExtra["poi"] = detail.poi;
	  		content = detail.poi;
	  		contentHtml = detail.content;
	  	}else if("FW:richTextMsg" == msgobjname){
	  		favExtra["image"] = extraObj.image;
	  		favExtra["imageurl"] = extraObj.imageurl;
	  		favExtra["url"] = extraObj.url;
	  	}else if("RC:VcMsg" == msgobjname){
	  		contentHtml = detail.content;
	  		favExtra["duration"] = detail.duration;
	  		content = "";
	  	}else if("FW:PersonCardMsg" == msgobjname){
	  		favid = extraObj.hrmCardid;
	  	}else if("RC:TxtMsg_ding" == msgobjname){
	  		favid = msgObj.shareid;
	  	}
	  	
	  	var favData = {
			"favid": favid,
			"favtype": favtype,
			"content": content,
			"msgobjname": msgobjname,
			"senderid":senderid,
			"sendtime": sendtime,
			"contentHtml": contentHtml,
			"extra": JSON.stringify(favExtra)
		};
		
		return favData;
	  },
	  //浮动菜单点击处理
	  doFloatMenuClick: function(target, obj) {
	  	//隐藏浮动菜单
		var contentdiv = $(obj);
	  	window.clearTimeout(contentdiv.data("timerid")); 
	  	window.setTimeout(function(){	  		
	  		var floatwrap = $("#tempchatFloatmenu");
	  			floatwrap.hide();
	  	}, 100);
		//收藏
	  	if(target == "opCollect"){
	  		var chatitem = IM_Ext.getChatItem(obj);
	  		var msgObj = chatitem.data("msgObj");
			var favInfo = IM_Ext.getFavInfo(msgObj, chatitem);
			//return;
	  		$.post("/mobile/plugin/social/SocialMobileOperation.jsp?operation=savefavourate&userid="+M_USERID, {"favInfo": JSON.stringify(favInfo)}, function(resp){
	  			if(resp.issuccess){
					IM_Ext.showMsg("收藏成功");
				}else{
					IM_Ext.showMsg(resp.errormsg);
				}
	  		},'json');
	  		/*
	  		//收藏标题
	  		var fav_title = "";
	  		//收藏链接
			var fav_uri = "";
			var chatitem = IM_Ext.getChatItem(obj);
	  		var msgObj = chatitem.data("msgObj");
	  		var msgType = msgObj.msgType;
			//分享类消息
			if(msgType == 6){ 
				var objectName = msgObj.objectName;
				if(objectName == "FW:CustomShareMsg"){
					var extra = eval("("+msgObj.extra+")");
					var shareid = extra.shareid;
					var sharetitle = extra.sharetitle;
					var sharetype = extra.sharetype;
					fav_title = sharetitle;
					if(sharetype == "workflow"){
						var sharer = chatitem.find(".shareDetail").attr("_senderid");
						fav_uri = "/workflow/request/ViewRequest.jsp?requestid="+shareid+"&isfromchatshare=1&sharer="+sharer;
					}else if(sharetype == "doc"){
						fav_uri = "/docs/docs/DocDsp.jsp?id="+shareid;
					}else if(sharetype == "task"){
						fav_uri = "/rdeploy/task/data/Main.jsp?taskid=" + shareid;
					}
				}
			}
			//图片
			else if(msgType == 2) {
				fav_title = "";
			}
			//文本
			else if(msgType == 1){
				
			}
			showModalDialogForBrowser(event,
				'/systeminfo/BrowserMain.jsp?url=/favourite/FavouriteBrowser.jsp?' +
				'fav_pagename='+fav_title+'&fav_uri='+fav_uri,
				'#','msgId',false,1,'',
				{
					name:'favouriteBrowser',
					hasInput:false,
					zDialog:true,
					needHidden:true,
					dialogTitle:'收藏夹',
					arguments:'',
					_callback:IM_Ext.collectCallback
				});
			*/
	  	}
	  	//新建必达
	  	else if(target == "opBing"){	  		
	  		var title="新建必达";
	  		var chatitem = IM_Ext.getChatItem(obj);
	  		//var content = chatitem.find(".chatContent div").html();
	  		var msgObj = chatitem.data("msgObj");
	  		var msgType = msgObj.msgType;
	  		var msgid = IM_Ext.getMsgId(msgObj);
	  		var content = msgObj.content;
	  		//先转化为json对象
	  		var extra = JSON.parse(msgObj.extra);
	  		//获取当前对话的用户的id
	  		var receiverids = extra.receiverids;
	  		content = content.replace(/<br>/g, '');
	  		content = IM_Ext.getPlainText(content);
			
			var chatwin = ChatUtil.getchatwin(chatitem);
			var targettype = chatwin.attr("_targettype");
			if(targettype==1){
				ChatUtil.getUnreadId(msgid,M_USERID,function(data){
					if($.trim(data)=="0"){
						var url="/rdeploy/bing/BingAdd.jsp?from=chat&msgtype="+msgType+"&msgid="+msgid+"&receiverids="+receiverids;
					}else{
						var url="/rdeploy/bing/BingAdd.jsp?from=chat&msgtype="+msgType+"&msgid="+msgid+"&receiverids="+$.trim(data);
					}				
					var diag=getSocialDialog(title,500,450,function(){
						IM_Ext.doAddMsgTag(msgObj, diag.finalData);
					});
					diag.URL =url;
					content = encodeURI(content);
					content = $.base64.encode(content);
					diag.initData = {'content':content};
					IM_Ext.cache.msgObj = msgObj;	
					diag.show();
					document.body.click();
				});
			}else{
				var url="/rdeploy/bing/BingAdd.jsp?from=chat&msgtype="+msgType+"&msgid="+msgid+"&receiverids="+receiverids;
				var diag=getSocialDialog(title,500,450,function(){
					IM_Ext.doAddMsgTag(msgObj, diag.finalData);
				});
				diag.URL =url;
				content = encodeURI(content);
				content = $.base64.encode(content);
				diag.initData = {'content':content};
				IM_Ext.cache.msgObj = msgObj;	
				diag.show();
				document.body.click();
				
			}
	  		
	  	}
	  	//转发
	  	else if(target == "opForward"){
	  		var chatitem = IM_Ext.getChatItem(obj);
	  		var msgObj = chatitem.data("msgObj");
	  		var content =chatitem.find(".chatContent div").html();
	  		var height = chatitem.find('.chatContent').outerHeight();
	  		if(height)
	  			msgObj['_coth'] = height;
	  		IM_Ext.forwardMsg(msgObj);
	  	}
		// 撤销
		else if(target == "opWithDraw") {
			var chatitem = IM_Ext.getChatItem(obj);
			IM_Ext.resetMsgObj(chatitem);
	  		var msgObj = chatitem.data("msgObj");
	  		var content =chatitem.find(".chatContent div").html();
			var chatwin = ChatUtil.getchatwin(chatitem);
			var targettype = chatwin.attr("_targettype");
			var targetid = chatwin.attr("_targetid");
			var sendtime = chatitem.attr('_sendtime');
			try{
				  sendtime = Number(sendtime);
				  // 超过两分钟，不允许撤销
				  if(ClientSet && ClientSet.maxWithdrawTime != '0' && (M_CURRENTTIME-sendtime)/(1000*60)>parseInt(ClientSet.maxWithdrawTime)) {
					  IM_Ext.showMsg('超过三分钟');
				  }else{
					  HandleInfoNtfMsg.withDrawMsg(msgObj, targettype, targetid);
				  }
			  }catch(e){
				  IM_Ext.showMsg('撤销失败，服务器异常');
			  }
		}
		//取消网盘分享
		else if(target == "opCancelDisk"){
			var chatitem = IM_Ext.getChatItem(obj);
			IM_Ext.resetMsgObj(chatitem);
			var msgObj = chatitem.data("msgObj");			
			try{
				var msgObjExtra = eval("("+msgObj.extra+")");
			}catch(e){}
			var chatwin = ChatUtil.getchatwin(chatitem);
			var targettype = chatwin.attr("_targettype");
			var targetid = chatwin.attr("_targetid");
	  		var _msgid = msgObjExtra.msg_id;
			var _folderid = msgObjExtra.sharetype =="folder"?msgObjExtra.shareid:"";
			var _fileid = msgObjExtra.sharetype =="pdoc"?msgObjExtra.shareid:"";
			HandleInfoNtfMsg.caneclShareDiskMsg(msgObj, targettype, targetid, function callback(result){
				cancelShareDisk(_folderid,_fileid,_msgid);
			});
		}
		//添加到网盘
		else if(target == "opSaveDisk"){
			var chatitem = IM_Ext.getChatItem(obj);
			var msgObj = chatitem.data("msgObj");
			var objName = msgObj.objectName;
			try{
				var msgObjExtra = eval("("+msgObj.extra+")");
			}catch(e){}
			var _categoryid = '';
			var _folderid = '';
			var _fileid = '';
			if(objName =="FW:attachmentMsg"){
				_fileid = msgObjExtra.fileid;
			}else if(objName == "FW:CustomShareMsg"){
				var _folderid =msgObjExtra.sharetype =="folder"?msgObjExtra.shareid:"";
				_fileid = (msgObjExtra.sharetype =="pdoc"||msgObjExtra.sharetype =="doc")?msgObjExtra.shareid:"";
			}else if(objName =="RC:ImgMsg"){
				_fileid = msgObjExtra.imgUrl;
			}
			var url = "/systeminfo/BrowserMain.jsp?mouldID=networkdisk&url=/rdeploy/setting/MultiCategorySingleBrowser.jsp?hasClear=0&hasCancel=1&hasWarm=1&type=2";
			showModalDialogForBrowser(event,url,'#','resourceBrowser',false,1,'',{name:'resourceBrowser',hasInput:false,zDialog:true,needHidden:true,dialogTitle:'',arguments:'',_callback: function(event,data,name,oldid){
				var _categoryid=data.id
				saveToMyselfDisk(_categoryid,_folderid,_fileid);
			}});
		}
	  	
	  },
	  //添加消息标记
	  doAddMsgTag: function(msgObj, data){
	  	if(data && data.dingid){
	  		var dingid = data.dingid;
	  		var msgid = IM_Ext.getMsgId(msgObj);
	  		if(dingid != ""){
	  			IM_Ext._addMsgTag(1, dingid, msgid);
	  		}
	  	}
	  },
	  //添加标记
	  _addMsgTag: function(tag, shareid, msgid){
	  	if(!!localmsgtags[msgid]) {
	  		//改变消息体样式
			IM_Ext.doChangeStyleByTag(tag, shareid, msgid);
			return;
	  	}
	  	$.post("/social/im/SocialIMOperation.jsp?operation=AddMsgTag&tag="+tag+"&shareid="+shareid+"&msgid="+msgid, function(result){
			if(result.issuccess){
				//存储到本地缓存
				localmsgtags[msgid] = result.resinfo
				//改变消息体样式
				IM_Ext.doChangeStyleByTag(tag, shareid, msgid);
			}
		},'json');
	  },
	  //还原普通文本样式
	  restoreStyleByTag: function(tag, msgid){
	  	var chatitem = $("#"+msgid);
	  	//var chatlist = chatitem.parents(".chatList");
	  	var chatcontent = chatitem.find(".chatContent");
	  	var msgtagno = chatitem.attr("msgtag");
	  	if(msgtagno != tag){
	  		//client.error("restoreStyleByTag 试图转换非对应标记的气泡");
	  		return;
	  	}
	  	//获取纯文本内容
	  	var tagPrefix = (msgtagno == 1) ? "ding" : "task";
	  	var tdClass = (msgtagno == 1) ? "chatDing" : "chatTask";
		var content = chatcontent.find("."+tagPrefix+"Title").html();
		chatcontent.html(content);
		chatitem.find('.chattd').removeClass(tdClass);
		IM_Ext.resetUnreaddivHt(chatitem);
	  	chatitem.removeAttr('msgtag');
	  },
	  //修改气泡样式
	  doChangeStyleByTag: function(tag, shareid, msgid, force){
	  	var chatitem = $("#"+msgid);
	  	var chatlist = chatitem.parents(".chatList");
	  	var chatcontent = chatitem.find(".chatContent");
	  	var content = chatcontent.find('div').html();
	  	var msgtagno = chatitem.attr("msgtag");
	  	if(typeof(msgtagno) != 'undefined'){
	  		if(!force){
	  			return;
	  		}else{
	  			var tagPrefix = (msgtagno == 1) ? "ding" : "task";
		  		content = chatcontent.find("."+tagPrefix+"Title").html();
	  		}
	  	}
	  	chatitem.attr("msgtag", tag);
	  	//消除自定义字体样式
	  	chatitem = FontUtils.clearFontSetStyle(chatitem);
	  	//必达
	  	if(tag == 1){
	  		//client.log("文本转必达样式");
	  		var dingid = shareid;
	  		var dingMsgItem=$("#dingMsgTemp").clone().attr("id","ding_"+dingid).show();
	  		dingMsgItem.attr("_dingid", dingid);
			var dingContent = dingMsgItem.find(".dingMsgContent");
			var dingTitle = dingContent.find(".dingTitle");
			var dingCreator = dingContent.find(".dingCreator");
			var dingCreatime = dingContent.find(".dingCreatime");
			var dingMsgDetail = dingMsgItem.find(".dingMsgDetail");
			chatitem.find('.chattd').addClass("chatDing");
			chatcontent.html("").append(dingMsgItem);
			dingTitle.html(content);
			dingCreator.html("");
			dingCreatime.html("");
			var msgtag = localmsgtags[msgid];
			if(msgtag&&userInfos[msgtag.resinfo.sendid]){
				dingMsgItem.attr('_sendid',msgtag.resinfo.sendid);
				dingCreator.html(userInfos[msgtag.resinfo.sendid].userName);
				dingCreatime.html(msgtag.resinfo.operateDate);
				IM_Ext.setDingConfirm(dingMsgItem,msgtag.resinfo);
			}else{
				ChatUtil.getDingInfo(dingid, function(ding){
					//添加到本地缓存
					var tempmsgtag = {};
					tempmsgtag['msgid'] = msgid;
					tempmsgtag['tag'] = '1';
					tempmsgtag['shareid'] = dingid;
					tempmsgtag['resinfo'] = ding;
					localmsgtags[msgid] = tempmsgtag;
					dingMsgItem.attr('_sendid',ding.sendid);
					dingCreator.html(ding.sendname);
					dingCreatime.html(ding.operateDate);
					IM_Ext.setDingConfirm(dingMsgItem,ding);
				});
			}
	  	}
	  	//任务
	  	else if(tag == 2){
	  		//client.log("文本转任务样式");
	  		var taskid = shareid;
	  		var taskMsgItem=$("#taskMsgTemp").clone().attr("id","task_"+taskid).show();
	  		taskMsgItem.attr("_taskid", taskid);
			chatitem.find('.chattd').addClass("chatTask");
			chatcontent.html("").append(taskMsgItem);
			ChatUtil.setTaskState(taskMsgItem, taskid, content, false, msgid);
	  	}
	  	var msgObj = chatitem.data("msgObj");
	  	//重新绑定msgObj对象
	  	if(typeof(msgObj) == 'object'){
	  		msgObj["msgtag"] = tag;
	  		msgObj["shareid"] = shareid;
	  	}
	  	chatitem.data("msgObj", msgObj);
	  	//重新计算未读提示的位置
	  	IM_Ext.resetUnreaddivHt(chatitem);
	  	scrollTOBottom(chatlist);
	  },
	  //重新计算未读提示的位置
	  resetUnreaddivHt: function(chatitem){
	  	var msgObj = chatitem.data("msgObj");
	  	var recordType = 'send';
	  	try{
	  		recordType = msgObj.recordType; 
	  	}catch(err){
	  		recordType = 'send';
	  	}
	  	if(typeof(recordType) == 'undefined'){
	  		if(chatitem.find(".chatRItem").length > 0){
	  			recordType = "send";
	  		}else{
	  			recordType = "receive";
	  		}
	  	}
	  	//重新计算未读提示的位置
	  	if("send" == recordType){
	  		var outerHeight = chatitem.find(".chatContentdiv").outerHeight();
	  		var height = outerHeight + 'px';
	  		chatitem.find(".msgUnreadCount").css({"height":height,"line-height":height});
	  	}else{
	  		chatitem.find(".msgUnreadCount").css({"height":0,"line-height":0});
	  	}
	  },
	  //设置必达确认提示
	  setDingConfirm: function(dingMsgItem, dingInfo){
	  	var dingStatediv = dingMsgItem.find(".dingState");
	  	var dingMsgContentdiv = dingMsgItem.find(".dingMsgContent");
	  	var result = IM_Ext.isDingReciver(dingInfo);
  		//是必达的接受者并且登录者不是发送人，显示“已确认”或“确认收到”
  		if(result.isReciver && M_USERID != dingInfo.sendid){
  			if(result.confirm == 'true'){
  				dingStatediv.
  					addClass("dingComfirmed").
  					removeClass("dingComfirm").
					html("已确认").attr("onclick","");
  			}else{
  				dingStatediv.
  					addClass("dingComfirm").
  					removeClass("dingComfirmed").
					html("确认收到").attr("onclick","IM_Ext.confirmDing(this, '"+result.dingid+"')");
  			}
  		}
  		//登录者是发送人显示确认详情，显示“X人未确认”或“全部已确认”
  		else if(M_USERID == dingInfo.sendid){
  			//特殊情况：‘我’是发送者且是唯一的接受者，优先认定就是接受者的身份
			if(result.reciverCnt == 1 && result.isReciver){
				if(result.confirm == 'true'){
					dingStatediv.
	  					addClass("dingComfirmed").
	  					removeClass("dingComfirm").
						html("已确认").attr("onclick","");
				}else{
					dingStatediv.
	  					addClass("dingComfirm").
	  					removeClass("dingComfirmed").
						html("确认收到").attr("onclick","IM_Ext.confirmDing(this, '"+result.dingid+"')");
				}
				return;
			}
  			var dingRecivers = dingInfo.dingRecivers,unconfirmCnt = 0;
	  		for(var i = 0; i < dingRecivers.length; ++i){
	  			if(dingRecivers[i].confirm == 'false'){
	  				unconfirmCnt++;
	  			}
	  		}
	  		var tip = "全部已确认";
	  		if(unconfirmCnt > 0){
	  			tip = unconfirmCnt + "人未确认";
	  			dingStatediv.css("cursor", "pointer");
	  		}
	  		dingStatediv.
				addClass("dingComfirmed").
				removeClass("dingComfirm").
				html(tip).attr("onclick","IM_Ext.showDingConDetail(this, '"+dingInfo.id+"', 'chat');");
  		}
  		//即不是发送者又不是接受者，还原成普通文本显示
  		else{
  			IM_Ext.restoreStyleByTag(1, dingInfo.messageid);
  			/*
  			dingStatediv.remove();
			dingMsgContentdiv.css({
				"border-bottom": 'none',
				"padding-bottom": '0'
			});
			*/
  		}
	  },
	  //查看确认详情
	  showDingConDetail: function(dingStatediv, dingid, from){
	  	var detailUrl="/rdeploy/bing/BingConfirmStatus.jsp?dingid="+dingid;
		if(from=="chat"){
			var title="确认详情";
		    var url=detailUrl;
			var diag=getSocialDialog(title,500,450);
			diag.URL =url+"&from=chat";
			diag.show();
		}
	  },
	  //确认必达
	  confirmDing: function(dingStatediv, dingid){
	  	$.post("/rdeploy/bing/BingOperation.jsp?operation=doConfirm",{"dingid":dingid},function(data){
	  		var count=Number($.trim(data));
	  		var $dingStatediv = $(dingStatediv);
	  		var msgid = $dingStatediv.parents(".chatItemdiv").attr("id");
	  		$dingStatediv.addClass("dingComfirmed").
	  					removeClass("dingComfirm").
						html("已确认").attr("onclick","");
			//确认后更新本地缓存
			ChatUtil._getMsgTags([msgid]);
	  	});
	  },
	  //判断当前是否是必达的接受者
	  isDingReciver: function(dingInfo){
	  	var dingRecivers = dingInfo.dingRecivers;
	  	for(var i = 0; i < dingRecivers.length; ++i){
	  		if(dingRecivers[i].userid == M_USERID){
	  			return {"isReciver": true, "reciverCnt": dingRecivers.length, "confirm": dingRecivers[i].confirm, "dingid": dingRecivers[i].dingid};
	  		}
	  	}
	  	return {"isReciver": false};
	  },
	  //获取msgid
	  getMsgId: function(msgObj){
		var msgid, extraObj ;
	  	try{
	  		if(msgObj.extra) {
				extraObj = msgObj.extra;
			}else{
				extraObj = msgObj.getExtra();
			}
	  		extraObj=eval("("+extraObj+")");
	  		msgid = extraObj.msg_id;
	  	}catch(err){
	  		//client.error("getMsgId转换extra失败",err);
	  	}
	  	return msgid;
	  },
	  //重写objname
	  transObjName: function(msgObj){
	  	
	  	// 公告 RC:PublicNoticeMsg
	  	if('objectName' in msgObj) {
	  		switch(msgObj.objectName){
	  		case 'RC:PublicNoticeMsg':
	  			msgObj['objectName'] = 'RC:TxtMsg';
	  			msgObj['msgType'] = 1;
	  			break;
	  		}
	  	}
	  	return msgObj;
	  },
	  // 重置msgid
	  resetMsgObj: function(chatitem) {
	  	var msgObj = chatitem.data('msgObj');
	  	var extraObj = {}, msgid = chatitem.attr('id');
		try{
			extraObj = eval("("+msgObj.extra+")");
			extraObj['msg_id'] = msgid;
			msgObj['extra'] = JSON.stringify(extraObj);
		}catch(e){
			//client.error("transMsgId转换extra失败",e);
		}
		
		chatitem.data('msgObj', msgObj);
		return chatitem;
	  },
	  //重写msgid
	  transMsgId: function(msgObj){
	  	var msgid=IMUtil.guid();
	  	var extraObj = {};
		try{
			extraObj = eval("("+msgObj.extra+")");
			extraObj['msg_id'] = msgid;
			msgObj['extra'] = JSON.stringify(extraObj);
		}catch(e){
			//client.error("transMsgId转换extra失败",e);
		}
        //detail object
        var detailObj = {};
        try{
        	if(typeof msgObj.detail == 'object'){
        		detailObj = msgObj.detail;
        	}else{
        		detailObj = JSON.parse(msgObj.detail);
        	}
			var detailExtraObj = eval("("+detailObj.extra+")");
			detailExtraObj['msg_id'] = msgid;
			detailObj['extra'] = JSON.stringify(detailExtraObj);
			msgObj['detail'] = JSON.stringify(detailObj);
		}catch(e){
			//client.error("transMsgId转换detail失败",e);
		}
        return {"msgObj":msgObj, "msgid":msgid};
	  },
	  //来源转发
	  repeatFromFav: function(favInfo, callback){
	  	if(favInfo.msgobjname && favInfo.msgobjname == 'RC:TxtMsg') {
			favInfo.content = decodeURI(favInfo.content);
		}
	  	var msgObj = IM_Ext.getMsgObj("fav", favInfo);
	  	IM_Ext.forwardMsg(msgObj);
	  	IM_Ext.cache.callback = callback;
	  },
	  //获取消息体
	  getMsgObj: function(from, info){
	  	var msgObj = {};
	  	if("fav" == from){
	  		var favid = info.favouriteObjId;
			var	objname = info.msgobjname;
			var content = info.content;
			msgObj['content'] = content;
			msgObj['objectName'] = IM_Ext.getRealObjname(objname);
			var msgType = IM_Ext.getMsgType(objname);
			msgObj['msgType'] = msgType;
			var extraObj = IM_Ext.getExtraByInfo(info);
			msgObj['extra'] = extraObj;
	  	}
	  	return msgObj;
	  },
	  //获取图片Id
	  getImgUrl: function(msgObj){
	  	var imgUrl = "";
	  	if(typeof msgObj == 'object'){
	  		try{
	  			imgUrl = msgObj.imgUrl;
	  			if(!imgUrl){
	  				var extraObj = IM_Ext.getExtraObj(msgObj);
	  				imgUrl = extraObj.imgUrl;
	  				if(!imgUrl){
	  					imgUrl = msgObj.detail.imageUri;
	  				}
	  			}
	  		}catch(e){
	  			//client.error("error from IM_Ext.getImgUrl",e);
	  		}
	  	}
	  	return imgUrl;
	  },
	  //获取ExtraObj
	  getExtraObj: function(msgObj){
	  	var extraObj = {};
	  	if(typeof msgObj == 'object'){
	  		try{
				extraObj = eval("("+msgObj.extra+")");
	  		}catch(e){
	  			//client.error("error from IM_Ext.getExtraObj",e);
	  		}
	  	}
	  	return extraObj;
	  },
	  //获取消息类型
	  getMsgType: function(msgobjname){
	  	var realObjname = IM_Ext.getRealObjname(msgobjname);
	  	var rongMsgType = '';
	  	var typeMapping = CONST.typeMapping;
	  	if(realObjname in typeMapping)
	  		rongMsgType = typeMapping[realObjname];
	  	return RongIMClient.MessageType[rongMsgType].value;
	  },
	  //获取消息类型描述
	  getRealObjname: function(msgobjname){
	  	if(/FW:CustomShareMsg/.test(msgobjname)){
	  		return "FW:CustomShareMsg";
	  	}else if(/RC:TxtMsg/.test(msgobjname)){
	  		return "RC:TxtMsg";
	  	}else{
	  		return msgobjname;
	  	}
	  },
	  //获取extraObj
	  getExtraByInfo: function(info){
	  	var	objname = info.msgobjname;
	  	var msgid=IMUtil.guid();
		var extra="\"msg_id\":\""+msgid+"\"";
	  	if(/RC:ImgMsg/.test(objname)){
	  		var imgUrl = info.favouriteObjId;
	  		extra+=",\"imgUrl\":\""+imgUrl+"\"";
	  	}else if(/FW:attachmentMsg/.test(objname)){
	  		var fileName = info.content;
	  		var fileId = info.favouriteObjId;
	  		var fileSize = info.filesize;
	  		var fileType = info.filetype;
	  		extra+=",\"fileName\":\""+fileName+"\",\"fileid\":\""+fileId+"\",\"fileSize\":\""+fileSize+"\",\"fileType\":\""+fileType+"\"";
	  	}else if(/FW:CustomShareMsg/.test(objname)){
	  		var shareid = info.favouriteObjId;
	  		var sharetitle = info.content;
	  		var sharetype = objname.split("_")[1];
	  		extra+=",\"shareid\":\""+shareid+"\",\"sharetitle\":\""+sharetitle+"\",\"sharetype\":\""+sharetype+"\"";
	  	}
	  	extra="{"+extra+"}";
	  	return extra;
	  },
	  //消息转发
	  forwardMsg: function(msgObj){
	  	IM_Ext.cache.msgObj = msgObj;
        var title="分享";
		var loginuserid = M_USERID;
		var msgContent = getMsgContent(null, msgObj);
		msgContent = IM_Ext.truncContent(msgContent, 100);
	    var url=getPostUrl("/social/im/SocialHrmBrowser.jsp?boxTitle="+msgContent+"&coth="+msgObj['_coth']);
		var diag=getSocialDialog(title,400,500);
		diag.URL =url;
		diag.openerWin = window;
		diag.show();
		document.body.click();
	  	
	  	
	  	/*
        // pc端对拖拽特殊处理
        if(typeof from != 'undefined' && from == 'pc') {
            DragUtils.closeDrags();
        }
        
  		showModalDialogForBrowser(event,'/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?' +
				'selectedids=','#','resourceid',false,1,'',
		{
			name:'resourceBrowser',
			hasInput:false,
			zDialog:true,
			needHidden:true,
			dialogTitle:'人员',
			arguments:'',
			_callback:IM_Ext.resourceBrowserCallback
		});
        
        // pc端对拖拽特殊处理
        if(typeof from != 'undefined' && from == 'pc') {
            browserDialog.closeHandle = function(){
                browserDialog.closeHandle = null;
                DragUtils.restoreDrags();
            };
        }
        */
	  },
	  //按字符长度截断字符串
	  truncContent: function(content, len, startPos){
	  	if(!content){
	  		return null;
	  	}
	  	//去除<br>
	  	content = content.replace(/<br>/g, ' ');
	  	var actLen = content.length;
	  	if(actLen <= len){
	  		return content;
	  	}
	  	startPos = startPos?(startPos > 0? startPos : 0):0;
	  	var contentCache = content.substring(startPos, startPos + len);
	  	return contentCache;
	  },
	  //刷新接受人id
	  refreshReceiver: function(targetId, targetType, msgObj){
	  	var extraObj = {};
	  	var receiverids = targetId;
	  	if(targetType == 1){
	  		receiverids=ChatUtil.getMemberids(targetType,targetId,false);
	  	}
		try{
			extraObj = eval("("+msgObj.extra+")");
			extraObj['receiverids'] = receiverids;
			msgObj['extra'] = JSON.stringify(extraObj);
		}catch(e){
			//client.error("refreshReceiver转换extra失败",e);
		}
		return msgObj;
	  },
	  //刷新字体设置
	  refreshFontSet: function(msgObj){
	  	var extraObj = {};
		try{
			extraObj = eval("("+msgObj.extra+")");
			extraObj['bubblecolor'] = FontUtils.getColorHex(FontUtils.getConfig('bubblecolor', FontUtils.defaults.bubblecolor));
			msgObj['extra'] = JSON.stringify(extraObj);
		}catch(e){
			//client.error("refreshReceiver转换extra失败",e);
		}
		return msgObj;
	  },
	  //发送单聊消息
	  sendMsgToUserOrDiscuss:function(targetId,targetName, targetType,msgObj,msgType, callback){
		if(targetType=='1'){
			var discuss = discussList[targetId];
			if(!discuss){
				ChatUtil.getDiscussionInfo(targetId, true, function(discuss){
					IM_Ext.sendMsgToUserOrDiscussCallBack(targetId,targetName, targetType,msgObj,msgType, callback)
				});
			}else{
				 IM_Ext.sendMsgToUserOrDiscussCallBack(targetId,targetName, targetType,msgObj,msgType, callback)
			}
		}else{
			IM_Ext.sendMsgToUserOrDiscussCallBack(targetId,targetName, targetType,msgObj,msgType, callback);
		}
	  },
	  sendMsgToUserOrDiscussCallBack:function(targetId,targetName, targetType,msgObj,msgType, callback){
	  	//重写msgid
		var transMsgObj = IM_Ext.transMsgId(msgObj);
		var msgid = transMsgObj.msgid;
		msgObj = transMsgObj.msgObj;
		msgObj = IM_Ext.formatMsgContent(msgObj);
		//重置receiverids
		msgObj = IM_Ext.refreshReceiver(targetId, targetType, msgObj);
		msgObj = IM_Ext.transObjName(msgObj);
		//重置颜色气泡
		msgObj = IM_Ext.refreshFontSet(msgObj);
		IM_Ext.cache.msgObj = msgObj;
		IM_Ext.cache.msgId = msgid;
		//修复私有云下语音消息缺少duration属性
		if(IS_BASE_ON_OPENFIRE && msgObj.objectName == 'RC:VcMsg' && typeof msgObj.duration != 'number'){
			try{
				msgObj.duration = Number(JSON.parse(msgObj.detail).duration);
			}catch(err){
				msgObj.duration = 1;
			}
		}
	  	var triggerFunc = function(result){
	  		//client.log("转发结果",result);
	  		var _msgObj = IM_Ext.cache.msgObj;
	  		var _msgId = IM_Ext.cache.msgId;
			//if(result.issuccess){
				IM_Ext.showMsg("转发成功");
				//如果转发的是图片或者是附件则添加到相关资源权限表里
				if(_msgObj.objectName == "RC:ImgMsg" || _msgObj.objectName == "FW:attachmentMsg"){
					IM_Ext.addFileRight(_msgObj,targetId, targetType);
				}
				//同步消息
				ChatUtil.publishMessage(_msgObj);
				//更新会话和聊天窗口
				var userInfo=userInfos[M_USERID];
				var msgContent=userInfo.userName+":"+
					getMsgContent(null,
						{
							"content":_msgObj.content,
						 	"objectName":_msgObj.objectName,
						 	"extra":_msgObj.extra,
						 	"msgType":_msgObj.msgType
						 });
				var sendtime=M_CURRENTTIME;
				updateConversationList(userInfo,targetId,targetType,msgContent,sendtime);
				var chatdiv = $("#chatdiv_"+targetId);
				if(chatdiv.length > 0/* && targetid != M_USERID*/){
					var tempdiv=ChatUtil.getChatRecorddiv(userInfo,_msgObj,'send',_msgObj.msgType, null, targetId);
					tempdiv.attr('_coth', msgObj['_coth'])
					var chatlist = chatdiv.find(".chatList");
					chatlist.append(tempdiv);
					scrollTOBottom(chatlist);
				}
				//初始化阅读记录
				if(targetType == '0'){
					ChatUtil.initMsgRead(_msgId,targetType,targetId,true,targetId);
				}else if(targetType == '1'){
					var resourceids=ChatUtil.getMemberids(targetType,targetId,false);
					ChatUtil.initMsgRead(_msgId,targetType,resourceids,true,targetId);
				}
				//同步到本地会话
				var jsconverList = [{
					senderid:M_USERID,
					targetid: targetId,
					targettype: targetType,
					msgcontent: msgContent,
					sendtime: sendtime,
					targetname:targetName,
					receiverids:ChatUtil.getMemberids(targetType,targetId,true)
				}];
				ChatUtil.syncConversToLocal(jsconverList);
				//如果是流程，文档，项目添加共享权限[ps: 网盘和客户卡片已单独做处理--参考socialHrmBrowser.jsp]
				var extraObj = IM_Ext.getExtraObj(_msgObj);
				if(extraObj && _msgObj.objectName == "FW:CustomShareMsg" 
					&& extraObj.sharetype != "pdoc" && extraObj.sharetype != "folder"&& extraObj.sharetype != "crm"){
					var resourcetype = getResourcetype(extraObj.sharetype);
					var resourceid = extraObj.shareid;
					var sharegroupid = targetType == '1'?targetId:"";
					var receiverids = extraObj.receiverids;
					addShareRight(resourcetype, resourceid, sharegroupid, receiverids);
				}
			//}
			//var callback = IM_Ext.cache.callback;
			if(callback && typeof callback == 'function'){
				callback(result);
			}
	  	}
	  	// 修复公有云转发图片手机打不开的问题
	  	if(!IS_BASE_ON_OPENFIRE &&msgObj.objectName == 'RC:ImgMsg') {
	  		var extraObj = IM_Ext.getExtraObj(msgObj);
	  		msgObj.imgUrl = extraObj.imgUrl;
	  	}
	  	if(targetType == '0'){
	  	    if(ChatUtil.isFromPc()&&WindowDepartUtil.isAllowWinDepart()){
	  	        ClientUtil.sendMessageToUser(targetId, msgObj, msgType,targetType,triggerFunc);
	  	    }else{
	  	        client.sendMessageToUser.call(client, targetId, msgObj, msgType, triggerFunc);
	  	    }
	  	}else if(targetType == '1'){
	  	    if(ChatUtil.isFromPc()&&WindowDepartUtil.isAllowWinDepart()){
	  	        ClientUtil.sendMessageToDiscussion(targetId, msgObj, msgType,targetName,targetType,triggerFunc);
	  	    }else{
	  	        client.sendMessageToDiscussion.call(client, targetId, msgObj, msgType, triggerFunc);
	  	    }
	  		
	  	}
	  },
	  //转发处理
	  resourceBrowserCallback: function(event,data,name,oldid){
	  	if (data!=null){
	        if (data.id!= ""){
	        	var resourceids=data.id.split(",");
	        	var msgObj = IM_Ext.cache.msgObj;
        		var extraObj = {};
    			try{
    				extraObj = eval("("+msgObj.extra+")");
    			}catch(e){
    				extraObj = {};
    			}
    			if(!extraObj){
    				extraObj = {};
    			}
        		if(msgObj.objectName == 'RC:ImgMsg' && msgObj.imgUrl == undefined){
        			msgObj['imgUrl'] = extraObj.imgUrl;
        		}
        		//如果是公告，要转成纯文本类型
        		if(msgObj.objectName == 'RC:PublicNoticeMsg'){
        			msgObj.msgType = 1;
        			msgObj.objectName = 'RC:TxtMsg';
        		}
        		if(!extraObj.hasOwnProperty("receiverids")){
        			extraObj['receiverids'] = data.id;
    				msgObj['extra'] = JSON.stringify(extraObj);
    				IM_Ext.cache.msgObj = msgObj;
    			}
	        	resourceids.forEach(function(resourceid){
	        		IM_Ext.sendMsgToUserOrDiscuss(resourceid, userInfos[resourceid].userName, '0',IM_Ext.cache.msgObj,IM_Ext.cache.msgObj.msgType);
	        	});
	        }else{
	        	
	        }
		 }
	  },
	  //格式化消息内容(含表情or@)
	  formatMsgContent: function(msgObj){
	  	var content = msgObj.content;
	  	var objName = msgObj.objectName;
	  	var extra = msgObj.extra;
	  	if(objName == 'RC:TxtMsg'){
	  		var contentObj = $("<div>"+content+"</div>");
	  		//表情
	  		content=ChatUtil.formatChatContent(contentObj);
			msgObj['content'] = content;	
	  	}
	  	
	  	return msgObj;
	  },
	  //添加资源权限
	  addFileRight: function(msgObj,targetid, targettype){
	  	var resourcetype = 1;
		var extraObj = {};
		try{
			extraObj = eval("("+msgObj.extra+")");
		}catch(e){
			
		}
		var fileId = extraObj.fileid;
		if(msgObj.msgType == 2){
			resourcetype = 2;
			fileId = msgObj.imgUrl;
			if(!fileId || fileId == ""){
				fileId = extraObj.imgUrl;
			}
		}
		var memberids=ChatUtil.getMemberids(targettype, targetid,true);
		var filedata = {
			"resourcetype": resourcetype,
			"fileId": fileId,
			"memberids": memberids
		};
		_addIMFileRight(targetid, targettype, filedata);
	  },
	  //提取纯文本
	  getPlainText: function(content){
	  	var $content = $("<div>"+content+"</div>");
	  	var plainText = $content[0].innerText;
	  	plainText = IMUtil.replaceSpace160(plainText);
	  	return plainText;
	  },
	  //根据参数获取收藏链接
	  getFavuriByShare: function(share){
	  	var url;
	  	var sharetype = share.sharetype;
	  	var shareid = share.shareid;
	  	var sharer = share.sharer;
	  	if(sharetype=="workflow"){
			url="/workflow/request/ViewRequest.jsp?requestid="+shareid+"&isfromchatshare=1&sharer="+sharer;
		}else if(sharetype=="doc"){
			url="/docs/docs/DocDsp.jsp?id="+shareid;
		}
		return url;
	  },
	  //浮动菜单子菜单处理
	  doSubMenuItemClick: function(target, pTarget, obj) {
	  	var chatitem = IM_Ext.getChatItem(obj);
	  	var msgObj = chatitem.data("msgObj");
	  	var content = msgObj.content;
	  	content = content.replace(/<br>/g, '');
	  	switch(pTarget) {
	  		case 'opMore':
	  			//转为任务
	  			if(target == "opSendToTask"){
	  				content = IM_Ext.getPlainText(content);
	  				content = content.replace(/&nbsp;/gi, ' ');
	  				var msgid = IM_Ext.getMsgId(msgObj);
	  				ChatUtil.openTaskAdd(content, msgid);
	  				/*
	  				$.post("/rdeploy/im/IMOperation.jsp?operation=sendtotask&content="+content,function(resp){
	  					if(resp.issuccess){
	  						IM_Ext.showMsg("转为任务成功");
	  					}else{
	  						IM_Ext.showMsg(resp.errormsg);
	  					}
	  				}, "json");
	  				*/
	  			}
	  			//发送到日志
	  			else if(target == "opSendToBlog"){
	  				$.post("/rdeploy/im/IMOperation.jsp?operation=sendtoblog&content="+content,function(resp){
	  					if(resp){
	  						IM_Ext.showMsg("发送到日志成功");
	  					}
	  				});
	  			}
	  		break;
	  		
	  	}
	  	//FIXME: 简单地隐藏菜单
	  },
	  //获取消息气泡
	  getChatItem: function(obj){
	  	//直接找上级元素
	  	var chatitem = $(obj).parents(".chatItemdiv");
	  	if(chatitem.length > 0)
	  		return chatitem;
	  	var floatmenu = $(obj).parents(".chatFloatmenuWrap");
	  	if(floatmenu.length == 0){
	  		floatmenu = $("#tempchatFloatmenu");
	  	}
	  	var chatitemid = floatmenu.attr('_chatitemid');
	  	chatitem = $("#"+chatitemid);
	  	return chatitem
	  },
	  //适应窗口高度
	  ajustChatList: function(obj){
	  	var chatlist = $(obj).parents(".chatList");
	  	chatlist.perfectScrollbar('update');
	  	var chatitem = $(obj).parents(".chatItemdiv");
	  	if(chatitem.nextAll(".chatItemdiv").length == 0){
	  		scrollTOBottom(chatlist);
	  	}
	  },
	  //判断mouseover/mouseout的处理对象
	  isMouseLeaveOrEnter: function(e, handler) {  
	    if (e.type != 'mouseout' && e.type != 'mouseover') return false;  
	    var reltg = e.relatedTarget ? e.relatedTarget : e.type == 'mouseout' ? e.toElement : e.fromElement;  
	    while (reltg && reltg != handler)  
	        reltg = reltg.parentNode;  
	    return (reltg != handler);  
	  },
	  //显示浮动提示
	  //消息提醒
	  showMsg: function(msg){
		jQuery("#warn").find(".title").html(msg);
		jQuery("#warn").css("display","block");
		setTimeout(function (){
			jQuery("#warn").css("display","none");
		},1500);
	  },
	  //图片集合
	  icrimgPool:[],
	  icrResIds:[],
	  cache:{
	  	msgObj: null
	  }
	  
}

/*静态资源*/
CONST = {
	typeMapping : {
            "RC:TxtMsg": "TextMessage",
            "RC:ImgMsg": "ImageMessage",
            "RC:VcMsg": "VoiceMessage",
            "RC:ImgTextMsg": "RichContentMessage",
            "RC:LBSMsg": "LocationMessage",
            "FW:CustomShareMsg": "UnknownMessage",
            "FW:attachmentMsg": "UnknownMessage",
            "RC:PublicNoticeMsg": "UnknownMessage",
            "FW:PersonCardMsg": "UnknownMessage",
            "FW:richTextMsg": "UnknownMessage"
            
        },
    optionMap: {
		"all": "全部",
		"interest": "关注"
	},
	taskStatus: {
		"UNCOMPLETE": 1,
		"COMPLETE": 2,
		"DELETE": 4
	}
}
