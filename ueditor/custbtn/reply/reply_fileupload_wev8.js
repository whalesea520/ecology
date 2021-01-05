UE.registerUI('wfannexbutton',function(editor,uiName){
	var language = readCookie("languageidweaver");
	var msg = SystemEnv.getHtmlNoteName(3449,language);
	var labelname = "@";

	var initphrase = function () {
		//点击其他地方，隐藏附件上传选择框
		jQuery("html").live('mouseup', function (e) {
			var banfold = jQuery("#fsUploadProgressfileuploaddiv").attr("banfold");
			var _filetop = jQuery("#_fileuploadphraseblock").offset().top;
			if (_filetop > 0 && !!!jQuery(e.target).closest("#_fileuploadphraseblock")[0] && banfold!="1") {
				jQuery("#_fileuploadphraseblock").css("top","-500px");
				jQuery("#fsUploadProgressfileuploaddiv").css("top","-500px");
			}
			e.stopPropagation();
		});
		try {
			jQuery("html", jQuery("#remark").find("iframe")[0].contentWindow.document).live('mouseup', function (e) {
				var showfor = jQuery("#_fileuploadphraseblock").attr("showfor");
				var _filetop = jQuery("#_fileuploadphraseblock").offset().top;
				if (_filetop > 0 && !!!jQuery(e.target).closest("#_fileuploadphraseblock")[0] && banfold!="1") {
					jQuery("#_fileuploadphraseblock").css("top","-500px");
					jQuery("#fsUploadProgressfileuploaddiv").css("top","-500px");
				}
				e.stopPropagation();
			});
		} catch (e) {}
		var comboxHtml = "" +
						"<div id=\"_fileuploadphraseblock\" class=\"_signinputphraseblockClass\" style='top:-100px;z-index:99;'>" +
						"	<div class=\"phrase_arrowsblock\"><img src=\"/images/ecology8/workflow/phrase/addPhrasejt_wev8.png\" width=\"14px\" height=\"14px\"></div>" +
						"	<div class=\"cg_block\"  style='background:#fff;'>" +
						"		<div id=\"_filecontentblock\">" +
						"			<ul>" +
						"				<li style=\"padding:2px;text-align:center;\" id=\"promptinformation\" ></li>" +
						"			</ul>" +
						"	    </div>" +
						"		<div class=\"cg_splitline\" id=\"cg_splitline\" ></div>" +
						"		<ul>" +
						"			<li >" +
						"				<div class=\"cg_optblock\" style=\"text-align:center;margin:2px 0 4px 0px;\">" +
						"					<div style=\"margin:0 auto; height:22px;width:22px;background-image:url(/images/ecology8/workflow/phrase/addPhrase_wev8.png);\"> "+
						"					<span class=\"phrase_btn\" style=\"color:#1ca96f;\" id=\"_addfilebtn\" title=\""+SystemEnv.getHtmlNoteName(3456,language)+"\">" +
						"						<span id=\"_continueaddfile\" >	" +
						SystemEnv.getHtmlNoteName(3456,language) +
						"						</span></span>" +
						"				</div></div>" +
						"			</li>" +
						"		</ul>" +
						"	</div>" +
						"</div>"+
						"<div id=\"fsUploadProgressfileuploaddiv\" class='_signinputphraseblockClass' style='top:-100px;z-index:999;'>" +
						"	<div class=\"phrase_arrowsblock\" id=\"_fsarrowsblock\"><img src=\"/images/ecology8/workflow/phrase/addPhrasejt_wev8.png\" width=\"14px\" height=\"14px\"></div>" +
						"	<div class=\"cg_block\" id=\"_fscgblock\" style='background:#fff;padding-bottom:2px;'>" +
						"	<div class=\"fieldset flash\" id=\"fsUploadProgressfileupload\" > </div></div></div>";
		var comboxobj = jQuery(comboxHtml);
		//插入dom对象
		jQuery(document.body).append(comboxobj);
	};

	var splitchar = "////~~weaversplit~~////";
	initphrase();
	cfileupload();
    //注册按钮执行时的command命令，使用命令默认就会带有回退操作
	function addli(){
		var el = jQuery(".edui-for-wfannexbutton");
        var px=el.offset().left;
	    var py=el.offset().top + 17;
	    jQuery("#_fileuploadphraseblock").css("z-index","999");
	    jQuery("#_fileuploadphraseblock").css({"top":py + "px", "left":px+"px"});
		//jQuery("#_fileuploadphraseblock").show();
			var ids = jQuery.trim(jQuery("#field-annexupload").val());
			var names = jQuery.trim(jQuery("#field-annexupload-name").val());
			var _ul = jQuery("#_fileuploadphraseblock").find("#_filecontentblock ul");
			if(ids != "" && ids != null){
				var fieldcancle = jQuery("#field-cancle").val();
				jQuery("#promptinformation").html("").css("padding","2px");
				if(ids.indexOf(",") > -1){
					var idArray = ids.split(",");
					var nameArray = names.split(splitchar);
					for (var i=0; i<idArray.length; i++) {
				    	var curid = jQuery.trim(idArray[i]);
		                var curname = jQuery.trim(nameArray[i]);
		                if(!checkliid(jQuery.trim(curid))){
		                	//continue;
		                	_ul.append("<li id='li_"+curid+"' onclick=\"onAddUploadFile("+curid+",'"+curname+"')\" class=\"cg_item\"><span class='cg_detail' style='width:130px;' title='" + curname + "' >" + curname + "</span><a onmouseover=\"showBt("+curid+")\" onmouseout=\"hiddenBt("+curid+")\" onclick=\"deletefile("+curid+",'"+curname+"')\" style=\"float:right;width:10px;height:10px;margin-right:5px;margin-top:8px;background-image:url(/images/ecology8/workflow/annexdel_wev8.png);\" class=\"e8_delClass1\" title='"+fieldcancle+"' ></a></li>");
		                }
				    }
				}else{
					if(!checkliid(jQuery.trim(ids))){
	                	//return;
	                	_ul.append("<li id='li_"+ids+"' onclick=\"onAddUploadFile("+ids+",'"+names+"')\" class=\"cg_item\"><span class='cg_detail' style='width:130px;' title='" + names + "'>" + names + "</span><a onmouseover=\"showBt("+ids+")\" onmouseout=\"hiddenBt("+ids+")\" onclick=\"deletefile("+ids+",'"+names+"')\" style=\"float:right;width:10px;height:10px;margin-right:5px;margin-top:8px;background-image:url(/images/ecology8/workflow/annexdel_wev8.png);\" class=\"e8_delClass1\" title='"+fieldcancle+"' ></a></li>");
					}
				}
			}
	    	var _outdiv = jQuery("#_filecontentblock");
	    	var _li = jQuery("#_filecontentblock ul li");
	    	if (_li.length > 4)  {
				jQuery("#_filecontentblock").css("height", "124px");
				jQuery("#_filecontentblock").css("overflow", "hidden");
				jQuery("#_filecontentblock").perfectScrollbar({horizrailenabled:false,zindex:1000});
				_li.show();
			}
	    	if (_li.length == 4)  {
				jQuery("#_filecontentblock").css("height", "94px");
				jQuery("#_filecontentblock").css("overflow","");
			}
	    	if (_li.length == 3)  {
				jQuery("#_filecontentblock").css("height", "64px");
				jQuery("#_filecontentblock").css("overflow","");
			}
	    	if (_li.length == 2)  {
				jQuery("#_filecontentblock").css("height", "34px");
				jQuery("#_filecontentblock").css("overflow","");
			}
	    	if (_li.length == 1)  {
				jQuery("#_filecontentblock").css("height", "34px");
				jQuery("#_filecontentblock").css("overflow","");
			}
	}
	
    editor.registerCommand(uiName,{
        execCommand:function() {
        }
    });
    //创建一个button
    var btn = new UE.ui.Button({
        //按钮的名字
        name:uiName,
        labelname:SystemEnv.getHtmlNoteName(3457,language),
        //提示
        title:SystemEnv.getHtmlNoteName(3457,language),
        //需要添加的额外样式，指定icon图标，这里默认使用一个重复的icon
        /*cssRules :"background-image: url('/ueditor/custbtn/images/wf_annex_wev8.png') !important;background-position: -990px 1px!important;border:1px solid transparent;",*/
        //点击时执行的命令
        onclick:function () {
            //这里可以不用执行命令,做你自己的操作也可
			//editor.execCommand(uiName);
        	addli();
        }
    });
    //当点到编辑内容上时，按钮要做的状态反射
    editor.addListener('selectionchange', function () {
        var state = editor.queryCommandState(uiName);
        if (state == -1) {
            btn.setDisabled(true);
            btn.setChecked(false);
        } else {
            btn.setDisabled(false);
            btn.setChecked(state);
        }
    });

    //因为你是添加button,所以需要返回这个button
    return btn;
}, 34, "remark"/*index 指定添加到工具栏上的那个位置，默认时追加到最后,editorId 指定这个UI是那个编辑器实例上的，默认是页面上所有的编辑器都会添加这个按钮*/);


