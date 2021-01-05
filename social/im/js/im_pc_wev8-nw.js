// 来自pc客户端登陆时，加载完成要做的操作
var pcWindowConfig = {
    winMax: false,
    shortcut: {
        screenshot: null
    }
};
var nwgui = window.require('nw.gui');
var node_path = window.require('path');
var appConfig = require(node_path.join(nwgui.__dirname, '/appConfig.json'));
var GLOBAL_INFOS = nwgui.global.GLOBAL_INFOS;
var focusFlag = false;
const _platform = {
    Windows: /^win/i.test(process.platform),
    OSX: /^darwin/i.test(process.platform),
    Linux: /unix/i.test(process.platform)
};
const WindowPlatform = "xp"
//获取当前窗体对象
var currentWindow = nwgui.Window.get();
$(function () {
    $('#pcOnTop').hide();//屏蔽窗口前置功能
    $('#pc-accountswtichblock').hide();//屏蔽主次账号功能
    // 设置ajax全局参数
    $.ajaxSetup({
        data: {
            from: 'pc',
            sessionkey: GLOBAL_INFOS.sessionKey,
            language: PcMainUtils.userInfos.language
        }
    });
    currentWindow.on('close', function (e) {
        var config = PcSysSettingUtils.getConfig();
        var noLongerRemind = config.mainPanel.noLongerRemind;
        var alwaysQuit = config.mainPanel.alwaysQuit;
        if (noLongerRemind) {
            if (alwaysQuit) {
                PcMainUtils.quitApp();
            } else {
                PcMainUtils.hiddenToTray();
            }
        } else {
            if ($("#noLongerRemind").length < 1) {
                currentWindow.show();
                currentWindow.focus();
                showQuitDialog();
            }
        }
        e.preventDefault();

    });
    currentWindow.on('new-win-policy', function (frame, url, policy) {
        policy.ignore();
        nwgui.Shell.openExternal(url);
    });
    // 初始化托盘
    TrayUtils.init();    
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
    // 获取配置信息
    PcSysSettingUtils.init(function () {
        // 注册全局快捷键
        PcGlobalShortcutUtils.init();
    });
    // 窗口最小化
    $('#pcMin').click(function () {
        currentWindow.minimize();
    });
    // 窗口最大化
    var isMainWinMax = false; // 主窗口是否是最大化
    $('#pcMax').click(function () {        
        isMainWinMax = !isMainWinMax;
        if (isMainWinMax) {
            currentWindow.maximize();
            isMainWinMax = true;
            $('#imMainbox').removeClass('imMainbox-p5').addClass("imMainbox-p0");
        } else {
            //currentWindow.unmaximize();
            currentWindow.resizeTo(1053, 627);
            currentWindow.moveTo(300, 200);
            isMainWinMax = false;
            $('#imMainbox').removeClass('imMainbox-p0').addClass("imMainbox-p5");
        }
        try {
            isMainWinMax ? $(this).removeClass('pc-imMaxBtn').addClass('pc-imMaxBtn-re').attr('title', '还原') : $(this).removeClass('pc-imMaxBtn-re').addClass('pc-imMaxBtn').attr('title', '最大化');
        } catch (e) {

        }
    });

    // 关闭窗口
    $('#pcClose').click(function () {        
        var config = PcSysSettingUtils.getConfig();
        var noLongerRemind = config.mainPanel.noLongerRemind;
        var alwaysQuit = config.mainPanel.alwaysQuit;
        if (noLongerRemind) {
            if (alwaysQuit) {
                PcMainUtils.quitApp();
            } else {
                PcMainUtils.hiddenToTray();
            }
        } else {
            showQuitDialog();
        }
    });
    //聊天窗口获得焦点
    currentWindow.on('hide', function () {
        currentWindow.blur();
    });
    currentWindow.on('show', function () {
        currentWindow.focus();
    });
    currentWindow.on('focus', function () {
        focusFlag = true;
        if (currentWindow) {
            var currentTab = getCurrentTab();
            var chatWinid = $(currentTab).attr("_chatWinid");
            try {
            console.log('获取焦点');
            //检测是否离线
            // ServerExceptionHandling._exeAjax();
  			var chattype = chatWinid.substring(8, 9);
  			var targetid = chatWinid.substring(10, chatWinid.length);
            client && client.reconnect();//激活后检查链接状态，如果断开重新连接
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
            } catch (e) {
                console.log('error from pc_focus');
            }
            TrayUtils.setTrayCommon();
            TrayUtils.restoreTray();
        }
    });
    currentWindow.on('blur', function () {
        focusFlag = false;
    });
    // 启动服务器状态监测
    ServerExceptionHandling.start();
    // 检测服务端版本
    //DetectionOfUpgrade.start();    
});

// 打开退出按钮确认对话框
function showQuitDialog() {
    DragUtils.closeDrags();
    var inhtml = '<div class="quitdialog none-select">';
    inhtml += '   <div><input type="radio" name="confirmQuit" value="1"/>最小化到托盘</div>';
    inhtml += '   <div style="padding-top: 5px;"><input type="radio" name="confirmQuit" value="2" checked="checked" />退出&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</div>';
    inhtml += '   <div class="noLongerRemind"><input type="checkbox" id="noLongerRemind" name="noLongerRemind" onclick="clickNoLongerRemind(this)" />记住选择，不再提醒</div>';
    inhtml += '</div>';

    var diag = new window.top.Dialog();
    diag.Title = '退出';
    diag.Width = 280;
    diag.Height = 130;
    diag.normalDialog = false;
    diag.InnerHtml = inhtml;
    diag.OKEvent = function () {
        var confirmQuit = $('input[name="confirmQuit"]:checked').val();
        var noLongerRemind = $('#noLongerRemind').is(':checked');
        if (noLongerRemind) {
            var userConfig = PcSysSettingUtils.getConfig();
            userConfig.mainPanel.noLongerRemind = true;
            userConfig.mainPanel.alwaysQuit = confirmQuit == 1 ? false : true;
            PcSysSettingUtils.saveConfig(userConfig);
            comfirmDialog(confirmQuit);
        } else {
            comfirmDialog(confirmQuit);
        }
    };
    diag.CancelEvent = function () {
        DragUtils.restoreDrags();
        diag.close();
    };

    diag.show();
    $('.quitdialog').jNice();

    function comfirmDialog(cq) {
        if (cq == 1) {
            DragUtils.restoreDrags();
            diag.closeManual();

            setTimeout(function () {
                PcMainUtils.hiddenToTray();
            }, 100)
        } else {
            PcMainUtils.quitApp();
        }
    }

    // 带上这个checkbox才能点，不知道为什么！！
    function clickNoLongerRemind(obj) { }
}

// 打开设置对话框
function openSysSetting() {
    DragUtils.closeDrags();

    var diag = new window.top.Dialog();
    diag.Title = '系统设置';
    diag.Width = 570;
    diag.Height = 420;
    diag.normalDialog = false;
    diag.ShowButtonRow = false;
    diag.URL = '/social/im/SocialIMPcSysSetting.jsp?d=' + new Date().getTime();
    diag.closeHandle = function () {
        DragUtils.restoreDrags();
    };
    diag.show();
}

