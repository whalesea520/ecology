
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.social.service.SocialIMService"%>
<%@page import="weaver.social.po.SocialRemind"%>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<script>

var browserName = $.client.browser;             //浏览器名称
var browserVersion = $.client.version;//浏览器版本
var isChrome=browserName=="Chrome";
//alert("browserName:"+browserName+" browserVersion:"+browserVersion+" isChrome:"+isChrome);

//通过如今的插件Jquery.client.js不能探查到edge内核浏览器，建议更新jqeury.client.js！！以下是暂时性替换方案
var ua = navigator.userAgent.toLowerCase();
if(/edge/i.test(ua)){
	browserName = 'Edge';
	browserVersion = ua.match(/edge\/([\d.]+)/)[1];
	isChrome=false;
	console.error('通过如今的插件Jquery.client.js不能探查到edge内核浏览器，建议更新jqeury.client.js！！');
}
var diag=null;
function addGroup(groupid){
	    var title="<%=SystemEnv.getHtmlLabelName(126909, user.getLanguage())%>";  //新建群
	    var url="/social/group/SocialGroupSetting.jsp";
	    if(groupid){
	    	title="<%=SystemEnv.getHtmlLabelName(126910, user.getLanguage())%>";  //群设置
	    	url+="?groupid="+groupid;
	    }
		diag=getDialog(title,600,530);
		diag.URL =url;
		diag.show();
		document.body.click();
 }
 
var messageQueue=new Array();
/*
var msgInterval=setInterval(function(){
	for (key in messageQueue) {
        if (messageQueue.hasOwnProperty(key)) {
        	try{
				handleIMMsg(messageQueue[key]);
			}catch(e){
				console.log("处理消息体报错："+e);
			}
        	delete messageQueue[key];
        	break;
        }
    }
},100);
*/
//接收消息
var converMsgList={};
var countMsgidsArray=new Array();
var sendCountMsgids=new Array(); //已发送count消息id
var countInterval=setInterval(function(){
	if(countMsgidsArray.length>0){
		var msgdata=countMsgidsArray.pop();
		var msgid=msgdata.msgid;
		var toid=msgdata.toid;
		var msgFrom=msgdata.msgFrom;
        
        if(toid == 'SysNotice') {
            coutinue;
        }
		
		var index=sendCountMsgids.indexOf(msgid);
		if(sendCountMsgids.indexOf(msgid)==-1){
    		client && client.error("发送count消息： sendmsgid:"+msgid+" toid:"+toid+" index:"+index);
			ChatUtil.sendCountMsg(msgid, toid,msgFrom);
	    }
	}
},300);
//每间隔1小时清空一次已发送count消息id
var countClearInterval=setInterval(function(){
	if(sendCountMsgids.length>0){
		sendCountMsgids.splice(0,sendCountMsgids.length);
  	}
},1000*60*60);

//推送消息处理接口 1125 created by wyw
function handlePushMsg(pushMsgType, message){
	var sendtime=message.getSentTime();
	switch(pushMsgType){
    	//必达
    	case 0:
    		try{
    			var contentObj = eval("("+message.getContent()+")");
    		}catch(e){
    			client && client.error("handlePushMsg content -->contentObj 失败！");
    		}
    		var targettype = 3;
    		var msgType=6;
    		var dingObj = contentObj.para.ding;
    		var dingContent = dingObj.content;
    		var dingid = dingObj.id;
    		var senderid = dingObj.sendid;
    		var targetid="bing_"+M_USERID;
    		var messageid = dingObj.messageid;
    		
    		var senderInfo=getUserInfo(senderid);
    		//只有自己是接受者的情况下才会提醒 0114 by wyw
    		if(versionTag == 'rdeploy'){
    			var result = IM_Ext.isDingReciver(dingObj);
    			if(result.isReciver){
    				remindRdeploy(4);
    			}
    		}
    		updateConversationList(senderInfo,targetid,targettype,dingContent,sendtime);
    		//带消息id的必达，表示是从文本消息转过来的必达
    		if(messageid != ''){
    			//如果已有的本地缓存，表示：
    			//1 web的文本转必达（其实在收到消息前已经变样式）；
    			//2 移动端的必达确认消息 对于情况2要强制改变气泡气泡确认状态
    			if(!!localmsgtags[messageid]) {
    		  		//改变消息体样式
    		  		localmsgtags[messageid].resinfo = dingObj;
    				IM_Ext.doChangeStyleByTag(1, dingid, messageid, true);
    				return;
    		  	}
    		  	//如果没有本地缓存，表示：移动端的文本转必达
    			IM_Ext._addMsgTag(1, dingid, messageid);
    		}
    	break;
    	//流程 or 邮件
    	case 1:
            return; // 屏蔽老的推送方法
    		try{
    			var extraObj =eval("("+message.getExtra()+")");
    			var wfObj = extraObj.para;
    			//pc端调用pc端的提醒接口
    			if(typeof from != 'undefined' && from == 'pc'){
    				var moduleno = extraObj.para.module, requestid;
    				if(moduleno == '1'){
    					requestid = extraObj.para.detail;
    				}else if(moduleno == '13'){
    					requestid = extraObj.para.id;
    				}
    				isRemindPupup(moduleno, requestid, function(ret){
    					if(ret.isNeedRemind){
    						RemindTipUtils.showRemindTip(extraObj);
    					}
    				});
    			}
    		}catch(e){
    			
    		}
    	break;
        case 2:
            try{
                client && client.writeLog('FW:SysMsg 开始拦截');
                var allContent = eval("(" + message.getContent() + ")");
                var content = allContent.content;
            
                // pc和web都处理的
                switch(content.pushType) {
                    case 'forced_offline' :  //强制下线
                        HandleSysMsgUitl.forcedOffline(allContent);
                        break;
					case 'forced_openCon'://打开会话
						HandleSysMsgUitl.openCon(allContent);
						break;
                    //处理各种推送
                }
				var targetid = message.getTargetId();
				var targetid = message.getTargetId();
				if((typeof targetid !="undefined"&& targetid.indexOf("push_")!=-1)){
					var push_id =  targetid.substring(targetid.indexOf("_")+1,targetid.indexOf('|'));
					content.urltype =push_id+"_"+content.urltype;
					var targetInfoO = getUserInfo(push_id);
					content.title=content.title+"-"+targetInfoO.deptName+"："+targetInfoO.userName;
				}
            	//更新会话(params[pushType:推送类型, requestid:资源标识, subject: 标题, sendtime: 发送时间)
                //PushHandler.updatePushMsgConversation(content.pushType, content.requestid, content.requesttitle, sendtime);
            	//emessage嵌入窗口追加消息体
            	//if($("#chatWin_5_SysRemind").length > 0){
            	//	HandleSysMsgUitl.appendMsg(content, sendtime);
            	//}
                // pc处理的消息
                if(ChatUtil.isFromPc()){
                    switch(content.pushType) {
                        case 'weaver_remind' :  // 流程提醒
                            HandleSysMsgUitl.weaverRemind(content);
                            break;
                        case 'weaver_sendDir' :  //发送文件夹，发送系统消息通知对方
                            var userInfos = window.require('nw.gui').global.GLOBAL_INFOS.userInfos;
                            //window.Electron.ipcRenderer.sendSync('global-getUserInfos');
                            HandleSysMsgUitl.sendDir(allContent, userInfos);
                            break;
                        case 'weaver_confirmSendDir' :  //发送文件夹，如果不能同网传输，处理对方回馈
                            HandleSysMsgUitl.confirmSendDir(allContent);
                            break;
                        case 'weaver_senderCancelDir' :  //发送方取消发送
                            HandleSysMsgUitl.senderCancelDir(allContent);
                            break;
                        case 'weaver_setpass' :   //服务端修改密码提示
                            HandleSysMsgUitl.affterResetPassword(allContent);
                            break;
                    }
                }
                client && client.writeLog('FW:SysMsg 拦截结束');
            }catch(e){
                client && client.writeLog('FW:SysMsg 拦截出现异常，异常信息如下');
                client.writeLog(e);
            }
        break;
	case 3 :
	    var targetId = message.getContent();
        HandleInterceptMsgUtils.clearUnreadCount(targetId);
	break;	
	case 4:
   		try{
   			var extraObj =eval("("+message.getExtra()+")");
   		}catch(e){
   			client && client.error("handlePushMsg broadcast extra -->contentObj 失败！");
   		}
   		var msgContent = message.getContent();
   		if(extraObj){
   			var senderid = extraObj.senderid;
   			var sendtime = extraObj.sendtime;
   			var senderInfo=getUserInfo(senderid);
   			var senderName = senderInfo.userName;
			var broadid = extraObj.broadid;
   			var plaintext = extraObj.plaintext;
   		}
   		var targetid = "SysNotice_"+M_USERID;
   		var targettype = 4;
   		updateConversationList(senderInfo,targetid,targettype,msgContent,sendtime);
   		PushHandler.updateBroadcastList(extraObj);
   		// 滚动到顶部
		$("#msgList").scrollTop(0);
   		//弹窗走你
   		var popContent = new Object();
   		popContent.url = "/mobile/plugin/social/broadcastdetails.jsp?from=pc&broadid="+broadid;
   		
   		var params = "";
   		
   		params += "&imageids="+extraObj.imageids;
   		params += "&accids="+extraObj.accids;
   		params += "&wfids="+extraObj.wfids;
   		params += "&docids="+extraObj.docids;
   		params += "&accnames="+extraObj.accnames;
   		params += "&accsizes="+extraObj.accsizes;
   		params += "&wfnames="+extraObj.wfnames;
   		params += "&docnames="+extraObj.docnames;
   		params += "&senderid="+extraObj.senderid;
   		params += "&sendtime="+extraObj.sendtime;
   		
   		popContent.url += params;
   		popContent.urltype = 0;
   		popContent.requestid = broadid;
   		popContent.requesttitle = msgContent;
   		popContent.requestdetails = "<div style='width:90%;text-overflow:ellipsis;white-space:nowrap;overflow:hidden'>"+IM_Ext.truncContent(plaintext, 80, 0)+"</div>";
   		popContent.title = "新广播";
   		if(from == 'pc'){
   			RemindTipUtils.showRemindTip(popContent);
   		}
   		
   	break;
	   case 6:
	  	 	try{
    			var content = message.getContent();
    		}catch(e){
    		}
			if(message.getTargetId().indexOf("|notice|-2")!=-1) return;
    		var targettype = 6;
    		var msgType=6;
    		var targetid="notice_-1";    		
    		var senderInfo={};
			senderInfo.userid = "notice_-1";
    		updateConversationList(senderInfo,targetid,targettype,content,sendtime);
			if($("#chatWin_6_notice_-1").length!=0){
				try {
					window.frames['notice_-1'].toDoList();
				} catch (error) {
					
				}
			}
			var chatWin=$("#chatWin_6_notice_-1");
			var isWinAct = chatWin.length==0||chatWin.is(":hidden")||!IMUtil.isWindowActive(window.self);
			if(!isWinAct) return;
			var conversation=$("#"+ getConverId(targettype, targetid));
	  		var msgcount=conversation.find(".msgcount").css({"display":"block"});
	  		msgcount.html(Number(msgcount.html())+1);
	  		var tabmsgcount=$("#chatTab_6_notice_-1 .msgcount").css("display", "block");
	  		tabmsgcount.html(Number(tabmsgcount.html())+1);
	  		updateTotalMsgCount(1,'add');  		
	  		var remindType=ChatUtil.getRemindType(targetid);			
	  		if(remindType==1){
                var playAudio = true;
                if(ChatUtil.isFromPc()) {
                    var config = PcSysSettingUtils.getConfig();
                    if(config.msgAndRemind.audioSet_all) {
                        playAudio = false;
                    }
                    TrayUtils.flashingTray();
                } 
                if(playAudio) {
                    // audio = document.getElementsByTagName("audio")[0]
                    audio = document.getElementById('smsReceivedAudio');
                    audio.play();
                }
	  		}
	   break;
	}
}

//推送消息处理
var PushHandler = {
	//更新会话
	updatePushMsgConversation: function(pushType, requestid, requesttitle, sendtime, content){
		var targetType = 5;
		var senderInfo = {'userid': 'weaver_remind'};
		var realTargetid = pushType;
		if(pushType == 'weaver_remind'){
			realTargetid = 'SysRemind';
		}
		var msgcontent = requesttitle;
		updateConversationList(senderInfo,realTargetid,targetType,msgcontent,sendtime);
	},
	//更新广播列表
	updateBroadcastList: function(extraObj, updateMode) {
		var chatWin = $("#chatWin_4_SysNotice");
		if(chatWin.length <= 0){
			return;
		}
		var senderid = extraObj.senderid;
 		var sendtime = extraObj.sendtime;
 		var senderInfo=getUserInfo(senderid);
 		var senderName = senderInfo.userName;
 		var broadid = extraObj.broadid;
 		var plaintext = extraObj.plaintext;
 		var imageIdList = IMUtil.niceSplit(extraObj.imageids, ',');
 		var accIdList = IMUtil.niceSplit(extraObj.accids, ',');
 		var accNameList = IMUtil.niceSplit(extraObj.accnames, ',');
 		var accSizeList = IMUtil.niceSplit(extraObj.accsizes, ',');
 		var wfIdList = IMUtil.niceSplit(extraObj.wfids, ',');
 		var wfNameList = IMUtil.niceSplit(extraObj.wfnames, ',');
 		var docIdList = IMUtil.niceSplit(extraObj.docids, ',');
 		var docNameList = IMUtil.niceSplit(extraObj.docnames, ',');
		var itemObj = $("#msgItemTemp").clone();
		itemObj.find('.msgItem').attr('broadid', broadid);
		itemObj.find('.txtdiv').html(plaintext.replace(/\n/gim, '<br>').replace(/\r/gim, '<br>'));
		itemObj.find('.sendname').text(senderName);
		itemObj.find('.sendtime').text(IMUtil.getFormatTimeByMillis(sendtime));
		var imgList = itemObj.find('.imgdiv');
		var accList = itemObj.find('.accList .titleBody');
		var wfList = itemObj.find('.wfList .titleBody');
		var docList = itemObj.find('.docList .titleBody');
		
		$.each(imageIdList, function(index, id){
			$("<img onclick='BCHandler.showImgLight(this)' style='width: 70px; height: 70px;' src='/weaver/weaver.file.FileDownload?fileid="+id+"'/>").
			appendTo(imgList);
		});
		if(accIdList.length <= 0){
			accList.prevAll('.titleHead').hide();
		}
		for(var i = 0; i < accIdList.length; ++i){
			$("<div onclick='downloads("+accIdList[i]+");'>" +
				"<a href='javascript:void(0);'>"+accNameList[i]+"("+accSizeList[i]+")"+"</a>" +
			"</div>").
			appendTo(accList);
		}
		if(wfIdList.length <= 0){
			wfList.prevAll('.titleHead').hide();
		}
		for(var i = 0; i < wfIdList.length; ++i){
			$("<div onclick=\"PcExternalUtils.openUrlByLocalApp(\'/workflow/request/ViewRequest.jsp?requestid="+wfIdList[i]+"\', 0)\">" +
				"<a href='javascript:void(0);'>"+wfNameList[i]+"</a>" +
			"</div>").
			appendTo(wfList);
		}
		if(docIdList.length <= 0){
			docList.prevAll('.titleHead').hide();
		}
		for(var i = 0; i < docIdList.length; ++i){
			$("<div onclick=\"PcExternalUtils.openUrlByLocalApp(\'/docs/docs/DocDsp.jsp?id="+docIdList[i]+"\', 0)\">" +
				"<a href='javascript:void(0);'>"+docNameList[i]+"</a>" +
			"</div>").
			appendTo(docList);
		}
		$("#msgList .bg").remove();
		if(updateMode == 'append') {
			$("#msgList").append(itemObj.find('.msgItem'));
		}else{
			$("#msgList").prepend(itemObj.find('.msgItem').attr('temp', 'true'));
		}
		
		//判断当前已经临时添加的数目
		var tempLen = $("#msgList>msgItem[temp]").length;
		var pagesize = BCHandler.options.PAGESIZE;
		if(tempLen > pagesize){
			BCHandler.tempPageSize = tempLen + pagesize;
		}
	}
}
//处理Fw:CloseMsg 
var HandleCloseMsgUitl ={
	//pc或者web退出设置
	closePc:function(){
		if(ChatUtil.isFromPc()){
			PcMainUtils.logout();
		}else{
			 clearInterval(parent.webLoginStatusHandle);
			 parent.isLoginOut=true;
			$("#IMbg",parent.document).remove();
			$("#immsgdiv",parent.document).remove();
			$("#addressdiv",parent.document).remove();
		}
	}
}
// 处理FW:SysMsg类型消息
var HandleSysMsgUitl = {
	//追加消息体
	appendMsg: function(content, sendtime){
		var contentBody = $("#chatWin_5_SysRemind iframe[name='sysremindframe']").contents();
		var msgList = contentBody.find("#msgList");
		var msgItemTemp = contentBody.find("#msgItemTemp").clone();
		var _sendtime = getFormateTime(sendtime);
		var _remindtype = content.remindType;
		var _url = content.url;
		//FIXME: 获取标题
		var _msgtitle = "新到达流程";
		var _subject = content.requesttitle;
		var _details = content.requestdetails;
		var _requestid = content.requestid;
		msgItemTemp.find(".sendtime").text(_sendtime);
		msgItemTemp.find(".msgItem").attr("data-remindtype", _remindtype).attr("data-requestid", _requestid);
		msgItemTemp.find(".msgTitle").text(_msgtitle);
		msgItemTemp.find(".subject").text(_subject);
		msgItemTemp.find(".msgDetails").html(_details);
		msgList.prepend(msgItemTemp.html());
	},
    // 流程提醒
    weaverRemind : function(content){
        // 根据配置进行拦截提示
        if((content.remindType == <%=SocialRemind.typeMapping.PROCESS_NEW.type %> && !PcSysSettingUtils.getConfig().msgAndRemind.wfRemind)
			|| (content.remindType == <%=SocialRemind.typeMapping.EMAIL.type %> && !PcSysSettingUtils.getConfig().msgAndRemind.mailRemind)
			||(content.remindType == 21 && typeof PcSysSettingUtils.getConfig().msgAndRemind.docRemind !='undefined'&&!PcSysSettingUtils.getConfig().msgAndRemind.docRemind)
        ) {
            client && client.writeLog('根据用户提醒配置进行了拦截  ' + content.remindType);
            return;
        }
        //非外部链接拼接requestid
        if(content.remindType != -1 && "requestid" in content){
        	content.url = content.url + content.requestid;
        }
		if(content.bebelongto !=""){
			var belongtoid = content.bebelongto;
			content.url += "&f_weaver_belongto_userid="+belongtoid;
			var belongtoInfo = getUserInfo(belongtoid);
			content.title=content.title+"-"+belongtoInfo.deptName+"："+belongtoInfo.userName;
		}
        if(content.needCheck) {
            isRemindPupup(content.remindType, content.requestid, function(ret){
                client && client.writeLog('是否进行提醒 ret.isNeedRemind = ' + ret.isNeedRemind);
                if(ret.isNeedRemind){
                    RemindTipUtils.showRemindTip(content);
                }
            });
        } else {
            RemindTipUtils.showRemindTip(content);
        }
    },
    // 强制用户下线
    forcedOffline : function(allContent){
        var content = allContent.content;
        var extra = allContent.extra;
        var clearType = content.clearType;
        
        // pc处理
        if(ChatUtil.isFromPc()) {
            var userInfos = window.require('nw.gui').global.GLOBAL_INFOS.userInfos;
            //window.Electron.ipcRenderer.sendSync('global-getUserInfos');
            // 如果是强制下线消息，且接收到时间小于用于登录时间，离线消息，不处理
            if(clearType == 1 && extra.sendtime < userInfos.loginTime) {
                return;
            }
            if(clearType == 0) { // 清理缓存
                //var win = window.Electron.currentWindow;
                //win.webContents.session.clearCache(function(){
                    writeLog('服务端强制清理缓存完成');
                //});
            }
            else if(clearType == 1) {  // 强制下线
                DragUtils.closeDrags();
                var count = 30;
                var html = '<%=SystemEnv.getHtmlLabelName(127210, user.getLanguage())%>';  // 服务端有更新，系统将在{ss}秒后自动退出，请重新登录
                window.top.Dialog.alert(ChatUtil.formatString(html, { ss : count }), function(){
                    exeLogout();
                });;
                
                function exeLogout() {
                    //var win = window.Electron.currentWindow;
                    //win.webContents.session.clearCache(function(){
                        PcMainUtils.logout();
                    //});
                }
                
                setInterval(function(){
                    count--;
                    if(count == 0){
                        exeLogout();
                        return;
                    };
                    $('#Message_undefined').html(ChatUtil.formatString(html, { ss : count }));
                }, 1000);
            }
        } 
        // web处理
        else {
            if(clearType == 0) { // 清理缓存
                writeLog('web端对服务端强制清理缓存暂不处理');
            }
            else if(clearType == 1) {  // 强制下线
                window.top.Dialog.alert('<%=SystemEnv.getHtmlLabelName(127259, user.getLanguage())%>'); //服务端有更新，web端已经自动退出，请刷新页面后重新使用
                parent.$.get('/social/im/ServerStatus.jsp?p=logout');
                
                clearInterval(parent.webLoginStatusHandle);
                parent.isLoginOut=true;
                
                parent.$("#immsgdiv").removeAttr('onclick').css('backgroundColor', '#ccc').html('').attr('title', '服务端有更新，web端已经自动退出，请刷新页面后重新使用').show();
                parent.$("#IMbg").remove();
                parent.$("#addressdiv").remove();  // 这一个要最后删除，否则iframe内的函数会调用不正常
            }
        }
    },
    // 通知对方发送文件夹
    sendDir : function(allContent, userInfos){
        var extra = allContent.extra;
        var sendTime = extra.sendTime;
        // 如果接受到时间小于用于登录时间，离线消息，不处理
        if(sendTime < userInfos.loginTime) {
            return;
        }
        PcSendDirUtils.sendAndReceiveDir(allContent);
    },
    // 如果不能同网传输，处理对方回馈
    confirmSendDir : function(allContent){
        var content = allContent.content;
        var extra = allContent.extra;
        
        var msgId = extra.msg_id;  //消息ID
        var type = content.type;
        var dirSender = PcSendDirUtils.currentSendDir[msgId];
        dirSender.updateSenderInfo({name:dirSender.EventsName.confirm, type: type, msgId : msgId});
    },
    // 发送方取消发送
    senderCancelDir : function(allContent){
        var content = allContent.content;
        var extra = allContent.extra;
        var msgId = extra.msg_id;
        PcSendDirUtils.afterSenderCancelSuccess(msgId);
    },
    // 服务端修改密码提示
    affterResetPassword : function(allContent){
        var content = allContent.content;
        var tipType = content.tipType;
        var msg = null;
        if(tipType == 0) { // 修改密码后提示用户重新登陆
            msg = '用户密码已更改，请重新登录';
        } else if(tipType == 1) {
            msg = '定时修改密码任务启动，请您退出并修改OA密码后，重新登录';
        }
        if(msg) {
            DragUtils.closeDrags();
            M_ISFORCEONLINE = true;
            client && client.disconnect();
            window.top.Dialog.alert(msg, function(){
                PcMainUtils.logout();
                DragUtils.restoreDrags();
            });
        }
    },
	openCon : function(allContent){
		var msgExtraObj = allContent.extra;
		var _targetIdList = msgExtraObj.conventioners.split(',');
		var _openType = msgExtraObj.openType;
		var _extraArray = msgExtraObj.extra;
		if(ClientSet.multiAccountMsg==1){
			if(_openType==2||_openType ==0){
				for(var i = _targetIdList.length-1;i>=0;i--){
					var parentAccountid =  AccountUtil.accountBelongTO[getRealUserId(_targetIdList[i])];
					if(typeof parentAccountid =="undefined") continue;
					if(parentAccountid==M_USERID){
						_targetIdList.splice(i,1);
					}else{
						if(_openType==2){
							_targetIdList.splice(i,1,getIMUserId(parentAccountid));
						}else if(_openType==0){
							_targetIdList.splice(i,1,parentAccountid);
						}
					}
				}
			_targetIdList = IMUtil.unique(_targetIdList);
				if(_openType==2){
					_targetIdList = IMUtil.removeArray(_targetIdList,getIMUserId(M_USERID));
				}else if(_openType==0){
					_targetIdList = IMUtil.removeArray(_targetIdList,M_USERID);
				}	
			}
		}
		if(_targetIdList.length==0) return;
		if(_openType == 2 &&_targetIdList.length==1 && getRealUserId(_targetIdList[0])!=M_USERID){
			_targetIdList[0] = getRealUserId(_targetIdList[0]);
			_openType = 0;
		}
		if(_openType ==0){
			$.each(_targetIdList,function(i,result){
				if(result!=M_USERID){
					if(result.length<32){
						var chatInfo = {};
						chatInfo.targetType = 0;
						chatInfo.acceptId =  result;
						chatInfo.userName = userInfos[result].userName;
						chatInfo.userHead = userInfos[result].userHead;
						ChatUtil.sendIMMsgSimulating(chatInfo,_extraArray,HandleSysMsgUitl.openConCallBack);
					}else{
						client.getDiscussionName(result,function(name){
						var chatInfo = {};
						chatInfo.targetType = 1;
						chatInfo.acceptId =  result;
						chatInfo.userName = name;
						chatInfo.userHead = '/social/images/head_group.png';
						ChatUtil.sendIMMsgSimulating(chatInfo,_extraArray,HandleSysMsgUitl.openConCallBack);
						})
					}
						
				}
			})
		}else if(_openType==1){
			$.each(_targetIdList,function(i,result){
				client.getDiscussionName(result,function(name){
						var chatInfo = {};
						chatInfo.targetType = 1;
						chatInfo.acceptId =  result;
						chatInfo.userName = name;
						chatInfo.userHead = '/social/images/head_group.png';
						ChatUtil.sendIMMsgSimulating(chatInfo,_extraArray,HandleSysMsgUitl.openConCallBack);
				})
			})
		}else if(_openType == 2){
			var _disName ="";
			if(msgExtraObj.groupName.length>0){
				_disName = msgExtraObj.groupName;
			}else{
				for(var i =0,j=_targetIdList.length;i<j;i++){
					var userid=getRealUserId(_targetIdList[i]);
					if(i <4&& typeof userid !=='undefined'){
						 _disName=_disName+","+userInfos[userid].userName;
					}else if(i>=4){
						break;
					}
				}
				_disName=_disName.substr(1);
			}	
			if(typeof parent.showIMdiv ==='function'){
				parent.showIMdiv(1);
			}	
			DiscussUtil._addDiscuss(_disName,_targetIdList.join(","),_targetIdList,function(info, disName){
						var chatInfo = {};
						chatInfo.targetType = 1;
						chatInfo.acceptId =  info;
						chatInfo.userName = disName;
						chatInfo.userHead = '/social/images/head_group.png';
						ChatUtil.sendIMMsgSimulating(chatInfo,_extraArray,HandleSysMsgUitl.openConCallBack);
			});	
		}
		
	},
	openConCallBack:function(realTargetid,targetType,msgTitle,msgHead,msgContent){
			if(ChatUtil.isFromPc()){
				if(typeof window.Electron !=="undefined"){
					var win = window.Electron.currentWindow;
				 if(!isCurrentWindowFocused()) {
						win.show();
						win.focus();
						}
					win.flashFrame(true);
				}
			}else if(typeof parent.showIMdiv ==='function'){
				//window.focus();
				if(!!window.ActiveXObject || "ActiveXObject" in window){
					window.focus();
				}else{
					if($(':focus').length==0){
						newMsgDeskNotify(realTargetid,targetType,msgTitle,msgHead,msgContent,true);
					}					
				}
				parent.showIMdiv(1);
			}		
	}
	
};
// 处理其他拦截型消息
var HandleInterceptMsgUtils = {
    // 清理指定会话的未读消息
    clearUnreadCount : function(targetId){
        var realTargetId = getRealUserId(targetId);
        var conversation = $("#"+ getConverId(-1, realTargetId));
        var msgcount = conversation.find(".msgcount").css({"display":"block"});
        var readyToDelCount = 0;
        if(msgcount.html() != ''){
        	readyToDelCount = parseInt(msgcount.html());
        }
        // 清除最近上的数字
        var recentmsgcountblock = $(".imToptab .tabitem .recentmsgcount");
        var recentmsgcount = parseInt(recentmsgcountblock.html());
        if (recentmsgcount >= readyToDelCount) {
        	recentmsgcount = recentmsgcount - readyToDelCount;
        }
        recentmsgcountblock.html(recentmsgcount);
        if(recentmsgcount <= 0 || isNaN(recentmsgcount)){
        	recentmsgcountblock.hide();
        }
        msgcount.html(Number(0)).hide();
        
        var targettype = conversation.attr('_targettype');
        msgcount = $("#chatTab_" + targettype + "_" + realTargetId).find(".msgcount");
        msgcount.html(0).hide();
        
        // 托盘图标抖动判断
        var count = 0;
        var msgcountgroup = $('.msgcount');
        for(var i = 0; i < msgcountgroup.length; ++i){
        	var c = $(this).html();
            if(c && c != '') {
                count += parseInt(c);
            }
        }
        if(count == 0) {
        	//console.info("===停止闪动===");
        	if(typeof TrayUtils !== 'undefined'){
        		TrayUtils.restoreTray();
        	}
        }
        
        //消除未读消息总数
        updateTotalMsgCount(readyToDelCount, 'del');
    }
};


