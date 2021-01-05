<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="java.util.*"%>
<%@page import="weaver.mobile.rong.WeaverRongUtil"%>
<%@page import="weaver.social.service.SocialOpenfireUtil"%>
<%@ include file="/systeminfo/init_wev8.jsp"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%
    if (!HrmUserVarify.checkUserRight("message:manager", user)) {
    	response.sendRedirect("/notice/noright.jsp");
    	return;
    }
    String titlename = SystemEnv.getHtmlLabelName(127152,user.getLanguage()); //群广播
%>

<html>
    <head>
        <title><%=titlename %></title>
        <link type="text/css" href="/css/Weaver_wev8.css" rel="stylesheet" />
        <script language="javascript" src="/js/weaver_wev8.js"></script>
        <style type="text/css">
            /*遮罩层*/
            #bgAlpha{  
                 display:none;
                 position: absolute;
                 top:0;
                 left: 0;
                 width: 100%;
                 height:100%;
                 -ms-filter: "progid:DXImageTransform.Microsoft.Alpha(Opacity=30)"; /*IE8*/
                 filter:alpha(opacity=30);  /*IE5、IE5.5、IE6、IE7*/
                 opacity: 0.3;  /*Opera9.0+、Firefox1.5+、Safari、Chrome*/
                 z-index: 100;  /*让其位于in的下面*/
                 background:#fff;
            }
            /*加载样式*/
            #loading{
                position:absolute;
                left:35%;
                background:#ffffff;
                top:40%;
                padding:8px;
                z-index:20001;
                height:auto;
                display:none;
                border:1px solid #ccc;
                font-size: 12px;
            }
        </style>
    </head>
    <body>
    
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<% 
	RCMenu += "{"+SystemEnv.getHtmlLabelName(2083, user.getLanguage())+",javascript:doSave(),_self} ";
	RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
    
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="social"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(127152, user.getLanguage()) %>"/>
</jsp:include>

<wea:layout attributes="{layoutTableId:topTitle}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
			<span title="<%=SystemEnv.getHtmlLabelName(127152, user.getLanguage()) %>" style="font-size: 12px;cursor: pointer;">
				<input class="e8_btn_top middle" onclick="doSave()" type="button" value="<%=SystemEnv.getHtmlLabelName(2083,user.getLanguage()) %>"/>
			</span>
			<span title="<%=SystemEnv.getHtmlLabelName(127152, user.getLanguage())%>" class="cornerMenu"></span>
		</wea:item>
	</wea:group>
