var pcWindowConfig = {
    winMax: false,
    shortcut : {
        screenshot : null
    }
};

var appPath = window.Electron.ipcRenderer.sendSync('global-getAppPath'),
node_path = window.Electron.require('path');
var localconfig = window.Electron.require(node_path.join(appPath, './localconfig.js'));
var pcUtils = window.Electron.require(node_path.join(appPath, './pcUtils.js'));

var PcMainUtils = {
    userInfos : window.Electron.ipcRenderer.sendSync('global-getUserInfos'),
    appPath : appPath,
    node_path : node_path,
    platform : window.Electron.ipcRenderer.sendSync('global-getPlatform'),
    localconfig : localconfig,
    pcUtils : pcUtils,
    
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
    // 显示提示框
    showMsg: function(msg, win){
        var dialog = window.Electron.remote.dialog;
        var currentWindow =window.Electron.currentWindow;
        dialog.showMessageBox(win?win:currentWindow, {
            type: 'info',
            title : '提示',
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
            title : '提示',
            message : msg,
            buttons : ['确认','取消'],
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
        }catch(err){
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
            //ChatUtil.isScreenShotMinimize = typeof _this._configs.isScreenShotMinimize ==='undefined'?0:_this._configs.isScreenShotMinimize;
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
            execMethodName : execMethodName || null,
        };
        return window.Electron.ipcRenderer.sendSync('globalshortcut-slave', reObj);
    },
    setScreenshotTitle : function(){
        if (PcMainUtils.isWindows() && pcWindowConfig.shortcut.screenshot) {
            $('[type="screenshot_div"]').attr('title' ,'截图（' + pcWindowConfig.shortcut.screenshot + '）');
        }
    }
};

// 获取配置信息
    PcSysSettingUtils.init(function(){
        // 注册全局快捷键
        PcGlobalShortcutUtils.init();
    });
 
// 检查更新
var  UpdateChecker = {
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

function pcSendLogout() {
    // 设置pc端为未登陆状态。
    $.ajax({
        async : false,
        url : '/social/im/ServerStatus.jsp?p=logout',
        timeout : 200
    });
}

