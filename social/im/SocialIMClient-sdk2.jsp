<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.hrm.User" %>
<%@page import="weaver.mobile.rong.RongConfig"%>
<%@page import="weaver.mobile.rong.RongService"%>
<%@page import="weaver.social.SocialUtil"%>
<%@page import="weaver.mobile.rong.WeaverRongUtil"%>
<%@page import="weaver.hrm.company.DepartmentComInfo"%>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<%
	
	WeaverRongUtil rongUtil=WeaverRongUtil.getInstanse();
	String userid=""+user.getUID();
	String username = ""+user.getLastname();
	String messageUrl =ResourceComInfo.getMessagerUrls(userid);
	String jobtitle = SocialUtil.getUserJobTitle(userid);
	jobtitle = jobtitle.replaceAll("\n","").replaceAll("\r", "");
	//获取个性签名
	String signatures = SocialUtil.getSignatures(userid);
	String mobile  = SocialUtil.getUserMobile(userid);
	//前端展示手机
	String mobileShow = SocialUtil.getUserMobileShow(userid);
	Map<String,String> rongConfig=rongUtil.getRongConfig(userid, username,messageUrl);
	String deptid=ResourceComInfo.getDepartmentID(userid);
	String supdeptid=DepartmentComInfo.getDepartmentsupdepid(deptid);
	String TOKEN=rongConfig.get("TOKEN");  //应用token
	String APPKEY =rongConfig.get("APPKEY");//应用key
	String UDID =rongConfig.get("UDID");//用户区分标识
	
	long currentTime=System.currentTimeMillis();

	boolean isOffLineMsg=true;
	
	//String scheme=request.getScheme();
%>
<script>
	//全局参数设置
	window['RongOpts'] = {
		NAVI_URL:"http://nav.cn.ronghub.com/", // navi 地址,必传。
		PB_URL:"/social/im/js/ronglib/protobuf.min.0.6.js", // protobuf.js 必传
		SWF_URL:"/social/im/js/ronglib/swfobject-0.2.min.js",// 可选 。
		XHR_URL:"/social/im/js/ronglib/xhrpolling.0.4.js",// Comet 解析消息对象，必传 。
		API_URL:"http://api.cn.ronghub.com/",
		EMOJI_BG_IMAGE:"/social/im/js/css-sprite_bg.png",
		VOICE_LIBAMR:"/social/im/js/libamr.js", 
		VOICE_PCMDATA:"/social/im/js/pcmdata.min.js",
		VOICE_AMR:"/social/im/js/amr.js",
		VOICE_SWFOBJECT:"/social/im/js/swfobject.js",
		VOICE_PLAY_SWF:"/social/im/js/player.swf"
	}
	var browserName = $.client.browserVersion.browser;             //浏览器名称
	var browserVersion = parseInt($.client.browserVersion.version);//浏览器版本
	if(browserName == "IE"&&browserVersion<10){
		window.WEB_XHR_POLLING  = true;
		window['RongOpts']['WEB_XHR_POLLING'] = true;
	}else{
		window.WEB_XHR_POLLING  = false;
		window['RongOpts']['WEB_XHR_POLLING'] = false;
	}
</script>

<script type="text/javascript">
	if(/^https/i.test(document.location.protocol)){
		window['RongOpts']['WS_PROTOCOL'] = 'wss';
		window['RongOpts']['PROTOCOL'] = 'https';
		window['RongOpts']['NAVI_URL'] = "https://nav.cn.ronghub.com/";
		window['RongOpts']['API_URL'] = "https://api.cn.ronghub.com/";
		document.write('<script src="https://cdn.ronghub.com/RongIMLib-2.2.7.min.js"><\/script>');
        document.write('<script src="https://cdn.ronghub.com/RongIMVoice-2.2.4.min.js"><\/script>');
        document.write('<script src="https://cdn.ronghub.com/RongEmoji-2.2.4.min.js"><\/script> ');
	}else{
		window['RongOpts']['WS_PROTOCOL'] = 'ws';
		window['RongOpts']['PROTOCOL'] = 'http';
		window['RongOpts']['NAVI_URL'] = "http://nav.cn.ronghub.com/";
		window['RongOpts']['API_URL'] = "http://api.cn.ronghub.com/";
		document.write('<script src="http://cdn.ronghub.com/RongIMLib-2.2.7.min.js"><\/script>');
        document.write('<script src="http://cdn.ronghub.com/RongIMVoice-2.2.4.min.js"><\/script>');
        document.write('<script src="http://cdn.ronghub.com/RongEmoji-2.2.4.min.js"><\/script> ');
	}
</script>

<script type="text/javascript">
var M_APPKEY = '<%=APPKEY%>';
var M_UDID = '<%=UDID%>';
var M_TOKEN = '<%=TOKEN%>';

var M_INITED = false;
var M_CORE = RongIMClient;
var M_USERID = '<%=userid%>';
var M_USERNAME = '<%=username%>';
var M_CURRENTTIME=Number('<%=currentTime%>');
var M_SERVERSTATUS=false; //链接状态
var M_OTHERDEVICE=false;  //其他设备登陆
var M_ISRECONNECT=false;  //是否重新连接
var M_ISFORCEONLINE=false; //是否强制下线
var M_NET_ERR=false; //是否出现网络故障

var timeCountInterval=setInterval(function(){
	M_CURRENTTIME=M_CURRENTTIME+1000;
},1000);

