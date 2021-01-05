<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.general.Util"%>
<%@page import="weaver.conn.RecordSet"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%

/*用户验证*/
User user = HrmUserVarify.getUser (request , response) ;
if(user==null) {
    response.sendRedirect("/login/Login.jsp");
    return;
}

int eid = Util.getIntValue(Util.null2String(request.getParameter("eid")));
int id = Util.getIntValue(Util.null2String(request.getParameter("id")), -1);
%>

<html>
  <head>
	<script type="text/javascript" src="/js/select/script/jquery-1.8.3.min_wev8.js"></script>
	<script type="text/javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
	<script type="text/javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
	<LINK href="/wui/theme/ecology8/jquery/js/e8_zDialog_btn_wev8.css" type=text/css rel=STYLESHEET>
	<script type="text/javascript" src="/js/ecology8/lang/weaver_lang_<%=user.getLanguage()%>_wev8.js"></script>
	
	<!--引入ueditor相关文件-->
	<script type="text/javascript" charset="UTF-8" src="/ueditor/ueditor.config_wev8.js"></script>
	<script type="text/javascript" charset="UTF-8" src="/ueditor/ueditor.all.min_wev8.js"> </script>
	<script type="text/javascript" charset="UTF-8" src="/ueditor/lang/zh-cn/zh-cn_wev8.js"></script>
	<link type="text/css" href="/ueditor/ueditorext_wf_wev8.css" rel="stylesheet"></link>
	<link href="/rdeploy/assets/css/index.css" rel="stylesheet" type="text/css">
	<script type="text/javascript" charset="UTF-8" src="/js/workflow/ck2uk_wev8.js"></script>
	<link href="/js/swfupload/default_wev8.css" rel="stylesheet" type="text/css" />
	
		<!-- for swfupload -->
