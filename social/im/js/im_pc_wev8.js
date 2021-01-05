// 来自pc客户端登陆时，加载完成要做的操作
var pcWindowConfig = {
    winMax: false,
    shortcut : {
        screenshot : null
    }
};

global.require = window.Electron.require;

$(function(){
    // 设置ajax全局参数
    $.ajaxSetup({
        data: {
            from: 'pc',
            sessionkey : window.Electron.ipcRenderer.sendSync('global-getSessionKey'),
            language : PcMainUtils.userInfos.language
        }
    });
    // 重置托盘图标提示信息
    window.Electron.ipcRenderer.send('tray-setToolTip', 'e-message\r\n用户：' + M_USERNAME + '\r\n状态：在线');

    //设置页面drag样式
    $('#imMainbox').addClass('no-drag');
    $('#imDefaultdiv').addClass('can-drag');
    
    // 聊天左侧tabs，有tab的地方不能拖拽，无tab的可以拖拽
    $('#imLeftdiv').addClass('can-drag');
    $('#chatIMTabs').addClass('no-drag');
    $('#imCenterdiv').addClass('no-drag');
    
    $('.addressTitle').addClass('can-drag none-select');
    
    // 初始化PC工具
    PcMainUtils.init();
    
    //初始化窗口分离
    if(WindowDepartUtil.isAllowWinDepart()&&new_win=="right"){
        WindowDepartUtil.init();
    }
    
    
    // 获取配置信息
    PcSysSettingUtils.init(function(){
        // 注册全局快捷键
        PcGlobalShortcutUtils.init();
    });
    
    // 绑定事件
    // 窗口最小化
    $('#pcMin').click(function(){
        window.Electron.currentWindow.minimize();
    });
	//pc顶部工具按钮
    $('#pcOnTop').click(function(){
       if($('#windowTool').is(":hidden")){
			$('#windowTool').show();
		}else{
			$('#windowTool').hide();
		}		
		stopEvent();
    });
	//保持窗口最前
	if(Electron.currentWindow.isAlwaysOnTop()){
		var  pcOnTop = $('#windowTool').find("[_index='1']");
		pcOnTop.addClass('active');
		windowUtil._isAlwaysOnTopFlag = true;
	}
	$('#tool-1').click(function(){
		var  pcOnTop = $('#windowTool').find("[_index='1']");
		var currentWindow = Electron.currentWindow;
		if(pcOnTop.hasClass('active')){
			if(currentWindow.isAlwaysOnTop()){
				currentWindow.setAlwaysOnTop(false);
			}
				windowUtil._isAlwaysOnTopFlag = false;
				pcOnTop.removeClass('active');
		}else{
			if(!Electron.currentWindow.isAlwaysOnTop()){
				currentWindow.setAlwaysOnTop(true);
			}
				pcOnTop.addClass('active');
				windowUtil._isAlwaysOnTopFlag = true;
		}
		$('#windowTool').hide();
	});
    // 窗口最大化
    var isMainWinMax = false; // 主窗口是否是最大化
    $('#pcMax').click(function(){
        isMainWinMax = !isMainWinMax;
        if(isMainWinMax){
            $('#imMainbox').removeClass('imMainbox-p5').addClass("imMainbox-p0");
        }else{
            $('#imMainbox').removeClass('imMainbox-p0').addClass("imMainbox-p5");
        }
        try{
            if(WindowDepartUtil.isAllowWinDepart()){
                if(WindowDepartUtil.tabIsNull()){
                    var win = window.Electron.currentWindow;
                    var width = win.getSize()[0];
                    var args = {
                        "isMainWinMax" : isMainWinMax,
                        "width" : width
                    };
                    window.Electron.ipcRenderer.send('set-mainwindow-max', args);
                }else
                {
                    window.Electron.ipcRenderer.send('set-mainwindow-max', isMainWinMax);
                }
            }else{
                window.Electron.ipcRenderer.send('set-mainwindow-max', isMainWinMax);
            }
            if(isMainWinMax){
                $(this).removeClass('pc-imMaxBtn').addClass('pc-imMaxBtn-re');
                $(this).attr('data-title',social_i18n('PCRETURN'));
            }else{
                $(this).removeClass('pc-imMaxBtn-re').addClass('pc-imMaxBtn');
                $(obj).attr('data-title',social_i18n('PCMAX'));
            }
            setInputAreaAutoResize();
        }catch(e){
        	
        }
    });
    
    // 关闭窗口
    $('#pcClose').click(function(){
        var config = PcSysSettingUtils.getConfig();
    	var noLongerRemind = config.mainPanel.noLongerRemind;
        var alwaysQuit = config.mainPanel.alwaysQuit;
        if(noLongerRemind) {
            if(alwaysQuit) {
                PcMainUtils.quitApp();
            } else {
               PcMainUtils.hiddenToTray();
            }
        } else {
            if(WindowDepartUtil.isAllowWinDepart()&&new_win=='right'){
                WindowDepartUtil.showQuitDialog();
            }else{
                showQuitDialog();
            }
        }
    });
    window.Electron.ipcRenderer.on('pc_out', function(event, args){
        if(PcMainUtils.isOSX()){
            PcMainUtils.quitApp();
        }else{
            var config = PcSysSettingUtils.getConfig();
            var noLongerRemind = config.mainPanel.noLongerRemind;
            var alwaysQuit = config.mainPanel.alwaysQuit;
            if(noLongerRemind) {
                if(alwaysQuit) {
                    PcMainUtils.quitApp();
                } else {
                PcMainUtils.hiddenToTray();
                }
            } else {
                if($("#noLongerRemind").length<1){
                    if(WindowDepartUtil.isAllowWinDepart()&&new_win=='right'){
                        WindowDepartUtil.showQuitDialog();
                    }else{
                        showQuitDialog();
                    }
                    window.Electron.currentWindow.show();
                }
            }
        }
    });
    window.Electron.ipcRenderer.on('pc_focus', function(event, args){
        var currentTab = getCurrentTab();
        var chatWinid=$(currentTab).attr("_chatWinid");
  		try{
            console.log('获取焦点');
            //检测是否离线
            // ServerExceptionHandling._exeAjax();
  			var chattype = chatWinid.substring(8, 9);
  			var targetid = chatWinid.substring(10, chatWinid.length);
            client && client.reconnect(function(isSuccess){
                if(isSuccess&&IS_BASE_ON_OPENFIRE) OpenFireConnectUtil._updateConverTimeAndMessage();
            });//激活后检查链接状态，如果断开重新连接
            if(chattype == 7) return;  
            if(chattype == 8){
                sendLocalCountMsg(targetid+"|private");
                PrivateUtil.setConnverCache(targetid,false);	
                return;
            }
            sendLocalCountMsg(targetid);
  			ChatUtil.setCurDiscussInfo(targetid, chattype);
            // 清理未读数
            updateTotalMsgCount(targetid,false,chattype,0);

            //消除窗口消息未读提醒
            checkReadPosition(chatWinid);
  		}catch(e){
  			console.log('error from pc_focus');
  		}
        //changeTabWin(currentTab);
    });
    
    // 注册托盘图标相关事件
    TrayUtils.initRegisterEvent();
    
    // 启动服务器状态监测
    ServerExceptionHandling.start();
    // 服务器端口扫描监测
    if(IS_BASE_ON_OPENFIRE){
        NetworkListenerUtils._init();
    }
   
    
    // 打开新窗口
    window.Electron.ipcRenderer.on('open-new-window', function(event, args){
        var url = args;
        // 内部链接
        PcExternalUtils.openUrlByLocalApp(url, 0);
    });
      // 打开设置窗口
    window.Electron.ipcRenderer.on('open-window-set', function(event, args){
        var url = args;
        // 内部链接
        //PcExternalUtils.openUrlByLocalApp(url, 0);
    });
    // 注册退出前事件
    window.Electron.ipcRenderer.on('pc-send-logout', function(event, args){
        pcSendLogout();
    });
    
    // 清理缓存后页面reload前事件
    // 注册退出前事件
    window.Electron.ipcRenderer.on('before-reload', function(event, args){
        // 取消所有下载
        PcDownloadUtils.abortAllDl();
        stopDirSending();
    });
    
    // 注册下载监听
    try {
        PcDownloadUtils.initDownload();
    } catch(e) {
        console.error('下载程序出错！！');
        console.error(e);
    }
    
    // 检测服务端版本
    DetectionOfUpgrade.start();
    
    //客户端调用本地浏览器打开链接。
    window.Electron.ipcRenderer.on('open-url-local', function(event, args){
        var url = args.url;
        var urlType = args.urlType;
        PcExternalUtils.openUrlByLocalApp(url, urlType);
    });
    
    //执行主窗口中的方法
    window.Electron.ipcRenderer.on('apply-chatwin-func', function(event, args){
        if('trayClick' == args) {
            $('.imToptab').find('[_target="recent"]').click();
        }
    });
	//取消云盘分享接口
	window.Electron.ipcRenderer.on('cancelShare-Message',function(event,args){
	if(args.cancelType =="disk"){			
		HandleInfoNtfMsg.caneclShareDiskMsg(args.msgid, args.targettype, args.targetid);
		}
	});
    //发送云盘消息
	 window.Electron.ipcRenderer.on('shareFile-to-us', function(event, args){
		//alert(args.sendType);
       if(args.sendType == 0){
			var _targetId = args.TargetId;
			var _msgObj = args.Msg;
			var _msgType = 6;
			var extraObj = eval("("+args.Msg.extra+")");
			showIMChatpanel(0,_targetId,_msgObj.targetName,userInfos[_targetId].userHead);
		IMClient.prototype.sendMessageToUser(_targetId ,_msgObj , _msgType,function(msg){
			  	msg.paramzip.msgobj.chatdivid = _targetId;
				var userInfo=userInfos[M_USERID];
				var chatList=$("#chatWin_"+0+"_"+_targetId).find(".chatList");
				var tempMsgObj={"content":_msgObj.content,"imgUrl":'',"objectName":_msgObj.objectName,"extra":_msgObj.extra,'chatdivid':_targetId, "timestamp":_msgObj.timestamp};
				var tempdiv=ChatUtil.getChatRecorddiv(userInfo,tempMsgObj,'send',_msgType, null, _targetId);
				var sendtime=M_CURRENTTIME;
				addSendtime(chatList,tempdiv,sendtime,"send");
				chatList.append(tempdiv);
				chatList.perfectScrollbar("update");
				scrollTOBottom(chatList);
				chatList.data("newMsgCome", true);		
				ChatUtil.doHandleSendState(msg);
				var issuccess=msg.issuccess;
				if(issuccess==1){
					ChatUtil.doHandleSendSuccess(msg, extraObj.msg_id, _targetId, 0);
				}
				window.Electron.currentWindow.flashFrame(true);
		});
	   }
	   if(args.sendType == 1){	 
			var _targetId = args.TargetId;
			var _msgObj = args.Msg;
			var _msgType = args.Msg.msgType;
			var extraObj = eval("("+args.Msg.extra+")");
		showIMChatpanel(1,_targetId,_msgObj.targetName,'/social/images/head_group.png');
		IMClient.prototype.getDiscussionMemberIds(extraObj.receiverids,function(info){
				extraObj.receiverids = info.join();
				_msgObj.extra = JSON.stringify(extraObj);
			IMClient.prototype.sendMessageToDiscussion (_targetId,_msgObj,_msgType,function(msg){
				msg.paramzip.msgobj.chatdivid = msg.paramzip.receverids;
				var userInfo=userInfos[M_USERID];
				var chatList=$("#chatWin_"+1+"_"+_targetId).find(".chatList");
				var tempMsgObj={"content":_msgObj.content,"imgUrl":'',"objectName":_msgObj.objectName,"extra":_msgObj.extra,'chatdivid':msg.paramzip.receverids, "timestamp":_msgObj.timestamp};
				var tempdiv=ChatUtil.getChatRecorddiv(userInfo,tempMsgObj,'send',_msgType, null, msg.paramzip.receverids);
				var sendtime=M_CURRENTTIME;
				addSendtime(chatList,tempdiv,sendtime,"send");
				chatList.append(tempdiv);
				chatList.perfectScrollbar("update");
				scrollTOBottom(chatList);
				chatList.data("newMsgCome", true);		
				ChatUtil.doHandleSendState(msg);
				var issuccess=msg.issuccess;
				if(issuccess==1){
					ChatUtil.doHandleSendSuccess(msg, extraObj.msg_id, _targetId, _msgType);
				}
				window.Electron.currentWindow.flashFrame(true);
		});
			});
	   }
	    if(args.sendType == 2){
		 var resourceids = '';
		 var msgInfo = args.Msg;
		 for(var i = 0; i< args.memList.length;i++){
				resourceids = resourceids + ',' + args.memList[i].substr(0, args.memList[i].indexOf('|'));
			}
		resourceids = resourceids.substr(1);
		 DiscussUtil._addDiscuss(args.disName,resourceids,args.memList,function(info, disName){
			showIMChatpanel(1,info,disName,'/social/images/head_group.png');	
					for (var i= 0; i < msgInfo.length;i++) {							
						var extraObj = eval("("+msgInfo[i].extra+")");
						extraObj.receiverids = resourceids;
						msgInfo[i].extra = JSON.stringify(extraObj);
		   IMClient.prototype.sendMessageToDiscussion (info,msgInfo[i],msgInfo[i].msgType,function(msg){
						msg.paramzip.msgobj.chatdivid = msg.paramzip.receverids;
						var userInfo=userInfos[M_USERID];
						var chatList=$("#chatWin_"+1+"_"+info).find(".chatList");
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
						typeof addNetWorkFileShare === 'function' && addNetWorkFileShare(msgInfo[i].shareFileId,info,2,msgInfo[i].shareFileType,extraObj.msg_id);
					 } 
			
		 		 window.Electron.currentWindow.flashFrame(true);
		 });
	   }
	   
    });
    // 截图相关通道注册
    ScreenshotUtils.initIpcRenderers();
    // 聊天窗口通道注册
    ChatWinUtils.initIpcRenderers();
    if(new_win!==undefined&&new_win=='right'){
        //窗口分离右侧窗口不需要加载
    }else{
        // 粘贴板通道注册
        ClipboardHelper.initIpcRenderers();
    }
    // 增量更新通道注册
    UpdateChecker.initIpcRenderers();
});

// 打开退出按钮确认对话框
function showQuitDialog(){
    DragUtils.closeDrags();
    var inhtml  = '<div class="quitdialog none-select">';
        inhtml += '   <div><input type="radio" name="confirmQuit" value="1"/>'+social_i18n('HideTray')+'</div>';
        inhtml += '   <div style="padding-top: 5px;"><input type="radio" name="confirmQuit" value="2" checked="checked" />'+social_i18n('Quit')+'&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</div>';
        inhtml += '   <div class="noLongerRemind"><input type="checkbox" id="noLongerRemind" name="noLongerRemind" onclick="clickNoLongerRemind(this)" />'+social_i18n('Remember')+'</div>';
        inhtml += '</div>';
        
    var diag = new window.top.Dialog();
    diag.Title = social_i18n('Quit');
    diag.Width = 280;
    diag.Height = 130;
    diag.normalDialog= false;
    diag.InnerHtml = inhtml;
    diag.OKEvent = function(){
        var confirmQuit = $('input[name="confirmQuit"]:checked').val();
        var noLongerRemind = $('#noLongerRemind').is(':checked');
        if(noLongerRemind) {
            var userConfig = PcSysSettingUtils.getConfig();
            userConfig.mainPanel.noLongerRemind = true;
            userConfig.mainPanel.alwaysQuit = confirmQuit == 1 ? false : true;
            PcSysSettingUtils.saveConfig(userConfig);
            comfirmDialog(confirmQuit);
        } else {
            comfirmDialog(confirmQuit);
        }
    };
    diag.CancelEvent = function(){
        DragUtils.restoreDrags();
        diag.close();
    };
        
    diag.show();
    $('.quitdialog').jNice();
    
    function comfirmDialog(cq) {
        if(cq == 1) {
           DragUtils.restoreDrags();
           diag.closeManual();
           
           setTimeout(function(){
               PcMainUtils.hiddenToTray();
           }, 100)
        } else {
            PcMainUtils.quitApp();
        }
    }
    
    // 带上这个checkbox才能点，不知道为什么！！
    function clickNoLongerRemind(obj) {}
}



// 打开设置对话框
function openSysSetting() {
    if(WindowDepartUtil.isAllowWinDepart()&&WindowDepartUtil.tabIsNull()){
       var args = {
           title : social_i18n("SysSettings"),
           width : 570,
           height : 480
       };
       WindowDepartUtil.openNewWindow(args,WindowDepartUtil.NewWindowList.SysSettings);
    }else{
           var diag = getSocialDialog(social_i18n("SysSettings"), 570, 420); 
	   diag.URL = '/social/im/SocialIMPcSysSetting.jsp?d=' + new Date().getTime();
	   diag.normalDialog= false;
	   diag.show();
    }
}

/**
    程序退出前执行的操作。
*/
function pcSendLogout() {
    /*
    // 清理缓存
    if(window.Electron.currentWindow) {
        window.Electron.currentWindow.webContents.session.clearCache(function(){
            console.info('退出清理缓存');
        });
    }
    */
    
    // 取消所有下载
    PcDownloadUtils.abortAllDl();
    //退出的时候假如报错会影响退出
    try{
    if(client) {
        M_ISFORCEONLINE = true;
        client.disconnect();
       // client.disconnect(true);
    }
    }catch(err){}
    stopDirSending();
    
    // 设置pc端为未登陆状态。
    $.ajax({
        async : false,
        url : '/social/im/ServerStatus.jsp?p=logout',
        timeout : 200
    });
}
// 取消所有发送和接收文件夹
function stopDirSending(){
	try{
		PcSendDirUtils.cancelAllSend();
	    PcSendDirUtils.cancelAllReceive();
	    PcSendDirUtils.stopServer();
	}catch(e){
		console.error("！！没有开启文件和文件夹传输功能！！");
	}
}

// 工具
var PcMainUtils = {
    userInfos : window.Electron.ipcRenderer.sendSync('global-getUserInfos'),
    appPath : window.Electron.ipcRenderer.sendSync('global-getAppPath'),
    node_path : window.Electron.require('path'),
    platform : window.Electron.ipcRenderer.sendSync('global-getPlatform'),
    localconfig : null,
    pcUtils : null,
    
    // 初始化
    init : function(){
        this.localconfig = window.Electron.require(this.node_path.join(this.appPath, './localconfig.js'));
        this.pcUtils = window.Electron.require(this.node_path.join(this.appPath, './pcUtils.js'));
    },
    
    // 判断用户操作系统类型
    isWindows : function(){
        return this.platform.Windows;
    },
    isOSX : function(){
        return this.platform.OSX;
    },
    isLinux : function(){
        return this.platform.Linux;
    },
    getOSType : function(){
        var osType = 1;
        if(this.isOSX()) {
            osType = 2;
        } else if(this.isLinux()) {
            osType = 3;
        }
        return osType;
    },
    
    // 阻塞程序numberMillis毫秒数
    sleep : function(numberMillis) {
        var now = new Date();
        var exitTime = now.getTime() + numberMillis;
        while (true) {
            now = new Date();
            if (now.getTime() > exitTime) return;
        }
    },
    
    // 最小化到托盘
    hiddenToTray : function(){
    	var  win = window.Electron.currentWindow;
        if(this.isWindows()) {
        	win.blur();
            win.hide();         
        } else if(this.isOSX()) {
           win.minimize();
        }
    },
    // 退出程序
    quitApp : function(){
		pcSendLogout();
        window.Electron.ipcRenderer.send('quit-app');
    },
    // 退出并重启程序
    restartApp : function(){
		pcSendLogout();
        window.Electron.ipcRenderer.send('quit-restart-app');
    },
    // 注销
    logout : function(){
        var _this = this;
        _this.localconfig.setLogout(true, function(){
            _this.quitApp();
        });
    },
    
    // 判断路径是否是一个文件
    isFile : function(filepath){
        const fs = window.Electron.require('fs');
        var stats = fs.statSync(filepath);
        return stats.isFile();
    },
    // 判断文件是否存在
    isExistFile: function(path, callback){
    	const fs = window.Electron.require('fs');
    	fs.exists(path, callback);
    },
    // 获取文件信息
    getFileStats: function(path, callback){
    	const fs = window.Electron.require('fs');
    	fs.stat(path, function(err, stats){
    		if(typeof callback != 'function') return;
    		if(err) callback(err);
    		else{
    			var index = path.lastIndexOf('\\');
				var len = path.length;
				var filename = index != -1? path.substring(index+1, len):path;
    			callback(null, {size:stats.size, name:filename, path: path, isfile: stats.isFile()});
    		}
    	});
    },
    // 显示提示框
    showMsg: function(msg, win){
    	var dialog = window.Electron.remote.dialog;
    	var currentWindow =window.Electron.currentWindow;
    	dialog.showMessageBox(win?win:currentWindow, {
			type: 'info',
			title : social_i18n('Info'),
			message : msg,
			buttons : []
		});
    },
    // 显示确认框
    showConfirm: function(msg, win, cbOption){
    	var dialog = window.Electron.remote.dialog;
    	var currentWindow =window.Electron.currentWindow;
    	dialog.showMessageBox(win?win:currentWindow, {
			type: 'info',
			title : social_i18n('Info'),
			message : msg,
			buttons : [social_i18n('Confirm'),social_i18n('Cancel')],
			defaultId: 0
		},function(response){
			if(response == 0) {
				if(cbOption.confirm)
					cbOption.confirm();
			}else{
				if(cbOption.cancel)
					cbOption.cancel();
			}
		});
    },
    // 获取用户配置信息,callback(error, config)
    getSetting : function(callback){
        this.localconfig.get(callback);
    },
    // 保存用户配置信息
    setSetting : function(config) {
        this.localconfig.set(config);
    },
    
    // 获得当前版本信息
    getVersion : function(){
        return this.pcUtils.getBuildVersion();
    },
    // 客户端开启控制台打印，默认关闭
    openConsole: function(){
    	try{
	    	window.Electron.require('log4js').configure({
			    "replaceConsole": false
			});
    	}catch(err){
    	}
    },
    // 客户端开启控制台打印
    closeConsole: function(){
    	try{
	    	window.Electron.require('log4js').configure({
			    "replaceConsole": true
			});
    	}catch(err){
    	}
    },
    logger: null,
    // 初始化日志对象
    initLogger: function(category){
    	try{
    		category = category || 'log_file';
	    	var log4js = window.Electron.require('log4js');
	    	var conf = {
	    		"appenders": [
			        {
			            "category": category,
			            "type": "datefile",
			            "filename": "logs/app",
			            "pattern": "-yyyy-MM-dd.log",
			            "alwaysIncludePattern": true,
			            "backups": 30
			        }
			    ],
			    "replaceConsole": false,
			    "levels": {
			        "log_file": "INFO"
			    }
	    	};
	    	log4js.configure(conf);
	    	this.logger = log4js.getLogger(category);
	    	if(!this.logger) this.logger = console;
    	}catch(err){
    		console.error(err);
    		this.logger = console;
    	}
    },
    // 记录文件日志
    log: function(content){
        if(this.logger == null) {
            this.initLogger("info");
        }
        var logger = this.logger;
        logger.info(content);
    },
    logToText : function(level,content){
        var args = {
            "level" : level,
            "content" : content
        };
        window.Electron.ipcRenderer.send('plugin-logToText',args);
    },
    //清理缓存
    clearCache: function(callback){
        var win = window.Electron.currentWindow;
        win.webContents.session.clearCache(callback);
    }
};

// 获取文档宽高
var documentUtils = {
    width : function(){
        return $(document).width();
    },
    height : function(){
        return $(document).height();
    }
};

// 关闭和打开其他可拖拽属性。
// 打开一个对话框或者弹出操作层时，首先关闭页面其他可拖拽属性，在操作完成或关闭对话框时，再恢复可拖拽。
var DragUtils = {
    _canDrags : null,
    closeDrags : function(){
        var $imSlideDiv = $('#imSlideDiv')
        if(this._canDrags == null && $imSlideDiv.css('display') == 'none') {
            this._canDrags = $('.can-drag');
            this._canDrags.removeClass('can-drag');
        }
    },
    restoreDrags : function(){
        var $imSlideDiv = $('#imSlideDiv')
        if(this._canDrags != null && $imSlideDiv.css('display') == 'none') {
            this._canDrags.addClass('can-drag');
            this._canDrags = null;
        }
    }
};

// 设置有未读消息时托盘图标闪动。
// 规则：只要有未读消息，就闪动图标。当没有未读时取消闪动。
var TrayUtils = {
    _isBusying : false,
    _isOffline : false,
    _currentWin : window.Electron.currentWindow,
    _username : M_USERNAME,  // 用户名
    initRegisterEvent : function(){
        var _this = this;
        window.Electron.ipcRenderer.on('user-click-tray', function(event, args){
            _this.restoreTray();
        });
    },
    hasUnreadMsg : function(){
        var recentTab = $(".imToptab .tabitem[_target='recent']");
        var recentmsgcount = recentTab.find(".recentmsgcount")	
        var total = Number(recentmsgcount.attr("_msgcount"));
        total = total? total:0;
        return count > 0;
    },
    flashingTray : function(){
        if(!isCurrentWindowFocused()) {
            this._currentWin.flashFrame(true);
        }
    
        if(!isCurrentWindowFocused() && this._isBusying == false) {
            window.Electron.ipcRenderer.send('tray-setTrayBusy');
            this._isBusying = true;
        }
    },
    restoreTray : function(){
        if(this._isBusying) {
            window.Electron.ipcRenderer.send('tray-setTrayCommon');
            this._isBusying = false;
            this._currentWin.flashFrame(false);
        }
        if(!IS_BASE_ON_OPENFIRE){this._isOffline =true;}
        if(!this._isOffline) {
            window.Electron.ipcRenderer.send('tray-setTrayCommon');
            if(SOCIAL_GLOBAL.OnlineStatus.M_ONLINESTATUS[M_USERID]!=undefined){
                try{
                    var status = SOCIAL_GLOBAL.OnlineStatus.M_ONLINESTATUS[M_USERID].pc;
                    if(status==undefined) status='online';
                }catch(err){
                    var status = "online";
                }
                
                this.setTrayTooltip('状态：'+ONLINESTATUS[status]);
                this._isOffline = false;
            }else{
                this.setTrayTooltip('状态：在线');
                this._isOffline = false;
            }
        }
    },
    offlineTray : function(x){
        var _this = this;
        if(!_this._isOffline) {
            window.Electron.ipcRenderer.send('tray-offlineStatus');            
            if(x){
                _this.setTrayTooltip('状态：'+x);
            }else{
                _this.setTrayTooltip('状态：离线');
            }
            _this._isOffline = true;
            _this._isBusying = false;
        }
    },
    setTrayTooltip : function(msg){
        window.Electron.ipcRenderer.send('tray-setToolTip', 'e-message\r\n用户：' + this._username + '\r\n' + msg);
    }
};

// 聊天窗口工具
var ChatWinUtils = {
	initIpcRenderers : function(){
		var win = window.Electron.currentWindow;
		var self = this;
        window.Electron.ipcRenderer.on('closeallchatwin-hotkey', function(event, args){
        	DragUtils.closeDrags();
        	var closeBtns = $('#chatIMTabs').find('.tabClostBtn');
        	var len = closeBtns.length;
        	if(len > 0) {
        		if(self.isShowing) return;
        		self.isShowing = true;
        		Dialog.confirm(social_i18n('ChatWinCloseTip'), function(){
	            	DragUtils.restoreDrags();
	            	self.isShowing = false;
	            	setTimeout(function(){
	            		
	            		var BusyOptions = self.checkChatWinBusy();
	            		if(BusyOptions.isBusy){
	            			var busyWinIds = BusyOptions.busyWinIds;
	            			var allWinIds = BusyOptions.allWinIds;
	            			self.closeChatWinBatch(busyWinIds, allWinIds);
	            		}else{
	            			var allWinIds = BusyOptions.allWinIds;
	            			while(allWinIds.length > 0) {
	            				var nextWinId = allWinIds.pop();
		            			self.closeChatWin(nextWinId, event);
		            			self.isShowing = false;
	            			}
	            		}
	            	}, 20);
	            }, function(){
	            	self.isShowing = false;
	            });
        	}
        });
        
        window.Electron.ipcRenderer.on('closechatwin-hotkey', function(event, args){
        	if(self.isShowing) return;
        		self.isShowing = true;
         	var currentChatWin = ChatUtil.getCurChatwin();
         	var chatwinid = currentChatWin.attr('id');
         	
         	DragUtils.restoreDrags();
        	self.isShowing = false;
        	setTimeout(function(){
        		
        		var BusyOptions = self.checkChatWinBusy();
        		if(BusyOptions.isBusy){
        			var busyWinIds = BusyOptions.busyWinIds;
        			if(busyWinIds.length > 0) {
        				var nextWinId = busyWinIds.pop();
            			changeTabWin($('#chatIMTabs').find("[_chatwinid='"+nextWinId+"']").get(0));
            			
            			//DragUtils.closeDrags();
            			self.isShowing = true;
            			PcMainUtils.showConfirm(social_i18n('ChatWinCloseTip1'), null, {
            				'confirm': function(){
            					self.closeChatWin(nextWinId, event);
            					self.isShowing = false;
            				},
            				'cancel': function(){
            					self.isShowing = false;
            				}
            			});
        			}
        		}else{
        			self.closeChatWin(chatwinid, event);
            		self.isShowing = false;
        		}
        		
        	}, 20);
         	
        });
    },
    closeChatWinBatch: function(busyWinIds, allWinIds){
    	var self = this;
    	if(busyWinIds.length > 0) {
			var nextWinId = busyWinIds.pop();
			changeTabWin($('#chatIMTabs').find("[_chatwinid='"+nextWinId+"']").get(0));
			IMUtil.removeArray(allWinIds, nextWinId);
			self.isShowing = true;
			PcMainUtils.showConfirm(social_i18n('ChatWinCloseTip1'), null, {
				'confirm': function(){
					self.closeChatWin(nextWinId, event);
					self.isShowing = false;
					self.closeChatWinBatch(busyWinIds,allWinIds);
				},
				'cancel': function(){
					self.isShowing = false;
					self.closeChatWinBatch(busyWinIds,allWinIds);
				}
			});
		}else{
			while(allWinIds.length > 0){
				var winId = allWinIds.pop();
				self.closeChatWin(winId, event);
			}
		}
		
    },
    // 关闭
    closeChatWin: function(chatwinid, evt){
    	var tabObj = $('#chatIMTabs').find("[_chatwinid='"+chatwinid+"']");
    	closeTabWin(tabObj);
    },
    // 检查窗口正在上传文件
    checkChatWinBusy: function(chatWinId){
    	var self = this;
    	var ret = {isBusy: false, busyWinIds: [], allWinIds: []};
    	if(chatWinId){
    		var isBusy = self._getBusyStatus(chatWinId);
    		ret = {isBusy: isBusy, busyWinIds: isBusy?[chatWinId]:[], allWinIds: [chatWinId]};
    	}else{
    		var chatwins = $('#chatIMdivBox').find('.chatWin');
    		for(var i = 0; i < chatwins.length; ++i){
    			var winid = $(chatwins[i]).attr('id');
    			var isBusy = self._getBusyStatus(winid);
    			if(isBusy){
    				ret.isBusy = true;
    				ret.busyWinIds.push(winid);
    			}
    			ret.allWinIds.push(winid);
    		}
    	}
    	return ret;
    },
    // 获取窗口状态
    _getBusyStatus: function(chatWinId){
    	var isBusy = false;
    	if($('#'+chatWinId+'_SUC').children().length > 0) {
    		isBusy = true;
    	}
    	var chatcontentDiv = $('#'+chatWinId).find('.chatcontent');
    	if(chatcontentDiv.length > 0 && chatcontentDiv.html().length > 0) {
    		isBusy = true;
    	}
    	return isBusy;
    },
    // 检查窗口正在输入
    checkChatWinTyping: function(obj){
    	var chatTabDiv = $(obj).closest('.chatIMTabItem');
    	var chatWinId = chatTabDiv.attr('_chatwinid');
    	var flag = false;
    	// 判断是否正在输入
    	var chatcontentDiv = $('#'+chatWinId).find('.chatcontent');
    	if(chatcontentDiv.length > 0 && chatcontentDiv.html().length > 0) {
    		flag = true;
    	}
    	return flag;
    }
};

// 检查更新
var  UpdateChecker = {
	initIpcRenderers : function(){
		var self = this;
	 	window.Electron.ipcRenderer.on('check-update-finished', function(event, args){
	 		showImConfirm(social_i18n('UpdateTip3'), function() {
	 			PcMainUtils.logout();
	 		});
	 	});
	 },
	 check: function() {
	 	$.ajax({
            url : '/social/im/ServerStatus.jsp?p=getVersion',
            dataType : 'json',
            success : function(data){
                var c_version = PcMainUtils.getVersion(), needUpdate = true;
                if(PcMainUtils.isWindows() && c_version.buildVersion < data.buildversion) {
                	updateTip = social_i18n('UpdateTip0')+data.version + "." + data.buildversion + social_i18n('UpdateTip1');
                }else if(PcMainUtils.isOSX() && c_version.osxBuildVersion < data.osxBuildVersion) {
                	updateTip = social_i18n('UpdateTip0')+data.version + "." + data.osxBuildVersion + social_i18n('UpdateTip1');
                }else {
                	updateTip = social_i18n('UpdateTip2');
                	needUpdate = false;
                }
                if(needUpdate) {
                	window.top.Dialog.confirm(updateTip, function() {
	                	window.Electron.ipcRenderer.send('check-Update', {'giveSuccDialog': true});
	                });
                }else {
                	window.top.Dialog.alert(updateTip);
                }
            }
		});
	 }
}

// 粘贴板操作
var ClipboardHelper = {
	querying: false,
	chatObj: null,
	ajaxUpload: function(blobParts, path, ts_msgid, chatObj, cb){
		var self = this;
		var chatwin = ChatUtil.getchatwin(chatObj);
    	var chatSend = chatwin.find(".chatSend");
    	var targetid = chatwin.attr("_targetid");
		var index = path.lastIndexOf('\\');
		var len = path.length;
		var filename = index != -1? path.substring(index+1, len):path;
		var file = new File(blobParts, filename);
		file.path = path;
		var formdata = new FormData();
		formdata.append('enctype', 'multipart/form-data')
		formdata.append('Filedata', file);
		// 上传 --begin
		$.ajax({
            url: '/social/SocialUploadOperate.jsp',
            type: "POST",
            data: formdata,
            processData: false,
            contentType: false,
            beforeSend: function() {
                
            },
            error: function() {
                $('#'+ts_msgid).find('.accTempdivLayer').text(social_i18n("UploadFail"));
                
            },
            success: function(data) {
            	data = $.parseJSON(data);
            	var chatcontentid = "chatcontent_"+targetid;
               	
            	var fileId = data.fileId;
            	var fileName = data.filename;
            	var fileSize = data.filesize;
            	var fileType = getFileType(fileName);
            	var filePath = path.replace(/\\/g, '\/');
            	var data={
					"fileId":fileId,
					"fileName":fileName,
					"fileSize":fileSize,
					"fileType":fileType,
					"filePath":filePath,
					"objectName":"FW:attachmentMsg",
					"resourcetype":"1",
					"tempdivid":ts_msgid
				};
				
				ChatUtil.sendIMMsg(chatSend,6,data,function(msg){
					if(msg && msg.issuccess){
						addIMFileRight(chatSend,data);
						PcDownloadUtils.recordLastsavepath(fileId, filePath);
					}
				});
            }
        })
        // 上传 --end
	},
	// 读取文件流
	readSingleFile: function(stat) {
		var self = this;
		if(!stat) return;
		const fs = window.Electron.require('fs');
	 	const mime = window.Electron.require('mime');
		var path = stat.path;
		var mimetype = mime.lookup(path)
		// use stream to read big file
		var blobParts;
		// 先显示气泡和上传进度--begin
		var chatwin = ChatUtil.getchatwin(self.chatObj);
		var targetid = chatwin.attr("_targetid");
		var sendTime = new Date().getTime();
		var ts_msgid = sendTime;
		// 文件夹不走上传，调用已有的文件夹传输接口
		if(!stat.isfile) {
			PcSendDirUtils.sendDir(self.chatObj, path);
			return;
		}
		var extra = {
			"msg_id": ts_msgid,
			"fileName":stat.name,
			"fileSize":stat.size,
			"fileType":getFileType(stat.name)
		};
		var tempMsgObj={
			"content":stat.name,
			"imgUrl":"",
			"objectName":"FW:attachmentMsg",
			"extra":JSON.stringify(extra),
			'chatdivid':targetid, 
			"timestamp":sendTime, 
			"sendTime": sendTime
		};
		var userInfo = userInfos[M_USERID];
		var tempdiv=ChatUtil.getChatRecorddiv(userInfo,tempMsgObj,'send',6, null, targetid);
		// anyway, 给个蒙板，提示正在上传
		var layer = tempdiv.find('.accitem').clone().removeClass('accitem');
		layer.addClass("accTempdivLayer").empty().text(social_i18n("Uploading"));
		tempdiv.find('.chatContent').css('position', 'relative').append(layer)
		var chatList = chatwin.find('.chatList');
		chatList.append(tempdiv);
		chatList.perfectScrollbar("update");
		scrollTOBottom(chatList);
		// 先显示气泡和上传进度--end
		// 读取文件 --begin
		var readStream = fs.createReadStream(path);
		readStream.on('open', function(fd){
			blobParts = new Array();
			console.log("Read \'"+path+"\' open");
		});
		readStream.on('data', function(data){
			var blob = new Blob([data], {type: mimetype});
			blobParts.push(blob);
		});
		readStream.on('end', function(){
			console.log("Read \'"+path+"\' end");
			self.ajaxUpload(blobParts, path, ts_msgid, self.chatObj);
		});
		readStream.on('close', function(){
			console.log("Read \'"+path+"\' close");
		});
		readStream.on('error', function(err){
			console.info('[!ERR!] Read \''+path+'\' failed!');
			blobParts.splice(0, blobParts.length);
		});
		// 读取文件 --end
	},
	// 按stats对象读取本地文件
	readLocalFilesByStats: function(stats) {
		var self = this;
		$.each(stats, function(i,n){
			var stat = n;
			self.readSingleFile(stat);
			if(i == stats.length - 1) {
				ClipboardHelper.querying = false;
			}
		});
	},
	// 按路径读取本地文件
	readLocalFilesByPath: function(paths) {
		var self = this;
		$.each(paths, function(i,n){
			if(n=='.') return;
			var path = n;
			PcMainUtils.getFileStats(path, function(err, stats){
				if(err) return;
				self.readSingleFile(stats);
			});
			if(i == paths.length - 1) {
				ClipboardHelper.querying = false;
			}
		});
		
	},
	// 判断是否是单个图片文件
	isSingleImageFile: function(files) {
		if(files && files.length == 1 && files[0].isfile) {
			try{
				const mime = window.Electron.require('mime');
				var mimetype = mime.lookup(files[0].path);
				if(mimetype.indexOf('image/') !== -1) {
					return {'stat': files[0], 'mimetype': mimetype};
				}
			}catch(e) {
				console.error(e);
			}
		}
		return false;
	},
	// 单个图片文件采用图片预览
	handleSingleImgFile: function(imgFile) {
		var self =  this;
		var base64Data = null;
		const fs = window.Electron.require('fs');
		try{
			var fileStat = imgFile.stat;
			var mimetype = imgFile.mimetype;
			var filePath = fileStat.path;
			var binData = fs.readFileSync(filePath);
			var base64Data = new Buffer(binData).toString('base64');
			// console.log(base64Data);
			var url = 'data:' + mimetype + ';base64,' + base64Data;  
			// ChatUtil.confirmImgbase64(base64Data, mimetype, $(self.chatObj));
			var blob = new Blob(new Array(binData), {type: mimetype});
			var form = new FormData();
			form.append('enctype', 'multipart/form-data')
			form.append('Filedata', blob);
			var IMdlg = $('.IMConfirm');
			ChatUtil.UploadPreview.imageSize = fileStat.size;
			ChatUtil.UploadPreview.previewdlg = IMdlg;
			ChatUtil.UploadPreview.form = form;
			ChatUtil.UploadPreview.blob = blob;
			ChatUtil.UploadPreview.chatdiv = ChatUtil.getchatdiv(self.chatObj);
			
			IMdlg.imconfirm({
				'autohide':false,
				'draggble':false,
				'isModel':true,
				'title':'图片预览',
				'buttons': [
					{
						'btn_ok': ChatUtil.doHandleChoose
					},
					{
						'btn_cancel': ChatUtil.doHandleChoose
					}
				],
				'innerhtml': '<img src="' + url + '"/>'
			});
			if(IMdlg.attr('showing') == 'true'){
				IMdlg.find('.inner>img').attr('src', url);
			}else{
				IMdlg.imshow();
			}
			ClipboardHelper.querying = false;
			return true;
		}catch(e) {
			console.error("handleSingleImgFile[Error]:", e);
		}
		return false;
	},
	initIpcRenderers : function(){
		var self = this;
	 	window.Electron.ipcRenderer.on('query-clipboard-cb', function(event, args){
	 		var paths = args.paths, files = new Array();
	 		if(paths){
	 			paths.forEach(function(path){
	 				if(path=='.') return;
	 				PcMainUtils.getFileStats(path, function(err, stats){
	 					files.push(stats);
	 					if(files.length == paths.length) {
	 						// 单个图片文件采用图片预览的方式打开
	 						var ImgFile = self.isSingleImageFile(files); 
	 						if(!ImgFile || !self.handleSingleImgFile(ImgFile)) {
	 							handleFileList(files, function(_files){
		 							if(_files){
		 								self.readLocalFilesByStats(_files);
		 							}else{
		 								ClipboardHelper.querying = false;
		 							}
		 						});
	 						}
	 					}
	 				});
	 			});
	 		}else {
	 			ClipboardHelper.querying = false;
	 		}
	 	});
	 }
};
// 截屏工具
var ScreenshotUtils = {
    initIpcRenderers : function(){
		var win = window.Electron.currentWindow;
        window.Electron.ipcRenderer.on('screenshot-hotkey', function(event, args){
            var isChatWinFocused = args.isChatWinFocused;
            if(isChatWinFocused) {
                var $chatwin = ChatUtil.getCurChatwin();
                if($chatwin.length > 0) {
                    var $chatContent = $chatwin.find('.chatcontent');
                    if($chatContent) {
                        $chatContent.focus();
                        //document.execCommand('Paste');
                        ChatUtil.startReloadPrevImgHandler();
                        // window.Electron.currentWindow.webContents.paste();
                    }
                }
           	}
        });
    },
    // 执行截图
    screenshot : function(obj){
		var flag = false;
        if(windowUtil._isAlwaysOnTop()){
			windowUtil._currentWin.setAlwaysOnTop(false);
		}
        if(!windowUtil._isHide()&&!windowUtil._isMinimized()){
            if(ChatUtil.isScreenShotMinimize == 1){
                windowUtil._hide();
                flag =true;
            }
        }
        //延迟加载插件
        setTimeout(function(){
	        var shotData = window.Electron.ipcRenderer.sendSync('plugin-screenshot');
	        // shotData = false 取消了截屏
			windowUtil._currentWin.setAlwaysOnTop(false);
			if(windowUtil._isAlwaysOnTopFlag && !windowUtil._isAlwaysOnTop()){
					windowUtil._currentWin.setAlwaysOnTop(true);
			}
	        if(flag){
	        	setTimeout(function(){
	        		windowUtil._show(); 
	        	}, 2000);
	        }
	        // shotData 总是会返回true
	        if(shotData) {
	            var win = window.Electron.currentWindow;
	            win.focus();
	            var $chatContent = $(obj).parent().parent().find('.chatcontent');
	            if($chatContent.length<=0){
	                $chatContent = $(obj).parent().parent().parent().find('.chatcontent');
	            }
	            $chatContent.focus();
	            //document.execCommand('Paste');
	            // 清除粘贴板里的文本，粘贴板里有文本会导致监听器中断
	            var clipText = window.Electron.clipboard.readText();
	            if(clipText) {
	            	console.log("截图的时候发现粘贴板有文本， 进行清空》》");
	            	window.Electron.clipboard.clear();
	            }
	            ChatUtil.startReloadPrevImgHandler();
	            //win.webContents.paste();
	        }
        },100);
    }
};
//窗口工具
var windowUtil = {
	_isAlwaysOnTopFlag: false,//标识
	_currentWin: window.Electron.currentWindow,
	_isAlwaysOnTop: function(){
		return Electron.currentWindow.isAlwaysOnTop();
	},
	_hide:function(){
		var _this = this;
		_this._currentWin.hide();
	},
	_show:function(){
		var _this = this;
		_this._currentWin.show();
	},
    _isMinimized:function(){//判断是否最小化
        var _this =this;
        return _this._currentWin.isMinimized();
    },
    _isHide:function(){//判断是否隐藏 true 表示没有隐藏
        return !this._currentWin.isVisible()
    }
}
// 提醒弹窗工具
var RemindTipUtils = {
    showRemindTip : function(tipInfo){
         // 注意：此处不能使用同步发送方式！！
         window.Electron.ipcRenderer.send('plugin-remind-show', tipInfo);
    }
};

// 判断当前窗口是否获取焦点，返回true标识获得焦点，否则返回false
function isCurrentWindowFocused() {
	var _curWin = window.Electron.currentWindow;
    return _curWin.isFocused() && !_curWin.isMinimized();
}

//图片全屏预览
var ImageReviewForPc = {
    // 预览图片。imgIndex：第一个图片的下标。imgSrcArray：图片src数组。
    show : function(imgIndex, imgSrcArray){
        window.Electron.ipcRenderer.send('plugin-imageView-show', { imgIndex: imgIndex, imgSrcArray: imgSrcArray });
    },
    // 关闭预览窗口
    close: function(){
        window.Electron.ipcRenderer.send('plugin-imageView-close');
        if(IMUtil.hasTopDialog()){
			IMCarousel.initImgScanner(false,null,null,null,$(top.document));
		}
    }
};

// 监测服务器是否异常并重连
var ServerExceptionHandling = {
	// 配置参数
    option : {
        commonMonitoringTime : 1000 * 60 * 3,  // 3分钟钟发送一次请求进行监测
        reLinkTime : 1000 * 30, // 断线后，系统30秒钟进行一次重连
        serverPage : window.Electron.ipcRenderer.sendSync('global-getHost') + '/social/im/ServerStatus.jsp'
    },
	
    start : function(){
        var _this = this;
        if(false){
            //_this._initMonitoring();//私有云取消监听
        }
        $(document)
            .ajaxSuccess(function(evt, request, settings){
                //过滤获取token的请求和检查服务端异常的请求。
				if(settings.url.indexOf('/social/im/ServerStatus.jsp?from=pc&p=n')==0||settings.url.indexOf("/social/im/SocialIMOperation.jsp?operation=getTokenOfOpenfire")==0){
                    return;
                }
                if(!NetworkListenerUtils._isScanUseful){
                     NetworkListenerUtils._noScanHost(true);
                 }
                _this._handleSuccess(request.responseText);
            })
            .ajaxError(function(event, XMLHttpRequest, ajaxOptions, thrownError){
                // _this._handleError();//服务端异常弹窗
                //私有云进行服务端判断
                if(ajaxOptions.url.indexOf('/social/im/ServerStatus.jsp?from=pc&p=n')==0||ajaxOptions.url.indexOf("/social/im/SocialIMOperation.jsp?operation=getTokenOfOpenfire")==0){
                    return;
                }
                //检查网络出问题了,进入oa端口检查 
                if(!NetworkListenerUtils._isScanUseful){//如果没有net扫描就进入收动
                    NetworkListenerUtils._noScanHost(false);
                }
            	console.info(thrownError);
            });
    },
    
    _hasHandWorked : false,  //是否触发了手工重连
    handworkRelink : function(){
        var _this = this;
        _this._hasHandWorked = true;
        ReconAnimationUtils.updateRelinkInfo(2, '正在尝试建立连接...');
        $.ajax({
            url: _this.option.serverPage + '?p=e&d=' + new Date().getTime(),
            success: function(data){
                _this._handleSuccess(data);
            },
            error: function(XMLHttpRequest, textStatus, errorThrown){
                ReconAnimationUtils.updateRelinkInfo(3, '与服务器连接故障，请稍候重试');
                // 与oa服务器断开后，和消息服务器必须也断开
                if(client) {
                	M_ISFORCEONLINE = true;
            		//client.disconnect();
                }
            }
        });
    },
    // 设置定时监测
    _isErroring : false,  //是否检测到服务器故障
    _monitoringHandle : null,  //监测服务器状态定时器
    _initMonitoring : function(){
        var _this = this;
        if(!_this._isErroring) {
            clearInterval(_this._monitoringHandle);
            _this._monitoringHandle =null;
            _this._monitoringHandle = setInterval(function(){
                if(!_this._isErroring){                    
                    _this._exeAjax();
                }
               console.log('检查服务器状态 ' + new Date());
            }, _this.option.commonMonitoringTime);
        }
    },

    _reLinking : false,  //是否正在重连
    _reLinkHandle : null,  //正在重连定时器
    _sysRelinkMsgShowHandle : null,  //系统重连时提醒信息更新定时器
    _initReLink : function(){
        var _this = this;
        _this._reLinking = true;
        clearTimeout(_this._reLinkHandle);
        _this._reLinkHandle = setTimeout(function(){
            _this._exeAjax(); //第一次先执行一次
            _this._reLinkHandle = setTimeout(arguments.callee, _this.option.reLinkTime);
        }, _this.option.reLinkTime);
    },
    
    // 设置系统重连时信息展示
    _setSysRelinkMsgShowHandle : function(){
        var _this = this;
        var time = 30;
        var count = 1;
        ReconAnimationUtils.updateRelinkInfo(0, '与服务器连接中断<br/><span>' + time + '</span>秒之后进行第<span>1</span>次连接');
        time--;
        _this._sysRelinkMsgShowHandle = setInterval(function(){
            if(!_this._hasHandWorked) {
                var mm = time;
                if(time < 10) {
                    mm = '0' + time
                }
                var msg = '与服务器连接中断<br/><span>' + mm + '</span>秒之后进行第<span>' + count + '</span>次连接';
                ReconAnimationUtils.updateRelinkInfo(0, msg);                
                time--;
                if(time == 0) {
                    time = 30;
                    count++;
                }
            }
        }, 1000);
    },
    _clearSysRelinkMsgShowHandle : function(){
        clearInterval(this._sysRelinkMsgShowHandle);
        this._sysRelinkMsgShowHandle = null;
    },

    // 执行服务器状态监测或重连
    _exeAjax : function(){
        var _this = this;
        var serverUrl = _this.option.serverPage + '?d=' + new Date().getTime()+"&from=pc";
        serverUrl += _this._isErroring ? '&p=e' : '&p=n';
        $.ajax({
            url: serverUrl,
            success: function(data){
                _this._handleSuccess(data);
            },
            error: function(XMLHttpRequest, textStatus, errorThrown){
               //  _this._handleError();
            	console.info(thrownError);
            }
        });
    },
    // 通用ajax重连成功处理
    _handleSuccess : function(data){
        var _this = this;
        // 其他客户端上线，提示退出
        try {
            data = $.trim(data);
        } catch (error) {
            
        }
        if(!_this._isErroring && data == 'RepeatLanding') {
            _this._isErroring = true;
            M_ISFORCEONLINE = true;
            DragUtils.closeDrags();
            window.Electron.currentWindow.show();
            if(WindowDepartUtil.isAllowWinDepart()){
                WindowDepartUtil.showNewClientComfirm('信息确认','用户在其他地方登陆，点击重连重新登录',function(){
                    $.ajax({
                        global : false,
                        async : false,
                        url : _this.option.serverPage + '?d=' + new Date().getTime(),
                        data : {
                            from: 'pc',
                            sessionkey : window.Electron.ipcRenderer.sendSync('global-getSessionKey'),
                            pcReLogin : 'true',//重新登录
                            userid : M_USERID
                        },
                        success : function(data){
                            M_ISFORCEONLINE = false;
                            M_SERVERSTATUS = false;
                            client && client.reconnect(
                                function(isSuc){
                                    if(isSuc&&IS_BASE_ON_OPENFIRE) OpenFireConnectUtil._updateConverTimeAndMessage();
                                }
                            );
                            DragUtils.restoreDrags();
                            _this._isErroring = false;
                        },
                        error : function(){
                            Dialog.alert('重连失败，服务器异常，请重新登录', function(){
                                PcMainUtils.logout();
                            });
                        }
                    });
                }, function(){
                    PcMainUtils.quitApp();
                },false,true);
            }else{
	            Dialog.confirm('用户在其他地方登陆，点击重连重新登录', function(){
	                $.ajax({
	                    global : false,
	                    async : false,
	                    url : _this.option.serverPage + '?d=' + new Date().getTime(),
	                    data : {
	                        from: 'pc',
	                        sessionkey : window.Electron.ipcRenderer.sendSync('global-getSessionKey'),
	                        pcReLogin : 'true',//重新登录
	                        userid : M_USERID
	                    },
	                    success : function(data){
	                        M_ISFORCEONLINE = false;
	                        M_SERVERSTATUS = false;
	                        client && client.reconnect(
	                            function(isSuc){
	                                if(isSuc&&IS_BASE_ON_OPENFIRE) OpenFireConnectUtil._updateConverTimeAndMessage();
	                            }
	                        );
	                        DragUtils.restoreDrags();
	                        _this._isErroring = false;
	                    },
	                    error : function(){
	                        Dialog.alert('重连失败，服务器异常，请重新登录', function(){
	                            PcMainUtils.logout();
	                        });
	                    }
	                });
	            }, function(){
	                PcMainUtils.quitApp();
	            }, null, null, true, null, social_i18n('Reconnect'), social_i18n('Quit'));
            }
        }
         else if(!_this._isErroring && data == 'reConnectError') {
            _this._isErroring = true;
            DragUtils.closeDrags();
            Dialog.alert('服务端重连异常，点击确定退出', function(){
                PcMainUtils.quitApp();
            });
        }
        else if(_this._reLinking && _this._isErroring) {
            // 取消重连
            clearInterval(_this._reLinkHandle);
            _this._reLinking = false;
            _this._reLinkHandle = null;            
            // 恢复状态
            _this._clearSysRelinkMsgShowHandle();
            _this._hasHandWorked = false;

            // 恢复监测
            _this._isErroring = false;            
            TrayUtils.restoreTray();
            // 关闭遮罩提示  TODO
            ReconAnimationUtils.close();
            
            // 恢复和融云的连接
            M_ISFORCEONLINE = false;
            client && client.reconnect();
            
            window.Electron.currentWindow.flashFrame(true);
        }
    },
    
    // 通用ajax错误处理
    _handleError : function(){
        var _this = this;
        if(!_this._isErroring && !_this._reLinking) {
            // 关闭监测
            _this._isErroring = true;
            TrayUtils.offlineTray();
            // 打开遮罩提示  TODO
            ReconAnimationUtils.showRelink();
            // 设置信息提醒
            _this._setSysRelinkMsgShowHandle();
            
            // 开始重连
            _this._initReLink();            
            // 关闭和融云的连接
            M_ISFORCEONLINE = true;
            // client && client.disconnect();
            window.Electron.currentWindow.flashFrame(true);
        }
    }
};

// 断线展示效果工具
var ReconAnimationUtils = {
    _config : {
        type_1 : '/offline-1.png',  //系统重连时图片
        type_2 : '/offline-2.png',  //手工重连中图片
        type_3 : '/offline-3.png',  //手工重连失败时图片
        type_1_data: '',
        type_2_data: '',
        type_3_data: ''
    },

    // 打开重连界面效果
    showRelink : function(reLinkcb){
        var html = '<div class="pc-recon can-drag">';
           html += '    <div class="pc-recon-message no-drag">';
           html += '        <div class="header">'+social_i18n('RelinkErr')+'</div>';
           html += '        <div class="center">';
           html += '            <div class="center-img"><img src="" /></div>';
           html += '            <div class="center-msg"></div>';
           html += '        </div>';
           html += '         <div class="footer">';
           html += '            <input type="button" class="task-relink" value="'+social_i18n('Reconnect')+'" />';
           html += '            <input type="button" class="task-close" value="'+social_i18n('Quit')+'" />';
           html += '        </div>';
           html += '    </div>';
           html += '</div>';
        $('body').append(html);
        $('.pc-recon').css('width', documentUtils.width()).css('height', documentUtils.height());
        $('.task-relink').click(function(){
            if(typeof reLinkcb ==="function"){
                reLinkcb();
            }else{
                 ServerExceptionHandling.handworkRelink();
            }
        });
        $('.task-close').click(function(){
            PcMainUtils.quitApp();
        });        
        this._config.type_1_data = LocalImagesUtils.getDataUrl(this._config.type_1);
        this._config.type_2_data = LocalImagesUtils.getDataUrl(this._config.type_2);
        this._config.type_3_data = LocalImagesUtils.getDataUrl(this._config.type_3);
        
        $('.pc-recon').fadeIn(500);
    },
    // 更新中部文字提示内容
    updateRelinkInfo : function(type, msg){
        var _this = this;
        if(type == 0) {
            $('.center-img').find('img').attr('src', _this._config.type_1_data);
        } else if(type ==1){
            $('.center-img').find('img').attr('src', _this._config.type_3_data);
            _this._setTaskRelinkStatus(false);
        }else if(type == 2) {
            $('.center-img').find('img').attr('src', _this._config.type_2_data);
            $('.center-msg').addClass('center-msg-hand');
            _this._setTaskRelinkStatus(false);
        } else if(type == 3) {
            $('.center-img').find('img').attr('src', _this._config.type_3_data);
            $('.center-msg').addClass('center-msg-hand');
             _this._setTaskRelinkStatus(true);
        }        
        $('.center-msg').html(msg);
    },
    // 关闭重连
    close: function(){
        $('.pc-recon').fadeOut(1000, function(){
            $(this).remove();
        });
    },
    // 设置重试按钮的可操作状态
    _setTaskRelinkStatus : function(flag){
        var $taskBtn = $('.task-relink');
        if(flag) {
            $taskBtn.removeClass('pc-disabled').removeAttr('disabled');
        } else {
            $taskBtn.addClass('pc-disabled').attr('disabled', 'disabled');;
        }
    }
};

// 获得本地图片的工具类
var LocalImagesUtils = {
    // imgFile为本地应用defaul_app/web_contents/images路径下的文件路径,
    // 如传入'/head.png'，则是获取 defaul_app/web_contents/images/head.png的base64编码数据。
    getDataUrl : function(imgFile){
         var localImagesDir = window.Electron.ipcRenderer.sendSync('global-getImagesDir');
         var nativeImage = window.Electron.remote.nativeImage;
         return nativeImage.createFromPath(localImagesDir + imgFile).toDataURL();
    }
};

// 外部链接：首页、邮件、博客等的打开（调用本地浏览器打开url）
var PcExternalUtils = {
    // urlType :连接类型
    //0 站内链接（拼oa地址）；1 站外链接（无需拼接）；2 单点登录（暂时不管）
    openUrlByLocalApp : function(url, urlType){		
        if(!url) return;
		if(url.indexOf('/rdeploy/chatproject/doc/index.jsp') >= 0){
			
			var _guid = window.Electron.ipcRenderer.sendSync('global-getUserConifg').guid;
			
			window.Electron.ipcRenderer.send('plugin-netWorkDisk-show',url+"&guid="+_guid);
			return;
		}
		// || url.indexOf('/docs/docs/DocDsp.jsp?id=') >= 0
		if(url.indexOf('/rdeploy/chatproject/doc/imageFileView.jsp?fileid=')>=0 ){
			window.Electron.ipcRenderer.send('plugin-imgTextView-show',url);
			return;
		}
        if(typeof urlType ==="string" && urlType.indexOf("_")!=-1){
            var pushuserid = urlType.substring(0,urlType.indexOf("_"));
            urlType = 0;
        }
        urlType = urlType || 0;
        var finalUrl = null;
        var querystring = window.Electron.require('querystring');
        var host = window.Electron.ipcRenderer.sendSync('global-getHost');
        var sessionkey = window.Electron.ipcRenderer.sendSync('global-getSessionKey');
        if(urlType == 0) {
            finalUrl = host + '/social/im/epcforword.jsp?';
            finalUrl += 'from=pc&external=true&sessionkey=' + sessionkey;
            finalUrl += '&language='+languageid;
            if(typeof pushuserid !=="undefined"){
                finalUrl+="&pushuserid="+pushuserid;
            }
            finalUrl += '&url=' + querystring.escape(url);
        }
        else if(urlType == 1) {
			var strRegex  = /^((svn)?:\/\/)/;
            if(strRegex.test(url)) {
               finalUrl = url.replace(strRegex,"http://");
            } else {
                finalUrl = url;
            }
			if(finalUrl.indexOf(":")==-1||finalUrl.indexOf(":")>5){
				finalUrl = "http://" +finalUrl;
			}
        } 
        else if(urlType == 2) {
        	/*
            finalUrl = host + '/interface/Entrance.jsp?';
            finalUrl += 'id=' + querystring.escape(url);
            */
        	var newurl = '/interface/Entrance.jsp?id=' + querystring.escape(url)
            finalUrl = host + '/social/im/epcforword.jsp?';
			finalUrl += 'from=pc&external=true&sessionkey=' + sessionkey;
            finalUrl += '&url=' + querystring.escape(newurl);
        }
        if(finalUrl) {
            if(urlType != 1) {
                ServerExceptionHandling._exeAjax();  //如果是打开内部链接，先发送服务器执行一次更新事件
            }
            setTimeout(function(){
                var shell = window.Electron.remote.shell;
                if(finalUrl.indexOf("http")!=-1||finalUrl.indexOf("https")!=-1){
	                var ca = finalUrl.charAt(finalUrl.length - 1);
	                //修复某些环境的客户端崩溃问题，打开的网址如果没有参数就会解析不了导致崩溃
	                if(ca!="/"&&ca!="#"){
	                    var da = new Date().getTime();
	                    if(finalUrl.indexOf("=")!=-1){
	                        finalUrl = finalUrl + "&d=" +da;
	                    }else{
	                        if(finalUrl.indexOf("#")==-1){
	                            finalUrl = finalUrl + "?d=" +da;
	                        }
	                    }
                    }
                }
                shell.openExternal(finalUrl);
            }, 200);
        }
    }
};

// 主聊天窗口任务栏进度展示工具
var ProgressBarUtils = {
    _currentWin : window.Electron.currentWindow,
    setPb : function(pb){
        if(PcMainUtils.isWindows()){
            this._currentWin.setProgressBar(pb);
        }
    },
    endPb : function(){
        if(PcMainUtils.isWindows()){
            var _this = this;
            _this._currentWin.setProgressBar(1.0);
            setTimeout(function(){
                _this._currentWin.setProgressBar(-1);
            }, 500);
        }
    },
    setToIndeterminateMode : function(){
        if(PcMainUtils.isWindows()){
            this._currentWin.setProgressBar(1.1);
        }
    },
    setToNomal : function(){
        if(PcMainUtils.isWindows()){
            this._currentWin.setProgressBar(-1);
        }
    }
};

// 显示一个windows tray ballon提示
function showTrayBallon(title, content) {
    if(PcMainUtils.isWindows()) {
        window.Electron.ipcRenderer.send('tray-balloon-show', { title: title, content: content});
    }
}

// PC下载工具
var PcDownloadUtils = {
    // 启动下载监听
    initDownload : function(){
        var _this = this;
        console.log('注册下载监听');
        window.Electron.ipcRenderer.on('create-new-download', function(event, args){
            if(_this.eDownloadList[args.url]) {
                return;
            }
            _this.startDownload(args);
        });
    },

    eDownloadList : {},  // 正在下载的文件
    eDownload : window.Electron.require('ding-download').Download,
    imDownloader: null,
    // 开始一个下载任务
    startDownload : function(config){
        console.log('启动一个新下载');
        var _this = this;
        try {
            var dlUrl = config.url;
            console.log('dlUrl = ' + dlUrl);
            var filename = config.filename;
            var filePath = config.filePath;
            var querystring = window.Electron.require('querystring');
            var fileid = querystring.parse(dlUrl.substring(dlUrl.indexOf('?') + 1))['fileid'];
            var item = config.item;
            var fileSize = (item&&item.totalbytes)||0;
            showTrayBallon(social_i18n('Dltip6')+'...', filePath);
            
            //console.log('url = ' + dlUrl);
            //console.log('filePath = ' + filePath);
            var sessionkey = window.Electron.ipcRenderer.sendSync('global-getSessionKey');
            var finalUrl =  dlUrl + '&from=pc&op=download&sessionkey=' + sessionkey;
            
            
            var newDlObj = null;
            try{
            	if(!_this.imDownloader) {
            		_this.imDownloader = window.Electron.require('downloader'); 
            	}
            	newDlObj = new _this.imDownloader();
            }catch(e){
            	newDlObj = null;
            	console.error(e);
            }
            /*Downder test begin*/
            if(newDlObj) {
            	 newDlObj.on('done', function(msg, status) {
					console.log('done===========',msg);
					FileDownloadViewUtils.setButton(fileid, filePath,fileSize);
	                _this._endDownload(dlUrl, filePath);
	                FileDownloadViewUtils.updateViewProgressBar(fileid, 1);
	                if(status === 'ABORTED') {
	                	showTrayBallon(social_i18n('Dltip9'), filePath);
	                	FileDownloadViewUtils.updateViewProgressBar(fileid, -1);
		                FileDownloadViewUtils.restoreButton(fileid);
	                } else {
	                	showTrayBallon(social_i18n('Dltip7'), filePath);
		                // 保存路径到服务端
		                _this.recordLastsavepath(fileid, filePath);
	                }
				});
				
				newDlObj.on('error', function(error) {
					console.log('error===========',error);
					if(error && error.code == 'EPERM'){
	                	alert(social_i18n('Dltip11'));
	                	_this._endDownload(dlUrl, filePath);
	                	_this.willdownload(item, false, true);
	                }else{
	                	_this._endDownload(dlUrl, filePath);
		                showTrayBallon(social_i18n('Dltip8'), filePath);
		                FileDownloadViewUtils.updateViewProgressBar(fileid, -1);
		                FileDownloadViewUtils.restoreButton(fileid);
	                }
				});
				
				newDlObj.on('progress', function(percent, currentsize, totalsize) {
					console.log('progress============'+percent+'  '+currentsize+'   '+totalsize);
					ProgressBarUtils.setPb(percent);
	                FileDownloadViewUtils.updateViewProgressBar(fileid, percent);
				});
	            
				newDlObj.download(finalUrl, filePath, fileSize);
            }
            /*Downder test end*/
            else {
	            newDlObj = new _this.eDownload(finalUrl, filePath);
	            newDlObj.contentSize = parseInt(_this._getfileSize(fileid));
	            
	            newDlObj.on('info', function(arg1){
	                //console.debug('fileid = ' + fileid + '   info = ' + arg1);
	                if(arg1==='req timeout'){
                        newDlObj.emit('error','req timeout');
                    }
	                ProgressBarUtils.setToIndeterminateMode();
	            });
	            newDlObj.on('progress', function(arg1, arg2, arg3){
	                console.log('progress = ' + arg1 + '   ' + arg2 + '  ' + arg3);
	                ProgressBarUtils.setPb(arg1);
	                FileDownloadViewUtils.updateViewProgressBar(fileid, arg1);
	            });
	            newDlObj.on('finish', function(arg1, arg2, arg3){
	                //console.debug('fileid = ' + fileid + '    finish');
	                FileDownloadViewUtils.setButton(fileid, filePath, fileSize);
	                _this._endDownload(dlUrl, filePath);
	                showTrayBallon(social_i18n('Dltip7'), filePath);
	                // 保存路径到服务端
	                _this.recordLastsavepath(fileid, filePath);
	            });
	            newDlObj.on('error', function(error){
	                //console.debug('fileid = ' + fileid + '    error');
	                console.info(error);
	                // error 
	                if(error && error.code == 'EPERM'){
	                	alert(social_i18n('Dltip11'));
	                	_this._endDownload(dlUrl, filePath);
	                	_this.willdownload(item, false, true);
	                }else{
	                	_this._endDownload(dlUrl, filePath);
	                	// user aborted
	                	if(error && error.code == 100010) {
	                		showTrayBallon(social_i18n('Dltip9'), filePath);
	                		FileDownloadViewUtils.restoreButtonWithoutbinding(fileid);
	                	} else {
	                		showTrayBallon(social_i18n('Dltip8'), filePath);
	                		FileDownloadViewUtils.restoreButton(fileid);
	                	}
		                FileDownloadViewUtils.updateViewProgressBar(fileid, -1);
	                }
	            });
	            
            }
             _this.eDownloadList[dlUrl] = { fileid: fileid, dlObj : newDlObj };
        } catch(e){
            console.log(e);
            _this._endDownload(config.url, filePath);
            alert(social_i18n('Dltip10'));
        }
    },
    // 取消所有下载
    abortAllDl : function(){
        var _this = this;
        for(var p in _this.eDownloadList) {
            _this.eDownloadList[p].dlObj.abort();
        }
    },
    // 结束下载
    _endDownload : function(dlUrl, filePath){
        this._sendDlComplete(dlUrl);
        delete this.eDownloadList[dlUrl];
        delete this.DownloadItems[dlUrl];
        delete this.DownloadFileNames[filePath];
        ProgressBarUtils.endPb();
    },
    // 获取文件大小
    _getfileSize : function(fileid){
        var fileSize = $('div.accitem[_fileid="' + fileid + '"]').attr('_filesize');
        if(typeof fileSize == 'undefined') {
            $.ajax({
                gloab: false,
                async: false,
                url : '/social/im/SocialImPcUtils.jsp',
                data : {
                    method : 'getFileSize',
                    fileid : fileid
                },
                success : function(data){
                    data = $.trim(data);
                    fileSize = parseInt(data);
                },
                error : function(){
                    fileSize = 0;
                }
            });
        }
        return fileSize;
    },
    
    _sendDlComplete : function(dlUrl){
        window.Electron.ipcRenderer.send('download-complete', dlUrl);
    },
    // 记录下载路径
    recordLastsavepath: function(fileId, filePath){
    	//return;
    	 $.post('/social/im/SocialImPcUtils.jsp', { method : 'recordLastsavepath', fileid: fileId, filepath: filePath }, function(data){
    	 	DownloadSet[fileId] = filePath;
    	 	console.log("add a download set:"+$.trim(data));
    	 });
    },
    DownloadItems: {},
    // 缓存文件名
    DownloadFileNames: {},
    // 获取新文件名
    getNewFileName: function(filename){
    	var index = filename.lastIndexOf('.');
		var name = index != -1? filename.substring(0, index):filename;
		var ext = index != -1?filename.substring(index + 1):"";
		return name + "(1)." + ext;
    },
    // 状态
    StateString: {
    	'normal': 'Receive',
    	'resume': 'Resume',
    	'pause': 'Pause',
    	'abort': 'Cancel'
    },
    // 设置下载状态
    setState: function(fileid, state, context) {
    	var _self = this;
    	var url = _self.getUrlByFileId(fileid);
    	_self.DownloadItems[url] = state;
    	var $fileDiv = $('div.accitem[_fileid="' + fileid + '"]', context || document);
    	$fileDiv.find('.opfile').text( social_i18n(_self.StateString[state]) ).attr('state', state);
    },
    // 根据fileid获取url
    getUrlByFileId: function(fileid, context) {
    	context = context || window.self;
    	return context.PcMainUtils.userInfos.currentHost + "/weaver/weaver.file.FileDownload?fileid="+fileid+"&download=1";
    },
    // 初始化下载设置
    willdownload: function(item, isDefPath, isResetPath){
    	var mainWindow =window.Electron.currentWindow;
    	var ipcMain = window.Electron.ipcRenderer;
    	var downloadConfig = PcSysSettingUtils.getConfig().download;
    	var DownloadItems = this.DownloadItems;
    	var DownloadFileNames = this.DownloadFileNames;
    	var platform = PcMainUtils.platform;
    	var dialog = window.Electron.remote.dialog;
    	var path = require('path');
    	var _self = this;
    	
    	console.log('a new download event');
		event && event.preventDefault();
		
		var url = item.url;
		var filename = item.filename;
		var fileSize = item.totalbytes;
		var fileid = item.fileid;
		
		var state = DownloadItems[url]; 
		if (state === 'abort') {
			try{
				// _self.imDownloader.pause();
				_self.eDownloadList[url].dlObj.abort();
				_self.setState(fileid, 'normal');
			}catch(e){
				console.log("取消失败");
				FileDownloadViewUtils.updateViewProgressBar(fileid, -1);
                FileDownloadViewUtils.restoreButton(fileid);
                PcDownloadUtils.setState(fileid, 'normal');
			}
			return;
		}
		
		// 并没有走progress，卡住了，打开网页下载
		if	(state === 'normal') {
			try{
				PcExternalUtils.openUrlByLocalApp(url, 0);
			}catch(e) {
				console.log("打开网页下载失败");
			}
			return;
		}
		
		var defaultDlPath = downloadConfig.defaultPath, nonePath = false;

		if(!defaultDlPath || defaultDlPath == ''){
			// 路径为空时，走else代码逻辑，并在点击确定时提示是否设置当前目录为默认下载目录
			nonePath = true;
		}

		if(isDefPath && !nonePath && !isResetPath) {
			// 如果配置了默认保存路径，那么不弹出保存对话框，直接保存文件到默认路径。
			var fse = require('fs-extra');
			fse.ensureDir(defaultDlPath, function(err){
				if(err){
					console.error("当前默认路径已失效且没有创建文件夹权限，请重新设置默认文件传输路径", err)
					_self.willdownload(item, isDefPath, true);
					return true;
				}
				var dlObj = {
					url : url,
					filePath : path.join(defaultDlPath, filename),
					item: item
				};
				
				// 有个相同文件名的文件正在下载
				if(DownloadFileNames[dlObj.filePath]) {
					dialog.showMessageBox(mainWindow, {
						type: 'info',
						title : social_i18n('Info'),
						message : social_i18n('Dltip3'),
						buttons : []
					});
					return;
					// dlObj.filePath = path.join(defaultDlPath, _self.getNewFileName(filename));
				}
				// 检测文件是否存在
				PcMainUtils.isExistFile( dlObj.filePath,  function(flag){
					if(flag){
						dialog.showMessageBox(mainWindow, {
							type: 'info',
							title : social_i18n('Info'),
							message : social_i18n('Dltip4'),
							buttons : [social_i18n('Yes'),social_i18n('No')],
							defaultId: 0,
							cancelId: 1
						},function(response){
							if(response == 0) {
								mainWindow.webContents.send('create-new-download', dlObj);
								DownloadItems[url] = "normal";
								DownloadFileNames[dlObj.filePath] = true;
							}	
						});
					}else{
						mainWindow.webContents.send('create-new-download', dlObj);
						DownloadItems[url] = "normal";
						DownloadFileNames[dlObj.filePath] = true;
					}
				});
				
			});
		} else{
			var index = filename.lastIndexOf('.');
			var name = platform.Windows ? filename.substring(0, index) : filename;
			var ext = filename.substring(index + 1);
			dialog.showSaveDialog(mainWindow, {
				title: social_i18n('SaveAs'),
				defaultPath: filename,
				filters: [
					{ name: '文件类型', extensions: [ ext ] },
					{ name: 'All Files', extensions: ['*'] }
				]
			}, function(filepn){
				if(filepn) {
					var dlObj = {
						url : url,
						filePath : filepn,
						ext : ext,
						item: item
					};
	
					if(nonePath || isResetPath){
						dialog.showMessageBox(mainWindow, {
							type: 'info',
							title : social_i18n('Info'),
							message : social_i18n('Dltip5'),
							buttons : [social_i18n('Yes'),social_i18n('No')],
							defaultId: 0
						},function(response){
							if(response == 0) {
								// TODO 这里更新个人设置
								var defaultPath = path.dirname(filepn);
								console.log('userConfig updating..:'+defaultPath);
								downloadConfig.defaultPath = defaultPath;
								PcSysSettingUtils._configs.download.defaultPath = defaultPath;
								PcSysSettingUtils.saveConfig(PcSysSettingUtils._configs);
							}	
	
						});
					}
					
					// 有个相同文件名的文件正在下载
					if(DownloadFileNames[dlObj.filePath+(dlObj.ext?("."+dlObj.ext):"")]) {
						dialog.showMessageBox(mainWindow, {
							type: 'info',
							title : social_i18n('Info'),
							message : social_i18n('Dltip3'),
							buttons : []
						});
						return;
						// dlObj.filePath = _self.getNewFileName(filename);
					}
	
					mainWindow.webContents.send('create-new-download', dlObj);
					DownloadItems[url] = "normal";
					DownloadFileNames[dlObj.filePath] = true;
				}
			});
		}
    }
};

// 下载文件时 进度条 及 按钮设置
var FileDownloadViewUtils = {
    // 更新下载进度条
    updateViewProgressBar : function(fileid, progress, context){
    	var _this = this;
        var $fileDiv = $('div.accitem[_fileid="' + fileid + '"]', context || document);
        if($fileDiv.length > 0) {
            var $pcFileDlBar = $fileDiv.find('.pc-fileDlBar');
            if($pcFileDlBar.length > 0) {
                var $barDiv = $pcFileDlBar.find('.progress-bar');
                 if (progress == 1) {
                    setTimeout(function(){
                        $pcFileDlBar.hide();
                        $barDiv.width('0%');
                    }, 300);
                } else if(progress == -1) {
                    $pcFileDlBar.hide();
                    $barDiv.width('0%');
                } else {
                    $pcFileDlBar.show();
                    var pro = progress.toFixed(2) * 100 + '%';
                    $barDiv.width(pro);
                    // 设置取消状态
                    PcDownloadUtils.setState(fileid, 'abort');
                }
            }
        }
        // 处理消息记录里的消息
        if(!context && context != document) {
        	try{
        		_this.updateViewProgressBar(fileid, progress, top.topWin.Dialog._Array[0].innerFrame.contentWindow.document || document);
        	}catch(e){
            }
        }
    },
    setButtonCon: function(container,fileid,filepath,filesize){
    	var _this = this;
    	var $fileBtn = container.hasClass("opdiv")? container: container.find('a.opdiv[_fileid="' + fileid + '"]');
    	var filename = $fileBtn.attr('_filename');
        var optiondiv = $fileBtn.parent();
        var openStr = social_i18n('Open');
        var dirStr = social_i18n('Folder');
        var fileStr = social_i18n('File');
        var opendir = $("<a>"+openStr+"" +dirStr+"</a>");
        var openfile = $("<a>"+openStr+"" +fileStr+"</a>");
        
        opendir.attr(
        	{
        		'id': 'pc-opendir' + fileid, 
        		'class': 'opdir opdiv',
        		'_fileid':fileid,
        		'_filename':filename,
        		'_filesize':filesize?filesize:0
        	}).css({'cursor':'pointer', 'marginLeft':'10px'}).click(function(){
                _this.openFilepath(fileid, filepath, 0);
            });
            
        openfile.attr(
        	{
        		'id': 'pc-openfile' + fileid, 
        		'class': 'opfile opdiv pc-openfile', 
        		'_fileid': fileid,
        		'_filename': filename,
        		'_filesize':filesize?filesize:0
        	}).css('cursor','pointer').click(function(){
                _this.openFilepath(fileid, filepath, 1);
            });
        optiondiv.empty().append(openfile).append(opendir);
        return container;
    },
    // 下载完成，设置'下载'按钮为'打开文件'和'打开文件夹'
    setButton : function(fileid, filepath,filesize, context){
        var _this = this;
        var $fileBtn = $('a.opdiv[_fileid="' + fileid + '"]', context || document);
        if($fileBtn.length > 0) {
       		_this.setButtonCon($fileBtn, fileid, filepath, filesize);
        }
        
        // 消息记录窗口消息处理
        if(!context && context != document) {
        	try{
        		_this.setButton(fileid, filepath, filesize,  top.topWin.Dialog._Array[0].innerFrame.contentWindow.document || document);
        	}catch(e){
        	}
        }
    },
    // '打开文件'，'打开文件夹'按钮事件
    openFilepath : function(fileid, filepath, openFile){
        var _this = this;
        const fs = window.Electron.require('fs');
        fs.exists(filepath, function (exists) {
        	const shell = window.Electron.remote.shell;
            if(exists) {
                if(openFile) {
                    shell.openItem(filepath);
                } else {
                    shell.showItemInFolder(filepath);
                }
            } else {
            	if(openFile){
            	     var Alerttext = social_i18n('Dltip1');
            	     if(WindowDepartUtil.isAllowWinDepart()){
            	         //Alerttext += "|normal";
            	     }
            		showImAlert(Alerttext);
            	}else{
            	     var Confirmtext = social_i18n('Dltip1');
                     if(WindowDepartUtil.isAllowWinDepart()){
                         //Confirmtext += "|normal";
                     }
            		showImConfirm(Confirmtext, function(){
            			shell.showItemInFolder(filepath);
            		});
            	}
                _this.restoreButton(fileid);
            }
        });
    },
    // 恢复按钮为‘接收’，并不绑定事件
    restoreButtonWithoutbinding: function(fileid, context) {
    	var _this = this;
        var $fileBtn = $('a.opfile[_fileid="' + fileid + '"]', context || document);
        var $fileDir = $('a.opdir[_fileid="' + fileid + '"]', context || document)
        if($fileBtn.length > 0) {
            $fileBtn.html(social_i18n('Receive'));
        }
        
        if($fileDir.length > 0) {
            $fileDir.html(social_i18n('SaveAs'));
        }
        // 消息记录窗口消息处理
        if(!context && context != document) {
        	try{
        		_this.restoreButton(fileid, top.topWin.Dialog._Array[0].innerFrame.contentWindow.document || document);
        	}catch(e){
        	}
        }
    },
    // 恢复按钮为'下载'
    restoreButton : function(fileid, context){
    	var _this = this;
        var $fileBtn = $('a.opfile[_fileid="' + fileid + '"]', context || document);
        var $fileDir = $('a.opdir[_fileid="' + fileid + '"]', context || document)
        if($fileBtn.length > 0) {
            $fileBtn.unbind('click').click(function(){
                downAccFile(this, true);
            }).html(social_i18n('Receive'));
        }
        
        if($fileDir.length > 0) {
            $fileDir.unbind('click').click(function(){
                downAccFile(this);
            }).html(social_i18n('SaveAs'));
        }
        // 消息记录窗口消息处理
        if(!context && context != document) {
        	try{
        		_this.restoreButton(fileid, top.topWin.Dialog._Array[0].innerFrame.contentWindow.document || document);
        	}catch(e){
        	}
        }
    }
};

RongErrorUtils = {
    isErroring : false,  
    autoReCount : 3,
    autoReHandle : null,
    errorCount:3,//服务都正常，但是就是连接失败的情况
    startRecon : function(){//连接失败就是检查端口
        var _this = this;
        if(!M_ISFORCEONLINE&&!_this.isErroring){
            _this.isErroring=true;
            NetworkListenerUtils._showHandleRelink();
        }      
    },

    reConTimeout : 5,  // 重连间隔，5秒
    reConHandle : null,
    _config : {
        type_1 : '/offline-1.png',  //系统重连时图片
        type_1_data: ''
    },
    // 打开重连界面效果
    showRelink : function(){
        var _this = this;
        var html = '<div class="pc-recon can-drag">';
           html += '    <div class="pc-recon-message no-drag">';
           html += '        <div class="header">'+social_i18n('RelinkErr')+'</div>';
           html += '        <div class="center">';
           html += '            <div class="center-img"><img src="" /></div>';
           html += '            <div class="center-msg">'+social_i18n('RelinkTip')+'<br/><span id="rong-recon-s1">5</span>'+social_i18n('RelinkTip1')+'<span id="rong-recon-s2">1</span>'+social_i18n('RelinkTip2')+'</div>';
           html += '        </div>';
           html += '         <div class="footer">';
           html += '            <input type="button" class="rong-task-close" value="'+social_i18n('Quit')+'" />';
           html += '        </div>';
           html += '    </div>';
           html += '</div>';
        $('body').append(html);
        $('.pc-recon').css('width', documentUtils.width()).css('height', documentUtils.height());
        $('.rong-task-close').click(function(){
            PcMainUtils.quitApp();
        });        
        _this._config.type_1_data = LocalImagesUtils.getDataUrl(this._config.type_1);
        $('.center-img > img').attr('src', this._config.type_1_data);        
        var rtime = _this.reConTimeout;
        var rcount = 1;
        var $rongspn1 = $('#rong-recon-s1');
        var $rongspn2 = $('#rong-recon-s2');
        _this.reConHandle = setInterval(function(){
            $rongspn1.html(--rtime);
            if(rtime == 0) {
                // _this._exeReCon();                
                rtime = _this.reConTimeout;
                $rongspn1.html(rtime);
                $rongspn2.html(++rcount);
            }
        }, 1000);        
        $('.pc-recon').fadeIn(500);
    },
    // 关闭重连
    close: function(){
           // clearInterval(this.autoReHandle);
            //    this.autoReHandle = null;
           clearInterval(this.reConHandle);
            this.reConHandle = null;            
            this.isErroring = false;
			this.errorCount = 3;
            $('.pc-recon').fadeOut(1000, function(){
                $(this).remove();
            });
    },
    _exeReCon : function(){
        try {
            client && client.reconnect();  // 客户端重连
            M_ISRECONNECT = false;  // !!
            console.info('尝试重连。。。');
        } catch(e) {
            console.info('重连错误');
            console.info(e);
        }
    }
};

// 检测服务器版本
var DetectionOfUpgrade = {
    detectionFrequency : 1000 * 60 * 60 * 5,  //5小时检测一次服务器版本
    nowVersion : null,
    isReminding : false,
    execHandle : null,
    
    start : function(){
        console.info('启动服务端版本监测定时器');
        var _this = this;
        _this.nowVersion = PcMainUtils.getVersion();
        if(_this.nowVersion) {
            _this.execHandle = setInterval(function(){
                if(!_this.isReminding) {
                    _this.execDetection();
                }
            }, _this.detectionFrequency);
        } else {
            console.info('检测升级程序异常，未能启动');
        }
    },
    execDetection : function(){
        var _this = this;
        console.info('检测服务端版本');
        $.ajax({
            url : '/social/im/ServerStatus.jsp?p=getVersion',
            dataType : 'json',
            success : function(data){
                console.info(data);
                var flag = true;
                // 只判断内核版本
                flag = data.hasOwnProperty('runtimeVersion') && !!data.runtimeVersion && ( _this.nowVersion.runtimeVersion != data.runtimeVersion);
                if( flag ) {
                    _this.isReminding = true;
                    clearInterval(_this.execHandle);
                    
                    var obj = {
                        currentHost : window.Electron.ipcRenderer.sendSync('global-getHost'),
                        sessionKey : window.Electron.ipcRenderer.sendSync('global-getSessionKey'),
                        newBuildVersion : {
                            buildVersion : data.buildversion,
                            osxBuildVersion : data.osxBuildVersion,
                            runtimeVersion: data.runtimeVersion
                        }
                    };
                    DragUtils.closeDrags();
                    if(WindowDepartUtil.isAllowWinDepart()&&new_win=='right'){
                        WindowDepartUtil.showNewClientAlert('系统提示','检测到有新版本，点击确定进行升级',function(){
                            PcMainUtils.localconfig.setLogoutThenUpgrade(obj, function(){
                                PcMainUtils.logout();
                            });
                        });
                    }else{
	                    Dialog.alert('检测到有新版本，点击确定进行升级', function(){
	                        PcMainUtils.localconfig.setLogoutThenUpgrade(obj, function(){
	                            PcMainUtils.logout();
	                        });
	                    });
                    }
                }
            }
        });
    }
};

// 全局快捷键相关
var GlobalShortMethods = {
	SCREENSHOT : 'screenshot',
    OPENANDHIDEWIN : 'openAndHideWin',
    CLOSEALLCHATWIN: 'closeAllChatWin',
    CLOSECHATWIN: 'closeChatWin'
};
var PcGlobalShortcutUtils = {
    // 初始化
    init : function(){
        var _this = this;
        var userConfig = PcSysSettingUtils.getConfig();
        if(PcMainUtils.isWindows()) {
            if(ClientSet && ClientSet.ifSendPicOrScreenShots == '0') {
                console.log('启用截图');
                var screenshot = userConfig.shortcut.screenshot;
                _this.execRegister(null, screenshot, GlobalShortMethods.SCREENSHOT);
            } else {
                console.log('禁用截图');
            }
            
            pcWindowConfig.shortcut.screenshot = screenshot;
            _this.setScreenshotTitle();
        }
        
        var openAndHideWin = userConfig.shortcut.openAndHideWin;
        _this.execRegister(null, openAndHideWin, GlobalShortMethods.OPENANDHIDEWIN);
        
        var closeAllChatWin = userConfig.shortcut.closeAllChatWin || (PcMainUtils.platform.OSX?'COMMAND+CONTROL+C':'CTRL+ALT+C');
        _this.execRegister(null, closeAllChatWin, GlobalShortMethods.CLOSEALLCHATWIN);
        
        var closeChatWin = userConfig.shortcut.closeChatWin || (PcMainUtils.platform.OSX?'CONTROL+C':'ALT+C');
        _this.execRegister(null, closeChatWin, GlobalShortMethods.CLOSECHATWIN);
    },
    // 是否已被注册
    isRegistered : function(accelerator){
    	return window.Electron.remote.globalShortcut.isRegistered(accelerator);
    },
    // 执行注册，注册成返回true，冲突或失败返回false
    execRegister : function(oldKey, newKey, execMethodName){
        var reObj = {
            oldKey : oldKey || null,
            newKey : newKey || null,
            execMethodName : execMethodName || null
        };
        return window.Electron.ipcRenderer.sendSync('globalshortcut-slave', reObj);
    },
    setScreenshotTitle : function(){
        if (PcMainUtils.isWindows() && pcWindowConfig.shortcut.screenshot) {
            $('[type="screenshot_div"]').attr('title' ,social_i18n('ScreenShot')+'（' + pcWindowConfig.shortcut.screenshot + '）');
        }
    }
};

// 抖动窗口
var ShakeWindowUtils = {
    loginTime : new Date().getTime(),
    lastShakeTime : {},  // 给不同的人抖动要单独计时
    dwellTime : 1000 * 10,  //抖动间隔，10秒钟
    sendShakeMessage : function (obj){
        var _this = this;
        var nowTime = new Date().getTime();
        var $chatWin = ChatUtil.getchatwin(obj);
        var toUserId = $chatWin.attr('_targetid');
        
        if(!_this.lastShakeTime[toUserId] || (nowTime - _this.lastShakeTime[toUserId] > _this.dwellTime)) {
            var msgid = IMUtil.guid();
            var sendTime = new Date().getTime();
            var data = {
                pushType : 'weaver_shakeMsg',
                objectName : 'FW:CustomMsg',
                msgType : 6,
                sendTime : sendTime,
                targetid : toUserId,
                targetType : 'FW:CustomMsg'
            };
            ChatUtil.sendIMMsg($chatWin.find(".chatSend"), data.msgType, data, function(msg) {
                if(msg.issuccess == 1) {
                    _this.lastShakeTime[toUserId] = sendTime;
                    _this.shakeWindow(false);
                    _this._playShakeAudio();
                } else {
                    ChatUtil.postNotice("发送了窗口抖动失败", obj);
                }
            });
        } else {
            IM_Ext.showMsg("抖动过频");
        }
    },
    shakeWindow : function(showWindow, extraObj, senderInfo){
        var win = window.Electron.currentWindow;
        if(showWindow) {
            var pushType = extraObj.pushType;
            if(pushType != 'weaver_shakeMsg') {
                return;
            }
            var sendTime = extraObj.sendTime;
            var senderUserid = senderInfo.userid;
            if(sendTime - this.loginTime < 1000 * 60 * 60 * 24) {
                win.show();
                win.focus();
                if(extraObj.isPrivate !='1'){
                    $('#conversation_' + senderUserid).click();
                };               
            }
        }
        var bounds = win.getBounds();
        var tempBounds = bounds;
        clearInterval(timer);
        var i = 0;
        var timer = setInterval(function() {
            i++;
            tempBounds.x = tempBounds.x + ((i%2)>0?-7:7);
            win.setBounds(tempBounds);
            if(i >= 10) {
                win.setBounds(bounds);
                clearInterval(timer);
            }
        }, 60);
        this._playShakeAudio();
    },
    _playShakeAudio : function() {
        var playAudio = true;
        // pc端，更具配置判断是否有提示音
        var config = PcSysSettingUtils.getConfig();
        if(config.msgAndRemind.audioSet_all) {
            playAudio = false;
        }
        
        if(playAudio) {
        	var audio = document.getElementById('pcShakeWinAudio');
            audio.play();
        }
    }
};

// 用户配置
var PcSysSettingUtils = {
    _configs : null,
    // 初始化配置信息
    init : function(callback){
        var _this = this;
        var localconfig = window.Electron.ipcRenderer.sendSync('global-getUserConifg');
        // 对本地特殊设置的处理
        var autoLogin = localconfig.login.autoLogin;
        $.post('/social/im/SocialImPcUtils.jsp', { method : 'getUserSysConfig', osType : PcMainUtils.getOSType() }, function(data){
            if(data.isSuccess) {
				var _configTemp = window.Electron.ipcRenderer.sendSync('global-getUserConifg');
				var _config = {};
				if(typeof data.config ==='object'){
					_config = data.config;
				}	
                _this._configs = $.extend(_configTemp, _config); 
                // 一些特殊值以客户端为准
                _this._configs.login.autoLogin = localconfig.login.autoLogin;
				_this._configs.guid = localconfig.guid;
				_this._configs.login.language = localconfig.login.language;
            } else {
                _this._configs = localconfig;
            }
            
            // 对3版本未升级到4版本时的特殊处理
            if(!_this._configs.msgAndRemind) {
                _this._configs.msgAndRemind = {newMsg:false, wfRemind:true, mailRemind:true, audioSet:{all:false, persion:false, group:false, broadcast:false}};
            }
            if(!_this._configs.skin) {
                _this._configs.skin = "default";
            }
            
            // 对本地特殊设置的处理
            _this._configs.login.autoLogin = autoLogin;
            //截图最小化设置
			ChatUtil.isScreenShotMinimize = typeof _this._configs.isScreenShotMinimize ==='undefined'?0:_this._configs.isScreenShotMinimize;
			//弹窗时间设置
			_this._configs.msgAndRemind.popWinAutoCloseSec = typeof _this._configs.msgAndRemind.popWinAutoCloseSec ==='undefined'?"180":_this._configs.msgAndRemind.popWinAutoCloseSec;
            //保存配置信息更改
            _this.saveConfig(_this.getConfig());
            
            typeof callback === 'function' && callback(_this._configs);
        }, 'json');
    },
    // 获取当前配置信息
    getConfig : function(callback){
        if(this._configs == null) {
            this.init(function(){
            	if(typeof callback == 'function')
            		callback();
            });
            PcMainUtils.sleep(500);
        }
        return this._configs;
    },
    // 保存配置信息
    saveConfig : function(config, callback){
        var _this = this;
        var cb = typeof callback === 'function' ? callback : function(){};
        //保存到本地
        window.Electron.ipcRenderer.send('global-setUserConifg', {
            config : _this.getConfig(),
            callback : null
        });
        _this._saveConfigToOA(callback); //保存到服务端
        _this._configs = config;
    },
    _saveConfigToOA : function(callback){
        var userConfig = JSON.stringify(this.getConfig());
        $.post('/social/im/SocialImPcUtils.jsp', { method : 'saveUserSysConfig', osType : PcMainUtils.getOSType(), config : userConfig },function(){
        	typeof callback === 'function' && callback();
        });
    }
};

// 新消息到达直接打开窗口
function openWindowWhenNewMsg() {
    var config = PcSysSettingUtils.getConfig();
    if(config.msgAndRemind.newMsg && !isCurrentWindowFocused()) {
        var win = window.Electron.currentWindow;
        win.show();
        win.focus();
    }
}

PcWinSizeUtils = {
    isBase : true,
    // 最小化
    base : function(){
        if(!this.isBase) {
            var win = window.Electron.currentWindow;
            var bounds = win.getBounds();
            win.hide();
            win.setBounds({
                x: bounds.x + 770,
                y: bounds.y,
                width : 280,
                height: bounds.height
            });
            this.isBase = true;
            win.show();
        }
    },
    // 最大化
    all : function(){
        if(this.isBase) {
            var win = window.Electron.currentWindow;
            var bounds = win.getBounds();
            win.hide();
            win.setBounds({
                x: bounds.x - 770,
                y: bounds.y,
                width : bounds.width + 770,
                height: bounds.height
            });
            this.isBase = false;
            win.show();
        }
    }
};
/* 
*网络监测工具
*/
var NetworkListenerUtils ={
    _isScanUseful:false,
    _hostName:window.location.hostname,//oa地址
    _hostPort:window.location.port==""?80:window.location.port,//oa端口
    _hostIsAvailable:true,//oa服务是否开启
    _serverIsAvailable:true,//emessage服务是否开启
    _timeOutFlag:0,//定时器初始化中
    _scanHostCount:3,//检查OA服务三次，可能端口开启，但是服务出现问题，三次检查出问题，直接抛出oa出问题,直接提示退出
    _isScanHosting:false,//是否正在进行端口监测，表示是由于ajax请求失败过来的
    _getTokenCount:3,//获取token的次数，3次没获取到token 说明服务端访问IM服务器出问题,需要检查，或者重启oa
    _init:function(){//端口扫描定时，要还是不要进行端口的定时扫描？只有当服务异常的
        //    var _this = this;
        //     _this._checkScanUseful(); 
        //     NetworkListenerUtils._isScanUseful =true;
            // setInterval(function(){
            //        if(_this._isScanUseful){
            //             var scanInterval = window.Electron.require('net-scan');  
            //             scanInterval.port({
            //                         host: _this._hostName,
            //                         ports: [_this._hostPort],
            //                         timeout: 2000
            //                     },function(err,result){                                   
            //                             if(result.length==1&&!NetworkListenerUtils._isScanHosting){
            //                                     console.log("开始检查oa服务")                                            
            //                                     NetworkListenerUtils._isScanHosting=true; 
            //                                     NetworkListenerUtils._scanHostPort();
            //                             }
            //                         })
            //             }
            // },  1000*60*3);                             
    },
    _checkScanUseful:function(successCb,failCb){
        var _this = this;
       try {
            var _scan = window.Electron.require("net-scan");
            _scan.port({
                 host: _this._hostName,
                 ports: [_this._hostPort],
                 timeout: 2000
            },function(err,result){
                if(result.length==1){
                  _scan.port({
                        host: M_SERVERIP,
                        ports: [M_SERVERPORT],
                        timeout: 2000
                  },function(err,result){
                        if(result.length==1){
                            NetworkListenerUtils._isScanUseful =true;
                            typeof successCb ==="function" && successCb();
                        }
                  });  
                }
            });

       } catch (error) {
             typeof failCb ==="function" && failCb();
       }

    },
    _scanHostPort:function(successCb,failCb){//监测oa服务是否启动 
        var _this = this;
        _this._isScanHosting = true;
        var scan = window.Electron.require('net-scan');
        if(_this._serverIsAvailable){//em正常 重新判断一次，然后在去连接emessage
        scan.port({
                host: _this._hostName,
                ports: [_this._hostPort],
                timeout: 2000
                }, function(err, result) {
                    if(result.length ==1){
                            if(_this._scanHostCount == 3){//oa服务正常启
                                if(!_this._hostIsAvailable){                                    
                                    _this._hostIsonline();
                                }
                                    _this._hostIsAvailable = true;
                                    if(_this._serverIsAvailable){//如果oa恢复正常，重置重连定制器，并进入emessage的服务验证
                                            _this._timeOutFlag= 0;
                                     }
                                NetworkListenerUtils._scanServerPort();             
                                typeof successCb ==='function' && successCb();
                            }else if(_this._scanHostCount>0&&_this._scanHostCount<3){
                                    setTimeout(function() {                    
                                        NetworkListenerUtils._checkHost();
                                    }, 1000*5);
                            }else if(_this._scanHostCount=0){
                                //提示服务异常，以及断开e-message连接,并在30秒后退出E-Message,将服务器中serverstatus.jsp去掉可以把e-message全部踢掉
                                  ReconAnimationUtils.showRelink();
                                  ReconAnimationUtils.updateRelinkInfo(1,"服务异常，请联系管理员！")
                            }                       
                        }else{
                                _this._hostIsAvailable = false;
                                _this._serverIsAvailable = true;
                                _this._scanHostCount = 3;
                                console.log("OA服务异常");
                                NetworkListenerUtils._hostIsoffline();
                                NetworkListenerUtils._hostTimeOut();
                                typeof failCb ==='function' && failCb();
                    } 
                }); 
        }else{
            NetworkListenerUtils._scanServerPort(); 
        }		     
    },
    _scanServerPort:function(successCb,failCb){//监测emessage是否启动
        var _this = this;
        var scan = window.Electron.require('net-scan');        
		scan.port({
			host: M_SERVERIP,
			ports: [M_SERVERPORT],
			timeout: 2000
		}, function(err, result) {
            if(result.length ==1){
               _this._serverIsAvailable = true;
               if(_this._hostIsAvailable){
                   _this._timeOutFlag = 0;
               }
               _this._getToken();
               typeof successCb ==='function' && successCb();
            }else{
                _this._serverIsAvailable = false;
                if(!RongErrorUtils.isErroring){
                        RongErrorUtils.isErroring = true;
                        RongErrorUtils.showRelink();
                }                
                _this._serverTimeOut();//emessage服务未开启就继续去检查
                typeof failCb ==='function' && failCb();
            }
		}); 
    },
    _hostIsoffline:function(){
        TrayUtils.offlineTray("oa离线");
        //showTrayBallon("系统提醒","OA链接已断开");
    },
    _hostIsonline:function(){
        TrayUtils._isOffline = false;
        TrayUtils.restoreTray();
        //showTrayBallon("系统提醒","OA链接已恢复");
    },
    _timeOut:function(cb){//连接定时器时间
        var _this = this;
        var _time =3000;  
        if(++_this._timeOutFlag>4){            
            if(_this._timeOutFlag>15) --this._timeOutFlag;
         _time = _time*_this._timeOutFlag;            
        }
        return _time;
    },
    _hostTimeOut:function(){
        setTimeout(function(){
                    NetworkListenerUtils._scanHostPort();
                 },NetworkListenerUtils._timeOut())
    },
    _serverTimeOut:function(){
          setTimeout(function(){
                    NetworkListenerUtils._scanServerPort();
                 },NetworkListenerUtils._timeOut())
    },
    _checkHost:function(successCb,error){//确定服务是否真的正常，更新在线状态先扫描端口，在发请求
        NetworkListenerUtils._isScanHosting=true;
        $.ajax({
            url: "/social/im/ServerStatus.jsp?from=pc&p=h&",
            success: function(data){
                NetworkListenerUtils._scanHostCount = 3;
                NetworkListenerUtils._isScanHosting = false;
                typeof successCb ==="function" && successCb();
            },
            error: function(XMLHttpRequest, textStatus, errorThrown){
                NetworkListenerUtils._scanHostCount--;
                NetworkListenerUtils._scanHostPort();
                typeof successCb ==="function" && successCb();
            }
        });

    },
    _getToken:function(){
         //端口开启就去获取token 存在问题：一个台电脑断网后，用户在另外一台电脑上用，网络恢复会发生重连，另外一台的电脑上的用户就异地登录
            if(M_TOKEN==""){
                getTokenOfOpenfire(function(data){
                    if(data == ""){
                        if(NetworkListenerUtils._getTokenCount>0){
                                setTimeout(function(){
                                                    NetworkListenerUtils._getTokenCount--;
                                                    NetworkListenerUtils._scanHostPort();
                                                }, 1000*5);
                        }else{
                            //提示错误 oa获取token出问题,需要重启oa，或者检查配置
                           ReconAnimationUtils.showRelink();
                           ReconAnimationUtils.updateRelinkInfo(1,"服务异常，请联系管理员！");
                           setTimeout(function(){//1分钟后退出倒计时，退出emessage
                            NetworkListenerUtils._quitApp();
                            },1000*60);
                        }
                        
                    }else{
                        //初始化重连工具，进行重连e-message服务
                        NetworkListenerUtils._getTokenCount = 3;
                        NetworkListenerUtils._isScanHosting = false;
                        // 恢复连接
                        M_ISFORCEONLINE = false;
                        client && client.reconnect();
                    }
                },"",function(){
                    if(NetworkListenerUtils._getTokenCount>0){
                    setTimeout(function(){
                                        NetworkListenerUtils._getTokenCount--;
                                        NetworkListenerUtils._scanHostPort();
                                        }, 1000*5);  
                    }
                });             
            }else{
               // 恢复连接
               //初始化重连工具，进行重连e-message服务
                NetworkListenerUtils._getTokenCount = 3;
                NetworkListenerUtils._isScanHosting = false;
                M_ISFORCEONLINE = false;
                client && client.reconnect(); 
            }
    },
    _quitApp:function(){
        var _this = this;
        var time = 30;
        ReconAnimationUtils.showRelink();
        ReconAnimationUtils.updateRelinkInfo(1, '与服务器连接中断<br/>将在' + time + '秒之后退出e-message');
        window.Electron.currentWindow.flashFrame(true);
        setInterval(function(){
            if(time>=0){
                var msg = '与服务器连接中断<br/>将在<span>' + time + '</span>秒之后退出e-message';
                ReconAnimationUtils.updateRelinkInfo(1, msg);                
                time--;  
            }else{
                PcMainUtils.quitApp();
            }                               
        }, 1000);
    },
    //无net扫描重连
    _noScanHost:function(flag){
        var _this =this;
        if(!flag){
            if(_this._hostIsAvailable){
             _this._hostIsoffline();
            _this._hostIsAvailable = false;
            }
        }else{
            if(!_this._hostIsAvailable){
             _this._hostIsonline();
             _this._hostIsAvailable = true;           
            }
        }
        
    },
    _showHandleRelink:function(){
        ReconAnimationUtils.showRelink(this._handleConnect);
        ReconAnimationUtils.updateRelinkInfo(3, '连接emessage故障');
    },
    _handleConnect:function(){//没有扫描工具不起作用的话，就切换到手动重连，前提是已经自动重连了M_CONNCNT
         ReconAnimationUtils.updateRelinkInfo(2, '正在尝试建立连接...');
         if(IS_BASE_ON_OPENFIRE){
	         getTokenOfOpenfire(function(data){
	             if(!data == ""){                 
	                M_ISFORCEONLINE = false;
	                client && client.reconnect(function(info){
	                    if(!info){
	                        ReconAnimationUtils.updateRelinkInfo(3, '连接emessage故障');
	                    }else{
	                        //重连成功后更新会话时间
	                        OpenFireConnectUtil._updateConverTimeAndMessage();
	                    }
	                });                
	             }else{
	                 ReconAnimationUtils.updateRelinkInfo(3, '连接emessage故障');
	             }
	         },function(){
	             ReconAnimationUtils.updateRelinkInfo(3, '连接emessage故障');
	         },function(){
	             ReconAnimationUtils.updateRelinkInfo(3, '连接emessage故障');
	         });
         }else{
            if(M_SDK_VER ==2){
                if(!M_SERVERSTATUS){
	                if(M_NET_ERR){
	                    M_CORE.setConnectionStatusListener(client.connectionStatusListener);
	                    M_CORE.connect(M_TOKEN, client.connectionListener);
	                }
                }
            }
         }
    }
};

var WindowDepartUtil = {
    NewWindowList: {
        "SysSettings":1,
        "IMMyFavs" :2,
        "AppManager" :3,
        "GetUserIcon" : 4,
        "AddGroup":5,
        "SystemAlert":6,
        "GroupSubAdd":7,
        "GroupSubRename":8,
        "SystemComfirm":9,
        "HrmGroupAdd":10
    },
    /*activeChatWin:右侧窗口当前聊天的targetid*/
    winDepartParm:{
        deleteGroupName:{
            groupName : '',
            targetId : ''
        },
        signType:'',
        hrmGroupAddNid : '',
        signResult : '',
        signLock : '',
        openurl : '',
        moveToGroup : {
            id:'',
            groupName:'',
            rel_id:'',
            group_id:''
        },
        sendtime:'',
        openConArray:'',
        openConNum:0,
        openConCount:0,
        activeChatWin :''
    },
    //窗口分离版退出框
    showQuitDialog : function(){
        var title = '退出';
        var html = '<div class="show-new-client can-drag">';
           html += '    <div class="show-new-client-message no-drag">';
           html += '        <div class="header">'+title+'</div>';
           html += '        <div class="center quitdialog none-select">';
           html += '                <div style="font-size:14px;"><input type="radio" name="confirmQuit" value="1"/>'+social_i18n('HideTray')+'</div>';
           html += '                <div style="padding-top: 5px;font-size:14px;"><input type="radio" name="confirmQuit" value="2" checked="checked" />'+social_i18n('Quit')+'&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</div>';
           html += '                <div class="noLongerRemind" style="font-size:14px;"><input type="checkbox" id="noLongerRemind" name="noLongerRemind" onclick="" />'+social_i18n('Remember')+'</div>';
           html += '        </div>';
           html += '         <div class="footer">';
           html += '            <input type="button" class="task-comfirm" value="确定" />';
           html += '            <input type="button" class="task-cancel" value="取消" />';
           html += '        </div>';
           html += '    </div>';
           html += '</div>';
           $('body').append(html);
        $('.show-new-client').css('width', documentUtils.width()).css('height', documentUtils.height());
        $(".show-new-client-message").attr("style","height:200px");
        $('.task-comfirm').click(function(){
            var confirmQuit = $('input[name="confirmQuit"]:checked').val();
            var noLongerRemind = $('#noLongerRemind').is(':checked');
            if(noLongerRemind) {
                var userConfig = PcSysSettingUtils.getConfig();
                userConfig.mainPanel.noLongerRemind = true;
                userConfig.mainPanel.alwaysQuit = confirmQuit == 1 ? false : true;
                PcSysSettingUtils.saveConfig(userConfig);
                comfirmDialog(confirmQuit);
            } else {
                comfirmDialog(confirmQuit);
            }
            $('.show-new-client').hide();
            $('.show-new-client').remove();
        });
        $('.task-cancel').click(function(){
            DragUtils.restoreDrags();
            $('.show-new-client').hide();
            $('.show-new-client').remove();
        });
        $('.show-new-client').show();
        $('.quitdialog').jNice();
    
        function comfirmDialog(cq) {
	       if(cq == 1) {
	          DragUtils.restoreDrags();
	          $('.show-new-client').hide();
              $('.show-new-client').remove();
	          
	          setTimeout(function(){
	              PcMainUtils.hiddenToTray();
	          }, 100)
	       } else {
	           PcMainUtils.quitApp();
	       }
        }
    },
    //窗口分离版提示窗口
    showNewClientAlert : function(title,message,comfirmCb){
        var html = '<div class="show-new-client can-drag">';
           html += '    <div class="show-new-client-message no-drag">';
           html += '        <div class="header">'+title+'</div>';
           html += '        <div class="center">';
           html += '            <table align="center"><tr><th id="th-pic" align="right">';
           html += '            <div class="center-img"><img src="/wui/theme/ecology8/skins/default/rightbox/icon_query_wev8.png" /></div></th>';
           html += '            <th align="left" id="th-message"><div class="center-msg">&nbsp;&nbsp;'+message+'</div></th><th style="width:5%"></th></tr></table>';
           html += '        </div>';
           html += '         <div class="footer">';
           html += '            <input type="button" class="task-comfirm" value="确定" />';
           html += '        </div>';
           html += '    </div>';
           html += '</div>';
        $('body').append(html);
        $('.show-new-client').css('width', documentUtils.width()).css('height', documentUtils.height());
        $('.task-comfirm').click(function(){
            if(comfirmCb!==undefined && typeof comfirmCb == 'function'){
                comfirmCb();
            }
            $('.show-new-client').hide();
            $('.show-new-client').remove();
        });
        $('.show-new-client').show();
    },
    //窗口分离版确认窗口
    //isLong代表是否需要增加长度
    showNewClientComfirm : function(title,message,comfirmCb,quitCb,isLong,isRelink){
        var info = '确定';
        if(isRelink){
            info = '重连';
        }
        var html = '<div class="show-new-client can-drag">';
           html += '    <div class="show-new-client-message no-drag">';
           html += '        <div class="header">'+title+'</div>';
           html += '        <div class="center">';
           html += '            <table align="center"><tr><th id="th-pic" align="right">';
           html += '            <div class="center-img"><img src="/wui/theme/ecology8/skins/default/rightbox/icon_query_wev8.png" /></div></th>';
           html += '            <th align="left" id="th-message"><div class="center-msg">&nbsp;&nbsp;'+message+'</div></th><th style="width:5%"></th></tr></table>';
           html += '        </div>';
           html += '         <div class="footer">';
           html += '            <input type="button" class="task-comfirm" value="'+info+'" />';
           html += '            <input type="button" class="task-cancel" value="取消" />';
           html += '        </div>';
           html += '    </div>';
           html += '</div>';
        $('body').append(html);
        $('.show-new-client').css('width', documentUtils.width()).css('height', documentUtils.height());
        if(isLong){
            $(".show-new-client-message").attr("style","height:212px");
        }
        if(message.length<32){
            $("#th-message").attr("style","padding-top:0px");
        }else if(message.length>200){
            $(".show-new-client-message").attr("style","height:292px");
        }
        $('.task-cancel').click(function(){
            if(quitCb!==undefined && typeof quitCb == 'function'){
                quitCb();
            }
            $('.show-new-client').hide();
            $('.show-new-client').remove();
        });
        $('.task-comfirm').click(function(){
            if(comfirmCb!==undefined && typeof comfirmCb == 'function'){
                comfirmCb();
            }
            $('.show-new-client').hide();
            $('.show-new-client').remove();
        });
        $('.show-new-client').show();
    },
    clearUnreadCount : function(targetId,recentmsgcount){
        var winContents = WindowDepartUtil.getWinContents();
        if(winContents===''||winContents===undefined) return;
        var obj = {
            'targetId':targetId,
            'recentmsgcount':recentmsgcount
        };
        try{
            if(winContents) winContents.send('plugin-clearUnreadCount-function',WINID,obj);
        }catch(err){
        }
    },
    closeChatWin : function(){
        try{
            var winContents = WindowDepartUtil.getWinContents();
            if(winContents!==''||winContents===undefined) winContents.send('plugin-closeChatWin-function',WINID);
            WindowDepartUtil.winDepartParm.activeChatWin = '';
        }catch(err){
        }
    },
    saveSkin: function(skin){
        try{
            var winContents = WindowDepartUtil.getWinContents();
            if(winContents!==''||winContents===undefined) winContents.send('plugin-saveSkin-function',WINID,skin);
        }catch(err){
        }
    },
    openNewChatWin : function(obj){
        try{
        if(!IS_BASE_ON_OPENFIRE){
            obj.M_SERVERCONFIG = {};
        }else{
            obj.M_SERVERCONFIG=M_SERVERCONFIG;
        }
        }catch(err){
            obj.M_SERVERCONFIG={};
        }
        WindowDepartUtil.winDepartParm.activeChatWin = obj.targetid;
        window.Electron.ipcRenderer.send('plugin-openNewChatWin-show',obj); 
    },
    openIMNewChatWin : function(chatType,acceptId,chatName,headicon){
        var obj = {
            'chatType':chatType,
            'acceptId':acceptId,
            'chatName':chatName,
            'headicon':headicon,
            'type':2
        };
        try{
        if(!IS_BASE_ON_OPENFIRE){
            obj.M_SERVERCONFIG = {};
        }else{
            obj.M_SERVERCONFIG=M_SERVERCONFIG;
        }
        }catch(err){
            obj.M_SERVERCONFIG={};
        }
        WindowDepartUtil.winDepartParm.activeChatWin = acceptId;
        window.Electron.ipcRenderer.send('plugin-openNewChatWin-show',obj);
        
    },
    getWinContents : function(){
        try{
            WINID = window.Electron.ipcRenderer.sendSync('plugin-getWinIdInfo');
            var win = window.Electron.remote.BrowserWindow.fromId(WINID.chatwinid);
            var winContents;
            if(win){
                winContents = win.webContents;
            }else{
                return '';
            }
            return winContents;
        }catch(err){
            return '';
        }
    },
    //获取左侧聊天窗口对象
    getLeftWin : function(){
        try{
            WINID = window.Electron.ipcRenderer.sendSync('plugin-getWinIdInfo');
            var win = window.Electron.remote.BrowserWindow.fromId(WINID.chatwinid);
            if(win){
                return win;
            }else{
                return '';
            }
        }catch(err){
            return '';
        }
    },
    setOtherLeftStatus : function(userid,userStatus,mobileStatus){
        var winContents = WindowDepartUtil.getWinContents();
        if(winContents==='') return;
        winContents.send('plugin-setOtherLeftStatus-function',userid,userStatus,mobileStatus);
    },
    handleIMMsg : function(message){
        var winContents = WindowDepartUtil.getWinContents();
        if(winContents==='') return;
       var MessagesObj = {
                      'content':(typeof message.getContent==='function'&&message.getContent()!==undefined)?message.getContent():'',
                      'objectName':(typeof message.getObjectName==='function'&&message.getObjectName()!==undefined)?message.getObjectName():'',
                      'sentTime':(typeof message.getSentTime==='function'&&message.getSentTime()!==undefined)?message.getSentTime():'',
                      'messageId':(typeof message.getMessageId==='function'&&message.getMessageId()!==undefined)?message.getMessageId():'',
                      'detail':(typeof message.getDetail==='function'&&message.getDetail()!==undefined)?message.getDetail():'',
                      'messageUId': (typeof message.getMessageUId==='function'&&message.getMessageUId()!==undefined)?message.getMessageUId():'',
                      'extra':(typeof message.getExtra==='function'&&message.getExtra()!==undefined)?message.getExtra():'',
                      'senderUserId':(typeof message.getSenderUserId==='function'&&message.getSenderUserId()!==undefined)?message.getSenderUserId():'',
                      'targetId':(typeof message.getTargetId==='function'&&message.getTargetId()!==undefined)?message.getTargetId():'',
                      'messageType':(typeof message.getMessageType==='function'&&message.getMessageType()!==undefined)?message.getMessageType():'',
                      'conversationType':(typeof message.getConversationType==='function'&&message.getConversationType()!==undefined)?message.getConversationType():'',
                      'messageTag':(typeof message.getMessageTag==='function'&&message.getMessageTag()!==undefined)?message.getMessageTag():'',
                      'poi':(typeof message.getPoi==='function'&&message.getPoi()!==undefined)?message.getPoi():'',
                      'longitude':(typeof message.getLongitude==='function'&&message.getLongitude()!==undefined)?message.getLongitude():'',
                      'latitude':(typeof message.getLatitude==='function'&&message.getLatitude()!==undefined)?message.getLatitude():'',
                      'imageUri':(typeof message.getImageUri==='function'&&message.getImageUri()!==undefined)?message.getImageUri():'',
                      'duration':(typeof message.getDuration==='function'&&message.getDuration()!==undefined)?message.getDuration():'',
                      'count':(typeof message.getCount==='function'&&message.getCount()!==undefined)?message.getCount():'',
                      'operator' : (typeof message.getOperator==='function'&&message.getOperator()!==undefined)?message.getOperator():'',
                      'extension' : (typeof message.getExtension==='function'&&message.getExtension()!==undefined)?message.getExtension():'',
                      'type' : (typeof message.getType==='function'&&message.getType()!==undefined)?message.getType():''
                      
                  };
        winContents.send('plugin-handleIMMsg-function',MessagesObj); 
    },
    openNewWindow : function(args,id){
        var obj = {
            'args' : args ,
            'newWinId' : id
        };
        window.Electron.ipcRenderer.send('plugin-windowsdepart-show',obj);
    },
    isAllowWinDepart : function(){
        var isAllow = ISAllowNW;
        var isPc = ChatUtil.isFromPc();
        var isNXP = (CLIENT==='NXP'?true:false);
        var isnwFlag = (nwFlag==='true'?true:false); 
        if(isAllow&&isPc&&isNXP&&isnwFlag){
            return true;
        }else{
            return false;
        }
    },
    tabIsNull : function(){
        return true;
    },
    checkIfHandleMessage : function(message){
            var objName = message.getObjectName();
            var senderUserid=message.getSenderUserId();
            if(objName=='FW:SysMsg'&&senderUserid.indexOf('forced_openCon')==1){
                    return false;   
            }else{
                    return true;
            }
    },
    init :function(){
    //初始化一些回调方法
    //调用应用设置的回调
    window.Electron.ipcRenderer.on('plugin-pcAppManager-cbHandle',function(event,datas){
        var footertoolbar = $("#pc-footertoolbar");
        var ulObj = footertoolbar.find('nav ul');
        ulObj.empty();
        $.each(datas, function(i, item){
            ulObj.append("<!-- 按钮 --><li _linkuri='"+item.linkuri+"' _uritype='"+item.uritype+"'>"+
                                " <span><img src='"+item.icouri+"' icoUri='"+item.icouri+"' hotIcoUri='"+item.icohoturi+"' alt='"+item.icotitle+"' title='"+item.icotitle+"' draggable='false'/></span>");
            if(i == ulObj.length - 1){
                ulObj.append("</li>");
            }
        });
    });
    
    //修改图片回调
    window.Electron.ipcRenderer.on('plugin-setUserIcon-cbHandle',function(event){
        PcModels.updateHeadIcon();
    });
    
    //创建群组回调
    window.Electron.ipcRenderer.on('plugin-addGroup-cbHandle',function(event,args){
        DiscussUtil.addDiscussCallback(null,args,'resourceid','');
    });
    
    //設置用戶信息回調
    window.Electron.ipcRenderer.on('plugin-setUserConifg-cbHandle',function(event,args){
        PcSysSettingUtils._configs=args.config;
        var winContents = WindowDepartUtil.getWinContents();
        if(winContents==='') return;
        winContents.send('plugin-saveConfig-function',args);
    });
    
    //创建群分组回调
    window.Electron.ipcRenderer.on('plugin-addGroupSub-cbHandle',function(event,args){
        if($('.imToptab').find('.tabitem[_target=discuss]').hasClass('activeitem')){
            loadIMDataList("discuss");
        }
    });
    
     //重命名群分组回调
    window.Electron.ipcRenderer.on('plugin-renameGroupSub-cbHandle',function(event,args){
        if($('.imToptab').find('.tabitem[_target=discuss]').hasClass('activeitem')){
            loadIMDataList("discuss");
        }
    });
    
     //確認框回調函數
    window.Electron.ipcRenderer.on('plugin-systemComfirm-cbHandle',function(event,args){
        if(args.doID==='1'){
            if(args.doFor==='deleteGroupSub'){
            var isopenfire = IS_BASE_ON_OPENFIRE?1:0;
            var url = "/social/im/SocialIMOperation.jsp?operation=deleteDiscussList&isopenfire="+isopenfire;
                              $.post(url +"&name=" + WindowDepartUtil.winDepartParm.deleteGroupName, function(data){
                                  var message = $.trim(data);
                                  if(message!=""){
                                      var win = window.Electron.currentWindow;
                                      win.hide();
                                      showImAlert(message);
                                  }
                                  WindowDepartUtil.deleteGroupName='';                              
                                  //刷新树
                                  if($('.imToptab').find('.tabitem[_target=discuss]').hasClass('activeitem')){
                                                            loadIMDataList("discuss");
                                                            }
             });
             }else if(args.doFor==='deleteCancel'){
                //直接关掉窗口即可
             }
        }else if(args.doID==='2'){
           if(args.doFor==='signInComfirmOk'){
                PcModels.printIMSignStatus(WindowDepartUtil.winDepartParm.signType);
                SignInfo.signType = '2';
                PcModels.loadSignItem(2);
                WindowDepartUtil.winDepartParm.signType='';
           }else if(args.doFor==='signInComfirmCancel'){
                PcModels.cache.signLock = 0;
           }
        }else if(args.doID==='3'){
           if(args.doFor==='signOutComfirmOk'){
                PcModels.printIMSignStatus(WindowDepartUtil.winDepartParm.signType);
                WindowDepartUtil.winDepartParm.signType='';
           }else if(args.doFor==='signOutComfirmCancel'){
                return;
           }
        }else if(args.doID==='4'){
           PcModels.cache.signResult = WindowDepartUtil.winDepartParm.signResult;
           PcModels.cache.signLock = WindowDepartUtil.winDepartParm.signLock;
           if(args.doFor==='signOutComfirmOkSec'){
               PcExternalUtils.openUrlByLocalApp(WindowDepartUtil.winDepartParm.openurl,0);
           }
        }else if(args.doID==='5'){
           if(args.doFor==='moveToGroupComfirm'){
                var id = WindowDepartUtil.winDepartParm.moveToGroup.id;
                var groupName = WindowDepartUtil.winDepartParm.moveToGroup.groupName;
                var rel_id = WindowDepartUtil.winDepartParm.moveToGroup.rel_id;
                var group_id = WindowDepartUtil.winDepartParm.moveToGroup.group_id;
                var url = "/social/im/SocialIMOperation.jsp?operation=changeGroupList";
                $.post(url + "&id=" + id + "&groupName=" + groupName + "&rel_id=" + rel_id + "&group_id=" + group_id, function(data) {
                    var message = $.trim(data);
                    if($('.imToptab').find('.tabitem[_target=discuss]').hasClass('activeitem')){
                                loadIMDataList("discuss");
                                }
                    if (message != "") {
                        showImAlert(message);
                    }
                });
           }else if(args.doFor==='moveToGroupCancel'){
           //关闭窗口
           }
        }else if(args.doID==='6'){
            if(args.doFor==='deleteGroupOk'){
                DiscussUtil.DiscussSetFunc.quitFromDiscussion(WindowDepartUtil.winDepartParm.deleteGroupName.targetId);
            }else if(args.doFor==='deleteGroupCancel'){
           //关闭窗口
           }
        }
    });
    
    window.Electron.ipcRenderer.on('plugin-clientDo-function',function(event,args,winid){
        var win = window.Electron.remote.BrowserWindow.fromId(winid.chatwinid);
        var winContents;
        if(win){
            winContents = win.webContents;
        }else{
            return;
        }
        if(args._do==='getDiscussion'){
                client.getDiscussion(args.discussid,function(discuss){
                    if(!!discuss){
                        discussList[args.discussid]=discuss;
                        var discussObj = {
                            'creatorId' : discuss.getCreatorId(),
                            'memberIdList' : discuss.getMemberIdList(),
                            'name' : discuss.getName(),
                            'id' :  discuss.getId(),
                            'icon' : IS_BASE_ON_OPENFIRE?discuss.getIcon():'',
                            'isDisableAddUser' : (discuss.isDisableAddUser && discuss.isDisableAddUser())||false,
                            'isDisableMsgRead' : (discuss.isDisableMsgRead && discuss.isDisableMsgRead())|| false
                        };
                        if(winContents)
                            winContents.send('plugin-clientDo-functionCb',args,winid,discussObj);
                    }
                });
        }else if(args._do==='getClientIns'){
            var obj = {
                'client':client?true:false
            };
            if(winContents) winContents.send('plugin-clientDo-functionCb',args,winid,obj);
        }else if(args._do==='getHistoryMessages'){
            var targetType = args.targetType;
            var targetid = args.targetid;
            var pagesize = args.pagesize;
            client && client.getHistoryMessages(targetType,targetid,pagesize,function(symbol,HistoryMessages,isSuccess,error){
              var MessagesArray = [];
              if(!isSuccess){
                  return;
              } 
              for (var i = 0;i<=HistoryMessages.length-1;i++){
                  var MessagesObj = {
                      'content':(typeof HistoryMessages[i].getContent==='function'&&HistoryMessages[i].getContent()!==undefined)?HistoryMessages[i].getContent():'',
                      'objectName':(typeof HistoryMessages[i].getObjectName==='function'&&HistoryMessages[i].getObjectName()!==undefined)?HistoryMessages[i].getObjectName():'',
                      'sentTime':(typeof HistoryMessages[i].getSentTime==='function'&&HistoryMessages[i].getSentTime()!==undefined)?HistoryMessages[i].getSentTime():'',
                      'messageId':(typeof HistoryMessages[i].getMessageId==='function'&&HistoryMessages[i].getMessageId()!==undefined)?HistoryMessages[i].getMessageId():'',
                      'detail':(typeof HistoryMessages[i].getDetail==='function'&&HistoryMessages[i].getDetail()!==undefined)?HistoryMessages[i].getDetail():'',
                      'messageUId': (typeof HistoryMessages[i].getMessageUId==='function'&&HistoryMessages[i].getMessageUId()!==undefined)?HistoryMessages[i].getMessageUId():'',
                      'extra':(typeof HistoryMessages[i].getExtra==='function'&&HistoryMessages[i].getExtra()!==undefined)?HistoryMessages[i].getExtra():'',
                      'senderUserId':(typeof HistoryMessages[i].getSenderUserId==='function'&&HistoryMessages[i].getSenderUserId()!==undefined)?HistoryMessages[i].getSenderUserId():'',
                      'targetId':(typeof HistoryMessages[i].getTargetId==='function'&&HistoryMessages[i].getTargetId()!==undefined)?HistoryMessages[i].getTargetId():'',
                      'messageType':(typeof HistoryMessages[i].getMessageType==='function'&&HistoryMessages[i].getMessageType()!==undefined)?HistoryMessages[i].getMessageType():'',
                      'conversationType':(typeof HistoryMessages[i].getConversationType==='function'&&HistoryMessages[i].getConversationType()!==undefined)?HistoryMessages[i].getConversationType():'',
                      'messageTag':(typeof HistoryMessages[i].getMessageTag==='function'&&HistoryMessages[i].getMessageTag()!==undefined)?HistoryMessages[i].getMessageTag():'',
                      'poi':(typeof HistoryMessages[i].getPoi==='function'&&HistoryMessages[i].getPoi()!==undefined)?HistoryMessages[i].getPoi():'',
                      'longitude':(typeof HistoryMessages[i].getLongitude==='function'&&HistoryMessages[i].getLongitude()!==undefined)?HistoryMessages[i].getLongitude():'',
                      'latitude':(typeof HistoryMessages[i].getLatitude==='function'&&HistoryMessages[i].getLatitude()!==undefined)?HistoryMessages[i].getLatitude():'',
                      'imageUri':(typeof HistoryMessages[i].getImageUri==='function'&&HistoryMessages[i].getImageUri()!==undefined)?HistoryMessages[i].getImageUri():'',
                      'duration':(typeof HistoryMessages[i].getDuration==='function'&&HistoryMessages[i].getDuration()!==undefined)?HistoryMessages[i].getDuration():'',
                      'count':(typeof HistoryMessages[i].getCount==='function'&&HistoryMessages[i].getCount()!==undefined)?HistoryMessages[i].getCount():'',
                      'operator' : (typeof HistoryMessages[i].getOperator==='function'&&HistoryMessages[i].getOperator()!==undefined)?HistoryMessages[i].getOperator():'',
                      'extension' : (typeof HistoryMessages[i].getExtension==='function'&&HistoryMessages[i].getExtension()!==undefined)?HistoryMessages[i].getExtension():'',
                      'type' : (typeof HistoryMessages[i].getType==='function'&&HistoryMessages[i].getType()!==undefined)?HistoryMessages[i].getType():''
                      
                  };
                  MessagesArray[i]=MessagesObj;
              }
              var obj = {
                  'symbol':symbol,
                  'HistoryMessages':MessagesArray,
                  'isSuccess':isSuccess,
                  'error':error
              };
              winContents.send('plugin-clientDo-functionCb',args,winid,obj);
            });
        }else if(args._do==='sendIMMsg'){
            var targetid = args.targetid;
            var msgObj = args.msgObj;
            var msgType = args.msgType;
            var msgid = args.msgid;
            var targetType = args.targetType;
            client.sendIMMsg(targetid,msgObj,msgType,function(msg){
                if(msg.sendtime==undefined){
                    msg.sendtime = WindowDepartUtil.winDepartParm.sendtime;
                    WindowDepartUtil.winDepartParm.sendtime ='';
                }
                var issuccess=msg.issuccess;
                if(issuccess==1&&winContents){
                    //更新会话
                    if(msgObj.objectName!='FW:CountMsg'&&msgObj.objectName!='FW:SyncMsg'&&msgObj.objectName!='FW:SyncQuitGroup'){
                        ChatUtil.doHandleSendSuccess(msg, msgid, targetid, targetType);
                    }
                    winContents.send('plugin-clientDo-functionCb',args,winid,msg);
                }
            });
        }else if(args._do==='setDiscussionName'){
            var discussid = args.discussid;
            var newDiscussName = args.newDiscussName;
            newDiscussName = newDiscussName.replace(/&nbsp;/gi, ' ');
            client.setDiscussionName(discussid, newDiscussName,function(){
                winContents.send('plugin-clientDo-functionCb',args,winid,true);
            });
        
        }else if(args._do==='resetGetHistoryMessages'){
            var targetType = args.targetType;
            var targetid = args.targetid;
            client.resetGetHistoryMessages(targetType, targetid,function(){
                winContents.send('plugin-clientDo-functionCb',args,winid,true);
            });
        }else if(args._do==='reconnect'){
            client && client.reconnect();
        }else if(args._do==='getDiscussionMemberIds'){
            var targetid = args.targetid;
            client.getDiscussionMemberIds(targetid,function(ids){
                winContents.send('plugin-clientDo-functionCb',args,winid,ids);
            });
        }else if(args._do==='clearMessagesUnreadStatus'){
            var targetType = args.targetType;
            var targetid = args.targetid;
            try{
                client && client.clearMessagesUnreadStatus(targetType, targetid);
                winContents.send('plugin-clientDo-functionCb',args,winid,true);
            }catch(err){
                winContents.send('plugin-clientDo-functionCb',args,winid,false);
            }
        }else if(args._do==='removeConversation'){
           var targetType = args.targetType;
            var targetid = args.targetid;
            client.removeConversation(targetType, targetid,function(){
                winContents.send('plugin-clientDo-functionCb',args,winid,true);
            });
        }else if(args._do==='sendMessageToUser'){
           var userid = args.userid;
           var msgObj = args.msgObj;
           var count = args.count;
           var targettype = args.targettype;
           client.sendMessageToUser(userid, msgObj, count,function(result){
                if(msgObj.objectName==='FW:ClearUnreadCount'){
                    return;
                }
                var issuccess=result.issuccess;
                if(issuccess==1&&winContents){
                    //更新会话
                    if(msgObj.objectName!='FW:CountMsg'&&msgObj.objectName!='FW:SyncMsg'){
                        var userInfo=userInfos[M_USERID];
                        var msgContent=userInfo.userName+":"+
                        getMsgContent(null,
                        {
                            "content":msgObj.content,
                            "objectName":msgObj.objectName,
                            "extra":msgObj.extra,
                            "msgType":result.paramzip.msgtype
                         });
                         var sendtime=M_CURRENTTIME;
                         updateConversationList(userInfo,userid,targettype,msgContent,sendtime);
                    }
                    winContents.send('plugin-clientDo-functionCb',args,winid,result);
                }
           });
           
        }else if(args._do==='setConversationToTop'){
           var targetType = args.targetType;
            var targetid = args.targetid;
            client.setConversationToTop(targetType, targetid,function(targetid){
                winContents.send('plugin-clientDo-functionCb',args,winid,true);
            });
        }else if(args._do==='addMemberToDiscussion'){
           var discussid = args.discussid;
            var memList = args.memList;
            client.addMemberToDiscussion(discussid, memList,function(){
                winContents.send('plugin-clientDo-functionCb',args,winid,true);
            });
        }else if(args._do==='quitDiscussion'){
           var discussid = args.discussid;
            client.quitDiscussion(discussid,function(){
                winContents.send('plugin-clientDo-functionCb',args,winid,true);
                loadIMDataList("discuss");
            });
        }else if(args._do==='removeMemberFromDiscussion'){
           var discussid = args.discussid;
           var imUserid = args.imUserid;
            client.removeMemberFromDiscussion(discussid,imUserid,function(data){
                winContents.send('plugin-clientDo-functionCb',args,winid,data);
            });
        }else if(args._do==='loadIMDataList'){
           try{
               if($('.imToptab').find('.tabitem[_target=discuss]').hasClass('activeitem')){
                   loadIMDataList("discuss");
               }
               winContents.send('plugin-clientDo-functionCb',args,winid,true);
           }catch(err){
               winContents.send('plugin-clientDo-functionCb',args,winid,false);
           }
        }else if(args._do==='sendMessageToDiscussion'){
           try{
              var targetid = args.targetid;
              var sdMsgObj = args.msgObj;
              var msgType = args.msgType;
              var targetType = args.targetType;
              var targetName = args.targetName; 
              var callbackSuccess = function(data){
                  winContents.send('plugin-clientDo-functionCb',args,winid,data);
                  var userInfo=userInfos[M_USERID];
                  var msgContent=userInfo.userName+":"+
                    getMsgContent(null,
                        {
                            "content":sdMsgObj.content,
                            "objectName":sdMsgObj.objectName,
                            "extra":sdMsgObj.extra,
                            "msgType":msgType
                         });
                var sendtime=M_CURRENTTIME;
                updateConversationList(userInfo,targetid,targetType,msgContent,sendtime);
                //同步到本地会话
                var jsconverList = [{
                    senderid:M_USERID,
                    targetid: targetid,
                    targettype: targetType,
                    msgcontent: msgContent,
                    sendtime: sendtime,
                    targetname:targetName,
                    receiverids:ChatUtil.getMemberids(targetType,targetid,true)
                }];
                ChatUtil.syncConversToLocal(jsconverList);
              }
              client.sendMessageToDiscussion.call(client, targetid, sdMsgObj, msgType,callbackSuccess);
           }catch(err){
               winContents.send('plugin-clientDo-functionCb',args,winid,false);
           }
        }else if(args._do==='updateTotalMsgCount'){
            var targetid = args.targetid;
            var flag = args.flag;
            var chattype = args.chattype;
            var count = args.count;
            updateTotalMsgCount(targetid,flag,chattype,count);
            winContents.send('plugin-clientDo-functionCb',args,winid,true);
        }else if(args._do==='getDiscussionName'){
           try{
                var result = args.result;
              client.getDiscussionName(result,function(name){
                 winContents.send('plugin-clientDo-functionCb',args,winid,name);
              },function(err){
                 winContents.send('plugin-clientDo-functionCb',args,winid,false);
              });
           }catch(err){
               winContents.send('plugin-clientDo-functionCb',args,winid,false);
           }
        }else if(args._do==='createDiscussion'){
            var disName = args.disName;
            var memList = args.memList;
            try{
            RongIMClient.getInstance().createDiscussion(disName,memList,{
                onSuccess:function(targetId){
                    winContents.send('plugin-clientDo-functionCb',args,winid,targetId);
                },
                onerror:function(err){
                    winContents.send('plugin-clientDo-functionCb',args,winid,err);      
                }
                });
            }catch(err){
                winContents.send('plugin-clientDo-functionCb',args,winid,err);
            }
        }else if(args._do==='setDiscussionAdmin'){
           var discussid = args.discussid;
           var userid = args.userid;
           var callback = function(){
                winContents.send('plugin-clientDo-functionCb',args,winid,true);
           }
           IMClient.prototype.setDiscussionAdmin(discussid,userid,callback);
        }else if(args._do==='setDiscussionIcon'){
           var discussid = args.discussid;
           var imgurl = args.imgurl;
           var callback = function(info){
                winContents.send('plugin-clientDo-functionCb',args,winid,info);
           }
           client.setDiscussionIcon(discussid,imgurl,callback);
        }else if(args._do==='getConversationCount'){
           var targetType = args.targetType;
           var realTargetId = args.realTargetId;
           var conversation = $("#"+ getConverId(targetType, realTargetId));
           var conversationMsgCount = conversation.find(".msgcount");
           var count = Number(conversationMsgCount.attr("_msgcount"))
           if(count==undefined||isNaN(count)){
               count = 0;
           }
           winContents.send('plugin-clientDo-functionCb',args,winid,count);
        }else if(args._do==='updateChatWinID'){
            WindowDepartUtil.winDepartParm.activeChatWin = args.targetId;
        }else if(args._do==='setNewMsgNotice'){
            var settingInfo = args.settingInfo;
            refreshDiscussSetting(settingInfo);
        }
    });
    }
};