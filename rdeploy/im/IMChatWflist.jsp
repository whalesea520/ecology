
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.social.SocialUtil"%>
<%@page import="weaver.general.TimeUtil"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="weaver.hrm.resource.ResourceComInfo"%>
<%@page import="weaver.social.service.SocialIMService"%>
<%@page import="weaver.social.po.SocialIMFile"%>
<%@page import="weaver.workflow.workflow.WorkflowComInfo"%>
<%@page import="weaver.workflow.workflow.WorkTypeComInfo"%>
<%@ include file="/social/im/SocialIMInit.jsp"%>
<jsp:useBean id="SocialIMService" class="weaver.social.service.SocialIMService" scope="page" />
<jsp:useBean id="iMService" class="weaver.social.rdeploy.im.IMService" scope="page" />
<%
	String userid=""+user.getUID();
	String username = user.getUsername();
	String targettype=Util.null2String(request.getParameter("targettype"),"0"); //聊天类型 0：私聊；1：群聊
	String targetid=Util.null2String(request.getParameter("targetid"));
	String targetname=Util.null2String(request.getParameter("targetname"));
	List<Map<String, String>> listmap = iMService.getChatResources(userid+"",targetid, targettype, "0");
	WorkflowComInfo workflowComInfo = new WorkflowComInfo();
	WorkTypeComInfo workTypeComInfo = new WorkTypeComInfo();
	ResourceComInfo resourceComInfo=SocialUtil.getResourceComInfo();
%>
<style>
	.icrWfList {
		position: absolute;
		left: 0;
		top: 0;
		right: 0;
		bottom: 30px;
	}
	
	.icrWfoptpane {
		position: absolute;
  		height: 30px;
  		bottom: 0;
  		left: 0;
  		right: 0;
  		line-height: 30px;
  		text-align: right;
  		padding: 0 10px;
  		background: #fcfcfc;
  		border-top: 1px solid #f5f5f5;
  		color: #8e9598;
	}
	
	.icrWfList .wfItem {
		height: 80px;
  		border-bottom: 1px solid #eeeeee;
	}
	.icrWfList .wfItem:hover {
		background: #f1faff;
		background-clip: content-box;
	}
	.icrWfList .wfItemLeftPad {
		height: 100%;
		width: 30px;
		float: left;
		border-bottom: 1px solid #FFF;
	}
	
	.icrWfList .wfItem .wfcreatorHead {
		width: 50px;
		height: 100%;
		float: left;
		line-height: 80px;
		
	}
	.icrWfList .wfItem .wfcreatorHead img {
		border-radius: 50%;
		vertical-align: middle;
		width: 35px;
  		height: 35px;
	}
	.icrWfList .wfItem .wfContent {
		float: left;
  		height: 80px;
  		width: auto;
  		border-bottom: 1px solid #eeeeee;
  		position: absolute;
  		right: 0px;
  		left: 80px;
  		line-height: 60px;
	}
	
	.icrWfList .wfItem .wfContent .wfNameWrap{height: 20px;padding: 0px 10px;color: #3c4350;}
	.icrWfList .wfItem .wfContent .wfDetails{height: 20px;padding: 0px 10px;color: #8e9598;}
	.icrWfList .wfItem .wfContent .wfdetailLeft{float: left;}
	.icrWfList .wfItem .wfContent .wfdetailRight{float: right;}
	/*无显示样式*/
	.icrWfList .icrwfnoneBg {
		width: 100%;
  		height: 50%;
  		background: url("/rdeploy/im/img/wflist_nonebg_wev8.png") no-repeat center bottom;
	}
	.icrWfList .icrwfnoneWord{
		text-align: center;
		width: 100%;
		height: 50%;
  		bottom: 10px;
  		color: #8e9598;
	}
</style>
</div>

<div class="icrWfList">
	<%
	for(int i = 0; i < listmap.size(); ++i){ 
		Map<String, String> resmap = listmap.get(i);
		String worktype = workTypeComInfo.getWorkTypename(workflowComInfo.getWorkflowtype(resmap.get("resourceid")));
		String userHead = resourceComInfo.getMessagerUrls(resmap.get("creatorid"));
		if("".equals(userHead)){
			userHead = "/messager/images/icon_m_wev8.jpg";
		}
	%>
		<div class="wfItem">
			<div class="wfItemLeftPad"></div>
			<div class="wfcreatorHead"><img src="<%=userHead %>"/></div>
			<div class="wfContent">
				<div class="wfNameWrap">
					<a href="javascript:void(0)" class="wfName" onclick="viewShare(this)" 
						_shareid="<%=resmap.get("resourceid")%>"
						_sharetype="workflow"
						_senderid="<%=resmap.get("creatorid")%>">
						<%=resmap.get("resourcename") %>
					</a>
				</div>
				<div class="wfDetails">
					<div class="wfdetailLeft"><%=resourceComInfo.getLastname(resmap.get("creatorid")) %>
					&nbsp;&nbsp;<%=TimeUtil.getTimeString(new Date(Long.parseLong(resmap.get("createtime")))) %></div>
					<div class="wfdetailRight"><%=worktype %></div>
				</div>
			</div>
			<div class="clear"></div> 
		</div>		
		
	<%}	%>
	<%if(listmap.size() <= 0){ %>
		<div class="icrwfnoneBg"></div>
		<div class="icrwfnoneWord">在这里，你可以与大家分享流程</div>
	<%} %>
</div>
<div class="icrWfoptpane">
	共<span class="wfcnt"><%=listmap.size() %></span>条记录
</div>
<script>
	$(".dataLoading").hide();
	$('.icrWfList').perfectScrollbar();
</script>