var queuednames = "";
var splitchar = "////~~weaversplit~~////";
var x=0;
function cfileupload() {
	var annexmainId = jQuery("#annexmainId").val();
	var annexsubId = jQuery("#annexsubId").val();
	var annexsecId = jQuery("#annexsecId").val();
	var fileuserid = jQuery("#fileuserid").val();
	var fileloginyype = jQuery("#fileloginyype").val();
	var oUploadannexupload;
	var settings = {
			flash_url : "/js/swfupload/swfupload.swf",
			upload_url: "/docs/reply/upload/UploadForReplyImage.jsp",
			file_size_limit : "100 MB",
			file_types : "*.*",
			file_types_description : "All Files",
			file_upload_limit : 50,
			file_queue_limit : 0,
			custom_settings : {
				progressTarget : "fsUploadProgressfileupload",
				cancelButtonId : "fileCancel"
			},
			debug: false,
			secid : window._secid,
			// Button settings
		button_image_url : "",
		button_placeholder_id : "_continueaddfile",
		button_width: 22,
		button_height: 22,
		//button_text: '添加附件',
		button_text_style: '',
		button_text_top_padding: 0,
		button_text_left_padding: 0,
		button_window_mode: SWFUpload.WINDOW_MODE.TRANSPARENT,
		button_cursor: SWFUpload.CURSOR.HAND,

		file_queued_handler : fileQueued,
		file_queue_error_handler : fileQueueError,
		file_dialog_complete_handler : function(numFilesSelected, numFilesQueued){
			if (numFilesSelected > 0) {		
				jQuery(".edui-for-wfannexbutton").css("visibility","visible");
				jQuery(".edui-for-wfannexbutton").css("cursor","pointer");
				jQuery(".edui-for-wfannexbutton").css("z-index","101");
				   jQuery("#promptinformation").html("");
				   var el = jQuery(".edui-for-wfannexbutton");
		           var px=el.offset().left;
			       var py=el.offset().top + 17;
			       jQuery("#fsUploadProgressfileuploaddiv").css({"top":py + "px", "left":px+"px"});
				   jQuery("#fsUploadProgressfileuploaddiv").show();
				
				jQuery("#field-annexupload-count").val(numFilesQueued);
				jQuery("#fsUploadProgressfileuploaddiv").css("z-index","999");
				jQuery("#_fileuploadphraseblock").css("top","-500px");
				jQuery("#fsUploadProgressfileuploaddiv").attr("banfold","1");
				enableAllmenu();
				this.startUpload();
			}
		},
		upload_start_handler : uploadStart,
		upload_progress_handler : uploadProgress,
		upload_error_handler : uploadError,
		upload_success_handler : function (file, server_data) {
			var rtvids = "";
			var rtvnames = "";
			var rtvsizes = "";
			if (!!file) {
				if (rtvids == "") {
					rtvids = jQuery.trim(server_data);
					rtvnames = jQuery.trim(file.name);
					rtvsizes = file.size;
				} else {
					rtvids += "," + jQuery.trim(server_data);
					rtvnames += splitchar + jQuery.trim(file.name);
					rtvsizes += splitchar + file.size;
				}
			}
			
			var fieldannexuploadid = jQuery.trim(jQuery("#field-annexupload").val());
			var fieldannexuploadidname = jQuery.trim(jQuery("#field-annexupload-name").val());
			if(fieldannexuploadid != "" && fieldannexuploadid !=null){
				jQuery("#field-annexupload").val(fieldannexuploadid+","+jQuery.trim(rtvids));
				jQuery("#field-annexupload-name").val(fieldannexuploadidname+splitchar+jQuery.trim(rtvnames));
			}else{
				jQuery("#field-annexupload").val(jQuery.trim(rtvids));
				jQuery("#field-annexupload-name").val(jQuery.trim(rtvnames));
			}
		},
		upload_complete_handler : function(){
			var fieldannexuploadcount = jQuery("#field-annexupload-count").val();
			x++;
			if(x == fieldannexuploadcount){
				jQuery("#fsUploadProgressfileupload").html("");
				jQuery("#fsUploadProgressfileuploaddiv").css("z-index","99");
				jQuery("#_fileuploadphraseblock").css("z-index","999");
				jQuery("#fsUploadProgressfileuploaddiv").css("top","-500px");
				try {
		   			var _targetobj = jQuery(".edui-for-wfannexbutton").children("div").children("div").children("div").children(".edui-metro");
		        	if (document.getElementById("field-annexupload").value != '') {
		        		_targetobj.addClass("wfres_1_slt");
		        		_targetobj.removeClass("wfres_1");
		        	} else {
		        		_targetobj.addClass("wfres_1");
		        		_targetobj.removeClass("wfres_1_slt");
		        	}
		        } catch (e) {}
		        jQuery("#fsUploadProgressfileuploaddiv").attr("banfold","0");
		        addlinew();
				x = 0;
				displayAllmenu();
			}
		},
		queue_complete_handler : function(){
		
		}	// Queue plugin event
		};

	try {
		 oUploadannexupload = new SWFUpload(settings);
	} catch(e) {
		top.Dialog.alert(SystemEnv.getHtmlNoteName(3502,readCookie("languageidweaver")));
		jQuery("#remarkShadowDiv").hide();
	}
}

