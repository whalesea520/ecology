
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="javax.servlet.*"%>
<%@ page import="javax.servlet.http.*"%>
<html>
<head>
	<style type="text/css">
		.swfuploadbtn {
			display: block;
			width: 50px;
			font-size: 12px; 
			color: #666666
		}
		.browsebtn { background: url(/images/add_wev8.png) no-repeat 0 4px; }
		.uploadbtn { 
			display: none;
			background: url(/images/accept_wev8.png) no-repeat 0 4px; 
		}
		.cancelbtn { 
			display: block;
			width: 16px;
			height: 16px;
			float: right;
			background: url(/images/cancel_wev8.png) no-repeat; 
		}
		#cancelqueuebtn {
			display: block;
			display: none;
			background: url(/images/cancel_wev8.png) no-repeat 0 4px;
			margin: 10px 0;
		}
		#SWFUploadFileListingFiles ul {
			margin: 0;
			padding: 0;
			list-style: none;
		}
		.SWFUploadFileItem {
			display: block;
			width: 230px;
			height: 70px;
			float: left;
			background: #eaefea;
			margin: 0 10px 10px 0;
			padding: 5px;

		}
		.fileUploading { background: #fee727; }
		.uploadCompleted { background: #d2fa7c; }
		.uploadCancelled { background: #f77c7c; }
		.uploadCompleted .cancelbtn, .uploadCancelled .cancelbtn {
			display: none;
		}
		span.progressBar {
			width: 200px;
			display: block;
			font-size: 10px;
			height: 4px;
			margin-top: 2px;
			margin-bottom: 10px;
			background-color: #CCC;
		}
	</style>
	<script type="text/javascript" src="/tools/SWFUpload/js/SWFUpload_wev8.js"></script>
	<script type="text/javascript" src="/tools/SWFUpload/js/example_callbacks_wev8.js"></script>
	<script type="text/javascript">
		var swfu;
	window.onload = function() {
	swfu = new SWFUpload({
		upload_script : "/tools/SWFUpload/upload.jsp",
		target : "SWFUploadTarget",
		flash_path : "/tools/SWFUpload/js/SWFUpload.swf",
		allowed_filesize : 30720,	// 30 MB
		allowed_filetypes : "*.*",
		allowed_filetypes_description : "All files...",
		browse_link_innerhtml : "<%=SystemEnv.getHtmlLabelName(20800,user.getLanguage())%>",
		upload_link_innerhtml : "",
		browse_link_class : "swfuploadbtn browsebtn",
		upload_link_class : "swfuploadbtn uploadbtn",
		flash_loaded_callback : 'swfu.flashLoaded',
		upload_file_queued_callback : "fileQueued",
		upload_file_start_callback : 'uploadFileStart',
		upload_progress_callback : 'uploadProgress',
		upload_file_complete_callback : 'uploadFileComplete',
		upload_file_cancel_callback : 'uploadFileCancelled',
		upload_queue_complete_callback : 'uploadQueueComplete',
		upload_error_callback : 'uploadError',
		upload_cancel_callback : 'uploadCancel',
		auto_upload : false
	});
};
</script>
</head>		
		<%
			session.setAttribute("filepath",filepath);
		%>
		<div id="SWFUploadTarget">
			<form action="upload.jsp?filepath=<%=filepath%>" method="post" enctype="multipart/form-data">
			</form>
		</div>
		<div name="queueinfo" id="queueinfo"></div>
		<div id="SWFUploadFileListingFiles"></div>
		<br class="clr" />
		<a class="swfuploadbtn" id="cancelqueuebtn" href="javascript:cancelQueue();"><%=SystemEnv.getHtmlLabelName(20799,user.getLanguage())%></a>
		<div name="divCode" style="display:none" id="divCode"></div>
<html>
<script>

function fileUpload(code){
	var aUpload;
	var i=0;
	var oAs=document.getElementById("SWFUploadTarget").getElementsByTagName("A");
	if (code!=="" || code!==null) document.getElementById("divCode").innerHTML=code;
	
	for(key in oAs) {
		if (key!=null)	{
			if(i==oAs.length) aUpload=oAs[key];
			//alert(i+oAs[key].outerHTML)
		}
		i++;
	}
	//var aUpload=document.getElementById("aUploadlink");
	//alert(aUpload.outerHTML)
	
	aUpload.onclick()

	//alert(aUpload.onclick());
}
</script>



