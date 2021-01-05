
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.social.service.SocialOpenfireUtil"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@page import="weaver.mobile.rong.RongService"%>
<%@ page import="weaver.social.po.SocialClientProp" %>
<%@ include file="/systeminfo/init_wev8.jsp"%>
<jsp:useBean id="SocialIMService" class="weaver.social.service.SocialIMService" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<%
int userid=user.getUID();
String tabid = Util.null2String(request.getParameter("tabid"));
String searchName = Util.null2String(request.getParameter("searchName"));
String titlename = "" + SystemEnv.getHtmlLabelName(571,user.getLanguage()) + ":" + SystemEnv.getHtmlLabelName(93,user.getLanguage());
%>


<script type="text/javascript" src="/js/weaver_wev8.js"></script>
<link type="text/css" rel="stylesheet" href="/css/Weaver_wev8.css" />
<script type="text/javascript" src="/js/ecology8/jNice/jNice/jquery.jNice_wev8.js"></script>
<link rel="stylesheet" href="/js/ecology8/jNice/jNice/jNice_wev8.css" type="text/css" />
<style>
	.chatItemWrap{
		font-size: 12px;
	    height: 400px;
	    /* border: 1px solid red; */
	    overflow: auto;
	}
	.chatItem{
	    padding-top: 10px;
	    padding-bottom: 10px;
	    cursor: pointer;
	    padding-left: 15px;
	    height: 40px;
	    width: 409px;
	}
	
	.chatItem .itemleft {
		float: left;
    	margin-right: 10px;
	}
	.head35 {
	    width: 35px;
	    height: 35px;
	    -webkit-border-radius: 30px;
	    -moz-border-radius: 30px;
	    border-radius: 30px;
	    cursor: pointer;
	}
	.chatItem .itemconverright {
	    float: left;
	    width: 240px;
	}
	.chatItem .groupName {
	    color: #384560;
	    height: 35px;
	    line-height: 35px;
	}
	.ellipsis {
	    text-overflow: ellipsis;
	    white-space: nowrap;
	    overflow: hidden;
	}
	.msgcontent {
		color: #B3BED8;
	}
	.selected {
		background: #efefef url("/social/images/select_wev8.png") no-repeat 95% center;
		border-top: 1px solid #fff;
	}
</style>
</head>

<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%
RCFromPage="mailOption";//屏蔽右键菜单时使用
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:saveInfo(),_self} " ;    
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<body>
<wea:layout attributes="{layoutTableId:topTitle}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
			<input type="text" class="searchInput"  id="searchName" name="searchName" value="<%=searchName %>"/>
			<span title="菜单" class="cornerMenu"></span>
		</wea:item>
	</wea:group>
</wea:layout>

