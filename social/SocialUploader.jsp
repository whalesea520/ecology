
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.general.DesUtil"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.general.Util"%>
<%@page import="weaver.social.po.SocialClientProp"%>
<%
  	DesUtil desUtil=new DesUtil();
	if(user == null)
		return;
%>
<script type="text/javascript" src="/social/js/swfupload/vendor/swfupload/swfupload_wev8.js"/></script>  
<script type="text/javascript" src="/social/js/swfupload/vendor/swfupload/swfupload.queue_wev8.js"/></script>  
<script type="text/javascript" src="/social/js/swfupload/vendor/swfupload/fileprogress_wev8.js"/></script>  
<script type="text/javascript" src="/social/js/swfupload/vendor/swfupload/handlers_wev8.js"/></script>
<script type="text/javascript" src="/social/js/swfupload/src/jquery.swfupload_wev8.js"/></script> 
<script type="text/javascript" src="/social/js/progressbar/jquery.progressbar_wev8.js"/></script>

<!-- 上传插件 -->
<script src="/social/js/dmuploader/src/dmuploader.min.js"></script>

<link rel="stylesheet" href="/social/css/im_upload_wev8.css" type="text/css" />

<style>
	.innerTableWrap .fileListDelBtn {
		font-size: 22px;
	    line-height: 22px;
	    text-align: right;
	    cursor: pointer;
	    color: #ccc;
	}	
	.innerTableWrap .fileListDelBtn:hover {
	    color: lightblue;
	}
</style>

<script type="text/template">
	<tr id='{id}'>
		<td><img src='{icon}' /></td>
		<td class='ellipsis'>{name}</td>
		<td class='ellipsis'>{size}</td>
		<td class='fileListDelBtn'>×</td>
	</tr>
</script>

<script language="javascript">

