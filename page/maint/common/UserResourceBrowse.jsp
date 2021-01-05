
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.io.*"%>
<jsp:useBean id="rssysadminmenu" class="weaver.conn.RecordSet" scope="page" />
<html xmlns="http://www.w3.org/1999/xhtml">
<script src="/js/weaver_wev8.js" type="text/javascript"></script>
<script src="/js/jquery/jquery_wev8.js" type="text/javascript"></script>
<script src="/js/jquery/plugins/jqueryFileTree/jquery.easing_wev8.js"
	type="text/javascript"></script>
<script src="/js/jquery/plugins/jqueryFileTree/jqueryFileTree_wev8.js"
	type="text/javascript"></script>
<script type="text/javascript" src="/js/page/swfupload/swfupload_wev8.js"></script>
<script type="text/javascript" src="/js/page/swfupload/swfupload.queue_wev8.js"></script>
<script type="text/javascript" src="/js/page/swfupload/fileprogress_wev8.js"></script>
<script type="text/javascript" src="/js/page/swfupload/handlers_wev8.js"></script>

<link href="/js/jquery/plugins/jqueryFileTree/jqueryFileTree_wev8.css" rel="stylesheet" type="text/css" media="screen" />
<link href="/js/page/swfupload/default_wev8.css" rel="stylesheet" type="text/css" />
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<style type="text/css">
#container_id ul li {
	*height: 20px;
}

#container_id ul li a {
	height: 20px;;
}
</style>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ include file="/docs/docs/DocCommExt.jsp"%>
<%if(user.getLanguage()==7) {%>
	<script type="text/javascript" src="/js/page/maint/common/lang-cn_wev8.js"></script>
<%} else if(user.getLanguage()==8) {%>
	<script type='text/javascript' src='/js/page/maint/common/lang-en_wev8.js'></script>
<%} else if(user.getLanguage()==9) {%>
	<script type='text/javascript' src='/js/page/maint/common/lang-tw_wev8.js'></script>
<%}%>

<body>
<% 
	String file = Util.null2String(request.getParameter("file"));
	String singleSelect = Util.null2String(request.getParameter("singleSelect"));

	if(singleSelect.equals("")){
		singleSelect = "true";
	}
	int isSysadmin=0;
	rssysadminmenu.executeSql("select count(*) from hrmresourcemanager where id="+user.getUID());
	if(rssysadminmenu.next()){
		isSysadmin=rssysadminmenu.getInt(1);
	}
	String active = "";
	String fileName = "";
	String root = "/page/resource/userfile/";
	boolean fileExist = true;
	if(!"none".equals(file)){
		String realPath = GCONST.getRootPath();
		String fileDir = realPath.substring(0,realPath.length()-1)+root+file;
		fileDir =  Util.StringReplace(fileDir,"/","\\");
		File _file = new File(fileDir);
		fileExist = _file.exists();
		if(fileExist){
			active  = file.substring(0,file.lastIndexOf("/")+1);
			fileName = file.substring(file.lastIndexOf("/")+1,file.length());
		}
		
	}
%>

<div id="container_id" style='padding-left:5px'></div>

<div id="uploadDiv" style="display: none">
	<form id="form1" action="UserResourceUpload.jsp" method="post" enctype="multipart/form-data">
		<input type = hidden  id = "dir" name ="dir" value = "">
			<div class="fieldset flash" id="fsUploadProgress">
			</div>
			<div>
			<input  id="btnCancel" type="hidden" value="Cancel All Uploads" onclick="swfu.cancelQueue();" disabled="disabled" style="margin-left: 2px; font-size: 8pt; height: 29px;" />
			</div>

	</form>
</div>
<img id=divPreviewImg style='display:none'>
<div id=elDiv style='display:none;height: 20px;width: 180px;overflow: hidden'>
	<input id=elId type=text maxlength='100' onChange="checkinput('elId','elIdSpan')"> 
	<span id=elIdSpan name=elIdSpan>
		<IMG src='/images/BacoError_wev8.gif' align=absMiddle>
	</span>