function deletefile(id,names){
	jQuery("#_fileuploadphraseblock").attr("showfor","2");
	top.Dialog.confirm(SystemEnv.getHtmlNoteName(3458,readCookie("languageidweaver"))+names+SystemEnv.getHtmlNoteName(3459,readCookie("languageidweaver")), function(){
		var ids = jQuery("#field-annexupload").val();
		ids = ids.replace(id,"");
		ids = ids.replace(",,",",");
		if(ids.indexOf(",") == 0){
			ids = ids.substr(1);
		}
		if (ids.lastIndexOf(",") == ids.length - 1) {
			ids = ids.substring(0, ids.length - 1);
		}
		jQuery("#field-annexupload").val(ids);
		
		jQuery("#field_annexupload_del_id").val(jQuery("#field_annexupload_del_id").val()+","+id);
		
		jQuery("#li_"+id).remove();
		var _li = jQuery("#_filecontentblock ul li");
		if (_li.length == 4)  {
			jQuery("#_filecontentblock").height(94); 
			jQuery("#_filecontentblock").css("overflow","");
		}
		if (_li.length == 3)  {
			jQuery("#_filecontentblock").height(64); 
			jQuery("#_filecontentblock").css("overflow","");
		}
		if(_li.length == 2){
			jQuery("#_filecontentblock").height(34); 
			jQuery("#_filecontentblock").css("overflow","");
		}
		if(_li.length == 1){
			var fieldaddname = jQuery("#field-add-name").val();
			jQuery("#promptinformation").html(fieldaddname).css("padding-top","8px").css("cursor","Default");
			jQuery("#_filecontentblock").css("overflow","");
		}

		try {
   			var _targetobj = jQuery(".edui-for-wfannexbutton").children("div").children("div").children("div").children(".edui-metro");
        	if (document.getElementById("field-annexupload").value != '') {
        		_targetobj.addClass("wfres_1_slt");
        		_targetobj.removeClass("wfres_1");
        	} else {
        		_targetobj.addClass("wfres_1");
        		_targetobj.removeClass("wfres_1_slt");
        	}
        } catch (e) {}
	}, function () {
	}, 320, 90,true);
}

