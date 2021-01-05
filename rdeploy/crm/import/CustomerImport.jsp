<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<HTML>
	<HEAD>
		<script type="text/javascript"
			src="/js/select/script/jquery-1.8.3.min_wev8.js"></script>
		<!-- swfupload -->
		<script type="text/javascript" src="/js/swfupload/swfupload_wev8.js"></script>
		<script type="text/javascript"
			src="/js/swfupload/swfupload.queue_wev8.js"></script>
		<script type="text/javascript"
			src="/rdeploy/crm/js/rdeploy_handlers_wev8.js"></script>
		<script type="text/javascript"
			src="/rdeploy/crm/js/rdeploy_doc_swfupload_wev8.js"></script>
		<script type="text/javascript"
			src="/rdeploy/crm/js/fileprogress_wev8.js"></script>
		<!--  -->
		<script type="text/javascript"
			src="/js/ecology8/jNice/jNice/jquery.jNice_wev8.js"></script>
		<link rel="stylesheet" href="/js/ecology8/jNice/jNice/jNice_wev8.css"
			type="text/css" />
		<style type='text/css'>
body {
    margin: 0px;
}
.content {
	text-align: center;
	font-family: "微软雅黑";
	font-size: 12px;
	color: #3c4350;
}
.errorDiv {
	height: 422px;
}

.errorNoCellDiv {
    padding-top: 25px;
}

.item1 {
    padding-top: 73px;
}

.item2 {
	padding-left: 10px;
    padding-top: 29px;
}

.item3 {
	padding-left: 95px;
}

.uploadItem {
	width: 415px;
	padding-top: 37px;
}

.uploadfilename {
	border-width: 1px;
	border-style: solid none solid solid;
	border-color: #e4e4e4;
}

.filenameDiv {
	height: 35px;
	line-height: 35px;
	overflow-y: hidden;
	outline: none;
	text-align: left;
	padding-left: 10px;
}

.uploadBtn {
	border-width: 1px;
	border-style: solid;
	border-color: #e4e4e4;
	float: left;
	height: 35px;
	margin-left: 377px;
	margin-top: -37px;
	background-color: #e4e4e4;
}

.uploadBtnImg {
	padding-top: 10px;
	padding-left: 10px;
	padding-right: 10px;
}

.swfUploadBtnDiv {
	width: 34px;
	height: 34px;
	position: absolute;
	top: 172px;
    right: 101px;
}

.item4 {
	padding-top: 36px;
}

.item5 {
	background-color: #f2f2f2;
    height: 40px;
    text-align: center;
    line-height: 40px;
    width: 608px;
    margin-top: 120px;
    position: absolute;
}

.importBtnDiv {
    font-family: "微软雅黑";
    font-size: 12px;
    cursor: pointer;
    width: 50px;
    height: 30px;
    line-height: 30px;
    margin-left: 280px;
    margin-top: 5px;
}

.importBtnDiv:hover {
	color: #4ba9df;
}

.radioSpan {
	padding-left: 5px;
}
.infoDiv {
	padding-top: 88px;
}
.errorInfoDiv {
	padding-top: 40px;
    color: red;
}
.errorTable {
	width: 100%;
    border: 1px solid #f0f5f6;
    font-size: 12px;
}
.errorNoCellTable {
	width: 89%;
    border: 1px solid #f0f5f6;
    font-size: 12px;
}
.errorTitle {
	height: 37px;
    text-align: center;
    border: 1px solid #f0f5f6;
}
.rowNum {
	background-color: #f0f5f6;
    text-align: center;
    height: 37px;
    border: 1px solid #f0f5f6;
}
.errorNoCellRowNum {
    text-align: center;
    height: 37px;
}

.bgc1 {
    text-align: center;
    height: 37px;
    border: 1px solid #e4e4e4;
}

.bgc2 {
    text-align: center;
    height: 37px;
    border: 1px solid #f2f2f2;
}

