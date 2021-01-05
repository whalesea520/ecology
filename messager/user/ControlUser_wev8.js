var userOnlineIdList=new ArrayList();
var userOnlineMuList=new ArrayList();



var ControlUser={
	initOnlineUsrNum:0,
	firstJid:'',
	addOnlineUser:function(jid,type,show,status){
		var loginid=Util.cutResourceAtFlag(jid);
		userOnlineIdList.add(loginid);
		
		$(".imgOnlineState_"+loginid).attr("src","/messager/images/icon-available_wev8.gif");
		$(".ins_imgOnlineState_"+loginid).css("background-image","url('/messager/images/hrm-online_wev8.gif')")
		
		ControlUser.initOnlineUsrNum++;	
	},
	removeOnlineUser:function(jid,type){
		var loginid=Util.cutResourceAtFlag(jid);
		userOnlineIdList.remove(loginid);
		
		$(".imgOnlineState_"+loginid).attr("src","/messager/images/icon-offline_wev8.gif");
		$(".ins_imgOnlineState_"+loginid).css("background-image","url('/messager/images/hrm-offline_wev8.gif')")
		
		ControlUser.initOnlineUsrNum--;	
	},
	isUserOnline:function(loginid){
		return userOnlineIdList.indexOf(loginid)!=-1;
	},
	addRecentlyContatct:function(jidCurrent,jid,callback){		
		jid=Util.cutResource(jid);
		if(ControlUser.firstJid==jid) return;
		
		var tmpUser=$(".recently #User_"+Util.cutResourceAtFlag(jid));
		var tmpUser=$(".recently").children("div[toJid='"+jid+"']");
		
		tmpUser.css("background-color","#ffffff")
		 if(tmpUser.length>0){ //已存在
			 //alert(Page.config.tabtype)
			 if(Page.config.tabtype!="recently"){
				 //alert("1");
				 tmpUser.parent().children("div:first").before(tmpUser);
			 	 $.get("/messager/MessagerDataForEcology.jsp?method=addRecentlyContact&isNeedGetInfo=false&loginid="+Util.cutResourceAtFlag(jidCurrent)+"&contactLoginid="+Util.cutResourceAtFlag(jid));
			 }			 
		 }	else { //不存在
			 $.getJSON("/messager/MessagerDataForEcology.jsp?method=addRecentlyContact&isNeedGetInfo=true&loginid="+Util.cutResourceAtFlag(jidCurrent)+"&contactLoginid="+Util.cutResourceAtFlag(jid),function(json){
					$.each(json.items,function(i,n){					
						var para={
						    	userid:n.userid,
						    	loginid:n.loginid,
						    	lastname:n.lastname,
						    	sex:n.sex,
						    	departmentid:n.departmentid,
						    	departmentname:n.departmentname,
						    	telephone:n.telephone,
						    	mobile:n.mobile,
						    	mobilecall:n.mobilecall,
						    	email:n.email,
						    	messagerurl:n.messagerurl
						    };
						var mu=new MessageUser(para);
					 	mu.insertBeforeFirst("recently");
					 	
					 	if(typeof callback!="undefined"){
					 		var call=eval(callback);
							call();
					 	}
					})
				});				 			 	
		 }
		
		
		ControlUser.firstJid=jid;
	},
	changeStatus:function (val,away,prio) {
		Debug.log("changeStatus: "+val+","+away+","+prio, 2);
		
		onlstat = val;
		if (away){
			onlmsg = away;
		}

		if (prio && !isNaN(prio))	{
			onlprio = prio;
		}
		if (!con.connected() && val != 'offline') {
			Login.doLogin(jid,psw,Debug);	
			//init();
			return;
		}

		var aPresence = new JSJaCPresence();
		switch(val) {
			case "unavailable":
				val = "invisible";
				aPresence.setType('invisible');
				break;
			case "offline":				
				val = "unavailable";
				aPresence.setType('unavailable');
				con.send(aPresence);
				con.disconnect();

				Debug.log("changeStatus:offline  ...TODO", 2);
				/*
				var img = eval(val+"Led");
				statusLed.src = img.src;
				if (away) {
					statusMsg.value = away;
				}
				else {
					statusMsg.value = onlstatus[val];
				}
				cleanUp();
				*/
				return;
				break;
			case "available":
				val = 'available'; // needed for led in status bar
				if (away)
					aPresence.setStatus(away);
				if (prio && !isNaN(prio))
					aPresence.setPriority(prio);
				else
					aPresence.setPriority(onlprio);			
				break;
			case "chat":
				if (prio && !isNaN(prio))
					aPresence.setPriority(prio);
				else
					aPresence.setPriority(onlprio);			
			default:
				if (away) {
					aPresence.setStatus(away);
				}

				if (prio && !isNaN(prio)) {
					aPresence.setPriority(prio);
				} else{
					aPresence.setPriority('0');
				}

				aPresence.setShow(val);
		}
		con.send(aPresence);
		
		//修改用户状态及其它
		ControlUser.UpdateUserState(val,away);

	},
	UpdateUserState:function(state,msg){
		
	
				
		$(document.body).find("#divConnectting").hide();		
		$(document.body).find("#ifrmMessager").show();
		
		//设置工具条上的图标等信息。
		
		$.get("/messager/MessagerDataForEcology.jsp?method=getTempMsgCount",{loginid:Util.cutResourceAtFlag(jid)},function(data){	
			if($.trim(data)>0){
				$("#imgMsgStateBar").attr("src",ControlUser.getUserStateImg("msg")).attr("title",rMsg.controlUserMessageHave+$.trim(data)+rMsg.controlUserMessageCount);
			} else {
				$("#imgMsgStateBar").attr("src",ControlUser.getUserStateImg(state)).attr("title",msg);
			}
			//设直聊天面板上的图标等信息
			//$("#imgMsgStatePanel").attr("src",ControlUser.getUserStateImg(state));
			
			$("#userState_panel").html(msg);

			//document.body.onbeforeunload=function(){
			//	event.returnValue=rMsg.controlUserQuit;
			//}

		});		
		
	},
	getUserStateImg:function(state){
		switch(state) {
			case "available":
				return "/messager/images/icon-available_wev8.gif"; 
				//return "/messager/images/icon-available_wev8.gif";
				
			case "connect":
				return "/images/images/logining_wev8.gif";
			case "offline":
				return "/messager/images/icon-offline_wev8.gif";
			case "msg":
				return "/messager/images/msg_wev8.gif";				
			default:
				return "";
		}
	}
}