function onAddUploadFile(ids,names){
	var showfor = jQuery("#_fileuploadphraseblock").attr("showfor");
	if(showfor != 2){
		var fieldannexuploadrequest = jQuery("#field-annexupload-request").val();
		var phrase = "<a  target='_blank' href='/weaver/weaver.docs.docs.reply.FileDownload?docid="+docid+"&fileid="+ids+"' style='color:#123885;'>" + names + "</a>&nbsp;&nbsp;";
		if(phrase!=null && phrase!=""){
			try{
				UE.getEditor("remark").setContent(phrase, true);
			}catch(e){
			}
		}
		jQuery("#_fileuploadphraseblock").attr("showfor","1");
	}else{
		jQuery("#_fileuploadphraseblock").attr("showfor","0");
	}
}

function openAboutFiles(ids)
{
	parent.openFullWindowHaveBar("/docs/docs/DocDspExt.jsp?id="+docid+"&meegingid=-1&votingId=0&versionId=&imagefileId="+ids+"&from=docreply&userCategory=0&isFromAccessory=true");
}

function checkliid(id){
	var ischeck = false;
	var liarray = jQuery("#_filecontentblock ul li");
	for (var j=0; j<liarray.length; j++) {
		if(jQuery.trim(jQuery(liarray[j]).attr("id")) == ("li_"+id)){
			ischeck = true;
		}
	}
	return ischeck;
}

