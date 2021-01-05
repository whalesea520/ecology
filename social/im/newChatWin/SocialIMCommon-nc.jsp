<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="weaver.general.StaticObj" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.hrm.settings.RemindSettings" %>
<%@ page import="net.sf.json.JSONObject"%>
<%@ page import="org.apache.commons.logging.Log"%>
<%@ page import="org.apache.commons.logging.LogFactory"%>
<%@page import="weaver.social.service.SocialOpenfireUtil"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="log" class="weaver.general.BaseBean" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="SocialIMService" class="weaver.social.service.SocialIMService" scope="page" />

<%@ taglib uri="/browserTag" prefix="brow"%>

<%
    // 是否是基于openfire部署
    boolean IS_BASE_ON_OPENFIRE = SocialOpenfireUtil.getInstanse().isBaseOnOpenfire();  

    String RONG_SDK_VER =  SocialOpenfireUtil.getInstanse().getRongSdkVersion(application.getRealPath("/"));
    
    // 私有云只用版本1
    if(IS_BASE_ON_OPENFIRE){
        RONG_SDK_VER = "1";
    }

    response.setHeader("cache-control", "no-cache");
    response.setHeader("pragma", "no-cache");
    response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
    
    user = HrmUserVarify.getUser (request , response) ;
    if(user == null){
        out.println("<script>window.top.location='/login/Logout.jsp';</script>");
        return; 
    }
    Boolean isUseAppDetach = SocialIMService.isUseAppDetatch(user);
    String from = Util.null2String(request.getParameter("from"));
    String pcOS = Util.null2String(request.getParameter("pcOS"));
    String isAllow = Util.null2String(request.getParameter("isAllowNewWin"));
    String serverIp = Util.null2String(request.getParameter("serverIp"), "null");
    Boolean nwFlag=false;
    if(isAllow.equals("")||isAllow.equals("undefined")){
        nwFlag = false;
    }else{
        nwFlag = true;
    }
    //log.writeLog("===========nwFlag="+nwFlag);
    Calendar calendar = TimeUtil.getCalendar(TimeUtil.getCurrentDateString());
    calendar.add(Calendar.DATE, 1);
    String zeroTimeMillis = calendar.getTimeInMillis()+"";
%>

<script> 
var CUST_SERV_IP = '<%=serverIp%>'; 
var IS_BASE_ON_OPENFIRE = <%=IS_BASE_ON_OPENFIRE%>; 
var M_SDK_VER = <%=RONG_SDK_VER%>; 
var ZERO_TIME_MILLIS = <%=zeroTimeMillis%>;
var IS_USE_APPDETACH = <%=isUseAppDetach%>;
var nwFlag = '<%=nwFlag%>';
var WINID ={};
var IS_USE_APPDETACH = <%=isUseAppDetach%>;
var M_SERVERCONFIG = {};
</script>

<script type="text/javascript" src="/js/select/script/jquery-1.8.3.min_wev8.js"></script>
<script> var jq183=$; </script>

<script type="text/javascript" src="/wui/common/jquery/jquery.min_wev8.js"></script>

<script type="text/javascript" src="/js/jquery/plugins/client/jquery.client_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/jNice/jNice/jquery.jNice_wev8.js"></script>
<link rel="stylesheet" href="/js/ecology8/jNice/jNice/jNice_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/base/jquery-ui_wev8.js"></script>
<link rel="stylesheet" href="/js/ecology8/base/jquery-ui_wev8.css" type="text/css" />

<jsp:include page="/social/SocialUtil.jsp"></jsp:include>

<script src="/social/im/js/social_init.js"></script>

<LINK href="/social/js/jquery.atwho/css/jquery.atwho_wev8.css" type=text/css rel=STYLESHEET>
<script src="/social/js/jquery.atwho/js/jquery.atwho_wev8.js"></script>
<script src="/social/js/jquery.atwho/js/jquery.caret_wev8.js"></script>

<script type="text/javascript" src="/cowork/js/jquery.fancybox/fancybox/jquery.mousewheel-3.0.4.pack_wev8.js"></script>
<script type="text/javascript" src="/cowork/js/jquery.fancybox/fancybox/jquery.fancybox-1.3.4_wev8.js"></script>
<link rel="stylesheet" type="text/css" href="/cowork/js/jquery.fancybox/fancybox/jquery.fancybox-1.3.4_wev8.css" media="screen" />

<script language='javascript' type='text/javascript' src='/social/js/jquery.base64/jquery.base64_wev8.js'></script>
<script src="/social/js/imconfirm/IMConfirm.js"></script> 
<link rel="stylesheet" href="/social/js/imconfirm/IMConfirm.css"/>
<script src="/social/js/Social_wev8.js"></script>

