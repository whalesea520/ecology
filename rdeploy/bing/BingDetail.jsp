<!DOCTYPE HTML>
<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@page import="weaver.file.FileUpload"%>
<%@page import="weaver.mobile.ding.MobileDing"%>
<%@page import="weaver.social.SocialUtil"%>
<%@page import="weaver.mobile.ding.DingReply"%>
<%@ include file="/social/im/SocialIMInit.jsp"%>
<jsp:useBean id="MobileDingService" class="weaver.mobile.ding.MobileDingService" scope="page" />
<%
String userid=""+user.getUID();
FileUpload fu = new FileUpload(request);
String dingid=Util.null2String(fu.getParameter("dingid"));
MobileDing mobileDing=MobileDingService.getMobileDing(dingid); 
String content=mobileDing.getContent();
content=content.replaceAll("\r\n","<br>").replaceAll("\r","<br>").replaceAll("\n","<br>");
String sendid=mobileDing.getSendid();
String sendName=SocialUtil.getUserName(sendid);
String createtime=mobileDing.getOperateDate();

int receiverTotal=mobileDing.getDingRecivers().size();
int unConfirmTotal=MobileDingService.getDingUnConfirmCount(dingid);

List<DingReply> replyList=mobileDing.getDingReplys();

String from=Util.null2String(request.getParameter("from"));
%>
<div id="detail_<%=dingid%>">
		<div id="statusDetail" class="statusDetail" onclick="BingUtils.stopEvent();"></div>
		<%if(from.equals("chat")){%>
			<div class="dCloseBtn" onclick="closeDetailBox(this)" title="<%=SystemEnv.getHtmlLabelName(309, user.getLanguage())%>">×</div><!-- 关闭 -->
		<%}%>
  		<div class="bdetailtop" id="">
  			<div class="btitleName" title="<%=content%>"><%=content%></div>
  			<div>
  				<div class="bcreatetime left"><%=sendName+" "+createtime%></div>
  				<%if(sendid.equals(userid)){%>
  					<div class="right" style="cursor:pointer;" onclick="BingUtils.showStatusDetail(<%=dingid%>,'<%=from%>')">
  						<div class="right b_extend"></div>
                        <div class="bcount right"><%=unConfirmTotal>0?(unConfirmTotal+SystemEnv.getHtmlLabelName(127008, user.getLanguage())+"("+SystemEnv.getHtmlLabelName(126311, user.getLanguage())+receiverTotal+SystemEnv.getHtmlLabelName(127, user.getLanguage())+")"):SystemEnv.getHtmlLabelName(127009, user.getLanguage())%></div><!-- 人未确认   共  人  全部确认  -->
  						<div class="clear"></div>
  					</div>
  				<%}%>
  				<div class="clear"></div>
  			</div>	
  		</div>
  		<%if(sendid.equals(userid)){%>
  			<div class="confirmBar" id="confirmBar"></div>
  			<div class="unConfirmBar" id="unConfirmBar"></div>
  			<div class="clear"></div>
  		<%}%>
  		<div class="breplyList" style="overflow: auto;">
  			<%
  			if(replyList.size()>0){
  			for(int i=0;i<replyList.size();i++){
  				DingReply dingReply=replyList.get(i);
  				String replyUserid=dingReply.getUserid();
  				String replyDate=dingReply.getOperate_date();
  				String replyContent=dingReply.getContent();
  			%>
	  			<div class="breplyitem">
	  				<div class="bheaddiv">
	  					<img src="<%=SocialUtil.getUserHeadImage(replyUserid)%>" class="head35 targetHead">
	  				</div>
	  				<div class="breplyright">
	  					<div class="breplytime"><%=SocialUtil.getUserName(replyUserid)+" "+replyDate%></div>
	  					<div class="breplycontent"><%=replyContent%></div>
	  				</div>
	  				<div class="clear"></div>
	  			</div>
  			<%}
  			}else{%>
  				<div class="nodata" style="margin-left:45%;margin-top:120px;">
					<div>
						<img src="/rdeploy/bing/images/b_no_reply.png">
					</div>
					<div style="color:#E4E4E4;margin-top:20px;font-size:16px;"><%=SystemEnv.getHtmlLabelName(127010, user.getLanguage())%></div><!-- 在这里，你可以进行回复 -->
				</div> 
  			<%}%>
  		</div>
  		
        <!-- Enter键发送，Shift+Enter换行 -->
  		<div class="replybox" style="background:#f7f7f7;padding:10px;">
  			<div style="border:1px solid #e9e9e9;background:#fff;padding:5px;">
  				<textarea id="replycontent" _dingid="<%=dingid%>" onkeydown="BingUtils.enterReply(this,event);" style="border:0px;height:20px;width:100%;overflow-y:hidden;resize: none;" placeholder="<%=SystemEnv.getHtmlLabelName(127011, user.getLanguage())%>"></textarea>
  			</div>
  		</div>
</div>

<script>
$(document).ready(function(){
	var detailWdith=<%=from.equals("chat")%>?450:($("#bMain").width()-$("#bleft").width()-2);
	var barWidth=detailWdith*(<%=(receiverTotal-unConfirmTotal)/(receiverTotal*1.0)%>);
	var confirmBar = $("#confirmBar");
	var unConfirmBar = $("#unConfirmBar");
	if(confirmBar.length > 0){
		confirmBar.prev(".bdetailtop").css("border-bottom", "0");
	}
	confirmBar.css({"display": "inline-block","width": "0"}).animate({
		'width': barWidth+'px'
	}, 400, function(){
		
	})
	unConfirmBar.css({"display": "inline-block","width": detailWdith+'px'}).animate({
		'width': (detailWdith - barWidth)+'px'
	}, 400, function(){
		
	})
	
	try{
		var scrollbarid=IMUtil.imPerfectScrollbar($('#detail_<%=dingid%> .breplyList'));
		$("#"+scrollbarid).css({"z-index":"1001"});
	}catch(e){
		$('#detail_<%=dingid%> .breplyList').perfectScrollbar();
	}
	
	$("#replycontent").bind("keyup",function(){
		autoHeight()
	}).bind("change",function(){
		autoHeight()
	}).bind("focus",function(){
		autoHeight()
	});
	
	setReplyHeight();
	
})


function autoHeight(){
	
	var obj=$("#replycontent")[0];
	if (!$.browser.msie) {
        $(obj).height(0);
    }
    var _minHeight=0;
    var _maxHeight=100;
    var h = parseFloat(obj.scrollHeight);
    h = h < _minHeight ? _minHeight :
                h > _maxHeight ? _maxHeight : h;
    $(obj).height(h).scrollTop(h);
    if (h >= _maxHeight) {
        $(obj).css("overflow-y", "scroll");
    }
    else {
        $(obj).css("overflow-y", "hidden");
    }
   
    setReplyHeight();
    
    $('.breplyList').perfectScrollbar("update");
    
}

function setReplyHeight(){
	var height=$("#dingDetail").height()-$(".bdetailtop").height()-$(".replybox").height()-21;
	$(".breplyList").height(height);
}

</script>

<div class="breplyitem" id="breplyitemTemp" style="display:none;">
		<div class="bheaddiv">
			<img src="/messager/images/icon_m_wev8.jpg" class="head35 targetHead">
		</div>
		<div class="breplyright">
			<div class="breplytime">方观生 2015-09-15 18:08:23</div>
			<div class="breplycontent">内容</div>
		</div>
		<div class="clear"></div>
</div>