// 处理小灰条通知消息
var HandleInfoNtfMsg = {
	withDrawMap:{},
	cancelShareMap:{},
	handle: function(targettype, targetid, message) {
		var extra = message.getExtra();
		var extraObj = {};
		try{
			extraObj=eval("("+extra+")");
		}catch(e){
			extraObj = {};
		}
		var notiType = extraObj.notiType;
		if(notiType=='noti_withdraw'){
			this.handleWithdraw(notiType, targettype, targetid, message);
		}else if(notiType=='cancelShare'){
			this.handleCaneclShareDisk(notiType, targettype, targetid, message);
		}
	},
	// 判断消息是否被撤回
	isMsgWithdrawed: function(message){
		var messageid = IM_Ext.getMsgId(message);
		var withdrawed = false;
		withdrawed = this.withDrawMap[messageid];
		if(!withdrawed){
			withdrawed = !!WithdrawGlobal[messageid]
		}
		
		if(!withdrawed){
			withdrawed = !!WithdrawGlobal[messageid]
		}
		return withdrawed;
	},
	isMsgCancelShared: function(message){
		var messageid = IM_Ext.getMsgId(message);
		return this.cancelShareMap[messageid];
	},
	// 设置缓存
	setCache: function(message){
		var extra=message.getExtra();
		var extraObj = {};
		try{
			extraObj=eval("("+extra+")");
		}catch(e){
			extraObj = {};
		}
		var notiType = extraObj.notiType;
		if(notiType=='noti_withdraw'){
			this.withDrawMap[extraObj.withdrawId] = 1;
			return true;
		}
		if(notiType=='cancelShare'){
			this.cancelShareMap[extraObj.cancelShareId] = 1;
			return true;
		}
		if(notiType=='noti_vote'||notiType=="noti_voteDeadline"){
			return  false;
		}
	},
	// 处理撤销成功后的逻辑
	_handleWithDrawSuccess: function(msgObj){
		var objName = msgObj.objectName;
		var extra = msgObj.extra, extraObj;
		try{
			if(!extra) extra="";
			extraObj=eval("("+extra+")");
			
		}catch(e){
			extraObj={};
		}
		// 公告
		if(objName == 'RC:PublicNoticeMsg') {
			var noteid=extraObj.noteId || "";
			$.post("/social/im/SocialIMOperation.jsp?operation=deletenote", {noteId: noteid});
		}else if(objName == 'FW:attachmentMsg') {
			var fileId=extraObj.fileid;
			$.post("/social/im/SocialIMOperation.jsp?operation=delFileShare", {fileId: fileId});
		}
	},
	// 撤销消息
	withDrawMsg: function(msgObj, targettype, targetid, callback){
		var msgId = IM_Ext.getMsgId(msgObj);
		var wdMsgObj = new Object();
		wdMsgObj.content = "";
		wdMsgObj.extra = JSON.stringify({"withdrawId": msgId, "notiType": "noti_withdraw", "msgFrom": "pc"});
		wdMsgObj.objectName = "RC:InfoNtf";
		var triggerFunc = function(result){
			if(result.issuccess){
				HandleInfoNtfMsg.withDrawMap[msgId] = 1;
				// 保存被撤销的消息
				HandleInfoNtfMsg.saveWithdraw(msgId, targetid, 'pc');
				var msgObj = result.paramzip.msgobj;
				var content = "你撤回了一条消息";
				var msgItemdiv = $("#"+msgId);
				var msgItemDataObj = msgItemdiv.data("msgObj");
				if(msgItemdiv.nextAll('div').length == 0){
					// 更新会话
					updateConversationList(userInfos[M_USERID],targetid,targettype,M_USERNAME+":撤回了一条消息",M_CURRENTTIME,true);
				}
				msgItemdiv.replaceWith("<div class='chatItemdiv chatNotice'><span>"+content+"</span></div>");
				// 特殊消息的处理
				HandleInfoNtfMsg._handleWithDrawSuccess(msgItemDataObj);
			}
			if(callback && typeof callback == 'function'){			
				callback(result);
			}			 			
		}		
		if(targettype == '0'){
			client.sendMessageToUser.call(client, targetid, wdMsgObj, 9, triggerFunc);
		}else if(targettype == '1'){
			client.sendMessageToDiscussion.call(client, targetid, wdMsgObj, 9, triggerFunc);
		}
	},
	// 保存撤销消息
	saveWithdraw: function(msgId, targetId, msgFrom){
		ChatUtil.saveWithdrawLocal(msgId, targetId, msgFrom);
		$.post('/social/im/SocialIMOperation.jsp?operation=saveWithdraw', {"msgId": msgId, "targetId": targetId}, function(curMsgId){
			ChatUtil.delWithdrawLocal($.trim(curMsgId));
		});
	},
	// 取消网盘分享
	caneclShareDiskMsg: function(msgObjOrMsgid, targettype, targetid, callback){
		var msgId = typeof msgObjOrMsgid ==='object'?IM_Ext.getMsgId(msgObjOrMsgid):msgObjOrMsgid;
		var sdMsgObj = new Object();
		sdMsgObj.content = "";
		sdMsgObj.extra = JSON.stringify({"cancelShareId": msgId, "notiType": "cancelShare"});
		sdMsgObj.objectName = "FW:InfoNtf";		
		var triggerFunc = function(result){
			if(result.issuccess){
				HandleInfoNtfMsg.cancelShareMap[msgId] = 1;
				var msgObj = result.paramzip.msgobj;
				var msgItemdiv = $("#"+msgId);
				if(msgItemdiv.length>0){
					var msgObjold = msgItemdiv.data("msgObj");
					if(typeof msgObjold ==="object"){
					msgObjold.objectName = "FW:InfoNtf:cancelShare";
					}
				msgItemdiv.find(".shareDetail").removeAttr("onclick");
				msgItemdiv.find(".shareDetail").attr("_cancelshare","cancelshare");
				msgItemdiv.find(".shareDetail").html("").append("<span style='color:red;'>已取消分享</span>");
				}
				
			if(callback && typeof callback == 'function'){
				callback(result);
			}
			}else{
				IM_Ext.showMsg("取消云盘分享消息发送失败！");
			}
		}
		
		if(targettype == '0'){
			client.sendMessageToUser.call(client, targetid, sdMsgObj, 6, triggerFunc);
		}else if(targettype == '1'){
			client.sendMessageToDiscussion.call(client, targetid, sdMsgObj, 6, triggerFunc);
		}
	},
	// 处理撤销消息
	handleWithdraw: function(notiType, targettype, targetid, message) {
		var extra = message.getExtra();
		var sendtime = message.getSentTime();
		var extraObj = {};
		try{
			extraObj=eval("("+extra+")");
		}catch(e){
			extraObj = {};
		}
		var withDrawId = extraObj.withdrawId;
		var msgFrom = extraObj.msgFrom;
		var chatWinid="chatWin_"+targettype+"_"+targetid;
		var chatwin = $("#"+chatWinid);
		var senderUserid=getRealUserId(message.getSenderUserId()); //发送人id
		var senderInfoUndo=getUserInfo(senderUserid);
		// 缓存消息id
		this.withDrawMap[withDrawId] = 1;
		var needUpdateConver = false;
		// 展示小灰条
		if(chatwin.length>0){
			var senderName = senderInfoUndo.userName;
			if(senderUserid == M_USERID){
				senderName = "你";
			}
			var content = senderName + "撤回了一条消息";
			var withDrawMsgItemdiv = $("#"+withDrawId); 
			needUpdateConver = withDrawMsgItemdiv.nextAll('div').length == 0;
			withDrawMsgItemdiv.replaceWith("<div class='chatItemdiv chatNotice'><span>"+content+"</span></div>");
		}else{
			var lastMessageid = $('#'+getConverId(targettype, targetid)).attr('_msgid');
			if(lastMessageid == withDrawId){
				needUpdateConver = true;
			}
		}
		// 更新会话
		if(targetid!=="" && needUpdateConver){
			updateConversationList(senderInfoUndo,targetid,targettype,senderInfoUndo.userName+":撤回了一条消息",sendtime);
			// 更新底部提示
			var relateddiv = $('#relatedMsgdiv_bottom_'+targetid);
			if(relateddiv.length > 0) {
				relateddiv.find(".relatedContent").html(senderInfoUndo.userName+":撤回了一条消息");
			}
		}
		
		// 来自手机端的消息
		if(msgFrom != 'pc'){
			HandleInfoNtfMsg.saveWithdraw(withDrawId, targetid, 'mobile');
		}
	},
	// 处理取消网盘分享
	handleCaneclShareDisk: function(notiType, targettype, targetid, message) {
		var extra = message.getExtra();
		var extraObj = {};
		try{
			extraObj=eval("("+extra+")");
		}catch(e){
			extraObj = {};
		}
		var cancelShareId = extraObj.cancelShareId;
		var chatWinid="chatWin_"+targettype+"_"+targetid;
		var chatwin = $("#"+chatWinid);
		// 缓存消息id
		this.cancelShareMap[cancelShareId] = 1;
		// 展示网盘取消分享
		if(chatwin.length>0){			
			var msgItemdiv = $("#"+cancelShareId);
			var msgObjold = msgItemdiv.data("msgObj");
			if(typeof msgObjold ==="object"){
				msgObjold.objectName = "FW:InfoNtf:cancelShare";
			}
			msgItemdiv.find(".shareDetail").removeAttr("onclick");
			msgItemdiv.find(".shareDetail").attr("_cancelshare","cancelshare");
			msgItemdiv.find(".shareDetail").html("").append("<span style='color:red;'>分享已取消</span>");
			var chatList=$("#"+chatWinid+" .chatList");
			scrollTOBottom(chatList);
		}
	},
	checkShareDiskMsg : function(msgid){	
	   if(IS_BASE_ON_OPENFIRE||!!HandleInfoNtfMsg.cancelShareMap[msgid]) return;
		jQuery.ajax({
				url : "/rdeploy/chatproject/doc/eventForAjax.jsp",
				data : {
					"type" : "checkShareByMsgId",
					"msgid" : msgid //消息id
				},
				type : "post",
				dataType : "json",
				success : function(data){
					if(data && data.flag != 1){	
						HandleInfoNtfMsg.cancelShareMap[data.msgid] = 1;
						var msgItemdiv = $("#"+data.msgid);
						var _senderid = msgItemdiv.attr('_senderid');
						var msgObjold = msgItemdiv.data("msgObj");
						if(typeof msgObjold ==="object"){
							msgObjold.objectName = "FW:InfoNtf:cancelShare";
						}				
						var content  =  _senderid == M_USERID? "已取消分享":"分享已取消";
						msgItemdiv.find(".shareDetail").removeAttr("onclick");
						msgItemdiv.find(".shareDetail").attr("_cancelshare","cancelshare");
						msgItemdiv.find(".shareDetail").html("").append("<span style='color:red;'>"+content+"</span>");
						}else{
						}
					}
			});	
		}	
};

// 处理常用组
var HrmGroupUtil = {
	getBrowserDiag: function(title, nid){
		var diag=getSocialDialog(title,500,330);
		diag.closeHandle = function(){
			setTimeout(function(){
				HrmGroupUtil.loadGroupList(nid);
			}, 100);
		};
		return diag;
	},
	loadGroupList: function(nid){
		$('#hrmGroupTree').treeview({url:"/social/im/SocialHrmOrgTree.jsp?operation=hrmGroup&groupid="+nid,reload:[nid]});
	},
	doAdd: function(memberIdList, nid){
		var diag = this.getBrowserDiag("新建自定义组", nid);
		var type = 0;
		if(nid == 'publicGroup') {
			type = 1;
		}
		if(memberIdList) {
			var hrmids = "",hrmnames="";
			for (var i=0;i<memberIdList.length;i++) {
				var memberid=getRealUserId(memberIdList[i]);
				hrmids += (i==0?"":",")+memberid;
				hrmnames += (i==0?"":",")+userInfos[memberid].userName;
			}
			diag.URL ="/social/im/SocialHrmDialogTab.jsp?_fromURL=hrmGroup&method=HrmGroupAdd&isdialog=1&type="+type+"&hrmids="+hrmids+"&hrmnames="+hrmnames;
		}else {
			diag.URL = "/social/im/SocialHrmDialogTab.jsp?_fromURL=hrmGroup&method=HrmGroupAdd&isdialog=1&type="+type+"";
		}
		
		diag.show();
	},
	doEdit: function(nid){
		var diag = this.getBrowserDiag("编辑自定义组", $('#'+nid).parents('li').attr('id'));
		diag.URL = "/hrm/HrmDialogTab.jsp?_fromURL=hrmGroup&method=HrmGroupAdd&isdialog=1&id="+nid;
		diag.show();
	},
	doDel: function(nid){
		showImConfirm("你确定要删除这条记录吗?",function(){
				jQuery.ajax({
					url:"/hrm/group/GroupOperation.jsp?operation=deletegroup&groupid="+nid,
					type:"post",
					async:true,
					complete:function(xhr,status){
						HrmGroupUtil.loadGroupList($('#'+nid).parents('li').attr('id'));
					}
				});
		});
	}
};

//是否已处理
function isRemindPupup(moduleNo, requestid, callback){
	var url = "/social/im/SocialIMOperation.jsp?operation=isRemindPupup";
	$.post(url, {"moduleNo" : moduleNo, "requestid" : requestid}, function(ret){
		callback(ret);
	}, 'json');
}

