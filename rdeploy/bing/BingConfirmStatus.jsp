
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.social.SocialUtil"%>
<%@page import="weaver.conn.RecordSet"%>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<%@ include file="/social/im/SocialIMInit.jsp"%>

<%
String dingid = Util.null2String(request.getParameter("dingid"),"");
String userid=user.getUID()+"";
RecordSet recordSet=new RecordSet();

String from=Util.null2String(request.getParameter("from"));
%>


	<%
		String sql="select * from mobile_dingReciver where dingid="+dingid+" and confirm<>'true' order by id asc";
		recordSet.execute(sql);
		int unReadCount=recordSet.getCounts();
	%>
		<%if(!from.equals("chat")){%>
			<div align="center" style="height:35px;line-height:35px;font-size:14px;background:#8d9598;color:#fff;"><%=SystemEnv.getHtmlLabelName(127007, user.getLanguage())%></div><!-- 确认详情 -->
			<div class="bCloseBtn" onclick="closeStatusBox(this)" title="<%=SystemEnv.getHtmlLabelName(309, user.getLanguage())%>">×</div><!-- 关闭 -->
		<%}else{%>
			<link rel="stylesheet" type="text/css" href="/rdeploy/assets/css/common.css">
			<link rel="stylesheet" type="text/css" href="/rdeploy/bing/css/bing_wev8.css">
		<%}%>
		<div align="center" style="height:45px;line-height:45px;font-size:14px;"><%=unReadCount>0?unReadCount+SystemEnv.getHtmlLabelName(127008, user.getLanguage()):SystemEnv.getHtmlLabelName(127009, user.getLanguage())%></div><!-- 人未确认 --><!-- 全部确认 -->
		<%if(unReadCount>0){%>
		<div style="padding-left:10px;padding-bottom:10px;border-top:1px solid #E3E6F0">
			<div style="height:30px;line-height:30px;color:#544E4E"><%=SystemEnv.getHtmlLabelName(23062, user.getLanguage())%>(<%=unReadCount%>)</div><!-- 未确认 -->
			<div>
				<%
					while(recordSet.next()){
						String receiverid=recordSet.getString("userid");
				%>
						<div class="left" style="margin-right:10px;margin-bottom:5px;text-align:center;">
							<div><img src="<%=SocialUtil.getUserHeadImage(receiverid)%>" class="head35 targetHead"></div>
							<div style="color:#8f8f8f"><%=SocialUtil.getUserName(receiverid) %></div>
						</div>
				<%} %>
				<div class="clear"></div>
			</div>
		</div>
		<%}%>
		<%
		
		sql="select * from mobile_dingReciver where dingid="+dingid+" and confirm='true' order by id asc";
		recordSet.execute(sql);
		int readCount=recordSet.getCounts();
		
		if(readCount>0){%>
		<div style="padding-left:10px;padding-bottom:10px;border-top:1px solid #E3E6F0">	
			<div style="height:30px;line-height:30px;color:#544E4E"><%=SystemEnv.getHtmlLabelName(18189, user.getLanguage())%>(<%=readCount%>)</div><!-- 已确认 -->
			<div>
				<%
					while(recordSet.next()){
						String receiverid=recordSet.getString("userid");
				%>
						<div class="left" style="margin-right:10px;margin-bottom:5px;text-align:center;">
							<div><img src="<%=SocialUtil.getUserHeadImage(receiverid)%>" class="head35 targetHead"></div>
							<div style="color:#8f8f8f"><%=SocialUtil.getUserName(receiverid) %></div>
						</div>
				<%} %>
				<div class="clear"></div>
			</div>
		</div>
		<%}%>