function showBt(id){
	jQuery("#li_"+id).find("a").css("background-image","url(/images/ecology8/workflow/annexdel_hover_wev8.png)");
}

function hiddenBt(id){
	jQuery("#li_"+id).find("a").css("background-image","url(/images/ecology8/workflow/annexdel_wev8.png)");
}


function enableAllmenu()
{
}

function displayAllmenu()
{

}

function addlinew(){
	var el = jQuery(".edui-for-wfannexbutton");
    var px=el.offset().left;
    var py=el.offset().top + 17;
    jQuery("#_fileuploadphraseblock").css("z-index","999");
    jQuery("#_fileuploadphraseblock").css({"top":py + "px", "left":px+"px"});
	//jQuery("#_fileuploadphraseblock").show();
		var ids = jQuery.trim(jQuery("#field-annexupload").val());
		var names = jQuery.trim(jQuery("#field-annexupload-name").val());
		var _ul = jQuery("#_fileuploadphraseblock").find("#_filecontentblock ul");
		if(ids != "" && ids != null){
			var fieldcancle = jQuery("#field-cancle").val();
			jQuery("#promptinformation").html("").css("padding","2px");
			if(ids.indexOf(",") > -1){
				var idArray = ids.split(",");
				var nameArray = names.split(splitchar);
				for (var i=0; i<idArray.length; i++) {
			    	var curid = jQuery.trim(idArray[i]);
	                var curname = jQuery.trim(nameArray[i]);
	                if(!checkliid(jQuery.trim(curid))){
	                	//continue;
	                	_ul.append("<li id='li_"+curid+"' onclick=\"onAddUploadFile("+curid+",'"+curname+"')\" class=\"cg_item\"><span class='cg_detail' style='width:130px;' title='" + curname + "' >" + curname + "</span><a onmouseover=\"showBt("+curid+")\" onmouseout=\"hiddenBt("+curid+")\" onclick=\"deletefile("+curid+",'"+curname+"')\" style=\"float:right;width:10px;height:10px;margin-right:5px;margin-top:8px;background-image:url(/images/ecology8/workflow/annexdel_wev8.png);\" class=\"e8_delClass1\" title='"+fieldcancle+"' ></a></li>");
	                }
			    }
			}else{
				if(!checkliid(jQuery.trim(ids))){
                	//return;
                	_ul.append("<li id='li_"+ids+"' onclick=\"onAddUploadFile("+ids+",'"+names+"')\" class=\"cg_item\"><span class='cg_detail' style='width:130px;' title='" + names + "'>" + names + "</span><a onmouseover=\"showBt("+ids+")\" onmouseout=\"hiddenBt("+ids+")\" onclick=\"deletefile("+ids+",'"+names+"')\" style=\"float:right;width:10px;height:10px;margin-right:5px;margin-top:8px;background-image:url(/images/ecology8/workflow/annexdel_wev8.png);\" class=\"e8_delClass1\" title='"+fieldcancle+"' ></a></li>");
				}
			}
		}
    	var _outdiv = jQuery("#_filecontentblock");
    	var _li = jQuery("#_filecontentblock ul li");
    	if (_li.length > 4)  {
			jQuery("#_filecontentblock").css("height", "124px");
			jQuery("#_filecontentblock").css("overflow", "hidden");
			jQuery("#_filecontentblock").perfectScrollbar({horizrailenabled:false,zindex:1000});
			jQuery("#_filecontentblock").scrollTop(jQuery("#_filecontentblock ul").height());
			_li.show();
		}
    	if (_li.length == 4)  {
			jQuery("#_filecontentblock").css("height", "94px");
			jQuery("#_filecontentblock").css("overflow","");
		}
    	if (_li.length == 3)  {
			jQuery("#_filecontentblock").css("height", "64px");
			jQuery("#_filecontentblock").css("overflow","");
		}
    	if (_li.length == 2)  {
			jQuery("#_filecontentblock").css("height", "34px");
			jQuery("#_filecontentblock").css("overflow","");
		}
    	if (_li.length == 1)  {
			jQuery("#_filecontentblock").css("height", "34px");
			jQuery("#_filecontentblock").css("overflow","");
		}
}