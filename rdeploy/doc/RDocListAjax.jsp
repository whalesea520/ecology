<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ page import="weaver.general.Util"%>
<%@ page import="weaver.systeminfo.SystemEnv"%>
<%@ page import="weaver.hrm.HrmUserVarify"%>
<%@ page import="weaver.hrm.User"%>
<%@ page import="weaver.docs.category.security.*"%>
<%@ include file="/systeminfo/init_wev8.jsp"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<!DOCTYPE HTML>
<html>
	<head>
		<link href="/js/swfupload/default_wev8.css" rel="stylesheet"
			type="text/css" />
		<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css"
			rel="stylesheet">
		<link rel="stylesheet" href="/css/init_wev8.css" type="text/css">

		<link href="/css/Weaver_wev8.css" type=text/css rel="stylesheet"
			type="text/css" />
		<!-- swfupload -->
		<script type="text/javascript" src="/js/swfupload/swfupload_wev8.js"></script>
		<script type="text/javascript"
			src="/js/swfupload/swfupload.queue_wev8.js"></script>

		<script type="text/javascript"
			src="/rdeploy/assets/js/doc/rdeploy_handlers_wev8.js"></script>

		<script type="text/javascript"
			src="/rdeploy/assets/js/doc/rdeploy_doc_swfupload_wev8.js"></script>
		<script type="text/javascript"
			src="/rdeploy/assets/js/doc/fileprogress_wev8.js"></script>



		<style type="text/css">
.progressWrapper {
	
}

.rprogressContainer {
	background: #fff none repeat scroll 0 0;
	height: 50px;
	overflow: hidden;
}

.rgreen {
	
}

.fileIconDiv {
	float: left;
	padding-top: 15px;
	padding-left: 19px;
}

.rprogressName {
	float: left;
	padding-top: 15px;
	padding-left: 8px;
	white-space: nowrap;
	overflow: hidden;
	text-overflow: ellipsis;
	width: 220px;
	text-align: left;
}

.fileSize {
	float: left;
	color: #aaaaaa;
	padding-top: 15px;
	padding-left: 33px;
	text-align: left;
	width: 20px;
}

.rprogressBarStatus {
	float: left;
	padding-top: 15px;
	padding-left: 149px;
	color: #3fca6a;
}

.cancelDiv {
	float: left;
	padding-top: 16px;
	padding-left: 10px;
}

/*进度条*/
.rprogressBarInProgress {
	height: 2px;
	background: #5ec475;
	z-index: 9999;
	width: 0px;
}

.rprogressBarInProgressLine {
	height: 1px;
	background: #e4e4e4;
	margin-top: 10px;
	width: 94%;
	margin-left: 20px;
}

.clearBoth {
	clear: both;
}

.rprogressError {
	float: left;
	padding-top: 15px;
	padding-left: 0px;
	width: 77px;
	text-align: left;
	display: none;
}

.progressBarInProgressWrapper {
	height: 30px;
	border: 1px solid #e4f1fa;
	background: #fff;
	position: relative !important;
}

.progressBarInProgressScale {
	position: absolute;
	left: 5px;
	top: 5px;
	color: #83a85b;
	font-size: 12px;
	font-family: 微软雅黑;
}

.rprogressCancel {
	width: 15px;
	height: 15px;
	background: url('/rdeploy/assets/img/doc/cancel.png') 0 0 no-repeat
		!important;
	display: inline-block;
}

.rprogressSucess {
	width: 15px;
	height: 15px;
	background: url('/rdeploy/assets/img/doc/upload_sucess.png') 0 0
		no-repeat !important;
	display: inline-block;
}

.btstyle01 {
	display: block;
	width: 100px;
	height: 32px;
	font-size: 14px;
	text-align: center;
	line-height: 32px;
	cursor: pointer;
	background: #43b2ff;
	color: #FFFFFF;
	font-family: 微软雅黑;
}

.btstyle02 {
	display: block;
	width: 100px;
	height: 32px;
	font-size: 14px;
	text-align: center;
	line-height: 32px;
	cursor: pointer;
	background: #18a0ff;
	color: #FFFFFF;
	font-family: 微软雅黑;
}

a {
	text-decoration: none;
}

a:link {
	text-decoration: none;
}

a:visited {
	text-decoration: none;
}

a:hover {
	text-decoration: none;
}

.againAddBtn {
	float: left;
	margin-left: 14px;
	color: #739aea;
}


.boxhead {
	height: 60px;
	overflow: hidden;
	z-index: 3;
	border-bottom: 1px solid #DADADA;
}

#Container {
	width: 586px;
	margin: 0 auto; /*设置整个容器在浏览器中水平居中*/
}

#Header {
	height: 180px;
	background: #0FF;
}

#logo {
	padding-bottom: 50px;
	margin-top: 55px;
}

.Content {
	height: 351px;
	margin: 0 auto;
	margin-top: 15px;
	background: #F8FBFB;
	border-top: 1px solid #DADADA;
	border-left: 1px solid #DADADA;
	border-right: 1px solid #DADADA;
	border-bottom: 1px solid #DADADA;
}

#uploadbtn {
	width: 235px;
	height: 55px;
	-moz-border-radius: 15px;
	-webkit-border-radius: 15px;
	border-radius: 15px;
	background: #739beb;
}


.topoperator {
  float: right;
  margin: 6px;
  background: #6abc50;
  color: #fff;
  cursor: pointer;
  height: 36px;
  width: 120px;
  font-size: 14px;
  text-align: center;
  margin-right: 38px;
}

