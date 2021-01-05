<%@page import="weaver.conn.RecordSet"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util"%>
<%
	String billid = Util.null2String(request.getParameter("billid"));
	String clienttype = Util.null2String(request.getParameter("clienttype"));	//当前访问客户端类型 可能的值：Webclient|iphone|ipad|Android
	boolean isIOS = clienttype.equalsIgnoreCase("iphone") || clienttype.equalsIgnoreCase("ipad");
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no, minimum-scale=1.0, maximum-scale=1.0">
<script type="text/javascript" src="/mobilemode/jqmobile4/js/jquery.min_wev8.js"></script>
<script type="text/javascript" src="/mobilemode/js/iscroll/iscroll5_wev8.js"></script>
<script type="text/javascript" src="/mobilemode/js/iscroll/iScrollHandler_wev8.js"></script>
<link type="text/css" rel="stylesheet" media="all" href="/mobilemode/css/iScroll_wev8.css" />

<script type="text/javascript" src="/mobilemode/js/mpc/photo_wev8.js?1"></script>
<link type="text/css" rel="stylesheet" media="all" href="/mobilemode/css/mpc/photo_wev8.css" />

<style type="text/css">
*{
font-family: 'Microsoft Yahei',Arial;
}

#pullDown{
	border-bottom: none;
}

#scroll_header {
	position: absolute;
	z-index: 2;
	top: 10px;
	width: 94%;
	left: 3%;
	height: 35px;
	line-height: 35px;
	background: rgb(255, 255, 255);
	padding: 0;
	border-bottom: 1px solid #EAEBED;
}

#scroll_wrapper{
	top: 45px;
	bottom: 48px;
	background-color: rgb(255, 255, 255);
	width: 94%;
	left: 3%;
}
.scroll_wrapper_contraction{
	bottom: 155px !important;
}

#scroll_header .title{
	font-size: 18px;	
	color: #000;
	font-weight: bold;
	padding-left: 2px;
}
#scroll_header .title .commentCount{
	font-size: 13px;
	color: #aaa;
	font-weight: normal;
	margin-left: 5px;
}
#commentList{
	
}
#commentList .commentEntry{
	padding: 15px 2px 12px 2px;
	border-bottom: 1px solid #EAEBED;
}
#commentList .commentEntry .commentTitle{
	overflow: hidden;
}
#commentList .commentEntry .commentTitle .avtor{
	float: left;
	height: 20px;
	line-height: 20px;
}
#commentList .commentEntry .commentTitle .avtor img{
	width: 18px;
	height: 18px;
	border-radius: 2.25em;
	margin-top: 1px;
}
#commentList .commentEntry .commentTitle .name{
	float: left;
	font-size: 12px;
	color: #0095cc; 
	margin-left: 8px;
	height: 20px;
	line-height: 20px;
}
#commentList .commentEntry .commentTitle .time{
	float: right;
	font-size: 12px;
	color: #aaa;
	margin-left: 6px;
	height: 20px;
	line-height: 20px;
}
#commentList .commentEntry .commentContent{
	margin-top: 7px;
	color: #333;
	font-size: 14px;
	line-height: 1.5;
}
#commentList .commentEntry .commentContent *{
	font-size: 14px !important;
	line-height: 1.5 !important;
}
#commentList .commentEntry .commentContent img{
	width: 80px;
	height: 80px;
	margin-right: 5px;
}
#commentList .commentEntry .commentContent .lbsContent{
	margin-top: 10px;
	line-height: normal !important;
}
<%if(isIOS){%>
#commentList .commentEntry .commentContent .lbsContent{
	padding-top: 10px !important;
	padding-bottom: 6px !important;
}
<%}%>
<%if(isIOS){%>
#commentList .commentEntry .commentContent audio{
	display: block;
	margin-top: 15px;
	margin-bottom: 2px;
}
<%}%>
#loading{
	position: absolute;
    left:0px;
    top:0px;
    height: 100%;
    width: 100%;
    z-index: 20001;
    display: none;
}
#loading .loadMask{
	height: 100%;
    width: 100%;
	background-color: #fff;
    opacity: 0.3;
}
#loading .loadText{
	position: absolute;
    top:45%;
    left:45%;
    width: 48px;
    height: 16px;
    background: url("/mobilemode/images/mobile_loading_wev8.gif") no-repeat;
	background-position: center center;
}
#loadMore{
	display: block;
	height: 30px;
	line-height: 30px;
	text-decoration: none;
	background-color: rgb(246, 246, 246);
	color: #333;
	text-align: center;
	margin: 8px 0px 8px 0px;
	border: 1px solid #e0e0e0;
	cursor: pointer;
	font-size: 12px;
	border-radius: 2px;
}
#scroll_footer{
	width: 100%;
	left: 0px;
	display: block;
	height: 48px;
	border-top: none;
	background-color: #EAEBED;
	border-top: 1px solid #Ccc;
}
.scroll_footer_open{
	height: 155px !important;
}
#commentContainer{
	padding-top: 6px;
	padding-left: 50px;
	padding-right: 72px;
	height: 42px;
}
#commentContent{
	overflow: hidden;
	border: 1px solid #DADADA;
	border-radius: 5px;
	height: 35px;
	padding-top: 7px;
	width: 100%;
	-webkit-tap-highlight-color:transparent;
}
#submitBtn{
	position: absolute;
	top: 6px;
	right: 6px;
	height: 35px;
	width: 60px;
	background-color: #ababab;
	font-size: 14px;
	color: #fff;
	line-height: 35px;
	text-align: center;
	border-radius: 5px;
	cursor: pointer;
	-webkit-tap-highlight-color:transparent;
}
.submitBtn_Enabled{
	background-color: #17B4EB !important;
}
#expandBtn{
	position: absolute;
	top: 6px;
	left: 6px;
	height: 35px;
	width: 35px;
	background: url("/mobilemode/images/add_wev8.png") no-repeat;
	background-size: 35px; 
	-webkit-tap-highlight-color:transparent;
}
.scroll_footer_open #expandBtn{
	background: url("/mobilemode/images/jp_wev8.png") no-repeat;
	background-size: 35px; 
}

