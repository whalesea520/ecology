
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<script>


var diag=null;
function addGroup(groupid){
	    var title="新建群";
	    var url="/social/group/SocialGroupSetting.jsp";
	    if(groupid){
	    	title="群设置";
	    	url+="?groupid="+groupid;
	    }
		diag=getDialog(title,600,530);
		diag.URL =url;
		diag.show();
		document.body.click();
 }

function getNoticediv(senderInfo,objName){
	var noticeContent="通知消息";
	if(objName=="RC:DizNtf"){
		noticeContent=senderInfo.userName+" 退出了群";
	}
	var noticediv="<div class='chatItemdiv chatNotice'><span>"+noticeContent+"</span></div>";
	//return noticediv;
	return "";
}


function updateConversationList(sendinfo,targetid,targetType,content,sendtime){
	
	$("#recentListdiv .dataloading").hide();
	var converTempdiv=$("#conversation_"+targetid);
	
	if(converTempdiv.length==0){
	
		converTempdiv=$(".converTemp").clone().removeClass("converTemp").show();
		
		var targetHead="";
		var targetName="";
		
		if(targetType==0){
			var targetInfo=getUserInfo(targetid);
			var targetHead=targetInfo.userHead;
			var targetName=targetInfo.userName;
		}
		
		
		converTempdiv.find(".targetHead").attr("src",targetHead);
		converTempdiv.find(".targetName").html(targetName);
		converTempdiv.attr("id","conversation_"+targetid).attr("_targetid",targetid).attr("_targetName",targetName).attr("_targetHead",targetHead).attr("_targetType",targetType);
		
		var conversationType=M_CORE.ConversationType.DISCUSSION;
		if(targetType==1){
			converTempdiv.hide();
			ChatUtil.getDiscussionInfo(targetid,0,function(discuss){
			
				targetHead="/social/images/head_group.png";
				targetName=discuss.getName();
				
				converTempdiv.find(".targetHead").attr("src",targetHead);
				converTempdiv.find(".targetName").html(targetName);
				converTempdiv.show();
				
				converTempdiv.attr("id","conversation_"+targetid).attr("_targetid",targetid).attr("_targetName",targetName).attr("_targetHead",targetHead).attr("_targetType",targetType);
				
				console && console.log("conversationTitle:"+targetName);
			});
		}
		
		//getConversationList();
	}
	
	if(targetType==1){
		content=sendinfo.userName+":"+content;
	}
	converTempdiv.find(".msgcontent").html(content);
	sendtime=getFormateTime(sendtime);
	converTempdiv.find(".latestTime").html(sendtime);
	
	$("#recentListdiv").prepend(converTempdiv);
	$("#recentListdiv").scrollTop(0);
}

//获取最近联系人
var loadConverFinish=false; //记录会话加载状态
var converCount=0; //记录有效会话总数
var sortCountList=new Array();
function getConversationList(){
	client.getConversationList(function(conversationList){
		
		console && console.log('已同步',conversationList);
		for (var i = 0; i <conversationList.length; i++) {
			
			var conversation=conversationList[i];
			
			var targetid=conversation.getTargetId();
			var conversationTitle=conversation.getConversationTitle(); //会话标题
			var conversationType=conversation.getConversationType(); //会话类型
			var unreadMsgCount=conversation.getUnreadMessageCount(); //未读消息数量
			var latestTime=conversation.getSentTime();
			unreadMsgCount=0;
			
			console && console.log("===============会话记录==============");
			//var targetType=conversationType;
			
			console && console.log("conversationType:"+conversationType);
			console && console.log("conversationTitle:"+conversationTitle);
			console && console.log("unreadMsgCount:"+unreadMsgCount);
			
			var targetType=client.getTargetType(conversationType,targetid); //0：单聊 1:群聊 -1：其他	
			
			var realTargetid=getRealUserId(targetid); //获取实际id,人员为id
			
			if(realTargetid==1){
			   console && console.log("会话记录过滤系统管理员");
			   continue ;
			}
			
			var senderName="";
			var senderHead="";
			var targetName=""; //聊天对象名称
			var targetHead=""; //聊天对象图标
			
			console && console.log("targetType:"+targetType);
		    console && console.log("targetid:"+targetid);
		    console && console.log("realTargetid:"+realTargetid);
			
			if(targetType==0&&realTargetid!="undefined"){
				try{
					conversationTitle=getUserInfo(realTargetid).userName;
				}catch(e){
					conversationTitle="";
					console && console.log("realTargetid error realTargetid:"+realTargetid);
				}
			}
			
			var message=conversation.getLatestMessage();
			console && console.log("message:"+message);
			if(targetType>-1&&message&&conversationTitle!=""){  //获取发送人信息
			
				$("#recentListdiv .dataloading").hide(); //隐藏loading
				if($("#conversation_"+realTargetid).length==1) continue ;
			
				var content=getMsgContent(message);
				var senderUserid=message.getSenderUserId(); //发送人id
				var senderid=getRealUserId(senderUserid); //发送人id
				var objName = message.getObjectName(); //消息标识
				
				try{
					latestTime=message.getSentTime();
				}catch(e){
					latestTime=new Date().getTime();
				}
				
				var sendtime=getFormateTime(latestTime);

				var senderInfo=getUserInfo(senderid);
				senderName=senderInfo.userName;
				senderHead=senderInfo.userHead;
				
				targetName=conversationTitle;
				
				console && console.log("senderName:"+senderName);
				console && console.log("senderHead:"+senderHead);
				
				if(targetType==1){ //获取群信息
					targetHead="/social/images/head_group.png";
					content=senderName+":"+content;
				}else{
					targetHead=getUserInfo(realTargetid).userHead;
				}
				
				var converTempdiv=$(".converTemp").clone().removeClass("converTemp");
				converTempdiv.find(".targetHead").attr("src",targetHead);
				converTempdiv.find(".targetName").html(targetName);
				converTempdiv.find(".msgcontent").html(content);
				converTempdiv.find(".latestTime").html(sendtime);
				
				if(unreadMsgCount>0){
					if(unreadMsgCount>99) unreadMsgCount="99+";
					converTempdiv.find(".msgcount").html(unreadMsgCount).css({"display":"block"});
				}	
				converTempdiv.attr("id","conversation_"+realTargetid).attr("_targetid",realTargetid).attr("_targetName",targetName).attr("_targetHead",targetHead).attr("_targetType",targetType);
				
				converCount++; 
				client.error("targetName:"+targetName);
				if(objName=="FW:CountMsg"){
					converTempdiv.hide();
					ChatUtil.getLatestMessage(realTargetid,targetType,targetName);
				}else{
				
					sortCountList.push({"targetid":realTargetid,"sendtime":latestTime});
					
					console && console.log("loadConverFinish:"+loadConverFinish+" sortCountList:"+sortCountList.length+" converCount:"+converCount);
					if(loadConverFinish&&sortCountList.length==converCount){
						sortConversation(sortCountList);
					}
					converTempdiv.show();
				}
				$("#recentListdiv").append(converTempdiv);
				
				loadConverFinish=true;
			}
		}
		$("#recentListdiv").find('.dataloading').hide();
		//$("#recentListdiv .chatItem").fadeIn();
	});
	//屏蔽上下文菜单
	document.oncontextmenu = function(){return false;};
}