// 文件列表
var uploadfileListTemp = new Array();
var uploadfileListFlags = new Array();
//绑定上传控件
function bindDmUploader(domid, argconfig) {
	var defaults={
		url: '/social/SocialUploadOperate.jsp',
        dataType: 'json',
        maxFileSize: <%=Util.getIntValue(SocialClientProp.getPropValue(SocialClientProp.MAXACCUPLOADSIZE)) * 1024 * 1024%>,
        fileName: 'Filedata',
    	maxFiles: 10,
    	onInit: function(){
    		console && console.log("init "+ domid +" successful!");
    		if(argconfig.hasOwnProperty("flashContainerId")){
    			$('#'+argconfig.flashContainerId).append("<div id='"+domid+"_SUC' class='socialUploadContainer' style='display:none;'></div>");
    		}
    	},
	    onFallbackMode: function(message) {
	    	console && console.log("onFallbackMode：",message);
	    },
	    onNewFile: function(id, file){
	    	console && console.log("onNewFile：", id, file);
	    	var isfile = true;
	    	try{
	    		isfile = PcMainUtils.isFile(file.path);
	    	}catch(e){
	    		console && console.error('PcMainUtils.isFile 未定义');
	    	}
	    	if(isfile){
	    		addFile("#"+domid+"_SUC", id, file);
	    		$("#"+domid+"_SUC").find(".abort[data-id='"+id+"']").bind('click', function(){
	    			abortUpload(id, domid);
	    		});
	    	}else{
	    		var targetObj = document.getElementById(domid);
		    	PcSendDirUtils.sendDir(targetObj, file.path);
		    	return isfile;
	    	}
	    	return true;
	    },
	    onDrop: function(files, cb) {
	    	if(files && files.length > 0)
				handleFileList(files, cb, argconfig);
		},
	    onBeforeUpload: function(id){
	    	console && console.log("onBeforeUpload: ", id);
	    	$("#"+domid+"_SUC").show();
	    },
	    onComplete: function(){
	    	console && console.log("upload completely");
	    	$("#"+domid+"_SUC").hide();
	    },
	    onUploadProgress: function(id, percent){
	    	// console && console.log("onUploadProgress：", id, percent);
	    	var percentStr = percent + '%';
        	updateFileProgress(domid, id, percentStr);
	    },
	    onUploadSuccess: function(id, data){
	    	console && console.log("onUploadSuccess:", id, data);
          	updateFileProgress(domid, id, '100%');
          	var fileCnt = $("#"+domid+"_SUC").attr('file-counter');
          	// 获取上传的附件路径
          	var filepath = $("#"+domid+"_SUC .social-upload-file"+ id).find('.file-path').val();
          	$("#"+domid+"_SUC .social-upload-file"+ id).remove();
          	$("#"+domid+"_SUC").attr('file-counter', --fileCnt);
          	if(argconfig.hasOwnProperty("successcallback") && typeof argconfig.successcallback == 'function'){
          		var chatcontentid = "chatcontent_"+argconfig.targetid;
          		// 如果是上传的图片，那就进行本地压缩
          		if(data.imgUrl && !data.content) {
          			try{
          				var widget = $('#'+domid).data('dmUploader');
	          			IMUtil.getImgUrlFromBlob(widget.queue[id], function(src){
	          				IMUtil.compressImg(src, {maxWidth: 180}, function(base64){
	          					data.content = base64;
	          					handleData(data);
	          				});
	          			});
	          			
	          		} catch(e) {
	          			
	          		}
          		}else{
          			handleData(data);
          		}
          		function handleData(data) {
          			var dataString = JSON.stringify(data);
	          		try{
	          			var file = {'name': data.filename, 'size': data.filesize, 'path': encodeURIComponent(filepath)};
		          		if(data){
		          			argconfig.successcallback(chatcontentid, dataString, file, (fileCnt == 0?true: false));
		          		}
	          		}catch(e){
	          			client.error("上传返回数据为空",e);
	          		}
          		}
          	}
	    },
	    onUploadError: function(id, message){
	    	console && console.log("onUploadError:", id, message);
	    },
	    onUploadAbort: function(id){
	    	console && console.log("onUploadAbort:", id);
	    	$("#"+domid+"_SUC .social-upload-file"+ id).remove();
	    	var fileCnt = $("#"+domid+"_SUC").attr('file-counter');
	    	$("#"+domid+"_SUC").attr('file-counter', --fileCnt);
	    },
	    onFileTypeError: function(file){
	    	console && console.log("onFileTypeError:", file);
	    },
	    onFileSizeError: function(file){
	    	console && console.log("onFileSizeError:", file);
	    	showImAlert("<%=SystemEnv.getHtmlLabelName(127328, user.getLanguage())+SocialClientProp.getPropValue(SocialClientProp.MAXACCUPLOADSIZE)%>M");//<!-- 最大不能超过300M -->
	    },
	    onFileExtError: function(file){
	    	console && console.log("onFileExtError:", file);
	    },
	    onFilesMaxError: function(file){
	    	console && console.log("onFilesMaxError:", file);
	    }
	}
	var allconfigs = $.extend(defaults, argconfig);
	var $JqEle = $('#'+domid);
	$JqEle.dmUploader(allconfigs);
	if(argconfig && argconfig.hasOwnProperty('fireBtnCls')){
		var fireBtnCls = argconfig.fireBtnCls;
		if(fireBtnCls == '')
			return;
		//绑定上传按钮点击事件
		$JqEle.find('.'+fireBtnCls).bind('click', function(event){
			var obj = $JqEle.find('#'+fireBtnCls)[0];
			if(obj.fireEvent){
				return obj.fireEvent("onclick");
			}else if(obj.onclick){
				return obj.onclick();
			}else if(obj.click){
				return obj.click();
			}
		});
	}
}

// 处理文件对象
function handleFileList(files, cb, argconfig) {
	var IMdlg = $('.IMConfirm');
	IMdlg.imconfirm({
		'autohide':false,
		'draggble':false,
		'isModel':true,
		'title':'发送文件',
		'buttons': [
			{
				'btn_ok': function(){cb && cb(getCurrentFileList(IMdlg));IMdlg.imclose()}
			},
			{
				'btn_cancel': function(){cb && cb();IMdlg.imclose()}
			}
		],
		'innerhtml': getFileListHtml(files, argconfig),
		'onshow': function(){
			var wrapDiv = IMdlg.find('.innerTableWrap');
			IMUtil.imPerfectScrollbar(wrapDiv);
			// 如果是客户端，使它获得焦点
			if(window.Electron){
				window.Electron.currentWindow.focus();
			}
			// 使得当前的混动窗口获取焦点
			wrapDiv.focus();
			// 绑定点击事件
			wrapDiv.find('.fileListDelBtn').live('click', function(){
				var closestTR = $(this).closest('tr'); 
				var id = closestTR.attr('id');
				closestTR.remove();
				uploadfileListFlags[id] = 0;
			});
		}
	});
	if(uploadfileListTemp && uploadfileListTemp.length > 0) 
		IMdlg.imshow();
	else 
		cb();
}
// 格式化模版
function formatTemplate(dta, tmpl) {  
    var format = {  
        name: function(x) {  
            return x  
        }  
    };  
    return tmpl.replace(/{(\w+)}/g, function(m1, m2) {  
        if (!m2)  
            return "";  
        return (format && format[m2]) ? format[m2](dta[m2]) : dta[m2];  
    });  
}

