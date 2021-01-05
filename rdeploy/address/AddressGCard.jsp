
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.hrm.settings.BirthdayReminder"%>
<%@page import="weaver.social.service.*"%>
<%@page import="weaver.social.SocialUtil"%>
<%@page import="weaver.hrm.resource.ResourceComInfo"%>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<%
	String targetid = Util.null2String(request.getParameter("targetid"),"");
%>	
<style>
	html,body {
		padding: 0;
		border: 0;
		margin: 0;
	}
	.discussInfoWrap .left{
		float: left;
	}
	.discussInfoWrap .right{
		float: right;
	}
	.discussInfoWrap .dsMemberCard {
		width: 380px;
	  	height: 290px;
	  	background: #fff;
	  	color: #3C4350;
	  	border: 1px solid #e4e4e4;
  		border-radius: 3px;
  		box-shadow: 0px 0px 1px 1px #f7f7f7;
  		margin: 33px auto;
	}
	.discussInfoWrap .dsMemberCard .dsBanner{width: 100%; height: 120px;background: #f2f9fe;}
	.discussInfoWrap .dsMemberCard .dsBanner .dsHead img{
		width: 80px;
  		height: 80px;
  		border-radius: 40px;
  		vertical-align: middle;
	}
	.discussInfoWrap .dsMemberCard .dsBanner .dsHead{
		width: 152px;
 	 	height: 120px;
  		line-height: 120px;
  		display: inline-block;
 		text-align: right;
	}
	.discussInfoWrap .dsMemberCard .dsBanner .dsName{
		width: 192px;
  		height: 100%;
  		line-height: 120px;
  		text-align: left;
  		font-size: 14px;
	}
	.discussInfoWrap .dsMemberCard .title {width: 380px;height: 45px;border-bottom: 1px solid #e4e4e4;}
	.discussInfoWrap .dsMemberCard .title .right:hover {color: #5bb4d7;}
	.discussInfoWrap .dsMemberCard .itemGroove {width: 315px;height: 58px; padding: 33px 33px;}
	.discussInfoWrap .dsMemberCard .itemGroove .mitem {width: 62px;text-align: center;float: left;}
	
	.discussInfoWrap .dsMemberCard .linebox {  padding: 0px 20px;height: 100%;line-height: 45px;}
	.discussInfoWrap .dsMemberCard .linepad22 {  height: 100%; width: 22px;}
		
</style>
<div class="discussInfoWrap">
	<div class="dsMemberCard">
		<div class="dsBanner">
			<div class="dsHead left"><img src="/social/images/head_group.png"/></div>
			<div class="linepad22 left"></div>
			<div class="dsName ellipsis left"></div>
		</div>
		<div class="title">
			<div class="linebox left">群成员<span style="color: #8e9598;">(<span class="membercnt">0</span>人)</span></div>
			<div class="linebox right" style="cursor:pointer;" onclick="parentwin.DiscussUtil.showMoreMember('<%=targetid %>');">查看详情>></div>
		</div>
		<div class="itemGroove">
			<div class="mitem mtemp" style="display:none;">
				<div>
					<img src="/social/images/head_group.png" class="head35 mhead" onclick="DiscussUtil.showPersonalInfo(this);">
				</div>
				<div class="mname">曾东平</div>
			</div>
		</div>
	</div>
</div>
<script>
	discussid = "<%=targetid%>";
	parentwin = window.parent;
	DIS_LIMIT_CNT = 5;
	parentwin.ChatUtil.getDiscussionInfo(discussid, true, setDiscussInfo);
	function setDiscussInfo(discuss) {
		try{
			var discussInfoWrap = $(".discussInfoWrap");
			var itemGroove = $(".discussInfoWrap .itemGroove");
			var memberIds=discuss.getMemberIdList();
			var createrid=parentwin.getRealUserId(discuss.getCreatorId());
			itemGroove.find(".members").remove();
			itemGroove.prepend(getMitem(itemGroove, createrid));
			var cnt = 1;
			var memberinfo,memberid;
			for(var i=memberIds.length-1;i>=0;i--){
				if(cnt == DIS_LIMIT_CNT) break;
				memberid = parentwin.getRealUserId(memberIds[i]);
				var mitem= getMitem(itemGroove, memberid);
				if(memberid != createrid){
					itemGroove.append(mitem);
					cnt++;
				}
			}
			discussInfoWrap.find(".membercnt").html(memberIds.length);
			discussInfoWrap.find(".dsName").html(discuss.getName());
		}catch(e){
			parentwin.client.error(e,"设置群名片失败");
		}
	}
	
	function getMitem(itemGroove, memberid){
		var mitem = itemGroove.find(".mtemp").clone().
			removeClass("mtemp").addClass("members").show();
		var memberinfo=parentwin.getUserInfo(memberid);
		mitem.attr('resourceid', memberid);
		mitem.find(".mhead").attr("src",memberinfo.userHead);
		mitem.find(".mname").html(memberinfo.userName);
		return mitem;
	}
</script>





