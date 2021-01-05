function  ChatWindow(para){	
	MessageWindow.call(this,para)
	this.para=para;
}
ChatWindow.prototype=new MessageWindow();


ChatWindow.prototype._setChatList=function(){	
	this.objBody.append("<div class='chatList'></div><div style='clear:both'/>");
}

ChatWindow.prototype._createChat=function(){	
	this._setChatList();	
}
ChatWindow.prototype._fixChatBody=function(){	
	var chatListWidth=70;
	var msgWidth=parseInt(this.objBody[0].style.width)-chatListWidth-2;	
	var chatListHeight=parseInt(this.objBody[0].style.height)-4;	
	this.objBody.find(".chatList").css({float:'left',width:chatListWidth,height:'100%'});
	this.objBody.find(".msg").css({float:'right',width:msgWidth});
}

ChatWindow.prototype._joinChat=function(){		
	XmppSend.joinToChat(this.para.sendTo,this.para.nickname);
}

ChatWindow.prototype.send=function(msg){	
	//send 消息	
	XmppSend.sendMessage(this.para.sendTo,msg);
	
	//清空消息
	this.objBody.find(".input").children("textarea").val('');
}

ChatWindow.prototype.addChateUser=function(cu){ 
	//alert(nickname)
	this.objBody.find(".chatList").append(cu.toString())
	this.showMessage(cu.para.nick+rMsg.chatWindowJoinMeeting,"");
}
ChatWindow.prototype.removeChateUser=function(cu){ 
	//alert(nickname)
	if(cu.isAdmin()){
		alert(rMsg.chatWindowAdminCloseMeeting);
		this.remove();
		Page.removeChat(this.para.sendTo);		
	} else {		
		this.objBody.find(".chatList").find("#"+cu.getChatDivId()).remove();
		this.showMessage(cu.para.nick+rMsg.chatWindowLeaveMeeting,"");
	}
}


//重载
ChatWindow.prototype._fixSize=function(){	
	this._fixWindow();
	this._fixMessageBody();
	this._fixChatBody();
}
ChatWindow.prototype._create=function(){		
	this._createBase();
	this.objBody=this.objWindow.find(".body");
	this._createMessage();
	this._createToolbar();	
	this._createChat();	

	this._joinChat();
}
