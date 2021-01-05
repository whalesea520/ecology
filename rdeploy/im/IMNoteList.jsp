
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/social/im/SocialIMInit.jsp"%>
<%
	int userid=user.getUID();
	String username = user.getUsername();
%>
<link rel="stylesheet" type="text/css" href="/rdeploy/im/css/im_note_wev8.css"/>
<div class="noteEdit" onclick="DiscussUtil.showNote(this);" style="display:none;">
       	请输入公告内容
</div>
<!-- 编辑区域 -->
<div style="display:none;" class="note-editor" 
	_senderid="<%=userid%>" _sendername="<%=username %>" _acceptid="%acceptId%" onclick="DiscussUtil.showNote(this);stopEvent();">
	<div style="padding: 5px;">
		<textarea name="noteEditor" maxlength="4000" id="noteEd_%acceptId%" class="gg_edit_area" onkeyup="checkWord(this);"></textarea>
	</div>
	<div class="note_ctrl">
		<!-- 字数提示 1109 by wyw -->
		<div class="wordLen" style="display: block;">尚可输入2000字</div>
		<div id="releaseNote" style="float:right;" title="确认发布此公告" onclick="DiscussUtil.releaseNote(this);resetWordLen(this);">发布公告</div>
		<div class="clear"></div>
	</div>
</div>
<!-- 显示标题 -->
<div class="note_title">
	<div class="tip">历史公告</div>
</div>
<!-- 显示历史记录 -->
<div id="noteTrack" class="note-track"></div>
<!-- 历史记录显示模板 -->
<div id="noteitemdivmode" style="display:none">
	<div class="note-content-pane">
		
	</div>
	<div class="note-bottom-pane">
		<!-- 编辑删除 -->
		<!--
			<div class="bottom-left-control">
				<a href="javascript:void;" onclick="DiscussUtil.editNote(this)">编辑</a>
				&nbsp;&nbsp;&nbsp;
				<a href="javascript:void;" onclick="DiscussUtil.delNote(this)">删除</a>
			</div>
		 -->
		<div class="bottom-right-sender">
			<span class="sendername"></span>
			&nbsp;发表于：<span class="senderdate"></span>
			<input class="senderid" type="hidden"/>
		</div>
	</div>
	
</div>
<script>
	//检查字数
	function checkWord(obj){
	  	var noteEditorDiv = $(obj).parents(".note-editor");
	  	var wordLenDiv = noteEditorDiv.find(".wordLen");
	  	var maxLen = 2000;
	  	if(IMUtil){
	  		maxlen = IMUtil.settings.WORDMAXLEN;
	  	}
	  	var curContent = obj.value;
	  	//删空后会预留一个<br>
	  	if(curContent == "<br>"){
	  		curContent = "";
	  	}
	  	var strLen = 0;
	  	if(IMUtil){
	  		strLen = IMUtil.getStrLen(curContent);
	  	}
	  	if(strLen > maxLen * 2){
	  		wordLenDiv.html("当前输入已超出"+maxLen+"字的上限");
	  	}else{
	  		var left = Math.ceil(maxLen-strLen/2);
	  		wordLenDiv.html("尚可输入" + left + "字");
	  	}
	  }
	 //初始化字数提示
	 function resetWordLen(obj) {
	 	var noteEditorDiv = $(obj).parents(".note-editor");
	  	var wordLenDiv = noteEditorDiv.find(".wordLen");
	  	var maxLen = 2000;
	  	if(IMUtil){
	  		maxlen = IMUtil.settings.WORDMAXLEN;
	  	}
	  	wordLenDiv.html("尚可输入"+maxlen+"字");
	 }
</script>
