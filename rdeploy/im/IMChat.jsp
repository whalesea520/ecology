
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.social.SocialUtil"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="weaver.hrm.resource.ResourceComInfo"%>
<%@page import="weaver.social.service.SocialIMService"%>
<%@page import="weaver.social.po.SocialIMFile"%>
<%@ include file="/social/im/SocialIMInit.jsp"%>
<jsp:useBean id="SocialIMService" class="weaver.social.service.SocialIMService" scope="page" />
<%
	int userid=user.getUID();
	String username = user.getUsername();
	String chatType=Util.null2String(request.getParameter("chatType"),"0"); //聊天类型 0：私聊；1：群聊
	String acceptId=Util.null2String(request.getParameter("acceptId"));
	
	String receiverids=acceptId; //消息接收人 
	
	String attachmentMaxsize="50";
	
	String targetName=Util.null2String(request.getParameter("targetName"));
%>
<style>
	.dataLoading{
		position:absolute;
		top:20px;bottom:0px;left:0px;right:0px;
		background: url('/social/images/loading_large_wev8.gif') no-repeat center 200px;
		display: block;
		z-index:1000
	}
	.atwho-view{}
</style>
<div id="dataLoading" class="dataLoading">
</div>
	
</div>
<!-- 聊天页面 -->
<div id="chatdiv_<%=acceptId%>" class="chatdiv">
<div class="chatleft">
	<!-- 聊天顶部 -->
	<div class="imtitle">
		<span class="imtitleName" style="color: #3c4350;font-size: 14px;" title="<%=targetName%>"><%=targetName%></span>
		<span class="imCloseSpan" onclick="closeChatWin(this)">×</span>
	</div>
	<div class="discussInfo clickHide" id="discussInfo_<%=acceptId%>">
		<div class="mitem mtemp" style="display:none;">
			<div>
				<img src="/social/images/head_group.png" class="head28 mhead">
			</div>
			<div class="mname">曾东平</div>
		</div>
		<div class="mitem" onclick="DiscussUtil.showMoreMember('<%=acceptId%>');">
			<div>
				<img src="/social/images/im/im_dmore_wev8.png" class="head28 mhead">
			</div>
			<div class="mname">更多</div>
		</div>
	</div>
	<div class="chattop chatIMtop">
		<div class="chattabdiv chatActiveTab" style="float:left;" onclick="changeChatTopTab(this,'chat')" _target="chatList">
			<div class="chattab imchat">聊天</div>
		</div>
		<div class="chattabdiv" style="float:left;" onclick="changeChatTopTab(this,'file');" _target="icrList">
			<div class="chattab imfile">相关资源</div>
		</div>
		<%if(chatType.equals("1")){%>
			<div class="chattabdiv imnote" style="float:left;" onclick="changeChatTopTab(this,'note');DiscussUtil.getHistoryNotes(this);" _target="noteList">
				<div class="chattab imnote">公告</div>
			</div>
		<%}%>
		<div class="imSetting" onclick="DiscussUtil.showDiscussSetting();"></div>
		<div class="clear"></div>
		<div class="chatArrow"></div>
	</div>
	
	<!-- 聊天记录 -->
	<div class="chatListbox chatList chatRecord scroll-pane" id="chatList" >
	
	</div>
	<!-- 相关资源 -->
	<div class="chatListbox icrList" id="icrList" style="display:none;">
		
	</div>
	<!-- 公告列表 -->
	<div class="chatListbox noteList" id="noteList" style="display:none;">
		<jsp:include page="/rdeploy/im/IMNoteList.jsp">
			<jsp:param name="targetid" value="<%=acceptId %>"/> 
		</jsp:include>
	</div>
	<!-- 聊天底部 -->
	<div class="chatbottom">
		<div class="chatremarkdiv">
			<div class="chatAppdiv" id="chatAppdiv">
	 				<div class="chatapp" title="表情" onclick="showChatPopBox(this)" style="background-image: url('/social/images/app_biaoqing.png');">
	 					<div id="faceBox" class="popBox faceBox clickHide RongIMexpressionWrap" style="display:none;">
	 					
						</div>
	 				</div>
					
					<div class="chatapp" title="图片" onclick="hideChatPopBox();" id="uploadImgDiv_<%=acceptId%>" secId="0" maxsize="10" _uploadType="image" style="background-image: url('/social/images/app_img.png');position:relative;">
						<span id="holder_uploadImgDiv_<%=acceptId%>" ></span>
						<div class="uploadProcess" id="uploadProcess_uploadImgDiv_<%=acceptId%>">
							<div class="progressDemo hide" id="progressDemo_uploadImgDiv_<%=acceptId%>">
								<div>
									<div class="left fileName p-b-3 ellipsis w180"></div>
									<div class="right fileSize p-l-15"></div>
									<div class="clear"></div>
								</div>
								<div>
									<div class="fileProgress m-b-5">0%</div>
								</div>
							</div>
							<div class="fsUploadProgress" id="fsUploadProgress_uploadImgDiv_<%=acceptId%>"></div>
						</div>
					</div>
					<div class="chatapp" title="附件" id="uploadAccDiv_<%=acceptId%>" secId="0" maxsize="<%=attachmentMaxsize%>" style="background-image: url('/social/images/icon_acc.png');">
						<span id="holder_uploadAccDiv_<%=acceptId%>" ></span>
						<div class="uploadProcess" id="uploadProcess_uploadAccDiv_<%=acceptId%>">
							<div class="progressDemo hide" id="progressDemo_uploadAccDiv_<%=acceptId%>">
								<div>
									<div class="left fileName p-b-3 ellipsis w180"></div>
									<div class="right fileSize p-l-15"></div>
									<div class="clear"></div>
								</div>
								<div>
									<div class="fileProgress m-b-5">0%</div>
								</div>
							</div>
							<div class="fsUploadProgress" id="fsUploadProgress_uploadAccDiv_<%=acceptId%>"></div>
						</div>
					</div>
					
					<div class="chatapp" title="流程" onclick="onShowApp('workflow','#chatcontent_<%=acceptId%>')" style="background-image: url('/social/images/chat_icon_wf_wev8.png');">
					</div>
					
					<div class="chatapp" title="文档" onclick="onShowApp('doc','#chatcontent_<%=acceptId%>')" style="background-image: url('/social/images/chat_icon_doc_wev8.png');">
					</div>
					
					<div class="chatapp" style="background-image: url('/social/images/icon_more.png');display: none;" onclick="showChatPopBox(this)">
						<div id="chatMoreApp" title="更多" class="popBox moreApp">
							<div class="appitem" title="文档" onclick="onShowApp('doc','#chatcontent_<%=acceptId%>')" style="display:none;">
								<span style="margin-right:8px;"><img src="/social/images/app_doc.png" align="absmiddle"></span>
								<span>文档</span>
							</div>
							<div class="appitem" title="流程" onclick="onShowApp('workflow','#chatcontent_<%=acceptId%>')" style="display:none;">
								<span style="margin-right:8px;"><img src="/social/images/app_wf.png" align="absmiddle"></span>
								<span>流程</span> 
							</div>
							<div class="appitem" title="客户" onclick="onShowApp('crm','#chatcontent_<%=acceptId%>')" style="display:none;">
								<span style="margin-right:8px;"><img src="/social/images/app_crm.png" align="absmiddle"></span>
								<span>客户</span>
							</div>
							<div class="appitem" title="项目" onclick="onShowApp('project','#chatcontent_<%=acceptId%>')" style="display:none;">
								<span style="margin-right:8px;"><img src="/social/images/app_proj.png" align="absmiddle"></span>
								<span>项目</span>
							</div>
						</div>
					</div>
					
					<div _acceptId="<%=acceptId%>" _chattype="<%=chatType%>" class="chatRecord" onclick="ChatUtil.showChatRecord(this)" style="display:block;">
						消息记录
					</div>
					
					<div class="clear"></div>
	 		</div>
	 		<div class="chatcontentwrap">
		 		<div id="chatcontent_<%=acceptId%>" name="chatcontent" class="chatcontent" contenteditable="true" _istaskmode="0" _imgCapturer='1'
		 			 onkeyup="toggleWithEditing(this,event);" onkeydown="ajustChatWin(this);return doEnterSend(this, event);"><span class="modehint">输入您要发送的内容，Enter键发送，Shift+Enter键换行</span></div>
		 		<!-- 模式切换 -->
		 		<div class="immodeChangeSwitch" title="切换到任务输入" onclick="changeEditMode(this);"></div>
	 		</div>
	 	</div>
	 	
		<div class="chatoption" style="display:none;">
			<!-- 提示 -->
			<div class="chatsendtip">请按<span>Shift+Enter</span>换行</div>
			<div class="chatSend" style="width:75px;" onclick="ChatUtil.sendIMMsg(this)" _senderid="<%=userid%>" _acceptId="<%=acceptId%>" _chattype="<%=chatType%>" _receiverids="<%=receiverids%>">
				<div style="/*float:left;margin-left:15px;*/text-align:center;">发送</div>
				<!--
				<div class="sendSplitLine"></div>
				<div onclick="showSendType(this)" class="sendtypeSet down"></div>
				 -->
				<div class="clear"></div>
			</div>
 			<div class="clear"></div>
		</div>
		
		<div class="sendtype clickHide">
			<div class="checkpane active" _index="1"></div>
			<div class="checkpane" _index="2" style="top:30px;"></div>
			<div style="margin:3px;">
				<div class="sendtypeItme" _index="1" onclick="ChatUtil.updateEnterSet(this)">
					<span>按Enter键发送消息</span>
				</div>
				<div class="sendtypeItme" _index="2" onclick="ChatUtil.updateEnterSet(this)">
					<span>按Ctrl+Enter键发送消息</span>
				</div>
			<div>
		</div>
	</div>
