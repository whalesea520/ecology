var ControlWindow={
	intMessagerWindowNum:0,
	intMessagerZindex:100,
	getWindowId:function(jid){	
		if(jid.indexOf("conference")!=-1){ //chat
			return "chatWindow_"+Util.cutResourceAtFlag(jid);
		} else { //message
			return "mWindow_"+Util.cutResourceAtFlag(jid);
		}		
	},
	isWindowExist:function(jid){
		var windowId=ControlWindow.getWindowId(jid);		
		return typeof window[windowId]=="object";
	},
	getWindow:function(jid,name,logo,userImg,user){				
		var windowId=ControlWindow.getWindowId(jid);		
		if(typeof window[windowId]=="object")  {
			return window[windowId]
		} else {			
			if(jid.indexOf("conference")!=-1){ //chat
				//list 一下会议
				Page.refreshChatList();
				return ControlWindow.createChatWindow(windowId,jid,name,logo,Config.ChatWindowWidth,Config.ChatWindowHeight,userImg);				
			} else { //message	
				return ControlWindow.createMessageWindow(windowId,jid,name,logo,Config.MessageWindowWidth,Config.MessageWindowHeight,userImg,user);
			}
			
		}
	},
	getWindowFromRecently:function(jid){
		jid=Util.cutResource(jid);
		document.getElementById("wmForWeb").dbClickJid(jid);  
		var windowId=ControlWindow.getWindowId(jid);	
		return window[windowId]
	},
	getWindowPos:function(width,height){		
		
		//var tepLeft=parseInt(screen.width)/2-parseInt(width)/2+ControlWindow.intMessagerWindowNum*20		
		//var tepTop=parseInt(screen.height)/2-parseInt(height)+ControlWindow.intMessagerWindowNum*20
		//var tmpRight=(parseInt(width)+10)*ControlWindow.intMessagerWindowNum;
		//var tmpBottom=0;		
		//ControlWindow.intMessagerWindowNum++;	
		
		
		var tmpLeft=parseInt(screen.width)/2-parseInt(width)+30*ControlWindow.intMessagerWindowNum+250;
		var tmpTop=parseInt(screen.height)/2-parseInt(height)+100+40*ControlWindow.intMessagerWindowNum;
		return {
			left:tmpLeft,
			top:tmpTop
		}
	},
	createMessageWindow:function(windowId,jid,name,logo,width,height,userImg,user){				
		width=parseInt(width);
		height=parseInt(height);
		var postion=ControlWindow.getWindowPos(width,height);
		var tmpLeft=postion.left;
		var tmpTop=postion.top;
		
		
		/*var str=windowId+"=new MessageWindow({	id:'"+windowId+"_dom',templateId:'windowTemplate',height:'"+height+"', width:'"+width+"',top:'"+top+"',left:'"+left+"',logoImg:'"+logo+"',name:'"+name+"',canDrag:'true',sendTo:'"+jid+"'})";		
		eval(str);		
		eval(windowId+".appendTo(document.body)");	
		return eval("window."+windowId);
		*/
		
		
		window[windowId]=new MessageWindow({id:windowId+"_dom",templateId:"windowTemplate",height:height, width:width,top:tmpTop,left:tmpLeft,logoImg:logo,name:name,canDrag:'true',sendTo:jid,userImg:userImg,user:user});
				
		if(Config.target=="parent"){
			window[windowId].appendTo($(parent.document.body));
		} else {
			window[windowId].appendTo(document.body);
		}
		return window[windowId];			
	},
	createChatWindow:function(windowId,chatid,name,logo,width,height,userImg){
		width=parseInt(width);
		height=parseInt(height);
		var postion=ControlWindow.getWindowPos(width,height);
		var tmpLeft=postion.left;
		var tmpTop=postion.top;
		
		/*var str=windowId+"=new ChatWindow({	id:'"+windowId+"_dom',templateId:'windowTemplate',height:'"+height+"', width:'"+width+"',top:'"+top+"',left:'"+left+"',logoImg:'"+logo+"',name:'"+name+"',canDrag:'true',sendTo:'"+chatid+"',nickname:'"+nickname+"'})";
		eval(str);
		eval(windowId+".appendTo(document.body)");		
		return eval("window."+windowId);*/
		

		window[windowId]=new ChatWindow({id:windowId+"_dom",templateId:"windowTemplate",height:height, width:width,top:tmpTop,left:tmpLeft,logoImg:logo,name:name,canDrag:'true',sendTo:chatid,nickname:nickname,userImg:userImg});		
	
		if(Config.target=="parent"){
			window[windowId].appendTo(parent.document.body);
		} else {
			window[windowId].appendTo(document.body);
		}
		return window[windowId];
	},
	getBaseWindow:function(windowId,name,logo,width,height,left,top,el){
		if(typeof window[windowId]=="object")  {
			return window[windowId]
		} else {			
			return ControlWindow.createBaseWindow(windowId,name,logo,width,height,left,top,el);				
		}
	},	
	createBaseWindow:function(windowId,name,logo,width,height,left,top,el){
		width=parseInt(width);
		height=parseInt(height);
	
		
		window[windowId]=new BaseWindow({id:windowId+"_dom",templateId:"windowTemplate",height:height, width:width,top:top,left:left,logoImg:logo,name:name,canDrag:'true',el:el});
		if(Config.target=="parent"){
			window[windowId].appendTo(parent.document.body);
		} else {
			window[windowId].appendTo(document.body);
		}
		return window[windowId];		
	
	}
}