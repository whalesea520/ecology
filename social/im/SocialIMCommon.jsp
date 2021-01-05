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
	Boolean isxp = Boolean.parseBoolean(request.getParameter("isxp"));
    String serverIp = Util.null2String(request.getParameter("serverIp"), "null");
    Boolean nwFlag=false;
    if(isAllow.equals("")||isAllow.equals("undefined")){
        nwFlag = false;
    }else{
        nwFlag = true;
    }
    // boolean pcIsWinodws = "Windows".equals(pcOS);
    // boolean pcIsOSX = "OSX".equals(pcOS);
    // boolean pcIsLinux = "Linux".equals(pcOS);
    
    Calendar calendar = TimeUtil.getCalendar(TimeUtil.getCurrentDateString());
	calendar.add(Calendar.DATE, 1);
	String zeroTimeMillis = calendar.getTimeInMillis()+"";
%>
<script>var CUST_SERV_IP = '<%=serverIp%>'; var IS_BASE_ON_OPENFIRE = <%=IS_BASE_ON_OPENFIRE%>; var M_SDK_VER = <%=RONG_SDK_VER%>; var ZERO_TIME_MILLIS = <%=zeroTimeMillis%>; var IS_USE_APPDETACH = <%=isUseAppDetach%></script>

<script type="text/javascript" src="/js/select/script/jquery-1.8.3.min_wev8.js"></script>
<script> var jq183=$; var loginuserid = "<%=user.getUID()%>"; var languageid = '<%=user.getLanguage()%>'</script>

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

<link type='text/css' rel='stylesheet'  href='/social/js/treeviewAsync/eui.tree_wev8.css'/>
<script language='javascript' type='text/javascript' src='/social/js/treeviewAsync/jquery.treeview_wev8.js'></script>
<script language='javascript' type='text/javascript' src='/social/js/treeviewAsync/jquery.treeview.async_wev8.js'></script>
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
<jsp:include page="/social/im/SocialIMUtil.jsp"></jsp:include> 

<!--引入ztree-->
<script type="text/javascript" src="/social/js/jquery.ztree/jquery.ztree.core.min.js"></script>
<link rel="stylesheet" href="/social/js/jquery.ztree/zTreeStyle_wev8.css" type="text/css">
<!-- 引入superfish -->
<script type="text/javascript" src="/social/js/superfish/superfish.js"></script>
<script type="text/javascript" src="/social/js/superfish/hoverIntent.js"></script>
<link rel="stylesheet" href="/social/js/superfish/superfish.css" type="text/css">
<link rel="stylesheet" href="/social/js/superfish/superfish-vertical.css" type="text/css">
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
<jsp:include page="/social/im/SocialIMClientOpenfire.jsp"></jsp:include>
<% } else if(RONG_SDK_VER.equals("1")) { %>
<!-- 融云 -->
<jsp:include page="/social/im/SocialIMClient.jsp"></jsp:include>
<% } else if(RONG_SDK_VER.equals("2")) {%>
<jsp:include page="/social/im/SocialIMClient-sdk2.jsp"></jsp:include>
<%} %>


<script src="/social/im/js/ChatUtil_wev8.js"></script>
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
<%
if (isxp) {
%>
<script src="/social/im/js/im_pc_wev8-nw.js"></script>
<%
} else {
%>
<script src="/social/im/js/im_pc_wev8.js"></script>
<%
}
%>
<script src="/social/im/js/im_pcmodels_wev8.js"></script>
<!-- 皮肤 -->
<link rel="stylesheet" href="/social/css/skin/<%=skin%>_wev8.css" type="text/css" media="screen" id="skincss" target="<%=skin %>"/>

    <% if(!"1".equals(SocialClientProp.getPropValue(SocialClientProp.FORBIT_FILETRANSFER)) && !"1".equals(SocialClientProp.getPropValue(SocialClientProp.FORBIT_FOLDERTRANSFER))) { if(isxp){%>
	<script src="/social/im/js/im_pc_senddir_wev8-nw.js"></script>
	<%}else{%>
	<script src="/social/im/js/im_pc_senddir_wev8.js"></script>
	<%}%>
<%
        }
    }
%>
<%@ include file="/hrm/resource/simpleHrmResource_wev8.jsp" %>