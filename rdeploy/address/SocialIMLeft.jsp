
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
	
	String keyword = Util.null2String(request.getParameter("keyword"),"");
	SocialIMService socialIMService=new SocialIMService();
%>	

<%if(menuType.equals("dept")||menuType.equals("lower")||menuType.equals("tempSearch")){
	List<Map<String,String>> hrmList=null;
	if(menuType.equals("dept"))
		hrmList=socialIMService.getSameDeptHrm(""+userid);
	else if(menuType.equals("lower"))
		hrmList=socialIMService.getLowerHrm(""+userid);
	else if(menuType.equals("recent"))
		hrmList = socialIMService.getRecentHrm(""+userid);
	else
		hrmList=socialIMService.getTempSearch(keyword);
	
	int hrmListSize = hrmList.size();
%>
	<input type="hidden" id="hrmListSize" value="<%=hrmListSize %>"/>
	<%
	ResourceComInfo resourceComInfo=SocialUtil.getResourceComInfo();
	for(Map<String,String> hrmMap:hrmList){
		String resourceid=hrmMap.get("resourceid");
		String lastName=hrmMap.get("lastName");
		String deptName=hrmMap.get("deptName");
		String subName=hrmMap.get("subName");
		String jobtitle=hrmMap.get("jobtitle");
		String imageurl=hrmMap.get("imageurl");
		
		String mobile=resourceComInfo.getMobile(resourceid);
		
	%>
		<div class="chatItem" onclick="doItemClick(this)" _targetid="<%=resourceid%>" _targetName="<%=lastName%>" _targetHead="<%=imageurl%>" _targetType="0">
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
		</div>
	<%}%>

<%}else if(menuType.equals("discuss")){
	List<String> groupList=RongService.getGroupList(user);
	for(int i=0;i<groupList.size();i++){
		String groupid=groupList.get(i);
%>
	<div class="chatItem groupItem" onclick="showConverChatpanel(this)" _targetid="<%=groupid%>" _targetName="" _targetHead="/social/images/head_group.png" _targetType="1">
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