function getPushMsgType(message){
	var objName = message.getObjectName();
	var targetId = message.getTargetId();
	var pushMsgType = -1;
	try{
		//根据targetId判断是否是推送消息类型
		if(targetId.indexOf("|ding") != -1){
			//权限过滤
    		if(ClientSet.ifForbitBing == '1'){
    			console.log("必达已被禁用");
    			return -1;
    		}
			pushMsgType = 0;
		}else if(targetId.indexOf("|wf|") != -1||
				 targetId.indexOf("|mails") != -1||
				 targetId.indexOf("|schedus") != -1||
				 targetId.indexOf("|meetting") != -1||
				 targetId.indexOf("|doc") != -1||
				 targetId.indexOf("|notice") != -1){
					 if(targetId.indexOf("|notice|-1")!=-1||targetId.indexOf("|notice|-2")!=-1){
						pushMsgType = 6;
					 }else{
						pushMsgType = 1;
					 }
		}
        // 系统消息
        else if(objName == 'FW:SysMsg') {
            pushMsgType = 2;
        }
        // 其他端已阅
        else if(objName == 'FW:ClearUnreadCount') {
            pushMsgType = 3;
        }
        // 系统广播
        else if(("|"+targetId+"|").indexOf("|sysnotice|") != -1) {
        	console.info("来了一条系统广播");
        	pushMsgType = 4;
        }
	}catch(e){
		
	}
	return pushMsgType;
}

function receiveIMMsg(message){
	var sendtime=message.getSentTime();
	//messageQueue[sendtime] = message;
	try{
		handleIMMsg(message);
	}catch(e) {
		console.log("处理消息体报错："+e);
	}
}

function handleIMMsg(message){
	var messageid=message.getMessageId();
	var senderUserid=message.getSenderUserId(); //发送人id
	var targetid=message.getTargetId(); //消息来源对象id
	var content=getFormteMsgContent(message); //消息内容
	var msgType=message.getMessageType();
	var conversationType=message.getConversationType(); //会话类型
	var sendtime=message.getSentTime();
	var objName = message.getObjectName(); //消息标识
	var extra=message.getExtra();
	var detail=message.getDetail();
	
	var realTargetid=getRealUserId(targetid);
	var senderid=getRealUserId(senderUserid); //发送人id
	var senderName="";
	var senderHead="";
	var targetName=""; //聊天对象名称
	var targetHead=""; //聊天对象图标
	var isRelated=false; //是否被提到
	
	var targetType=client.getTargetType(conversationType,targetid); //0：单聊 1:群聊 -1：其他
	
	client.writeLog("-----------收到开始----------");
	
	client.writeLog("targetType:"+targetType);
	client.writeLog("senderid:"+senderUserid);
    client.writeLog("targetid:"+targetid);
    client.writeLog("content:"+content);
	client.writeLog("objectName:" + objName);
	client.writeLog("extra:" + extra);
	if(typeof targetid =="string" &&targetid.indexOf("push_")>=0){
		return;
	}
	var isOfflineMsg=false;
	try{
		isOfflineMsg=typeof message.getHasReceivedByOtherClient === 'function'?
			 message.getHasReceivedByOtherClient(): (receivedStatus==8);//是否离线补偿消息
		if(!IS_BASE_ON_OPENFIRE && isOfflineMsg){
			isOfflineMsg = message.getIsOffLineMessage();
		}
		client.writeLog("isOfflineMsg:" + isOfflineMsg);
		isOfflineMsg=isOfflineMsg?true:false;
		client.writeLog("isOfflineMsg:" + isOfflineMsg);
	}catch(e){
		isOfflineMsg=false;
	}
	//FW:CloseMsg 关闭pc或者web端处理
	if(objName=="FW:CloseMsg"){
		HandleCloseMsgUitl.closePc();
		return;
	}
	// 拦截推送消息
	var pushMsgType = getPushMsgType(message);
	if(-1 != pushMsgType){
		if(!isOfflineMsg){
			handlePushMsg(pushMsgType, message);
		}
		return; 
	}
	// 拦截小灰条消息
    if(objName=="RC:InfoNtf"||objName=="FW:InfoNtf"||objName =="RC:InfoNtfVote") {
		var extra = message.getExtra();
		var extraObj = {};
		try{
			extraObj=eval("("+extra+")");
		}catch(e){
			extraObj = {};
		}
		var notiType = extraObj.notiType;
		if(notiType!="noti_vote"&&notiType!="noti_voteDeadline"){
			HandleInfoNtfMsg.handle(targetType, realTargetid, message);
			return;
		}
		if(notiType=="noti_vote"){
			if(extraObj.sharer != M_USERID){
				return;
			}
		}
	} 
	
	if(message && message.getObjectName() == 'RC:DizNtf'){
		var notificationType=message.getType();
		if(notificationType==1) {
			ChatUtil.cache.kickFlags[realTargetid+'_'+targetType] = 0;
		}
	}
	var flag = ChatUtil.cache.kickFlags[realTargetid+'_'+targetType];
    // 自己已被当前群踢出，忽略掉
    if(flag) {
    	client.writeLog("自己已被当前群踢出，忽略掉, targetName:"+targetName);
    	return;
    }
	
	if(isOfflineMsg && objName!="FW:CountMsg" && objName!="FW:SysMsg" && objName!="FW:ClearUnreadCount") {
        var senderInfo=getUserInfo(senderid);
		senderName=senderInfo.userName;
        var msgcontent=senderName+":"+getMsgContent(message);
        updateConversationList(senderInfo,realTargetid,targetType,msgcontent,sendtime);
    }
	
	if(objName=="FW:SyncQuitGroup"){
		var discussid=content;
		ChatUtil.closeConversation('1', discussid);
		ChatUtil.delDiscussBook(discussid);
		ChatUtil.delLocalConver(discussid,1);
		client.error("删除本地讨论组 disucssid:" + discussid);
		return ;
	}
	
	if(targetType==-1) return;
	
	var extraObj=ChatUtil.getExtraObj(extra);
	var msgid=extraObj.messageid;
	var msgFrom=extraObj.msgFrom?extraObj.msgFrom:"";
	
	if(msgid!=""&&$("#"+msgid).length==1){
		client.error("消息重复推送 msgid:"+msgid);
		return ;
	}
	
	//过滤消息指令
	if(objName=="FW:CountMsg"){ 
	    var messageid=content;
		client.error("receivemsgid:"+messageid);
		//非补偿消息
	    if(targetType>-1&&senderid!=M_USERID){
	    	ChatUtil.updateMsgUnreadCount(messageid,senderid,conversationType==4?"0":"1",false,msgFrom);
	    }
		return ; 
	}
	
	if(objName=="FW:SyncMsg"){
		client.error("过滤同步会话syncUser");
		/*
		var messageObj=eval("("+content+")");
		var msgid=messageObj.extra.msg_id;
		$.post("/social/im/SocialIMOperation.jsp?operation=saveSyncMsg",{"msgid":msgid,"message":content},function(data){
		});
		*/
		return ;
	}
	//输入状态[暂时忽略]
	if(objName=="RC:TypSts" || objName=="FW:ClearUnreadCount"){ 
		return;
	}
	try{
		var senderInfo=getUserInfo(senderid);
		senderName=senderInfo.userName;
		senderHead=senderInfo.userHead;
		targetName=senderName;
		targetHead=senderHead;
		
		client.writeLog("senderName:"+senderName);
		client.writeLog("senderHead:"+senderHead);
			
		var currTab=getCurrentTab();
		var currTabid=currTab.attr("id");
		
		var chatWinid="chatWin_"+targetType+"_"+realTargetid;
	  	var chatTabid="chatTab_"+targetType+"_"+realTargetid;
	  	
	  	var chatWin=$("#"+chatWinid);	  	
	  	var msgcontent=senderName+":"+getMsgContent(message);
	  	if(typeof notiType !=="undefined"&&notiType =="noti_voteDeadline"){
			senderInfo.userHead = "/social/images/sysnotice_head.png";
			 msgcontent ="系统提醒"+msgcontent;
		  }
	  	//显示@提醒
	  	if(!isOfflineMsg){
	  		showRelateddiv(extraObj,realTargetid,targetType,senderInfo,msgcontent);
	        
	        if(senderid != M_USERID && ChatUtil.isFromPc()) {
	            // 窗口抖动
	            if(objName == 'FW:CustomMsg') {
	                ShakeWindowUtils.shakeWindow(true, extraObj, senderInfo);
	            }
	            // 消息到达是否弹出窗口
	            typeof openWindowWhenNewMsg === 'function' && openWindowWhenNewMsg();
	        }
	  	}
	}catch(err){
		console.error(err);
	}
  	// !!trace begin!!
	var isWinAct = chatWin.length==0||chatWin.is(":hidden")||!IMUtil.isWindowActive(window.self);
	var isMine = senderid == M_USERID;
	localStorage.setItem("msgid_isWinAct_isMine", msgid+"_"+isWinAct+"_"+isMine);
	// !!trace end!!
  	//消息窗口没有打开或浏览器窗口未聚焦
  	var converTempdiv = updateConversationList(senderInfo,realTargetid,targetType,msgcontent,sendtime);
  	//聊天tab页置顶
  	ChatUtil.setChatTabTop(realTargetid, targetType);
  	if(isWinAct && senderid!=M_USERID){ 
  		
  		if(!isOfflineMsg && converTempdiv){
	  		var conversation=$("#"+ getConverId(targetType, realTargetid));
	  		var msgcount=conversation.find(".msgcount").css({"display":"block"});
	  		msgcount.html(Number(msgcount.html())+1);
	  		var tabmsgcount=$("#chatTab_"+targetType+"_"+realTargetid+" .msgcount").css("display", "block");
	  		tabmsgcount.html(Number(tabmsgcount.html())+1);
	  		updateTotalMsgCount(1,'add');
	  		conversation.attr("_isNeedRedmind","1").attr("_msgid", msgid);
	  		
	  		var remindType=ChatUtil.getRemindType(realTargetid);
	  		if(remindType==1){
                var playAudio = true;
                // pc端，更具配置判断是否有提示音
                if(ChatUtil.isFromPc()) {
                    var config = PcSysSettingUtils.getConfig();
                    if(config.msgAndRemind.audioSet_all) {
                        playAudio = false;
                    }
                    TrayUtils.flashingTray();
                } 
                if(playAudio) {
                    // audio = document.getElementsByTagName("audio")[0]
                    audio = document.getElementById('smsReceivedAudio');
                    audio.play();
                }
	  		}
	  	}
  	}
  	
  	var countMsgItem={"toid":senderid,"msgid":msgid,"msgFrom":msgFrom}; //count消息
  	
  	//消息窗口已经打开
  	if($("#"+chatWinid).length==1){
  		
  		//是必达消息
  		if(targetType == 3){
  			//FIXME: 处理必达消息的显示和会话的同步
  			return;
  		}
  		var chatList=$("#"+chatWinid+" .chatList");
  		
  		var msgObj={"content":content,"objectName":objName,"extra":extra,"detail":detail};
  		var recordType=senderid!=M_USERID?"receive":"send";
		var tempdiv=ChatUtil.getChatRecorddiv(senderInfo,msgObj,recordType,msgType, message, realTargetid);
		
		if(IS_BASE_ON_OPENFIRE || !isOfflineMsg){  //非补偿消息才显示在窗口中
			var flag = isScrollBottom(chatList);
			if(!flag){
				ChatUtil.postFloatNoticeBottom(msgcontent, {
					"chatwin": chatWin,
					"senderinfo": senderInfo,
					"onclick": function(){
						scrollTOBottom(chatList);
					},
					"msgid": msgid
				});
			}
			addSendtime(chatList,tempdiv,sendtime,"receive");
			chatList.append(tempdiv);
			if(flag){
				scrollTOBottom(chatList);
			}
			//绑定窗口滚动标记
			chatList.data("newMsgCome",true);
	  	
	  		if(currTabid==chatTabid){ //当前窗口与消息窗口一致
	  		   
	  		}
	  		// 如果当前滚动条在底部，则继续判断是否显示顶部提示，否则不显示
	  		if(flag) {
	  			if(!chatWin.is(":visible") || !IMUtil.isWindowActive(window.self)){
		  			var ChatItems = chatList.children('div');
		  			var options = {
		  				"onclick": {
		  					"fn": function(){
		  						var chatitemid = chatWin.attr("anchorTopId");
		  						scrollTOMessage(chatList, chatitemid);
		  					},
		  					"params": tempdiv.attr('id')
		  				},
		  				"chatwin": chatWin
		  			};
		  			ChatUtil.postFloatNotice("您还有尚未阅读的消息，请点击阅读", "normal", options);
		  		}
	  		}
  		}
		
		//当前窗口处于打开窗台，主界面处于显示状态，浏览器窗口处于激活状态
		var isWinActive=false;
		if(IMUtil.isWindowActive(window.self)){
			if(versionTag=="rdeploy"&&$("#conversation_"+realTargetid).hasClass("activeChatItem")){
				isWinActive=true;
			}else if($("#chatTab_"+targetType+"_"+realTargetid).hasClass("chatIMTabActiveItem")&&$("#addressdiv",parent.document).is(":visible")){
				isWinActive=true;
			}else if(typeof from != 'undefined' && from == 'pc' && $("#chatTab_"+targetType+"_"+realTargetid).hasClass("chatIMTabActiveItem")){
				isWinActive=true;
			}
		}
		if(isWinActive){
            if(senderid != 'SysNotice') {
    			countMsgidsArray.push(countMsgItem);
                ChatUtil.savaCountMsg(msgid,senderid,0,'send');
            }
		}else{
			//窗口为非激活状态，count消息id暂时存贮
			var localMsgArray=converMsgList[realTargetid];
			if(!localMsgArray){
				localMsgArray=new Array();
			}
			//client.error("push msgid:"+msgid);
			localMsgArray.push(countMsgItem);
			converMsgList[realTargetid]=localMsgArray;
		}
  	}
  	
  	if(isOfflineMsg){  //补偿消息直接发送count消息
        if(senderid != 'SysNotice') {
  		    countMsgidsArray.push(countMsgItem);
            ChatUtil.savaCountMsg(msgid,senderid,0,'send');
        }
  	}
  	 
  	client.writeLog("-----------收到结束----------");
  	
  	if(message && message.getObjectName() == 'RC:DizNtf'){
  		//通知类消息的处理
  		ChatUtil.handlePublicNotification(message);
  	}else{
	  	if(senderid!=M_USERID){ //非同步消息
	  		/*
	    	var msgid=extraObj.messageid;
			countMsgidsArray.push({"toid":senderid,"msgid":msgid});
			*/
	    }else if(senderid==M_USERID){ //接收到自身同步消息
	    	var msgid=extraObj.messageid;
	    	var receiverids=extraObj.receiverids;
	    	ChatUtil.initMsgRead(msgid,targetType,receiverids,true);
	   }
   }
   //Rdeploy版提醒方式
   remindRdeploy(1);
   
}

//Rdeploy提醒方式
function remindRdeploy(idx){
	if(versionTag == 'rdeploy'){
   		if(typeof top.getModelState == 'function'){
   			var modelstr = 'message';
   			if(idx == 1){
				modelstr = 'message';
			}else if(idx == 2){
				modelstr = 'addrbook';
			}else{
				modelstr = idx+'';
			}
   			var state = top.getModelState(modelstr);
   			if(state.exist && !state.active){
   				top.addRemindSpot(modelstr);
   			}
   		}
   }
}

//显示@提醒
function showRelateddiv(extraObj,targetid,targetType,senderinfo,msgcontent){
  	var msg_at_userid=","+extraObj.msg_at_userid+",";
  	
  	client.error("msg_at_userid:"+msg_at_userid);
  	if(msg_at_userid.indexOf(","+M_USERID+",")!=-1){
  	
  		var senderHead=senderinfo.userHead;
  		var senderName=senderinfo.userName;
  		var chatWinid="chatWin_"+targetType+"_"+targetid;
  		var targetname=$("#"+ getConverId(targetType, targetid)).attr('_targetname');
  		
	  	if($("#"+chatWinid).length==1){
		  		var relateddiv=$("#relatedMsgdiv").show();
		  		relateddiv.find(".userHead").attr("src",senderHead);
		  		relateddiv.find(".relatedContent").html(msgcontent);
				$("#"+chatWinid+" .chatleft").append(relateddiv);
	  	}
	  	
	  	newMsgDeskNotify(targetid,targetType,"["+ targetname +"]",senderHead,senderName+" @<%=SystemEnv.getHtmlLabelName(126985, user.getLanguage())%>");  // 了您
  	}
}

function updateTotalMsgCount(count,flag){
	var isTabact = $(".imToptab .tabitem[_target='recent']").hasClass('activeitem');
	
	var total=0;
	$("#recentListdiv .msgcount").each(function(){
		var count=Number($(this).html());
		count=count?count:0;
		total=total+count;
	});
	var recentmsgcount = $(".imToptab .tabitem .recentmsgcount");
	recentmsgcount.html(total > 99 ? '99+':total);
	if(total>0 && !isTabact){
		recentmsgcount.css("display","block");
	}else{
		recentmsgcount.css("display","none");
	}
	
	var immsgdiv=$("#immsgdiv",parent.document);
	if(immsgdiv.length==0) return ;
	var unreadMsgCount=$("#unreadMsgCount",parent.document);
	var unreadMsgSpan=$("#unreadMsgSpan",parent.document);
	
	var total=0;
	$("#recentListdiv .msgcount").each(function(){
		var count=Number($(this).html());
		count=count?count:0;
		total=total+count;
	});
	
	unreadMsgCount.html(total);
	if(total>0){
		unreadMsgSpan.show();
		immsgdiv.css({"background-image":"url('/social/images/im_d_msg.gif')"});
		//immsgdiv.html("您有新的消息(<span id='unreadMsgCount'>"+total+"</span>)")
	}else{
		immsgdiv.css({"background-image":"url('/social/images/im_msg.png')"});
		unreadMsgSpan.hide();
	}
}

//桌面消息通知
function newMsgDeskNotify(realTargetid,targetType,msgTitle,msgHead,msgContent,flag){

	var chatWin=$("#chatWin_"+targetType+"_"+realTargetid);
	//
	if(($("#addressdiv",parent.document).is(":hidden")||!IMUtil.isWindowActive(window.self))||flag){
		var remindType=ChatUtil.getRemindType(realTargetid);
		if(remindType){
			IMUtil.Notif.notify(msgTitle,msgContent,msgHead,
		  	{
		  		onclick: function(){
		  			IMUtil.Notif.goChatWin(window, realTargetid);
		  		},
		  		onclose: function(){
		  			//console.log("成功关闭");
		  		},
		  		delay: 5000,
		  		title: msgTitle
		  	});
		}
	}
}

//桌面消息通知
function msgDeskNotify(realTargetid,targetType,targetName,targetHead,message){
	var remindType=ChatUtil.getRemindType(realTargetid);
	
	if(remindType){
		var notifyContent=getMsgContent(message);
		if(targetType==0){
			IMUtil.Notif.notify(targetName,notifyContent,targetHead,
		  	{
		  		onclick: function(){
		  			IMUtil.Notif.goChatWin(window, realTargetid);
		  		},
		  		onclose: function(){
		  			//console.log("成功关闭");
		  		},
		  		delay: 5000	
		  	});
		}else{
			ChatUtil.getDiscussionInfo(realTargetid,false,function(discuss){
				targetName=discuss.getName();
				IMUtil.Notif.notify(targetType,targetName,notifyContent,targetHead,
		  	{
		  		onclick: function(){
		  			IMUtil.Notif.goChatWin(window, realTargetid);
		  		},
		  		onclose: function(){
		  			//console.log("成功关闭");
		  		},
		  		delay: 5000	
		  	});
			});
		}
	}
}

function getNoticediv(senderInfo,objName){
	var noticeContent="<%=SystemEnv.getHtmlLabelName(126986, user.getLanguage())%>";  //通知消息
	if(objName=="RC:DizNtf"){
		noticeContent=senderInfo.userName+" <%=SystemEnv.getHtmlLabelName(126987, user.getLanguage())%>";  //退出了群
	}
	var noticediv="<div class='chatItemdiv chatNotice'><span>"+noticeContent+"</span></div>";
	//return noticediv;
	return "";
}

function getConverdiv(converjs){
	var classTag = "converTemp";
	if(versionTag == "rdeploy"){
		classTag += "_rdeploy";
	}
	var converTempdiv=$("."+classTag).clone().removeClass(classTag).show();
	var targetName=converjs.targetname;
	var targetid = converjs.targetid;
	var targettype = converjs.targettype==""?1:converjs.targettype;
	var sendtime=converjs.sendtime;
	var senderid=converjs.senderid;
	var targetHead="";
	//获取群信息
	if(targettype==1){ 
		if(typeof converjs.iconurl==="undefined"||converjs.iconurl ==""){
			targetHead="/social/images/head_group.png";
		}else{
			targetHead="/weaver/weaver.file.FileDownload?fileid="+converjs.iconurl;
		}
	}
	//bing头像
	else if(targettype==3){ 
		targetHead="/social/images/bing_head.png";
	}
	//系统广播特殊处理
    else if(targettype==4){ 
        targetHead="/social/images/sysnotice_head.png";
        //targetid = 'SysNotice';
        //targettype = 0;
        //senderid = 'SysNotice';
    }
    //信息中心(系统提醒)处理
    else if(targettype==5){ 
        targetHead="/social/images/sysremind_head_wev8.png";
    }else if(targettype == 6){//小e
		targetHead="/social/images/icon_smalle.png";
	}
    else{
		targetid.replace("|"+M_UDID).replace(M_UDID+"|");
		try{
			targetHead=getUserInfo(targetid).userHead;
		}catch(e){
			console.error("targetid:"+targetid);
		}
	}
	converTempdiv.find(".targetHead").attr("src",targetHead);
	if(targettype==0){
	//添加个性签名
	var signatures = "";
    try {
		signatures=userInfos[targetid].signatures;
	}catch(err){
		signatures="";
	}
	if(signatures==""){
		converTempdiv.find(".targetName").find(".name").remove();
		converTempdiv.find(".targetName").find(".signatures").remove();
		converTempdiv.find(".targetName").html(targetName);
	}else{
		converTempdiv.find(".targetName").find(".name").html(targetName);
		converTempdiv.find(".targetName").find(".signatures").html(signatures).attr("title",signatures);		
	}
	}else{
		converTempdiv.find(".targetName").html(targetName);
	}
	converTempdiv.attr("id",getConverId(targettype, targetid))
				 .attr("_targetid",targetid)
				 .attr("_targetName",targetName)
				 .attr("_targetHead",targetHead)
				 .attr("_targetType",targettype)
				 .attr("_sendtime", sendtime)
				 .attr("_senderid", senderid);
				 
	converTempdiv.find(".msgcontent").html(IMUtil.htmlEncode(getEmotionText(converjs.msgcontent)));
	converTempdiv.find(".latestTime").html(getFormateTime(sendtime));
	return converTempdiv;
}

