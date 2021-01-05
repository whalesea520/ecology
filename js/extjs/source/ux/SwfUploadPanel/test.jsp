<!--DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/loose.dtd"-->
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>上传测试</title>
<link rel="stylesheet" type="text/css" href="/js/extjs/resources/css/ext-all_wev8.css" />
<script type="text/javascript" src="/js/extjs/adapter/ext/ext-base_wev8.js"></script>
<script type="text/javascript" src="/js/extjs/ext-all_wev8.js"></script>
<!-- Files needed for SwfUploaderPanel -->

<link rel="stylesheet" type="text/css" href="/js/extjs/source/ux/SwfUploadPanel/SwfUploadPanel_wev8.css" />
<script type="text/javascript" src="/js/extjs/source/ux/SwfUploadPanel/SwfUpload_wev8.js"></script>
<script type="text/javascript" src="/js/extjs/source/ux/SwfUploadPanel/SwfUploadPanel_wev8.js"></script>
<script>	


		Ext.onReady(function() {		

			String.prototype.trim = function() {
				return this.replace(/^\s+|\s+$/g,"");
			}
		
			// Get SessionId from cookie
			var PHPSESSIDX = null;
			var cookies = document.cookie.split(";");
			Ext.each(cookies, function(cookie) {
				var nvp = cookie.split("=");
				if (nvp[0].trim() == 'PHPSESSID')
					PHPSESSIDX = nvp[1];
			});
			
			var uploader = new Ext.ux.SwfUploadPanel({
				title: '多文档上传'
				, renderTo: 'grid'
				, width: 600
				, height: 300

				// Uploader Params				
				, upload_url: '/docs/docupload/MultiDocUpload.jsp'
//				, upload_url: 'http://localhost/www.silverbiology.com/ext/plugins/SwfUploadPanel/upload_example.php'
				, post_params: { PHPSESSIDX: PHPSESSIDX }
	<%
		//if (isset($_REQUEST[debug])) print ", debug: true";
	%>		
				, flash_url: "/js/extjs/source/ux/SwfUploadPanel/swfupload_f9.swf"
//				, single_select: true // Select only one file from the FileDialog

				// Custom Params
				, single_file_select: false // Set to true if you only want to select one file from the FileDialog.
				, confirm_delete: false // This will prompt for removing files from queue.
				, remove_completed: false // Remove file from grid after uploaded.
			});

			uploader.on('swfUploadLoaded', function() { 
				this.addPostParam( 'Post1', 'example1' );
			});
			
			uploader.on('fileUploadComplete', function(panel, file, response) {
			});
			
			uploader.on('queueUploadComplete', function() {
				if ( Ext.isGecko ) {
					console.log("Files Finished");
				} else {
					alert("Files Finished");
				}
			});
						
			
			/*var btn = new Ext.Button({
					text: 'Launch Sample Uploader'
				, renderTo: 'btn'
				, handler: function() {

						var dlg = new Ext.ux.SwfUploadPanel({
								title: 'Dialog Sample'
							, width: 500
							, height: 300
							, border: false
			
							// Uploader Params				
							, upload_url: 'http://www.silverbiology.com/ext/plugins/SwfUploadPanel/upload_example.php'
//							, upload_url: 'http://localhost/www.silverbiology.com/ext/plugins/SwfUploadPanel/upload_example.php'
							, post_params: { id: 123}
							, file_types: '*.jpg'
							, file_types_description: 'Image Files'
							<%
								//if (isset($_REQUEST[debug])) print ", debug: true";
							%>	
			
							, flash_url: "/js/extjs/source/ux/SwfUploadPanel/swfupload_f9.swf"
			//				, single_select: true // Select only one file from the FileDialog
			
							// Custom Params
							, single_file_select: false // Set to true if you only want to select one file from the FileDialog.
							, confirm_delete: false // This will prompt for removing files from queue.
							, remove_completed: true // Remove file from grid after uploaded.
						}); // End Dialog

						var win = new Ext.Window({
								title: 'Window'
							, width: 514
							, height: 330
							, resizable: false
							, items: [ dlg ]
						}); // End Window
								
						win.show();
					
					} // End Btn Handler
								
				}); // end Btn*/
		});
	</script>
<style type="text/css">
<!--
.style1 {
	font-weight: bold
}
body, td, th {
	font-family: Arial, Helvetica, sans-serif;
}
body {
	margin-left: 5px;
	margin-top: 5px;
	margin-right: 5px;
	margin-bottom: 5px;
}
.style3 {font-size: 10px; font-style: italic;}
-->
</style>
</head>
<body>

<div id="grid"></div>
<br>
<!--<div id="btn"></div>-->
</body>
</html>
