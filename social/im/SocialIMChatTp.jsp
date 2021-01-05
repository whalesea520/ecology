<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.hrm.*" %>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%
    String from=Util.null2String(request.getParameter("from"));
    boolean frompc = "pc".equals(Util.null2String(from));
    String isImgSendCutForbit = Util.null2String(request.getParameter("isImgSendCutForbit"));
    String isFileTransForbit = Util.null2String(request.getParameter("isFileTransForbit"));
    String ifForbitFolderTransfer = Util.null2String(request.getParameter("ifForbitFolderTransfer"));
    String ifForbitShake = Util.null2String(request.getParameter("ifForbitShake"));
    String ifForbitDocShare = Util.null2String(request.getParameter("isDocShareForbit"));
	String ifForbitWfShare = Util.null2String(request.getParameter("isWfShareForbit"));
	String isForbitPrivateChat = Util.null2String(request.getParameter("isForbitPrivateChat"));
    String isOpenDisk = Util.null2String(request.getParameter("isOpenDisk"));
    String isOpenVote = Util.null2String(request.getParameter("isOpenVote"));
    String pcOS = Util.null2String(request.getParameter("pcOS"));
	String ifForbitCustomer = Util.null2String(request.getParameter("ifForbitCustomer"));
    String nwflag = Util.null2String(request.getParameter("nwflag"));
    if(nwflag==null||nwflag.equals("")){
        nwflag = "0";
    }
    boolean pcIsWinodws = "Windows".equals(pcOS);
    boolean pcIsOSX = "OSX".equals(pcOS);
    boolean pcIsLinux = "Linux".equals(pcOS);
    

    String attachmentMaxsize="50";
    User user = HrmUserVarify.getUser (request , response) ;
    String userid=""+user.getUID();
