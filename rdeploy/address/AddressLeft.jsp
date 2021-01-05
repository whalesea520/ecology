
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.hrm.settings.BirthdayReminder"%>
<%@page import="weaver.social.service.*"%>
<%@page import="weaver.social.SocialUtil"%>
<%@page import="weaver.mobile.rong.RongService"%>
<%@page import="weaver.hrm.resource.ResourceComInfo"%>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<%
	int userid=user.getUID();
	String menuType=Util.null2String(request.getParameter("menuType"),"homeMenus");
	String uid = Util.null2String(request.getParameter("uId"),userid + "");
	if(uid.equals("")) uid = userid+"";
	else if(!uid.equals(userid+"")){
		return;
	}
	String keyword = Util.null2String(request.getParameter("keyword"),"");
	SocialIMService socialIMService=new SocialIMService();
%>	

<%if(menuType.equals("dept")||menuType.equals("lower")||menuType.equals("tempSearch")||menuType.equals("recent")){
	List<Map<String,String>> hrmList=null;
	if(menuType.equals("dept"))
		hrmList=socialIMService.getSameDeptHrm(""+userid);
	else if(menuType.equals("lower"))
		hrmList=socialIMService.getLowerHrm(uid);
	else if(menuType.equals("recent"))
		hrmList = socialIMService.getRecentConvers(""+userid);
	else
		hrmList=socialIMService.getTempSearch(keyword);
	
	int hrmListSize = hrmList.size();
%>
	<input type="hidden" id="hrmListSize" value="<%=hrmListSize %>"/>
	<%
	ResourceComInfo resourceComInfo=SocialUtil.getResourceComInfo();
	if(menuType.equals("recent")){
		for(Map<String,String> hrmMap:hrmList){
			String targetid = hrmMap.get("targetid");
			String targetname = hrmMap.get("targetname");
			String mobile = hrmMap.get("mobile");
			String telephone = hrmMap.get("telephone");
			String py = hrmMap.get("py");
			String targettype = hrmMap.get("targettype");
			String lasttime = hrmMap.get("lasttime");
			if(targettype.equals("0")){
				String imageurl=SocialUtil.getUserHeadImage(targetid);
				String deptName=SocialUtil.getUserDepCompany(targetid);
				String subName=SocialUtil.getUserSubCompany(targetid);
				String jobtitle=SocialUtil.getUserJobTitle(targetid);
			%>
				<div class="chatItem" _targetid="<%=targetid%>" _targetName="<%=targetname%>" _targetHead="<%=imageurl%>" _targetType="0">
					<div class="itemleft" style="float: left;">
						<img src="<%=imageurl%>" class="head35"/>
					</div>
					<div class="itemcenter" style="float: left;">
						<div class="lastName ellipsis"><%=targetname%></div>
						<div class="deptName ellipsis"><%=deptName%></div>
					</div>
					<div class="itemright" style="float: left;">
						<div class="mobile ellipsis"><%=mobile%></div>
						<div class="subName ellipsis"><%=jobtitle%></div>
					</div>
					<div class="clear"></div>
				</div>
			<%}else if(targettype.equals("1")){
				String imageurl = "/social/images/head_group.png";
			%>
				<div class="chatItem dsItem" _targetid="<%=targetid%>" 
				_targetName="<%=targetname%>" _targetHead="<%=imageurl%>" _targetType="<%=targettype %>">
					<div class="itemleft" style="float: left;">
						<img src="<%=imageurl%>" class="head35"/>
					</div>
					<div class="itemcenter" style="float: left;">
						<div class="lastName ellipsis"><%=targetname%></div>
					</div>
					<div class="itemright" style="float: left;">
					</div>
					<div class="clear"></div>
				</div>
			<%} %>
		<%} %>
	<%}else 
		for(Map<String,String> hrmMap:hrmList){
			String resourceid=hrmMap.get("resourceid");
			String lastName=hrmMap.get("lastName");
			String deptName=hrmMap.get("deptName");
			String subName=hrmMap.get("subName");
			String jobtitle=hrmMap.get("jobtitle");
			String imageurl=hrmMap.get("imageurl");
			int subLowerSize = 0;
			String display = "none";
			//String display = "block";
			//如果是下属，则带出下属的下属人数
			if(menuType.equals("lower")){
				List subLowers = socialIMService.getLowerHrm(resourceid);
				subLowerSize = subLowers.size();
				if(subLowerSize > 0) display = "block";
			}
			
			String mobile=resourceComInfo.getMobile(resourceid);
		
	%>
		<div class="chatItem" _targetid="<%=resourceid%>" _targetName="<%=lastName%>" _targetHead="<%=imageurl%>" _targetType="0">
			<div class="itemleft" style="float: left;">
				<img src="<%=imageurl%>" class="head35"/>
			</div>
			<div class="itemcenter" style="float: left;">
				<div class="lastName ellipsis"><%=lastName%></div>
				<div class="deptName ellipsis"><%=deptName%></div>
			</div>
			<div class="itemright" style="float: left;">
				<div class="mobile ellipsis"><%=mobile%></div>
				<div class="subName ellipsis"><%=jobtitle%></div>
			</div>
			<div class="clear"></div>
			<div class="lowerCnt" style="display:<%=display %>" 
				onclick="loadIMDataList('lower', '<%=resourceid%>');event.stopPropagation();event.cancelBubble=true;">
				<div class="lowerCntSpan"><%=subLowerSize %></div>
			</div>
		</div>
	<%}%>

<%}else if(menuType.equals("discuss")){
	List<String> groupList=RongService.getGroupList(user);
	for(int i=0;i<groupList.size();i++){
		String groupid=groupList.get(i);
%>
	<div class="chatItem groupItem" _targetid="<%=groupid%>" _targetName="" _targetHead="/social/images/head_group.png" _targetType="1">
	<div class="itemleft">
		<img src="/social/images/head_group.png" class="head35 targetHead"/>
	</div>
	<div class="itemconverright">
		<div class="groupName">
			未知群组
		</div>
	</div>
	<div class="clear"></div>
</div>
<%}
}%>
<script>
$(document).ready(function(){
	//$('#leftmyattlist').perfectScrollbar();
	$('.childrenMenus').perfectScrollbar();
	
	$('#recentChatList').find('.chatitem').hover(function(){
		$(this).find('.clearchat').show();
	}, function(){ $(this).find('.clearchat').hide(); });
	
	$('#recentChatList').find('.clearchat').bind('click',function(){
		var clearbtn = $(this);
		var _chatType=$(this).attr("_chatType"); 
		var _acceptId=$(this).attr("_acceptId");
		
		var params = {
		  "operation":"clearlastchat",
		  "chatType":_chatType,
		  "acceptId":_acceptId};
		  console && console.info(params);
		$.post("/social/group/SocialChatOperation.jsp",params,function(result){
			clearbtn.parents('.childrenItem').remove();
		});	
	
		stopEvent();
	});
});

</script>