<form method="post" action="MailMaintOperation.jsp" name="weaver">
<div class="chatItemWrap">
<%
if(tabid.equals("recent")){
	List<Map<String, String>> mapList = SocialIMService.getConvers(userid+"");
	String queryMemCountSql = "select t3.targetid, count(t3.targetid)from social_IMRecentConver t3 where EXISTS " +
	"( " +
	"select * from social_IMRecentConver  t1  " +
	"left join social_IMConversation t2 on t1.targetid=t2.targetid  " +
	"where t1.userid='"+userid+"' and t1.targetid=t2.targetid and t2.targettype = '1' and t3.targetid = t1.targetid " +
	") group by t3.targetid ";
	rs.execute(queryMemCountSql);
	HashMap<String, Integer> targetCountMap = new HashMap<String, Integer>();
	while(rs.next()){
		targetCountMap.put(rs.getString(1), rs.getInt(2));
	}
	Map<String, String> converMap = null;
	String defaultHeadM = "/messager/images/icon_m_wev8.jpg";
	String defaultHeadW = "/messager/images/icon_w_wev8.jpg";
	String defaultHeadG = "/social/images/head_group.png";
	String defaultHead = "", targetType, targetId, msgContent="",targetName, targetHead=null;
	for(int i = 0; i < mapList.size(); ++i){
		converMap = mapList.get(i);
		targetName = Util.null2String(converMap.get("targetname"));
		if(!searchName.equals("") && targetName.indexOf(searchName) == -1){
			continue;
		}
		targetType = Util.null2String(converMap.get("targettype"));
		targetId = Util.null2String(converMap.get("targetid"));
		if(targetType.equals("0")){
			String sex = ResourceComInfo.getSexs(targetId);
			if("0".equals(sex)){
				defaultHead = defaultHeadM;
			}else{
				defaultHead = defaultHeadW;
			}
			//人员岗位信息
			String deptid=ResourceComInfo.getDepartmentID(targetId);
			String subcompid=ResourceComInfo.getSubCompanyID(targetId);
			String deptName = DepartmentComInfo.getDepartmentName(deptid);
			String subCompName = SubCompanyComInfo.getSubcompanyname(subcompid);
			targetHead = ResourceComInfo.getMessagerUrls(targetId);
			msgContent = deptName + "/" + subCompName;
		}else if(targetType.equals("1")){
			defaultHead = defaultHeadG;
			targetHead = null;
			msgContent = Util.null2String(targetCountMap.get(targetId)+"", "1") + "人";
		}else{
			continue;
		}
	%>
	
	<div class="chatItem" onclick="doSelect(this)" _targetid="<%=targetId%>" _targetName="<%=targetName%>" _targetHead="<%=defaultHead %>" _targetType="<%=targetType %>">
		<div class="itemleft">
			<img src="<%=Util.null2String(targetHead, defaultHead) %>" class="head35 targetHead" onerror="this.src='<%=defaultHead %>'"/>
		</div>
		<div class="itemconverright">
			<div>
				<div class="targetName ellipsis left"><%=Util.null2String(converMap.get("targetname")) %></div>
				<div class="latestTime right"></div>
				<div class="clear"></div>
			</div>
			<div style="margin-top:3px;">
				<div class="msgcontent ellipsis left"><%=msgContent %></div>
				<div class="msgcount right"></div>
				<div class="clear"></div>
			</div>
		</div>
		<div class="clear"></div>
	</div>
	
	<%}%>
<%}else if(tabid.equals("group")){ %>
	<%
	//是否禁用群聊
	boolean isGroupChatForbit = "1".equals(SocialClientProp.getPropValue(SocialClientProp.FORBIT_GROUPCHAT));
	if(isGroupChatForbit){
		return;
	}
	List<Map<String, String>> groupList=RongService.getGroupList(""+userid, SocialOpenfireUtil.getInstanse().isBaseOnOpenfire() ? 1 : 0);
	for(int i=0;i<groupList.size();i++){
		Map<String, String> groupMap=groupList.get(i);
		String groupid=Util.null2String(groupMap.get("groupid"));
		String targetName=Util.null2String(groupMap.get("targetName"));
		if(!searchName.equals("") && targetName.indexOf(searchName) == -1){
			continue;
		}
	%>
		<div class="chatItem groupItem" onclick="doSelect(this)" _targetid="<%=groupid%>" _targetName="<%=targetName%>" _targetHead="/social/images/head_group.png" _targetType="1">
			<div class="itemleft">
				<img src="/social/images/head_group.png" class="head35 targetHead"/>
			</div>
			<div class="itemconverright">
				<div class="groupName ellipsis"><%=targetName%></div>
			</div>
			<div class="clear"></div>
		</div>
	<%}%>
<%} %>
</div>
</form>
</body>
<script type="text/javascript" src="/wui/theme/ecology7/jquery/js/zDialog_wev8.js"></script>  
<script type="text/javascript" src="/wui/theme/ecology7/jquery/js/zDrag_wev8.js"></script>
<script type="text/javascript">
	jQuery(function(){
		$("#topTitle").topMenuTitle({searchFn:searchName});
		$("#hoverBtnSpan").hoverBtn();
		$(".chatItemWrap").perfectScrollbar();
		parent.clearSelect();
	});

	try{
		var openerWin = parent.openerWin;
	}catch(e){
		console.error("!!openerWin none!!");
		openerWin = null;
	}
	//选择
	function doSelect(_thisObj){
		$(_thisObj).toggleClass("selected");
		var chatItems = $(".chatItemWrap .selected");
		var len = chatItems.length;
		if(len > 0){
			if(len == 6 && $(_thisObj).hasClass("selected")){
				window.top.Dialog.alert("选取过多，可能会因为网络不稳定导致有些转发会失败");
			}
			$(parent.document).find("#zd_btn_cancle").val("清除");
			$(parent.document).find("#zd_btn_confirm").val("确认("+ chatItems.length +")");
		}else{
			$(parent.document).find("#zd_btn_cancle").val("取消");
			$(parent.document).find("#zd_btn_confirm").val("确认");
		}
	}
	
	function searchName(){
		var searchName = jQuery("#searchName").val();
		location.href = "SocialHrmBrowserList.jsp?tabid=<%=tabid%>&searchName="+searchName;
	}
</script>