//会话列表排序
function sortConversation(converList){
    var len = converList.length,
    j, d;
    for (var i = 0; i < len; i++) {
        for (j = 0; j < len; j++) {
            if (converList[i].sendtime < converList[j].sendtime) {
                d = converList[j];
                converList[j] = converList[i];
                converList[i] = d;
            }
        }
    }
    for (var i = len-1; i >=0; i--) {
    	$("#recentListdiv").append($("#conversation_"+converList[i].targetid));
    }
    return converList;
}


function updateLatestMessage(targetid,message){

	var converTempdiv=$("#conversation_"+targetid);
	
	var content=getMsgContent(message);
	var senderUserid=message.getSenderUserId(); //发送人id
	var senderid=getRealUserId(senderUserid); //发送人id
	var senderInfo=getUserInfo(senderid);
	var senderName=senderInfo.userName;
	var senderHead=senderInfo.userHead;
	var sendtime=getFormateTime(message.getSentTime());
	
	content=senderName+":"+content;
	
	converTempdiv.find(".msgcontent").html(content);
	converTempdiv.find(".latestTime").html(sendtime);
	
	converTempdiv.show();
}

function getFormateTime(latestTime){

	var date = new Date();
	date.setTime(latestTime);
	
	var today=new Date();
	var tomorrow=new Date();
	tomorrow.setDate(tomorrow.getDate()-1);
	
	var tomorrowdate=tomorrow.pattern("yyyy-MM-dd");
	var todaydate=new Date().pattern("yyyy-MM-dd");
	var senddate=date.pattern("yyyy-MM-dd");
	
	if(senddate==todaydate){
		sendtime=date.pattern("HH:mm");
	}else if(senddate==tomorrowdate){
		sendtime="昨天";
	}else{
		sendtime=date.pattern("MM-dd");;
	}
	
	return sendtime;
}

function initScrollBar(targetType,realTargetid,pagesize){

	var chatWinid="chatWin_"+targetType+"_"+realTargetid;
	var chatListdiv=$("#"+chatWinid+" .chatList");
    $(chatListdiv).bind('mousewheel', function(event,delta, deltax, deltay){
    	var scrollTop = $(this).perfectScrollbar("getScrollTop");
    	//console && console.log(scrollTop);
    	var delta = IMUtil.getDeltaValue(event);
    	//console && console.log("deltavalue: " + delta);
    	var dir = delta > 0 ? 'Up' : 'Down',
            vel = Math.abs(delta);
        
        var isHasNext=chatListdiv.attr("_isHasNext"); //是否有下一页
        var isFinish=chatListdiv.attr("_isFinish"); //一次数据是否加载完成
        
        //console && console.log("isFinish:"+isFinish+" dir:"+dir+" scrollTop:"+scrollTop+" isHasNext:"+isHasNext+" delta:"+delta);
        if(dir == 'Up' && scrollTop<=20 && isFinish=="1" && isHasNext=="1"){
        	 console && console.log("isFinish:"+isFinish);
        	 console && console.log("isHasNext:"+isHasNext);
        	 
        	 chatListdiv.attr("_isFinish","0"); //设置为加载完成状态
        	 
        	//现在加载图标--showLoading(1)
        	var mystyle = {Left: 50, Top: 10, Width: 550, Height: 20};
        	
        	IMUtil.showLoading($(this), mystyle, 1000, 
        		function(){ChatUtil.getHistoryMessages(targetType,realTargetid,pagesize,false);});
	    	console && console.log("==滚动条上滚触发历史记录加载==");
        }
        return false;
    });
 
 } 
 
 //显示聊天表情 
 function drawExpressionWrap(targetid) {
        var RongIMexpressionObj = $("#chatdiv_"+targetid+" .RongIMexpressionWrap");
        if (true) {
            var arrImgList = RongIMClient.Expression.getAllExpression(128, 0);
            if (arrImgList && arrImgList.length > 0) {
                for (var objArr in arrImgList) {    //扩展 Array prototype 使用for in问题
                    var imgObj = arrImgList[objArr].img;
                    if (!imgObj) {
                        continue;
                    };
                    imgObj.setAttribute("alt", arrImgList[objArr].chineseName);
                    imgObj.setAttribute("title", arrImgList[objArr].chineseName);
//                    imgObj.alt = arrImgList[objArr].chineseName;
                    var newSpan = $('<span class="RongIMexpression_' + arrImgList[objArr].englishName + '"></span>');
                    newSpan.append(imgObj);
                    RongIMexpressionObj.append(newSpan);
                }
            }
            $("#chatdiv_"+targetid+" .RongIMexpressionWrap>span").bind('click', function (event) {
                //$(".textarea")[0].value+="[" + $(this).children().first().attr("alt") + "]";
				//$(".textarea").append($(this).clone());
				$("#chatcontent_"+targetid).append($(this).html());
				//$("#chatcontent_"+targetid).append("[" + $(this).children().first().attr("alt") + "]");
				$(".popBox").hide();
				stopEvent();
            });
        }
        ;
};



function getFormteMsgContent(message){

	var content=message.getContent();
	var messageType=message.getMessageType();
	var objName = message.getObjectName();
	
	if(messageType==1){
		content=ChatUtil.receiveMsgFormate(content); //接收消息格式化处理
	}else if(messageType==2){
		var imageUrl=message.getImageUri();
		var imageFrom=imageUrl.indexOf("rongcloud-image.ronghub.com")!=-1?"mobile":"";
		content='<img _imageUrl='+imageUrl+' src="data:image/jpg;base64,'+content+'"/>';
	}else if(messageType==3){
		content="[音频]";
		content=message.getContent();
	}else if(messageType==4){
		content="[图文]";
	}else if(messageType==6){
		var objName = message.getObjectName();
		if(objName =="RC:PublicNoticeMsg"||objName=="FW:attachmentMsg"){ //公告
			content=ChatUtil.receiveMsgFormate(content); //接收消息格式化处理
		}else{
			//content="objName："+objName;
		}	
	}else if(messageType==8){
		var latitude=message.getLatitude();
		var longitude=message.getLongitude();
		var poi=message.getPoi();
		content='<div class="locationdiv" onclick="showIMLocation(\''+latitude+'\',\''+longitude+'\',\''+poi+'\')">'+
				'	<img class="locationimg" src="data:image/jpg;base64,'+content+'"/>'+
				'	<div class="locationpoi">'+poi+'</div>'+
				'</div>';
		console && console.log("latitude:"+latitude+" longitude:"+longitude+" poi:"+poi);
	}else{
		if(objName=="RC:DizNtf"){
			content="退出了群";
		}else{
			content="消息类型："+messageType;
		}
	}
	return content;
}