// 获取上传文件列表展示页
function getFileListHtml(files, argconfig) {
	var oTableWrap = $("<div class='innerTableWrap' ondrop='addDragFile(this, event)' style='height:250px;overflow: auto;padding: 0 10px;'></div>");
	var oTable = $("<table style='table-layout:fixed;width: 100%;font-size: 14px;text-align: left;'><colgroup><col width='*'><col width='60%'><col width='*'><col width='8%'></colgroup></table>");
	uploadfileListTemp = new Array();
	uploadfileListFlags = new Array();
	var aryTmp = getFileListAryTemp(files);
	oTable.append(aryTmp.join(''));
	oTableWrap.append(oTable);
	// 绑定上传参数
	if(argconfig && argconfig.extFilter) {
		oTableWrap.attr("extFilter", argconfig.extFilter);
	}
	return oTableWrap.prop("outerHTML");
}

// 获取当前文件列表
function getCurrentFileList(IMdlg) {
	var aryTemp = new Array();
	for(var i = 0; i < uploadfileListFlags.length; ++i) {
		if(uploadfileListFlags[i]) {
			aryTemp.push(uploadfileListTemp[i]);
		}
	}
	return aryTemp;
}

// 获取上传文件信息
function getFileListAryTemp(files) {
	var html = $('script[type="text/template"]').html();
	var oF, id, icon, name, size, oTmp={}, aryTmp = [];
	var maxId = uploadfileListTemp.length;
	for(var i = 0; i < files.length; ++i) {
		try{
			oF = files[i];
			id = i + maxId;
			name = oF.name;
			icon = getFileIcon(name);
			size = humanizeSize(oF.size);
			oTmp['id'] = id;
			oTmp['icon'] = icon;
			oTmp['name'] = name;
			oTmp['size'] = size;
			// 过滤文件夹
			if(!('isfile' in oF) && oF.path) {
				var isfile = PcMainUtils.isFile(oF.path);
				oF.isfile = isfile;
			}else {
				oF.isfile = oF.size != 0;
			}
			if(!oF.isfile && (!(oF instanceof File) || !oF.isfile)) continue;
			aryTmp.push(formatTemplate(oTmp, html));
			uploadfileListTemp.push(oF);
			uploadfileListFlags.push(1);
		} catch(err) {
			console.error(err);
			continue;
		}
	}
	return aryTmp;
}

// 添加拖动的附件
function addDragFile(obj, evt) {
	 evt.preventDefault();
	 var files = evt.dataTransfer.files;
	 
	 var extFilter = $(obj).attr("extFilter");
	 var newFileList = null;
	 if(extFilter) {
	 	newFileList = new Array();
 		var extList = extFilter.toLowerCase().split(';');
        var ext = "", file;
 		for(var i = 0; i < files.length; ++i) {
 			file = files[i];
 			ext = file.name.toLowerCase().split('.').pop();
 			if($.inArray(ext, extList) >= 0){
 				newFileList.push(file);
 			}
 		}
	 }else {
	 	newFileList = files;
	 }
	 var oTableWrap = $(obj);
	 oTable = oTableWrap.find('table');
	 var aryTmp = getFileListAryTemp(newFileList);
	 oTable.append(aryTmp.join(''));
}