<!-- 图片浏览处理库 -->
<script type="text/javascript" src="/social/js/imcarousel/imcarousel.js"></script>

<!-- 上传插件 -->
<%@ include file="/social/SocialUploader.jsp" %>

<!-- textarea 自动收缩插件 -->
<script src="/social/js/autosize/jquery.autosize.min.js"></script>

<!-- 取色器插件 -->
<script src="/social/js/spectrum/spectrum.js"></script>
<link rel="stylesheet" href="/social/js/spectrum/spectrum.css" type="text/css" />

<!-- rangy -->
<script src="/social/js/rangy/rangy-core.js"></script>
<script type="text/javascript" src="/social/js/WebSql_wev8.js"></script>
<link rel="stylesheet" href="/social/css/base_public_wev8.css" type="text/css" />
<jsp:include page="/social/im/newChatWin/SocialIMUtil-nc.jsp"></jsp:include> 


<!-- 引入watermark -->
<script type="text/javascript" src="/social/js/watermark/jquery.watermark.js"></script>
<!-- 提示插件 -->
<script src="/social/js/jquery.just-tip/justTools.js"></script>
<link rel="stylesheet" href="/social/js/jquery.just-tip/just-tip.css" type="text/css" />

<!-- 国际化插件 -->
<script src="/social/js/i18n/jquery.i18n.properties-min-1.0.9.js"></script>

<!-- 动画 -->
<link rel="stylesheet" href="/social/css/animate.min.css" type="text/css" />

<% if(IS_BASE_ON_OPENFIRE) { %>
<!-- openfire部署 -->
<jsp:include page="/social/im/newChatWin/SocialIMClientOpenfire-nc.jsp"></jsp:include>
<% } else if(RONG_SDK_VER.equals("1")) { %>
<!-- 融云 -->
<jsp:include page="/social/im/newChatWin/SocialIMClient-nc.jsp"></jsp:include>
<% } else if(RONG_SDK_VER.equals("2")) {%>
<jsp:include page="/social/im/newChatWin/SocialIMClient-sdk2-nc.jsp"></jsp:include>
<%} %>


<script src="/social/im/newChatWin/js/ChatUtil_wev8-nc.js"></script>


<script type="text/javascript" src="/social/im/js/IMUtil_wev8.js"></script>
<script src="/social/im/js/IMUtil_Ext_wev8.js"></script>
<!--plugin.js-->
<script type="text/javascript" src="/social/plugins/commonplugin.js"></script>
<!-- pc客户端 -->
<%
    if("pc".equals(from)) {
        //获取皮肤设置
        String column = "winConfig",skin="default";
        if("OSX".equals(pcOS)){
            column = "osxConfig";
        }
        RecordSet.execute("select " + column + " from Social_IMUserSysConfig where userId = "+user.getUID());
        if(RecordSet.next()){
            try{
                JSONObject userConfig = JSONObject.fromObject(RecordSet.getString(1));
                skin = userConfig.optString("skin", "default");
            }catch(Exception e){
                skin = "default";
            }
        }
%>
<%@ page import="weaver.social.po.SocialClientProp" %>
<link rel="stylesheet" href="/social/css/im_pc_wev8.css" type="text/css" />
<link rel="stylesheet" href="/social/css/im_pcmodels_wev8.css" type="text/css" />
<!--窗口分离样式-->
<link rel="stylesheet" href="/social/im/newChatWin/css/newMainClient.css" type="text/css" />

<script src="/social/im/js/im_pc_wev8.js"></script>
<script src="/social/im/js/im_pcmodels_wev8.js"></script>
<!-- 皮肤 -->
<link rel="stylesheet" href="/social/css/skin/<%=skin%>_wev8.css" type="text/css" media="screen" id="skincss" target="<%=skin %>"/>

    <% if(!"1".equals(SocialClientProp.getPropValue(SocialClientProp.FORBIT_FILETRANSFER)) && !"1".equals(SocialClientProp.getPropValue(SocialClientProp.FORBIT_FOLDERTRANSFER))) { %>
<script src="/social/im/js/im_pc_senddir_wev8.js"></script>
<%
        }
    }