function showIMLocation(latitude,longitude,description){
	description=encodeURIComponent(description);
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	var url = "/social/im/SocialShowLocation.jsp?latitude="+latitude+"&longitude="+longitude+"&description="+description;
	dialog.Title = "位置";
	dialog.Width = 600;
	dialog.Height = 450;
	dialog.normalDialog= false;
	dialog.Drag = true;
	dialog.URL = url;
	dialog.show();
}

function initEmotion(str) {
    var a = document.createElement("span");
    return RongIMClient.Expression.retrievalEmoji(str, function (img) {
        a.appendChild(img.img);
        var str = '<span class="RongIMexpression_' + img.englishName + '">' + a.innerHTML + '</span>';
        a.innerHTML = "";
        return str;
    });
}

function getEmotionText(str){
	return RongIMClient.Expression.retrievalEmoji(str, function (img) {
        return "[表情]";
    });
}

function onRMenuClick(obj, index){
	var _menudiv = $($(obj).parents('.rightMenudiv')[0]);
	var _targetid = _menudiv.data("targetId");
	var _targetname = _menudiv.data("targetName");
	var _targettype = _menudiv.data("targetType");
	var _istop = false;
	switch(index){
	case "1":		//会话置顶
		ChatUtil.setThisConversationToTop(_targettype, _targetid, _istop);
	break;
	case "2":		//删除会话
		ChatUtil.removeThisConversation(_targettype, _targetid);
	break;
	}
	$('.rightMenudiv').hide();
}

function removeConversation(_targettype, _targetid) {
	ChatUtil.removeThisConversation(_targettype, _targetid);
}

//chatitem 的鼠标点击事件处理
function goMounseHandler(obj, e) {
	e = e || window.event;
	switch(e.which) {
		case 3:		//右键菜单
			var options = {
				menuList: [
							//{ menuName: "置顶该会话", clickfunc: "onRMenuClick(this, '1')"},
						   	{ menuName: "从最近列表中移出", clickfunc: "onRMenuClick(this, '2')"}
						  ],
				left: e.clientX,
				top: e.clientY
			};
			//从obj绑定的参数中获知是否是置顶会话
			//demo
			if($(obj).attr('_istop')) options.menuList[0].menuName = "取消置顶";
			showRightMenu(obj, options);
		break;
		case 1:		//单击	
			//showConverChatpanel(obj);
			//stopEvent();
		break;
	}
}
  function launchOn(){
  	return $("#launchIco").hasClass('launchOn');
  }
  
  function updateSelectedCnt(){
  	var headsDispane = $("#displaypane").find(".userHeadsDis");
  	var selectedCnt = headsDispane.find(".headCellItem").length;
	$("#imMainbox .imTopTitle").html("已选择("+selectedCnt+")");
  }
  
  //移出单人
  function removeCurCell(obj) {
  	$(obj).parent().remove();
  	updateSelectedCnt();
  }
  //处理item点击
  function doItemClick(obj){
  	if(launchOn()){
  		addPersonToPane(obj);
  	}else{
  		clearUpheadCells();
  		showPersonInfo(obj);
  	}
  }
  //是否管理员
  function checkIfMgr(){
  	return true;
  }
  //管理员添加成员
  function doAddNewMember(){
  	if(!checkIfMgr()){
  		doInvitationResource();
  		return;
  	}
	if(dialog==null){
		dialog = new window.top.Dialog();
	}
	dialog.currentWindow = window;
	dialog.Title = "新增人员";
    dialog.URL = "/rdeploy/hrm/RdResourceAdd.jsp";
	dialog.Width = 400;
	dialog.Height = 260;
	dialog.Drag = true;
	dialog.textAlign = "center";
	dialog.normalDialog = false;
	dialog.show();
  }
  //邀请成员
  function doInvitationResource(){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	var url = "";
	dialog.Width = 600;
	dialog.Height = 390;
	dialog.Title = "邀请成员加入";
	url = "/rdeploy/hrm/RdInvitationResource.jsp";
	dialog.Drag = true;
	dialog.URL = url;
	dialog.show();
}

//显示人员名片
function showPersonInfo(obj){
  var targetid=$(obj).attr("_targetid");
  var dispane = $("#displaypane");
  dispane.find(".dis").hide();
  $("#imMainbox .imTopTitle").html("详细信息");
  $("#imMainbox .clearConfirmBtn").hide();
  $("#imMainbox .addComfirmBtn").hide();
  /*
  $.post("/social/im/SocialIMOperation.jsp?operation=getPersonDetails&resourceid="+targetid, function(data){
  	var detail = $.trim(data);
  	console && console.log("detail:%c"+detail, "color:green");
  	
  	
  	dispane.find(".personInfoDis").show();
  });
  */
  var targetName=$(obj).attr("_targetName");
  var targetHead=$(obj).attr("_targetHead");
  var targetType=$(obj).attr("_targetType");
  var targetOrg = $(obj).find(".deptName").html();
  var targetJob = $(obj).find(".subName").html();
  var targetMobile = $(obj).find(".mobile").html();
  
  dispane.find("._targetHead").attr('src',targetHead);
  dispane.find("._targetName").html(targetName);
  dispane.find("._targetOrg").html(targetOrg);
  dispane.find("._targetJob").html(targetJob);
  dispane.find("._targetMobile").html(targetMobile);
  dispane.find(".personInfoDis").show();//应该放到回调中
}
//清空选择的头像
function clearUpheadCells(){
	var headsDispane = $("#displaypane").find(".userHeadsDis");
	headsDispane.empty();
	$("#imMainbox .imTopTitle").html("已选择(0)");
	$("#imMainbox .addComfirmBtn").hide();
}
//添加头像到显示面板
 function addPersonToPane(obj) {
 	var targetid=$(obj).attr("_targetid");
	var targetName=$(obj).attr("_targetName");
	var targetHead=$(obj).attr("_targetHead");
	var dispane = $("#displaypane");
	dispane.find(".dis").hide();
	var headsDispane = dispane.find(".userHeadsDis");
	headsDispane.find("div[_targetid='"+ targetid +"']").remove();
	var temp = $("#headCellTemp").clone();
	temp.find(".mhead").attr("src", targetHead);
	temp.find(".mname").html(targetName);
	temp.attr({"_targetid": targetid, "id":""}).show();
	temp.appendTo(headsDispane);
	updateSelectedCnt();
	$("#imMainbox .clearConfirmBtn").show();
	$("#imMainbox .addComfirmBtn").show();
	dispane.find(".userHeadsDis").show();
 }