//添加上传文件
function addFile(jqid, i, file) {
	var template = '<div class="upload-item social-upload-file' + i + '">' +
	                   '<input type="hidden" class="demo-file-id" value="'+i+'"/>' +  
	                   '<input type="hidden" class="file-path" value="'+file.path+'"/>' +  
	                   '<div>'+
							'<div class="left fileName p-b-3 ellipsis w180">'+file.name+'</div>'+
							'<div class="right fileSize p-l-15">'+humanizeSize(file.size)+'</div>'+
							'<div class="clear"></div>'+
						'</div>'+
	                   '<div class="progress progress-striped active">'+
	                   	   '<div class="progress-bar" role="progressbar" style="width: 0%;"></div>'+
	                   '</div>'+
	                   '<span class="sr-only"></span>'+
	                   '<span class="abort" data-id="'+i+'">×</span>'+
	                   '<div class="clear"></div>'+
	               '</div>';
	var i = $(jqid).attr('file-counter');
	if (!i){
		$(jqid).empty();
		i = 0;
	}
	i++;
	$(jqid).attr('file-counter', i);
	$(jqid).prepend(template);
}

// 取消上传
function abortUpload(id, domid) {
	showImConfirm("确认取消？", function(){
		var dmUploader = $('#'+domid).data('dmUploader');
		dmUploader.abort(id);
	});
}

//更新文件上传进度
function updateFileProgress(domid, i, percent){
	var fileItemdiv = $("#"+domid+"_SUC .social-upload-file"+ i);
	fileItemdiv.find('div.progress-bar').width(percent);
	fileItemdiv.find('span.sr-only').html(percent);
}
//转换文件大小的显示方式
function humanizeSize(size) {
	var i = size == 0 ? size: Math.floor( Math.log(size) / Math.log(1024) );
	return ( size / Math.pow(1024, i) ).toFixed(2) * 1 + ' ' + ['B', 'kB', 'MB', 'GB', 'TB'][i];
}
/********************************************漂亮的分隔线*************************************************/
function bindUploaderDiv(argconfig){
	var defaults={
		targetid:'',
		contentid:'',
		callback:null,
		processBarWidth:120,
		clearProcess:true
	}
	var config=$.extend({},defaults, argconfig);
	
	var targetid=config.targetid;
	var chatcontent=config.contentid;
	var callback=config.callback;
	var targetObj=$("#"+targetid);
	var maxsize=<%=Util.getIntValue(SocialClientProp.getPropValue(SocialClientProp.MAXACCUPLOADSIZE))%>;
	var secId=targetObj.attr("secId");
	var uploadType=targetObj.attr("_uploadType");
	getUploader(targetid,maxsize,secId,uploadType,chatcontent,callback,config);   
}

