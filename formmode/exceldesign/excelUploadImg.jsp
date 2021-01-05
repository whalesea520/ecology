
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<HTML><HEAD>
<!-- for swfupload -->
<script type="text/javascript" src="/js/page/swfupload/swfupload_wev8.js"></script>
<script type="text/javascript" src="/js/page/swfupload/swfupload.queue_wev8.js"></script>
<script type="text/javascript" src="/js/page/swfupload/fileprogress_wev8.js"></script>
<script type="text/javascript" src="/js/page/swfupload/handlers_wev8.js"></script>
<%if(user.getLanguage()==7) {%>
	<script type="text/javascript" src="/js/page/maint/common/lang-cn_wev8.js"></script>
<%} else if(user.getLanguage()==8) {%>
	<script type='text/javascript' src='/js/page/maint/common/lang-en_wev8.js'></script>
<%} else if(user.getLanguage()==9) {%>
	<script type='text/javascript' src='/js/page/maint/common/lang-tw_wev8.js'></script>
<%}%>
<link href="/js/page/swfupload/default_wev8.css" rel="stylesheet" type="text/css" />
	<script type="text/javascript">
		var swfu;

		function init() {
			var language = "<%=user.getLanguage()%>";
			var btnwidth = language==8?86:35;
			var settings = {
				flash_url : "/js/swfupload/swfupload.swf",
				upload_url: "/weaver/weaver.formmode.exceldesign.ExcelUploadServlet",
				post_params:{"method":"uploadFile"},
				use_query_string : true,//要传递参数用到的配置
				file_size_limit : "100 MB",
				file_types : "*.jpg;*.gif;*.png;*.swf;*.flv;*.mp3",
				file_types_description : "image file,flash file,flv file,mp3 file",
				file_upload_limit : 1,
				file_queue_limit : 0,
				custom_settings : {
					progressTarget : "fsUploadProgress",
					cancelButtonId : "btnCancel"
				},
				debug: false,

				// Button settings
			button_image_url : "/js/swfupload/upload_wev8.png",
            button_placeholder_id : "spanUpload",
            button_width: 142,
            button_height: 33,
          	button_text: '<span class="buttonText"><%=SystemEnv.getHtmlLabelName(20001,user.getLanguage())%></span>',
			button_text_style: '.buttonText {font-family:"微软雅黑","宋体"; color: #1094f6;font-size: 15px;}',
            button_text_top_padding: 3,
            button_text_left_padding: 50,
            button_window_mode: SWFUpload.WINDOW_MODE.TRANSPARENT,
            button_cursor: SWFUpload.CURSOR.HAND,
				
			//button_placeholder_id: "spanButtonPlaceHolder",
			// The event handler functions are defined in handlers.js
			file_queued_handler : fileQueued,
			file_queue_error_handler : fileQueueError,
			//file_dialog_start_handler : fileDialogStartselect,
			file_dialog_complete_handler : fileDialogComplete,
			upload_start_handler : uploadStart,
			upload_progress_handler : uploadProgress,
			upload_error_handler : uploadError,
			upload_success_handler : uploadSuccess,
			upload_complete_handler : uploadComplete,
			queue_complete_handler : queueComplete	// Queue plugin event
			};
			
			swfu = new SWFUpload(settings);
		}
		
		var dialog;
		var savefile;
		$(document).ready( function() {
		    init();
		    dialog = window.top.getDialog(window);
		    var zd_btn_confirmBtn = jQuery("#zd_btn_confirm");
		    zd_btn_confirmBtn.hide().next().hide();
		});
		
		function doChangeImgSrc(obj){
			$("div[name=imgupdiv_1],div[name=imgupdiv_2]").hide();
			$("div[name=imgupdiv_"+$(obj).val()+"]").show();
			var zd_btn_confirmBtn = jQuery("#zd_btn_confirm");
			if($(obj).val() === "1"){
				$("#imglabel").text("图片地址");
				zd_btn_confirmBtn.show().next().show();
			}else{
				$("#imglabel").text("选择图片");
				zd_btn_confirmBtn.hide().next().hide();
			}
		}
		
		function fileQueued(file) {
			var filename = file.name;
			var myDate = new Date();
			var curdate = myDate.getFullYear()+""+(myDate.getMonth()+1)+""+myDate.getDate()+""+myDate.getHours()+""+myDate.getMinutes()+""+myDate.getSeconds();
			savefile = "uploadImg_" + curdate + "." + filename.split(".")[1];
			
			swfu.setUploadURL("/weaver/weaver.formmode.exceldesign.ExcelUploadServlet?method=uploadFile&savefile="+savefile);
			if(!checkFileName(file.name,'')){
				swfu.cancelUpload(file.id);
				return false;
			}
		}
		
		/**
		 * 判断文件名是否合法
		 * @param {} name
		 * @return {Boolean}
		 */
		function checkFileName(name,type) {
		    if($.trim(name)==''){
		    	alert("请输入名称");
		    	return false;
		    }
		    
		    if(name.indexOf(' ')!=-1) {
		        alert("不能包含空格！");
		        return false;
		    }
	   		if (name.match(/[\x7f-\xff]/)) { 
		        alert("名称不能包含中文！");
		        return false;
		    }
		    
		    if(/.*[\u4e00-\u9fa5]+.*$/.test(name)){
		    	alert(urmsg.noChineseChar)
		    	return false;
		    }
		    return true;
		}
		
		/*选择文件之后自动上传*/
		function fileDialogComplete(){
			if (this.getStats().files_queued > 0) {
				this.startUpload();
			}
		}
		
		function uploadComplete(fileObj) {
			try {
				/*  I want the next upload to continue automatically so I'll call startUpload here */
				if (this.getStats().files_queued === 0) {
					$("#imgname").text(savefile);
					$("[name=imgsrc_2]").val("/filesystem/exceldesign/uploadimg/"+savefile);
					setPicDesc();
				}
			} catch (ex) { this.debug(ex); }
		
		}
		
		function setPicDesc(){	
			var rejson = {type:$("#srcdtype").val(),value:$("[name=imgsrc_"+$("#srcdeal").val()+"]").val()};
			if(!$("[name=imgsrc_"+$("#srcdeal").val()+"]").val()){
				window.top.Dialog.alert("未上传图片！");
				return;
			}else{
				dialog.close(rejson);
			}
		}
		
		function doClose(){
			dialog.closeByHand();
		}
	</script>