//显示会话聊天窗口
function showConverChatpanel(obj){
  var targetid=$(obj).attr("_targetid");
  var targetName=$(obj).attr("_targetName");
  var targetHead=$(obj).attr("_targetHead");
  var targetType=$(obj).attr("_targetType");
  
  $(obj).find(".msgcount").html(0).hide();
  clearMessagesUnreadStatus(targetType,targetid);//清除未读消息
  
  $("#imMainbox .chatItem").removeClass("activeChatItem");
  $(obj).addClass("activeChatItem");
  //更新群设置信息
  ChatUtil.setCurDiscussInfo(targetid, targetType);
  showIMChatpanel(targetType, targetid,targetName,targetHead);
  
}


function clearMessagesUnreadStatus(targetType,targetId){
	console && console.log("targetType:"+targetType+" targetId:"+targetId);
	client.clearMessagesUnreadStatus(targetType,targetId);	
}


//获得消息内容
function getMsgContent(message,isNotify){
	var content="";
	try{
		content=message.getContent();
		var objName = message.getObjectName();
		var messageType=message.getMessageType();
		var extra=message.getExtra();
		
		//alert("objName:"+objName+" content:"+content+" extra:"+extra);
		
		if (message instanceof M_CORE.DiscussionNotificationMessage) {
			var senderUserid=message.getSenderUserId(); //发送人id
			var senderid=getRealUserId(senderUserid); //发送人id
			var senderInfo=getUserInfo(senderid);
            content=ChatUtil.getNotifiContent(senderInfo,message);
		}else{
			if(messageType==1){
				if(isNotify)
					content=getEmotionText(content);
				else
					content=initEmotion(content);
			}else if(messageType==2){
				content="[图片]";
			}else if(messageType==3){
				content="[音频]";
			}else if(messageType==4){
				content="[图文]";
			}else if(messageType==6){
				
				if("RC:PublicNoticeMsg" == objName){ //公告
					content="[公告]"+content;
				}else if(objName=="FW:attachmentMsg"){ //附件
					var extraObj;
					try{
						if(!extra) extra="";
						extraObj=eval("("+extra+")");
						content="[附件]"+content;
					}catch(e){
						if(content!=""){
							var contents=content.split("|");
							content="[附件]"+contents[0];
						}
					}
				}else if(objName=="FW:CustomShareMsg"){ //分享
					var sharetitle = content;
					var extraObj;
					try{
						if(!extra) extra="";
						extraObj=eval("("+extra+")");
						content="[分享]"+extraObj.sharetitle;
					}catch(e){
						extra=content;
						extraObj=eval("("+extra+")");
						content="[分享]"+extraObj.sharetitle;
					}
				}else if(objName=="FW:PersonCardMsg"){ //名片
					if(!extra&&content!=""){
						extra="{\"hrmCardid\":\""+content+"\"}";
					}
					var extraObj=eval("("+extra+")");
					var hrmid=extraObj.hrmCardid;
					
					content="[名片]"+userInfos[hrmid].userName;
				}
			}else if(messageType==8){
				content="[位置]";
			}else{
				content="消息类型："+messageType;
			}
		}
	}catch(e){
		console && console.log("getMsgContent获取不到消息内容");
	}
	return content;
}

function addSendtime(chatList,recorddiv,sendtime,recordType){
	
	recorddiv.attr("_sendtime",sendtime);
	var date = new Date();
	date.setTime(sendtime);
	var senddate=date.pattern("MM-dd HH:mm:ss");
	
	if(recordType=="send"||recordType=="receive"){
		var latestSendtime=chatList.find(".chatItemdiv:last").attr("_sendtime");
		if((sendtime-latestSendtime)/(1000*60)>2){
			chatList.append("<div class='chatTime'>"+senddate+"</div>");
		}
	}else{
		var latestSendtime=chatList.attr("_latestSendtime");
		latestSendtime=latestSendtime==undefined?(new Date().getTime()):latestSendtime;
		if((latestSendtime-sendtime)/(1000*60)>2){
			chatList.prepend("<div class='chatTime'>"+senddate+"</div>");
			chatList.attr("_latestSendtime",sendtime);
		}
	}
}
      
/**      
 * 对Date的扩展，将 Date 转化为指定格式的String      
 * 月(M)、日(d)、12小时(h)、24小时(H)、分(m)、秒(s)、周(E)、季度(q) 可以用 1-2 个占位符      
 * 年(y)可以用 1-4 个占位符，毫秒(S)只能用 1 个占位符(是 1-3 位的数字)      
 * eg:      
 * (new Date()).pattern("yyyy-MM-dd hh:mm:ss.S") ==> 2006-07-02 08:09:04.423      
 * (new Date()).pattern("yyyy-MM-dd E HH:mm:ss") ==> 2009-03-10 二 20:09:04      
 * (new Date()).pattern("yyyy-MM-dd EE hh:mm:ss") ==> 2009-03-10 周二 08:09:04      
 * (new Date()).pattern("yyyy-MM-dd EEE hh:mm:ss") ==> 2009-03-10 星期二 08:09:04      
 * (new Date()).pattern("yyyy-M-d h:m:s.S") ==> 2006-7-2 8:9:4.18      
 */        
Date.prototype.pattern=function(fmt) {         
    var o = {         
    "M+" : this.getMonth()+1, //月份         
    "d+" : this.getDate(), //日         
    "h+" : this.getHours()%12 == 0 ? 12 : this.getHours()%12, //小时         
    "H+" : this.getHours(), //小时         
    "m+" : this.getMinutes(), //分         
    "s+" : this.getSeconds(), //秒         
    "q+" : Math.floor((this.getMonth()+3)/3), //季度         
    "S" : this.getMilliseconds() //毫秒         
    };         
    var week = {         
    "0" : "/u65e5",         
    "1" : "/u4e00",         
    "2" : "/u4e8c",         
    "3" : "/u4e09",         
    "4" : "/u56db",         
    "5" : "/u4e94",         
    "6" : "/u516d"        
    };         
    if(/(y+)/.test(fmt)){         
        fmt=fmt.replace(RegExp.$1, (this.getFullYear()+"").substr(4 - RegExp.$1.length));         
    }         
    if(/(E+)/.test(fmt)){         
        fmt=fmt.replace(RegExp.$1, ((RegExp.$1.length>1) ? (RegExp.$1.length>2 ? "/u661f/u671f" : "/u5468") : "")+week[this.getDay()+""]);         
    }         
    for(var k in o){         
        if(new RegExp("("+ k +")").test(fmt)){         
            fmt = fmt.replace(RegExp.$1, (RegExp.$1.length==1) ? (o[k]) : (("00"+ o[k]).substr((""+ o[k]).length)));         
        }         
    }         
    return fmt;         
}       