// 取消所有发送和接收文件夹
function stopDirSending() {
    try {
        PcSendDirUtils.cancelAllSend();
        PcSendDirUtils.cancelAllReceive();
        PcSendDirUtils.stopServer();
    } catch (e) {
        console.error("！！没有开启文件和文件夹传输功能！！");
    }
}
// 工具
var PcMainUtils = {
    userInfos: GLOBAL_INFOS.userInfos,
    appPath: GLOBAL_INFOS.appPath,
    platform: _platform,
    localconfig: null,
    pcUtils: null,

    // 初始化
    init: function () {
        this.localconfig = window.require(node_path.join(GLOBAL_INFOS.appPath, '/localconfig.js'));
        this.pcUtils = window.require(node_path.join(GLOBAL_INFOS.appPath, '/pcUtils.js'));
    },

    // 判断用户操作系统类型
    isWindows: function () {
        return this.platform.Windows;
    },
    isOSX: function () {
        return this.platform.OSX;
    },
    isLinux: function () {
        return this.platform.Linux;
    },
    getOSType: function () {
        var osType = 1;
        if (this.isOSX()) {
            osType = 2;
        } else if (this.isLinux()) {
            osType = 3;
        }
        return osType;
    },

    // 阻塞程序numberMillis毫秒数
    sleep: function (numberMillis) {
        var now = new Date();
        var exitTime = now.getTime() + numberMillis;
        while (true) {
            now = new Date();
            if (now.getTime() > exitTime) return;
        }
    },

    // 最小化到托盘
    hiddenToTray: function () {
        if (this.isWindows()) {
            currentWindow.hide();
        } else if (this.isOSX()) {
            currentWindow.minimize();
        }
    },
    // 退出前的一些列操作
    beforeQuitApp:function(callback){
        try {
            // 取消所有下载
            PcDownloadUtils.abortAllDl();
            stopDirSending();
            if (client) {
                M_ISFORCEONLINE = true;
                client.disconnect();
            }
            // 设置pc端为未登陆状态。
            $.ajax({
                async: false,
                url: '/social/im/ServerStatus.jsp?p=logout',
                timeout: 200
            }); 
        } catch (error) {
            
        } 
        typeof callback ==="function" && callback();  
    },
    // 退出程序
    quitApp: function () {
        this.beforeQuitApp();   
        nwgui.App.quit();
    },
    // 注销
    logout: function () {
        var _this = this;
        _this.localconfig.setLogout(true, function () {
            _this.quitApp();
        });
    },
    // 判断路径是否是一个文件
    isFile: function (filepath) {
        const fs = window.require('fs');
        var stats = fs.statSync(filepath);
        return stats.isFile();
    },
    isExistFile: function (path, callback) {
        const fs = window.require('fs');
        fs.exists(path, callback);
    },
    // 获取用户配置信息,callback(error, config)
    getSetting: function (callback) {
        this.localconfig.get(GLOBAL_INFOS.userInfos,function(error,config){
                typeof callback == "function" && callback(config);
        });
    },
    // 保存用户配置信息
    setSetting: function (config,callback) {
        this.localconfig.set(GLOBAL_INFOS.userInfos,config,callback);
    },
    // 获得当前版本信息
    getVersion: function () {
        return this.pcUtils.getBuildVersion(GLOBAL_INFOS.appPath);
    },
    clearCache:function(callback){
         //清理缓存的时候关闭图片浏览窗口
        if (ImageViewPageUtil._currentTipWindow) {
            ImageViewPageUtil._currentTipWindow.close();
        }
        var userConfig = PcSysSettingUtils.getConfig();
        nwgui.App.unregisterGlobalHotKey(nwgui.Shortcut({ key: userConfig.shortcut.screenshot }));
        nwgui.App.unregisterGlobalHotKey(nwgui.Shortcut({ key: userConfig.shortcut.openAndHideWin }));
        nwgui.App.clearCache();
        currentWindow.reload();
        typeof callback =="function" && callback();
    },	
	log :function(content){
		
	}
};

// 获取文档宽高
var documentUtils = {
    width: function () {
        return $(document).width();
    },
    height: function () {
        return $(document).height();

    }
};

// 关闭和打开其他可拖拽属性。
// 打开一个对话框或者弹出操作层时，首先关闭页面其他可拖拽属性，在操作完成或关闭对话框时，再恢复可拖拽。
var DragUtils = {
    _canDrags: null,
    closeDrags: function () {
        var $imSlideDiv = $('#imSlideDiv')
        if (this._canDrags == null && $imSlideDiv.css('display') == 'none') {
            this._canDrags = $('.can-drag');
            this._canDrags.removeClass('can-drag');
        }
    },
    restoreDrags: function () {
        var $imSlideDiv = $('#imSlideDiv')
        if (this._canDrags != null && $imSlideDiv.css('display') == 'none') {
            this._canDrags.addClass('can-drag');
            this._canDrags = null;
        }
    }
};

// 设置有未读消息时托盘图标闪动。
// 规则：只要有未读消息，就闪动图标。当没有未读时取消闪动。
var TrayUtils = {
    _isBusying: false,
    _isOffline: false,
    _currentWin: currentWindow,
    _username: M_USERNAME,  // 用户名
    init: function () {
        this.setTrayTooltip('状态：在线');
        this.setTrayCommon();
    },
    // 托盘图标变成正常
    setTrayCommon:function(){
        opener.TrayUtils.setTrayCommon();
    },
    hasUnreadMsg: function () {
        var count = 0;
        $('.msgcount').each(function (i) {
            var c = $(this).html();
            if (c != '') {
                count += parseInt(c);
            }
        });
        return count > 0;
    },
    flashingTray: function () {
        if (!isCurrentWindowFocused()) {
            this._currentWin.requestAttention(true);
        }
        if (!isCurrentWindowFocused() && this._isBusying == false) {
            this._isBusying = true;
           opener.TrayUtils.setTrayBusy();
        }
    },    
    restoreTray: function () {
        if (this._isBusying) {
            this._isBusying = false;
            opener.TrayUtils.setTrayCommon();
        }
        if(this._isOffline) {
            
            if(SOCIAL_GLOBAL.OnlineStatus.M_ONLINESTATUS[M_USERID]!=undefined){
                try{
                    var status = SOCIAL_GLOBAL.OnlineStatus.M_ONLINESTATUS[M_USERID].pc;
                    if(status==undefined) status='online';
                }catch(err){
                    var status = "online";
                }
                this.setTrayTooltip('状态：'+ONLINESTATUS[status]);
            }else{
                this.setTrayTooltip('状态：在线');
            }
            this._isOffline = false;
            opener.TrayUtils.setTrayCommon();
        }
    },
    offlineTray : function(){
        if (!this._isOffline) {
            this.setTrayTooltip('状态：离线');
            this._isOffline = true;
            this._isBusying = false;
            opener.TrayUtils.setTrayOffline();
        }
    },
    setTrayTooltip: function (msg) {
       opener.TrayUtils.setToolTip('e-message-xp\r\n用户：' + this._username + '\r\n' + msg );
    },
    showTrayBalloon: function (title, content) {
        var notif = showNotification(title, content);
        setTimeout(function () {
            notif.close();
        }, 1200);
    },
    clickTrayShowWin:function(){
        $('.imToptab').find('[_target="recent"]').click();
    }
    
};