function getConverTempdiv(targetid,targetType,senderinfo) {
	var classTag = "converTemp";
	if(versionTag == "rdeploy"){
		classTag += "_rdeploy";
	}
	var converTempdiv=$("."+classTag).clone().removeClass(classTag).show();
	
	var senderid=senderinfo?senderinfo.userid:"";
	
	var targetHead="";
	var targetName="";
	
	if(targetType==0){
		var targetInfo=getUserInfo(targetid);
		targetHead=targetInfo.userHead;
		targetName=targetInfo.userName;
	}
	//bing
	if(targetType == 3){
		targetHead = "/social/images/bing_head.png";
		targetName= "<%=SystemEnv.getHtmlLabelName(126359, user.getLanguage())%>";  //必达
	}
	//系统广播
	if(targetType == 4){
		targetHead = "/social/images/sysnotice_head.png";
		//targetName= "<%=SystemEnv.getHtmlLabelName(127351, user.getLanguage())%>";  //系统广播
		targetName = "系统广播";
	}
	//System alert
	if(targetType == 5){
		targetHead = "/social/images/sysremind_head_wev8.png";
		//targetName= "<%=SystemEnv.getHtmlLabelName(127351, user.getLanguage())%>";  //系统提醒
		targetName = "系统提醒";
	}
	if(targetType == 6){//小e
		targetHead = "/social/images/icon_smalle.png";
		targetName = "小e工作台";
	}
	var converId = getConverId(targetType, targetid);
	converTempdiv.find(".targetHead").attr("src",targetHead);
	//todo
	if(targetType==0){
	//添加个性签名
	var signatures = "";
    try {
		signatures=userInfos[targetid].signatures;
	}catch(err){
		signatures="";
	}
	if(signatures==""){
		converTempdiv.find(".targetName").find(".name").remove();
		converTempdiv.find(".targetName").find(".signatures").remove();
		converTempdiv.find(".targetName").html(targetName);
	}else{
		converTempdiv.find(".targetName").find(".name").html(targetName);
		converTempdiv.find(".targetName").find(".signatures").html(signatures).attr("title",signatures);		
	}
	}else{
		converTempdiv.find(".targetName").html(targetName);
	}
	//converTempdiv.find(".targetName").html(targetName);
	converTempdiv.attr("id",converId).attr("_targetid",targetid).attr("_targetName",targetName)
				 .attr("_targetHead",targetHead).attr("_targetType",targetType).attr("_senderid",senderid);
	
	var conversationType = M_CORE.ConversationType? M_CORE.ConversationType.DISCUSSION: IMClient.ConversationType.DISCUSSION;
	if(targetType==1){
		converTempdiv.hide();
		ChatUtil.getDiscussionInfo(targetid,0,function(discuss){
			
			if(!discuss) return ;

			targetHead="/social/images/head_group.png";
			if(discuss.getIcon&&discuss.getIcon()){
				targetHead='/weaver/weaver.file.FileDownload?fileid='+discuss.getIcon();
			}
			targetName=discuss.getName();
			
			converTempdiv.find(".targetHead").attr("src",targetHead);
			converTempdiv.find(".targetName").html(targetName);
			converTempdiv.show();
			
			converTempdiv.attr("id",converId).attr("_targetid",targetid).attr("_targetName",targetName).attr("_targetHead",targetHead).attr("_targetType",targetType);
			
			var jsconverList = [{
				targetid: targetid,
				targettype: "1",
				msgcontent: converTempdiv.find(".msgcontent").html(),
				sendtime: converTempdiv.attr("_sendtime"),
				targetname:targetName,
				senderid:senderid
			}];
			client.writeLog("conversationTitle:"+targetName);
		});
	}
	
	return converTempdiv;
}

//获取会话id
function getConverId(targettype,targetid){
	//必达
	if(targettype == 3){
		if(targetid == 'bing'){
			targetid = 'bing_'+M_USERID;
		}
		return "conversation_"+targetid;
	}
	//系统广播
    else if(targettype == 4) {
        if(targetid == 'SysNotice'){
            targetid = 'SysNotice_' + M_USERID;
        }
        return "conversation_" + targetid;
    }
    //信息中心
    else if(targettype == 5) {
        if(targetid == 'SysRemind'){
            targetid = 'SysRemind_' + M_USERID;
        }
        return "conversation_" + targetid;
    }
	//小E平台
	else if(targettype == 6){
		return "conversation_" + targetid;
	}
    else{
		return "conversation_"+targetid;
	}
}

function updateConversationList(sendinfo,targetid,targetType,content,sendtime,syncDb){
	$("#recentListdiv .dataloading").hide();
	if(typeof content === 'string' && content.indexOf("###IGNOREME###")!= -1){
		//console && console.warn("捕捉到: "+content);
		return;
	}
	//修复sdk2空格乱码问题
	if(M_SDK_VER!=undefined&&M_SDK_VER==2){
		var reg=new RegExp("&nbsp;","g"); //创建正则RegExp对象 
		if(content!=undefined){
			content= content.replace(reg," "); 
		}
	}
	var converId = getConverId(targetType,targetid);
	var converTempdiv=$("#" + converId);
	
	if(converTempdiv.length==0){
		converTempdiv = getConverTempdiv(targetid, targetType,sendinfo);
	}
	
	localStorage.setItem(targetid, sendtime);
	
	if(targetType==1){
		//content=sendinfo.userName+":"+content;
	}
	var senderid=sendinfo.userid;
	converTempdiv.attr("_senderid",senderid);
	converTempdiv.attr("_sendtime",sendtime);
	converTempdiv.find(".msgcontent").text(content);
	ChatUtil.imFaceFormate(converTempdiv.find(".msgcontent"));
	var sendftime=getFormateTime(sendtime);
	converTempdiv.find(".latestTime").text(sendftime);
	
	$("#recentListdiv").prepend(converTempdiv);
    
	$("#recentListdiv").scrollTop(0);
	if(versionTag=="rdeploy"){
		IM_Ext.updateSearchConverList(targetid);
	}
	//同步会话到本地数据库
	var jsconverList = [{
		senderid:senderid,
		targetid: targetid,
		targettype: targetType,
		msgcontent: content,
		sendtime: sendtime,
		targetname: converTempdiv.attr("_targetname")
	}];
	if(syncDb)
		ChatUtil.syncConversToLocal(jsconverList);
    if(targetType ==6 && targetid =="notice_-1"){
		jsconverList[0].receiverids = M_USERID;
		jsconverList[0].senderid = -1;
		ChatUtil.syncConversToLocal(jsconverList,true);
	}
	
	converTempdiv.show();
	if(targetType==0){
	   if(IS_BASE_ON_OPENFIRE){
       var chatWin = $('#chatWin_0_'+targetid);
       if(chatWin.length<=0){
           var memArr = new Array();
            memArr.push(targetid);
            OnLineStatusUtil.getUserOnlineStatus(memArr);
       }
       }  
     }
	return converTempdiv;
}

//获取最近联系人
var loadConverFinish=false; //记录会话加载状态
var loadLocalConverFinish=false; //加载本地会话完成
var isSyncLatestMsg=false; //是否已经同步过最后一条消息
var converCount=0; //记录有效会话总数
var sortCountList=new Array();
var converList=new Array();

function getConversationList(){
	
	if(!M_ISRECONNECT){ //非重新连接状态下
		if(loadLocalConverFinish){ //本地是否加载完成
			client.error("getConversationList 加载本地会话");
			getConverLatestMsg();//获取会话最后一条消息
		}
	}
	
	//return;
	client.getConversationList(function(conversationList){
		client.writeLog('已同步',conversationList);
        
		for (var i = 0; i <conversationList.length; i++) {
			
			var conversation=conversationList[i];
			
			var targetid = ('targetId' in conversation)?conversation.targetId:conversation.getTargetId();
			var conversationTitle = ('conversationTitle' in conversation)?conversation.conversationTitle: conversation.getConversationTitle(); //会话标题
			var conversationType = ('conversationType' in conversation)?conversation.conversationType: conversation.getConversationType(); //会话类型
			var unreadMsgCount = ('unreadMessageCount' in conversation)?conversation.unreadMessageCount: conversation.getUnreadMessageCount(); //未读消息数量
			var latestTime = ('sentTime' in conversation)?conversation.sentTime: conversation.getSentTime();
			unreadMsgCount=0;
			
			client.writeLog("===============会话记录==============");
			//var targetType=conversationType;
			
			client.writeLog("conversationType:"+conversationType);
			client.writeLog("conversationTitle:"+conversationTitle);
			client.writeLog("unreadMsgCount:"+unreadMsgCount);
			
			if (!conversationTitle) continue;
			
			var targetType=client.getTargetType(conversationType,targetid); //0：单聊 1:群聊 -1：其他	
			
			var realTargetid=getRealUserId(targetid); //获取实际id,人员为id
			
			if(realTargetid=='syncUser'||realTargetid=="1"){
			   client.error("过滤同步会话syncUser");
			   continue ;
			}
			
			var senderName="";
			var senderHead="";
			var targetName=""; //聊天对象名称
			var targetHead=""; //聊天对象图标
			
			client.writeLog("targetType:"+targetType);
		    client.writeLog("targetid:"+targetid);
		    client.writeLog("realTargetid:"+realTargetid);
			
			if(targetType==0&&realTargetid!="undefined"){
				try{
					conversationTitle=getUserInfo(realTargetid).userName;
				}catch(e){
					conversationTitle="";
					client.writeLog("realTargetid error realTargetid:"+realTargetid);
				}
			}
			var message = conversation.latestMessage?conversation.latestMessage: conversation.getLatestMessage();
			client.writeLog("message:"+message);
			if(ClientSet.ifForbitGroupChat == '1' && targetType == 1){
				continue;
			}
			if(targetType>-1&&message&&conversationTitle!=""){  //获取发送人信息
			
				$("#recentListdiv .dataloading").hide(); //隐藏loading
				//if($("#conversation_"+realTargetid).length==1) continue ;
			
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
				
				client.writeLog("senderName:"+senderName);
				client.writeLog("senderHead:"+senderHead);
				
				if(targetType==1){ //获取群信息
					targetHead="/social/images/head_group.png";
					content=senderName+":"+content;
				}else{
					targetHead=getUserInfo(realTargetid).userHead;
				}
				
				var converTempdiv=$("#"+ getConverId(targetType,realTargetid));
				if(converTempdiv.length==0){
					if(versionTag == "rdeploy"){
						converTempdiv = $(".converTemp_rdeploy").clone().removeClass("converTemp_rdeploy");
					}else
						converTempdiv=$(".converTemp").clone().removeClass("converTemp");
					converTempdiv.hide();
					$("#recentListdiv").append(converTempdiv);
				}
				client.error("targetName:"+targetName);
				converTempdiv.find(".targetHead").attr("src",targetHead);
				converTempdiv.find(".targetName").html(targetName);
				//converTempdiv.find(".msgcontent").html(content);
				//converTempdiv.find(".latestTime").html(sendtime);
				
				if(unreadMsgCount>0){
					if(unreadMsgCount>99) unreadMsgCount="99+";
					converTempdiv.find(".msgcount").html(unreadMsgCount).css({"display":"block"});
				}	
				converTempdiv.attr("id",getConverId(targetType, realTargetid))
							 .attr("_targetid",realTargetid)
							 .attr("_targetName",targetName)
							 .attr("_targetHead",targetHead)
							 .attr("_targetType",targetType)
							 .attr("_sendtime", latestTime);
				
				converCount++;
				converList.push({"targetid":realTargetid,"targetType":targetType,"targetName":targetName,"sendtime":latestTime});
				
			}
		}
		
		loadConverFinish=true;
		
		for (var i = 0; i <converList.length; i++) {
    		var conver = converList[i];
    		var targetid=conver.targetid;
    		var targetType=conver.targetType;
    		var targetName=conver.targetName;
    		//if(M_SDK_VER == "1") {
    			ChatUtil.getLatestMessage(targetid,targetType,targetName);
    		//}
    	}
    	
		$("#recentListdiv").find('.dataloading').hide();
		//$("#recentListdiv .chatItem").fadeIn();
	});
	//屏蔽上下文菜单
	//document.oncontextmenu = function(){return false;};
}

//获取会话最后一条消息
function getConverLatestMsg(){
    if(IS_BASE_ON_OPENFIRE) return;  //openfire不走此逻辑

	if(isSyncLatestMsg){ //已经同步过最后一条消息
		return ;
	}
	
	var converIteams=$("#recentListdiv .chatItem[_targettype!='3']");
	converCount=converIteams.length;
	
	converIteams.each(function(){
	
    	converdiv=$(this);
    	var targetid = converdiv.attr("_targetid");
    	var targettype = converdiv.attr("_targettype");
    	var targetname = converdiv.attr("_targetname");
    	
		if(targettype!="3"){
			//if(M_SDK_VER == "1") {
				ChatUtil.getLatestMessage(targetid,targettype,targetname);
			//}
    	}
    });
    
    loadConverFinish=true;
}

//合并会话列表
function mergeConverList(){

	var remoteConverList = sortCountList;
	var mergedList = [];
	var tempids = localconverids;
	
	client.error("remoteConverList.length:"+remoteConverList.length);
	client.error("localconverList.length:"+localconverList.length);
	
	for(var i = 0; i < remoteConverList.length; ++i){
		var index = $.inArray(remoteConverList[i], mergedList);
		if(index == -1){
			mergedList.push(remoteConverList[i]);
		}
	}
	for(var j = 0; j < localconverList.length; ++j){
		var index = $.inArray(localconverList[j], mergedList);
		if(index == -1){
			mergedList.push(localconverList[j]);
		}
	}
	return mergedList;
}

//会话列表排序
function sortConversation(){
	
	var mergedList =new Array();
    
    $("#recentListdiv .chatItem").each(function(){
    	
    	var converdiv=$(this);
    	var targetid = converdiv.attr("_targetid");
    	var msgcontent = converdiv.find(".msgcontent").html();
    	var targettype = converdiv.attr("_targettype");
    	var targetname = converdiv.attr("_targetname");
    	var sendtime = converdiv.attr("_sendtime");
    	var senderid = converdiv.attr("_senderid");
    	
    	mergedList.push({"targetid":targetid,"targettype":targettype,"targetname":targetname,"msgcontent":msgcontent,"sendtime":sendtime,"senderid":senderid});
    	
    });
    
    var len = mergedList.length,i,j, d;
    for(i = len - 1; i > 0; --i){
    	for(j = 0; j < i; ++j){
    		 if (mergedList[i].sendtime < mergedList[j].sendtime) {
                d = mergedList[j];
                mergedList[j] = mergedList[i];
                mergedList[i] = d;
            }
    	}
    }
    var jsconverList = [];
    for (var i = len-1; i >=0; i--) {
    	var conver = mergedList[i];
    	var converdiv = $("#"+ getConverId(conver.targettype, conver.targetid));
    	$("#recentListdiv").append(converdiv);
    }
    
    //同步会话到本地数据库
	//ChatUtil.syncConversToLocal(mergedList);
	if(versionTag=="rdeploy"){
		IM_Ext.getIMAttention(mergedList);
		IM_Ext.getSearchConverList(mergedList);
	}
    return sortCountList;
}

//加载本地会话
function loadLocalConvers(version){
	var url=getPostUrl("/social/im/SocialIMOperation.jsp?operation=getConvers");
	$.post(url,function(data){
  		for(var i=0;i<data.length;i++){
  			converjs=data[i];
  			var targetid=converjs.targetid;
  			var targettype=converjs.targettype;
  			//同步个性签名
            if(targettype==0){
                ChatUtil.updateSignatureHandle(targetid);
                if(IS_BASE_ON_OPENFIRE){
                    SOCIAL_GLOBAL.OnlineStatus.M_ALLUSERSTATUS.push(targetid);
                }
            }
  			//屏蔽‘系统提醒’
  			if(targettype == '5'){
  				continue;
  			}
  			if(ClientSet.ifForbitGroupChat == '1' && targettype == '1'){
  				continue;
  			}
			if(IS_BASE_ON_OPENFIRE && targettype == '1' && converjs.isopenfire != "" && converjs.isopenfire == '0'){
                continue;
			}
            if(!IS_BASE_ON_OPENFIRE && targettype == '1' && converjs.isopenfire != "" && converjs.isopenfire == '1'){
                continue;
            }
			if(targettype=="100"){
				continue;
			}
  			//关闭必达会话
  			if(version=="rdeploy"){
  				//if(targetid.indexOf("bing_")!=-1) continue ;
  			}
  			if($("#"+ getConverId(converjs.targettype, converjs.targetid)).length==0){
  				var converTempdiv = getConverdiv(converjs);
                if(!IS_BASE_ON_OPENFIRE) {  // 融云的话，群组通过历史消息判断有无
                    if(converjs.targettype==1){
                        // converTempdiv.hide();
                    }
                } else {
                    var converObj={"targetid":converjs.targetid,"targetType":converjs.targettype,"targetName":converjs.targetname,"sendtime":converjs.sendtime};
                    sortCountList.push(converObj);
                }
				$("#recentListdiv").append(converTempdiv);
			}
  		}
  		$("#recentListdiv .dataloading").hide();
		//增加获取我的关注 1201 by wyw
		if(versionTag == 'rdeploy'){
			IM_Ext.getIMAttention(data);
		}
		loadLocalConverFinish=true;
		var handle = setInterval(function(){
			if(M_SERVERSTATUS){
				clearInterval(handle);
				client.error("loadLocalConvers 加载本地会话");
                if(!IS_BASE_ON_OPENFIRE) {  // 融云的话，群组通过历史消息判断有无
				    getConverLatestMsg();
                }
			}
		}, 150);
  	},"json");
}

function updateLatestMessage(targetid,targettype,message){

	var converTempdiv=$("#"+ getConverId(targettype, targetid));
	
	var content=getMsgContent(message);
	var senderUserid=message.getSenderUserId(); //发送人id
	var senderid=getRealUserId(senderUserid); //发送人id
	var senderInfo=getUserInfo(senderid);
	var senderName=senderInfo.userName;
	var senderHead=senderInfo.userHead;
	var senddate=getFormateTime(message.getSentTime());
	var sendtime=message.getSentTime();
	
	var latestTime=Number(converTempdiv.attr("_sendtime"));
	var targettype=converTempdiv.attr("_targettype");
	var targetname=converTempdiv.attr("_targetname");
	var msgcontent=senderName+":"+content;
	
	converTempdiv.find(".msgcontent").html(IMUtil.htmlEncode(msgcontent));
	converTempdiv.find(".latestTime").html(senddate);
	converTempdiv.attr("_sendtime",sendtime);

	converTempdiv.attr("_senderid",senderid);
	converTempdiv.show();
	
	client.error("同步本地会话 targetid:"+targetid+" sendtime:"+sendtime+" latestTime:"+latestTime+" isSync:"+(sendtime!=latestTime));

	//if(targetid=='955f9c3b-0e0b-49d7-947b-9e69ff63fdaf'||targetid=='a0758d95-9479-4742-add4-c819d53ae9e4')
	//if(sendtime!=latestTime){
	if(true){
		var resourceids=ChatUtil.getMemberids(targettype,targetid,true);
		var jsconverList = [{
			senderid:senderid,
			targetid: targetid,
			targettype: targettype,
			msgcontent: msgcontent,
			sendtime: sendtime,
			targetname:targetname,
			receiverids:resourceids
		}];
		if(targettype==1){
			ChatUtil.getDiscussionInfo(targetid,true,function(discussion){
				if(discussion){
					
					$("#conversation_"+targetid).show();
					
					//$('#recentListdiv').perfectScrollbar("update");
					
					resourceids=ChatUtil.getMemberids(targettype,targetid,true);
					
					if(targetname==discussion.getName()&&sendtime==latestTime){
						return ;
					}
					
					targetname=discussion.getName();
					refreshDiscussName(discussion); //重新刷新标题
					
					client.error("targetid:"+targetid+" resourceids:"+resourceids+" memberids:"+discussion.getMemberIdList()+"   discussion:"+discussion);
					
					jsconverList[0]["targetname"]=targetname;
					jsconverList[0]["receiverids"]=resourceids;
					
					ChatUtil.syncConversToLocal(jsconverList);
					
				}else{
					 client.error("delete discussion "+targetid);
					 //closeTabWin($("#chatTab_1_"+targetid+" .tabClostBtn"));
					 //$("#conversation_"+targetid).remove();

				}
			});
		}else{
			if(sendtime!=latestTime){
				ChatUtil.syncConversToLocal(jsconverList);
			}
		}
	}
}