//加载最近
function loadRecent(){
	$('#recentListdiv .dataloading').hide();
	loadIMDataList('recent');
}

//获取人员基本信息
function getUserInfo(resourceid){
	if(!resourceid) resourceid=M_USERID;
	var userInfo=userInfos[resourceid];
	if(!userInfo){
		var data=getAjaxData("/social/im/SocialIMOperation.jsp?operation=getUserInfo&resourceid="+resourceid);
		userList=eval("("+data+")");
		if(userList.length>0){
			userInfo=userList[0];
			userInfos[resourceid]=userInfo;
		}
	}
	return userInfo;
}

//加载所有人员基本信息到页面缓存
function loadUserInfo(){
	$.post("/social/im/SocialIMOperation.jsp?operation=getUserInfo",function(data){
		var userList=eval("("+data+")");
		for(var i=0;i<userList.length;i++){
			var userInfo=userList[i];
			var resourceid=userInfo.userid;
			userInfos[resourceid]=userInfo;
		}
	})	
}

//加载所有人员基本信息到页面缓存
function loadSettingInfo(){
	$.post("/social/im/SocialIMOperation.jsp?operation=getSettingInfo",function(data){
		var settingList=eval("("+data+")");
		for(var i=0;i<settingList.length;i++){
			var settingInfo=settingList[i];
			var targetid=settingInfo.targetid;
			settingInfos[targetid]=settingInfo;
		}
	})	
}

function getCurrentTab(){
	var currentTab=$("#chatIMTabs .chatIMTabActiveItem");
	return currentTab;
}

function getAjaxData(url){
	var result="";
	jQuery.ajax({
       type: "POST",
       url: url,
	   async: false,
	   success: function(data){
	   	 data=jQuery.trim(data);
	   	 result=data;
	   }
	});
	return result; 
}	

function getEmojiObj(x) {
      return RongIMClient.Expression.getEmojiObjByEnglishNameOrChineseName(x.slice(1, x.length - 1)).tag || x;
}

//发送附件
function initUploadAcc(chatcontentid,fileId,file){
	var filedata=eval('('+filedata+')');
	var fileSize=file.size;
	var fileName=file.name;
	var fileType=getFileType(fileName);
	
	var params={"docid":fileId, "operation":"getaccbychat"};
	
	var data={"fileId":fileId,"fileName":fileName,"fileSize":fileSize,"fileType":fileType,"objectName":"FW:attachmentMsg"}
	
	var chatSend=$("#"+chatcontentid).parents(".chatdiv").find(".chatSend");
	ChatUtil.sendIMMsg(chatSend,6,data);
	
	addIMFileRight(chatSend,data);
	
}

//发送图片初始化
function initUploadImg(chatcontentid,imagedate,file){

	var data=eval('('+imagedate+')');
	var fileSize=file.size;
	var fileName=file.name;
	var fileType=getFileType(fileName);
	
	//发送图片消息
	var chatSend=$("#"+chatcontentid).parents(".chatdiv").find(".chatSend");
	ChatUtil.sendIMMsg(chatSend,2,data);
	
	data["fileId"]=data.imgUrl;
	data["fileName"]=fileName;
	data["fileSize"]=fileSize;
	data["fileType"]=fileType;
	
	addIMFileRight(chatSend,data);
}

function addIMFileRight(chatSend,data){

	var targetid=chatSend.attr("_acceptid");
	var targetType=chatSend.attr("_chattype");
	data["targetid"]=targetid;
	data["targetType"]=targetType;
	
	data["memberids"]=ChatUtil.getMemberids(targetType, targetid);
	jQuery.post("/social/im/SocialIMOperation.jsp?operation=addIMFile",data,function(content){	
			
	});
}

function getFileType(filename){
		var suffix=filename.substring(filename.lastIndexOf(".")+1).toLowerCase();
		if((suffix=="jpg")||(suffix=="bmp")||(suffix=="gif")||(suffix=="png")){
			return "img";
		}else if((suffix=="doc")||(suffix=="docx")){
			return "doc";
		}else if((suffix=="ppt")||(suffix=="pptx")){
			return "ppt";
		}else if((suffix=="xls")||(suffix=="xlsx")){
			return "xls";
		}else if((suffix=="html")||(suffix=="htm")||(suffix=="java")||(suffix=="js")||(suffix=="jsp")){
			return "html";
		}else if((suffix=="pdf")){
			return "pdf";
		}else if((suffix=="rar")||(suffix=="zip")){
			return "rar";
		}else if((suffix=="txt")){
			return "txt";
		}else if((suffix=="exe")){
			return "exe";
		}
		return "default";
}

function getFileIcon(filename){
	
	var fileType=getFileType(filename);
	
	return "/social/images/acc_"+fileType+"_wev8.png";
}

function getSizeFormate(size){
	
	if(size<=1023)
	   return size+"B";
	else if(size/1024<1023)
	   return (size/1024).toFixed(2)+"K";
	else
	   return (size/(1024*1024)).toFixed(2)+"M"; 
	   
}

//下载附件消息中附件
function downAccFile(obj){
	var fileId=$(obj).attr("_fileId");
	downloads(fileId);
}