.bgc3 {
    text-align: center;
    height: 37px;
    border: 1px solid #f7f7f7;
}
.errorCol {
	height: 37px;
    padding-left: 19px;
    border: 1px solid #f0f5f6;
}
.errorInfo {
	color: #ff6262;
}
.noname {
	position: absolute;
    left: 120px;
    top: 35px;
    width: 130px;
    display: none;
}
.nostatus {
	position: absolute;
    left: 246px;
    top: 35px;
    display: none;
    width: 145px;
}
.nocu {
	position: absolute;
    left: 387px;
    top: 35px;
    width: 151px;
    display: none;
}
</style>
	</head>

	<BODY>
		<div id="uploadContent">
			<div class="content">
				<div class="item1">
					<span>1.&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;下载《<a
						href=CustomerImport.xls>客户导入模板</a>》</span>
				</div>
				<div class="item2">
					<span>2.&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;根据模板修改文件后上传</span>
				</div>
				<div class="item3">
					<div class="uploadItem">
						<div class="uploadfilename">
							<div id="filenameDiv" class="filenameDiv" tabindex="5000">
								选择文件
							</div>
						</div>
						<div class="uploadBtn">
							<img class="uploadBtnImg"
								src="/wui/theme/ecology8/skins/default/general/browser_wev8.png" />
						</div>
					</div>
					<div class="swfUploadBtnDiv">
						<span id="swfUploadBtn"></span>
					</div>
				</div>
				<div class="item4">
					<span>当【客户名称】相同时：</span>
					<span class="radioSpan"> <input type="radio" value="1"
							id="isCover" name="isCover" checked /> </span>
					<span>覆盖导入</span>
					<span class="radioSpan"> <input type="radio" value="0"
							id="isCover" name="isCover" /> </span>
					<span>不导入</span>
				</div>
	
			</div>
			<div class="item5">
				<div onclick="startUpload();" class="importBtnDiv">
					导入
				</div>
			</div>
		</div>
		
		<div id="resultContent" style="display:none;">
			<div id="errorDiv" class="content errorDiv">
				<table cellpadding="0px" cellspacing="0px" class="errorTable">
					<colgroup>
						<col width="45px" />
						<col width="223px" />
						<col width="316px" />
					</colgroup>
					<tr class="errorTitle">
						<td class="rowNum">行</td>
						<td class="errorCol">客户名称</td>
						<td class="errorCol">失败原因</td>
					</tr>
				</table>
			</div>
		</div>
		
		<div id="successDivContent" style="display:none;">
			<div id="successDiv" style="width: 100%;text-align: center;padding-top: 35px;">
				<img src="/rdeploy/crm/image/no_data_error.png" />
			</div>
			<divstyle="padding-top: 25px;height: 30px;line-height: 22px;">
				<div style="float: left; margin-left: 240px;">
					<img src="/rdeploy/crm/image/sucess.png" />
				</div>
				<span style="margin-left: 13px;padding-top: 11px;">全部数据已导入成功</span>
			</div>
		</div>
		
		<div id="noDataDivContent" style="display:none;">
			<div id="noDataDiv" style="width: 100%;text-align: center;padding-top: 35px;">
				<img src="/rdeploy/crm/image/no_data_error.png" />
				<div style="padding-top: 44px;font-size: 14px;">在这里，你可以导入客户数据</div>
			</div>
		</div>
		<div id="noCallErrorContent" style="display:none;">
			<div id="errorDiv" class="content errorNoCellDiv">
				<img src="/rdeploy/crm/image/no_cell_error.png" />
				<img class="noname" id="noname" src="/rdeploy/crm/image/red_border.png" />
				<img class="nostatus" id="nostatus" src="/rdeploy/crm/image/red_border.png" />
				<img class = "nocu" id="nocu" src="/rdeploy/crm/image/red_border.png" />
				<div style="padding-top: 53px;font-size: 14px;">没有找到列信息</div>
			</div>
		</div>
	</body>
	<script type="text/javascript">
		jQuery(document).ready(function(){
			jQuery('.item4').jNice();
		});
	
	     var currentFileID = "";
        var delannexids = "";
		var oUploadannexupload;
		
		function initFileupload(btnid) {
		
			var settings = {
				flash_url: "/js/swfupload/swfupload.swf",
				upload_url: "/rdeploy/doc/MultiDocUpload.jsp",
				
				file_size_limit: "0MB",
				file_types: "*.xls;*.xlsx",
				file_types_description: "*.xls;*.xlsx",
				file_upload_limit: 0,
				file_queue_limit: 0,
				custom_settings: {
					progressTarget: "filenameDiv"
				},
				debug: false,
				button_placeholder_id: btnid,
				button_width: 34,
				button_height: 34,
				button_text_top_padding: 0,
				button_text_left_padding: 0,
				button_action : SWFUpload.BUTTON_ACTION.SELECT_FILE,
				button_window_mode: SWFUpload.WINDOW_MODE.TRANSPARENT,
				button_cursor: SWFUpload.CURSOR.HAND,
				file_queued_handler: function(file) { 
					$("#filenameDiv").empty();
					$("#filenameDiv").append(file.name);
					this.customSettings.queue = this.customSettings.queue || new Array();
					while (this.customSettings.queue.length > 0) 
					{
						this.cancelUpload(this.customSettings.queue.pop(), false); 
					} 
					this.customSettings.queue.push(file.id); 
				}, 
				file_queue_error_handler: fileQueueError,
				file_dialog_complete_handler : fileDialogComplete,
				upload_start_handler: uploadStart,
				upload_progress_handler: uploadProgress,
				upload_error_handler: uploadError,
				upload_success_handler : function (file, serverData) {
				progressUplouder(file,serverData);
			}, 
				upload_complete_handler: uploadComplete_1,
				queue_complete_handler: queueComplete // Queue plugin event
			};
		
			try {
				oUploadannexupload = new SWFUpload(settings);
			} catch(e) {
				alert(e)
			}
		}
		
		
		function startUpload()
		{
			parentDialog.setLoadDiv();
			oUploadannexupload.startUpload();
		}
		// 显示成功列表信息，并创建文档
		function progressUplouder(file,serverData)
		{
			try {
				var jsonobj=eval('('+serverData+')');
				jQuery.ajax({
					type: "POST",
					url: "/rdeploy/crm/import/CustomerImportOperation.jsp",
					data: {
						fileid: jsonobj.imageid,
						isCover: $("#isCover").val()
						},
						cache: false,
						async:false,
						dataType: 'json',
						success: function(dataJson){
							parentDialog.setLoadDivHide();
							var isNoData = dataJson.isNoData;
							if(isNoData)
							{
									$("#uploadContent").hide();
									$("#noDataDivContent").show();	
							}
							else
							{
								var errorRowIds=eval('('+dataJson.errorIds+')');
							var errorList=eval('('+dataJson.errorList+')');
							var mustCallList=eval('('+dataJson.mustCallList+')');
							if(mustCallList.length > 0)
							{
								for(var rid in mustCallList)
								{
									var rowNum = mustCallList[rid];
									if(rowNum == '1')
									{
										$("#noname").show();
									}
									else if(rowNum == '2')
									{
										$("#nostatus").show();
									}
									else if(rowNum == '3')
									{
										$("#nocu").show();
									}
								}
								$("#uploadContent").hide();
								$("#noCallErrorContent").show();	
							}
							else
							{
							 	parentDialog.setTitle(dataJson.success,dataJson.total);
								if(errorList.length > 0)
								{
									for(var rid in errorRowIds)
								{
									$tr = $("<tr />");
									$td1 = $("<td />");
									$td1.addClass("rowNum");
									$td1.append(errorRowIds[rid]);
									
									$td2 = $("<td />");
									$td2.addClass("errorCol");
									$td2.append(errorList[rid].errorCustomerName);
									
									$td3 = $("<td />");
									$td3.addClass("errorCol errorInfo");
									$td3.append(errorList[rid].errorMes);
									
									$tr.append($td1).append($td2).append($td3);
									
									$(".errorTable").append($tr);
								}
								var intoDbErrorIndex = errorRowIds.length;
								for(intoDbErrorIndex; intoDbErrorIndex < errorList.length ; intoDbErrorIndex ++)
								{
									$tr = $("<tr />");
									$td1 = $("<td />");
									$td1.addClass("rowNum");
									$td1.append(errorList[intoDbErrorIndex].rowNum);
									
									$td2 = $("<td />");
									$td2.addClass("errorCol");
									$td2.append(errorList[intoDbErrorIndex].errorCustomerName);
									
									$td3 = $("<td />");
									$td3.addClass("errorCol errorInfo");
									$td3.append(errorList[intoDbErrorIndex].errorMes);
									
									$tr.append($td1).append($td2).append($td3);
									
									$(".errorTable").append($tr);
								}
								$("#uploadContent").hide();
								$("#resultContent").show();	
								}
								else 
								{
									$("#uploadContent").hide();
									$("#successDivContent").show();	
								}
							}
							}
						}
					});
			} catch (ex) {		
				oUploadannexupload.debug(ex);
			}
					
		}
		
		
		function firstButtonLoad() {
			initFileupload('swfUploadBtn');
		}
		
		if (window.addEventListener) {
			window.addEventListener("load", firstButtonLoad, false);
		} else if (window.attachEvent) {
			window.attachEvent("onload", firstButtonLoad);
		} else {
			window.onload = firstButtonLoad;
		}
		$(".swfUploadBtnDiv").hover(function() {
			$(".uploadBtnImg").attr("src","/wui/theme/ecology8/skins/default/general/browser_hover_wev8.png");
        },
        function() {
           $(".uploadBtnImg").attr("src","/wui/theme/ecology8/skins/default/general/browser_wev8.png");
        });
		
		// 上传列表滚动条美化
	 $('#errorDiv').perfectScrollbar();
	</script>