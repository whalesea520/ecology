
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
	
    boolean frompc = Boolean.parseBoolean(request.getParameter("frompc"));
%>

	
<!-- 聊天页面 -->
<div id="chatdiv_<%=acceptId%>" class="chatdiv">
<div class="chatleft">
	<!-- 聊天顶部 -->
	<div class="imtitle <% if(frompc){ %><%="can-drag" %><% } %>">
		<span class="imtitleName" style="color:#5cb5d8" title="<%=targetName%>"><%=targetName%></span>
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
	<div class="chattop chatIMtop <% if(frompc){ %><%="can-drag" %><% } %>">
		<div class="chattabdiv chatActiveTab <% if(frompc){ %><%="no-drag" %><% } %>" style="float:left;" onclick="changeChatTopTab(this,'chat')" _target="chatList">
			<div class="chattab imchat">聊天</div>
		</div>
		<div class="chattabdiv <% if(frompc){ %><%="no-drag" %><% } %>" style="float:left;" onclick="changeChatTopTab(this,'file');DiscussUtil.getIMFileList(this,'<%=acceptId%>','<%=chatType %>')" _target="fileList">
			<div class="chattab imfile">文件</div>
		</div>
		<%if(chatType.equals("1")){%>
			<div class="chattabdiv imnote <% if(frompc){ %><%="no-drag" %><% } %>" style="float:left;" onclick="changeChatTopTab(this,'note');DiscussUtil.getHistoryNotes(this);" _target="noteList">
				<div class="chattab imnote">公告</div>
			</div>
		<%}%>
		<div class="imSetting  <% if(frompc){ %><%="no-drag" %><% } %>" onclick="IMUtil.doShowSlideDiv('311px', DiscussUtil.DiscussSetFunc.setDsNameDisabled);"></div>
		<div class="clear"></div>
		<div class="chatArrow"></div>
	</div>
	
	<!-- 聊天记录 -->
	<div class="chatListbox chatList chatRecord scroll-pane" id="chatList" >
	
	</div>
	
	<!-- 文件列表 -->
	<div class="chatListbox fileList" id="fileList" style="display:none;">
	   <div class="fileListTop">
			<div class="left" style="margin-left:25px;">
				<img src="/social/images/icon_acc.png" align="absmiddle">
				<span class="fileCount">(0)</span>
			</div>
			<div class="downloadAll" style="margin-top:15px;width:75px;cursor:pointer;display:none;">下载全部</div>
			<div class="downloadAll uploadFile" onclick="showPopBox(this);" style="margin-top:15px;width:75px;float:right;margin-right:10px;background-color:#5cb5d7;cursor:pointer;display:none;">上传文件
				<div class="popBox imgBox">
					<div class="imgArrow"></div>
					<div secId="0" maxsize="<%=attachmentMaxsize%>" id="uploadFile_<%=acceptId%>">
						<span id="holder_uploadFile_<%=acceptId%>" ></span>
					</div>
					
					<div class="uploadProcess" id="uploadProcess_uploadFile_<%=acceptId%>">
						<div class="progressDemo hide" id="progressDemo_uploadFile_<%=acceptId%>">
							<div>
								<div class="left fileName p-b-3 ellipsis w180"></div>
								<div class="right fileSize p-l-15"></div>
								<div class="clear"></div>
							</div>
							<div>
								<div class="fileProgress m-b-5">0%</div>
							</div>
						</div>
						<div class="fsUploadProgress" id="fsUploadProgress_uploadFile_<%=acceptId%>"></div>
					</div>
				</div>
			</div>
			<div class="clear"></div>
		</div>
		<div class="acclist" style="height:480px;overflow-y:auto;">
			
		</div>
		<div style="height:40px;line-height:40px;text-align: center;display:none;">暂时没有附件</div>
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
					
					 <%
                        if(frompc) {
                    %>
					 <div class="chatapp" title="图片" onclick="hideChatPopBox();" id="uploadImgDiv_<%=acceptId%>" style="background-image: url('/social/images/app_img.png');position:relative;">
						<input type="file" name="images[]" multiple="multiple" class="uploadImg" accept="image/gif, image/jpeg, image/png, image/gif">
						<div class="uploadImgLayer"></div>
					</div>
					 <div class="chatapp" title="附件" onclick="hideChatPopBox();" id="uploadAccDiv_<%=acceptId%>" style="background-image: url('/social/images/icon_acc.png');position:relative;">
						<input type="file" name="accfiles[]" multiple="multiple" class="uploadImg">
						<div class="uploadImgLayer"></div>
					</div>
                     <%
                        }else {
                    %>
                    <!-- flash 模式 -->
					<div class="chatapp" title="图片" onclick="hideChatPopBox();" id="uploadImgDiv_<%=acceptId%>" secId="0" maxsize="10" _uploadType="image" style="background-image: url('/social/images/app_img.png');<%if(frompc){ %>position:relative;<%} %>">
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
                    <%
                    	} 
                    %>
                    <%
                        if(frompc) {
                    %>
                    <div class="chatapp" title="截屏 Ctrl + Q" onclick="ScreenshotUtils.screenshot(this);" style="background-image: url('/social/images/app_screenshot.png');"></div>
                    <%
                        }
                    %>
                    
					<div class="chatapp" title="流程" onclick="onShowApp('workflow','#chatcontent_<%=acceptId%>')" style="background-image: url('/social/images/chat_icon_wf_wev8.png');">
					</div>
					
					<div class="chatapp" title="文档" onclick="onShowApp('doc','#chatcontent_<%=acceptId%>')" style="background-image: url('/social/images/chat_icon_doc_wev8.png');">
					</div>
					<div class="chatapp" title="客户" onclick="onShowApp('crm','#chatcontent_<%=acceptId%>')" style="background-image: url('/social/images/chat_icon_crm_wev8.png');display:none;">
					</div>
					<div class="chatapp" style="background-image: url('/social/images/icon_more.png');display:none;" onclick="showChatPopBox(this)">
						<div id="chatMoreApp" title="更多" class="popBox moreApp">
							<div class="appitem" title="文档" onclick="onShowApp('doc','#chatcontent_<%=acceptId%>')" style="display:none;">
								<span style="margin-right:8px;"><img src="/social/images/app_doc.png" align="absmiddle"></span>
								<span>文档</span>
							</div>
							<div class="appitem" title="流程" onclick="onShowApp('workflow','#chatcontent_<%=acceptId%>')" style="">
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
					
					<div _acceptId="<%=acceptId%>" _chattype="<%=chatType%>" class="chatRecord" onclick="ChatUtil.showChatRecord(this)" style="">
						消息记录
					</div>
					
					<div class="clear"></div>
	 		</div>
	 		<div id="chatcontent_<%=acceptId%>" name="chatcontent" class="chatcontent" contenteditable="true" _imgCapturer='1' onkeydown="ChatUtil.enterIMSend(this,event);$(this).perfectScrollbar('update')"></div>
	 	</div>
	 	
		<div class="chatoption">
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
</div>
<script>

  $(document).ready(function(){
  		
  		var chatdiv=$("#chatdiv_<%=acceptId%>"); //聊天窗口对象
  		
  		//发布公告相关
  		DiscussUtil.bindEscape(chatdiv);
  		
  		drawExpressionWrap('<%=acceptId%>');
  		
  		var chatcontent=chatdiv.find('.chatcontent');
  		
  		chatcontent.focus(); //输入窗口获得焦点
  		
  		<%if(chatType.equals("1")){%>
	  		ChatUtil.getDiscussionInfo("<%=acceptId%>",true,function(discuss){
				var targetid="<%=acceptId%>";
				//设置群信息
				ChatUtil.setCurDiscussInfo('<%=acceptId%>', '<%=chatType%>');

				if(!discuss){

					 $("#conversation_"+targetid).remove();
					 closeTabWin($("#chatTab_1_"+targetid+" .tabClostBtn"));

					$('.dataLoading').fadeOut(); //去除loading提示	
					return ;
				}

				ChatUtil.getHistoryMessages(<%=chatType%>,'<%=acceptId%>',10,true);
	  			setTimeout(function(){
	  				ChatUtil.initIMAtwho("<%=acceptId%>");//初始化输入框提示
	  			},2000);
	  			var createrid=getRealUserId(discuss.getCreatorId());
	  			client.writeLog("createrid:"+createrid);
	  			if(createrid==M_USERID){
	  				chatdiv.find(".noteEdit").show();
	  			}
	  			
	  		});
  		<%}else{%>
			ChatUtil.getHistoryMessages(<%=chatType%>,'<%=acceptId%>',10,true);
		<%}%>
		//chatdiv.find('.chatRight').perfectScrollbar();
		var chatList=chatdiv.find('.chatList');
  		var scrollbarid=IMUtil.imPerfectScrollbar(chatList);
  		$("#"+scrollbarid).css({"z-index":1001});
  		
  		IMUtil.imPerfectScrollbar(chatdiv.find('.acclist'));
  		IMUtil.imPerfectScrollbar(chatdiv.find('.noteList'));
  		//增加参数防止滚动条对空格输入的影响 1125 by wyw
  		chatdiv.find('.chatcontent').perfectScrollbar({'spacebarenabled':false});
  		//关掉内容格式过滤
  		clearContentHtml(chatdiv.find('.chatcontent'));
  		//滚动条显示在最下方
  		//scrollTOBottom($('#chatdiv_<%=acceptId%> .chatList'));
  		<%
  			if(frompc){
  		%>
  		bindDmUploader("uploadImgDiv_<%=acceptId%>", {
  			"allowedTypes": "image/(?:png|jpeg|bmp|gif)",
  			"extraData": {"uploadType": "image"},
  			"extFilter":"png;jpg;jpeg;bmp;gif",
  			"targetid": "<%=acceptId%>",
  			"fireBtnCls": "uploadImgLayer",
  			"successcallback": initUploadImg
  		});
  		bindDmUploader("uploadAccDiv_<%=acceptId%>", {
  			"allowedTypes": ".*",
  			"extraData": {"uploadType": "acc"},
  			"targetid": "<%=acceptId%>",
  			"fireBtnCls": "uploadImgLayer",
  			"successcallback": initUploadAcc
  		});
  		
  		<%
  			}else{
  		%>
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
  		<%
  			}
  		%>
  		
  		bindUploaderDiv({
	  		"targetid":"uploadFile_<%=acceptId%>",
	  		"contentid":"chatcontent_<%=acceptId%>",
	  		"processBarWidth":180,
	  		"callback":initUploadAcc,
	  		"clearProcess":true
  		});
  });
  
</script>




