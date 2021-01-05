var XmppReceive={
	handleIQSet:function (iq) {
		 Debug.log('handleIQSet')	
		 Debug.log(iq.xml(),2);			
	},
    handlePresence:function(presence) {
		Debug.log('handlePresence',2)
		Debug.log(presence.xml(),2);

		var from = presence.getFrom();
	    var type = presence.getType();
	    var show = presence.getShow();
	    var status = presence.getStatus();
	    
		if(from.indexOf("conference")!=-1){ //chat在线人员	
			
			var x = presence.getChild('x', 'http://jabber.org/protocol/muc#user');			
			var aItem = x.getElementsByTagName('item').item(0);
		    
		    var affiliation = aItem.getAttribute('affiliation');
		    var role = aItem.getAttribute('role');
		    var nick = Util.getResourceName(from);
		    var realjid = aItem.getAttribute('jid');		    
		    var  cu=new ChatUser({
		    	affiliation:affiliation,
		    	role:role,
		    	nick:nick,
		    	jid:realjid,
		    	status:status
		    });	
		   	    
		    
		    var xStatusCode="";
		    try{
		    	xStatusCode=x.getElementsByTagName('status').item(0).getAttribute('code');		   		    	
		    } catch(e){}
		    
			if(xStatusCode=="201"){//新建会议成功
				XmppSend.sendChatConfig();
			} else {
				var winChat=ControlWindow.getWindow(from);
				if(type=="unavailable" && xStatusCode!="303") {
					winChat.removeChateUser(cu);
				} else {
					winChat.addChateUser(cu);
				}
			}
		} else { //msg在线人员
			if(type=="unavailable")
				ControlUser.removeOnlineUser(from,type);
			else
				ControlUser.addOnlineUser(from,type,show,status);
		}
		

	},
    handleMessage:function(oMsg) {
	  	Debug.log("handleMessage got a msg:\n"+oMsg.xml(),2);		
		var fromJid = oMsg.getFrom();		
		if(fromJid.indexOf("conference")!=-1) { //chat
			var win=ControlWindow.getWindow(fromJid);
			win.receive(oMsg.getBody(), Util.getResourceName(fromJid));
		} else {			
			if (ControlWindow.isWindowExist(fromJid)){				
				var win=ControlWindow.getWindow(fromJid);
				if(win.isShow){
					win.receive(oMsg.getBody(), Util.cutResourceAtFlag(fromJid));
				} else {	
					Page.doPopMsg(fromJid,oMsg.getBody());	
					//Page.addToMsgList(oMsg.getBody(), fromJid);		
				}				
			} else {
				//Page.doPopMsg(fromJid,oMsg.getBody());	
				Page.addToMsgList(oMsg.getBody(),fromJid);
			}		
		}		 
	},
    handleMessageError:function(oMsg) {
		  Debug.log(oMsg.xml());
		  Debug.log('handleMessageError')
	},
    handleDisconnect:function() {		
		Debug.log('handleDisconnect')
		con=null;
		if(Page.config.isLogoOuted){
			alert("disconnect")
		} else {
			//Page.connect();
		}		
	},
    handleConnected:function() {
		Debug.log("Connected");
		XmppSend.getAllOnlineList();
		XmppSend.getChatList();
		
		//每隔一定的时间，定期去访问Messager服务器，以防上系统断线
		intervalCall = setInterval("XmppSend.sendMyState();", Config.TIMERVAL);
		
		//con.setPollInterval(2);
		
		/*if(firstTab=="all") {
			XmppSend.getAllList();
		} else if(firstTab=="chat") {
			XmppSend.getChatList();
		}*/		
	},
    handleConError:function(e) {
	   Debug.log('handleConError')	
	   Debug.log(strError)	
	   var strError="Code: "+e.getAttribute('code')+"\Reson: "+e.getAttribute('type')+"\Situation: "+e.firstChild.nodeName;
	  
	   
	   switch (e.getAttribute('code')) {		
			case '401':
				alert(rMsg.err.authenticationFailed);
				break;
			case '409':
				alert(rMsg.err.registerErr);
				break;
			case '503':
				alert(rMsg.err.msgErr);
				Page.changeMessagerState("offline");
				onlstat="unavailable";
				//Login.doLogin();
				break;
			case '500':
				alert(rMsg.err.errThenRetry);
				break;
			default:
				 alert(strError);
				break;
		}
	   Page.changeMessagerState("offline");
	},
	handleRoster:function(iq){
		if (!iq || iq.getType() != 'result') {
			if (iq)
				Debug.log("Error fetching roster:\n"+iq.xml(),1);
			else
				Debug.log("Error fetching roster",1);
			return;
		}
		Debug.log("got roster:\n"+iq.xml(),2);
		var items=iq.getQuery().childNodes;
		if (!items)	return;
		for (var i=0;i<items.length;i++) {
			/* if (items[i].jid.indexOf("@") == -1) */ // no user - must be a transport
			if (typeof(items.item(i).getAttribute('jid')) == 'undefined')	continue;
			var name = items.item(i).getAttribute('name') || cutResource(items.item(i).getAttribute('jid'));
			var groups = new Array('');

			for (var j=0;j<items.item(i).childNodes.length;j++) {
				if (items.item(i).childNodes.item(j).nodeName == 'group'){
					if (items.item(i).childNodes.item(j).firstChild) {//if stanza != <group/>
						groups = groups.concat(items.item(i).childNodes.item(j).firstChild.nodeValue);
					}
				}
			}

			Page.addUser(items.item(i).getAttribute('jid'),items.item(i).getAttribute('subscription'),groups,name,"all");
		}
		Page.hideLoading("all");
		//得到用户保存的状态
		iq = new JSJaCIQ();
		iq.setIQ(null,'get','weavermessager_state');
		var query = iq.setQuery('jabber:iq:private');
		query.appendChild(iq.buildNode('weavermessager', {'xmlns': 'weavermessager:state'}));
		con.send(iq,XmppReceive.handleSavedState);
	},
	handleSavedState:function(iq){
		if (!iq || iq.getType() != 'result') {
			if (iq)
				Debug.log("Error retrieving saved state:\n"+iq.xml(),1);
			else
				Debug.log("Error retrieving saved state",1);
		} else {
			Debug.log(iq.xml(), 2);			
			/*var jNode = iq.getNode().getElementsByTagName('jwchat').item(0);
			for (var i=0; i<jNode.childNodes.length; i++) {
				var item = jNode.childNodes.item(i);
				try {
					switch (item.nodeName) {
						case 'presence': 
						if (onlstat == '' && item.firstChild.nodeValue != 'offline') 
							onlstat = item.firstChild.nodeValue;
							break;
						case 'onlmsg': 
							onlmsg = item.firstChild.nodeValue;
							break;
						case 'hiddenGroups':
							var hiddenGroups = item.firstChild.nodeValue.split(',');
							for (var j=0; j<hiddenGroups.length; j++) {
								if (hiddenGroups[j] != '') {
									roster.hiddenGroups[hiddenGroups[j]] = true;
								}
							}
					}
				} catch(e) { 
					Debug.log(e.toString(), 1); 
				}
			}*/
		}

		// get prefs
		iq = new JSJaCIQ();
		iq.setIQ(null,'get','weavermessager_prefs');
		var query = iq.setQuery('jabber:iq:private');
		query.appendChild(iq.buildNode('weavermessager', {'xmlns': 'weavermessager:prefs'}));

		con.send(iq,XmppReceive.handlePrefs);
	},
	handlePrefs:function(iq) {	
		if (!iq || iq.getType() != 'result') {
			if (iq)
				Debug.log("Error retrieving preferences:\n"+iq.xml(), 1);
			else
				Debug.log("Error retrieving preferences",1);
		}

		if (iq && iq.getType() == 'result') {
			Debug.log(iq.xml() ,2);
			if (iq.getNode().getElementsByTagName('weavermessager').item(0)) {
				/*var jNode = iq.getNode().getElementsByTagName('weavermessager').item(0);
				for (var i=0; i<jNode.childNodes.length; i++) {
					try {
						switch (jNode.childNodes.item(i).nodeName) {
							case 'usersHidden':
								if (eval(jNode.childNodes.item(i).firstChild.nodeValue) != usersHidden)
								roster.toggleHide();
								break;
							case 'timerval':
								timerval = eval(jNode.childNodes.item(i).firstChild.nodeValue);
								con.setPollInterval(timerval);
								break;
							case 'autoPopup':
								autoPopup = eval(jNode.childNodes.item(i).firstChild.nodeValue);
								break;
							case 'autoPopupAway':
								autoPopupAway = eval(jNode.childNodes.item(i).firstChild.nodeValue);
								break;
							case 'playSounds':
								playSounds = eval(jNode.childNodes.item(i).firstChild.nodeValue);
								break;
							case 'focusWindows':
								focusWindows = eval(jNode.childNodes.item(i).firstChild.nodeValue);
								break;
							case 'timestamps':
								timestamps = eval(jNode.childNodes.item(i).firstChild.nodeValue);
								break;
							case 'enableLog':
								enableLog = eval(jNode.childNodes.item(i).firstChild.nodeValue);
								break;
						}
					} catch(e) { Debug.log(e.toString(),1); }
				}*/
			}
		}

		// print roster
		//roster.print();

			
		ControlUser.changeStatus(onlstat,onlmsg,onlprio);
		Multimedia.playSound('connected');
		
		

		// Start Service Discovery
		/*iq = new JSJaCIQ();
		iq.setIQ(con.domain,'get','disco_item_1');
		iq.setQuery('http://jabber.org/protocol/disco#items');

		con.send(iq,getDiscoItems);*/

		// get bookmarks
		/*iq = new JSJaCIQ();
		iq.setIQ(null,'get','storage_bookmarks');
		var query = iq.setQuery('jabber:iq:private');
		query.appendChild(
		iq.buildNode('storage', {'xmlns': 'storage:bookmarks'}));

		con.send(iq,getBookmarks);*/

		// get annotations
		/*iq = new JSJaCIQ();
		iq.setIQ(null,'get','jwchat_notes');
		var query = iq.setQuery('jabber:iq:private');
		query.appendChild(
		iq.buildNode('storage', {'xmlns': 'storage:rosternotes'}));

		con.send(iq,getAnnotations);*/


	},	
	handleChatList:function(iq){
		Debug.log("ControlChat.handleChatList"+iq.getDoc().xml,2);
		
		for (var i=0; i<iq.getQuery().getElementsByTagName('item').length; i++) {
		  var aNode = iq.getQuery().getElementsByTagName('item').item(i);
		  var chatId=aNode.getAttribute('jid'); 
		  var chatName=aNode.getAttribute('name');
		  Page.addChat(chatId,chatName);
		}
		Page.hideLoading("chat");
	},
	handleChatConfig:function(iq){		
		Debug.log(iq.getDoc().xml,2);
		if (iq.getType() == 'error')    return;		  
		if (iq.getNode().getElementsByTagName('x').length && iq.getNode().getElementsByTagName('x').item(0).getAttribute('xmlns') == 'jabber:x:data'){
			 alert(iq.getNode().getElementsByTagName('x').item(0))
		}
	}
}