// 截屏工具
var ScreenshotUtils = {
    /* 
    *是否是e-message截图获取到的图片
     */
    isScreenshot:false,
    // 执行截图
    screenshot: function (obj) {
        clearTimeout(ScreenshotUtils.pasteTimeout); 
        var flag  = false;
        nwgui.Clipboard.get().clear();
        this.isScreenshot = true;
        if(ChatUtil.isScreenShotMinimize == 1){
            windowUtil._hide();
            flag = true;
        }
        setTimeout(function(){
            nwgui.Shell.openItem(node_path.join(GLOBAL_INFOS.appPath, '/extension/screenshot/CaptureImageTool.exe'));
            if(flag){
                setTimeout(function(){
                    windowUtil._show();
                },2000);
            }
            ScreenshotUtils.pasteSetTimeout(); 
        },400)      
    },
    checkClipData:function(){
        return !!nwgui.Clipboard.get().get('png');
    },
    timeOutCount:30,
    pasteTimeout:null,
    pasteSetTimeout:function(){
      ScreenshotUtils.pasteTimeout = setTimeout(function(){
            if(ScreenshotUtils.isScreenshot && ScreenshotUtils.checkClipData()){
                clearTimeout(ScreenshotUtils.pasteTimeout);
                ScreenshotUtils.timeOutCount = 30;
                ScreenshotUtils.isScreenshot = false;
                var $chatwin = ChatUtil.getCurChatwin();
                if($chatwin.length > 0) {
                    var $chatContent = $chatwin.find('.chatcontent');
                    if($chatContent) {
                        $chatContent.focus();
                        document.execCommand('paste')
                    }
                }
            }else{
                if(ScreenshotUtils.timeOutCount-->0){
                    ScreenshotUtils.pasteSetTimeout();
                }                
            }
        },1000);
    },    
};

// 提醒弹窗工具
var RemindTipUtils = {
    showRemindTip: function (tipInfo) {
        AppTipWindowUtil.showAppTipWindow(tipInfo);
    }
};
// 判断当前窗口是否获取焦点，返回true标识获得焦点，否则返回false
function isCurrentWindowFocused() {
    return focusFlag;
};
//图片全屏预览
var ImageReviewForPc = {
    // 预览图片。imgIndex：第一个图片的下标。imgSrcArray：图片src数组。
    show: function (imgIndex, imgSrcArray) {
        ImageViewPageUtil.showImageViewWindow({ imgIndex: imgIndex, imgSrcArray: imgSrcArray });
    },
    // 关闭预览窗口
    close: function () {
        var win = ImageViewPageUtil._currentTipWindow;
        if (win != null) {
            win.close();
        }
    }
};

// 监测服务器是否异常并重连
var ServerExceptionHandling = {
    // 配置参数
    option: {
        commonMonitoringTime: 1000 * 60 * 3,  // 3分钟钟发送一次请求进行监测
        reLinkTime: 1000 * 30, // 断线后，系统30秒钟进行一次重连
        serverPage: GLOBAL_INFOS.currentHost + '/social/im/ServerStatus.jsp'
    },

    start: function () {
        var _this = this;
        $(document)
            .ajaxSuccess(function (evt, request, settings) {
                _this._handleSuccess(request.responseText);
            })
            .ajaxError(function (event, XMLHttpRequest, ajaxOptions, thrownError) {
                console.info(thrownError);
            });
    },

    _hasHandWorked: false,  //是否触发了手工重连
    handworkRelink: function () {
        var _this = this;
        _this._hasHandWorked = true;
        ReconAnimationUtils.updateRelinkInfo(2, '正在尝试建立连接...');
        $.ajax({
            url: _this.option.serverPage + '?p=e&d=' + new Date().getTime(),
            success: function (data) {
                _this._handleSuccess(data);
            },
            error: function (XMLHttpRequest, textStatus, errorThrown) {
                ReconAnimationUtils.updateRelinkInfo(3, '与服务器连接故障，请稍候重试');
            }
        });
    },

    // 设置定时监测
    _isErroring: false,  //是否检测到服务器故障
    _monitoringHandle: null,  //监测服务器状态定时器
    _initMonitoring: function () {
        var _this = this;
        if (!_this._isErroring) {
            _this._exeAjax();
            clearInterval(_this._monitoringHandle);
            _this._monitoringHandle = setInterval(function () {
                _this._exeAjax();
                console.log('检查服务器状态 ' + new Date());
            }, _this.option.commonMonitoringTime);
        }
    },

    _reLinking: false,  //是否正在重连
    _reLinkHandle: null,  //正在重连定时器
    _sysRelinkMsgShowHandle: null,  //系统重连时提醒信息更新定时器
    _initReLink: function () {
        var _this = this;
        _this._reLinking = true;
        clearTimeout(_this._reLinkHandle);
        _this._reLinkHandle = setTimeout(function () {
            _this._exeAjax(); //第一次先执行一次
            _this._reLinkHandle = setTimeout(arguments.callee, _this.option.reLinkTime);
        }, _this.option.reLinkTime);
    },

    // 设置系统重连时信息展示
    _setSysRelinkMsgShowHandle: function () {
        var _this = this;
        var time = 30;
        var count = 1;
        ReconAnimationUtils.updateRelinkInfo(0, '与服务器连接中断<br/><span>' + time + '</span>秒之后进行第<span>1</span>次连接');
        time--;
        _this._sysRelinkMsgShowHandle = setInterval(function () {
            if (!_this._hasHandWorked) {
                var mm = time;
                if (time < 10) {
                    mm = '0' + time
                }
                var msg = '与服务器连接中断<br/><span>' + mm + '</span>秒之后进行第<span>' + count + '</span>次连接';
                ReconAnimationUtils.updateRelinkInfo(0, msg);
                time--;
                if (time == 0) {
                    time = 30;
                    count++;
                }
            }
        }, 1000);
    },
    _clearSysRelinkMsgShowHandle: function () {
        clearInterval(this._sysRelinkMsgShowHandle);
        this._sysRelinkMsgShowHandle = null;
    },

    // 执行服务器状态监测或重连
    _exeAjax: function () {
        var _this = this;
        var serverUrl = _this.option.serverPage + '?d=' + new Date().getTime() + "&from=pc";
        serverUrl += _this._isErroring ? '&p=e' : '&p=n';
        $.ajax({
            url: serverUrl,
            success: function (data) {
                _this._handleSuccess(data);
            },
            error: function (XMLHttpRequest, textStatus, errorThrown) {
                //  _this._handleError();
                console.info(thrownError);
            }
        });
    },
    // 通用ajax重连成功处理
    _handleSuccess: function (data) {
        var _this = this;
        // 其他客户端上线，提示退出
        if (!_this._isErroring && data == 'RepeatLanding') {
            _this._isErroring = true;
            M_ISFORCEONLINE = true;
            DragUtils.closeDrags();
            currentWindow.show();
            Dialog.confirm('用户在其他地方登陆，点击重连重新登录', function () {
                $.ajax({
                    global: false,
                    async: false,
                    url: _this.option.serverPage + '?d=' + new Date().getTime(),
                    data: {
                        from: 'pc',
                        sessionkey: GLOBAL_INFOS.sessionKey,
                        pcReLogin: 'true',
                        userid: M_USERID
                    },
                    success: function (data) {
                        M_ISFORCEONLINE = false;
                        client && client.reconnect();
                        DragUtils.restoreDrags();
                        _this._isErroring = false;
                    },
                    error: function () {
                        Dialog.alert('重连失败，服务器异常，请重新登录', function () {
                            PcMainUtils.logout();
                        });
                    }
                });
            }, function () {
                PcMainUtils.quitApp();
            }, null, null, true, null, '重连', '退出');
        }
        else if (!_this._isErroring && data == 'reConnectError') {
            _this._isErroring = true;
            DragUtils.closeDrags();
            Dialog.alert('服务端重连异常，点击确定退出', function () {
                PcMainUtils.quitApp();
            });
        }
        else if (_this._reLinking && _this._isErroring) {
            // 取消重连
            clearInterval(_this._reLinkHandle);
            _this._reLinking = false;
            _this._reLinkHandle = null;

            // 恢复状态
            _this._clearSysRelinkMsgShowHandle();
            _this._hasHandWorked = false;
            // 恢复监测
            _this._isErroring = false;
            _this._initMonitoring();
            TrayUtils.restoreTray();
            // 关闭遮罩提示  TODO
            ReconAnimationUtils.close();
            // 恢复和融云的连接
            M_ISFORCEONLINE = false;
            client && client.reconnect();
            currentWindow.requestAttention(true);
        }
    },

    // 通用ajax错误处理
    _handleError: function () {
        var _this = this;
        if (!_this._isErroring && !_this._reLinking) {
            // 关闭监测
            _this._isErroring = true;
            clearInterval(_this._monitoringHandle);
            _this._monitoringHandle = null;
            TrayUtils.offlineTray();
            // 打开遮罩提示  TODO
            ReconAnimationUtils.showRelink();
            // 设置信息提醒
            _this._setSysRelinkMsgShowHandle();

            // 开始重连
            _this._initReLink();

            // 关闭和融云的连接
            M_ISFORCEONLINE = true;
            client && client.disconnect();
            currentWindow.requestAttention(true);
        }
    }
};