var getIMUserId = function(userId) {
	try{
		var sufs = '|'+M_UDID;
		var index = userId.indexOf(sufs);
		if (index == -1) {
			return userId + sufs;
		}else{
			return userId.substring(0, index + sufs.length);
		}
	}catch(e){}
	return userId + '|' + M_UDID;
};

var getRealUserId = function(imUserId) {
	if (imUserId) {
		//alert(imUserId);
		try{
			var index = imUserId.indexOf('|');
			if (index > 0) {
				return imUserId.substring(0, index);
			}
		}catch(e){}
	}
	return imUserId;
};
function setRongSocketStatus(flag){
	$.post("/social/im/ServerStatus.jsp?p=socketstatus&socketstatus="+flag+"&websessionkey="+websessionkey);
}
function checkLoginStatus(){
	//if(from!="pc"){
		$.post("/social/im/SocialIMOperation.jsp?operation=checkPCLogin",{"websessionkey":websessionkey},function(data){
			data=$.trim(data);
			if((data == 1||data==-1||data==2)&&from!="pc"){
				if(data !=2){
					window.top.Dialog.alert('<%=SystemEnv.getHtmlLabelName(126971, user.getLanguage())%>'); //您已使用e-message客户端登录,web端已经自动退出
				}	                
                clearInterval(parent.webLoginStatusHandle);                
                parent.isLoginOut=true;
                // 关闭图片预览
				$('.miniClose', parent.document).click();
				setTimeout(function(){
					$("#IMbg",parent.document).remove();
					$("#immsgdiv",parent.document).remove();
					$("#addressdiv",parent.document).remove();
				}, 20);
				
			}
		})
	//}
}

if (typeof console == "undefined") {
    this.console = {log: function() {}};
}

function writeLog(log){
		var ua = navigator.userAgent.toLowerCase();
		if(ua.match(/chrome\/([\d.]+)/)){
		   console.log(log);
		}   
	}