//下载附件
function downloads(fileid){
	$("#downloadFrame").attr("src","/weaver/weaver.file.FileDownload?fileid="+fileid+"&download=1");
}

  //关闭通讯录
  function closeIMBox(){
  	$("#IMbg").hide();
  	$("#imMainbox").hide();
  }
  
  function showIMBox(){
  	$("#IMbg").show();
  	$("#imMainbox").show();
  	$("#imAddress").css({"background-image":"url(/social/images/im_address_wev8.png)"});
  }
  
  //切换联系人tab
  function changeContactTab(obj){
  	  $("#imConTabs .conActItem").removeClass("conActItem");
  	  $(obj).addClass("conActItem");
  	  var target=$(obj).attr("_target");
  	  loadIMDataList(target);
  }
  
  //显示聊天面板
  function showIMChatpanel(chatType, acceptId,chatName,headicon) {
  	//隐藏搜索结果页
  	showResultDiv(0);
  	$(".imSearchdiv").find(".imInputdiv").val(preKeyword==undefined?M_HINT:preKeyword);
  	
  	$("#imLeftdiv").show();
  	$("#imCenterdiv").show();
  
  	var chatWinid="chatWin_"+chatType+"_"+acceptId;
  	var chatTabid="chatTab_"+chatType+"_"+acceptId;
  	
  	$("#chatIMdivBox .chatWin").hide();
  	$("#chatIMTabs .chatIMTabActiveItem").removeClass("chatIMTabActiveItem");
  	if($("#"+chatTabid).length==0){
  		
  		$("#chatIMTabs").prepend("<div id='"+chatTabid+"' class='chatIMTabItem chatIMTabActiveItem' onclick='changeTabWin(this)' _chatWinid='"+chatWinid+"'>"+
  								"	<div class='headicon'><img src='"+headicon+"' class='head28' align='absmiddle'></div>"+
  								"	<div class='targetName ellipsis' title='"+chatName+"'>"+chatName+"</div>"+
  								"	<div class='clear'></div>"+
  								"	<div class='tabClostBtn' onclick='closeTabWin(this)' _chatWinid='"+chatWinid+"'>x</div>"+
  								"</div>");
  								
  		if($("#"+chatWinid).length==0){						
  			$("#chatIMdivBox").prepend("<div id='"+chatWinid+"' class='chatWin'></div>");						
  			$("#"+chatWinid).load("/social/im/SocialIMChat.jsp?chatType="+chatType+"&acceptId="+acceptId,{"targetName":chatName}).show();
  		}
  		
  		$("#imLeftdiv").scrollTop(0);
  		
  	}else{
  		$("#"+chatTabid).addClass("chatIMTabActiveItem");
  	}
  	
  	$("#"+chatWinid).show();
  	$("#"+chatWinid+" .chatcontent").focus();
  	
  	scrollTOBottom($("#"+chatWinid+" .chatList"));
  	
  	//$("#chatIMdivBox").show();
	//clearChatMsg(acceptId,userid,chatType);
  }

  //切换聊天窗口
  function changeTabWin(obj){
    var chatWinid=$(obj).attr("_chatWinid");
  	$("#chatIMTabs .chatIMTabActiveItem").removeClass("chatIMTabActiveItem");
  	$(obj).addClass("chatIMTabActiveItem");
  	$("#chatIMdivBox .chatWin").hide();
  	var chatWin=$("#"+chatWinid).show();
  	
  	var chatActiveTab=$("#"+chatWinid+" .chatActiveTab");
  	chatActiveTab.click();
  	/*
  	var scrollbarid=chatList.attr("_scrollbarid");
  	$(".chatListScrollbar").css({"z-index":"1000"});
  	$("#"+scrollbarid).css({"z-index":"1001"});
  	*/
  	chatWin.find(".chatcontent").focus();
  	var chattype = chatWinid.substring(8, 9);
  	var targetid = chatWinid.substring(10, chatWinid.length);
  	
  	ChatUtil.setCurDiscussInfo(targetid, chattype);
  }

  //关闭聊天窗口
  function closeTabWin(obj){
	  var chatWinid=$(obj).attr("_chatWinid");	
	  var chatWin=$("#"+chatWinid);
	  var chatTab=$(obj).parents(".chatIMTabItem");
	  var nextChatTab=chatTab.next();
	  var nextChatWin=$("#"+nextChatTab.attr("_chatWinid"));
	  
	  if(nextChatTab.length==0){
	  	nextChatTab=chatTab.prev();
	  	nextChatWin=$("#"+nextChatTab.attr("_chatWinid"));
	  }
	  if(chatTab.hasClass("chatIMTabActiveItem")){
	  	$("#chatIMdivBox .chatWin").hide();
	  	nextChatTab.addClass("chatIMTabActiveItem");
	  	nextChatWin.show();
	  }	
	  try{
		  chatWin.remove();
	  }catch(e){
	  	  var chatWindiv=document.getElementById(chatWinid);
		  chatWindiv.parentNode.removeChild(chatWindiv);
	  }
	  chatTab.remove();
	  if($("#chatIMTabs .chatIMTabItem").length==0){
	  	 $("#imDefaultdiv").show();
  		 $("#imLeftdiv").hide();
  		 $("#imCenterdiv").hide();
	  }
	  var targetType=chatWinid.split("_")[1];
	  var targetid=chatWinid.split("_")[2];
	  
	  client.resetGetHistoryMessages(targetType,targetid);
	  stopEvent();
  }
  
  function openBlog(resourceid,orgType,obj){
  	if(orgType==1){
  		var userInfo=getUserInfo(resourceid);
  		showIMChatpanel(0,resourceid,userInfo.userName,userInfo.userHead);
  	}
  }
  
  //初始化顶部
  function initIMNavTop(){
  
  	$(".imToptab .tabitem").bind("click",function(){
  		
  			$(".imToptab .activeitem").removeClass("activeitem");
  			var target=$(this).attr("_target");
  			
  			$(this).addClass("activeitem");
  			
  			$(".leftMenus .leftMenudiv").hide();
  			$("#"+target+"Listdiv").show();
  			loadIMDataList(target);
  			/*
  			if(target!="contact"){
  				$("#imConTabs").show();
  				loadIMDataList("dept");
  			}else{
  				$("#imConTabs").hide();
  				loadIMDataList(target);
  			}*/
  			
  			
  			
  	});
  	$(".imToptab .tabitem:first").click();
  }	
 
  var M_HINT = "  姓名/首字母/移动电话";  //感觉这里要做标签的规范
  var M_SMS = "无搜索结果";	  //默认显示的提示
  //获取搜索关键字
  function getKeyword() {
  	var keyword = $.trim($("#searchResultListDiv>.imSearchInputdiv").val());
  	try {
  		if(keyword == undefined || keyword == '' || keyword == M_HINT)
  			throw "未输入搜索关键字";	//同样要坐标签的规范
  			
  		return keyword;
  	}catch(err){
  		return undefined;
  	}
  }
  
  //校验关键字合法性
  function checkValid(keyword) {
  	var keyword = $.trim(keyword);
  	//TODO 这里校验关键字是否非法字符
  	if(keyword == undefined || keyword == ''){
  		return false;
  	}
  	if(keyword != preKeyword){
  		console && console.log("校验关键字[" + keyword + "]合法");
  	}
  	return true;
  }
  
  var preKeyword = undefined;		//上一个搜索的关键字
  
  //搜索联系人
  function doSearch(keyword) {
  	if(keyword == ''){		//搜索的关键字为空则执行清空动作
  	//	showResultDiv(0);
  		clearHistorySearch();
  		return;
  	}
  	var keyword = $.trim(keyword);
  	if(keyword == ''){
  		//清空？
  	}
  	if(checkValid(keyword)){
  		if(keyword != preKeyword){
  			preKeyword = keyword;
	 		console && console.log("搜索: " + keyword);
	 		loadIMDataList("tempSearch");
  		}
 	}
  }
  
  //清空历史搜索
  function clearHistorySearch() {
  	$("#searchResultListDiv>.imSearchList").empty();
  	preKeyword = undefined;
  }
  
  function changeLaunchState(obj) {
  	var launchIco = $(obj).find('.launchIco');
  	if(!launchIco.hasClass('launchOn')){
  		launchIco.addClass('launchOn');
  	}else{
  		launchIco.removeClass('launchOn');
  	}
  }
  
  //显示并搜索最近联系人
  function showResultDiv(bDisplay) {
  	if(bDisplay){
  		$("#searchResultListDiv").show();
  		/*
  		$("#searchResultListDiv").html("<input type=\"text\" value=\"  姓名/首字母/移动电话\" onkeyup=\"doSearch($(this).val())\"" + 
  			"onclick=\"javascript:$(this).select();\" class=\"imSearchInputdiv\">" + 
  			"<div class=\"imSearchClose\"></div>" +
  			"<div class=\"imSearchList\"></div>");
  		*/	
  		var target = "tempSearch";
  		$("#searchResultListDiv>.imSearchInputdiv").focus().val(preKeyword==undefined?'':preKeyword).select();
  		$("#searchResultListDiv>.imSearchClose").bind("click", function(){
  			showResultDiv(0);
  			//这里还要清空历史搜索
  			clearHistorySearch();
  		});
  		//这里暂时不用加载联系人
  		//添加事件监听器
  		$(document).bind('click.tempsearch', function(e){
  			var target = $(e.target || e.srcElement);
  			if(getKeyword() != undefined){
  			//	$("#searchResultListDiv>.imSearchInputdiv").select();
  			//	对搜索结果做隐藏
  				showResultDiv(0);
  				$(".imSearchdiv").find(".imInputdiv").val(preKeyword==undefined?'':preKeyword);
  			}else if(target.attr('class') != 'imInputdiv') showResultDiv(0);
  		});
  		$("#searchResultListDiv").bind('click', function(e){
  			e.stopPropagation();
  		});
  	}else{
  		$("#searchResultListDiv").css({display:'none', position:'absolute'});
  		$("#searchResultListDiv>.imSearchClose").unbind("click");
  		$(document).unbind('.tempsearch');
  		$("#searchResultListDiv").unbind('click');
  		$(".imSearchdiv").find(".imInputdiv").val(M_HINT);
  	}
  }
  
  //显示最近联系人列表
  function dropRecent(evt, searchbox) {
  	var search = $(searchbox);
  	var hint = search.val();
  	if(hint == M_HINT)		
  		search.val(preKeyword==undefined?'':preKeyword);
  	//显示遮罩
  	showResultDiv(1);
  }
  
  //搜索结果为空时的显示
  function showEmptyResultDiv(bShow, containerId, sms, _margin_top_px) {
  	var oContainer = $("#" + containerId);
  	var default_px = 200;
  	if(bShow) {
  		console && console.log(sms);
	  	//隐藏所有的子元素
	  	oContainer.find('._hiddeit').hide();
	  	oContainer.append('<div class=\"_removeit\" style=\"' +
	  	 'background: url(\'/social/images/search_empty_wev8.png\') no-repeat center;' +
	  	 'background-size:58px 58px;' +
	  	 'background-position:center center;' +
	  	 'width:100%;height:60px;' +
	  	 'margin-top: ' + (_margin_top_px==undefined?default_px:_margin_top_px) + 'px;' +
	  	 'text-align: center;' +
	  	 '\"></div>');
	  	oContainer.append('<div class=\"_removeit\" style=\"' +
	  	'text-align:center;' +
	  	'width:100%;height:20px;' + 
	  	'line-height:20px;' +
	  	'font-size:14px;' +
	  	'font-family:\'微软雅黑\', Verdana, Arial, Tahoma;' +
	  	'color: #b1c2c5;' +
	  	'\">' + (sms == undefined?M_SMS:sms) + '</div>');
  	}else{
  		oContainer.remove('._removeit');
  		oContainer.find('._hiddeit').show();
  	}
  }
  