%>
<div id = 'chatdivTemp'>
	<div id="chatdiv_%acceptId%" class="chatdiv">
		<div class="chatleft">
			<!-- 聊天顶部 -->
			<div class="imtitle">
				<span class="imtitleName" title="%targetName%">%targetName%</span>
				<span class="imtitleBlock <% if(frompc){ %><%="can-drag" %><% } %>"></span>
				<span class="contactPhone">
					<img src="/social/images/dept_wev8.png" style="margin-left: 13px;"/>
					<span class="dept"></span>
					<img src="/social/images/mobilephone_wev8.png" style="margin-left: 13px;"/>
					<span class='mobilephone'></span>
					<img src="/social/images/fixphone_wev8.png" style="margin-left: 13px;"/>
					<span class='fixphone'></span>
				</span>
			<% if(nwflag.equals("1")){%>
			<div id="pcChatClose" class="pc-imChatCoseBtn" onclick="PcNewWinUtil.pcChatClose(this)" onmouseenter="PcNewWinUtil.pcChatButtonMouseEnter(this)" onmouseleave="PcNewWinUtil.pcChatButtonMouseLeave(this)" data-title="<%=SystemEnv.getHtmlLabelName(309, user.getLanguage())%>"></div><!-- 关闭 -->	
			<div id="pcChatMax" class="pc-imChatMaxBtn" onclick="PcNewWinUtil.pcChatMax(this)" onmouseenter="PcNewWinUtil.pcChatButtonMouseEnter(this)" onmouseleave="PcNewWinUtil.pcChatButtonMouseLeave(this)" data-title="<%=SystemEnv.getHtmlLabelName(19944, user.getLanguage())%>"></div><!-- 最大化 -->
			<div id="pcChatMin" class="pc-imChatMinBtn" onclick="PcNewWinUtil.pcChatMin(this)" onmouseenter="PcNewWinUtil.pcChatButtonMouseEnter(this)" onmouseleave="PcNewWinUtil.pcChatButtonMouseLeave(this)" data-title="<%=SystemEnv.getHtmlLabelName(19965, user.getLanguage())%>"></div><!-- 最小化 -->
			<div id="pcChatOnTop" class="pc-imChatOnTopBtn" data-title="<%=SystemEnv.getHtmlLabelName(129799, user.getLanguage())%>" onclick="PcNewWinUtil.pcChatOnTopShow(this)" onmouseenter="PcNewWinUtil.pcChatButtonMouseEnter(this)" onmouseleave="PcNewWinUtil.pcChatButtonMouseLeave(this)"></div><!-- 窗口前置 -->
                    <div id = "windowTool" class="pChatcontop clickHide" style="display:none">
                    <div class="topnarrow"></div>
                        <div  class="checkpane" _index="1"></div>
                        <div style="margin:3px;">
                            <div id="tool-1" class="pcontopItme" onclick="PcNewWinUtil.pcChatOnTopTool(this)">
                                <span><%=SystemEnv.getHtmlLabelName(129800, user.getLanguage())%></span><!-- 保持窗口最前 -->
                            </div>
                        </div>
            </div>
			<% }%>
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
					<div class="mname"><%=SystemEnv.getHtmlLabelName(17499, user.getLanguage()) %></div><!-- 更多 -->
				</div>
			</div>
			<div class="chattop chatIMtop <% if(frompc){ %><%="can-drag" %><% } %>">
			
				<div class="signatures <% if(frompc){ %><%="can-drag" %><% } %>" style="float:left;">	
				</div>
			
				<div class="imSetting  <% if(frompc){ %><%="no-drag" %><% } %>" style="float:right;" onclick="IMUtil.doShowSlideDiv('311px', {'onshow':hideChatWinScrollers});"></div>
				<%
                   if("1".equals(isOpenVote)){
                 %>
				<div class="chattabdiv imvote <% if(frompc){ %><%="no-drag" %><% } %>" style="float:right;display:none;" onclick="changeChatTopTab(this,'vote');DiscussUtil.openVotePanel(this);" _target="vote">
					<div class="chattab imvote">投票</div><!-- 投票 -->
				</div>	
				<% }%>
				<div class="chattabdiv imnote <% if(frompc){ %><%="no-drag" %><% } %>" style="float:right;display:none;" onclick="changeChatTopTab(this,'note');DiscussUtil.getHistoryNotes(this);" _target="noteList">
					<div class="chattab imnote"><%=SystemEnv.getHtmlLabelName(23666, user.getLanguage()) %></div><!-- 公告 -->
				</div>
				
				<div class="chattabdiv <% if(frompc){ %><%="no-drag" %><% } %>" style="float:right;" onclick="changeChatTopTab(this,'file');DiscussUtil.getIMFileList(this,'%acceptId%','%chatType%','','',true)" _target="fileList">
					<div class="chattab imfile"><%=SystemEnv.getHtmlLabelName(18493, user.getLanguage()) %></div><!-- 文件 -->
				</div>
				
				<div class="chattabdiv chatActiveTab <% if(frompc){ %><%="no-drag" %><% } %>" style="float:right;" onclick="changeChatTopTab(this,'chat')" _target="chatList">
					<div class="chattab imchat"><%=SystemEnv.getHtmlLabelName(126862, user.getLanguage()) %></div><!-- 聊天 -->
				</div>
					
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
					<div class="right">
						<div class="bSearchdiv">
				            <input type="text" name="q" onkeydown="doSearchAccFile(this,event);" class="keyword" placeholder="<%=SystemEnv.getHtmlLabelName(131669, user.getLanguage()) %>"><!-- 文件标题 -->
				            <span class="input-group-btn" title="<%=SystemEnv.getHtmlLabelName(197, user.getLanguage()) %>" onclick="doSearchAccFile(this,event,true)"></span>
				        </div>
				    </div>
					<div class="clear"></div>
				</div>
				<div class="acclist">
					
				</div>
				<div style="height:40px;line-height:40px;text-align: center;display:none;"><%=SystemEnv.getHtmlLabelName(126864, user.getLanguage()) %></div><!-- 暂时没有附件 -->
			</div>
			<!-- 公告列表 -->
			<div class="chatListbox noteList" id="noteList" style="display:none;">
				<jsp:include page="/social/im/SocialIMNoteList.jsp">
					
				</jsp:include>
			</div>
			<!-- 投票列表 -->
			<div class="chatListbox emessgevoteList" id="emessgevoteList" style="display:none;z-index:100;">
			</div>
			<!-- 聊天底部 -->
			<div class="chatbottom">
				<div class="chatremarkdiv" id="dmUploadAccDiv_%acceptId%">
					<div class="chatAppdiv" id="chatAppdiv">
							<!-- 字体 -->
			 				<div class="chatapp" title="<%=SystemEnv.getHtmlLabelName(129933, user.getLanguage()) %>" onclick="FontUtils.showFontBox(this)" onselectstart="return false" style="background-image: url('/social/images/app_font.png');"><!-- 字体设置 -->
			 					<div id="fontBox_%acceptId%" class="fontBox" style="display:none;" title="" onclick="stopEvent();">
			 						<form id="fontsetform_%acceptId%" action="" method="post" onsubmit="FontUtils.saveConfig(this);return false;">
			 							<table>
			 								<colgroup><col width="160px"><col width="240px"><col width="*"></colgroup>
			 								<tr>
			 									<td><span><%=SystemEnv.getHtmlLabelName(131670, user.getLanguage()) %></span><select name="fontsize" class="fs_selector" onchange="FontUtils.pickFontsize(this)"></select></td><!--  字体大小  -->
			 									<td><span><%=SystemEnv.getHtmlLabelName(131671, user.getLanguage()) %></span><span name="bubblecolor_btn" class="btn_color_pick color_default" onclick="FontUtils.showColorPickPane(this);"><%=SystemEnv.getHtmlLabelName(149, user.getLanguage()) %></span></td> <!--选择气泡颜色， 默认 -->
			 									<td><input type="submit" class="inputStyle e8_btn_top_first" value="<%=SystemEnv.getHtmlLabelName(826, user.getLanguage()) %>"/></td><!-- 确定 -->
			 								</tr>
			 							</table>
			 							<input type='hidden' name='bubblecolor'/>
			 						</form>
			 						<div class="color_pick_pane">
			 							<div class="arrow"></div>
			 							<div class="rec_color"><span class="btn_color_pick btn_spec ellipsis" title="<%=SystemEnv.getHtmlLabelName(131672, user.getLanguage()) %>"><%=SystemEnv.getHtmlLabelName(131673, user.getLanguage()) %></span></div><!-- 打开取色器 ，自定义-->
			 						</div>
								</div>
			 				</div>
                            <!-- 表情 -->
			 				<div class="chatapp" title="<%=SystemEnv.getHtmlLabelName(126865, user.getLanguage()) %>" onclick="showChatPopBox(this)" style="background-image: url('/social/images/app_biaoqing.png');">
			 					<div id="faceBox" class="popBox faceBox clickHide RongIMexpressionWrap" style="display:none;">
			 					
								</div>
			 				</div>
							
							 <%
		                        if(true) {
		                        	if(!isImgSendCutForbit.equals("1")){ 
		                    %>
                             <!-- 图片 -->
							 <div class="chatapp" title="<%=SystemEnv.getHtmlLabelName(74, user.getLanguage()) %>" onclick="hideChatPopBox();" id="uploadImgDiv_%acceptId%" style="background-image: url('/social/images/app_img.png');position:relative;">
								<input type="file" id='uploadImgLayer' name="images[]" multiple="multiple" class="uploadImg" accept="image/gif, image/jpeg, image/png, image/gif, image/bmp">
								<div class="uploadImgLayer" ></div>
							</div>
									<%}if(!isFileTransForbit.equals("1")){ %>
							 <div class="chatapp" title="<%=SystemEnv.getHtmlLabelName(156, user.getLanguage()) %>" onclick="hideChatPopBox();" style="background-image: url('/social/images/icon_acc.png');position:relative;">
								<input type="file" id='uploadAccLayer' name="accfiles[]" multiple="multiple" class="uploadImg">
								<div class="uploadAccLayer"></div>
							</div>
		                     <%
									}
		                        }else {
		                        	if(!isImgSendCutForbit.equals("1")){ 
		                    %>
		                    <!-- flash 模式 -->
                            <!-- 图片 -->
							<div class="chatapp" title="<%=SystemEnv.getHtmlLabelName(74, user.getLanguage()) %>" onclick="hideChatPopBox();" id="uploadImgDiv_%acceptId%" secId="0" maxsize="10" _uploadType="image" style="background-image: url('/social/images/app_img.png');<%if(frompc){ %>position:relative;<%} %>">
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
									<%}if(!isFileTransForbit.equals("1")){ %>
							<div class="chatapp" title="<%=SystemEnv.getHtmlLabelName(156, user.getLanguage()) %>" id="uploadAccDiv_%acceptId%" onclick="hideChatPopBox();" secId="0" maxsize="<%=attachmentMaxsize%>" style="background-image: url('/social/images/icon_acc.png');">
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
		                    <%
									}
		                    	} 
		                    %>
		                    <%
		                        if(frompc && pcIsWinodws && !isImgSendCutForbit.equals("1")) {
		                    %>
                            <!-- 截图 -->
							<div class="chatapp" style="padding-right: 0px;width: 30px">
		                    <div title="<%=SystemEnv.getHtmlLabelName(126866, user.getLanguage()) %>" type="screenshot_div" onclick="ScreenshotUtils.screenshot(this);" style="float: left;width: 16px;height: 25px; background-repeat: no-repeat;background-position: center center; cursor: pointer; overflow: hidden; border: 1px solid #fff;background-image: url('/social/images/app_screenshot.png');"></div>
		                    <div class ="screenshotup" onclick="ChatUtil.showScreenSet(this)" style="background-image: url('/social/images/screenshotup.png');"></div>
							</div>
		                    <%
		                        }
		                    %>
                            <%
                                if(frompc && !"1".equals(ifForbitShake)){
                            %>
                            <!-- 抖动提醒 -->
                            <div class="chatapp" title="<%=SystemEnv.getHtmlLabelName(127147, user.getLanguage()) %>" type="shakeWindow_div" onclick="ShakeWindowUtils.sendShakeMessage(this)" style="display:none; background-image: url('/social/images/app_shakewindow.png');"></div>
                            <%
                                }
                            %>
                            <% if(frompc && !"1".equals(ifForbitFolderTransfer) &&!"1".equals(isFileTransForbit)) { %>
                            <!-- 发送文件夹 -->
                            <div class="chatapp" title="<%=SystemEnv.getHtmlLabelName(126812, user.getLanguage()) %>" type="sendDir_div" onclick="PcSendDirUtils.sendDir(this)" style="display:none; background-image: url('/social/images/app_senddir.png');"></div><!-- 文件夹传输 -->
                            <% } %>
                            <% if(!"1".equals(ifForbitWfShare)) { %>
		                    <!-- 流程 -->
							<div class="chatapp" title="<%=SystemEnv.getHtmlLabelName(18015, user.getLanguage()) %>" onclick="onShowApp(event, 'workflow','#chatcontent_%acceptId%')" style="background-image: url('/social/images/chat_icon_wf_wev8.png');">
							</div>
							<% } %>
							<% if(!"1".equals(ifForbitDocShare)) { %>
							<!-- 文档 -->
							<div class="chatapp" title="<%=SystemEnv.getHtmlLabelName(58, user.getLanguage()) %>" onclick="onShowApp(event, 'doc','#chatcontent_%acceptId%')" style="background-image: url('/social/images/chat_icon_doc_wev8.png');">
							</div>
                            <% } %>
							<!-- 名片 -->
							<div class="chatapp" title="<%=SystemEnv.getHtmlLabelName(126356, user.getLanguage()) %>" onclick="onShowApp(event, 'card','#chatcontent_%acceptId%')" style="background-image: url('/social/images/chat_icon_card_wev8.png');">
							</div>
							 <%
                               if(frompc && "1".equals(isOpenDisk)){
                            %>
							<!-- 云盘 -->
							<div class="chatapp" title="<%=SystemEnv.getHtmlLabelName(129678, user.getLanguage()) %>" onclick="onShowApp(event, 'disk','#chatcontent_%acceptId%')" style="background-image: url('/social/images/chat_icon_disk_wev8.png');">
							</div>
							<%
                                }
                            %>
                            <%
                               if(!"1".equals(ifForbitCustomer)){
                            %>
							<!-- 客户 -->
							<div class="chatapp" title="<%=SystemEnv.getHtmlLabelName(136, user.getLanguage()) %>" onclick="onShowApp(event, 'crm','#chatcontent_%acceptId%')" style="background-image: url('/social/images/chat_icon_crm_wev8.png');">
							</div>
							<%
                                }
                            %>
							<!-- 密聊 -->
							<%
							 if(!"1".equals(isForbitPrivateChat)){
							%>
							<div class="chatapp" title="<%=SystemEnv.getHtmlLabelName(131962, user.getLanguage())%>" onclick="PrivateUtil.openPrivateChat('%acceptId%')"  type="private_div"  style="display:none; background-image: url('/social/images/chat_icon_private_wev8.png');">
							</div>
							<%
									}
							%>
                            <!-- 更多 -->
							<div class="chatapp" style="background-image: url('/social/images/icon_more.png');display:none;" onclick="showChatPopBox(this)">
								<div id="chatMoreApp" title="更多" class="popBox moreApp">
                                    <!-- 文档 -->
									<div class="appitem" title="<%=SystemEnv.getHtmlLabelName(58, user.getLanguage()) %>" onclick="onShowApp(event, 'doc','#chatcontent_%acceptId%')" style="display:none;">
										<span style="margin-right:8px;"><img src="/social/images/app_doc.png" align="absmiddle"></span>
										<span><%=SystemEnv.getHtmlLabelName(58, user.getLanguage()) %></span>
									</div>
                                    <!-- 流程 -->
									<div class="appitem" title="<%=SystemEnv.getHtmlLabelName(18015, user.getLanguage()) %>" onclick="onShowApp(event, 'workflow','#chatcontent_%acceptId%')" style="">
										<span style="margin-right:8px;"><img src="/social/images/app_wf.png" align="absmiddle"></span>
										<span><%=SystemEnv.getHtmlLabelName(18015, user.getLanguage()) %></span> 
									</div>
                                    <!-- 客户 -->
									<div class="appitem" title="<%=SystemEnv.getHtmlLabelName(136, user.getLanguage()) %>" onclick="onShowApp(event, 'crm','#chatcontent_%acceptId%')">
										<span style="margin-right:8px;"><img src="/social/images/app_crm.png" align="absmiddle"></span>
										<span><%=SystemEnv.getHtmlLabelName(136, user.getLanguage()) %></span>
									</div>
                                    <!-- 项目 -->
									<div class="appitem" title="<%=SystemEnv.getHtmlLabelName(101, user.getLanguage()) %>" onclick="onShowApp(event, 'project','#chatcontent_%acceptId%')" style="display:none;">
										<span style="margin-right:8px;"><img src="/social/images/app_proj.png" align="absmiddle"></span>
										<span><%=SystemEnv.getHtmlLabelName(101, user.getLanguage()) %></span>
									</div>
								</div>
							</div>
							
							<div _acceptId="%acceptId%" _chattype="%chatType%" class="chatRecord" onclick="ChatUtil.showChatRecord(this)" style="">
								<%=SystemEnv.getHtmlLabelName(126867, user.getLanguage()) %>
							</div><!-- 消息记录 -->
							
							<div class="clear"></div>
			 		</div>
			 		<div id="chatcontent_%acceptId%" name="chatcontent" class="chatcontent" contenteditable="true" _imgCapturer='1' onkeydown="ChatUtil.enterIMSend(this,event);$(this).perfectScrollbar('update')" onkeyup="ChatUtil.checkTagDeleted(this, event);" onmouseup="//showEditorRightMenu(this, event)"></div>
			 	</div>
			 	
				<div class="chatoption">
					<!-- 提示 -->
                    <!-- 请按 换行-->
					<div class="chatsendtip"><%=SystemEnv.getHtmlLabelName(126868, user.getLanguage()) %><span>Shift+Enter </span><%=SystemEnv.getHtmlLabelName(126869, user.getLanguage()) %></div>
                    <%
                        if(!frompc) {
                    %>
                    <!-- 网页沟通不方便？点此下载客户端-->
                    <div class="remindDownClient" style="max-width:150px;white-space: nowrap;overflow: hidden;text-overflow: ellipsis;" title="<%=SystemEnv.getHtmlLabelName(126870, user.getLanguage()) %>" onclick="window.open('/messager/installm3/emessageproduce.jsp')"><%=SystemEnv.getHtmlLabelName(126870, user.getLanguage()) %></div>
                    <%
                        }
                    %>
                    
                    <!-- 快捷回复 -->
                    <div class="quickreply" onclick="QuickReplyUtil.openQuickreplay('%acceptId%', event)"><%=SystemEnv.getHtmlLabelName(130290, user.getLanguage())%></div>
                    <!-- 发送 -->
					<div onclick="ChatUtil.showSendType(this)" class="chatSendType sendtypeSet" style="width:27px;"></div>
					<div class="chatSend" style="width:55px;" onclick="ChatUtil.sendIMMsg(this)" _senderid="<%=userid%>" _acceptId="%acceptId%" _chattype="%chatType%" _receiverids="%acceptId%">
						<div style="float:left;margin-left:15px;text-align:center;width:34px;letter-spacing:3px;"><%=SystemEnv.getHtmlLabelName(2083, user.getLanguage()) %></div>						
						<div class="sendSplitLine"></div>							
						<div class="clear"></div>
					</div>					
		 			<div class="clear"></div>
				</div>
					<div class="screenshot clickHide" style="display:none">
					<div class="checkpane" _index="0"></div>
					<div class="checkpane" _index="1" style="top:30px;"></div>
					<div style="margin:3px;">
						<div class="screenshotItme" _index="0" onclick="ChatUtil.exeScreenShot(this);">
							<span type="screenShotkey_div"><%=SystemEnv.getHtmlLabelName(126866, user.getLanguage()) %>(Ctrl+Q)</span><!-- 截图(Alt+Q) -->
						</div>
						<div class="screenshotItme" _index="1" onclick="ChatUtil.updateScreenShotSet(this)">
							<span class="ellipsis"><%=SystemEnv.getHtmlLabelName(131668, user.getLanguage()) %></span><!-- 截图时隐藏当前窗口 -->
						</div>
					</div>
				</div>
				<div class="sendtype" style="display:none">
					<div class="checkpane active" _index="1"></div>
					<div class="checkpane" _index="2" style="top:30px;"></div>
					<div style="margin:3px;">
						<div class="sendtypeItme" _index="1" onclick="ChatUtil.updateEnterSet(this)">
							<span class="ellipsis"><%=SystemEnv.getHtmlLabelName(126872, user.getLanguage()) %></span><!-- 按Enter键发送消息 -->
						</div>
						<div class="sendtypeItme" _index="2" onclick="ChatUtil.updateEnterSet(this)">
							<span class="ellipsis"><%=SystemEnv.getHtmlLabelName(126874, user.getLanguage()) %></span><!-- 按Ctrl+Enter键发送消息 -->
						</div>
				</div>
			</div>
		</div>
	</div>
</div>
