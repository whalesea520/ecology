
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>

<%@page import="weaver.general.Util"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="java.net.URLDecoder"%>
<%@page import="weaver.docs.docs.DocImageManager"%>
<%
/*用户验证*/
User user = HrmUserVarify.getUser (request , response) ;
if(user==null) {
    response.sendRedirect("/login/Login.jsp");
    return;
}

String annexmainId = Util.null2String(request.getParameter("annexmainId"));
String annexsubId = Util.null2String(request.getParameter("annexsubId"));
String annexsecId = Util.null2String(request.getParameter("annexsecId"));
String userid = Util.null2String(request.getParameter("userid"));
String logintype = Util.null2String(request.getParameter("logintype"));
int userlanguage = Util.getIntValue(Util.null2String(request.getParameter("userlanguage")), 0);

String annexmaxUploadImageSize = Util.null2String(request.getParameter("annexmaxUploadImageSize"));

String field_annexupload = Util.null2String(request.getParameter("field_annexupload"));
String field_annexupload_del_id = Util.null2String(request.getParameter("field_annexupload_del_id"));
//String field_annexupload_name = Util.null2String(request.getParameter("field_annexupload_name"));
//System.out.println(field_annexupload_del_id);
List field_annexuploads = Util.TokenizerString(field_annexupload, ",");
List field_annexupload_del_ids = Util.TokenizerString(field_annexupload_del_id, ",");

String splitchar = "////~~weaversplit~~////";

//String[] field_annexupload_names = URLDecoder.decode(field_annexupload_name).split(splitchar);
//System.out.println(field_annexupload_name.split(splitchar));
//System.out.println(field_annexuploads + ", " + field_annexupload_names);
%>