function getFormateTime(latestTime){

	var date = new Date();
	var currentFullYear = date.getFullYear();
	var datePattern = "MM-dd";
	date.setTime(latestTime);
	
	var today=new Date();
	var tomorrow=new Date();
	tomorrow.setDate(tomorrow.getDate()-1);
	
	var tomorrowdate=tomorrow.pattern("yyyy-MM-dd");
	var todaydate=new Date().pattern("yyyy-MM-dd");
	var senddate=date.pattern("yyyy-MM-dd");
	var year=Number(date.pattern("yyyy"));
	if(year < currentFullYear){
		datePattern = "yyyy-MM-dd";
	}
	
	if(senddate==todaydate){
		sendtime=date.pattern("HH:mm");
	}else if(senddate==tomorrowdate){
		sendtime="<%=SystemEnv.getHtmlLabelName(82640, user.getLanguage())%>";  //昨天
	}else{
		sendtime=date.pattern(datePattern);
	}
	
	return sendtime;
}

function initScrollBar(targetType,realTargetid,pagesize){

	var chatWinid="chatWin_"+targetType+"_"+realTargetid;
	var chatListdiv=$("#"+chatWinid).find('.chatList');
	var chatWin = $("#"+chatWinid);
    $(chatListdiv).bind('mousewheel', function(event,delta, deltax, deltay){
    	var $this = $(this);
    	var scrollTop = $this.perfectScrollbar("getScrollTop");
    	var delta = IMUtil.getDeltaValue(event);
        //是否有下一页
        var isHasNext=chatListdiv.attr("_isHasNext"); 
        //一次数据是否加载完成
        var isFinish=chatListdiv.attr("_isFinish"); 
        
        if(delta > 0 && scrollTop<=20 && isFinish=="1" && isHasNext=="1"){
        	chatListdiv.attr("_isFinish","0"); //设置为加载完成状态
        	chatListdiv.find('.loadmorediv').hide();
        	IMUtil.showLoading($this, ChatUtil.settings.mystyle1,"", 1000,function(){
        		ChatUtil.getHistoryMessages(targetType,realTargetid,pagesize,false);
        	});
        }
        //滚动到上一次阅读的位置自动消除掉阅读提示
        if(delta > 0){
        	checkReadPosition(chatWinid);
        }else if(isScrollBottom(chatListdiv)){
        	$('#relatedMsgdiv_bottom_'+realTargetid).remove();
        }
        return false;
    });
 
 } 
 
 //检查聊天窗口阅读位置
 function checkReadPosition(chatWinId){
 	var chatWin = $("#"+chatWinId);
 	var chatListdiv = chatWin.find(".chatList");
 	var chatitemid = chatWin.attr("anchorTopId");
	var _temp = chatListdiv.find("#"+chatitemid);
	if(_temp.length > 0){
		var chatListDivCord = IMUtil.getDomCord(chatListdiv, false);
		var chatItemDivCord = IMUtil.getDomCord(_temp, false);
		if(chatItemDivCord.top + _temp.outerHeight() >= chatListDivCord.top){
			var floatmsgid = chatWinId+"_floatmsg";
			chatWin.find("#"+floatmsgid).off().remove();
			chatWin.find(".chatList").css("top", "61px");
			chatWin.removeAttr("anchorTopId");
		}
	}
 }
 
 //显示聊天表情 
 function drawExpressionWrap(targetid) {
        var RongIMexpressionObj = $("#chatdiv_"+targetid+" .RongIMexpressionWrap");
        
        if(M_SDK_VER == "2") {
        	var arrImgList = IMClient.RongIMEmoji.emojis, bElem, faceCode;
        	if (arrImgList && arrImgList.length > 0) {
                for (var i = 0; i < arrImgList.length; ++i) {
                    var newSpan = arrImgList[i];
                    if (!newSpan) {
                        continue;
                    };
                    faceCode = newSpan.firstChild.getAttribute("name");
                    faceCode = faceCode.substring(1, faceCode.length - 1);
                    bElem = newSpan.firstChild.firstChild;
                    // mac下bElem取的是text
                    try{
			            bElem.setAttribute("contenteditable","false");
			            bElem.setAttribute("unselectable","off");
			            bElem.setAttribute("alt",faceCode);
			            bElem.setAttribute("title",faceCode);
			        } catch(e) {}
                    RongIMexpressionObj.append(newSpan.innerHTML);
                }
            }
            
        }else {
        	var arrImgList = RongIMClient.Expression.getAllExpression(128, 0);
            if (arrImgList && arrImgList.length > 0) {
                for (var objArr in arrImgList) {    //扩展 Array prototype 使用for in问题
                    var imgObj = arrImgList[objArr].img;
                    if (!imgObj) {
                        continue;
                    };
                    imgObj.setAttribute("alt", arrImgList[objArr].chineseName);
                    imgObj.setAttribute("title", arrImgList[objArr].chineseName);
                    var newSpan = $('<span class="RongIMexpression_' + arrImgList[objArr].englishName + '"></span>');
                    newSpan.append(imgObj);
                    RongIMexpressionObj.append(newSpan);
                }
            }
        }
        $("#chatdiv_"+targetid+" .RongIMexpressionWrap>span").bind('click', function (event) {
			if($("#chatcontent_"+targetid+" .modehint").length > 0){
				$("#chatcontent_"+targetid).empty();
			}
			
			//光标处插入
			var dom = $("#chatcontent_"+targetid)[0];
			$(this).find('.RC_Expression').attr({'tabindex': '-1', 'draggable': 'true'});
			var expHtml = $(this).html();
			var curPos = IMUtil.cache.cursorPos;
			if(typeof isIE === 'function' && isIE()) {
				$(dom).append(expHtml);
			}else{
				IMUtil.insertHtmlAtPos(dom, curPos, expHtml, true);
			}
			$(".popBox").hide();
			stopEvent();
			dom.focus();
         });
};

function getFormteMsgContent(message){

	var content=message.getContent();
	var messageType=message.getMessageType();
	var objName = message.getObjectName();
	
	if(messageType==1){
		content=ChatUtil.receiveMsgFormate(content); //接收消息格式化处理
	}else if(messageType==2){
		/*
		var imageUrl=message.getImageUri();
		var imageFrom=imageUrl.indexOf("rongcloud-image.ronghub.com")!=-1?"mobile":"";
		content='<img _imageUrl='+imageUrl+' src="data:image/jpg;base64,'+content+'"/>';
		*/
	}else if(messageType==3){
		/*
		content="[音频]";
		content=message.getContent();
		*/
	}else if(messageType==4){
		content="[<%=SystemEnv.getHtmlLabelName(81638, user.getLanguage())%>]";  //图文
	}else if(messageType==6){
		/*
		var objName = message.getObjectName();
		if(objName =="RC:PublicNoticeMsg"||objName=="FW:attachmentMsg"){ //公告
			content=ChatUtil.receiveMsgFormate(content); //接收消息格式化处理
		}else{
			//content="objName："+objName;
		}
		*/	
	}else if(messageType==8){
		var latitude=message.getLatitude();
		var longitude=message.getLongitude();
		var poi=message.getPoi();
		content='<div class="locationdiv" onclick="ChatUtil.showIMLocation(\''+latitude+'\',\''+longitude+'\',\''+poi+'\')">'+
				'	<img class="locationimg" src="data:image/jpg;base64,'+content+'"/>'+
				'	<div class="locationpoi">'+poi+'</div>'+
				'</div>';
		client.writeLog("latitude:"+latitude+" longitude:"+longitude+" poi:"+poi);
	}else{
		/*
		if(objName=="RC:DizNtf"){
			content="退出了群";
		}else{
			content="消息类型："+messageType;
		}
		*/
	}
	return content;
}

//将文本格式化为表情
function initEmotion(str) {
	try{
		if(M_SDK_VER == 2){
			return str;
		}
		var a = document.createElement("span");
	    return RongIMClient.Expression.retrievalEmoji(str, function (img) {
	        a.appendChild(img.img);
	        var str = '<span class="RongIMexpression_' + img.englishName + '">' + a.innerHTML + '</span>';
	        a.innerHTML = "";
	        return str;
	    });
    }catch(e){
    	console.log(e);
    	return str;
    }
}

//将文本转换为表情字符
function getEmotionObj(str) {
	str = str.replace(/\[.+?\]/g, function (x) {
		if(M_SDK_VER == '2'){
			return  IMClient.RongIMEmoji.symbolToEmoji(x);
		}
        return M_CORE.Expression.getEmojiObjByEnglishNameOrChineseName(x.slice(1, x.length - 1)).tag || x; 
    });
    return str;
}

//将表情格式化为文本
function getEmotionText(str){
	try{
		if(M_SDK_VER == 2){
			return IMClient.RongIMEmoji.emojiToSymbol(str);
		}
		return M_CORE.Expression.retrievalEmoji(str, function (img) {
	        return "["+img.chineseName+"]";
	    });
    }catch(e){
    	console.log(e);
    	return str;
    }
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
		if(_targettype == 1 || _targettype == 0||_targettype==6)
			ChatUtil.removeThisConversation(_targettype, _targetid);
	break;
	}
	//alert($('.rightMenudiv').length);
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
						   	{ menuName: "<%=SystemEnv.getHtmlLabelName(126988, user.getLanguage())%>", clickfunc: "onRMenuClick(this, '2')"}  //从最近列表中移除
						  ],
				left: e.clientX,
				top: e.clientY
			};
			//从obj绑定的参数中获知是否是置顶会话
			//demo
			if($(obj).attr('_istop')) options.menuList[0].menuName = "<%=SystemEnv.getHtmlLabelName(24675, user.getLanguage())%>";  //取消置顶
			var targettype = $(obj).attr('_targettype');
            var targetid = $(obj).attr('_targetid');
			if(targettype == 3 || targetid == 'SysNotice'){
				return;
			}
			showRightMenu(obj, options);
		break;
		case 1:		//单击	
			//记录时间戳
			var curClicktime = new Date().getTime();
			var lastClicktime = $(obj).attr('_lastclicktime');
			if(!lastClicktime){
				lastClicktime = curClicktime;
			}
			$(obj).attr('_lastclicktime', curClicktime);
			if(curClicktime - lastClicktime < 120000){
				stopEvent();
			}
			if(!client){
				alert("尚未连接到消息服务器，请稍后重试");
			}
		break;
	}
}

//显示会话聊天窗口
function showConverChatpanel(obj, _paramsObj){
	var targetid = "",targetName ="",targetHead="",targetType="",count="";
	var lastActiveChatItem = $("#recentListdiv .activeChatItem");
	if($(obj).length > 0){
		targetid=$(obj).attr("_targetid");
		targetName=$(obj).attr("_targetName");
		targetHead=$(obj).attr("_targetHead");
		targetType=$(obj).attr("_targetType");
		var msgcount=$(obj).find(".msgcount");
		msgcount.html(0).hide();
		count=Number(msgcount.html());
		$(obj).addClass("activeChatItem");
		$("#imMainbox .chatItem").removeClass("activeChatItem");
		$(obj).data('timerid', timerid);
	}else if(_paramsObj){
		targetid=_paramsObj.targetId;
		targetName=_paramsObj.targetName;
		targetHead=_paramsObj.targetHead;
		targetType=_paramsObj.targetType;
		count=_paramsObj.msgCount?_paramObj.msgCount:0;
	}
		//主次切换账号	
	if(targetType==0 && ClientSet.multiAccountMsg==1){
		var _recentListdiv ="";
		if( $(obj).parent().length>0){
			_recentListdiv = $(obj).parent().attr('id');
		}
		if(_recentListdiv!="recentListdiv"){
			var parentAccountid = AccountUtil.accountBelongTO[targetid];
			if(typeof parentAccountid !="undefined"){
				obj = null;
				var  parentAccountInfo = getUserInfo(parentAccountid);
				if(!!!_paramsObj){
					_paramsObj ={};
				}
				targetid=_paramsObj.targetId=parentAccountid;
				targetName=_paramsObj.targetName=parentAccountInfo.userName;
				targetHead=_paramsObj.targetHead=parentAccountInfo.userHead;
				_paramsObj.targetType = 0;
			}
		}
		
	}
	var timerid = setTimeout(function(){
	  	updateTotalMsgCount(count,'del');
		//更新群设置信息
		if(targetType==3){
			 //必达
			showIMChatpanel(3,'bing','<%=SystemEnv.getHtmlLabelName(126359, user.getLanguage())%>','/social/images/bing_head.png'); 
		}else if(targetType==4){
			showIMChatpanel(4,'SysNotice','广播','/social/images/sysnotice_head.png'); 
		}else if(targetType==5){
			showIMChatpanel(5,'SysRemind','系统提醒','/social/images/sysremind_head_wev8.png'); 
		}else if(targetType==6){
			showIMChatpanel(6,'notice_-1','小e工作台','/social/images/icon_smalle.png'); 
		}else{
			ChatUtil.setCurDiscussInfo(targetid, targetType);
		  	clearMessagesUnreadStatus(targetType,targetid);//清除未读消息
		  	showIMChatpanel(targetType, targetid,targetName,targetHead);
		}
		//处理滚动条
		var _target = $('#imMainbox .activeitem').attr('_target');
		setToTopScroller(_target);
        
        // 特殊聊天类型：如群广播 等对聊天面板的处理
        setIMChatPanel(obj,_paramsObj);
        
        // pc对聊天面板的处理
        setIMChatPanelOfPc(obj,_paramsObj);
        
        //console.warn("当前窗口："+targetid + " "+targetType);
        // 发送端已读消息
        ChatUtil.sendClearUnreadCountMsg(targetid, targetType);
        ChatUtil.curEnterSet = $.isEmptyObject(WebAndpcConfig)? 1: typeof WebAndpcConfig.sendType ==="undefined"? 1:WebAndpcConfig.sendType;
        if(lastActiveChatItem && lastActiveChatItem.length > 0 && lastActiveChatItem.attr('_targetid') !== targetid){
        	//console.warn("上一个窗口："+lastActiveChatItem.attr('_targetid')+" "+lastActiveChatItem.attr('_targettype'));
        	ChatUtil.sendClearUnreadCountMsg(lastActiveChatItem.attr('_targetid'), lastActiveChatItem.attr('_targettype'));
        }
        if(targetType==0){
            if(IS_BASE_ON_OPENFIRE){
            var memArr = new Array();
            memArr.push(targetid);
            OnLineStatusUtil.getUserOnlineStatus(memArr); 
            }  
        }
	}, 100);
}

function setIMChatPanel(obj, _paramObj){
	var targetId='', targetType='';
	if($(obj).length > 0){
		targetId=$(obj).attr("_targetid");
		targetType=$(obj).attr("_targetType");
	}else if(_paramObj){
		targetId = _paramObj.targetId;
		targetType = _paramObj.targetType;
	}
    if(targetId == 'SysNotice') {
        var $chatWin = $('#chatWin_' + targetType + '_' + targetId);
        $chatWin.find('.imtitleName').unbind('click');
        $chatWin.find('.contactPhone').hide();
        $chatWin.find('.imSetting').hide();
    }
}

// pc端对聊天面板处理
function setIMChatPanelOfPc(obj, _paramObj) {
	var targetId='', targetType='';
	if($(obj).length > 0){
		targetId=$(obj).attr("_targetid");
		targetType=$(obj).attr("_targetType");
	}else if(_paramObj){
		targetId = _paramObj.targetId;
		targetType = _paramObj.targetType;
	}
    // pc端对工具栏处理
    if(ChatUtil.isFromPc()) {
        PcGlobalShortcutUtils.setScreenshotTitle();  // 设置 截图 按钮的title
        if(targetType == 0 && targetId != M_USERID && targetId != 'SysNotice') {  // 单聊显示抖一抖
            var $chatWin = $('#chatWin_' + targetType + '_' + targetId);
            $chatWin.find('div[type="shakeWindow_div"]').show();
            $chatWin.find('div[type="sendDir_div"]').show();
        }
    }
    
    var chatWinid="chatWin_"+targetType+"_"+targetId;
	var chatwin = $("#"+chatWinid);
    if(targetType==0){
	//添加个性签名
	var signatures = "";
    try {
		signatures=userInfos[targetId].signatures;
	}catch(err){
		signatures="";
	}
	if(signatures==""){
		chatwin.find(".chattop").children(".signatures").text("暂无个性签名").attr('title',"暂无个性签名");
	}else{
		chatwin.find(".chattop").children(".signatures").text(signatures).attr('title',signatures);
	}
	}

}

//检查消除未读状态
function checkClearUnreadStatus(_win){
	var chatwin = $(_win.document.body).find(".chatWin:visible");
	var targetid = chatwin.attr("_targetid");
	var targettype = chatwin.attr("_targettype");
	if(chatwin.length > 0){
		//$("#conversation_"+targetid).click();
		sendLocalCountMsg(targetid);
        var msgcount=$("#"+ getConverId(targettype, targetid)).find(".msgcount");
        var count=Number(msgcount.html());
        msgcount.html(0).hide();
        msgcount=$("#chatTab_"+targettype+"_"+targetid).find(".msgcount");
        msgcount.html(0).hide();
	}
	
	
}

function clearMessagesUnreadStatus(targetType,targetId){
	client && client.writeLog("targetType:"+targetType+" targetId:"+targetId);
	client.clearMessagesUnreadStatus(targetType,targetId);	
}


//获得消息内容
function getMsgContent(message,msgObj){
	var content="";
	var objName="";
	var messageType="";
	try{
		if(message){
			content=message.getContent();
			objName = message.getObjectName();
			messageType=message.getMessageType();
			extra=message.getExtra();
		}else{
			content=msgObj.content;
			objName = msgObj.objectName;
			messageType=msgObj.msgType;
			extra=msgObj.extra;
		}
		
		//alert("objName:"+objName+" content:"+content+" extra:"+extra);
		
		if (message && message.getObjectName() == 'RC:DizNtf') {
			var senderUserid=message.getSenderUserId(); //发送人id
			var senderid=getRealUserId(senderUserid); //发送人id
			var senderInfo=getUserInfo(senderid);
            content=ChatUtil.getNotifiContent(senderInfo,message);
		}else{
			if(messageType==1){
				content=getEmotionText(content);
				content=content.replace(/\n/g,"");
			}else if(messageType==2){
				content="[<%=SystemEnv.getHtmlLabelName(74, user.getLanguage())%>]";  //图片
			}else if(messageType==3){
				content="[<%=SystemEnv.getHtmlLabelName(126989, user.getLanguage())%>]";  //音频
			}else if(messageType==4){
				content="[<%=SystemEnv.getHtmlLabelName(81638, user.getLanguage())%>]";  //图文
			}else if(messageType==6){
				if("RC:PublicNoticeMsg" == objName){ //公告
					content="[<%=SystemEnv.getHtmlLabelName(23666, user.getLanguage())%>]"+content.replace(/\n/g,"");  //公告
				}else if(objName=="FW:attachmentMsg"){ //附件
					var extraObj;
					try{
						if(!extra) extra="";
						extraObj=eval("("+extra+")");
						content="[<%=SystemEnv.getHtmlLabelName(156, user.getLanguage())%>]"+content;  //附件
					}catch(e){
						if(content!=""){
							var contents=content.split("|");
							content="[<%=SystemEnv.getHtmlLabelName(156, user.getLanguage())%>]"+contents[0];  //附件
						}
					}
				}else if(objName=="FW:CustomShareMsg"||objName=="FW:CustomShareMsgVote"){ //分享
					var sharetitle = content;
					var extraObj;
					try{
						if(!extra) extra="";
						extraObj=eval("("+extra+")");
						if(typeof  extraObj.sharetype ==='string' && extraObj.sharetype == 'crm'){
							content="[<%=SystemEnv.getHtmlLabelName(136, user.getLanguage())%>]"+IMUtil.cleanBR(extraObj.sharetitle);  //客户
						}else if(typeof  extraObj.sharetype ==='string' && extraObj.sharetype == 'vote'){
							content="[投票]"+IMUtil.cleanBR(extraObj.sharetitle);  //投票
						}else {							
							content="[<%=SystemEnv.getHtmlLabelName(126091, user.getLanguage())%>]"+IMUtil.cleanBR(extraObj.sharetitle);  //分享
						}
					}catch(e){
						extra=content;
						extraObj=eval("("+extra+")");
						content="[<%=SystemEnv.getHtmlLabelName(126091, user.getLanguage())%>]"+IMUtil.cleanBR(extraObj.sharetitle);  //分享
					}
				}else if(objName=="FW:PersonCardMsg"){ //名片
					
					var extraObj=eval("("+extra+")");
					var hrmid=extraObj.hrmCardid;
					
					content="[<%=SystemEnv.getHtmlLabelName(126356, user.getLanguage())%>]"+content;  //名片
				}else if(objName=="FW:richTextMsg"){ //图文
					
					content="[<%=SystemEnv.getHtmlLabelName(81638, user.getLanguage())%>]"+content;  //图文
				}
                else if(objName == "FW:CustomMsg") {  // 自定义消息
                    var senderId = message ? message.getSenderUserId().split('|')[0] : M_USERID;
                    var customObj = getFwCustomMsgContent(senderId, content, extra);
                    content = customObj.content;
                }else if(objName == "RC:InfoNtfVote"){
					try{
						var extraobj = eval("("+extra+")")
						if(extraobj.notiType == "noti_voteDeadline"){
							content = "[投票]"+extraobj.sharetitle+"即将截止";
						}else if(extraobj.notiType == "noti_vote"){
							content = "参与了投票"+extraobj.content;
						}
						
						}catch(e){}

				}
				else if(objName.toLowerCase().indexOf('rc:infontf:withdraw') != -1){
					var senderId = message ? message.getSenderUserId().split('|')[0] : M_USERID;
					var senderName = userInfos[senderId].userName;
					content=(senderId == M_USERID? "你" : senderName)+"撤回了一条消息";
				} 
                else{
                	content="<%=SystemEnv.getHtmlLabelName(126958, user.getLanguage())%>";  //该版本暂不支持此消息
					content="###IGNOREME###"+objName
				}
			}else if(messageType==8){
				content="[<%=SystemEnv.getHtmlLabelName(22981, user.getLanguage())%>]";  //位置
			}else if(messageType==9){
				content="撤回一条消息";  //通知
			}else{
				content="<%=SystemEnv.getHtmlLabelName(126990, user.getLanguage())%>"+messageType;  //消息类型：
			}
		}
	}catch(e){
		client && client.writeLog("getMsgContent获取不到消息内容");
	}
	if(typeof content === 'string'){
		content=content.replace(/&amp;/g, '\&');
		content=content.replace(/&lt;/g, '\<');
		content=content.replace(/&gt;/g, '\>');
	}
	return content;
}

