<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
    <head>
        <title><%=SystemEnv.getHtmlLabelName(774, user.getLanguage())%></title><!-- 系统设置 -->
        <link rel="stylesheet" href="/social/css/im_pc_wev8.css" type="text/css" />
        <script type="text/javascript" src="/js/jquery/plugins/client/jquery.client_wev8.js"></script>
        <script type="text/javascript" src="/js/ecology8/jNice/jNice/jquery.jNice_wev8.js"></script>
        <link rel="stylesheet" href="/js/ecology8/jNice/jNice/jNice_wev8.css" type="text/css" />
        <style type="text/css">
            * {
                padding: 0;
                margin: 0;
            }
            #e-message-version-check span:active {
            	background: #00A9FF;color:#fff;
            }
            
            #e-message-version-check span {
            	font-size: 12px;color: #666;display: inline-block;border: 1px solid #d2d2d2;width: 112px;text-align: center;border-radius: 4px;cursor: pointer;
            }
        </style>
    </head>

    <body>
        <div class="pcSysSetTab">
            <ul class="sysItems">
                <li class="active" name="#tabs-1"><%=SystemEnv.getHtmlLabelName(674, user.getLanguage())%></li><!-- 登录 -->
                <li name="#tabs-2"><%=SystemEnv.getHtmlLabelName(126885, user.getLanguage())%></li><!-- 主面板 -->
                <li name="#tabs-3"><%=SystemEnv.getHtmlLabelName(126886, user.getLanguage())%></li><!-- 热键 -->
                <li name="#tabs-4"><%=SystemEnv.getHtmlLabelName(127109, user.getLanguage())%></li><!-- 消息和提醒 -->
                <li name="#tabs-5"><%=SystemEnv.getHtmlLabelName(130690, user.getLanguage())%></li><!-- 文件传输 -->
                <li name="#tabs-6"><%=SystemEnv.getHtmlLabelName(131198, user.getLanguage())%></li><!-- 关于 -->
            </ul>
            <div class="sysSetContent">
                <div id="tabs-1" style="display: block;">
                    <div class="contentTitle"><%=SystemEnv.getHtmlLabelName(33396, user.getLanguage())%></div><!-- 设置项 -->
                    <div class="contentInfo">
                        <input type="checkbox" id="autoLogin" name="autoLogin" /><%=SystemEnv.getHtmlLabelName(24701, user.getLanguage())%><!-- 自动登录 -->
                    </div>
                    <div id="autoStartup_div" class="contentInfo" style="display: none;">
                        <input type="checkbox" id="autoStartup" name="autoStartup" /><%=SystemEnv.getHtmlLabelName(126887, user.getLanguage())%><!-- 开机时自动启动e-message -->
                    </div>
                </div>
                
                <div id="tabs-2">
                    <div class="contentTitle"><%=SystemEnv.getHtmlLabelName(126888, user.getLanguage())%></div><!-- 关闭主面板时 -->
                    <div class="contentInfo">
                        <input type="radio" name="confirmQuit" value="1"/><%=SystemEnv.getHtmlLabelName(126889, user.getLanguage())%><!-- 最小化到托盘 -->
                    </div>
                    <div class="contentInfo">
                        <input type="radio" name="confirmQuit" value="2"/><%=SystemEnv.getHtmlLabelName(126890, user.getLanguage())%><!-- 退出程序 -->
                    </div>
                </div>
                
                <div id="tabs-3">
                    <div class="contentTitle" style="text-align: center; color: red;"><%=SystemEnv.getHtmlLabelName(127115, user.getLanguage())%></div><!-- 若不能使用，请尝试其他组合键 -->
                    <div class="contentTitle" id="screenshot_msg"><%=SystemEnv.getHtmlLabelName(126866, user.getLanguage())%></div><!-- 截图 -->
                    <div class="contentInfo" id="screenshot_div" style="display:flex;">
                        <select id="screenshot_ctrl_1" notBeauty=true>
                        </select>
                        +
                        <select id="screenshot_ctrl_2">
                            <% for(int i = 65; i < 91; i ++) { %>
                            <option value="<%=(char)i %>"><%=(char)i %></option>
                            <% } %>
                        </select>
                    </div>
                    
                    <br/>
                    <div class="contentTitle"><%=SystemEnv.getHtmlLabelName(126891, user.getLanguage())%></div><!-- 展示聊天窗口 -->
                    <div class="contentInfo" style="display:flex;">
                        <select id="openAndHideWin_ctrl_1" notBeauty=true>
                        </select>
                        +
                        <select id="openAndHideWin_ctrl_2">
                            <% for(int i = 65; i < 91; i ++) { %>
                            <option value="<%=(char)i %>"><%=(char)i %></option>
                            <% } %>
                        </select>
                    </div>
                    
                    <br/>
                    <div class="contentTitle"><%=SystemEnv.getHtmlLabelName(130682, user.getLanguage())%></div><!-- 关闭所有聊天窗口 -->
                    <div class="contentInfo" style="display:flex;">
                        <select id="closeAllChatWin_ctrl_1" notBeauty=true>
                        </select>
                        +
                        <select id="closeAllChatWin_ctrl_2">
                            <% for(int i = 65; i < 91; i ++) { %>
                            <option value="<%=(char)i %>"><%=(char)i %></option>
                            <% } %>
                        </select>
                    </div>
                    
                    <br/>
                    <div class="contentTitle"><%=SystemEnv.getHtmlLabelName(130714, user.getLanguage())%></div><!-- 关闭当前聊天窗口 -->
                    <div class="contentInfo" style="display:flex;">
                        <select id="closeChatWin_ctrl_1" notBeauty=true>
                        </select>
                        +
                        <select id="closeChatWin_ctrl_2">
                            <% for(int i = 65; i < 91; i ++) { %>
                            <option value="<%=(char)i %>"><%=(char)i %></option>
                            <% } %>
                        </select>
                    </div>
                </div>
                
                <div id="tabs-4">
                    <div class="contentTitle"><%=SystemEnv.getHtmlLabelName(19085, user.getLanguage())%></div><!-- 消息提醒 -->
                    <div class="contentInfo">
                        <input type="checkbox" id="newMsg" name="newMsg" /><%=SystemEnv.getHtmlLabelName(127110, user.getLanguage())%><!-- 消息到达直接弹出窗口 -->
                    </div>
                    <div class="contentTitle"><%=SystemEnv.getHtmlLabelName(23042, user.getLanguage())%></div><!-- 流程提醒 -->
                    <div class="contentInfo">
                        <input type="checkbox" id="wfRemind" name="wfRemind"/><%=SystemEnv.getHtmlLabelName(127111, user.getLanguage())%><!-- 开启流程提醒 -->
                    </div>
                     <div class="contentTitle"><%=SystemEnv.getHtmlLabelName(131338, user.getLanguage())%></div><!-- 文档提醒 type =21  -->
                    <div class="contentInfo">
                        <input type="checkbox" id="docRemind" name="docRemind"/><%=SystemEnv.getHtmlLabelName(131339, user.getLanguage())%><!-- 新文档阅读提醒-->
                    </div>
                    <div class="contentTitle"><%=SystemEnv.getHtmlLabelName(18845, user.getLanguage())%></div><!-- 邮件提醒 -->
                    <div class="contentInfo">
                        <input type="checkbox" id="mailRemind" name="mailRemind"/><%=SystemEnv.getHtmlLabelName(127112, user.getLanguage())%><!-- 开启邮件提醒 -->
                    </div>
                    <div class="contentTitle"><%=SystemEnv.getHtmlLabelName(127113, user.getLanguage())%></div><!-- 提示音设置 -->
                    <div class="contentInfo">
                        <input type="checkbox" id="audioSet_all" name="audioSet_all"/><%=SystemEnv.getHtmlLabelName(127114, user.getLanguage())%><!-- 关闭所有提示音 -->
                    </div>
		            <div class="contentTitle"><%=SystemEnv.getHtmlLabelName(131438, user.getLanguage())%></div><!-- 提醒弹窗设置 -->
                    <div class="contentInfo">
                        <%=SystemEnv.getHtmlLabelName(131439, user.getLanguage()).trim()%>
                       	<input type="text" id="popWinAutoCloseSec" style="width:60px; margin: 0 5px;" 
                       		onkeyup="this.value=this.value.replace(/\D/g,'')"  
                       		onafterpaste="this.value=this.value.replace(/\D/g,'')" maxlength="5" size="14" name="popWinAutoCloseSec"/>s <div title="<%=SystemEnv.getHtmlLabelName(131440, user.getLanguage())%>" 
                       			style="float: right;text-overflow: ellipsis;width: 215px;white-space: nowrap;overflow: hidden;">&nbsp;(<%=SystemEnv.getHtmlLabelName(131440, user.getLanguage())%>)</div>
                       	<!-- 自动关闭时间 --><!-- 不填写或填写0代表不自动关闭 -->
                    </div>
                </div>
                
                <div id="tabs-5">
                    <div class="contentTitle"><%=SystemEnv.getHtmlLabelName(130691, user.getLanguage())%>：</div><!-- 设置项 -->
                    <div class="contentInfo">
                        <input id="defaultDlPath" name="defaultDlPath" class='InputStyle DlpathInput' readonly='readonly'/>
                        <input type='button' id='changeDlpathBtn' class='DlpathBtn' value="<%=SystemEnv.getHtmlLabelName(130699, user.getLanguage())%>">
                    </div>
                </div>
                <div id="tabs-6">
                    <div class="contentTitle"></div>
                    <div class="contentInfo">
                       <div style="margin-top: 67px;margin-left: 126px;">
                           <img src="/social/images/social_system_version.png" draggable="false">
                            <div style="margin-left: -12px;font-size: 20px;color: #333333;margin-top: -7px;">e-message</div>
                            <div id="e-message-version" style="margin-left: -25px;margin-top：3px;"><span style="font-size: 12px;color: #666666;">
                                <%=SystemEnv.getHtmlLabelName(131199, user.getLanguage())%></span>
                            </div>
                            <div id="e-message-version-check" style="margin-left: -12px;">
                            	<span><%=SystemEnv.getHtmlLabelName(32396, user.getLanguage())%></span><!-- 检查更新 -->
                            </div>
                        </div> 
                        <div style="margin-top:63px;margin-left:28px"><span style="font-size:12px;color:#b1b1b1"><%=SystemEnv.getHtmlLabelName(131197, user.getLanguage())%>&nbsp&nbsp©&nbsp&nbspShanghai Weaver Network Co., Ltd</span></div>                   
                    </div>                    
                </div>
            </div>
        </div>
        
       <!-- 底部按钮组 -->
       <div id="zDialog_div_bottom" class="zDialog_div_bottom">
            <wea:layout>
                <wea:group context="" attributes="{groupDisplay:none}">
                    <wea:item type="toolbar">
                        <input type="button" value="<%=SystemEnv.getHtmlLabelName(826, user.getLanguage())%>" id="zd_btn_confirm" class="zd_btn_cancle" ><!-- 确定 -->
                        <!-- <input type="button" value="<%=SystemEnv.getHtmlLabelName(25432, user.getLanguage())%>" id="zd_btn_apply" class="zd_btn_cancle" > 应用 -->
                        <input type="button" value="<%=SystemEnv.getHtmlLabelName(201, user.getLanguage())%>" id="zd_btn_cancle" class="zd_btn_cancle" ><!-- 取消 -->
                    </wea:item>
                </wea:group>
            </wea:layout>
        </div>
    </body>
    
    <script type="text/javascript">
        var localconfig = PcMainUtils.localconfig;
        var platform = PcMainUtils.platform;
        var openerWin = window;
        var _electron = null;
        var eleFlag = true; 
        if(typeof openerWin ==='undefined'){
            eleFlag = false;
        }else{
             _electron = openerWin.Electron;
        }
        
        
        $(function(){
        $('#tabs-3').css('width','250px');
            /*
            $('#tabs-3').find('#screenshot_ctrl_1').next('span').css('max-width','150px');
            $('#tabs-3').find('#screenshot_ctrl_2').next('span').css('max-width','150px');
            $('#tabs-3').find('#openAndHideWin_ctrl_1').next('span').css('max-width','150px');
            $('#tabs-3').find('#openAndHideWin_ctrl_2').next('span').css('max-width','150px');
            $('#tabs-3').find('#openAndHideWin_ctrl_1').next('span').css('max-width','150px');
            $('#tabs-3').find('#openAndHideWin_ctrl_2').next('span').css('max-width','150px');
            $('#tabs-3').find('#closeAllChatWin_ctrl_2').next('span').css('max-width','150px');
            $('#tabs-3').find('#closeAllChatWin_ctrl_1').next('span').css('max-width','150px');
            */
            $('.sysItems li').click(function(){
                $(this).addClass('active').siblings().removeClass('active');
                $('.sysSetContent > div').hide();
                $($(this).attr('name')).show();
            });
            
            $('#zd_btn_apply').click(function(){
                    saveConfig();
                });
            $('#zd_btn_cancle').click(function(){
                var win = _electron.currentWindow;
                win.close();
            });
            $('#zd_btn_confirm').click(function(){
                saveConfig(function(){
                    $('#zd_btn_cancle').click();
                });
            });
            
            $('#changeDlpathBtn').click(function(){
                try{
                if(eleFlag){
                    var e_dialog = _electron.remote.dialog;
                    if(e_dialog){
                        e_dialog.showOpenDialog(_electron.currentWindow, {properties : ['openDirectory']}, function(choosed){
                            if(choosed) {
                                var srcPath = choosed[0]
                                $('#defaultDlPath').val(srcPath);
                            }
                        });
                    }
                }else{
                     parent.nwdialog.setContext(parent.document.getElementById("downloadFrame").contentWindow.document);
                     parent.nwdialog.folderBrowserDialog(function(choosed){
                            if(choosed) {
                                var srcPath = choosed;
                                $('#defaultDlPath').val(srcPath);
                            }
                        });
                }
                }catch(err){
                    console.error("更换目录失败", err);
                }
            });
            
            $('#e-message-version-check span').click(function(){
            	try{
					UpdateChecker.check();
            	}catch(err){
            		console.error("检查更新异常", err);
            	}
            }); 
            // 初始化默认页面
            $('[notbeauty="true"]').removeAttr('notbeauty');
            if(PcMainUtils.isWindows()) {
                $('#autoStartup_div').show();
                PcMainUtils.localconfig.validAutoStartup(platform, function(err, exist){
                    try{
                        $('#autoStartup').trigger('checked', exist);
                    }catch(err){
                        
                    }
                    if(exist){
                       $('#autoStartup').prop("checked", exist);
                       document.getElementById('autoStartup').checked = exist;
                       $('#autoStartup').next('.jNiceCheckbox').addClass('jNiceChecked');
                    }
                });
                
                if(ClientSet.ifSendPicOrScreenShots == '0') {
                    initControlSelect('screenshot_ctrl_1');
                } else {
                    $('#screenshot_msg').hide();
                    $('#screenshot_div').hide();
                }
                
                initControlSelect('openAndHideWin_ctrl_1');
                initControlSelect('closeAllChatWin_ctrl_1');
                initControlSelect('closeChatWin_ctrl_1');
            } else if(PcMainUtils.isOSX()) {
                $('#screenshot_msg').hide();
                $('#screenshot_div').hide();
                initControlSelect('openAndHideWin_ctrl_1');
                initControlSelect('closeAllChatWin_ctrl_1');
                initControlSelect('closeChatWin_ctrl_1');
            }
            __jNiceNamespace__.beautySelect();
            
            // 获得设置值，并设置
            var config = PcSysSettingUtils.getConfig();
            var confirmQuit = config.mainPanel.noLongerRemind ? (config.mainPanel.alwaysQuit ? 2 : 1) : null;
            var autoLogin = config.login.autoLogin;
            var defaultDlPath = config.download.defaultPath;
            var popWinAutoCloseSec = config.msgAndRemind.popWinAutoCloseSec;
            
            if(!config.shortcut.closeAllChatWin){
                config.shortcut.closeAllChatWin = platform.OSX?'COMMAND+CONTROL+C':'CTRL+ALT+C';
            }
            
            if(!config.shortcut.closeChatWin){
                config.shortcut.closeChatWin = platform.OSX?'CONTROL+C':'ALT+C';
            }
            try{
                $('#autoLogin').trigger('checked', autoLogin);
            }catch(err){
            }
            if(autoLogin){
                $('#autoLogin').prop("checked", true);
                document.getElementById('autoLogin').checked = true;
                 $('#autoLogin').next('.jNiceCheckbox').addClass('jNiceChecked');
            }
            if(confirmQuit != null) {
                try{
                    $('[name="confirmQuit"][value="' + confirmQuit + '"]').trigger('checked', true);
                   
                }catch(err){
                    $('[name="confirmQuit"][value="' + confirmQuit + '"]').attr('checked', true);
                    
                }
                $('[name="confirmQuit"][value="' + confirmQuit + '"]').next('.jNiceRadio').addClass('jNiceChecked');
            }
            
            if(PcMainUtils.isWindows() && ClientSet.ifSendPicOrScreenShots == '0') {
                var screenshotArr = getShortcutArr(config.shortcut.screenshot);
                $('#screenshot_ctrl_1').selectbox('change', screenshotArr[0]);
                $('#screenshot_ctrl_2').selectbox('change', screenshotArr[1]);
            }
            var openAndHideWinArr = getShortcutArr(config.shortcut.openAndHideWin);
            $('#openAndHideWin_ctrl_1').selectbox('change', openAndHideWinArr[0]);
            $('#openAndHideWin_ctrl_2').selectbox('change', openAndHideWinArr[1]);
            
            var closeAllChatWinArr = getShortcutArr(config.shortcut.closeAllChatWin);
            $('#closeAllChatWin_ctrl_1').selectbox('change', closeAllChatWinArr[0]);
            $('#closeAllChatWin_ctrl_2').selectbox('change', closeAllChatWinArr[1]);
            
            var closeChatWinArr = getShortcutArr(config.shortcut.closeChatWin);
            $('#closeChatWin_ctrl_1').selectbox('change', closeChatWinArr[0]);
            $('#closeChatWin_ctrl_2').selectbox('change', closeChatWinArr[1]);
            try{
                $('#newMsg').trigger('checked', config.msgAndRemind.newMsg);
                if(config.msgAndRemind.newMsg){
                   $('#newMsg').prop("checked", true);
                   $('#newMsg').attr("checked","true");
                   $('#newMsg').next('.jNiceCheckbox').addClass('jNiceChecked');
                }
            }catch(err){
                $('#newMsg').attr('checked', config.msgAndRemind.newMsg);
            }
            try{
                $('#wfRemind').trigger('checked', config.msgAndRemind.wfRemind);
                if(config.msgAndRemind.wfRemind){
                   $('#wfRemind').prop("checked", true);
                   $('#wfRemind').next('.jNiceCheckbox').addClass('jNiceChecked');
                }
            }catch(err){
                $('#wfRemind').attr('checked', config.msgAndRemind.wfRemind);
            }
            try{
                $('#docRemind').trigger('checked', typeof config.msgAndRemind.docRemind =="undefined"? true: config.msgAndRemind.docRemind);
                if(typeof config.msgAndRemind.docRemind =="undefined" ? true: config.msgAndRemind.docRemind){
                   $('#docRemind').prop("checked", true);
                   $('#docRemind').next('.jNiceCheckbox').addClass('jNiceChecked'); 
                }
            }catch(err){
                $('#docRemind').attr('checked', typeof config.msgAndRemind.docRemind =="undefined"? true: config.msgAndRemind.docRemind);
            }
            try{
                $('#mailRemind').trigger('checked', config.msgAndRemind.mailRemind);
                if(typeof config.msgAndRemind.mailRemind =="undefined" ? true: config.msgAndRemind.mailRemind){
                   $('#mailRemind').prop("checked", true);
                   $('#mailRemind').next('.jNiceCheckbox').addClass('jNiceChecked'); 
                }
            }catch(err){
                $('#mailRemind').attr('checked', config.msgAndRemind.mailRemind);
            }
            try{
                $('#audioSet_all').trigger('checked', config.msgAndRemind.audioSet_all);
                if(config.msgAndRemind.audioSet_all){
                   $('#audioSet_all').prop("checked", true);
                   $('#audioSet_all').next('.jNiceCheckbox').addClass('jNiceChecked');
                }
            }catch(err){
                $('#audioSet_all').attr('checked', config.msgAndRemind.audioSet_all);
            }
             $('#popWinAutoCloseSec').val(typeof popWinAutoCloseSec == "undefined"? "180": popWinAutoCloseSec);
            $('#defaultDlPath').val(defaultDlPath);
            getEmessageVersion();//设置版本
            
        });
        
        // 保存配置信息
        function saveConfig(callback) {
            var config = PcSysSettingUtils.getConfig();
                
            if(PcMainUtils.isWindows()) {
                // 自启动
                PcMainUtils.localconfig.validAutoStartup(platform, function(err, exist){
                    if($('#autoStartup').is(':checked') != exist) {
                        if($('#autoStartup').is(':checked')) {
                            PcMainUtils.localconfig.setAppAutoStartup(platform, function(err, flag){
                                if(!flag) {
                                    $('#autoStartup').trigger('checked', false);
                                    console.error('设置开机自启动失败');
                                    console.error(e);
                                    // 设置开机自启动失败
                                    var e_dialog = _electron.remote.dialog;
                                    e_dialog.showErrorBox('emessage','<%=SystemEnv.getHtmlLabelName(126893, user.getLanguage())%>');
                                    return;
                                }
                            })
                        } else {
                            PcMainUtils.localconfig.cancelAppAutoStartup(platform, function(err, flag){
                                if(!flag) {
                                    $('#autoStartup').trigger('checked', true);
                                    console.error('取消自启动失败');
                                    console.error(err);
                                    // 取消开机自启动失败
                                    //parent.Dialog.alert('<%=SystemEnv.getHtmlLabelName(126898, user.getLanguage())%>');
                                    var e_dialog = _electron.remote.dialog;
                                    e_dialog.showErrorBox('emessage','<%=SystemEnv.getHtmlLabelName(126898, user.getLanguage())%>');
                                    return;
                                }
                            });
                        }
                    }
                });
            }
            
            // 是否自动登陆
            config.login.autoLogin = $('#autoLogin').is(':checked');
            
            var confirmQuit = $('input[name="confirmQuit"]:checked').val();
            if(confirmQuit) {
                config.mainPanel.noLongerRemind = true;
                config.mainPanel.alwaysQuit = confirmQuit == 1 ? false : true;
            }
            
            // 快捷键
            // 截图
            if(PcMainUtils.isWindows() && ClientSet.ifSendPicOrScreenShots == '0') {
                var screenshotNew = getShortcutKey('screenshot');
                var screenshotFlag = true;
                if(screenshotNew != config.shortcut.screenshot) {
                    if(!PcGlobalShortcutUtils.isRegistered(screenshotNew)) {
                        if(PcGlobalShortcutUtils.execRegister(config.shortcut.screenshot, screenshotNew, GlobalShortMethods.SCREENSHOT)) {
                            config.shortcut.screenshot = screenshotNew;
                            pcWindowConfig.shortcut.screenshot = screenshotNew;
                            PcGlobalShortcutUtils.setScreenshotTitle();
                        } else {
                            screenshotFlag = false;
                            // 热键设置失败
                            //parent.Dialog.alert('<%=SystemEnv.getHtmlLabelName(126900, user.getLanguage())%>');
                            var e_dialog = _electron.remote.dialog;
                            e_dialog.showErrorBox('emessage','<%=SystemEnv.getHtmlLabelName(126900, user.getLanguage())%>');
                            return;
                        }
                    } else {
                        screenshotFlag = false;
                        // 截图热键设置失败，   键位被占用
                        //parent.Dialog.alert('<%=SystemEnv.getHtmlLabelName(126866, user.getLanguage()) + SystemEnv.getHtmlLabelName(126900, user.getLanguage()) + ","%>' + screenshotNew + '<%=SystemEnv.getHtmlLabelName(126903, user.getLanguage())%>');
                        var e_dialog = _electron.remote.dialog;
                            e_dialog.showErrorBox('emessage','<%=SystemEnv.getHtmlLabelName(126866, user.getLanguage()) + SystemEnv.getHtmlLabelName(126900, user.getLanguage()) + ","%>' + screenshotNew + '<%=SystemEnv.getHtmlLabelName(126903, user.getLanguage())%>');
                            return;
                    }
                }
                if(!screenshotFlag) {
                    $('#screenshot_ctrl_2').selectbox('change', getShortcutArr(config.shortcut.screenshot)[1]);
                }
            }
            // 隐藏和呼出
            var openAndHideWinNew = getShortcutKey('openAndHideWin');
            var openAndHideWinFlag = true;
            if(openAndHideWinNew != config.shortcut.openAndHideWin) {
                if(!PcGlobalShortcutUtils.isRegistered(openAndHideWinNew)) {
                    if(PcGlobalShortcutUtils.execRegister(config.shortcut.openAndHideWin, openAndHideWinNew, GlobalShortMethods.OPENANDHIDEWIN)) {
                        config.shortcut.openAndHideWin = openAndHideWinNew;
                    } else {
                        openAndHideWinFlag = false;
                        // 热键设置失败
                        //parent.Dialog.alert('<%=SystemEnv.getHtmlLabelName(126900, user.getLanguage())%>');
                        var e_dialog = _electron.remote.dialog;
                            e_dialog.showErrorBox('emessage','<%=SystemEnv.getHtmlLabelName(126900, user.getLanguage())%>');
                            return;
                    }
                } else {
                    openAndHideWinFlag = false;
                    // 呼出和隐藏热键设置失败，   键位被占用
                    //parent.Dialog.alert('<%=SystemEnv.getHtmlLabelName(126891, user.getLanguage()) + SystemEnv.getHtmlLabelName(126900, user.getLanguage()) + ","%>' + openAndHideWinNew + '<%=SystemEnv.getHtmlLabelName(126903, user.getLanguage())%>');
                    var e_dialog = _electron.remote.dialog;
                            e_dialog.showErrorBox('emessage','<%=SystemEnv.getHtmlLabelName(126891, user.getLanguage()) + SystemEnv.getHtmlLabelName(126900, user.getLanguage()) + ","%>' + openAndHideWinNew + '<%=SystemEnv.getHtmlLabelName(126903, user.getLanguage())%>');
                            return;
                }
            }
            if(!screenshotFlag) {
                $('#openAndHideWin_ctrl_2').selectbox('change', getShortcutArr(config.shortcut.openAndHideWin)[1]);
            }
            if(eleFlag){
                // 关闭所有聊天窗口
                var closeAllChatWinNew = getShortcutKey('closeAllChatWin');
                var closeAllChatWinFlag = true;
                if(closeAllChatWinNew != config.shortcut.closeAllChatWin) {
                    if(!PcGlobalShortcutUtils.isRegistered(closeAllChatWinNew)) {
                        if(PcGlobalShortcutUtils.execRegister(config.shortcut.closeAllChatWin, closeAllChatWinNew, GlobalShortMethods.CLOSEALLCHATWIN)) {
                            config.shortcut.closeAllChatWin = closeAllChatWinNew;
                        } else {
                           closeAllChatWinFlag = false;
                            // 热键设置失败
                            //parent.Dialog.alert('<%=SystemEnv.getHtmlLabelName(126900, user.getLanguage())%>');
                            var e_dialog = _electron.remote.dialog;
                            e_dialog.showErrorBox('emessage','<%=SystemEnv.getHtmlLabelName(126900, user.getLanguage())%>');
                            return;
                        }
                    } else {
                       closeAllChatWinFlag = false;
                        // 呼出和隐藏热键设置失败，   键位被占用
                        //parent.Dialog.alert('<%=SystemEnv.getHtmlLabelName(126891, user.getLanguage()) + SystemEnv.getHtmlLabelName(126900, user.getLanguage()) + ","%>' + closeAllChatWinNew + '<%=SystemEnv.getHtmlLabelName(126903, user.getLanguage())%>');
                        var e_dialog = _electron.remote.dialog;
                            e_dialog.showErrorBox('emessage','<%=SystemEnv.getHtmlLabelName(126891, user.getLanguage()) + SystemEnv.getHtmlLabelName(126900, user.getLanguage()) + ","%>' + closeAllChatWinNew + '<%=SystemEnv.getHtmlLabelName(126903, user.getLanguage())%>');
                            return;
                    }
                }
                if(!screenshotFlag) {
                    $('#closeAllChatWin_ctrl_2').selectbox('change', getShortcutArr(config.shortcut.closeAllChatWin)[1]);
                }
                
                // 关闭当前聊天窗口
                var closeChatWinNew = getShortcutKey('closeChatWin');
                var closeChatWinFlag = true;
                if(closeChatWinNew != config.shortcut.closeChatWin) {
                    if(!PcGlobalShortcutUtils.isRegistered(closeChatWinNew)) {
                        if(PcGlobalShortcutUtils.execRegister(config.shortcut.closeChatWin, closeChatWinNew, GlobalShortMethods.CLOSECHATWIN)) {
                            config.shortcut.closeChatWin = closeChatWinNew;
                        } else {
                           closeChatWinFlag = false;
                            // 热键设置失败
                            //parent.Dialog.alert('<%=SystemEnv.getHtmlLabelName(126900, user.getLanguage())%>');
                            var e_dialog = _electron.remote.dialog;
                            e_dialog.showErrorBox('emessage','<%=SystemEnv.getHtmlLabelName(126900, user.getLanguage())%>');
                            return;
                        }
                    } else {
                       closeChatWinFlag = false;
                        // 呼出和隐藏热键设置失败，   键位被占用
                        //parent.Dialog.alert('<%=SystemEnv.getHtmlLabelName(126891, user.getLanguage()) + SystemEnv.getHtmlLabelName(126900, user.getLanguage()) + ","%>' + closeChatWinNew + '<%=SystemEnv.getHtmlLabelName(126903, user.getLanguage())%>');
                        var e_dialog = _electron.remote.dialog;
                            e_dialog.showErrorBox('emessage','<%=SystemEnv.getHtmlLabelName(126891, user.getLanguage()) + SystemEnv.getHtmlLabelName(126900, user.getLanguage()) + ","%>' + closeChatWinNew + '<%=SystemEnv.getHtmlLabelName(126903, user.getLanguage())%>');
                            return;
                    }
                }
                if(!screenshotFlag) {
                    $('#closeChatWin_ctrl_2').selectbox('change', getShortcutArr(config.shortcut.closeChatWin)[1]);
                }
            }else {
                //parent.IM_Ext.showMsg('设置关闭聊天窗口快捷键失败，客户端可能暂不支持'); // 设置关闭聊天窗口快捷键失败，客户端可能暂不支持
                var e_dialog = _electron.remote.dialog;
                e_dialog.showErrorBox('emessage','设置关闭聊天窗口快捷键失败，客户端可能暂不支持');
                return;
            }
            
            // 消息和提示
            config.msgAndRemind.newMsg = $('#newMsg').is(':checked');
            config.msgAndRemind.wfRemind = $('#wfRemind').is(':checked');
            config.msgAndRemind.docRemind = $('#docRemind').is(':checked');            
            config.msgAndRemind.mailRemind = $('#mailRemind').is(':checked');
            config.msgAndRemind.audioSet_all = $('#audioSet_all').is(':checked');
            config.msgAndRemind.popWinAutoCloseSec = $('#popWinAutoCloseSec').val();
            
            // 文件传输路径
            config.download.defaultPath = $.trim($("#defaultDlPath").val());
            
            // 保存配置
            PcSysSettingUtils.saveConfig(config);
            
            window.Electron.ipcRenderer.send('plugin-setUserConifg-cb', {
                config : config,
                callback : null
            });
            
            setTimeout(function(){
                typeof callback === 'function' && callback();
            }, 200);
        }
        
        function initControlSelect(id){
            var ctrl_1 = document.getElementById(id);
            if(PcMainUtils.isWindows()) {
                ctrl_1.options.add(new Option("ALT","ALT"));
                ctrl_1.options.add(new Option("CTRL","CTRL"));
                ctrl_1.options.add(new Option("CTRL+ALT","CTRL+ALT"));
            } else if(PcMainUtils.isOSX()) {
                ctrl_1.options.add(new Option("COMMAND","COMMAND"));
                ctrl_1.options.add(new Option("CONTROL","CONTROL"));
                ctrl_1.options.add(new Option("COMMAND+CONTROL","COMMAND+CONTROL"));
            }
        }
        
        function getShortcutArr(shortcutKey) {
            var resutl = [];
            var index = shortcutKey.lastIndexOf('+');
            resutl[0] = shortcutKey.substring(0, index);
            resutl[1] = shortcutKey.substring(index + 1);
            return resutl;
        }        
        function getShortcutKey(prefix) {
            return $('#' + prefix + '_ctrl_1').selectbox('option').val() + '+' + $('#' + prefix + '_ctrl_2').selectbox('option').val();
        }
        function getEmessageVersion(){
            $.ajax({
            url : '/social/im/ServerStatus.jsp?p=getVersion',
            dataType : 'json',
            success : function(data){
                var version ="："+data.version+".";
                var c_version = PcMainUtils.getVersion();
                if(PcMainUtils.isWindows()) {
                    if(eleFlag){
                        version += c_version.buildVersion+"（Windows）";
                    }else{
                        version+= data.xpbuildVersion+" （Win  XP）";
                        $("#e-message-version-check").hide();
                    }                        
                    } else if(PcMainUtils.isOSX()) {
                        version += c_version.osxBuildVersion+"（Mac Os）";
                    }
                    $("#e-message-version span").append(version);
                }
            });
        }
    </script>
    </html>