(function(w) {
	var browserName = $.client.browserVersion.browser;             //浏览器名称
	var browserVersion = parseInt($.client.browserVersion.version);//浏览器版本
	if(browserName == "IE"&&browserVersion<10){
		w.WEB_XHR_POLLING  = true;
	}else{
		w.WEB_XHR_POLLING = false;
	}
	//w.WEB_SOCKET_FORCE_FLASH = true;
	//w.FORCE_LOCAL_STORAGE = true;
	<%if(isOffLineMsg){%>
		RongIMClient.isSyncOfflineMsg=true;
	<%}else{%>
	    RongIMClient.isSyncOfflineMsg=false;
    <%}%>
    
    // 重写message对象
	
	IMClient = function(listeners) {
		if (M_INITED) {
			throw '-----already has an instance-----';
		}
		if (!listeners) {
			throw '-----please set listeners-----';
		}
		if (!listeners.onMessageReceived) {
			throw '-----please set onMessageReceived-----';
		}
		if (!listeners.onConnectionStatusChanged) {
			listeners.onConnectionStatusChanged = function (status) {
	            switch (status) {
	                //链接成功
	                case RongIMLib.ConnectionStatus.CONNECTED:
	                    console && console.log('链接成功');
	                    M_SERVERSTATUS=true;
	                    M_OTHERDEVICE=false;
	                    M_NET_ERR = false;
						setRongSocketStatus(1);
	                    break;
	                //正在链接
	                case RongIMLib.ConnectionStatus.CONNECTING:
	                    console && console.log('正在链接');
	                    break;
	                //重新链接
	                case RongIMLib.ConnectionStatus.RECONNECT:
	                    console && console.log('重新链接');
	                    break;
	                //其他设备登陆
	                case RongIMLib.ConnectionStatus.KICKED_OFFLINE_BY_OTHER_CLIENT:
	                	console && console.log('其他设备登陆');
	                	M_OTHERDEVICE=true;
	                	checkLoginStatus();
	                    break;
	                //连接关闭
	                case RongIMLib.ConnectionStatus.DISCONNECTED:
	                	console && console.log('链接断开');
	                	M_SERVERSTATUS=false;
						setRongSocketStatus(0);
	                	if(!M_OTHERDEVICE){ //非其他设备登陆造成的断开就重新连接
	                		client.reconnect();
	                	}
	                	if(WindowDepartUtil.isAllowWinDepart()){
                            WindowDepartUtil.closeChatWin();
                        }
	                	break;
	                //未知错误
	                case RongIMLib.ConnectionStatus.UNKNOWN_ERROR:
	                	console && console.log('未知错误');
	                	M_SERVERSTATUS=false;
	                    break;
	                //登出
	                case RongIMLib.ConnectionStatus.LOGOUT:
	                	console && console.log('登出');
	                	M_SERVERSTATUS=false;
	                    break;
	                //用户已被封禁
	                case RongIMLib.ConnectionStatus.BLOCK:
	                	console && console.log('用户已被封禁');
	                	M_SERVERSTATUS=false;
	                    break;
	                //"DOMAIN_INCORRECT"
	                case RongIMLib.ConnectionStatus.DOMAIN_INCORRECT:
                        console && console.log('域不正确');
                        M_SERVERSTATUS=false;
                        break;
	                //网络不可用
	                case RongIMLib.ConnectionStatus.NETWORK_UNAVAILABLE:
	                	console && console.log('网络不可用');
	                	M_NET_ERR=true;
	                	M_SERVERSTATUS=false;
	                	if(WindowDepartUtil.isAllowWinDepart()){
                            WindowDepartUtil.closeChatWin();
                        }
	                	if(typeof ChatUtil != 'undefined'){
	                		setTimeout(function(){
	                			var chatWin= ChatUtil.getCurChatwin(), needNotice = false;
	                			var chatWinFloatMsgdiv = chatWin.find('.chatWinFloatMsgdiv');
								if(chatWin.length>0){
									if(chatWinFloatMsgdiv.length==0||chatWinFloatMsgdiv.attr('msgflag')!='network_error'||chatWinFloatMsgdiv.is(':hidden')){
										needNotice = true;
									}			
								}
	                			if(!M_SERVERSTATUS ) {
	                				if(needNotice) {
	                					ChatUtil.postFloatNotice("网络连接故障", "info", {
		                					"msgflag":"network_error"
		                				});
		                				if(M_NET_ERR){
			                				M_CORE.setConnectionStatusListener(client.connectionStatusListener);
											M_CORE.connect(M_TOKEN, client.connectionListener);
			                			}
	                				}
	                				setTimeout(arguments.callee, 1000);
	                			}else if(!needNotice){
	                				$(".chatWinFloatMsgdiv[msgflag='network_error']").find(".clearmsg").click();
	                			}
	                			if(M_SERVERSTATUS) {
	                				M_NET_ERR = false;
	                			}
	                		}, 1000);
	                	}
		        		break;
	            }
            };
		}
		var receiveMessageListener = {
			onReceived : function(data) {
				/*
				if (data instanceof M_CORE.NotificationMessage || data instanceof M_CORE.StatusMessage) {
	                return;
	            }
	            */
	            //设置会话名称
	            /*
	            M_CORE.getInstance().getConversation(data.conversationType, data.targetId, {
	            	onSuccess: function(tempval){
	            		console.log(tempval);
	            		
	            		if (tempval.conversationTitle == undefined) {
			                switch (tempval.conversationType) {
			                    case RongIMLib.ConversationType.DISCUSSION:
			                        tempval.conversationTitle = '群:' + tempval.targetId;
			                        break;
			                    case RongIMLib.ConversationType.PRIVATE:
			                        M_CORE.getInstance().getUserInfo(tempval.targetId, {
			                            onSuccess: function (x) {
			                                tempval.setConversationTitle(x.getUserName());
			                            },
			                            onError: function () {
			                                tempval.conversationTitle = "陌生人Id：" + tempval.targetId;
			                            }
			                        });
			                        break;
			                    default :
			                        tempval.conversationTitle = '该会话类型未解析:'+tempval.conversationType + tempval.targetId;
			                }
			            }
	            	},
	            	onError: function(tempval){
	            		console.log(tempval);
	            	}
	            });
	            */
	            listeners.onMessageReceived(data);
			}
		};
		var connectionStatusListener = {
			onChanged : listeners.onConnectionStatusChanged
		};
		M_CORE.init(M_APPKEY);
		// 注册自定义消息
		//计数型自定义消息
		M_CORE.registerMessageType('AttachmentMessage','FW:attachmentMsg',new RongIMLib.MessageTag(true,true),["content","extra"]);
		M_CORE.registerMessageType('CustomShareMessage','FW:CustomShareMsg',new RongIMLib.MessageTag(true,true),["content","extra"]);
		M_CORE.registerMessageType('PublicNoticeMessage','RC:PublicNoticeMsg',new RongIMLib.MessageTag(true,true),["content","extra"]);
		M_CORE.registerMessageType('CustomMessage','FW:CustomMsg',new RongIMLib.MessageTag(true,true),["content","extra"]);
		M_CORE.registerMessageType('PersonCardMessage','FW:PersonCardMsg',new RongIMLib.MessageTag(true,true),["content","extra"]);
		M_CORE.registerMessageType('RichTextMessage','FW:richTextMsg',new RongIMLib.MessageTag(true,true),["content","extra"]);
		M_CORE.registerMessageType('CancelShareMessage','FW:InfoNtf',new RongIMLib.MessageTag(true,true),["content","extra"]);		
		M_CORE.registerMessageType('CustomShareMsgVote','FW:CustomShareMsgVote',new RongIMLib.MessageTag(true,true),["content","extra"]);
		M_CORE.registerMessageType('InfoNtfVote','RC:InfoNtfVote',new RongIMLib.MessageTag(true,true),["content","extra"]);
		//不计数型自定义消息
		M_CORE.registerMessageType('CountMessage','FW:CountMsg',new RongIMLib.MessageTag(false,false),["content","extra"]);
		M_CORE.registerMessageType('SyncQuitGroupMessage','FW:SyncQuitGroup',new RongIMLib.MessageTag(false,false),["content","extra"]);
		M_CORE.registerMessageType('SyncMsgMessage','FW:SyncMsg',new RongIMLib.MessageTag(false,false),["content","extra"]);
		M_CORE.registerMessageType('ClearUnreadCountMessage','FW:ClearUnreadCount',new RongIMLib.MessageTag(false,false),["content","extra"]);
		M_CORE.registerMessageType('SysMessage','FW:SysMsg',new RongIMLib.MessageTag(false,false),["content","extra"]);
		M_CORE.setConnectionStatusListener(connectionStatusListener);
		//M_CORE.getInstance().setOnReceiveMessageListener(receiveMessageListener);
		M_CORE.setOnReceiveMessageListener(receiveMessageListener);
		var syncConversationList = function() {
			M_CORE.getInstance().syncConversationList({
                onSuccess: function () {
                    //同步会话列表
                    setTimeout(function () {
                        var conversationList = M_CORE.getInstance().getConversationList();
                        var conversations = [];
                        var temp = null;
                        for (var i = 0; i < conversationList.length; i++) {
                            temp = conversationList[i];
                            temp.setTargetId(getRealUserId(temp.getTargetId()));
                            switch (temp.getConversationType()) {
                                case RongIMLib.ConversationType.CHATROOM:
                                    temp.setConversationTitle('聊天室');
                                    break;
                                case RongIMLib.ConversationType.CUSTOMER_SERVICE:
                                    temp.setConversationTitle('客服');
                                    break;
                                case RongIMLib.ConversationType.DISCUSSION:
                                    temp.getConversationTitle()||temp.setConversationTitle('群:' + temp.getTargetId());
                                    conversations.push(temp);
                                    break;
                                case RongIMLib.ConversationType.GROUP:
                                    temp.setConversationTitle('讨论群:' + temp.getTargetId());
                                    break;
                                case RongIMLib.ConversationType.PRIVATE:
                                	if (!temp.getConversationTitle()) {
                                		if (temp.getTargetId() == M_USERID) {
                                			temp.setConversationTitle(M_USERNAME);
                                		} else {
                                			temp.setConversationTitle('陌生人:'+temp.getTargetId());
                                		}
                                	}
                                    conversations.push(temp);
                                    break;
                            }
                        }
                        if (typeof(listeners.onConversationListChanged) === 'function') {
                        	listeners.onConversationListChanged(conversations);
						}
						//alert("会话变更");
                    }, 1000);
                }, onError: function () {
                    console && console.log("syncConversationList fail");
                }
            });
		};
        var connectionListener = {
			onSuccess : function(imUserId) {
				//syncConversationList();
				if (typeof(listeners.onConnectionSuccess) === 'function') {
					if(typeof versionTag != 'undefined')
						getConversationList(versionTag);
					else
						getConversationList();
					RongIMLib.RongIMVoice.init();
					RongIMLib.RongIMEmoji.init();
					listeners.onConnectionSuccess(getRealUserId(imUserId));
				}
			},
			onError : listeners.onConnectionError,
           // token不合法
           onTokenIncorrect: listeners.onTokenIncorrect
		};
		this.connectionStatusListener = connectionStatusListener;
		this.connectionListener = connectionListener;
		M_CORE.connect(M_TOKEN, connectionListener);
		M_INITED = true;
	};

	IMClient.prototype = new Object();
	//发送消息给个人
	IMClient.prototype.sendMessageToUser = function(toId, msgObj,msgType,callback) {
		this.sendMessage(RongIMLib.ConversationType.PRIVATE, getIMUserId(toId), msgObj,msgType, callback);
	};
	//发送消息给群
	IMClient.prototype.sendMessageToDiscussion = function(toId, msgObj, msgType,callback) {
		this.sendMessage(RongIMLib.ConversationType.DISCUSSION, toId, msgObj, msgType,callback);
	};
	//发送message消息
	IMClient.prototype.sendIMMsg = function(toId, msgObj, msgType,callback) {
		var targetType=msgObj.targetType;
		if(targetType=="0")
			this.sendMessage(RongIMLib.ConversationType.PRIVATE, getIMUserId(toId), msgObj,msgType,callback);
		else	
			this.sendMessage(RongIMLib.ConversationType.DISCUSSION, toId, msgObj, msgType,callback);
	};
	IMClient.prototype.sendMessage = function(conversationType, toId, msgObj,msgType,callback) {
		var content=msgObj.content;
		var imgUrl=msgObj.imgUrl;
		var objectName=msgObj.objectName;
		var extra=msgObj.extra;
		var msg;
		if(msgType==1){//文本
			msg=IMClient.TextMessage.obtain(content);
		}else if(msgType==2) //图片	
			msg=IMClient.ImageMessage.obtain(content,imgUrl);
		else if(msgType==3){ //语音
			msg=IMClient.VoiceMessage.obtain(content,msgObj.detail.duration);
		}else if(msgType==6){ //自定义消息
			switch(objectName) {
				case "FW:attachmentMsg": msg = new M_CORE.RegisterMessage.AttachmentMessage(msgObj);break;
				case "FW:CustomShareMsg": msg = new M_CORE.RegisterMessage.CustomShareMessage(msgObj);break;
				case "RC:PublicNoticeMsg": msg = new M_CORE.RegisterMessage.PublicNoticeMessage(msgObj);break;
				case "FW:CustomMsg": msg = new M_CORE.RegisterMessage.CustomMessage(msgObj);break;
				case "FW:PersonCardMsg": msg = new M_CORE.RegisterMessage.PersonCardMessage(msgObj);break;
				case "FW:richTextMsg": msg = new M_CORE.RegisterMessage.RichTextMessage(msgObj);break;
				case "FW:CountMsg": msg = new M_CORE.RegisterMessage.CountMessage(msgObj);break;
				case "FW:SyncQuitGroup": msg = new M_CORE.RegisterMessage.CountMessage(msgObj);break;
				case "FW:SyncMsg": msg = new M_CORE.RegisterMessage.CountMessage(msgObj);break;
				case "FW:ClearUnreadCount": msg = new M_CORE.RegisterMessage.ClearUnreadCountMessage(msgObj);break;
				case "FW:SysMsg": msg = new M_CORE.RegisterMessage.SysMessage(msgObj);break;
				case "FW:InfoNtf": msg = new M_CORE.RegisterMessage.CancelShareMessage(msgObj);break;
				case "FW:CustomShareMsgVote": msg = new M_CORE.RegisterMessage.CustomShareMsgVote(msgObj);break;
				case "RC:InfoNtfVote": msg = new M_CORE.RegisterMessage.InfoNtfVote(msgObj);break;
			}
		}else if(msgType==8){ // 地理位置
			msg=IMClient.LocationMessage.obtain(msgObj.detail.content, msgObj.detail.latitude, msgObj.detail.longitude, msgObj.detail.poi);
		}else if(msgType==9){
			msg=IMClient.InformationNotificationMessage.obtain(content);
		}else
			msg=IMClient.TextMessage.obtain(content);
		msg.extra = extra;		//设置附加消息	
			
		client.writeLog("-----------发送消息开始----------");
		client.writeLog("objectName:"+objectName);
		client.writeLog("extra:"+extra);
		client.writeLog("msgType:"+msgType);
		client.writeLog("content:"+content);
		client.writeLog("-----------发送消息结束----------");
		
		/*		
		if (!/[24]/.test(msgType)) {	
			throw '-----message type is invalid-----';
		}
		*/
		client.reconnect();
		var con = conversationType;
		M_CORE.getInstance().sendMessage(con,toId, msg, {
            onSuccess: function (data) {
            	var sendtime="", rongsendtime="";
               	try{
               		rongsendtime=data.timestamp;
               	}catch(e){
               		client.error("返回时间异常");
               		rongsendtime=M_CURRENTTIME;
               	}
               	
               	//比较融云返回的时间和oa服务器返回的时间，如果相差超过60s,则重新同步一次oa服务器时间
               	if(Math.abs(M_CURRENTTIME - rongsendtime)/(1000*60) > 1){
               		ChatUtil.getServerTimeStamp(function(ts){
               			M_CURRENTTIME = Number(ts);
               		});
               	}
               	sendtime = rongsendtime;
            	client.error("sendtime:"+sendtime);
            	console && console.log("send successfully");
            	var paramzip = {'chattype':con, 'receverids':toId, 'msgobj':msgObj, 'msgtype':msgType};
            	if(callback){
            		callback({'issuccess': 1,'paramzip':paramzip,'sendtime':sendtime});
            	}
            }, onError: function (err) {
            	client.error("send fail"+" error:"+err);
            	var paramzip = {'chattype':con, 'receverids':toId, 'msgobj':msgObj, 'msgtype':msgType};
            	if(callback){
            		callback({'issuccess': 0, 'err': err, 'paramzip':paramzip});
            	}
            }
        });
	};
	//异步获取群成员id列表
	IMClient.prototype.getDiscussionMemberIds = function(discussionId, callback) {
		M_CORE.getInstance().getDiscussion(discussionId, {
			 onSuccess : function(info) {
			     var memberIds = info.getMemberIdList();
			     for (mIndex in memberIds) {
			     	memberIds[mIndex] = getRealUserId(memberIds[mIndex]);
			     }
			     callback(memberIds);
			     client.writeLog("discuss info:"+info);
			 }, onError : function(err) {
			     console && console.log(err);
			 }
		});
	};
	
	//创建群并发消息
	IMClient.prototype.createDiscussion = function(msgInfo, disName, memList,successCb,errorCb) {
		var opts = {
			 onSuccess : function(info) {
				IMClient.prototype.getDiscussionMemberIds(info,function(ids){
					showIMChatpanel(1,info,disName,'/social/images/head_group.png');	
					for (var i= 0; i < msgInfo.length;i++) {							
						var extraObj = eval("("+msgInfo[i].extra+")"); 
						extraObj.receiverids = ids.join();
						msgInfo[i].extra = JSON.stringify(extraObj);
						IMClient.prototype.sendMessageToDiscussion (info,msgInfo[i],msgInfo[i].msgType,function(msg){
						msg.paramzip.msgobj.chatdivid = msg.paramzip.receverids;
						var userInfo=userInfos[M_USERID];
						var chatList=$(".chatWin").find(".chatList");
						var tempMsgObj={"content":msg.paramzip.msgobj.content,"imgUrl":'',"objectName":msg.paramzip.msgobj.objectName,"extra":msg.paramzip.msgobj.extra,'chatdivid':msg.paramzip.receverids, "timestamp":msg.paramzip.msgobj.timestamp};
						var tempdiv=ChatUtil.getChatRecorddiv(userInfo,tempMsgObj,'send',msg.paramzip.msgobj.msgType, null, msg.paramzip.receverids);
						var sendtime=M_CURRENTTIME;
						addSendtime(chatList,tempdiv,sendtime,"send");
						chatList.append(tempdiv);
						chatList.perfectScrollbar("update");
						scrollTOBottom(chatList);
						chatList.data("newMsgCome", true);		
						ChatUtil.doHandleSendState(msg);
						var issuccess=msg.issuccess;
						if(issuccess==1){
							ChatUtil.doHandleSendSuccess(msg, msg.paramzip.msgobj.timestamp, info, msg.paramzip.msgobj.msgType);
						}
						
				});
						typeof successCb === 'function' && successCb(msgInfo[i].shareFileId,info,2,msgInfo[i].shareFileType);
					 }
				 });
			     client.writeLog("创建群并发消息成功....");
			 }, onError : function(err) {
				 if(typeof errorCb == 'function'){
					 errorCb(err);
				 }
			     client.writeLog("创建群并发消息失败...."+err);
			 }
		};
		M_CORE.getInstance().createDiscussion(disName, memList,opts);
	};		
	
	//退出群
	IMClient.prototype.quitDiscussion = function(discussionId,callback) {
		M_CORE.getInstance().quitDiscussion(discussionId,{
			 onSuccess : function(info) {
			     callback(info);
			     client.writeLog("退出群成功....");
			 }, onError : function(err) {
			     client.writeLog("退出群失败...."+err);
			 }
		});
	};	
	
	//异步添加群成员
	IMClient.prototype.addMemberToDiscussion = function(discussionId,memberids,callback) {
		M_CORE.getInstance().addMemberToDiscussion(discussionId,memberids,{
			 onSuccess : function(info) {
			     callback(info);
			 }, onError : function(err) {
			     console && console.log(err);
			 }
		});
	};
	
	//异步删除群成员
	IMClient.prototype.removeMemberFromDiscussion = function(discussionId,userid,callback) {
		M_CORE.getInstance().removeMemberFromDiscussion(discussionId,userid,{
			 onSuccess : function(info) {
			     callback(info);
			 }, onError : function(err) {
			     console && console.log(err);
			 }
		});
	};
	
	//异步获取群成员id列表
	IMClient.prototype.getDiscussion = function(discussionId, callback) {
		M_CORE.getInstance().getDiscussion(discussionId, {
			 onSuccess : function(info) {
			     callback(info);
			     client.writeLog("discussionId:"+discussionId+" 获取讨论组成功");
			     
			 }, onError : function(err) {
			     console && console.log(err);
			     client.writeLog("discussionId:"+discussionId+" 获取讨论组失败");
			     callback(null);
			 }
		});
	};
	
	//异步获取群名称
	IMClient.prototype.getDiscussionName = function(discussionId, callback) {
		M_CORE.getInstance().getDiscussion(discussionId, {
			 onSuccess : function(info) {
			     callback(info.getName());
			 }, onError : function(err) {
			     console && console.log(err);
			 }
		});
	};
	//异步设置群名称
	IMClient.prototype.setDiscussionName = function(discussionId,discussTitle, callback) {
		M_CORE.getInstance().setDiscussionName(discussionId, discussTitle, {
			 onSuccess : function(info) {
			     callback(info);
			 }, onError : function(err) {
			     console && console.log(err);
			 }
		});
	};
	//获取最近联系人
	IMClient.prototype.getConversationList=function(callback){
	
		M_CORE.getInstance().getConversationList({
                onSuccess: function (list) {
                    //同步会话列表
                    callback(list);
                }, onError: function (error) {
                    console && console.log("syncConversationList fail");
                }
        }, null);
	};
	
	//删除会话
	IMClient.prototype.removeConversation=function(_targettype, _targetId, callback){
		var _conversationType = RongIMLib.ConversationType.DISCUSSION;
		var _imtargetid;
		if('0' == _targettype){	//私聊
			_conversationType = RongIMLib.ConversationType.PRIVATE;
			_imtargetid = getIMUserId(_targetId);
		}else if('1' == _targettype){ //群
			_conversationType = RongIMLib.ConversationType.DISCUSSION;
			_imtargetid = _targetId;
		}
		
		M_CORE.getInstance().removeConversation(_conversationType, _imtargetid);
		callback(_targetId);
        
	};
	//会话置顶
	IMClient.prototype.setConversationToTop=function(_targettype, _targetId, callback){
		var _conversationType = RongIMLib.ConversationType.DISCUSSION;
		var _imtargetid;
		if('0' == _targettype){	//私聊
			_conversationType = RongIMLib.ConversationType.PRIVATE;
			_imtargetid = getIMUserId(_targetId);
		}else if('1' == _targettype){ //群
			_conversationType = RongIMLib.ConversationType.DISCUSSION;
			_imtargetid = _targetId;
		}
		//alert("_imtargetid:"+_imtargetid);
		M_CORE.getInstance().setConversationToTop(_conversationType, _imtargetid);
		
		//var isTop=M_CORE.getInstance().getConversationToTop(_conversationType, _imtargetid).isTop();
		//alert(isTop);
		callback(_targetId);
        
	};
	
	//获取历史消息记录
	IMClient.prototype.getHistoryMessages=function(targetType,targetid,pagesize,callback,isFirst){
	 
	 	try{
			targetid=this.getRongTargetid(targetid,targetType);
			if(typeof pagesize != 'number') {
				pagesize = Number(pagesize);
			}
			
			var conversationtype;
			if(targetType==0)
			   conversationtype=RongIMLib.ConversationType.PRIVATE; 
			else
			   conversationtype=RongIMLib.ConversationType.DISCUSSION;
			
			M_CORE.getInstance().getHistoryMessages(conversationtype,
			targetid,
			isFirst?0:null,
			pagesize,{
			 onSuccess:function(HistoryMessages, hasMsg){
			 
			   callback(hasMsg,HistoryMessages,true);
			   
			 },onError:function(error){
			 
			   callback(false,null,false,error);
			   
			 }
			});
		} catch(err) {
			console.error(err);
			callback(false,null,false,err);
		}
	
	};
	//清空指定会话的未读消息数量
	IMClient.prototype.clearMessagesUnreadStatus=function(targetType,targetId){
	
		var conversationtype=RongIMLib.ConversationType.DISCUSSION;
		if(targetType==0)
		   conversationtype=RongIMLib.ConversationType.PRIVATE;
		
		M_CORE.getInstance().clearMessagesUnreadStatus(RongIMLib.ConversationType.DISCUSSION,targetId, {
			'onSuccess': function(m){},
			'onError': function(m){}
		});
	};
	
	IMClient.prototype.reconnect=function(callback){
	
		if(!M_SERVERSTATUS && !M_ISFORCEONLINE){
			console && console.log('正在重新链接');
			M_ISRECONNECT=true;
			RongIMClient.reconnect({
                 onSuccess:function(){
                    console.log('重新连接成功');
                    if(typeof callback === 'function'){
                    	callback(true);
                    }
                 },
                 onError: function(e){ 
                    console.log('重新连接失败');
                    console.log(e);
                    if(typeof callback === 'function'){
                    	callback(false, e);
                    }
                 }
            });
		}
		
	};
	
	IMClient.prototype.disconnect=function(force){
		if(force){
   			M_ISFORCEONLINE = true;
   		}
		console && console.log('断开链接');
		RongIMClient.getInstance().disconnect();
	};
	
	IMClient.Message = RongIMLib.Message;
	IMClient.DiscussionNotificationMessage = RongIMLib.DiscussionNotificationMessage;
	IMClient.TextMessage = RongIMLib.TextMessage;
	IMClient.ImageMessage = RongIMLib.ImageMessage;
	IMClient.VoiceMessage = RongIMLib.VoiceMessage;
	IMClient.RichContentMessage = RongIMLib.RichContentMessage;
	IMClient.HandshakeMessage = RongIMLib.HandshakeMessage;
	IMClient.UnknownMessage = RongIMLib.UnknownMessage;
	IMClient.SuspendMessage = RongIMLib.SuspendMessage;
	IMClient.LocationMessage = RongIMLib.LocationMessage;
	IMClient.InformationNotificationMessage = RongIMLib.InformationNotificationMessage;
	IMClient.ContactNotificationMessage = RongIMLib.ContactNotificationMessage;
	IMClient.ProfileNotificationMessage = RongIMLib.ProfileNotificationMessage;
	IMClient.CommandNotificationMessage = RongIMLib.CommandNotificationMessage;
	IMClient.RongIMEmoji = RongIMLib.RongIMEmoji;
	IMClient.RongIMVoice = RongIMLib.RongIMVoice;
	IMClient.ConversationType = RongIMLib.ConversationType;
	
	//获取用户真实id
	IMClient.prototype.getRealUserId=function(imUserId){
		if (imUserId) {
			//alert(imUserId);
			try{
				var index = imUserId.indexOf('|' + M_UDID);
				if (index > 0) {
					return imUserId.substring(0, index);
				}
			}catch(e){}
		}
		return imUserId;
	}
	//获取消息类型 0 单聊 1群聊
	IMClient.prototype.getTargetType=function(conversationType,targetid){
		var targetType="-1";
		if(targetid){
		    try{
		    	if(M_SDK_VER == 2){
		    		if(RongIMLib.ConversationType.DISCUSSION == conversationType){
		    			targetType = 1;
		    		}else if (RongIMLib.ConversationType.PRIVATE == conversationType) {
		    			targetType = 0;
		    		}
		    	}else{
		    		var index = targetid.indexOf('|' + M_UDID);
					if(conversationType==2){
						targetType=1; //群聊	
					}else if(conversationType==4){
					    if(targetid.indexOf('|' + M_UDID)>0)
					 		targetType=0; //单聊
					}else {
						console && console.log("会话类型conversationType："+conversationType);
					}
					
		    	}
				
			}catch(e){
			    console && console.log("targetid22:"+targetid);
			}
		}
		
		return targetType;
	}
	
	//获取消息类型 0 单聊 1群聊
	IMClient.prototype.getRealTargetid=function(conversationType,targetid){
		if(targetid){
		    try{
		    	console && console.log("conversationType:"+conversationType+" targetid:"+targetid);
				var index = targetid.indexOf('|' + M_UDID);
				if(conversationType==2){
					return targetid; //群聊	
				}else if(conversationType==4){
				    return getRealUserId(targetid);
				}else {
					console && console.log("targetide无效："+targetid);
				}
				
			}catch(e){
			    console && console.log("targetid:"+targetid);
			}
		}
	}
	
	IMClient.prototype.getRongTargetid=function(realTargetid,targetType){
		var targetid=realTargetid;
		if(targetType==0) targetid=getIMUserId(targetid);
		return targetid;
	}
	
	//打印日志
	IMClient.prototype.writeLog=function(log,obj,level){
		var ua = navigator.userAgent.toLowerCase();
		if(ua.match(/chrome\/([\d.]+)/)){
		   if(isIMdebug){
			   if(level=="error"){
			   		console.error(log);
			   		if(obj){
			   		   console.error(obj);
			   		}
			   }else{
			   		console.log(log);
			   		if(obj){
			   		   console.log(obj);
			   		}
			   }		
		   }
		}   
	}
	//打印错误日志
	IMClient.prototype.error=function(log,obj){
		this.writeLog(log,obj,"error");
	}
	//打印一般日志
	IMClient.prototype.log=function(log,obj){
		this.writeLog(log,obj);
	}
	
	// 扩展Message对象
	RongIMLib.Message.prototype.getMessageId = function(){
		return this.messageId;
	}
	RongIMLib.Message.prototype.getMessageUId = function(){
		return this.messageUId;
	}
	RongIMLib.Message.prototype.getExtra = function(){
		return this.content.extra;
	}
	RongIMLib.Message.prototype.getSenderUserId = function(){
		return this.senderUserId;
	}
	RongIMLib.Message.prototype.getTargetId = function(){
		return this.targetId;
	}
	RongIMLib.Message.prototype.getMessageType = function(){
		var msgType = 1;
		switch(this.messageType){
            case RongIMClient.MessageType.TextMessage:
                msgType = 1;
                break;
            case RongIMClient.MessageType.VoiceMessage:
                msgType = 3;
                break;
            case RongIMClient.MessageType.ImageMessage:
                msgType = 2;
                break;
            case RongIMClient.MessageType.DiscussionNotificationMessage:
                // do something...
                break;
            case RongIMClient.MessageType.LocationMessage:
                msgType = 8;
                break;
            case RongIMClient.MessageType.RichContentMessage:
                // do something...
                break;
            case RongIMClient.MessageType.DiscussionNotificationMessage:
                // do something...
                break;
            case RongIMClient.MessageType.InformationNotificationMessage:
                msgType = 9;
                break;
            case RongIMClient.MessageType.ContactNotificationMessage:
                // do something...
                break;
            case RongIMClient.MessageType.ProfileNotificationMessage:
                // do something...
                break;
            case RongIMClient.MessageType.CommandNotificationMessage:
                // do something...
                break;
            case RongIMClient.MessageType.CommandMessage:
                // do something...
                break;
            case RongIMClient.MessageType.UnknownMessage:
                msgType = 6;
                break;
            default:
                // 自定义消息
                msgType = 6;
        }
        return msgType;
	}
	RongIMLib.Message.prototype.getConversationType = function(){
		return this.conversationType;
	}
	RongIMLib.Message.prototype.getSentTime = function(){
		return this.sentTime;
	}
	RongIMLib.Message.prototype.getObjectName = function(){
		return this.objectName;
	}
	RongIMLib.Message.prototype.getDetail = function(){
		return this.content.detail;
	}
	RongIMLib.Message.prototype.getIsOffLineMessage = function(){
		return this.offLineMessage;
	}
	RongIMLib.Message.prototype.getContent = function(){
		return this.content.content || "";
	}
	RongIMLib.Message.prototype.setContent = function(content){
		return this.content.content = content;
	}
	RongIMLib.Message.prototype.getMessageTag = function(){
		return "";
	}
	RongIMLib.Message.prototype.getImageUri = function(){
		return this.content.imageUri;
	}
	
	RongIMLib.Message.prototype.getDuration = function(){
		return this.content.duration;
	}
	
	RongIMLib.Message.prototype.getLatitude = function(){
		return this.content.latitude;
	}
	
	RongIMLib.Message.prototype.getLongitude = function(){
		return this.content.longitude;
	}
	
	RongIMLib.Message.prototype.getPoi = function(){
		return this.content.poi;
	}
	
	// 扩展Discuss对象
	RongIMLib.Discussion.prototype.getCreatorId = function(){
		return this.creatorId;
	}
	
	RongIMLib.Discussion.prototype.getId = function(){
		return this.id;
	}
	
	RongIMLib.Discussion.prototype.getName = function(){
		return this.name;
	}
	
	RongIMLib.Discussion.prototype.getMemberIdList = function(){
		return this.memberIdList;
	}
	
	// 通知类消息
	RongIMLib.Message.prototype.getType = function(){
		return this.content.type;
	}
	
	RongIMLib.Message.prototype.getOperator = function(){
		return this.content.operator;
	}
	
	RongIMLib.Message.prototype.getExtension = function(){
		return this.content.extension;
	}
	
})(window);

