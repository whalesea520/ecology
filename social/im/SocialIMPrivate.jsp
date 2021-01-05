<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<html>
	<head>
			<script type="text/javascript" src="/social/im/js/im_privateChat_wev8.js"></script>
			<script src="/social/im/js/IMUtil_wev8.js"></script>
			<link rel="stylesheet" href="/social/css/im_privateChat_wev8.css" type="text/css" />
	</head>
	<body>
			<div class="titlebar">
				<%=SystemEnv.getHtmlLabelName(131962, user.getLanguage())%>
					<div class="btnGroup">
						<div class="sendBtn" onclick="PrivateUtil.launchedPrivateChat(event)"><%=SystemEnv.getHtmlLabelName(131964, user.getLanguage())%></div>
					</div>
			</div>	
			<div id="privateRecentListdiv" class="leftMenudiv scrollbar" style="overflow-x: auto; overflow-y: hidden; display: block; outline: none;">
				<div id="privateLoading" class='dataloading' style='text-align:center;height:50%;padding-top:50%;'>
					<img src='/social/images/loading_large_wev8.gif' />
				</div>			
			</div>
			<div class="footbar">
					<div class = "leftItem unselected" onclick="PrivateChatUtil.onSelectedAll(this)"><%=SystemEnv.getHtmlLabelName(131965, user.getLanguage())%></div>
					<div class = "rightItem" onclick="PrivateChatUtil.deleteConverChatpanel()"><%=SystemEnv.getHtmlLabelName(131966, user.getLanguage())%></div>
				</div>
			<!-- 密聊会话模板 -->
			<div class="privateConverTemp chatItem"   style="display:none;">
				<div class="itemleft"  onclick="PrivateChatUtil.onSelected(this)" >
					<div class="leftItem unselected" ></div>
					<div class="rightItem"><img src="/messager/images/icon_m_wev8.jpg" class="head35 targetHead" onerror="this.src='/messager/images/icon_m_wev8.jpg'"/></div>
				</div>
				<div class="itemconverright" onclick="PrivateChatUtil.showConverChatpanel(this)">
					<div>
						<div class="targetName ellipsis left">
							<span class="name"></span>
							<span class="signatures"></span>
						</div>
						<div class="latestTime right"></div>
						<div class="clear"></div>
					</div>
					<div style="margin-top:20px;">
						<div class="deptname ellipsis left"></div>
						<div class="msgcount right" _msgcount="0" >0</div>
						<div class="clear"></div>
					</div>
				</div>
				<div class="clear"></div>
			</div>
			<script type="text/javascript">	
			 var deleteText ="<%=SystemEnv.getHtmlLabelName(131966, user.getLanguage())%>";
			 var deleteImConfirm = 	"<%=SystemEnv.getHtmlLabelName(132207, user.getLanguage())%>";			
				PrivateChatUtil.init();				
			</script>
	</body>
</html>