.topoperator:hover {
  float: right;
  margin: 6px;
  background: #6ad04a!important;
  color: #fff;
  cursor: pointer;
  height: 36px;
  width: 120px;
  font-size: 14px;
  text-align: center;
  margin-right: 38px;
}

.e8_tablogo {
	background-image: url("/js/tabs/images/nav/default_wev8.png");
	background-repeat: no-repeat;
	background-position: 50% 50%;
	width: 43px;
	height: 60px;
	line-height: 60px;
	margin-left: 12px;
	float: left;
}

.e8_navtab {
	height: 20px;
	line-height: 38px;
	margin-left: 25px;
	padding-top: 10px;
	font-size: 16px;
	font-weight: normal;
}

.e8_os {
	float: left;
	width: 586px;
}

.e8_innerShow {
	overflow: hidden;
	min-height: 22px;
	word-wrap: break-word;
	word-break: break-all;
	white-space: normal;
	cursor: text;
	float: left;
}

.e8_showNameClass {
	background: none repeat scroll 0 0 #fff;
	cursor: pointer;
	vertical-align: middle;
	display: inline;
	float: none !important;
	margin: 8px;
	display: inline-block;
}

.e8_innerShow_button {
	position: relative;
	float: right;
	margin-left: 5px;
	z-index: 2;
}

.e8_innerShow_button_right30 { /* right: -30px; */
	
}

.ac_input {
	
}

.sinput {
	border-style: solid;
	border-width: 0;
	border-image: none;
	padding: 0px 5px;
	outline: none;
	height: 34px !important;
}

.subbtn {
	background-image: url("/rdeploy/assets/img/doc/file.png");
	background-repeat: no-repeat;
	background-position: 50% 50%;
	background-color: #f1f6f5;
	cursor: pointer;
	height: 38px;
	width: 40px;
	-moz-appearance: none;
}

.subbtn:hover {
	background-image: url("/rdeploy/assets/img/doc/file_hot.png");
	background-repeat: no-repeat;
	background-position: 50% 50%;
	background-color: #f1f6f5;
	cursor: pointer;
	height: 38px;
	width: 40px;
	-moz-appearance: none;
}

.e8_innerShow_button {
	float: right;
	margin-left: 5px;
	position: relative;
	z-index: 2;
}

.e8_innerShow {
	cursor: text;
	float: left;
	min-height: 22px;
	overflow: hidden;
	white-space: normal;
	word-break: break-all;
	word-wrap: break-word;
}

.e8_outScroll {
	border: 1px solid #d7e2e4;
	border-right-style: none;
	float: left;
	overflow: hidden;
	position: relative;
}

.e8_innerShowContent {
	background-color: #fff;
	float: right;
	border-color: #d7e2e4;
	position: relative;
	text-align: left;
	width: 100% !important;
}

.uploadBtnDiv {
	background-color: #739beb;
	color: #ffffff;
	font-size: 16px;
	height: 35px;
	padding: 10px;
	text-align: center;
	width: 212px;
	border-radius: 5px;
}

.uploadBtnDiv:hover {
	background-color: #5d88e1;
	color: #ffffff;
	font-size: 16px;
	height: 35px;
	padding: 10px;
	text-align: center;
	width: 212px;
	border-radius: 5px;
}

.icons {
	background-image: url("/rdeploy/assets/img/doc/docs.png");
	background-position: 50% 50%;
	background-repeat: no-repeat;
	height: 124px;
	line-height: 60px;
	width: 235px;
}