// 断线展示效果工具
var ReconAnimationUtils = {
    _config: {
        type_1: '/offline-1.png',  //系统重连时图片
        type_2: '/offline-2.png',  //手工重连中图片
        type_3: '/offline-3.png',  //手工重连失败时图片
        type_1_data: '',
        type_2_data: '',
        type_3_data: ''
    },

    // 打开重连界面效果
    showRelink: function (reLinkcb) {
        var html = '<div class="pc-recon can-drag">';
        html += '    <div class="pc-recon-message no-drag">';
        html += '        <div class="header">连接故障</div>';
        html += '        <div class="center">';
        html += '            <div class="center-img"><img src="" /></div>';
        html += '            <div class="center-msg"></div>';
        html += '        </div>';
        html += '         <div class="footer">';
        html += '            <input type="button" class="task-relink" value="重连" />';
        html += '            <input type="button" class="task-close" value="退出" />';
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
        } else if(type == 2) {
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
    getDataUrl: function (imgFile) {
        var localImagesDir = node_path.join(GLOBAL_INFOS.appPath, '/web_contents/images');
        var nativeImage = 'file://' + localImagesDir + imgFile;
        return nativeImage;
    }
};

// 外部链接：首页、邮件、博客等的打开（调用本地浏览器打开url）
var PcExternalUtils = {
    // urlType :连接类型
    //0 站内链接（拼oa地址）；1 站外链接（无需拼接）；2 单点登录（暂时不管）
    openUrlByLocalApp : function(url, urlType){
        if(!url) return;
        urlType = urlType || 0;
        var finalUrl = null;
        var querystring = window.require('querystring');
        var host = GLOBAL_INFOS.currentHost;
        var sessionkey = GLOBAL_INFOS.sessionKey;
        if(urlType == 0) {
            finalUrl = host + '/social/im/epcforword.jsp?';
            finalUrl += 'from=pc&external=true&sessionkey=' + sessionkey;
            finalUrl += '&url=' + querystring.escape(url);
        }
        else if(urlType == 1) {
            if(url.substring(0, 4).toLowerCase() !== 'http') {
                finalUrl = 'http://' + url;
            } else {
                finalUrl = url;
            }
        }
        else if (urlType == 2) {
            var newurl = '/interface/Entrance.jsp?id=' + querystring.escape(url)
            finalUrl = host + '/social/im/epcforword.jsp?';
			finalUrl += 'from=pc&external=true&sessionkey=' + sessionkey;
            finalUrl += '&url=' + querystring.escape(newurl);
        }
        if(finalUrl) {
            if(urlType != 1) {
                ServerExceptionHandling._exeAjax();  //如果是打开内部链接，先发送服务器执行一次更新事件
            }
            setTimeout(function () {
                    var shell = nwgui.Shell;
                    shell.openExternal(finalUrl);
                }, 200);
        }
    }
};

// 主聊天窗口任务栏进度展示工具
var ProgressBarUtils = {
    _currentWin :currentWindow,
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
// PC下载工具
var PcDownloadUtils = {
    creatNewDownload: function (data) {
        var _this = this;
        if (_this.eDownloadList[data.url]) {
            return;
        }
        _this.startDownload(data);
    },
    eDownloadList : {},  // 正在下载的文件
    eDownload : window.require('ding-download').Download,
    imDownloader : null,
    // 开始一个下载任务
    startDownload : function(config){
        console.log('启动一个新下载');
        var _this = this;
        try {
            var dlUrl = config.url;
            var filePath = config.filePath;
            var querystring = window.require('querystring');
            var fileid = querystring.parse(dlUrl.substring(dlUrl.indexOf('?') + 1))['fileid'];
            var item = config.item;
            var fileSize = (config.size == 0 || typeof config.size === "undefined") ? _this._getfileSize(fileid) : config.size;
            TrayUtils.showTrayBalloon('正在下载文件...', filePath);
            var sessionkey = GLOBAL_INFOS.sessionKey;
            var finalUrl = dlUrl + '&from=pc&op=download&sessionkey=' + sessionkey;
            var newDlObj = null;
            try{
                if(!_this.imDownloader){
                    _this.imDownloader = window.require('downloader');
                }
                newDlObj = new _this.imDownloader();
             }catch (e){
                newDlObj = null;
                console.error(e);
            }
            if(newDlObj){//新下载组件
                newDlObj.on('done', function(msg, status) {
                    // console.log('done===========',msg);
                    FileDownloadViewUtils.setButton(fileid, filePath,fileSize);
                    _this._endDownload(dlUrl, filePath);
                    FileDownloadViewUtils.updateViewProgressBar(fileid, 1);
                    if(status === 'aborted') {
                        TrayUtils.showTrayBalloon(social_i18n('Dltip9'), filePath);
                        FileDownloadViewUtils.updateViewProgressBar(fileid, -1);
                        FileDownloadViewUtils.restoreButton(fileid);
                    } else {
                        TrayUtils.showTrayBalloon(social_i18n('Dltip7'), filePath);
                        // 保存路径到服务端
                        _this.recordLastsavepath(fileid, filePath);
                    }
                });
                newDlObj.on('error', function(error) {
                    console.log('error===========',error);
                    if(error && error.code == 'EPERM'){
                        _this._endDownload(dlUrl, filePath);
                        _this.willdownload(item, false, true);
                        alert(social_i18n("Dltip11"));
                    }else{
                        _this._endDownload(dlUrl, filePath);
                        TrayUtils.showTrayBalloon(social_i18n('Dltip8'), filePath);
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
            }else {
                newDlObj = new _this.eDownload(finalUrl, filePath);
                newDlObj.contentSize = parseInt(fileSize);
                newDlObj.on('info', function(arg1){
                    //console.debug('fileid = ' + fileid + '   info = ' + arg1);
                    ProgressBarUtils.setToIndeterminateMode();
                });
                newDlObj.on('progress', function(arg1, arg2, arg3){
                    //console.log('progress = ' + arg1 + '   ' + arg2 + '  ' + arg3);
                    ProgressBarUtils.setPb(arg1);
                    FileDownloadViewUtils.updateViewProgressBar(fileid, arg1);
                });
                newDlObj.on('finish', function (arg1, arg2, arg3) {
                    //console.debug('fileid = ' + fileid + '    finish');
                    FileDownloadViewUtils.setButton(fileid, filePath);
                    _this._endDownload(dlUrl);
                    TrayUtils.showTrayBalloon('文件下载完成', filePath);
                    // 保存路径到服务端
                    _this.recordLastsavepath(fileid, filePath);
                });
                newDlObj.on('error', function (error) {
                    //console.debug('fileid = ' + fileid + '    error');
                    console.info(error);
                    // error
                    if (error && error.code == 'EPERM') {
                        alert("您没有该目录的操作权限");
                        _this._endDownload(dlUrl);
                        _this.willdownload(item, false, true);
                    } else {
                        _this._endDownload(dlUrl);
                        TrayUtils.showTrayBalloon('文件下载失败', filePath);
                        PcExternalUtils.openUrlByLocalApp(finalUrl,0);
                        FileDownloadViewUtils.updateViewProgressBar(fileid, -1);
                        FileDownloadViewUtils.restoreButton(fileid);
                    }
                });
                _this.eDownloadList[dlUrl] = { fileid: fileid, dlObj: newDlObj };
            }
        } catch (e) {
            console.log(e);
            _this._endDownload(config.url);
            PcExternalUtils.openUrlByLocalApp(finalUrl,0);
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
    _endDownload : function(dlUrl){
        this._sendDlComplete(dlUrl);
        delete this.eDownloadList[dlUrl];
        delete this.DownloadItems[dlUrl];
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
       delete this.DownloadItems[dlUrl];
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
    // 初始化下载设置
    willdownload: function (item, isDefPath, isResetPath) {
        var url = item.url;
        var filename = item.filename;
        var fileSize = item.totalbytes;
        var _this = this;
        if (_this.DownloadItems[url]) {
            Dialog.alert('该文件正在下载');
            return;
        }
        var downloadConfig = PcSysSettingUtils.getConfig().download;
        var defaultDlPath = downloadConfig.defaultPath, nonePath = false;
        if (!defaultDlPath || defaultDlPath == '') {
            // 路径为空时，走else代码逻辑，并在点击确定时提示是否设置当前目录为默认下载目录
            nonePath = true;
        }
        if (isDefPath && !nonePath && !isResetPath) {
            // 如果配置了默认保存路径，那么不弹出保存对话框，直接保存文件到默认路径。
            var fse = require('fs-extra');
            var index = filename.lastIndexOf('.');
            var name = PcMainUtils.isWindows() ? filename.substring(0, index) : filename;
            var ext = filename.substring(index);
            fse.ensureDir(defaultDlPath, function (err) {
                if (err) {
                    console.error("当前默认路径已失效且没有创建文件夹权限，请重新设置默认文件传输路径", err)
                    _self.willdownload(item, isDefPath, true);
                    return true;
                };
                var dlObj = {
                    url: url,
                    filePath: node_path.join(defaultDlPath, filename),
                    ext: ext,
                    size: fileSize
                };
                // 检测文件是否存在
                PcMainUtils.isExistFile(dlObj.filePath, function (flag) {
                    if (flag) {
                        Dialog.confirm('文件已存在，是否覆盖本地文件？', function () {
                            _this.creatNewDownload(dlObj);
                            _this.DownloadItems[url] = true;
                        });
                    } else {
                        _this.creatNewDownload(dlObj);
                        _this.DownloadItems[url] = true;
                    }
                });
            });
        } else {
            var index = filename.lastIndexOf('.');
            var name = PcMainUtils.isWindows() ? filename.substring(0, index) : filename;
            var ext = filename.substring(index);
            nwdialog.setContext(document.getElementById("downloadFrame").contentWindow.document);
            nwdialog.saveFileDialog(filename, ext, function (filepn) {
                if (filepn) {
                    var dlObj = {
                        url: url,
                        filePath: filepn,
                        ext: ext,
                        size: fileSize
                    };
                    _this.creatNewDownload(dlObj);
                    _this.DownloadItems[url] = true;
                }
                if (nonePath || isResetPath) {
                    Dialog.alert('请到右下角设置界面设置文件传输目录再使用此功能！');
                }
            })
        }
    }
};

// 下载文件时 进度条 及 按钮设置
var FileDownloadViewUtils = {
    // 更新下载进度条
    updateViewProgressBar : function(fileid, progress){
        var $fileDiv = $('div.accitem[_fileid="' + fileid + '"]');
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
                }
            }
        }
    },
    setButtonCon: function(container,fileid,filepath){
    	var _this = this;
    	var $fileBtn = container.hasClass("opdiv")? container: container.find('a.opdiv[_fileid="' + fileid + '"]');
    	var filename = $fileBtn.attr('_filename');
        var optiondiv = $fileBtn.parent();
        
        var opendir = $("<a>打开文件夹</a>");
        var openfile = $("<a>打开文件</a>");
        
        opendir.attr(
        	{
        		'id': 'pc-opendir' + fileid, 
        		'class': 'opdir opdiv',
        		'_fileid':fileid,
        		'_filename':filename
        	}).css('cursor','pointer').click(function(){
                _this.openFilepath(fileid, filepath, 0);
            });
            
        openfile.attr(
        	{
        		'id': 'pc-openfile' + fileid, 
        		'class': 'opfile opdiv pc-openfile', 
        		'_fileid': fileid,
        		'_filename': filename
        	}).click(function(){
                _this.openFilepath(fileid, filepath, 1);
            });
        optiondiv.empty().append(openfile).append(opendir);
        return container;
    },
    // 下载完成，设置'下载'按钮为'打开文件'和'打开文件夹'
    setButton : function(fileid, filepath){
        var _this = this;
        var $fileBtn = $('a.opdiv[_fileid="' + fileid + '"]');
        if($fileBtn.length == 0) {
       		return;
        }
        
        _this.setButtonCon($fileBtn, fileid, filepath);
    },
    // '打开文件'，'打开文件夹'按钮事件
    openFilepath : function(fileid, filepath, openFile){
        var _this = this;
        const fs = require('fs');
        fs.exists(filepath, function (exists) {
 		const shell = nwgui.Shell;
            if(exists) {
                if(openFile) {
                    shell.openItem(filepath);
                } else {
                    shell.showItemInFolder(filepath);
                }
            } else {
            	if(openFile){
            		showImAlert('文件不存在，请重新下载');
            	}else{
            		showImConfirm('文件不存在，是否继续打开文件夹？', function(){
            			shell.showItemInFolder(filepath);
            		});
            	}
                _this.restoreButton(fileid);
            }
        });
    },
    // 恢复按钮为'下载'
    restoreButton : function(fileid){
        var $fileBtn = $('a.opfile[_fileid="' + fileid + '"]');
        var $fileDir = $('a.opdir[_fileid="' + fileid + '"]')
        if($fileBtn.length > 0) {
            $fileBtn.unbind('click').click(function(){
                downAccFile(this, true);
            }).html('接收');
        }
        
        if($fileDir.length > 0) {
            $fileDir.unbind('click').click(function(){
                downAccFile(this);
            }).html('另存为');
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
        type_1_data: '',
    },
    // 打开重连界面效果
    showRelink : function(){
        var _this = this;
        var html = '<div class="pc-recon can-drag">';
           html += '    <div class="pc-recon-message no-drag">';
           html += '        <div class="header">连接故障</div>';
           html += '        <div class="center">';
           html += '            <div class="center-img"><img src="" /></div>';
           html += '            <div class="center-msg">连接e-message-xp服务器故障<br/><span id="rong-recon-s1">5</span>秒之后进行第<span id="rong-recon-s2">1</span>次连接</div>';
           html += '        </div>';
           html += '         <div class="footer">';
           html += '            <input type="button" class="rong-task-close" value="退出" />';
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
                rtime = _this.reConTimeout;
                $rongspn1.html(rtime);
                $rongspn2.html(++rcount);
            }
        }, 1000);        
        $('.pc-recon').fadeIn(500);
    },
    close: function(){
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
                if(PcMainUtils.isWindows()) {
                    flag = _this.nowVersion.buildVersion == data.buildversion;
                } else if(PcMainUtils.isOSX()) {
                    flag = _this.nowVersion.osxBuildVersion == data.osxBuildVersion;
                }
                if( !flag ) {
                    _this.isReminding = true;
                    clearInterval(_this.execHandle);
                    
                    var obj = {
                        currentHost : GLOBAL_INFOS.currentHost,
                        sessionKey : GLOBAL_INFOS.sessionKey,
                        newBuildVersion : {
                            buildVersion : data.buildversion,
                            osxBuildVersion : data.osxBuildVersion
                        }
                    };
                    DragUtils.closeDrags();
                    Dialog.alert('检测到有新版本，点击确定进行升级', function(){
                        PcMainUtils.localconfig.setLogoutThenUpgrade(obj, function(){
                            PcMainUtils.logout();
                        });
                    });
                }
            }
        });
    }
};

