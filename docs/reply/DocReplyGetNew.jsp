<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="weaver.general.*"%>
<%@ page import="weaver.hrm.*"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="docReply"
	class="weaver.docs.docs.reply.DocReplyManager" scope="page" />
<html>
	<head>
		<%
		    User user = HrmUserVarify.getUser(request, response);
			String docid = Util.null2String(request.getParameter("docid"));
			String secid ="";
			RecordSet.executeSql("select seccategory from docdetail where id="+docid);
			while(RecordSet.next()){
			    secid=RecordSet.getString("seccategory");
			}
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
		<script type="text/javascript"
			src="/js/messagejs/highslide/highslide-full_wev8.js"></script>
		<script type="text/javascript" src="/js/messagejs/simplehrm_wev8.js"></script>
		<script type="text/javascript" src="/js/messagejs/messagejs_wev8.js"></script>
		
		
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
	height: 1px;
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
.praiseImg:hover {
	background-image: url('/docs/reply/img/praise_hot.png');
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
    width: 99%;
    height: auto;
    overflow: auto;
    overflow-x: hidden;
    bottom:75px;
    top:0px;
}
.replyDiv {
	width: 99%;
    position: fixed;
    bottom: 0px;
}

</style>
	<script type="text/javascript">
	var docid = <%= docid %>;
	jQuery("html").live('mousedown', function(){
		 iframepage.window.hideRemark();
	});
</script>
	<body>
		<div id="rc" class="rcDiv">
			<iframe src="/docs/reply/DocReplyGetNew1.jsp?docid=<%= docid %>&secid=<%=secid %>"  id="iframepage" name="iframepage" style="width:100%;height:100%;" frameborder="0" scrolling="no" marginheight="0" marginwidth="0"></iframe>
		</div>
		
		<div id="replyDiv" class="replyDiv">
			<jsp:include page="/docs/reply/DocReply.jsp" flush="true">
				<jsp:param name="docid" value="<%=docid%>" />
			</jsp:include>
		</div>
	</body>
</html>