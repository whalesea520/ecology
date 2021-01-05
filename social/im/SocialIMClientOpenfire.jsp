<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.hrm.User" %>
<%@page import="weaver.social.SocialUtil"%>
<%@page import="weaver.hrm.company.DepartmentComInfo"%>
<%@page import="weaver.social.service.SocialOpenfireUtil"%>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<%@page import="weaver.general.BaseBean"%>
<%
    SocialOpenfireUtil openfireUtil = SocialOpenfireUtil.getInstanse();
	String userid = "" + user.getUID();
	String username = "" + user.getLastname();
	//String messageUrl = ResourceComInfo.getMessagerUrls(userid);
	String messageUrl = SocialUtil.getUserHeadImage(userid);
	String jobtitle = SocialUtil.getUserJobTitle(userid);
	String mobile  = SocialUtil.getUserMobile(userid);
	//前端展示手机
    String mobileShow = SocialUtil.getUserMobileShow(userid);
	//简拼
	String py = SocialUtil.getFirstSpell(username);
	//log.writeLog("========mobile========="+mobile);
	//获取个性签名
	String signatures = SocialUtil.getSignatures(userid);
	//log.writeLog("========signatures========="+signatures);
	jobtitle = jobtitle.replaceAll("\n","").replaceAll("\r", "");
	Map<String,String> openfireConfig = openfireUtil.getOpenfireConfig(userid, username, messageUrl, request);
	String deptid = ResourceComInfo.getDepartmentID(userid);
	String supdeptid = DepartmentComInfo.getDepartmentsupdepid(deptid);
	String TOKEN = openfireConfig.get("TOKEN");  //应用token，用户登录密码
	String UDID = openfireConfig.get("UDID");  //用户区分标识, rongAppUDIDNew字段值
    String DOMAIN = openfireConfig.get("DOMAIN"); // openfire服务器标志
    String SERVERIP = openfireConfig.get("SERVERIP");
    String SERVERPORT = openfireConfig.get("SERVERPORT");
    String RESOURCE = openfireConfig.get("RESOURCE");
    
	long currentTime=System.currentTimeMillis();

	boolean isOffLineMsg=false;
	if(supdeptid.equals("25")){
		isOffLineMsg=true;
	}
	boolean isHttps=request.getScheme().equals("https");
	if(isHttps){
		SERVERPORT = "7443";
	}
%>
<script>
	var browserName = $.client.browserVersion.browser;             //浏览器名称
	var browserVersion = parseInt($.client.browserVersion.version);//浏览器版本
	if(browserName == "IE"&&browserVersion<10){
		window.WEB_XHR_POLLING = true;
	}
    
    var M_UDID = '<%=UDID%>';
    var M_TOKEN = '<%=TOKEN%>';
    var M_DOMAIN = '<%=DOMAIN%>';
    var M_SERVERIP = '<%=SERVERIP%>';
    var M_SERVERPORT = '<%=SERVERPORT%>';
    var M_RESOURCE = '<%=RESOURCE%>';
    var M_USERID = '<%=userid%>';
    var M_USERNAME = '<%=username%>';
    var M_CURRENTTIME=<%=currentTime%>;
    if(CUST_SERV_IP !== 'null') {
    	M_SERVERIP = CUST_SERV_IP;
    	// ip是否包含端口
    	var s_str_index = M_SERVERIP.lastIndexOf(':');
    	if(s_str_index != -1){
    		M_SERVERIP = M_SERVERIP.substring(0, s_str_index);
    		M_SERVERPORT = M_SERVERIP.substring(s_str_index+ 1, CUST_SERV_IP.length);
    	}
    }
    //在线状态
    var ONLINESTATUS = new Array();
    ONLINESTATUS['away']='<%=SystemEnv.getHtmlLabelName(131097, user.getLanguage())%>';
    ONLINESTATUS['online']='<%=SystemEnv.getHtmlLabelName(131096, user.getLanguage())%>';
    ONLINESTATUS['busy']='<%=SystemEnv.getHtmlLabelName(131098, user.getLanguage())%>';

    var M_INITED = false;
    
    var M_SERVERSTATUS=false; //链接状态
    var M_OTHERDEVICE=false;  //其他设备登陆
    var M_ISRECONNECT=false;  //是否重新连接
    var M_ISFORCEONLINE=false; //是否强制下线
    var M_CONNCNT = 5;       //重连次数
	var M_SERVERCONFIG ={};//服务端接口配置
    var timeCountInterval = setInterval(function(){
        M_CURRENTTIME = M_CURRENTTIME + 1000;
    }, 1000);  
    var M_SERVERPINGInterval;//ping服务
    //全局参数设置
	window['RongOpts'] = {
		EMOJI_BG_IMAGE:"/social/im/js/css-sprite_bg.png",
		VOICE_LIBAMR:"/social/im/js/libamr.js", 
		VOICE_PCMDATA:"/social/im/js/pcmdata.min.js",
		VOICE_AMR:"/social/im/js/amr.js",
		VOICE_SWFOBJECT:"/social/im/js/swfobject.js",
		VOICE_PLAY_SWF:"/social/im/js/player.swf"
	}
    