%>
<%@ include file="/hrm/resource/simpleHrmResource_wev8.jsp" %>
<script>
    var loginuserid = "<%=user.getUID()%>";
    //可拖拽部分缩短
    //alert($("span.imtitleBlock").length);
    //$("span.imtitleBlock").css('right','66px !important');
    // 窗口最大化
    var isMainChatWinMax = false; // 主窗口是否是最大化
    
    //打开会话
    window.Electron.ipcRenderer.on('plugin-openUserChatWin-cbHandle',function(event,args,winid){
        WINID = winid;
        M_SERVERCONFIG = args.M_SERVERCONFIG;
        if(args.type==1){
            showConverChatpanelNew(args.targetid,args.targetName,args.targetHead,args.targetType,args.count);
        }else if(args.type==2){
            showIMChatpanel(args.chatType,args.acceptId,args.chatName,args.headicon);
        }
        if(args.targetType==1){
            //获取群组信息并保存
            ClientUtil.getDiscussion(args.targetid);
        }
    });
    
    window.Electron.ipcRenderer.on('window-open-by-guest',function(event,url, frameName, features){
        PcExternalUtils.openUrlByLocalApp(url,0);
    });
    //最大化
    window.Electron.ipcRenderer.on('plugin-maximize-cbHandle',function(){
        var obj = $('#pcChatMax'); 
        var chatdiv=$(obj).parents('.chatdiv');
        $(obj).removeClass('pc-imChatMaxBtn').addClass('pc-imChatMaxBtn-re');
        $(obj).attr('data-title',social_i18n('PCRETURN'));
        if(chatdiv.find('.fixphone').length > 0){
            chatdiv.find('.fixphone').removeClass('fixphoneEllipsis1');
            chatdiv.find('.fixphone').removeClass('fixphoneEllipsis2');
        }
        if(chatdiv.find('.mobilephone').length > 0){
            chatdiv.find('.mobilephone').removeClass('mobilephoneEllipsis');
            chatdiv.find('.mobilephone').removeClass('mobilephoneEllipsis1');
        }
        isMainChatWinMax = true;
    });
    //非最大化
    window.Electron.ipcRenderer.on('plugin-unmaximize-cbHandle',function(){
        var obj = $('#pcChatMax'); 
        var chatdiv=$(obj).parents('.chatdiv');
        $(obj).removeClass('pc-imChatMaxBtn-re').addClass('pc-imChatMaxBtn');
        $(obj).attr('data-title',social_i18n('PCMAX'));
        if(chatdiv.find('.mobilephone').length > 0){
            if(chatdiv.find('.fixphone').length > 0){
                chatdiv.find('.fixphone').addClass('fixphoneEllipsis1');
                chatdiv.find('.mobilephone').addClass('mobilephoneEllipsis');
            }else{
                chatdiv.find('.mobilephone').addClass('mobilephoneEllipsis1');
            }
        }else{
            if(chatdiv.find('.fixphone').length > 0){
                chatdiv.find('.fixphone').addClass('fixphoneEllipsis2');
            }
        }
        isMainChatWinMax = false;
    });
        
    //获取焦点
    window.Electron.ipcRenderer.on('chatwin_focus',function(event){
        var currentTab = getCurrentTab();
        var chatWinid=$(currentTab).attr("_chatWinid");
        try{
            var chattype = chatWinid.substring(8, 9);
            var targetid = chatWinid.substring(10, chatWinid.length);
            if(chattype == 7) return;  
            if(chattype == 8){
                sendLocalCountMsg(targetid+"|private");
                PrivateUtil.setConnverCache(targetid,false);    
                return;
            }
            sendLocalCountMsg(targetid);
            ChatUtil.setCurDiscussInfo(targetid, chattype);
            // 清理未读数
            //updateTotalMsgCount(targetid,false,chattype,0);
            //消除窗口消息未读提醒
            checkReadPosition(chatWinid);
            //清除tab上未读数
            currentTab.find(".msgcount").html(Number(0)).hide();
            //消息提示去掉
            $("#relatedMsgdiv_bottom_"+targetid).remove();
            //清除右侧最近列表的数字
            ClientUtil.updateTotalMsgCount(targetid,false,chattype,0);
            
        }catch(e){
            console.log('error from chatwin_focus');
        }
    });
    
    
    //页面加载完成后执行
    window.Electron.ipcRenderer.on('plugin-newChatWin-didFinishLoad',function(event){
    });
    
    
    //关闭窗口事件触发
    window.Electron.ipcRenderer.on('plugin-hideChatWin-cbHandle',function(event){
        PcNewWinUtil.pcChatClose();
    });
    
    
    //处理消息
    window.Electron.ipcRenderer.on('plugin-handleIMMsg-function',function(event,messageJson){
        var message = new FwMessage(messageJson);
        handleIMMsg(message);
    });
    
    //改变皮肤
    window.Electron.ipcRenderer.on('plugin-saveSkin-function',function(event,winid,obj){
        var jsonSkin = {'skin':obj};
        PcSysSettingUtils._configs = $.extend(PcSysSettingUtils._configs, jsonSkin);
        $("#skincss").attr("href","/social/css/skin/"+obj+"_wev8.css").attr("target", obj);
    });
    
    //在线状态
    window.Electron.ipcRenderer.on('plugin-setOtherLeftStatus-function',function(event,userid,userStatus,mobileStatus){
        setTimeout(
            function(){
                OnLineStatusUtil.setOtherLeftStatus(userid,userStatus,mobileStatus);
                OnLineStatusUtil.showUserStatusTip(userid,userStatus,mobileStatus);
        },800);
    });
    
    //修改未读数
    window.Electron.ipcRenderer.on('plugin-clearUnreadCount-function',function(event,winid,obj){
        HandleInterceptMsgUtils.clearUnreadCountNew(obj.targetId,obj.recentmsgcount);
    });
    
    
    //同步用户数据
    window.Electron.ipcRenderer.on('plugin-saveConfig-function',function(event,obj){
        PcSysSettingUtils._configs=obj.config;
    });
    
    //关闭聊天窗口
    window.Electron.ipcRenderer.on('plugin-closeChatWin-function',function(event,winid){
        PcNewWinUtil.pcChatClose();
    });

    //执行回调
    window.Electron.ipcRenderer.on('plugin-clientDo-functionCb',function(event,args,winid,json){
        if(args._do==='getDiscussion'){
            var discuss = new FwDiscussion(json);
            //存储在数组里面
            discussList[json.id] = discuss;
            if(typeof cbFunctionMap[args.uid] === 'function'){
                //执行完回调然后再把回调置为空
                cbFunctionMap[args.uid](discuss);
                delete cbFunctionMap[args.uid];
            }
        }else if(args._do==='getHistoryMessages'){
            if(typeof cbFunctionMap[args.uid] === 'function'){
                var history = json.HistoryMessages;
                var historyArray = new Array();
                for(var i = 0 ; i<history.length ; i++){
                    var historyMessage = new FwMessage(history[i]);
                    historyArray[i] = historyMessage;
                }
                json.HistoryMessages = historyArray;
                cbFunctionMap[args.uid](json);
            }
        }else if(args._do==='sendIMMsg'){
            if(typeof cbFunctionMap[args.uid] === 'function'){
                cbFunctionMap[args.uid](json);
            }
        }else if(args._do==='getClientIns'){
            if(typeof cbFunctionMap[args.uid] === 'function'){
                cbFunctionMap[args.uid](json.client);
            }
        }else if(args._do==='setDiscussionName'){
            if(typeof cbFunctionMap[args.uid] === 'function'){
                cbFunctionMap[args.uid](args.discussid,args.newDiscussName);
            }
        }else if(args._do==='resetGetHistoryMessages'){
            if(typeof cbFunctionMap[args.uid] === 'function'){
                cbFunctionMap[args.uid]();
            }
        }else if(args._do==='reconnect'){
            if(typeof cbFunctionMap[args.uid] === 'function'){
                cbFunctionMap[args.uid]();
            }
        }else if(args._do==='getDiscussionMemberIds'){
            if(typeof cbFunctionMap[args.uid] === 'function'){
                cbFunctionMap[args.uid](json);
            }
        }else if(args._do==='removeConversation'){
            if(typeof cbFunctionMap[args.uid] === 'function'){
                cbFunctionMap[args.uid](args.targetid);
            }
        }else if(args._do==='sendMessageToUser'){
            if(typeof cbFunctionMap[args.uid] === 'function'){
                cbFunctionMap[args.uid](json);
            }
        }else if(args._do==='setConversationToTop'){
            if(typeof cbFunctionMap[args.uid] === 'function'){
                cbFunctionMap[args.uid](args.targetid);
            }
        }else if(args._do==='addMemberToDiscussion'){
            if(typeof cbFunctionMap[args.uid] === 'function'){
                cbFunctionMap[args.uid]();
            }
        }
        else if(args._do==='quitDiscussion'){
            if(typeof cbFunctionMap[args.uid] === 'function'){
                cbFunctionMap[args.uid]();
            }
        }
        else if(args._do==='removeMemberFromDiscussion'){
            if(typeof cbFunctionMap[args.uid] === 'function'){
                cbFunctionMap[args.uid](json);
            }
        }
        else if(args._do==='loadIMDataList'){
            if(typeof cbFunctionMap[args.uid] === 'function'){
                cbFunctionMap[args.uid](json);
            }
        }
        else if(args._do==='sendMessageToDiscussion'){
            if(typeof cbFunctionMap[args.uid] === 'function'){
                if(json) cbFunctionMap[args.uid](json);
            }
        }
        else if(args._do==='updateTotalMsgCount'){
            if(typeof cbFunctionMap[args.uid] === 'function'){
                if(json) cbFunctionMap[args.uid](json);
            }
        }
        else if(args._do==='getDiscussionName'){
            if(typeof cbFunctionMap[args.uid] === 'function'){
                if(json) cbFunctionMap[args.uid](json);
            }
        }
        else if(args._do==='createDiscussion'){
            
           if(json){
               cbFunctionMap[args.uid].onSuccess(json);
           }else{
               cbFunctionMap[args.uid].onerror(json);
           }
        }
        else if(args._do==='setDiscussionAdmin'){
            if(typeof cbFunctionMap[args.uid] === 'function'){
                if(json) cbFunctionMap[args.uid]();
            }
        }
        else if(args._do==='setDiscussionIcon'){
            if(typeof cbFunctionMap[args.uid] === 'function'){
                if(json) cbFunctionMap[args.uid](json);
            }
        }
        else if(args._do==='getConversationCount'){
            if(typeof cbFunctionMap[args.uid] === 'function'){
                cbFunctionMap[args.uid](json);
            }
        }
    });
    
    //连接云对象方法
    var ClientUtil = {
        generateUid : function(){
            try{
                var uuid = window.Electron.require('node-uuid');
                return uuid.v4();
            }catch(err){
                return '';
            }
        },
        getDiscussion : function(discussid,callback){
           var obj = {
                '_do' : 'getDiscussion',
                'discussid' : discussid,
                'uid' : ClientUtil.generateUid()
                
            };
            ClientUtil.doWork(obj,callback);
        },
        removeMemberFromDiscussion : function(discussid,imUserid,callback){
           var obj = {
                '_do' : 'removeMemberFromDiscussion',
                'discussid' : discussid,
                'imUserid' : imUserid,
                'uid' : ClientUtil.generateUid()
            };
            ClientUtil.doWork(obj,callback);
        },
        addMemberToDiscussion : function(discussid,memList,callback){
           var obj = {
                '_do' : 'addMemberToDiscussion',
                'discussid' : discussid,
                'memList':memList,
                'uid' : ClientUtil.generateUid()
            };
            ClientUtil.doWork(obj,callback);
        },
        quitDiscussion : function(discussid,callback){
           var obj = {
                '_do' : 'quitDiscussion',
                'discussid' : discussid,
                'uid' : ClientUtil.generateUid()
            };
            ClientUtil.doWork(obj,callback);
        },
        setDiscussionName : function(discussid,newDiscussName,callback){
            var obj = {
                '_do' : 'setDiscussionName',
                'discussid' : discussid,
                'newDiscussName': newDiscussName,
                'uid' : ClientUtil.generateUid()
            };
            ClientUtil.doWork(obj,callback);
        },
        getDiscussionMemberIds : function (targetid,callback){
            var obj = {
                '_do' : 'getDiscussionMemberIds',
                'targetid' : targetid,
                'uid' : ClientUtil.generateUid()
            };
            ClientUtil.doWork(obj,callback);
        },
        resetGetHistoryMessages : function (targetType,targetid,callback){
            var obj = {
                '_do' : 'resetGetHistoryMessages',
                'targetType' : targetType,
                'targetid' : targetid,
                'uid' : ClientUtil.generateUid()
            };
            ClientUtil.doWork(obj,callback);
        },
        setConversationToTop : function (targetType,targetid,callback){
            var obj = {
                '_do' : 'setConversationToTop',
                'targetType' : targetType,
                'targetid' : targetid,
                'uid' : ClientUtil.generateUid()
            };
            ClientUtil.doWork(obj,callback);
        },
        removeConversation : function (targetType,targetid,callback){
            var obj = {
                '_do' : 'removeConversation',
                'targetType' : targetType,
                'targetid' : targetid,
                'uid' : ClientUtil.generateUid()
            };
            ClientUtil.doWork(obj,callback);
        },
         reconnect : function (callback){
            var obj = {
                '_do' : 'reconnect',
                'uid' : ClientUtil.generateUid()
            };
            ClientUtil.doWork(obj,callback);
        },
        clearMessagesUnreadStatus : function (targetType,targetid,callback){
            var obj = {
                '_do' : 'clearMessagesUnreadStatus',
                'targetType' : targetType,
                'targetid' : targetid,
                'uid' : ClientUtil.generateUid()
            };
            ClientUtil.doWork(obj,callback);
        },
        getClientIns : function (callback){
            var obj = {
                '_do' : 'getClientIns',
                'uid' : ClientUtil.generateUid()
            };
            ClientUtil.doWork(obj,callback);
        },
        sendMessageToUser : function (userid,msgObj,count,targettype,callback){
            var obj = {
                '_do' : 'sendMessageToUser',
                'userid' : userid,
                'msgObj':msgObj,
                'count' :count,
                'targettype' : targettype,
                'uid' : ClientUtil.generateUid()
            };
            ClientUtil.doWork(obj,callback);
        },
        //获取历史记录
        getHistoryMessages : function(targetType,targetid,pagesize,callback){
            var obj = {
                '_do' : 'getHistoryMessages',
                'targetType':targetType,
                'targetid':targetid,
                'pagesize':pagesize,
                'uid' : ClientUtil.generateUid()
            };
            ClientUtil.doWork(obj,callback);
        },
        sendIMMsg : function(targetid,msgObj,msgType,msgid,targetType,callback){
            var obj = {
                '_do' : 'sendIMMsg',
                'msgType':msgType,
                'targetid':targetid,
                'msgObj':msgObj,
                'msgid':msgid,
                'targetType':targetType||msgObj.targetType,
                'uid' : ClientUtil.generateUid()
            };
            ClientUtil.doWork(obj,callback);
        },
        doWork : function (obj,callback){
            if(callback!==undefined){
                cbFunctionMap[obj.uid] = callback;
            }
            if(WINID.mainwinid===undefined){
               WINID = window.Electron.ipcRenderer.sendSync('plugin-getWinIdInfo');
            }
            var winContents = window.Electron.remote.BrowserWindow.fromId(WINID.mainwinid).webContents;
            if(winContents){
                winContents.send('plugin-clientDo-function',obj,WINID);
            }
        },
        loadIMDataList : function(callback){
            var obj = {
                '_do' : 'loadIMDataList',
                'uid' : ClientUtil.generateUid()
            };
            ClientUtil.doWork(obj,callback);
        },
        sendMessageToDiscussion : function(targetid,msgObj,msgType,targetName, targetType,callback){
            var obj = {
                '_do' : 'sendMessageToDiscussion',
                'uid' : ClientUtil.generateUid(),
                'targetid' : targetid,
                'msgObj' : msgObj,
                'msgType' : msgType,
                'targetName':targetName,
                'targetType':targetType
            };
            ClientUtil.doWork(obj,callback);
        },
        updateTotalMsgCount : function(targetid,flag,chattype,count,callback){
            var obj = {
                '_do' : 'updateTotalMsgCount',
                'uid' : ClientUtil.generateUid(),
                'targetid' : targetid,
                'flag' : flag,
                'chattype':chattype,
                'count' : count,
            };
            ClientUtil.doWork(obj,callback);
        },
        getDiscussionName : function(result,callback){
            var obj = {
                '_do' : 'getDiscussionName',
                'uid' : ClientUtil.generateUid(),
                'result' : result
            };
            ClientUtil.doWork(obj,callback);
        },
        createDiscussion : function(disName,memList,callbackObj){
            var obj = {
                '_do' : 'createDiscussion',
                'uid' : ClientUtil.generateUid(),
                'disName' : disName,
                'memList' : memList
            };
            ClientUtil.doWork(obj,callbackObj);
        },
        setDiscussionAdmin : function(discussid,userid,callback){
            var obj = {
                '_do' : 'setDiscussionAdmin',
                'uid' : ClientUtil.generateUid(),
                'discussid' : discussid,
                'userid' : userid
            };
            ClientUtil.doWork(obj,callback);
        },
        setDiscussionIcon : function(discussid,imgurl,callback){
            var obj = {
                '_do' : 'setDiscussionIcon',
                'uid' : ClientUtil.generateUid(),
                'discussid' : discussid,
                'imgurl' : imgurl
            };
            ClientUtil.doWork(obj,callback);
        },
        getConversationCount: function(targetType,realTargetId,callback){
            var obj = {
                '_do' : 'getConversationCount',
                'uid' : ClientUtil.generateUid(),
                'targetType' : targetType,
                'realTargetId' : realTargetId
            };
            ClientUtil.doWork(obj,callback);
        },
        //同步窗口分离左侧窗口targetid
        updateChatWinID : function(targetId,callback){
            var obj = {
                '_do' : 'updateChatWinID',
                'uid' : ClientUtil.generateUid(),
                'targetId' : targetId
            };
            ClientUtil.doWork(obj,callback);
        },
        //同步窗口分离左侧窗口新消息提醒设置
        setNewMsgNotice : function(settingInfo,callback){
            var obj = {
                '_do' : 'setNewMsgNotice',
                'uid' : ClientUtil.generateUid(),
                'settingInfo' : settingInfo
            };
            ClientUtil.doWork(obj,callback);
        }
    };
    
    
    //最大化最小化
    var PcNewWinUtil = {
        pcChatMin : function(obj){
            var win = window.Electron.currentWindow;
            win.minimize();
        },
        
        pcChatButtonMouseEnter : function(obj){
            var _this = $(obj);
            _this.justToolsTip({
                animation:"fadeIn",
                height:"22px",
                theme: "theme-newChatWin",
                contents:_this.attr("data-title"),
                gravity:'bottom'
            });
            setTimeout(function(){
                PcNewWinUtil.pcChatButtonMouseLeave();
            },1000);
        },
        
        pcChatButtonMouseLeave : function(obj){
            $('.just-tooltip').remove();
        },
        
        pcChatMax : function(obj){
            var win = window.Electron.currentWindow;
            var chatdiv=$(obj).parents('.chatdiv');
            if(!isMainChatWinMax){
                $(obj).removeClass('pc-imChatMaxBtn').addClass('pc-imChatMaxBtn-re');
                $(obj).attr('data-title',social_i18n('PCRETURN'));
                if(chatdiv.find('.fixphone').length > 0){
                    chatdiv.find('.fixphone').removeClass('fixphoneEllipsis1');
                    chatdiv.find('.fixphone').removeClass('fixphoneEllipsis2');
                }
                if(chatdiv.find('.mobilephone').length > 0){
                    chatdiv.find('.mobilephone').removeClass('mobilephoneEllipsis');
                    chatdiv.find('.mobilephone').removeClass('mobilephoneEllipsis1');
                }
            }else{
                $(obj).removeClass('pc-imChatMaxBtn-re').addClass('pc-imChatMaxBtn');
                $(obj).attr('data-title',social_i18n('PCMAX'));
                if(chatdiv.find('.mobilephone').length > 0){
                    if(chatdiv.find('.fixphone').length > 0){
                        chatdiv.find('.fixphone').addClass('fixphoneEllipsis1');
                        chatdiv.find('.mobilephone').addClass('mobilephoneEllipsis');
                    }else{
                        chatdiv.find('.mobilephone').addClass('mobilephoneEllipsis1');
                    }
                }else{
                    if(chatdiv.find('.fixphone').length > 0){
                        chatdiv.find('.fixphone').addClass('fixphoneEllipsis2');
                    }
                }
            };
            if(isMainChatWinMax){
               win.unmaximize();
               isMainChatWinMax = false;
            }else{
               win.maximize();
               isMainChatWinMax = true;
            }
        },
        
        pcChatClose : function(obj){
            var win = window.Electron.currentWindow;
            $('.just-tooltip').remove();
            win.hide();
            //清理缓存
            //win.webContents.session.clearCache(function() {});
            var tabObj = $('#chatIMTabs').find(".chatIMTabItem");
            
            tabObj.each(function(i,obj){
                beforeCloseTabWin($(obj).find('.tabClostBtn'));
                ClientUtil.updateChatWinID('');
            });
        },
        
        pcChatOnTopShow : function(obj){
            if($('#windowTool').is(":hidden")){
                $('#windowTool').show();
            }else{
                $('#windowTool').hide();
            }       
            stopEvent();
        },
        
        pcChatOnTopTool : function(obj){
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
        }
    };
    
    //自定义discuss对象
    function FwDiscussion(json){
        var u = json.isDisableAddUser,
            d = json.isDisableMsgRead;
        this.id = json.id;
        this.creatorId = json.creatorId;
        this.memberIdList = typeof json.memberIdList === 'String' ? json.memberIdList.spilt(','):json.memberIdList;
        this.icon = json.icon;
        this.name = json.name;
        this.isDisableAddUser = function () {
            return u;
        };
        this.isDisableMsgRead = function () {
            return d;
        };

    };
    
    FwDiscussion.prototype.getCreatorId = function(){
        return this.creatorId;
    };
    
    FwDiscussion.prototype.setCreatorId = function(creatorId){
        this.creatorId = creatorId;
    };
    
    FwDiscussion.prototype.getId = function(){
        return this.id;
    };
    
    FwDiscussion.prototype.setId = function(id){
        this.id = id;
    };
    
    FwDiscussion.prototype.getMemberIdList = function(){
        return this.memberIdList;
    };
    
    FwDiscussion.prototype.setMemberIdList = function(memArry){
        this.memberIdList = memArry;
    };
    
    FwDiscussion.prototype.getIcon = function(){
        return this.icon;
    };
    
    FwDiscussion.prototype.setIcon = function(icon){
        this.icon = icon;
    };
    
    FwDiscussion.prototype.getName = function(){
        return this.name;
    };
    
    FwDiscussion.prototype.setName = function(name){
        this.name = name;
    };
    
    FwDiscussion.prototype.toJson = function(){
        var  jsonObj = {
            'creatorId' : this.getCreatorId(),
            'memberIdList' : this.getMemberIdList(),
            'name' : this.getName(),
            'id' :  this.getId(),
            'icon' : this.getIcon()
        };
        return jsonObj;
    };

    function FwMessage(json){
        this.content = json.content;
        this.objectName = json.objectName;
        this.messageId = json.messageId;
        this.detail = json.detail;
        this.messageUId = json.messageUId;
        this.senderUserId = json.senderUserId;
        this.extra = json.extra;
        this.targetId = json.targetId;
        this.messageType = json.messageType;
        this.conversationType = json.conversationType;
        this.messageTag = json.messageTag;
        this.count = json.count;
        this.sentTime = json.sentTime;
        this.type = json.type;
        this.poi = json.poi ;
        this.imageUri = json.imageUri;
        this.longitude = json.longitude;
        this.latitude = json.latitude;
        this.duration = json.duration;
        this.operator = json.operator;
        this.extension = json.extension;
    };
    
    FwMessage.prototype.getContent = function(){
        return this.content;
    };
    
    FwMessage.prototype.setContent = function(content){
        this.content = content;
    };
    
    FwMessage.prototype.getObjectName = function(){
        return this.objectName;
    };
    
    FwMessage.prototype.setObjectName = function(objectName){
        this.objectName = objectName;
    };
    
    FwMessage.prototype.getMessageId = function(){
        return this.messageId;
    };
    
    FwMessage.prototype.setMessageId = function(messageId){
        this.messageId = messageId;
    };
    
    FwMessage.prototype.getDetail = function(){
        return this.detail;
    };
    
    FwMessage.prototype.setDetail = function(detail){
        this.detail = detail;
    };
    
    FwMessage.prototype.getMessageUId = function(){
        return this.messageUId;
    };
    
    FwMessage.prototype.setMessageUId = function(messageUId){
        this.messageUId = messageUId;
    };
    
    FwMessage.prototype.getSenderUserId = function(){
        return this.senderUserId;
    };
    
    FwMessage.prototype.setSenderUserId = function(senderUserId){
        this.senderUserId = senderUserId;
    };
    
    FwMessage.prototype.getExtra = function(){
        return this.extra;
    };
    
    FwMessage.prototype.setExtra = function(extra){
        this.extra = extra;
    };
    
    
    FwMessage.prototype.getTargetId = function(){
        return this.targetId;
    };
    
    FwMessage.prototype.setTargetId = function(targetId){
        this.targetId = targetId;
    };
    
    FwMessage.prototype.getMessageType = function(){
        if(this.messageType.value!==undefined){
            return this.messageType.value;
        }else{
            return this.messageType;
        }
    };
    
    FwMessage.prototype.setMessageType = function(messageType){
        if(messageType.value!==undefined){
            this.messageType.value = messageType.value;
        }else{
            this.messageType = messageType;
        }
    };
    
    FwMessage.prototype.getConversationType = function(){
        if(this.conversationType.value!==undefined){
            return this.conversationType.value;
        }else{
            return this.conversationType;
        }
    };
    
    FwMessage.prototype.setConversationType = function(conversationType){
        if(conversationType.value!==undefined){
            this.conversationType.value = conversationType.value;
        }else{
            this.conversationType = conversationType;
        }
    };
    
    FwMessage.prototype.getMessageTag = function(){
        return this.messageTag;
    };
    
    FwMessage.prototype.setMessageTag = function(messageTag){
        this.messageTag = messageTag;
    };
    
    FwMessage.prototype.getCount = function(){
        return this.count;
    };
    
    FwMessage.prototype.setCount = function(count){
        this.count = count;
    };
    
    FwMessage.prototype.getSentTime = function(){
        return this.sentTime;
    };
    
    FwMessage.prototype.setSentTime = function(sentTime){
        this.sentTime = sentTime;
    };
    
    FwMessage.prototype.getType = function(){
        return this.type;
    };
    
    FwMessage.prototype.setType = function(type){
        this.type = type;
    };
    

    FwMessage.prototype.getPoi = function(){
        return this.poi;
    };
    
    FwMessage.prototype.setPoi = function(poi){
        this.poi = poi;
    };
    
    FwMessage.prototype.getImageUri = function(){
        return this.imageUri;
    };
    
    FwMessage.prototype.setImageUri = function(imageUri){
        this.imageUri = imageUri;
    };
    
    FwMessage.prototype.getLongitude = function(){
        return this.longitude;
    };
    
    FwMessage.prototype.setLongitude = function(longitude){
        this.longitude = longitude;
    };
    
    FwMessage.prototype.getLatitude = function(){
        return this.latitude;
    };
    
    FwMessage.prototype.setLatitude = function(latitude){
        this.latitude = latitude;
    };
    
    FwMessage.prototype.getDuration = function(){
        return this.duration;
    };
    
    FwMessage.prototype.setDuration = function(duration){
        this.duration = duration;
    };
    
    
    FwMessage.prototype.getOperator = function(){
        return this.operator;
    };
    
    FwMessage.prototype.setOperator = function(operator){
        this.operator = operator;
    };
    
    FwMessage.prototype.getExtension = function(){
        return this.extension;
    };
    
    FwMessage.prototype.setExtension = function(extension){
        this.extension = extension;
    };
    

    
</script>
