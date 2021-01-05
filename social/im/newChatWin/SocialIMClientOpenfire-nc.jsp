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
    
    var M_CORE = RongIMClient;
    IMClient = function() {};
    // 定义IMClient对象
    IMClient.prototype = new Object();
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
    
    //初始化音频播放
    M_CORE.RongIMVoice.init();
    
    var client = {};
    var cbFunctionMap = [];
    var userInfos={};
    var discussList={};
    var settingInfos={};
    var localmsgtags={};
    var isIMdebug=false;
    userInfos[M_USERID]={"userid":"<%=userid%>","userName":"<%=user.getLastname()%>","userHead":"<%=messageUrl%>","deptName":"<%=SocialUtil.getUserDepCompany(userid)%>","jobtitle":"<%=jobtitle%>","mobile":"<%=mobile%>","mobileShow":"<%=mobileShow%>","py":"<%=py%>","signatures":"<%=signatures%>"};
    
</script>