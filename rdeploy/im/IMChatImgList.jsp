
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.social.SocialUtil"%>
<%@page import="weaver.general.TimeUtil"%>
<%@page import="com.alibaba.fastjson.*"%>
<%@page import="weaver.hrm.resource.ResourceComInfo"%>
<%@page import="weaver.social.service.SocialIMService"%>
<%@page import="weaver.social.po.SocialIMFile"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ include file="/social/im/SocialIMInit.jsp"%>
<jsp:useBean id="SocialIMService" class="weaver.social.service.SocialIMService" scope="page" />
<jsp:useBean id="iMService" class="weaver.social.rdeploy.im.IMService" scope="page" />
<%
	int userid=user.getUID();
	String username = user.getUsername();
	String targettype=Util.null2String(request.getParameter("targettype"),"0"); //聊天类型 0：私聊；1：群聊
	String targetid=Util.null2String(request.getParameter("targetid"));
	String targetname=Util.null2String(request.getParameter("targetname"));
	
%>
<style>
	.icrimgList {color: #8e9598;height: 100%; overflow-y: auto;}
	.icrimgList .icrimgnoneBg {
		width: 100%;
  		height: 50%;
  		background: url("/rdeploy/im/img/imglist_nonebg_wev8.png") no-repeat center bottom;
	}
	.icrimgList .icrimgnoneWord{
		text-align: center;
		width: 100%;
		height: 50%;
  		bottom: 40px;
	}
	
	.icrimgList .imgThumbWrap{
		display: inline-block;
		float: left;
		margin-left: 12px;
		margin-top: 12px;
		width: 100px;
		height: 100px;
		line-height: 97px;
		text-align: center;
		background-color: #e4e4e4;
	}
	.icrimgList .imgThumb {
		max-width: 100px;
		max-height: 100px;
		cursor: pointer;
		vertical-align: middle;
	}
	
</style>
<div class="icrimgList">

	<%
	
	List<SocialIMFile> imFileList=SocialIMService.getIMFileList(""+userid,targetid,targettype,"2");
	String tempcreatedate="";
	for (SocialIMFile imFile :imFileList) {
		String createdate=imFile.getCreatedate().substring(0, 10);
		String fileid=imFile.getFileid();
		
		if(!createdate.equals(tempcreatedate)){
			tempcreatedate=createdate;
	%>
			<div class="clear"></div>
			<div class="note_title">
				<div class="tip"><%=createdate %></div>
			</div>
	<%
		}
		
	%>
			<div>
				<div class = "imgThumbWrap">
					<img class="imgThumb" _fileid="<%=fileid%>" src="/weaver/weaver.file.FileDownload?fileid=<%=fileid %>"
						onclick="IM_Ext.showBigImg(this);"/>
				</div>
			</div>
	<%}
		
	%>
	
	<%if(imFileList.size() <= 0){ %>
		<div class="icrimgnoneBg"></div>
		<div class="icrimgnoneWord">在这里，你可以与大家分享图片</div>
	<%} %>
</div>
<script>
	$(".dataLoading").hide();
	$('.icrimgList').perfectScrollbar();
	IM_Ext.icrimgPool = [];
	IM_Ext.icrResIds = [];
	<%for(SocialIMFile imFile :imFileList){%>
		IM_Ext.icrimgPool.push("/weaver/weaver.file.FileDownload?fileid=" + "<%=imFile.getFileid()%>");
		IM_Ext.icrResIds.push("<%=imFile.getFileid()%>");
	<%}%>
</script>
