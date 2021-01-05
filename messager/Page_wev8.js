var Page={
	config:{
		isLogoOuted:false,
		tabtype:"",
		loginState:"noLogin"
	},
	initpara:{
		chat:false,
		dept:false,
		recently:false,
		organization:false
	},
	changeTab:function(type){ //all organization  recently
		var id = event.srcElement.id;		//
		$("#"+id).parent().children(".tab2selected").addClass("tab2unselected").removeClass("tab2selected");
		$("#"+id).addClass("tab2selected").removeClass("tab2unselected");
	
		$(".messagers").children("."+type).fadeIn("fast");
		$(".messagers").children("div").not("."+type).hide();
		if(type=="chat"){//会议比较特殊需每次都要获取						
			Page.refreshChatList();
		} else if(type=="dept"){//部门只需加载一次				
			if(!Page.initpara.dept){
				Page.getDeptUserList();
				Page.initpara.dept=true;
			}
		}   else if(type=="recently"){//最近也只需加载一次		
			if(!Page.initpara.recently){
				Page.getRecentlyUserList();
				Page.initpara.recently=true;
			}
		}else if(type=="organization"){//最近也只需加载一次		
			if(!Page.initpara.organization){
				Page.getOrganizationList();
				Page.initpara.organization=true;
			}
		}
		
		Page.config.tabtype=type;
	},
	getOrganizationList:function(){
		$.ajaxSetup({cache:false});
		$(".organization").tree({
			id:"treeOrg",
			data:{
				async : true,
				type  : "json",
				opts  : { method: "GET", url: "/messager/MessagerDataForEcology.jsp?method=getOrganization" }
			},
			callback:{
				beforedata:function(NODE, TREE_OBJ) { 
					return { organType : $(NODE).attr("organType") || "company" ,value : $(NODE).attr("value") || "0" }
				},
				onopen:function(NODE, TREE_OBJ) {
					if($(NODE).attr("isDoInitMessger")!="true"){
						$.each($(NODE).find("[organtype='hrm']"),function(i,n){
							var a=$(n).children("A");
							var loginid=a.attr("loginid");
							var ins=a.children("ins");	
							if(ControlUser.isUserOnline(loginid)){
								ins.css("background-image","url('/messager/images/hrm-online_wev8.gif')")
							}
							ins.addClass("ins_imgOnlineState_"+loginid);
							
						})						
						$(NODE).attr("isDoInitMessger","true");
					}
				},
				ondblclk:function(NODE, TREE_OBJ) {
					if($(NODE).attr("organtype")=="hrm"){						
						var a=$(NODE).children("A");
						var ins=a.children("ins");						
						
						
						var toJid=a.attr("loginid")+"@"+Config.JABBERSERVER;
						var msgName=a.html()
						var re = /<.*>/gi;
						msgName=msgName.replace(re,""); 

						var logoImg=ins.css("background-image");
						if(logoImg.indexOf("online")!=-1){
							logoImg="/messager/images/icon-available_wev8.gif";
						} else {
							logoImg="/messager/images/icon-offline_wev8.gif";
						}
						var win=ControlWindow.getWindow(toJid,msgName,logoImg,logoImg);			
						win.show();			
					}
					TREE_OBJ.toggle_branch.call(TREE_OBJ, NODE);
					TREE_OBJ.select_branch.call(TREE_OBJ, NODE);

				}
			}
			
		});
	},
	getDeptUserList:function(){
		$.getJSON("/messager/MessagerDataForEcology.jsp?method=getDeptUser&loginid="+Util.cutResourceAtFlag(jid),function(json){		
			
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
			    mu.showTo("dept");
			})
			Page.hideLoading("dept");
		});
	},
	doShowSomeBodyTempMsg:function(fromJid){  
		$.getJSON("/messager/MessagerDataForEcology.jsp?method=getSomBodyTempMsg",{loginid:Util.cutResourceAtFlag(jid),fromJid:fromJid},function(json){
			$.each(json.items,function(i,n){
				var fromJid=n.fromJid;
				var msgbody=n.body;
				Page.doPopMsg(fromJid,msgbody);		
			})
		});
	},
	doShowAllTempMsg:function(){  
		$.getJSON("/messager/MessagerDataForEcology.jsp?method=getAllTempMsg",{loginid:Util.cutResourceAtFlag(jid)},function(json){
			$.each(json.items,function(i,n){
				var fromJid=n.fromJid;
				var msgbody=n.body;
				Page.doPopMsg(fromJid,msgbody);		
			})	
			
			$("#imgMsgStateBar").attr("src",ControlUser.getUserStateImg("available")).attr("title",rMsg.pageOnline);
		});
	},
	doPopMsg:function(fromJid,msgbody){
		if (ControlWindow.isWindowExist(fromJid)){		
			var win=ControlWindow.getWindow(fromJid);
			if(win.isShow){						
				win.receive(msgbody, Util.cutResourceAtFlag(fromJid));
			} else {						
				win.receive(msgbody, Util.cutResourceAtFlag(fromJid));
			}				
		} else {		
			var win=ControlWindow.getWindowFromRecently(fromJid);
			if(typeof win=="object"){
				win.receive(msgbody, Util.cutResourceAtFlag(fromJid));
			} else {
				ControlUser.addRecentlyContatct(jidCurrent,fromJid,function(){
					var win=ControlWindow.getWindowFromRecently(fromJid);
					if(typeof win=="object"){
						win.receive(msgbody, Util.cutResourceAtFlag(fromJid));
					} else {
						var win=ControlWindow.getWindow(fromJid);
						win.receive(msgbody, Util.getResourceName(fromJid));
					}
				})
			}				
		}
	},
	getRecentlyUserList:function(){
		$.getJSON("/messager/MessagerDataForEcology.jsp?method=getRecentlyUser&loginid="+Util.cutResourceAtFlag(jid),function(json){	
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
				if(ControlUser.firstJid=='') ControlUser.firstJid=n.loginid+'@'+Config.JABBERSERVER;
			    var mu=new MessageUser(para);
			    mu.showTo("recently");
			})
			Page.hideLoading("recently");
		});
	},
	refreshChatList:function(){
		$(".chat .divBlock").remove();
		Page.showLoading("chat");
		if(con!=null) XmppSend.getChatList();
	},
	showLoading:function(type){
		$("."+type+" .divLoading ."+type).show();
	},
	hideLoading:function(type){
		$("."+type+" .divLoading").hide();
	},
	
	/*addUser:function(jid,subscription,groups,name,type){ //all  recently
		Debug.log("Page.addUser");
		Debug.log("jid:"+jid+" subscription:"+subscription+" groups:"+groups+" "+"name:"+name+" type:"+type,2);
		
		
		$("."+type).children(".divLoading").before(
						"<div class='divBlock' id='User_"+Util.cutResourceAtFlag(jid)+"' toJid='"+jid+"'>"+
							  "<div style='float:left;width:18px;'><img id='imgState' src='images/icon-offline_wev8.gif'/></div>"+
							  "<div style='float:left;width:130px;'>"+
							  "		<div style='padding:2px' id='username'>"+name+"</div>"+
							  "		<div class='txtState' style='color:#808080'>offline</div>"+
							  "</div>"+
							  "<div style='float:right;width:35px;'><img src='images/icon-blue_wev8.gif'/></div>"+
							  "<div style='clear:both'></div>"+
						 "</div>"
						); 	
		
		$("#User_"+Util.cutResourceAtFlag(jid)).dblclick(function () {
			var toJid=$(this).attr("toJid");			

			var msgName=$(this).find("#username").html()	
			var logoImg=$(this).find("#imgState").attr("src");
			

			var win=ControlWindow.getWindow(toJid,msgName,logoImg);			
			win.show();				
		}); 

		Page.bindDivBlockHover();
	},*/
	
	addChat:function(chatId,chatName){
		$(".chat .divLoading").before(
		"<div class='divBlock'  id='Chat_"+Util.cutResourceAtFlag(chatId)+"'  toJid='"+chatId+"' style='padding-top:8px'>"+			 
			"<img id='imgChat' align='absmiddle' src='/messager/images/chat_wev8.gif'/><span id='chatName' style='padding-left:2px;margin-top:14px;'>"+chatName+"</span>"+
		 "</div>"
		); 		

		$("#Chat_"+Util.cutResourceAtFlag(chatId)).dblclick(function () {
			var toJid=$(this).attr("toJid");
			var chatname=$(this).find("#chatName").html()	
			var chatImg=$(this).find("#imgChat").attr("src");	
			
			
			var win=ControlWindow.getWindow(toJid,chatname,chatImg);			
			win.show();		
		}); 

		Page.bindDivBlockHover();
	},
	removeChat:function(chatId){
		$("#Chat_"+Util.cutResourceAtFlag(chatId)).remove();
	},
	bindDivBlockHover:function(){
		$(".divBlock").hover(
			function () {
				$(this).css("background-color","#D6D9E5");
				
			},
			function () {
				$(this).css("background-color","#ffffff");
				
			}
		);
	},
	
	
	chatPara:{
		chatName:'',
		ownerJid:'',
		chatId:''			
	},
	createChat:function(){		
		wCreateChatConfig=ControlWindow.getBaseWindow("wCreateChatConfig",rMsg.pageMeetingRoomSet,"",250,120,500,400,'divCreateChatConfig');
		wCreateChatConfig.show();
		
	},
	createChatSubmit:function(btnObj){
		var name=$.trim(wCreateChatConfig.objWindow.find("#txtName").val());
		var psw=$.trim(wCreateChatConfig.objWindow.find("#txtPsw").val());
		if(name!=""){
			Page.chatPara.chatName=name;
			Page.chatPara.ownerJid=Util.cutResource(jidCurrent);
			Page.chatPara.chatId='chat_'+new Date().getTime()+"@"+Config.DEFAULTCONFERENCESERVER;
			
			XmppSend.sendChatInit();
		}
		wCreateChatConfig.hide();
	},
	createChatCancel:function(btnObj){
		wCreateChatConfig.objWindow.find("#txtName").val('');
		wCreateChatConfig.objWindow.find("#txtPsw").val('');
		wCreateChatConfig.hide();
	},
	destroy:function(chatid) {
		if(window.confirm(rMsg.pageSureToCloseMeeting+chatid+"?")){
			XmppSend.sendDestroyChat(chatid);
			Page.refreshChatList();
		}
	},
	connect:function(){
		/*if(Config.target=="parent"){
			$(parent.document.body).find("#divConnectting").show();
			$(parent.document.body).find("#ifrmMessager").hide();
			
			$(parent.document.body).find("#imgState").find("img").attr("src",ControlUser.getUserStateImg("connect"));
			$(parent.document.body).find("#txtState").html("Connecting...");
		}*/
					
		//$("#imgState").find("img").attr("src",ControlUser.getUserStateImg("connect"));
		//$("#txtState font").html("Connecting...");	
		
		
		Login.doLogin();
	},
	openPage:function(type,sendTo,obj){		
		if(type=="face"){		
			var bottom=parseInt(screen.height)-parseInt($(obj).offset().top+180+20)			
			var right=parseInt(screen.width)-parseInt($(obj).offset().left+10)
			ControlWindow.getBaseWindow("winFaceAll"+Util.cutResourceAtFlag(sendTo),"Face","",184,180,right,bottom,"divContainer").show();
		} else if(type=="email"||type=="sms"){
			document.getElementById("divIframe").all(0).src = "/messager/OpenPage.jsp?type="+type+"&sendTo="+sendTo;
			var openPageWindow=ControlWindow.getBaseWindow("openPageWindow"+type+sendTo.substring(0,sendTo.indexOf("@")),type,"",380,280,350,100,'divIframe');
			openPageWindow.show();
			//window.open("/messager/OpenPage.jsp?type="+type+"&sendTo="+sendTo);
		} else {
			document.getElementById("divIframe").all(0).src = "/messager/OpenPage.jsp?type="+type+"&sendTo="+sendTo;
			var openPageWindow=ControlWindow.getBaseWindow("openPageWindow"+type+sendTo.substring(0,sendTo.indexOf("@")),type,"",480,360,350,100,'divIframe');
			openPageWindow.show();
			//window.open("/messager/OpenPage.jsp?type="+type+"&sendTo="+sendTo);
		}
	},	
	logOut:function(){	
	    window.clearInterval(intervalCall);
	    
		var aPresence = new JSJaCPresence();
	    aPresence.setType('unavailable');
	    con.send(aPresence);
	    
		con.disconnect();
		Page.changeMessagerState("offline")
		onlstat="unavailable";
		Page.config.isLogoOuted=true;
			
	},
	changeMessagerState:function(state){
		if(state=="offline"){
			$(document.body).find("#divConnectting").show();		
			$(document.body).find("#ifrmMessager").hide();
			
			$(document.body).find("#divConnectting").find(".showMsg").html(
					"<img src='"+ControlUser.getUserStateImg("offline")+"' align='absmiddle'/>&nbsp;<b>"+rMsg.offline+"</b><br><br>"+
					"<a href='javascript:Login.doLogin()'>"+rMsg.loginHere+"</a>"
			);
			
			$("#imgMsgStateBar").attr("src",ControlUser.getUserStateImg("offline"));
			$("#imgMsgStateBar").attr("title",rMsg.offline);	
			
			document.body.onbeforeunload=null;
		} else if(state=="msg"){
			$("#imgMsgStateBar").attr("src",ControlUser.getUserStateImg("msg"));
			$("#imgMsgStateBar").attr("title","You have received new messages.");			
		}
	},
	sendState:function(state){
		onlstat=state;
		XmppSend.sendMyState();	
	},
	addToMsgList:function(body,fromJid){
		//Multimedia.playSound("reciveMessage");
		//如果是焦点相关的消息，不需要做任何处理		
		//如果是提醒方面的消息，则需要显示与此人相关的消息。
		
		if($.trim(body)==Config.AlertFlag){			
			Page.doShowSomeBodyTempMsg(fromJid);		
			return ;		
		} else if($.trim(body)==Config.FocusFlag){
			return ;
		}else if($.trim(body)==Config.BlurFlag){
			return ;
		}else if($.trim(body)==Config.OnlineFlag){
			return ;
		}
		
		
		body=encodeURIComponent (encodeURIComponent (body));
		
		//把数据暂存在服务器
		$.get("/messager/MessagerDataForEcology.jsp?method=saveTempMsg",{loginid:Util.cutResourceAtFlag(jid),fromJid:fromJid,body:body,receiveTime:Util.getCurrentTimeForMsg()},function(data){	
			//记录数据到本地LIST
			
			//改变当前图标
			
			//改变状态			
			Page.changeMessagerState("msg");	
		});
		
	}
	
	,showMessage:function(userid){
		$.get("/messager/MessagerDataForEcology.jsp?method=getLoginid",{userid:userid},function(data){
			var fromJid=$.trim(data)+"@"+Config.JABBERSERVER;
			if (ControlWindow.isWindowExist(fromJid)){				
				var win=ControlWindow.getWindow(fromJid);
				win.show();
			} else {
				var win=ControlWindow.getWindowFromRecently(fromJid);
				if(typeof win=="object"){
					win.show();
				} else {
					ControlUser.addRecentlyContatct(jidCurrent,fromJid,function(){
						var win=ControlWindow.getWindowFromRecently(fromJid);
						if(typeof win=="object"){
							win.show();
						} else {
							var win=ControlWindow.getWindow(fromJid);
							win.show();
						}
					})
				}
			}			
			
		})
		
	}
}