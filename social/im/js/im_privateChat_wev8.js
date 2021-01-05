/**
 * 导入父级类
 */
M_CORE = parent.M_CORE;
IM_Ext = parent.IM_Ext;
ChatUtil = parent.ChatUtil;
ClientSet = parent.ClientSet;
IS_BASE_ON_OPENFIRE = parent.IS_BASE_ON_OPENFIRE;
PrivateUtil = parent.PrivateUtil;

/**
 * 密聊方法
 */
var PrivateChatUtil = {
	init:function(){
		this.initScrollbar();
		this.loadPrivateList();
	},
	initScrollbar:function(){
		try{
			var scrollbarid=IMUtil.imPerfectScrollbar($('#privateRecentListdiv'));
			IMUtil.showPerfectScrollbar($('#privateRecentListdiv'));
		}catch(e){
			$('#privateRecentListdiv').perfectScrollbar();
		}
	},
	/**
	 * 数据加载
	 */
	loadPrivateList: function () {
        jQuery.ajax({
            type: "POST",
            url: "/social/im/SocialIMOperation.jsp",
            data : {operation : "getConversByTargetType",targetType : 8},
            async: false,
            dataType : "json",
            success: function(data){
                for (var i = 0; i < data.length; i++) {
                    converjs = data[i];
                    var targetid = converjs.targetid;
                    var targettype = converjs.targettype;
                    var converTempdiv = PrivateChatUtil.getConverdiv(converjs);
                    var converObj = { "targetid": converjs.targetid, "targetType": converjs.targettype, "targetName": converjs.targetname, "sendtime": converjs.sendtime };
                    $("#privateRecentListdiv").append(converTempdiv);									
					}
                $("#privateLoading.dataloading").hide();
            }
        });
	},
	getConverdiv:function(converjs){
		var classTag = "privateConverTemp";		
		var converTempdiv=$("."+classTag).clone().removeClass(classTag).show();
		var targetName=converjs.targetname;
		var targetid = converjs.targetid;
		var targettype = "8";
		var sendtime=converjs.sendtime;
		var senderid=converjs.senderid;
		var userInfo = parent.getUserInfo(targetid);
		var targetHead  = userInfo.userHead;
		converTempdiv.find(".targetHead").attr("src",targetHead);
		converTempdiv.find(".deptname").html(userInfo.deptName+" / "+userInfo.jobtitle);
		converTempdiv.find(".targetName").find(".name").html(targetName);
		converTempdiv.attr("id","conversation_"+targetid)
					 .attr("_targetid",targetid)
					 .attr("_targetName",targetName)
					 .attr("_targetHead",targetHead)
					 .attr("_targetType",targettype)
					 .attr("_sendtime", sendtime)
					 .attr("_senderid", senderid);
		var msgArrgy = PrivateUtil.privateUnClearConnverCache[targetid];
		if(msgArrgy&&msgArrgy.length>0){
			converTempdiv.find(".msgcount").html(msgArrgy.length>99?"99+":msgArrgy.length).css({"display":"block"});
		}					 
		converTempdiv.find(".latestTime").html(parent.getFormateTime(sendtime));
		return converTempdiv;
	},
	onSelected:function(obj){
		obj = $(obj).find(".leftItem");
		if($(obj).hasClass("unselected")){
			$(obj).removeClass("unselected").addClass("selected");
		}else{
			$(obj).removeClass("selected").addClass("unselected");
			$('.footbar .leftItem').removeClass("selected").addClass("unselected");
		}
		var selectedDiv = 	$('#privateRecentListdiv').find('.selected');
		var count = $(selectedDiv).length;
		if(count>0){
			count = "("+count+")";
		}else{
			count ="";
		}
		count = deleteText +count;
		$('.footbar .rightItem').html(count);
		event.stopPropagation();
	},
	onSelectedAll:function(obj){		
		if($(obj).hasClass("unselected")){
			$('#privateRecentListdiv').find('.unselected').each(function(){
				$(this).removeClass('unselected').addClass('selected')
			})
			var selectedDiv = 	$('#privateRecentListdiv').find('.selected');
			var count = $(selectedDiv).length;
			count = deleteText +"("+count+")";
			$('.footbar .rightItem').html(count);
			$(obj).removeClass("unselected").addClass("selected");
		}else{			
			$('#privateRecentListdiv').find('.selected').each(function(){
				$(this).removeClass('selected').addClass('unselected')
			})
			$('.footbar .rightItem').html(deleteText);			
			$(obj).removeClass("selected").addClass("unselected");
		}
	},
	deleteConverChatpanel:function(){
		var targetids ="";
		$('#privateRecentListdiv').find('.selected').each(function(){
			var targetid = $(this).parent().parent().attr("_targetid")
			targetids+=","+targetid;			
		});
		if(targetids.length>0){	
			targetids = targetids.substring(1);
			parent.showImConfirm(deleteImConfirm+"？",function () {
                jQuery.ajax({
                    type: "POST",
                    url: "/social/im/SocialIMOperation.jsp",
                    data : {
                        operation : "delPrivateConver",
                        targetids : targetids,
                        targettype : 8
					},
                    async: false,
                    dataType : "json",
                    success: function(data){
                        if(data&&data.flag){
                            var targetids = data.targetids.split(',');
                            for(var i = 0;i<targetids.length;i++){
                                $('#conversation_'+targetids[i]).remove();
                            }
                            $('.footbar .rightItem').html(deleteText);
                            $('.footbar .leftItem').removeClass("selected").addClass("unselected");
                        }else{

                        }
                    }
            });
		});
		}
	},
	showConverChatpanel:function(obj,_paramsObj){
		obj = $(obj).parent();
		$("#privateRecentListdiv .chatItem").removeClass("activeChatItem");
		parent.showConverChatpanel(obj,_paramsObj);
	},
	/**
	 * 发起密聊
	 */
	launchedPrivateChat:function(event){
		PrivateUtil.launchedPrivateChat(event);
	},
	/**
	 * 更新列表
	 */
	updateConversationList:function(targetid,sendtime){
		var converTempdiv=$("#conversation_" + targetid);
		var userInfo = parent.getUserInfo(targetid);
		var converjs ={};
		converjs.targetname = userInfo.userName;
		converjs.targetid = targetid;
		converjs.sendtime = sendtime;
		converjs.senderid = targetid;
		if(converTempdiv.length==0){
			converTempdiv = PrivateChatUtil.getConverdiv(converjs);
		}
		converTempdiv.attr("_senderid",targetid);
		converTempdiv.attr("_sendtime",sendtime);
		ChatUtil.imFaceFormate(converTempdiv.find(".msgcontent"));
		var sendftime=parent.getFormateTime(sendtime);
		converTempdiv.find(".latestTime").text(sendftime);
		$("#privateRecentListdiv").prepend(converTempdiv);
		$("#privateRecentListdiv").scrollTop(0);
	},
	updateMsgCount:function(targetid,flag,count){
		var msgcount=$("#conversation_"+targetid).find(".msgcount");
		if(msgcount.length>0){
			if(!flag){				
				count = 0;											
			}			
			if(count>0){
				if(count>99) count = "99+";
				msgcount.html(count).css({"display":"block"});
			}else{
				msgcount.html(0).css({"display":"none"});
			}
		}
	}
}	