#expandContainer{
	background: transparent;
	display:none;
}
.scroll_footer_open #expandContainer{
	display: block;
}

#expandContainer .mpcTable{
	border: none;
	width: 100%;
	border-collapse: collapse;
}
#expandContainer .mpcTable td{
	vertical-align: middle;
	padding: 5px 0px;
}
#expandContainer .mpcTable td .mpcWrap{
	width: 55px;
	display: inline-block;
	margin-right: 50px;
	-webkit-tap-highlight-color:transparent;
}
#expandContainer .mpcTable td .mpcWrap:last-child{
	margin-right: 0px;
}
#expandContainer .mpcTable td .mpcWrap .mpcImg{
	width: 100%;
}
#expandContainer .mpcTable td .mpcWrap .mpcImg img{
	width:55px;
	height:55px;
}
#expandContainer .mpcTable td .mpcWrap .mpcDesc{
	width: 100%;
	text-align: center;
	padding: 5px 0px;
	color: #555;
	font-size: 12px;
}
.photoContainer{
	padding-left: 3px;
}
.photoContainer .photoEntryWrap .photoEntry{
	border: 1px solid #ccc;
}
.photoContainer .photoEntryWrap .photoEntry img{
	width: 35px;
	height: 40px;
}
#comment_mpc_wrap{
	position:absolute; z-index:3;
	left: 0px;
	bottom: 48px;
	background: transparent;
}
.comment_mpc_wrap_up{
	bottom: 155px !important;
}
.lbsContainerWrap{
}
.lbsContainerWrap .lbsEntery{
	position: relative;
	padding: 3px 5px 3px 3px;
}
.lbsContainerWrap .lbsEntery .lbsContent{
	border: 1px solid #ddd !important;
	-webkit-tap-highlight-color:transparent;
}
<%if(isIOS){%>
.lbsContainerWrap .lbsEntery .lbsContent{
	padding-top: 10px !important;
	padding-bottom: 6px !important;
}
<%}%>
.lbsContainerWrap .lbsEntery .lbsDelete{
	background-image: url("/mobilemode/images/delete_wev8.png");
	background-repeat: no-repeat;
	background-position: right 0px;
	position: absolute;
	top: 0px;
	right: 0px;
	width: 26px;
	height: 26px;
	-webkit-tap-highlight-color:transparent;
}
.soundContainerWrap{
	display: none;
}
.soundContainerWrap .soundEntery{
	position: relative;
	padding: 5px 5px 3px 3px;
	max-width: 110px;
}
.soundContainerWrap .soundEntery .soundText{
	border: 1px solid #ddd;
	background-color: rgb(249, 249, 249);
	padding: 9px 12px 7px 30px;
	font-size: 13px !important;
	font-family: 'Microsoft Yahei',Arial;
	border: 1px solid #EAEBED;
	border-radius: 5px;
	color: #888;
	line-height: normal;
}
.soundContainerWrap .soundEntery  .soundDelete{
	background-image: url("/mobilemode/images/delete_wev8.png");
	background-repeat: no-repeat;
	background-position: right -3px;
	position: absolute;
	top: 0px;
	right: 0px;
	width: 26px;
	height: 26px;
	-webkit-tap-highlight-color:transparent;
}
.soundContainerWrap .soundEntery .soundIcon{
	height: 24px;
	width: 24px;
	position: absolute;
	top: 10px;
	left: 8px;
	background: url("/mobilemode/images/voice_wev8.png?1") no-repeat;
}
</style>
<script type="text/javascript">
var currPgNo = 1;
var pageSize = 10;