function getFwCustomMsgContent(senderId, content, extra) {
    var result = {};
    extra = JSON.parse(extra);
    switch(extra.pushType) {
        case 'weaver_shakeMsg' :
            result.pushType = extra.pushType;
            result.content = extra.receiverids != M_USERID ? '您发送了一个窗口抖动' : getUserInfo(senderId).userName + ' 抖了您一下';
            break;
    }
    return result;
}

function isScrollBottom(chatList){
	var container = $(chatList);
	var scrollTop = container.perfectScrollbar("getScrollTop");
	var containerHeight = chatList.height();
	var scrollHeight = container[0].scrollHeight;
	return scrollTop + containerHeight >= scrollHeight;
}

function getScrollTop(chatList, chatitemid){
	var _temp = chatList.find("#"+chatitemid);
	var prevDivs = _temp.prevAll('div');
	var _top = 0;
	for(var i = 0; i < prevDivs.length; i++){
		_top += $(prevDivs.get(i)).outerHeight();
	}
	return _top;
}

//滚动条显示在最下方
function scrollTOMessage(chatList, chatitemid){
	try{
		var _top = getScrollTop(chatList, chatitemid);
		$(chatList).scrollTop(_top);
	}catch(e){
		
	}
}

function addSendtime(chatList,recorddiv,sendtime,recordType,isLast){
	recorddiv.attr("_sendtime",sendtime);
	var date = new Date();
	var currentFullYear = date.getFullYear();
	var datePattern = "MM-dd HH:mm:ss";
	
	date.setTime(sendtime);
	
	var targetFullYear = date.getFullYear();
	
	if(targetFullYear < currentFullYear) {
		datePattern = "yyyy-MM-dd HH:mm:ss";
	}
	
	var senddate=date.pattern(datePattern);
	
	if(recordType=="send"||recordType=="receive"){
		var latestSendtime=chatList.find(".chatItemdiv:last").attr("_sendtime");
		if(latestSendtime==undefined||(sendtime-latestSendtime)/(1000*60)>2){
			chatList.append("<div class='chatTime' data-msgid='"+recorddiv.attr('id')+"'>"+senddate+"</div>");
		}
	}else{
		var latestSendtime=chatList.attr("_latestSendtime");
		var chatItemdiv=chatList.find(".chatItemdiv:eq(1)");
		if(chatItemdiv){
			var preSendtime=chatItemdiv.attr("_sendtime");
			var preChattimeid="chatTime_"+preSendtime;
			if((latestSendtime-sendtime)/(1000*60)>2&&(latestSendtime-preSendtime)/(1000*60)<=2&&$("#"+preChattimeid).length==0){
				chatList.find(".chatTime:eq(0)").remove();
				date.setTime(preSendtime);
				var preSenddate=date.pattern(datePattern);
				chatItemdiv.before("<div class='chatTime' data-msgid='"+recorddiv.attr('id')+"' id='"+preChattimeid+"'>"+preSenddate+"</div>");
			}
		}
		
		//latestSendtime=latestSendtime==undefined?(new Date().getTime()):latestSendtime;
		if(latestSendtime==undefined||(latestSendtime-sendtime)/(1000*60)>2||isLast){
			chatList.prepend("<div class='chatTime' id='chatTime_"+sendtime+"'>"+senddate+"</div>");
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


//获取人员基本信息
function getUserInfo(resourceid){
	if(!resourceid||resourceid=="") resourceid=M_USERID;
	if(!(/^[0-9]*$/.test(resourceid))){
		return {};
	} ;
	var userInfo = {};
	try{
		userInfo=userInfos[resourceid];
		if(!userInfo){
			var url=getPostUrl("/social/im/SocialIMOperation.jsp?operation=getUserInfo&resourceid="+resourceid);
			var data=getAjaxData(url);
			userList=eval("("+data+")");
			if(userList.length>0){
				userInfo=userList[0];
				userInfos[resourceid]=userInfo;
			}
		}
	}catch(error){
		userInfo = {};
	}
	if(!userInfo) {
		userInfo = {
			'userName': "",
			'userHead': ""
		};
	}
	return userInfo;
}

//加载所有人员基本信息到页面缓存
function loadUserInfo(){
    // 初始化特殊人物信息，如群广播
    initSpecialUserInfos();

	var url=getPostUrl("/social/im/SocialIMOperation.jsp?operation=getUserInfo");
	$.getJSON(url,function(data){
        try {
	    // data = data.replace(/\r/gi, '').replace(/\n/gi, '').replace(/\\/gi,'');
            var userList=data;
            for(var i=0;i<userList.length;i++){
                var userInfo=userList[i];
                var resourceid=userInfo.userid;
                 if(!userInfos[resourceid]){
					userInfos[resourceid]=userInfo;
				} 
            }
        } catch(e){
            client && client.error(e);
        }
	})	
}

// 初始化特殊人物信息
function initSpecialUserInfos() {
    // 初始化 群广播 虚拟人物
    userInfos['SysNotice'] = {userid:'SysNotice',userName:'<%=SystemEnv.getHtmlLabelName(127152,user.getLanguage()) %>',userHead:'/social/images/sysnotice_head.png',py:'qgb',deptName:'',jobtitle:''};
}


//加载本地用户信息
function loadLocalUserInfo(data){
	for(var i=0;i<data.length;i++){
		var userInfo=data[i];
		var resourceid=userInfo.userid;
		userInfos[resourceid]=userInfo;
	}
}


//加载所有人员基本信息到页面缓存
function loadSettingInfo(){
	var url=getPostUrl("/social/im/SocialIMOperation.jsp?operation=getSettingInfo");
	$.post(url,function(data){
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

//批量发送图片
function uploadImgBatch(chatcontentid,filedata,file,isLast){
	ChatUtil.cache.preSendData.push({
		'chatcontentid': chatcontentid,
		'filedata': filedata,
		'file': file
	});
	if(isLast && ChatUtil.cache.preSendData.length > 0){
		var interval = 250;
		setTimeout(function(){
			if(ChatUtil.cache.preSendData.length == 0){
				return;
			}
			var data = ChatUtil.cache.preSendData.shift();
			initUploadImg(data.chatcontentid, data.filedata, data.file);
			setTimeout(arguments.callee, interval);
		}, interval);
		
	}
}

//批量发送附件
function uploadAccBatch(chatcontentid,filedata,file,isLast){
	ChatUtil.cache.preSendData.push({
		'chatcontentid': chatcontentid,
		'filedata': filedata,
		'file': file
	});
	if(isLast && ChatUtil.cache.preSendData.length > 0){
		var interval = 250;
		setTimeout(function(){
			if(ChatUtil.cache.preSendData.length == 0){
				return;
			}
			var data = ChatUtil.cache.preSendData.shift();
			initUploadAcc(data.chatcontentid, data.filedata, data.file);
			setTimeout(arguments.callee, interval);
		}, interval);
		
	}
}

//发送附件
function initUploadAcc(chatcontentid,filedata,file,successcallback){
	var filedata=eval('('+filedata+')');
	var fileId = filedata.fileId;
	var fileSize=file.size;
	var fileName=file.name;
	var fileType=getFileType(fileName);
	var filePath=file.path;
	
	var params={"docid":fileId, "operation":"getaccbychat"};
	
	var data={
		"fileId":fileId,
		"fileName":fileName,
		"fileSize":fileSize,
		"fileType":fileType,
		"filePath":filePath,
		"objectName":"FW:attachmentMsg",
		"resourcetype":"1"};
	
	var chatSend=$("#"+chatcontentid).parents(".chatdiv").find(".chatSend");
	ChatUtil.sendIMMsg(chatSend,6,data,function(msg){
		if(msg && msg.issuccess){
			addIMFileRight(chatSend,data);
			if(typeof successcallback === 'function') {
				successcallback();
			}
		}
	});
	
	
}

//发送图片初始化
function initUploadImg(chatcontentid,imagedate,file,successcallback){

	var data=eval('('+imagedate+')');
	var fileSize=file.size;
	var fileName=file.name;
	var fileType=getFileType(fileName);
	
	//发送图片消息
	var chatSend=$("#"+chatcontentid).parents(".chatdiv").find(".chatSend");
	ChatUtil.sendIMMsg(chatSend,2,data,function(msg){
		if(msg && msg.issuccess){
			data["fileId"]=data.imgUrl;
			data["fileName"]=fileName;
			data["fileSize"]=fileSize;
			data["fileType"]=fileType;
			data["resourcetype"]="2";
			
			addIMFileRight(chatSend,data);
			if(typeof successcallback === 'function') {
				successcallback();
			}
		}
	});
	
}

function addIMFileRight(chatSend,data){
	var targetid=chatSend.attr("_acceptid");
	var targetType=chatSend.attr("_chattype");
	_addIMFileRight(targetid, targetType, data);
}
function _addIMFileRight(targetid, targettype, data){
	data["targetid"]=targetid;
	data["targetType"]=targettype;
	data["memberids"]=ChatUtil.getMemberids(targettype, targetid,true);
	var url=getPostUrl("/social/im/SocialIMOperation.jsp?operation=addIMFile");
	jQuery.post(url,data,function(content){	
		client.log("addIMFileRight callback content:"+content);
	});
}

function getFileType(filename){
		var suffix=filename.substring(filename.lastIndexOf(".")+1).toLowerCase();
		if((suffix=="jpg")||(suffix=="bmp")||(suffix=="gif")||(suffix=="png") || (suffix=="jpeg")){
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
	else if(size/(1024*1024) < 1023)
	   return (size/(1024*1024)).toFixed(2)+"M"; 
    else if(size/(1024*1024*1024) < 1023)
       return (size/(1024*1024*1024)).toFixed(2)+"G"; 
	   
}
//nw 相关对象
var downgui = window.require('nw.gui');
//var downnode_path = window.require('path'); 
//var dispatcherDown = window.require(downnode_path.join(downgui.__dirname,'/dispatcher.js'));
//下载附件消息中附件
function downAccFile(obj,isDefPath){
	var fileId=$(obj).attr("_fileId");
	var fileName=$(obj).attr("_filename");
	var fileSize = 0;
	if(from == 'pc'){
		try {
		var chatitem = IM_Ext.getChatItem(obj);
	  	var msgObj = chatitem.data("msgObj");
		var msgObjExtra = eval("("+msgObj.extra+")");
		fileSize = msgObjExtra.fileSize;		
		}catch(e){fileSize = 0;}
		var item = {};
		item['url'] = downgui.global.GLOBAL_INFOS.currentHost + "/weaver/weaver.file.FileDownload?fileid="+fileId+"&download=1";
		item['filename'] = fileName;
		item['totalbytes'] = fileSize;
		PcDownloadUtils.willdownload(item, isDefPath);
	}else{
		downloads(fileId,fileName);
	}

}
//删除附件
function delAccFile(obj){
	var fileId=$(obj).attr("_fileId");
	showImConfirm("确认删除吗？", function(){
		$.post("/social/im/SocialIMOperation.jsp?operation=delIMFile&fileIds="+fileId, function(){
			$(obj).closest('.accitem').remove();
		});
	});
}

//判断是否被删除，标准要屏蔽此功能
function checkFileDelete(fileIds, callback){
	$.post("/social/im/SocialIMOperation.jsp?operation=checkFileDelete&ids="+fileIds, function(data){
		data = $.trim(data);
		data = $.parseJSON(data);
		if(typeof callback === 'function') {
			callback(data);
		}
	});
}

//下载附件
function downloads(fileId,fileName,fileSize){
	var downloadFrm = $("#downloadFrame");
	if(downloadFrm.length == 0){
		downloadFrm = $("#downloadFrame", top.document);
	}
	var item = {};
	if(from == 'pc'){		
		item['url'] = downgui.global.GLOBAL_INFOS.currentHost + "/weaver/weaver.file.FileDownload?fileid="+fileId+"&download=1";
		item['filename'] = fileName;
		item['totalbytes'] = fileSize;
	}
	checkFileDelete(fileid,function(data){
		if(data[fileid] =='1'){
			IM_Ext.showMsg("附件已超出"+ClientSet.taskTime+"天，已过期");
		}else{			
			PcDownloadUtils.willdownload(item, false);
		}
	});	
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
  	  if(target=='hrmOrg' || target=='hrmGroup'){
  	  	$('#contactListdiv .hrmTreeItem').show();
  	  }
  	  loadIMDataList(target);
  }
  //移除聊天面板
  function removeIMChatpanel(targetid, targettype){
	var chatWinid="chatWin_"+targettype+"_"+targetid;
	$("#"+chatWinid).remove();
	$("#imCenterdiv").hide();
  }
  //显示聊天面板
  function showIMChatpanel(chatType, acceptId,chatName,headicon) {
  	var targettype=chatType;
  	var targetid=acceptId;
  	var defaultHeadImage = headicon;
  	if(targettype == 0){
  		var sex = '0';
  		try{
  			sex = userInfos[targetid].sex;
  		}catch(err){
  			sex = '0';
  		}
  		defaultHeadImage = sex == '0'? "/messager/images/icon_m_wev8.jpg": "/messager/images/icon_w_wev8.jpg";
  	}
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
  								"	<div class='headicon'><img src='"+headicon+"' class='head28' align='absmiddle' onerror='this.src=\""+defaultHeadImage+"\"'></div>"+
  								"	<div class='targetName ellipsis' title='"+chatName+"'>"+chatName+"</div>"+
  								"	<div class='clear'></div>"+
  								"	<div class='tabClostBtn' onclick='beforeCloseTabWin(this)' _chatWinid='"+chatWinid+"'>x</div>"+
  								"	<div class='msgcount hoverRight'>0</div>"+
  								"</div>");
  		
  		var chatjspUrl = "/social/im/SocialIMChat.jsp";
  		if(versionTag == "rdeploy"){
  			chatjspUrl = "/rdeploy/im/IMChat.jsp";
  		}	
  		if(acceptId=="bing"){
  			chatjspUrl = "/rdeploy/bing/BingMain.jsp";
  		}else if(acceptId=="SysRemind"){
  			chatjspUrl = "/social/im/SocialSysRemind.jsp";
  		}else if(acceptId=="SysNotice"){
  			chatjspUrl = "/social/im/SocialBroadCastView.jsp";
  		}else if(acceptId == "notice_-1"){
			chatjspUrl = "/fullsearch/EAssistant/eWorkbenchTp.jsp?from=pc";
		  }
  		if($("#"+chatWinid).length==0){						
  			$("#chatIMdivBox").prepend("<div id='"+chatWinid+"' class='chatWin' _targetid='"+acceptId+"' _targetType='"+chatType+"'></div>");					
  			//第一次都加载
  			var url=getPostUrl(chatjspUrl+"?from=chat&chatType="+chatType+"&acceptId="+acceptId);
            if(typeof from != 'undefined' && from == 'pc') {
                url += '&frompc=true';
            }
  			//$("#"+chatWinid).html("<div class='loading1'></div>").load(url,{"targetName":chatName}).show();
  			if(acceptId == "bing"){
  				$("#"+chatWinid).html("<div class='loading1'></div>").load(url,{"targetName":chatName}).show();
  			}else if(acceptId == "SysRemind"){
  				$("#"+chatWinid).css('height','100%');
  				$("#"+chatWinid).html("<iframe name='sysremindframe' frameborder='0' width='100%' height='100%'></iframe>");
  				$("#"+chatWinid + " iframe[name='sysremindframe']").attr('src',url+"&targetName="+chatName);
  			}else if(acceptId == "SysNotice"){
  				$("#"+chatWinid).css('height','100%');
  				$("#"+chatWinid).html("<div class='loading1'></div>").load(url,{"targetName":chatName}).show();
  				//$("#"+chatWinid).html("<iframe name='sysnoticeframe' frameborder='0' width='100%' height='100%'></iframe>");
  				//$("#"+chatWinid + " iframe[name='sysnoticeframe']").attr('src',url+"&targetName="+chatName);
  			}else if(acceptId == "notice_-1"){
  				$("#"+chatWinid).css('height','100%');
				$("#"+chatWinid).html("<div id='notice_-1' class='chatdiv'><div class='chatleft'><div class='imtitle'>"+
										"<span class='imtitleName' style='margin-top: 4px;margin-left:-7px;' title='小e客服工作台'>小e客服工作台</span>"+
										"<span class='imtitleBlock can-drag'></span></div>"+
										"<iframe name='notice_-1' frameborder='0' src='"+chatjspUrl+"' width='100%' height='95%'></iframe></div></div>");				
			  }else{
  				var chatdivTemp = $("#chatDivFrm").contents().find("#chatdivTemp").clone();
	  			if(chatType == '1'){
	  				chatdivTemp.find('.imnote').show();
					chatdivTemp.find('.imvote').show();
	  			}
	  			var chatdivTempHtml = chatdivTemp.html();
	  			chatdivTempHtml = chatdivTempHtml.replace(/\%targetName\%/gim, chatName);
	  			chatdivTempHtml = chatdivTempHtml.replace(/\%acceptId\%/gim, acceptId);
	  			chatdivTempHtml = chatdivTempHtml.replace(/\%chatType\%/gim, chatType);
	  			$("#"+chatWinid).html("<div class='loading1'></div>").prepend(chatdivTempHtml).show(20, function(){
	  				ChatUtil.initChatDiv(acceptId, chatType, chatName, headicon);
	  			});
  			}
  		}
  		/*
  		else if(versionTag == "rdeploy"){
  			//只对R版做重载
  			$("#"+chatWinid).load(chatjspUrl+"?chatType="+chatType+"&acceptId="+acceptId,{"targetName":chatName}).show();
  		}
  		*/
  		$("#imLeftdiv").scrollTop(0);
  		
  	}else if(targettype == 4 || targettype == 3||targettype==6){
  		$("#"+chatTabid).addClass("chatIMTabActiveItem");
  	}else{
  		$("#"+chatTabid).addClass("chatIMTabActiveItem");
  		if(!$("#"+chatWinid).attr('_isInited')){
  			ChatUtil.initChatDiv(acceptId, chatType, chatName, headicon);
  			setTimeout(function(){
  				$("#"+chatTabid).click();
  			}, 200);
  		}else{
  			$("#"+chatTabid).click();
  		}
  	}
  	if(versionTag == "rdeploy"){
  		if(acceptId == 'bing')
  			acceptId = 'bing_'+M_USERID;
  	}
  	var converid = getConverId(chatType, acceptId);
	$("#recentListdiv .chatItem").removeClass("activeChatItem");
	if($("#"+converid).length == 0){
		var converTempdiv = getConverTempdiv(acceptId, chatType);
		$("#recentListdiv").prepend(converTempdiv);
		$("#recentListdiv").scrollTop(0);
	}
	$("#"+converid).addClass("activeChatItem");
	//将激活状态下的会话count消息id放入发送池中
	sendLocalCountMsg(targetid);
	
	//群聊窗口去掉个性签名
	if(targettype==1){
		$("#"+chatWinid).find(".chattop").children(".signatures").remove();
	}
	
  	$("#"+chatWinid).show();
  	
  	$("#"+chatWinid).find(".chatcontent").focus();
  	
  	scrollTOBottom($("#"+chatWinid).find(".chatList"));
  	
  	if(targettype==3){
  		IMUtil.showPerfectScrollbar($("#"+chatWinid+" #bingList"));
  	}else if(targettype==5||targettype == 6){
  		//TODO 内页滚动条？
  	}else{
	  	var chatActiveTab=$("#"+chatWinid).find(".chatActiveTab");
	  	chatActiveTab.click();
  	}
  	//$("#chatIMdivBox").show();
	//clearChatMsg(acceptId,userid,chatType);
	
  }

  //切换聊天窗口
  function changeTabWin(obj){
    var chatWinid=$(obj).attr("_chatWinid");
  	$("#chatIMTabs").find('.chatIMTabActiveItem').removeClass("chatIMTabActiveItem");
  	$(obj).addClass("chatIMTabActiveItem");
  	$("#chatIMdivBox").find('.chatWin').hide();
  	var chatActiveTab=$("#"+chatWinid).find('.chatActiveTab');
  	var chatWin=$("#"+chatWinid).css('display', 'block');
  	var chattype = chatWinid.substring(8, 9);
 	var targetid = chatWinid.substring(10, chatWinid.length);
 	//同步个性签名
    if(chattype==0){
        ChatUtil.updateSignature(targetid);
        if(IS_BASE_ON_OPENFIRE){
        var memArr = new Array();
        memArr.push(targetid);
        OnLineStatusUtil.getUserOnlineStatus(memArr);
        }
    }
 	var lastActiveChatItem = $("#recentListdiv").find('.activeChatItem');
 	lastActiveChatItem.removeClass("activeChatItem");
 	$("#"+ getConverId(chattype, targetid)).addClass("activeChatItem");
 	
 	// 如果切换当前窗口，发送未读数字消除消息
 	if(lastActiveChatItem.length > 0 && lastActiveChatItem.attr('_targetid') !== targetid){
 		//console.warn("上一个窗口："+lastActiveChatItem.attr('_targetid')+" "+lastActiveChatItem.attr('_targettype'));
 		ChatUtil.sendClearUnreadCountMsg(lastActiveChatItem.attr('_targetid'), lastActiveChatItem.attr('_targettype'));
 	}
 	
  	//web版公告
  	if(chatActiveTab.attr("_target") == 'noteList' && versionTag != 'rdeploy'){
  		chatActiveTab.click();
  	}
  	//重新加载历史记录
  	var errorTag =chatWin.attr('errorTag');
  	if(M_SERVERSTATUS && errorTag == 'history-load-failed'){
  		ChatUtil.getHistoryMessages(chattype,targetid,10,true);
  		chatWin.removeAttr("errorTag").find(".chatWinFloatMsgdiv").hide();
  	}
  	//以下代码是处理滚动条是否滚动到底部，1105 by wywei
  	var chatList = chatWin.find(".chatList");
  	if(chatList.is(":visible")&&chatList.data("newMsgCome")){
  		chatList.perfectScrollbar("update");
  		scrollTOBottom(chatList);
  		chatList.data("newMsgCome", false);
  	}
  	
  	var scrollbarid=chatList.attr("_scrollbarid");
  	$(".chatListScrollbar").css({"z-index":"1000"});
  	$("#"+scrollbarid).css({"z-index":"1001"});
  	
  	chatWin.find(".chatcontent").focus();
  	var chattype = chatWinid.substring(8, 9);
  	var targetid = chatWinid.substring(10, chatWinid.length);
  	
  	var msgcount=$("#"+ getConverId(chattype, targetid)).find(".msgcount");
  	var count=Number(msgcount.html());
  	msgcount.html(0).hide();
  	msgcount=$("#chatTab_"+chattype+"_"+targetid).find(".msgcount");
    msgcount.html(0).hide();
  	updateTotalMsgCount(count,'del');
  	ChatUtil.setCurDiscussInfo(targetid, chattype);
  	//将激活状态下的会话count消息id放入发送池中
  	sendLocalCountMsg(targetid);
  	
  	//console.warn("当前窗口："+targetid+" "+chattype);
    // 发送端已读消息
    ChatUtil.sendClearUnreadCountMsg(targetid, chattype);
    
    // 清除消息阅读位置
	checkReadPosition(chatWinid);	
	//清理重连提示
	typeof OpenFireConnectUtil!="undefined" && OpenFireConnectUtil._closeConnectPostFloatNotice();
  }
  
  //激活窗口时将本地接收到的消息id放入count消息发送池
  function sendLocalCountMsg(targetid){
  	var localMsgArray=converMsgList[targetid];
  	if(localMsgArray){
  		for(var i=0;i<localMsgArray.length;i++){
  			var msgitem=localMsgArray[i];
            if(localMsgArray[i].toid == 'SysNotice') {
                continue;
            }
            client.error(localMsgArray[i]);
            countMsgidsArray.push(localMsgArray[i]);
            ChatUtil.savaCountMsg(localMsgArray[i].msgid,localMsgArray[i].toid,0,'send');
  		}
  		converMsgList[targetid]=new Array();
  	}
  }
  
  // 对传输文件夹情况进行处理
  function beforeCloseTabWin(obj) {
	if(ChatUtil.isFromPc()) {
      	 var chatWinid=$(obj).attr("_chatWinid"); 
         var chatWin=$("#"+chatWinid);
         var dirSends = chatWin.find('.chatItemdiv[_msgtype="dirSend"][_finish="false"]');
         if(dirSends.length > 0) {
            DragUtils.closeDrags();
            window.top.Dialog.confirm('<%=SystemEnv.getHtmlLabelName(127286, user.getLanguage())%>', function(){
                $.each(dirSends, function(i, v){
                    v = $(v);
                    var msgId = v.attr('id');
                    if(v.attr('_dirtype') == 'send') {
                        var targetId = v.attr('_targetid');
                        PcSendDirUtils._exeSenderCancelDir(false, msgId, targetId);
                    } else {
                        var receiverObj = PcSendDirUtils.currentReceiveDir[msgId];
                        if(receiverObj) {
                            receiverObj.cancelDownload();
                            // 通知发送方
                            PcSendDirUtils.node_request.get('http://' + receiverObj.srcIpAddress + ':' + receiverObj.srcIpPort + '/cancelReceive?msgId=' + msgId);
                            delete PcSendDirUtils.currentReceiveDir[msgId];
                        } else {
                            var srcIpAddress = v.attr('_srcIpAddress');
                            var srcIpPort = v.attr('_srcIpPort');
                            PcSendDirUtils.node_request.get('http://' + srcIpAddress + ':' + srcIpPort + '/cancelReceive?msgId=' + msgId);
                        } 
                    }
                });
                DragUtils.restoreDrags();
                
                closeTabWin(obj);
            }, function(){
                DragUtils.restoreDrags();
            });
        } else {
            closeTabWin(obj);
        }
	} else {
	   closeTabWin(obj);
	}
  }


  // 关闭所有的聊天窗口
  function closeAllTabs(){
  	var chatTabItems = $('#chatIMTabs .tabClostBtn');
  	var chatWinId;
  	$.each(chatTabItems, function(i, obj){
  		closeTabWin(obj);
  	});
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
	  	try{
	  		nextChatTab.click();
	  	}catch(err){
	  		client.writeLog("捕获到错误：", err);
	  	}
	  	
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
	  	 if(from!="main"){
	  	 	$("#imDefaultdiv").show();
	  	 }
  		 $("#imLeftdiv").hide();
  		 $("#imCenterdiv").hide();
	  }
	  var targetType=chatWinid.split("_")[1];
	  var targetid=chatWinid.split("_")[2];
	  
	  if(M_SDK_VER == '1') {
	  	client.resetGetHistoryMessages(targetType,targetid);
	  }
	  //发现聊天窗口里没有任何聊天内容且会话没有最后一条消息，则把会话移除掉 0307 by wyw
	  var converdiv = $('#'+getConverId(targetType, targetid));
	  if(chatWin.find('.chatList .chatItemdiv').length <= 0 && 
	  	converdiv.find('.msgcontent').html() == '') {
	  		converdiv.remove();
	  	}
	  //清除会话中的未读数字
	  converdiv.find('.msgcount').html(0).hide();
	  //清除绑定的滚动条 0427 by wyw
	  IMUtil.removeIMScrollbar(chatWin.find(".chatList,.acclist,.noteList,.bingList"));
	  stopEvent();
  }
  
  function openBlog(resourceid,orgType,obj){
  	if(orgType==1){
  		var userInfo=getUserInfo(resourceid);
  		var paramObj = {};
  		paramObj['targetId'] = resourceid;
  		paramObj['targetName'] = userInfo.userName;
  		paramObj['targetHead'] = userInfo.userHead;
  		paramObj['targetType'] = 0;
		showConverChatpanel(null, paramObj);
  	}
  }
  
  function dblclickTree(resourceid,orgType,obj){
  	if(orgType==1){
  		var userInfo=getUserInfo(resourceid);
  		var paramObj = {};
  		paramObj['targetId'] = resourceid;
  		paramObj['targetName'] = userInfo.userName;
  		paramObj['targetHead'] = userInfo.userHead;
  		paramObj['targetType'] = 0;
		showConverChatpanel(null, paramObj);
  	}
  }
  function initBrowerTabHandler(_win){
  	var doc = _win.document;
  	var hiddenProperty = 'hidden' in doc ? 'hidden' :    
	    'webkitHidden' in doc ? 'webkitHidden' :    
	    'mozHidden' in doc ? 'mozHidden' :    
	    'msHidden' in doc ? 'msHidden': null;
	//IE10 以下 没有msHidden属性 == 0421 wyw
	if(hiddenProperty == null){
		return;
	}
	var visibilityChangeEvent = hiddenProperty.replace(/hidden/i, 'visibilitychange');
	var onVisibilityChange = function(){
	    if (!doc[hiddenProperty]) {    
	        client && client.log('页面激活');
	        _win.IMUtil.cache.isWindowFocus = 1;
	        client && client.reconnect();//激活后检查链接状态，如果断开重新连接
	        checkClearUnreadStatus(_win);
	        checkReadPosition(ChatUtil.getCurChatwin(_win).attr('id'));
	    }else{
	        client && client.log('页面非激活')
	        _win.IMUtil.cache.isWindowFocus = 0;
	    }
	}
	if(typeof doc.addEventListener == 'function')
		doc.addEventListener(visibilityChangeEvent, onVisibilityChange);
	//IE8
	else
		doc.attachEvent(visibilityChangeEvent, onVisibilityChange);
  }
  //初始化消息提醒监听
  function initNotifHandler(){
  
  	window.setInterval(function(){
  	
  		var converlist = $('#recentListdiv .chatItem').each(function(){
  		
  			var converdiv = $(this);
  			var count = 0;
  			var isNeedRedmind=converdiv.attr("_isNeedRedmind");
  			try{
  				count = Number(converdiv.find('.msgcount').html());
  			}catch(err){
  				count = 0;
  			}
  			if(count > 0&&isNeedRedmind=="1"){
  				var targetid = converdiv.attr('_targetid');
	  			var targetname = converdiv.attr('_targetname');
	  			var targethead = converdiv.attr('_targethead');
	  			var targettype = converdiv.attr('_targettype');
	  			var msgcontent=converdiv.find('.msgcontent').html()
	  			var notifTitle = "";
	  			if(targettype == '1'){
                    // notifTitle = "["+ targetname +"]有 ("+ count +") 条新消息";
	  				notifTitle = "["+ targetname +"]<%=SystemEnv.getHtmlLabelName(15086, user.getLanguage())%> ("+ count +") <%=SystemEnv.getHtmlLabelName(126991, user.getLanguage())%>";
	  			}else{
	  				// [徐如晶]发来 (5) 条新消息
                    // notifTitle = "["+ targetname +"]发来 ("+ count +") 条新消息";
	  				notifTitle = "["+ targetname +"]<%=SystemEnv.getHtmlLabelName(126992, user.getLanguage())%> ("+ count +") <%=SystemEnv.getHtmlLabelName(126991, user.getLanguage())%>";
	  			}
  				newMsgDeskNotify(targetid,targettype,notifTitle,targethead,msgcontent);
  				converdiv.attr("_isNeedRedmind","0");
  			}
  		
  		});
  		
  	}, 1000*60*3);
  }
  
  //初始化顶部
  function initIMNavTop(){
  
  	$(".imToptab .tabitem").bind("click",function(){
  		
  			$(".imToptab .activeitem").removeClass("activeitem");
  			var target=$(this).attr("_target");
  			
  			$(this).addClass("activeitem");
  			
  			$(".leftMenus .leftMenudiv").hide();
  			$("#"+target+"Listdiv").show();
  			
  			if(target=="contact"){
  				$("#imConTabs").show();
  				$('#imConTabs .conActItem').click();
  			}else{
  				$("#imConTabs").hide();
  				/*
  				if(ClientSet.ifForbitGroupChat == '1' && target == 'discuss'){
			  	  return;
			  	}
			  	*/
			  	// '最近'tab页上的数字隐藏
			  	if(target=="recent"){
			  		// $('.activeChatItem').click();
			  		var recentmsgcount = $(".imToptab .tabitem .recentmsgcount");
			  		recentmsgcount.css('display', 'none');
			  	}
  				loadIMDataList(target);
  			}
  			if(target!="recent"){
  				var recentmsgcount = $(".imToptab .tabitem .recentmsgcount");
  				var count = parseInt(recentmsgcount.html());
  				if(count > 0)
		  			$(".imToptab .tabitem .recentmsgcount").css('display', 'block');
		  	}
  			//处理联系人列表的滚动条显示
  			setToTopScroller(target);
  			
  	});
  	$(".imToptab .tabitem:first").click();
  }	
  
  function setToTopScroller(target){
  	var scrollid = $("#"+target+"Listdiv").attr('_scrollbarid');
	IMUtil.findBindScrollers('#recentListdiv,#contactListdiv,#discussListdiv', function(scrollers){
		for(var i = 0; i < scrollers.length; ++i){
			$(scrollers[i]).css('z-index', '1000');
		}
		$('#'+scrollid).css('z-index', '1001');
	});
  }
  var M_HINT = "<%=SystemEnv.getHtmlLabelName(130148, user.getLanguage())%>";  //感觉这里要做标签的规范  //请输入关键字
  var M_SMS = "<%=SystemEnv.getHtmlLabelName(126993, user.getLanguage())%>";	  //默认显示的提示  //无搜索结果
  //获取搜索关键字
  function getKeyword() {
  	var keyword = $.trim($("#searchResultListDiv>.imSearchInputdiv").val());
  	try {
  		if(keyword == undefined || keyword == '' || keyword == M_HINT)
  			throw "未输入搜索关键字";	//同样要坐标签的规范
  		keyword = keyword.split("'").join("");
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
  		client.writeLog("校验关键字[" + keyword + "]合法");
  	}
  	return true;
  }
  
  var preKeyword = undefined;		//上一个搜索的关键字
   var searchTimer = undefined;		//搜索定时器
  //搜索联系人
  function doMemberSearch(obj, e) {
	window.clearTimeout(searchTimer);
  	searchTimer = window.setTimeout(function(){
  		var keyword = $(obj).val();
  		if(keyword != keyword.split("'").join("")){
	  		stopEvent();
	  		return false;
	  	}
  		doRealSearch(keyword);
  	}, 600);
  	
  }
  
  function doRealSearch(keyword){
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
	 		client.writeLog("搜索: " + keyword);
	 		loadIMDataList("tempSearch");
  		}
 	}
  }
  
  //清空历史搜索
  function clearHistorySearch() {
  	$("#searchResultListDiv>.imSearchList").empty();
  	preKeyword = undefined;
  }
  
  //显示并搜索最近联系人
  function showResultDiv(bDisplay) {
  	if(bDisplay){
  		$("#searchResultListDiv").css({display:'block', position:'absolute', top: '36px', width: '281px', bottom: '0px'});
  		if(typeof from != 'undefined' && from == 'pc'){
  			$("#searchResultListDiv").css({"width": '281px', 'top': '112px'});
  		}
  		/*
  		$("#searchResultListDiv").html("<input type=\"text\" value=\"请输入关键字\" onkeyup=\"doSearch($(this).val())\"" + 
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
  		$(document).unbind('.tempsearch');
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
  		//处理滚动条显示
  		var scrollbarid = $("#imSearchList").attr('_scrollbarid');
  		$('.chatListScrollbar').css('z-index', '1000');
  		$('#'+scrollbarid).css('z-index', '1001');
  	}else{
  		$("#searchResultListDiv").css({display:'none', position:'absolute'});
  		$("#searchResultListDiv>.imSearchClose").unbind("click");
  		$(document).unbind('.tempsearch');
  		$("#searchResultListDiv").unbind('click');
  		$(".imSearchdiv").find(".imInputdiv").val(M_HINT);
  		var scrollbarid = $("#imSearchList").attr('_scrollbarid');
  		$('#'+scrollbarid).css('z-index', '1000');
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
  		client.writeLog(sms);
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
 //点击切换聊天窗口顶部tab页
function changeChatTopTab(obj,tabtype){
	var chatdiv=$(obj).parents(".chatdiv");
	var chattop=$(obj).parents(".chattop");
	var chatwin = $(obj).parents(".chatWin");
	chattop.find(".chatActiveTab").removeClass("chatActiveTab");
	
	chatdiv.find(".chatListbox").hide();
	var target=$(obj).attr("_target");
	//显示tab页
	chatdiv.find("."+target).show(10, function(){
		//如果是公告，则判断是否该隐藏输入入口
 		if(target=="noteList"){
 			var targetid = chatwin.attr("_targetid");
 			var noteEdit = chatwin.find(".noteEdit");
 			var noteEditArea = chatwin.find(".gg_edit_area");
 			DiscussUtil.checkDisRight(targetid, function(hasRight){
 				if(!hasRight){
 					noteEdit.css("display", "none");
 				}
 				chatwin.find('.noteList').perfectScrollbar('update');
 			});
 		}
	});
	/*如果不是聊天窗口，隐藏上传动画*/
	if(target != "chatList"){
		$(".uploadProcess").hide();
	}else{
		var targetid = "uploadImgDiv_"+chatdiv.attr("id").substring(8);
		try{
			var swfu = $.swfupload.getInstance('#'+targetid);
	        if(swfu && swfu.getStats().files_queued > 0){
	        	$("#"+targetid+" .uploadProcess").show();
	        }
		}catch(err){
			client.error("获取不到swfupload对象");
		}
		
        var chatList = chatdiv.find(".chatList");
        if(chatList.data("newMsgCome")){
        	chatList.perfectScrollbar("update");
			scrollTOBottom(chatList);
			chatList.data("newMsgCome", false);
        }
        
        checkReadPosition(chatwin.attr('id'));
	}
	var targetScroll=target;
	if(target=="fileList"){
		targetScroll="acclist";
	}
	var scrollbarid=chatdiv.find("."+targetScroll).attr("_scrollbarid");
	$(".chatListScrollbar").css({"z-index":"1000"});
  	$("#"+scrollbarid).css({"z-index":"1001"});
  	
	$(obj).addClass("chatActiveTab");
 	var right=chattop.width()-$(obj).position().left-($(obj).width()/2)-13;
 	//var right=$(obj).position().left+($(obj).width()/2);
	var top=$(obj).position().top+30;
	if(versionTag=="rdeploy"){
 		if(target!="chatList"){
 			left+=5;
 		}
 		top++;
 		if(target=="icrList"){
 			IM_Ext.loadIcrJsp(obj, false);
 		}else{
 			chattop.find(".chatArrow").removeClass("chatArrowGrey");
 		}
 	}
	//chattop.find(".chatArrow").css({"left":left,"top":top}).show();
	chattop.find(".chatArrow").css({"right":right,"top":top}).show();
	QuickReplyUtil.hide();
	stopEvent();
} 

function getSocialDialog(title,width,height,closeHandler){
    var diag =new window.top.Dialog();
    diag.currentWindow = window; 
    diag.Modal = true;
    diag.Drag=true;
	diag.Width =width?width:680;	
	diag.Height =height?height:420;
	diag.ShowButtonRow=false;
	diag.Title = title;
	diag.closeHandle = function(){
		if(typeof closeHandler == 'function'){
			closeHandler(diag);
		}
		//pc端关闭时恢复拖动绑定
		if(typeof from != 'undefined' && from == 'pc'){
			DragUtils.restoreDrags();
		}
	}
	if(typeof from != 'undefined' && from == 'pc'){
		DragUtils.closeDrags();
	}
	return diag;
}

function updateDiscussInfo(discussid,operate) {
	if(operate=="quit"){ //退出群
		$("#conversation_"+discussid).remove();
		closeTabWin($("#chatTab_1_"+discussid+" .tabClostBtn"));
	}else{
		ChatUtil.setDiscussInfo(discussid);
		//设置当前群信息
		ChatUtil.setCurDiscussInfo(discussid, '1');
	}
}
  
function refreshDiscussTitle(discussid) {
	ChatUtil.getDiscussionInfo(discussid, true, function(discuss){
		if(!discuss) return ;
		refreshDiscussName(discuss);
	});
}

function refreshDiscussName(discuss){
	if(!discuss) return;
	var discussid=discuss.getId();
	var discussName=discuss.getName();
	discussName = IMUtil.htmlEncode(discussName);
	var chatdivid = "chatdiv_" + discussid;
	//alert(chatdivid);
	//alert($('#' + chatdivid+' .imtitleName').length);
	$('#' + chatdivid+' .imtitleName').text(discussName).attr("title",discussName);
	
	var chatTabid = "chatTab_1_" +discussid;
	$("#"+chatTabid+" .targetName").text(discussName).attr("title",discussName);
	
	var conversationid="conversation_"+discussid;
	$("#"+conversationid+" .targetName").text(discussName).attr("title",discussName);
	$("#"+conversationid).attr("_targetname",discussName);
	ChatUtil.setCurDiscussInfo(discussid, '1');
	//刷新群聊列表名称
	var discussItemObj = $("#discussListdiv .groupItem[_targetid='"+discussid+"']");
	if(discussItemObj.length > 0){
		discussItemObj.attr("_targetname",discussName);
		discussItemObj.find(".groupName").text(discussName);
	}
}

//请出内容格式
function clearContentHtml(obj){
	
 	$(obj)[0].onpaste = function(event){
		event = event || window.event;
		var clipboard = event.clipboardData || window.clipboardData;
		plaintext = "";
		if(clipboard.items){
			var leng=clipboard.items.length;
			 if(leng==4&&$(obj).attr("_imgCapturer") && (clipboard.items[leng-1].kind == 'file' || clipboard.items[leng-1].type.indexOf('image') > -1)){
						var imageFile = clipboard.items[leng-1].getAsFile();
			            var form = new FormData;
			            var chatdiv = ChatUtil.getchatdiv(obj);
			            form.append('enctype', 'multipart/form-data')
			            form.append('Filedata', imageFile);
			            ChatUtil.confirmImg(imageFile, form, chatdiv);
			 }else{
		
			for(var i=0,len=clipboard.items.length; i<len; i++) {
				if($(obj).attr("_imgCapturer") && (clipboard.items[i].kind == 'file' || clipboard.items[i].type.indexOf('image') > -1) && i == 0) {
				   	var imageFile = clipboard.items[i].getAsFile();
		            var form = new FormData;
		            var chatdiv = ChatUtil.getchatdiv(obj);
		            form.append('enctype', 'multipart/form-data')
		            form.append('Filedata', imageFile);
		            ChatUtil.confirmImg(imageFile, form, chatdiv);
				}
				else if(clipboard.items[i].kind == 'string' && clipboard.items[i].type == 'text/plain'){
					plaintext = clipboard.getData("Text");
				}
			}
			}
		}
		//IE下
		else{
			plaintext = clipboard.getData("Text");
		}
		event.preventDefault(); 
		//清除选择的内容
		IMUtil.clearSelected(this);
		var curPos = IMUtil.getCursorPos(this);
		IMUtil.cache.cursorPos = curPos;
		IMUtil.insertHtmlAtPos(this, curPos, plaintext);
		$(obj).perfectScrollbar('update');
	};

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

function showEditorRightMenu(obj, e){
	e = e || window.event;
	if(e.which == 3) {
		var options = {
			menuList: [
					   	{ menuName: "粘贴", clickfunc: "$(this).blur().hide();IMUtil.doPaste(null, event, '"+$(obj).attr('id')+"');"}
					  ],
			left: e.clientX,
			top: e.clientY
		};
		var curPos = IMUtil.getCursorPos(obj);
		//弹出右键菜单前，保存当前光标位置
		$(obj).blur();
		showRightMenu(obj, options);
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
			classtag + "\" onmousedown=\"" + 
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
	var filetype=$(obj).attr("_filetype");
	if(filetype == undefined)
		filetype = $(obj).parents(".accitem").attr("_filetype");
	if(!checkFileType(fileName)){
		downloads(fileid,fileName);
		return ;
	}
	//是图片改用图片浏览
	else if(filetype && filetype.toLowerCase() == "img"){
		var acclist = $(obj).parents(".acclist");
		//是从聊天窗口打开的
		if(acclist.length == 0){
			acclist = $(obj).parents(".chatList");
		}
		var curfileid = $(obj).attr("_fileid");
		if(curfileid == undefined)
			curfileid = $(obj).parents(".accitem").attr("_fileid");
		var imgidlist = [], imgpool=[],imgidPool=[],index=0;
		var accitems = acclist.find(".accitem[_filetype='img']");
		for(var i = 0; i < accitems.length; ++i){
			var fileid = $(accitems[i]).attr("_fileid");
			imgidPool[fileid] = i;
			imgidlist.push(fileid);
			if(fileid==curfileid){
				index=i;
			}
		}
		checkFileDelete(imgidlist.join(','), function(data){
			if(data[curfileid] == '1'){
				IM_Ext.showMsg("当前图片已过期，无法打开");
			}else{
				for(var i = 0; i < imgidlist.length; ++i){
					if(data[imgidlist[i]] == '0') {
						 imgpool.push("/weaver/weaver.file.FileDownload?fileid="+imgidlist[i]);
					}else{
						index=0;
					}
				}
				openImgView(index, imgpool, imgidPool);
			}
		});
	}
	else{
        if(typeof from != 'undefined' && from == 'pc') {
            DragUtils.closeDrags();
        }
    	checkFileDelete(fileid, function(data){
			if(data[fileid] == '1'){
				var _message ="附件已超出"+ClientSet.taskTime+"天，已过期";
				if(typeof ClientSet.isOpenDeleteFileTask!="undefined"&&ClientSet.isOpenDeleteFileTask =="1"){
					_message ="文件已经被删除";
				}
				IM_Ext.showMsg(_message);	
			}else{
				dialogfile = new window.top.Dialog();
				dialogfile.currentWindow = window;
				dialogfile.Title = "<%=SystemEnv.getHtmlLabelName(126994, user.getLanguage())%>";  //文件预览
				dialogfile.Width = 800;
				dialogfile.Height = 600;
				dialogfile.maxiumnable=true;
				dialogfile.Drag = true;
				var url=getPostUrl("/social/im/SocialIMFilePreView.jsp?fileid="+fileid);
				dialogfile.URL =url;
				dialogfile.show();
		        
		        if(typeof from != 'undefined' && from == 'pc') {
		            dialogfile.closeHandle = function(){
		                DragUtils.restoreDrags();
		            }
		        }
			}
		});
		
	}
}
//打开图片轮播
function openImgView(index, imgpool, imgidPool) {
	var fileids = "";
	for(var fileid in imgidPool){
		if(!/^[0-9]+$/.test(fileid)){
			continue;
		}
		if(fileids == ''){
			fileids = fileid;
		}else{
			fileids += ","+fileid;
		}
	}
	if(typeof from != 'undefined' && from == 'pc'){
		var handlers = {
			afterClose: function(){
				DragUtils.restoreDrags();
			},
			beforeOpen: function(){
				DragUtils.closeDrags();
			}
		};
		ImageReviewForPc.show(index, imgpool);
	}else{
		IMCarousel.showImgScanner4Pool(true, imgpool, index, null, window.top);
	}
}

//检查文件类型
function checkFileType(filename) {
	var isavailable = false;
	//去掉预览类型；'.doc', '.docx', '.xls', '.xlsx','.pdf', 
	var filePostfixs = ['.txt', '.png', '.jpg', 'jpeg', '.bmp', '.gif','.java','.jsp'];
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
function onShowApp(evt, type,target){
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
	   else if(type=='card')   
		  url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp";
	  else if (type == 'disk')
		 url= "/systeminfo/BrowserMain.jsp?mouldID=networkdisk&url=/rdeploy/chatproject/doc/MultiPrivateBrowser.jsp";
	   hideChatPopBox();  
       
       // pc端对拖拽特殊处理
       if(typeof from != 'undefined' && from == 'pc') {
            DragUtils.closeDrags();
        }
       
	   showModalDialogForBrowser(evt,url,'#','resourceBrowser',false,1,'',{name:'resourceBrowser',hasInput:false,zDialog:true,needHidden:true,dialogTitle:'',arguments:'',_callback: appCallback});
       
       // pc端对拖拽特殊处理
       if(typeof from != 'undefined' && from == 'pc') {
            browserDialog.closeHandle = function(){
                browserDialog.closeHandle = null;
                DragUtils.restoreDrags();
            };
        }
}

function getResourcetype(appType){
	var resourcetype=0;
	if(appType=="doc"){
		resourcetype=1;
	}else if(appType=="crm"){   
		resourcetype=4;
	}else if(appType=="workflow"){   
		resourcetype=0;
	}else if(appType=="project"){   
		resourcetype=3;
	}
	return resourcetype;
}

function getRequestUrl(appType, requestId){
	var url = "";
	if(appType=="doc"){
		url="/docs/docs/DocDsp.jsp?id="+requestId;
	}else if(appType=="crm"){   
		url="/CRM/data/ViewCustomer.jsp?CustomerID="+requestId;
	}else if(appType=="workflow"){   
		url="/workflow/request/ViewRequest.jsp?requestid="+requestId;
	}else if(appType=="project"){   
		url="/proj/data/ViewProject.jsp?ProjID="+requestId;
	}
	return url;
}


function appCallback(event,data,name,oldid){
	if(data){
	   var sHtml="";
       var ids=data.id;
       var names=data.name;
       if(ids.split(",").length>10){
          window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(126995, user.getLanguage())%>");  //您选择的数量太多，请重新选择！
       }else if(ids.length>0){
          var tempids=ids.split(","); 
          var tempnames=names.split(",");
          if(appType =='disk'){
			   var sharetypes = data.sharetype.split(",");
		  }          
          for(var i=0;i<tempids.length;i++){
              var tempid=tempids[i];
              var tempname=tempnames[i];
              if(tempid=='') continue;
              
              var url=getRequestUrl(appType, tempid);
              var resourcetype=getResourcetype(appType);
			  	
              var sendObj=$(targetObj).parents(".chatdiv").find(".chatSend");
              var targetid=sendObj.attr("_acceptid");
              var targetType=sendObj.attr("_chattype");
              var resourceids=ChatUtil.getMemberids(targetType, targetid,true);
              var sharegroupid=targetType==1?targetid:"";
		      var data={"shareid":tempid,"sharetitle":tempname,"sharetype":appType,"objectName":"FW:CustomShareMsg"};
		      if(appType == 'card'){
				  data = {"hrmCardid":tempid,"textContent":tempname,"sharetype":appType,"objectName":"FW:PersonCardMsg"};
			  }
			  if(appType =='disk'){
				data={"shareid":tempid,"sharetitle":tempname,"sharetype":sharetypes[i],"objectName":"FW:CustomShareMsg"}; 
			  }
		      var shareDataObj = targetObj.data("shareData") || new Array();
		      shareDataObj.push({data: data, sendObj: sendObj, tempid: tempid, sharegroupid: sharegroupid, resourceids: resourceids, resourcetype: resourcetype});
		      targetObj.data("shareData", shareDataObj);
          }
          
          sendShareMsgs();
       }
    }
}

function sendShareMsgs(){
	 if(targetObj){
	 	var sendTimerId = setInterval(function(){
		   var shareDataObj = targetObj.data("shareData");
		   if(shareDataObj && shareDataObj.length > 0){
		   		 var shareData = shareDataObj.shift();
		   		 ChatUtil.sendIMMsg(shareData.sendObj,6,shareData.data, function(msg){
		   		 	if(appType == 'card') return;
					if(msg && msg.issuccess){
						//保存权限
						if(appType =='disk'){
							var shareType  = shareData.data.sharetype;
							var msgobj = msg.paramzip.msgobj;
							var sendType = shareData.sharegroupid ==""?1:2;
							addNetWorkFileShare(shareData.tempid,msgobj.targetid,sendType,shareType,msgobj.timestamp)
						}else if (appType == 'crm'){
							var msgobj = msg.paramzip.msgobj;
							var targetType = msgobj.targetType;							
							var targetId = msgobj.targetid;
						try{
							var extraObj =  eval("("+msgobj.extra+")");							
							var shareid = extraObj.shareid;
						}catch(e){
						}
 							if(targetType =='0'){
								shareCrm(shareid,targetId);
							}else{
								typeof client ==='object' && client.getDiscussionMemberIds(targetId ,function(ids){shareCrm(shareid,ids+"")});
							}
						}else{							
							addShareRight(shareData.resourcetype, shareData.tempid, shareData.sharegroupid, shareData.resourceids);
						}
					}
				  });
		   }else{
		   		window.clearInterval(targetObj.data("sendTimerId"));
		   		targetObj.removeData("shareData");
		   }
	  	}, 500);
	  	targetObj.data("sendTimerId", sendTimerId);
	 }
}

function addShareRight(resourcetype, resourceid, sharegroupid, receiverids, callback){
	$.post("/mobile/plugin/chat/addShare.jsp"+
		"?resourcetype="+resourcetype+
		"&resourceid="+resourceid+
		"&sharegroupid="+sharegroupid,
		{"resourceids":receiverids},function(){
			if(typeof callback == 'function'){
				callback();
			}
		});
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
	}else if(sharetype=="crm"){
		url="/CRM/data/ViewCustomer.jsp?CustomerID="+shareid;
	}else if(sharetype=="task"){
		url="/rdeploy/task/data/Main.jsp?taskid=" + shareid
	}else if(sharetype=="folder"){
		 // pc端对拖拽特殊处理
		 if(checkShare(obj)){
				var _userid = "<%= user.getUID() %>";
				var targetid = '';
			try{
				targetid = ChatUtil.getchatwin(obj).attr('_targetid');
			}catch(e){				
			}
			if(_userid != sharer){
				url="/rdeploy/chatproject/doc/index.jsp?type=shareMy&categoryid=" + shareid + "&targetid=" + targetid;
			}else{
				url="/rdeploy/chatproject/doc/index.jsp?type=myShare&categoryid=" + shareid + "&targetid=" + targetid;
			}
		}else{
				return;
		}
	}else if(sharetype=="pdoc"){
			if(checkShare(obj)){
				url="/rdeploy/chatproject/doc/imageFileView.jsp?fileid=" + shareid
			}else{
				return;
			}
	}else if(sharetype =="vote"){
			docUtil.voteView(obj,shareid);
			return;
		}

    if(typeof parent.from != 'undefined' && parent.from == 'pc'){
			parent.PcExternalUtils.openUrlByLocalApp(url);
     } else {
		if(sharetype=="pdoc" ||sharetype=="folder"){
			IM_Ext.showMsg("暂不支持web端浏览，请用客户端查看！");
		}else{
			window.open(url);
		}
    	
    }
}

function checkShare(obj)
{
	var shareid=$(obj).attr("_shareid");
	var sharetype=$(obj).attr("_sharetype");
	var sharer=$(obj).attr("_senderid");
	var targetid = '';
	try{
		targetid = ChatUtil.getchatwin(obj).attr('_targetid');
	}catch(e){
	
	}
	// 目录已删除
	// 文档已删除
	// 分享已取消
	var flag = false;
	jQuery.ajax({
       type: "POST",
       url: "/rdeploy/chatproject/doc/eventForAjax.jsp",
	   data : {type : "checkShare",sharetype : sharetype,fid : shareid,sharer : sharer,targetid : targetid},
	   async: false,
	   dataType : "json",
	   success: function(data){
		   if(data){
			   if(data.flag == 1){
					flag = true;
				}else if(data.flag == 2){ //删除
					$(obj).html((sharetype=="folder" ? "目录" : "文件") + "已删除").removeAttr("onClick").css("color","red");
				}else if(data.flag == 3){ //取消
					$(obj).html("分享已取消").removeAttr("onClick").css("color","red");
				}
		   }
	   }
	});
	return flag;
	
}

function viewHrmCard(hrmid){
	window.open("/hrm/HrmTab.jsp?_fromURL=HrmResource&id="+hrmid);
}

/*检查群名称长度*/
function checkDsNameLen(obj){
	var $input = $(obj);
	var ev = event || window.event;
	if(ev.keyCode == 8 || ev.keyCode == 46){ //backspace or delete
		return true;
	}
	if($input.val().length >= 40){
		return false;
	}else{
		return true;
	}
}

/*检查字符串长度*/
function checkWordLen(str){
	if(str == "<br>" || str == ""){
		return true;
	}
	if(IMUtil.getStrLen(str) > IMUtil.settings.WORDMAXLEN * 2){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(126996, user.getLanguage())%>");  //群公告的字数超过上限
		return false;
	}
	return true;
}

function getPostUrl(url){
	return url;
}

function cleargroupmsg(obj){
 	$(obj).parents('.chatgroupmsga').hide();
}
  
function showChatPopBox(obj){
 	hideChatPopBox();
 	//隐藏滚动条
 	IMUtil.showIMScrollbar(false, $('.chatList,.acclist,.noteList,.bingList'));
 	$(obj).find(".popBox").show();
 	stopEvent();
 }
 
 function hideChatPopBox(obj){
 	//显示滚动条
	IMUtil.showIMScrollbar(true, ChatUtil.getCurChatwin().find('.chatList,.acclist,.noteList,.bingList'));
 	$(".popBox").hide();
 	stopEvent();
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
  
  function hideChatWinScrollers(){
  	var scrollObjs = $("#chatIMdivBox div[_scrollbarid]");
  	var scrollid;
  	scrollObjs.each(function(){
  		scrollid = $(this).attr('_scrollbarid');
  		$('#'+scrollid).hide();
  	});
  }
  
  function isSlideDivOn(){
  	return $('#imSlideDiv').is(':visible');
  }
  
  //原型方法： closediv 为了添加pc版的拖动
  function closeIMdiv(obj){
		document.getElementById('mainsupports').style.display="none";
		document.getElementById('message_table').style.display="none";
	  	if(typeof from != 'undefined' && from == 'pc'){
			DragUtils.restoreDrags();
		}
		var onclickbak = $(obj).data('onclickbak');
		console.log('onclickbak:', onclickbak);
		//$(obj).attr('onclick', onclickbak);
		void(0);
	}
	
	//文件搜索
	function doSearchAccFile(obj, evt, isClick){
		if(isClick || (evt || window.event).keyCode == 13){
			var chatdiv = ChatUtil.getchatdiv(obj);
			var keywordInput = $(obj).closest(".bSearchdiv").find('input.keyword');
			var keyword = keywordInput.val();
			//关键字只包含空格符号
			if(keyword != '' && $.trim(keyword) == ''){
				keywordInput.val('');
				return;
			}
			chatdiv.find(".chatActiveTab").click();
		}
	}
	
	//alert
	function showImAlert(text, callback){
		setTimeout(function(){
			if(typeof from != 'undefined' && from == 'pc') {
	            DragUtils.closeDrags();
	        }
			window.top.Dialog.alert(text, function(){
				if(typeof from != 'undefined' && from == 'pc') {
		            DragUtils.restoreDrags();
		        }
		        if(typeof callback === 'function')
		        	callback();
			});
		}, 200);
	}
	
	//confirm
	function showImConfirm(text, callback){
		setTimeout(function(){
			if(typeof from != 'undefined' && from == 'pc') {
	            DragUtils.closeDrags();
	        }
	        window.top.Dialog.confirm(text, function(){
	        	if(typeof from != 'undefined' && from == 'pc') {
		            DragUtils.restoreDrags();
		        }
		        if(typeof callback === 'function')
		        	callback();
	        }, function(){
	        	if(typeof from != 'undefined' && from == 'pc') {
		            DragUtils.restoreDrags();
		        }
	        });
	    }, 200);
	}
	function openUrlFromEmessge(url,type){
		var strRegex  = /^(:\/\/)/;
		if(strRegex.test(url)){
			url = url.replace(strRegex,"http://");
		}
		if(url.indexOf(":")==-1||url.indexOf(":")>5){
			url = "http://" +url;
		}
		if(typeof from !=='undefined' && from =="pc"){
			PcExternalUtils.openUrlByLocalApp(url,1)
		}else{
			window.open(url,'_blank');
		}
	}
	//保存网盘分享到自己云盘
    function saveToMyselfDisk(_categoryid,_folderid,_fileid){
		jQuery.ajax({
			url : "/rdeploy/chatproject/doc/eventForAjax.jsp",
			data : {
				"type" : "save2Disk",
				"categoryid" : _categoryid,//所选目录id
				"folderid" : _folderid,//目录id
				"fileid" : _fileid//文件id
			},
			type : "post",
			dataType : "json",
			success : function(data){
				if(data.flag == 1){
					IM_Ext.showMsg(data.msg);
				}else{
					IM_Ext.showMsg(data.msg);
				}
			}
		});
	}
	//取消网盘分享
	function cancelShareDisk(_folderid,_fileid,_msgid){
		jQuery.ajax({
				url : "/rdeploy/chatproject/doc/eventForAjax.jsp",
				data : {
					"type" : "cancelShareObj",
					"folderid" : _folderid,//目录id
					"fileid" : _fileid,//文件id
					"msgid": _msgid
				},
				type : "post",
				dataType : "json",
				success : function(data){
					if(data.flag ==1){
						IM_Ext.showMsg(data.msg);
					}else{
						IM_Ext.showMsg(data.msg);
					}
				}
			});
	}
		//加入网盘分享
	function addNetWorkFileShare(_fileid,_targetId,_sharetype,_filetype,_msgid){
		
		jQuery.ajax({
			url : window.Electron.ipcRenderer.sendSync('global-getHost') +"/docs/networkdisk/addNetWorkFileShare.jsp",
			data : {
				'tosharerid':_targetId,
				'fileid':_fileid,
				'sharetype':_sharetype,
				'filetype':_filetype,
				'msgid' : _msgid
			},
			type : "post",
			dataType : "json",
			success : function(data){
				//console.log(data);
			}
		});
	}
	//转发加入网盘
	function shareDiskFileOrFolder(_userids,_groupids,_folderid,_fileid,_msgid){
		
		//userids：分享人ID，如果多个","分割。
		//groupids：分享群组ID，如果多个","分割。
		//folderid：目录ID，如果消息是目录，如果不是目录可不传。
		//fileid：文件ID，如果消息是文件，如果不是可不传。
		jQuery.ajax({
			url : window.Electron.ipcRenderer.sendSync('global-getHost') +"/mobile/plugin/networkdisk/shareDiskFileOrFolder.jsp",
			data : {
				'userids':_userids,
				'groupids':_groupids,
				'folderid':_folderid,
				'fileid':_fileid,
				'msgid' : _msgid
			},
			type : "post",
			dataType : "json",
			success : function(data){
				//console.log(data);
			}
		});
	}
	//客户卡片信息加入权限
	function shareCrm(_cid,_uid){
		//_cid：客户id 
		//_uid：人员id，如果多个","分割（群）。
		jQuery.ajax({
			url : window.Electron.ipcRenderer.sendSync('global-getHost') +"/mobile/plugin/crm/CrmServiceForMobile.jsp",
			data : {
				'cid':_cid,
				'uid':_uid
			},
			type : "post",
			dataType : "json",
			success : function(data){
				//console.log(data);
			}
		});
	}
	
	function setInputAreaAutoResize(){
		var chatwin = ChatUtil.getCurChatwin(window.self);
        chatwin.find('.chatbottom').css({'height': 'auto', 'top': 'unset'});
        chatwin.find('.chatList').css('bottom', '170px');
	}
	
		
	function countByte(content){
	  var reg = /[\u4e00-\u9fa5]/g;
		if (content==undefined)return 0;
		var chinese = content.match(reg);
	  try{
	  	var chlength = chinese.length;
	  }catch(err){
	  	var chlength=0;
	  }
	  var english = content.length - chlength;
	  return english+chlength*2;
	}
	  
	
</script>