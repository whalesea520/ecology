//封装消息处理对象
var ChatUtil = {
    discussMenuSet: { FirstTop: 0, SecTop: 0, ThirdTop: 0, FourTop: 0, isOnMove: false, isOnQuit: false, isOnMoveToGroup: false, onHideDelay: 100, event: null },
	//初始化本地数据库
	initLocalDB:function(){
		if(isChrome){
			//创建数据库
			webSql.openDatabase("socialdb", "1.0", "web message db", 10*1024 * 1024, function () { });
			//创建表count消息表
			webSql.createTable("create table if not exists social_IMCountMsg (id INTEGER PRIMARY KEY, messageid TEXT,receiverid integer,targettype integer,type TEXT)");
			// 暂时加一个字段，后面搞张新表处理
			webSql.createTable("alter table social_IMCountMsg  add userid integer");
			//创建同步消息表
			webSql.createTable("create table if not exists social_IMSyncMsg (id INTEGER PRIMARY KEY,messageid TEXT,msgObj TEXT)");
			//创建被撤销消息表
			webSql.createTable("create table if not exists social_WithdrawMsg (id INTEGER PRIMARY KEY,messageid TEXT, targetid TEXT, msgfrom TEXT)");
			//定时清除count消息
			var clearCountMsgInterval=setInterval(function(){
				ChatUtil.clearCountMsg();
			},1000*60*3);
			//定时清除同步消息
			var clearSyncMsgInterval=setInterval(function(){
				ChatUtil.clearSyncMsg();
			},1000*60*5);
			//定时清除被撤销消息
			var clearWithdrawMsgInterval=setInterval(function(){
				ChatUtil.clearWithdrawMsg();
			},1000*60*7);
		}
		// 初始化主次账号关系
		AccountUtil.init();
	},
	
	//获取未读人员id
	getUnreadId:function(messageid,userid,callback){
		$.post("/social/im/SocialIMOperation.jsp?operation=getUnreadId",{"messageid":messageid,"userid":userid},function(data){
			if(typeof callback !=undefined && typeof callback == 'function'){
				callback(data);
			}
		});
	},
	
	//同步个性签名
	updateSignature :function(userid,callback){
		var self = this;
		$.post("/social/im/SocialIMOperation.jsp?operation=updateCardInfo",{"userids":userid},function(data){
			var cardInfo = $.parseJSON($.trim(data));
			var textValue = cardInfo.signature[userid];
			var mobileshow = cardInfo.mobileshow[userid]
			userInfos[userid] = getUserInfo(userid);
			userInfos[userid].signatures=textValue;			
			self.updateSignatureHandle(userid,textValue);			
			if(typeof callback !=undefined && typeof callback == 'function'){
				callback(mobileshow);
			}
		})	
	},
	//个性签名处理逻辑
	updateSignatureHandle:function(userid,textValue){
		//只更新对方的个性签名
		var userInfo = userInfos[userid];
		if(textValue !="" && !textValue){
			try {
				textValue = userInfo.signatures;
			} catch (error) {
				textValue = ""
				userInfo = {
					"userName":"",
					"userHead":""
				};
			}			
		}
			//只更新对方的个性签名
			var chatWinid="chatWin_"+0+"_"+userid;
			var chatwin = $("#"+chatWinid);
			if(textValue==""){
				var noSigStr = social_i18n('SignatureTip2');
				chatwin.find(".chattop").children(".signatures").text(noSigStr).attr('title',noSigStr);
			}else{
				chatwin.find(".chattop").children(".signatures").text(textValue).attr('title',textValue);
			}
			
			if($("#recentListdiv").find("#conversation_"+userid)){
				if($("#recentListdiv").find("#conversation_"+userid).find(".targetName").find(".signatures").length==0){
					$("#recentListdiv").find("#conversation_"+userid).find(".targetName").html("");
					$("#recentListdiv").find("#conversation_"+userid).find(".targetName").append('<span class="name"></span><span class="signatures"></span>');
				}
				$("#recentListdiv").find("#conversation_"+userid).find(".targetName").find(".name").text(userInfo.userName).attr('title',userInfo.userName);
				$("#recentListdiv").find("#conversation_"+userid).find(".targetName").find(".signatures").text(textValue).attr('title',textValue);
			}
			
	},
	//隐藏个性签名
	hideImSignPic :function(obj){
		var self = this;
		clearTimeout(self.showImSignPicTimer);
		self.showImSignPicTimer = null;
		$("#imSignaturesMessage").hide();
	},
	//展示个性签名
	showImSignPic :function(obj,uid){
	    if($(obj).closest('.zDialog_div_content').length===1&&$(obj).closest('.zDialog_div_content').prev('.chatrec_div_top').length===1){
	       return;
	    }
		var self = this;
		if (self.showImSignPicTimer) {
			return;
		}
		self.showImSignPicTimer = setTimeout(function(){
			if(uid!="undefined"&&uid!=""&&uid!=undefined){
		  		var $object =  $(obj);
		  		var targetId = uid;
				var targetName = $object.find('a').text();
				userInfos[targetId] = getUserInfo(targetId);
	            var targetHead = userInfos[targetId].userHead;	 		
		  	}else{
		  		var $object =  $(obj).parent().parent().parent();		
		  		var targetId = $object.attr("_targetid");
				var targetName = $object.attr("_targetname");
				var targetHead = $object.attr("_targethead");
		  	}
			ChatUtil.updateSignature(targetId,  function(mobileshow){
				ChatUtil.showPicSign(obj,$object,uid,targetId,targetName,targetHead, mobileshow)
			});
			clearTimeout(self.showImSignPicTimer);
			self.showImSignPicTimer = null;
		}, 600);
	},
	
	getMobileShow :function(userid,callback){
       $.post("/social/im/SocialIMOperation.jsp?operation=getMobileShow",{"userid":userid},function(data){
           if(typeof callback !=undefined && typeof callback == 'function'){
                callback($.trim(data));
            }
       });
    },
    
	showPicSign: function(obj,object,uid,targetId,targetName,targetHead, mobileshow){  
        userInfos[targetId] = getUserInfo(targetId);
        var signatures = userInfos[targetId].signatures;
        if(signatures==""){
            signatures=social_i18n('SignatureTip2');
        }
        var job = userInfos[targetId].jobtitle;
        if(job==""){
            job=social_i18n('None');
        }
        var mobile = mobileshow || userInfos[targetId].mobileShow;
        if(mobile==""){
            mobile=social_i18n('None');
        }
        var top = $(obj).offset().top;
        var left = $(obj).offset().left;
        $("#imSignaturesMessage").find(".imPic").attr("src",targetHead);
        $("#imSignaturesMessage").find("#imName").text(targetName);
        $("#imSignaturesMessage").find("#imJob").text(job);
        $("#imSignaturesMessage").find("#imPhone").text(mobile).attr("title",mobile);
        $("#imSignaturesMessage").find("#imSign").text(signatures);
        if(countByte(signatures)>48){
            $("#imSignaturesMessage").css("height","155px");
        }else if(countByte(signatures)>24){
            $("#imSignaturesMessage").css("height","140px");
        }else{
            $("#imSignaturesMessage").css("height","129px");
        }
        if(object.find('.chatLItem').length>0){
            $("#imSignaturesMessage").css("left", left+10);
            $("#imSignaturesMessage").css("top", top+50);
        }
        if(object.find('.chatRItem').length>0){
            $("#imSignaturesMessage").css("left", left-300);
            $("#imSignaturesMessage").css("top", top+50);
        }
        if(uid!="undefined"&&uid!=""&&uid!=undefined){
            $("#imSignaturesMessage").css("left", left-100);
            try{
                var top1 = $("#pc-footertoolbar").offset().top;
            }catch(err){
                var top1 = $(".imRightdiv .rightNavdiv").offset().top;
            }
            if (top1 - top < 140) {
                var y = top - 140;
            } else {
                var y = top + 50;
            }
            $("#imSignaturesMessage").css("top", y);
            if(ChatUtil.isFromPc()&&WindowDepartUtil.isAllowWinDepart()&&WindowDepartUtil.tabIsNull()){
                $("#imSignaturesMessage").css("left",-10 );
            }
        }
        $("#imSignaturesMessage").css("display","block");
    },
	
	iconRightClick: function(object,event){
		if(event.button==2){
			ChatUtil.hideImSignPic();
			if(object.parent().parent().parent().parent().attr("_targettype")==1){
				var targetId = object.attr("_targetid");
				var targetName = userInfos[targetId].userName;
				var x= event.clientX;
				var y = event.clientY;
				$('#atMessage').css("top",y+12);
				$('#atMessage').css("left",x+12);
				$('#atMessage').find("#atName").text("@"+targetName);
				$('#atMessage').show();
				$('#atMessage').unbind().bind('mouseenter',function(){
					var color = "#7bc5df";
                    if (from == 'pc') {
                        if (PcSysSettingUtils._configs.skin == 'default') {
                            color = "#7bc5df";
                        }
                        if (PcSysSettingUtils._configs.skin == 'yellow') {
                            color = "#d79a61";
                        }
                        if (PcSysSettingUtils._configs.skin == 'pink') {
                            color = "#f07994";
                        }
                        if (PcSysSettingUtils._configs.skin == 'green') {
                            color = "#48d08b";
                        }
                    } else {
                        color = "#7bc5df";
                    }
					$(this).css("background",color);
				}).bind('mouseleave',function(){
					$(this).css("background","#ffffff");
					$(this).hide();
				}).bind('click',function(){
					$(this).hide();
					var chatContentDiv = object.parent().parent().find(".chatcontent");
					var insert_tpl = "<a href='/hrm/HrmTab.jsp?_fromURL=HrmResource&id="+targetId+"' onclick=\"IMUtil.doOpenLink('/hrm/HrmTab.jsp?_fromURL=HrmResource&id="+targetId+"', '_blank')\" class='hrmecho' _relatedid='"+targetId+"' atsome='@"+targetId+"' unselectable='off' contenteditable='false' target='_blank'>@"+targetName+"</a>"; 
					//chatContentDiv.html(chatContentDiv.html()+insert_tpl+"&nbsp;");
					chatContentDiv.append(insert_tpl);
					var curPos = IMUtil.getCursorPos(chatContentDiv[0]);
					IMUtil.cache.cursorPos = curPos;
					IMUtil.moveToEndPos(chatContentDiv[0]);
					// chatContentDiv.append("&nbsp;<span id='delete'></span>");
					var deleteTag = chatContentDiv.find('.deleteTag'); 
					if(deleteTag.length == 0)
						chatContentDiv.append("&nbsp;<b class='deleteTag' style='font-weight: inherit;font-size: "+FontUtils.getConfig('fontsize')+"px'></b>");
					else 
						chatContentDiv.append(deleteTag);
					var curPos = IMUtil.getCursorPos(chatContentDiv[0]);
					IMUtil.cache.cursorPos = curPos;
					//chatContentDiv.append("&nbsp;&nbsp;");
					IMUtil.moveToEndPos(chatContentDiv[0]);


				});		
				$(document).bind("click.autoHide",function(e){
					$('#atMessage').hide();
				});
			}
		}	
	},
	
	clearWithdrawMsg: function(){
		if(isChrome){
			webSql.del("delete from social_WithdrawMsg where messageid='undefined'");
			webSql.query("select * from social_WithdrawMsg",function(result){
				if(result.length == 0 || result.rows.length == 0){
					return;
				}
				$.each(result.rows, function(i,n){
					var item=result.rows.item(i);
					var messageid = item['messageid'];
					var msgfrom = item['msgfrom'];
					var targetid = item['targetid'];
	                HandleInfoNtfMsg.withDrawMap[messageid] = 1;
	                setTimeout(function(messageid, targetid, msgfrom){
	                	HandleInfoNtfMsg.saveWithdraw(messageid, targetid, msgfrom);
	                }, 100 * i);
	                webSql.del("delete from social_WithdrawMsg where messageid='"+messageid+"'");
				});
			});
		}
	},
	//保存被撤销消息
	saveWithdrawLocal: function(messageid, targetid, msgfrom){
		if(isChrome){
            if(!messageid || messageid.length == 0 || messageid == 'undefined' || messageid == 'null') return;
			var valuses=[messageid, targetid, msgfrom];
			webSql.insert("insert into social_WithdrawMsg(messageid, targetid, msgfrom) values(?,?,?)",valuses);
		}
	},
	//删除被撤销消息
	delWithdrawLocal: function(messageid){
		if(isChrome){
            if(!messageid || messageid.length == 0 || messageid == 'undefined' || messageid == 'null') return;
			var valuses=[messageid];
			webSql.del("delete from social_WithdrawMsg where messageid=?",valuses);
		}
	},
	//保存count消息
	savaCountMsg:function(messageid,receiverid,targettype,type,userid){
		if(isChrome){
            if(!messageid || messageid.length == 0 || messageid == 'undefined' || messageid == 'null') return;
			var valuses=[messageid,receiverid,targettype,type,userid];
			webSql.insert("insert into social_IMCountMsg(messageid,receiverid,targettype,type,userid) values(?,?,?,?,?)",valuses);
		}
	},
	//删除count消息
	delCountMsg:function(messageid,userid){
		if(isChrome){
			webSql.del("delete from social_IMCountMsg where messageid='"+messageid+"' and userid ='"+userid+"'");
		}
	},
	//清除count消息
	clearCountMsg:function(){
		if(isChrome){
			client.error("清除本地count消息");
			webSql.del("delete from social_IMCountMsg where messageid='undefined'");
			webSql.query("select * from social_IMCountMsg where userid ='"+M_USERID+"'",function(result){
				for (var i = 0; i < result.rows.length; i++) {
					var item=result.rows.item(i);
					var messageid = item['messageid'];
	                var receiverid = item['receiverid'];
	                var targettype = item['targettype'];
	                var type = item['type'];
	                
	                if(type=='receive'){
	               		ChatUtil.updateMsgUnreadCount(messageid,receiverid,targettype,true,"");
	                }else{
                        if(receiverid != 'SysNotice') {
    	                	//ChatUtil.sendCountMsg(messageid,receiverid);
    	                	//将消息存入到发送池中
    	                	countMsgidsArray.push({"toid":receiverid,"msgid":messageid,"msgFrom":"web"});
    						//ChatUtil.savaCountMsg(messageid,receiverid,0,'send');
                        }
	                }
	                
	                //console.log("messageid:"+messageid+" receiverid:"+receiverid);
				}
			});
		}
	},
    //发送count消息
	sendCountMsg:function(messageid,receiverid,msgFrom){
		if(ClientSet.ifForbitReadstate == '1' && !PrivateUtil.privateRecordCache[messageid]) return;
        if((!(/^[0-9]*$/.test(receiverid))&&(receiverid+'').length<32)||(messageid+'').length<=9) {
			ChatUtil.delCountMsg(messageid,M_USERID);
			return;
		}
		var msgObj={"content":messageid,"objectName":"FW:CountMsg","targetType":"0","extra":"{\"msgFrom\":\"web\"}"};
		//接收人将消息标记为已读，接收人为当前人，消息所属人为receiverid，接收人直接将消息标记为已读之后，再给远消息发送人发送回执
		$.post("/social/im/SocialIMOperation.jsp?operation=markMsgRead",{"messageid":messageid,"receiverid":M_USERID,"senderid":receiverid},function(){
			client.sendIMMsg(receiverid,msgObj,6,function(data){
                    if(data.issuccess==1){
                        ChatUtil.delCountMsg(messageid,M_USERID);
					sendCountMsgids.push(messageid);
					try {
						var msgid =data.paramzip.msgobj.content; 
						if(!!PrivateUtil.privateRecordCache[msgid]){
							PrivateUtil.updateMsgUnreadCountHtml(msgid);
						}
					} catch (error) {}
		    	}else{
		    		countMsgidsArray.unshift({"toid":receiverid,"msgid":messageid,"msgFrom":msgFrom}); //发送失败继续发送
		    	}
	    	});
		})
	},
	//保存同步消息
	savaSyncMsg:function(messageid,msgObj){
		if(isChrome){
			var valuses=[messageid,msgObj];
			webSql.insert("insert into social_IMSyncMsg(messageid,msgObj) values(?,?)",valuses);
		}
	},
	//删除同步消息
	delSyncMsg:function(messageid){
		if(isChrome){
			webSql.del("delete from social_IMSyncMsg where messageid='"+messageid+"'");
		}
	},//清除同步消息
	clearSyncMsg:function(){
		if(isChrome){
			client.error("清除本地同步消息");
			webSql.query("select * from social_IMSyncMsg",function(result){
				
				var syncMsgidsArray=new Array();
				for (var i = 0; i < result.rows.length; i++) {
					
					var item=result.rows.item(i);
					var messageid = item['messageid'];
	                var params = item['msgObj'];
	                
	                syncMsgidsArray.push({"messageid":messageid,"params":params});
	                //console.log("messageid:"+messageid+" receiverid:"+receiverid);
				}
				
				setTimeout(function(){
					if(syncMsgidsArray.length>0){
						var msgdata=syncMsgidsArray.pop();
						var messageid=msgdata.messageid;
						var params=msgdata.params;
						client.error("----发送同步消息-----");
						var msgObj={"content":params,"objectName":"FW:SyncMsg","targetType":"0"};
						client.sendIMMsg(M_USERID,msgObj,6,function(data){
							if(data.issuccess==1){
					    		ChatUtil.delSyncMsg(messageid);
							}
						});
					}
				},500);
				
			});
		}
	},
    isFromPc : function(){
        return typeof from != 'undefined' && from == 'pc';
    },
    getServerTimeStamp: function(callback){
    	$.post("/social/im/SocialIMOperation.jsp?operation=getTime", function(ts){
    		if(typeof callback == 'function') {
    			callback(ts);
    		}
    	});
    },
    formatString : function(srcStr, args) {
        var result = srcStr;
        if (arguments.length > 0) {    
            if (typeof (args) == "object") {
                for (var key in args) {
                    if(args[key]!=undefined){
                        var reg = new RegExp("({" + key + "})", "g");
                        result = result.replace(reg, args[key]);
                    }
                }
            }
            else {
                for (var i = 0; i < arguments.length; i++) {
                    if (arguments[i] != undefined) {
    　　　　　　　　　　var reg= new RegExp("({)" + i + "(})", "g");
                        result = result.replace(reg, arguments[i]);
                    }
                }
            }
        }
        return result;
    },
    //设置
    settings: {
    	mystyle: {
			"left": 135+"px", 
       		"bottom": 0+"px", 
       		"right": 286+"px"
		},
		mystyle1: {
    		"left": 50+"px", 
    		"top": 10+"px", 
    		"right": 50+"px",
    		"height": 20+"px",
    		"position": "absolute"
		},
		gif: "/express/task/images/loading1_wev8.gif",
		voice_left_png: "/social/images/chat_voice_l_wev8.png",
		voice_right_png: "/social/images/chat_voice_r_wev8.png",
		voice_left_gif: "/social/images/chat_voice_l_wev8.gif",
		voice_right_gif: "/social/images/chat_voice_r_wev8.gif",
		dismissionStatus: ['4', '5', '6', '7']
    },
	//缓存
	cache: {
		//已完成任务
		completedTasks: [],
		//输入框编辑缓存
		chatContents: [],
		//CTRL+Z缓存
		cache4ctrlz: [],
		dialog: null,
		voicestate: [],
		//待发送的附件或图片
		preSendData: [],
		//是否被踢出
		kickFlags: []
	},
	//图片池
	imgpool : [],
	//音频池
	voicepool : [],
	stopAllVoice: function(isLeft, curKey, selfIgnore){
		for(var _key in ChatUtil.voicepool){
			if(typeof ChatUtil.voicepool[_key] != 'string'
				|| (selfIgnore && _key == curKey))
				continue;
			IMClient.RongIMVoice.stop(ChatUtil.voicepool[_key]);
			client.writeLog("stopping voice "+ _key);
			ChatUtil.cache.voicestate[_key] = '0';
			var isLefts = $("#voice_"+_key).attr("isLefts") === 'true';
			$("#voice_"+_key+">img").attr('src', isLefts?ChatUtil.settings.voice_left_png:ChatUtil.settings.voice_right_png);
		}
	},
	stopVoice: function(isLeft, _key){
		if(typeof ChatUtil.voicepool[_key] != 'string')
				return;
		IMClient.RongIMVoice.stop(ChatUtil.voicepool[_key]);

		client.writeLog("stopping voice "+ _key);
		ChatUtil.cache.voicestate[_key] = '0';
		$("#voice_"+_key+">img").attr('src', isLeft?ChatUtil.settings.voice_left_png:ChatUtil.settings.voice_right_png);
	},
	//播放语言
	playVoice : function(obj, key, isLeft, duration) {
		ChatUtil.stopAllVoice(isLeft, key, true);
		var voice_base64 = ChatUtil.voicepool[key];
		if(typeof voice_base64 != 'string'){
			client.writeLog("不是base64串！");
			return;
		}
		//当前语音正在播放，立即停止播放
		if( ChatUtil.cache.voicestate[key] == '1') {
			ChatUtil.stopVoice(isLeft, key);
			ChatUtil.cache.voicestate[key] = '2';
			return;
		}
		
		var img = $(obj).find('img');
		var srcGif = isLeft?ChatUtil.settings.voice_left_gif:ChatUtil.settings.voice_right_gif;
		var srcPng = isLeft?ChatUtil.settings.voice_left_png:ChatUtil.settings.voice_right_png;
		try{
			client.writeLog("开始播放");
			ChatUtil.cache.voicestate[key] = '1';
			IMClient.RongIMVoice.onprogress = function(isOk){
				client.writeLog(isOk);
				isOk = Math.floor(isOk);
				//需要立即停止
				var needStopNow = ChatUtil.cache.voicestate[key] == '2';
				if(isOk || needStopNow){
					if(needStopNow){
						client.writeLog("播放被停止");
						ChatUtil.stopVoice(isLeft, key);
					}
					client.writeLog("播放完毕");
					$(img).attr('src', srcPng);
				}else{
					ChatUtil.cache.voicestate[key] == '1';
				}
			}
			IMClient.RongIMVoice.play(voice_base64, 1+duration);
			$(img).attr('src', srcGif);
		}catch(err){
			client.writeLog("播放异常");
			ChatUtil.stopVoice(isLeft, key);
		}
	},
	//加载更多文件
	doLoadMoreFiles: function(targetList){
		if(targetList.length > 0){
			var chatwin = ChatUtil.getchatwin(targetList);
			var targetId = chatwin.attr("_targetid");
			var targetType = chatwin.attr("_targettype");
			var pageno = targetList.attr("pageno");
			pageno = parseInt(pageno)+1;
			var hasnext = targetList.attr("hasnext");
			if(hasnext == 'false' || !!targetList.attr("loading")){
				return;
			}
			targetList.attr("loading", "loading");
			DiscussUtil.getIMFileList(targetList, targetId, targetType, pageno, 10, false);
		}
	},
	cardOpenHrm:function(userid){
		var e = getEvent();
    	e = e || window.event;
		pointerXY(e);
		if(typeof from != 'undefined' && from == 'pc'){
			DragUtils.closeDrags();
		}
		$('#closetext').data('onclickbak', $(this).attr('onclick'));
		$('#closetext').attr('onclick', 'closeIMdiv(this);');
		openhrm(userid);
		$('#HelpFrame').css('border', 'none');
    },
	//初始化聊天窗口
	initChatDiv: function(acceptId, chatType, chatName, headicon){
		setTimeout(function(){
			$('.dataLoading,.loading1').fadeOut(); //去除loading提示
		}, 10 * 1000);
		if(!client){
			$('.dataLoading,.loading1').fadeOut(); //去除loading提示
			ChatUtil.postFloatNotice(social_i18n('FloatNotice2'), "error", {
				"onclick": {
					"fn": function(acceptId, chatType, chatName, headicon){
						ChatUtil.initChatDiv(acceptId, chatType, chatName, headicon);
					}
				}
			});
			return;
		}
		var chatdiv=$("#chatdiv_"+acceptId); //聊天窗口对象
		var chatWinid="chatWin_"+chatType+"_"+acceptId;
		var realTargetid =  acceptId;
  		if(chatType == 8){
			var realTargetid = acceptId.substring(acceptId.indexOf("_")+1);
		  }
  	if(ClientSet.ifForbitEmWaterMark == '0' && chatType != "8"){
      var watermark ;
			var markid ='';
			var textBg = 'white';
			try{
			markid = userInfos[M_USERID].mobile;
			if(markid!==''&&markid!=='undefined'&&markid!==undefined){
				var reg = new RegExp("[\\u4E00-\\u9FFF]+","g");
				if(reg.test(markid)){
					markid='';
				}else{
					markid=markid.substring(markid.length-4, markid.length);
				}
			}else{
					markid='';
			}
			}catch(err){
				markid='';
			}
			try{
            if(ClientSet.emWaterMark==''||ClientSet.emWaterMark=='null'||ClientSet.emWaterMark==undefined||ClientSet.emWaterMark=='undefined'){
                watermark = userInfos[M_USERID].userName+markid;        
            }else{
                watermark = ClientSet.emWaterMark;
            }}catch(err){
				watermark = userInfos[M_USERID].userName+markid; 
			}
			//watermark='这个名字有点长，看下能不能展示出来';
			try{
				var cArr = watermark.match(/[^\x00-\xff]/ig);
				var Chineselength = watermark.length + (cArr == null ? 0 : cArr.length);
				if(Chineselength>=24){
					watermark = watermark.substring(0, 12);
					textBg='black';
				}
			}catch(err){
				watermark='水印异常，请检查';
			}
          var img, textWidth, firstMargin, secondMargin ;
          img="/social/js/watermark/watermark100_150.png";
          textWidth = "80";	  
		  secondMargin=15;
		  firstMargin=5;
          var mydate = new Date();
          var year=mydate.getFullYear(); //获取完整的年份(4位,1970-????)
          var month = 1 + mydate.getMonth(); //获取当前月份(0-11,0代表1月)
          var day = mydate.getDate(); //获取当前日(1-31) 
          var textDay = year + "-" + month +"-" +day;
            try{
              $(function() {
                  $('<img>', {
                      src: img
                  }).watermark({
                      textColor:'grey',
                      textSize:12,
                      text:watermark,
                      textWidth: textWidth,
                      textBg:textBg,
                      gravity: 'nw',
                      opacity: 0.2,
                      margin:firstMargin,
                      outputType:'png',
                      done: function (imgURL) {                           
                        $(function() {
                          $('<img>', {
                              src: imgURL
                          }).watermark({
                              textColor:'grey',
                              textSize:12,
                              text:textDay,
                              textWidth: textWidth,
                              textBg:'white',
                              gravity: 'nw',
                              opacity: 0.2,
                              margin:secondMargin,
                              outputType:'png',
                              done: function (newImg) {
                                  //console.log(newImg);
                                  chatdiv.find("#chatList").css("background-image","url("+newImg+")");
                                    chatdiv.find("#chatList").css("background-repeat","repeat");
                                    chatdiv.find("#chatList").css("background-attachment","scroll");
                              },
                              fail: function ( newImg ) {
                             console.error(newImg, 'image error!');
                              }
                          });
                      });
                      },
                      fail: function ( imgURL ) {
                     console.error(imgURL, 'image error!');
                      }
                  });
              });}catch(err){
                  client.writeLog("该浏览器不支持canvas");
              }
        }
		//判断群文件共享权限、
		if(ClientSet.ifForbitGroupFileShare == '1' && chatType == '1'){
			chatdiv.find(".chattabdiv[_target='fileList']").remove();
		}
  		//发布公告相关
		if(chatType == "1"){
			DiscussUtil.checkDisRight(acceptId, function(hasRight){
				if(hasRight){
					$(document).bind("click.autoHide",function(e){
						e = e || window.event;
						var $obj = $(e.srcElement || e.target);
						if($obj.hasClass('noteEdit')) 
							return false;
						DiscussUtil.cancelRelease(document.getElementById('noteEd_'+acceptId), false);
					});
					//DiscussUtil.bindEscape(chatdiv);
					chatdiv.find(".gg_edit_area").autosize();
				}
			});
		}
		// 使用4401测试
		if(true){
			drawExpressionWrap(acceptId);
		}
  		
  		var chatcontent=chatdiv.find('.chatcontent');
  		
  		chatcontent.focus(); //输入窗口获得焦点
  		
  		if(chatType == "1"){
	  		ChatUtil.getDiscussionInfo(acceptId,true,function(discuss){
				var targetid=acceptId;
				//设置群信息
				ChatUtil.setCurDiscussInfo(acceptId, chatType);

				if(!discuss){

					 $("#conversation_"+targetid).remove();
					 closeTabWin($("#chatTab_1_"+targetid+" .tabClostBtn"));
					ChatUtil.postFloatNotice(social_i18n('FloatNotice3'));
					$('.dataLoading,.loading1').fadeOut(); //去除loading提示	
					return ;
				}

				ChatUtil.getHistoryMessages(chatType,acceptId,10,true);
	  			setTimeout(function(){
	  				ChatUtil.initIMAtwho(acceptId);//初始化输入框提示
	  			},2000);
	  			var createrid=getRealUserId(discuss.getCreatorId());
	  			client.writeLog("createrid:"+createrid);
	  			if(createrid==M_USERID){
	  				chatdiv.find(".noteEdit").show();
	  			}
	  			
	  		});
  		}else if(chatType == 8){			
			ChatUtil.getHistoryMessages(chatType,realTargetid,10,true);			
		}else{
			ChatUtil.getHistoryMessages(chatType,acceptId,10,true);
			PrivateUtil.setHotPrivatChatIcon(realTargetid,true);
		}
		//chatdiv.find('.chatRight').perfectScrollbar();
		var chatList=chatdiv.find('.chatList');
		try{
	  		var scrollbarid=IMUtil.imPerfectScrollbar(chatList)[0];
	  		$("#"+scrollbarid).css({"z-index":1001});
	  		
	  		IMUtil.imPerfectScrollbar(chatdiv.find('.acclist'));
	  		IMUtil.bindLoadMoreHandler(chatdiv.find('.acclist'), function(targetList){
	  			ChatUtil.doLoadMoreFiles(targetList);
	  		});
	  		if(chatType == "1"){
	  			IMUtil.imPerfectScrollbar(chatdiv.find('.noteList'));
	  		}
		}catch(e){
			client.error("error from IMUtil.imPerfectScrollbar", e);
		}
  		//增加参数防止滚动条对空格输入的影响 1125 by wyw
  		chatdiv.find('.chatcontent').perfectScrollbar({'spacebarenabled':false});
  		chatdiv.find('.chatbottom').resizable({
  			handles: 'n',
  			maxHeight: 377,
  			minHeight: 171,
  			resize: function( event, ui ) {
  				var _chatLeft = ui.element.parent();
  				var _chatList = _chatLeft.find('.chatList');
  				var b =  ui.element.height();
  				var ch = _chatLeft.height();
  				_chatList.css('bottom', b * 100 / ch + '%');
  				ui.element.css('top', (_chatList.height() + _chatList.position().top) * 100 / ch + '%');
  			},
  			start: function( event, ui ) {
  				ui.originalPosition.top = ui.element.position().top;
  			},
  			stop: function(event, ui) {
  				ui.element.css('height', 'auto');
  			}
  			
  		});
  		chatdiv.find('.sendtype').autoHide("#chatdiv_"+acceptId+" .sendtype, #chatdiv_"+acceptId+" .chatSendType");
  		//关掉内容格式过滤
  		clearContentHtml(chatdiv.find('.chatcontent'));
  		//滚动条显示在最下方
  		//scrollTOBottom($('#chatdiv_<%=acceptId%> .chatList'));
  		if(true){
	  		bindDmUploader("uploadImgDiv_"+acceptId, {
	  			"allowedTypes": "image/(?:png|jpeg|bmp|gif)",
	  			"extraData": {"uploadType": "image"},
	  			"extFilter":"png;jpg;jpeg;bmp;gif",
	  			"targetid": acceptId,
	  			"fireBtnCls": "uploadImgLayer",
	  			"successcallback": uploadImgBatch,
	  			"flashContainerId": "dmUploadAccDiv_"+acceptId
			  });
	  		var targetContId = "chatWin_"+chatType+"_"+realTargetid;
	  		var opts = {
	  			"allowedTypes": ".*",
	  			"extraData": {"uploadType": "acc"},
	  			"targetid": acceptId,
	  			"fireBtnCls": "uploadAccLayer",
	  			"successcallback": uploadAccBatch,
	  			"flashContainerId": "dmUploadAccDiv_"+acceptId
	  		};
	  		
	  		if(ClientSet.ifForbitFilesTransfer == '1'){
	  			opts['dropEventOff'] = true;
	  		}
	  		bindDmUploader(targetContId, opts);
	  		
  		}else{
	  		bindUploaderDiv({
		  		"targetid":"uploadImgDiv_"+acceptId,
		  		"contentid":"chatcontent_"+acceptId,
		  		"processBarWidth":180,
		  		"callback":initUploadImg,
		  		"clearProcess":true
	  		});
	  		
	  		bindUploaderDiv({
		  		"targetid":"uploadAccDiv_"+acceptId,
		  		"contentid":"chatcontent_"+acceptId,
		  		"processBarWidth":180,
		  		"callback":initUploadAcc,
		  		"clearProcess":true
	  		});
  		}
  		
  		bindUploaderDiv({
	  		"targetid":"uploadFile_"+acceptId,
	  		"contentid":"chatcontent_"+acceptId,
	  		"processBarWidth":180,
	  		"callback":initUploadAcc,
	  		"clearProcess":true
  		});
  		//监听输入框失去焦点事件，缓存输入框最新光标位置（场景：表情插入）
  		chatcontent.mouseover(function(e){
  			$(this).unbind('blur.cursor').bind('blur.cursor',function(e){
  				e = event || window.event;
  				var dom = e.srcElement || e.target;
	  			var curPos = IMUtil.getCursorPos(dom);
				IMUtil.cache.cursorPos = curPos;	
				$(this).unbind('blur.cursor');
  			});
  		});
  		//人员卡片模块
  		$("#mainsupports,#message_table").hide();
  		if(typeof from != 'undefined' && from == 'pc'){
			DragUtils.restoreDrags();
		}
  		if(chatType == '0'){
  			var userid = acceptId;
  			//chatdiv.find('.imtitleName').addClass('imtitleNameEllipsis');
			chatdiv.find('.imtitleName').bind('click', function(e){
				e = e || window.event;
				pointerXY(e);
				if(typeof from != 'undefined' && from == 'pc'){
					DragUtils.closeDrags();
				}
				$('#closetext').data('onclickbak', $(this).attr('onclick'));
				$('#closetext').attr('onclick', 'closeIMdiv(this);');
				openhrm(userid);
				$('#HelpFrame').css('border', 'none');
			});
            if(/^[0-9]*$/.test(userid)) {
                //电话和手机号码
                var posturi = "/hrm/resource/simpleHrmResourceTemp.jsp?userid="+userid+"&date="+new Date();
                $.post(posturi, function(ret){
                    ret = $.trim(ret);
                    var simpleInfo = ret.split('$$$');
                    var mobilephone = simpleInfo[4];
                    var fixphone = simpleInfo[5];
//                    var dept = simpleInfo[simpleInfo.length-5];
                    var dept = getUserInfo(userid).deptName;
                    client.writeLog("simpleInfo；",simpleInfo);
                    if(mobilephone != '' && mobilephone != ','){
                        chatdiv.find('.mobilephone').attr("title",mobilephone).text(mobilephone).prev('img').show();
                    }else{
                    	chatdiv.find('.mobilephone').remove();
                    }
                    if(fixphone != '' && fixphone != ','){
                        chatdiv.find('.fixphone').attr("title",fixphone).text(fixphone).prev('img').show();
						chatdiv.find('.mobilephone').addClass('mobilephoneEllipsis');
                    }else{
                    	chatdiv.find('.fixphone').remove();
                    }
			
		    var url=getPostUrl("/social/im/SocialIMOperation.jsp?operation=getUserDeptID&acceptid="+userid);
					$.post(url,	
					function(data){	
						var d = $.trim(data);
						if(d != "") {
							chatdiv.find('.dept').attr("deptid",d);
						}
					});
                    if(dept != '' && dept != ','){
                    	chatdiv.find('.dept').attr("title",dept).text(dept).prev('img').show();
						if((mobilephone != '' && mobilephone != ',')||(fixphone != '' && fixphone != ',')){chatdiv.find('.dept').addClass('deptEllipsis'); }                 	
                    }else{
                    	chatdiv.find('.dept').remove();
                    }
					if(mobilephone!=''||fixphone!=''||dept!=''){
						chatdiv.find('.imtitleName').addClass('imtitleNameEllipsis');
					}
                });
            }

            chatdiv.find('.dept').bind('click', function(e){
				e = e || window.event;
				pointerXY(e);
				if(typeof from != 'undefined' && from == 'pc'){
					DragUtils.closeDrags();
				}
				var deptid = $(this).attr('deptid');
				var url = '/hrm/HrmTab.jsp?_fromURL=HrmDepartmentDsp&id='+deptid;
				PcExternalUtils.openUrlByLocalApp(url,0);
				DragUtils.restoreDrags();
			}).mouseenter(function(){
				$(this).addClass("dept_hover");
			}).mouseleave(function(){
				$(this).removeClass("dept_hover");
			});
  		}else if(chatType =="8"){
			//密聊会话处理
			chatdiv.find('.imtitleName').text('<' + social_i18n('Back')).attr('title', social_i18n('Back')).addClass('imtitlePrivateBack')
					.unbind('click').bind('click',function(e){
						PrivateUtil.backToPrivateRecentList();
					});
			chatdiv.find('.chattop').hide();
			chatdiv.find('.chatListbox ').css({'border-top':' 1px solid #e3e6f0'});
			chatdiv.find('.chatRecord').hide();
		  }

  		
  		// 查看更多消息
  		chatList.append("<div class='loadmorediv'><img src='/social/images/im/im_loadmore_wev8.png'/><span onclick='ChatUtil.loadMoreHistorys(event, this)'>查看更多消息</span></div>");
  		
  		// 初始化字体设置
  		FontUtils.init(acceptId);
  		//快速版需要做的处理
  		if(versionTag == 'rdeploy'){
  			chatcontent.find("span.modehint").empty(); //输入窗口获得焦点
  			chatdiv.find('.noteList').perfectScrollbar();
  			//监听输入框焦点事件
	  		chatdiv.find('.chatcontent').focus(function(event){
	  			var mode = getEditMode(this);
			  	if(mode == "normal")
			  		$(this).parent().addClass('chatContentActive');
			  	else if(mode == "task"){
			  		$(this).parent().addClass('chatContentActiveTask');
			  	}
	  			var hint = $(this).find("span.modehint");
	  			if(hint.length > 0){
	  				hint.empty();
	  				$(this).empty();
	  			} 
	  		}).
	  		blur(function(event){
			  	$(this).parent().removeClass('chatContentActiveTask');
			  	$(this).parent().removeClass('chatContentActive');
	  			var chatct = $(this);
	  			if(chatct.html() == "" || chatct.html() == "<br>"){
	  				var modeChangeSwitch = $(this).parent().find(".immodeChangeSwitch");
	  				var istaskmode = chatdiv.find('.chatcontent').attr("_istaskmode");
	  				if(istaskmode == '1'){
	  					chatct.html("<span class='modehint'>添加一个新的任务</span>");
	  				}else{
	  					chatct.html("<span class='modehint'>输入您要发送的内容，Enter键发送，Shift+Enter键换行</span>");
	  				}
	  				modeChangeSwitch.show();
	  			}
	 		});
	 		chatdiv.find('.chatcontentwrap').live("hover",function(event){
	 			var mode = getEditMode(chatdiv.find('.chatcontent'));
			  	
	 			if(event.type=='mouseenter'){ 
					if(mode == "normal")
				  		$(this).addClass('chatContentActive');
				  	else if(mode == "task"){
				  		$(this).addClass('chatContentActiveTask');
				  	}
				}else if(!$(this).find(".chatcontent").is(":focus")){ 
				  	$(this).removeClass('chatContentActive').removeClass('chatContentActiveTask');
				} 
	 		});
	 		bindCloseBtnHover(chatType,acceptId);
  		}
  		
  		$('#'+chatWinid).attr('_isInited', 'true');
	},
	// 获取历史消息
	loadMoreHistorys: function(evt, obj){
		var chatwin = ChatUtil.getchatwin(obj);
		var chatListdiv = chatwin.find('.chatList');
		var isHasNext=chatListdiv.attr("_isHasNext"); //是否有下一页
        var isFinish=chatListdiv.attr("_isFinish"); //一次数据是否加载完成
        chatListdiv.attr("_isFinish","0"); //设置为加载完成状态
        var targetType = chatwin.attr("_targettype");
    	var realTargetid = chatwin.attr("_targetid");
    	
    	var mystyle = {
    		"left": 50+"px", 
    		"top": 10+"px", 
    		"right": 50+"px",
    		"height": 20+"px",
    		"position": "absolute"
    	};
    	$(obj).parent().hide();
    	if(isFinish=="1" && isHasNext=="1"){
    		IMUtil.showLoading(chatListdiv, mystyle,"", 1000, function(){
	    		ChatUtil.getHistoryMessages(targetType,realTargetid,10,false);
	    	});
    	}
	},
	//显示位置
	showIMLocation: function(latitude,longitude,description){
		description=encodeURIComponent(description);
		dialog = new window.top.Dialog();
		dialog.currentWindow = window;
		var url=getPostUrl("/social/im/SocialShowLocation.jsp?latitude="+latitude+"&longitude="+longitude+"&description="+description);
		
		url=getPostUrl(url);
		
		dialog.Title = "位置";
		dialog.Width = 600;
		dialog.Height = 450;
		dialog.normalDialog= false;
		dialog.Drag = true;
		dialog.URL = url;
		dialog.show();
	},
	//表情格式化
	imFaceFormate: function(obj) {
		//debugger;
		$(obj).find(".RC_Expression").each(function(){
			var $b = $(this);
		 	var faceCode=$b.attr("alt");
		 	if(!faceCode){
		 		var classStr = $b.parent('span').attr('class');
		 		var en = classStr.substring('RongIMexpression_'.length, classStr.length);
		 		var emObj = M_CORE.Expression.getEmojiObjByEnglishNameOrChineseName(en);
		 		faceCode = emObj.chineseName;
		 	}
		 	$b.replaceWith('['+faceCode+']');
		});
	},
	//格式化聊天内容，对表情，html进行转换
	formatChatContent: function(obj) {
		if(!(obj instanceof jQuery)) {
			obj = $("<div>"+obj+"</div>");
		}
		var tempObj=obj.clone();
		$(tempObj).find("div").each(function(){
		 	var txtContent=$(this).text();
		 	$(this).replaceWith('\n'+txtContent);
		});
		/*
		$(tempObj).find(".RC_Expression").each(function(){
		 	var faceCode=$(this).attr("alt");
		 	$(this).replaceWith('['+faceCode+']');
		});
		*/
		ChatUtil.imFaceFormate(tempObj);
		$(tempObj).find("br").each(function(){
			$(this).replaceWith("##br##");
		});
		
		var content=tempObj.text();
		//在这边会把[表情]转为unicode再转化为网页编码（utf-8）,但是存在数据库会乱码，所以私有云不进行转码操作
		//[中文]-->表情
		//if(!IS_BASE_ON_OPENFIRE){
			content = getEmotionObj(content);
		//}
		content=content.replace(/&nbsp;/g," ").replace(/##br##/g,"\n");
		// 处理编码为160的空格
		content = IMUtil.replaceSpace160(content);
		return content;
	},
	UploadPreview: {
		form: null,
		blob: null,
		chatdiv: null,
		previewdlg: null,
		ignoreCompress: false
	},
	//从base64串里转换blob
	confirmImgbase64: function(base64, mimetype, chatdiv){
		var imgtypedarray = IMUtil.base64ToTypedArray(base64);
		var blob = new Blob(imgtypedarray, {type : mimetype});
		var formdata = new FormData();
		formdata.append('enctype', 'multipart/form-data')
		formdata.append('Filedata', blob);
		ChatUtil.confirmImg(blob, formdata, chatdiv);
	},
	//确认粘贴的图片
	confirmImg: function(blob, form, chatdiv, ignoreCompress) {
		if(ClientSet.ifSendPicOrScreenShots == '1') return;
		var IMdlg = $('.IMConfirm');
		if(ChatUtil.cache.reloadPrevImgHandler && ChatUtil.isFromPc() && blob.size == ChatUtil.UploadPreview.imageSize) {
			return;
		}
		ChatUtil.UploadPreview.imageSize = blob.size;
		ChatUtil.UploadPreview.previewdlg = IMdlg;
		ChatUtil.UploadPreview.form = form;
		ChatUtil.UploadPreview.blob = blob;
		ChatUtil.UploadPreview.chatdiv = chatdiv;
		ChatUtil.UploadPreview.ignoreCompress = !!ignoreCompress;
		/*注:FileReader是html5新特性，确保IE版本不低于10*/
		IMUtil.getImgUrlFromBlob(blob, function(url){
			IMdlg.imconfirm({
				'autohide':false,
				'draggble':false,
				'isModel':true,
				'title':'图片预览',
				'buttons': [
					{
						'btn_ok': ChatUtil.doHandleChoose
					},
					{
						'btn_cancel': ChatUtil.doHandleChoose
					}
				],
				'innerhtml': '<img src="' + url + '"/>',
				'onclose': function(){
					ChatUtil.closeReloadPrevImgHandler();
				}
			});
			if(IMdlg.attr('showing') == 'true'){
				IMdlg.find('.inner>img').attr('src', url);
			}else{
				IMdlg.imshow();
			}
			if(ChatUtil.isFromPc() && !ChatUtil.cache.reloadPrevImgHandler&& typeof WindowPlatform=="undefined"){
				ChatUtil.startReloadPrevImgHandler();
			}
		});
	},
	// 关闭图片预览监听器
	closeReloadPrevImgHandler: function(){
		clearInterval(ChatUtil.cache.reloadPrevImgHandler);
		ChatUtil.cache.reloadPrevImgHandler = null;
	},
	// 启动图片预览监听器
	startReloadPrevImgHandler: function(){
		ChatUtil.closeReloadPrevImgHandler();
		ChatUtil.cache.reloadPrevImgHandler = setInterval(function(){
			var $chatwin = ChatUtil.getCurChatwin();
            if($chatwin.length > 0) {
                var $chatContent = $chatwin.find('.chatcontent');
                if($chatContent) {
                    $chatContent.focus();
				  	if(typeof WindowPlatform!="undefined" && WindowPlatform =="xp"){
						document.execCommand('Paste');
					}else{
						window.Electron.currentWindow.webContents.paste();
					}
                }
            }
		}, 1000);
	},
	//确认是否发送图片
	doHandleChoose: function(result){
		var choose = result.choose;
		var previewdlg = ChatUtil.UploadPreview.previewdlg;
		var chatdiv = ChatUtil.UploadPreview.chatdiv;
		var chatSendDiv = chatdiv.find(".chatSend");
		var targetid = chatSendDiv.attr("_acceptid");
		var targettype = chatSendDiv.attr("_chattype");
		if(targettype=="8"){
			targettype = "0";
			targetid = targetid.substring(targetid.indexOf("_")+1);
		}
		//取消
		if(choose == '2'){
			previewdlg.imclose();
			return;
		}
		if(choose == '1'){
			var form = ChatUtil.UploadPreview.form;
			var curtime = new Date().getTime();
			$.ajax({
	            url: '/social/SocialUploadOperate.jsp?uploadType=pasteimage',
	            type: "POST",
	            data: form,
	            processData: false,
	            contentType: false,
	            beforeSend: function() {
	                //开启加载动画
	            	//previewdlg.imtoast();
	            },
	            error: function() {
	                client.writeLog("图片上传失败");
	                previewdlg.imclose();
	            },
	            success: function(data) {
	            	data = $.parseJSON(data);
	            	var blob = ChatUtil.UploadPreview.blob;
	            	var ignoreCompress = ChatUtil.UploadPreview.ignoreCompress
	            	// 服务端压缩失败的情况下， 使用js进行图片压缩
	            	if(!data.content) {
		            	IMUtil.getImgUrlFromBlob(blob, function(src){
		            		if(!ignoreCompress) {
		            			IMUtil.compressImg(src, {maxHeight: 180}, function(base64){
			            			data.content = base64;
			            			handleData(data);
			            		});
		            		} else {
		            			data.content = src.replace(/^data:image\/\w+;base64,/, "");
		            			handleData(data);
		            		}
		            	});
	            	} else {
	            		handleData(data);
	            	}
	            	function handleData(data) {
	            		ChatUtil.sendIMMsg(chatSendDiv,2,data, function(msg){
		                	var issuccess = msg.issuccess;
		                	if(issuccess){
		                		// 添加权限方法移到外面
		                	}
		                });
		                previewdlg.imclose();
		                //粘贴图片添加权限 1225 by wyw
	        			var filedata = {};
	        			filedata["fileId"]=data.imgUrl;
						filedata["fileName"]=data.filename;
						filedata["fileSize"]=data.filesize;
						filedata["fileType"]="img";
						filedata["resourcetype"]="2";
	        			_addIMFileRight(targetid, targettype, filedata);
	            	}
	            },
	            xhr: function(){
			        var xhrobj = $.ajaxSettings.xhr();
			        if(xhrobj.upload){
			          xhrobj.upload.addEventListener('progress', function(event) {
			            var percent = 0;
			            var position = event.loaded || event.position;
			            var total = event.total || event.totalSize;
			            if(event.lengthComputable){
			              percent = Math.ceil(position / total * 100);
			            }
						client.writeLog("当前进度:" + percent);
			            ChatUtil.showUploadProgress(targetid, percent, curtime);
			          }, false);
			        }
			
			        return xhrobj;
			      }
	        })
		}
		previewdlg.imclose();
	},
	// 显示上传进度
	showUploadProgress: function(targetid, percent, fileid){
		//显示上传进度
    	var blob = ChatUtil.UploadPreview.blob;
    	var file = {id:fileid, name:fileid+".png", size: blob.size};
    	if(typeof from != 'undefined' && from == 'pc'){
    		var jqId = '#uploadImgDiv_'+targetid+'_SUC';
    		var $suc = $(jqId);
    		var item = $suc.find(".social-upload-file0");
    		if(item.length == 0){
    			addFile(jqId, 0, file);
    		}
    		$suc.show();
    		/*
    		setTimeout(function(){
	    		var item = $suc.find(".social-upload-file0");
	    		var percentages = [20, 30, 40, 50, 60, 70, 80, 90, 100], per;
	    		$.each(percentages, function(i, per){
	    			per = percentages[i] + '%';
	    			setTimeout(function(){
	    				item.find('div.progress-bar').width(per);
						item.find('span.sr-only').html(per);
						console.log("执行："+i,"per:"+per);
						if(per == '100%'){
							setTimeout(function(){
								$suc.empty().hide();
							}, 400);
						}
	    			}, percentages[i] * i);
	    		});
    		}, 50);
    		*/
    		
    		item.find('div.progress-bar').width(percent+'%');
			item.find('span.sr-only').html(percent+'%');
			if(percent == '100'){
				setTimeout(function(){
					$suc.empty().hide();
					var chatdiv = ChatUtil.UploadPreview.chatdiv;
					IMUtil.moveToEndPos(chatdiv.find('.chatcontent')[0]);
				},400);
			}
    	}else{
    		var ud_targetid = "uploadImgDiv_"+targetid;
	    	$("#uploadProcess_"+ud_targetid).show();
	    	var $progress = $("#"+file.id);
	    	if($progress.length == 0){
	    		$progress = $("#progressDemo_"+ud_targetid).clone();
	    		$progress.attr("id",file.id);
		    	$progress.find(".fileName").text(file.name);
		    	$progress.find(".fileSize").text(getSizeFormate(file.size));
		    	$progress.show();
		    	var $fsUploadProgress=$("#fsUploadProgress_"+ud_targetid);
		    	if(ud_targetid=="uploadRemarkImgDiv"||ud_targetid=="uploadEditRemarkImgDiv"){
		    		$fsUploadProgress.find(".imgAdddiv").before($progress);
		    	}else{
		    		$fsUploadProgress.append($progress);
		    	}
	    	}
	    	/*
		    var percentage = 10,SEED = 200,X = 10;
	        $progress.show();
	        var timeProgress = setInterval(function(){
	        	if(percentage >= 80)
	        		percentage = 99;
	        	if(percentage == 99){
	        		clearInterval(timeProgress);
	        	}else{
	        		$('#'+file.id).find('.fileProgress').progressBar(percentage);
	        	}
	        	percentage += ((X++)*3 + SEED) / (X++)*2;
	        }, 500);
	        */
	    	$('#'+file.id).find('.fileProgress').progressBar(percent);
	    	if(percent == '100'){
	    		setTimeout(function(){
					$('#'+file.id).remove();
        			$('#uploadProcess_'+ud_targetid).hide();
        			var chatdiv = ChatUtil.UploadPreview.chatdiv;
					IMUtil.moveToEndPos(chatdiv.find('.chatcontent')[0]);
				},400);
			}
    	}
	},
	//打开消息记录
	showChatRecord: function(obj){
		var chatWin = $(obj).parents('.chatWin').first();
		var title=social_i18n('ChatRecord');
		var loginuserid = M_USERID;
		var targetid = chatWin.attr('_targetid');
		var targettype = chatWin.attr('_targettype');
	    var url="/social/im/SocialIMChatRecord.jsp?loginuserid="+loginuserid+"&targetid="+targetid+"&targettype="+targettype+"&IS_BASE_ON_OPENFIRE="+IS_BASE_ON_OPENFIRE;
	    url=getPostUrl(url);
	    
		var diag=getSocialDialog(title,620,550);
		diag.URL =url;
		diag.openerWin = window;
		diag.show();
		ChatUtil.cache.dialog = diag;
		document.body.click();
	},
	//获取本地会话
	getLocalConvers: function(){
		var url=getPostUrl("/social/im/SocialIMOperation.jsp?operation=getConvers");
		$.post(url,
		function(data){
			var d = $.trim(data);
			if(d != "") {
				var convers = $.parseJSON(d);
				client.writeLog("convers"+convers);
				$.each(convers, function(i, converjs){
					var converTempdiv = getConverTempdiv(converjs.targetid, converjs.targettype);
					converTempdiv.find(".msgcontent").html(converjs.msgcontent);
					converTempdiv.find(".latestTime").html(converjs.lasttime);
					$("#recentListdiv").prepend(converTempdiv);
				});
			}
		});
	},
	//保存会话到本地数据库
	syncConversToLocal: function(converList,flag){
		if(IS_BASE_ON_OPENFIRE&&typeof flag ==="undefined") return;
		if(!converList || converList.length <= 0) return;
		var convers = {};
		var converlen=0;
		for(var i = 0; i < converList.length; ++i){
			var conver=converList[i];
			var targettype=conver.targettype+"";
			if(conver.targetid==""||targettype==""||conver.targetname==""||conver.receiverids==""){
				continue;
			}else{
				converlen++;
				convers[""+i+""]=conver;
			}
		}
		if(converlen>0){
			var url=getPostUrl("/social/im/SocialIMOperation.jsp?operation=syncConvers&converlen="+converlen);
            if(IS_BASE_ON_OPENFIRE){
                url += '&IS_BASE_ON_OPENFIRE='+IS_BASE_ON_OPENFIRE;
            }
			$.post(url, 
			{"convers": JSON.stringify(convers)},
			function(data){
			});
		}
	},
	//删除指定会话
	removeThisConversation: function(targettype, targetid){
		//移出最近联系人列表
		client.removeConversation(targettype, targetid, function(targetid){			
			$('#recentListdiv').find('#conversation_' + targetid).remove();
			ChatUtil.delLocalConver(targetid,targettype);
			//关闭聊天窗口
			if(targetid.indexOf('_')>-1){
				targetid =  targetid.substring(0,targetid.indexOf("_"));
			}			
			var tabClostBtn=$('#chatTab_'+ targettype +'_' + targetid).find('.tabClostBtn');
			if(tabClostBtn.length>0){
				closeTabWin($('#chatTab_'+ targettype +'_' + targetid).find('.tabClostBtn'));
			}
			
		});
		
	},
	//关闭窗口
	closeConversation: function(targettype, targetid){
		updateTotalMsgCount(targetid,false,-1,0);
		$('#recentListdiv').find('#conversation_' + targetid).remove();
		//关闭聊天窗口
		//$('#chatTab_'+ targettype +'_' + targetid).find('.tabClostBtn').click();
		var tabClostBtn=$('#chatTab_'+ targettype +'_' + targetid).find('.tabClostBtn');
		if(tabClostBtn.length==1){
			closeTabWin(tabClostBtn);
		}
		$('.imDiscussSetting .dsCloseBtn').click();
		if(versionTag == 'rdeploy'){
			//移除掉聊天窗口
			removeIMChatpanel(targetid, targettype);
		}
	},
	//移出群通讯录
	delDiscussBook: function(discussid,callback){
		var url=getPostUrl('/social/im/SocialIMOperation.jsp?operation=addOrDelGroupBook&opt=del&discussid=' + discussid);
		$.post(url, function(){
			$('#discussListdiv').find('.groupItem[_targetid=\''+discussid+'\']').remove();
			typeof callback ==='function' && callback();
		});
	},
	//删除通讯录最近
	delRecent: function(discussid,targettype){
		var url=getPostUrl('/social/im/SocialIMOperation.jsp?operation=deleteRecent&targetid='+discussid+'&targettype='+targettype);
		$.post(url,function(){
		});
	},
	delLocalConver: function(discussid,targettype){
		var url=getPostUrl('/social/im/SocialIMOperation.jsp?operation=delLocalConver&targetid='+discussid+'&targettype='+targettype);
		$.post(url,function(){
		});
	},
	//置顶会话
	setThisConversationToTop: function(targettype, targetid, istop){
		if(!istop){		//非置顶状态
			client.setConversationToTop(targettype, targetid, function(targetid){
				var tempChatItem = $('#recentListdiv').find('#conversation_' + targetid).remove();
				$('#recentListdiv').prepend(tempChatItem);
				//取消置顶？
			});
		}else{
			//FIXME: 这里处理取消置顶
		}
	},
	//获取父窗的div
	getchatdiv: function(obj){
	  	var chatdiv=$(obj).parents(".chatdiv");
	  	if(chatdiv.length==0){
	  		client.writeLog("没有找到chatdiv");
	  	}	
	  	return chatdiv;
  	},
  	getCurChatwin: function(_win){
  		var bodyObj = (typeof _win == 'undefined')? document.body : _win.document.body;
  		var chatwin = $(bodyObj).find(".chatWin:visible");
  		return chatwin;
  	},
  	isWinActive: function(chatwinid, _win){
  		var curWin = ChatUtil.getCurChatwin(_win);
  		return curWin.attr("id") == chatwinid;
  	},
  	getchatwin: function(obj){
  		var $obj = $(obj);
  		var chatwin=$obj.parents(".chatWin");
	  	if(chatwin.length==0){
	  		if($obj.hasClass('chatWin')){
	  			return $obj;
	  		}
	  		client.writeLog("没有找到chatwin");
	  	}	
	  	return chatwin;
  	},
	//更新讨论组头像
	setGroupIcon:function(targetid,targettype,iconid){
		if(targettype==1){
			var conversationObj = $("#conversation_"+targetid);
			var chatTab = $('#chatTab_1_'+targetid);
			if(conversationObj.length>=1){
				var headurl = "/weaver/weaver.file.FileDownload?fileid="+iconid+"&time="+new Date().getTime();
				if(typeof iconid=='undefined' ||iconid==""){
					headurl="/social/images/head_group.png";
				}				
				conversationObj.attr("_targethead",headurl);
				conversationObj.find('img').attr('src',headurl);
			}
			if(chatTab.length>=1){
				chatTab.find('img').attr('src',headurl);
			}
			//更新群聊列表头像
			var treeObj = $.fn.zTree.getZTreeObj("discussTree");
			if(treeObj!=null){
				var treeNode  = treeObj.getNodeByParam('id',targetid,null);
				treeNode.icon =headurl;
				treeObj.updateNode(treeNode); 
			}
		}
	},
  	//处理通知类消息
  	handlePublicNotification: function(message) {
  		if(message && message.getObjectName() != 'RC:DizNtf'){
  			return;
  		}
  		var notificationType=message.getType();
        var notificationContent=message.getContent();
        var notificationOperator=message.getOperator();
        var notificationExtension=message.getExtension();
        var targetid = message.getTargetId();
        
        //被提出讨论组
        if(notificationType==4){
        	var resourceids=notificationExtension.split(",");
        	for(var i=0;i<resourceids.length;i++){
            	var resourceid=getRealUserId(resourceids[i]);
            	if(resourceid == M_USERID){  //自己被踢出
            		ChatUtil.closeConversation('1', targetid);
            		ChatUtil.delDiscussBook(targetid);	//删除通讯录
            		ChatUtil.delLocalConver(targetid,1); //删除本地会话记录
            		ChatUtil.cache.kickFlags[targetid+'_1'] = 1;
            	}
            }
        }
        
        // 解散群消息处理
         if(notificationType==5){
         	var targetname = $('#' + getConverId(1, targetid)).attr('_targetname');
         	if(targetname) {
         		alert('讨论组【' + targetname + '】已被解散');
         	}
        	ChatUtil.closeConversation('1', targetid);
    		ChatUtil.delDiscussBook(targetid);	//删除通讯录
    		ChatUtil.delLocalConver(targetid,1); //删除本地会话记录
    		ChatUtil.cache.kickFlags[targetid+'_1'] = 1;
        }
        
        ChatUtil.getDiscussionInfo(targetid,true,function(discussion){
        	
        	if(!discussion) return ;
        	
        	discussList[targetid]=discussion;
        	var targetname = discussion.getName();
        	var senderUserid=message.getSenderUserId(); //发送人id
        	var senderid=getRealUserId(senderUserid); //发送人id
			var senderInfo=getUserInfo(senderid);
			var senderName=senderInfo.userName;
        	var msgcontent=senderName+":"+getMsgContent(message);
        	var targetType=1; //0：单聊 1:群聊 -1：其他
        	var sendtime=message.getSentTime();
        	var receiverids=ChatUtil.getMemberids(targetType,targetid,true);
			if(M_USERID==senderid){
	        	var jsconverList = [{
					"targetid": targetid,
					"targettype": targetType,
					"msgcontent": msgcontent,
					"sendtime": sendtime,
					"targetname":targetname,
					"senderid":senderid,
					"receiverids":receiverids
				}];
				ChatUtil.syncConversToLocal(jsconverList);
			}
			
        	var creatorname = getUserInfo(getRealUserId(discussion.getCreatorId())).userName;
	        switch(notificationType){
		        case 3:  // 更改讨论组名称
		        	//refreshDiscussTitle(targetid);
		        	refreshDiscussName(discussion);
		        break;
				case 6:  //转移群组
				case 7:  //换群头像
		        case 4:  // 被移出讨论组
		        case 5:  // 解散讨论组 
		        case 1:  // 加入讨论组
		        case 2:  // 退出讨论组
		        	ChatUtil.refreshDiscussioinInfo(targetid, function(discuss){
		        		updateDiscussInfo(targetid);
		        		ChatUtil.setDisMemberInfo(discuss);
		        		//更新@列表
		        		ChatUtil.initIMAtwho(targetid);
		        	});
		        break;
	        }
			if(notificationType==7){
				ChatUtil.setGroupIcon(targetid,targetType,discussion.getIcon());
			}
        });
  	},
  	getNotifiContent:function(senderInfo,message){
  		
  			var senderName=senderInfo.userid==M_USERID ?"你":senderInfo.userName;
			
  			var notificationType=message.getType();
            var notificationContent=message.getContent();
            var notificationOperator=message.getOperator();
            var notificationExtension=message.getExtension();
            
            //client.writeLog("notificationExtension:"+notificationExtension);
            //client.writeLog("notificationType:"+notificationType);
            // 处理人员没有同步导致个别人员加群失败的情况
			var failedResourceids;
			var failedResourceNames = "";
			try{
				var detail = message.getDetail();
				if(detail && detail.failedExtension) {
					failedResourceids = IMUtil.niceSplit(detail.failedExtension, ",");
					for(var i=0; i<failedResourceids.length; i++){
						var realId = getRealUserId(failedResourceids[i]);
						failedResourceNames+=","+getUserInfo(realId).userName;
					}
				}
				failedResourceNames=failedResourceNames.length>0?failedResourceNames.substring(1):"";
			}catch(err){}

            var resourceids=IMUtil.niceSplit(notificationExtension, ",");
            var resourceNames="";
            if(notificationType==1||
				notificationType==2||
				notificationType==4||
				notificationType==6||
				notificationType==7){
	            for(var i=0;i<resourceids.length;i++){
	            	var resourceid=getRealUserId(resourceids[i]);
					if(M_USERID == resourceid){
						resourceNames+=",你";
					}else{
						resourceNames+=","+getUserInfo(resourceid).userName;
					}
	            	
	            }
            	resourceNames=resourceNames.length>0?resourceNames.substring(1):"";
            }
            var content="";
            if(notificationType==1){
            	if(resourceids.length>10)
            		resourceNames=resourceids.length+"人";
            	content=senderName+" 邀请 "+resourceNames+" 加入群";
            	if(failedResourceids && failedResourceids.length>0) {
					if(resourceids.length == 0)
						content=senderName;
					else
						content +=",";
					if(failedResourceids.length>10)
						content+=(" 邀请"+failedResourceids.length+" 人失败");
					else
						content+=(" 邀请"+failedResourceNames+" 失败");
				}
            }else if(notificationType==2){
            	content=resourceNames+" 退出群";
            }else if(notificationType==3){
            	content=senderName+" 修改群名称为 "+notificationExtension;
            }else if(notificationType==4){
            	content=resourceNames+" 被 "+senderName+" 请出了群";
            }else  if(notificationType==6){
				content=senderName+" 已将群主身份转让给 "+resourceNames;
			}else  if(notificationType==7){
				content=senderName+" 更改了群头像";
			}
            return content;
  	},
	//获取消息的div
	getChatRecorddiv : function(senderInfo,msgObj,recordType,msgType,message,chatdivid){
		
		var content=msgObj.content;
		var objectName=msgObj.objectName;
		var extra=msgObj.extra;
		var timestamp=msgObj.timestamp ? msgObj.timestamp : new Date().getTime();
		var detail=msgObj.detail;
		
        if(!senderInfo) {
            senderInfo = getUserInfo();
        }
        
		var senderName=senderInfo.userName;
		var senderHead=senderInfo.userHead;
		var senderid=senderInfo.userid;
		
		if (message && message.getObjectName() == 'RC:DizNtf') {
							
            content=this.getNotifiContent(senderInfo,message);
            var tempdiv=$("<div class='chatItemdiv chatNotice'><span>"+content+"</span></div>");
            if (!IS_BASE_ON_OPENFIRE && M_SDK_VER == '2' && message  && 'getMessageUId' in message) {
				var messageUId = message.getMessageUId();
				tempdiv.attr('messageUId', messageUId);
			}
            tempdiv.attr('timestamp', msgObj.timestamp);
            return tempdiv;
            
		}else if(objectName.toLowerCase().indexOf('rc:infontf:withdraw') != -1){
			if(chatdivid.indexOf("8_")==0){
				senderName = "对方";
			}
			content=social_i18n('WithdrawTip', (senderid == M_USERID? social_i18n('You') : senderName));
			var tempdiv=$("<div class='chatItemdiv chatNotice'><span>"+content+"</span></div>");
            tempdiv.attr('timestamp', msgObj.timestamp);
            return tempdiv;
		}else if(objectName.toLowerCase()==("rc:infontfvote")){
					try {
						if(typeof extra =="string")
							extra=eval("("+extra+")");
						}catch(e){
					}
					   if(extra.notiType=='noti_voteDeadline'){
						  	content="投票<a style='color:#018efb;cursor:pointer;word-break: break-all' onclick='docUtil.voteView(this,"+extra.shareid+",true)'>"+extra.sharetitle+"</a>即将截止";
							var tempdiv=$("<div class='chatItemdiv chatNotice'><span>"+content+"</span></div>");
							return tempdiv;
					   }
					   if(extra.notiType =="noti_vote"){
						   	content=(senderid == M_USERID? "你" : senderName)+"参与了投票<a style='word-break:break-all;color:#018efb;cursor:pointer;' onclick='docUtil.voteView(this,"+extra.shareid+",true)'>"+extra.content+"</a>";
							var tempdiv=$("<div class='chatItemdiv chatNotice'><span>"+content+"</span></div>");
							return tempdiv;
					   }
		}else{
			
			var messageid=timestamp, messageUId="";
			try{
				var extraObj=eval("("+extra+")");
				messageid=extraObj.msg_id?extraObj.msg_id:messageid;
			}catch(e){
				client.error("无效的messageid:"+messageid);
			}
			client.error("messageid:"+messageid);
			var tempdiv=$('#tempChatItem').clone().attr("id","").attr("id",messageid).show();
			tempdiv.attr('timestamp', msgObj.timestamp);
			if (!IS_BASE_ON_OPENFIRE && M_SDK_VER == '2' && message && 'getMessageUId' in message) {
				messageUId = message.getMessageUId();
				tempdiv.attr('messageUId', messageUId);
			}
			//密聊判断
			if(extraObj && extraObj.isPrivate == "1"){
				senderName = "";
				// if(senderid == M_USERID){
				// 	senderHead = "/social/images/private_right.png";
				// }else{
				// 	senderHead = "/social/images/private_left.png";
				// }
				tempdiv.find('.head35').removeAttr('onmousedown')
										.removeAttr('onmouseenter')
										.removeAttr('onmouseleave')
										.removeAttr('onclick').addClass('headblur');
			}
			tempdiv.attr("_targetid",senderid).attr("_targetName",senderName).attr("_targetHead",senderHead).attr("_targetType","0").attr("_senderid", senderid);
			if(IS_BASE_ON_OPENFIRE){
				content = content.replace(/\[.+?\]/g, function (x) {
					var ejObj = M_CORE.Expression.getEmojiObjByEnglishNameOrChineseName(x.slice(1, x.length - 1));
					if(ejObj && ejObj.img){
						return ejObj.img.outerHTML;
					}
					return x;
				});
			}
			if(message){
				var _tmpContent = getEmotionText(detail? (detail.content?detail.content:content): content);
				_tmpContent = IMUtil.htmlEncode(_tmpContent);
				_tmpContent = _tmpContent.replace(/\[.+?\]/g, function (x) {
					if(M_SDK_VER == 2){
						 var str = IMClient.RongIMEmoji.symbolToHTML(x);
						 try{
						 	return $(str).html() || str;
						 }catch(e){
						 	return str;
						 }
					}else{
						var ejObj = M_CORE.Expression.getEmojiObjByEnglishNameOrChineseName(x.slice(1, x.length - 1));
						if(ejObj && ejObj.img){
							return ejObj.img.outerHTML;
						}
					}
					return x;
				});
				_tmpContent = IMUtil.httpHtml(_tmpContent);//格式url
				tempdiv.find('.chatContent').html("<div>"+_tmpContent+"</div>");
			}else{
			 	var _noMessageContent = content.replace(/\r?\n/gi, '<br>');
			 	_noMessageContent = IMUtil.httpHtml(_noMessageContent);//格式url
			 	if(objectName == "RC:TxtMsg"){
			 		var retrivedText = initEmotion(_noMessageContent);
			 		var retrivedObj = $("<div>" + initEmotion(_noMessageContent) + "</div>");
			 		_noMessageContent = retrivedObj.html();
			 	}
				tempdiv.find('.chatContent').html("<div>"+_noMessageContent+"</div>");
			}
			
			tempdiv.find('.chatName').html(senderName); 	  //发送消息人姓名
			tempdiv.find('.userimage').attr("src",senderHead); //发送消息人头像
			if(recordType=="receive" || (recordType == "send" && 
				(objectName == 'RC:ImgMsg' || objectName == 'FW:attachmentMsg') || objectName == 'RC:TxtMsg')){
				if(recordType=="receive") {
					tempdiv.find(".chatRItem").removeClass("chatRItem").addClass("chatLItem");
				}
				FontUtils.clearFontSetStyle(tempdiv);
			}
			
			switch((msgType && msgType.value) || msgType){
				case 1://文本消息
					tempdiv.addClass("txtMsgTag");
					// 对系统广播消息进行特殊处理
                    if(senderid == 'SysNotice') {
                        var extraTmp=ChatUtil.getExtraObj(extra);
                        if(extraTmp.hasOwnProperty('senderid')) {
                            var realSenderid = extraTmp.senderid;
                            var realSender = getUserInfo(realSenderid);
                            var realSenderName = realSender.userName;
                            tempdiv.find('.chatName').html(realSenderName + ' 发来的系统广播');
                        }
                    }
                   // if(recordType=="receive"){
                    	var fontset = FontUtils.getMsgFontSet(msgObj);
						// 对方是默认颜色配置
						if(fontset.issetted == "true") {
							FontUtils.addFontSetStyle(tempdiv, {
								'fontsize': FontUtils.getConfig('fontsize'), 
								'bubblecolor': fontset.bubblecolor
							});
                        }else {
                        	var bctmp = fontset.bubblecolor;
                        	if(!bctmp){
                        		bctmp = FontUtils.getConfig('bubblecolor');
                        	}
                        	FontUtils.addFontSetStyle(tempdiv, {
								'fontsize': FontUtils.getConfig('fontsize'),
								'bubblecolor': bctmp
							});
                        }
                    //}
				break;
				case 2://图片消息
					tempdiv.find(".headtd").before(tempdiv.find(".chattd"));
					tempdiv.addClass("imgMsgTag");
					var imgId ="";
					var imgUrl="";
					if(message){
						imgId=message.getMessageId();
						imgUrl= message.getImageUri();
						if(!imgUrl){
							imgUrl = IM_Ext.getImgUrl(msgObj);
						}
					}else{
						imgId = new Date().getTime();
						//根据ios发的图片直接从msgObj取不到imgUrl的情况做得调整 0107 by wyw
						imgUrl=IM_Ext.getImgUrl(msgObj);
					}
					client.writeLog("imgUrl:"+imgUrl);
					//在没有自定义imgUrl且融云丢失了imageUri,<ToT>捕获异常处理,并以缩略图替换原图显示 0107 by wyw
					try{
						if(imgUrl.indexOf("/weaver/weaver.file.FileDownload?fileid=")==-1){
							imgUrl="/weaver/weaver.file.FileDownload?fileid="+imgUrl;
						}
					}catch(e){
						client.error("获取到的imgUrl是空 from getChatRecorddiv");
						imgUrl = "data:image/jpg;base64,"+content;
					}
					content='<img _imgId='+imgId+' _imageUrl='+imgUrl+' src="data:image/jpg;base64,'+content+'">';
					if(!ChatUtil.imgpool[chatdivid])
						ChatUtil.imgpool[chatdivid] = {};
					ChatUtil.imgpool[chatdivid][imgId] = imgUrl;
					tempdiv.find('.chatContent').html("<div class='chatcontentimg' onclick='ChatUtil.doChatImgClick(event, \""+imgUrl+"\");'>"+content+"</div>");
					
					var fontset = FontUtils.getMsgFontSet(msgObj);
					// 对方是默认颜色配置
					if(fontset.issetted == "true") {
						FontUtils.addFontSetStyle(tempdiv, fontset);
                    }
				break;
				case 8://位置消息
					tempdiv.find(".headtd").before(tempdiv.find(".chattd"));
					tempdiv.find('.chatContent').html("<div>"+content+"</div>");
				break;
				case 6://群公告,分享类消息,图文消息
					
					if(objectName=="FW:attachmentMsg"){ //附件
						tempdiv.addClass("accMsgTag");
						//var contents=content.split("|");
						var fileName=content;
						var extraObj;
						try{
							if(!extra) extra="";
							extraObj=eval("("+extra+")");
							
						}catch(e){
							if(content!=""){
								var contents=content.split("|");
								extra="{\"fileName\":\""+contents[0]+"\",\"fileid\":\""+contents[1]+"\",\"fileSize\":\""+contents[2]+"\"}";
								fileName=contents[0];
							}
							//alert("extra:"+extra);
							extraObj=eval("("+extra+")");
						}
						
						var fileId=extraObj.fileid;
						var fileSize=getSizeFormate(extraObj.fileSize);
						var fileType=extraObj.fileType;
						var filePath=extraObj.filePath;
						var fileIcon=getFileIcon(fileName);
						
						var accMsgdiv=$("#accMsgTemp").clone().removeAttr('id').show();
						accMsgdiv.find(".filename").html(fileName).attr("title",fileName);
						accMsgdiv.find(".filesize").html("("+fileSize+")");
						accMsgdiv.find(".accicon").css({"background-image":"url("+fileIcon+")"});
						accMsgdiv.find(".opdiv").attr("_fileId",fileId).attr("_fileName",fileName).attr("_fileSize", extraObj.fileSize);
						//绑定fileid 和filetype 1117by wyw
						if(!fileType) {
							fileType = getFileType(fileName);
						}
						accMsgdiv.attr("_fileid", fileId).attr("_filetype", fileType);
						
						if(from=='pc' && ( DownloadSet[fileId] || recordType=='send') ) {
							filePath = DownloadSet[fileId] || decodeURIComponent(filePath);
							accMsgdiv = FileDownloadViewUtils.setButtonCon(accMsgdiv, fileId, filePath, extraObj.fileSize);
						}
						
						if(recordType=="receive"){
							accMsgdiv.find(".sendok").hide();
							accMsgdiv.find(".acccomplete").hide();
						}
						tempdiv.find('.chatContent').html("").append(accMsgdiv);
						
						var fontset = FontUtils.getMsgFontSet(msgObj);
						// 对方是默认颜色配置
						if(fontset.issetted == "true") {
							FontUtils.addFontSetStyle(tempdiv, {'bubblecolor': fontset.bubblecolor})
	                    }
					}else if(objectName=="FW:CustomShareMsg" ||
							objectName.toLowerCase().indexOf('fw:infontf:cancelshare') != -1||
							objectName=="FW:CustomShareMsgVote"){ //分享文档或流程或者云盘取消
						//var contentObj=eval("("+content+")");
						var sharetitle = content;
						var extraObj = {};
						
						try{
							if(!extra) extra="";
							extraObj=eval("("+extra+")");
						}catch(e){
							extra=content;
							//extraObj=eval("("+extra+")");
							//sharetitle=extraObj.sharetitle;
						}
						var sharetype = extraObj.sharetype;
						var shareid = extraObj.shareid;  //文档id或流程id
						client.writeLog("message:" + message);
						client.writeLog("shareTitle:" + sharetitle + " shareType:" + sharetype + " shareId:" + shareid);
						var typedes = '',classname='';
						if('doc' == sharetype){
							typedes = '新闻/文档';
							classname = 'sharedoc';
						}
						else if('pdoc' == sharetype){
							typedes = "云盘文档";
							classname = 'sharedoc';
						}
						else if('folder' == sharetype){
							typedes = "云盘目录";
							classname = 'sharedoc';
						}
						else if('workflow' == sharetype){
							typedes = '流程';
							classname = 'sharewf';
						}else if('crm' == sharetype){
							typedes = "客户";
							classname = 'sharecrm';
						}else if('vote' == sharetype){
							typedes = "投票";
							classname = 'sharevote';
						}
						/*	
						tempdiv.find('.chatContent').html(
							"<div onclick='ChatUtil.openShareView(\'" + shareid + "\', \'"+sharetype+"\');'>" + typedes + "分享:"+sharetitle+"</div>");
						*/
						if("task" == sharetype){
							tempdiv.find('.chattd').addClass('chatTask');
							var taskid = shareid;
							var taskMsgItem=$("#taskMsgTemp").clone().attr("id","task_"+taskid).show();
							taskMsgItem.attr("_shareid", shareid).attr("_sharetype", sharetype).attr("_senderid", senderid);
							tempdiv.find('.chatContent').html("").append(taskMsgItem);
							
							ChatUtil.setTaskState(taskMsgItem, taskid, content, true, "");
						}else if("vote" == sharetype){
							var voteMsgItem=$("#voteMsgTemp").clone().attr("id","").show();
							voteMsgItem.find(".voteMsgTitle").html(typedes).addClass(classname);
							var url = extraObj.iconid>0?"/weaver/weaver.file.FileDownload?fileid="+extraObj.iconid:'/voting/groupchatvote/images/themedefaultimage.png';
							voteMsgItem.find(".voteImg").attr("src",url);
							voteMsgItem.find(".voteDetail").html(sharetitle);
							voteMsgItem.find(".voteDetail").attr('title',sharetitle);
							voteMsgItem.find(".voteMsgDeadline").html("截止时间:"+extraObj.voteDeadline);
							voteMsgItem.find(".opdiv").attr("_shareid",shareid).attr("_sharetype",sharetype).attr("_senderid",senderid);							
							tempdiv.find('.chattd').addClass('chatVote');
							tempdiv.find('.chatContent').html("").append(voteMsgItem);
						}else{
							var shareMsgItem=$("#shareMsgTemp").clone().attr("id","").show();
							shareMsgItem.find(".shareTitle").html(typedes).addClass(classname);
							//去掉title, 1117bywyw   【.attr("title",sharetitle)】
							shareMsgItem.find(".shareContent").html(sharetitle);
							shareMsgItem.find(".opdiv").attr("_shareid",shareid).attr("_sharetype",sharetype).attr("_senderid",senderid);
							if(objectName.toLowerCase().indexOf('fw:infontf:cancelshare') != -1){
								shareMsgItem.find(".shareDetail").removeAttr("onclick");
								//添加取消分享属性用于判断是否被取消分享cancelshare
								shareMsgItem.find(".opdiv").attr("_cancelshare","cancelshare");
								var _shareDetailcontent = senderid == M_USERID? "已取消分享" : "分享已取消";
								shareMsgItem.find(".shareDetail").html("").append("<span style='color:red;'>"+_shareDetailcontent+"</span>");
							}
							client.error("tempdiv:"+tempdiv.length);
							tempdiv.find('.chattd').addClass('chatShare');
							tempdiv.find('.chatContent').html("").append(shareMsgItem);
						}
					}else if(objectName=="FW:PersonCardMsg"){ //名片
						
						var hrmid;
						try{
							if(!extra) extra="";
							extraObj=eval("("+extra+")");
							hrmid=extraObj.hrmCardid;
						}catch(e){
							hrmid=content;
						}

						var hrmName=userInfos[hrmid].userName;
						var hrmHead=userInfos[hrmid].userHead;
						var jobtitle=userInfos[hrmid].jobtitle;
						
						if(objectName=="FW:PersonCardMsg"){
							if(recordType=="receive"){
								tempdiv.find(".chatArrow").html("<");
							}else{
								tempdiv.find(".chatArrow").html(">");
							}
						}
						tempdiv.find('.chattd').addClass('chatCard');
						tempdiv.find('.chatContent').html("").append(
							"<div>名片</div>"+
							"<div class='chatCardInfo' _targetid='"+hrmid+"' _targetname='"+hrmName+"' _targethead='"+hrmHead+
							"'_targettype='0' ><div class='left' onclick=\"showConverChatpanel($(this).parents(\'.chatCardInfo\'))\"><img src='"+hrmHead+"' class='head35 userimage'></div>" +
								"<div class='left' style='margin-left:10px;'>"+
									"<div class='hrmName' onclick='ChatUtil.cardOpenHrm("+hrmid+")'>"+hrmName+"</div>" +
									"<div>"+jobtitle+"</div>" +
								"</div>" +
								"<div class='clear'></div>" +
							"</div>"
						);
						//tempdiv.find('.chatContent').html("").append(userInfos[content].userName);	
					}else if(objectName=="FW:richTextMsg"){  //图文
						try{
							if(!extra) extra="";
								extraObj=eval("("+extra+")");
							
						}catch(e){
							extraObj = {};
						}
						var tempTextImg = $("#tempTextImg").clone().removeAttr("id").show();
						var imgbase64 = extraObj.image;
						var imguri = IMUtil.getImgUri(imgbase64, extraObj.imageurl);
						var url = extraObj.url;
						ChatUtil.getImgDiv(imguri, function(imgdiv){
							tempTextImg.find(".imgcot").html("").append(imgdiv);
						});
						tempTextImg.find(".textcot").html(content);
						tempdiv.find('.chatContent').html("").append(tempTextImg);
						//tempdiv.find('.chattd').addClass('chatShare');
						tempTextImg.attr("onclick", "IMUtil.doOpenLink('"+url+"', '_blank');");
					}else if(objectName=="RC:PublicNoticeMsg"){ //公告
						content=ChatUtil.receiveMsgFormate(content);
						var $content = $("<div>"+IMUtil.htmlEncode(content)+"</div>");
						tempdiv.find('.chatContent').empty().append($content);
						tempdiv.find('.chattd').addClass('chatNote');
						
						var noteid;
						try{
							if(!extra) extra="";
							extraObj=eval("("+extra+")");
							noteid=extraObj.noteId;
						}catch(e){
							noteid="";
						}
						tempdiv.attr('noteId', noteid);
						tempdiv.find('.chatContent').append(
							"<div class='chatnoteMark'>" +
								"<div class='noteJLink' onclick='DiscussUtil.jumpToTab(this, \"noteList\");'>群公告</div>" +
							"</div>");
					}
                    else if(objectName == "FW:CustomMsg") {  // 自定义消息
                        var customObj = getFwCustomMsgContent(senderInfo.userid, content, extra);
                        if(customObj.pushType == 'weaver_shakeMsg') {
                            tempdiv = $("<div class='chatItemdiv chatNotice'><span>" + customObj.content + "</span></div>");
                        }
                        else {
                            tempdiv = $("<div class='chatItemdiv chatNotice'><span>未知自定义类型</span></div>");
                        }
                    }else if(objectName == "FW:Extension_Msg"){
                        var tempdiv=$("<div class='chatItemdiv chatNotice'><span>收到红包 , 请在手机上查看</span></div>");
                        if(senderid == M_USERID) {
                        	tempdiv = $("<div class='chatItemdiv chatNotice'><span>发出红包 , 请在手机上查看</span></div>");
						}
                        return tempdiv;
					}
                    else {
						var tempdiv=$("<div class='chatItemdiv chatNotice'><span>该版本暂不支持此消息</span></div>");
			            return tempdiv;
					}
				break;
				case 3://语音
					var messageId = new Date().getTime();
					var duration = 0;
					if(message){
						duration = message.getDuration();
						if(typeof duration == 'undefined') {
							try{
								duration = JSON.parse(message.getDetail().detail).duration;
							}catch(err){}
						}
					}else{
						duration = msgObj.detail.duration;
					}
					if(typeof duration == 'undefined') {
						try{
							if(typeof msgObj.detail == 'object') {
								duration = msgObj.detail.duration?msgObj.detail.duration:msgObj.detail.detail.duration;
							}else{
								try{
									duration = JSON.parse(msgObj.detail).duration;
								}catch(er){
									duration = 1;
								}
							}
							
						}catch(err){
							duration = 1;
						}
					}
					if(message)
						messageId = message.getMessageId();
					ChatUtil.voicepool[messageId] = content;
					ChatUtil.voicepool.push(content);
					var index = ChatUtil.voicepool.length - 1;
					var src = "";
					var lefts = tempdiv.find(".chatLItem");
					var isLefts = lefts.length && lefts.length > 0;
					if(isLefts)
						src = "/social/images/chat_voice_l_wev8.png";
					else
						src = "/social/images/chat_voice_r_wev8.png";
					tempdiv.find('.chatContent').html("<div id='voice_"+messageId+"' class='chatVoice' " +
							"ondblclick='return false;' onclick='ChatUtil.playVoice(" +
							"this,\"" + messageId + "\", " + 
							lefts.length + ", " + 
							duration + ");' isLefts='"+isLefts+"'></div>");
					tempdiv.find('.chatVoice').append("<img src='" + src + "' />");
					//拼接时长
					tempdiv.find('.chatContent').after("<div class='chatVoiceTime'>" + duration + "\'\'</div>");
					setTimeout(function(){
						IMClient.RongIMVoice.preLoaded(content);
					}, 500);
					if ('detail' in msgObj) {
						if(!msgObj.detail) {
							msgObj.detail = new Object();
						}
						msgObj.detail.duration = duration;
					}
				break;
			}
			
			// 取消非文本消息的字体样式
			if(!tempdiv.hasClass('txtMsgTag') && objectName !== 'RC:ImgMsg' && objectName !== 'FW:attachmentMsg'){
				FontUtils.clearFontSetStyle(tempdiv);
			}
			
			//绑定消息体对象
			msgObj['msgType'] = (msgType && msgType.value) || msgType;
			tempdiv.data("recordType", recordType);
			tempdiv.data("msgObj", msgObj);
			return tempdiv;
		}
	},
	//聊天窗口图片点击处理
	doChatImgClick: function(e, imgurl){
		if(typeof from != 'undefined' && from == 'pc'){
			var handlers = {
				afterClose: function(){
					DragUtils.restoreDrags();
				},
				beforeOpen: function(){
					DragUtils.closeDrags();
				}
			};
			IMCarousel.showImgScanner(e, true, imgurl, handlers);
		}else{
			IMCarousel.showImgScanner(e, true, imgurl);
		}
		
	},
	//设置任务完成状态
	setTaskState: function(taskMsgItem, taskid, title, force, msgid){
		var taskContent = taskMsgItem.find(".taskMsgContent");
		var taskCreator = taskContent.find(".taskCreator");
		var taskCreatime = taskContent.find(".taskCreatime");
		var taskMsgDetail = taskMsgItem.find(".taskMsgDetail");
		var taskTitle = taskContent.find(".taskTitle");
		taskTitle.html(
			"任务标题 : "+
			"<a onclick='ChatUtil.showTaskDetails(\""+taskid+"\", this);' href='javascript:void(0);'>"+
			IMUtil.cleanBR(title)+
			"</a>"
		);
		taskCreator.html("创建人 : ");
		taskCreatime.html("创建时间 : ");
		if(!!msgid)
			var msgtag = localmsgtags[msgid];
		if(msgtag && !force){
			var resinfo = msgtag.resinfo;
			var deleted = resinfo.deleted;
			var creater = resinfo.creater;
			var createdate = resinfo.createdate;
			var creatorid = resinfo.createrID;
			var principalid = resinfo.principalid;
			var status = resinfo.status;
			taskCreator.html(taskCreator.html()+creater);
			taskCreatime.html(taskCreatime.html()+createdate);
			//如果任务被删除，显示'该任务已删除'
			if(deleted == '1'){
				ChatUtil._taskStateCallback(CONST.taskStatus.DELETE, taskMsgItem);
			}
			//判断任务的状态，如果是‘已完成’，显示‘已完成’提示
			else if(status == CONST.taskStatus.COMPLETE){
				ChatUtil._taskStateCallback(status, taskMsgItem);
			}
			//如果认为未完成且当前登录者有操作权限时显示“完成”按扭
			else if((M_USERID == creatorid || M_USERID == principalid) 
				&& status == CONST.taskStatus.UNCOMPLETE){
				ChatUtil._taskStateCallback(status, taskMsgItem);
			}
			//移除操作区域
			else{
				taskMsgItem.find(".taskMsgDetail").remove();
				taskMsgItem.find(".taskMsgContent").css({
					"borderBottom": 'none',
					"paddingBottom": '0'
				});
			}
		}else{
			//判断任务状态
			ChatUtil.isTaskDeleted(taskid, function(isDelete){
				if(isDelete.ifDelete){
					ChatUtil._taskStateCallback(CONST.taskStatus.DELETE, taskMsgItem);
				}else{
					ChatUtil.isTaskCompleted(taskid, function(isCompleted){
						var taskCode = CONST.taskStatus.UNCOMPLETE;
						if(isCompleted.isComplete){
							ChatUtil.cache.completedTasks.push(taskid);
							taskCode = CONST.taskStatus.COMPLETE;
						}else taskCode = CONST.taskStatus.UNCOMPLETE;
						ChatUtil._taskStateCallback(taskCode, taskMsgItem);
					});
				}
			});
			//获取任务相关信息
			ChatUtil.getTaskInfo(taskid, function(info){
				var taskinfo = info;
				taskCreator.html("创建人 : "+ (taskinfo.creator=="null"?"":taskinfo.creator));
				taskCreatime.html("创建时间 : "+ (taskinfo.createdate=="null"?"":taskinfo.createdate));
				var principalid = taskinfo.principalid;
				var creatorid = taskinfo.creatorid;
				var status = taskinfo.status;
				//当前操作者无操作权限
				if(M_USERID != creatorid && M_USERID != principalid && status == CONST.taskStatus.UNCOMPLETE){
					taskMsgDetail.remove();
					taskContent.css({
						"borderBottom": 'none',
						"paddingBottom": '0'
					});
				}
			});
		}
	},
	//获取富文本图片
	getImgDiv: function(imguri, callback){
		var $img = $("<img src='"+imguri+"' style='max-width:45px;max-height:45px;'/>&nbsp;");
		var defaultImgUri = "/social/images/link_default_wev8.png";
		$img[0].onload = function(){
			callback($img);
		}
		$img[0].onerror = function(){
			$img.attr('src', defaultImgUri);
			callback($("<div class='defLinkWrap'></div>").append($img));
		}
		
	},
	//完成任务
	completeTask: function(obj) {
		var taskid = $(obj).parents(".taskMsgItem").attr("id").substring(5);
		$.post("/mobile/plugin/social/SocialMobileOperation.jsp?operation=completeTask&taskid="+taskid, function(resval){
			var resjs = $.trim(resval);
			if(resjs != ""){
				resjs = $.parseJSON(resjs);
			}else resjs = {};
			if(resjs.isSuccess){
				$(obj).removeClass("taskComplete").
		  			addClass("taskCompleted").html("已完成").removeAttr("onclick");
			}else{
				client.error(resjs.error?resjs.error:"任务完成接口发生错误！");
			}
		})
	},
	//判断任务是否完成
	isTaskCompleted: function(taskid, _callback){
		$.post("/mobile/plugin/social/SocialMobileOperation.jsp?operation=istaskcomplete&taskid="+taskid, function(tag){
			_callback(tag);
		},'json');
	},
	//判断任务是否删除
	isTaskDeleted: function(taskid, _callback){
		$.post("/mobile/plugin/social/SocialMobileOperation.jsp?operation=istaskdeleted&taskid="+taskid, function(tag){
			_callback(tag);
		},'json');
	},
	//获取任务信息
	getTaskInfo: function(taskid, _callback){
		$.post("/mobile/plugin/social/SocialMobileOperation.jsp?operation=gettaskinfo&taskid="+taskid, function(info){
			_callback(info);
		},'json');
	},
	//获取必达信息
	getDingInfo: function(dingid, _callback){
		$.post("/rdeploy/bing/BingOperation.jsp?operation=getdinginfo&dingid="+dingid, function(info){
			_callback(info);
		},'json');
	},
	//打开我的收藏
	goMyFavourate: function(){
	if(ChatUtil.isFromPc()&&WindowDepartUtil.isAllowWinDepart()&&WindowDepartUtil.tabIsNull()){
	    var args = {
           title : social_i18n('Favourite'),
           width : 680,
           height : 565
        };
        WindowDepartUtil.openNewWindow(args,WindowDepartUtil.NewWindowList.IMMyFavs);
    }else{
		var title=social_i18n('Favourite');
		var loginuserid = M_USERID;
	        var url=getPostUrl("/social/im/SocialIMMyFavs.jsp?");
		var diag=getSocialDialog(title,657,565);
		diag.URL =url;
		diag.openerWin = window;
		diag.show();
		ChatUtil.cache.dialog = diag;
		document.body.click();
	}
	},
	//打开必达
	goBing: function(){
		showIMChatpanel(3,'bing',social_i18n('Bing'),'/social/images/bing_head.png');
	},
	//打开密聊
	goPrivate: function(){
		showIMChatpanel(7,'private',social_i18n('PrivateChat'),'/social/images/private_head.png');
	},
	//打开分享的视图
	openShareView: function(shareId, shareType) {
		client.writeLog("分享的id:" + shareId);
		var url = IMUtil.getShareUrl(shareId, shareType);
		client.writeLog("要打开的url:" + url);
	},
	goSysBroadcast: function(){
        showIMChatpanel(4,'SysNotice',social_i18n('BroadCast'),'/social/images/sysnotice_head.png');
    },
	//获取历史消息
	getHistoryMessages: function(targetType,realTargetid,pagesize,isFirst) {
			
			client.writeLog("------加载历史记录------");
			client.getHistoryMessages(targetType,realTargetid,pagesize,function(symbol,HistoryMessages,isSuccess, error){
					client.writeLog("==历史消息记录回调==")
				    client.error("symbol:"+symbol+" HistoryMessages:"+HistoryMessages);
				    // 记录客户端本地日志 开始
				    /*
				    if(ChatUtil.isFromPc() && HistoryMessages) {
				    	PcMainUtils.log("--------记录最近10条历史记录-----targetid----"+realTargetid);
				    	var cnt = 0;
				    	for (var i = HistoryMessages.length-1; i >=0; i--) {
				    		var imMessage=HistoryMessages[i];
				    		if(imMessage) {
				    			
				    			PcMainUtils.log(("toJSONString" in imMessage) ? imMessage.toJSONString() : JSON.stringify(imMessage));
				    		}else{
				    			PcMainUtils.log("message 对象为空");
				    		}
				    		
				    		cnt++;
				    		if(cnt > 9) {
				    			break;
				    		}
				    	}
				    }
				    */
				    // 记录客户端本地日志 结束
					if(!isSuccess&&!HistoryMessages){
						$('.dataLoading, .loading1').fadeOut(); //去除loading提示
						ChatUtil.postFloatNotice(social_i18n('FloatNotice4'));
						//可能是由于网络原因导致历史消息加载失败，这里先记录需要重试的标记 0421 wyw
						$("#chatWin_"+targetType+"_"+realTargetid).attr("errorTag", "history-load-failed");
						return;
					}
		  			client.writeLog("HistoryMessages:"+HistoryMessages.length);
		  			
		  			var chatWinid="chatWin_"+targetType+"_"+realTargetid;
		  			var chatListdiv=$("#"+chatWinid+" .chatList");
		  			var isFinish = chatListdiv.attr("_isFinish");
		  			var isNextNone = HistoryMessages.length==0||HistoryMessages.length<pagesize;
		  			chatListdiv.attr("_isHasNext",isNextNone?"0":"1");
		  			
		  			var recordCount=0;
		  			var messageArray=$(chatListdiv).data("messageArray");
		  			if(!messageArray||messageArray==null) messageArray=new Array();

		  			var preMessageid="";
		  			for (var i = HistoryMessages.length-1; i >=0; i--) {
		  				
		  				var imMessage=HistoryMessages[i];
		  				var messageid="";
		  				//有时候会有空消息，暂作过滤，原因未知 1106 by wyw
		  				if(imMessage == null || imMessage == undefined){
		  					continue;
		  				}
						var objName = imMessage.getObjectName(); //消息标识
						var extra=imMessage.getExtra();
						try{
							var extraObj=eval("("+extra+")");
							messageid=extraObj.msg_id;
						}catch(e){
							messageid=IMUtil.guid();
						}
						//自己发送给自己只保留一条记录
						if(messageid==preMessageid){
							continue;
						}else{
							preMessageid=messageid;
						}
						
						//client.writeLog("------消息记录-------"+i);
						
						var date = new Date();
						date.setTime(imMessage.getSentTime());
						var sendtime=date.pattern("yyyy-MM-dd HH:mm:ss");

						client.writeLog("messageid:"+messageid+"objName:"+objName+" sendtime:"+sendtime);
						
						if(objName=="FW:CountMsg"){
							continue;
						}
						if(objName=="FW:ClearUnreadCount"){
							continue;
						}
						// 把撤销消息，放到缓存里
						if(objName=="RC:InfoNtf" || objName=="FW:InfoNtf") {
							if(HandleInfoNtfMsg.setCache(imMessage))
							       continue;
						}
						
						recordCount++;
						messageArray.push(imMessage);
		  				
		  			}
		  			var historyCount=chatListdiv.attr("_historyCount");
		  			historyCount=historyCount==undefined?0:historyCount;
		  			historyCount=Number(historyCount)+recordCount;
		  			
		  			client.writeLog("recordCount:"+recordCount+" historyCount:"+historyCount);
		  			
		  			if(historyCount<10&&HistoryMessages.length>0){
		  				
		  				ChatUtil.getHistoryMessages(targetType,realTargetid,pagesize,isFirst);
		  				chatListdiv.attr("_historyCount",historyCount);
		  				
		  				$(chatListdiv).data("messageArray",messageArray);
		  			}else{
		  				
		  				var messageLength=messageArray.length;
		  				var messageids=new Array();
		  				var accfileids=new Array();
		  				for (var i = 0; i<messageArray.length; i++) {
			  				var imMessage=messageArray[i];
			  				
			  				var messageid=imMessage.getMessageId();
			  				var senderUserid=imMessage.getSenderUserId(); //发送人id
							var targetid=imMessage.getTargetId(); //消息来源对象id
							var content=getFormteMsgContent(imMessage); //消息内容
							if(M_SDK_VER!=undefined&&M_SDK_VER==2){
								var reg=new RegExp("₠","g"); //创建正则RegExp对象 
								if(content!=undefined){
									content= content.replace(reg,"&nbsp;"); 
									imMessage.content.content = content;
									imMessage.setContent(content);
								}							
							}
							var msgType=imMessage.getMessageType();
							var conversationType=imMessage.getConversationType(); //会话类型
							var sendtime=imMessage.getSentTime(); //消息发送时间
							var objName = imMessage.getObjectName(); //消息标识
							var messageTag=imMessage.getMessageTag()
							var extra=imMessage.getExtra();
							var detail=imMessage.getDetail();
							
							client.writeLog("------消息记录-------"+i);
							
							client.writeLog("messageid:"+messageid);
							client.writeLog("senderUserid:"+senderUserid);
							client.writeLog("targetid:"+targetid);
							client.writeLog("content:"+content);
							client.writeLog("conversationType:"+conversationType);
							client.writeLog("objName:"+objName);
							client.writeLog("messageTag:"+messageTag);
							client.writeLog("extra:"+extra);
							client.writeLog("detail:"+detail);
							
							//过滤消息统计和必达消息 1120 by wyw
							if(objName=="FW:CountMsg" && objName=="FW:CMDMsg" && objName=="FW:ClearUnreadCount"){
								continue;
							}
							
							var senderid=getRealUserId(senderUserid); //发送人id
							var senderInfo=getUserInfo(senderid);
							var senderName=senderInfo.userName;
							var senderHead=senderInfo.userHead;
							
							var recordType=senderid==M_USERID?"send":"receive";
							
							var msgObj={"content":content,"objectName":objName,"extra":extra,"detail":detail};
							
							var extraObj=ChatUtil.getExtraObj(extra);
							var messageid=extraObj.msg_id;
							
							if($("#"+messageid).length>0){
								continue;
							}
							
							var chatdivid = ChatUtil.getchatdiv(chatListdiv[0]);
							chatdivid = chatdivid.attr('id').substring(8);
							
							
							//判断这条消息id是否已撤销
							if(HandleInfoNtfMsg.isMsgWithdrawed(imMessage)){
								msgObj.objectName = 'RC:InfoNtf:withdraw';
							}
							//判断这条消息id是否已取消云盘分享
							if(HandleInfoNtfMsg.isMsgCancelShared(imMessage)){
								msgObj.objectName = 'FW:InfoNtf:cancelShare';
							}
							
							// 公有云还有一个messageUId，由于公有云的群通知会重复推送，暂时通过这个属性进行去重
							if (!IS_BASE_ON_OPENFIRE && M_SDK_VER == '2' && imMessage  &&  'getMessageUId' in imMessage) {
								var messageUId = imMessage.getMessageUId();
								if($("#chatdiv_"+chatdivid).find(".chatItemdiv[messageUId='"+messageUId+"']").length > 0) {
									continue;
								}
							}
			  				var tempdiv=ChatUtil.getChatRecorddiv(senderInfo,msgObj,recordType, msgType, imMessage, chatdivid);
							chatListdiv.prepend(tempdiv);
							
							//根据消息体时间更新会话副标题
							if(i==0) {
								var converTempdiv=$("#"+ getConverId(targetType,realTargetid));
								var lastUpdatetime =converTempdiv.attr('_sendtime');
								try{
									lastUpdatetime = Number(lastUpdatetime);
								}catch(err){
									lastUpdatetime = sendtime;
								}
								if(sendtime > lastUpdatetime){
									updateLatestMessage(realTargetid, targetType, imMessage);
								}
							}
							
							var isLast=false;
							if(i==messageLength-1) isLast=true;
			  				addSendtime(chatListdiv,tempdiv,sendtime,"history",isLast);
		  					
			  				//获取消息阅读状态
			  				if(recordType=="send"){
								var receiverids=extraObj.receiverids;
								if(messageid!=""&&receiverids!=""){
									ChatUtil.getMsgUnreadCount(targetType,messageid,receiverids,realTargetid);
								}
							}else{
								//再次发送阅读确认消息
								if(messageid!="" && senderid != 'SysNotice'){
									client.error("发送阅读count消息 toid:"+senderid+" msgid:"+messageid);
									if(!CountidsUtil.checkSendCountMsg(realTargetid,messageid) && !ChatUtil.isDisableMsgRead(targetid,targetType)){
                                        countMsgidsArray.push({"toid":senderid,"msgid":messageid,"msgFrom":"web"});
                                        ChatUtil.savaCountMsg(messageid,senderid,targetType,'send',M_USERID);
									}
								}
							}

							if(targetType == 8){
								PrivateUtil.calculationSeconds(imMessage,messageid);
							}

							//云盘消息处理
							if(objName =="FW:CustomShareMsg"&&( extraObj.sharetype =="folder" ||extraObj.sharetype =="pdoc")){								
								HandleInfoNtfMsg.checkShareDiskMsg(messageid);
							}
							//获取消息类型标记[注：先放到缓存队列里]
							if(!!messageid && msgType == 1)
								messageids.push(messageid);
							if(!!messageid && objName=="FW:attachmentMsg"){
								if(extraObj.fileid){
									accfileids[extraObj.fileid] = messageid;
								}
							}
							//缓存消息id
							if(!!messageid)
								if(senderid!=M_USERID){
									CountidsUtil.setMsgidToCIdsCaChe(realTargetid,messageid,false);
									CountidsUtil.setMsgidToRIdsCache(realTargetid,extraObj.countids,targetType);
								}else{
									CountidsUtil.setMsgidToSIdsCaChe(realTargetid,extraObj.countids,targetType);
								}
		  				}
		  				
		  				$(chatListdiv).data("messageArray",null);
		  				chatListdiv.attr("_historyCount",0);
		  				
			  			if(isFirst){
			  				initScrollBar(targetType,realTargetid,pagesize); //初始化自动记载滚动条
			  				//ChatUtil.postFloatNotice("正常加载结束", "error");
			  				$('.dataLoading, .loading1').fadeOut(); //去除loading提示
			  				scrollTOBottom(chatListdiv);
			  			}else{
			  				var topItem = chatListdiv.data('topanchor');
			  				chatListdiv.scrollTop(topItem.length>0?topItem.position().top: 200);
			  			}	
			  			chatListdiv.attr("_isFinish","1"); //设置为加载完成状态
			  			//获取窗口顶部元素
		  				var topItem = chatListdiv.find('.chatItemdiv').first();
		  				chatListdiv.data('topanchor', topItem);
		  				//获取消息类型标记
		  				ChatUtil.getMsgTags(messageids.join(','));
		  				if(!isNextNone){
		  					chatListdiv.find('.loadmorediv').show();
		  				}else{
		  					chatListdiv.find('.loadmorediv').hide();
		  				}
			  		}
		  	}, isFirst);
	},
	//获取消息类型标记
	getMsgTags: function(msgids){
		if(msgids == '' || msgids == undefined)
			return;
		//试着取本地缓存
		var msgidary = msgids.split(',');
		if(localmsgtags){
			var tempidary = [];
			for(var i = 0; i < msgidary.length; ++i){
				var mid = msgidary[i];
				var localmsgtag = localmsgtags[mid];
				if(localmsgtag){
				  	var tag = localmsgtag.tag;
				  	var shareid = localmsgtag.shareid;
				  	IM_Ext.doChangeStyleByTag(tag, shareid, mid);
				}else{
					tempidary.push(mid);
				}
			}
			msgidary = tempidary;
		}
		if(msgidary.length == 0)
			return;
		ChatUtil._getMsgTags(msgidary);
	},
	//获取消息标记
	_getMsgTags: function(msgidary){
		var url=getPostUrl("/social/im/SocialIMOperation.jsp?operation=getMsgTags&msgids="+msgidary.join(','));
		$.post(url, function(msgtags){
			if(msgtags && msgtags.length > 0){
				$.each(msgtags, function(i, msgtag){
				  var msgid = msgtag.msgid;
				  var tag = msgtag.tag;
				  var shareid = msgtag.shareid;
				  //本地缓存
				  localmsgtags[msgid] = msgtag;
				  client.log("msgid:"+msgid,"msgtag:"+msgtag);
				  IM_Ext.doChangeStyleByTag(tag, shareid, msgid);
				});
			}
		},'json');
	},
	//确认必达
	comfirmDing: function(obj){
		var dingid = $(obj).parents(".dingMsgItem").attr("_dingid");
		IM_Ext.confirmDing(obj, dingid);
	},
	//是否禁用阅读转台 --手机同步的消息，在没有打开的情况，过滤不了，后面改成回调。
    isDisableMsgRead : function (targetId,targetType) {
    	var flag = false;
    	if(IS_BASE_ON_OPENFIRE && targetType == "1" && targetId){
            var discuss=discussList[targetId];
            if(discuss){
				if(discuss.isDisableMsgRead && discuss.isDisableMsgRead()){
					flag = true;
				}
			}else {
                client.getDiscussion(targetId,function(discuss){
                    if(discuss){
                        discussList[targetId]=discuss;
                    }
                });
			}
		}
    	return flag;
    },
    // 初始化消息阅读状态
    
	initMsgRead:function(msgid,targetType,resourceids,flag,targetId){
		if(ClientSet.ifForbitReadstate == '1' || ChatUtil.isDisableMsgRead(targetId,targetType)) return;
		if(resourceids!=M_USERID&&msgid!=""&&resourceids!=""){ //当前用户自己发送给自己的消息不统计未读
			var unreadCount=resourceids.split(",").length;
			var url=getPostUrl("/social/im/SocialIMOperation.jsp?operation=initMsgRead");
			$.post(url,{"msgid":msgid,"resourceids":resourceids},function(data){
				client.log("消息阅读状态初始化成功");
				var msgObj=data;
				var mssageid=msgObj.messageid;
				var count=Number(msgObj.count);
				client.log("mssageid:"+mssageid+" resourceids:"+resourceids+" unreadCount:"+count);
				if(flag){
					ChatUtil.updateMsgUnreadCountHtml(mssageid,targetType,count);
				}
			},"json");
		}
	},
    //获取未读数 拉取历史消息用到
	getMsgUnreadCount:function(targetType,messageids,receiverids,targetId){
		if(ClientSet.ifForbitReadstate == '1') return;
		if(targetType==0&&CountidsUtil.checkMsgRead(targetId,messageids)){
			ChatUtil.updateMsgUnreadCountHtml(messageids,targetType,0);
		}else if(!ChatUtil.isDisableMsgRead(targetId,targetType)){
			client.error("messageids:"+messageids+" receiverids:"+receiverids+" receiverids:"+(typeof receiverids));
			if(messageids==""||receiverids==undefined) return;
			var url=getPostUrl("/social/im/SocialIMOperation.jsp?operation=getMsgUnreadCount");
			$.post(url,{"messageids":messageids,"receiverids":receiverids},function(data){
				var msgObj=data;
				var mssageid=msgObj.messageid;
				var count=Number(msgObj.count);
				ChatUtil.updateMsgUnreadCountHtml(mssageid,targetType,count);
				if(targetType == 0 && count==0){
					CountidsUtil.setMsgidToRIdsCache(targetId,mssageid,targetType);
				}
			},"json");
		}
	},
	updateMsgUnreadCountHtml:function(messageid,targetType,count){
		var chatitem = $("#"+messageid);
		var unreadCountdiv=chatitem.find(".msgUnreadCount");
		var chatContentdiv=chatitem.find(".chatContentdiv");
		var chatWin=unreadCountdiv.parents(".chatWin:first");
		var targetType=chatWin.attr("_targetType");
		var targetid=chatWin.attr("_targetid");
		client.log("targetType:"+targetType+" targetid:"+targetid);
        
        if(targetid == 'SysNotice') { //系统广播时不显示阅读状态
            return;
        }
        
		if(targetid==M_USERID){//聊天对象为自身的时候不更新阅读状态
			return ;
		}
		if(chatitem.find(".chatRItem").length==0){ //聊天记录不属于当前人，不显示阅读状态，显示在右边的属于当前人
			return ;
		}
		var countstr="";
		if(count>0){
			if(targetType=="0"||targetType == "8"){
				countstr=social_i18n('ReadStatus1');
			}else{
				if(count>99){
					countstr=social_i18n('ReadStatus4', '99+');
				}else{
					countstr=social_i18n('ReadStatus4', count);
				}
			}
		}else{
			if(targetType=="0"){
				countstr=social_i18n('ReadStatus2');
			}else if(targetType == "8"){
				countstr=social_i18n('ReadStatus2')+PrivateUtil.privateRecordCache[messageid];
				PrivateUtil.startUpdateMsgTimer(messageid);
			}else{
				countstr=social_i18n('ReadStatus3');
			}
		}
		var unreadCount=unreadCountdiv.attr("_unreadCount");
		if(unreadCount){
			unreadCount=Number(unreadCount);
			if(count>unreadCount) return ;
		}else{
            //不需要重新计算高度,重复计算高度会导致位置偏移
            var contentHeight=chatContentdiv.find('.chatContent').outerHeight();
            if(contentHeight==0){
                if($("#"+messageid+" .chatNote").length==1){
                    contentHeight=75;
                }else{
                    contentHeight=unreadCountdiv.height();
                }
            }
            //FIXME: 转发后阅读状态丢失，因为这里的高度不能获取 0309 by wyw
            if(contentHeight==0){
                client.error("未获取到内容高度 unreadCountMsgid:"+messageid);
                //由于窗口隐藏获取不到高度，给默认高度
                contentHeight = 24;
            }

            if(chatWin.is(':hidden')){
                contentHeight = chatitem.attr('_coth')?chatitem.attr('_coth'):24;
            }

            var height=contentHeight+"px";
            unreadCountdiv.css({"height":height,"line-height":height});
		}
		unreadCountdiv.attr("_unreadCount",count).html(countstr).show();
		if(targetType=="0"||targetType ==8){
			unreadCountdiv.css({"cursor":"default"});
		}
		return countstr;
	},
    //更新阅读状态 收到count消息后触发
	updateMsgUnreadCount:function(messageid,receiverid,targetType,isRepeat,msgFrom){ //更新消息阅读状态
		if(messageid==""||receiverid==undefined || receiverid == 'SysNotice' || ClientSet.ifForbitReadstate == '1') return;
		msgFrom=msgFrom?msgFrom:"";
		client.error("updateMsgUnreadCount:更新消息阅读状态");
		if(!isRepeat){ //非重复发送
			ChatUtil.savaCountMsg(messageid,receiverid,targetType,'receive',M_USERID);
		}
		var url=getPostUrl("/social/im/SocialIMOperation.jsp?operation=updateMsgUnreadCount");
		$.post(url,{"messageid":messageid,"receiverid":receiverid,"msgFrom":msgFrom},function(data){
            ChatUtil.delCountMsg(messageid,M_USERID);
			var msgObj=data;
			var isInit=msgObj.isInit;
			var mssageid=msgObj.messageid;
			var unreadCount=Number(msgObj.count);
			client.error("mssageid:"+mssageid+" unreadCount:"+unreadCount+" isInit:"+isInit);
			if(isInit){
				ChatUtil.updateMsgUnreadCountHtml(messageid,targetType,unreadCount);
			}else{
				var unreadCountdiv=$("#"+messageid+" .msgUnreadCount");
				var chatWin=unreadCountdiv.parents(".chatWin:first");
				var _targetType=chatWin.attr("_targetType");
				var targetid=chatWin.attr("_targetid");
				if(_targetType == 1){
					client.getDiscussionMemberIds(targetid,function(ids){
						var _unreadCount= (ids.length-1-unreadCount)>0? ids.length-1-unreadCount : 0;
						ChatUtil.updateMsgUnreadCountHtml(messageid,targetType,_unreadCount);
					})
				}else{
					ChatUtil.updateMsgUnreadCountHtml(messageid,targetType,0);
				}
			}
		},"json");
	},
	showMsgReadStatus:function(obj){
		var chatItem=$(obj).parents(".chatItemdiv:first");
		var messageid=chatItem.attr("id");
		var targetType=$(obj).parents(".chatWin:first").attr("_targetType");
		client.error("messageid:"+messageid+" targetType:"+targetType);
		if(targetType==0||targetType == 8) return ; //单聊不查看阅读状态
		var title=social_i18n('ReadStatus5');
	    var url=getPostUrl("/social/im/SocialIMMsgReadStatus.jsp?messageid="+messageid);
		var diag=getSocialDialog(title,500,450);
		diag.URL =url;
		diag.show();
		ChatUtil.cache.dialog = diag;
		document.body.click();
	},
	getExtraObj:function(extra){
		var extraObj=null;
		var messageid="";
		var receiverids="";
		try{
			var extraObj=eval("("+extra+")");
			extraObj["messageid"]=extraObj.msg_id;
		}catch(e){
			extraObj={"messageid":messageid,"receiverids":receiverids,"msg_at_userid":""};
			client.error("无效的messageid");
		}
		return extraObj;
	},
	//获取最后一条消息
	getLatestMessage:function(targetid,targetType,targetName){
		if(targetType == 3) return;
		//client.writeLog("------获取最后一条消息----------");
        
        // console.info('----------client = ' + client);
		
		client.getHistoryMessages(targetType,targetid,5,function(symbol,HistoryMessages,flag){
				var message, objName;
				var isFind=false;
				if(HistoryMessages){
					
					for (var i = HistoryMessages.length-1; i >=0; i--) {
						message=HistoryMessages[i];
						if(M_SDK_VER!=undefined&&M_SDK_VER==2){
							var reg=new RegExp("₠","g"); //创建正则RegExp对象   
							var content = message.getContent();
							if(content!=undefined){
								content = content.replace(reg,"&nbsp;"); 
								message.content.content = content;
								message.setContent(content);
							}						
						}
						objName = message.getObjectName(); //消息标识
						// 撤回消息，缓存到本地
						if(objName=='RC:InfoNtf' || objName=='FW:InfoNtf'){
							HandleInfoNtfMsg.setCache(message);
						}
					}
					
					for (var i = HistoryMessages.length-1; i >=0; i--) {
						message=HistoryMessages[i];
						if(objName=="FW:CountMsg" || objName=="FW:ClearUnreadCount" || objName=="FW:SyncMsg" || objName=='RC:InfoNtf' || objName == 'FW:InfoNtf'){
							
						}else{
							isFind=true;
							break ;
						}
					}
				}
				if(isFind){
					// 如果改消息被撤回，则强制更改content为'撤回了一条消息'
					if(HandleInfoNtfMsg.isMsgWithdrawed(message)){
						message.setContent(social_i18n('WithdrawTip', ''));
					}
					updateLatestMessage(targetid,targetType,message);
					if(M_SDK_VER == '1'){
						client.resetGetHistoryMessages(targetType,targetid);
					}
					var sendtime=message.getSentTime();
					var converObj={"targetid":targetid,"targetType":targetType,"targetName":targetName,"sendtime":sendtime};
					sortCountList.push(converObj);
					
					client.writeLog("targetid:"+targetid+" loadConverFinish:"+loadConverFinish+" sortCountList:"+sortCountList.length+" converCount:"+converCount);
					if(loadConverFinish&&sortCountList.length==converCount){
						sortConversation();
					}
				}else{
					if(!symbol){
						converCount--;
						client.error("targetid:"+targetid+" loadConverFinish:"+loadConverFinish+" sortCountList:"+sortCountList.length+" converCount:"+converCount);
						if(loadConverFinish&&sortCountList.length==converCount){
							sortConversation();
						}
						/*
						client.removeConversation(targetType,targetid,function(targetid){
							client.error("deltet conversation targetid:"+targetid);
						});
						*/
						//alert("targetid:"+targetid);
					}
					if(symbol){
						ChatUtil.getLatestMessage(targetid,targetType,targetName);
					}
				}
			
		});
	},
	//获取群组信息
	getDiscussionInfo : function(discussid,force,callback){
		var discuss=discussList[discussid];		
		if(discuss && !force){
			callback(discuss);
		}else{
			client.getDiscussion(discussid,function(discuss){
				if(discuss){
					discussList[discussid]=discuss;
					try{
						var imUserId = IS_BASE_ON_OPENFIRE ? getIMUserId(M_USERID).toLowerCase():getIMUserId(M_USERID);
						if(!IMUtil.contains(discuss.getMemberIdList(),imUserId)){
							ChatUtil.afterQuitOrOutDiscussion(discuss.getId());
							return;
						}	
					}catch(e){}	
				}
				callback(discuss);
			});
		}
	},
	//刷新群组信息
	refreshDiscussioinInfo : function(discussid, callback) {
		client.getDiscussion(discussid,function(discuss){
			if(!!discuss){
				discussList[discussid]=discuss;
				try{
					var imUserId = IS_BASE_ON_OPENFIRE ? getIMUserId(M_USERID).toLowerCase():getIMUserId(M_USERID);
					if(!IMUtil.contains(discuss.getMemberIdList(),imUserId)){
						ChatUtil.afterQuitOrOutDiscussion(discuss.getId());
						return;
					}	
				}catch(e){}	
			}
			callback(discuss);
		});
	},
	//退出讨论组或者不在讨论组后的操作
	afterQuitOrOutDiscussion:function(discussid){
		//退群后续操作				
		ChatUtil.closeConversation('1', discussid);	
		//删除本地会话			
		ChatUtil.delLocalConver(discussid,1);
		//删除通讯录最近
		ChatUtil.delRecent(discussid,1);			
		//删除群组关系
		ChatUtil.delDiscussBook(discussid,function(){
			loadIMDataList("discuss");
		});
		delete discussList[discussid];
	},
	//初始化@提醒
	initIMAtwho:function (targetid){
	    var allatids = ",";
	    //var datas=[{"uid":"1","data":"张三","datapy":"zs"},{"uid":"2","data":"李四","datapy":"ls"}];
		
		var discuss=discussList[targetid];
		if(!discuss)
			return true;
		var datas="{id:'msg_at_all',name:'"+social_i18n("All")+"',py:'qtcyall'}";
		var memberIds = discuss.getMemberIdList();
		for (var i=0;i<memberIds.length;i++) {
			var memberid=getRealUserId(memberIds[i]);
			if(memberid!=""){
				var memberinfo=userInfos[memberid];
				if(memberinfo){
					datas+=",{id:'"+memberinfo.userid+"',name:'"+memberinfo.userName+"',py:'"+memberinfo.py+"'}";
				}
			}
		}

		// datas=datas.length>0?datas.substr(1):"";
		datas="["+datas+"]";
		datas=eval("("+datas+")");
	    var at_config = {
	        at: "@",
	        data: datas,
	        tpl: "<li data-value='@${name}'>${name}</li>",
	        insert_tpl: "<a href='/hrm/HrmTab.jsp?_fromURL=HrmResource&id=${id}' onclick=\"IMUtil.doOpenLink('/hrm/HrmTab.jsp?_fromURL=HrmResource&id=${id}', '_blank')\" class='hrmecho' _relatedid='${id}' atsome='@${id}' unselectable='off' contenteditable='false' target='_blank'>${atwho-data-value}</a>", 
	        limit: 200,
	        callbacks:{
	        	before_save:function(data){
					var names =jQuery.map(data, function(value, i) {
						if (allatids.indexOf("," + value.id + ",") == -1) {
							allatids += value.id + ",";
							return {'id':value.id,'name':value.name, 'py':value.py};
						}
					});
					return names;
	       		 },
                before_insert: function(value, $li) {
                    var $value =$(value);
                    if($value.attr('_relatedid') == 'all'){
                        value = $value.removeAttr('onclick').removeAttr('href')[0].outerHTML;
                    }
                    var tmpV = value.replace(/&/g, '&amp;').replace(/\s/g, '&nbsp;');
                    IMUtil.cache.cursorPos += (tmpV.length-1);
                    // 加空格的长度
                    IMUtil.cache.cursorPos += 6;
                    // console.warn("before_insert_html:"+tmpV);
                    // console.warn("before_insert_pos:"+IMUtil.cache.cursorPos);
                    return value;
                }
	        },
	        show_the_at: true,
	        start_with_space : false,
	        with_repeat_matcher : false,
	        search_key_py : 'py'
	    }
	    $('#chatcontent_'+targetid).atwho(at_config);
	    $("#atwho-ground-chatcontent_"+targetid+" .atwho-view").perfectScrollbar();
	},
	//显示窗口内部提示
	postNotice: function(content, obj){
		 var tempdiv=$("<div class='chatItemdiv chatNotice'><span>"+content+"</span></div>");
		 var chatList=$(obj).parents(".chatWin").find(".chatList");
		 chatList.append(tempdiv);
		 scrollTOBottom(chatList);
	},
	//显示浮动提示
	postFloatNotice: function(content, type, opt){
		if(typeof window.console != 'undefined'){
			console.log(content);
		}
		var chatwin = ChatUtil.getCurChatwin();
		if(opt && opt.hasOwnProperty("chatwin")){
			chatwin = opt.chatwin;
		}
		if(chatwin.length==1){
			var floatmsgid = chatwin.attr("id")+"_floatmsg";
	  		var relateddiv=$("#chatWinFloatMsgdiv").clone().removeAttr('id').attr("id", floatmsgid);
	  		var levelTypediv=relateddiv.find(".levelType");
	  		relateddiv.find(".msgContent").html(content);
	  		if(type =='error'){
	  			levelTypediv.removeClass("warn").addClass("error");
	  			relateddiv.css('background-color','#F6E2E2');
	  		}else if(type == 'warn'){
	  			levelTypediv.removeClass("error").addClass("warn");
	  			relateddiv.css('background-color','#F6F5E2');
	  		}else{
	  			levelTypediv.removeClass("warn").removeClass("error");
	  		}
	  		chatwin.find("#"+floatmsgid).off().remove();
			chatwin.find(".chatList").before(relateddiv).css("top", "95px");
			relateddiv.slideDown('fast');
			//附加参数
			if(opt){
				if(opt.onclick){
					var anchorTopId = opt.onclick.params;
					if(chatwin.attr("anchorTopId")){
						anchorTopId = chatwin.attr("anchorTopId");
					}else{
						chatwin.attr("anchorTopId", anchorTopId);
					}
					relateddiv.one('click', function(){
						opt.onclick.fn(this);
						$(this).find(".clearmsg").click();
						$(this).css('cursor', 'unset');
						chatwin.removeAttr("anchorTopId");
						chatwin.find(".chatList").css("top", "61px");
					}).css('cursor', 'pointer');
				}
				if(opt.msgflag){
					relateddiv.attr("msgflag",opt.msgflag);
				}
			}
	  	}
	},
	//底部通知
	postFloatNoticeBottom: function(msgcontent,opt){
		var chatwin = ChatUtil.getCurChatwin();
		if(opt && opt.hasOwnProperty("chatwin")){
			chatwin = opt.chatwin;
		}
		if(chatwin.length==1){
			var targetid = chatwin.attr("_targetid");
			var senderinfo = opt.senderinfo;
			var senderHead=senderinfo.userHead;
  			var senderName=senderinfo.userName;
  			var relateddiv = $('#relatedMsgdiv_bottom_'+targetid);
  			if(relateddiv.length == 0){
  				relateddiv = $("#relatedMsgdiv").clone().attr("id", "relatedMsgdiv_bottom_"+targetid);
  				chatwin.find(".chatbottom").append(relateddiv);
  				relateddiv.find('.clearmsg').removeAttr('onclick').unbind('click').bind('click', function(){
					$(this).parents('.chatgroupmsg_bottom').remove();
				});
				if(opt.onclick){
					relateddiv.one('click', function(){
						opt.onclick(this);
						$(this).remove();
					}).css('cursor', 'pointer');
				}
  			}
	  		relateddiv.removeClass('chatgroupmsga').addClass("chatgroupmsg_bottom");
	  		relateddiv.find(".userHead").attr("src",senderHead);
	  		relateddiv.find(".relatedContent").html(msgcontent);
	  		if(opt.msgid){
	  			relateddiv.attr('msgid', opt.msgid);
	  		}
	  		// 延迟关闭顶部提示
	  		setTimeout(function(){
	  			var floatmsgid = chatwin.attr("id")+"_floatmsg";
	  			var relateddiv=$("#"+floatmsgid).find('.clearmsg').click();
	  		}, 5000);
		}
	},
	//发送消息
	sendIMMsgAuto: function(chatdiv, msgType,data) {
		//var contentobj=$(chatdiv).find("div[name=chatcontent]");
		//contentobj.html(tempcontent);
		//alert(JSON.stringify(data));
		var sendbtn=$(chatdiv).find(".chatSend");
		return ChatUtil.sendIMMsg(sendbtn, msgType,data);
	},
	//模拟发消息
    sendIMMsgSimulating: function(chatInfo, msgArray, callback) {
        var _acceptid = chatInfo.acceptId;
       showConverChatpanel("",{targetId:_acceptid,
						targetName:chatInfo.userName,
						targetHead:chatInfo.userHead,
						targetType:chatInfo.targetType});
		setTimeout(function(){
			 if (msgArray && msgArray.length > 0) {
            //发送消息
            $.each(msgArray, function(i, msg) {
                var _objeceName =typeof msg.objectname==="undefined"?"":msg.objectname.toLowerCase();
				var _msgType;
                var data = {};
            if(_objeceName == "fw:customsharemsg") {
                    data.shareid = msg.shareid;
                    data.sharetitle = msg.sharetitle;
                    data.sharetype = msg.sharetype;
                    data.objectName = "FW:CustomShareMsg";
					_msgType = 6;
                }else if(_objeceName =="fw:personcardmsg"){
					data.hrmCardid=msg.shareid;
					data.textContent = msg.sharetitle;
					data.objectName = "FW:PersonCardMsg";
					_msgType = 6;
				}
                var charSendDiv = $("div[_acceptid='" + _acceptid + "']").filter('.chatSend');
                if (_msgType == 6 || _msgType == 1) {
                    ChatUtil.sendIMMsg(charSendDiv, _msgType, data,function(msg){
						var msgobj = msg.paramzip.msgobj;
						var objectName = msgobj.objectName;
						if(msg && msg.issuccess){
							//保存权限
							if(objectName =="FW:CustomShareMsg"){
									var targetType = msgobj.targetType;	
									try{var extraObj =  eval("("+msgobj.extra+")");}catch(e){};
									var shareid = extraObj.shareid;
									var targetid = msgobj.targetid;
									var shareType = extraObj.sharetype;
									if(shareType=="folder"||shareType=="pdoc"){
										addNetWorkFileShare(shareid,targetid,targetType=='0'?1:2,shareType,extraObj.msg_id);
									}else if(shareType=="crm"){
										if(targetType =='0'){
											shareCrm(shareid,msgobj.targetid);
										}else{
											typeof client ==='object' && client.getDiscussionMemberIds(msgobj.targetid ,function(ids){shareCrm(shareid,ids+"")});
										}
									}else if(shareType=="workflow"||shareType=="doc"||shareType=="task"){
										var resourcetype = '';
										if(shareType=="workflow"){
											resourcetype = 0;
										}else if(shareType=="doc"){
											resourcetype = 1;
										}else if(shareType=="task"){
											resourcetype = 2;
										}
										var receiverids  = extraObj.receiverids;
										if(targetType == 1&&(typeof receiverids ==='undefined'||receiverids=="")){
											receiverids=ChatUtil.getMemberids(targetType,targetid,false);
										}
										addShareRight(resourcetype,shareid,targetType=='0'?'':targetid,receiverids);
									}
							}}
					})
                }
            })
        }
		},1500)	
       
        typeof callback === "function" && callback(_acceptid, chatInfo.targetType, "e-message通知", chatInfo.userHead, "您发起的与"+ chatInfo.userName+"e-message聊天已经建立，请点击交流");
    },
	//手动发送消息
	sendIMMsg: function(obj, msgType,data,callback) {
		msgType=msgType?msgType:1;
		var lasttime = $("#chatLastDateTime").val();
		var senderid=$(obj).attr("_senderid");
		var chattype=$(obj).attr("_chattype");		
		var targetid=$(obj).attr("_acceptid");		
		var tempcontent="";
		var content="";
		var imageid="";
		var hrmids=""; //人员ID
		var imgUrl=""; //图片地址
		var objectName=""; //消息标记
		var extra=""; //附加内容
		var isPrivate = "";
		if(chattype == "8"){
			chattype = "0";
			targetid = targetid.substring(targetid.indexOf("_")+1);
			extra = "\"isPrivate\":\"1\",";
			isPrivate = "|private";
		}
		var targetType=chattype;
		//获取接收人
		var resourceids=targetid;
		if(targetType==1){
			resourceids=ChatUtil.getMemberids(targetType,targetid,false);
		}
		var msgid=IMUtil.guid();
		extra+="\"msg_id\":\""+msgid+"\",\"receiverids\":\""+resourceids+"\"";
		var contentobj=$(obj).parents(".chatdiv").find("div[name=chatcontent]");
		var tempContentObj=contentobj.clone();
		
		if(msgType==2){ //发送图片
			objectName="RC:ImgMsg";
			content=data.content;
			imgUrl=data.imgUrl;
			tempcontent=content;
			extra+=",\"imgUrl\":\""+imgUrl+"\"";
		}else if(msgType == 6){	//发送自定义消息
			objectName=data.objectName;
			if(objectName=="FW:attachmentMsg"){  //附件
				var fileName=data.fileName;
				var fileSize=data.fileSize;
				var fileType=data.fileType;
				var fileId=data.fileId;
				var filePath=data.filePath;
				content=fileName;
				extra+=",\"fileName\":\""+fileName+"\",\"fileid\":\""+fileId+"\",\"fileSize\":\""+fileSize+"\",\"fileType\":\""+fileType+"\",\"filePath\":\""+filePath+"\"";
				tempcontent=content;
			}else if(objectName=="FW:CustomShareMsg"){  //分享文档或流程
				var sharetype = data.sharetype;
				var sharetitle = data.sharetitle;
				var shareid = data.shareid;
				content=sharetitle;
				extra+=",\"shareid\":\""+shareid+"\",\"sharetitle\":\""+sharetitle+"\",\"sharetype\":\""+sharetype+"\"";
				tempcontent=content;
			}else if(objectName=="RC:PublicNoticeMsg"){ //发送公告
				//objectName="RC:PublicNoticeMsg";
				content=data.textContent;
				tempcontent=content;
				extra+=",\"noteId\":\""+data.noteId+"\"";
			}
            else if(objectName=="FW:CustomMsg") {
                var pushType = data.pushType;
                if(pushType = 'weaver_shakeMsg') {
                    extra += ",\"pushType\":\""+pushType+"\",\"sendTime\":"+data.sendTime;
                }
            }
            else if(objectName == 'FW:PersonCardMsg'){
				var hrmCardid = data.hrmCardid;
				content=data.textContent;
				extra+=",\"hrmCardid\":\""+hrmCardid+"\"";
			}
            else{
				ChatUtil.postNotice("暂不支持此消息类型", obj);
				return;
			}
		}else{ //发送文本消息
			contentobj.html("");
			objectName="RC:TxtMsg";
			//获取@人员
			tempContentObj.find('.hrmecho').each(function(){
				var hrmid = $(this).attr('_relatedid');
				if(hrmid !=null && typeof(hrmid) != 'undefined')
					hrmids += hrmid +',';
			});
			if(hrmids!=""){
				hrmids=","+hrmids;
			}	
			extra+=",\"msg_at_userid\":\""+hrmids+"\"";
			
			//用来判断是否是是模拟发送的文本消息
			if(typeof data !=='undefined'&&$.trim(data.content) !=""){
				content = data.content;
				tempcontent =content;
			}else{				
				tempcontent=tempContentObj.html();
				content=ChatUtil.formatChatContent(tempContentObj);			
				if($.trim(tempcontent)==""){
					//contentobj.html("").focus();
					stopEvent();
					return;
				}
			}
		}
		// 带入字体配置
		extra+=",\"bubblecolor\":\""+FontUtils.getColorHex(FontUtils.getConfig('bubblecolor', FontUtils.defaults.bubblecolor))+"\"";
		// extra+=",\"fontsize\":\""+FontUtils.getConfig('fontsize', FontUtils.defaults.fontsize)+"\"";
		extra+=",\"issetted\":\""+FontUtils.isSetted+"\"";
		extra+=",\"countids\":\""+CountidsUtil.getMsgids(targetid+isPrivate)+"\"";
		extra="{"+extra+"}";
		
		client.error("extra:"+extra);
		client.writeLog("tempcontent:"+tempcontent);
	    client.writeLog("content:"+content);
	    
		var userInfo=userInfos[M_USERID];
		var chatList=$(obj).parents(".chatWin").find(".chatList");
		var timestamp = msgid;
		var sendtime=M_CURRENTTIME;
		var chatdivid = ChatUtil.getchatdiv(obj).attr('id').substring(8);
		var tempMsgObj={"content":tempcontent,"imgUrl":imgUrl,"objectName":objectName,"extra":extra,'chatdivid':chatdivid, "timestamp":timestamp, "sendTime": sendtime};
		var tempdiv=ChatUtil.getChatRecorddiv(userInfo,tempMsgObj,'send',msgType, null, chatdivid);
		//暂时隐藏消息体 1123 by wyw
		//tempdiv.css("display", 'none');
		// 替换临时气泡
		if(typeof data !=='undefined' && data.tempdivid && $('#'+data.tempdivid).length > 0){
			$("#"+data.tempdivid).replaceWith(tempdiv);
		}else{
			addSendtime(chatList,tempdiv,sendtime,"send");
			chatList.append(tempdiv);
		}
		//下面2行没有效果==
		chatList.perfectScrollbar("update");
		scrollTOBottom(chatList);
		chatList.data("newMsgCome", true);
		//更新会话消息
		//var msgContent=userInfo.userName+":"+getMsgContent(null,{"content":content,"objectName":objectName,"extra":extra,"msgType":msgType});

		//var targetname=$("#"+ getConverId(chattype,targetid)).attr("_targetname");

		var msgObj={"content":content,"imgUrl":imgUrl,"objectName":objectName,"msgType":msgType,"extra":extra,"targetid":targetid,"targetType":targetType,"toUserid":M_USERID,'chatdivid':chatdivid, "timestamp":timestamp, "sendTime": sendtime};
		
		client.sendIMMsg(targetid,msgObj,msgType,function(msg){
				if(msg.sendtime==undefined){
					msg.sendtime = sendtime;
				}
				ChatUtil.doHandleSendState(msg, callback);
				if(callback && typeof callback == 'function'){
					callback(msg);
				}
				var issuccess=msg.issuccess;
				if(issuccess==1){
					ChatUtil.doHandleSendSuccess(msg, msgid, targetid, targetType);
				}
		});
		if(msgType==1){
			window.setTimeout(function(){
				contentobj.html("");//清除聊天窗口内容
				IMUtil.cache.cursorPos = 0;//光标清零
			}, 80);
		}
		contentobj.focus();
		// tab页置顶
		ChatUtil.setChatTabTop(targetid, targetType,isPrivate);
	},
	// tab页置顶显示
	setChatTabTop: function(targetid, targetType,flag){
		var chatTabdiv = $("#chatTab_"+targetType+"_"+targetid);
		if(flag =="|private"){
			chatTabdiv =  $("#chatTab_7_private");
		}
	  	chatTabdiv.detach();
	  	$('#chatIMTabs').prepend(chatTabdiv);
	},
	//消息发送成功的后续操作
	doHandleSendSuccess: function(msg, msgid, targetid, targetType){
		var sendtime=msg.sendtime;
		var msgObj = msg.paramzip.msgobj;
		var userInfo=userInfos[M_USERID];
		var msgContent=userInfo.userName+":"+getMsgContent(null,msgObj);
		var receiverids=ChatUtil.getMemberids(targetType,targetid,true);
		var resourceids=ChatUtil.getMemberids(targetType,targetid,false);
		var senderid = M_USERID;
		var chatdivid = msgObj.chatdivid;
		//更新密聊会话
		try {
			extraObj=eval("("+msgObj.extra+")");
			if(extraObj.isPrivate =="1"){
				targetType = 8;
				PrivateUtil.calculationSeconds(msgObj,extraObj.msg_id);
			}
		} catch (e) {}
		if(targetType == 8){			
			PrivateUtil.updateConversationList(targetid,sendtime);
		}else{
			//更新会话
			updateConversationList(userInfo,targetid,targetType,msgContent,sendtime);
		}		
        //初始化阅读记录
		ChatUtil.initMsgRead(msgid,targetType,resourceids,true,targetid);
		//同步消息
		msgObj["sendtime"]=sendtime;
		//ChatUtil.publishMessage(msgObj);
		var targetname=$("#"+ getConverId(targetType,targetid)).attr("_targetname");
		//更新最后一条消息
		var jsconverList = [{
			senderid:senderid,
			targetid: targetid,
			targettype: targetType,
			msgcontent: msgContent,
			sendtime: sendtime,
			targetname:targetname,
			receiverids:receiverids
		}];
		ChatUtil.syncConversToLocal(jsconverList);
		//刷新自己的头像
		$('#chatdiv_'+targetid+' .chatRItem .chatHead>.userimage').attr('src', userInfo.userHead);
		//刷新发送时间
		var sendFormatTime = IMUtil.getFormatDateCustomByMillis(sendtime, "MM-dd HH:mm:ss");
		$(".chatTime[data-msgid='"+IM_Ext.getMsgId(msgObj)+"']").text(sendFormatTime);
		//发送最后一条消息的count消息
		ChatUtil.sendCountMsgNow(chatdivid);
	},
	// 立即发送count消息
	sendCountMsgNow: function(targetid){
		if(ClientSet.ifForbitReadstate == '1') return;
		var chatdivObj = $('#chatdiv_'+targetid);
		if(isChrome){
			webSql.query("select * from social_IMCountMsg where userid ='"+M_USERID+"'",function(result){
					for (var i = 0; i < result.rows.length; i++) {
						var item=result.rows.item(i);
						var messageid = item['messageid'];
		                var receiverid = item['receiverid'];
		                var type = item['type'];
                        if(chatdivObj.find('#'+messageid).length > 0) {
                            ChatUtil.sendCountMsg(messageid, receiverid,'web');
                            ChatUtil.delCountMsg(messageid, M_USERID);
                        }
					}
			});
		}
	},
	publishMessage:function(msgObj){
        if(IS_BASE_ON_OPENFIRE) return;
		
		var targetid=msgObj.targetid;
		var targetType=msgObj.targetType;
		var content=msgObj.content;
		var messageType=msgObj.msgType;
		var objectName=msgObj.objectName;
		var extra=eval('('+msgObj.extra+')');
		var imageUrl=msgObj.imgUrl;
		var sendtime=msgObj.sendtime;
		var messageid=extra.msg_id;
		
		if(targetType==0){
			targetid=targetid+"|"+M_UDID;
		}
		extra["imageUrl"]=imageUrl;
		extra["targetid"]=targetid;
		extra["sendtime"]=sendtime;
		
		var syncMsgObj={};
		syncMsgObj["content"]=content;
		syncMsgObj["messageType"]=messageType;
		syncMsgObj["objectName"]=objectName;
		syncMsgObj["extra"]=extra;
		
		var params=JSON.stringify(syncMsgObj);
		/*
		var params=JSON.stringify(msgObj);
		$.post("/social/im/SocialIMOperation.jsp?operation=publishMessage",{"params":params},function(){
			client.writeLog("消息同步成功");
		});
		*/
		client.error("----发送同步消息-----");
		var msgObj={"content":params,"objectName":"FW:SyncMsg","targetType":"0"};
		client.sendIMMsg(M_USERID,msgObj,6,function(data){
			if(data.issuccess==0){
	    		ChatUtil.savaSyncMsg(messageid,params);
	    	}
		});
	},
	//处理消息发送状态
	doHandleSendState: function(msg, callback){
		var issuccess = msg.issuccess;
		
		var paramzip = msg.paramzip;
		var msgobj = paramzip.msgobj;
		var chatList = $('#chatdiv_' + msgobj.chatdivid).find('.chatList');
		client.error("msgobj.timestamp:"+msgobj.timestamp);
		var tempdiv = chatList.find("div[timestamp='" + msgobj.timestamp + "']");
		var chattype = paramzip.chattype;
		//console && console.log("tempdiv是这样的:", tempdiv);
		if(!issuccess){
			var err = msg.err;
			client.writeLog("testst", err);
			var chatContentDiv = tempdiv.find('.chatContentdiv');
			chatContentDiv.addClass('sendError');
			var cleardiv = chatContentDiv.find('.clear:last');
			var chatContent = chatContentDiv.find('.chatContent');
			var contentHeight = chatContent.outerHeight();
			contentHeight=contentHeight==0?75:contentHeight;
			chatContentDiv.data("paramzip", paramzip);
			chatContentDiv.data("chattype", chattype);
			chatContentDiv.data("msgobj", msgobj);
			chatContentDiv.data("callback", callback);
			var imgHtml = "<span onselectstart=‘return false‘ class='resendBtn' title='重新发送'  class='resend' onclick='ChatUtil.resendMsg(this);' onmouseenter='$(this).addClass(\"animated infinite pulse\")' onmouseleave='$(this).removeClass(\"animated infinite pulse\")'>!</span>";
			cleardiv.before("<div class='resendwrap'>"+imgHtml+"</div>");
			chatContentDiv.find('.resendwrap').css({'height':contentHeight+'px', 'line-height':(contentHeight + 8)+'px'});
		}
		//显示消息体
		tempdiv.show(10,function(){
			//隐藏的div获取不到高度 1209 by wyw
			var chatContent = tempdiv.find('.chatContentdiv .chatContent');
			var contentHeight = chatContent.outerHeight();
			// tempdiv.find('.chatContentdiv .resendwrap').css({'height':contentHeight+'px', 'line-height':(contentHeight + 8)+'px'});
			// tempdiv.find('.chatContentdiv .msgUnreadCount').css({'height':contentHeight+'px', 'line-height':(contentHeight)+'px'});
			scrollTOBottom(chatList);
		});
	},
	//重新发送
	resendMsg: function(obj){
		var chatContentDiv = $(obj).parents(".chatContentdiv");
		var paramzip = chatContentDiv.data("paramzip");
		var msgType = paramzip.msgtype;
		var msgobj = chatContentDiv.data("msgobj");
		var targetType = msgobj.targetType;
		var targetid = msgobj.targetid;
		var chatList = $(obj).parents(".chatList");
		var chatitem = $(obj).parents(".chatItemdiv");
		var callback = chatContentDiv.data("callback");
		chatContentDiv.removeClass('sendError');
		chatContentDiv.find('.resendwrap').remove();
		//移出消息气泡
		chatitem.remove();
		//重写msgid
		var transMsgObj = IM_Ext.transMsgId(msgobj);
		var msgid = transMsgObj.msgid;
		msgobj = transMsgObj.msgObj;
		chatitem.data("msgObj", msgobj);
		chatitem.attr('id', msgid);
		chatList.append(chatitem);
		scrollTOBottom(chatList);
		client.sendIMMsg(targetid,msgobj,msgType,function(msg){
				if(msg.sendtime==undefined){
					var sendtime=M_CURRENTTIME;
					msg.sendtime = sendtime;
				}
				ChatUtil.doHandleSendState(msg, callback);
				if(callback && typeof callback == 'function'){
					callback(msg);
				}
				var issuccess=msg.issuccess;
				if(issuccess==1){
					ChatUtil.doHandleSendSuccess(msg, msgid, targetid, targetType);
				}
		});
		
	},
	//当前Enter设置
	curEnterSet: 1,
	//更新Enter设置
	updateEnterSet: function(obj) {
		var idx = $(obj).attr('_index');
		ChatUtil.curEnterSet = idx;
		$($(obj).parents('.sendtype')[0]).hide();
		var children = $($(obj).parents('.sendtype')[0]).children('.checkpane');
		for(var i = 0; i < children.length; ++i){
			var type = $(children[i]);
			if(type.attr('_index') == ChatUtil.curEnterSet){
				type.addClass('active');
			}else{
				type.removeClass('active');
			}
		}
		WebAndpcConfig['sendType'] =  idx;		
		ChatUtil.saveConfigToOA('4',JSON.stringify(WebAndpcConfig));
	},
	saveConfigToOA: function(osType,userConfig,callback){
        $.post('/social/im/SocialImPcUtils.jsp', { method : 'saveUserSysConfig', osType : osType, config : userConfig },function(){
        	typeof callback === 'function' && callback();
        });
    },
	showSendType:function(obj){
		ChatUtil.curEnterSet = $.isEmptyObject(WebAndpcConfig)? 1: typeof WebAndpcConfig.sendType ==="undefined"? 1:WebAndpcConfig.sendType;
		var children =$(obj).parents('.chatbottom').find(".sendtype").children('.checkpane');
		for(var i = 0; i < children.length; ++i){
			var type = $(children[i]);
			if(type.attr('_index') == ChatUtil.curEnterSet){
				type.addClass('active');
			}else{
				type.removeClass('active');
			}
		}
		if($(obj).parents('.chatbottom').find(".sendtype").is(":hidden")){
			$(obj).parents('.chatbottom').find(".sendtype").show();
		}else{
			$(obj).parents('.chatbottom').find(".sendtype").hide();
		}		
		//stopEvent();
	},
	/*聊天截图*/
	isScreenShotMinimize:0,
	showScreenSet:function(obj){
		$('.screenshot').css('left',event.pageX-160+'px');
		var children =$(obj).parents('.chatbottom').find(".screenshot").children('.checkpane');
		var screenShotMin = $(children[1]);
		if(screenShotMin.attr('_index') == ChatUtil.isScreenShotMinimize){
				screenShotMin.addClass('active');
			}else{
				screenShotMin.removeClass('active');
			}
		if($(obj).parents('.chatbottom').find(".screenshot").is(":hidden")){
			$(obj).parents('.chatbottom').find(".screenshot").show();
		}else{
			$(obj).parents('.chatbottom').find(".screenshot").hide();
		}		
		stopEvent();
	  },
	  exeScreenShot:function(obj){
		var children =$(obj).parents('.chatbottom').find(".screenshot");
		children.hide();
		setTimeout(function() {
			ScreenshotUtils.screenshot(obj);
		}, 300);
	  },
	  updateScreenShotSet:function(obj){
			var idx = $(obj).attr('_index');
			ChatUtil.curEnterSet = idx;
			$($(obj).parents('.screenshot')[0]).hide();
			var children =$($(obj).parents('.chatbottom').find(".screenshot").children('.checkpane')[1]);
			if(children.hasClass("active")){
				ChatUtil.isScreenShotMinimize = 0;
				children.removeClass('active');
			}else{
				ChatUtil.isScreenShotMinimize = 1;
				children.addClass('active');
			}
			var config = PcSysSettingUtils.getConfig();
			config['isScreenShotMinimize'] =  ChatUtil.isScreenShotMinimize;		
			PcSysSettingUtils.saveConfig(config);
	  },
	//解决删除表情，会保留标签和回车后生成带样式的br
	checkTagDeleted: function(obj, event){
		event = event || window.event;
		var keynum;
		if(typeof window.event != 'undefined')
       		keynum=event.keyCode;
        else
            keynum=event.which;
        var content = obj.innerHTML;
        if(keynum == 8){
        	//console.log(content);
        	if(content == '' || content == '<br>'){
        		$(obj).empty();
        	}
        }else if(/<b>(.+)<\/b>/gim.test(content)){
        	//console.log('tested b tag');
        	$(obj).find('b').each(function(){
        		var _this = $(this);
        		if(_this.text()){
        			_this.replaceWith(_this.text());
        		}
        	});
        	// $(obj).empty().prepend($(content).text());
        	IMUtil.moveToEndPos(obj);
        }else if(/<div><br><\/div>/gim.test(content)){
        	if($('<div>'+content+'</div>').text().length == 0) {
        		content = content.replace(/<div><br><\/div>/g, '<br>');
        	}else{
        		content = content.replace(/<div><br><\/div>/g, '<br><br>');
        	}
        	$(obj).html(content);
        	IMUtil.moveToEndPos(obj);
        }
        $(obj).find('div').css('fontSize', FontUtils.getConfig('fontsize')+'px');
	},
	//Enter建发送消息
	enterIMSend: function(obj,evt){
		evt = evt || window.event;
		var keynum;
		if(typeof window.event != 'undefined'){
			keynum = evt.keyCode;
		}else{
			keynum=evt.which;
		}
		if(keynum==8){ //@ 样式
            var div = $(obj)
			var chds = div[0].childNodes;
			if(chds.length == 0) return true;
			div.find("A.hrmecho").each(function(index, elem){
				if(index > 0){
					$(elem).before(" ");
				}
			});
		}else if(keynum==13||keynum==10){
			var div = $(obj);
        	var atwhoid="atwho-ground-"+div.attr("id");
			if($("#"+atwhoid+" .atwho-view").is(":visible")){
				evt.keyCode = 0;//屏蔽回车键
				evt.returnvalue = false; 
				stopEvent();
				return false;
			}
			var sendType = typeof WebAndpcConfig == 'undefined'?1:WebAndpcConfig.sendType?WebAndpcConfig.sendType:1;
			if(typeof sendType == 'string') sendType = Number(sendType);
			switch(sendType){
				case 1:
					if(!evt.shiftKey){
                        var baddivs = div.find('div');
                        if(baddivs.length > 0){
                            for(var i = baddivs.length - 1; i >= 0; --i){
                                if(baddivs[i].innerHTML == '<br>'){
                                    $(baddivs.get(i)).remove();
                                }
                            }
                        }
                        if(div.html() == ''){
                            setTimeout(function () {
                                div.empty();
                            },0);
                            //清除聊天窗口内容
                        }else{
                            var chatdiv=ChatUtil.getchatdiv(obj);
                            var chatSend=chatdiv.find('.chatSend');
                            chatSend.click();
                        }
                        evt.keyCode = 0;//屏蔽回车键
                        evt.returnvalue = false;
                        evt.preventDefault();
                    }
				break;
				case 2:
					if(evt.ctrlKey){
						if(div.html().trim() ==""){
                            setTimeout(function () {
                                div.empty();
                            },0);
						}else{
                            //清除聊天窗口内容
                            var chatdiv=ChatUtil.getchatdiv(obj);
                            var chatSend=chatdiv.find('.chatSend');
                            chatSend.click();
						}
						evt.keyCode = 0;//屏蔽回车键
						evt.returnvalue = false;
                        evt.preventDefault();
					}
				break;
			}
        }
        stopEvent();
	},
	//接收消息格式化
	receiveMsgFormate:function(content){
		try{
			client.error("receiveMsgFormate:"+content);
			content=content.replace(" ","&nbsp;").replace(/\n/g,"<br>");
			content=initEmotion(content);
			//content=IMUtil.httpHtml(content);
		}catch(e){
			client.error("receiveMsgFormate 异常：",content);
		}
		return content;
	},
	//获取成员头像
	_getMitem: function(itemGroove, memberid){
		var mitem = itemGroove.find(".mtemp").clone().
			removeClass("mtemp").addClass("members").show();
		var memberinfo=getUserInfo(memberid);
		mitem.attr('resourceid', memberid);
		mitem.find(".mhead").attr("src",memberinfo.userHead);
		//mitem.find(".mname").html(memberinfo.userName);
		mitem.find(".mname").attr('title',memberinfo.userName).addClass('ellipsis').html(memberinfo.userName);
		var status = memberinfo.status;
		if(IMUtil.contains(ChatUtil.settings.dismissionStatus, status)) {
			var mhead = mitem.find(".mhead");
			var hoverBtn = $("<div style='width:28px;height:28px;position:absolute;top:0;left:17px;"+
				"border-radius:14px;background:#ddd;opacity:0.8;text-align:center;color:#fff;font-size:11px;line-height:28px;'>离职</div>");
			mitem.css('position', 'relative');
 			mhead.after(hoverBtn);
		}
		return mitem;
	},
	//清空群设置页面信息
	flushDisMemeberInfo: function() {
		var dsDiv = $('.imDiscussSetting');
		var discussInfodiv = $('#discussInfo');
		var itemGroove = $('#discussInfo .itemGroove');
		itemGroove.find('.members').remove();
		var dsNameInput = dsDiv.find('.dsNameInput');
		dsNameInput.val("");
		discussInfodiv.find(".title .left span").html("0");
		var memAddBtn = dsDiv.find(".memberadd");
		memAddBtn.attr("onclick", "");
	},
	//更新群成员信息
	setDisMemberInfo: function(discuss){
		var dsDiv = $('#imDiscussSetting');
		var discussInfodiv = $('#discussInfo');
		var itemGroove = $('#discussInfo').find('.itemGroove');
		var createrid = "";
		//没有取到讨论组对象啊，为了防止群设置信息串掉，要清空群设置信息 1224 by wyw
		if(!discuss){
			ChatUtil.flushDisMemeberInfo();
			return;
		}else{
			createrid=getRealUserId(discuss.getCreatorId());
		}
		itemGroove.find('.members').remove();
		itemGroove.prepend(ChatUtil._getMitem(itemGroove, createrid));
		var memberIds = discuss.getMemberIdList().unique();
		var mitemCount=parseInt(discussInfodiv.width()/60);
		var count=1,memberid;
		for (var i=0; i < memberIds.length; ++i) {
			if(count == mitemCount)
				break;
			memberid = getRealUserId(memberIds[i]);
			var mitem= ChatUtil._getMitem(itemGroove, memberid);
			if(memberid != createrid){
				itemGroove.append(mitem);
				count++;
			}
			
		}
		
		//成员数目
		$('#discussInfo .title .left span').text(''+memberIds.length);
		//名称
		var dsNameInput = dsDiv.find('.dsNameInput');
		dsNameInput.val(discuss.getName().replace(/&nbsp;/ig, " "));
		//名称修改权限
		if(createrid != M_USERID){
			//dsNameInput.attr('disabled', 'disabled');
			//dsNameInput.css('background', '#FFF');
		}else{
			dsNameInput.removeAttr('disabled');
		}
		
	},
	//设置当前群信息
	setCurDiscussInfo: function(discussionId, chattype){
		var dsDiv = $('#imDiscussSetting');
		var discussInfodiv = $('#discussInfo .itemGroove');
		//绑定targetid
		dsDiv.attr("discussid", discussionId);
		if(chattype == '1'){
			var discuss=discussList[discussionId];
			if(!discuss){
				ChatUtil.refreshDiscussioinInfo(discussionId, ChatUtil.setDisMemberInfo,function(info){
					discuss = info;
				})
			}else{
				setTimeout(function(){
					ChatUtil.setDisMemberInfo(discuss);
				}, 400);
			}
			dsDiv.find('.setTitle').html(social_i18n('GroupSetting'));
			dsDiv.attr("chattype", 1);
				//设置
			var url=getPostUrl("/social/im/SocialIMOperation.jsp?operation=getGroupBookStatus&discussid=" + discussionId);
			$.post(url,function(isadd){
				isadd = $.trim(isadd);
				var abchk = dsDiv.find('.opItem[_itemIndex=\'3\'] .switch input:checkbox');
				if(isadd == '1'){
					abchk.attr("checked",true);
					abchk.next().addClass("checked");
				}else{
					abchk.attr("checked",false);
					abchk.next().removeClass("checked");
				}
				
			});
		}else if(chattype == '0'){
			dsDiv.find('.setTitle').html(social_i18n('ChatSetting'));
			dsDiv.attr("chattype", 0);
		}	
		
		var remindType = ChatUtil.getRemindType(discussionId);
		var rtchk = $('.imDiscussSetting .dsCommonOpList .opItem[_itemIndex=\'2\'] .switch input:checkbox');
		if(remindType == '1'){
			rtchk.attr("checked",true);
			rtchk.next().addClass("checked");
		}else{
			rtchk.attr("checked",false);
			rtchk.next().removeClass("checked");
		}
		//非群组的模块隐藏
		if(chattype == '0'){
			dsDiv.find('.dsMemberCard .title').addClass('hidden');
			dsDiv.find('.dsMemberCard .itemGroove').addClass('hidden');
			dsDiv.find('.dsCommonOpList .opItem[_itemindex=\'0\']').addClass('hidden');
			dsDiv.find('.dsCommonOpList .opItem[_itemindex=\'3\']').addClass('hidden');
			dsDiv.find('.dsCommonOpList .opItem[_itemindex=\'4\']').addClass('hidden');
			dsDiv.find('.dsBottom').addClass('hidden');
			dsDiv.find('.dsCommonOpList').addClass('minipane');
		}else{
			dsDiv.find('.dsMemberCard .title').removeClass('hidden');
			dsDiv.find('.dsMemberCard .itemGroove').removeClass('hidden');
			dsDiv.find('.dsCommonOpList .opItem[_itemindex=\'0\']').removeClass('hidden');
			dsDiv.find('.dsCommonOpList .opItem[_itemindex=\'3\']').removeClass('hidden');			
			if(IS_BASE_ON_OPENFIRE&&M_SERVERCONFIG.setGroupIcon==1&&discuss&&discuss.getIcon()!=""&&getRealUserId(discuss.getCreatorId())==M_USERID){
				dsDiv.find('.dsCommonOpList .opItem[_itemindex=\'4\']').removeClass('hidden');
				$('.imDiscussSetting .dsCommonOpList .opItem[_itemIndex=\'4\'] .discussHead img').attr('src','/weaver/weaver.file.FileDownload?fileid='+discuss.getIcon()+'&time='+new Date().getTime())
			}else{
				dsDiv.find('.dsCommonOpList .opItem[_itemindex=\'4\']').addClass('hidden');
			}			
			dsDiv.find('.dsBottom').removeClass('hidden');
			dsDiv.find('.dsCommonOpList').removeClass('minipane');
		}
		ChatUtil.transDsDiv(dsDiv, chattype);
		if(DiscussUtil.isDisableAddUser(discussionId)){
            var memAddBtn = dsDiv.find(".memberadd");
            memAddBtn.attr("onclick", "").html("");
		}
	},
	//转换群设置接口
	transDsDiv: function(dsDiv, chattype){
		if(chattype == 0){
			var memAddBtn = dsDiv.find(".memberadd");
			memAddBtn.html("+&nbsp;&nbsp;"+social_i18n('GroupNewChat'));
			var targetid = dsDiv.attr("discussid");
			memAddBtn.attr("onclick","DiscussUtil.addDiscuss(event,'"+targetid+"');");
		}else{
			var memAddBtn = dsDiv.find(".memberadd");
			memAddBtn.html("+&nbsp;&nbsp;"+social_i18n('GroupAddMember'));
			memAddBtn.attr("onclick","DiscussUtil.DiscussSetFunc.addMember(event);");
		}
	},
	//设置群信息
	setDiscussInfo:function(discussionId){
		var discussInfodiv=$("#discussInfo_"+discussionId);
		discussInfodiv.find('.members').remove();
		try{
			if(discussInfodiv.find(".mitem").length==2){
				var mitemCount=parseInt(discussInfodiv.width()/60);
				var discuss=discussList[discussionId];
				var memberIds=discuss.getMemberIdList();
				var createrid=getRealUserId(discuss.getCreatorId());
				var count=0;
				for (var i=memberIds.length-1;i>=0;i--) {
					count++;
				    var mitem=discussInfodiv.find(".mtemp").clone().removeClass("mtemp").show();
				    mitem.addClass('members');
					var memberid=getRealUserId(memberIds[i]);
					if(count>mitemCount-2) memberid=createrid;
					if(memberid!=""){
						var memberinfo=getUserInfo(memberid);
						mitem.find(".mhead").attr("src",memberinfo.userHead);
						//mitem.find(".mname").html(memberinfo.userName);
						mitem.find(".mname").attr('title',memberinfo.userName).addClass('ellipsis').html(memberinfo.userName);
						discussInfodiv.prepend(mitem);
					}
					if(count>mitemCount-2) return;
				}
			}
		}catch(e){
			client.error("设置群【"+discussionId+"】信息失败");
		}
	},
	//显示群信息
	showDiscussInfo:function(discussionId){
	
		var discussInfodiv=$("#discussInfo_"+discussionId);
		if(!discussInfodiv.is(":hidden")){
			discussInfodiv.hide();	
			return ;
		}else{
			discussInfodiv.show();
		}
		stopEvent();
		
	},
	//获取消息提醒方式
	getRemindType:function(targetid){
		var remindType=1;
		if(settingInfos[targetid]){
			remindType=settingInfos[targetid].remindType;
		}
		client.writeLog("remindType:"+remindType);
		return remindType;
	},
	//获取人员id的字符串
	getMemberids: function(chattype, discussid,isHasSelf){
		var memberids="";
		if(chattype == '0'){
			memberids=getRealUserId(discussid);
			if(isHasSelf){
				memberids=M_USERID+',' +memberids; 
			}
		}else if(chattype == '8'){
			memberids=getRealUserId(discussid);
			memberids = memberids.substring(memberids.indexOf("_")+1);
			if(isHasSelf){
				memberids=M_USERID+',' +memberids; 
			}
		}else{	
			var discuss = discussList[discussid];
			if(!discuss)
				return memberids;
			var memberlist = discuss.getMemberIdList();
			var temp = [];
			for(var i = 0; i < memberlist.length; ++i){
				var memberid=getRealUserId(memberlist[i]);
				if(memberid==M_USERID&&!isHasSelf){
					continue;
				}
				temp.push(memberid);
			}
			memberids = temp.join(',');
		}
		return memberids;
	},
	//打开任务详情页面
	showTaskDetails: function(taskid, obj){
		if(versionTag == 'rdeploy'){
			var slideDiv = $("#imSlideDiv");
			slideDiv.find(".imDiscussSetting").hide();
			$("#imSlideDiv iframe").show();
			var tdsFrm =  slideDiv.find("iframe");
			tdsFrm.attr("src", "/rdeploy/task/data/Main.jsp?showDetail=0&taskid=" + taskid);
			var width = "45%";
			IMUtil.doShowSlideDiv(width, {
				'afterhide': function(){
					//判断任务是否完成
					var taskMsgItem = $(obj).parents(".taskMsgItem");
					ChatUtil.isTaskDeleted(taskid, function(isDelete){
						if(isDelete.ifDelete){
							ChatUtil._taskStateCallback(CONST.taskStatus.DELETE, taskMsgItem);
						}else {
							ChatUtil.isTaskCompleted(taskid, function(isCompleted){
								var taskCode = CONST.taskStatus.UNCOMPLETE;
								if(isCompleted.isComplete) taskCode = CONST.taskStatus.COMPLETE;
								ChatUtil._taskStateCallback(taskCode, taskMsgItem);
							});
						}
					});
				}
			});
		}
		//弹出窗口方式打开
		else{
			viewShare($(obj).parents(".taskMsgItem"));
		}
		
	},
	//任务状态回调(stateCode: 1进行 2已完成 4删除)
	_taskStateCallback: function(stateCode, taskMsgItem){
		if(stateCode == CONST.taskStatus.UNCOMPLETE){
			taskMsgItem.find(".taskState").addClass("taskComplete").removeClass("taskDelete").
						removeClass("taskCompleted").html("完成").attr("onclick","ChatUtil.completeTask(this);");
		}else if(stateCode == CONST.taskStatus.COMPLETE){
			taskMsgItem.find(".taskState").removeClass("taskComplete").removeClass("taskDelete").
						addClass("taskCompleted").html("已完成").removeAttr("onclick");
		}else if(stateCode == CONST.taskStatus.DELETE){
			taskMsgItem.find(".taskState").removeClass("taskComplete").removeClass("taskCompleted").
						addClass("taskDelete").html("此任务已删除").removeAttr("onclick");
			
		}
	}, 
	//打开新建任务页面
	openTaskAdd: function(tasktitle, msgid){
		var slideDiv = $("#imSlideDiv");
		slideDiv.find(".imDiscussSetting").hide();
		$("#imSlideDiv iframe").show();
		var tdsFrm =  slideDiv.find("iframe");
		tdsFrm.attr("src", "/rdeploy/task/data/Add.jsp?name=" + tasktitle + "&msgid="+msgid);
		var width = "45%";
		IMUtil.doShowSlideDiv(width);
	},
    // 发送该人员会话阅读消息(openfire)
    sendClearUnreadCountMsg : function(targetId, targetType){
		if(targetType ==7) return;
        var ct = targetType == 0 ? getIMUserId(targetId) : targetId;
		if(targetType == 8 ){
			ct = getIMUserId(targetId) + "|private";
		}
        var msgObj = {"content":ct, "objectName":"FW:ClearUnreadCount"};
        if(client){
        	client.sendMessageToUser(M_USERID, msgObj, 6);
        }else{
        	ChatUtil.postFloatNotice(social_i18n('FloatNotice2'), "error", {
				"onclick": {
					"fn": function(targetId, targetType){
						var chatWinid="chatWin_"+targetType+"_"+targetId;
						var chatActiveTab=$("#"+chatWinid).find(".chatActiveTab");
						chatActiveTab.click();
					}
				}
			});
        	setTimeout(function(){
        		ChatUtil.sendClearUnreadCountMsg(targetId, targetType);
        	}, 1000);
        }
    }
};
//群组
var DiscussUtil = {
	cache: {
		discuss: null
	},
	settings: {
		MAX_MEMS: 500
	},
	//修改群名称
	changeDisSetting: function(){
		alert("群设置修改");
	},
	//显示群设置页面
	showDiscussSetting: function(){
		$("#imSlideDiv iframe").hide();
		$("#imSlideDiv .imDiscussSetting").show();
		IMUtil.doShowSlideDiv( '311px');
	},
	//打开人员卡片
	showPersonalInfo: function(obj){
		var mitem = $(obj).parents('.mitem').first();
		var resourceid = mitem.attr('resourceid');
		window.open(IMUtil.settings.hrmurl+resourceid, '_blank');
	},
	
	//群设置方法
	DiscussSetFunc: {
		//鼠标移动效果
		itemMouseHand: function(obj, ismovein){
			var dsDiv = $(obj).parents('.imDiscussSetting');
			var dsNameInput = dsDiv.find('.dsNameInput');
			var dsSaveBtn =dsDiv.find('.savebtn');
			var discuss = discussList[dsDiv.attr('discussid')];
			//是否创建人
			if(getRealUserId(discuss.getCreatorId()) != M_USERID){
				//return;
			}
			if(ismovein){
				dsNameInput.addClass('borderStyle').focus();
				dsSaveBtn.fadeIn();
			}else{
				var olddisName=discuss.getName();
				var disName=dsNameInput.val();
				if(olddisName==disName){
					dsNameInput.removeClass('borderStyle').blur();
					dsSaveBtn.fadeOut();
					dsNameInput.val(discuss.getName().replace(/&nbsp;/ig, " "));
				}
			}
		},
		setDsNameDisabled: function(){
			var dsDiv = $(".imDiscussSetting");
			var dsSaveBtn =dsDiv.find('.savebtn');
			var dsNameInput = dsDiv.find(".dsNameInput");
			dsNameInput.removeClass('borderStyle').blur();
			dsSaveBtn.fadeOut();
		},
		//删除并退出群
		dsDelToQuit : function(){
			var discussSetdiv = $('.imDiscussSetting');
			var discussid = discussSetdiv.attr('discussid');
			//alert(discussid);
			var discuss = discussList[discussid];
			var creatorid = getRealUserId(discuss.getCreatorId());
			//IMUtil.cache.dialog = window.top.Dialog;
			if(creatorid == M_USERID){  //创建者退出群
				window.top.Dialog.confirm("确定退出群？",function(){
					DiscussUtil.DiscussSetFunc.destroyDiscussion(discussid);
				});
			}else {		//成员退出群
				window.top.Dialog.confirm("确定退出群？",function(){
					DiscussUtil.DiscussSetFunc.quitFromDiscussion(discussid);
				});
			}
			
		},
		//转让群组 私有云
		setDiscussionAdmin:function(discussid, admins,cb){
			if(admins.length<2){
				IMClient.prototype.setDiscussionAdmin(discussid,getIMUserId(admins[0]),cb);	
			}			
		},
		//修改群名称
		changeDiscussName: function(obj){
			var discussSetdiv = $('.imDiscussSetting');
			var discussid = discussSetdiv.attr('discussid');
			var discuss = discussList[discussid];
			var discussName = discuss.getName();
			var disNameInput = $(obj).parent().parent().find('.dsNameInput');
		   	var newDiscussName = $.trim(disNameInput.val());
		   	if(newDiscussName==""){
		   		window.top.Dialog.alert("请填写群组名称",function(){
		   			disNameInput.focus();
		   		});
		   	}else if(newDiscussName == discussName){
		   		disNameInput.focus();
		   	}else if(DiscussUtil.DiscussSetFunc.checkDsNameValid(newDiscussName)){
		   		newDiscussName = IMUtil.htmlEncode(newDiscussName);
		   		//将连续的空格&nbsp;代码转化为一个
		   		var reg = /(&nbsp;)(\1)+/g;
		   		newDiscussName = newDiscussName.replace(reg,'$1');
		   		newDiscussName = newDiscussName.replace(/<br>/gi, '').replace(/<\/br>/gi, '').replace(/&nbsp;/gi, ' ');
		   		client.setDiscussionName(discussid, newDiscussName, function(){
		   			refreshDiscussTitle(discussid);
		   			var isopenfire = IS_BASE_ON_OPENFIRE?1:0;
                    var url = "/social/im/SocialIMOperation.jsp?operation=updateDiscussName";
                    $.post(url,{newDiscussName:newDiscussName,discussid:discussid,isopenfire:isopenfire}, function(data){
                     //刷新树
                     loadIMDataList("discuss");
                 });
		   		});
		   	}else {
		   		window.top.Dialog.alert(social_i18n('GroupNameInvalid'),function(){
		   			disNameInput.focus();
		   		});
		   	}
		},
		//检查群组名称的合法性，不包含‘ “ < > &%$=/\()
		checkDsNameValid: function(dsName){
			var isvalid = false;
			if(dsName.match(/^[^('"\\<>&$%=\/)]+$/gi)){
				isvalid = true;
			}
			return isvalid;
		},
		//添加到通讯录
		setToAddress: function(obj){
			var discussSetdiv = $('.imDiscussSetting');
			var discussid = discussSetdiv.attr('discussid');
			var opt = obj.checked?"add":"del";
			IMUtil.addGroupBook(discussid,M_USERID,opt);
		},
		//新消息通知
		setNewMsgNotice: function(obj){
			var discussSetdiv = $('.imDiscussSetting');
			var targetid = discussSetdiv.attr('discussid');
			var targetType = '1';
			var remindType=obj.checked?"1":"0";
			var url=getPostUrl("/social/im/SocialIMOperation.jsp?operation=editIMSetting");
			$.post(url,{"targetid":targetid,"targetType":targetType,"remindType":remindType},function(data){
				var settingInfo=eval("("+data+")");
				refreshDiscussSetting(settingInfo);
			})
			
		},
		//设置群头像
		setDiscussionIcon:function(obj){
			var discussSetdiv = $('.imDiscussSetting');
			var targetid = discussSetdiv.attr('discussid');
			var title="设置群头像";
            var url="/social/im/SocialHrmDialogTab.jsp?_fromURL=GetGroupIcon&discussid="+targetid;
            var diag=getSocialDialog(title,625,480);
            diag.URL =url;
			diag.openerWin = window;
            diag.show();    

		},
		//置顶聊天
		setChatToTop: function(obj){
			alert('开发中。。');
		},
		//添加成员
		addMember: function(event,selectedids){
			ChatUtil.cache.dialog = "MutiResourceBrowser";
			if(!selectedids){
				selectedids = "";
				var discussSetdiv = $('.imDiscussSetting');
                var discussid = discussSetdiv.attr('discussid');
                var discuss = discussList[discussid];
                var MemIdArray = discuss.getMemberIdList();
                if(MemIdArray.length > parseInt(ClientSet.maxGroupMems)){
                    showImAlert(social_i18n('GroupMemberLimit'));
                    return;
                }
                var realUserId = "", creatorId=getRealUserId(discuss.getCreatorId());
                for(var i = 0; i < MemIdArray.length; ++i) {
                	realUserId = getRealUserId(MemIdArray[i]);
                	var memberinfo=getUserInfo(realUserId);
					var status = memberinfo.status;
					if(IMUtil.contains(ChatUtil.settings.dismissionStatus, status)) {
						continue;
					}
					if(creatorId == realUserId) {
						continue;
					}
                	selectedids += (","+realUserId);
                }
                selectedids = creatorId + selectedids;
			}
			showModalDialogForBrowser(event,'/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?' +
					'selectedids='+selectedids,'#','resourceid',false,1,'',
			{
				name:'resourceBrowser',
				hasInput:false,
				zDialog:true,
				needHidden:true,
				dialogTitle:'人员',
				arguments:'',
				_callback:DiscussUtil.DiscussSetFunc.resourceBrowserCallback
			});
		},
		resourceBrowserCallback: function(event, data, name, oldid) {
            ChatUtil.cache.dialog = null;
            if (data != null) {
                if (data.id != "") {
					var resourceids = data.id.split(",");
					resourceids = AccountUtil.checkAccount(resourceids);
                    var discussSetdiv = $('.imDiscussSetting');
                    var discussid = discussSetdiv.attr('discussid');
                    //比较新加的人员和旧的人员是否重合，把相同的剔除
                    var MemIdArray = discussList[discussid].getMemberIdList();
                    var temp = []; //临时数组1 
                    var temparray = []; //临时数组2 
                    var Memid = "";

                    for (var i = 0; i < MemIdArray.length; i++) {
                        if (i == 0) {
                            Memid += getRealUserId(MemIdArray[i]);
                        } else {
                            Memid += "," + getRealUserId(MemIdArray[i]);
                        }

                    }

                    var MemList = Memid.split(",");


                    for (var i = 0; i < MemList.length; i++) {
                        temp[MemList[i]] = true;
                    };

                    for (var i = 0; i < resourceids.length; i++) {
                        if (!temp[resourceids[i]]) {
                            temparray.push(resourceids[i]);
                        }
                    }

                    var memberids = "";
                    for (var i = 0; i < resourceids.length; i++) {
                        memberids += "," + getIMUserId(resourceids[i]);
                    }
                    memberids = memberids.substr(1);


                    var chattype = discussSetdiv.attr('chattype');
                    var memList = memberids.split(",");

                    if (temparray.length == 0) {
                        window.top.Dialog.alert("你所添加的成员已在群组中", function() {});
                        return;
                    }
                    
                    var Memids = "";
					for (var i = 0; i < temparray.length; i++){
						if (i == 0) {
                            Memids += getIMUserId(temparray[i]);
                        } else {
                            Memids += "," + getIMUserId(temparray[i]);
                        }
					} 
					
                    memList = [];
                    memList = Memids.split(",");
                    
                    DiscussUtil.checkMemCount(memList, discussid, function(isOver) {
                        //if(isOver){
                        //	showImAlert("超过"+DiscussUtil.settings.MAX_MEMS+"人的上限");
                        //	return;
                        //}else{
                        client.addMemberToDiscussion(discussid, memList, function() {
                            ChatUtil.refreshDiscussioinInfo(discussid, function(discuss) {
                                var memberids = discuss.getMemberIdList();
                                updateDiscussInfo(discussid);
                                //将改讨论组添加到被添加人员的通讯录中 1106 by wyw
                                IMUtil.addGroupBook(discussid, data.id, "add");
                            })
                        });
                        //}
                    });
                } else {}
            }
        },
		destroyDiscussion: function(discussid){
			this.quitFromDiscussion(discussid);
		},
		quitFromDiscussion: function(discussid){
            client.quitDiscussion(discussid,function(){
                if(!IS_BASE_ON_OPENFIRE){
                    //公有云维护最近回话列表
                    var targetid=discussid;
                    var targettype="1";
                    var senderid=M_USERID;
                    var senderInfo=getUserInfo(senderid);
                    var senderName=senderInfo.userName;
                    var msgcontent=senderName+":退出讨论组";
                    var sendtime=M_CURRENTTIME;
                    var targetname ='';
                    try{
                        targetname=discussList[discussid].getName();
                    }catch(err){
                        //没有获取到群组名称
                    }
                    var receiverids=ChatUtil.getMemberids(targettype,targetid,false);
                    var jsconverList = [{
                        "targetid": targetid,
                        "targettype": targettype,
                        "msgcontent": msgcontent,
                        "sendtime": sendtime,
                        "targetname":targetname,
                        "senderid":senderid,
                        "receiverids":receiverids
                    }];
                    ChatUtil.syncConversToLocal(jsconverList);
                };              
                //退群后续操作                
                ChatUtil.afterQuitOrOutDiscussion(discussid);
                //发送补偿退群消息
                var msgObj={"content":discussid,"objectName":"FW:SyncQuitGroup","targetType":"0"};
                client.sendIMMsg(M_USERID,msgObj,6);
            },function(err){
                //退群失败，或者是群组已经退掉了，但是没删除群聊列表
                ChatUtil.afterQuitOrOutDiscussion(discussid);
            });
        }
	},
	
	onDiscussRightClick:function(event, treeId, treeNode){
		$("ul.sf-menu").hide();
        $("#discussListNav").hide();
        var isopenfire = IS_BASE_ON_OPENFIRE?1:0;
        try{
        	var top1 = $("#pc-footertoolbar").offset().top;
        	var left1 = $("#pc-footertoolbar").offset().left+$("#pc-footertoolbar").width();
        }catch(err){
        	var top1 = $(".imRightdiv .rightNavdiv").offset().top;
        	var left1 = $(".imRightdiv .rightNavdiv").offset().left + $(".imRightdiv .dddiscussDiv").width() + $(".imRightdiv .rightNavdiv").width();
        }
        
        var top2 = event.clientY;      
        var left2 = event.clientX;
        var x = 0;
        var y = 0;
        if (top1 - top2 < (70 + 15)) {
            y = event.clientY - 70;
        } else {
            y = event.clientY + 15;
        }
        if (left1 - left2 < (140 + 15)) {
            x = event.clientX - 140;
        } else {
            x = event.clientX + 15;
        }
        if (treeNode.isParent) {
            //群聊分组操作    
            $("#discussListNav").css("left", x);
            $("#discussListNav").css("top", y);
            var name = treeNode.name;
            if (name == '我的群聊' || name == 'My Chat Group') {
                $("#discussListNav").css("height", "35px");
            } else {
                $("#discussListNav").css("height", "105px");
            }
            $("#discussListNav").find("li").each(function(index, obj) {
                $(obj).unbind('mouseenter').bind('mouseenter', function() {
                    var color = "#7bc5df";
                    if (from == 'pc') {
                        if (PcSysSettingUtils._configs.skin == 'default') {
                            color = "#7bc5df";
                        }
                        if (PcSysSettingUtils._configs.skin == 'yellow') {
                            color = "#d79a61";
                        }
                        if (PcSysSettingUtils._configs.skin == 'pink') {
                            color = "#f07994";
                        }
                        if (PcSysSettingUtils._configs.skin == 'green') {
                            color = "#48d08b";
                        }
                    } else {
                        color = "#7bc5df";
                    }
                    //$("#discussListNav ul.nav li a:hover").css("background", color);
					$(obj).find("a:hover").css("background", color);
					
                });
                $(obj).unbind('mouseleave').bind('mouseleave', function() {
                   // $("#discussListNav ul.nav li a").css("background", "white");
					$(obj).find("a").css("background", "white");
                });
                var target = $(obj).find("a").attr("_target");
                var objEvt = $._data($(obj)[0], "events");
            	  if(objEvt && objEvt["click"]) {
            		  $(obj).unbind('click');
            	  }              
                  if(target=='add'){ 
                    $(obj).unbind('click').bind('click', function() {
                    	  $("#discussListNav").hide();
                    	  	var max = treeNode.attr.max;
                    	  	if(max>=10){
                    	  		showImAlert(social_i18n('GroupSubTooMany'));
                    	  		return;
                    	  	}
                    	 if(ChatUtil.isFromPc()&&WindowDepartUtil.isAllowWinDepart()&&WindowDepartUtil.tabIsNull()){
                    	    var args = {
                                title : social_i18n('GroupSubAdd'),
                                width : 400,
                                height : 300
                            };
                            WindowDepartUtil.openNewWindow(args,WindowDepartUtil.NewWindowList.GroupSubAdd);    
                    	 }else{
                    	    var title=social_i18n('GroupSubAdd');
                            var url="/social/im/discussManage.jsp?operation=add&isopenfire="+isopenfire;
                            var diag=getSocialDialog(title,100,50);
                            diag.URL =url;
                            diag.show();
                            ChatUtil.cache.dialog = diag;
                            document.body.click(); 
                    	 }
                                                
                      });                      
                  }else if(target=='rename'){                      
                    $(obj).unbind('click').bind('click', function() {
                    	  $("#discussListNav").hide();
                    	  if(ChatUtil.isFromPc()&&WindowDepartUtil.isAllowWinDepart()&&WindowDepartUtil.tabIsNull()){
                            var args = {
                                'title' : social_i18n('Rename'),
                                'width' : 400,
                                'height' : 300,
                                'name': name
                            };
                            WindowDepartUtil.openNewWindow(args,WindowDepartUtil.NewWindowList.GroupSubRename);    
                         }else{
                          var title=social_i18n('Rename');
                          var url="/social/im/discussManage.jsp?operation=rename&orgname="+name+"&isopenfire="+isopenfire;
                          var diag=getSocialDialog(title,100,50);
                          diag.URL =url;
                          diag.show();
                          ChatUtil.cache.dialog = diag;
                          document.body.click(); 
                          }	  
                      });                      
                  }else if(target=='delete'){              
                    $(obj).unbind('click').bind('click', function() {
                    	  $("#discussListNav").hide();
                    	  var text = social_i18n('GroupSubDelConfirm');
                    	  if(ChatUtil.isFromPc()&&WindowDepartUtil.isAllowWinDepart()&&WindowDepartUtil.tabIsNull()){
                    	      //text = text + "|1";
                    	      //WindowDepartUtil.winDepartParm.deleteGroupName=name;
                    	      WindowDepartUtil.showNewClientComfirm("信息确认",text,function(){
	                              var url = "/social/im/SocialIMOperation.jsp?operation=deleteDiscussList&isopenfire="+isopenfire;
	                              $.post(url +"&name=" + name, function(data){
	                                  var message = $.trim(data);
	                                  if(message!=""){
	                                      showImAlert(message);
	                                  }                                
	                                  //刷新树
	                                  loadIMDataList("discuss");
	                              });                                            
                              });
                    	  }else{
                              showImConfirm(text,function(){
	                              var url = "/social/im/SocialIMOperation.jsp?operation=deleteDiscussList&isopenfire="+isopenfire;
	                              $.post(url +"&name=" + name, function(data){
	                            	  var message = $.trim(data);
	                            	  if(message!=""){
	                            		  showImAlert(message);
	                            	  }                                
	                                  //刷新树
	                                  loadIMDataList("discuss");
	                              });                                            
                              });
                          }
                      });
                }
            });
            setTimeout(function() { $("#discussListNav").show(); }, ChatUtil.discussMenuSet.onHideDelay);
            $("#discussListNav").bind('mouseleave', function() { setTimeout(function() { $("#discussListNav").hide(); }, ChatUtil.discussMenuSet.onHideDelay); });
          }else{
              //群组操作    
              var url = "/social/im/SocialIMOperation.jsp?operation=getSocialGroupList";
              var pNode = treeNode.getParentNode();
              var pName = pNode.name;
              
              $.post(url, function(data){
                  var ul = "<ul>";
                  var jsonGroup = eval("("+$.trim(data)+")");
                  var num = jsonGroup.length;
                  var all="";
                  var j = 0;
                  for(var i=0; i<jsonGroup.length; i++) {
                      var JsonName = jsonGroup[i].name;
                      if(languageid==="8"&&JsonName ==='我的群聊') JsonName= 'My Chat Group';
                      if(JsonName==pName)
                          continue;
                      var li = "<li><a href='#' _target='moveToGroup' id='"+jsonGroup[i].id+"' style='max-width:130px;white-space:nowrap;overflow:hidden;text-overflow:ellipsis' title='"+JsonName+"'>&nbsp;&nbsp;&nbsp;"+JsonName+"</a></li>";;
                      all=all+li;
                      j=j+1;
                  }
                  ul=ul+all;
                  ul=ul+"</ul>";
                  
                  $("ul.sf-menu").find("li.current").children("ul").remove();
                  if(all!=""){
                      $("ul.sf-menu").find("li.current").append(ul);
                  }          
                  
                  $("ul.sf-menu").superfish({
                       hoverClass:    'sfHover',  //当鼠标掠过时的class
                       pathClass:     'overideThisToUse', // 激活的菜单项的class
                       pathLevels:    2,       // 菜单级数
                    delay: ChatUtil.discussMenuSet.onHideDelay, // 下拉菜单在鼠标离开时自动隐藏时间。默认是800毫秒
                       animation:     {opacity:'show'},  // 动画效果，参考Jquery的动画jQuery’s .animate()
                       speed:         'normal',    // 动画速度， 参考Jquery的动画jQuery’s .animate()
                       dropShadows:   true,     // 阴影效果，关闭用‘false’
                    onInit: function() {
                        //console.log('onInit');
                        ChatUtil.discussMenuSet.SecTop = 0;
                        ChatUtil.discussMenuSet.ThirdTop = 0;
                        ChatUtil.discussMenuSet.FourTop = 0;
                        ChatUtil.discussMenuSet.isOnMoveToGroup = false;
                        ChatUtil.discussMenuSet.isOnMove = false;
                        ChatUtil.discussMenuSet.isOnQuit = false;
                        $("ul.sf-menu").find(".sf-sub-indicator").each(function(i, obj) {
                            $(obj).attr("style", "");
                        });
                    }, // 初始化的回调函数
                    onBeforeShow: function() {

                        if (ChatUtil.discussMenuSet.isOnMoveToGroup || ChatUtil.discussMenuSet.isOnQuit) {
                                return;
                        }
                        //console.log('onBeforeShow');
                        if (ChatUtil.discussMenuSet.isOnMove) {
                            var count = num;
                            var max = count * 35;
                            var top = $("ul.sf-menu").offset().top;
                            var top1;
                            if (from == 'pc') {
                                try{
									top1 = $("#pc-footertoolbar").offset().top;
								}catch(e){
									top1 = $(".imRightdiv .rightNavdiv").offset().top;
								}
                            } else {
                                top1 = 500;
                            }
                            if (parseInt(ChatUtil.discussMenuSet.SecTop) > 0) {
                                $(".sf-menu").css("top", ChatUtil.discussMenuSet.SecTop);
                            } else if (parseInt(ChatUtil.discussMenuSet.ThirdTop) > 0) {
                                $(".sf-menu").css("top", ChatUtil.discussMenuSet.FirstTop);
                            } else if (parseInt(ChatUtil.discussMenuSet.FourTop) > 0) {
                                $(".sf-menu").css("top", ChatUtil.discussMenuSet.SecTop);
                            } else {
                                if (top1 - top >= max) {
                                    //doAdd
                                } else {
                                    var setTop = parseInt(ChatUtil.discussMenuSet.FirstTop) - (parseInt(top) + parseInt(max) - parseInt(top1));
                                    $(".sf-menu").css("top", setTop);
                                    ChatUtil.discussMenuSet.SecTop = setTop;
                                }
                            }
                        }

                    }, // 子菜单显示前回调函数
                    onShow: function() {
                        //console.log('onShow');
                    }, // 子菜单显示时回调函数
                    onHide: function() {
                            if (ChatUtil.discussMenuSet.isOnMoveToGroup || ChatUtil.discussMenuSet.isOnMove) {
                                return;
                            }
                            if (ChatUtil.discussMenuSet.isOnQuit) {
                                if (parseInt(ChatUtil.discussMenuSet.SecTop) > 0) {
                                    var setTop = ChatUtil.discussMenuSet.SecTop + (num - 2) * 35;
                                    if (parseInt(ChatUtil.discussMenuSet.event.clientY) - parseInt(setTop) >= 70) {
                                        setTop = parseInt(ChatUtil.discussMenuSet.event.clientY) - 35;
                                    } else if (parseInt(ChatUtil.discussMenuSet.event.clientY) < parseInt(setTop)) {
                                        setTop = parseInt(ChatUtil.discussMenuSet.event.clientY) - 35;
                                    }
                                    $(".sf-menu").css("top", setTop);
                                    ChatUtil.discussMenuSet.FourTop = setTop;
                                } else {
                                    var setTop = ChatUtil.discussMenuSet.FirstTop + (num - 2) * 35;
                                    if(num==3){
                                        var setTop = ChatUtil.discussMenuSet.FirstTop + (num - 1) * 35;
                                    }
                                    if (parseInt(ChatUtil.discussMenuSet.event.clientY) - parseInt(setTop) >= 70) {
                                        setTop = parseInt(ChatUtil.discussMenuSet.event.clientY) - 35;
                                    } else if (parseInt(ChatUtil.discussMenuSet.event.clientY) < parseInt(setTop)) {
                                        setTop = parseInt(ChatUtil.discussMenuSet.event.clientY) - 35;
                                    }
                                    $(".sf-menu").css("top", setTop);
                                    ChatUtil.discussMenuSet.ThirdTop = setTop;
                                }
                            }
                            //console.log('onHide');
                        } // 子菜单隐藏时回调函数
                });

                $("ul.sf-menu").find("li").each(function(index, obj) {
                    var target = $(obj).find("a").attr("_target");
                    $(obj).find("a").unbind('mouseenter').bind('mouseenter', function(event) {
                        var color = "#7bc5df";
                        if (from == 'pc') {
                            if (PcSysSettingUtils._configs.skin == 'default') {
                                color = "#7bc5df";
                            }
                            if (PcSysSettingUtils._configs.skin == 'yellow') {
                                color = "#d79a61";
                            }
                            if (PcSysSettingUtils._configs.skin == 'pink') {
                                color = "#f07994";
                            }
                            if (PcSysSettingUtils._configs.skin == 'green') {
                                color = "#48d08b";
                            }
                        } else {
                            color = "#7bc5df";
                        }
                        $(this).css("background-color", color);
                        if ($(this).attr("_target") == 'move') {
                            //console.log(event);
                            ChatUtil.discussMenuSet.isOnMove = true;
                            ChatUtil.discussMenuSet.isOnQuit = false;
                            ChatUtil.discussMenuSet.isOnMoveToGroup = false;
                            ChatUtil.discussMenuSet.event = event;
                            // console.log('move');
                             $("ul.sf-menu").find(".sf-sub-indicator").each(function(i, obj) {
                                $(obj).attr("style", "background:url('/social/js/superfish/arrows2.png') no-repeat");
                            });
                        } else if ($(this).attr("_target") == 'quit') {
                            //console.log(event);
                            ChatUtil.discussMenuSet.isOnQuit = true;
                            ChatUtil.discussMenuSet.isOnMove = false;
                            ChatUtil.discussMenuSet.isOnMoveToGroup = false;
                            ChatUtil.discussMenuSet.event = event;
                            // console.log('quit');
                            $("ul.sf-menu").find(".sf-sub-indicator").each(function(i, obj) {
                                $(obj).attr("style", "background:url('/social/js/superfish/arrows1.png') no-repeat");
                            });
                        } else if ($(this).attr("_target") == 'moveToGroup') {
                            //console.log(event);
                            ChatUtil.discussMenuSet.isOnQuit = false;
                            ChatUtil.discussMenuSet.isOnMove = false;
                            ChatUtil.discussMenuSet.isOnMoveToGroup = true;
                            ChatUtil.discussMenuSet.event = event;
                            // console.log('moveToGroup');
                            $("ul.sf-menu").find(".sf-sub-indicator").each(function(i, obj) {
                                $(obj).attr("style", "background:url('/social/js/superfish/arrows2.png') no-repeat");
                            });
                        }
                    });
                    $(obj).find("a").unbind('mouseleave').bind('mouseleave', function(event) {
                        $(this).css("background-color", "white");
                    });

                    if (target == 'move') {
                        //superfish does
                    }
                    if (target == 'quit') {
                        $(obj).unbind().bind('click', function() {
                            $("ul.sf-menu").hide();
                            try {
                                var targetId = treeNode.attr[0].targetid;
                                var name = treeNode.name;
                                 var text =  social_i18n('GroupQuitConfirm')+"“"+name+"”";
                                 if(ChatUtil.isFromPc()&&WindowDepartUtil.isAllowWinDepart()){
                                    //text = text + "|6";
                                    //WindowDepartUtil.winDepartParm.deleteGroupName.targetId=targetId;
                                    WindowDepartUtil.showNewClientComfirm("信息确认",text, function() {
                                        var url = "/social/im/SocialIMOperation.jsp?operation=deleteDiscussRel";
                                        $.post(url + "&group_id=" + targetId, function(data) {
                                            loadIMDataList("discuss");
                                        });
                                    });
                                 }else{
	                                showImConfirm(text, function() {
	                                       DiscussUtil.DiscussSetFunc.quitFromDiscussion(targetId);
	                                });
                                 }
                            } catch (e) {
                                if(ChatUtil.isFromPc()&&WindowDepartUtil.isAllowWinDepart()){
                                    WindowDepartUtil.showNewClientComfirm("信息确认",social_i18n('GroupQuitConfirm'),function() {
                                        var url = "/social/im/SocialIMOperation.jsp?operation=deleteDiscussRel";
                                        $.post(url + "&group_id=" + targetId, function(data) {
                                            loadIMDataList("discuss");
                                        });
                                    });
                                }else{
                                    showImConfirm(social_i18n('GroupQuitConfirm'), function() {
	                                    var url = "/social/im/SocialIMOperation.jsp?operation=deleteDiscussRel";
	                                    $.post(url + "&group_id=" + targetId, function(data) {
	                                        loadIMDataList("discuss");
	                                    });
                                    });
                                }
                            }
                        });
                    }
                    if (target == 'moveToGroup') {
                        $(obj).unbind('click').bind('click', function() {
                            $("ul.sf-menu").hide();
                            var name = treeNode.name;
                            var groupName = $(obj).find("a").attr("title");
                            var id = $(obj).find("a").attr("id");
                            var pNode = treeNode.getParentNode();
                            var pName = pNode.name;
                            var rel_id = treeNode.attr[0].rel_id;
                            var group_id = treeNode.attr[0].targetid;
                            var text = social_i18n('MoveToGroupTip', "“"+name+"”", "“"+groupName+"”");
                            if(ChatUtil.isFromPc()&&WindowDepartUtil.isAllowWinDepart()){
                                //WindowDepartUtil.winDepartParm.moveToGroup.id = id;
                                //WindowDepartUtil.winDepartParm.moveToGroup.groupName = groupName;
                                //WindowDepartUtil.winDepartParm.moveToGroup.rel_id = rel_id;
                                //WindowDepartUtil.winDepartParm.moveToGroup.group_id = group_id;
                                //text = social_i18n('MoveToGroupTip', "“"+name+"”", "“"+groupName+"”") +"|5";
                                WindowDepartUtil.showNewClientComfirm("信息确认",text,function() {
                                var url = "/social/im/SocialIMOperation.jsp?operation=changeGroupList";
                                $.post(url + "&id=" + id + "&groupName=" + groupName + "&rel_id=" + rel_id + "&group_id=" + group_id, function(data) {
                                    var message = $.trim(data);
                                    loadIMDataList("discuss");
                                    if (message != "") {
                                        showImAlert(message);
                                    }
                                    });
                                });
                            }else{
                            showImConfirm(text, function() {
                                var url = "/social/im/SocialIMOperation.jsp?operation=changeGroupList";
                                $.post(url + "&id=" + id + "&groupName=" + groupName + "&rel_id=" + rel_id + "&group_id=" + group_id, function(data) {
                                    var message = $.trim(data);
                                    loadIMDataList("discuss");
                                    if (message != "") {
                                        showImAlert(message);
                                    }
                                });
                            });
                            }
                        });
                    }
                });

                $("ul.sf-menu").bind('mouseleave', function() { setTimeout(function() { $("ul.sf-menu").hide(); }, ChatUtil.discussMenuSet.onHideDelay); });
                $("ul.sf-menu").css("left", x);
                $("ul.sf-menu").css("top", y);
                ChatUtil.discussMenuSet.FirstTop = y;
                setTimeout(function() { $("ul.sf-menu").show(); }, ChatUtil.discussMenuSet.onHideDelay);
            });
        }
    },

    onDiscussClick: function(event, treeId, treeNode) {
        $("#discussListNav").hide();
        $("ul.sf-menu").hide();
        if (!treeNode.isParent) {
            var targetId = treeNode.attr[0].targetid;
            var targetName = treeNode.name;
            var targetType = treeNode.attr[0].targetType;
            var targetHead = treeNode.icon;
            //打开群聊
            showConverChatpanel(null, {
                "targetId": targetId,
                "targetName": targetName,
                "targetType": targetType,
                "targetHead": targetHead
            });
            $("#discussListdiv").perfectScrollbar();
        } else {
            var zTree = $.fn.zTree.getZTreeObj(treeId);
            if (treeNode.attr.hasNoChildren) {
                zTree.expandNode(null);
                //showImAlert("该分组下没有群聊");
            } else {
                zTree.expandNode(treeNode);
            }
            $("#discussListdiv").perfectScrollbar();

        }
    },
    getDiscussAsyncUrl: function() {
        var isopenfire = IS_BASE_ON_OPENFIRE ? 1 : 0;
        return "/social/im/SocialIMOperation.jsp?operation=getDiscussGroup&isopenfire=" + isopenfire;
    },

    onAsyncSuccess: function(event, treeId) {
        var treeObj = $.fn.zTree.getZTreeObj(treeId);
        var nodes = treeObj.getNodes();
        for (var i = 0; i < nodes.length; i++) {
            if (nodes[i].attr.hasNoChildren) {
                nodes[i].children = {};
                $(nodes[i].tid).children = null;
            }
        }
    },

	//更多按钮
	doMore: function(discussid) {
		var url=getPostUrl('/systeminfo/BrowserMain.jsp?url=/social/im/SocialIMDiscussHrmList.jsp?discussid=' + discussid);
		__browserNamespace__.showModalDialogForBrowser(event,
			 url, '#','resourceid',false,1,'',
			{name:'resourceBrowser',hasInput:false,zDialog:true,needHidden:true,dialogTitle:social_i18n('GroupMM'),arguments:'',
			_callback:DiscussUtil.doMoreCallback});
	},
	doMoreCallback: function(res){
		ChatUtil.cache.dialog = null;
	},
	//查看详情
	showMemberDetails:function(e){
		var discussid = $('.imDiscussSetting').attr('discussid');
		DiscussUtil.showMoreMember(discussid);
	},
	// 添加到私人组
	addToPrivateGroup: function(obj){
		var discussid = $('.imDiscussSetting').attr('discussid');
		if(discussid){
			ChatUtil.getDiscussionInfo(discussid, false, function(discuss){
				if(discuss){
					var memberIdList = discuss.getMemberIdList();
					HrmGroupUtil.doAdd(memberIdList, 'privateGroup');
				}
			});
		}
	},
	showMoreMember:function(discussid){
		var title=social_i18n('GroupMM');
		var discuss=discussList[discussid];
		var discussName=discuss.getName();
		var creatorid=discuss.getCreatorId();
		if(creatorid==undefined||creatorid==''){
			creatorid = $("#conversation_"+discussid).attr("_senderid") + '|' + M_UDID;
		}
	    var url=getPostUrl("/social/im/SocialIMDiscussHrmList.jsp?discussid="+discussid+"&discussName="+discussName+"&creatorid="+creatorid+"&IS_BASE_ON_OPENFIRE="+IS_BASE_ON_OPENFIRE+"&isdisableadduser="+DiscussUtil.isDisableAddUser(discussid));
		var diag=getSocialDialog(title,600,530);
		diag.URL =encodeURI(url);
		diag.show();
		diag.callbackfunc4CloseBtn = DiscussUtil.doMoreCallback;
		ChatUtil.cache.dialog = diag;
		//document.body.click();
	},
	//发起群聊
	addDiscuss: function(event,selectedids){
	if(ChatUtil.isFromPc()&&WindowDepartUtil.isAllowWinDepart()&&WindowDepartUtil.tabIsNull()){
        var height = 0;
        if(PcMainUtils.platform.OSX){
            height = 588; 
        }
        if(PcMainUtils.platform.Windows){
            height =565; 
        }
        var args = {
           title : social_i18n("Member"),
           width : 680,
           height : height
        };
        WindowDepartUtil.openNewWindow(args,WindowDepartUtil.NewWindowList.AddGroup);
    }else{
		if(!selectedids)
			selectedids = "";
            
        // pc端对拖拽特殊处理
        if(typeof from != 'undefined' && from == 'pc') {
            DragUtils.closeDrags();
        }
            
		__browserNamespace__.showModalDialogForBrowser(event,'/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?' +
				'selectedids='+selectedids,'#','resourceid',false,1,'',
		{
			name:'resourceBrowser',
			hasInput:false,
			zDialog:true,
			needHidden:true,
			dialogTitle: social_i18n("Member"),
			arguments:'',
			_callback:DiscussUtil.addDiscussCallback
		});
        
        // pc端对拖拽特殊处理
        if(typeof from != 'undefined' && from == 'pc') {
            browserDialog.closeHandle = function(){
                browserDialog.closeHandle = null;
                DragUtils.restoreDrags();
            };
        }
    }
	},
	_addDiscuss: function(disName,resourceids,memList,callback) {
							
		if(!memList || memList.length <= 0) {
			showImAlert(social_i18n('GroupAddFail'));
			if(typeof callback === 'function'){
				callback(targetId, disName);
			}
			return;
		}
		DiscussUtil.checkMemCount(memList, null, function(isOver){
			if(isOver){
				showImAlert(social_i18n('Exceed',DiscussUtil.settings.MAX_MEMS));
				return;
			}else{
				IMUtil.doHideSlideDiv(document);
				RongIMClient.getInstance().createDiscussion(disName,
					memList,{
					 onSuccess:function(targetId){
					 	
							try
							{
								if (typeof(eval(parent.shareFilesAndFolders)) == "function") {
									var __targetObjQueue = new Array();
									__targetObjQueue.push({"targetId":targetId, "targetType":"2"});
									parent.shareFilesAndFolders(__targetObjQueue);
									if(typeof callback === 'function'){
										callback(targetId, disName);
									}
								}
							}
							catch(exception)
							{
								
							}
							
								 if(IS_BASE_ON_OPENFIRE){
		 								IMUtil.addConversation(targetId, disName);	
		 						}													
								setTimeout(function(){
										
										ChatUtil.getDiscussionInfo(targetId, true, function(discuss){
											if(discuss){
												resourceids=resourceids+","+M_USERID;
												var resourceLength=resourceids.split(",").length;
												var memberLength=ChatUtil.getMemberids("1",targetId,true).split(",").length;
												//client.error("resourceLength："+resourceLength+" memberLength：" + memberLength+" getMemberids:"+ChatUtil.getMemberids("1",targetId,true));
												if(memberLength==resourceLength){
													
													 //保存到通讯录
												 	IMUtil.addGroupBook(targetId,resourceids,"add");
												 	 //保存到缓存数组
												 	ChatUtil.refreshDiscussioinInfo(targetId, ChatUtil.setDisMemberInfo);
												 	client.writeLog("群组："+disName+" 创建成功 targetId：" + targetId);
												 	
												}else{
													client.writeLog("讨论组创建失败 targetName：" + disName);
									 	 			// showImAlert(social_i18n('GroupAddFail'));
												}
											
										 	 	showIMChatpanel(1,targetId,disName,'/social/images/head_group.png');
										 	 	//loadIMDataList("discuss");
										 	 	//快速部署版保存到最近
											 	if(versionTag == "rdeploy"){
											 		$("conversation_"+targetId).click();
											 	}
											 	//创建讨论组成功后的操作
											 	if(typeof callback === 'function'){
											 		callback(targetId, disName);
											 	}
											}
									});	 	
									 	
								},1500);
					 	 
					 },onError:function(err){
					 	 client.writeLog("讨论组创建失败 targetName：" + disName);
					 	 showImAlert(social_i18n('GroupAddFail'));
					     client.writeLog("err:>>" + err);
					 }
					});
			}
		});
	},
	addDiscussCallback: function(event,data,name,oldid){
		if (data!=null){
       		if (data.id!= ""){
				var memberids="";
				var memberidsArray = new Array();
        		var discussName="";
        		var resourceids="";
				var ids = data.id.split(",");
				var namesArray= new Array();
				for(var i=ids.length-1;i>=0;i--){
					var idsTemp = ids[i];
					if(idsTemp==M_USERID) continue;
					if(ClientSet.multiAccountMsg==1){
						var parentAccountid = AccountUtil.accountBelongTO[idsTemp];
						if(typeof parentAccountid !="undefined"){
							ids.splice(i, 1,parentAccountid);
							idsTemp = parentAccountid;	
						}
					}					
					memberidsArray.push(getIMUserId(idsTemp));
	        	}
				ids = IMUtil.unique(ids);
				ids = IMUtil.removeArray(ids,M_USERID);
				memberidsArray = IMUtil.unique(memberidsArray);
				memberidsArray = IMUtil.removeArray(memberidsArray,getIMUserId(M_USERID));
				for(var i = 0; i<ids.length&& namesArray.length <3 ;i++){
					var _nameTemp  =  getUserInfo(ids[i]).userName;
					if(_nameTemp){
						namesArray.push(_nameTemp);
					}
				}
				memberids = memberidsArray.join(",");
				resourceids = ids.join(",");
	        	discussName=namesArray.join(",");
	        	//人数不符合要求
	        	if(memberids == ''){
	        		showImAlert("人员数目不符合要求");
	        		return;
	        	}
	        	var memberidList = memberids.split(",");
	        	//只有一个人的情况下直接打开单聊窗口
	        	if(memberidList.length == 1){
	        		var targetId = getRealUserId(memberidList[0]);
	        		var targetName = userInfos[targetId].userName;
	        		var targetType = "0";
	        		var targetHead = userInfos[targetId].userHead;
	        		showConverChatpanel(null, {
	        			"targetId": targetId,
	        			"targetName": targetName,
	        			"targetType": targetType,
	        			"targetHead": targetHead
 	        		});
	        		return;
	        	}
				DiscussUtil._addDiscuss(discussName,resourceids,memberidList);
				
        	}else{
        		showImAlert("请选择群成员");	
        	}
		}
	},
	//检查讨论组人数上限
	checkMemCount: function(memList, discussid, callback){
		if(memList && (memList instanceof Array || typeof memList == 'object')){
			var max = DiscussUtil.settings.MAX_MEMS;
			var attachsize = memList.length;
			var memsize = 0;
			if(discussid){
				ChatUtil.getDiscussionInfo(discussid, false, function(discuss){
					if(discuss){
						memsize = discuss.getMemberIdList().length;
					}
					callback(memsize + attachsize > max);
				});
			}else{
				callback(attachsize > max);
			}
		}else
			callback(0);
	},
	//跳转到指定的聊天窗口的tab
	jumpToTab: function(obj, _target) {
		var chatdiv = $(obj).parents('.chatdiv')[0];
		var chattop = $(chatdiv).find('.chattop');
		chattop.find('div[_target=' + _target + ']').click();
	},
	//显示公告编辑框
	showNote: function(obj){
		var chatdiv=ChatUtil.getchatdiv(obj);
		var className = $(obj).attr('class');
		var pa = $(obj).parents('.note-editor');
		if(className == 'noteEdit'){
			chatdiv.find(".note-editor").show();
			var editor = chatdiv.find(".gg_edit_area");
			editor.focus();
			//适应编辑器高度
			if(editor[0].value == ''){
				editor.height(100);
			}
			$(obj).hide();
		}else if(className != 'note-editor' && pa && pa.length <= 0 
			&& chatdiv.find('.note-editor').is(':visible') 
			&& chatdiv.find(".gg_edit_area").text() == ''){
			chatdiv.find(".noteEdit").show();
			chatdiv.find('.note-editor').hide();
		}
	},
	//取消发布公告
	cancelRelease: function(obj, flush) {
		var chatdiv = ChatUtil.getchatdiv(obj);
		if(!chatdiv || chatdiv.length == 0){
			return;
		}
		var noteEdit_act = $(chatdiv).find(".note-editor");
		var noteEdit = $(chatdiv).find(".noteEdit");
		var noteEditor = noteEdit_act.find('.gg_edit_area');
		if(flush){
			noteEditor.html("");
			//textarea
			noteEditor[0].value = "";
		}else{
			var curEditText = $.trim(noteEditor[0].value);
			if(curEditText != ''){
				//noteEdit.text(curEditText);
				return;
			}else{
				noteEdit.text("请输入公告内容");
			}
		}
		noteEdit_act.hide();
		noteEdit.show();
		noteEdit_act.css('min-height','85px');
		noteEdit_act.perfectScrollbar('update');
		
	},
	//发布公告
	releaseNote: function(obj) {
		var chatdiv = $(obj).parents(".chatdiv")[0];
		var noteEdit_act = $(obj).parents(".note-editor:first");
		var contentobj = noteEdit_act.find('.gg_edit_area');
		var content =contentobj[0].value;
		var ecodedContent=IMUtil.htmlEncode(content);
		var textContent=content;
		var acceptId = noteEdit_act.attr("_acceptid");
		
		//这里要刷新历史公告列表
		var senderid = noteEdit_act.attr("_senderid");
		var sendername = noteEdit_act.attr("_sendername");
		var noteid = noteEdit_act.attr("_noteid");
		
		if('' == $.trim(content)){
			contentobj.focus();
			return;	
		}else{
			if(!checkWordLen(content)){
				return;
			}
		}
		var url=getPostUrl("/social/im/SocialIMOperation.jsp?operation=insertnote");
		$.post(url +
				"&senderid=" + senderid + "&acceptid=" + acceptId,{"content" : content}, function(json){
					var res = $.parseJSON(json);
					var noteId = res.noteId;
					// DiscussUtil.prependNote(chatdiv, noteId, ecodedContent, senderid, sendername, res.creDate, 1);
					//以消息的形式发送
					var data={"htmlContent":ecodedContent,"textContent":textContent, "objectName":"RC:PublicNoticeMsg","noteId": noteId}
					ChatUtil.sendIMMsgAuto(chatdiv, 6,data);
					//收缩编辑区域
					DiscussUtil.cancelRelease(obj,true);
					var chatWinid="chatWin_1_"+acceptId;
					var chatwin = $("#"+chatWinid);
					chatwin.find('.imnote').click();
		});
	},
	//插入
	prependNote: function(chatdiv, noteId, content, senderId, senderName, creDate, hasOpRight){
		var oDiv = $(chatdiv).find('.note-track');
		var tempdiv = DiscussUtil.getNoteDiv(noteId, IMUtil.htmlEncode(content), senderId, senderName, creDate,hasOpRight);
		oDiv.prepend(tempdiv);
	},
	//管理员或创建者编辑公告
	editNote: function(oTarget) {
		var noteItem = $(oTarget).parents('.note_item_split')[0];
		var content = $(noteItem).find('.note-content-pane').html();
		var noteList = $(noteItem).parents('.noteList')[0];
		$(noteList).find(".note-editor").show().focus();
		$(noteList).find(".noteEdit").hide();
		$(noteList).find('.gg_edit_area').html(content).focus();
		var noteEditdiv = $(noteList).find('.note-editor');
		//绑定参数
		var noteid = $(noteItem).attr('_noteid');
		var senderid = $(noteItem).find('.senderid').val();
		var sendername = $(noteItem).find('span.sendername').text();
		$(noteEditdiv).attr("_noteid", noteid);
		$(noteEditdiv).attr("_senderid", senderid);
		$(noteEditdiv).attr("_sendername", sendername);
		stopEvent();
	},
	//管理员或创建者删除公告
	delNote: function(oTarget) {
		window.top.Dialog.confirm("确定删除当前公告？",function(){
			client.writeLog(oTarget);
			var noteItem = $(oTarget).parents('.note_item_split')[0];
			var noteId = $(noteItem).attr('_noteid');
			client.writeLog("noteId", noteId);
			var url=getPostUrl("/social/im/SocialIMOperation.jsp?operation=deletenote");
			$.post(url +
					"&noteId=" + noteId, function(flag){
						client.writeLog(flag);
						if(!$.trim(flag)){
							showImAlert("删除失败");
							return;
						}
						//刷新列表
						$(noteItem).remove();
					});
		});
	},
	//获取Item的div
	getNoteDiv: function(noteId, content, senderId, senderName, senderDate,hasOpRight) {
		content = IMUtil.httpHtml(content);
		var tempdiv=$("<div class='note_item_split'>"+$('#noteitemdivmode').clone().html()+"</div>");
		tempdiv.attr('_noteid', noteId);
		tempdiv.find('.note-content-pane').html(content);
		tempdiv.find('.bottom-right-sender span:eq(0)').text(senderName);
		tempdiv.find('.bottom-right-sender span:eq(1)').text(senderDate);
		tempdiv.find('.bottom-right-sender .senderid').val(senderId);
		
		if(hasOpRight=="0"){
			tempdiv.find('.bottom-left-control').empty();
		}	
		return tempdiv;
	},
	//获取历史公告
	getHistoryNotes: function(obj){
		client.writeLog("==获取历史公告==");
		var chatdiv = ChatUtil.getchatdiv(obj);
		var noteEdit_act = $(chatdiv).find(".note-editor");
		var acceptId = noteEdit_act.attr("_acceptid");
		var url=getPostUrl("/social/im/SocialIMOperation.jsp?operation=getnotelist");
		$.post(url+"&acceptid=" + acceptId, function(json){
					json = $.parseJSON(json);
					json = json.res;
					//添加数据到Item
					var oDiv = $(chatdiv).find('.note-track');
					oDiv.empty();
					//oDiv.perfectScrollbar();//滚动条会叠加
					for(var i = 0; i < json.length; ++i){
						var noteId	   = json[i].noteId;
						var content    = ChatUtil.receiveMsgFormate(json[i].content);
						var senderId   = json[i].senderId;
						var senderName = json[i].senderName;
						var senderDate = json[i].creDate;
						var targetId   = json[i].targetId;
						var hasOpRight = json[i].hasOpRight;
						var tempdiv = DiscussUtil.getNoteDiv(noteId, IMUtil.htmlEncode(content), senderId, senderName, senderDate,hasOpRight);
						oDiv.append(tempdiv);
					}
				});
	},
	openVotePanel:function(obj){
		var chatdiv = ChatUtil.getchatdiv(obj);
		var group_id = ChatUtil.getCurChatwin().attr('_targetid');
		var votediv = $(chatdiv).find(".emessgevoteList");
		var url=getPostUrl("/voting/groupchatvote/VotingShow.jsp?groupid="+group_id+"&skin="+docUtil.skin()+"#/votelist");
		votediv.css('height','100%').html("<iframe name='vote_"+group_id+"' frameborder='0' src='"+url+"' width='100%' height='100%' overflow-x='hidden'></iframe>").show();
  	},
	//绑定编辑自动收缩
	bindEscape: function(chatdiv) {
		$(chatdiv).find('.noteEdit').bind('click', function(e){
			return false;
		});
		$('body').bind('click.noteedit', function(e){
			e = window.event || e;
			var obj = $(e.srcElement || e.target);
			DiscussUtil.showNote(obj);
		});
	},
	//获取文件列表
	getIMFileList:function(obj,targetid,targetType,pageno, pagesize, flush){
		var chatdiv=ChatUtil.getchatdiv(obj);
		if(!obj && chatdiv.length == 0){
			chatdiv=$("#chatWin_"+targetType+"_"+targetId).find(".chatdiv");
		}
		var acclist=chatdiv.find(".acclist");
		if(flush){
			acclist.html("");
			acclist.attr('filecount', '0')
		}
		var senderid = getRealUserId(M_USERID);
		var keyword = chatdiv.find(".fileList input.keyword").val();
		var data = {};
		data['targetid'] = targetid;
		data['targetType'] = targetType;
		data['keyword'] = encodeURI($.trim(keyword));
		data['pageno'] = pageno;
		data['pagesize'] = pagesize;
		var url=getPostUrl("/social/im/SocialIMOperation.jsp?operation=getIMFileList");
		IMUtil.showLoading(acclist,ChatUtil.settings.mystyle,ChatUtil.settings.gif,2000,function(){
			IMUtil.shutLoading();
			acclist.removeAttr('loading');
		});
		$.post(url,data,function(data){
			acclist.attr("pageno", data.pageno);
			acclist.attr("hasnext", data.hasnext);
			acclist.attr("filecount", acclist.attr('filecount')?parseInt(acclist.attr('filecount')) + parseInt(data.fileCount):data.fileCount);
			
			var fileList=data.fileList;
			var fileCount=data.fileCount;
			if(acclist.attr("filecount") == '0'){
				chatdiv.find(".fileCount").html(social_i18n('AccTip'));
			}else{
				chatdiv.find(".fileCount").html("("+acclist.attr("filecount")+")");
			}
			
			if(fileCount==0 && fileList.length <= 0 && flush){
				$("<div class='accNoneBg'></div>").appendTo(acclist);
				$("<div class='accNoneCap'>"+social_i18n('AccTip1')+"</div>").appendTo(acclist);
			} else {
				var bg = acclist.find('.accNoneBg');
				var cap = acclist.find('.accNoneCap');
				bg.remove();
				cap.remove();
				for(var i=0;i<fileList.length;i++){
					
					var fileItem=fileList[i];
					var fileid=fileItem.fileid;
					var filetype=fileItem.fileType;
					var fileName=fileItem.fileName;
					var fileSize=getSizeFormate(fileItem.fileSize);
					var userName=fileItem.userName;
					var createdate=fileItem.createdate;
					var fileIcon=getFileIcon(fileName);
					
					var fileItemdiv=$("#accFileItemTemp").clone().attr("id","").show();
					fileItemdiv.find(".fileName").html(IMUtil.htmlEncode(fileName));
					fileItemdiv.find(".fileName").attr("title",IMUtil.htmlEncode(fileName));
					fileItemdiv.find(".fileName").parent().attr("style","text-overflow: ellipsis;white-space: nowrap;overflow: hidden;max-width:480px");
					fileItemdiv.find(".fileSize").html(fileSize);
					fileItemdiv.find(".accicon").css({"background-image":"url("+fileIcon+")"});
					fileItemdiv.find(".senderName").html(userName+"&nbsp;&nbsp;"+createdate);
					fileItemdiv.find(".opdiv").attr("_fileId",fileid).attr("_fileName",fileName);
					fileItemdiv.attr("_fileid", fileid);
					fileItemdiv.attr("_filetype", filetype.toLowerCase());
					if(targetType == 0 && fileItem.userid != M_USERID){
						fileItemdiv.find('.imDelete').remove();
					}else if(targetType == 1){
						DiscussUtil.checkDisRight(targetid, function(hasRight){
							if(!hasRight && fileItem.userid != M_USERID){
								fileItemdiv.find('.imDelete').remove();
							}
						});
					}
					acclist.append(fileItemdiv);
				}
				acclist.find(".accitem").hover(
					function(event){
		  				$(this).find(".download").show(); 
					},function(){
			  			$(this).find(".download").hide(); 
					}
				)
			}
			acclist.removeAttr("loading");
			IMUtil.shutLoading();
		},"json");
	},
	//判断是否是创建人
	isDiscussCreator: function(userid, discussid){
		if(userid == '1') return true;
		var discuss=discussList[discussid];
		var creatorid = getRealUserId(discuss.getCreatorId());
		return creatorid == userid;
	},
	//判断是否含有讨论组权限
	checkDisRight: function(discussid, callback){
		var hasRight = false;
		ChatUtil.getDiscussionInfo(discussid, false, function(discuss){
			if(!!discuss){
				var creatorid = getRealUserId(discuss.getCreatorId());
				if(creatorid == M_USERID){
					hasRight = true;
				}
				callback(hasRight);
			}else{
				callback(false);
			}
		});
	},
    //群是否禁用添加群成员
    isDisableAddUser : function (discussid,callback) {
        var flag  = false ;
        if(!IS_BASE_ON_OPENFIRE){return false;}
        var discuss = discussList[discussid];
        if(discuss && discuss.isDisableAddUser && discuss.isDisableAddUser()){
            flag = true ;
        }
        return flag;
    }
};

// 处理字体设置
var FontUtils = {
	getFontBox: function(obj, targetId){
		var $obj = $(obj);
		if(obj) obj = $(obj);
		else if(targetId) return $("#fontBox_"+targetId);
		var fb = obj.find('.fontBox');
		if(fb.length > 0) return fb;
		fb = obj.closest('.fontBox');
		if(fb.length >0 ) return fb;
		else return null;
	},
	getColorPickPane: function(obj, targetId){
		return this.getFontBox(obj, targetId).find(".color_pick_pane");
	},
	defaults: {
		fontsize: 12,
		bubblecolor: 'color_default'
	},
	isSetted: false,
	showFontBox: function(obj) {
	 	var _self = this;
	 	var $fb = $(obj).find('.fontBox');
	 	var active = $fb.data('active');
	 	$fb.data('active', !active);
	 	var bubblecolor = WebAndpcConfig.bubblecolor;
		var fontsize = WebAndpcConfig.fontsize;
 		$fb.css('display', !active?'block':'none');
 		if(active) $fb.parent().removeClass('chatapp_active');
 		else $fb.parent().addClass('chatapp_active');
 		$fb.find(".fs_selector").val(fontsize);
		_self.setPickedColor($fb, bubblecolor, _self.initData.colors[bubblecolor]);
		this.getColorPickPane(obj).hide();
	},
	showColorPickPane: function(obj) {
		var fontBox = this.getFontBox(obj);
		var colorPickPane = this.getColorPickPane(obj);
		colorPickPane.toggle();
	},
	cache: {
		org_color: null
	},
	initData: {
		colors: {
			'color_blue':      'ColorLightBlue',
			'color_green':    'ColorLightGreen',
			'color_orange':  'ColorYellow',
			'color_red':        'ColorLightRed',
			'color_pink': 	    'ColorPink',
			'color_purple':   'ColorPurple',
			'color_default':   'Default'
		},
		fontsize: [9,10,11,12,13,14,15,16,17,18,19,20,21,22],
		palette: [
                ["#ECEFF6", "#BDCCF5", "#FED2EB", "#FFC8D1", "#FFE49D", "#E4F2D9", "#D8F2F1", "#efefef", "#f3f3f3", "#f6f6f6"],
                ["#980000", "#ff0000", "#ff9900", "#ffff00", "#00ff00", "#00ffff", "#4a86e8", "#0000ff", "#9900ff", "#ff00ff"],
                ["#e6b8af", "#f4cccc", "#fce5cd", "#fff2cc", "#ecead3", "#d9ead3", "#c9daf8", "#cfe2f3", "#d9d2e9", "#ead1dc"],
                ["#dd7e6b", "#ea9999", "#f9cb9c", "#ffe599", "#b6d7a8", "#a2c4c9", "#a4c2f4", "#9fc5e8", "#b4a7d6", "#d5a6bd"],
                ["#cc4125", "#e06666", "#f6b26b", "#ffd966", "#93c47d", "#76a5af", "#6d9eeb", "#6fa8dc", "#8e7cc3", "#c27ba0"],
                ["#a61c00", "#cc0000", "#e69138", "#f1c232", "#6aa84f", "#45818e", "#3c78d8", "#3d85c6", "#674ea7", "#a64d79"],
                ["#85200c", "#990000", "#b45f06", "#bf9000", "#38761d", "#134f5c", "#1155cc", "#0b5394", "#351c75", "#741b47"],
                ["#5b0f00", "#660000", "#783f04", "#7f6000", "#274e13", "#0c343d", "#1c4587", "#073763", "#20124d", "#4c1130"]
         ],
         color_index: {
         	'color_blue':      6,
			'color_green':    5,
			'color_orange':  4,
			'color_red':        3,
			'color_pink': 	    2,
			'color_purple':   1,
			'color_default':   0
         },
         color_hex: {
         	'color_blue':      '#D8F2F1',
			'color_green':    '#E4F2D9',
			'color_orange':  '#FFE49D',
			'color_red':        '#FFC8D1',
			'color_pink': 	    '#FED2EB',
			'color_purple':   '#BDCCF5',
			'color_default':   '#87E2F2'
         }
	},
	init: function(targetId) {
		var _self = this;
		var pickColors = this.initData.colors;
		var fontsizes = this.initData.fontsize;
		var fontBox = this.getFontBox(null, targetId);
		var colorPickPane = this.getColorPickPane(null, targetId);
		$.each(pickColors, function(color_cls, color_title){
			var colorBox = $("<span data-cls='"+color_cls+
					"' class='btn_color_pick "+color_cls+
					"' onclick='FontUtils.pickColor(this);'>"+social_i18n(color_title)+
					"</span>");
			colorPickPane.find('.rec_color').prepend(colorBox);
		});
		
		var selector = fontBox.find(".fs_selector");
		fontsizes.forEach(function(size){
			selector.append("<option value='"+size+"'>"+size+"</option>");
		});
		// 设置默认值
		var bubblecolor = FontUtils.defaults.bubblecolor;
		var fontsize = FontUtils.defaults.fontsize;
		if(typeof WebAndpcConfig !== 'undefined') {
			if(typeof WebAndpcConfig.bubblecolor !== 'undefined') {
				bubblecolor = WebAndpcConfig.bubblecolor;
				this.isSetted = true;
			}
			if(typeof WebAndpcConfig.fontsize !== 'undefined') {
				fontsize = WebAndpcConfig.fontsize;
			}
			WebAndpcConfig.bubblecolor = bubblecolor;
			WebAndpcConfig.fontsize = fontsize;
		}
		selector.val(fontsize);
		fontBox.find("input[name='bubblecolor']").val(bubblecolor);
		var index = _self.initData.color_index[bubblecolor];
		if(typeof index === 'undefined') index = 0;
		// 初始化取色器
		colorPickPane.find('.btn_spec').spectrum({
			color: _self.initData.palette[0][index],
            showPalette:true,
            clickoutFiresChange: false,
            chooseText: social_i18n('Confirm'),
            cancelText: social_i18n('Cancel'),
            showInput:true,
            preferredFormat:"hex",
            palette: _self.initData.palette,
            show :function (color){
            	_self.cache.org_color = color.toHexString();
            },
            change:function(color){
            	var color = color.toHexString();
            	_self.setPickedColor(fontBox, color, color);
            },
            move:function(color){
            	var color = color.toHexString();
            	_self.setPickedColor(fontBox, color, color);
            },
            hide: function(color) {
            	color = color.toHexString();
            	if(color == _self.cache.org_color){
            		// _self.setPickedColor(fontBox, color, color);
            	}else{
            		_self.showColorPickPane(fontBox);
            	}
			}
        });
		this.setPickedColor(fontBox, bubblecolor, 
			bubblecolor.indexOf("#") == 0? bubblecolor:pickColors[bubblecolor]);
		this.updatePage();
		/*
		// 关闭所有设置栏
		this.active = false;
		$('.fontBox').each(function(i, fb){
	 		var $fb = $(fb);
	 		$fb.css('display', 'none').parent().removeClass('chatapp_active');
	 	});
	 	*/
	 	
	},
	updateSet: function(setobj){
		var _self = this;
		var fontsize = setobj.fontsize;
		var bubblecolor =setobj.bubblecolor;
		$('.fontBox').each(function(i, fb){
			var $fb = $(fb);
			if(bubblecolor){
				_self.setPickedColor(fb, bubblecolor, _self.initData.colors[bubblecolor]);
			}
			if(fontsize){
				$fb.find(".fs_selector").val(fontsize);
			}
		});
	},
	setPickedColor: function(obj, color_cls, color_title){
		// 转换为对应语言
		if (color_title && color_title.indexOf('#') == -1) {
			color_title = social_i18n(color_title);
		}
		var fontBox = this.getFontBox(obj);
		var target_pick = fontBox.find('form .btn_color_pick');
		target_pick.text(color_title?color_title:color_cls).attr('class', 'btn_color_pick '+color_cls).css('backgroundColor', color_cls);
		if(FontUtils.isColorDark(color_cls)){
			target_pick.css('color', '#fff');
		}else{
			target_pick.css('color', 'unset');
		}
		fontBox.find("input[name='bubblecolor']").val(color_cls);
	},
	pickColor: function(obj) {
		var _self = this;
		var color_cls = $(obj).attr('data-cls');
		_self.updateSet({'bubblecolor': color_cls});
		this.getColorPickPane(obj).toggle();
	},
	pickFontsize: function(obj){
		var _self = this;
		_self.updateSet({'fontsize': $(obj).val()});
	},
	saveConfig: function(obj) {
		var fontsetForm = obj;
		var bubblecolor = fontsetForm.bubblecolor.value;
		var fontsize = fontsetForm.fontsize.value; 
		WebAndpcConfig['bubblecolor'] = bubblecolor?bubblecolor:FontUtils.defaults.bubblecolor;
		WebAndpcConfig['fontsize'] = fontsize?fontsize:FontUtils.defaults.fontsize;
		ChatUtil.saveConfigToOA('4',JSON.stringify(WebAndpcConfig));
		this.getColorPickPane(obj).hide();
		$(obj).closest('.chatapp').click();
		this.updateMsgItemStyle();
	},
	getConfig: function(configName, defaultValue) {
		if(typeof configName !== 'string') {
			return null;
		}
		var configValue = null;
		if(typeof WebAndpcConfig !== 'undefined') {
			configValue = WebAndpcConfig[configName]
			if(typeof configValue === 'undefined') {
				return null;
			}
		}
		if(configValue == null && typeof defaultValue !== 'undefined') {
			configValue = defaultValue;
		}
		return configValue;
		
	},
	getColorHex: function(color_cls){
		if(color_cls.indexOf('color_') != -1){
			return this.initData.color_hex[color_cls];
		}else {
			return color_cls;
		}
	},
	_updateStyle: function(obj, fontset){
		obj = $(obj);
		var fontsize = fontset.fontsize;
		var bubblecolor = fontset.bubblecolor;
		var flag_fontsize = true, flag_bubblecolor = true;
		// 屏蔽掉附件和必达消息
		if(obj.closest('.chatItemdiv[msgtag]').length > 0) return;
		if(obj.closest('.accMsgTag').length > 0) {
			// 附件只修改气泡颜色，不修改字体
			flag_fontsize = false;
		} 
		// 接收和发送方的纯文本不刷新气泡颜色，只修改字体
		if(obj.closest('.txtMsgTag .chatLItem').length > 0 && 
			obj.closest('.txtMsgTag .chatRItem').length > 0) {
			flag_bubblecolor = false;
		} 
		if(flag_fontsize) {
			var oldfs = obj.attr('fontsize')?obj.attr('fontsize'):FontUtils.defaults.fontsize;
			obj.removeClass('font'+oldfs).
			addClass('font'+fontsize).
			attr('fontsize', fontsize);
		}
		
		if(flag_bubblecolor){
			obj.removeClass(obj.attr('bubblecolor')?obj.attr('bubblecolor'):FontUtils.defaults.bubblecolor).
			addClass(bubblecolor).
			attr('bubblecolor', bubblecolor)
			.css('backgroundColor', bubblecolor);
			
			var chatitem = obj.closest('.chatRItem'); 
			chatitem.attr('class', 'chatRItem arrow_bubble_color');
			chatitem.find('.chatArrow').attr('class', 'chatArrow arrow_'+bubblecolor).
				css('borderLeft', "7px solid "+bubblecolor);
		}
	},
	updateMsgItemStyle: function(){
		var fontsize = WebAndpcConfig['fontsize'];
		var bubblecolor = WebAndpcConfig['bubblecolor'];
		var _self = this;
		setTimeout(function(){
			$('div.chatcontent').css('fontSize', fontsize+'px');
			$('#tempChatItem .chatContent').each(function(i, obj){
				_self._updateStyle(obj, WebAndpcConfig);
			});
		}, 100);
	},
	updatePage: function() {
		var fontsize = WebAndpcConfig['fontsize'];
		var bubblecolor = WebAndpcConfig['bubblecolor'];
		var _self = this;
		// 修改样式
		setTimeout(function(){
			$('div.chatcontent').css('fontSize', fontsize+'px');
			$('#tempChatItem .chatContent').each(function(i, obj){
				
				_self._updateStyle(obj, WebAndpcConfig);
			});
			$('.fontBox').each(function(i, obj){
				var fontBox = $(obj);
				fontBox.find(".fs_selector").val(fontsize);
				_self.setPickedColor(fontBox, bubblecolor, _self.initData.colors[bubblecolor]);
			});
		}, 100);
		
	},
	// 清除字体样式
  	clearFontSetStyle: function(tempdiv){
  		tempdiv.find(".chatRItem").removeClass("arrow_bubble_color");
  		tempdiv.find(".chatLItem").removeClass("arrow_l_bubble_color").removeClass("arrow_bubble_color");
		var tempChatcontent = tempdiv.find(".chatContent");
		tempChatcontent.attr('class', 'chatContent').removeAttr('style');
		tempdiv.find(".chatArrow").attr('class', 'chatArrow').removeAttr('style');
		var atag = tempChatcontent.find('a');
		atag.removeAttr('style');
		return tempdiv;
  	},
  	// 添加字体样式
  	addFontSetStyle: function(tempdiv, fontset) {
  		var fontsize = fontset.fontsize;
  		var bubblecolor = fontset.bubblecolor;
  		if(fontsize) {
  			tempdiv.find(".chatContent").addClass('font'+fontsize).attr('fontsize', fontsize);
  		}
  		if(bubblecolor) {
  			tempdiv.find(".chatLItem").addClass("arrow_l_bubble_color");
  			tempdiv.find(".chatRItem").addClass("arrow_bubble_color");
  			tempdiv.find(".chatContent").
  				addClass(bubblecolor).
  				attr('bubblecolor', bubblecolor).
  				css('backgroundColor', bubblecolor);
  			tempdiv.find('.chatLItem .chatArrow').
  				addClass('arrow_l_'+bubblecolor).
  				css('borderRight', "7px solid "+bubblecolor);
  			tempdiv.find('.chatRItem .chatArrow').
  				addClass('arrow_'+bubblecolor).
  				css('borderLeft', "7px solid "+bubblecolor);
  				/*
  			// 如果bubblecolor不是色值，则去掉内联样式
  			if(bubblecolor.indexOf('#') != 0) {
  				tempdiv.find('.chatLItem .chatArrow').removeAttr('style');
  				tempdiv.find('.chatRItem .chatArrow').removeAttr('style');
  			}
  			*/
  			// 深色系字体变白
  			if(FontUtils.isColorDark(bubblecolor)){
  				var tempopt = {
  					'color': '#fff'
  				};
  				if(tempdiv.find(".chatContent").text().charCodeAt(0) == 38378){
  					tempopt['animation'] = 'change 2s ease-in infinite';
  				}
  				if(!tempdiv.hasClass('accMsgTag')) {
	  				tempdiv.find(".chatContent").css(tempopt);
	  				tempdiv.find(".chatContent a").css(tempopt);
  				}
  			}
  			// 链接文字样式
			var atag = tempdiv.find('.chatContent a');
  			if(atag.length > 0) {
  				atag.css('fontSize', fontsize+'px');
  			}
  		}
  		return tempdiv;
  	},
  	// 从消息体获取字体设置
  	getMsgFontSet: function(msgObj){
  		var extraObj={}, extra = msgObj.extra;
		try{
			if(!extra) extra="";
			extraObj=eval("("+extra+")");
		}catch(e){}
		var bubblecolor = extraObj.bubblecolor;
		var fontsize = extraObj.fontsize;
		var issetted = extraObj.issetted;
		if(!bubblecolor || bubblecolor == '\"null\"') {
			bubblecolor = FontUtils.defaults.bubblecolor;
		}
		if(!fontsize || fontsize == '\"null\"') {
			fontsize = FontUtils.defaults.fontsize;
		}
		// 手机端设置的颜色带透明度属性
		if(bubblecolor.indexOf('#') == 0 && bubblecolor.length == 9)
        	bubblecolor = '#'+bubblecolor.substring(3,9);
		return {'fontsize': fontsize, 'bubblecolor': bubblecolor, 'issetted': issetted};
  	},
  	// 判断是否是深色
  	isColorDark: function(colorHex, threshold){
  		if(!colorHex || typeof colorHex != 'string')
			return false;
		if(colorHex.indexOf('#') == 0) {
			colorHex = colorHex.substring(1, colorHex.length);
		}
		var temp = colorHex.split('');
		var R,G,B;
		// #abcdef
		if(temp.length == 6){
			R = temp[0]+temp[1];
			G = temp[2]+temp[3];
			B = temp[4]+temp[5];
			
		}
		// #abc
		else if(temp.length == 3){
			R = temp[0]+temp[0];
			G = temp[1]+temp[1];
			B = temp[2]+temp[2];
		}
		else {
			return false;
		}
		var Gray = parseInt(R,16) *0.299 + parseInt(G,16) * 0.587 + parseInt(B,16) * 0.114;
		if(Gray < (threshold?threshold:125)){
			return true;
		}else{
			return false;
		}
  	}
};

// em系统菜单
var MenuUtil = {
	cache: {
		MaxHeightAry: ["367", "177", "100", "60"],
		companyid: 0
	},
	//打开系统菜单
	showMenuItem: function(obj, evt){
		var SysMenu = $("#sysMenuRoot"); 
		if(SysMenu.attr("isshow") == '1'){
			if(typeof from != 'undefined' && from == 'pc'){
				DragUtils.restoreDrags();
			}
			IMUtil.showIMScrollbar(true, ChatUtil.getCurChatwin().find('.chatList,.acclist,.noteList,.bingList'));
		}else{
			if(typeof from != 'undefined' && from == 'pc'){
				DragUtils.closeDrags();
			}
			IMUtil.showIMScrollbar(false, $('.chatList,.acclist,.noteList,.bingList'));
			if(!SysMenu.attr('isload')) {
				this.loadSysMenuInfo();
				SysMenu.menu();
				SysMenu.attr('isload', '1')
			}
		}
		if(ChatUtil.isFromPc()&&WindowDepartUtil.isAllowWinDepart()&&WindowDepartUtil.tabIsNull()){
            $("#sysMenuRoot").css('left','10px');
        }
		$("#sysMenuRoot").toggle();
		$("#sysMenuRoot").attr("isshow", 1 - parseInt($("#sysMenuRoot").attr("isshow")));
	},
	// 加载系统菜单
	loadSysMenuInfo: function(parentid, level, maxLevel){
	  	try{
	  		if(typeof parentid == 'undefined') parentid = 0;
	  		if(typeof level == 'undefined') level = 0;
		  	var SysMenu = $("#sysMenuRoot"); 
			var getMenuUrl = "/page/maint/menu/SystemMenuMaintListJSON.jsp?type=left&resourceType=3&resourceId="+MenuUtil.cache.companyid+"&parentid="+parentid+"&mode=hidden&e=" + new Date().getTime();
			$.post(getMenuUrl, function(data){
				data = $.trim(data);
				try{
					var menuItemAry = $.parseJSON(data), menuItem;
					if(parentid == 0){
						SysMenu.html(MenuUtil.getMenuHtml(menuItemAry));				
					}else if(menuItemAry.length > 0){
						SysMenu.find('li[menuid='+parentid+']').append("<span class='ui-menu-icon oamenu-icon'></span><ul menuid='"+parentid+"_ul' level='"+level+"' class='max-height-0 ui-menu ui-widget ui-widget-content ui-corner-all' style='display:none;'>"+MenuUtil.getMenuHtml(menuItemAry)+"</ul>");
						IMUtil.imPerfectScrollbar(SysMenu.find("ul[menuid='"+parentid+"_ul']"));
					}
					if(typeof maxLevel === 'undefined' || maxLevel > level) {
						menuItemAry.forEach(function(menuItem){
							if(menuItem.isReferedParent) {
								setTimeout(function(){
									MenuUtil.loadSysMenuInfo(menuItem.id, level+1);
								}, 200 * (level + 1));
							}
						});
					}
				}catch(e){
					
				}
			});
			// 绑定事件
			if(parentid == 0){
				this.bindSysMenuEventListener(SysMenu);
			}
		}catch(err){
			client.error("获取客户端系统菜单信息错误",err);
		}
	},
	// 解析系统菜单
	getMenuHtml: function(menus) {
  		var htmlary = [];
  		for (var i = 0; i < menus.length; ++i) {
  			var menu = menus[i];
			var linkAddress = menu.linkAddress?menu.linkAddress: "";
			var id = menu.id;
			var parentId = menu.parentId;
			var isCustom = menu.isCustom;
			var isReferedParent = menu.isReferedParent;
			var label = menu.name;
			htmlary.push("<li menuid='"+id+"'");
			htmlary.push(" linkAddress='"+linkAddress+"'");
			htmlary.push(" onclick='PcExternalUtils.openUrlByLocalApp(\""+linkAddress+"\")'");
			label = label.replace(/&/g, "&amp;");
			label = label.replace(/</g, "&lt;");
			label = label.replace(/>/g, "&gt;");
			label = label.replace(/\"/g, "&quot;");
			label = label.replace(/\'/g, "&apos;");
			htmlary.push(" label='"+label+"'");
			htmlary.push(" parentId='"+parentId+"'");
			htmlary.push(" isCustom='"+isCustom+"'");
			htmlary.push(" isReferedParent='"+isReferedParent+"'");
			htmlary.push(">");
			htmlary.push("<span class='title'>"+label+"</span>");
			htmlary.push("</li>");
		}
		return htmlary.join('');
  	},
  	// 绑定系统菜单事件
  	bindSysMenuEventListener: function(SysMenu){
	  	var MaxHeightAry = MenuUtil.cache.MaxHeightAry;
	  	$(document).on("mouseenter mouseleave",'#sysMenuRoot li',function(e){
	  			e = e || window.event;
	  			var rootU = $(this).closest('ul[level=0]');
			 	var closestU = $(this).closest('ul');
			 	var level = closestU.attr('level');
			 	var parentU = rootU;
				if(typeof level != 'undefined' && level != '0'){
					level = Number(level);
					parentU = $("ul[level='"+(level - 1)+"']");
				}
			 	var scrollbarid = closestU.attr("_scrollbarid");
			 	if(e.type == "mouseenter"){
			 		var subM = $(this).children('ul');
			 		var top = closestU.offset().top;
			 		var liPositionTop = $(this).position().top;
			 		var clientY = e.clientY;
			 		if(!top) top = closestU.data('top');
			 		var index = $(this).index();
			 		//console.log("top:"+top, "index:"+index);
			 		if(subM.length > 0){
			 			//隐藏滚动条
				 		$("#"+scrollbarid).hide();
				 		
				 		var subLevel = subM.attr('level');
				 		var subHeight = subM.children("li").length * 25;
				 		if(subHeight > MaxHeightAry[subLevel]){
				 			subHeight = MaxHeightAry[subLevel];
				 		}
				 		if(level == '0'){
				 			var subMTop = top + liPositionTop + 25 - subHeight;
				 		}else{
				 			var subMTop = clientY - subHeight + 12;
				 		}
				 		//隐藏所有子菜单
				 		closestU.find('ul').hide();
					  	if(ChatUtil.isFromPc()&&WindowDepartUtil.isAllowWinDepart()&&WindowDepartUtil.tabIsNull()){
                            if(subLevel==='2'){
                                subM.css({
                                    'right': '10px',  
                                    'top':subMTop+'px', 
                                    'position':'fixed',
                                    'z-index':'1000',
                                    'display': 'block'
                                });
                            }else{
                                subM.css({
                                    'right': '86px',  
                                    'top':subMTop+'px', 
                                    'position':'fixed',
                                    'z-index':'1000',
                                    'display': 'block'
                                });
                            
                            }   
                        }else{
                            subM.css({
                                'right': (168 - level * 100)+'px', 
                                'top':subMTop+'px', 
                                'position':'fixed',
                                'z-index':'1000',
                                'display': 'block'
                            });
                        }
					  	subM.data("top", subMTop);
					  	subM.data("height", subHeight);
			 		}
			 		//消除聊天窗口滚动条影响
			 		IMUtil.showIMScrollbar(false, $('.chatList,.acclist,.noteList,.bingList'));
				  	stopEvent();
				}else if(e.type == "mouseleave"){
					var ulObjMenuId = closestU.attr('menuid');
					parentU.find("ul[menuid!='"+ulObjMenuId+"']").hide();
					$("#"+scrollbarid).show();
					stopEvent();
				}
	  		});
	  		SysMenu.addClass("max-height-0");
	  		IMUtil.imPerfectScrollbar(SysMenu);
	  		SysMenu.find("ul").each(function(){
	  			var level = $(this).attr("level");
	  			if(level){
	  				$(this).addClass("max-height-"+level);
	  				IMUtil.imPerfectScrollbar($(this));
	  			}
	  		});

			SysMenu.autoHide($('.menuNav')[0], function(){
				SysMenu.attr("isshow", '0');
				if(!IMUtil.hasTopDialog()){
					if(typeof from != 'undefined' && from == 'pc'){
						DragUtils.restoreDrags();
					}
				}
				IMUtil.showIMScrollbar(true, ChatUtil.getCurChatwin().find('.chatList,.acclist,.noteList,.bingList'));
			});
	  }
}

/*快捷回复*/
var QuickReplyUtil = {
	openQuickreplay: function(targetid, evt, reload){
		var quickreplayBlock = $('#quickreplyDiv');
		quickreplayBlock.slideToggle('normal', function(){
			if(quickreplayBlock.is(":visible")) {
				if(reload) {
					quickreplayBlock.find('.listDiv').load('/social/im/socialQuickReplyList.jsp?targetid='+targetid);
				}
				var isBinded = quickreplayBlock.attr('isBinded');
				if(!isBinded) {
					quickreplayBlock.autoHide("#quickreplyDiv,.quickreply");
					quickreplayBlock.attr('isBinded', 'isBinded')
				}
			}
		});
	},
	openCustomSetting: function(){
		var url = "/systeminfo/menuconfig/CustomSetting.jsp";
		var urlType = 0;
		if(ChatUtil.isFromPc()) {
			PcExternalUtils.openUrlByLocalApp(url,urlType);
		}else{
			window.open(url);
		}
	},
	insertPhrase: function(phrase, targetid) {
		if(!targetid){
			try{
				targetid = ChatUtil.getCurChatwin().attr('_targetid');
			}catch(err){}
		}
		var contentDiv = $('#chatcontent_'+targetid);
		if(contentDiv.length <= 0) {
			contentDiv =  ChatUtil.getCurChatwin().find('.chatcontent');
			targetid = ChatUtil.getCurChatwin().attr('_targetid');
		}
		if(contentDiv.length > 0) {
			var wraper = $("<div>"+phrase+"</div>");
			var plaintext = "";
			var childList = wraper.find('p'); 
			if(childList.length > 0){
				childList.each(function(i, ele){
					plaintext += $(ele).text() + '<br>';
					if(i == childList.length - 1) {
						var obj = contentDiv[0];
						IMUtil.clearSelected(obj);
						var curPos = IMUtil.getCursorPos(obj);
						IMUtil.cache.cursorPos = curPos;
						IMUtil.insertHtmlAtPos(obj, curPos, plaintext);
						contentDiv.perfectScrollbar('update');
					}
				});
			}else{
				plaintext = wraper.text();
				var obj = contentDiv[0];
				IMUtil.clearSelected(obj);
				var curPos = IMUtil.getCursorPos(obj);
				IMUtil.cache.cursorPos = curPos;
				IMUtil.insertHtmlAtPos(obj, curPos, plaintext);
				contentDiv.perfectScrollbar('update');
			}
		}
	},
	doItemClick: function(obj, evt) {
		var phraseId = obj.getAttribute('phraseId');
		var phraseDesc = document.getElementById(phraseId).value;
		var targetid = ChatUtil.getCurChatwin().attr('_targetid');
		this.insertPhrase(phraseDesc, targetid);
		this.openQuickreplay(null, evt);
		//增加自动发送
        var $checkbox = $(obj).parent().prev().find(".checkboxDiv");
        if($checkbox.length>0){
            var flag = $checkbox.children("input")[0].checked;
            if(flag){
                $(".chatSend").click();
            }
        }
	},
	hide: function(evt){
		$('#quickreplyDiv').hide();
	}
};

/*客户端在线状态*/
var OnLineStatusUtil = {
    getUserOnlineStatus : function(memberids,cb){
        var callback = {
            onSuccess : function(array){
                OnLineStatusUtil.receiveUserStatusHandle(array,memberids,cb);
            },
            onError : function(){
                client && client.writeLog("获取用户状态失败,服务端拒绝请求");
                //服务器不允许拉取状态,把设置在线状态的按钮去掉
                //var editUserStatus = $("#pc-headtoolbar").find("._userName").find(".edUserStatus");
                //if(editUserStatus.length>0){
                //    editUserStatus.remove();
                //}
                if(cb!=undefined){
                    cb.onError();
                }
            }
        };
        if (IS_BASE_ON_OPENFIRE && (ClientSet.ifForbitOnlineStatus == '0' || ClientSet.ifForbitOnlineStatus == null || ClientSet.ifForbitOnlineStatus == undefined || ClientSet.ifForbitOnlineStatus == 'undefined')) {
            var length = memberids.length;
            var tempmenbers = memberids.slice(0);
            if(client){
                for(var i=0;i < length / 200;i++ ){
                    var temp = tempmenbers.splice(0,200);
                    client.getUserOnlineStatus(temp,callback);
                }
            }else{
                SOCIAL_GLOBAL.OnlineStatus.M_ALLUSERSTATUS = IMUtil.unique(SOCIAL_GLOBAL.OnlineStatus.M_ALLUSERSTATUS.concat(tempmenbers))
            }
            $(document).bind("click.autoHide",function(e){
                $(".userStatusPanel").hide();
            });
        }
    },
    receiveUserStatusHandle : function (array,memberids,cb){
            if(array!=undefined&&array.length!=0){
               for (var x = 0 ;x < array.length ;x++){
                   try{
                       if(array[x]==undefined){
                            continue;
                       }
                       var pcStatus = array[x].pc;
                   }catch(err){
                       var pcStatus = "offline";
                       client.writeLog("pc客户端状态不存在");
                   }
                   if(pcStatus==undefined) var pcStatus = "offline";
                   try{
                       var mobileStatus = array[x].mobile;
                   }catch(err){
                       var mobileStatus = "offline";
                       client.writeLog("mobile客户端状态不存在");
                   }
                   if(mobileStatus==undefined) var mobileStatus = "offline";
                   var userid= array[x].userid;
                   //设置最近列表人员状态
                   OnLineStatusUtil.setAllStatus(userid,pcStatus,mobileStatus,1);
                   if(memberids!=undefined){
                        var index = $.inArray(userid, memberids);
                        var indexRe = $.inArray(parseInt(userid), memberids);
                        if(index!='-1'||parseInt(index)!=-1) delete memberids[index];
                        if(indexRe!='-1'||parseInt(indexRe)!=-1) delete memberids[indexRe];
                        if($.inArray(userid, SOCIAL_GLOBAL.OnlineStatus.M_ALLUSERSTATUS)=='-1'){
                            SOCIAL_GLOBAL.OnlineStatus.M_ALLUSERSTATUS.push(userid);
                        }
                   }
                   if(cb!=undefined){
                        cb.onSuccess(userid,pcStatus,mobileStatus);
                   }
                   
               }
               if(memberids!=undefined&&memberids.length>0){
                    for (var y = 0 ;y < memberids.length ;y++){
                        var useridy = memberids[y];
                        if(y!=undefined&&useridy!=undefined){
                             OnLineStatusUtil.setAllStatus(useridy,'offline','offline',1);
                             var index = $.inArray(useridy, memberids);
                             delete memberids[index];
                             if(cb!=undefined){
                                cb.onSuccess(useridy,'offline','offline');
                             }
                             if($.inArray(useridy, SOCIAL_GLOBAL.OnlineStatus.M_ALLUSERSTATUS)=='-1'){
                                SOCIAL_GLOBAL.OnlineStatus.M_ALLUSERSTATUS.push(useridy);
                             }
                        }
                    }
               }
            }else{
                if(memberids!=undefined&&memberids.length>0){
                    for (var x = 0 ;x < memberids.length ;x++){
                        var useridx = memberids[x];
                        if(x!=undefined&&useridx!=undefined){
                            OnLineStatusUtil.setAllStatus(useridx,'offline','offline',1);
                            var index = $.inArray(useridx, memberids);
                            delete memberids[index];
                            if(cb!=undefined){
                                cb.onSuccess(useridx,'offline','offline');
                            }
                            if($.inArray(useridx, SOCIAL_GLOBAL.OnlineStatus.M_ALLUSERSTATUS)=='-1'){
                                SOCIAL_GLOBAL.OnlineStatus.M_ALLUSERSTATUS.push(useridx);
                             }
                        }
                    }
                }
            }
    },
    
    setUserOnlineStatus : function(userStatus,callback){
        var callback = {
            onSuccess : function() {
                $("#pc-headtoolbar").find(".edUserStatus").css('background','url("'+SOCIAL_GLOBAL.OnlineStatus.TOP_ONLINESTATUS[userStatus]+'") no-repeat center center')
                .attr('title',ONLINESTATUS[userStatus]).attr('target',userStatus);
                //IM_Ext.showMsg("您已成功设置为（"+ONLINESTATUS[userStatus]+"）状态");
                OnLineStatusUtil.setAllStatus(M_USERID,userStatus,'offline');
                OnLineStatusUtil.setTaryInfo(ONLINESTATUS[userStatus]);
                if(SOCIAL_GLOBAL.OnlineStatus.M_ONLINESTATUS[M_USERID]==undefined){
                     var status = {pc:userStatus};
                     SOCIAL_GLOBAL.OnlineStatus.M_ONLINESTATUS[M_USERID]=status;
                }else{
                     SOCIAL_GLOBAL.OnlineStatus.M_ONLINESTATUS[M_USERID].pc=userStatus;
                }
               
            },
            onError : function(){
                IM_Ext.showMsg("在线状态设置失败");
            }
        }
        IMClient.prototype.setUserOnlineStatus(userStatus,callback);
    },
    
    userStatusHandler : function(){
        var callback = {
            onSuccess : function(array){
                OnLineStatusUtil.receiveUserStatusHandle(array);
            }
        };
        IMClient.prototype.handlePresenceMessageListener(callback);
    },
    
    switchUserStatus : function(obj){
        $(".userStatusPanel").hide();
        var status = $(obj).find("a").attr("_target");
        var oldStatus = $("#pc-headtoolbar").find(".edUserStatus").attr('target');
        if(status==oldStatus){
            //IM_Ext.showMsg("目前状态就是"+ONLINESTATUS[oldStatus]+"，不需要设置");
            return;
        }
        OnLineStatusUtil.setUserOnlineStatus(status);
    },
    showUserStatusPanel : function(obj,event ){
        var userStatusPanel = $(".userStatusPanel");
        userStatusPanel.css("left",$(obj).offset().left-25);
        userStatusPanel.css("top", $(obj).offset().top-30);
        setTimeout(function() { userStatusPanel.show(); }, ChatUtil.discussMenuSet.onHideDelay);
        userStatusPanel.unbind("mouseleave").bind('mouseleave', function() {
                setTimeout(function() { userStatusPanel.hide();}, ChatUtil.discussMenuSet.onHideDelay);
             });
    },
    //最近ChatTab在线状态
    setOtherLeftStatus : function (userid,userStatus,mobileStatus){
        //左边列表
        var chatIMTabLeft = $("#chatTab_0_"+userid);
        if(chatIMTabLeft.length>0){
            var head = chatIMTabLeft.find(".head28");
            chatIMTabLeft.find("#userStatus").remove();
            if(mobileStatus=='offline'){
                if(userStatus=='offline'){
                    var hoverBtn = $('<div id="userStatus" target="offline" device="pc" style="width:28px;height:28px;position:absolute;margin-top:-28px;border-radius:30px;background: #000000;opacity: 0.5;text-align:center;color: #ffffff;font-size: 11px;line-height: 28px;position:relative;">离线</div>');
                    head.after(hoverBtn);
                }else{
                    if(userStatus!="online"){
                        var hoverBtn = $('<div id="userStatus" target="'+userStatus+'" device="pc" style="margin-top: -13px;z-index: 10;"><img style="margin-left: 17px;" src='+SOCIAL_GLOBAL.OnlineStatus.LEFT_ONLINESTATUS[userStatus]+'></div>');
                        head.after(hoverBtn);
                    }
                }
            }else{
                var hoverBtn = $('<div id="userStatus" target="'+mobileStatus+'" device="mobile" style="margin-top: -13px;z-index: 10;"><img style="margin-left: 17px;" src='+SOCIAL_GLOBAL.OnlineStatus.LEFT_ONLINESTATUS[mobileStatus]+'></div>');
                head.after(hoverBtn);
            }
        }
        if(ChatUtil.isFromPc()&&WindowDepartUtil.isAllowWinDepart()){
            WindowDepartUtil.setOtherLeftStatus(userid,userStatus,mobileStatus);
        }
    },
    //最近会话人在线状态
    setOtherRightStatus : function (userid,userStatus,mobileStatus){
        //右边列表
        var chatIMTabRight = $("#conversation_"+userid);
        if(chatIMTabRight.length>0){
            var head = chatIMTabRight.find('.head35');
            chatIMTabRight.find('#userStatus').remove();
            if(mobileStatus=='offline'){
                if(userStatus=='offline'){
                    var hoverBtn = $('<div id="userStatus" target="offline" device="pc" style="width:35px;height:35px;position:absolute;margin-top:-38px;border-radius:30px;background: #000000;opacity: 0.5;text-align:center;color: #ffffff;font-size: 12px;line-height: 35px;position:relative;">离线</div>');
                    head.after(hoverBtn);
                }else{
                    if(userStatus!="online"){
                        var hoverBtn = $('<div id="userStatus" target="'+userStatus+'" device="pc" style="margin-top: -16px;z-index: 10;"><img style="margin-left: 24px;" src='+SOCIAL_GLOBAL.OnlineStatus.LEFT_ONLINESTATUS[userStatus]+'></div>');
                        head.after(hoverBtn);
                    }
                }
            }else{
                var hoverBtn = $('<div id="userStatus" target="'+mobileStatus+'" device="mobile" style="margin-top: -16px;z-index: 10;"><img style="margin-left: 24px;" src='+SOCIAL_GLOBAL.OnlineStatus.LEFT_ONLINESTATUS[mobileStatus]+'></div>');
                head.after(hoverBtn);
            }
        }
    },
    
    setAllStatus : function (userid,userStatus,mobileStatus){
        //最近ChatTab在线状态
        OnLineStatusUtil.setOtherLeftStatus(userid,userStatus,mobileStatus);
        //最近会话人在线状态
        OnLineStatusUtil.setOtherRightStatus(userid,userStatus,mobileStatus);
        //提示用户不在线登录信息
        OnLineStatusUtil.showUserStatusTip(userid,userStatus,mobileStatus);
        //组织结构和常用组树在线状态
        OnLineStatusUtil.setTreeUserStatus(userid,userStatus,mobileStatus);
        //同部门人员和我的下属在线状态
        OnLineStatusUtil.setDeptLowerUserStatus(userid,userStatus,mobileStatus);
    },
    
    listenUserStatusHandle : function (info){
        var tempArr = new Array();
        if(info.onlineUsers!=""){
            var onlineUsers = info.onlineUsers;
            for(var i=0;i<onlineUsers.length;i++){
            var arrInfo = onlineUsers[i].split("/");
                var onlineStatus = {};
                onlineStatus.userid=arrInfo[0];
                if(arrInfo.length==1){
                    onlineStatus.pc="online";
                }
                if(arrInfo.length==2){
                    if(arrInfo[1]=="mobile"){
                         onlineStatus.mobile="online";  
                    }
                }
                if(arrInfo.length==3){
                    if(arrInfo[1]=="mobile"){
                        onlineStatus.mobile=arrInfo[2];
                    }
                    if(arrInfo[1]=="pc"){
                        onlineStatus.pc=arrInfo[2];  
                    }
                }
                SOCIAL_GLOBAL.OnlineStatus.M_ONLINESTATUS[arrInfo[0]]=onlineStatus;
                tempArr.push(onlineStatus);
              }
        }
        OnLineStatusUtil.receiveUserStatusHandle(array);
    },
    showUserStatusTip : function(userid,userStatus,mobileStatus){
        var tip = "";
        if(userStatus=='offline'&&mobileStatus=='offline'){
            tip = social_i18n('OfflineTip');
        }
        if(userStatus=='busy'&&mobileStatus!='online'){
            tip = social_i18n('BusyTip');
        }
        if(userStatus=='away'&&mobileStatus!='online'){
            tip = social_i18n('AwayTip');
        }
        var chatWin = $('#chatWin_0_'+userid);
        //窗口打开了
        if(chatWin.length>0&&(userStatus!='online'&&mobileStatus!='online')){
                if(chatWin.find('.chatList').find('.chatItemdiv.chatNotice.userStatus').length>0){
                    chatWin.find('.chatList').find('.chatItemdiv.chatNotice.userStatus').remove();
                    //chatWin.find('.chatList').find('.chatItemdiv.chatNotice.userStatus').find('span').text(tip);
                }
                    var tempdiv=$("<div class='chatItemdiv chatNotice userStatus'><span>"+tip+"</span></div>");
                    var chatList = chatWin.find('.chatList');
                    chatList.append(tempdiv);
                    scrollTOBottom(chatList);
        }else if(chatWin.length>0&&(userStatus=='online'||mobileStatus=='online')){
            chatWin.find('.chatList').find('.chatItemdiv.chatNotice.userStatus').remove();
        }
    },
    //封装在线状态信息
    packageUserStatus : function(innerHTML,type){
        var onlineInfos = JSON.parse(innerHTML);
        var onlineUsers ="";
        var offlineUsers = "";
        for(var i=0;i<onlineInfos.length;i++){
            var info = onlineInfos[i];
            if(info.onlineUsers!=undefined){
                onlineUsers = info.onlineUsers;
            }
            if(type==2){
                if(info.offlineUsers!=undefined){
                    offlineUsers = info.offlineUsers;
                }
            }
        }
        var tempArr = new Array();
        if(onlineUsers!=""){
           for(var i=0;i<onlineUsers.length;i++){
                var arrInfo = onlineUsers[i].split("/");
                var onlineStatus = {};
                onlineStatus.userid = arrInfo[0];
                if(arrInfo.length==1){
                    onlineStatus.pc="online";
                }
                if(arrInfo.length==2){
                    if(arrInfo[1]=="mobile"){
                    onlineStatus.mobile="online";  
                    }
                }
                if(arrInfo.length==3){
                    if(arrInfo[1]=="mobile"){
                        onlineStatus.mobile=arrInfo[2];  
                    }
                    if(arrInfo[1]=="pc"){
                        onlineStatus.pc=arrInfo[2];  
                    }
                }
                var oldStatus = SOCIAL_GLOBAL.OnlineStatus.M_ONLINESTATUS[arrInfo[0]];
                if(oldStatus!=undefined){
                    if((oldStatus.pc!=undefined&&oldStatus.pc!='offline')||(oldStatus.mobile!=undefined&&oldStatus.mobile!='offline')){
                        if(oldStatus.pc!='offline'&&onlineStatus.pc!='offline'){
                            SOCIAL_GLOBAL.OnlineStatus.M_IS_CHANGESTATUS[arrInfo[0]] = true;
                        }else{
                            SOCIAL_GLOBAL.OnlineStatus.M_IS_CHANGESTATUS[arrInfo[0]] = false;
                        }
                        if(oldStatus.mobile!='offline'&&onlineStatus.mobile!='offline'){
                            SOCIAL_GLOBAL.OnlineStatus.M_IS_CHANGESTATUS[arrInfo[0]] = true;
                        }else{
                            SOCIAL_GLOBAL.OnlineStatus.M_IS_CHANGESTATUS[arrInfo[0]] = false;
                        }
                    }else{
                        SOCIAL_GLOBAL.OnlineStatus.M_IS_CHANGESTATUS[arrInfo[0]] = false;
                    }
                }else{
                    SOCIAL_GLOBAL.OnlineStatus.M_IS_CHANGESTATUS[arrInfo[0]] = false;
                }
                //适合下标取值
                SOCIAL_GLOBAL.OnlineStatus.M_ONLINESTATUS[arrInfo[0]]=onlineStatus;
                tempArr.push(onlineStatus);
           }
       }
       if(type==2){
            if(offlineUsers!=""){
                for(var i=0;i<offlineUsers.length;i++){
                    var offlineStatus = {};
                    offlineStatus.pc = 'offline';
                    offlineStatus.mobile = 'offline';
                    offlineStatus.userid = offlineUsers[i];
                    SOCIAL_GLOBAL.OnlineStatus.M_ONLINESTATUS[offlineUsers[i]]=offlineStatus;
                    tempArr.push(offlineStatus);
                }
            }
       }
       return tempArr;
    },
    //设置托盘信息
    setTaryInfo : function(userStatus){
        TrayUtils.setTrayTooltip("状态："+userStatus);
    },
    //清理在线状态
    removeAllUserStatus : function(userid){
        var chatWin = $('#chatWin_0_'+userid);
        chatWin.find('.chatList').find('.chatItemdiv.chatNotice.userStatus').remove();
        var chatIMTabLeft = $('#chatIMTabs').find("#chatTab_0_"+userid);
        chatIMTabLeft.find('.headicon').find('#userStatus').remove();
        var chatIMTabRight = $('#recentListdiv').find("#conversation_"+userid);
        chatIMTabRight.find('.itemleft').find('#userStatus').remove();
    },
//主动拉取组织结构和常用组树在线状态
    setOrgTreeUserStatus : function (currentArr,memArr,type){
        if(type==1 || type==2 || type ==3){//FIXME 沿用 SOCIAL_GLOBAL.OnlineStatus的缓存方式
            for(var i=0,len = memArr.length;i<len;i++){
                var tempArray =  SOCIAL_GLOBAL.OnlineStatus.M_ORGGROUP_TREE[memArr[i]];
                if(!tempArray){
                    tempArray = SOCIAL_GLOBAL.OnlineStatus.M_ORGGROUP_TREE[memArr[i]]= new Array();
                }
                tempArray.push(currentArr[memArr[i]]);
            }
        }
        OnLineStatusUtil.getUserOnlineStatus(memArr);
    },
    //组织结构和常用组树在线状态
    setTreeUserStatus : function(userid,pcStatus,mobileStatus){
        //FIXME 后期尽量只传一种状态 mobile在线>pc状态
        var hrmGroupList = SOCIAL_GLOBAL.OnlineStatus.M_ORGGROUP_TREE[userid];
        if(hrmGroupList){
            if(pcStatus=='online'||mobileStatus=='online'){
                var tempdiv=$('<div class="orgTreeUserStatus dot-online"></div>');
                for(var i = 0;i<hrmGroupList.length;i++){
                    hrmGroupList[i].find(".orgTreeUserStatus").remove();
                    hrmGroupList[i].prepend(tempdiv.clone());
                    var $obj = $(hrmGroupList[i].parent().parent().find('span.department.folder')[0]).find('#statusNum');
                    //var info = $obj.html();
                    //var index = info.indexOf('/');
                    //var num = parseInt(info.substring(1,index));
                    var isFirst = $obj.attr('isFirst');
                    if($obj.length==1){
	                    var member = parseInt($obj.attr('member'));
	                    var all = $obj.attr('all');
	                    var count = parseInt($obj.attr('count'));
	                    count += 1;
	                    if(isFirst=='false'){
	                       //var pcStatus = SOCIAL_GLOBAL.OnlineStatus.M_ONLINESTATUS[userid].pc;
                           //var mobileStatus = SOCIAL_GLOBAL.OnlineStatus.M_ONLINESTATUS[userid].mobile;
                           //if(!(pcStatus!='offline'||mobileStatus!='offline')){
                           //   member += 1;
                           //}
                           if(!SOCIAL_GLOBAL.OnlineStatus.M_IS_CHANGESTATUS[userid]){
                               member += 1;
                           }
	                    }else{
	                       member += 1;
	                    }
	                    $obj.html("("+member+"/"+all+")");
	                    $obj.attr('member',member);
	                    $obj.attr('count',count);
	                    if(count==all){
	                       $obj.attr('isFirst','false');
	                    }
                    }
                }
            }else if(pcStatus!='online'&&mobileStatus!='online'){
                var flag = false;
                if(pcStatus=='offline'&&mobileStatus=='offline'){
                    var tempdiv=$('<div class="orgTreeUserStatus dot-offline"></div>');
                    var tempdivTextTip = tempdiv.clone().attr('class', 'orgTreeUserStatus textTip').text('['+social_i18n('Offline')+']');
                    flag = false;
                }else{
                    var tempdiv=$('<div class="orgTreeUserStatus dot-'+pcStatus+'"></div>');
                    var tempdivTextTip = tempdiv.clone().attr('class', 'orgTreeUserStatus textTip').text('['+ONLINESTATUS[pcStatus]+']');
                    flag = true;
                }
                for(var i = 0;i<hrmGroupList.length;i++){
                    hrmGroupList[i].find(".orgTreeUserStatus").remove();
                    hrmGroupList[i].prepend(tempdiv.clone());
                    hrmGroupList[i].append(tempdivTextTip.clone());
                    var $obj = $(hrmGroupList[i].parent().parent().find('span.department.folder')[0]).find('#statusNum');
                    if($obj.length==1){
                        var info = $obj.html();
                        //var index = info.indexOf('/');
                        //var num = parseInt(info.substring(1,index));
                        //var count = info.substring(parseInt(index+1),parseInt(info.length-1));
                        var member = parseInt($obj.attr('member'));
                        var all = $obj.attr('all');
                        var count = parseInt($obj.attr('count'));
                        count += 1;
                        var isFirst = $obj.attr('isFirst');
                        if(flag){
                            if(isFirst=='false'){
                                if(!SOCIAL_GLOBAL.OnlineStatus.M_IS_CHANGESTATUS[userid]){
	                               member += 1;
	                           }
                            }else{
                                member += 1;
                            }
                            $obj.html("("+member+"/"+all+")");
                            $obj.attr('member',member);
                        }else{
                            if(isFirst=='false'){
                                if(member>0){
                                    member = member -1;
	                            }else{
	                               member = 0;
	                            }
	                            $obj.html("("+member+"/"+all+")");
                                $obj.attr('member',member);
                            }
                        }
                        $obj.attr('count',count);
	                    if(count==all){
	                       $obj.attr('isFirst','false');
	                    }
                    }
                }
            }
        }
    },
    //同部门人员和我的下属
    setDeptLowerUserStatus : function(userid,pcStatus,mobileStatus){
        var chatDept = $("#dept_"+userid);
        var chatLower = $("#lower_"+userid);
        var flag = 0;
        var hoverBtn= "" ;
        if(mobileStatus=='offline'){
            if(pcStatus=='offline'){
                hoverBtn = $('<div id="userStatus" target="offline" device="pc" style="width:35px;height:35px;position:absolute;margin-top:-38px;border-radius:30px;background: #000000;opacity: 0.5;text-align:center;color: #ffffff;font-size: 12px;line-height: 35px;position:relative;">离线</div>');
                flag = 1;
            }else{
                if(pcStatus!="online"){
                    hoverBtn = $('<div id="userStatus" target="'+pcStatus+'" device="pc" style="margin-top: -16px;z-index: 10;"><img style="margin-left: 24px;" src='+SOCIAL_GLOBAL.OnlineStatus.LEFT_ONLINESTATUS[pcStatus]+'></div>');
                    flag = 1;
                }
            }
        }else{
            hoverBtn = $('<div id="userStatus" target="'+mobileStatus+'" device="mobile" style="margin-top: -16px;z-index: 10;"><img style="margin-left: 24px;" src='+SOCIAL_GLOBAL.OnlineStatus.LEFT_ONLINESTATUS[mobileStatus]+'></div>');
            flag = 1;
        }
        if(chatDept.length>0){
            var headDept = chatDept.find('.head35');
            chatDept.find('#userStatus').remove();
            if(flag==1){
                headDept.after(hoverBtn);
            }
        }
        if(chatLower.length>0){
            var headLower = chatLower.find('.head35');
            chatLower.find('#userStatus').remove();
            if(flag==1){
                headLower.after(hoverBtn);
            }
        }
    }
};
/**
*发送可见消息，带上会话中别人发的消息ids，加强count消息
*/
var CountidsUtil = {
	//缓存收到的消息id，会话的消息id，其中缓存的缓存消息的ids每个会话最多30；
	countIdsCache:{},
	//缓存对方消息的中 countid，标识这里的消息id都表示已读
	receiveIdsCache:{},
	//缓存已经发送了count消息的msgid,一个会话最大缓存30条
    sendCountMsgids: {},
	//加入缓存 
	setMsgidToCIdsCaChe:function(targetid,msgid,flag,callback){
		var _this = this;
		var _targetidTemp = _this.countIdsCache[targetid];
		if(typeof _targetidTemp==="undefined"){
			_targetidTemp = _this.countIdsCache[targetid] = new Array();
		}
		if(flag){//先进后出
			_targetidTemp.push(msgid);
		}else{//先进先出
			_targetidTemp.unshift(msgid);				
		}
			_targetidTemp.unique();
		if(_targetidTemp.length>30){
			_targetidTemp.shift();
		}		
		typeof callback ==="function" &&callback();
	},
	//加入接收缓存，对方法的消息中有countids，
	setMsgidToRIdsCache:function(targetid,msgids,targetType,callback){
		if(targetType != 0) return;
		var _this = this;
		try {
			var _targetidMapTemp = _this.receiveIdsCache[targetid];
			if(typeof _targetidMapTemp==="undefined"){
				_targetidMapTemp = _this.receiveIdsCache[targetid] = {};
			}
			if(typeof msgids !=="string") return;
			var _idsArray =msgids.split(",");
			for(var i =0;i<_idsArray.length;i++){
				var _tempid = _idsArray[i];
				if(typeof _tempid !=="undefined" && _tempid !=""){
					if(targetType == 0){
							_targetidMapTemp[_tempid] = true;
						}
				}
			}			
		} catch (error) {
			console.log(error);
		}	
		typeof callback ==="function" &&callback();
	},
    //加入sendCountMsgids缓存
    setMsgidToSIdsCaChe:function(targetid,msgid,targetType,callback){
		if(targetType != 0) return;
        var _this = this;
        var _targetidTemp = _this.sendCountMsgids[targetid];
        if(typeof _targetidTemp==="undefined"){
            _targetidTemp = _this.sendCountMsgids[targetid] = new Array();
        }
        if(typeof msgid !=="string") return;
        msgid = msgid.split(",");
        for(var i=0 ;i < msgid.length; i++){
        	if(_targetidTemp.indexOf(msgid[i])>-1){
        		continue;
			}
            //先进先出
            _targetidTemp.unshift(msgid[i]);
            if(_targetidTemp.length>30){
                _targetidTemp.shift();
            }
		}
        typeof callback ==="function" &&callback();
    },
	//窗口关闭清理缓存
	deleteCacheByTargetid:function(targetid){
		try{
            delete this.receiveIdsCache[targetid];
            delete this.countIdsCache[targetid];
            delete this.sendCountMsgids[targetid];
		}catch (e){}
		return true ;
	},
	//通过targetid获取msgids
	getMsgids:function(targetid,callback){
		var idsArray = CountidsUtil.countIdsCache[targetid];
		if(typeof idsArray !=="undefined"){
			idsArray = idsArray.toString();
		}else{
			idsArray =""
		}
		if(typeof callback ==="function"){
			callback(idsArray);
		}else{
			return idsArray;
		}
	},
	//通过计算，更新未读数
	updateMsgUnreadCount:function(ids,targetType,callback){
		if(typeof ids !=="string" || ClientSet.ifForbitReadstate == '1') return;
		try {
			var _idsArray =ids.split(",");
			for(var i =0;i<_idsArray.length;i++){
				var _tempid = _idsArray[i];
				if(typeof _tempid !=="undefined" &&_tempid !=""){
					if(targetType == 0||targetType == 7||targetType ==8){
							ChatUtil.updateMsgUnreadCountHtml(_tempid,targetType,0);
						}
				}
			}			
		} catch (error) {
			console.log(error);
		}		
		typeof callback ==="function" &&callback();
	},
	//检查缓存中是否已读，未读去服务端校验
	checkMsgRead:function(targetid,msgid){
		var _this = this;
		var _flag = false;
		var _targetidMapTemp = _this.receiveIdsCache[targetid];
		if(typeof _targetidMapTemp!=="undefined"){
			if(!!_targetidMapTemp[msgid]){
				_flag = true;
			}
		}
		return _flag;
	},
	//检查是否已经发过count消息，包括发出的消息的中的消息countids
	checkSendCountMsg :function (targetid,msgid) {
		var _this = this;
        var _targetidMapTemp = _this.sendCountMsgids[targetid];
        var flag  = false;
        if(_targetidMapTemp){
            flag =  _targetidMapTemp.indexOf(msgid)>-1;
		}
		return flag;
	}
}
/**
 * 主次账号账号id处理方法 --后续优化
 */
var AccountUtil ={
	/**
	 * 主次账号关系
	 */	
	accountBelongTO:{},
	/**
	 * 获取次账号关系
	 */
	getAccountBelongTO:function(){
		var url=getPostUrl("/social/im/SocialIMOperation.jsp?operation=getAccountBelongTO");
		$.post(url,function(data){
			try {
				data = data.replace("\n","").replace("\r","");
				var userList=eval("("+data+")");
				if(userList.length>0){
					AccountUtil.accountBelongTO = userList[0];
				}
			} catch(e){
				client && client.error(e);
			}
		})	
	},
	//初始化
	init:function(){
		this.getAccountBelongTO();
	},
	/**
     * 检查账号是否存在主账号，如果存在则返回对应的主账号 
     * @param accountList  oa中用户id 最后返回不包含当前用户的用户id串
     */
	checkAccount:function(accountList){
		var isIMUser = false;
		var isString = false;
		if(ClientSet.multiAccountMsg==1){
				if(typeof accountList === "string"){
					accountList = accountList.split(",");
					isString = true;
				}
				if(accountList[0].indexOf("|")!=-1) isIMUser = true;
				for(var i = accountList.length-1; i>= 0;i--){
					var parentAccountid = AccountUtil.accountBelongTO[accountList[i]];
					if(typeof parentAccountid !="undefined"){
						accountList.splice(i, 1,parentAccountid);
					}	
				}
				accountList = IMUtil.unique(accountList);
				accountList = IMUtil.removeArray(accountList,M_USERID);
				accountList = isString ? accountList.join(","):accountList;	
		}	
		return accountList;
	},
	/**
	 * 获取某个useid对应主账号的用户信息
	 * @param userid 用户id
	 */
	getAccountInfo:function(userid){
		userid =  getRealUserId(userid);
		var parentAccountid = AccountUtil.accountBelongTO[userid];
		if(typeof parentAccountid !="undefined"){
			userid = parentAccountid;			
		}
		return getUserInfo(userid);	
	},
	/**
     * 通过oaID获得imID
     * @param userId  oa中用户id
     */
    getIMUserId:function(userId,flag) {
		if(flag){
			try{
				var sufs = '|' + M_UDID;
				var index = userId.indexOf(sufs);
				if (index == -1) {
					return userId + sufs;
				}else{
					return userId.substring(0, index + sufs.length);
				}
			}catch(e){}
			return userId + '|' + M_UDID;
		} else{
			return userId;
		}   	
    }

}
/**
 * 粘贴版相关
 * @type 
 */
var ClipboardUtil = {
	copyPcImg: function(dataURL){
	  	if(window.Electron) {
	  		copyImgElectron(dataURL);
	  	}else if(window.nw){
	  		copyImgNw(dataURL);
	  	}
	  	
	  	function copyImgElectron(dataURL){
		  	var nativeImage = window.Electron.remote.nativeImage;
		    var oReq = new XMLHttpRequest();
			oReq.open("GET", dataURL, true);
			oReq.responseType = "arraybuffer";
			oReq.onload = function (oEvent) {
				var arraybuffer = oReq.response;  
				if (arraybuffer) {
					var byteArray = new Uint8Array(arraybuffer);
					if(ChatUtil.isFromPc()){
						var clipboard = window.Electron.remote.clipboard;
						var nImg = nativeImage.createFromBuffer(new Buffer(byteArray));
						clipboard.writeImage(nImg);
					}
				}
		    }
		    oReq.send();
		  }
		  
		  function copyImgNw(dataURL){
		  	var oReq = new XMLHttpRequest();
			oReq.open("GET", dataURL, true);
			oReq.responseType = "blob";
			oReq.onload = function (oEvent) {
				var blob = oReq.response;  
				if (blob) {
					var reader = new FileReader();
					var base64Data = "";
					reader.addEventListener("load", function () {
					    base64Data = reader.result;
					    if(base64Data && ChatUtil.isFromPc()){
							try{
								var nwgui = window.require('nw.gui');
								var clipboard = nwgui.Clipboard.get();
								var type='png';
								if(base64Data.indexOf('jpg') != -1) {
									base64Data = base64Data.replace(/data:image\/jpg;/, "data:image/jpeg;");
								}
								if(base64Data.indexOf('jpeg') != -1) {
									type="jpeg";
								}
								clipboard.set(base64Data, type);
							}catch(e) {}
						}
					  }, false);
					  
					reader.readAsDataURL(blob);
				}
		    }
		    oReq.send();
		  }
  },
  // Finish it, use flash to copy image cross web browser
  copyWebImg: function(dataURL) {
//		if(!ZeroClipboard) return;
		// check flash useable
//		if(ZeroClipboard.isFlashUnusable()) return;
//		var clip = new ZeroClipboard(document.getElementById('copybtn'), {
//			swfPath:'/social/js/zeroclipboard/ZeroClipboard.swf'
//		});
//		clip.off('noflash').on('noflash', function(){
//			IM_Ext.showMsg('no flash detected!');
//		});
//		clip.off('wrongflash').on('wrongflash', function(){
//			IM_Ext.showMsg('version too low, need over 10');
//		});
//		/*
//		var img = new Image();
//		img.src=dataURL;
//    	img.onload = function(){
//    		var canvas = document.createElement("canvas");
//    		var ctx = canvas.getContext("2d");
//    		canvas.width = img.width;
//    		canvas.height = img.height;
//    		ctx.drawImage(img, 0, 0);
//    		var imgd = canvas.toDataURL("image/png");
//    		
//    		var blob = new Blob(imgtypedarray, {type : mimetype});
//			clip.setData(imgd);
//    	}
//    	*/
//    	var oReq = new XMLHttpRequest();
//		oReq.open("GET", dataURL, true);
//		oReq.responseType = "blob";
//		oReq.onload = function (oEvent) {
//			var blob = oReq.response;  
//			if (blob) {
//				clip.setData("blob", blob);
//			}
//	    }
//	    oReq.send();
    	
  },
  
  execCopy: function(obj, evt){
  		var chatitem = IM_Ext.getChatItem(obj);
        var msgObj = chatitem.data("msgObj");
        var msgType = msgObj.msgType;
        // msgType  1文本，2图片
        var dataURL = chatitem.find('.chatcontentimg > img').attr('_imageurl');
        if(msgType == 1) {
        	var content = msgObj.content;
        	content = content.replace(/<br>/g, '\n');
            content = IM_Ext.getPlainText(content);
            // 选中文本
            if(document.selection) {
				window.clipboardData.setData("Text", content);
			}else{
				var selection = rangy.getSelection();
				var range = rangy.createRange();
				range.selectNode(chatitem.find('.chatContent > div')[0]);
				selection.addRange(range);
				document.execCommand('Copy');
			}
        } 
        else if(msgType == 2) {
        	if(ChatUtil.isFromPc()) {
        		this.copyPcImg(dataURL);
        	}else{
        		this.copyWebImg(dataURL);
        	}
        }
        
		var contentdiv = $(obj);
	  	window.clearTimeout(contentdiv.data("timerid")); 
	  	window.setTimeout(function(){	  		
	  		var floatwrap = $("#tempchatFloatmenu");
	  			floatwrap.hide();
	  	}, 100);
        IM_Ext.showMsg(social_i18n('CopySuccess')); //复制成功
    },
    // 访问系统粘贴板
    queryClipboard: function(ele, cb){
    	// web版不能访问
    	if(!ChatUtil.isFromPc())
    		return;
    	if(typeof ClipboardHelper == 'undefined')
    		return;
    	if(ClipboardHelper.querying)
    		return;
    	// ios和linux不支持
    	if(!PcMainUtils.platform.Windows) {
    		return;
    	}
    	// 解决截图功能冲突
    	 if(ChatUtil.cache.reloadPrevImgHandler){
		 	return;
		 }
		 var _self = this;
	  	// 控制ctrl+v粘滞健发送频率
	  	if(_self.queryHandler) {
	  		return;
	  	}
	  	_self.queryHandler = setTimeout(function(){
	  		_self.queryHandler = null;
	  	}, 2000);
    	ClipboardHelper.querying = true;
    	ClipboardHelper.chatObj = ele;
    	if(window.Electron) {
	  		window.Electron.ipcRenderer.send('query-clipboard');
	  	}
    }
};
/**
 * 密聊方法
 */
var PrivateUtil ={
	/**
	 * 缓存密聊的会话消息数目用于计算 未读数 targetid = MsgIdArray
	 */
	privateUnClearConnverCache:{},
	/**
	 * 记录所有的密聊消息
	 */
	privateRecordCache:{},
	/**
	 * 记录正在跑秒的msgid
	 */
	msgTimerCache:{},
	/**
	 * iframe 密聊方法对象
	 */ 
	privateChatUtil:function(){
		if($('#privateframe').length>0){
			return $('#privateframe')[0].contentWindow.PrivateChatUtil;
		}else{
			return {};
		}
	},	
	setRecordCahce:function(msgid,msgSecond,callback){
		var _this =this;
		if(msgSecond < 0){
			 delete  _this.privateRecordCache[msgid] ;
		}else{
			_this.privateRecordCache[msgid] = msgSecond;
		}		
		typeof callback ==="function" &&callback(msgid,msgSecond);
	},
	setConnverCache:function(targetid,flag,msgid,callback){
		var _this =this;
		var targetidArray = _this.privateUnClearConnverCache[targetid];
		if(typeof targetidArray==="undefined"){
			targetidArray = _this.privateUnClearConnverCache[targetid] = new Array();
		}
		try {
			if(flag){
				targetidArray.push(msgid);
				_this.updatePrivateMsgCount(targetid,flag,targetidArray.length);			
			}else{
				_this.updatePrivateMsgCount(targetid,flag,targetidArray.length);
				for(var i= 0;i<targetidArray.length;i++){
					countMsgidsArray.push({"toid":targetid,"msgid":targetidArray[i],"msgFrom":"web"});
				}
				delete _this.privateUnClearConnverCache[targetid];					
			}
		} 	
		catch (error) {	console.log("密聊清理未读数失败"+error);}
		_this.setHotPrivatChatIcon(targetid,flag);
		typeof callback ==="function" &&callback();
	},
	/**
	 * 从单聊打开密聊
	 */
	openPrivateChat:function(targetid){
		PrivateUtil.setConnverCache(targetid,false);
		showIMChatpanel(8,targetid,social_i18n('PrivateChat'),"/social/images/private_head.png");	
	},
	/**
	 * 发起密聊
	 */	
	launchedPrivateChat:function(event){
		 // pc端对拖拽特殊处理
		 if(typeof from != 'undefined' && from == 'pc') {
            DragUtils.closeDrags();
        }
		__browserNamespace__.showModalDialogForBrowser(event,'/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp','#','resourceid',false,1,'',
		{
			name:'resourceBrowser',
			hasInput:false,
			zDialog:true,
			needHidden:true,
			dialogTitle: social_i18n("Member"),
			arguments:'',
			_callback:PrivateUtil.launchedPrivateChatCallback
		});
        // pc端对拖拽特殊处理
        if(typeof from != 'undefined' && from == 'pc') {
            browserDialog.closeHandle = function(){
                browserDialog.closeHandle = null;
                DragUtils.restoreDrags();
            };
        }
	},
	launchedPrivateChatCallback:function(event,data){
		if(data!=null&&data.id!=""){
			var ids = data.id.split(",");
			ids = AccountUtil.checkAccount(ids);
			//人数不符合要求
			if(ids.length>1 || ids.length ==0){
				showImAlert(social_i18n('PrivateOneToOne'));
			}else{
				PrivateUtil.openPrivateChat(ids[0]);
			}
		}
		return;
		// else{
		// 	showImAlert("请选择密聊对象");
		// 	return;
		// }
	},
	/**
	 * 返回密聊会话列表
	 */
	backToPrivateRecentList:function(){
		if($("#conversation_private_"+M_USERID).length>0){
			$("#conversation_private_"+M_USERID).click()
		}
	},
	/**
	 * 密聊更新会话
	 */
	updateConversationList:function(targetid,sendtime){
		if(!!PrivateUtil.privateChatUtil().updateConversationList){
			PrivateUtil.privateChatUtil().updateConversationList(targetid,sendtime);
		}
	},
	/**
	 * 更新密聊的未读数
	 */
	updatePrivateMsgCount:function(targetid,flag,targetCount){
		var  privateChatTab = $('#chatTab_7_private');
		if( $('#chatWin_7_private').length>0){
			//更新密聊会话列表未读书
			if(!!PrivateUtil.privateChatUtil().updateMsgCount){
				PrivateUtil.privateChatUtil().updateMsgCount(targetid,flag,targetCount);
			}
		}
		if(!flag){
			if(targetCount > 0){
				updateTotalMsgCount('private',true,7,-targetCount);
			}	
		}else{
			if(!Number($('#conversation_private_'+M_USERID).find('.msgcount').attr('_msgcount'))){
				updateTotalMsgCount('private',true,7,this.getAllUnReadCount());
			}else{
				updateTotalMsgCount('private',true,7,1);
			}
		
		}
	},
	updateMsgTimer:function(msgid,second){
		var _this  = this;
		if(!second){
			second = _this.privateRecordCache[msgid];
		}
		if(second>=0){
			var content =" "+second+"''";
			if($('#'+msgid).attr("_targetid")==M_USERID){
				content = social_i18n('ReadStatus2') + content;
			}
			$('#'+msgid+' .msgUnreadCount').html(content);
		}else{
			$('#'+msgid).remove();
			$("[data-msgid='"+msgid+"']").remove();
		}
		if(second-->-1){
			_this.setRecordCahce(msgid,second,function(msgid,second){
				setTimeout("PrivateUtil.updateMsgTimer('"+msgid+"',"+second+")",1000);
			})
		}				
	},
	startUpdateMsgTimer:function(msgid,callback){
		var _this = this;
		if(_this.privateRecordCache[msgid]){
			if(!_this.msgTimerCache[msgid]){
				_this.msgTimerCache[msgid] = true;
				_this.updateMsgTimer(msgid);
			}
		}
		if($('#'+msgid).attr("_targetid")==M_USERID){//只有接受者收到countmsg后删除消息
			_this.deleteRecords(msgid);
		}else{
			_this.deleteRecords(msgid);
		}		
	},
	deleteRecords:function(msgids,callback){
		$.getJSON("/social/im/SocialIMOperation.jsp?operation=deletePrivateChatRecords", { msgids: msgids}, function(data){
				typeof callback =="function"&& callback(data);
		  });
	},
	updateMsgUnreadCountHtml:function(messageid){
		var chatitem = $("#"+messageid);
		var unreadCountdiv=chatitem.find(".msgUnreadCount");
		var chatContentdiv=chatitem.find(".chatContentdiv");
		var chatWin=unreadCountdiv.parents(".chatWin:first");
		var contentHeight=chatContentdiv.find('.chatContent').outerHeight();
		if(contentHeight==0){
			contentHeight = 24;
		}
		if(chatWin.is(':hidden')){
			contentHeight = chatitem.attr('_coth')?chatitem.attr('_coth'):24;
		}
		var height=contentHeight+"px";
		unreadCountdiv.show();
		unreadCountdiv.css({"height":height,"line-height":height});
		unreadCountdiv.css({"cursor":"default"});
		PrivateUtil.startUpdateMsgTimer(messageid);
	},
	calculationSeconds:function(imMessage,msgid){//msg 防止mssage中不准，这块还没理
		var second  = 30;
		try {
			if(imMessage instanceof RongIMClient.TextMessage && imMessage.getObjectName()== "RC:TxtMsg"){
				second += Math.floor(imMessage.getContent().length/30) * 30;
			}else if(imMessage instanceof RongIMClient.VoiceMessage){
				second =  Math.floor(imMessage.getDuration())+30;
			}else if(imMessage.objectName =="RC:TxtMsg"){
				second += Math.floor(imMessage.content.length/30) * 30;
			}else{
				second = 60;
			}
			this.setRecordCahce(msgid,second);
		} catch (error) {
			console && console.log(error);
		}
		
	},
	/* 
	*新消息到达，单聊的密聊图标显示红点
	*flag 为false 的时候表示没有消息了
	*/
	setHotPrivatChatIcon:function(targetid,flag){
		var _this =this;
		var targetidArray = _this.privateUnClearConnverCache[targetid];
		var chatWin = $("#chatWin_0_"+targetid);
		if(chatWin.length>0){
			if(flag && targetidArray  && targetidArray.length>0){
				chatWin.find('[type=private_div]').css("background-image","url('/social/images/chat_icon_private_h_wev8.png')");
			}else{
				chatWin.find('[type=private_div]').css("background-image","url('/social/images/chat_icon_private_wev8.png')");
			}
		}		
	},
	/* 
	*获取除了targetid以外的消息总数
	 */
	getAllUnReadCount:function(targetid){
		var _this  = this;
		var totalCount = 0;
		for (var i in _this.privateUnClearConnverCache){
			if(i==targetid){
				continue;
			}
			totalCount+= _this.privateUnClearConnverCache[i].length;
		}
		return totalCount;
	}
}