<!DOCTYPE HTML>
<html>
	<head>
		<script type="text/javascript" language="javascript" src="/js/jquery/jquery_wev8.js"></script>
		<link href="/js/swfupload/default_wev8.css" rel="stylesheet" type="text/css" />
		<script type="text/javascript" src="/js/swfupload/swfupload_wev8.js"></script>
		<script type="text/javascript" src="/js/swfupload/swfupload.queue_wev8.js"></script>
		<script type="text/javascript" src="/js/swfupload/fileprogressBywfAnnex_wev8.js"></script>
		<script type="text/javascript" src="/js/swfupload/handlersBywfAnnex_wev8.js"></script>
		<script type="text/javascript" src="/js/swfupload/workflowswfupload_wev8.js"></script>
		
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<LINK href="/wui/theme/ecology8/jquery/js/e8_zDialog_btn_wev8.css" type=text/css rel=STYLESHEET>
		<script language="javascript" src="../../js/weaver_wev8.js"></script>
		
        <script>
        
        var currentFileID = "";
        
        var delannexids = "";
		var oUploadannexupload;
		function cfileupload() {
			var settings = {
				flash_url: "/js/swfupload/swfupload.swf",
				upload_url: "/docs/docupload/MultiDocUploadByWorkflow.jsp",
				// Relative to the SWF file
				post_params: {
					"mainId": "<%=annexmainId%>",
					"subId": "<%=annexsubId%>",
					"secId": "<%=annexsecId%>",
					"userid": "<%=userid%>",
					"logintype": "<%=logintype%>"
				},
				file_size_limit: "<%=annexmaxUploadImageSize%> MB",
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
		
				// Button settings
				button_image_url: "/images/ecology8/upload/uploadimg_wev8.png",
				// Relative to the SWF file
				button_placeholder_id: "continueadd",
		
				button_width: 170,
				button_height: 45,
				//button_text: '继续上传',
				//button_text_style: '.button { font-family: Helvetica, Arial, sans-serif; font-size: 12pt; } .buttonSmall { font-size: 10pt; }',
				button_text_top_padding: 0,
				button_text_left_padding: 18,
		
				button_window_mode: SWFUpload.WINDOW_MODE.TRANSPARENT,
				button_cursor: SWFUpload.CURSOR.HAND,
		
				// The event handler functions are defined in handlers.js
				file_queued_handler: fileQueued,
				file_queue_error_handler: fileQueueError,
				file_dialog_complete_handler: fileDialogComplete_2,
				upload_start_handler: uploadStart,
				upload_progress_handler: uploadProgress,
				upload_error_handler: uploadError,
				upload_success_handler: uploadSuccess_1,
				upload_complete_handler: uploadComplete_1,
				queue_complete_handler: queueComplete // Queue plugin event
			};
		
			try {
				oUploadannexupload = new SWFUpload(settings);
			} catch(e) {
				alert(e)
			}
		}
		
		
		function fileuploadannexupload() {
			var settings = {
				flash_url: "/js/swfupload/swfupload.swf",
				upload_url: "/docs/docupload/MultiDocUploadByWorkflow.jsp",
				// Relative to the SWF file
				post_params: {
					"mainId": "<%=annexmainId%>",
					"subId": "<%=annexsubId%>",
					"secId": "<%=annexsecId%>",
					"userid": "<%=userid%>",
					"logintype": "<%=logintype%>"
				},
				file_size_limit: "<%=annexmaxUploadImageSize%> MB",
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
		
				// Button settings
				button_image_url: "/images/ecology8/upload/uploadimgn_wev8.png",
				// Relative to the SWF file
				button_placeholder_id: "spanButtonPlaceHolderannexupload",

				button_width: 100,
				button_height: 32,
				//button_text: "<span style=\"color:#FFDD00;font-size:26pt;\"></span>",
				//button_text: '<span class="button"></span>',
				//button_text_style : "color: #000000; font-size: 16pt;"",

				button_text_top_padding: 0,
				button_text_left_padding: 18,
		
				button_window_mode: SWFUpload.WINDOW_MODE.TRANSPARENT,
				button_cursor: SWFUpload.CURSOR.HAND,
		
				// The event handler functions are defined in handlers.js
				file_queued_handler: fileQueued,
				file_queue_error_handler: fileQueueError,
				file_dialog_complete_handler: fileDialogComplete_2,
				upload_start_handler: uploadStart,
				upload_progress_handler: uploadProgress,
				upload_error_handler: uploadError,
				upload_success_handler: uploadSuccess_1,
				upload_complete_handler: uploadComplete_1,
				queue_complete_handler: queueComplete // Queue plugin event
			};
		
			try {
				oUploadannexupload = new SWFUpload(settings);
			} catch(e) {
				alert(e)
			}
		}
		if (window.addEventListener) {
			window.addEventListener("load", cfileupload, false);
		} else if (window.attachEvent) {
			window.attachEvent("onload", cfileupload);
		} else {
			window.onload = cfileupload;
		}
		
		//var clicktype = 0;
		//function upload() {
			//clicktype = 0;
		//	if ($("#fsUploadProgressannexupload").children().length > 0) {
		//		StartUploadAll();
		//	} else {
		//		uploadSuccess_callbackfun(null, null, 0);
		//	}
		//}
		
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
				if(this_value == "<%=SystemEnv.getHtmlLabelName(81562,user.getLanguage())%>"){
					havedelete = 1;
				}
			});
			
			
			if (ispendingover != 0) {
				top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(84535,user.getLanguage())%>"+ispendingover+"<%=SystemEnv.getHtmlLabelName(84536,user.getLanguage())%>");
				return;
			}else if(havedelete != 0){
				parentWin.document.getElementById("field_annexupload_del_id").value = $("#field-annexupload_del_id").val();
				uploadSuccess_callbackfun(null, null, 0);
			}else {
				uploadSuccess_callbackfun(null, null, 0);
			}
		}
		var plen = 0;
		function upload() {
			if ($("#fsUploadProgressannexupload").children().length > 0) {
				StartUploadAll();
				plen = getpengingcount();
			} else {
				uploadSuccess_callbackfun(null, null, 0);
			}
		}
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
					rtvids += "<%=splitchar %>" + server_data;
					rtvnames += "<%=splitchar %>" + file.name;
					rtvsizes += "<%=splitchar %>" + file.size;
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
			//$(parentWin.document.getElementById("annexuploadcountTD")).html($(".progressCancel").length);
            //$(parentWin.document.getElementById("annexuploadcountTD")).parent().parent().parent().parent().show();
            
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
				pbstatusobj.children(".progressBarInProgressScale").html("<%=SystemEnv.getHtmlLabelName(81562,user.getLanguage())%>").css("color", "#c59291");
		
				pbstatusobj.children(".progressBarInProgress").css("background", "#feebeb");
				$(annexbl).addClass("progressCancelUndo");
				$(annexbl).removeClass("progressCancel");
			} else {
				annexids += "," + annexid;
				delid = (delid + ",").replace(annexid + ",", "").replaceAll(",,", ",");
				$("#field-annexupload").val(annexids);
				$("#field-annexupload_del_id").val(delid)
				
				var pbstatusobj = $(annexbl).nextAll(".progressBarInProgressWrapper");
				pbstatusobj.children(".progressBarInProgressScale").html("<%=SystemEnv.getHtmlLabelName(25388,user.getLanguage())%>").css("color", "#83a85b");
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
		
		function showBt(obj){
			$(obj).find(".btstyle01").addClass("btstyle02");
		}

		function hiddenBt(obj){
			$(obj).find(".btstyle01").removeClass("btstyle02");
		}
		
		function __fileDialogComplete_2() {
			var div_top2 = jQuery("#div_top2").css("display");
		    if(div_top2 == "none"){
		    	jQuery("#adduploadoutblock").css("top","-100px");
		    	jQuery("#div_topblock2").css("display","block");
		    	jQuery("#zDialog_div_bottom").css("display","block");
		    	jQuery("#backline").css("display","block");
		    	jQuery("#div_top2").css("display","block");
		    	fileuploadannexupload();
		    }
			
		}

		</script>
		
		
		<style type="text/css">
		html,body {
			height:100%;
			width:100%;
			margin:0;
			padding:0;
			font-family:微软雅黑;
		}
		.progressWrapper {
			
		}
		.progressContainer {
			margin:0px!important;
			background:#fff;
			border:none;
			position:relative;
		}
		
		.progressName {
			font-weight:normal!important;
			margin-bottom:5px;
		}
		
		.progressBarInProgressWrapper {
			height:30px;
			border:1px solid #e4f1fa;
			background:#fff;
			position:relative!important;
		}
		/*进度条*/
		.progressBarInProgress {
			height:30px;
			background:#e4f0fa;
			margin:0!important;
		}
		.progressBarInProgressScale {
			position:absolute;left:5px;top:5px;color:#83a85b;
			font-size:12px;
			font-family:微软雅黑;
		}
		
		.progressBarStatus {
			display:none;
		}
		
		.ok_btn {
			height:27px;width:75px;border:1px solid #dadada;background:#fff;cursor:pointer;font-family:微软雅黑;
		}
		.ok_btn:hover {
			height:27px;width:75px;border:1px solid #109eff;background:#fff;cursor:pointer;font-family:微软雅黑;
		}
		
		.progressCancelUndo {
			width:10px;
			height:10px;
			background:url('/images/ecology8/workflow/annexundo_wev8.png') 0 0 no-repeat!important;
			display:inline-block;position:absolute;right:10px;top:40px;z-index:20;
		}
		
		.progressCancelUndo:hover {
			background:url('/images/ecology8/workflow/annexundo_hover_wev8.png') 0 0 no-repeat!important;
		}
		
		.progressCancel {
			width:10px;
			height:10px;
			background:url('/images/ecology8/workflow/annexdel_wev8.png') 0 0 no-repeat!important;
			display:inline-block;position:absolute;right:10px;top:40px;z-index:20;
		}
		.progressCancel:hover {
			background:url('/images/ecology8/workflow/annexdel_hover_wev8.png') 0 0 no-repeat!important;
		}
		.btstyle01{
		display:block;
		width:100px;
		height:32px;
		font-size:14px;
		text-align:center;
		line-height:32px;
		cursor:pointer;
		background:#43b2ff;
		color:#FFFFFF;
		font-family:微软雅黑;
		}
		
		.btstyle02{
		display:block;
		width:100px;
		height:32px;
		font-size:14px;
		text-align:center;
		line-height:32px;
		cursor:pointer;
		background:#18a0ff;
		color:#FFFFFF;
		font-family:微软雅黑;
		}
		
		a {text-decoration:none;}   
		a:link {text-decoration:none;}
		a:visited {text-decoration:none;} 
		a:hover {text-decoration:none;}
		</style>
	</head>

	<body>
	
	<!-- *********20141020***************** -->
     <!-- 上传附件 -->

     <div id="tip" style="postion:absolute;height:87%;width:100%;font-size:14px;color:#c6c6c6;">
     	 <div id="div_topblock2" style="width:50%;height:5px!important;float:left;display:none;"></div>

	     <div id="div_top2" style="float:left;width:100%;display:none;">
			<%--<div style="float:right;width:5px!important;height:1px;"></div>
	     	<div style="float:right">
	     		<a onmouseover="showBt(this)" onmouseout="hiddenBt(this)"  onclick="upload()" >
	     			<span class="btstyle01"><%=SystemEnv.getHtmlLabelName(75,user.getLanguage())%></span>
	     		</a>
			</div>	 --%>
			<div style="float:right;width:5px!important;height:1px;"></div>
			<div style="float:right;">
				<span style="display:block;width:100px;height:32px;cursor:pointer;">
					<span id="spanButtonPlaceHolderannexupload" ></span> 
				</span>
			</div>
		 	<div style="clear:both;"></div>
		</div>
		<div style="float:right;width:1px;height:5px!important;"></div>
		<div style="clear:both;"></div>
		<div id="backline" style="background:rgb(204,204,204);width:100%;height:1px!important;display:none"></div>
     
     	<div class="zDialog_div_content" id="zDialog_div_content" style="float:left;width:100%;height:82%;">
			<%
				DocImageManager docImageManager = new DocImageManager();
				for (int i=0; i<field_annexuploads.size(); i++) {
				    String fileid = (String)field_annexuploads.get(i);
				    String fileidname = "";
				    docImageManager.resetParameter();
				    docImageManager.setDocid(Integer.parseInt(fileid));
				    docImageManager.selectDocImageInfo();
				    
				    if (docImageManager.next()) {
				    	//docImagefileid = docImageManager.getImagefileid();
						//docImagefileSize = docImageManager.getImageFileSize(Util.getIntValue(docImagefileid));
						fileidname = docImageManager.getImagefilename();
				    }
				%>
				<div class="progressWrapper" id="_0_<%=i %>" _fileid="<%=fileid %>">
					<div class="progressContainer green">
						<a class="progressCancel" href="#" style="visibility: visible;" onclick="delAnnex(this, '<%=fileid %>')" title="<%=SystemEnv.getHtmlLabelName(589,user.getLanguage())%>"> </a>
						<div class="progressName"><%=fileidname %></div>
						<div class="progressBarStatus">&nbsp;</div>
						<div class="progressBarInProgressWrapper">
							<div class="progressBarInProgress" style="width: 100%;"></div>
							<div class="progressBarInProgressScale"><%=SystemEnv.getHtmlLabelName(25388,user.getLanguage())%></div>
						</div>
					</div>
				</div>
				<%
				}
				
				for (int i=0; i<field_annexupload_del_ids.size(); i++) {
				    String fileid = (String)field_annexupload_del_ids.get(i);
				    String fileidname = "";
				    docImageManager.resetParameter();
				    docImageManager.setDocid(Integer.parseInt(fileid));
				    docImageManager.selectDocImageInfo();
				    
				    if (docImageManager.next()) {
				    	//docImagefileid = docImageManager.getImagefileid();
						//docImagefileSize = docImageManager.getImageFileSize(Util.getIntValue(docImagefileid));
						fileidname = docImageManager.getImagefilename();
				    }
				%>
				<div class="progressWrapper" id="_0_<%=i %>" _fileid="<%=fileid %>">
					<div class="progressContainer green">
						<a class="progressCancelUndo" href="#" style="visibility: visible;" onclick="delAnnex(this, '<%=fileid %>')" title="<%=SystemEnv.getHtmlLabelName(23777,user.getLanguage())%>"> </a>
						<div class="progressName"><%=fileidname %></div>
						<div class="progressBarStatus">&nbsp;</div>
						<div class="progressBarInProgressWrapper">
							<div class="progressBarInProgress" style="width: 100%;background:#feebeb;"></div>
							<div class="progressBarInProgressScale" style="color:#c59291;"><%=SystemEnv.getHtmlLabelName(81562, user.getLanguage())%></div>
						</div>
					</div>
				</div>
				<%
				}
				%>
			<div class="fieldset flash" id="fsUploadProgressannexupload">
				
	        </div>
	        <div id="divStatusannexupload">
	        </div>
			<input type=hidden name='annexmainId' value=<%=annexmainId%>>
			<input type=hidden name='annexsubId' value=<%=annexsubId%>>
			<input type=hidden name='annexsecId' value=<%=annexsecId%>>
			
			<input class=InputStyle type=hidden size=60 name="field-annexupload_del_id" id="field-annexupload_del_id" value="<%=field_annexupload_del_id %>">
	        <input class=InputStyle type=hidden size=60 name="field-annexupload" id="field-annexupload" value="<%=field_annexupload %>">
			
		</div>
     
     

		 <div id="adduploadoutblock" style="position:absolute;top:120px;left:170px;z-index:9999;">
	         <div id="addupload" style="float:left;">
	   			<span id="continueadd" ></span>   
	         </div>
         </div>
    </div>

	<!-- *********20141020***************** -->
	<div id="zDialog_div_bottom" class="zDialog_div_bottom" style="display:none;">	
			<table width="100%" cellpadding="0" cellspacing="0">
				<tr align="center">
					<td valign="center">
						<input type="button" value="<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%>" onclick="upload()" class="ok_btn">
					</td>
				</tr>
			</table>
		</div>

	</body>
	<script type="text/javascript">
	<%  
		if (field_annexuploads.size() > 0 || field_annexupload_del_ids.size() > 0) {
	%>
	    	jQuery("#adduploadoutblock").css("top","-100px");
	    	jQuery("#div_topblock2").css("display","block");
	    	jQuery("#zDialog_div_bottom").css("display","block");
	    	jQuery("#backline").css("display","block");
	    	jQuery("#div_top2").css("display","block");
	    	fileuploadannexupload();
	 <%
		}
	 %>
		
	
	</script>
</html>