</wea:layout>

        <form method="post" id="mainForm" name="mainForm" >
            <wea:layout>
            	<wea:group context="<%=SystemEnv.getHtmlLabelName(127152, user.getLanguage())%>"><!-- 群广播 -->
            		<wea:item><%=SystemEnv.getHtmlLabelName(15525,user.getLanguage())%></wea:item> <!-- 接收人 -->
            		<wea:item attributes="{'samePair':'showsharetype'}">
            			<div id="resourceDiv">
            				<brow:browser viewType="0" name="broadcastUsers" 
            			         browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp"
            			         isSingle="false" hasBrowser="true"  hasInput="true" isMustInput='2'
            			         completeUrl="/data.jsp" width="90%" ></brow:browser> 
            			</div>
            		</wea:item>
            		
            		<wea:item><%=SystemEnv.getHtmlLabelName(26456,user.getLanguage())%></wea:item> <!-- 消息内容 -->
            		<wea:item attributes="{'samePair':'showseclevel'}">
            			<wea:required id="broadcastContentImage" required="true">
            				<textarea class="InputStyle" name="broadcastContent" rows="5"
                                    onBlur='checkinput("broadcastContent","broadcastContentImage")' style="width: 89%;" ></textarea>
            			</wea:required>
            		 </wea:item>
            	</wea:group>
            </wea:layout>
        </form>
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>

    <!-- 遮罩层 -->
    <div id=bgAlpha></div>
    
    <div id="loading">  
        <span><img src="/images/loading2_wev8.gif" align="absmiddle"></span>
        <span  id="loading-msg" style="font-size:12"><%=SystemEnv.getHtmlLabelName(127153, user.getLanguage())%>...</span>
    </div>
    
    <script>
        //保存会话到本地数据库
        function syncConversToLocal(converList){
            if(!converList || converList.length <= 0) return;
            var convers = {};
            var converlen=0;
            for(var i = 0; i < converList.length; ++i){
                var conver=converList[i];
                var targettype=conver.targettype+"";
                if(conver.targetid==""||targettype==""||conver.targetname==""||conver.receiverids==""){
                    continue;
                }else{
                    converlen++;
                    convers[""+i+""]=conver;
                }
            }
            if(converlen > 0){
                var url=getPostUrl("/social/im/SocialIMOperation.jsp?operation=syncConvers&converlen="+converlen);
                $.post(url, 
                    {"convers": JSON.stringify(convers)},
                    function(data){}
                );
            }
        }
        
        function getPostUrl(url){
            return url;
        }
        
        function guid () {
            return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
                var r = Math.random()*16|0, v = c == 'x' ? r : (r&0x3|0x8);
                var uuid=v.toString(16).replace(/-/,"");
                return uuid;
            });
        }
   
       // 遮罩层           
       function showLoading(isShow){
           if(isShow==1){
                $("#bgAlpha").show();
                $("#loading").show();
           }else{
                $("#bgAlpha").hide();
                $("#loading").hide();   
           }        
        }
    </script>
