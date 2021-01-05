var XmppSend={
	_waitCon:function(){
		while(true){
			Debug.log("wait");
			
			if(con!=null){
				
				return;
			} 
		}
	},

	refreshCon:function(){	
		if(con==null){
			Login.doLogin(jid,psw,Debug);
			//XmppSend._waitCon();			
		}
	},
	preSend:function(){
		
	},

	sendMessage:function(sendTo,msg){
		if (msg== '' || sendTo == '')	return false;
		//if (sendTo.indexOf('@') == -1)	sendTo += '@' + Config.JABBERSERVER;
		
		var aMsg = new JSJaCMessage();
		aMsg.setTo(sendTo);
		aMsg.setBody(msg);
		if(sendTo.indexOf("conference")!=-1){
			aMsg.setType('groupchat');	
		}
		
		con.send(aMsg);			
	},
	getAllList:function(){	
		var iq = new JSJaCIQ();
		iq.setIQ(null,'get','weavermessager_roster');
		iq.setQuery('jabber:iq:roster');
		
		Debug.log("do");
		con.send(iq,XmppReceive.handleRoster);
	
	},
	getAllOnlineList:function(){		
		
		var iq = new JSJaCIQ();
		iq.setIQ(null,'get','weavermessager_prefs');
		var query = iq.setQuery('jabber:iq:private');
		query.appendChild(iq.buildNode('weavermessager', {'xmlns': 'weavermessager:prefs'}));

		con.send(iq,XmppReceive.handlePrefs);
		
	
	},
	getChatList:function(){		

		var iq = new JSJaCIQ();
		iq.setType('get');
		iq.setTo(Config.DEFAULTCONFERENCESERVER);
		iq.setID(Config.DEFAULTCONFERENCESERVER+"IQ");
		iq.setQuery('http://jabber.org/protocol/disco#items');
		
		con.send(iq,XmppReceive.handleChatList);
	},
	joinToChat:function(chatid,nickname){
		var pass="";
		var aPresence = new JSJaCPresence();
		aPresence.setTo(chatid+'/'+nickname); 
		var x = aPresence.appendNode('x',{'xmlns': 'http://jabber.org/protocol/muc'});
		if (typeof(pass) != 'undefined' && pass != '') x.appendChild(aPresence.buildNode('password' ,pass)); 

		aPresence.setShow("available");
		aPresence.setStatus("online"); 
		con.send(aPresence); 
	},
	getChatNeedConfig:function(toJid){
		alert(toJid)
		  var iq = new JSJaCIQ();
		  iq.setTo(toJid);
		  iq.setType('get');
		  iq.setQuery('http://jabber.org/protocol/muc#owner');
		  con.send(iq, XmppReceive.handleChatConfig);
	},
	sendChatInit:function(){
		var aPresence = new JSJaCPresence();
		aPresence.setTo(Page.chatPara.chatId+'/'+nickname);
		var x = aPresence.appendNode('x', {'xmlns': 'http://jabber.org/protocol/muc'});		
		aPresence.setShow('');		
		aPresence.setStatus('');
		Debug.log("sending muc presence:\n"+aPresence.xml(),3);		
		con.send(aPresence);				  
	},
	sendChatConfig:function(){		
		ownerJid=Page.chatPara.ownerJid			
		toJid=Page.chatPara.chatId;
		chatName=Page.chatPara.chatName;
		
		var xmlStr='<x xmlns="jabber:x:data" type="submit"><field var="FORM_TYPE"><value>http://jabber.org/protocol/muc#roomconfig</value>'+
		'</field><field var="muc#roomconfig_roomname"><value>'+chatName+'</value></field><field var="muc#roomconfig_roomdesc">'+
		'<value>'+chatName+'</value></field><field var="muc#roomconfig_changesubject"><value>0</value></field>'+
		'<field var="muc#roomconfig_maxusers"><value>30</value></field><field var="muc#roomconfig_publicroom"><value>1</value>'+
		'</field><field var="muc#roomconfig_persistentroom"><value>0</value></field><field var="muc#roomconfig_moderatedroom">'+
		'<value>0</value></field><field var="muc#roomconfig_membersonly"><value>0</value></field><field var="muc#roomconfig_allowinvites">'+
		'<value>0</value></field><field var="muc#roomconfig_passwordprotectedroom"><value>0</value></field>'+
		'<field var="muc#roomconfig_whois"><value>anyone</value></field><field var="muc#roomconfig_enablelogging">'+
		'<value>0</value></field><field var="x-muc#roomconfig_reservednick"><value>0</value></field>'+
		'<field var="x-muc#roomconfig_canchangenick"><value>1</value></field><field var="x-muc#roomconfig_registration"><value>1</value>'+
		'</field><field var="muc#roomconfig_roomowners"><value>'+ownerJid+'</value></field></x>';	
			
		  var iq = new JSJaCIQ();
	      iq.setType('set');
	      iq.setTo(toJid);
	      var query = iq.setQuery('http://jabber.org/protocol/muc#owner');

	      var xmldoc = XmlDocument.create('body','foo');
	      xmldoc.loadXML('<body>'+xmlStr+'</body>');
	      
	      for (var i=0; i<xmldoc.firstChild.childNodes.length; i++){
	        query.appendChild(xmldoc.firstChild.childNodes.item(i).cloneNode(true));
	      }
	      		
	      con.send(iq);
	},
	sendDestroyChat:function(chatid){		
		 var iq = new JSJaCIQ();
	     iq.setType('set');
	     iq.setTo(chatid);
	     var query = iq.setQuery('http://jabber.org/protocol/muc#owner');
	     query.appendChild(iq.getDoc().createElement('destroy')).appendChild(iq.getDoc().createElement('reason')).appendChild(iq.getDoc().createTextNode('Close'));
	     con.send(iq);	
	},
	sendMyState:function(){		
	   var aPresence = new JSJaCPresence();
	   aPresence.setType(onlstat);
	   con.send(aPresence);
	}	
}