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
<%@page import="weaver.general.BaseBean"%>
<%
    BaseBean log = new BaseBean();
    WeaverRongUtil rongUtil=WeaverRongUtil.getInstanse();
    String userid=""+user.getUID();
    String username = ""+user.getLastname();
    //String messageUrl =ResourceComInfo.getMessagerUrls(userid);
    String mobile  = SocialUtil.getUserMobile(userid);
    //前端展示手机
    String mobileShow = SocialUtil.getUserMobileShow(userid);
    //简拼
    String py = SocialUtil.getFirstSpell(username);
    //log.writeLog("========mobile========="+mobile);
    String messageUrl = SocialUtil.getUserHeadImage(userid);
    String jobtitle = SocialUtil.getUserJobTitle(userid);
    jobtitle = jobtitle.replaceAll("\n","").replaceAll("\r", "");
    //获取个性签名
    String signatures = SocialUtil.getSignatures(userid);
    //log.writeLog("========signatures========="+signatures);
    Map<String,String> rongConfig=rongUtil.getRongConfig(userid, username,messageUrl);
    String deptid=ResourceComInfo.getDepartmentID(userid);
    String supdeptid=DepartmentComInfo.getDepartmentsupdepid(deptid);
    String TOKEN=rongConfig.get("TOKEN");  //应用token
    String APPKEY =rongConfig.get("APPKEY");//应用key
    String UDID =rongConfig.get("UDID");//用户区分标识
    
    long currentTime=System.currentTimeMillis();

    boolean isOffLineMsg=true;
    
    String scheme=request.getScheme();
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
<%if(scheme.equals("https")){%>
<script type="text/javascript">
    window['RongOpts']['WS_PROTOCOL'] = 'wss';
    window['RongOpts']['PROTOCOL'] = 'https';
    window['RongOpts']['NAVI_URL'] = "https://nav.cn.ronghub.com/";
    window['RongOpts']['API_URL'] = "https://api.cn.ronghub.com/";
</script>
<!-- 
<script type="text/javascript" src="https://cdn.ronghub.com/RongIMClient-0.9.20.min.js"></script>
<script type="text/javascript" src="https://cdn.ronghub.com/RongIMClient.emoji-0.9.20.min.js"></script>
<script type="text/javascript" src="https://cdn.ronghub.com/RongIMClient.voice-0.9.20.min.js"></script>
-->
<%}else{%>
<script type="text/javascript">
    if(/^https/i.test(document.location.protocol)){
        window['RongOpts']['WS_PROTOCOL'] = 'wss';
        window['RongOpts']['PROTOCOL'] = 'https';
        window['RongOpts']['NAVI_URL'] = "https://nav.cn.ronghub.com/";
        window['RongOpts']['API_URL'] = "https://api.cn.ronghub.com/";
    }else{
        window['RongOpts']['WS_PROTOCOL'] = 'ws';
        window['RongOpts']['PROTOCOL'] = 'http';
        window['RongOpts']['NAVI_URL'] = "http://nav.cn.ronghub.com/";
        window['RongOpts']['API_URL'] = "http://api.cn.ronghub.com/";
    }
</script>
<%}%>
<script type="text/javascript" src="/social/im/js/RongIMClient.js"></script>
<script type="text/javascript" src="/social/im/js/RongIMClient.emoji-0.9.2.js"></script>
<script type="text/javascript" src="/social/im/js/RongIMClient.voice-0.9.1.js"></script>

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
var M_CONNCNT = 5; 

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
                    case RongIMClient.ConnectionStatus.CONNECTED:
                        console && console.log('链接成功');
                        M_SERVERSTATUS=true;
                        M_OTHERDEVICE=false;
                        setRongSocketStatus(1);
                        break;
                    //正在链接
                    case RongIMClient.ConnectionStatus.CONNECTING:
                        console && console.log('正在链接');
                        break;
                    //重新链接
                    case RongIMClient.ConnectionStatus.RECONNECT:
                        console && console.log('重新链接');
                        break;
                    //其他设备登陆
                    case RongIMClient.ConnectionStatus.OTHER_DEVICE_LOGIN:
                        console && console.log('其他设备登陆');
                        M_OTHERDEVICE=true;
                        checkLoginStatus();
                        break;
                    //连接关闭
                    case RongIMClient.ConnectionStatus.CLOSURE:
                        console && console.log('链接断开');
	                	if(M_SERVERSTATUS){
                            setRongSocketStatus(0);
						}
                        M_SERVERSTATUS=false;
                        if(!M_OTHERDEVICE){ //非其他设备登陆造成的断开就重新连接

                            client.reconnect();
                        }
                        break;
                    //未知错误
                    case RongIMClient.ConnectionStatus.UNKNOWN_ERROR:
                        console && console.log('未知错误');
                        M_SERVERSTATUS=false;
                        break;
                    //登出
                    case RongIMClient.ConnectionStatus.LOGOUT:
                        console && console.log('登出');
                        M_SERVERSTATUS=false;
                        break;
                    //用户已被封禁
                    case RongIMClient.ConnectionStatus.BLOCK:
                        console && console.log('用户已被封禁');
                        M_SERVERSTATUS=false;
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
                var tempval = M_CORE.getInstance().getConversation(data.getConversationType(), data.getTargetId());
                if (tempval.getConversationTitle() == undefined) {
                    switch (data.getConversationType()) {
                        case M_CORE.ConversationType.DISCUSSION:
                            tempval.setConversationTitle('群:' + data.getTargetId());
                            break;
                        case M_CORE.ConversationType.PRIVATE:
                            M_CORE.getInstance().getUserInfo(data.getTargetId(), {
                                onSuccess: function (x) {
                                    tempval.setConversationTitle(x.getUserName());
                                },
                                onError: function () {
                                    tempval.setConversationTitle("陌生人Id：" + data.getTargetId());
                                }
                            });
                            break;
                        default :
                            tempval.setConversationTitle('该会话类型未解析:'+data.getConversationType()+data.getTargetId());
                            return;
                    }
                }
                //data.setTargetId(getRealUserId(data.getTargetId()));
                listeners.onMessageReceived(data);
            }
        };
        var connectionStatusListener = {
            onChanged : listeners.onConnectionStatusChanged
        };
        M_CORE.init(M_APPKEY);
        M_CORE.registerMessageType({messageType:'ClearUnReadCountMessage',objectName:'FW:ClearUnreadCount',fieldName:['extra']});
        M_CORE.registerMessageType({messageType:'CancelShareMessage',objectName:'FW:InfoNtf',fieldName:['extra']});
        
        M_CORE.setConnectionStatusListener(connectionStatusListener);
        M_CORE.getInstance().setOnReceiveMessageListener(receiveMessageListener);
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
                                case M_CORE.ConversationType.CHATROOM:
                                    temp.setConversationTitle('聊天室');
                                    break;
                                case M_CORE.ConversationType.CUSTOMER_SERVICE:
                                    temp.setConversationTitle('客服');
                                    break;
                                case M_CORE.ConversationType.DISCUSSION:
                                    temp.getConversationTitle()||temp.setConversationTitle('群:' + temp.getTargetId());
                                    conversations.push(temp);
                                    break;
                                case M_CORE.ConversationType.GROUP:
                                    temp.setConversationTitle('讨论群:' + temp.getTargetId());
                                    break;
                                case M_CORE.ConversationType.PRIVATE:
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
                    /*
                    if(typeof versionTag != 'undefined')
                        getConversationList(versionTag);
                    else
                        getConversationList();
                        */
                    RongIMClient.RongIMVoice.init();
                    listeners.onConnectionSuccess(getRealUserId(imUserId));
                }
            },
            onError : listeners.onConnectionError
        };
        //注册自定义消息

        /*
        var clearUnreadCountMsg = new Object();
        clearUnreadCountMsg.messageType = "ClearUnreadCountMessage";
        clearUnreadCountMsg.objectName = "FW:ClearUnreadCount";
        clearUnreadCountMsg.fieldName = ['extra'];
        M_CORE.registerMessageType(clearUnreadCountMsg);
        */
        
        //"messageType" in regMsg && "objectName" in regMsg && "fieldName" in regMsg
        
        M_CORE.connect(M_TOKEN, connectionListener);
        M_INITED = true;
    };

    IMClient.prototype = new Object();
    //发送消息给个人
    IMClient.prototype.sendMessageToUser = function(toId, msgObj,msgType,callback) {
        this.sendMessage(M_CORE.ConversationType.PRIVATE.value, getIMUserId(toId), msgObj,msgType, callback);
    };
    //发送消息给群

    IMClient.prototype.sendMessageToDiscussion = function(toId, msgObj, msgType,callback) {
        this.sendMessage(M_CORE.ConversationType.DISCUSSION.value, toId, msgObj, msgType,callback);
    };
    //发送message消息
    IMClient.prototype.sendIMMsg = function(toId, msgObj, msgType,callback) {
        var targetType=msgObj.targetType;
        if(targetType=="0")
            this.sendMessage(M_CORE.ConversationType.PRIVATE.value, getIMUserId(toId), msgObj,msgType,callback);
        else    
            this.sendMessage(M_CORE.ConversationType.DISCUSSION.value, toId, msgObj, msgType,callback);
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

            msg=IMClient.TextMessage.obtain(content);
            msg.setObjectName(objectName);      //设置消息标记
            msg.setMessageType(6);
            if(objectName=="FW:CountMsg"||objectName=="FW:SyncQuitGroup"||objectName=="FW:SyncMsg"||objectName=="FW:SysMsg"){
                msg.setPersist(0);
            }
        }else if(msgType==8){ // 地理位置
            msg=IMClient.LocationMessage.obtain(msgObj.detail.content, msgObj.detail.latitude, msgObj.detail.longitude, msgObj.detail.poi);
        }else if(msgType==9){
            msg=IMClient.InformationNotificationMessage.obtain(content);
        }else
            msg=IMClient.TextMessage.obtain(content);
        msg.setExtra(extra);        //设置附加消息    
            
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
        var con = M_CORE.ConversationType.setValue(conversationType);
        M_CORE.getInstance().sendMessage(con,toId, msg, null, {
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
	IMClient.prototype.quitDiscussion = function(discussionId,callback,callbackErr) {
		M_CORE.getInstance().quitDiscussion(discussionId,{
			 onSuccess : function(info) {
			     callback(info);
			     client.writeLog("退出群成功....");
			 }, onError : function(err) {
			     if(typeof callbackErr !== 'undefined'){
			         callbackErr(err);
			     }
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
        /*
        M_CORE.getInstance().syncConversationList({
                onSuccess: function () {
                    //同步会话列表
                    setTimeout(function () {
                        var conversationList =RongIMClient.getInstance().sortConversationList(M_CORE.getInstance().getConversationList());
                        //var conversationList =M_CORE.getInstance().getConversationList();
                        callback(conversationList);
                    }, 1000);
                }, onError: function () {
                    console && console.log("syncConversationList fail");
                }
        });
        */
    };
    
    //删除会话
    IMClient.prototype.removeConversation=function(_targettype, _targetId, callback){
        var _conversationType = M_CORE.ConversationType.DISCUSSION;
        var _imtargetid;
        if('0' == _targettype){ //私聊
            _conversationType = M_CORE.ConversationType.PRIVATE;
            _imtargetid = getIMUserId(_targetId);
        }else if('1' == _targettype){ //群

            _conversationType = M_CORE.ConversationType.DISCUSSION;
            _imtargetid = _targetId;
        }
        
        M_CORE.getInstance().removeConversation(_conversationType, _imtargetid);
        callback(_targetId);
        
    };
    //会话置顶
    IMClient.prototype.setConversationToTop=function(_targettype, _targetId, callback){
        var _conversationType = M_CORE.ConversationType.DISCUSSION;
        var _imtargetid;
        if('0' == _targettype){ //私聊
            _conversationType = M_CORE.ConversationType.PRIVATE;
            _imtargetid = getIMUserId(_targetId);
        }else if('1' == _targettype){ //群

            _conversationType = M_CORE.ConversationType.DISCUSSION;
            _imtargetid = _targetId;
        }
        //alert("_imtargetid:"+_imtargetid);
        M_CORE.getInstance().setConversationToTop(_conversationType, _imtargetid);
        
        //var isTop=M_CORE.getInstance().getConversationToTop(_conversationType, _imtargetid).isTop();
        //alert(isTop);
        callback(_targetId);
        
    };
    
    //获取历史消息记录
    IMClient.prototype.getHistoryMessages=function(targetType,targetid,pagesize,callback){
     
        targetid=this.getRongTargetid(targetid,targetType);
        
        var conversationtype;
        if(targetType==0)
           conversationtype=M_CORE.ConversationType.PRIVATE; 
        else
           conversationtype=M_CORE.ConversationType.DISCUSSION;
        
        M_CORE.getInstance().getHistoryMessages(conversationtype,
        targetid,
        pagesize,{
         onSuccess:function(symbol,HistoryMessages){
         
           callback(symbol,HistoryMessages,true);
           
         },onError:function(error){
         
           callback(false,null,false,error);
           
         }
        });
    
    };
    //清空指定会话的未读消息数量

    IMClient.prototype.clearMessagesUnreadStatus=function(targetType,targetId){
    
        var conversationtype=M_CORE.ConversationType.DISCUSSION;
        if(targetType==0)
           conversationtype=M_CORE.ConversationType.PRIVATE;
        
        M_CORE.getInstance().clearMessagesUnreadStatus(M_CORE.ConversationType.DISCUSSION,targetId);
    };
    
    //清空指定会话的未读消息数量

    IMClient.prototype.resetGetHistoryMessages=function(targetType,targetId){
        
        targetId=this.getRongTargetid(targetId,targetType);
        var conversationtype=M_CORE.ConversationType.DISCUSSION;
        if(targetType==0)
           conversationtype=M_CORE.ConversationType.PRIVATE;
        
        M_CORE.getInstance().resetGetHistoryMessages(conversationtype,targetId);
    };
    
    IMClient.prototype.reconnect=function(callback){
        if(!M_SERVERSTATUS && !M_ISFORCEONLINE){
            console && console.log('正在重新链接');
            M_ISRECONNECT=true;
            RongIMClient.getInstance().reconnect({
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
    
    
    IMClient.DiscussionNotificationMessage = M_CORE.DiscussionNotificationMessage;
    IMClient.TextMessage = M_CORE.TextMessage;
    IMClient.ImageMessage = M_CORE.ImageMessage;
    IMClient.VoiceMessage = M_CORE.VoiceMessage;
    IMClient.RichContentMessage = M_CORE.RichContentMessage;
    IMClient.HandshakeMessage = M_CORE.HandshakeMessage;
    IMClient.UnknownMessage = M_CORE.UnknownMessage;
    IMClient.SuspendMessage = M_CORE.SuspendMessage;
    IMClient.LocationMessage = M_CORE.LocationMessage;
    IMClient.InformationNotificationMessage = M_CORE.InformationNotificationMessage;
    IMClient.ContactNotificationMessage = M_CORE.ContactNotificationMessage;
    IMClient.ProfileNotificationMessage = M_CORE.ProfileNotificationMessage;
    IMClient.CommandNotificationMessage = M_CORE.CommandNotificationMessage;
    IMClient.RongIMVoice = M_CORE.RongIMVoice;
    
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
                
                var index = targetid.indexOf('|' + M_UDID);
                if(conversationType==2){
                    targetType=1; //群聊  
                }else if(conversationType==4){
                    if(targetid.indexOf('|' + M_UDID)>0)
                        targetType=0; //单聊
                }else {
                    console && console.log("会话类型conversationType："+conversationType);
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
    
})(window);

var client;
var userInfos={};
var cbFunctionMap = [];
var discussList={};
var settingInfos={};
var localmsgtags={};
var isIMdebug=false;
//var webSql = new WebStorage.websql();

window.onload = function () {

userInfos[M_USERID]={"userid":"<%=userid%>","userName":"<%=user.getLastname()%>","userHead":"<%=messageUrl%>","deptName":"<%=SocialUtil.getUserDepCompany(userid)%>","jobtitle":"<%=jobtitle%>","mobile":"<%=mobile%>","mobileShow":"<%=mobileShow%>","py":"<%=py%>","signatures":"<%=signatures%>"};
}


</script>