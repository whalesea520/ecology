
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/social/im/SocialIMInit.jsp"%>
<%
	int userid=user.getUID();
	String username = user.getUsername();
%>
<link rel="stylesheet" type="text/css" href="/social/css/im_note_wev8.css"/>
<div class="noteEdit" onclick="DiscussUtil.showNote(this);" style="display:none;">
       	<%=SystemEnv.getHtmlLabelName(131674, user.getLanguage()) %> 
</div><!-- 请输入公告内容 -->
<!-- 编辑区域 -->
<div style="display:none;" class="note-editor" 
	_senderid="<%=userid%>" _sendername="<%=username %>" _acceptid="%acceptId%" onclick="DiscussUtil.showNote(this);stopEvent();">
	<div style="padding: 5px;">
		<textarea name="noteEditor" maxlength="4000" id="noteEd_%acceptId%" class="gg_edit_area" onkeyup="checkWord(this);"></textarea>
	</div>
	<div class="note_ctrl">
		<!-- 字数提示 1109 by wyw -->
		<div class="wordLen" style="display: block;"><%=SystemEnv.getHtmlLabelName(131677, user.getLanguage()) %>2000<%=SystemEnv.getHtmlLabelName(131676, user.getLanguage()) %></div> <!-- 可输入2000字 -->
		<div id="releaseNote" style="float:right;" title="<%=SystemEnv.getHtmlLabelName(131678, user.getLanguage()) %>" onclick="DiscussUtil.releaseNote(this);resetWordLen(this);"><%=SystemEnv.getHtmlLabelName(131679, user.getLanguage()) %></div><!-- 确认发布此公告， 发布公告 -->
		<div class="clear"></div>
	</div>
</div>
<!-- 显示标题 -->
<div class="note_title">
	<div class="tip"><%=SystemEnv.getHtmlLabelName(131680, user.getLanguage()) %></div><!-- 历史公告 -->
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
			&nbsp;<%=SystemEnv.getHtmlLabelName(131681, user.getLanguage()) %>：<span class="senderdate"></span> <!-- 发表于 -->
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
	  		// 输入超过上限
	  		wordLenDiv.html("<%=SystemEnv.getHtmlLabelName(131682, user.getLanguage()) %> "+maxLen+" <%=SystemEnv.getHtmlLabelName(131676, user.getLanguage())+SystemEnv.getHtmlLabelName(594, user.getLanguage()) %>");
	  	}else{
	  		var left = Math.ceil(maxLen-strLen/2);
	  		wordLenDiv.html("<%=SystemEnv.getHtmlLabelName(131677, user.getLanguage()) %> " + left + " <%=SystemEnv.getHtmlLabelName(131676, user.getLanguage()) %>");
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
	  	wordLenDiv.html("<%=SystemEnv.getHtmlLabelName(131677, user.getLanguage()) %> "+maxlen+" <%=SystemEnv.getHtmlLabelName(131676, user.getLanguage()) %>");
	 }
</script>