function doSearch(){
	
	$("#loading").show();
	var url = "/mobilemode/apps/ktree/commentAction.jsp?action=getCommentData&billid=<%=billid%>&pageno="+currPgNo;
	$.post(url, {"pageSize":pageSize}, function(responseText){
		$("#loading").hide();
		
		var result = $.parseJSON(responseText);
		
		var totalPageCount = result["totalPageCount"];
		var totalSize = result["totalSize"];
		var datas = result["datas"];
		
		if(currPgNo == 1){
			$("#commentList").find("*").remove();
		}
		
		$("#scroll_header .commentCount").html("("+totalSize+")");
		
		for(var i = 0; i < datas.length; i++){
			var data = datas[i];
			
			var creatorAvtor = data["creatorAvtor"];
			var creatorName = data["creatorName"];
			var time = data["time"];
			var content = data["content"];
			
			var $commentEntry = $("<div class=\"commentEntry\"></div>");
			
			var $commentTitle = $("<div class=\"commentTitle\"></div>");
			$commentTitle.html("<div class=\"avtor\"><img src=\""+creatorAvtor+"\"></div>"
							 + "<div class=\"name\">"+creatorName+"</div>"
							 + "<div class=\"time\">"+time+"</div>");
			$commentEntry.append($commentTitle);
			
			var $commentContent = $("<div class=\"commentContent\"></div>");
			$commentContent.html(content);
			$commentEntry.append($commentContent);
			
			$("#commentList").append($commentEntry);
			
			$("img", $commentContent).click(function(e){
				var imgsSrc = $(this).attr("src");
				openDetail("/mobilemode/displayPicOnMobile.jsp?imgSrc="+imgsSrc);
				e.stopPropagation(); 
			});
		}
		
		if(currPgNo >= totalPageCount){
			$("#loadMore").hide();
		}else{
			$("#loadMore").show();
		}
	 			
		refreshIScroll();
	});
}

function searchMore(){
	currPgNo++;
	doSearch();
}	

function openDetail(url){
	if(top && typeof(top.openUrl) == "function"){
		top.openUrl(url);
	}else{
		location.href = url;
	}
}

