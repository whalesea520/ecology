<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="weaver.general.*"%>
<%@ page import="java.util.*"%>
<%@ page import="net.sf.json.JSONArray"%>
<%@ page import="weaver.hrm.*"%>
<%@ page import="weaver.docs.docs.reply.DocReplyModel"%>
<jsp:useBean id="docReply"
	class="weaver.docs.docs.reply.DocReplyManager" scope="page" />
<%@ include file="/systeminfo/init_wev8.jsp"%>
<%@ include file="/hrm/resource/simpleHrmResource_wev8.jsp" %>
<html>
	<head>
		<%
			String secid = Util.null2String(request.getParameter("secid"));
			String docid = Util.null2String(request.getParameter("docid"));
			String order = "desc";
			Cookie[] cookie = request.getCookies();
			if(cookie != null){
				for(Cookie c : cookie){
					if("docReplyOrder".equals(c.getName())){
					    order = c.getValue();
					    break;
					}
				}
			}
			List<DocReplyModel> jsonList = docReply.getDocReply(docid,user.getUID()+"",false,0,15,5,order);
			String jsonData = JSONArray.fromObject(jsonList).toString();
			String userbelongids = Util.null2String(user.getBelongtoids(),"");
		%>
		<script>
			this._secid = "<%=secid %>";
		</script>
		<script type="text/javascript"
			src="/js/select/script/jquery-1.8.3.min_wev8.js"></script>
		<script language="javascript" type="text/javascript"
			src="/js/init_wev8.js"></script>
		<script type="text/javascript"
			src="/js/ecology8/lang/weaver_lang_<%=user.getLanguage()%>_wev8.js"></script>
		
		<script type="text/javascript" src="/js/ecology8/jNice/jNice/jquery.jNice_wev8.js"></script>
		<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.bgiframe.min_wev8.js'></script>
		<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.ajaxQueue_wev8.js'></script>
		<script type='text/javascript' src='/js/jquery-autocomplete/jquery.autocomplete_wev8.js'></script>
		<script type='text/javascript' src='/js/jquery-autocomplete/browser_wev8.js'></script>
		<script type="text/javascript" src="/js/ecology8/weaverautocomplete/weaverautocomplete_wev8.js"></script>
		
		<link type="text/css" rel="stylesheet"
			href="/js/ecology8/jNice/jNice/jNice_wev8.css">
		<link type="text/css" rel="stylesheet"
			href="/css/ecology8/WorkflowSignInput_wev8.css">
		<!--swfupload相关-->
		<script type="text/javascript" src="/js/swfupload/swfupload_wev8.js"></script>
		<script type="text/javascript" src="/js/swfupload/swfupload.queue_wev8.js"></script>
		<script type="text/javascript" src="/js/swfupload/fileprogress_wev8.js"></script>
		<script type="text/javascript" src="/js/swfupload/handlers_wev8.js"></script>
		<link href="/js/page/swfupload/default_wev8.css" rel="stylesheet" type="text/css" />
		
		<!--引入ueditor相关文件-->
		<script type="text/javascript" charset="UTF-8"
			src="/ueditor/ueditor.config_wev8.js"></script>
		<script type="text/javascript" charset="UTF-8"
			src="/ueditor/custbtn/reply/ueditor.all_wev8.js"> </script>
		<script type="text/javascript" charset="UTF-8"
			src="/ueditor/lang/zh-cn/zh-cn_wev8.js"></script>
		<link type="text/css" href="/ueditor/ueditorext_wf_wev8.css"
			rel="stylesheet"></link>
			
			
		<!-- ckeditor的一些方法在uk中的实现 -->
		<script type="text/javascript" charset="UTF-8"
			src="/ueditor/custbtn/reply/ck2uk_wev8.js"></script>
		
		<!--添加插件-->
		
		<script type="text/javascript"
			src="/ueditor/custbtn/reply/reply_fileupload_wev8.js"></script>
		<script type="text/javascript" src="/ueditor/custbtn/reply/appwf_doc_wev8.js"></script>
		<script type="text/javascript" src="/ueditor/custbtn/reply/appwf_wf_wev8.js"></script>
		<!-- word转html插件 -->
		<script type="text/javascript" charset="UTF-8"
			src="/ueditor/custbtn/wordtohtml_wev8.js"></script>
	</head>
	<style type="text/css">
	._signinputphraseblockClass .progressBarInProgress {
	height: 5px;
	background: #e33633;
	margin: 0 !important;
}

._signinputphraseblockClass .progressWrapper {
	height: 30px !important;
	width: 100% !important;
}

._signinputphraseblockClass .progressContainer {
	background-color: #FFFFFF !important;
	border: solid 0px !important;
	padding-left: 0px !important;
	margin-top: 3px !important;
}

._signinputphraseblockClass .progressCancel {
	display: none !important;
}

._signinputphraseblockClass .progressBarStatus {
	display: none !important;
}

._signinputphraseblockClass .edui-for-wfannexbutton {
	cursor: pointer !important;
}

._signinputphraseblockClass .progressName {
	width: 140px !important;
	height: 18px;
	font-size: 12px;
	font-family: 微软雅黑;
	font-weight: normal !important;
	white-space: nowrap;
	overflow: hidden;
	text-overflow: ellipsis;
	color: #000;
}
body {
	font-size: 12px;
	font-family: 微软雅黑;
	margin-top: 0px;
}

.core_reply_wrapper {
	background: #f7f8fa;
	width: 573px;
	border: 1px solid #f0f1f2;
	margin-top: -1px;
	min-height: 0;
}

.core_reply_content {
	padding-left: 10px;
	padding-top: 10px;
}

.reply_none {
	display:none;
}

.j_lzl_s_p {
	padding-top: 10px;
}

.lzl_p_p {
	float: left;
	width: 32px;
	height: 32px;
	padding: 1px;
}

.lzl_p_p img {
	width: 32px;
	height: 32px;
}

.lzl_cnt {
	margin-left: 45px;
	zoom: 1;
	word-wrap: break-word;
	word-break: break-all;
}

.lzl_cnt .lzl_content_reply {
	text-align: right;
	padding-top: 5px;
}

.core_reply_ul {
	list-style: none;
	-webkit-padding-start: 0px;
	-webkit-margin-before: 0px;
	-webkit-margin-after: 0px;
	-webkit-margin-start: 0px;
	-webkit-margin-end: 0px;
}


