
<%@page import="net.sf.json.JSONObject"%>
<%@ page import="net.sf.json.JSONArray"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.hrm.settings.BirthdayReminder"%>
<%@page import="weaver.social.service.*"%>
<%@page import="weaver.social.SocialUtil"%>
<%@page import="weaver.mobile.rong.RongService"%>
<%@page import="weaver.hrm.resource.ResourceComInfo"%>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />

<%
	int userid=user.getUID();
	String menuType=Util.null2String(request.getParameter("menuType"),"homeMenus");
	boolean isShowSubAccount = true;
	boolean isShowAccount = false;
	String keyword = Util.null2String(request.getParameter("keyword"),"");
	SocialIMService socialIMService=new SocialIMService();
	
%>	

<%if(menuType.equals("dept")||menuType.equals("lower")||menuType.equals("tempSearch")||menuType.equals("recent")){
	List<Map<String,String>> hrmList=null;
	Map<String,String> groupIconMap = new HashMap<String,String>();
	if(menuType.equals("dept"))
		hrmList=socialIMService.getSameDeptHrm(user, isShowAccount);
	else if(menuType.equals("lower"))
		hrmList=socialIMService.getLowerHrm(user, isShowAccount);
	else if(menuType.equals("recent"))
		hrmList = socialIMService.getRecentHrm(user, isShowAccount);
	else{
		if(SocialOpenfireUtil.getInstanse().isBaseOnOpenfire()){
			String useridofOpenfire = user.getUID() +"|"+RongService.getRongConfig().getAppUDIDNew().toLowerCase();
			String iconsql  = "select og.groupName,op.propValue from ofGroupUser og,ofGroupProp op where og.groupName=op.groupName and og.username ='"+useridofOpenfire+"' and op.name='group_icon_prop'";
			RecordSet.execute(iconsql);
			while(RecordSet.next()){
				groupIconMap.put(RecordSet.getString("groupName"),RecordSet.getString("propValue"));
			}
		}
		hrmList=socialIMService.getTempSearch(keyword, user, isShowAccount);
	}		
	
	int hrmListSize = hrmList.size();
%>
	<input type="hidden" id="hrmListSize" value="<%=hrmListSize %>"/>
	<%
	ResourceComInfo resourceComInfo=SocialUtil.getResourceComInfo();
	Set<String> groupidSet = new HashSet<String>();
	for(Map<String,String> hrmMap:hrmList){
		
		String isGroup = hrmMap.get("isGroup");
		if(isGroup == null || "0".equals(isGroup)){
			String resourceid=hrmMap.get("resourceid");
			String lastName=hrmMap.get("lastName");
			String deptName=hrmMap.get("deptName");
			String subName=hrmMap.get("subName");
			String jobtitle=hrmMap.get("jobtitle");
			String imageurl=hrmMap.get("imageurl");
			String defaultUri=hrmMap.get("defaultUri");
			//String mobile=resourceComInfo.getMobile(resourceid);
			String mobile = resourceComInfo.getMobileShow(resourceid, user);
			String accountType = "0";//resourceComInfo.getAccountType(resourceid);
			if(!isShowSubAccount && "1".equals(accountType)){
				continue;
			}
	%>
		<div class="chatItem" id = <%=menuType+"_"+ resourceid%> _targetid="<%=resourceid%>" _targetName="<%=lastName%>" _targetHead="<%=imageurl%>" _targetType="0">
			<div class="itemleft" style="float: left;">
				<img src="<%=imageurl%>" class="head35" onerror="this.src='<%=defaultUri%>'"/>
			</div>
			<div class="itemcenter" style="float: left;">
				<div class="lastName ellipsis">
					<div class="name"><%=lastName%></div>
					<img src="/social/images/signatures.png" class="signatures"/>
				</div>
				<div class="deptName ellipsis"><%=deptName%></div>
			</div>
			<div class="itemright" style="float: left;">
				<div class="mobile ellipsis"><%=mobile%></div>
				<div class="subName ellipsis"><%=jobtitle%></div>
			</div>
			<div class="clear"></div>
		</div>
		<%}else{ 
			String groupid=Util.null2String(hrmMap.get("groupid"));
			if(groupidSet.contains(groupid)) continue;
			else groupidSet.add(groupid);
			String targetName=Util.null2String(hrmMap.get("targetName"));
			String defaultUri="/social/images/head_group.png";
			if(groupIconMap.containsKey(groupid)){
					defaultUri = "/weaver/weaver.file.FileDownload?fileid="+groupIconMap.get(groupid);
			}
		%>
		<div class="chatItem groupItem" _targetid="<%=groupid%>" _targetName="<%=targetName%>" _targetHead="/social/images/head_group.png" _targetType="1">
			<div class="itemleft">
				<img src="<%=defaultUri%>" onerror="this.src=/social/images/head_group.png" class="head35 targetHead" />
			</div>
			<div class="itemconverright">
				<div class="groupName ellipsis"><%=targetName%></div>			
			</div>
			<div class="clear"></div>
		</div>
	<%}}%>

<%}else if(menuType.equals("discuss")){
    int isopenfire = Util.getIntValue(request.getParameter("isopenfire"), 0);
	List<Map<String, String>> groupList=RongService.getGroupList(""+userid, isopenfire);
	for(int i=0;i<groupList.size();i++){
		Map<String, String> groupMap=groupList.get(i);
		String groupid=Util.null2String(groupMap.get("groupid"));
		String targetName=Util.null2String(groupMap.get("targetName"));
%>
	<div class="chatItem groupItem" _targetid="<%=groupid%>" _targetName="<%=targetName%>" _targetHead="/social/images/head_group.png" _targetType="1">
		<div class="itemleft">
			<img src="/social/images/head_group.png" class="head35 targetHead"/>
		</div>
		<div class="itemconverright">
			<div class="groupName ellipsis"><%=targetName%></div>
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