</div>
</body>
<script type="text/javascript">
 var singleSelect='<%=singleSelect%>'
 
 var mainPanel;
 var wfTrees;
 var viewport;
 var panelLeft;
 var myData ;
 var currentDir="";
 var isSystem = false;
 
 <%if(isSysadmin==1){%>
 	isSystem = true;
 <%}%>
 var swfu;

		function init() {
			var language = "<%=user.getLanguage()%>";
			var btnwidth = language==8?136:75;
			var settings = {
				flash_url : "/js/swfupload/swfupload.swf",
				upload_url: "/page/maint/common/UserResourceUpload.jsp",
				file_size_limit : "100 MB",
				file_types : "*.jpg;*.gif;*.png;*.swf;*.flv;*.mp3",
				file_types_description : "image file,flash file,flv file,mp3 file",
				file_upload_limit : 100,
				file_queue_limit : 0,
				custom_settings : {
					progressTarget : "fsUploadProgress",
					cancelButtonId : "btnCancel"
				},
				debug: false,

				// Button settings
			 //button_image_url : "/js/swfupload/add_wev8.png",
            button_placeholder_id : "spanButtonPlaceHolder",
            button_width: btnwidth,
            button_height: 21,
            button_text : '<span class="button" ><%=SystemEnv.getHtmlLabelName(21406,user.getLanguage())%></span>',
            button_text_style : '.button {color:#414141; font-family:微软雅黑; FONT: 11px arial,tahoma,verdana,helvetica; } .buttonSmall { font-size: 10pt; }',
            button_text_top_padding: 0,
            button_text_left_padding: 0,
            button_window_mode: SWFUpload.WINDOW_MODE.TRANSPARENT,
            button_cursor: SWFUpload.CURSOR.HAND,
				
				//button_placeholder_id: "spanButtonPlaceHolder",
				// The event handler functions are defined in handlers.js
				file_queued_handler : fileQueued,
				file_queue_error_handler : fileQueueError,
				file_dialog_complete_handler : fileDialogComplete,
				upload_start_handler : uploadStartExt,
				upload_progress_handler : uploadProgress,
				upload_error_handler : uploadError,
				upload_success_handler : uploadSuccess,
				upload_complete_handler : uploadComplete,
				queue_complete_handler : queueComplete	// Queue plugin event
			};
			
			swfu = new SWFUpload(settings);
			Ext.get('btnClick').child('em').child('Button').dom.style.display='none';
	     };





  var uploadBtn= new Ext.Button({
        //renderTo: 'btnHolder',
        id : 'btnClick',
        //handleMouseEvents :false,
        width:1,
        listeners : {
            'click' : function(){
               
            },
            'render' : function(btn) {
                Ext.get('btnClick').child('em').insertFirst({tag: 'span', id: 'spanButtonPlaceHolder'});
               
               // Ext.get('btnClick').child('em').child('Button').style.display='none'
            }
        }
    });




FileProgress.prototype.disappear = function () {

	var reduceOpacityBy = 15;
	var reduceHeightBy = 4;
	var rate = 30;	// 15 fps

	if (this.opacity > 0) {
		this.opacity -= reduceOpacityBy;
		if (this.opacity < 0) {
			this.opacity = 0;
		}

		if (this.fileProgressWrapper.filters) {
			try {
				this.fileProgressWrapper.filters.item("DXImageTransform.Microsoft.Alpha").opacity = this.opacity;
			} catch (e) {
				// If it is not set initially, the browser will throw an error.  This will set it if it is not set yet.
				this.fileProgressWrapper.style.filter = "progid:DXImageTransform.Microsoft.Alpha(opacity=" + this.opacity + ")";
			}
		} else {
			this.fileProgressWrapper.style.opacity = this.opacity / 100;
		}
	}

	if (this.height > 0) {
		this.height -= reduceHeightBy;
		if (this.height < 0) {
			this.height = 0;
		}

		this.fileProgressWrapper.style.height = this.height + "px";
	}

	if (this.height > 0 || this.opacity > 0) {
		var oSelf = this;
		setTimeout(function () {
			oSelf.disappear();
		}, rate);
	} else {
		
		this.fileProgressWrapper.style.display = "none";
		viewport.doLayout();
	}
};
function uploadStartExt(){
	showUpload();
	uploadStart();
}
function fileQueued(file) {
	swfu.setUploadURL("/page/maint/common/UserResourceUpload.jsp?dir="+currentDir);
	if(!checkFileName(file.name)){
		swfu.cancelUpload();
		return false;
	}
	try {
		var progress = new FileProgress(file, this.customSettings.progressTarget);
		progress.setStatus("Pending...");
		progress.toggleCancel(true, this);
		viewport.doLayout();
	} catch (ex) {
		this.debug(ex);
	}

}


