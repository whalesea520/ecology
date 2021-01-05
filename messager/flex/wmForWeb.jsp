
<%@ page language="java" contentType="text/html; charset=UTF-8"%>


<jsp:useBean id="PluginLicense" class="weaver.license.PluginLicenseForInterface" scope="page" />
<jsp:useBean id="GetPhysicalAddress" class="weaver.system.GetPhysicalAddress" scope="page" />
<jsp:useBean id="PluginUserCheck" class="weaver.license.PluginUserCheck" scope="page" />
<jsp:useBean id="MessagerSettingCominfo" class="weaver.messager.MessagerSettingCominfo" scope="page" />
<%@ page import="weaver.general.Util"%>

<%@ include file="/page/maint/common/initNoCache.jsp" %>

<%
	request.setCharacterEncoding("UTF-8");
	String loginid = Util.null2String(request.getParameter("loginid"));
	String psw = Util.null2String(request.getParameter("psw"));
	String width = Util.null2String(request.getParameter("width"));
	String height = Util.null2String(request.getParameter("height"));
	
	int pingInterval = Util.getIntValue(Util.null2String(MessagerSettingCominfo.getSettingValueByName("PingInterval")),15000);
	
	int licenseState=PluginLicense.getLicenseState("messager");
	int userAccess = PluginUserCheck.checkPluginUserRight("messager",user.getUID()+"");
	licenseState=1;
	userAccess=1;
	if(licenseState!=1){ 
		out.println("<div style='border:1px solid #ccc;padding:20px;padding-top:200px;padding-bottom:200px;'>"+PluginLicense.getErrorMsg(licenseState)+"<br>"+SystemEnv.getHtmlLabelName(24528, user.getLanguage())+"。<br>"+SystemEnv.getHtmlLabelName(18639, user.getLanguage())+":<br>"
				+"<span style='word-break:break-all'>"+Util.getEncrypt(GetPhysicalAddress.getPhysicalAddress())+"</span></div>");
	} else if(userAccess!=1) {
		out.println("<div style='border:1px solid #ccc;padding:20px;padding-top:200px;padding-bottom:200px;'>"+SystemEnv.getHtmlLabelName(24529, user.getLanguage())+"!</div>"); 
	} else {
%>
	<style type="text/css" media="screen">
	object:focus {
		outline: none;
	}
	
	#flashContent {
		display: none;
	}
	</style>
	
	<script type="text/javascript" src="/messager/flex/swfobject_wev8.js"></script>
	<script type="text/javascript">           
	    var swfVersionStr = "10.0.0";            
	    var xiSwfUrlStr = "/messager/flex/playerProductInstall.swf";
	    var flashvars = {
	    		loginid:"<%=loginid%>",
	    	    psw:"<%=psw%>",
	    		remoteEcologyServer:"",
	    		remoteServiceUrl:"/Messager/MessagerServlet",
	    		remoteOpenFireServer:Config.JABBERSERVER,
	    		pingInterval:"<%=pingInterval%>"
	    };
	    var params = {};
	    params.quality = "high";
	    params.bgcolor = "#ffffff";
	    params.allowscriptaccess = "sameDomain";
	    params.allowfullscreen = "true";
	    //params.wmode="transparent";
	    var attributes = {};
	    attributes.id = "wmForWeb";
	    attributes.name = "wmForWeb";
	    attributes.align = "middle";
	    swfobject.embedSWF(
	        "/messager/flex/wmForWeb.swf", "flashContent", 
	        "<%=width%>", "<%=height%>", 
	             swfVersionStr, xiSwfUrlStr, 
	             flashvars, params, attributes);			
	swfobject.createCSS("#flashContent", "display:block;text-align:left;");
	     </script>
	<div id="flashContent">
	<p>To view this page ensure that Adobe Flash Player version 10.0.0
	or greater is installed.</p>
	<script type="text/javascript"> 
					var pageHost = ((document.location.protocol == "https:") ? "https://" :	"http://"); 
					document.write("<a href='http://www.adobe.com/go/getflashplayer'><img src='" 
									+ pageHost + "www.adobe.com/images/shared/download_buttons/get_flash_player_wev8.gif' alt='Get Adobe Flash player' /></a>" ); 
				</script></div>


<%}%>