<!-- 暂时只使用融云的发送 -->
<% if(SocialOpenfireUtil.getInstanse().isBaseOnOpenfire()) { %>
<!-- openfire部署 -->
    <%
        final String fromUserName = "SysNotice";
    %>
    <script>
        // 发送
        function doSave(){
            if(check_form(mainForm,'broadcastUsers,broadcastContent')) {
                showLoading(1);
                var userIdArray = $('input[name="broadcastUsers"]').val();
                var content = $('textarea[name="broadcastContent"]').val();
                var fromUserId = '<%=fromUserName %>';  // 
                var sendTime = new Date().getTime();
                var extra = '{"msg_id":"'+guid()+'","receiverids":"'+userIdArray+'","sendTime":'+sendTime+',"msg_at_userid":"","msg_is_broadcast":true}';
                
                $.ajax({
                    type : 'POST',
                    url : '/social/im/SocialIMOperation.jsp?operation=sendMsgByOpenfire',
                    data : {
                        fromUserId : fromUserId,
                        userIdArray : userIdArray,
                        objectName : 'RC:TxtMsg',
                        content : content,
                        extra : extra
                    },
                    dataType : 'json',
                    success : function(data){
                        var jsconverList = [];
                        var toUserIds = userIdArray.split(',');
                        for(var i = 0; i < toUserIds.length; i++) {
                            var toUserId = toUserIds[i];
                            //更新最后一条消息
                            jsconverList.push({
                                "senderid" : '<%=user.getUID() %>',
                                "targetid" : fromUserId + '_' + toUserId,
                                "targettype" : '4',
                                "msgcontent" : encodeURI(content),
                                "sendtime" : '' + sendTime,
                                "targetname" : encodeURI('<%=SystemEnv.getHtmlLabelName(127152,user.getLanguage()) %>'),
                                "receiverids" : '' + toUserId
                            });
                        }
                        //同步本地会话
                        syncConversToLocal(jsconverList);
                        showLoading(0);
                    },
                    error : function(){
                        showLoading(0);
                    }
                });
            }
       }
    </script>
<% } else { %>
<!-- 融云 -->
    <%
        final String fromUserName = "SysNotice";
        WeaverRongUtil rongUtil = WeaverRongUtil.getInstanse();
        Map<String,String> rongConfig = rongUtil.getRongConfig(fromUserName, "" ,"");
        String TOKEN = rongConfig.get("TOKEN");  //应用token
        String APPKEY = rongConfig.get("APPKEY");  //应用key
        String UDID = rongConfig.get("UDID");  //用户区分标识
    %>
    <script type="text/javascript" src="/social/im/js/RongIMClient.js"></script>
    <script>
            var UDID = "<%=UDID%>";
            var M_UDID = "<%=UDID%>";
            var M_APPKEY = "<%=APPKEY%>";
            var M_CORE = RongIMClient;
            var M_TOKEN = '<%=TOKEN%>';
            
            var getIMUserId = function(userId) {
                try{
                    var sufs = '|' + M_UDID;
                    var index = userId.indexOf(sufs);
                    if (index == -1) {
                        return userId + sufs;
                    }else{
                        return userId.substring(0, index + sufs.length);
                    }
                }catch(e){}
                return userId + '|' + M_UDID;
            };
            
            (function(w) {
                IMClient = function(listeners) {
                    if (!listeners.onConnectionStatusChanged) {
                        listeners.onConnectionStatusChanged = function (status) {
                            switch (status) {
                                //链接成功
                                case RongIMClient.ConnectionStatus.CONNECTED:
                                    console && console.log('链接成功');
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
                                    break;
                                //连接关闭
                                case RongIMClient.ConnectionStatus.CLOSURE:
                                    console && console.log('链接断开');
                                    break;
                                //未知错误
                                case RongIMClient.ConnectionStatus.UNKNOWN_ERROR:
                                    console && console.log('未知错误');
                                    break;
                                //登出
                                case RongIMClient.ConnectionStatus.LOGOUT:
                                    console && console.log('登出');
                                    break;
                                //用户已被封禁
                                case RongIMClient.ConnectionStatus.BLOCK:
                                    console && console.log('用户已被封禁');
                                    break;
                            }
                        };
                    }
                    var receiveMessageListener = {
                        onReceived : function(data) {
                            listeners.onMessageReceived(data);
                        }
                    };
                    var connectionStatusListener = {
                        onChanged : listeners.onConnectionStatusChanged
                    };
                    M_CORE.init(M_APPKEY);
                    M_CORE.setConnectionStatusListener(connectionStatusListener);
                    M_CORE.getInstance().setOnReceiveMessageListener(receiveMessageListener);
            
                    var connectionListener = {
                        onSuccess : function(imUserId) {
                        },
                        onError : listeners.onConnectionError
                    };
                };
            
                IMClient.prototype = new Object();
                IMClient.TextMessage = M_CORE.TextMessage;
                
                IMClient.prototype.reconnect=function(){
                    RongIMClient.getInstance().reconnect({
                        onSuccess:function(){
                            console && console.log('重新连接成功');
                        },
                        onError: function(e){
                            console && console.log('重新连接失败');
                            console && console.log(e);
                        }
                    });
                };
            
                IMClient.prototype.disconnect=function(){
                    console && console.log('断开链接');
                    RongIMClient.getInstance().disconnect();
                };
                
                //发送消息给个人
                IMClient.prototype.sendMessageToUser = function(toId, msgObj,msgType,callback) {
                    this.sendMessage(M_CORE.ConversationType.PRIVATE.value, getIMUserId(toId), msgObj,msgType, callback);
                };
                IMClient.prototype.sendMessage = function(conversationType, toId, msgObj, msgType, callback) {
                    var content=msgObj.content;
                    var imgUrl=msgObj.imgUrl;
                    var objectName=msgObj.objectName;
                    var extra=msgObj.extra;
                    var msg;
                    if(msgType==1){//文本
                        msg=IMClient.TextMessage.obtain(content);
                    }
                    msg.setExtra(extra);        //设置附加消息    
                        
                    console && console.log("-----------发送消息开始----------");
                    console && console.log("objectName:"+objectName);
                    console && console.log("extra:"+extra);
                    console && console.log("msgType:"+msgType);
                    console && console.log("content:"+content);
                    console && console.log("-----------发送消息结束----------");
                    
                    // client.reconnect();
                    var con = M_CORE.ConversationType.setValue(conversationType);
                    M_CORE.getInstance().sendMessage(con,toId, msg, null, {
                        onSuccess: function (data) {
                            console.info(data);
                            var sendtime="";
                            try{
                                sendtime=data.timestamp;
                                //sendtime=M_CURRENTTIME;
                            }catch(e){
                                console && console.log("返回时间异常");
                                sendtime = M_CURRENTTIME;
                            }
                            console && console.log("sendtime:"+sendtime);
                            console && console.log("send successfully");
                            var paramzip = {'chattype':con, 'receverids':toId, 'msgobj':msgObj, 'msgtype':msgType};
                            if(callback){
                                callback({'issuccess': 1,'paramzip':paramzip,'sendtime':sendtime});
                            }
                        }, onError: function (err) {
                            console && console.log("send fail"+" error:"+err);
                            var paramzip = {'chattype':con, 'receverids':toId, 'msgobj':msgObj, 'msgtype':msgType};
                            if(callback){
                                callback({'issuccess': 0, 'err': err, 'paramzip':paramzip});
                            }
                        }
                    });
                };
            })(window);
            
            var client;
            
            window.onload = function () {
                var listeners = {
                    //接收消息的回调
                    onMessageReceived:function (data) {
                    },
                    onConnectionSuccess: function (x) {
                        console && console.log("connected，userid＝" + x);
                    },
                    onConnectionError: function (x) {
                        console && console.log(x)
                        console && console.info('链接失败');
                    }
                };
                client = new IMClient(listeners);
            }
            
            // 发送
            function doSave(){
                if(check_form(mainForm,'broadcastUsers,broadcastContent')) {
                    var userIdArray = $('input[name="broadcastUsers"]').val().split(',');
                    var content = $('textarea[name="broadcastContent"]').val();
                    
                    var fromUserId = '<%=fromUserName %>';  // 
                    var sendTime = new Date().getTime();
                    var count = 0;
                    showLoading(1);
                    RongIMClient.connect(M_TOKEN, {
			            onSuccess : function(imUserId) {
			            	console && console.log("测试链接：" + imUserId + "成功");
                            var jsconverList = [];
                            for(var i = 0;  i < userIdArray.length; i++) {
                                var toUserId = userIdArray[i];
                                
                                var msgid = guid();
                                var extra = '{"msg_id":"'+msgid+'","receiverids":"'+toUserId+'","sendTime":'+sendTime+',"msg_at_userid":"","msg_is_broadcast":true}';
                                var msgObj = {"content": content, "objectName":"RC:TxtMsg", "msgType":1, "extra":extra, "senderid":fromUserId, "targetid":fromUserId +"_"+toUserId, "targetType":"RC:TxtMsg"};
                                //更新最后一条消息
                                jsconverList.push({
                                    "senderid" : '<%=user.getUID() %>',
                                    "targetid" : fromUserId + '_' + toUserId,
                                    "targettype" : '4',
                                    "msgcontent" : encodeURI(content),
                                    "sendtime" : ''+sendTime,
                                    "targetname" : encodeURI('<%=SystemEnv.getHtmlLabelName(127152,user.getLanguage()) %>'),
                                    "receiverids" : ''+toUserId
                                });
                                
                                client && client.sendMessageToUser(toUserId, msgObj, 1, function(data){
                                    count++;
                                    if(count == userIdArray.length) {
                                        //同步本地会话
                                        syncConversToLocal(jsconverList);
                                        
                                        showLoading(0);
                                        Dialog.alert('发送群消息成功', function(){
                                            parent.mainFrame.location.reload();
                                        });
                                    }
                                });
                            }
			            },
			            onError: function(err) {
                            showLoading(0);
			                console && console.log("测试链接：" + err + "失败");
                            Dialog.alert('建立连接失败');
			            }
			        });
                }
           }
        </script>
<% } %>
    </body>
</html>
