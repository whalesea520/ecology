function bindCloseBtnHover(targettype, targetid){
  	var chatwin=$("#chatWin_"+targettype+"_"+targetid);
 	chatwin.live("hover",function(event){
		if(event.type=='mouseenter'){ 
			$(this).find(".imCloseSpan").css("display", "inline-block");
		}else{ 
		  	$(this).find(".imCloseSpan").css("display", "none");
		} 
	});
	chatwin.find(".chatList,.noteList,.icrList").hover(
		function(){
			
		},
		function(){
			var curChatwin = $(this).parents(".chatWin");
			curChatwin.find(".imCloseSpan").css("display", "none");
		}
	);
	chatwin.find(".imtitle").hover(
		function(){
			var curChatwin = $(this).parents(".chatWin");
			curChatwin.find(".imCloseSpan").css("display", "inline-block");
		},
		function(){
			
		}
	);
	chatwin.find(".chattop").hover(
		function(){
			var curChatwin = $(this).parents(".chatWin");
			curChatwin.find(".imCloseSpan").css("display", "inline-block");
		},
		function(){
		}
	);
  }

  //border: 1px solid #7f878a
  /*切换模式*/
  function changeEditMode(obj) {
  	var isTaskMode = false;
  	var sw = $(obj);
  	if(sw.hasClass("modeChangeSwitchActive")){
  		sw.removeClass("modeChangeSwitchActive");
  		$(sw.parents(".chatbottom")[0]).removeClass("chatbottomtaskmode");
  		isTaskMode = false;
  		sw.attr("title", "切换到任务输入");
  		sw.parent().find(".chatcontent").attr("_istaskmode", "0").html("<span class='modehint'>输入您要发送的内容，Enter键发送，Shift+Enter键换行</span>");
  		sw.parent().addClass("chatContentActive").removeClass("chatContentActiveTask");
  	}else{
  		sw.addClass("modeChangeSwitchActive");
  		$(sw.parents(".chatbottom")[0]).addClass("chatbottomtaskmode");
  		isTaskMode = true;
  		sw.attr("title", "切换到普通输入");
  		sw.parent().find(".chatcontent").attr("_istaskmode", "1").html("<span class='modehint'>添加一个新的任务</span>");
  		sw.parent().addClass("chatContentActiveTask").removeClass("chatContentActive");
  	}
  	var appdivs = sw.parents(".chatbottom").find(".chatAppdiv .chatapp");
  	if(isTaskMode){
  		//禁用chatappdiv
  		addDisabledLayer(appdivs);
  	}else{
  		removeDisabledLayer(appdivs);
  	}
  }
  
  function addDisabledLayer(appdivs){
  	appdivs.each(function(){
		var maskLayer = IMUtil.getLayer(IMUtil.getPageOffset(this),"maskLayer");
		$(this).parent().append(maskLayer);
	});
  }
  
  function removeDisabledLayer(appdivs){
  	appdivs.each(function(){
		$(this).parent().find(".maskLayer").remove();
	});
  }
  /*自适应窗口高度*/
  function ajustChatWin(obj){
  	var chatct = $(obj);
  	chatct.perfectScrollbar('update');
  	var chatbottom = chatct.parents(".chatbottom");
  	var ht = chatbottom.height();
  	console.log("聊天窗口底部高度："+ht);
  	var chatdiv = ChatUtil.getchatdiv(obj);
  	var chatlist = chatdiv.find(".chatList");
  	chatlist.perfectScrollbar('update');
  	scrollTOBottom(chatlist);
  	chatlist.css("bottom", ht);
  	
  }
  /*处理编辑时联动*/
  function toggleWithEditing(obj, evt) {
  	evt = evt || window.event;
  	var chatct = $(obj);
  	var htm = chatct.html();
  	var orgHt = chatct.data("orgHeight");
  	if(htm != "" && htm != "<br>"){
  		chatct.parent().find(".immodeChangeSwitch").hide();
  	}else{
  		chatct.parent().find(".immodeChangeSwitch").show();
  	}
  }
  /*处理enter发送消息*/
  function doEnterSend(obj, evt){
  	evt = evt || window.event;
	var keynum;
	if(window.event)
    	keynum=evt.keyCode;
    else
        keynum=evt.which;
    var tempContent = $(obj).html();
    var ht = $(obj).height();
    $(obj).data("orgHeight", ht);
    if(evt.shiftKey&&(keynum==13||keynum==10)){
    	evt.returnvalue = true;
    	return true;
    }
    else if(keynum==13||keynum==10){
    	var atwhoid="atwho-ground-"+$(obj).attr("id");
		if($("#"+atwhoid+" .atwho-view").is(":visible")){
			event.keyCode = 0;//屏蔽回车键
			event.returnvalue = false; 
			stopEvent();
			return false;
		}
    	var mode = getEditMode(obj);
    	if(tempContent == "" || tempContent == "<br>"){
    		return false;
    	}
    	
	  	if(mode == "normal")
	  		ChatUtil.enterIMSend(obj,evt);
	  	else if(mode == "task"){
	  		enterSendTask(obj, evt);
	  	}
	  	//清空编辑器
	  	$(obj).html("").focus();
	  	evt.keyCode = 0;//屏蔽回车键
		evt.returnvalue = false; 
		stopEvent();
	  	return false;
    }else if(event.ctrlKey&&(keynum==90)){
		//ctrl+z
		var cacheContent = ChatUtil.cache.chatContents; 
		if(cacheContent.length > 0){
			var cot = cacheContent.pop();
			ChatUtil.cache.cache4ctrlz.push( $(obj).html());
			$(obj).html(cot);
			IMUtil.moveToEndPos(obj)
		}
	}else if(event.ctrlKey&&(keynum==89)){
		//ctrl+y
		var cache4ctrlz = ChatUtil.cache.cache4ctrlz; 
		if(cache4ctrlz.length > 0){
			var cot = cache4ctrlz.pop();
			ChatUtil.cache.chatContents.push( $(obj).html());
			 $(obj).html(cot);
			IMUtil.moveToEndPos(obj)
		}
	}else if(keynum==8){
		var chds =obj.childNodes;
		if(chds.length == 0) return true;
		$(obj).find("A.hrmecho").each(function(index, elem){
			if(index > 0){
				$(elem).before(" ");
			}
		});
	}
  }
  /*获取当前编辑模式*/
  function getEditMode(chatcontentdiv){
  	var istaskmode = $(chatcontentdiv).attr("_istaskmode");
  	if(istaskmode == '1') return "task";
  	else return "normal";
  }
  /*发送创建任务的消息*/
  function enterSendTask(obj, evt) {
  	var chatdiv = $(obj).parents(".chatdiv")[0];
  	var tempContent = IMUtil.cleanBR($(obj).html());
  	tempContent = tempContent.replace(/&nbsp;/gi, ' ');
  	
  	//创建任务接口(bugy)
  	var shareids = "";
  	var chatWin = $(obj).parents('.chatWin').first();
  	var targetid = chatWin.attr('id').substring(10);
	var targettype = chatWin.attr('id').substring(8,9);
	ChatUtil.getDiscussionInfo(targetid, true, function(){
		shareids = ChatUtil.getMemberids(targettype, targetid);
		$.post("/mobile/plugin/social/SocialMobileOperation.jsp?operation=addtask&tasktitle="+tempContent+"&shareids="+shareids, function(taskinfo){
			taskinfo = $.trim(taskinfo);
			if(taskinfo != ""){
				taskinfo = $.parseJSON(taskinfo);
			}
			var data = {
			"objectName":"FW:CustomShareMsg",
			"shareid":taskinfo.taskid, 
			"sharetype":"task", 
			"sharetitle":tempContent,
			"createdate":taskinfo.createdate, 
			"status":taskinfo.status,
			"creatorid":taskinfo.creatorid};
	  		var tempdiv = ChatUtil.sendIMMsgAuto(chatdiv, 6, data);
	  		var resourcetype = 2;
	  		var resourceid = taskid;
	  		var sharegroupid = targettype=='1'?targettype:"";
	  		var resourceids=ChatUtil.getMemberids(targettype, targetid, true);
	  		$.post("/mobile/plugin/chat/addShare.jsp?resourcetype="+resourcetype+"&resourceid="+resourceid+"&sharegroupid="+sharegroupid,{"resourceids":resourceids},function(){
		    	
		    });
	  	});
	});
  }