.content_reply_ul {
	list-style: none;
}


.content_reply_ul_child {
	margin:0;padding:0;
}

.r_content {
	padding-top: 10px;
}

.showrequestline {
	height: 0px;
	background-color: #FAFAFA;
	border-bottom: 1px solid #eeeeee;
	margin-left: 45px;
	margin-top: 20px;
}

.reply_span {
	padding-left: 5px;
	padding-right: 5px;
}

.right_div {
	padding-right: 25px;
}

.span_date {
	color: #9b9b9b;
	padding-left: 5px;
}

.handImg {
	width: 30px;
	height: 30px;
	border-radius: 20px;
}

.leftDiv {
	float: left;
}

.userName {
	color: #099cff;
	text-decoration: none;
}
.praise {
	padding-right: 10px;
	float: right;
    margin-top: -5px;
}

.praiseImg {
	cursor: pointer;
	background-image: url('/docs/reply/img/praise.png');
    width: 22px;
    height: 22px;
    float: left;
}
.praiseImg_hot {
	cursor: pointer;
	background-image: url('/docs/reply/img/praise_hot.png');
    width: 22px;
    height: 22px;
    float: left;
}

.praiseFont {
    margin-top: 5px;
    float: left;
    margin-left: 10px;
    width: 46px;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
    text-align: left;
}

.replyBtn {
	padding-right: 10px;
	cursor: pointer;
}
.delBtn1 {
	padding-right: 10px;
	cursor: pointer;
}
.updateBtn {
	padding-right: 10px;
	cursor: pointer;
}

.submitBtn1 {
	    width: 50px;
    height: 25px;
    line-height: 25px;
    cursor: pointer;
    background-color: #4ba9df;
    color: #fff;
    text-align: center;
    border-radius: 3px;
    float: right;
    margin-top: 10px;
    margin-right: 15px;
}

.celBtn1 {
	    width: 50px;
    height: 25px;
    line-height: 25px;
    cursor: pointer;
    background-color: #848484;
    color: #fff;
    text-align: center;
    border-radius: 3px;
    float: right;
    margin-top: 10px;
    margin-right: 30px;
}
.rcDiv {
	position: absolute;
    width: 100%;
    height: 96%;
    padding-top: 15px;
}
.replyDiv {
	width: 99%;
    position: fixed;
    bottom: 0px;
}
.moreFoot {
    POSITION: absolute;
    HEIGHT: 37px;
    width: 100%;
    text-align: center;
    line-height: 37px;
}
.defaultdiv {
    right: 0px;
    height: 100%;
    position: absolute;
    text-align: center;
    background: #fff;
    width: 100%;
    display: none;
}
iframe {
border:none;
}
.fullScreenDiv {
	width: 100%; margin-left: 45px; margin-top: 15px; margin-bottom: 5px; position: relative; top: -257px; left: -45px;
}
.nofullScreenDiv
{
	width: 95%; margin-left: -2000px; margin-top: 15px; margin-bottom: 5px;
}

#reply_operator{
	position:fixed;
	right:30px;
	bottom:30px;
}
#reply_order{
	display:none;
}
#reply_operator div{
	padding:5px 6px 3px 6px;
	margin-top:10px;
	background-color:#5ebdff;
	cursor:pointer;
	border-radius:4px;
}
#reply_operator div:hover{
	background-color:#22a4ff;
}
#reply_top{
	display:none;
}
.flowsign{
	z-index:199;
	position:relative;
}
</style>
	<script type="text/javascript">
var docid = <%= docid %>;
var userbelongids = "<%= userbelongids %>";
var _ueditorChild = '';
var replycontent = '';
var ishave = false;
var pageNo = 2;
var lastMainReplyid = -1;
var updateScroll = false;
var isMainHave = false;
var order = "<%=order%>";
var queryAll = false;
$(function() {

	var jsonData=eval(<%=jsonData%>);
	if(jsonData.length > 0)
	{
		$.each(jsonData,function(id, docReplyModel) {
			 fullDocReplyMain(docReplyModel,false);
		 });
		 $("#reply_order").show();
	}
	else
	{
		$("#imDefaultdiv").show();
		$("#reply_order").hide();
	}
	// 列表滚动条美化
	jQuery('#rc').perfectScrollbar();
	
	//设置滚动加载
  	$("#rc").scroll(function() {
	  	//校验数据请求
	  	
	  	//判断滚动条是否在顶部，如果不在，则显示“返回顶部”图标
	  	if(this.scrollTop ==0){
	  		jQuery("#reply_top").hide();
	  	}else{
	  		jQuery("#reply_top").show();
	  	}
	  	
  			if(getCheck())
  			{
  				if(isMainHave){
	  				 	$loadingDiv = $("<div />");
	  					$loadingDiv.css("float","left");
	  					$loadingDiv.css("width","94%");
	  					$loadingDiv.css("height","20px");
	  					$loadingDiv.css("line-height","20px");
	  					$loadingDiv.css("text-align","center");
	  					$loadingDiv.attr("id","loadingDiv");
	  					$loadImg = $("<img />");
	  					$loadImg.attr("src","/rdeploy/assets/img/doc/loading.gif");
	  					$loadingDiv.append($loadImg);
	  					$("#rc").append($loadingDiv);
	  					moreReply(docid);
	  					pageNo ++;
	  			}
  			}
  			var el = jQuery(".edui-for-wfannexbutton");
  			if(el.length > 0){
		        var px=el.offset().left;
			    var py=el.offset().top + 17;
			    jQuery("#_fileuploadphraseblock").css("z-index","999");
			    jQuery("#_fileuploadphraseblock").css({"top":py + "px", "left":px+"px"});
		    }
	});
});

