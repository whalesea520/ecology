
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.general.DesUtil"%>
<%
  DesUtil desUtil=new DesUtil();
%>
<style type="text/css">
	#warn {
		width: 260px;
		height: 65px;
		line-height: 65px;
		background-color: gray;
		position: absolute;
		display: none;
		text-align: center;
		background: url("/images/ecology8/addWorkGround_wev8.png");
	}
</style>
<link href="/js/swfupload/default_wev8.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="/js/swfupload/swfupload_wev8.js"></script>
<script type="text/javascript" src="/js/swfupload/swfupload.queue_wev8.js"></script>
<script type="text/javascript" src="/js/swfupload/fileprogress_wev8.js"></script>
<script type="text/javascript" src="/js/swfupload/handlers_wev8.js"></script>
	<script type="text/javascript" src="/js/doc/upload_wev8.js"></script>
<script language="javascript">
var parentWin = window;
function bindUploaderDiv(targetObj,relateaccName,e8isParentWin){
	if(e8isParentWin){
		try{
			parentWin = jQuery("#e8DocAccIfrm").get(0).contentWindow;
		}catch(e){} 
	}else{
		parentWin = window;
	}
	var maxsize=targetObj.attr("maxsize");
	var mode=targetObj.attr("mode");
	var docid=targetObj.attr("docid");
	var isEditionOpen = 0;
	if(mode!="add") {
		if(e8isParentWin){
			isEditionOpen=window.isEditionOpen?1:0;
		}else{
			isEditionOpen=parent.isEditionOpen?1:0;
		}
	}
	
	var d=new Date();
	var indexid="index_"+d.getSeconds()+d.getMilliseconds();
	targetObj.attr("oUploaderIndex","oUploader_"+indexid);
	//"<input id='relateAccDocids_"+indexid+"' type='hidden' name='"+relateaccName+"'>"+
	targetObj.html(
	   "<div>"+
			"<span>"+ 
				 "<span id='btnSelectedAcc_"+indexid+"'></span>"+
			"</span>"+		
		"</div>"+
		"<div class='fieldset flash' style='display:none;width:240px;position:absolute;"+(e8isParentWin?"":"right:0;")+"' id='fsUploadProgress_"+indexid+"'></div>"+
		"<div id='divStatus_"+indexid+"'></div>");
		
	   window["oUploader_"+indexid]=getUploader(indexid,maxsize,mode,docid,isEditionOpen,e8isParentWin);
	   //alert( window["oUploader_"+indexid]);
}

