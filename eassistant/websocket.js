var webSocket = null;

function sendMsg(json){
	if(!json.token){
		json.token = __tokenstring__;
	}
	var message = JSON.stringify(json);
	if(!webSocket){
		console.log("连接异常，请重新刷新页面连接...");
		webSocket = new WebSocket(wsUrl);
	}
	if(webSocket){
		webSocket.send(message);
	}
}

function onOpen(){

	if (window.WebSocket) {
		webSocket = new WebSocket(wsUrl);
		webSocket.onerror = function(event) {
		  onError(event)
		};
	 
		webSocket.onopen = function(event) {
		  onOpen(event);
		};

		webSocket.onclose = function(event){
			webSocket = null;
		}
	 
		webSocket.onmessage = function(event) {
		  onMessage(event)
		};

		function notification(){
			if(window.Notification) {
				Notification.requestPermission(function(status) {
					var n = new Notification('新的问题', { body: '您有新的问题到达！' }); 
					n.onshow = function () { 
					  setTimeout(n.close.bind(n), 5000); 
					}
				});
			}
		}

		//窗口隐藏显示事件监听
		function tabSwithEvent(){
			document.addEventListener('visibilitychange',function(){ //浏览器切换事件
				if(document.visibilityState=='hidden') { //状态判断
					//normal_title=document.title;
					//document.title='隐藏的标题'; 
					jQuery("#customService").val(0);
					changeServiceStatus("#customService");
				}else {
					//document.title=normal_title;
				}
			});
		}
	 
		function onMessage(event) {
			var data = $.parseJSON(event.data);
			//console.log(data);
			if(data.msgType=="question"){//推送的问题
				pendingData.add(data);
				//notification();
			}else if(data.msgType==99){//当前账号状态
				//jQuery("#customService").val(data.status);
				changeServiceStatusClick("#customService",data.status);
			}else if(data.msgType==98){//推送的其他账号状态
				if(!!userOnList[data.userid]){//如果存在则直接更新
					userOnList[data.userid].status = data.status;
				}else{
					userOnList[data.userid] = data;//不存在插入到队列中
					var divP = jQuery("<div></div>");
					var lastname = data.lastname;
					if(!!lastname && lastname.indexOf("~`~`")!=-1){
						var b =  lastname.match(/7 .*?`/);
						if(b!=null){
							lastname = b[0].replace("7 ","").replace("`","");
						}
					}
					var spanUser = jQuery("<span></span>").attr("id",data.userid+"_user").addClass("spanUser").attr("_userid",data.userid).text(lastname || data.userid);
					var spanStatus = jQuery("<span></span>").attr("id",data.userid+"_status").addClass("spanStatus");
					var selectStatus = jQuery("<select></select>").attr("id",data.userid+"_status_sel").attr("name",data.userid+"_status_sel").attr("_userid",data.userid).bind("change",function(){
						changeServiceStatus(this, jQuery(this).attr("_userid"),__customOtherStatus);
					});

					var option1 = jQuery("<option></option").attr("value",1).text("在线");
					var option2 = jQuery("<option></option").attr("value",0).attr("selected","selected").text("挂起");
					selectStatus.append(option1).append(option2);
					spanStatus.append(selectStatus);
					divP.append(spanUser).append(spanStatus);
					jQuery("#userOnListDiv").append(divP);
				}
				if(__tokenstring__==data.userid){
					//jQuery("#customService").val(data.status);
					changeServiceStatusClick("#customService",data.status);
				}
				jQuery("#"+data.userid+"_status_sel").val(data.status);
			}
		}
	 
		function onOpen(event) {
		  console.log( '连接建立成功...');
		  tabSwithEvent();
			//发送当前用户信息
			var data = {msgType:"currentUserInfo",token:__tokenstring__,tokenUserId:__tokenUserIdString__};
			sendMsg(data);
		}
	 
		function onError(event) {
		  console.log("发生错误："+event);
		}
	}else{
		alert("您的浏览器不支持WebSocket，请使用Chrome浏览器操作！");
	}
}