<script language="javascript">	
	var isMesasgerUnavailable=true; 
	var jidCurrent="<%=loginid%>"+"@"+Config.JABBERSERVER;
	var windowTitleOld=window.document.title;
	/*For common*/
	function getUserIconPath(loginid) {
		str = document.getElementById("wmForWeb").getUserIconPath(loginid);
		return str;
	}
	function changeMessageWindowIcon(item) {
		//alert(item.loginid+"===="+item.state+"====="+ControlWindow.isWindowExist(item.loginid))
		if (ControlWindow.isWindowExist(item.loginid)) {
			ControlWindow.getWindow(item.loginid).changeLogo(getUserStateImg(item.state));
		}
	}
	function reloadMyLogo(){	
		document.getElementById("wmForWeb").reloadMyLogo();	
	}	
	function logoutForMessager() {
		try {
			document.getElementById("wmForWeb").doDisconnect();
		} catch (e) {
		}
	}
	function openHistory(item) {
		try {
			openPage("allhistory",jidCurrent,rMsg.toolHistory);
		} catch (e) {
			
		}
	}
	
	
	/*For Presence Manager begin..............*/
	function getUserStateImg(state) {
		switch (state) {
		case "Free To Chat":
			return "/messager/images/status/im_free_chat_wev8.png";
		case "Available":
			return "/messager/images/status/im_available_wev8.png";
		case "Away":
			return "/messager/images/status/im_away_wev8.png";
		case "On Phone":
			return "/messager/images/status/on-phone_wev8.png";
		case "Extended Awa":
			return "/messager/images/status/im_away_wev8.png";
		case "On The Road":
			return "/messager/images/status/airplane_wev8.png";
		case "Do Not Disturb":
			return "/messager/images/status/im_dnd_wev8.png";
		case "msg":
			return "/messager/images/msgComing_wev8.gif";
		default:
			return "/messager/images/status/im_unavailable_wev8.png";
		}
	}
	function changeMyPrense(user) {
		if (user.state == "unavailable") {
			$("#divMessager").fadeOut("normal"); 	
			isMessagerShow=false;
			
			$("#tdMessageState").html("");
			$("#tdMessageState").append("<img src='" + getUserStateImg(user.state) + "' id='imgMsgStateBar' align='absmiddle'  width='16px' title='" + rMsg.offline + "' isMsgAlert='false'/>");;
			isMesasgerUnavailable = true;
		} else {
			if ($("#imgMsgStateBar").attr("isMsgAlert") != "true") {
				$("#tdMessageState").html("");
				$("#tdMessageState").append("<img src='" + getUserStateImg(user.state) + "' id='imgMsgStateBar' align='absmiddle'  width='16px' title='" + user.sign + "'/>");;
			}
			isMesasgerUnavailable = false;
		}
	}
	/*For Msg Manager begin..............*/
	function isMessageWindowShow(msg) {
		var fromJid = msg.fromJid;

		if (ControlWindow.isWindowExist(fromJid)) {
			var win = ControlWindow.getWindow(fromJid);
			return win.isShow;

		} else {
			return false;
		}
	}

	function messageWindowShow(msg, user) {	
		var img = getUserStateImg(user.state)
		var win = ControlWindow.getWindow(user.loginid, user.lastname, img, img,user);
		win.show();
		if(msg!=null){		
			ControlWindow.getWindow(msg.fromJid).receive(msg.body, msg.fromJid,msg.receiveTime)
		}
	}

	function messagerIconStateShow(count, state, sign) {
		if (count > 0) {
			$("#tdMessageState").html("");
			$("#tdMessageState").append("<img src='" + getUserStateImg("msg") + "' id='imgMsgStateBar' align='absmiddle'  width='16px' title='" + rMsg.controlUserMessageHave + count +rMsg.controlUserMessageCount + "' isMsgAlert='true'/>");;
		} else {
			$("#tdMessageState").html("");
			$("#tdMessageState").append("<img src='" + getUserStateImg(state) + "' id='imgMsgStateBar' align='absmiddle'  width='16px' title='" + sign + "' isMsgAlert='false'/>");;
		}
	}
	function windowTitleMsg(strMsg) {
		if ($.trim(strMsg) != "") {	
			TitleFlash.setTitle(strMsg);
			TitleFlash.go();
		} else {
			//alert(windowTitleOld)
			TitleFlash.stop();
			window.setTimeout(function() {
				document.title=windowTitleOld;	
			}, 1000);
		}
	}
	function doShowAllTempMsg() {
		try{		
			document.getElementById("wmForWeb").popAllMsg();
		} catch(e){}
	}
	function sendMessage(sendto, msg) {
		//msg=msg+"&nbsp;";
		document.getElementById("wmForWeb").sendMessage(sendto, msg);
	}

	/*For TitleFlash.................
	 * 调用方法
	 * TitleFlash.stop();
	 * TitleFlash.setTitle(str);
	 * TitleFlash.go();
	 */
	var TitleFlash = (function() {
		var msg = "";
		var msgud = " " + msg;
		var isStop=false;

		function titleScroll() {
			try{

				if (msgud.length < msg.length)
					msgud += " - " + msg;
				msgud = msgud.substring(1, msgud.length);
	
				if (!isStop) {
					T = window.setTimeout(function() {
						titleScroll()
					}, 500)
					
					document.title = msgud.substring(0, msg.length);
				} else {
					msg = "";
					msgud = " " + msg;
				}
			} catch(e){
			}

		}
		return {
			setTitle : function(title) {
				msg = title;
			},
			go : function() {
				titleScroll();
			},
			stop : function() {
				isStop=true
			}
		}

	})();


	 var Page={
		showMessage:function(loginid){
	 		document.getElementById("wmForWeb").popSomeBodyMsg(loginid);
		}
	 }
	 
	function messageTips(msg) {
		document.getElementById('msgTips').contentWindow.doPopup("1,<tr><td width='13'><img src='/images/PopupMsgDot_wev8.gif'></td><td><a href='#' id='messagerTips'>" + msg + "</a></td></tr>");
	}
</script>