<script type="text/javascript" src="/js/page/swfupload/swfupload_wev8.js"></script>
<script type="text/javascript" src="/js/page/swfupload/swfupload.queue_wev8.js"></script>
<script type="text/javascript" src="/js/page/swfupload/fileprogress_wev8.js"></script>
<script type="text/javascript" src="/js/page/swfupload/handlers_wev8.js"></script>
	
	<style type="text/css">
		* {
			font-size:12px;
		}
		.edui-metro {
			margin:0px!important;
		}
		object {
			position:absolute;
			left:0px;
			top:0px;
			opacity:0;
			filter: Alpha(Opacity=0);
		}
	</style>
	
	<script type="text/javascript">
	<!--
		var dialog = parent.getDialog(window);
		var parentWin = parent.getParentWindow(window);
	  	function cancle() {
			dialog.close();
	  	}
		$(function () {
			initupload("noticeuploadbtn");
			var objparam = {
				autoFloatEnabled:false,//不保持工具栏位置
				toolbars: [[
		            'fullscreen', 'source', '|',
		            'bold', 'italic', 'underline', 'fontborder', 'strikethrough', '|', 
		            'fontfamily', 'fontsize', 'forecolor', 'backcolor','|', 
		            'insertorderedlist', 'insertunorderedlist',
		            'lineheight', 'indent','paragraph', '|',
		            'justifyleft', 'justifycenter', 'justifyright', '|',
		            'insertimage', 'inserttable', '|',
		            'link', 'unlink', 'anchor', '|', 
		            'map', 'insertframe', 'background', 'horizontal',  'spechars', '|',
		            'removeformat', 'formatmatch','pasteplain', '|',
		            'undo', 'redo' 
		        ]], theme : "metro", initialStyle : "p{font-family:Microsoft YaHei; font-size:12px;}"
			};
			
			var _ue = UEUtil.initEditor('noticeconent', objparam, "100%");
			_ue.addListener('contentChange', function(){
	        	//var conten = _ue.getContent();
	        	//conten = conten.replace(new RegExp(/<img src=/g), "<img width='100%' src=");
	        	//_ue.setContent(conten);
			});
			//var _ue = UE.getEditor('noticeconent', objparam);
			/*
			$("#addnoticeimg, #modifynoticeimg").on("click", function () {
				var $this = $(this);
				var tempFile = $("#noticeimgsrc").val();
				var dlg = new window.top.Dialog();
				dlg.Title = "选择图片";
				dlg.Model = true;
				//dlg.Width = 550;
				//dlg.Height = 550;
				dlg.Width = top.document.body.clientWidth-100;
 				dlg.Height = top.document.body.clientHeight-100;
				//dlg.URL = "/docs/DocBrowserMain.jsp?url=/page/maint/common/UserResourceBrowse.jsp?file="+tempFile;
				dlg.URL = "/page/maint/common/CustomResourceMaint.jsp?isDialog=1&file="+tempFile;
				dlg.callbackfun=function(obj,datas){
					//if (datas != null && datas != "false"){
					if (datas != null && datas.id != "false"){
						$this.parent().css("background-image", "url('" + datas.id + "')");
						$("#noticeimgsrc").val(datas.id);
						
						if ($("#noticeimgsrc").val() == "") {
							//$("#modifynoticeimg").hide();
							$("#addnoticeimg").show();
						} else {
							//$("#modifynoticeimg").show();
							$("#addnoticeimg").hide();
						}
					}
				}
				dlg.show();
			});
			*/
			$("#modifynoticeimg").parent().hover(function () {
				if ($("#noticeimgsrc").val() != "") {
					$("#modifynoticeimg").show();
				}
			}, function () {
				$("#modifynoticeimg").hide();
			});
		})
		
		function dosubmit() {
			var _ue = UE.getEditor('noticeconent');
			_ue.sync();
			var noticeimgsrc = $("#noticeimgsrc").val();
			var moticetitle = $("#noticetitle").val();
			var noticeconent =  _ue.getContent();//光图片也算有内容了
			//getContentTxt();//$("#noticeconent").html();
			if (noticeimgsrc == "") {
				window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(24502,user.getLanguage())%>！");
				return ;
			}
			if (moticetitle == "") {
				window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(83869,user.getLanguage())+SystemEnv.getHtmlLabelName(229,user.getLanguage())%>！", function () {
					$("#noticetitle")[0].focus();
				});
				return ;
			}
			
			if (noticeconent == "") {
				window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(83869,user.getLanguage())+SystemEnv.getHtmlLabelName(345,user.getLanguage())%>！", function () {
					_ue.focus();
				});
				return ;
			}
			
			$("#pform")[0].submit();
		}
		
		function initupload(uploadeleid) {
			var $this = $("#addnoticeimg");
		    var language = "<%=user.getLanguage()%>";
		    var btnwidth = language == 8 ? 86 : 35;
		    var settings = {
		        flash_url: "/js/swfupload/swfupload.swf",
		        //upload_url: "/weaver/weaver.page.maint.common.CustomResourceServlet",
		        upload_url: "/docs/docs/DocImgUploadOnlyForPic.jsp?docfiletype=1",
		        post_params: {
		            "method": "uploadFile",
		            "dir": "image"
		        },
		        use_query_string: true, //要传递参数用到的配置
		        file_size_limit: "100 MB",
		        file_types: "*.jpg;*.gif;*.png",
		        file_types_description: "image file,flash file",
		        file_upload_limit: 100,
		        file_queue_limit: 0,
		        custom_settings: {
		            progressTarget: "fsUploadProgress",
		            cancelButtonId: "btnCancel"
		        },
		        debug: false,
		        
		        // Button settings
		        /*button_image_url: "/page/element/imgSlide/resource/image/upload.png",*/
		        button_placeholder_id: uploadeleid,
		        button_width: 168,
		        button_height: 80,
		        button_text: '<span class="buttonText"></span>',
		        button_text_style: '.buttonText {background:#6abc50;font-family:"微软雅黑","宋体"; color: #1094f6;font-size: 12px;}',
		        button_action: SWFUpload.BUTTON_ACTION.SELECT_FILE,
		        button_text_top_padding: 3,
		        button_text_left_padding: 0,
		        button_window_mode: SWFUpload.WINDOW_MODE.TRANSPARENT,
		        button_cursor: SWFUpload.CURSOR.HAND,
		        //button_placeholder_id: "spanButtonPlaceHolder",
		        // The event handler functions are defined in handlers.js
		        file_queued_handler: fileQueued,
		        file_queue_error_handler: fileQueueError,
		        //file_dialog_start_handler : fileDialogStartselect,
		        file_dialog_complete_handler: function () {
		            this.startUpload();
		            //$this.children(".btntext").html("上传中...");
		        },
		        upload_start_handler: uploadStart,
		        upload_progress_handler: uploadProgress,
		        upload_error_handler: uploadError,
		        upload_success_handler: function (file, server_data) {
	                var img = "<img  src='/weaver/weaver.file.FileDownload?fileid=" + jQuery.trim(server_data) + "' alt=''/>";
	                var imgsrc = "/weaver/weaver.file.FileDownload?fileid=" + jQuery.trim(server_data);
					
					$this.parent().css("background-image", "url('" + imgsrc + "')");
					$this.parent().css("background-size", "100% 100%");
					$("#noticeimgsrc").val(imgsrc);
					
					if ($("#noticeimgsrc").val() == "") {
						//$("#modifynoticeimg").hide();
						$("#addnoticeimg").show();
					} else {
						//$("#modifynoticeimg").show();
						$("#addnoticeimg").hide();
					}
					
	            },
	            upload_complete_handler: function () {},
	            queue_complete_handler: queueComplete // Queue plugin event
		    };
		
		    var swfu = new SWFUpload(settings);
		    return swfu;
		}
	-->
	</script>
  </head>