/**
  	* 数据请求检验
  	*/
  	function getCheck(){
  		var documentH = document.documentElement.clientHeight;
  		var scrollH = $("#rc").offset().top;
  		return documentH+scrollH+60 >= $(".core_reply_ul:last").offset().top ?true:false;
  	}
  	
	function fullDocReplyMain(docReplyModel,isedit,isNew)
	{
		$coreReplyContent = $("<div />");
		if(docReplyModel.rtype == "1")
		{
			$coreReplyContent.css("padding-left","45px");
			$coreReplyContent.attr("id",docReplyModel.replyid);
		}
		else
		{
			$coreReplyContent.attr("id",docReplyModel.replyid);
		}
		$coreReplyUl = $("<ul />");
		$coreReplyUl.addClass("core_reply_ul");
		if(docReplyModel.rtype == "1")
		{
			$coreReplyUl.css("background-color","#f9f9f9");
		}
		
		
		$coreReplyLi = $("<li />");
		if(docReplyModel.rtype == "1")
		{
			$coreReplyLi.css("padding-top","15px");
			$coreReplyLi.css("padding-left","15px");
		}
		$liDiv = $("<div />");
		$liDiv.addClass("lzl_p_p");
		//$handImg = $("<img />");
		//$handImg.addClass("handImg");
		
		//$handImg.attr("src",docReplyModel.handImg);
		$liDiv.append(docReplyModel.handImg);
		
		$coreReplyLi.append($liDiv);
		
		$cntDiv = $("<div />");
		$cntDiv.attr("id",docReplyModel.replyid+"cntDiv");
		$cntDiv.addClass("lzl_cnt");
		
		$replyInfoDiv = $("<div />");
		$replyInfoDiv.addClass("lzl_content_reply");
		
		$leftDiv = $("<div />");
		$leftDiv.addClass("leftDiv");
		
		
		$name = $("<a />");
		$name.addClass("userName");
  		$name.attr("href","javaScript:openhrm("+docReplyModel.userid+");");
  		$name.bind('click',function() {
				        pointerXY(event);
				    });
  		$name.append(docReplyModel.username);

		if(docReplyModel.rtype == "1")
		{
			$replyName = $("<a />");
			$replyName.addClass("userName");
	  		$replyName.attr("href","javaScript:openhrm("+docReplyModel.ruserid+");");
	  		$replyName.bind('click',function() {
					        pointerXY(event);
					    });
	  		$replyName.append(docReplyModel.rusername);
			$reply_span = $("<span />");
			$reply_span.addClass("reply_span");
			$reply_span.append("<%=SystemEnv.getHtmlLabelName(126369,user.getLanguage())%>");
			$leftDiv.append($name).append($reply_span).append($replyName);
		}
		else
		{
			$leftDiv.append($name);
		}
		
		$replyDate = $("<span />");
		$replyDate.addClass("span_date");
		$replyDate.append(docReplyModel.rdata+" "+docReplyModel.rtime);
		$leftDiv.append($replyDate);
		
		$replyInfoDiv.append($leftDiv);
		
		$rightDiv = $("<div />");
		$rightDiv.addClass("right_div");
		if($("#"+docReplyModel.rreplyid+"updateBtn").length > 0)
		{
			$("#"+docReplyModel.rreplyid+"updateBtn").remove();
				$("#"+docReplyModel.rreplyid+"delBtn1").remove();
		}
		if(docReplyModel.userid == <%= user.getUID() %> || (","+userbelongids+",").indexOf(","+docReplyModel.userid+",") > -1)
		{
			var mydate = new Date();
			var dtEnd = StringToDate(docReplyModel.rdata +" "+ docReplyModel.rtime);
			if(parseInt((mydate - dtEnd) / 60000) < 10)
			{
				$replyEdit = $("<span />");
				$replyEdit.attr("id",docReplyModel.replyid+"updateBtn");
				$replyEdit.attr("_id",docReplyModel.replyid);
				$replyEdit.attr("_rtype",docReplyModel.rtype);
				$replyEdit.addClass("updateBtn");
				$replyEdit.append("<%=SystemEnv.getHtmlLabelName(126370,user.getLanguage())%>");
				
				$replyEdit.bind('click',function(){
					editReply($(this).attr("_id"), $(this).attr("_rtype"));
				});
				
				$replyDel = $("<span />");
				$replyDel.attr("id",docReplyModel.replyid+"delBtn1");
				$replyDel.attr("_id",docReplyModel.replyid);
				$replyDel.attr("_mainid",docReplyModel.replymainid);
				$replyDel.attr("_docid",docReplyModel.docid);
				$replyDel.addClass("delBtn1");
				$replyDel.append("<%=SystemEnv.getHtmlLabelName(126371,user.getLanguage())%>");
				$replyDel.bind('click',function(){
					var delid = $(this).attr("_id");
					var delmainid = $(this).attr("_mainid");
					var deldocid = $(this).attr("_docid");
					top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(126376,user.getLanguage())%>",function(){
						delReply(delid,delmainid,deldocid);
						//$("#"+delid+"delBtn1").parent().parent().parent().parent().parent().remove();
					});
				});
				
				$rightDiv.append($replyEdit).append($replyDel);
				setTimeout(function(){
					$("#"+docReplyModel.replyid+"updateBtn").remove();
					$("#"+docReplyModel.replyid+"delBtn1").remove();
				},10*60*1000 - parseInt((mydate - dtEnd) / 60));
			}
		}
		$reply = $("<span />");
		$reply.addClass("replyBtn");
		$reply.append("<%=SystemEnv.getHtmlLabelName(126369,user.getLanguage())%>");
		$reply.attr("_dataid",docReplyModel.replyid);
		$reply.attr("_replyuserid",docReplyModel.userid);
		$reply.attr("_replymainid",docReplyModel.replymainid);
		
		$reply.bind('click',function(){
			moveReplyContent($(this).attr("_dataid"),$(this).attr("_replyuserid"),$(this).attr("_replymainid"));
		});
		
		
		$replyParise = $("<div />");
		$replyParise.addClass("praise");
		$praiseImg = $("<div />");
		if(docReplyModel.praiseInfo == null)
		{
			$praiseImg.addClass("praiseImg");
			$praiseImg.attr("title","<%=SystemEnv.getHtmlLabelName(32942,user.getLanguage())%>");
		}
		else
		{
			if(docReplyModel.praiseInfo.isPraise == '1')
			{
				$praiseImg.addClass("praiseImg_hot");
				$praiseImg.attr("title","<%=SystemEnv.getHtmlLabelName(32944,user.getLanguage())%>");
			}
			else
			{
				$praiseImg.addClass("praiseImg");
				$praiseImg.attr("title","<%=SystemEnv.getHtmlLabelName(32942,user.getLanguage())%>");
			}
		}
		$praiseImg.attr("id",docReplyModel.replyid+"Praise");
		
		$praiseNum = $("<font />");
		$praiseNum.addClass("praiseFont");
		if(docReplyModel.praiseInfo == null)
		{
			$praiseNum.text("");
		}
		else
		{
			$praiseNum.text(docReplyModel.praiseInfo.users.length);
		}
		$replyParise.append($praiseImg).append($praiseNum);
		
			if(docReplyModel.praiseInfo == null)
			{
				$praiseImg.bind('click',function(){
					praise(docReplyModel.replyid, '1',docid);
				});
			}
			else
			{
				if(docReplyModel.praiseInfo.isPraise == '1')
				{
					$praiseImg.bind('click',function(){
						unPraise(docReplyModel.replyid, '1');
					});
				}
				else
				{
					$praiseImg.bind('click',function(){
						praise(docReplyModel.replyid, '1',docid);
					});
				}
			}
		
		$rightDiv.append($reply).append($replyParise);
		
		$replyInfoDiv.append($rightDiv);
		
		
		$replyContent = $("<div />");
		$replyContent.attr("id",docReplyModel.replyid+"r_content");
		$replyContent.addClass("r_content");
		
		if(docReplyModel.aboutImgs.length > 0)
		{
			var contentTemp = docReplyModel.content;
			contentTemp += "<br />";
			for(var imgs in docReplyModel.aboutImgs)
			{
				for(var imgid in docReplyModel.aboutImgs[imgs])
				{
					contentTemp += "<img style='max-width: 60px; max-height: 60px;' onclick='playImgs(this);' src='/weaver/weaver.file.FileDownload?fileid="+jQuery.trim(imgid)+"' />";
				}
			}
			$replyContent.append(contentTemp);
		}
		else
		{
			$replyContent.append(docReplyModel.content);
		}
		// 相关文档
		$aboutDocs = $("<div />");
		fullAboutDocs($aboutDocs,docReplyModel.aboutDocs);
		$replyContent.append($aboutDocs);
		// 相关流程
		$aboutwfs = $("<div />");
		fullAboutWorkflow($aboutwfs,docReplyModel.aboutwfs);
		$replyContent.append($aboutwfs);
		// 相关附件
		$aboutFiles = $("<div />");
		fullAboutFiles($aboutFiles,docReplyModel.aboutFiles);
		$replyContent.append($aboutFiles);
		
		$cntDiv.append($replyInfoDiv).append($replyContent);
		$coreReplyLi.append($cntDiv);
		
		$showrequestline = $("<div />");
		$showrequestline.attr("id",docReplyModel.replyid+"showrequestline");
		$showrequestline.addClass("showrequestline");
		if(docReplyModel.rtype == "1")
		{
			$("#"+docReplyModel.replymainid+"showrequestline").remove();
			$showrequestline.css("padding-left","45px");
			$showrequestline.css("background-color","#E8E8E8");
			
		}
		$coreReplyLi.append($showrequestline);
		
		if(docReplyModel.rtype==1 && docReplyModel.ishave)
		{
			$residue = $("<p />")
			$residue.css("margin-left","44%");
			$residue.css("padding-bottom","15px");
			$residueSpan = $("<span />")
			$residueSpan.css("color","#8e9598");
			
			var residueSpanLabel = "<%=SystemEnv.getHtmlLabelName(126375,user.getLanguage())%>";
			residueSpanLabel = residueSpanLabel.replace("{0}",docReplyModel.residue);
			$residueSpan.append(residueSpanLabel);
			
			$residuea = $("<a />")
			$residuea.css("color","#4ba9df");
			$residuea.css("cursor","pointer");
			$residuea.attr("id",docReplyModel.replymainid+"residue");
			$residuea.attr("_id",docReplyModel.replyid);
			$residuea.attr("_docid",docReplyModel.docid);
			$residuea.attr("_replymainid",docReplyModel.replymainid);
			$residuea.bind('click',function(){
				residueReply($(this).attr("_docid"),$(this).attr("_replymainid"),$(this).attr("_id"));
				$(this).parent().remove();
			});
			$residuea.append("<%=SystemEnv.getHtmlLabelName(82279,user.getLanguage())%>");
			$residue.append($residueSpan).append($residuea);
			$coreReplyLi.append($residue);
		}
		
		
		$coreReplyUl.append($coreReplyLi);
		$coreReplyContent.append($coreReplyUl);
		
		if(isedit)
		{
			$("#"+docReplyModel.replyid).append($coreReplyUl);
			$("#"+docReplyModel.replyid).show();
		}
		else
		{
			if($("#"+docReplyModel.replymainid).length > 0)
			{
				$("#"+docReplyModel.replymainid).append($coreReplyContent);
			}
			else
			{
				if(isNew)
				{
					$("#rc").prepend($coreReplyContent);
					//$("#reply_operator").after($coreReplyContent);
				}
				else
				{
					$("#rc").append($coreReplyContent);
				}
			}
			if(docReplyModel.rtype==0)
			{
				if(docReplyModel.ishave)
				{
					isMainHave = true;
				}
				else
				{
					isMainHave = false;
				}
				lastMainReplyid = docReplyModel.replyid;
			}
			else
			{
				ishave = false;
			}
		}
		
		if($("#"+docReplyModel.replymainid+"LH").length <= 0)
		{
			$lastReplyidHidden = $("<input />");
			$lastReplyidHidden.attr("type","hidden");
			$lastReplyidHidden.attr("id",docReplyModel.replymainid+"LH");
			$lastReplyidHidden.val(docReplyModel.replyid);
			$coreReplyContent.append($lastReplyidHidden);
		}
		else
		{
			$("#"+docReplyModel.replymainid+"LH").val(docReplyModel.replyid);
		}
		
	}
	
	
	function fullEditDocReplyMain(docReplyModel)
	{
		$replyContent = $("<div />");
		$replyContent.attr("id",docReplyModel.replyid+"r_content");
		$replyContent.addClass("r_content");
		if(docReplyModel.aboutImgs.length > 0)
		{
			var contentTemp = docReplyModel.content;
			contentTemp += "<br />";
			for(var imgs in docReplyModel.aboutImgs)
			{
				for(var imgid in docReplyModel.aboutImgs[imgs])
				{
					contentTemp += "<img style='max-width: 60px; max-height: 60px;' onclick='playImgs(this);' src='/weaver/weaver.file.FileDownload?fileid="+jQuery.trim(imgid)+"' />";
				}
			}
			$replyContent.append(contentTemp);
		}
		else
		{
			$replyContent.append(docReplyModel.content);
		}
		// 相关文档
		$aboutDocs = $("<div />");
		fullAboutDocs($aboutDocs,docReplyModel.aboutDocs);
		$replyContent.append($aboutDocs);
		// 相关流程
		$aboutwfs = $("<div />");
		fullAboutWorkflow($aboutwfs,docReplyModel.aboutwfs);
		$replyContent.append($aboutwfs);
		// 相关附件
		$aboutFiles = $("<div />");
		fullAboutFiles($aboutFiles,docReplyModel.aboutFiles);
		$replyContent.append($aboutFiles);
		
		$("#"+docReplyModel.replyid+"cntDiv").append($replyContent);
	}
	
	function moreReply(did)
	{
		jQuery.ajax({
			type: "POST",
			url: "/docs/reply/OperDocReply.jsp",
			data: {
			operation: queryAll ? "allResidueReply" : 'moreReply',
			replyid : lastMainReplyid,
			pageSize: '15',
			childrenSize: '5',
			docid : did,
			orderby : order,
			userid: <%=user.getUID() %>
			},
			cache: false,
			async:false,
			dataType: 'json',
			success: function(data){
				$("#loadingDiv").remove();
				$.each(data,function(id, docReplyModel) {
					 fullDocReplyMain(docReplyModel,false);
				 });
				 
				 if(queryAll){ //获取所有的，并滚动到最低端
				 	queryAll = false;
					var _scrollTop = 0;
					jQuery("#reply_operator").nextAll().each(function(){
						_scrollTop += this.clientHeight;
					});
					jQuery("#rc").animate({
						scrollTop : _scrollTop
					},300);
				}
			}
		});
	}
	
	/**
	删除
	*/
	function residueAllReply(did)
	{
		jQuery.ajax({
			type: "POST",
			url: "/docs/reply/OperDocReply.jsp",
			data: {
			operation: 'allResidueReply',
			docid : did,
			replyid : lastReplyid,
			childrenSize: '5',
			userid: <%=user.getUID() %>
			},
			cache: false,
			async:false,
			dataType: 'json',
			success: function(data){
				$.each(data,function(id, docReplyModel) {
					 fullDocReplyMain(docReplyModel,false);
				 });
			}
		});
	}
	
	function residueReply(did,replymainid,lastreplyid)
	{
		jQuery.ajax({
			type: "POST",
			url: "/docs/reply/OperDocReply.jsp",
			data: {
			operation: 'residue',
			docid : did,
			lastReplyid : lastreplyid,
			replymainid: replymainid,
			userid: <%=user.getUID() %>
			},
			cache: false,
			async:false,
			dataType: 'json',
			success: function(data){
				$.each(data,function(id, docReplyModel) {
					 fullDocReplyMain(docReplyModel,false);
				 });
			}
		});
	}
	
	
	function moveReplyContent(id,ruserid,replymainid)
	{
		$("#optype").val('reply');
		$("#childReplyDiv").css("position","");
		$("#childReplyDiv").css("margin-left","45px");
		$("#"+replymainid).append($("#childReplyDiv"));
		$("#replyid").val(id);
		$("#docid").val(docid);
		$("#lastReplyid").val($("#"+replymainid+"LH").val());
		$("#replytype").val("1");
		$("#replymainid").val(replymainid);
		$("#replyuserid").val(ruserid); 
		$("#signdocids").val('');
		$("#signworkflowids").val('');
		$("#field-annexupload").val('');
		$("#field-annexupload-name").val('');
		$("#field-annexupload-count").val('');
		jQuery("#_fileuploadphraseblock").find("#_filecontentblock ul").empty();
		updateScroll = true;
		replycontent = '';
		_ueditorChild = '';
		initremarkueditor();
	}
	
	function StringToDate(DateStr)
	{
		var converted = Date.parse(DateStr.replace(/-/g, "/"));
		var myDate = new Date(converted);
		if (isNaN(myDate))
		{
		var arys= DateStr.split('-');
		myDate = new Date(arys[0],--arys[1],arys[2]);
		}
		return myDate;
	} 
	
	
	function fullAboutDocs(lidiv,aboutDocs)
	{
			 $.each(aboutDocs,
                    function(iid, doc) {
                    	if(iid == 0)
                    	{
                    		$aboutdoc =  $("<span />")
							$aboutdoc.css("line-height","26px");
							$aboutdocImg = $("<img />");
							$aboutdocImg.attr('id','aboutdocImg');
							$aboutdocImg.attr("title","<%=SystemEnv.getHtmlLabelName(126378,user.getLanguage())%>");
							$aboutdocImg.attr("src","/images/sign/wd_wev8.png");
							$aboutdocImg.css("line-height","26px");
							$aboutdocImg.css("vertical-align","middle");
							$aboutdoc.append($aboutdocImg);
                    		$aboutdoc_a = $("<a />");
							$aboutdoc_a.addClass("wffbtn");
							$aboutdoc_a.css("line-height","26px");
							$aboutdoc_a.css("cursor","pointer");
							$aboutdoc_a.css("color","#123885");
							$aboutdoc_a.css("padding-left","15px");
							for (var docid in doc) {
								$aboutdoc_a.attr("title",doc[docid]);
								$aboutdoc_a.append(doc[docid]);
								$aboutdoc_a.bind('click',function(){
									openFullWindowHaveBar('/docs/docs/DocDsp.jsp?id='+docid);
								});
								$aboutdoc.append($aboutdoc_a);
								lidiv.append($aboutdoc).append("<br />");
					        }
                    	}
                    	else
                    	{
                    		$aboutdocchild =  $("<span />")
                    		$aboutdocchild.css("line-height","26px");
                    		$aboutdocchildSpan =  $("<span />")
                    		$aboutdocchildSpan.css("line-height","26px");
                    		$aboutdocchildSpan.css("vertical-align","middle");
                    		$aboutdocchildSpan.css("opacity","0");
                    		$aboutdocchildSpan.css("padding-left","19px");
                    		$aboutdocchild.append($aboutdocchildSpan);
                    		$aboutdocchild_a = $("<a />");
							$aboutdocchild_a.addClass("wffbtn");
							$aboutdocchild_a.css("line-height","26px");
							$aboutdocchild_a.css("cursor","pointer");
							$aboutdocchild_a.css("color","#123885");
							$aboutdocchild_a.css("padding-left","15px");
							for (var docid in doc) {
								$aboutdocchild_a.attr("title",doc[docid]);
								$aboutdocchild_a.append(doc[docid]);
								$aboutdocchild_a.bind('click',function(){
									openFullWindowHaveBar('/docs/docs/DocDsp.jsp?id='+docid);
								});
								$aboutdocchild.append($aboutdocchild_a);
	                    		lidiv.append($aboutdocchild).append("<br />");
					        }
                    	}
                    });
       }
	
	function fullAboutFiles(lidiv,aboutfiles)
	{
			 $.each(aboutfiles,
                    function(iid, imagefile) {
                    	if(iid == 0)
                    	{
                    		$aboutfjfiles =  $("<span />")
							$aboutfjfiles.css("line-height","26px");
							$aboutfjfilesImg = $("<img />");
							$aboutfjfilesImg.attr("title","<%=SystemEnv.getHtmlLabelName(126380,user.getLanguage())%>");
							$aboutfjfilesImg.attr("src","/images/sign/fj_wev8.png");
							$aboutfjfilesImg.css("line-height","26px");
							$aboutfjfilesImg.css("vertical-align","middle");
							$aboutfjfiles.append($aboutfjfilesImg);
                    		$aboutfjfiles_a = $("<a />");
							$aboutfjfiles_a.addClass("wffbtn");
							$aboutfjfiles_a.addClass("fj");
							$aboutfjfiles_a.css("line-height","26px");
							$aboutfjfiles_a.css("cursor","pointer");
							$aboutfjfiles_a.css("color","#123885");
							$aboutfjfiles_a.css("padding-left","15px");
							for (var imageid in imagefile) {
								$aboutfjfiles_a.attr("title",imagefile[imageid]);
								$aboutfjfiles_a.append(imagefile[imageid]);
								$aboutfjfiles_a.attr("target","_blank");
								$aboutfjfiles_a.attr("href","/weaver/weaver.docs.docs.reply.FileDownload?docid="+docid+"&fileid="+imageid);
								//$aboutfjfiles_a.bind('click',function(){
								//	 openAboutFiles(imageid);
								//});
								$aboutfjfiles.append($aboutfjfiles_a);
								lidiv.append($aboutfjfiles).append("<br />");
					        }
                    	}
                    	else
                    	{
                    		$aboutfjchild =  $("<span />")
                    		$aboutfjchild.css("line-height","26px");
                    		$aboutfjchildSpan =  $("<span />")
                    		$aboutfjchildSpan.css("line-height","26px");
                    		$aboutfjchildSpan.css("vertical-align","middle");
                    		$aboutfjchildSpan.css("opacity","0");
                    		$aboutfjchildSpan.css("padding-left","19px");
                    		$aboutfjchild.append($aboutfjchildSpan);
                    		$aboutfjchild_a = $("<a />");
							$aboutfjchild_a.addClass("wffbtn");
							$aboutfjchild_a.css("line-height","26px");
							$aboutfjchild_a.css("cursor","pointer");
							$aboutfjchild_a.css("color","#123885");
							$aboutfjchild_a.css("padding-left","15px");
                    		for (var imageid in imagefile) {
								$aboutfjchild_a.attr("title",imagefile[imageid]);
								$aboutfjchild_a.append(imagefile[imageid]);
								$aboutfjchild_a.attr("target","_blank");
								$aboutfjchild_a.attr("href","/weaver/weaver.docs.docs.reply.FileDownload?docid="+docid+"&fileid="+imageid);
								//$aboutfjchild_a.bind('click',function(){
								//	openAboutFiles(imageid);
								//});
								$aboutfjchild.append($aboutfjchild_a);
	                    		lidiv.append($aboutfjchild).append("<br />");
					        }
                    	}
                    });
	}
	
	function fullAboutWorkflow(lidiv,aboutwfs)
	{
			 $.each(aboutwfs,
                    function(iid, wf) {
                    	if(iid == 0)
                    	{
                    		$aboutwf =  $("<span />")
							$aboutwf.css("line-height","26px");
							$aboutwfImg = $("<img />");
							$aboutwfImg.attr("title","<%=SystemEnv.getHtmlLabelName(126379,user.getLanguage())%>");
							$aboutwfImg.attr("src","/images/sign/wf_wev8.png");
							$aboutwfImg.css("line-height","26px");
							$aboutwfImg.css("vertical-align","middle");
							$aboutwf.append($aboutwfImg);
                    		$aboutwf_a = $("<a />");
							$aboutwf_a.addClass("wffbtn");
							$aboutwf_a.css("line-height","26px");
							$aboutwf_a.css("cursor","pointer");
							$aboutwf_a.css("color","#123885");
							$aboutwf_a.css("padding-left","15px");
							for (var wid in wf) {
								$aboutwf_a.attr("title",wf[wid]);
								$aboutwf_a.append(wf[wid]);
								$aboutwf_a.bind('click',function(){
									openFullWindowHaveBar("/workflow/request/ViewRequest.jsp?f_weaver_belongto_userid=<%= user.getUID() %>&f_weaver_belongto_usertype=<%= user.getType() %>&requestid="+wid+"&isrequest=1");
								});
								$aboutwf.append($aboutwf_a);
								lidiv.append($aboutwf).append("<br />");
					        }
                    	}
                    	else
                    	{
                    		$aboutwfchild =  $("<span />")
                    		$aboutwfchild.css("line-height","26px");
                    		
                    		$aboutwfchildSpan =  $("<span />")
                    		$aboutwfchildSpan.css("line-height","26px");
                    		$aboutwfchildSpan.css("vertical-align","middle");
                    		$aboutwfchildSpan.css("opacity","0");
                    		$aboutwfchildSpan.css("padding-left","19px");
                    		$aboutwfchild.append($aboutwfchildSpan);
                    		$aboutwfchild_a = $("<a />");
							$aboutwfchild_a.addClass("wffbtn");
							$aboutwfchild_a.css("line-height","26px");
							$aboutwfchild_a.css("cursor","pointer");
							$aboutwfchild_a.css("color","#123885");
							$aboutwfchild_a.css("padding-left","15px");
							for (var wid in wf) {
								$aboutwfchild_a.attr("title",wf[wid]);
								$aboutwfchild_a.append(wf[wid]);
								$aboutwfchild_a.bind('click',function(){
									openFullWindowHaveBar("/workflow/request/ViewRequest.jsp?f_weaver_belongto_userid=<%= user.getUID() %>&f_weaver_belongto_usertype=<%= user.getType() %>&requestid="+wid+"&isrequest=1");
								});
								$aboutwfchild.append($aboutwfchild_a);
	                    		lidiv.append($aboutwfchild).append("<br />");
					        }
                    	}
                    });
	}
	
	
	function praise(replyid,replytype,docid)
	{
		jQuery.ajax({
			type: "POST",
			url: "/docs/reply/OperDocReply.jsp",
			data: {
			replyid: replyid,
			operation: 'praise',
			docid : docid,
			replytype: replytype,
			userid: <%=user.getUID() %>
			},
			cache: false,
			async:false,
			dataType: 'json',
			success: function(msg){
				
					$("#"+replyid+"Praise").unbind("click");
					$("#"+replyid+"Praise").bind('click',function(){
						unPraise(replyid, replytype);
					});
					if($("#"+replyid+"Praise").next().text() == "")
					{
						$("#"+replyid+"Praise").next().text("1");
					}
					else
					{
						var index = parseInt($("#"+replyid+"Praise").next().text());
		  				$("#"+replyid+"Praise").next().text(index+1);
					}
					$("#"+replyid+"Praise").removeClass('praiseImg');
					$("#"+replyid+"Praise").attr("title","<%=SystemEnv.getHtmlLabelName(32944,user.getLanguage())%>");
					$("#"+replyid+"Praise").addClass('praiseImg_hot');
			}
		});
	}
	
	function unPraise(replyid,replytype)
	{
		jQuery.ajax({
			type: "POST",
			url: "/docs/reply/OperDocReply.jsp",
			data: {
			replyid: replyid,
			operation: 'unpraise',
			docid : docid,
			replytype: replytype,
			userid: <%=user.getUID() %>
			},
			cache: false,
			async:false,
			dataType: 'json',
			success: function(msg){
					$("#"+replyid+"Praise").unbind("click");
					$("#"+replyid+"Praise").bind('click',function(){
						praise(replyid, replytype,docid);
					});
					var index = parseInt($("#"+replyid+"Praise").next().text());
						if(index - 1 > 0)
						{
							$("#"+replyid+"Praise").next().text(index-1);
						}
						else
						{
							$("#"+replyid+"Praise").next().text("");
						}
		  			$("#"+replyid+"Praise").removeClass('praiseImg_hot');
		  			$("#"+replyid+"Praise").attr("title","<%=SystemEnv.getHtmlLabelName(32942,user.getLanguage())%>");
					$("#"+replyid+"Praise").addClass('praiseImg');
			}
		});
	}
	
	function delReply(replyid,mainid,docid)
	{
			jQuery.ajax({
			type: "POST",
			url: "/docs/reply/OperDocReply.jsp",
			data: {
			replyid: replyid,
			docid: docid,
			replymainid: mainid,
			operation: 'delReply',
			userid: <%=user.getUID() %>
			},
			cache: false,
			async:false,
			dataType: 'json',
			success: function(msg){
				if(msg.error == "0")
				{
					top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(126381,user.getLanguage())%>");
		        	setTimeout(function(){
		        		top.Dialog.close();
		        	},2000);
				}
				else
				{
						$("#"+replyid).hide();
						var _flag = true;
						$("#" + replyid).siblings("div:visible").each(function(){
							if(this.id && /^\d*$/.test(this.id)){
								_flag = false;
								return;
							}
						});
						if(_flag){
							var _id = $("#" + replyid).parent().attr("id");
							if($("#" + _id + "showrequestline").length == 0){
								$("#" + _id).append("<div id='" + _id + "showrequestline' class='showrequestline'></div>")
							}
						}
						// 改写回复总数
					   			var replyCountText = $("#divReplayATabTitle",window.parent.parent.document).text();
					   			replyCountText = replyCountText.substr(replyCountText.lastIndexOf(";")+1);
					   			var replyCount = replyCountText.substr(replyCountText.lastIndexOf("(")+1,replyCountText.lastIndexOf(")"));
					   			var replyCountAdd = parseInt(replyCount);
					   			replyCountAdd = replyCountAdd - 1;
					   			$("#divReplayATabTitle",window.parent.parent.document).text(replyCountText.replace(replyCount,replyCountAdd)+")");
					    
				}
				if($(".core_reply_ul:visible").length <= 0)
				{
					$("#imDefaultdiv").show();
					$("#reply_order").hide();
				}
			}
		});	
	}
	
	
	function editReply(replyid,replytype)
	{
		jQuery.ajax({
			type: "POST",
			url: "/docs/reply/OperDocReply.jsp",
			data: {
			replyid: replyid,
			docid : docid,
			operation: 'getReply'
			},
			cache: false,
			async:false,
			dataType: 'json',
			success: function(msg){
					if(msg.error == "0")
					{
						top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(126382,user.getLanguage())%>");
		        		setTimeout(function(){
		        			top.Dialog.close();
		        		},2000);
					}			
					else
					{
					var docReplyModel = msg.docReplyModel;
					$("#optype").val('edit');
					$("#replyid").val(replyid);
					$("#replytype").val(replytype);
					$("#replymainid").val(docReplyModel.replymainid);
					
					var signdocids = '';
					var signdocnames = '';
					for(var docids in docReplyModel.aboutDocs)
					{
						 for(var docid in docReplyModel.aboutDocs[docids])
						 {
						 	signdocids += docid;
						 	signdocnames += docReplyModel.aboutDocs[docids][docid];
						 }
						 if(docReplyModel.aboutDocs.length != docids+1)
						 {
						 	signdocids += ',';
						 	signdocnames +=  '////~~weaversplit~~////';
						 }
					}
					if(signdocids != '')
					{
						signdocids = signdocids.replace(/,$/g,"");
						$("#signdocids").val(signdocids);
						$("#signdocnames").val(signdocnames);
					}
					
					var signwfids = '';
					var signworkflownames = '';
					for(var wfids in docReplyModel.aboutwfs)
					{
						 for(var wfid in docReplyModel.aboutwfs[wfids])
						 {
						 	signwfids += wfid;
						 	signworkflownames += docReplyModel.aboutwfs[wfids][wfid];
						 }
						 if(docReplyModel.aboutwfs.length != wfids+1)
						 {
						 	signwfids += ',';
						 	signworkflownames +=  '////~~weaversplit~~////';
						 }
					}
					if(signwfids != '')
					{
						signwfids = signwfids.replace(/,$/g,"");
						$("#signworkflowids").val(signwfids);
						$("#signworkflownames").val(signworkflownames);
					}
					var imgids = '';
					var imgnames = '';
					var i = 0;
					
					for(var fileids in docReplyModel.aboutFiles)
					{
						 for(var fileid in docReplyModel.aboutFiles[fileids])
						 {
						 	imgids += fileid ;
						 	imgnames += docReplyModel.aboutFiles[fileids][fileid];
						 }
						 if(docReplyModel.aboutFiles.length != fileids+1)
						 {
						 	imgids += ',';
						 	imgnames +=  '////~~weaversplit~~////';
						 }
						 i++;
					}
					if(imgids != '')
					{
						imgids = imgids.replace(/,$/g,"");
					}
					
					$("#field-annexupload").val(imgids);
					$("#field-annexupload-name").val(imgnames);
					$("#field-annexupload-count").val(i);
					
					var imgincontent = '';
					var imgincontentname = '';
					for(var inimg in docReplyModel.aboutImgs)
					{
						 for(var inimgid in docReplyModel.aboutImgs[inimg])
						 {
						 	imgincontent += inimgid;
						 	imgincontentname += docReplyModel.aboutImgs[inimg][inimgid];
						 }
						 if(docReplyModel.aboutImgs.length != inimg+1)
						 {
						 	imgincontent += ',';
						 	imgincontentname +=  '////~~weaversplit~~////';
						 }
					}
					$("#imgFileids").val(imgincontent);
					$("#imgFilenames").val(imgincontentname);
					
					$("#childReplyDiv").css("position","");
					$("#childReplyDiv").css("margin-left","0px");
					
					$("#childReplyDiv").insertAfter($("#"+replyid).find(".r_content"));
					
					
					$("#"+replyid).find(".r_content").hide();
					
					_ueditorChild = '';
					replycontent = docReplyModel.content;
					initremarkueditor();
					}
				}
		});
	}
	
	
	function openAppLink(obj,linkid){

    var linkType=jQuery(obj).attr("linkType");
    if(linkType=="doc")
        window.open("/docs/docs/DocDsp.jsp?id="+linkid);
    else if(linkType=="task")
        window.open("/proj/process/ViewTask.jsp?taskrecordid="+linkid);
    else if(linkType=="crm")
        window.open("/CRM/data/ViewCustomer.jsp?CustomerID="+linkid);
    else if(linkType=="workflow")
        window.open("/workflow/request/ViewRequest.jsp?requestid="+linkid);
    else if(linkType=="project")
        window.open("/proj/data/ViewProject.jsp?ProjID="+linkid);
    else if(linkType=="workplan")
        window.open("/workplan/data/WorkPlanDetail.jsp?workid="+linkid);
    return false;
}
function playImgs(e)
{
	var imgPool=new Array()
	var indexNum = 0;
	var imgs = $(e).closest('.r_content').find("img");
    imgs.each(function(){
        if($(this).attr('src') != '/images/sign/fj_wev8.png' && $(this).attr('src') != '/images/sign/wf_wev8.png' && $(this).attr('src') != '/images/sign/wd_wev8.png')
        {
        	imgPool.push($(this).attr('src'));
        }
    });
    for(var i = 0; i < imgPool.length ; i ++)
    {
    	if($(e).attr('src') == imgPool[i])
        {
        	break;
        }
        else
        {
        	indexNum++;
        }
    }
    parent.parent.IMCarousel.showImgScanner4Pool(true, imgPool, indexNum, null, window.top);
}
</script>
	<body>
		<div id="rc" class="rcDiv">
			<div class="defaultdiv" id="imDefaultdiv">
				<div style="margin-top:200px;">
					<img src="/social/images/im/im_nochat_wev8.png">
				</div>
				<div style="color:ababab;margin-top:20px;font-size:16px;"><%=SystemEnv.getHtmlLabelName(126368,user.getLanguage())%></div>
			</div>
			<div id="reply_operator">
				
				<%if("desc".equals(order)){ %>
					<div id="reply_order" class="reply_order_asc">
						<img src="img/reply_order_asc.png" title="<%=SystemEnv.getHtmlLabelName(21605,user.getLanguage())%>"/>
					</div>
				<%}else{ %>
					<div id="reply_order" class="reply_order_desc">
						<img src="img/reply_order_desc.png" title="<%=SystemEnv.getHtmlLabelName(21604,user.getLanguage())%>"/>
					</div>
				<%} %>
				
				<div id="reply_top">
					<img src="img/reply_top.png" title="<%=SystemEnv.getHtmlLabelName(84529,user.getLanguage())%>"/>
				</div>
			</div>
		</div>
		<div id="childReplyDiv" class="nofullScreenDiv">
				<jsp:include page="/docs/reply/DocReplyChild.jsp" flush="true">
					<jsp:param name="docid" value="<%=docid%>" />
				</jsp:include>
		</div>
	</body>
	
	<script>
	
	
		jQuery(function(){
		
			//返回顶部
			jQuery("#reply_top").click(function(){
				jQuery("#rc").animate({
					scrollTop : 0
				},300);
			});
			
			jQuery("#reply_order").click(function(){
				var _class = this.className;
				if(_class.indexOf("reply_order_desc") != -1){
					jQuery(this).children().attr({
						"src" : "img/reply_order_asc.png",
						"title" : "<%=SystemEnv.getHtmlLabelName(21605,user.getLanguage())%>"
					});
					this.className = "reply_order_asc";
					order = "desc";
				}else if(_class.indexOf("reply_order_asc") != -1){
					jQuery(this).children().attr({
						"src" : "img/reply_order_desc.png",
						"title" : "<%=SystemEnv.getHtmlLabelName(21604,user.getLanguage())%>"
					});
					this.className = "reply_order_desc";
					order = "asc";
				}
		        var exp  = new Date();  
		        exp.setTime(exp.getTime() + 30*24*60*60*1000); 
				document.cookie = "docReplyOrder" + "="+ escape (order) + ";expires=" + exp.toGMTString(); 
				location.href = location.href;
			});
		});
		
		
		function replyNewsAll(docReplyModel,isedit,isNew){
			$("#reply_order").show();
			if(order == "asc"){
				queryAll = true;
				moreReply(docid);
				lastMainReplyid = docoReplyModel.replyid;
			}else{
				fullDocReplyMain(docReplyModel,isedit,isNew);
			}
		}
		
	</script>
</html>