</div>

</div>

<script>

  $(document).ready(function(){
  		var chatdiv=$("#chatdiv_<%=acceptId%>"); //聊天窗口对象
  		//发布公告相关
  		DiscussUtil.bindEscape(chatdiv);
  		
  		drawExpressionWrap('<%=acceptId%>');
  		
  		ChatUtil.getHistoryMessages(<%=chatType%>,'<%=acceptId%>',10,true);
  		
  		var chatcontent=chatdiv.find('.chatcontent');
  		
  		chatcontent.find("span.modehint").empty(); //输入窗口获得焦点
  		chatcontent.empty().focus()
  		//绑定editor高度缓存
  		
  		<%if(chatType.equals("1")){%>
	  		ChatUtil.getDiscussionInfo("<%=acceptId%>",false,function(discuss){
	  			setTimeout(function(){
	  				ChatUtil.initIMAtwho("<%=acceptId%>");//初始化输入框提示
	  			},3000);
	  			var createrid=getRealUserId(discuss.getCreatorId());
	  			client.writeLog("createrid:"+createrid);
	  			if(createrid==M_USERID){
	  				chatdiv.find(".noteEdit").show();
	  			}
	  			ChatUtil.setDiscussInfo("<%=acceptId%>");
	  			
	  			//设置讨论组信息
				ChatUtil.setCurDiscussInfo('<%=acceptId%>', '<%=chatType%>');
	  		});
  		<%}%>
		//chatdiv.find('.chatRight').perfectScrollbar();
		var chatList=chatdiv.find('.chatList');
		try{
	  		var scrollbarid=IMUtil.imPerfectScrollbar(chatList);
	  		$("#"+scrollbarid).css({"z-index":1001});
	  		IMUtil.imPerfectScrollbar(chatdiv.find('.icrlist'));
	  		IMUtil.imPerfectScrollbar(chatdiv.find('.noteList'));
  		}catch(e){
  			
  		}
  		chatdiv.find('.noteList').perfectScrollbar();
  		chatdiv.find('.chatcontent').perfectScrollbar();
  		//关掉内容格式过滤
  		clearContentHtml(chatdiv.find('.chatcontent'));
  		//滚动条显示在最下方
  		//scrollTOBottom($('#chatdiv_<%=acceptId%> .chatList'));
  		
  		bindUploaderDiv({
	  		"targetid":"uploadImgDiv_<%=acceptId%>",
	  		"contentid":"chatcontent_<%=acceptId%>",
	  		"processBarWidth":180,
	  		"callback":initUploadImg,
	  		"clearProcess":true
  		});
  		
  		bindUploaderDiv({
	  		"targetid":"uploadAccDiv_<%=acceptId%>",
	  		"contentid":"chatcontent_<%=acceptId%>",
	  		"processBarWidth":180,
	  		"callback":initUploadAcc,
	  		"clearProcess":true
  		});
  		
  		bindUploaderDiv({
	  		"targetid":"uploadFile_<%=acceptId%>",
	  		"contentid":"chatcontent_<%=acceptId%>",
	  		"processBarWidth":180,
	  		"callback":initUploadAcc,
	  		"clearProcess":true
  		});
  		
  		//初始化下载按钮效果 
  		/*
  		$(".accitem").live('mouseenter',function(event){
  			$(this).find(".download").show(); 
		}).live('mouseleave',function(event){
  			$(this).find(".download").hide(); 
		})
		*/
		
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
 		bindCloseBtnHover(<%=chatType%>,'<%=acceptId%>');
  });
  
  function bindCloseBtnHover(targettype, targetid){
  	var chatwin=$("#chatWin_"+targettype+"_"+targetid);
 	chatwin.live("hover",function(event){
		if(event.type=='mouseenter'){ 
			$(this).find(".imCloseSpan").css("display", "inline-block");
		}else{ 
		  	$(this).find(".imCloseSpan").css("display", "none");
		} 
	});
	chatwin.find(".chatList").hover(
		function(){
			
		},
		function(){
			var curChatwin = $(this).parents(".chatWin");
			curChatwin.find(".imCloseSpan").css("display", "none");
		}
	);
	chatwin.find(".imtitle").hover(
		function(){
			var curChatwin = $(this).parents(".chatWin");
			curChatwin.find(".imCloseSpan").css("display", "inline-block");
		},
		function(){
			
		}
	);
	chatwin.find(".chattop").hover(
		function(){
			var curChatwin = $(this).parents(".chatWin");
			curChatwin.find(".imCloseSpan").css("display", "inline-block");
		},
		function(){
		}
	);
  }

  //border: 1px solid #7f878a
  /*切换模式*/
  function changeEditMode(obj) {
  	var isTaskMode = false;
  	var sw = $(obj);
  	if(sw.hasClass("modeChangeSwitchActive")){
  		sw.removeClass("modeChangeSwitchActive");
  		$(sw.parents(".chatbottom")[0]).removeClass("chatbottomtaskmode");
  		isTaskMode = false;
  		sw.attr("title", "切换到任务输入");
  		sw.parent().find(".chatcontent").attr("_istaskmode", "0").html("<span class='modehint'>输入您要发送的内容，Enter键发送，Shift+Enter键换行</span>");
  		sw.parent().addClass("chatContentActive").removeClass("chatContentActiveTask");
  	}else{
  		sw.addClass("modeChangeSwitchActive");
  		$(sw.parents(".chatbottom")[0]).addClass("chatbottomtaskmode");
  		isTaskMode = true;
  		sw.attr("title", "切换到普通输入");
  		sw.parent().find(".chatcontent").attr("_istaskmode", "1").html("<span class='modehint'>添加一个新的任务</span>");
  		sw.parent().addClass("chatContentActiveTask").removeClass("chatContentActive");
  	}
  	var appdivs = sw.parents(".chatbottom").find(".chatAppdiv .chatapp");
  	if(isTaskMode){
  		//禁用chatappdiv
  		addDisabledLayer(appdivs);
  	}else{
  		removeDisabledLayer(appdivs);
  	}
  }
  
  function addDisabledLayer(appdivs){
  	appdivs.each(function(){
		var maskLayer = IMUtil.getLayer(IMUtil.getPageOffset(this),"maskLayer");
		$(this).parent().append(maskLayer);
	});
  }
  
  function removeDisabledLayer(appdivs){
  	appdivs.each(function(){
		$(this).parent().find(".maskLayer").remove();
	});
  }
  /*自适应窗口高度*/
  function ajustChatWin(obj){
  	var chatct = $(obj);
  	chatct.perfectScrollbar('update');
  	var chatbottom = chatct.parents(".chatbottom");
  	var ht = chatbottom.height();
  	console.log("聊天窗口底部高度："+ht);
  	var chatdiv = ChatUtil.getchatdiv(obj);
  	var chatlist = chatdiv.find(".chatList");
  	chatlist.perfectScrollbar('update');
  	scrollTOBottom(chatlist);
  	chatlist.css("bottom", ht);
  	
  }
  /*处理编辑时联动*/
  function toggleWithEditing(obj, evt) {
  	evt = evt || window.event;
  	var chatct = $(obj);
  	var htm = chatct.html();
  	var orgHt = chatct.data("orgHeight");
  	if(htm != "" && htm != "<br>"){
  		chatct.parent().find(".immodeChangeSwitch").hide();
  	}else{
  		chatct.parent().find(".immodeChangeSwitch").show();
  	}
  }
  /*处理enter发送消息*/
  function doEnterSend(obj, evt){
  	evt = evt || window.event;
	var keynum;
	if(window.event)
    	keynum=evt.keyCode;
    else
        keynum=evt.which;
    var tempContent = $(obj).html();
    var ht = $(obj).height();
    $(obj).data("orgHeight", ht);
    if(evt.shiftKey&&(keynum==13||keynum==10)){
    	evt.returnvalue = true;
    	return true;
    }
    else if(keynum==13||keynum==10){
    	var atwhoid="atwho-ground-"+$(obj).attr("id");
		if($("#"+atwhoid+" .atwho-view").is(":visible")){
			event.keyCode = 0;//屏蔽回车键
			event.returnvalue = false; 
			stopEvent();
			return false;
		}
    	var mode = getEditMode(obj);
    	if(tempContent == "" || tempContent == "<br>"){
    		return false;
    	}
    	
	  	if(mode == "normal")
	  		ChatUtil.enterIMSend(obj,evt);
	  	else if(mode == "task"){
	  		enterSendTask(obj, evt);
	  	}
	  	//清空编辑器
	  	$(obj).html("").focus();
	  	evt.keyCode = 0;//屏蔽回车键
		evt.returnvalue = false; 
		stopEvent();
	  	return false;
    }else if(event.ctrlKey&&(keynum==90)){
		//ctrl+z
		var cacheContent = ChatUtil.cache.chatContents; 
		if(cacheContent.length > 0){
			var cot = cacheContent.pop();
			ChatUtil.cache.cache4ctrlz.push( $(obj).html());
			$(obj).html(cot);
			IMUtil.moveToEndPos(obj)
		}
	}else if(event.ctrlKey&&(keynum==89)){
		//ctrl+y
		var cache4ctrlz = ChatUtil.cache.cache4ctrlz; 
		if(cache4ctrlz.length > 0){
			var cot = cache4ctrlz.pop();
			ChatUtil.cache.chatContents.push( $(obj).html());
			 $(obj).html(cot);
			IMUtil.moveToEndPos(obj)
		}
	}else if(keynum==8){
		var chds =obj.childNodes;
		if(chds.length == 0) return true;
		$(obj).find("A.hrmecho").each(function(index, elem){
			if(index > 0){
				$(elem).before(" ");
			}
		});
	}
  }
  /*获取当前编辑模式*/
  function getEditMode(chatcontentdiv){
  	var istaskmode = $(chatcontentdiv).attr("_istaskmode");
  	if(istaskmode == '1') return "task";
  	else return "normal";
  }
  /*发送创建任务的消息*/
  function enterSendTask(obj, evt) {
  	var chatdiv = $(obj).parents(".chatdiv")[0];
  	var tempContent = IMUtil.cleanBR($(obj).html());
  	tempContent = tempContent.replace(/&nbsp;/gi, ' ');
  	
  	//创建任务接口(bugy)
  	var shareids = "";
  	var chatWin = $(obj).parents('.chatWin').first();
  	var targetid = chatWin.attr('id').substring(10);
	var targettype = chatWin.attr('id').substring(8,9);
	ChatUtil.getDiscussionInfo(targetid, true, function(){
		shareids = ChatUtil.getMemberids(targettype, targetid);
		$.post("/mobile/plugin/social/SocialMobileOperation.jsp?operation=addtask&tasktitle="+tempContent+"&shareids="+shareids, function(taskinfo){
			taskinfo = $.trim(taskinfo);
			if(taskinfo != ""){
				taskinfo = $.parseJSON(taskinfo);
			}
			var data = {
			"objectName":"FW:CustomShareMsg",
			"shareid":taskinfo.taskid, 
			"sharetype":"task", 
			"sharetitle":tempContent,
			"createdate":taskinfo.createdate, 
			"status":taskinfo.status,
			"creatorid":taskinfo.creatorid};
	  		var tempdiv = ChatUtil.sendIMMsgAuto(chatdiv, 6, data);
	  		var resourcetype = 2;
	  		var resourceid = taskid;
	  		var sharegroupid = targettype=='1'?targettype:"";
	  		var resourceids=ChatUtil.getMemberids(targettype, targetid, true);
	  		$.post("/mobile/plugin/chat/addShare.jsp?resourcetype="+resourcetype+"&resourceid="+resourceid+"&sharegroupid="+sharegroupid,{"resourceids":resourceids},function(){
		    	
		    });
	  	});
	});
  }
</script>