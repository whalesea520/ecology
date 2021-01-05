<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<%@ page import="net.sf.json.JSONObject"%>
<%
	String from = Util.null2String(request.getParameter("from"));
	String groupSet = Util.null2String(request.getParameter("groupSet"));
	JSONObject jsonGroupSet = JSONObject.fromObject(groupSet);
	boolean isGroupChatForbit = jsonGroupSet.optString("isGroupChatForbit").equals("1");
	boolean hasGroupChatRight = jsonGroupSet.optString("hasGroupChatRight").equals("1");
%>
<link rel="stylesheet" type="text/css" href="/social/css/im_discuss_wev8.css" />
<!-- 群设置显示区域 -->
<div id="imDiscussSetting" class="imDiscussSetting">
	<div class="dsTitle">
		<span class="setTitle"><%=SystemEnv.getHtmlLabelName(131658, user.getLanguage())%></span><!-- 群设置 -->
		<div class="dsCloseBtn" onclick="IMUtil.doHideSlideDiv(this);" title="<%=SystemEnv.getHtmlLabelName(309, user.getLanguage())%>">×</div><!-- 关闭 -->
	</div>
	<div class="dsBody">
		<%if(!isGroupChatForbit ) { %>
		<div id="discussInfo" class="dsMemberCard">
			<div class="title">
				<div class="left"><%=SystemEnv.getHtmlLabelName(131659, user.getLanguage())%>(<span>0</span>人)</div><!-- 群成员 -->
				<div class="left" style="cursor:pointer;"><a title='<%=SystemEnv.getHtmlLabelName(131660, user.getLanguage())%>' href='javascript:void(0)' onclick='DiscussUtil.addToPrivateGroup(this);'><img src='/social/images/im/im_addto_privategroup_wev8.png' width='20px' height='20px'/></a></div><!-- 创建私人组 -->
				<div class="right" style="cursor:pointer;" onclick="DiscussUtil.showMemberDetails(event);"><%=SystemEnv.getHtmlLabelName(131661, user.getLanguage())%>>></div> <!-- 查看详情 -->
			</div>
			<div class="itemGroove">
				<div class="mitem mtemp" style="display:none;">
					<div>
						<img src="/social/images/head_group.png" class="head28 mhead" onclick="DiscussUtil.showPersonalInfo(this);">
					</div>
					<div class="mname">曾东平</div>
				</div>
				<div class="mitem" style="display:none;">
					<div>
						<img src="/social/images/im/im_dmore_wev8.png" class="head28 mhead">
					</div>
					<div class="mname"><%=SystemEnv.getHtmlLabelName(131654, user.getLanguage())%></div> <!-- 更多 -->
				</div>
			</div>
			<%if( hasGroupChatRight){%>
			<div class="bottom">
				<div class="memberadd" onclick="DiscussUtil.DiscussSetFunc.addMember();">+&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(131662, user.getLanguage())%></div><!-- 添加群成员 -->
			</div>
			<%} %>
		</div>
		<%} %>
		<div class="dsCommonOpList"  onmouseenter="DiscussUtil.DiscussSetFunc.itemMouseHand(this, 1);" onmouseleave="DiscussUtil.DiscussSetFunc.itemMouseHand(this, 0);" <%if(isGroupChatForbit || !hasGroupChatRight) {out.print("style='margin-top:0px;'"); }%>>
			<div class="opItem" _itemIndex="0">
				<div class="left leftpane" style="width: 100px;"><div class="title"><%=SystemEnv.getHtmlLabelName(131663, user.getLanguage())%></div></div><!-- 群聊名称 -->
				<div class="inLine centerpane" style="width: 150px;"><input maxLength='40' class="dsNameInput" value="<%=SystemEnv.getHtmlLabelName(131663, user.getLanguage())%>"/></div><!-- 群聊名称 -->
				<div class="right rightpane"><div onclick="DiscussUtil.DiscussSetFunc.changeDiscussName(this);" class="savebtn"><%=SystemEnv.getHtmlLabelName(86, user.getLanguage())%></div></div><!-- 保存 -->
			</div>
			<!-- 
			<div class="opItem" _itemIndex="1">
				<div class="left leftpane"><div class="title">置顶聊天</div></div>
				<div class="inLine centerpane"></div>
				<div class="right rightpane">
					<div class="switch"><input type="checkbox" tzCheckbox="true"  onclick="DiscussUtil.DiscussSetFunc.setChatToTop(this);"/></div>
				</div>
			</div>
			 -->
			  <div class="opItem" _itemIndex="4">
				<div class="left leftpane"><div class="title"><%=SystemEnv.getHtmlLabelName(130874, user.getLanguage())%></div></div><!-- 群头像 -->
				<div class="inLine centerpane"></div>
				<div class="right rightpane">
					<div class="discussHead">
						<img onclick='DiscussUtil.DiscussSetFunc.setDiscussionIcon(this);' src="/social/images/head_group.png" class="head35 targetHead" onerror="this.src='/social/images/head_group.png'" draggable="false">
					</div>
				</div>
			</div>
			<div class="opItem" _itemIndex="2">
				<div class="left leftpane ellipsis"><div class="title"><%=SystemEnv.getHtmlLabelName(131664, user.getLanguage())%></div></div><!-- 新消息通知 -->
				<div class="inLine centerpane"></div>
				<div class="right rightpane">
					<div class="switch"><input type="checkbox" tzCheckbox="true"  onclick="DiscussUtil.DiscussSetFunc.setNewMsgNotice(this);"/></div>
				</div>
			</div>
			<div class="opItem" _itemIndex="3">
				<div class="left leftpane ellipsis"><div class="title"><%=SystemEnv.getHtmlLabelName(131665, user.getLanguage())%></div></div><!-- 添加到通讯录 -->
				<div class="inLine centerpane"></div>
				<div class="right rightpane">
					<div class="switch"><input type="checkbox" tzCheckbox="true"  onclick="DiscussUtil.DiscussSetFunc.setToAddress(this);"/></div>
				</div>
			</div>
		</div>
		<div class="dsBottom">
			<div onclick="DiscussUtil.DiscussSetFunc.dsDelToQuit();" class="dsDelToQuit"><%=SystemEnv.getHtmlLabelName(131666, user.getLanguage())%></div><!-- 退出本群 -->
		</div>
	</div>
</div>