$(function() {
	doSearch();
	
	$("#expandBtn").click(function(e){
		var $expandContainer = $("#expandContainer");
		if($expandContainer.is(":hidden")){
			openExpandContainer();
		}else{
			closeExpandContainer();
		}
		e.stopPropagation(); 
	});
	
	$("#mec_photo").click(function(e){
		_p_addPhoto(e, "CommentImg");
		e.stopPropagation(); 
	});
	
	$("#mec_lbs").click(function(e){
		if(top && typeof(top.registLBSBackWindow) == "function"){
			top.registLBSBackWindow(window);
		}
		
		var url = "/mobilemode/lbs.jsp";
		openDetail(url);
		e.stopPropagation(); 
	});
	
	$("#mec_sound").click(function(e){
		_p_addSound("soundContent");
		e.stopPropagation(); 
	});
	
	$("#submitBtn").click(function(e){
		if(isCanSubmitComment()){
			$("#loading").show();
			$("#commentForm").submit();
		}
		e.stopPropagation(); 
	});
	
	var interval = null;
	$("#commentContent").focus(function(e){
		if(interval == null){
			interval = setInterval(changeSubmitBtnStyle, 300); 
		}
		e.stopPropagation(); 
	});
	
	$("#commentContent").blur(function(e){
		if(interval != null){
			clearInterval(interval);
			interval = null;
		}
		e.stopPropagation(); 
	});
	
	$(".soundContainerWrap .soundEntery .soundDelete").click(function(e){
		$(".soundContainerWrap").hide();
		$("#soundContent").val("");
		changeSubmitBtnStyle();
		e.stopPropagation(); 
	});
});

function _p_addSound(fieldid){
	fieldid = fieldid + "_" + ((new Date()).valueOf());
	if(top && typeof(top.registMPCWindow) == "function"){
		window.sound_fieldid = fieldid;
		top.registMPCWindow(window);
	}
	//alert("location: " + "emobile:speech:_p_addSound_uploaded:" + fieldid);
	location = "emobile:speech:_p_addSound_uploaded:" + fieldid;
}

function _p_addSound_uploaded(result, fieldid){
	if(result && fieldid){
		var fieldid = fieldid.substring(0, fieldid.lastIndexOf("_"));
		$("#" + fieldid).val(result);
		$(".soundContainerWrap").show();
		changeSubmitBtnStyle();
		//$("#submitBtn").trigger("click");
	}
}

function commentServerSaved(result){
	$("#loading").hide();
	var status = result["status"];
	if(status != "1"){
		alert("操作失败...");
		return;
	}
	currPgNo = 1;
	doSearch();	
	resetCommentForm();
}

function resetCommentForm(){
	$("#commentContent").val("");
	_p_addPhoto_clear("CommentImg");
	$("#soundContent").val("");
	$(".soundContainerWrap").hide();
	$("#lbsHtml").val("");
	$(".lbsContainerWrap .lbsEntery").remove();
	closeExpandContainer();
	changeSubmitBtnStyle();
}

function isCanSubmitComment(){
	var commentContent = $("#commentContent").val();
	var soundContent = $("#soundContent").val();
	var lbsHtml = $("#lbsHtml").val();
	return $.trim(commentContent) != "" || $("#photoContainer_CommentImg .photoEntryWrap").length > 0 || $.trim(soundContent) != "" || $.trim(lbsHtml) != "";
}

function changeSubmitBtnStyle(){
	var $submitBtn = $("#submitBtn");
	if(isCanSubmitComment()){
		if(!$submitBtn.hasClass("submitBtn_Enabled")){
			$submitBtn.addClass("submitBtn_Enabled");
		}
	}else{
		if($submitBtn.hasClass("submitBtn_Enabled")){
			$submitBtn.removeClass("submitBtn_Enabled");
		}
	}
}

function openMap(gpsstr){
	var url = "/mobilemode/showmap.jsp?gpsstr=" + gpsstr;
	openDetail(url);
	if(event && event.stopPropagation){
		event.stopPropagation();
	}
}

function _LBSLoaded(result){
	var resultArr = result.split(";;");
	
	var gpsstr = resultArr[0];
	var addstr = resultArr[1];
	
	var $lbsContainerWrap = $(".lbsContainerWrap");
	$lbsContainerWrap.find(".lbsEntery").remove();
	
	var $lbsEntery = $("<div class=\"lbsEntery\"></div>");
	
	var lbsContentHtm = "<div class=\"lbsContent\" onclick=\"openMap('"+gpsstr+"');\" style=\"background-image: url('/mobilemode/images/mpc/lbs2_wev8.png');background-repeat: no-repeat;background-position: 6px center;background-color: rgb(249, 249, 249);padding: 8px 12px 8px 25px;font-size: 13px !important;font-family: 'Microsoft Yahei',Arial;border: 1px solid #EAEBED;border-radius: 20px;color: #0095cc;\">"
						  + addstr
					  + "</div>";
	$lbsEntery.html(lbsContentHtm);
	
	var $lbsDelete = $("<div class=\"lbsDelete\"></div>");
	$lbsDelete.click(function(e){
		$(this).parent().remove();
		$("#lbsHtml").val("");
		changeSubmitBtnStyle();
		e.stopPropagation(); 
	});
	$lbsEntery.append($lbsDelete);
	
	$lbsContainerWrap.append($lbsEntery);
	
	$("#lbsHtml")[0].value = lbsContentHtm;
	changeSubmitBtnStyle();
}

