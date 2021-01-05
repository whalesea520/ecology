$(function(){
	$('img').attr('draggable', 'false');
	$('.imRightdiv,.imLeftdiv').attr('onselectstart', 'return false');
	//headtoolbar: 面板顶部按钮组
	var headtoolbar = $("#pc-headtoolbar");
	if(headtoolbar.length > 0){
		var navitems_htb = headtoolbar.find('nav ul li'); 
		navitems_htb.hover(
			function(){
				var ico = $(this).find('.nav-icon img');
				var hotIcoUri = ico.attr('hotIcoUri');
				ico.attr('src', hotIcoUri);
			},
			function(){
				var ico = $(this).find('.nav-icon img');
				var icoUri = ico.attr('icoUri');
				ico.attr('src', icoUri);
			}
		).click(function(){
			//var index = navitems_htb.index(this);
			PcModels.doClickHeadNavs(this);
		});
		//更新未读数目
		PcModels.updateRelatedCount(headtoolbar);
		//适应图标宽度
		PcModels.justifyHeadToolbar(headtoolbar);
		//启动定时器
		setInterval(function(){
			PcModels.updateRelatedCount(headtoolbar);
		}, 3 * 60 * 1000);
		//头像设置
		headtoolbar.find('._userHead,._userName').click(function(){
			var self = $(this);
			PcModels.openPersonEditBlock(event, this);
		});
	}
	var footertoolbar = $("#pc-footertoolbar");
	if(footertoolbar.length > 0){
		footertoolbar.find('.moreBtn').hover(
			function(){
				var ico = $(this).find('img');
				var altTxt = ico.attr('alt');
				ico.attr('src', '/social/images/pcmodels/ftb_'+altTxt+'_h_wev8.png');
			},
			function(){
				var ico = $(this).find('img');
				var altTxt = ico.attr('alt');
				ico.attr('src', '/social/images/pcmodels/ftb_'+altTxt+'_wev8.png');
			}
		).click(function(){
		    if(WindowDepartUtil.isAllowWinDepart()&&WindowDepartUtil.tabIsNull()){
		        var args = {
                    title : social_i18n('AppManagement'),
                    width : 600,
                    height : 430
                };
                WindowDepartUtil.openNewWindow(args,WindowDepartUtil.NewWindowList.AppManager);
		    }else{
		      PcModels.openAppManager({
                callbackfun: function(paras, datas){
                    //刷新模块
                    console.log(datas);
                    var ulObj = footertoolbar.find('nav ul');
                    ulObj.empty();
                    $.each(datas, function(i, item){
                        ulObj.append("<!-- 按钮 --><li _linkuri='"+item.linkuri+"' _uritype='"+item.uritype+"'>"+
                                " <span><img src='"+item.icouri+"' icoUri='"+item.icouri+"' hotIcoUri='"+item.icohoturi+"' alt='"+item.icotitle+"' title='"+item.icotitle+"' draggable='false'/></span>");
                        if(i == ulObj.length - 1){
                            ulObj.append("</li>");
                        }
                    });
                }
            });
		    }
		});
		var navitems_ftb = footertoolbar.find('nav ul li'); 
		 $(document).on("mouseover mouseout",'#pc-footertoolbar nav ul li',function(e){
		 	e = e || window.event;
		 	if(event.type == "mouseover"){
			  	var ico = $(this).find('span img');
				var hotIcoUri = ico.attr('hotIcoUri');
				ico.attr('src', hotIcoUri);
			}else if(event.type == "mouseout"){
			  	var ico = $(this).find('span img');
				var icoUri = ico.attr('icoUri');
				ico.attr('src', icoUri);
			}
		 });
		 
		 $(document).on("click",'#pc-footertoolbar nav ul li',function(e){
		 	PcModels.doClickFootNavs(this);
		 });
	}
	// 人员编辑卡片
	 var personeditblock = $('#pc-personeditblock');
	 if(personeditblock.length > 0 ) {
	 	personeditblock.find('.hoverBtn, ._userHead').click(function(){
	 		PcModels.doChangeHead(this, event);	
	 	}).mouseenter(
	 		function(){
	 			var hoverBtn = $(this).next();
	 			var cord = IMUtil.getDomCord(this, true);
	 			var w = $(this).width();
	 			var h = $(this).height();
	 			hoverBtn.css({
	 				'left': cord.left,
	 				'top': cord.top,
	 				'width': w,
	 				'height': h
	 			}).fadeIn();
			}
	 	);
	 	personeditblock.find('.hoverBtn').mouseleave(function(){
	 		$(this).fadeOut();
	 	});
	 	personeditblock.find('._userEditBtn').click(function(){
	 		PcModels.openHrmContactEdit(this, event)
	 	});
	 	personeditblock.find('._userSignatures').keyup(function(event){
	 		if(event.keyCode == 13) {
	 			$("#imPersonEditDiv").hide();
	 		}else{
	 			return;
	 		}
	 	});
	 	
	 	personeditblock.find('._userSignatures').blur(function(event){
	 	
	 		var textValue = $.trim(this.value);
	 		
	 		if(textValue!=""){
	 		
	 		
	 		if(!DiscussUtil.DiscussSetFunc.checkDsNameValid(this.value)){
                IM_Ext.showMsg(social_i18n('SignatureErr1'));
                $("#imPersonEditDiv").show();
                $("#imPersonEditDiv").find('#pc-personeditblock').find('._userSignatures').focus();
                $("#imPersonEditDiv").find('#pc-personeditblock').find('._userSignatures').value=userInfos[M_USERID].signatures;
                var evt = evt || window.event;
                evt.stopPropagation();
                return;
            }
	 		
	 		//先判断长度
	 		if(countByte(textValue)  > 60){
				IM_Ext.showMsg(social_i18n('SignatureErr2'));
				$("#imPersonEditDiv").show();
				$("#imPersonEditDiv").find('#pc-personeditblock').find('._userSignatures').focus();
				$("#imPersonEditDiv").find('#pc-personeditblock').find('._userSignatures').value=userInfos[M_USERID].signatures;
				var evt = evt || window.event;
				evt.stopPropagation();
				return;
			}
			
	 		if(textValue==userInfos[M_USERID].signatures){
				return;
			}
	 		
			}else{
			    if(textValue==userInfos[M_USERID].signatures){
                    return;
                }
			}
			
			$.post("/social/im/SocialIMOperation.jsp?operation=insertSignatures&signatures="+encodeURI(textValue), function(data){
				if($.trim(data)==1){
					IM_Ext.showMsg(social_i18n('SignatureTip1'));
					//更新本地的个性签名
					userInfos[M_USERID].signatures=textValue;
					var chatWinid="chatWin_"+0+"_"+M_USERID;
					var chatwin = $("#"+chatWinid);
					if(chatwin.length>0){
						if(textValue==""){
							chatwin.find(".chattop").children(".signatures").text(social_i18n('SignatureTip2')).attr('title',social_i18n('SignatureTip2'));
						}else{
							chatwin.find(".chattop").children(".signatures").text(textValue).attr('title',textValue);
						}							
					}
					if($("#recentListdiv").find("#conversation_"+M_USERID)){
						if($("#recentListdiv").find("#conversation_"+M_USERID).find(".targetName").find(".signatures").length==0){
							$("#recentListdiv").find("#conversation_"+M_USERID).find(".targetName").html("");
							$("#recentListdiv").find("#conversation_"+M_USERID).find(".targetName").append('<span class="name"></span><span class="signatures"></span>');
						}
						$("#recentListdiv").find("#conversation_"+M_USERID).find(".targetName").find(".name").text(userInfos[M_USERID].userName).attr('title',userInfos[M_USERID].userName);
						$("#recentListdiv").find("#conversation_"+M_USERID).find(".targetName").find(".signatures").text(textValue).attr('title',textValue);
					}
				}else if($.trim(data)==2){
					IM_Ext.showMsg(social_i18n('SignatureErr3'));
					$("#imPersonEditDiv").show();
					$("#imPersonEditDiv").find('#pc-personeditblock').find('._userSignatures').focus();
					$("#imPersonEditDiv").find('#pc-personeditblock').find('._userSignatures').value=userInfos[M_USERID].signatures;
					var evt = evt || window.event;
					evt.stopPropagation();
					return;
					
				}
			});
		});
	 }
	PcModels.loadSignItem();
	PcModels.loadSkin();
});