// userConfig
var PcSysSettingUtils = {
    _configs : null,
    // 初始化配置信息
    init : function(callback){
        var _this = this;
        var localconfig = nwgui.global.GLOBAL_INFOS.userConfig;
        // 对本地特殊设置的处理
        var autoLogin = localconfig.login.autoLogin;
        $.post('/social/im/SocialImPcUtils.jsp', { method : 'getUserSysConfig', osType : PcMainUtils.getOSType() }, function(data){
            if(data.isSuccess) {
                _this._configs = $.extend(localconfig, data.config);
                // 一些特殊值以客户端为准
                _this._configs.login.autoLogin = localconfig.login.autoLogin;
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
    saveConfig: function (config, callback) {
        var _this = this;
        var cb = typeof callback === 'function' ? callback : function () { };
        //保存到本地
        PcMainUtils.setSetting(config);
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
        var win = currentWindow;
        win.show();
        win.focus();
    }
}
/*--------------------------------  app  start  --------------------------------*/
/*--------------------------------  消息提醒小窗口工具  start  --------------------------------*/
var AppTipWindowUtil = {
    _currentTipWindow: null,
    _messageQueue: new Array(),  // 提醒消息队列
    _pushInQueue: function (args) {
        this._messageQueue.unshift(args);
    },
    _popFromQueue: function () {
        return this._messageQueue.pop();
    },
    // 初始化提醒窗口
    initAppTipWindow: function (data) {
        var primaryDisplay = nwgui.Screen.screens.length > 0 ? nwgui.Screen.screens[0] : null;
        var winWidth = appConfig.windowSize.appTipWin.width;
        var winHeight = appConfig.windowSize.appTipWin.height;
        var offsetX = primaryDisplay.work_area.width - winWidth;
        var offsetY = primaryDisplay.work_area.height - winHeight;
        var _this = this;
        var appTipWindowoption = {
            width: winWidth,
            height: winHeight,
            x: offsetX - 20,  // 额外加边距,
            y: offsetY,
            focus: true,
            resizable: false,
            frame: false,
            transparent: GLOBAL_INFOS.isAeroGlassEnabled
        };
        var htmlFile = '/web_contents/remind/remind.html';
        //document-start 不适用本地页面
        appTipWindow = nwgui.Window.open(htmlFile, appTipWindowoption, function (win) {
            win.window.remindData = data;
            win.setShowInTaskbar(false);
            win.setAlwaysOnTop(true);
            if(GLOBAL_INFOS.isMinVersion){
                win.window.opener = window;
            }  
            win.on('loaded', function () {
                _this._currentTipWindow = win.window;
            });
            win.on('closed', function (event) {
                _this._currentTipWindow = null;
                if (_this._messageQueue.length > 0) {
                    setTimeout(_this._executeShow(), 1000 * 3)
                }
            });
        });
        // 注册 打开工具栏快捷键
        // registerWindowShortcut(appTipWindow);
    },
    // 打开提醒窗口
    showAppTipWindow: function (args) {
        var _this = this;
        //加入消息
		_this._pushInQueue(args);
			if(!this._currentTipWindow&&_this._messageQueue.length == 1) {
				_this._executeShow();
			}
	},
	// 如果还有队列，3秒后打开下一条提醒。
	showNextTip : function(){
		var _this = this;
		if(_this._messageQueue.length > 0) {
			setTimeout(function(){
				_this._executeShow();
			}, 1000 * 3);
		}
	},
    //展示消息，并去掉最后一个
    _executeShow: function () {
        var _this = this;
        _this.initAppTipWindow(_this._popFromQueue());
    }
};
/*--------------------------------  消息提醒小窗口工具  end  --------------------------------*/
var nwdialog = {

    _context: typeof global.DOMDocument === 'undefined' ? document : global.DOMDocument,

    setContext: function(context) {
        this._context = context;
    },

    openFileDialog: function(filter, multiple, workdir, callback) {

        var fn          = callback;
        var node        = this._context.createElement('input');
        node.type       = 'file';
        node.id         = 'open-file-dialog';
        node.style      = 'display: none';

        if (typeof filter === 'function') {
            fn = filter;
        } else if (typeof filter === 'string') {
            node.setAttribute('accept', filter);
        } else if (typeof filter === 'boolean' && filter === true) {
            node.setAttribute('multiple', '');
        } else if (this.isArray(filter)) {
            node.setAttribute('accept', filter.join(','));
        }

        if (typeof multiple === 'function') {
            fn = multiple;
        } else if (typeof multiple === 'string') {
            node.setAttribute('nwworkingdir', multiple);
        } else if (typeof multiple === 'boolean' && multiple === true) {
            node.setAttribute('multiple', '');
        }

        if (typeof workdir === 'function') {
            fn = workdir;
        } else if (typeof workdir === 'string') {
            node.setAttribute('nwworkingdir', workdir);
        }

        this._context.body.appendChild(node);
        node.addEventListener('change', function(e) {
            fn(node.value);
            node.remove();
        });
        node.click();

    },

    saveFileDialog: function(name, accept, directory, callback) {
        
        var fn          = callback;
        var node        = this._context.createElement('input');
        node.type       = 'file';
        node.id         = 'save-file-dialog';
        node.style      = 'display: none';
        node.setAttribute('nwsaveas', '');

        if (typeof name === 'function') {
            fn = name;
        } else if (typeof name === 'string') {
            node.setAttribute('nwsaveas', name);
        }

        if (typeof accept === 'function') {
            fn = accept;
        } else if (typeof accept === 'string') {
            node.setAttribute('accept', accept);
        } else if (this.isArray(accept)) {
            node.setAttribute('accept', accept.join(','));
        }

        if (typeof directory === 'function') {
            fn = directory;
        } else if (typeof directory === 'string') {
            node.setAttribute('nwworkingdir', directory);
        }

        this._context.body.appendChild(node);
        node.addEventListener('change', function() {
            fn(node.value);
            node.remove();
        });
        node.click();

    },

    folderBrowserDialog: function(workdir, callback) {
        var fn          = callback;
        var node        = this._context.createElement('input');
        node.type       = 'file';
        node.id         = 'folder-browser-dialog';
        node.style      = 'display: none';
        node.nwdirectory= true;

        if (typeof workdir === 'function') {
            fn = workdir
        } else if (typeof workdir === 'string') {
            node.setAttribute('nwworkingdir', workdir);
        }
        this._context.body.appendChild(node);
        node.addEventListener('change', function() {
            fn(node.value);
            node.remove();
        });
        node.click();
    },

    isArray: function(value) {
      return Object.prototype.toString.call(value) === '[object Array]';
    }

};
/*--------------------------------  图片浏览窗口  start  --------------------------------*/
var ImageViewPageUtil = {
    _currentTipWindow: null,
    initImageViewPage: function (imgInfos) {
        var _this = this;
        var screenSize = nwgui.Screen.screens.length > 0 ? nwgui.Screen.screens[0].bounds : null;
        var imageViewWindowoption = {
            width: Math.round(screenSize.width * 0.8),
            height: Math.round(screenSize.height * 0.8),
            focus: true,
            position: 'center',
            resizable: false,
            frame: false,
            transparent: GLOBAL_INFOS.isAeroGlassEnabled
        };
        var url = GLOBAL_INFOS.currentHost + '/social/im/imageReview-nw.jsp?from=pc&frompc=true';
        nwgui.Window.open(url, imageViewWindowoption, function (win) {
            win.on("document-start", function () {
                _this._currentTipWindow = win;
                if(GLOBAL_INFOS.isMinVersion){
                    win.window.opener = window;
                }                
            })
            win.on('closed', function (event) {
                _this._currentTipWindow = null;
            });
            win.on('loaded', function () {
                _this._currentTipWindow = win.window;
                win.window.pluginImageViewHtmlFile(imgInfos);
            });
        });
    },
    showImageViewWindow: function (imgInfos) {
        var _this = this;
        if (_this._currentTipWindow == null) {
            _this.initImageViewPage(imgInfos);
        } else {
            _this._currentTipWindow.pluginImageViewHtmlFile(imgInfos);
        }
    }
};
/*--------------------------------  图片浏览窗口  end  --------------------------------*/
// 
// 全局快捷键相关
var GlobalShortMethods = {
    SCREENSHOT: 'screenshot',
    OPENDEVPTOOL: 'openDevpTool',
    OPENANDHIDEWIN: 'openAndHideWin',
    CLOSEALLCHATWIN: 'closeAllChatWin',
    CLOSECHATWIN: 'closeChatWin'
};
var PcGlobalShortcutUtils = {
    // 初始化
    init: function () {
        var _this = this;
        var userConfig = PcSysSettingUtils.getConfig();
        if (PcMainUtils.isWindows()) {
            
            var screenshot = userConfig.shortcut.screenshot;
            GlobalShortcutUtils.register(screenshot, screenshot, GlobalShortMethods.SCREENSHOT);
            pcWindowConfig.shortcut.screenshot = screenshot;
            _this.setScreenshotTitle();
        }
        var openAndHideWin = userConfig.shortcut.openAndHideWin;
        GlobalShortcutUtils.register(openAndHideWin, openAndHideWin, GlobalShortMethods.OPENANDHIDEWIN);
    },
    setScreenshotTitle: function () {
        if (PcMainUtils.isWindows() && pcWindowConfig.shortcut.screenshot) {
            $('[type="screenshot_div"]').attr('title', '截图（' + pcWindowConfig.shortcut.screenshot + '）');
        }
    },
    isRegistered: function (screenshotNew) {
        return (GLOBAL_INFOS.userConfig.shortcut.screenshot == screenshotNew) || (GLOBAL_INFOS.userConfig.shortcut.openAndHideWin == screenshotNew);
    },
    // 执行注册，注册成返回true，冲突或失败返回false
    execRegister : function(oldKey, newKey, execMethodName){
        GlobalShortcutUtils.register(oldKey, newKey, execMethodName);
    }
};
/*--------------------------------  注册快捷键       start  --------------------------------*/
var shortCut = {
    key: "CTRL+Q",
    active: function () {
    },
    failed: function (msg) {
        console.log(msg);
    }
};
var GlobalShortcutUtils = {
    // 注册快捷键
    register: function (oldKey, newKey, methodName) {
        try {
            if (!methodName || !GlobalShortcutUtils[methodName] || !newKey) {
                return false;
            }
            if (oldKey) {
                this.unRegister(oldKey);
            }
            if (newKey) {
                shortCut.key = newKey;
                shortCut.active = function () {
                    GlobalShortcutUtils[methodName].apply(null, []);
                };
                nwgui.App.registerGlobalHotKey(nwgui.Shortcut(shortCut));
            }
            return true;
        } catch (e) {
            console.info(e);
            return false;
        }
    },
    // 移除快捷已被注册
    unRegister: function (accelerator) {
        nwgui.App.unregisterGlobalHotKey(nwgui.Shortcut({ key: accelerator }));
    },
    // 截图
    screenshot: function () {
        ScreenshotUtils.screenshot();
    },
    // 呼入和隐藏聊天窗口
    openAndHideWin: function () {
        var chatWin = currentWindow;
        if (chatWin) {
            if (focusFlag) {
                chatWin.hide();
            } else {
                chatWin.show();
            }
        }
    },
    // 打开调试工具
    openDevpTool: function () {
        // 只有在sdk的情况有用
        currentWindow.showDevTools();
    },
       // 关闭所有聊天窗口
       closeAllChatWin: function() {
        var chatWin = currentWindow;
        if (chatWin) {
            var chatWin = currentWindow;
            if (chatWin &&focusFlag) {
              ChatWinUtils.closeallchatwin();
            }
        }
    },
    // 关闭聊天窗口
    closeChatWin: function() {
        var chatWin = currentWindow;
        if (chatWin &&focusFlag) {
          ChatWinUtils.closeChatWin();
        }
    }
};
/*--------------------------------  注册快捷键       end  --------------------------------*/
// 抖动窗口
var ShakeWindowUtils = {
    loginTime: new Date().getTime(),
    lastShakeTime: {},  // 给不同的人抖动要单独计时
    dwellTime: 1000 * 10,  //抖动间隔，10秒钟
    sendShakeMessage: function (obj) {
        var _this = this;
        var nowTime = new Date().getTime();
        var $chatWin = ChatUtil.getchatwin(obj);
        var toUserId = $chatWin.attr('_targetid');

        if (!_this.lastShakeTime[toUserId] || (nowTime - _this.lastShakeTime[toUserId] > _this.dwellTime)) {
            var msgid = IMUtil.guid();
            var sendTime = new Date().getTime();
            var data = {
                pushType: 'weaver_shakeMsg',
                objectName: 'FW:CustomMsg',
                msgType: 6,
                sendTime: sendTime,
                targetid: toUserId,
                targetType: 'FW:CustomMsg'
            };
            ChatUtil.sendIMMsg($chatWin.find(".chatSend"), data.msgType, data, function (msg) {
                if (msg.issuccess == 1) {
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
    shakeWindow: function (showWindow, extraObj, senderInfo) {
        var win = currentWindow;
        if (showWindow) {
            var pushType = extraObj.pushType;
            if (pushType != 'weaver_shakeMsg') {
                return;
            }
            var sendTime = extraObj.sendTime;
            var senderUserid = senderInfo.userid;
            if (sendTime - this.loginTime < 1000 * 60 * 60 * 24) {
                win.show();
                win.focus();
                $('#conversation_' + senderUserid).click();
            }
        }
        clearInterval(timer);
        var i = 0;
        var timer = setInterval(function () {
            i++;
            win.x = win.x + ((i % 2) > 0 ? -7 : 7);
            //win.setBounds(tempBounds);
            if (i >= 10) {
                clearInterval(timer);
            }
        }, 60);
        this._playShakeAudio();
    },
    _playShakeAudio: function () {
        var playAudio = true;
        // pc端，更具配置判断是否有提示音
        var config = PcSysSettingUtils.getConfig();
        if (config.msgAndRemind.audioSet.all) {
            playAudio = false;
        }

        if (playAudio) {
            var audio = document.getElementById('pcShakeWinAudio');
            //audio.play();
        }
    }
};

/*--------------------------------  桌面通知 气泡start   --------------------------------*/
// NW.JS Notification气泡
var showNotification = function (title, body) {
    //   if (icon && icon.match(/^\./)) {
    //     icon = icon.replace('.', 'file://' + process.cwd());
    //   }
    var notification = new Notification(title, { body: body });
    notification.onclick = function () {

    };
    notification.onclose = function () {

    };
    notification.onshow = function () {

    };
    return notification;
}
/*--------------------------------  桌面通知 气泡end   --------------------------------*/
/*--------------------------------  app  end  --------------------------------*/
/*--------------------------------  聊天窗口工具  --------------------------------*/
var ChatWinUtils = {
    /* 
    *关闭所有会话窗口
    */
    closeallchatwin:function(){
        var self = this;
        	DragUtils.closeDrags();
        	var closeBtns = $('#chatIMTabs').find('.tabClostBtn');
        	var len = closeBtns.length;
        	if(len > 0) {
        		if(self.isShowing) return;
        		self.isShowing = true;
        		Dialog.confirm('是否关闭所有聊天窗口?', function(){
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
    },
    /*
    *关闭当前会话窗口 
    */
    closechatwin:function(){
        var self = this;
        DragUtils.closeDrags();
        var closeBtns = $('#chatIMTabs').find('.tabClostBtn');
        var len = closeBtns.length;
        if(len > 0) {
            if(self.isShowing) return;
            self.isShowing = true;
            Dialog.confirm('是否关闭所有聊天窗口?', function(){
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
    },	
    closeChatWinBatch: function(busyWinIds, allWinIds){
    	var self = this;
    	if(busyWinIds.length > 0) {
			var nextWinId = busyWinIds.pop();
			changeTabWin($('#chatIMTabs').find("[_chatwinid='"+nextWinId+"']").get(0));
			IMUtil.removeArray(allWinIds, nextWinId);
			self.isShowing = true;
			PcMainUtils.showConfirm('当前窗口正在操作，是否强制关闭?', null, {
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
var windowUtil = {
	_isAlwaysOnTopFlag: false,//标识
	_currentWin: currentWindow,
	_isAlwaysOnTop: function(){
		return this._currentWin.isAlwaysOnTop;
	},
	_hide:function(){
		this._currentWin.hide();
	},
	_show:function(){
		this._currentWin.show();
	}
}
/*--------------------------------  重连工具start  --------------------------------*/
/* 
*网络监测工具
*/
var NetworkListenerUtils ={
    //打开手动重连
    _showHandleRelink:function(){
        ReconAnimationUtils.showRelink(this._handleConnect);
        ReconAnimationUtils.updateRelinkInfo(3, '连接emessage故障');
    },
    //手动重连
    _handleConnect:function(){
         ReconAnimationUtils.updateRelinkInfo(2, '正在尝试建立连接...');
         getTokenOfOpenfire(function(data){
             if(!data == ""){                 
                M_ISFORCEONLINE = false;
                client && client.reconnect(function(info){
					if(!info){
                        ReconAnimationUtils.updateRelinkInfo(3, '连接emessage故障');
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
    }
}
/*--------------------------------  重连工具end  --------------------------------*/
/*--------------------------------  聊天窗口工具  --------------------------------*/
//xp版本不做窗口分离
var WindowDepartUtil = {
    isAllowWinDepart : function(){
        return false;
    },
    tabIsNull : function(){
        return false;
    }
};