function getUploader(indexid,maxsize,mode,docid,isEditionOpen,e8isParentWin){
    maxsize=(maxsize==0?5:maxsize);
	var oUploader=null; 
	var upload_url = "";
	var button_height = 24;
	if(e8isParentWin){
		button_height = 16;
	}
	if(mode=="add"||isEditionOpen){
		upload_url= "/docs/docs/DocImgUploadOnly.jsp";	
	} else if(mode=="view"||mode=="edit"){
		upload_url="/docs/docs/DocImgUpload.jsp";
	}
	var filesSize = 0;	
	try{
		var settings = {
			flash_url : "/js/swfupload/swfupload.swf",
		    post_params: {
				"docid": docid,
		        "userid":'<%=desUtil.encrypt(user.getUID()+"")%>',
		        "usertype":'<%=user.getLogintype()%>'
		    },        
			upload_url: upload_url,
			secid: '<%=secid%>',
			file_size_limit : maxsize+" MB",
			file_types : "*.*",
			file_types_description : "All Files",
			file_upload_limit : "50",
			file_queue_limit : "0",
			custom_settings : {
		    	progressTarget : "fsUploadProgress_"+indexid
			},
			debug: false,
			
			button_image_url : "",	// Relative to the SWF file
			button_placeholder_id : "btnSelectedAcc_"+indexid,
	
			button_width: 21,
			button_height: button_height,
			button_text : "<span style='opacity:0;'>&nbsp;</span>", 
			button_text_style : '.button { font-family: Helvetica, Arial, sans-serif; font-size: 12pt;color:#1d76a4 } .buttonSmall { font-size: 10pt; }',
			button_text_top_padding: 0,
			button_text_left_padding: 18,
				
			button_window_mode: SWFUpload.WINDOW_MODE.TRANSPARENT,
			button_cursor: SWFUpload.CURSOR.HAND,
			
			file_queued_handler : fileQueued,
			file_queue_error_handler : fileQueueError,				
			file_dialog_complete_handler : function(numFilesSelected, numFilesQueued){		
				if (numFilesSelected > 0) {
					   try{
					   		//e8showAjaxTips("正在上传，请稍候...",true);
							   jQuery("#fsUploadProgress_"+indexid).show();
							   if(jQuery("#uploadDiv").length>0){
					   				//jQuery("#fsUploadProgress_"+indexid).css("left",jQuery("#uploadDiv").offset().left-jQuery("#fsUploadProgress_"+indexid).width());
					   			}
							   this.startUpload();
					   }catch(e){
					   }		
					   
					   //fileDialogComplete
				}
			},
			upload_start_handler : uploadStart,
			upload_progress_handler : uploadProgress,			
			upload_error_handler : uploadError,
			queue_complete_handler : queueComplete,
	
			upload_success_handler : function (file, server_data) {
				//KE.insertHtml(editorId,server_data);
				filesSize++;
				if(mode=="add"||isEditionOpen){
					//alert(server_data)
					var imageid=server_data.replace(/(^\s*)|(\s*$)/g, "");	
					var sPara={imgid:imageid,icon:'',name:file.name,size:Math.round(file.size/1024)+'K'};						
					addDocImgsData(sPara);		
				}
			},				
			upload_complete_handler : function(file){
			   try {
					if (this.getStats().files_queued === 0) {
						jQuery("#fsUploadProgress_"+indexid).html(""); //清空上传进度条 
						if(e8isParentWin){
							addContainer(mode,window,{filesSize:filesSize});
							try{
								jQuery("#newAccCount").html(filesSize);
								jQuery("#newAccCount").show();
							}catch(e){}
						}else{									
							addContainer(mode,parent,{filesSize:filesSize});
						}
						//e8showAjaxTips("",false);
						//jQuery("#warn").css("left",(jQuery(document.body).width()-220)/2);
						//jQuery("#warn").css("top",215+document.body.scrollTop);
						//jQuery("#warn").css("display","block");
						//setTimeout(function (){
						//	jQuery("#warn").css("display","none");
						//},1200);
						filesSize = 0;
					} 
				} catch (ex) { alert(ex); }
			}
		};
		oUploader = new SWFUpload(settings);
	} catch(e){alert(e)}
	return oUploader;
}

<%
String isIE_uploader = (String)session.getAttribute("browser_isie");
if (isIE_uploader == null || "".equals(isIE_uploader)) {
	isIE_uploader = "true";
}
%>

function flashChecker() {
	var hasFlash = 0; //是否安装了flash
	var flashVersion = 0; //flash版本
	//var isIE = /*@cc_on!@*/0; //是否IE浏览器
	var isIE = <%=isIE_uploader%>; //是否IE浏览器
	if (isIE) {
		var swf = new ActiveXObject('ShockwaveFlash.ShockwaveFlash');
		if (swf) {
			hasFlash = 1;
			VSwf = swf.GetVariable("$version");
			flashVersion = parseInt(VSwf.split(" ")[1].split(",")[0]);
		}
	} else {
		if (navigator.plugins && navigator.plugins.length > 0) {
			var swf = navigator.plugins["Shockwave Flash"];
			if (swf) {
				hasFlash = 1;
				var words = swf.description.split(" ");
				for ( var i = 0; i < words.length; ++i) {
					if (isNaN(parseInt(words[i])))
						continue;
					flashVersion = parseInt(words[i]);
				}
			}
		}
	}
	return {
		f :hasFlash,
		v :flashVersion
	};
}
var fls = flashChecker();
var flashversion = 0;
if (fls.f) {
	flashversion = fls.v;
}
if (flashversion < 9){
	//alert("<%=SystemEnv.getHtmlLabelName(24495,user.getLanguage())%>!");
}

</script>

<div id="divStatus" style="display:none"></div>
<div id="warn">
	<table width="100%" height="100%"><tr><td align="right" style="width:110px;"><img style="vertical-align:middle;" src='/images/ecology8/addWorkflow_wev8.png'></img></td><td align="left"><label style="margin-left: 5px;font-size:12px;"><%=SystemEnv.getHtmlLabelName(83072,user.getLanguage())%></label></td></tr></table>
</div>