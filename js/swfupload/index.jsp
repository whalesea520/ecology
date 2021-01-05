
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 

<link href="default_wev8.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="swfupload_wev8.js"></script>
<script type="text/javascript" src="swfupload.graceful_degradation_wev8.js"></script>
<script type="text/javascript" src="swfupload.queue_wev8.js"></script>
<script type="text/javascript" src="handlers_wev8.js"></script>

<%



%>




<script type="text/javascript">
		var upload1, upload2;

		window.onload = function() {
			upload1 = new SWFUpload({
				// Backend Settings
				upload_url: "upload.jsp",	// Relative to the SWF file (or you can use absolute paths)
				//post_params: {"PHPSESSID" : "<?php echo session_id(); ?>"},

				// File Upload Settings
				file_size_limit : "102400",	// 100MB
				file_types : "*.*",
				file_types_description : "All Files",
				file_upload_limit : "10",
				file_queue_limit : "0",

				// Event Handler Settings (all my handlers are in the Handler_wev8.js file)
				file_dialog_start_handler : fileDialogStart,
				file_queued_handler : fileQueued,
				file_queue_error_handler : fileQueueError,
				file_dialog_complete_handler : fileDialogComplete,
				upload_start_handler : uploadStart,
				upload_progress_handler : uploadProgress,
				upload_error_handler : uploadError,
				upload_success_handler : uploadSuccess,
				upload_complete_handler : uploadComplete,

				// Flash Settings
				flash_url : "swfupload_f8.swf",	// Relative to this file (or you can use absolute paths)
				
				swfupload_element_id : "flashUI1",		// Setting from graceful degradation plugin
				degraded_element_id : "degradedUI1",	// Setting from graceful degradation plugin

				custom_settings : {
					progressTarget : "fsUploadProgress1",
					cancelButtonId : "btnCancel1"
				},
				
				// Debug Settings
				debug: false
			});
		}
	</script>

	<%
		session.putValue("imagefileids","");
		//String imagefileids=(String) session.getValue("imagefileids");
		//out.println(imagefileids);
	%>




	<form id="form1"  method="post" enctype="multipart/form-data">		
		<div class="content">
			<table>
				<tr valign="top">
					<td>


						<div id="flashUI1" style="display: none;">
							<fieldset class="flash" id="fsUploadProgress1">
								<legend>File Upload List</legend>
							</fieldset>
							<div>
								<input type="button" value="Upload file (Max 100 MB)" onclick="upload1.selectFiles()" style="font-size: 8pt;" />
								<input id="btnCancel1" type="button" value="Cancel Uploads" onclick="cancelQueue(upload1);" disabled="disabled" style="font-size: 8pt;" /><br />
							</div>
						</div>


						<div id="degradedUI1">
							<fieldset>
								<legend>File Upload List</legend>
								<input type="file" name="anyfile1" /> (Any file, Max 100 MB)<br/>
							</fieldset>
							<div>
								<input type="submit" value="Submit Files" />
							</div>
						</div>

					</td>					
				</tr>
			</table>
		</div>
	</form>


	<button onclick="upload1.startUpload()">upload</button>