<%
String noticetitle = "";
String noticeconent = "";
String noticeimgsrc = "";
if (id > 0) {
	RecordSet rs = new RecordSet();
	rs.executeSql("select * from hpElement_notice where id=" + id);
    if (rs.next()) {
        noticeimgsrc = Util.null2String(rs.getString("imgsrc"));
	    noticetitle = Util.null2String(rs.getString("title"));
	    noticeconent = Util.null2String(rs.getString("content"));
	    noticetitle= noticetitle.replaceAll("\"", "&quot;");
    }
}
%>

  <body style="margin:0px;padding:0ppx;">
  	<div class="zDialog_div_content" style="position:absolute;bottom:48px;top:0px;width: 100%;">
	  	<div id="contnt" style="margin:0px 20px;">
		  	<form method="post" action="/page/element/newNotice/detailsettingOperation.jsp" target="formiframe" id="pform">
		  		<input type="hidden" name="id" value="<%=id %>">
		  		<input type="hidden" name="eid" value="<%=eid %>">
		  		<div style="height:20px!important;">
			  	</div>
		  		<input type="hidden" name="noticeimgsrc" id="noticeimgsrc" value="<%=noticeimgsrc %>">
		  		<div style="height:80px;border:1px dotted #cdcdcd;width:168px;position:relative;left:50%;margin-left:-84px;background:url('<%=noticeimgsrc %>') center center no-repeat;background-size:100% 100%">
		  				
					<div id="addnoticeimg" style="position:relative;width:100%;height:100%;cursor:pointer;<%=!"".equals(noticeimgsrc) ? "display:none;":"" %>" " title="<%=SystemEnv.getHtmlLabelName(124841,user.getLanguage())%>">
						<img src="/page/element/imgSlide/resource/image/new.png" height="24px" width="24px" style="position:absolute;left:50%;top:50%;margin-top:-12px;margin-left:-12px;cursor:pointer;">		
					</div>
					<div id="modifynoticeimg" style="display:none;width:100%;height:100%;filter: Alpha(Opacity=50);opacity: 0.5;background-color:#000;color:#fff;line-height:80px;text-align:center;cursor:pointer;">
						<%=SystemEnv.getHtmlLabelName(84563,user.getLanguage())+SystemEnv.getHtmlLabelName(74,user.getLanguage())%>
					</div>
					<span id="noticeuploadbtn">
					</span>
			  	</div>
			  	
			  	<div style="height:10px!important;"></div>
			  	<div style="color:#848484;text-align:center;">
			  		（<%=SystemEnv.getHtmlLabelName(16159,user.getLanguage())+SystemEnv.getHtmlLabelName(22352,user.getLanguage())%>:900<%=SystemEnv.getHtmlLabelName(218,user.getLanguage())%>*500<%=SystemEnv.getHtmlLabelName(218,user.getLanguage())%>）
			  	</div>
			  	
			  	<div style="height:20px!important;"></div>
			  	
			  	<div><%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%></div>
			  	
			  	<div style="height:10px!important;"></div>
			  	<div>
			  		<input type="text" value="<%=noticetitle %>" name="noticetitle" id="noticetitle" style="padding-left:10px;height:40px;width:100%;border:1px solid #b2b2b2;">
			  	</div>
			  	<div style="height:20px!important;"></div>
			  	<div><%=SystemEnv.getHtmlLabelName(345,user.getLanguage())%></div>
			  	
			  	<div style="height:10px!important;"></div>
			  	<div style="border:1px solid #d2d2d2;">
			  		<textarea name="noticeconent" id="noticeconent" style="width:100%;height:240px;"><%=noticeconent %></textarea>
			  	</div>
		  	</form>
	  	</div>
	</div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout needImportDefaultJsAndCss="false">
			<wea:group context="" attributes="{'groupDisplay':'none'}">
				<wea:item type="toolbar">
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" id="" class="zd_btn_cancle" onclick="dosubmit();"/>
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>" id="" class="zd_btn_cancle" onclick="cancle();"/>
				</wea:item>
			</wea:group>
		</wea:layout>
	</div>
	
	<div style="display:none;">
	  	<iframe name="formiframe" src="">
	</div>
  </body>
</html>
