<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="weaver.general.Util"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<style type="text/css">
	.e8login-recordcode-edit {
		height: 360px;
		overflow: hidden;
		width: 100%;
	}
	.e8login-recordcode-btns {
		text-align: center;
	}
</style>
<script src="/js/weaver_wev8.js" type="text/javascript"></script>
<script src="/js/jquery/jquery_wev8.js" type="text/javascript"></script>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<LINK href="/wui/theme/ecology8/jquery/js/e8_zDialog_btn_wev8.css" type=text/css rel=STYLESHEET>
<div id="e8login_recordcode_edit" class="e8login-recordcode-edit ">
	<textarea class="ckeditor1" name="recordcode" id="recordcode" TABINDEX="2" style="width: 100%"></textarea>
</div>
<div class="e8login-recordcode-btns ">
	<input type="button" value="保存" id="zd_btn_submit" class="zd_btn_submit" onclick="dosubmit();">
	<span class="e8_sep_line">|</span>
	<input type="button" value="取消" id="zd_btn_cancle" class="zd_btn_cancle" onclick="onCancel();">
</div>
<!--引入ueditor相关文件-->
<script type="text/javascript" charset="UTF-8" src="/ueditor/ueditor.config_wev8.js"></script>
<script type="text/javascript" charset="UTF-8" src="/js/doc/ueditor.all.min_wev8.js"> </script>
<script type="text/javascript" charset="UTF-8" src="/ueditor/lang/zh-cn/zh-cn_wev8.js"></script>

<script type="text/javascript">
	$("#zd_btn_submit").mouseover(function(){
		$("#zd_btn_submit").addClass("zd_btn_submit_hover")
	})
	$("#zd_btn_submit").mouseleave(function(){
		$("#zd_btn_submit").removeClass("zd_btn_submit_hover")
	})
	$("#zd_btn_cancle").mouseover(function(){
		$("#zd_btn_cancle").addClass("zd_btn_cancleHover")
	})
	$("#zd_btn_cancle").mouseleave(function(){
		$("#zd_btn_cancle").removeClass("zd_btn_cancleHover")
	})
	var ue = UE.getEditor('recordcode',{
		toolbars:[[
			'bold', //加粗
			'indent', //首行缩进
			'italic', //斜体
			'underline', //下划线
			'strikethrough', //删除线
			'subscript', //下标
			'fontborder', //字符边框
			'superscript', //上标
			'formatmatch', //格式刷
			'blockquote', //引用
			'pasteplain', //纯文本粘贴模式
			'selectall', //全选
			'preview', //预览
			'horizontal', //分隔线
			'removeformat', //清除格式
			'time', //时间
			'date', //日期
			'cleardoc', //清空文档
			'link', //超链接
			'unlink', //取消链接
			'undo', //撤销
			'redo', //重做
			'fontfamily', //字体
			'fontsize', //字号
			'spechars', //特殊字符
			'help', //帮助
			'justifyleft', //居左对齐
			'justifyright', //居右对齐
			'justifycenter', //居中对齐
			'justifyjustify', //两端对齐
			'forecolor', //字体颜色
			'backcolor', //背景色
			'insertorderedlist', //有序列表
			'insertunorderedlist',//无序列表
			'directionalityltr', //从左向右输入
			'directionalityrtl', //从右向左输入
			'imagecenter', //居中
			'lineheight', //行间距
			'edittip ', //编辑提示
		]],
		initialFrameHeight: 300,
  		initialFrameWidth:'100%'
	});
	UE.getEditor('recordcode').addListener("ready", function () {
		var dialog = parent.getDialog(window);
		UE.getEditor('recordcode').setContent(dialog.initData.recordcode);
	});
	function dosubmit(){
		var dialog = parent.getDialog(window);	
		dialog.callback(ue.getContent());
		dialog.close();
	}				
	function onCancel(){
		var dialog = parent.getDialog(window);	
		dialog.close();
	}
</script>