function changeChatTopTab(obj,tabtype){
	var chatdiv=$(obj).parents(".chatdiv");
	var chattop=$(obj).parents(".chattop");
	
	chattop.find(".chatActiveTab").removeClass("chatActiveTab");
	
	chatdiv.find(".chatListbox").hide();
	var target=$(obj).attr("_target");
	chatdiv.find("."+target).show();
	
	var targetScroll=target;
	if(target=="fileList"){
		targetScroll="acclist";
	}
	var scrollbarid=chatdiv.find("."+targetScroll).attr("_scrollbarid");
	$(".chatListScrollbar").css({"z-index":"1000"});
  	$("#"+scrollbarid).css({"z-index":"1001"});
	
	$(obj).addClass("chatActiveTab");
 	var left=$(obj).position().left+($(obj).width()/2);
	var top=$(obj).position().top+31;
	chattop.find(".chatArrow").css({"left":left,"top":top}).show();
	stopEvent();
} 

function getSocialDialog(title,width,height){
    var diag =new window.top.Dialog();
    diag.currentWindow = window; 
    diag.Modal = true;
    diag.Drag=true;
	diag.Width =width?width:680;	
	diag.Height =height?height:420;
	diag.ShowButtonRow=false;
	diag.Title = title;
	return diag;
}

function refreshDiscussInfo(discussid,callback){
//	ChatUtil.getDiscussionInfo(discussid,function(discuss){
//		callback(discuss);
//	});
	
	client.getDiscussion(discussid,function(discuss){
		discussList[discussid]=discuss;
		callback(discuss);
	});
}

function updateDiscussInfo(discussid,operate) {
	if(operate=="quit"){ //退出群
		$("#conversation_"+discussid).remove();
		closeTabWin($("#chatTab_1_"+discussid+" .tabClostBtn"));
	}else{
		ChatUtil.setDiscussInfo(discussid);
		//设置当前讨论组信息
		ChatUtil.setCurDiscussInfo(discussid, '1');
	}
}
  
function refreshDiscussTitle(discussid) {
	ChatUtil.getDiscussionInfo(discussid, true, function(discuss){
		refreshDiscussName(discuss);
	});
}

function refreshDiscussName(discuss){

	var discussid=discuss.getId();
	var discussName=discuss.getName();
	
	var chatdivid = "chatdiv_" + discussid;
	$('#' + chatdivid+' .imtitleName').html(discussName).attr("title",discussName);
	
	var chatTabid = "chatTab_1_" +discussid;
	$("#"+chatTabid+" .targetName").html(discussName).attr("title",discussName);
	
	var conversationid="conversation_"+discussid;
	$("#"+conversationid+" .targetName").html(discussName).attr("title",discussName);
}

