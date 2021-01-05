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
<link rel="stylesheet" type="text/css" href="/rdeploy/im/css/im_discuss_wev8.css" />
<!-- 群设置显示区域 -->
<div id="imDiscussSetting" class="imDiscussSetting">
	<div class="dsTitle">
		<span class="setTitle">群设置</span>
		<div class="dsCloseBtn" onclick="IMUtil.doHideSlideDiv(this);" title="关闭">×</div>
	</div>
	<div class="dsBody">
		<%if(!isGroupChatForbit && hasGroupChatRight) { %>
		<div id="discussInfo" class="dsMemberCard">
			<div class="title">
				<div class="left">群成员(<span>0</span>人)</div>
				<div class="left" style="display:none;"><a title='创建私人组' href='javascript:void(0)' onclick='DiscussUtil.addToPrivateGroup(this);'><img src='/social/images/im/im_addto_privategroup_wev8.png' width='20px' height='20px'/></a></div>
				<div class="right" style="cursor:pointer;" onclick="DiscussUtil.showMemberDetails(event);">查看详情>></div>
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
					<div class="mname">更多</div>
				</div>
			</div>
			<div class="bottom">
				<div class="memberadd" onclick="DiscussUtil.DiscussSetFunc.addMember();">+&nbsp;&nbsp;添加群成员</div>
			</div>
		</div>
		<%} %>
		<div class="dsCommonOpList" <%if(isGroupChatForbit || !hasGroupChatRight) {out.print("style='margin-top:0px;'"); }%>>
			<div class="opItem" _itemIndex="0" onmouseenter="DiscussUtil.DiscussSetFunc.itemMouseHand(this, 1);" onmouseleave="DiscussUtil.DiscussSetFunc.itemMouseHand(this, 0);">
				<div class="left leftpane"><div class="title">群聊名称</div></div>
				<div class="inLine centerpane"><input maxLength='40' class="dsNameInput" value="群名称"/></div>
				<div class="right rightpane"><div onclick="DiscussUtil.DiscussSetFunc.changeDiscussName(this);" class="savebtn">保存</div></div>
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
			<div class="opItem" _itemIndex="2">
				<div class="left leftpane"><div class="title">新消息通知</div></div>
				<div class="inLine centerpane"></div>
				<div class="right rightpane">
					<div class="switch"><input type="checkbox" tzCheckbox="true"  onclick="DiscussUtil.DiscussSetFunc.setNewMsgNotice(this);"/></div>
				</div>
			</div>
			<div class="opItem" _itemIndex="3">
				<div class="left leftpane"><div class="title">添加到通讯录</div></div>
				<div class="inLine centerpane"></div>
				<div class="right rightpane">
					<div class="switch"><input type="checkbox" tzCheckbox="true"  onclick="DiscussUtil.DiscussSetFunc.setToAddress(this);"/></div>
				</div>
			</div>
		</div>
		<div class="dsBottom">
			<div onclick="DiscussUtil.DiscussSetFunc.dsDelToQuit();" class="dsDelToQuit">退出本群</div>
		</div>
	</div>
</div>