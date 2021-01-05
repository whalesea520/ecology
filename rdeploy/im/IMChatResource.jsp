
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.social.SocialUtil"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="weaver.hrm.resource.ResourceComInfo"%>
<%@page import="weaver.social.service.SocialIMService"%>
<%@page import="weaver.social.po.SocialIMFile"%>
<%@ include file="/social/im/SocialIMInit.jsp"%>
<jsp:useBean id="SocialIMService" class="weaver.social.service.SocialIMService" scope="page" />
<%
	int userid=user.getUID();
	String username = user.getUsername();
	String targettype=Util.null2String(request.getParameter("targettype"),"0"); //聊天类型 0：私聊；1：群聊
	String targetid=Util.null2String(request.getParameter("targetid"));
	String targetname=Util.null2String(request.getParameter("targetname"));
	
	
%>
<style>
	.dataLoading{
		position:absolute;
		top:0px;bottom:0px;left:0px;right:0px;
		background: url('/social/images/loading_large_wev8.gif') no-repeat center 200px;
		display: none;
		z-index:1000
	}
	.icrMainBox{height: 100%;width: 100%;border: none;color: #3c4350;position:relative;}
	.icrMainBox .icrTopNav {
		width: 100%;
  		height: 40px;
  		background: #f6f6f6;
  		position: relative;
	}
	.icrTopNav .icrnavbox {
		width: 125px;
  		height: 100%;
  		float: left;
  		border-right: 1px solid #e4e4e4;
  		border-bottom: 1px solid #e4e4e4;
  		text-align: center;
  		line-height: 40px;
  		cursor: pointer;
	}
	.icrTopNav .icrnavActive {
		background: #fff;
  		border-bottom: none;
	}
	.icrTopNav .icrTopRight {
  		height: 100%;
  		border-bottom: 1px solid #e4e4e4;
  		position: absolute;
  		left: 377px;
  		right: 0px;
  		overflow: hidden;
	}
	.icrTopNav .icrsearchbox {
		position: absolute;
  		width: 171px;
  		height: 30px;
  		right: 6px;
  		border: 1px solid #e9e9e9;
  		margin-top: 4px;
  		border-radius: 3px;
  		background: #fff;
  		display: table;
	}
	.icrTopNav .icrsearchbox input {
		display: table-cell;
  		height: 30px;
  		width: 134px;
  		border: none;
  		padding: 0 5px;
	}
	.icrTopNav .icrsearchmag {
		background: url("/rdeploy/im/img/im_search_wev8.png") no-repeat center center;
		width:37px;
		height: 30px;
		display: table-cell;
		cursor: pointer;
	}
	.icrMainBox .icrFrmwrap {
		width: 100%;
  		bottom: 0px;
  		position: absolute;
  		top: 41px;
  		overflow: hidden;
	}
	/*响应式*/
	@media screen and (max-width: 801px) {
		.icrTopNav .icrnavbox{width: 55px;}
		.chatdiv .chattop .chatArrow{
		    background: none;
		}
	}
</style>
<div class="dataLoading"></div>
<div class="icrMainBox">
	<div class="icrTopNav">
		<div class="icrnavbox icrnavActive" _target="imgList">图片</div>
		<div class="icrnavbox" _target="fList">文件</div>
		<div class="icrnavbox" _target="wfList">流程</div>
		<!-- 右边 -->
		<div class="icrTopRight">
			<div class="icrsearchbox">
				<input placeHolder="名称" onkeyup="doSearchResByName(event, this)"/>
				<div class="icrsearchmag" onclick="doSearchResName(this)"></div>
			</div>
		</div>
		<div class="clear"></div>
	</div>
	<div class="icrFrmwrap">
	</div>
</div>
<script>
	$(".dataLoading").hide();
	$(".icrTopNav .icrnavbox").click(function(){
		var chatdiv = ChatUtil.getchatdiv(this);
		chatdiv.find(".icrnavbox").removeClass("icrnavActive");
		$(this).addClass("icrnavActive");
		var target = $(this).attr("_target");
		loadTabFrm(this);
		if("imgList" == target){   //是图片，箭头样式要切换
			chatdiv.find(".chatArrow").removeClass("chatArrowGrey");
			chatdiv.find(".icrsearchbox").hide();
		}else{
			chatdiv.find(".chatArrow").addClass("chatArrowGrey");
			chatdiv.find(".icrsearchbox").show();
		}
		
	});
	/*通过名称搜索聊天资源*/
	function doSearchResByName(evt, obj){
		var ev = evt || window.event;
		var keynum;
		if(window.event)
	    	keynum=evt.keyCode;
	    else
	        keynum=evt.which;
	    if(keynum!=13&&keynum!=10){
	    	return false;
	    }
		
		return doSearchResName(obj);
	}
	function doSearchResName(obj){
		obj = $(obj).parents(".icrsearchbox").find("input");
		var sname = $.trim($(obj).val());
		var mainbox = $($(obj).parents(".icrMainBox")[0]);
		var target = mainbox.find(".icrnavActive").attr("_target");
		if("fList" == target){	
			var acclist = mainbox.find(".acclist");
			var accitems = acclist.find(".accitem");
			if(sname == ""){
				acclist.find(".readyToHide").show().removeClass("readyToHide");
				return false;
			}else {
				sname = sname.toLowerCase();
				for(var i = 0; i < accitems.length; ++i){
					var itm = $(accitems[i]);
					var filename = itm.find(".fileName").html();
					filename = filename.toLowerCase();
					if(filename.indexOf(sname) == -1){
						itm.addClass("readyToHide");
						itm.hide();
					}else{
						itm.show();
						itm.removeClass("readyToHide");
					}
				}
			}
		}else if("wfList" == target){
			var wflist = mainbox.find(".icrWfList");
			var wfitems = wflist.find(".wfItem");
			if(sname == ""){
				wflist.find(".readyToHide").show().removeClass("readyToHide");
				return false;
			}else {
				sname = sname.toLowerCase();
				for(var i = 0; i < wfitems.length; ++i){
					var itm = $(wfitems[i]);
					var wfName = itm.find(".wfName").html();
					wfName = wfName.toLowerCase();
					if(wfName.indexOf(sname) == -1){
						itm.addClass("readyToHide");
						itm.hide();
					}else{
						itm.show();
						itm.removeClass("readyToHide");
					}
				}
			}
		}
		return true;
	}
	/*加载子标签页*/
	function loadTabFrm(targetTab){
		var chatdiv = ChatUtil.getchatdiv(targetTab);
		var chatwin = ChatUtil.getchatwin(targetTab);
		var targetid = chatwin.attr('_targetid');
		var targettype = chatwin.attr("_targettype");
		var icrFrmwrap = chatdiv.find(".icrFrmwrap");
		icrFrmwrap.empty();
		var targettag = $(targetTab).attr("_target");
		switch(targettag){
		case "imgList":
			icrFrmwrap.load("/rdeploy/im/IMChatImgList.jsp?"+
				"targetid="+targetid+"&targettype="+targettype);	
		break;
		case "fList":
			icrFrmwrap.load("/rdeploy/im/IMChatFilelist.jsp?"+
				"targetid="+targetid+"&targettype="+targettype);
		break;
		case "wfList":
			icrFrmwrap.load("/rdeploy/im/IMChatWflist.jsp?"+
				"targetid="+targetid+"&targettype="+targettype);
		break;
		}
	}
</script>
