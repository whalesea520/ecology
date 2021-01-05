 	<!--CSS-->
	<LINK href="/messager/ui_wev8.css" type="text/css" rel="STYLESHEET">
     
    <!-- For Jquery -->
    <script type="text/javascript" src="/messager/jquery_wev8.js"></script>
	<script type="text/javascript" src="/messager/tree/jquery.tree.debug_wev8.js"></script>
	<script type="text/javascript" src="/messager/jquery/jquery.draggable_wev8.js"></script>

	<LINK href="/messager/jquery/autoSearchComplete/autoSearchComplete_wev8.css" type="text/css" rel="STYLESHEET">
	<script type="text/javascript" src="/messager/jquery/autoSearchComplete/jquery.AutoSearchComplete_wev8.js"></script>
	
	
	
	 <!-- For XMPP -->
	<script type="text/javascript" src="/messager/jsjac_wev8.js"></script>      
    <script type="text/javascript" src="/messager/Debugger_wev8.js"></script>
	<script type="text/javascript" src="/messager/XmppReceive_wev8.js"></script>
	<script type="text/javascript" src="/messager/XmppSend_wev8.js"></script>	
   
   	<!-- For Other -->
   	<%@ include file="/messager/Config.jsp" %>
   	<script type="text/javascript" src="/js/ArrayList_wev8.js"></script>
	<script type="text/javascript" src="/messager/Util_wev8.js"></script>	
	<script type="text/javascript" src="/messager/Login_wev8.js"></script>

	<script type="text/javascript" src="/messager/Multimedia_wev8.js"></script>	
	<script type="text/javascript" src="/messager/Page_wev8.js"></script>
	
	

	 <!-- For Window -->	
	<script type="text/javascript" src="/messager/window/ControlWindow_wev8.js"></script>
	<script type="text/javascript" src="/messager/window/BaseWindow_wev8.js"></script>
	<script type="text/javascript" src="/messager/window/MessageWindow_wev8.js"></script>
	<script type="text/javascript" src="/messager/window/ChatWindow_wev8.js"></script>
	
	 <!-- For User -->	
	
	<script type="text/javascript" src="/messager/user/ControlUser_wev8.js"></script>
	<script type="text/javascript" src="/messager/user/BaseUser_wev8.js"></script>	
	<script type="text/javascript" src="/messager/user/MessageUser_wev8.js"></script>
	<script type="text/javascript" src="/messager/user/ChatUser_wev8.js"></script>
	
	<SCRIPT LANGUAGE="JavaScript">
	var con=null,Debug;
	var flag="1#1";
	
	var onlprio = Config.DEFAULTPRIORITY;
	var onlstat = 'available';
	var onlmsg = 'Want to Talk!';

	
	var jidCurrent="zdp@"+Config.JABBERSERVER+"/weavermessager";
	var msgCurrent="msg";
	var jid=jidCurrent;
	
	var psw="1";
	var nickname="Hunk";	
	var imgWindow;
	var wCreateChatConfig;
	function initDebug(){		
		if (!Debug || typeof(Debug) == 'undefined' || !Debug.start) {
			if (typeof(Debugger) != 'undefined'){
				Debug = new Debugger(Config.DEBUG_LVL,'WeaverMessager_' + Util.cutResource(jid));
			}else {
				Debug = new Object();
				Debug.log = function() {};
				Debug.start = function() {};
			}
		}

		if (Config.USE_DEBUGJID && Config.DEBUGJID == Util.cutResource(jid)){
			Debug.start();
		}

		Debug.log("jid: "+jid+"\npass: "+psw,2);
	}
	$(document).ready( function() {
		initDebug();	
		Login.doLogin();		
	});	
		
	</SCRIPT>