</HEAD>
 	<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
	<%
		RCMenu += "{"+SystemEnv.getHtmlLabelName(309,user.getLanguage())+",javascript:doClose(),_self} " ;
		RCMenuHeight += RCMenuHeightStep;
	%>
<BODY>
	<jsp:include page="/systeminfo/commonTabHead.jsp">
	   <jsp:param name="mouldID" value="workflow"/>
	   <jsp:param name="navName" value="插入图片"/>
	</jsp:include>     	
	
	<wea:layout type="twoCol">
	    <wea:group context="插入图片">
	    	<wea:item>类型</wea:item>
	    	<wea:item><select id="srcdtype" name="srcdtype">
	    		<option value="1">单元格</option>
	    		<option value="2">背景图</option>
	    		<option value="3">浮动</option>
	    	</select></wea:item>
	    	<wea:item>类型</wea:item>
	    	<wea:item><select id="srcdeal" name="srcdeal" onchange="doChangeImgSrc(this);">
	    		<option value="1">网络图片</option>
	    		<option value="2" selected>本地图片</option>
	    	</select></wea:item>
	    	<wea:item><span id="imglabel">选择图片</span></wea:item>
	    	<wea:item>
	    		<div name="imgupdiv_1" style="display:none;"><input type="text" name="imgsrc_1" value="http://" ></div>
	    		<div name="imgupdiv_2" style="margin-top:5px;">
	    			<div style="float:left;"><span id="spanUpload"></span></div>
	    			<div style="float:left;padding:5px;"><img src="/images/BacoError_wev8.gif" align="absMiddle"></div>
	    			<span id="imgname" style="position: relative;top: -10px;left: 20px;width: 250px;"></span>
	    			<input type="hidden" name="imgsrc_2" value="" >
    			<div>
	    	</wea:item>
	    </wea:group>
	</wea:layout>
	<div id="img_msg" style='padding-left:5px'></div>
	<div id="uploadDiv" style="display:">
		<form id="frmmain" action="/weaver/weaver.formmode.exceldesign.ExcelUploadServlet?method=uploadFile" method="post" enctype="multipart/form-data">
				
				<div class="fieldset flash" id="fsUploadProgress">
				</div>
				<div>
				<input  id="btnCancel" type="hidden" value="Cancel All Uploads" onclick="swfu.cancelQueue();" disabled="disabled" style="margin-left: 2px; font-size: 8pt; height: 29px;" />
				</div>
		</form>
	</div>
	<div id="divStatus" style="display:none"></div>
		<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>			 
		<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout needImportDefaultJsAndCss="false">
			<wea:group context=""  attributes="{groupDisplay:none}">
				<wea:item type="toolbar">
					<input type="button" value="确定" id="zd_btn_confirm"  class="zd_btn_cancle" onclick="setPicDesc()">
			    	<input type="button" value="关闭" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="doClose()">
				</wea:item>
			</wea:group>
		</wea:layout>      
	  </div>
  </body>
   <%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
</BODY>
</HTML>
