<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.hrm.*" %>
<%
String from=Util.null2String(request.getParameter("from"));
boolean frompc = "pc".equals(from);
String attachmentMaxsize="50";
User user = HrmUserVarify.getUser (request , response) ;
String userid=""+user.getUID();
%>
<div id = 'chatdivTemp'>
	<div id="chatdiv_%acceptId%" class="chatdiv">
		<div class="chatleft">
			<!-- 聊天顶部 -->
			<div class="imtitle">
				<span class="imtitleName" style="color: #3c4350;font-size: 14px;" title="%targetName%">%targetName%</span>
				<span class="imCloseSpan" onclick="closeChatWin(this)">×</span>
			</div>
			<div class="discussInfo clickHide" id="discussInfo_%acceptId%">
				<div class="mitem mtemp" style="display:none;">
					<div>
						<img src="/social/images/head_group.png" class="head28 mhead">
					</div>
					<div class="mname">曾东平</div>
				</div>
				<div class="mitem" onclick="DiscussUtil.showMoreMember('%acceptId%');">
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
				<div class="chattabdiv imnote" style="float:left;display:none;" onclick="changeChatTopTab(this,'note');DiscussUtil.getHistoryNotes(this);" _target="noteList">
					<div class="chattab imnote">公告</div>
				</div>
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
					<jsp:param name="targetid" value="%acceptId%"/> 
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
							
							<div class="chatapp" title="图片" onclick="hideChatPopBox();" id="uploadImgDiv_%acceptId%" secId="0" maxsize="10" _uploadType="image" style="background-image: url('/social/images/app_img.png');position:relative;">
								<span id="holder_uploadImgDiv_%acceptId%" ></span>
								<div class="uploadProcess" id="uploadProcess_uploadImgDiv_%acceptId%">
									<div class="progressDemo hide" id="progressDemo_uploadImgDiv_%acceptId%">
										<div>
											<div class="left fileName p-b-3 ellipsis w180"></div>
											<div class="right fileSize p-l-15"></div>
											<div class="clear"></div>
										</div>
										<div>
											<div class="fileProgress m-b-5">0%</div>
										</div>
									</div>
									<div class="fsUploadProgress" id="fsUploadProgress_uploadImgDiv_%acceptId%"></div>
								</div>
							</div>
							<div class="chatapp" title="附件" id="uploadAccDiv_%acceptId%" secId="0" maxsize="<%=attachmentMaxsize%>" style="background-image: url('/social/images/icon_acc.png');">
								<span id="holder_uploadAccDiv_%acceptId%" ></span>
								<div class="uploadProcess" id="uploadProcess_uploadAccDiv_%acceptId%">
									<div class="progressDemo hide" id="progressDemo_uploadAccDiv_%acceptId%">
										<div>
											<div class="left fileName p-b-3 ellipsis w180"></div>
											<div class="right fileSize p-l-15"></div>
											<div class="clear"></div>
										</div>
										<div>
											<div class="fileProgress m-b-5">0%</div>
										</div>
									</div>
									<div class="fsUploadProgress" id="fsUploadProgress_uploadAccDiv_%acceptId%"></div>
								</div>
							</div>
							
							<div class="chatapp" title="流程" onclick="onShowApp('workflow','#chatcontent_%acceptId%')" style="background-image: url('/social/images/chat_icon_wf_wev8.png');">
							</div>
							
							<div class="chatapp" title="文档" onclick="onShowApp('doc','#chatcontent_%acceptId%')" style="background-image: url('/social/images/chat_icon_doc_wev8.png');">
							</div>
							
							<div class="chatapp" style="background-image: url('/social/images/icon_more.png');display: none;" onclick="showChatPopBox(this)">
								<div id="chatMoreApp" title="更多" class="popBox moreApp">
									<div class="appitem" title="文档" onclick="onShowApp('doc','#chatcontent_%acceptId%')" style="display:none;">
										<span style="margin-right:8px;"><img src="/social/images/app_doc.png" align="absmiddle"></span>
										<span>文档</span>
									</div>
									<div class="appitem" title="流程" onclick="onShowApp('workflow','#chatcontent_%acceptId%')" style="display:none;">
										<span style="margin-right:8px;"><img src="/social/images/app_wf.png" align="absmiddle"></span>
										<span>流程</span> 
									</div>
									<div class="appitem" title="客户" onclick="onShowApp('crm','#chatcontent_%acceptId%')" style="display:none;">
										<span style="margin-right:8px;"><img src="/social/images/app_crm.png" align="absmiddle"></span>
										<span>客户</span>
									</div>
									<div class="appitem" title="项目" onclick="onShowApp('project','#chatcontent_%acceptId%')" style="display:none;">
										<span style="margin-right:8px;"><img src="/social/images/app_proj.png" align="absmiddle"></span>
										<span>项目</span>
									</div>
								</div>
							</div>
							
							<div _acceptId="%acceptId%" _chattype="%chatType%" class="chatRecord" onclick="ChatUtil.showChatRecord(this)" style="display:block;">
								消息记录
							</div>
							
							<div class="clear"></div>
			 		</div>
			 		<div class="chatcontentwrap">
				 		<div id="chatcontent_%acceptId%" name="chatcontent" class="chatcontent" contenteditable="true" _istaskmode="0" _imgCapturer='1'
				 			 onkeyup="toggleWithEditing(this,event);" onkeydown="ajustChatWin(this);return doEnterSend(this, event);"><span class="modehint">输入您要发送的内容，Enter键发送，Shift+Enter键换行</span></div>
				 		<!-- 模式切换 -->
				 		<div class="immodeChangeSwitch" title="切换到任务输入" onclick="changeEditMode(this);"></div>
			 		</div>
			 	</div>
			 	
				<div class="chatoption" style="display:none;">
					<!-- 提示 -->
					<div class="chatsendtip">请按<span>Shift+Enter</span>换行</div>
					<div class="chatSend" style="width:75px;" onclick="ChatUtil.sendIMMsg(this)" _senderid="<%=userid%>" _acceptId="%acceptId%" _chattype="%chatType%" _receiverids="%acceptId%">
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
				</div>
			</div>
		</div>
</div>
<!-- 快速部署版接口封装 -->
<script src="/rdeploy/im/js/IMChat_wev8.js"></script>