var client;
var userInfos={};
var discussList={};
var settingInfos={};
var localmsgtags={};
var isIMdebug=false;
//var webSql = new WebStorage.websql();

window.onload = function () {
var listeners = {
     	    //接收消息的回调
  		   onMessageReceived:function (data) {
  		          receiveIMMsg(data);
  		          
                 if (data instanceof IMClient.TextMessage) {
                   var p = document.createElement("span");
                   p.style.marginRight = "10px";
                   p.innerHTML = data.getContent();
                   //mydiv.appendChild(p);
                 }
             },
           onConnectionSuccess: function (x) {
                  console && console.log("connected，userid＝" + x);
                  client.getDiscussionMemberIds('58e97436-eb56-451f-9067-202839429d8c', function(memberIds){
			     	//alert('ok');
			   });
                  
                  if(typeof from != 'undefined' && from == 'pc') {
                      RongErrorUtils.close();
                  }
              },
           onConnectionError: function (x) {
                  console && console.log(x)
                  console.info('链接失败');                   
              },
              //最近会话列表
           onConversationListChanged: function(datas){
           	client.writeLog("会话更新datas："+datas.length);
              	for (var i = 0; i < datas.length; i++) {
              		var d = datas[i];
              		//alert(d.getConversationTitle());
              	}
           },
           onTokenIncorrect: function() {
           		if(M_NET_ERR) {
           			M_CORE.setConnectionStatusListener(client.connectionStatusListener);
					M_CORE.connect(M_TOKEN, client.connectionListener);
           		}
           }
               
};

client = new IMClient(listeners);
userInfos[M_USERID]={"userid":"<%=userid%>","userName":"<%=user.getLastname()%>","userHead":"<%=messageUrl%>","deptName":"<%=SocialUtil.getUserDepCompany(userid)%>","jobtitle":"<%=jobtitle%>","mobile":"<%=mobile%>","mobileShow":"<%=mobileShow%>","signatures":"<%=signatures%>"};
}


</script>