function getUploader(targetid,maxsize,secId,uploadType,chatcontent,callback,config){
    maxsize=(maxsize==0?5:maxsize);
    uploadType=uploadType?uploadType:"";
    var fileTypes="*.*";
    if(uploadType=="image"){
    	fileTypes="*.png;*.jpg;*.bmp;*.gif";
    }
	var flelimit=50;
	$("#"+targetid).swfupload({
        // Backend Settings
        post_params: {
		    	uploadType:uploadType,
				secId:secId,
				userid:'<%=desUtil.encrypt(""+user.getUID())%>',
				language:'<%=user.getLanguage()%>',
				logintype:'<%=user.getLogintype()%>',
				departmentid:'<%=user.getUserDepartment()%>'  
		 },  
        upload_url: "/social/SocialUploadOperate.jsp",    // Relative to the SWF file (or you can use absolute paths)
        
        // File Upload Settings
        file_size_limit : maxsize*1024, //
        file_types : fileTypes,
        file_types_description : "All Files",
        file_upload_limit : flelimit + "",
        file_queue_limit : "0",
    
        // Button Settings
       
        //button_placeholder_id : "spanButtonPlaceholder",
        button_placeholder_id : "holder_"+targetid,
        button_width: 16,
        button_height: 18,
        //button_text:"<span class='theFont' style='cursor:pointer'><%=SystemEnv.getHtmlLabelName(19812, user.getLanguage())%></span>",
        button_text_left_padding: 0,
		button_text_top_padding: 3,
		button_window_mode:'transparent',
        //button_text_style: ".theFont { font-size:12;font-weight:bold;color:#666666;cursor:pointer;}",
        button_image_url:"/social/images/acc_wev8.png",
        button_cursor: SWFUpload.CURSOR.HAND,
        // Flash Settings
        flash_url : "/social/js/swfupload/vendor/swfupload/swfupload.swf"
        
    });
    
    $("#uploadProcess_"+targetid).find(".delacc").bind('click', function(){ //Remove from queue on cancel click
          _removefile($(this),targetid);
    });

    
    $("#"+targetid).bind('fileQueued', function(event, file){	
    		var filesqueueNumber = $.swfupload.getInstance("#"+targetid).getStats().files_queued;
    		$("#uploadProcess_"+targetid).show();
        	$progress = $("#progressDemo_"+targetid).clone();
        	$progress.attr("id",file.id);
        	$progress.find(".fileName").text(file.name);
        	
        	$progress.find(".fileSize").text(getSizeFormate(file.size));
        	
        	$fsUploadProgress=$("#fsUploadProgress_"+targetid);
        	if(targetid=="uploadRemarkImgDiv"||targetid=="uploadEditRemarkImgDiv"){
        		$fsUploadProgress.find(".imgAdddiv").before($progress);
        	}else{
        		$fsUploadProgress.append($progress);
        	}
		    $("#uploadProcess_"+targetid).find(".delacc").bind('click', function(){ //Remove from queue on cancel click
				  _removefile($(this),targetid);
		    });
	        $progress.show();
         
            //$(this).swfupload('startUpload');
        }).bind('fileQueueError', function (event, file, errorCode, message) {

        	if(errorCode==-100){
        		alert("<%=SystemEnv.getHtmlLabelName(82451,user.getLanguage()) %>");
        	}
        	if(errorCode==-110){
        		alert("<%=SystemEnv.getHtmlLabelName(24494,user.getLanguage()) %>"+maxsize+"M");
        	}
        }).bind('fileDialogComplete', function (event, numFilesSelected, numFilesQueued) {
        	//$('#queuestatus').text('Files Selected: ' + numFilesSelected + ' / Queued Files: ' + numFilesQueued);
	        var swfuploadObj=$.swfupload.getInstance("#"+targetid);
	        swfuploadObj.startUpload();
        	//setButton();
        }).bind('uploadStart', function (event, file) {
        	$("#"+file.id).find(".btnred").hide();
        	$("#cur_patch").text(file.name);
        	$('#' + file.id).find('.fileProgress').progressBar({height:2,showText: false});
        }).bind('uploadProgress', function (event, file, bytesLoaded,bytesTotal) {
        	var percentage = Math.round((bytesLoaded / bytesTotal) * 100);
        	//$('#' + file.id).find('.fileProgress').text(percentage + '%');
        	$('#' + file.id).find('.fileProgress').progressBar(percentage);
        }).bind('uploadSuccess', function (event, file, serverData) {
        	var fileSize=file.size;
			var fileName=file.name;
			/*
        	if(uploadType=="image"){
        		initUploadImg(chatcontent,$.trim(serverData));
        	}else{
        		alert(serverData);
				initUploadAcc(chatcontent,$.trim(serverData),fileName,fileSize);
			}
			callback.call(this, target, settings);
			eval(opts._callBack)(datas,e);
			*/
			
			callback(chatcontent,$.trim(serverData),file);
        	
        }).bind('uploadComplete', function (event, file) {
        	// upload has completed, try the next one in the queue
        	// 文件上传完毕隐藏对应progress 1105 by wyw
        	$("#"+file.id).remove();
        	var swfu = $.swfupload.getInstance('#'+targetid);
        	if(swfu.getStats().files_queued ===0){
        		if(config.clearProcess){
	        		$("#"+targetid+" .uploadProcess").hide();
	        		$("#"+targetid+" .fsUploadProgress").html("");
        		}
        	}
        });
}




function flashChecker() {
	var hasFlash = 0; //是否安装了flash
	var flashVersion = 0; //flash版本
	var isIE = /*@cc_on!@*/0; //是否IE浏览器

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
	<!-- pc客户端 -->
    <%
        if(!"pc".equals(from)) {
    %>
	// alert("<%=SystemEnv.getHtmlLabelName(24495,user.getLanguage())%>!");
    <%
        }
    %>
}

function _removefile(obj,targetid){
	$(obj).parents('.accitemdiv').remove();
			           //              $("#"+file.id).remove();
     if($("#uploadProcess_"+targetid).find(".fsUploadProgress .accitemdiv").length == 0) {
      		$('.appacc').removeClass('appacc2');
     }

}

</script>

<div id="divStatus" style="display:none"></div>