function openExpandContainer(){
	$("#scroll_footer").addClass("scroll_footer_open");
	$("#scroll_wrapper").addClass("scroll_wrapper_contraction");
	$("#comment_mpc_wrap").addClass("comment_mpc_wrap_up");
	refreshIScroll();
}

function closeExpandContainer(){
	$("#scroll_footer").removeClass("scroll_footer_open");
	$("#scroll_wrapper").removeClass("scroll_wrapper_contraction");
	$("#comment_mpc_wrap").removeClass("comment_mpc_wrap_up");
	refreshIScroll();
}

function _when_photo_uploaded(){
	changeSubmitBtnStyle();
}
function _when_photo_removed(){
	changeSubmitBtnStyle();
}
function _when_photo_cleared(){
	changeSubmitBtnStyle();
}
</script>
</head>
<body>
<div id="loading">
	<div class="loadMask"></div>
	<div class="loadText"></div>
</div>

<div id="scroll_header">
	<div class="title">讨论<span class="commentCount"></span></div>
</div>
<div id="scroll_wrapper">
	<div id="scroll_scroller">
		<div id="pullDown">
			<span class="pullDownIcon"></span><span class="pullDownLabel">下拉刷新</span>
		</div>
		<div id="commentList">
		</div>
		<a id="loadMore" href="javascript:searchMore();">加载更多</a>
		<script type="text/javascript">
			$("#loadMore").hide();
		</script>
	</div>
</div>
<iframe name="commentFrame" style="display: none"></iframe>
	
<form id="commentForm" target="commentFrame" enctype="multipart/form-data" method="POST" action="/mobilemode/apps/ktree/commentAction.jsp?action=saveComment" style="margin: 0px; padding: 0px;">

<div id="scroll_footer">
	
	<input type="hidden" id="billid" name="billid" value="<%=billid %>" />
	<div id="commentContainer">
		<div id="expandBtn"></div>
		<textarea rows="" cols="" id="commentContent" name="commentContent"></textarea>
		<div id="submitBtn" class="">发送</div>
	</div>
	<div id="expandContainer">
		<table class="mpcTable">
			<tr>
				<td align="center">
					<div class="mpcWrap" id="mec_photo">
						<div class="mpcImg">
							<img src="/mobilemode/images/photo_wev8.png"/>
						</div>
						<div class="mpcDesc">
							拍照
						</div>
					</div>
					
					<div class="mpcWrap" id="mec_lbs">
						<div class="mpcImg">
							<img src="/mobilemode/images/lbs_wev8.png"/>
						</div>
						<div class="mpcDesc">
							位置
						</div>
					</div>
					
					<div class="mpcWrap" id="mec_sound">
						<div class="mpcImg">
							<img src="/mobilemode/images/sound_wev8.png"/>
						</div>
						<div class="mpcDesc">
							语音
						</div>
					</div>
				</td>
			</tr>
		</table>
	</div>
	
</div>
<div id="comment_mpc_wrap">
	<div class="photoContainerWrap">
		<input type="hidden" name="fieldCommentImg" id="fieldCommentImg" value=""/>
		<input type="hidden" name="imageCountCommentImg" id="imageCountCommentImg" value="0"/>
		
		<div id="photoContainer_CommentImg" class="photoContainer">
			
		</div>
	</div>
	<div class="soundContainerWrap">
		<input type="hidden" name="soundContent" id="soundContent" value=""/>
		
		<div class="soundEntery">
			<div class="soundIcon"></div>
			<div class="soundText">
				语音已录制
			</div>
			<div class="soundDelete">
				
			</div>
		</div>
	</div>
	<div class="lbsContainerWrap">
		<input type="hidden" name="lbsHtml" id="lbsHtml" value=""/>
	
	</div>
</div>

</form>
</body>
</html>