</script>
<script type="text/javascript" src="/social/im/js/strophe.min.js"></script>
<script type="text/javascript" src="/social/im/js/WeaverIMClient.js"></script>
<script type="text/javascript" src="/social/im/js/WeaverIMClient.emoji-0.9.2.js"></script>
<script type="text/javascript" src="/social/im/js/WeaverIMClient.voice-0.9.1.js"></script>

<script type="text/javascript">
    var M_CORE = RongIMClient;
    
    /**
     * 通过oaID获得imID
     * @param userId  oa中用户id
     */
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

    /**
     * 通过imID获得oaID
     * @param imUserId  IM中用户id（XXX|M_UDID）
     */
    var getRealUserId = function(imUserId) {
    	if (imUserId) {
    		try{
    			var index = imUserId.indexOf('|');
    			if (index > 0) {
    				return imUserId.substring(0, index);
    			}
    		}catch(e){}
    	}
    	return imUserId;
    };
    var recoWaitDelay = (function(){
		var delay = 2000, counter = 2;
		    function reset() {
		      delay = 2000;
		      counter = 2;
		    }
		    function increase() {
		      counter += 1;
			  delay = counter * 2000;
		    }
		    function value() {
		      return delay;
		    }
		    return {reset: reset, increase: increase, value: value};
            }());

    /**
     * 检测用户pc端登陆状态，若pc登录则提示网页版下线
     */
    function checkLoginStatus(callback){
		$.post("/social/im/SocialIMOperation.jsp?operation=checkPCLogin",{"websessionkey":websessionkey},function(data){
			data=$.trim(data);
			if((data == 1||data==-1||data==2) && !ChatUtil.isFromPc()){
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
			}else{
				//只有pc端才有回调
				callback && callback(data);
			}			
		})
    }
	/*
	*私有云重连方法
	*/
	var OpenFireConnectUtil={
		/*
		*最后一次断线时间
		*/
		_lastOffTime:new Date().getTime(),
		/* 
		* 当前断线时间
		*/
		_currentOffTime:0,
		/* 
		*标记是否断过线 
		*/
		_offLineStatus:false,
		/* 
		*记录打开的窗口
		*/
		_isOpenWin:-1,
		/* 
		*自动重连5次
		*/
		_startRecon : function(){
			var _this = this;
			if(M_CONNCNT<=0){ 
				this._remindDisconnection();
			}else{                
				getTokenOfOpenfire(function(data){
					if(data == ""){
						M_CONNCNT =0
					}
					client && client.reconnect();
				});      
			}      
		},
		/* 
		*获取历史消息记录 
		*/
		_getHistoryMsg:function(chatType,acceptId,callback){
			if(!IS_BASE_ON_OPENFIRE) return;
			if(this._offLineStatus && this._currentOffTime-this._lastOffTime>60*1000){
				this._offLineStatus = false;
				this._lastOffTime = this._currentOffTime;
			}else{
				ChatUtil.getHistoryMessages(chatType,acceptId,10,true);
			}
			typeof callback ==="function" &&callback();
		},
		/* 
		*关闭提示??可能会把其他提示也干掉
		*/
		_closeConnectPostFloatNotice:function(chatwinid){
			try{
				if(IS_BASE_ON_OPENFIRE && M_SERVERSTATUS){
					var chatWin= ChatUtil.getCurChatwin();
					if(chatWin.length>0){
						var chatWinFloatMsgdiv = chatWin.find('.chatWinFloatMsgdiv');
						if(chatWinFloatMsgdiv.length>0&&chatWinFloatMsgdiv.attr('msgflag')=='disconnect'){
							$(chatWin).find(".clearmsg").click();
							$(chatWinFloatMsgdiv).css('cursor', 'unset');
							chatWin.removeAttr("anchorTopId");
							chatWin.find(".chatList").css("top", "61px");
						}			
					}				
				}			
			}catch(e){}		
		},
		/* 
		* 手动重连接
		*/
		_remindDisconnection:function(){
			this._currentOffTime = new Date().getTime();
			this._offLineStatus = true;
			$('.dataLoading,.loading1').fadeOut();
			if(!WindowDepartUtil.isAllowWinDepart()){
				var chatWin= ChatUtil.getCurChatwin();
				if(chatWin.length>0){
					chatWin.attr("errorTag", "history-load-failed");
					var options = {
						"onclick": {
							"fn": function(ele){
								getTokenOfOpenfire(function(data){
									if(data == ""){
											M_CONNCNT =0
										}
									M_ISFORCEONLINE = false;
									client && client.reconnect(function(isSuccess){
										if(isSuccess){
											var chatwin = ChatUtil.getchatwin(ele);
											if(chatwin.length > 0) {
												var chatType = chatwin.attr('_targettype');
												var acceptId = chatwin.attr('_targetid');
												OpenFireConnectUtil._getHistoryMsg(chatType,acceptId);
											}
											//重连成功后更新会话时间
											OpenFireConnectUtil._updateConverTimeAndMessage();
										}						
									});
								});
							}
						},
						"msgflag":"disconnect"
					};
					ChatUtil.postFloatNotice("链接已断开，请点击重连", "error", options);
				}else if(ChatUtil.isFromPc){
					RongErrorUtils.startRecon();
				}		
		}else{
		    //窗口分离弹出重连框
		    ReconAnimationUtils.showRelink(function(){
		         //点击重连之后操作
		         ReconAnimationUtils.updateRelinkInfo(2, '正在重连中');
		         ReconAnimationUtils._setTaskRelinkStatus(false);
		         getTokenOfOpenfire(function(data){
	                 if(data == ""){
	                     M_CONNCNT =0
	                 }
	                 M_ISFORCEONLINE = false;
	                 client && client.reconnect(function(isSuccess){
	                     if(isSuccess){
	                          ReconAnimationUtils.close();
	                         //重连成功后更新会话时间
	                         OpenFireConnectUtil._updateConverTimeAndMessage();
	                     }else{
	                          ReconAnimationUtils.updateRelinkInfo(3, '重连失败');
	                          ReconAnimationUtils._setTaskRelinkStatus(false);
	                          setTimeout(function(){
	                              ReconAnimationUtils.close();
	                          },800);
	                     }                       
	                 });
	             });
		    });
		    ReconAnimationUtils.updateRelinkInfo(0, '连接emessage故障，点击重连');
		}
		},
		//验证失败后将M_TOKE设置为空串，重新获取token
		_setMessageToken:function(){
			M_TOKEN = "";	
		},
		//ping操作后没有返回值，或者type是不result就断线触发重连
		_disConnect:function(data,callback){
			M_CORE.getInstance().setPingTime(new Date().getTime());			
			if(M_CONNCNT<1)M_CONNCNT= 2;
			M_CORE.getInstance().disconnect();	
		},
		//更新会话的最后一条记录的时间
		_updateConverTimeAndMessage : function(){
            if(IS_BASE_ON_OPENFIRE){
            //连接成功后更新最近列表会话
            var objtemp = $($('#recentListdiv').find('.chatItem')[0]);
            var sendtime = objtemp.attr('_sendtime');
            var url = "/social/im/SocialIMOperation.jsp?operation=updateConverSationTime";
            var content = objtemp.find('.msgcontent').html();
            $.post(url +"&sendtime=" + sendtime+"&content=" + content+"&userid=" + M_USERID, function(data){
                var resultArr = $.trim(data);
                if(resultArr!==undefined&&resultArr!=='[]'&&resultArr!=='[{}]'){
                    var jsonArr = JSON.parse(resultArr);
                    for(var i = 0 ;i<jsonArr.length ; i++){
                        var targetType = jsonArr[i].targettype;
                        var msgcontent = jsonArr[i].msgcontent;
                        var sendtime = jsonArr[i].sendtime;
                        var senderid = jsonArr[i].userid;
                        var senderInfo = getUserInfo(senderid);
						var targetId = jsonArr[i].targetid;
                        updateConversationList(senderInfo,targetId,targetType,msgcontent,sendtime);
                    }
                    
                    if(!WindowDepartUtil.isAllowWinDepart()){
			             var $chatArr = $('#imLeftdiv').find('#chatIMTabs').find('.chatIMTabItem');
			             $chatArr.each(function(i,obj){
			                 var chatwinid = $(obj).attr('_chatwinid');
			                 var targetType = chatwinid.substring(8,9);
			                 var realTargetid = chatwinid.substring(10,chatwinid.length);
			                 M_CORE.getInstance().resetGetHistoryMessages(targetType,realTargetid);
			                 var $chatlist = $("#"+chatwinid).find(".chatList");
			                 if($(obj).hasClass('chatIMTabActiveItem')){
			                     $('.dataLoading,.loading1').fadeIn('normal',function(){
			                         $chatlist.find('.chatItemdiv').remove();
			                         $chatlist.find('.chatTime').remove();
			                         ChatUtil.getHistoryMessages(targetType,realTargetid,10,true);
			                         $('.dataLoading,.loading1').fadeOut();
			                     })
			                 }else{
			                     $(obj).attr('needReLoad','true');
			                 }
			             })
                    }
                }
            });
        }
    }
	}
	/*
	* 获取token方法 failCb连接失败后回调  successCb成功获取token回调，errorCb获取失败,网络连接错误 
	*/
	function getTokenOfOpenfire(successCb,errorCb,timeoutCb){
		M_CONNCNT--;
		if(M_TOKEN ==""){
			$.ajax({
				//后台方法会阻塞
				timeout : 60000,
                async : true,
				url : '/social/im/SocialIMOperation.jsp?operation=getTokenOfOpenfire',
				data:{reFreshToken:1},
                success : function(data){//oa正常，
                    data = $.trim(data);					
                    if(data !="" && M_TOKEN != data) {
						M_TOKEN = data;
                    }
                    M_CORE.connect.token = M_TOKEN;
					typeof successCb === "function" && successCb(data);
                },
                error : function(err){//oa服务错误或网络错误
                   typeof errorCb ==="function" && errorCb();
                },
                complete : function(XMLHttpRequest,status){
                	if(status=='timeout'){//超时处理逻辑
					typeof timeoutCb ==="function"&& timeoutCb();
						}
                    }
			}); 
		}else{
			typeof successCb === "function" && successCb(M_TOKEN);
		}
		       
	}
    if (typeof console == "undefined") {
        this.console = {log: function() {}};
    }
    // 向打印日志方法
    function writeLog(log){
		var ua = navigator.userAgent.toLowerCase();
		if(ua.match(/chrome\/([\d.]+)/)){
		   console.log(log);
		}   
	}

    /**
     * 定义IMClient
     * @param w  window对象
     */
    (function(w) {
        // WEB_XHR_POLLING，true：不支持websocket，否则支持
    
    	var browserName = $.client.browserVersion.browser;             //浏览器名称
    	var browserVersion = parseInt($.client.browserVersion.version);//浏览器版本
    	if(browserName == "IE" && browserVersion < 10){
    		w.WEB_XHR_POLLING  = true;
    	}else{
    		w.WEB_XHR_POLLING = false;
    	}
    	<%if(isOffLineMsg){%>
    		M_CORE.isSyncOfflineMsg=true;
    	<%}else{%>
    	    M_CORE.isSyncOfflineMsg=false;
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

					M_SERVERSTATUS = status == Strophe.Status.CONNECTED;

    	            switch (status) {
    	                //链接成功
    	                case Strophe.Status.CONNECTED:
    	                    writeLog('链接成功');
    	                    M_SERVERSTATUS=true;
    	                    M_OTHERDEVICE=false;
    	                    M_ISRECONNECT=false;
    	                    break;
    					// 连接失败
    					case Strophe.Status.CONNFAIL :
    						writeLog('连接失败');
    						M_ISRECONNECT=false;
    						break;
						//其他设备登陆(这个状态是连接错误，其他链接通过sockte建立时，会触发这个状态)
						case Strophe.Status.ERROR:
							writeLog('服务端有错误');
							//writeLog('其他设备登陆');
							M_OTHERDEVICE=true;
							checkLoginStatus(function(info){
								if(info !=="RepeatLanding"){
								    //私有云服务停掉后会触发该操作
                                    M_OTHERDEVICE = false;
                                    OpenFireConnectUtil._startRecon();
								}
							});
						break;
    	                //正在链接
    					case Strophe.Status.CONNECTING :
    	                    writeLog('正在链接');
    	                    break;
						// 链接断开
						case Strophe.Status.DISCONNECTED :
							writeLog('链接断开');
							M_SERVERSTATUS=false;
							if(WindowDepartUtil.isAllowWinDepart()){
							    WindowDepartUtil.closeChatWin();
							}
							break;
    	                //重新链接
    	                case Strophe.Status.DISCONNECTING:
    	                    writeLog('正在断开连接');
    	                    break;
						// 验证失败
						case Strophe.Status.AUTHFAIL :
							writeLog('验证尝试失败.');
							//获取token方法
							listeners.onConnectionVerifyFail();
							break;
                        case Strophe.Status.ATTACHED :
                            writeLog('连接已连接.');
                            break;
						default :
							writeLog('no this status : ' + status);
							break;
    	            }
                };
    		}
    		var receiveMessageListener = {
    			onReceived : function(data) {
    	            listeners.onMessageReceived(data);
    			},
            	OnLineStatuHandler : function(data,fromUserid) {
                    listeners.OnLineStatuHandler(data,fromUserid);
                }
    		};
    		var connectionStatusListener = {
    			onChanged : listeners.onConnectionStatusChanged
    		};
    		M_CORE.init(M_DOMAIN, M_SERVERIP, M_SERVERPORT, M_RESOURCE);
    		M_CORE.setConnectionStatusListener(connectionStatusListener);
    		M_CORE.getInstance().setOnReceiveMessageListener(receiveMessageListener);

            var connectionListener = {
    			onSuccess : function(imUserId) {
    				if (typeof(listeners.onConnectionSuccess) === 'function') {
                        setTimeout(function(){
                            M_CORE.RongIMVoice.init();
                        }, 2000); 
    					listeners.onConnectionSuccess(getRealUserId(imUserId));
    				}
    			},
    			onError : listeners.onConnectionError
    		};
    		M_CORE.connect(M_USERID, M_UDID, M_TOKEN, connectionListener);  //xmpp通信时的udid必须使用小写!!!
    		M_INITED = true;
    	};
    
        // 定义IMClient对象
    	IMClient.prototype = new Object();
    	//获取在线状态
    	IMClient.prototype.getUserOnlineStatus = function(members, callback) {
            M_CORE.getInstance().getUserOnlineStatus(members, {
                 onSuccess : function(info) {
                     callback.onSuccess(OnLineStatusUtil.packageUserStatus(info,1));
                 }, onError : function(errInfo) {
                     client.writeLog('err : ' + errInfo);
                     try{
                        var errElems = errInfo.getElementsByTagName('error');
                        if(errElems.length>0&&errElems!=undefined){
                            callback.onError();
                        }
                     }catch(err){
                        callback.onError();
                     }
                     callback.onError();
                 }
            });
        };
        //设置在线状态
        IMClient.prototype.setUserOnlineStatus = function(userStatus, callback) {
            M_CORE.getInstance().setUserOnlineStatus(userStatus, {
                 onSuccess : function() {
                     callback.onSuccess();
                 },
                 onError : function(){
                    client.writeLog('设置在线状态失败');
                    callback.onError();
                 }
            });
        };
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
			//特殊情况下不进行发送
			if(M_OTHERDEVICE) {
				return;
			}
            
            if(msgType==2){ //图片    
                msgObj.imageUri = msgObj.imgUrl;  // 命名跟sdk保持一致,和其他端保持一致
                delete msgObj['imgUrl'];
            }
            
            var content=msgObj.content;
            var objectName=msgObj.objectName;
            var extra=msgObj.extra;
            
    		client.writeLog("-----------发送消息开始----------");
    		client.writeLog("objectName:"+objectName);
    		client.writeLog("extra:"+extra);
    		client.writeLog("msgType:"+msgType);
    		client.writeLog("content:"+content);
    		client.writeLog("-----------发送消息结束----------");
    		
    		// client.reconnect();
    		var con = M_CORE.ConversationType.setValue(conversationType);
    		M_CORE.getInstance().sendMessage(con, toId, msgObj, {
                onSuccess: function (data) {
                	var sendtime="", ts="";
	               	try{
	               		ts=data.timestamp;
	               		if(typeof ts === 'number'){
	               			M_CURRENTTIME=ts;
	               		}
	               	}catch(e){
	               		client.error("返回时间异常");
	               		ts=M_CURRENTTIME;
	               	}
	               	sendtime = ts;
	            	client.error("sendtime:"+sendtime);
                	writeLog("send successfully");
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
					if(err == false){//如果发不出消息就重连
						OpenFireConnectUtil._startRecon();
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
    			     writeLog(err);
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
		//转让群组
		IMClient.prototype.setDiscussionAdmin = function(discussionId, admins,callback){
			M_CORE.getInstance().setDiscussionAdmin(discussionId, admins, {
				onSuccess : function(info) {
					callback(info);
				}, onError : function(err) {
					console && console.log(err);
				}
			});
		};
		//设置群头
		IMClient.prototype.setDiscussionIcon = function(discussionId, discussionIcon,callback){
			M_CORE.getInstance().setDiscussionIcon(discussionId, discussionIcon, {
				onSuccess : function(info) {
					callback(info);
				}, onError : function(err) {
					console && console.log(err);
				}
			});
		};	
    	//异步添加群成员
    	IMClient.prototype.addMemberToDiscussion = function(discussionId,memberids,callback) {
    		M_CORE.getInstance().addMemberToDiscussion(discussionId,memberids,{
    			 onSuccess : function(info) {
    			     callback(info);
    			 }, onError : function(err) {
    			     writeLog(err);
    			 }
    		});
    	};
    	//异步删除群成员
    	IMClient.prototype.removeMemberFromDiscussion = function(discussionId,userid,callback) {
    		M_CORE.getInstance().removeMemberFromDiscussion(discussionId,userid,{
    			 onSuccess : function(info) {
    			     callback(info);
    			 }, onError : function(err) {
    			     writeLog(err);
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
    			     writeLog(err);
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
    			     writeLog(err);
    			 }
    		});
    	};
    	//异步设置群名称
    	IMClient.prototype.setDiscussionName = function(discussionId,discussTitle, callback) {
    		M_CORE.getInstance().setDiscussionName(discussionId, discussTitle, {
    			 onSuccess : function(info) {
					 console.info(info);
    			     callback(info);
    			 }, onError : function(err) {
    			     writeLog('err : ' + err);
    			 }
    		});
    	};
        
    	//获取最近联系人（最近联系人列表保存在OA服务器，不采用融云的接口了）
    	IMClient.prototype.getConversationList=function(callback){
    	};
    	//删除会话
    	IMClient.prototype.removeConversation=function(_targettype, _targetId, callback){
    		callback(_targetId);
    	};
    	//会话置顶
    	IMClient.prototype.setConversationToTop=function(_targettype, _targetId, callback){
    		callback(_targetId);
    	};
    	
    	//获取历史消息记录
    	IMClient.prototype.getHistoryMessages=function(targetType,targetid,pagesize,callback){
			M_CORE.getInstance().getHistoryMessages(targetType, M_USERID, targetid, pagesize, {
					onSuccess:function(symbol,HistoryMessages){
						callback(symbol,HistoryMessages,true);
					},
					onError:function(error){
						callback(false,null,false);
					}
			});
    	};
        
    	//清空指定会话的未读消息数量
    	IMClient.prototype.clearMessagesUnreadStatus=function(targetType,targetId){
    	};
    	//清空指定会话的未读消息数量
    	IMClient.prototype.resetGetHistoryMessages=function(targetType,targetId){
    		M_CORE.getInstance().resetGetHistoryMessages(targetType, targetId);
    	};
    	
        // 重连 通信websocket
    	IMClient.prototype.reconnect=function(callback){
    	if(!M_SERVERSTATUS && !M_ISFORCEONLINE){
    			writeLog('IMClient.prototype.reconnect 正在重新链接');
    			M_ISRECONNECT=true;
				execReconnect(callback);
                function execReconnect(callback){
                    M_CORE.getInstance().reconnect({
                        onSuccess:function(info){
                            callback && callback(true);
                        },
                        onError:function(err){
                            callback && callback(false)
                        }
                    });
                }
    		}
    	};
        // 断开通信websocket
    	IMClient.prototype.disconnect=function(force){
    		writeLog('IMClient.prototype.disconnect  断开链接');
    		if(force){
    			M_ISFORCEONLINE = true;
    		}
    		M_CORE.getInstance().disconnect();
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
    			try{
    				var index = imUserId.indexOf('|' + M_UDID);
    				if (index > 0) {
    					return imUserId.substring(0, index);
    				}
    			}catch(e){}
    		}
    		return imUserId;
    	}
    	//获取消息类型 0 单聊 1群聊    融云
    	IMClient.prototype.getTargetType=function(conversationType,targetid){
    		var targetType="-1";
    		if(targetid){
    		    try{
    				var index = targetid.indexOf('|' + M_UDID);
    				if(conversationType==2){
    					targetType=1; //群聊	
    				}else if(conversationType==4){
    				    if(index>0)
    				 		targetType=0; //单聊
    				}else {
    					writeLog("会话类型conversationType："+conversationType);
    				}
    			}catch(e){
    			    writeLog("targetid22:"+targetid);
    			}
    		}
    		return targetType;
    	}

    	//获取消息类型 0 单聊 1群聊
    	IMClient.prototype.getRealTargetid=function(conversationType,targetid){
    		if(targetid){
    		    try{
    		    	writeLog("conversationType:"+conversationType+" targetid:"+targetid);
    				var index = targetid.indexOf('|' + M_UDID);
    				if(conversationType==2){
    					return targetid; //群聊	
    				}else if(conversationType==4){
    				    return getRealUserId(targetid);
    				}else {
    					writeLog("targetide无效："+targetid);
    				}
    			}catch(e){
    			    writeLog("targetid:"+targetid);
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
			if(isIMdebug){
    		var ua = navigator.userAgent.toLowerCase();
    		if(ua.match(/chrome\/([\d.]+)/)){
    		  
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
var discussList={};
var settingInfos={};
var localmsgtags={};
var isIMdebug=false;

window.onload = function () {
    var listeners = {
        //接收消息的回调
        onMessageReceived: function (data) {
            try {
                // 原处理逻辑  start
                receiveIMMsg(data);
            } catch (e) {
                writeLog('onMessageReceived 处理异常：' + e);
            }
        },
        onConnectionSuccess: function (x) {
            writeLog("connected，userid＝" + x);
            if (ChatUtil.isFromPc()) {
                RongErrorUtils.close();
                RongErrorUtils.isErroring = false;
            }
            M_CONNCNT = 5;
            M_ISRECONNECT = false;
            M_SERVERSTATUS = true;
            //连接成功获取服务端配置
            M_CORE.getInstance().getServerConfig({
                onSuccess: function (info) {
                    M_SERVERCONFIG = info;
                }, onError: function (err) {
                    writeLog(err);
                }
            });
            // 获取在线状态
            OnLineStatusUtil.getUserOnlineStatus(SOCIAL_GLOBAL.OnlineStatus.M_ALLUSERSTATUS.slice(0));
        },
        onConnectionError: function (x) {
            writeLog(x)
            writeLog('onConnectionError 链接失败');
            M_ISRECONNECT = false;
            M_SERVERSTATUS = false;
            //如果是强制下线不需重连
            if ((x == Strophe.Status.AUTHFAIL || x == Strophe.Status.DISCONNECTED) && !M_ISFORCEONLINE && !M_OTHERDEVICE) {
                if (M_ISFORCEONLINE) return;
                OpenFireConnectUtil._startRecon();
            }
        },
        //ws验证失败后的逻辑 验证失败(IM正常;但是token获取有问题)
        onConnectionVerifyFail: function (x) {
            OpenFireConnectUtil._setMessageToken();
        },
    	OnLineStatuHandler: function (data,fromUserid){
            try {
                if(ClientSet.ifForbitOnlineStatus != '1'){
                    if(data=='busy'||data=='away'){
                        //出现这种情况，是用户设置了在线状态，服务端给用户反馈了一个自己的状态，几乎不会走这里
                        OnLineStatusUtil.setAllStatus(fromUserid,data,'offline');
                    }else{
                        OnLineStatusUtil.receiveUserStatusHandle(OnLineStatusUtil.packageUserStatus(data,2));
                    }
                }else{
                    return ;
                }
			}catch(e) {console && console.log("在线状态处理异常"+e);}
		}
		};
		M_SERVERPINGInterval = setInterval(function () {
											if (typeof M_CORE.getInstance() == "object") {
												M_CORE.getInstance().pingSend({
													onSuccess: function (result) {
														if(!result){
															OpenFireConnectUtil._disConnect(result);
														}
													},
													onError: function (result) {//触发重连，失败后的操作
														if(typeof result =='boolean'&& (!!result)||(result==null)){
															OpenFireConnectUtil._disConnect(result);	
														}														
													}
												})
											}
										}, 1000 * 10);
    client = new IMClient(listeners);
	userInfos[M_USERID]={"userid":"<%=userid%>","userName":"<%=user.getLastname()%>","userHead":"<%=messageUrl%>","deptName":"<%=SocialUtil.getUserDepCompany(userid)%>","jobtitle":"<%=jobtitle%>","mobile":"<%=mobile%>","mobileShow":"<%=mobileShow%>","py":"<%=py%>","signatures":"<%=signatures%>"};
}
</script>