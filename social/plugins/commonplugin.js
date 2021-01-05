/**
 * 存放一公共的js方法，或者一些其他模块用的js方法
 */
var commonUtil= {
    /**
     * 公共的diallog 在e-message统一弹框，目前用系统的弹框，之后窗口分离用electron的dialog，或者保留两套
     */
    dialog : function(title,flag,url,width,height,okLabel,_win,callback,dialog){
        var diag = new window.top.Dialog();
        diag.currentWindow = _win?_win:window; 
        diag.Modal = true;
        diag.Drag=true;
        diag.Width =width?width:680;	
        diag.Height =height?height:420;
        diag.ShowButtonRow=flag;
        diag.Title = title;
        diag.URL = url;        
        if(!(typeof okLabel ==='undefined')){
            diag.okLabel = okLabel;
        }
        if(typeof dialog ==='object'){
            diag = dialog;
        }
        if(false){
            diag.OKEvent = function(){
                typeof callback ==='function' && callback();
                diag.close();
            }
        }
        diag.closeHandle = function(){
            if(typeof closeHandler == 'function'){
                closeHandler(diag);
            }
            //pc端关闭时恢复拖动绑定
            if(typeof from != 'undefined' && from == 'pc'){
                DragUtils.restoreDrags();
            }
        }
        if(typeof from != 'undefined' && from == 'pc'){
            DragUtils.closeDrags();
        }
        diag.show();
    },
    imedialog : function(dialog,_win){
        var diag = new window.top.Dialog();        
        diag = dialog;       
        diag.closeHandle = function(){            
            //pc端关闭时恢复拖动绑定
            if(typeof from != 'undefined' && from == 'pc'){
                DragUtils.restoreDrags();
            }
        }
        if(typeof from != 'undefined' && from == 'pc'){
            DragUtils.closeDrags();
        }
        diag.show();
    },
    imslideDiv :function(width,url,afterhideCB){        
			var slideDiv = $("#imSlideDiv");			
			var tdsFrm =  slideDiv.find("iframe");
			tdsFrm.attr("src", url);
			slideDiv.find(".imDiscussSetting").hide();
			$("#imSlideDiv iframe").show();
			setTimeout(function(){
			IMUtil.doShowSlideDiv(width, {
				'afterhide': function(){
                    slideDiv.find(".imDiscussSetting").show();
                    $("#imSlideDiv iframe").hide();
                    typeof afterhideCB ==='function' && afterhideCB();
                }
			});		
			},400);
				
        },
    doHideSlideDiv:function(){
        var slideDiv = $("#imSlideDiv");
        IMUtil.doHideSlideDiv(slideDiv);
		setTimeout(function(){
		$("#imSlideDiv iframe").hide();
        slideDiv.find(".imDiscussSetting").show();    	
		},400);
		    
    }

};
// 文档模块对接的方法 
var docUtil = {
    voiteid:-1,//记录打开右滑
    skincolor:{
        "default":"5BB4D8",
        "green":"31A66B",
        "yellow":"E6A872",
        "pink":"F78EA7",
    },
    skin :function(){
        if(typeof from !=='undefined'&& from =="pc"){
            return  docUtil.skincolor[PcSysSettingUtils.getConfig().skin];
        }else{
            return "5BB4D8";
        }
    },
    // 发起投票
    /**
     * shareid  投票id
     * sharetitle 投票标题
     * groupid  群id
     * voteDeadline 截止日期
     * callback 回调
     */
    voteMessage : function(shareid,sharetitle,groupid,voteDeadline,iconid,callback){        
        var objectName = "FW:CustomShareMsgVote";   
        var targettype = '1';       
        var receiverids = ChatUtil.getMemberids(targettype,groupid,false);
        var data={"shareid":shareid,"sharetitle":sharetitle,"sharetype":"vote","receiverids":receiverids,"objectName":objectName,"voteDeadline":voteDeadline,"iconid":iconid};
        var extra=$.extend({"msg_id":IMUtil.guid(),"groupid":groupid},data);
        var strExtra = JSON.stringify(extra);
        var timestamp = new Date().getTime();
        var msgObj={"content":sharetitle,"objectName":objectName,"extra":strExtra,"timestamp":timestamp,"msgType":6};
        if(ChatUtil.isFromPc()&&WindowDepartUtil.isAllowWinDepart()){
            ClientUtil.sendMessageToDiscussion(groupid,msgObj,6,"",targettype,function(result){
                typeof callback ==='function'&&callback(result);
                if(result.issuccess){                     
                    var userInfo=userInfos[M_USERID];
                    var resultMsgObj = result.paramzip.msgobj;
                    var chatList=$("#chatWin_1_"+groupid).find(".chatList");
                    var tempdiv=ChatUtil.getChatRecorddiv(userInfo,resultMsgObj,'send',6, null, groupid);
                    var sendtime=resultMsgObj.timestamp;
                    addSendtime(chatList,tempdiv,sendtime,"send");
                    chatList.append(tempdiv);
                    chatList.perfectScrollbar("update");
                    scrollTOBottom(chatList);
                    chatList.data("newMsgCome", true); 
                    try{
                    var resultExtra = eval("("+resultMsgObj.extra+")");
                    }catch(e){};                                       
                    ChatUtil.doHandleSendSuccess(result, resultExtra.msg_id, resultExtra.groupid, 1);               
                }
            });
        }else{
                client.sendMessageToDiscussion(groupid,msgObj,6,function(result){
                typeof callback ==='function'&&callback(result);
                if(result.issuccess){                     
                    var userInfo=userInfos[M_USERID];
                    var resultMsgObj = result.paramzip.msgobj;
                    var chatList=$("#chatWin_1_"+groupid).find(".chatList");
                    var tempdiv=ChatUtil.getChatRecorddiv(userInfo,resultMsgObj,'send',6, null, groupid);
                    var sendtime=resultMsgObj.timestamp;
                    addSendtime(chatList,tempdiv,sendtime,"send");
                    chatList.append(tempdiv);
                    chatList.perfectScrollbar("update");
                    scrollTOBottom(chatList);
                    chatList.data("newMsgCome", true); 
                    try{
                    var resultExtra = eval("("+resultMsgObj.extra+")");
                    }catch(e){};                                       
                    ChatUtil.doHandleSendSuccess(result, resultExtra.msg_id, resultExtra.groupid, 1);               
                }
            }); 
        }
    },
    // 投票消息
    /**
     * senderid 投票人
     * voiteid 投票id
     * content 界面展示的内容
     * grouid 群组
     */
    voteNotice :function(senderid,sharer,voteid,groupid,content,callback){
        var objectName = "RC:InfoNtfVote";
        var msgObj = new Object();
        msgObj.objectName = objectName;
        msgObj.extra = JSON.stringify({"msg_id":IMUtil.guid(),"shareid": voteid, "senderid":senderid,"notiType": "noti_vote","content":content, "sharer":sharer,"msgFrom": "pc"});
        msgObj.content =content;
        msgObj.timestamp=new Date().getTime();
        if(ChatUtil.isFromPc()&&WindowDepartUtil.isAllowWinDepart()){
                ClientUtil.sendMessageToDiscussion(groupid,msgObj,6,"",targettype,function(result){
                    typeof callback ==='function'&&callback(result);
                  if(result.issuccess){
                    var userInfo=userInfos[senderid];
                    var resultMsgObj = result.paramzip.msgobj;
                    var chatList=$("#chatWin_1_"+groupid).find(".chatList");
                    var sendtime=resultMsgObj.timestamp;
                    if(chatList.length>0){
                      var tempdiv=ChatUtil.getChatRecorddiv(userInfo,resultMsgObj,'send',6, null, groupid);                        
                        addSendtime(chatList,tempdiv,sendtime,"send");
                        chatList.append(tempdiv);
                        chatList.perfectScrollbar("update");
                        scrollTOBottom(chatList);
                        chatList.data("newMsgCome", true); 
                    }
                    updateConversationList(userInfo,groupid,1,userInfo.userName+':参与了投票'+resultMsgObj.content,sendtime);                                    
                }
                });
          }else{
            client.sendMessageToDiscussion(groupid,msgObj,6,function(result){
                typeof callback ==='function'&&callback(result);
                if(result.issuccess){
                    var userInfo=userInfos[senderid];
                    var resultMsgObj = result.paramzip.msgobj;
                    var chatList=$("#chatWin_1_"+groupid).find(".chatList");
                    var sendtime=resultMsgObj.timestamp;
                    if(chatList.length>0){
                      var tempdiv=ChatUtil.getChatRecorddiv(userInfo,resultMsgObj,'send',6, null, groupid);                        
                        addSendtime(chatList,tempdiv,sendtime,"send");
                        chatList.append(tempdiv);
                        chatList.perfectScrollbar("update");
                        scrollTOBottom(chatList);
                        chatList.data("newMsgCome", true); 
                    }
                    updateConversationList(userInfo,groupid,1,userInfo.userName+':参与了投票'+resultMsgObj.content,sendtime);                                    
                }
            });
          }
    },
    /**
     * 通过grouid获取群成员用逗号隔开的id
     */
    getMemberids:function(groupid){
        return ChatUtil.getMemberids('1',groupid,false);
    },
    /**
     * 通过groupid获取群主
     */
    getCreatorId:function(groupid){
        var discuss=discussList[groupid];
        var imUserId = discuss.getCreatorId();
        if (imUserId) {
    		try{
    			var index = imUserId.indexOf('|');
    			if (index > 0) {
    				return imUserId.substring(0, index);
    			}
    		}catch(e){}
    	}        
    	return imUserId;
    },
    /**
     * 投票view方法
     */
    voteView:function(obj,voteid,flag){
        //votestatus有3个状态：0：删除；1：进入详情页面；2：进入投票页面；
        if(!$("#imSlideDiv iframe").is(":hidden")&&docUtil.voiteid == voteid){
            docUtil.voiteid = -1;
            return;
        }else{
            docUtil.voiteid =voteid;
        }
        var groupid =$(obj).parents('.chatdiv').attr('id');
        if(typeof groupid ==='undefined'){
            var reg = new RegExp("(^|&)targetid=([^&]*)(&|$)", "i"); 
            var r = obj.ownerDocument.location.search.substr(1).match(reg); 
            if (r != null) groupid = unescape(r[2]); 
        }else{
            groupid = groupid.substring(8);
        }
        var groupowner = docUtil.getCreatorId(groupid);
        var memberids = docUtil.getMemberids(groupid).split(',').length;
        if(memberids>1){
            memberids++;
        }
        var viewurl="/voting/groupchatvote/VotingShow.jsp?groupid="+groupid+"&votingid="+voteid+"&groupowner="+groupowner+"&skin="+docUtil.skin()+"&time=time_"+new Date().getTime();
        jQuery.ajax({
			url : "/voting/groupchatvote/VotingOperator.jsp",
			data : {
				"groupid" : groupid,
				"votingid" : voteid,
				"method" : "chatmessage"
			},
			type : "post",
			dataType : "json",
			success : function(data){
                var votestatus=data.votestatus;
                if(votestatus=="0"){//提示删除  
                    if(flag){
                        IM_Ext.showMsg("投票已被删除");
                    }else{
                      $(obj).html("<span>投票已被删除</span>");
                    }
                }else{
                    if(votestatus == "3"){
                        if(!flag){
                            $(obj).html("<span>投票已结束</span>");
                        }
                    }
                    if(votestatus=="2"){//返回进入投票url
                        viewurl+="&method=vote#/startvoting";
                    }else{//返回进入详情url
                        viewurl+="$groupusercount="+memberids+"&method=detail#/votedetail";
                        
                    }
                    commonUtil.imslideDiv('400',viewurl);
                }		
			}
		});
    },
    //打开图片
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
		
	}
}