.footDiv {
	height: 44px;
	width: 580px;
	background-color: #f8fbfb;
	border: 1px solid #f7f7f7;
	border-bottom-style: none;
	border-left-style: none;
	border-right-style: none;
	position: absolute;
	top: 304px;
}
</style>

	</head>
	<%
	    String seccategory = "";
	    String seccategoryName = "";
	    String maxUploadFileSize = "";
	    String sql = "select id,categoryname,maxUploadFileSize from DocSecCategory where id = (select seccategory from CHECKIN_USER_SECCATEGORY where userid = " + user.getUID() + ")";

	    rs.executeSql(sql);
	    if (rs.next()) {
	        seccategory = rs.getString("id");
	        seccategoryName = rs.getString("categoryname");
	        maxUploadFileSize = rs.getString("maxUploadFileSize");
	    } else {
	       String defSql = "select id,categoryname,maxUploadFileSize from DocSecCategory where parentid = 0 and categoryname = '"+SystemEnv.getHtmlLabelName(75, user.getLanguage())+SystemEnv.getHtmlLabelName(156, user.getLanguage())+"'";
	        rs.executeSql(defSql);
	        if (rs.next()) {
	            seccategory = rs.getString("id");
	            seccategoryName = rs.getString("categoryname");
	            maxUploadFileSize = rs.getString("maxUploadFileSize");
	        }
	    }
	%>
	<script type="text/javascript">
	        var currentFileID = "";
        var delannexids = "";
        var numFilesQ = 0;
        var numFilesS = 0;
        var numUploadFiles = 0;
		var oUploadannexupload;
		var cancelNum = 0;
		var failNum = 0;
		
		function initFileupload(btnid,fileSizelimit) {
		
			var settings = {
				flash_url: "/js/swfupload/swfupload.swf",
				upload_url: "/rdeploy/doc/MultiDocUpload.jsp",
				
				file_size_limit: fileSizelimit+"MB",
				file_types: "*.*",
				file_types_description: "All Files",
				file_upload_limit: 100,
				file_queue_limit: 0,
				custom_settings: {
					progressTarget: "fsUploadProgressannexupload",
					cancelButtonId: "btnCancelannexupload",
					uploadfiedid: "field-annexupload"
				},
				debug: false,
				button_placeholder_id: btnid,
				button_width: 230,
				button_height: 50,
				button_text_top_padding: 0,
				button_text_left_padding: 0,
		
				button_window_mode: SWFUpload.WINDOW_MODE.TRANSPARENT,
				button_cursor: SWFUpload.CURSOR.HAND,
				file_queued_handler: fileQueued,
				file_queue_error_handler: fileQueueError,
				file_dialog_complete_handler : function(numFilesSelected, numFilesQueued){
				initBtnAndShowProgressList(numFilesSelected, numFilesQueued);
			},
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
		// 初始化按钮并显示队列列表
		function initBtnAndShowProgressList(numFilesSelected, numFilesQueued)
		{
				numFilesQ += numFilesQueued;
				numFilesS += numFilesSelected;
				
					if (numFilesSelected > 0) {
				    	var div_top2 = $("#div_top2").css("display");
				    	if(div_top2 == "none"){
					    	$("#adduploadoutblock").hide();
					    	$("#div_top2").show();
							$("#icons").hide();
							$("#uploadProgresScrollbar").show();
							$("#Content").css("background","#ffffff");
						}
						$("#firstBtn").css("top","318px");
						$("#firstBtn").css("left","60px");
						
						
						
						$("#Content").show();
						$("#sucessContent").hide();
						$("#failListScoll").hide();
						$("#failListScoll1").hide();
						$("#failList").empty();
						oUploadannexupload.startUpload();
					}
					
					
				if(numFilesS == failNum && numFilesS > 0)
				{
					 showSucceed();
				}
					
					
		}
		
		
		
		// 显示成功列表信息，并创建文档
		function progressUplouder(file,serverData)
		{
				
			try {
					 var jsonobj=eval('('+serverData+')');
					var fileEx = file.type.replace('.','');
					$.each(jsonobj,function(n,value){
						if(fileEx == n)
						{
							fileEx = value;
						}
					});
					
					var progress = new FileProgress(file, oUploadannexupload.customSettings.progressTarget);
						
						if($("#"+file.id+"hiddens").length <= 0)
						{
							 progress.setStatus("<%=SystemEnv.getHtmlLabelName(25388,user.getLanguage())%>");
						 	 $("#"+file.id+"CancelA").removeClass("rprogressCancel");
						 	 $("#"+file.id+"CancelA").addClass("rprogressSucess");
						 	 $("#"+file.id+"progressBar").hide();
						 	 progress.toggleCancel(true);
								jQuery.ajax({
									 type: "POST",
									 url: "/rdeploy/doc/MultiDocMaintOpration.jsp",
									 data: {
									 imgFileId:jsonobj.imageid,
									 seccategory:$("#seccategory").val(),
									 ownerid:<%=user.getUID() %>,
									 doclangurage:<%=user.getLanguage() %>,
									 docdepartmentid:<%= user.getUserDepartment() %>
									 },
									cache: false,
							 			async:false,
							 		dataType: 'json',
									 success: function(msg){
									 		var hiddens = $("<input type='hidden' />");
		          							hiddens.attr('value',msg.docId);
								          	hiddens.attr('id',file.id+"upSuc");
								          	
								          	$("#uploadProgresScrollbar").append(hiddens);
									 }
						 		});
						}
						 
					} catch (ex) {		
						oUploadannexupload.debug(ex);
					}
					numUploadFiles++;
						if((numUploadFiles+failNum) == numFilesS && numFilesS > 0)
						{
							showSucceed();
						}
					
		}
		
		// 显示成功信息
		function showSucceed()
		{
			$("#fsUploadProgressannexupload > div").each(function(){
			
				var errorMes = $('#'+$(this).attr('id')+'progressError').text();
	          	// 上传失败的项
	          	if (errorMes.replace(/(^\s*)|(\s*$)/g,"").length > 0)
	          	{
	          		var progressText = $("#"+$(this).attr('id')+"progressText").text();
	          		$("#failList").append(progressText).append("  ");
	          	}
			});
			
			if(failNum > 0)
	        {
	          	if(numFilesS == failNum)
	          	{
	          	 $("#topDiv").css("background-color","");
	          		$("#topDiv").css("height","");
	          		$("#topDiv").css("width","");
	          		$("#topDiv").css("position","");
	          		$("#topDiv").css("top","");
	          		$("#topDiv").css("left","");
	        
	        	$("#mTopImg").css("float","none");
		          	$("#mTopImg").css("margin-left","");
	          	
	          		$("#mTopFont").css("float","none");
		          	$("#mTopFont").css("margin-left","");
	          	
		          	$("#mTopImg").css("margin-top","-50px");
		        
			        $("#mTopFont").css("margin-top","32px");
		        	
		        	
					 $("#suceedImg").attr("src","/rdeploy/assets/img/doc/fail_all.png");
					
					if ((navigator.userAgent.indexOf('MSIE') >= 0) 
				    && (navigator.userAgent.indexOf('Opera') < 0)){
				   		$("#firstBtn").css("top","-98px");
					}else{
					    $("#firstBtn").css("top","-121px");
					}
					
					$("#firstBtn").css("left","185px");
					
					$("#againAddDiv").css("margin-top","43px");
					$("#againAddDiv").css("margin-left","183px");
					$("#againAddDiv").css("position","");
		          	$("#againAddDiv").css("top","");
		          	$("#againAddDiv").css("left","");
					$("#suMes").text("");
					var failAllFont = $("<font />")
					failAllFont.css("font-size","14px");
					failAllFont.css("color","#e98585");
					failAllFont.text("<%=SystemEnv.getHtmlLabelName(30898,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(25389,user.getLanguage())%>");
					$("#suMes").append(failAllFont);
			
					$("#mTop").show();
		          	
	          	}
	          	else{
	          		$("#topDiv").css("background-color","#ddf7e7");
	          		$("#topDiv").css("height","50px");
	          		$("#topDiv").css("width","562px");
	          		$("#topDiv").css("position","absolute");
	          		$("#topDiv").css("top","-128px");
	          		$("#topDiv").css("left","11px");
	          		
	          		$("#mTopImg").css("float","left");
		          	$("#mTopImg").css("margin-top","8px");
		          	$("#mTopImg").css("margin-left","137px");
	          	
	          		$("#mTopFont").css("float","left");
		          	$("#mTopFont").css("margin-top","13px");
		          	$("#mTopFont").css("margin-left","8px");
		          	
		          	var sname = $("#seccategoryName").val();
					$("#suMes").text("<%=SystemEnv.getHtmlLabelName(127883,user.getLanguage())%> ");
					
					
					var numfont = $("<font />")
					numfont.css("font-size","18px");
					numfont.text(numUploadFiles);
					
					var secnamestart = $("<font />")
					secnamestart.text(" <%=SystemEnv.getHtmlLabelName(127884,user.getLanguage())%> ");
					
					
					var secname = $("<font />")
					secname.css("color","#4d4d4d");
					secname.text(sname);
					
					
					var secnameend = $("<font />")
					secnameend.text(" <%=SystemEnv.getHtmlLabelName(33092,user.getLanguage())%>");
					
					$("#suMes").append(numfont).append(secnamestart).append(secname).append(secnameend);
		          	$("#mTop").show();
		          	if($("#failList").text().length > 200)
		          	{
		          		$("#failListScoll").css("height","120px");
		          	}
		          	else {
		          		$("#failListScoll").css("height","75px");
		          	}
		          	
		          	
		          	$("#failListScoll").show();
		          	$("#failListScoll1").show();
					$("#againAddDiv").css("margin-top","0px");
					$("#againAddDiv").css("margin-left","0px");
		          	$("#againAddDiv").css("position","absolute");
		          	$("#againAddDiv").css("top","137px");
		          	$("#againAddDiv").css("left","183px");
		          	$("#againAddDiv").css("background-color","rgb(115, 155, 235)");
		           $("#suceedImg").attr("src","/rdeploy/assets/img/doc/small_upload.png");
		          	
		          	$("#firstBtn").css("top","-75px");
		          	$("#firstBtn").css("left","185px");
		          	
		          	
		          	
		          	$("#failMsg").text(failNum+"<%=SystemEnv.getHtmlLabelName(127885,user.getLanguage())%>");
	          	}
	        }
	        else
	        {
	        
	       			 $("#topDiv").css("background-color","");
	          		$("#topDiv").css("height","");
	          		$("#topDiv").css("width","");
	          		$("#topDiv").css("position","");
	          		$("#topDiv").css("top","");
	          		$("#topDiv").css("left","");
	        
	        	$("#mTopImg").css("float","none");
		          	$("#mTopImg").css("margin-left","");
	          	
	          		$("#mTopFont").css("float","none");
		          	$("#mTopFont").css("margin-left","");
	        	
		        $("#mTopImg").css("margin-top","-50px");
		        
		        $("#mTopFont").css("margin-top","32px");
	        	
	        	
				 $("#suceedImg").attr("src","/rdeploy/assets/img/doc/sucess.png");
				
				
				if ((navigator.userAgent.indexOf('MSIE') >= 0) 
				    && (navigator.userAgent.indexOf('Opera') < 0)){
				   $("#firstBtn").css("top","-85px");
				}else{
				    $("#firstBtn").css("top","-109px");
				}
				
				
				$("#firstBtn").css("left","185px");
				
				$("#againAddDiv").css("margin-top","43px");
				$("#againAddDiv").css("margin-left","183px");
				
				$("#againAddDiv").css("position","");
		          	$("#againAddDiv").css("top","");
		          	$("#againAddDiv").css("left","");
				
						var sname = $("#seccategoryName").val();
					$("#suMes").text("<%=SystemEnv.getHtmlLabelName(127883,user.getLanguage())%> ");
					var numfont = $("<font />")
					numfont.css("font-size","18px");
					numfont.text(numUploadFiles);
					
					var secnamestart = $("<font />")
					secnamestart.text(" <%=SystemEnv.getHtmlLabelName(127884,user.getLanguage())%> ");
					
					
					var secname = $("<font />")
					secname.css("color","#4d4d4d");
					secname.text(sname);
					
					
					var secnameend = $("<font />")
					secnameend.text(" <%=SystemEnv.getHtmlLabelName(33092,user.getLanguage())%>");
					
					$("#suMes").append(numfont).append(secnamestart).append(secname).append(secnameend);
				
				$("#mTop").show();
				
				
	        }
		
		
			
			$('#uploadProgresScrollbar').getNiceScroll().remove();
			$("#sucessContent").show();
			$("#Content").hide();
			$("#div_top2").hide();
			$("#fsUploadProgressannexupload").empty();
			numUploadFiles = 0;
			numFilesQ = 0;
			numFilesS = 0;
			failNum = 0;
			
		}
		
		
		function firstButtonLoad() {
			initFileupload('firstButton',"<%=maxUploadFileSize%>");
		}
		
		if (window.addEventListener) {
			window.addEventListener("load", firstButtonLoad, false);
		} else if (window.attachEvent) {
			window.attachEvent("onload", firstButtonLoad);
		} else {
			window.onload = firstButtonLoad;
		}
		
		
		function __uploadSuccess_1__(file, imageid) {
			$("#" + file.id).find(".progressCancel").click(function(){
				delAnnex(this,imageid);
			});
		}
		
		function closecancle(){
			var dialog = parent.getDialog(window);
			var parentWin = parent.getParentWindow(window);
			clicktype = 1;
			
			var ispendingover = 0;
			var havedelete = 0;
			jQuery("div.progressBarInProgressScale").each(function (){
				var this_value = $(this).html();
				if(this_value == "Pending..."){
					ispendingover += 1;
				}
				if(this_value == "<%=SystemEnv.getHtmlLabelName(81562, user.getLanguage())%>"){
					havedelete = 1;
				}
			});
			
			
			if (ispendingover != 0) {
				top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(84535, user.getLanguage())%>"+ispendingover+"<%=SystemEnv.getHtmlLabelName(84536, user.getLanguage())%>");
				return;
			}else if(havedelete != 0){
				parentWin.document.getElementById("field_annexupload_del_id").value = $("#field-annexupload_del_id").val();
				uploadSuccess_callbackfun(null, null, 0);
			}else {
				uploadSuccess_callbackfun(null, null, 0);
			}
		}
		var plen = 0;
		var rtvids = "";
		var rtvnames = "";
		var rtvsizes = "";
		function uploadSuccess_callbackfun(file, server_data, count) {
			if (!!file) {
				if (rtvids == "") {
					rtvids = server_data;
					rtvnames = file.name;
					rtvsizes = file.size;
				} else {
					
				}
			}
			
			var dialog = parent.getDialog(window);
			var parentWin = parent.getParentWindow(window);
			
			var annexids = $("#field-annexupload").val();
			annexids = annexids.replaceAll(new RegExp(/[,]{2,}/g), ",");
			if (annexids.indexOf(",") == 0) {
				annexids = annexids.substr(1);
			}
			if (annexids.lastIndexOf(",") == annexids.length - 1) {
				annexids = annexids.substring(0, annexids.length - 1);
			}
			parentWin.document.getElementById("field-annexupload").value = annexids;
			parentWin.document.getElementById("field_annexupload_del_id").value = $("#field-annexupload_del_id").val();
            
            if(plen == 0){
            	var rtnjson = {"ids" : rtvids, "names":rtvnames, "sizes":rtvsizes};
				dialog.close(rtnjson);
            }else{
            	plen -= 1;
            	if(plen == 0){
            		var rtnjson = {"ids" : rtvids, "names":rtvnames, "sizes":rtvsizes};
    				dialog.close(rtnjson);
            	}
            }
			
		}
		
		function getpengingcount(){
			var indexcount = 0;
			jQuery(".progressBarInProgressScale").each(function(){
                	var this_value = $(this).html();
    				if(this_value == "Pending..."){
    					indexcount += 1;
    				}
             });
			
			return indexcount;
		}
		
		function delAnnex(annexbl, annexid) {
			var delid = $("#field-annexupload_del_id").val();
			var annexids = $("#field-annexupload").val();
			if (("," + delid + ",").indexOf(annexid) == -1) {
				delid += "," + annexid;
				annexids = (annexids + ",").replace(annexid + ",", "").replaceAll(new RegExp(/[,]{2,}/g), ",");
				$("#field-annexupload").val(annexids);
				$("#field-annexupload_del_id").val(delid)
				var pbstatusobj = $(annexbl).nextAll(".progressBarInProgressWrapper");
				pbstatusobj.children(".progressBarInProgressScale").html("<%=SystemEnv.getHtmlLabelName(81562, user.getLanguage())%>").css("color", "#c59291");
		
				pbstatusobj.children(".progressBarInProgress").css("background", "#feebeb");
				$(annexbl).addClass("progressCancelUndo");
				$(annexbl).removeClass("progressCancel");
			} else {
				annexids += "," + annexid;
				delid = (delid + ",").replace(annexid + ",", "").replaceAll(",,", ",");
				$("#field-annexupload").val(annexids);
				$("#field-annexupload_del_id").val(delid)
				
				var pbstatusobj = $(annexbl).nextAll(".progressBarInProgressWrapper");
				pbstatusobj.children(".progressBarInProgressScale").html("<%=SystemEnv.getHtmlLabelName(25388, user.getLanguage())%>").css("color", "#83a85b");
				pbstatusobj.children(".progressBarInProgress").css("background", "#e4f0fa");
				$(annexbl).addClass("progressCancel");
				$(annexbl).removeClass("progressCancelUndo");
			}
			
		}
		
		String.prototype.replaceAll = function(reallyDo, replaceWith, ignoreCase) {  
		    if (!RegExp.prototype.isPrototypeOf(reallyDo)) {  
		        return this.replace(new RegExp(reallyDo, (ignoreCase ? "gi": "g")), replaceWith);  
		    } else {  
		        return this.replace(reallyDo, replaceWith);  
		    }  
		}  
		

	function delValue(cu)
	{
		__browserNamespace__.del(window.event,cu,2,true,{});
	}
	
	function delByBS()
	{
		__browserNamespace__.delByBS(window.event,'seccategory__',2,true,{});
		$("#firstBtn").hide();
		$("#seccategory").val('');
		$("#outseccategorydiv").css("border","1px solid #ff8080");
		$("#outseccategorydiv").css("border-right-style","none");
		$("#sBtnDiv").css("border","1px solid #ff8080");
		$("#sBtnDiv").css("border-left-color","#d7e2e4");
		$("#fontMes").css('color','#ff8080');
		$("#fontMes").parent().css("margin-left","6%");
		$("#fontMes").text('<%=SystemEnv.getHtmlLabelName(33252, user.getLanguage())%>');
	}
	function inputOnblur(cu){
		__browserNamespace__.setAutocompleteOff(cu);
	}
	
	
	function inputonfocus(){
		
	}
	
	function cancelAll(){
		$("#fsUploadProgressannexupload > div").each(function(){
			var errorMes = $('#'+$(this).attr('id')+'progressError').text();
          	var hiddens = $("<input type='hidden' />");
		    hiddens.attr('value',$(this).attr('id'));
			hiddens.attr('id',$(this).attr('id')+"hiddens");
			$("#uploadProgresScrollbar").append(hiddens);
          	// 上传失败，直接移除元素
          	if (errorMes.replace(/(^\s*)|(\s*$)/g,"").length > 0)
          	{
	          	$(this).fadeOut("slow");
          		cancelNum++;
          	}
          	else
          	{
          		if($("#"+$(this).attr('id')+"upSuc").length > 0)
          		{
          			var docId = $("#"+$(this).attr('id')+"upSuc").val();
          			jQuery.ajax({
					type: "POST",
					url: "/rdeploy/doc/DelDocInfo.jsp",
					data: {docId:docId},
					cache: false,
					async:false,
					dataType: 'json',
					success: function(msg){
					}
					});
						delAnnex( $(this),$(this).attr('id'));	
						$(this).fadeOut("slow");
          			}
          			else
          			{
	          			delAnnex( $(this),$(this).attr('id'));
          			}
          			cancelNum++;
          	}
		});
		if(true){
				numUploadFiles = 0;
				numFilesQ = 0;
				numFilesS = 0;
				$("#icons").show();
				$("#Content").css("background","#F8FBFB");
				$("#Content").css("display","block");
				$("#div_top2").css("display","none");
				$("#uploadProgresScrollbar").getNiceScroll().remove();
				$("#adduploadoutblock").show();
				$("#fsUploadProgressannexupload").empty();
				$("#sucessContent").hide();
				$("#firstBtn").css("top","194px");
				$("#firstBtn").css("left","188px");
				
				
		}
	}
	</script>
	<body>
		<div class="boxhead">
			<div class="e8_tablogo" title="<%= SystemEnv.getHtmlLabelName(1986,user.getLanguage()) %>"
				style="cursor: pointer; background-image: url(/js/tabs/images/nav/mnav1_wev8.png);"></div>
			<div>
				<div class="e8_navtab">
					<span id="objName"><%= SystemEnv.getHtmlLabelName(1986,user.getLanguage()) %></span>  <!-- 1986 新建文档 -->
					<span class="topoperator" id="inadvancedmode"><a
						href="/docs/docs/DocList.jsp?hasTab=1&_fromURL=4"><font
							style="color: #fff;"><%= SystemEnv.getHtmlLabelName(127887,user.getLanguage()) %></font> </a> </span>
				</div>
			</div>
		</div>

		<div id="Container">

			<div id="logo">

				<span>
					<div style="width: 100%;" class="e8_os">

						<div style="width: 93%;" id="outseccategorydiv"
							class="e8_outScroll">
							<div id="innerContentseccategorydiv" style="height: 38px;"
								class="" tabindex="5000">
								<div hasbrowser="true" hasadd="false" id="innerseccategorydiv">
									<input type="hidden" id="seccategory" name="seccategory"
										value="<%=seccategory%>">

									<input type="hidden" id="seccategoryName"
										name="seccategoryName" value="<%=seccategoryName%>">
									<span id="seccategoryspan" name="seccategoryspan"
										style="float: none; font-size: 14px; color: #5f5f5f;">
										<span class="e8_showNameClass"> <a
											style="color: #5f5f5f;" href="#<%= seccategory %>"
											onclick="return false;" title="<%=seccategoryName%>"><%=seccategoryName%></a>
											<span id="<%=seccategory%>" class="e8_delClass"
											onclick="delValue(this);"
											style="visibility: hidden; opacity: 1;">x</span> </span> </span>
									<input type="text" onpropertychange="" id="seccategory__"
										name="seccategory__" onkeydown="delByBS();"
										onfocus="inputonfocus();" onblur="inputOnblur(this);"
										class="sinput" issingle="true" value=""
										style="width: 17px; border-left-style: none; border-bottom-style: none; border-top-style: none; border-right-style: none;"
										autocomplete="off">
								</div>
							</div>
						</div>
						<div id="sBtnDiv"
							style="border: 1px solid #d7e2e4; float: left; height: 38px; margin-left: 93%; margin-top: -40px;">
							<button
								onclick="__browserNamespace__.showModalDialogForBrowser(event,'/systeminfo/BrowserMain.jsp?mouldID=doc&amp;url=/docs/category/MultiCategorySingleBrowser.jsp?operationcode=0','#','seccategory',true,2,'',{name:'seccategory',hasInput:true,zDialog:true,needHidden:true,idKey:'id',nameKey:'path',dialogTitle:'文件存放目录',arguments:'',_callback:afterOnShowCreaterCatagory});"
								type="button" id="seccategory_browserbtn" class="subbtn">
							</button>
						</div>
						<div
							style="float: left; margin-top: -5%; margin-left: 100%; width: 206px;">
							<span> <font id="fontMes"
								style="color: #b8b8b8; size: 14px;"><%= SystemEnv.getHtmlLabelName(127890,user.getLanguage()).replace("{0}",maxUploadFileSize) %></font>
							</span>
						</div>
						<div style="clear: both;"></div>
					</div> <script type="text/javascript">
						window.setTimeout(function(){
							__browserNamespace__.hoverShowNameSpan('.e8_showNameClass');
							__browserNamespace__.e8autocomplete(
							{
							nameAndId:'seccategory',
							inputNameAndId:'seccategory__',
							isMustInput:2,
							hasAdd:false,
							completeUrl:"/data.jsp?type=categoryBrowser&amp;onlySec=true&amp;operationcode=0",
							isSingle:true,
							extraParams:{"_exclude":"getNameAndIdVal"},
							row_height:42,linkUrl:"#",
							needHidden:true,
							sb:{},
							_callback:'afterOnShowCreaterCatagory',
							type:'',
							browserBox:''
							})
							},500);
						jQuery(document).ready(function(){
								__browserNamespace__.e8formatInitData(
								{
								nameAndId:'seccategory',
								name:'seccategory',
								isMustInput:2,
								hasInput:true,
								browserBox:''
								})
							});
							</script> </span>
			</div>

			<div id="sucessContent" class="Content"
				style="display: none; text-align: center; position: relative; background-color: white;">
				<div style="position: relative; top: 40%;">
				
				<div id="topDiv">
	  					<div id="mTop">
							<div id="mTopImg" style="margin-top: -70px;">
								<img id="suceedImg" src="/rdeploy/assets/img/doc/small_upload.png">
							</div>
							<div id="mTopFont" style="margin-top: 3px;">
								<font id="suMes" style="font-size: 14px; color: #40c96a"></font>
							</div>
						</div>
					</div>
				
					
					<div style="clear: both;"></div>

					<div id="failListScoll"
						style="width: 562px; background-color: #fdf4f4;  position: absolute;  top: -67px;  left: 11px;">
						<div style="text-align: left; padding-top: 5px;padding-left: 9px;">
							<font id="failMsg" style="font-size: 14px; color: #e98585;"></font>
						</div>
						<div id="failListScoll1"
							style="padding: 10px;word-wrap: break-word;width: 530px;height: 54px;overflow-y: hidden;outline: none;">
							<div id="failList"
								style="height: 100%; width: 100%; text-align: left; color: #676767; font-size: 12px;"></div>
						</div>
					</div>
					<div id="againAddDiv" style=""
						class="uploadBtnDiv">
						<div style="margin-left: 50px; margin-top: 8px;">
							<div style="float: left; width: 30%; margin-top: -2px;">
								<img src="/rdeploy/assets/img/doc/upload_white.png">
							</div>
							<div style="float: left; width: 50%; margin-left: -9px;">
								<font style="font-size: 16px;"><%= SystemEnv.getHtmlLabelName(81561,user.getLanguage()) %></font><!-- 81561 继续上传 -->
							</div>
						</div>
						<div style="clear: both;"></div>

					</div>
				</div>
			</div>


			<div style="position: absolute;">
				<div id="firstBtn"
					style="position: absolute; top: 194px; left: 188px; z-index: 999;">
					<span id="firstButton"></span>
				</div>
			</div>

			<div id="Content" class="Content"
				style="text-align: center; position: relative;">
				<div id="center1" class=""
					style="position: relative; top: 15%; margin-left: 32%;">
					<div id="icons" class="icons"></div>
					<div id="adduploadoutblock" class="uploadBtnDiv">
						<div id="addupload" style="margin-left: 50px; margin-top: 8px;">
							<div style="float: left; width: 30%; margin-top: -2px;">
								<img src="/rdeploy/assets/img/doc/upload_white.png">
							</div>
							<div style="float: left; width: 50%; margin-left: -9px;">
								<font style="font-size: 16px;"><%= SystemEnv.getHtmlLabelName(127673,user.getLanguage()) %></font>
							</div>
						</div>
						<div style="clear: both;"></div>
						
					</div>
				</div>
				<div>
					<%
					    String extendName = "";
					    String iconpath = "";
					    rs.executeQuery("select extendName,iconpath from workflow_filetypeicon where iconPath like '%.png'");
					    while (rs.next()) {
					        extendName = rs.getString("extendName");
					        iconpath = rs.getString("iconpath");
					%>
					<input type="hidden" id=".<%=extendName%>" value="<%=iconpath%>" />
					<%
					    }
					%>
				</div>
				<div id="uploadProgresScrollbar"
					style="width: 580px; height: 306px; overflow-y: hidden; outline: none; position: absolute; top: 0px; display: none;">
					<div style="width: 98%;" id="fsUploadProgressannexupload">
					</div>
				</div>
				<div style="clear: both;"></div>
				<!-- 继续添加按钮 -->
				<div id="div_top2" class="footDiv" style="display: none;">
					<div style="float: left;">
						<div style="margin-left: 50px; margin-top: 8px;">
							<div style="float: left; margin-left: 65px;">
								<img src="/rdeploy/assets/img/doc/upload_file_normal.png">
							</div>
							<div id="againAddBtn" class="againAddBtn">
								<font style="font-size: 16px;"><%= SystemEnv.getHtmlLabelName(20800,user.getLanguage()) %></font><!-- 20800  添加文件-->
							</div>
						</div>
						<div style="clear: both;"></div>

						
					</div>
					<div
						style="float: left; width: 1px; height: 25px; background: #e0e8eb; margin-top: 10px; margin-left: 75px;"></div>
					<div style="float: left;">
						<div style="cursor: pointer; margin-left: 50px; margin-top: 8px;"
							onclick="cancelAll();">
							<div style="float: left; margin-left: 51px;">
								<img id="cancelAllIcon"
									src="/rdeploy/assets/img/doc/cancel_all.png">
							</div>
							<div id="CancelAllFiles"
								style="float: left; margin-left: 2px; color: #b8b8b8;">
								<font style="font-size: 16px;"><%= SystemEnv.getHtmlLabelName(82857,user.getLanguage()) %><%= SystemEnv.getHtmlLabelName(32694,user.getLanguage()) %></font> <!-- 82857 全部 32694 取消-->
							</div>
						</div>
						<div style="clear: both;"></div>
						<div style="margin-left: -62px; margin-top: -47px; height: 55px;">
							<span id="btnCancelannexupload"></span>
						</div>
					</div>
				</div>
	</body>
</html>
<SCRIPT LANGUAGE="JavaScript">
	
	function _userDelCallback()
	{
		$("#firstBtn").hide();
		$("#seccategory").val('');
		$("#seccategoryName").val('');
		$("#outseccategorydiv").css("border","1px solid #ff8080");
		$("#outseccategorydiv").css("border-right-style","none");
		$("#sBtnDiv").css("border","1px solid #ff8080");
		$("#sBtnDiv").css("border-left-color","#d7e2e4");
		$("#fontMes").css('color','#ff8080');
		$("#fontMes").parent().css("margin-left","6%");
		$("#fontMes").text('<%= SystemEnv.getHtmlLabelName(33252,user.getLanguage()) %>'); //33252 请先选择目录
	}

	function afterOnShowCreaterCatagory(e,datas,fieldid,params){
		if(datas){
			  if(datas.id!="" && datas.id!=0){
			  numUploadFiles = 0;
				numFilesQ = 0;
				numFilesS = 0;
				$("#icons").show();
				$("#Content").css("background","#F8FBFB");
				$("#Content").css("display","block");
				$("#div_top2").css("display","none");
				$("#uploadProgresScrollbar").hide();
				$("#adduploadoutblock").show();
				$("#fsUploadProgressannexupload").empty();
				$("#sucessContent").hide();
				
				$("#firstBtn").css("top","194px");
				$("#firstBtn").css("left","188px");
			 
			  
			  
			  jQuery.ajax({
					type: "POST",
					 url: "/rdeploy/doc/GetSecCategoryInfo.jsp",
					 data: {secCategoryId:datas.id},
						cache: false,
						async:false,
							dataType: 'json',
							 success: function(msg){
							 
							 
			  $("#firstBtn").empty();
				var span = $("<span />");
				span.attr("id","firstButton");
				$("#firstBtn").append(span);
		
		
			initFileupload('firstButton',msg.maxUploadFileSize);
							 var text_label="<%= SystemEnv.getHtmlLabelName(127890,user.getLanguage()) %>";
							 var text_in=text_label.replace("{0}",msg.maxUploadFileSize);
										$("#fontMes").text(text_in);
									 }
						 		});
						 		
			
			  
			  $("#firstBtn").show();
			  
			  $("#outseccategorydiv").css("border","1px solid #d7e2e4");
				$("#outseccategorydiv").css("border-right-style","none");
				$("#sBtnDiv").css("border","1px solid #d7e2e4");
				$("#fontMes").css('color','#d7e2e4');
				$("#fontMes").parent().css("margin-left","0%");
				$("#seccategoryName").val(datas.path);
				
				// 记录选择的目录信息
			 			 jQuery.ajax({
								 type: "POST",
								 url: "/rdeploy/doc/UpdateCheckinUserSeccate.jsp",
								 data: {seccategory:datas.id},
								 cache: false,
								 async:false,
								 dataType: 'json',
								    success: function(msg){
								 }
							 });
				}
			}
		
	}
	
	// 上传按钮鼠标悬浮效果
	$("#firstBtn").hover(
	  function () {
	    $("#adduploadoutblock").css("background-color","#5d88e1");
	    $("#againAddBtn").css("color","#3470ea");
	    
	    $("#againAddDiv").css("background-color","#5d88e1");
	    
	  },
	  function () {
	    $("#adduploadoutblock").css("background-color","#739beb");
	     $("#againAddBtn").css("color","#739aea");
	     
	     $("#againAddDiv").css("background-color","#739beb");
	  }
	);
	
	// 全部取消 鼠标悬浮效果
	$("#CancelAllFiles").hover(
	  function () {
	    $("#CancelAllFiles").css("color","#ff6f6f");
	    $("#cancelAllIcon").attr('src',"/rdeploy/assets/img/doc/cancelall_hot.png");
	  },
	  function () {
	    $("#CancelAllFiles").css("color","#b8b8b8");
	    $("#cancelAllIcon").attr('src',"/rdeploy/assets/img/doc/cancel_all.png");
	  }
	);
	
	
	// 上传列表滚动条美化
	$('#uploadProgresScrollbar').perfectScrollbar();
	// 结果页面失败列表滚动美化
	$("#failListScoll1").perfectScrollbar();
</SCRIPT>