//模块事件处理
var PcModels = {
	// 消除拖动事件
	closeDrags: function(){
		$('#imDefaultdiv').removeClass('can-drag');
		var curwin = ChatUtil.getCurChatwin();
		curwin.find('.chatIMtop').removeClass('can-drag');
	},
	// 恢复拖动事件
	restoreDrags: function(){
		$('#imDefaultdiv').addClass('can-drag');
		var curwin = ChatUtil.getCurChatwin();
		curwin.find('.chatIMtop').addClass('can-drag');
	},
	// 打开个人编辑卡片
	openPersonEditBlock: function(evt, obj) {
		var editBlok = $("#imPersonEditDiv");
		if(WindowDepartUtil.isAllowWinDepart()){
		  if(WindowDepartUtil.tabIsNull()){
		      editBlok.find("#pc-personeditblock").css("right","20px");
		      editBlok.find("#pc-personeditblock").css("top","113px");
		  }else{
		      editBlok.find("#pc-personeditblock").css("right","281px");
		      editBlok.find("#pc-personeditblock").css("top","0px");
		  }
		}else{
		    editBlok.find("#pc-personeditblock").css("right","281px");
            editBlok.find("#pc-personeditblock").css("top","0px");
		}
		var self = this;
		editBlok.autoHide("#imPersonEditDiv, " +
				"#pc-headtoolbar ._userName>span, " +
				"#pc-headtoolbar ._userHead", function(){
					if(!IMUtil.hasTopDialog()){
						self.restoreDrags();
					}
				});
		if(editBlok.is(":visible")) {
			self.restoreDrags();
		}else{
			// DragUtils.closeDrags();
			self.closeDrags();
			// 关闭个人卡片
			try{
				$('#closetext').click();
			}catch(err){}
		}
		editBlok.toggle();
	},
	// 修改头像
	doChangeHead: function(obj, evt) {
	    var loginid = $(this).attr('_loginid')
	    if(WindowDepartUtil.isAllowWinDepart()&&WindowDepartUtil.tabIsNull()){
            var args = {
                "title" : social_i18n('HeadChange'),
                "width" : 625,
                "height" : 480,
                "loginid" : loginid
            };
            WindowDepartUtil.openNewWindow(args,WindowDepartUtil.NewWindowList.GetUserIcon);
	    }else{
	       var dialog = getSocialDialog(social_i18n('HeadChange'),625,480, PcModels.updateHeadIcon);
           dialog.URL = '/hrm/HrmDialogTab.jsp?_fromURL=GetUserIcon&loginid='+loginid;
           dialog.show();
	    }
	},
	// 打开个人编辑
	openHrmContactEdit: function(obj, evt) {
		// var url = "/hrm/resource/HrmResourceContactEdit.jsp?isfromtab=true&id="+ M_USERID +"&isView=1";
		var url = "/hrm/HrmTab.jsp?_fromURL=HrmResource";
		var urlType = 0;
		PcExternalUtils.openUrlByLocalApp(url,urlType);
	},
	//重新链接
	reconnect: function(){
		if(client){	
			M_ISFORCEONLINE = false;
			client.reconnect();
		}
	},
	//断开链接
	disconnect: function(){
		if(client){
	    	M_ISFORCEONLINE = true;
	    	client.disconnect();
	    }
	},
	//获取操作系统标识
	getOsString: function(){
		var platform = PcMainUtils.platform;
	 	var os = 'Windows';
	    if(platform.OSX) {
	        os = 'OSX';
	    } else if(platform.Linux) {
	        os = 'Linux';
	    }
	    return os;
	},
	//皮肤按钮点击事件
	doSkinItemClick: function(obj, evt){
		var itemObj = $(obj);
		itemObj.find('.colorPane').toggle();
		itemObj.closest('.addressTitle').toggleClass('no-drag');
		itemObj.find('.colorPane').autoHide(itemObj.find('.itemblock')[0], function(){
			itemObj.closest('.addressTitle').removeClass("no-drag");
		});
	},
	// 主次账号切换
	doSwitchItemClick: function(obj, evt){
		var _selfObj = $(obj);
	 	_selfObj.find('.accoutList').autoHide(_selfObj.find('.icoblock')[0]);
	 	ServerExceptionHandling._exeAjax();
	 	_selfObj.find('.accoutList').toggle();
	},
	// 切换
	doSwitchAccount: function(obj, evt){
		var itemObj = $(obj);
	 	var osString = PcModels.getOsString();
	    var toUserId = itemObj.attr('userid');
	    //当前用户不切换
	    if(toUserId == M_USERID){
	    	return true;
	    }
	    var switchUrl = "/social/SocialUserSwitch.jsp?fromUserId="+M_USERID+"&toUserId="+toUserId+"&language="+PcMainUtils.userInfos.language;
	    //强制断线
	    PcModels.disconnect();
	    $.post(switchUrl, function(data){
	    	try{
	    		data = $.parseJSON(data);
	    		var status = data.STATUS;
				if(status){
					data['pcOs'] = osString;
					window.Electron.ipcRenderer.send('reload-mainChatwin', data);
				}else{
					if(data.message!=''){
						showImAlert(data.message);
					}else
					{
						showImAlert(social_i18n('AccountSwitFailed'));
					}			
				}
			}catch(err){
				showImAlert(social_i18n('AccountSwitFailed'));
			}finally{
				PcModels.reconnect();
			}
	    });
	    $('#pc-accountswtichblock .accoutList').toggle();
	},
	//保存皮肤设置
	saveSkin: function(skin, callback){
	    if(ChatUtil.isFromPc()&&WindowDepartUtil.isAllowWinDepart()&&WindowDepartUtil.tabIsNull()){
	       WindowDepartUtil.saveSkin(skin);
	    }
		var jsonSkin = {'skin':skin};
		PcSysSettingUtils._configs = $.extend(PcSysSettingUtils._configs, jsonSkin);
		PcSysSettingUtils.saveConfig(PcSysSettingUtils._configs, function(){
			callback();
		});
	},
	//加载皮肤
	loadSkin: function(){
		var skinitemblock = $("#pc-skinitemblock");
		if(skinitemblock.length > 0){
			//var skin = IMUtil.readCookie("emessage-skin");
			var skin = $("#skincss").attr("target");
			//获取失败，显示默认皮肤
			if(!skin){
				skin = 'default';
			}
			if(typeof skin == 'string' && skin != ''){
				//$("#skincss").attr("href","/social/css/skin/"+skin+"_wev8.css");
				skinitemblock.find(".colorPane>div[target]").removeClass("selected");
				skinitemblock.find(".colorPane>div[target='"+skin+"']").addClass("selected");
			}
			//绑定事件
			$(".colorPane>div[target]").on("click", function(e){
				var _self = this;
				var targetSkin = $(_self).attr("target");
				//IMUtil.setCookie("emessage-skin", targetSkin, 365);
				//如果当前的皮肤不做处理
				if($(_self).hasClass("selected")){
					skinitemblock.click();
					return;
				}
				PcModels.saveSkin(targetSkin, function(){
					$(_self).parent().children("div[target]").removeClass("selected");
					$(_self).addClass("selected");
					$("#skincss").attr("href","/social/css/skin/"+targetSkin+"_wev8.css").attr("target", targetSkin);
					skinitemblock.click();
				});
			});
		}
	},
	// 更新签到时间
	updateClock: function(curTimeMillis, clockMillis){
		curTimeMillis = Number(curTimeMillis);
		clockMillis = Number(clockMillis);
		var days = (curTimeMillis - clockMillis) / 86400000;
		clockMillis = clockMillis + (1 +days) * 86400000;
		SignInfo.zeroTimeMillis = clockMillis;
	},
	// 获取当前的签到时间
	getIMSignInfos: function(cb){
		$.post("/social/im/SocialIMOperation.jsp?operation=getIMSignInfos", function(data){
			if(data) data = $.trim(data);
			var info;
			try{
				info=JSON.parse(data);
			}catch(err){}
			if(info){
				SignInfo = info;
			}
			if(typeof cb == 'function') {
				cb(info);
			}
		});
	},
	//签退后监听事件，防止跨零点
	regSignStateListener: function(){
		var signItem = $("#pc-signitemblock");
		//一分钟检查下状态
		setInterval(function(){
			var clockMillis = SignInfo.zeroTimeMillis;
			var curTimeMillis = new Date().getTime().toString();
			if(curTimeMillis >= clockMillis) {
				PcModels.getIMSignInfos(function(info){
					if(!info) return;
					if(info.isNeedRemind == '1' && info.isNeedSign == '1') {
						if(signItem.length > 0){
							signItem.find('.icoblock').attr('title', social_i18n('SignOn')).text(social_i18n('SignOn')).show();
							signItem.find('.icoblockimg').removeClass('signout').addClass('signin').show();
						}else{
							PcModels.initSignItem(info);
						}
					}else{
						if(signItem.length > 0){
							signItem.find('.icoblock, .icoblockimg').hide();
						}
					}
				});
				PcModels.cache.signResult = 0;
				PcModels.cache.signLock = 0;
				// info.signType = 1;
				PcModels.updateClock(curTimeMillis, clockMillis);
			}
		}, 1000*60);
	},
	// 初始化考勤按钮
	initSignItem: function(SignInfo){
		var signItem = $("#pc-signitemblock");
		if(signItem.length > 0) return;
		var signOnStr = social_i18n('SignOn');
		var itemHtml = ""+
		"<div id='pc-signitemblock' class='signitemblock' _signFlag='"+SignInfo.signFlag+"' _clock='"+SignInfo.zeroTimeMillis+"'>" + 
			"<span class='icoblockimg'></span>" +
			"<span class='icoblock' title=social_i18n('SignOn')>"+signOnStr+"</span>"+
		"</div>";
		$(itemHtml).appendTo($('.imRightdiv')).show();
	},
	//加载考勤按钮
	loadSignItem: function(tag){
		var signItem = $("#pc-signitemblock");
		var signFlag = signItem.attr("_signFlag");
		if(signItem.length > 0){
			signItem[0].onclick = function(){PcModels.doIMSign()};
			if(tag == 1){
				signItem.find('.icoblock').attr('title', social_i18n('SignOn')).text(social_i18n('SignOn'));
				signItem.find('.icoblockimg').removeClass('signout').addClass('signin');
			}else if(tag == 2){
				signItem.find('.icoblock').attr('title', social_i18n('SignOff')).text(social_i18n('SignOff'));
				signItem.find('.icoblockimg').removeClass('signin').addClass('signout');
			}else{
				if(signFlag == 1){
					signItem.find('.icoblock').attr('title', social_i18n('SignOn')).text(social_i18n('SignOn'));
					signItem.find('.icoblockimg').removeClass('signout').addClass('signin');
				}else{
					signItem.find('.icoblock').attr('title', social_i18n('SignOff')).text(social_i18n('SignOff'));
					signItem.find('.icoblockimg').removeClass('signin').addClass('signout');
				}
			}
		}
	},
	checkHandler: null,
	// 检查签到状态
	checkSignStatus: function(){
		var signItem = $("#pc-signitemblock");
		if(signItem.length > 0 && signItem.find('.icoblock').attr('title') == social_i18n('SignOn')){
			return 1;
		}
		return 0;
	},
	//处理签到状态
	printIMSignStatus: function(signType){
		jQuery.ajax({
			url: "/hrm/schedule/HrmScheduleSignXMLHTTP.jsp?t="+Math.random(),
			data: "signType="+signType,
			type: "POST",
			success: function(content){
				var confirmContent = "<div style=\"margin-left:5px;margin-right:5px;\">" + content.substring(content.toUpperCase().indexOf('<TD VALIGN="TOP">') + 17, content.toUpperCase().indexOf("<BUTTON"));
				var targetSrc = "";
				try{
					//关闭pc版拖动机制
					DragUtils.closeDrags();
					if (SignInfo.isSignBlogRemind==1){
						var blogCheckTip = "";
					    if(0==SignInfo.prevWorkDayHasBlog&&signType==1){
					    	blogCheckTip = social_i18n('BlogCheckTip');
							confirmContent += "<br><br><span style=\"color:red;\">"+blogCheckTip+"</span>";
							targetSrc = "/blog/blogView.jsp?menuItem=myBlog";
						}else if(0==SignInfo.todayHasBlog&&signType==2){
							blogCheckTip = social_i18n('BlogCheckTip1');
							confirmContent += "<br><br><span style=\"color:red;\">"+blogCheckTip+"</span>";
							targetSrc = "/blog/blogView.jsp?menuItem=myBlog";
						}
						
						confirmContent += "</div>";
						if (targetSrc != undefined && targetSrc != null && targetSrc != "") {
							if(ChatUtil.isFromPc()&&WindowDepartUtil.isAllowWinDepart()){
                                //WindowDepartUtil.winDepartParm.signResult = 1;
                                //WindowDepartUtil.winDepartParm.signLock = 0;
                                //WindowDepartUtil.winDepartParm.openurl = targetSrc;
                                //showImConfirm(content.substring(content.toUpperCase().indexOf('<TD VALIGN="TOP">') + 17, content.toUpperCase().indexOf("<BUTTON"))+"|4"+"|"+targetSrc+'|'+blogCheckTip);
                                WindowDepartUtil.showNewClientComfirm("信息确认",confirmContent,function (){
                                    //window.open(targetSrc);
                                    PcExternalUtils.openUrlByLocalApp(targetSrc,"0");
                                    DragUtils.restoreDrags();
                                    PcModels.cache.signResult = 1;
                                    PcModels.cache.signLock = 0;
                                }, function () {
                                    DragUtils.restoreDrags();
                                    PcModels.cache.signResult = 1;
                                    PcModels.cache.signLock = 0;
                                },true);
							}else{
							Dialog.confirm(
								confirmContent, function (){
									window.open(targetSrc);
									DragUtils.restoreDrags();
									PcModels.cache.signResult = 1;
									PcModels.cache.signLock = 0;
								}, function () {
									DragUtils.restoreDrags();
									PcModels.cache.signResult = 1;
									PcModels.cache.signLock = 0;
								}, 520, 90,false
						    );
						    }
						} else {
						    if(ChatUtil.isFromPc()&&WindowDepartUtil.isAllowWinDepart()){
                                //WindowDepartUtil.winDepartParm.signResult = 1;
                                //WindowDepartUtil.winDepartParm.signLock = 0;
                                //showImAlert(confirmContent);
                                WindowDepartUtil.showNewClientComfirm("信息确认",confirmContent,function() {
                                    DragUtils.restoreDrags();
                                    PcModels.cache.signResult = 1;
                                    PcModels.cache.signLock = 0;
                                 });
                            }else{
							Dialog.alert(confirmContent, function() {
								DragUtils.restoreDrags();
								PcModels.cache.signResult = 1;
								PcModels.cache.signLock = 0;
							}, 520, 60,false);
							}
						}
						
					    return ;
					}
					confirmContent += "</div>";
					if(ChatUtil.isFromPc()&&WindowDepartUtil.isAllowWinDepart()){
					    //WindowDepartUtil.winDepartParm.signResult = 1;
					    //WindowDepartUtil.winDepartParm.signLock = 0;
					    //showImAlert(confirmContent);
					    WindowDepartUtil.showNewClientComfirm("信息确认",confirmContent, function() {
                            DragUtils.restoreDrags();
                            PcModels.cache.signResult = 1;
                            PcModels.cache.signLock = 0;
                        })
					}else{
					Dialog.alert(confirmContent, function() {
						DragUtils.restoreDrags();
						PcModels.cache.signResult = 1;
						PcModels.cache.signLock = 0;
					}, 520, 60,false);
					}
	            }catch(e){
	            	console.log("处理签到状态失败:[error from printIMSignStatus]", e);
	            }
			}
		});
	},
	cache: {
		signResult: 0,
		signLock: 0
	},
	//考勤签到
	doIMSign: function(flag){
		//系统弹窗冲突
		if(ServerExceptionHandling._isErroring || IMUtil.hasTopDialog()||$('.task-close').length>0){
			return;
		}
		var signRet = PcModels.cache.signResult;
		var signLock = PcModels.cache.signLock;
		if((signRet == 1 || signLock == 1) && flag) return;
		if(SignInfo.isNeedRemind == '1' && SignInfo.isNeedSign == '1'){
			var signType = SignInfo.signType;
			if(signType == '1'){
				DragUtils.closeDrags();
				PcModels.cache.signResult = 0;
				PcModels.cache.signLock = 1;
				if(ChatUtil.isFromPc()&&WindowDepartUtil.isAllowWinDepart()&&WindowDepartUtil.tabIsNull()){
				    //旧方法弹出新窗口
				    //WindowDepartUtil.winDepartParm.signType=signType;
				    //showImConfirm(social_i18n('SignOnTip')+"|2");
				    //改为弹出框
				    WindowDepartUtil.showNewClientComfirm("信息确认",social_i18n('SignOnTip'),function(){
                        PcModels.printIMSignStatus(signType);
                        SignInfo.signType = '2';
                        PcModels.loadSignItem(2);
                    },function(){
                        DragUtils.restoreDrags();
                        PcModels.cache.signLock = 0;
                    });
				}else{
				    window.top.Dialog.confirm(social_i18n('SignOnTip') ,function(){
                    PcModels.printIMSignStatus(signType);
                    SignInfo.signType = '2';
                    PcModels.loadSignItem(2);
                },function(){
                    DragUtils.restoreDrags();
                    PcModels.cache.signLock = 0;
                });
				}
			}else if(!flag){
				var ajaxUrl = "/wui/theme/ecology8/page/getSystemTime.jsp";
				ajaxUrl += "?field=";
				ajaxUrl += "HH";
				ajaxUrl += "&token=";
				ajaxUrl += new Date().getTime();
				
				jQuery.ajax({
				    url: ajaxUrl,
				    dataType: "text", 
				    contentType : "charset=UTF-8", 
				    error:function(ajaxrequest){}, 
				    success:function(content){
				    	var isWorkTime = jQuery.trim(content);
				    	if (isWorkTime == "true") {
				    	    if(ChatUtil.isFromPc()&&WindowDepartUtil.isAllowWinDepart()&&WindowDepartUtil.tabIsNull()){
                               //WindowDepartUtil.winDepartParm.signType=signType;
                               //showImConfirm(social_i18n('SignOffTip')+"|3");
                               WindowDepartUtil.showNewClientComfirm("信息确认",social_i18n('SignOffTip'),function(){
                                    PcModels.printIMSignStatus(signType);
                                    DragUtils.restoreDrags();
                                },function(){
                                    DragUtils.restoreDrags();
                                    return;
                                });
				    	    }else{
				    	       DragUtils.closeDrags();
                                window.top.Dialog.confirm(social_i18n('SignOffTip'),function(){
                                    PcModels.printIMSignStatus(signType);
                                    DragUtils.restoreDrags();
                                },function(){
                                    DragUtils.restoreDrags();
                                    return;
                                })
				    	    }  
				      }else{
				      		PcModels.printIMSignStatus(signType);
				      }
				    }  
			    });
			}
		}
	},
	//应用管理器
	openAppManager: function(opt){
		var title = social_i18n('AppManagement'),width = 600, height = 400;
		var url = '/social/im/SocialIMPcModels.jsp?model=appmanager';
		var dialog = getSocialDialog(title,width,height);
		dialog.URL =url;
		dialog.maxiumnable = true;
		dialog.ShowButtonRow = false;
		dialog.show();
		dialog.callbackfun = opt.callbackfun;
		document.body.click();
	},
	//更新头像
	updateHeadIcon: function(diag){
		$.post("/social/im/SocialIMOperation.jsp?operation=getHeadIcon", function(headuri){
			headuri = $.trim(headuri);
			console.log(headuri);
			$("#pc-headtoolbar ._userHead").attr('src',headuri);
			$("#pc-personeditblock ._userHead").attr('src',headuri);
			if(typeof userInfos != 'undefined'){
				userInfos[M_USERID].userHead = headuri;
			}
		})
	},
	//更新顶部相关资源数目
	updateRelatedCount: function(htb){
		var userid = M_USERID;
		//var uri = "/hrm/resource/HrmResourceItemData.jsp";
		var liObjs = htb.find(".nav-group nav ul li");
		var sysicoids = new Array();
		$.each(liObjs, function(i, obj){
			var numberuri = $(obj).attr("_numberuti");
			var identityid = parseInt('0'+$(obj).attr("_identityid"));
			if(numberuri && numberuri != '' && identityid > 0){
				if(identityid > 5){
					$.post(numberuri, {'resourceid': userid}, function(count){
						count = $.trim(count);
						//规则校验？
						count = parseInt(count);
						PcModels.addReCotById(identityid, count);
					});
				}else{
					sysicoids.push(identityid);
				}
			}
			if(i == liObjs.length - 1 && sysicoids.length > 0){
				$.post('/social/im/SocialHrmCountData.jsp', {'resourceid': userid, 'sysicoids': sysicoids.join(",")}, function(ret){
					ret = $.trim(ret);
					ret = JSON.parse(ret);
					for(var i in ret){
						PcModels.addReCotById(i, ret[i]);
					}
				});
			}
		})
	},
	//图标适应图标
	justifyHeadToolbar: function(htb){
		var ulObjs = htb.find(".nav-group nav ul");
		for(var i = 0; i < ulObjs.length; ++i){
			if($(ulObjs[i]).find("li").length < 5){
				$(ulObjs[i]).addClass("justify");
			}
		}
	},
	//根据id添加未读样式
	addReCotById: function(id, count){
		if(typeof count == 'undefined' || count < 0 || id < 0) return;
		var htb = $("#pc-headtoolbar");
		var navitem = htb.find("li[_identityid='"+id+"']");
		navitem.find('.dot').css('display', 'none');
		var countstr = count+'';
		if(count > 99){
			countstr='99';
		}
		var titletip = navitem.find('.nav-icon img').attr('title');
		titletip = titletip.replace(/(.*)?\(\d+\)/g, '$1');
		navitem.find('.nav-icon img').attr('title', titletip+"("+count+")");
		navitem.find('.nav-labe').text("("+countstr+")").attr('title', titletip+"("+count+")");
		return navitem.width();
	},
	_isTopOverN: function(num){
		var htb = $("#pc-headtoolbar");
		var itemCount = htb.attr("itemCount");
		return Number(itemCount) > num;
	},
	//消除未读样式
	removeReCot: function(index){
		var htb = $("#pc-headtoolbar");
		var navitem = htb.find('.nav-group ul li:nth-child('+(index + 1)+')');
		navitem.find('.dot').css('display', 'none');
		navitem.find('.nav-labe').text('').attr('title', '');
		var titletip = navitem.find('.nav-icon img').attr('title');
		titletip = titletip.replace(/(.*)?\(\d+\)/g, '$1');
		navitem.find('.nav-icon img').attr('title', titletip);
		return navitem.width();
	},
	//点击顶部导航区域
	doClickHeadNavs: function(liObj){
		var url = $(liObj).attr("_linkuri");
		var urlType = $(liObj).attr("_uritype");
		if($(liObj).hasClass('arrowDown')){
			$(liObj).parent().find(".itemDrops").each(function(){
				$(this).toggleClass("itemHidden");
			});
			$(liObj).parents('.nav-group').toggleClass('nav-group-box');
		}else{
			//url = "/interface/Entrance.jsp?id="+url;
			PcExternalUtils.openUrlByLocalApp(url,urlType);
		}
	},
	//面板底部导航区域
	doClickFootNavs: function(liObj) {
		var url = $(liObj).attr("_linkuri");
		var urlType = $(liObj).attr("_uritype");
		PcExternalUtils.openUrlByLocalApp(url, urlType);
	}
}