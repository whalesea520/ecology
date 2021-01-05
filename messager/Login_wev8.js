var Login={
	doLogin:function (){
		  $(document.body).find("#divConnectting").find(".showMsg").html(
				"<img src='/messager/images/logining_wev8.gif' height='40px'   align='absmiddle'/><br><b>"+rMsg.loadding+"...</b>"
		  );
	
		  con = new JSJaCHttpBindingConnection({
			 oDbg: Debug, 
			 httpbase:Config.HTTPBASE,
			 timerval:2000
		 });		 	        

		 con.registerHandler('iq',XmppReceive.handleIQSet);
		 con.registerHandler('presence',XmppReceive.handlePresence);
		 con.registerHandler('message',XmppReceive.handleMessage);
		 con.registerHandler('message',XmppReceive.handleMessageError);
		 con.registerHandler('ondisconnect',XmppReceive.handleDisconnect);
		 con.registerHandler('onconnect',XmppReceive.handleConnected);
		 con.registerHandler('onerror',XmppReceive.handleConError);
		  
		con.connect({			
			 domain:Config.JABBERSERVER,
			 username:jid.substring(0,jid.indexOf('@')),
			 resource:jid.substring(jid.indexOf('/')+1),
			 pass:psw,
			 register:false
		});
		
		onlstat="available";
		Page.config.isLogoOuted=false;
		 // setPollInterval(<int> timerval)  
		
		
	}
}