function showBlueLayer(obj, bshow){
	var item = $(obj);
	var layer = item.find('.rightMenuItemLayer');
	if(bshow){
		if(layer && layer.length > 0)
			layer.show();
		else{
			item.css('position', 'relative');
			item.find('.rightMenuItemLayer').remove();
			item.append("<div class='rightMenuItemLayer'>"+item.html()+"</div>");
		}
	}else{
		item.find('.rightMenuItemLayer').hide();
	}
}

function showRightMenu(obj, options){
	var menudiv = $('.rightMenudiv');
	menudiv.css('left', options.left+"px");
	menudiv.css('top', options.top+"px");
	menudiv.show().focus();
	menudiv.autoHide();
	var menuList = options.menuList;
	var menuItem;
	menudiv.empty();
	var classtag = "";
	for(var i = 0; i < menuList.length; ++i){
		menuItem = menuList[i];
		if(i > 0) classtag = "clearTopBorder";
		menudiv.append("<div class=\"rightMenuItem " + 
			classtag + "\" onclick=\"" + 
			menuItem.clickfunc + "\" onmouseover=\"showBlueLayer(this, 1)\" " +
			"onmouseout=\"showBlueLayer(this, 0)\">" + 
			menuItem.menuName + "</div>");
	}
	//绑定缓存数据
	var chatitem = $(obj);
	menudiv.data("targetType", chatitem.attr('_targettype'));
	menudiv.data("targetName", chatitem.attr('_targetname'));
	menudiv.data("targetId", chatitem.attr('_targetid'));
}

function refreshDiscussSetting(settingInfo) {
	settingInfos[settingInfo.targetid]=settingInfo;
}

var dialogfile = null;
//打开附件预览
function viewIMFile(obj) {
	var fileid=$(obj).attr("_fileid");
	var fileName=$(obj).attr("_fileName");
	if(!checkFileType(fileName)){
		downloads(fileid);
		return ;
	}
	dialogfile = new window.top.Dialog();
	dialogfile.currentWindow = window;
	dialogfile.Title = "文件预览";
	dialogfile.Width = 800;
	dialogfile.Height = 600;
	dialogfile.maxiumnable=true;
	dialogfile.Drag = true;
	dialogfile.URL = "/social/im/SocialIMFilePreView.jsp?fileid="+fileid;
	dialogfile.show();
}

//检查文件类型
function checkFileType(filename) {
	var isavailable = false;
	var filePostfixs = ['.pdf','.txt', '.png', '.doc', '.docx', '.xls', '.xlsx', '.jpg', '.bmp', '.gif','.java','.jsp']
	if(filename == "" || filename == null || typeof(filename)=="undefined")
		return isavailable;
		
	for(var i in filePostfixs) {
		var index = filename.toLowerCase().lastIndexOf(filePostfixs[i]);
		if((index+(filePostfixs[i].length)) == filename.length) { //判断文件名后缀是否以数组中的任意值结尾
			isavailable = true;
			break;		
		}  
	}
	
	return  isavailable;
}

var appType="";
var targetObj;
function onShowApp(type,target){
	   appType=type;
	   targetObj=$(target);
	   var url;
       if(type=='doc')
	      url="/systeminfo/BrowserMain.jsp?url=/docs/docs/MutiDocBrowser.jsp";
	   else if(type=='project')   
	      url="/systeminfo/BrowserMain.jsp?url=/proj/data/MultiProjectBrowser.jsp";
	   else if(type=='crm')   
	      url="/systeminfo/BrowserMain.jsp?url=/CRM/data/MutiCustomerBrowser.jsp";
	   else if(type=='workflow')   
	      url="/systeminfo/BrowserMain.jsp?url=/workflow/request/MultiRequestBrowser.jsp"; 
	   
	   hideChatPopBox();  
	   showModalDialogForBrowser(event,url,'#','resourceBrowser',false,1,'',{name:'resourceBrowser',hasInput:false,zDialog:true,needHidden:true,dialogTitle:'',arguments:'',_callback:appCallback});	
}

function appCallback(event,data,name,oldid){
	if(data){
	   var sHtml="";
       var ids=data.id;
       var names=data.name;
       if(ids.split(",").length>10){
          window.top.Dialog.alert("您选择的数量太多，请重新选择！");
       }else if(ids.length>0){
          var tempids=ids.split(","); 
          var tempnames=names.split(",");
          
          for(var i=0;i<tempids.length;i++){
              var tempid=tempids[i];
              var tempname=tempnames[i];
              if(tempid=='') continue;
              var url="";
              var resourcetype=0;
			  if(appType=="doc"){
					url="/docs/docs/DocDsp.jsp?id="+tempid;
					resourcetype=1;
			  }else if(appType=="crm"){   
					url="/CRM/data/ViewCustomer.jsp?CustomerID="+tempid;
					resourcetype=2;
			  }else if(appType=="workflow"){   
					url="/workflow/request/ViewRequest.jsp?requestid="+tempid;
					resourcetype=0;
			  }else if(appType=="project"){   
					url="/proj/data/ViewProject.jsp?ProjID="+tempid;
					resourcetype=3;
			  }	
			  	
              var sendObj=$(targetObj).parents(".chatdiv").find(".chatSend");
              var targetid=sendObj.attr("_acceptid");
              var targetType=sendObj.attr("_chattype");
              var resourceids=ChatUtil.getMemberids(targetType, targetid);
              var sharegroupid=targetType==1?targetid:"";
              resourceids=resourceids.substr(1,resourceids.length-2);
              
              //保存权限
		      $.post("/mobile/plugin/chat/addShare.jsp?resourcetype="+resourcetype+"&resourceid="+tempid+"&sharegroupid="+sharegroupid,{"resourceids":resourceids},function(){
		      	
		      });
		      var data={"shareid":tempid,"sharetitle":tempname,"sharetype":appType,"objectName":"FW:CustomShareMsg"};
		      ChatUtil.sendIMMsg(sendObj,6,data);
          }
       }
    }
}

function viewShare(obj){
	var shareid=$(obj).attr("_shareid");
	var sharetype=$(obj).attr("_sharetype");
	var sharer=$(obj).attr("_senderid");
	var url="";
	if(sharetype=="workflow"){
		url="/workflow/request/ViewRequest.jsp?requestid="+shareid+"&isfromchatshare=1&sharer="+sharer;
	}else if(sharetype=="doc"){
		url="/docs/docs/DocDsp.jsp?id="+shareid;
	}
	window.open(url);
}

function viewHrmCard(hrmid){
	window.open("/hrm/HrmTab.jsp?_fromURL=HrmResource&id="+hrmid);
}

</script>