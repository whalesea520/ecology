
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.social.service.SocialIMService"%>
<%@page import="weaver.social.SocialUtil"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="SocialIMService" class="weaver.social.service.SocialIMService" scope="page" />
<%@ include file="/systeminfo/init_wev8.jsp" %>
<head>
<script type="text/javascript" src="/js/weaver_wev8.js"></script>
<link type="text/css" rel="stylesheet" href="/css/Weaver_wev8.css" />
<link rel="stylesheet" href="/social/css/base_wev8.css" type="text/css" />
<link rel="stylesheet" href="/social/css/im_wev8.css" type="text/css" />
</head>

<body>

<%
String messageid = Util.null2String(request.getParameter("messageid"),"");
String userid=user.getUID()+"";

//int unReadCount=SocialIMService.getMsgUnReadCount(messageid);
RecordSet recordSet=new RecordSet();
%>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSubmit(),_self} " ;    
RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<div class="zDialog_div_content" id="zDialog_div_content" style="height:409px;">
	<%
	String sql="select distinct receiverid from (select * from social_IMMsgRead where msgid='"+messageid+"' and status=1) a where receiverid <> '"+userid+"'";
		recordSet.execute(sql);
		int unReadCount=recordSet.getCounts();
	%>
	   <!-- 人未读    全部已读 -->
		<div align="center" style="height:45px;line-height:45px;font-size:14px;"><%=unReadCount>0?unReadCount+SystemEnv.getHtmlLabelName(126956, user.getLanguage()):SystemEnv.getHtmlLabelName(126957, user.getLanguage())%></div>
		<div style="padding-left:10px;padding-bottom:10px;border-top:1px solid #E3E6F0">
			<div style="height:30px;line-height:30px;color:#544E4E"><%=SystemEnv.getHtmlLabelName(25396, user.getLanguage())%>(<%=unReadCount%>)</div><!-- 未读 -->
			<div>
				<%
					while(recordSet.next()){
						String receiverid=recordSet.getString("receiverid");
				%>
						<div class="left" style="margin-right:10px;margin-bottom:5px;text-align:center;">
							<div><img src="<%=SocialUtil.getUserHeadImage(receiverid)%>" class="head35 targetHead"></div>
							<div style="color:#8f8f8f"><%=SocialUtil.getUserName(receiverid) %></div>
						</div>
				<%} %>
				<div class="clear"></div>
			</div>
		</div>
		<div style="padding-left:10px;padding-bottom:10px;border-top:1px solid #E3E6F0">	
			<%
			sql="select distinct receiverid from (select * from social_IMMsgRead where msgid='"+messageid+"' and status=0) a where receiverid <> '"+userid+"'";
				recordSet.execute(sql);
				int readCount=recordSet.getCounts();
			%>
			<div style="height:30px;line-height:30px;color:#544E4E"><%=SystemEnv.getHtmlLabelName(25425, user.getLanguage())%>(<%=readCount%>)</div><!-- 已读 -->
			<div>
				<%
					while(recordSet.next()){
						String receiverid=recordSet.getString("receiverid");
				%>
						<div class="left" style="margin-right:10px;margin-bottom:5px;text-align:center;">
							<div><img src="<%=SocialUtil.getUserHeadImage(receiverid)%>" class="head35 targetHead"></div>
							<div style="color:#8f8f8f"><%=SocialUtil.getUserName(receiverid) %></div>
						</div>
				<%} %>
				<div class="clear"></div>
			</div>
		</div>

</div>

<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout>
		<wea:group context="" attributes="{groupDisplay:none}">
			<wea:item type="toolbar">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage()) %>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="parent.getDialog(window).close();">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include> 

<script language="javascript">
jQuery(document).ready(function(){
	$('.zDialog_div_content').perfectScrollbar();
	
})

function doSave(){
	var receiver=$("#receiver").val();
	var content=$("#content").val();
	var remindType=$("input[name='remindType']:checked").val();
	
	if(receiver==""){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(126981, user.getLanguage())%>");  //请填写接收人
		return;
	}
	if(content==""){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(126982, user.getLanguage())%>");  //请填写内容
		return;
	}
	
	$.post("BingOperation.jsp?operation=doSave",{"receiver":receiver,"content":content,"remindType":remindType},function(data){
		//window.parent.freshDingList();
		var parentWin = parent.getParentWindow(window);
		parentWin.freshDingList();
		parent.getDialog(window).close();
	});
	
}

</script>
</body>