function uploadComplete(fileObj) {
	try {
		/*  I want the next upload to continue automatically so I'll call startUpload here */
		if (this.getStats().files_queued === 0) {
			frmAddSubmit();
			document.getElementById(this.customSettings.cancelButtonId).disabled = true;
		} else {	
			this.startUpload();
		}
	} catch (ex) { this.debug(ex); }

}

function queueComplete(numFilesUploaded) {
	hideUpload();
	reShowDir($("a[rel='"+currentDir+"']").parent(),escape($("a[rel='"+currentDir+"']").attr('rel').match( /.*\// )))
}

var root = '/page/resource/userfile/';
var active = '/page/resource/userfile/image/';
var fileExist = '<%=fileExist%>';
var file = '<%=fileName%>'
<%if(!"".equals(active)){%>
	active =root+'<%=active%>';
<%}%>

$(document).ready( function() {
    var aa= $('#container_id').fileTree({
      root: root,
      active: active,
      script: '/js/jquery/plugins/jqueryFileTree/connectors/jqueryFileTree.jsp',
      expandSpeed: 100,
      collapseSpeed: 100
    }, function(file) {
    });
    
    
});


function reShowDir(c, t) {
	$(c).addClass('wait');
	$(".jqueryFileTree.start").remove();
	$.post('/js/jquery/plugins/jqueryFileTree/connectors/jqueryFileTree.jsp', { dir: t }, function(data) {
		
		var info = data.split("$%^&");
		var dir = info[0];
		var file = info[1];

		//if(o.active==''){
			currentDir = t;
			document.getElementById('dir').value = t;
			myData = eval(file);
			mainPanel.grid.store.loadData(myData);
		//}
		
		$(c).find('.start').html('');
		$(c).removeClass('wait');
		$(c).children("ul").remove();
		$(c).append(dir);
		
		if( root == t ) $(c).find('UL:hidden').show(); else $(c).find('UL:hidden').slideDown({ duration: 500, easing: null });
		
		rebindTree(c);
		
	});
}

function rebindTree(t) {
	$(t).find('LI A').bind("click", function() {
		if( $(this).parent().hasClass('directory') ) {
			if( $(this).parent().hasClass('collapsed') ) {
				// Expand
				
				$(this).parent().find('UL').remove(); // cleanup
				
				reShowDir( $(this).parent(), escape($(this).attr('rel').match( /.*\// )) );
				$(this).parent().removeClass('collapsed').addClass('expanded');
			} else {
				// Collapse
				$(this).parent().find('UL').slideUp({ duration: 500, easing: null });
				$(this).parent().removeClass('expanded').addClass('collapsed');
			}
		} else {
			h($(this).attr('rel'));
		}
		return false;
	});
	
	
}
<%if(isIE.equals("true")){%>
 var isIE=true;
<%}else{%>
 var isIE=false;
<%}%>
</script>
<script type="text/javascript">
	
</script>
<script src="/js/page/maint/common/userresourcebrowse_wev8.js" type="text/javascript"></script>
</HTML>
